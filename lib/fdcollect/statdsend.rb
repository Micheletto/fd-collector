# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Libraries
require "socket"

# Class to make UDP connections to statsd, and send timers
class Statsd

  # Open connection to host and port.  Use sensible
  # defaults of localhost and port 8125
  def initialize(host="127.0.0.1", port="8125")
    @usocket = UDPSocket.new
    @usocket.connect(host, port)
  end

  # Deliver timer to statsd
  def send (timer, data)
    # Send the message to statsd.
    @usocket.send("#{timer}:#{data}|ms", 0)
  end

end
