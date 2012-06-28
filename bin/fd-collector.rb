#!/usr/bin/env ruby
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Script to enumerate open file descriptors by daemontools managed daemons
# and report them to statsd

# Libraries
require 'optparse'
require 'fdcollect/svstat'
require 'fdcollect/ppid'
require 'fdcollect/statdsend'

# Defaults
options = {}

# Parse command line options.
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: [ -i SECONDS -a APPLICATION ] DIRECTORY"

  options[:interval] = 20
  opts.on( '-i', '--interval SECONDS', "Seconds between checks.") do |sec|
    options[:interval] = sec
  end

  opts.on( '-a', '--application APPLICATION', "Name of the application.") do |a|
    options[:application] = a
  end

  opts.on( '-h', '--help', "Display help information.") do
    puts opts
    exit
  end
end

# Make it happen.
optparse.parse!

# Make sure a directory was supplied.
unless ARGV[0]
  raise OptionParser::MissingArgument
end

# Default application name to the basename of the directory specified.
dir = ARGV[0]
unless options[:application]
  options[:application] = File.basename(dir)
end

# Build timer
mytimer = options[:application] + "open_fd"

# Build objects
sv = Svstat.new(dir)
ps = Ppid.new()
st = Statsd.new()

# Main
loop do
  # sv.pid returns the process id for a daemontools managed application
  # by querying its status file.

  # Send the timer: ps.fds iterates over the number of open fds by child
  # process of sv.pid
  ps.fds(sv.pid) do |fds|
    st.send(mytimer, fds)
  end

  # Delay for interval
  sleep(options[:interval])
end
