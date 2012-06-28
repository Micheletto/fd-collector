# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
Gem::Specification.new do |s|
  s.name          = 'fdcollector'
  s.version       = '1.0.0'
  s.summary       = 'FD Collector'
  s.description   = 'A statsd collector for open FDs for daemontools managed apps.'
  s.authors       = ['Bob Micheletto']
  s.email         = 'bobm@mozilla.com'
  s.files         = ['bin/fd-collector.rb', 'lib/fdcollect/ppid.rb', 'lib/fdcollect/statdsend.rb', 'lib/fdcollect/svstat.rb', 'LICENSE', 'README']
  s.executables   << 'fd-collector.rb'
  s.homepage      = 'https://github.com/Micheletto/fd-collector'
end
