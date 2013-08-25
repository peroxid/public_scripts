#!/usr/bin/python
# Accepts connections, prints the received messages to stdout.

from socket import *

# Listen on all available interfaces
serverHost = ''
serverPort = 1113

# Open socket to listen on
s = socket(AF_INET, SOCK_STREAM)
s.bind((serverHost, serverPort))
s.listen(1024)

# Process connections
while 1:
	# Accept connections
	c, a = s.accept()
	print 'Connection accepted from %s' % str(a)
	# Receive data
	while 1:
		d = c.recv(2 ** 16)
		print 'Received: %s' % str(d)
		# Acknowledge reception of data
		r = 'ACK\n'
		c.send(r)
		c.close()
		break
