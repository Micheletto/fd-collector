Gem::Specification.new do |s|
    s.name          = 'fdcollector'
    s.version       = '1.0'
    s.date          = '2012-06-26'
    s.summary       = 'FD Collector'
    s.description   = 'A statsd collector for open FDs for daemontools managed apps.'
    s.authors       = ['Bob Micheletto']
    s.email         = 'bobm@mozilla.com'
    s.files         = ['bin/fd-collector.rb', 'lib/FDcollect/PPid.rb', 'lib/FDcollect/StatdSend.rb', 'lib/FDcollect/Svstat.rb', 'LICENSE', 'README']
    s.executables   << 'fd-collector.rb'
    s.homepage      = 'https://github.com/Micheletto/fd-collector'
end
