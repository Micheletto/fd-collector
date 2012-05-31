# Libraries
require "socket"

# Class to make UDP connections to statsd, and send timers
class Statsd

	# Open connection to host and port, and initialize the hash
	# for assigning the proper facility / priority.  Use sensible
	# defaults of localhost and port 514.
	def initialize(host="127.0.0.1", port="8125")
		@usocket = UDPSocket.new
		@usocket.connect(host, port)
	end
	
	# Deliver timer to statsd
	def send (timer, data)

		# Send the message to statsd.
		@usocket.send(timer + ":" + data.to_s + "|c", 0)
	end
	
end
