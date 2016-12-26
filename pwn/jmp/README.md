0x1 Introduction
=

```
jmp: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=afcb1c16b8d5a795af98824aaede8fabc045d4ed, not stripped
```

This file is elf 32 bit execution.
```
	CANARY    : disabled

	FORTIFY   : disabled

	NX        : disabled
	
	PIE       : disabled
	
	RELRO     : Partial
```
And it didnt have any protect.

0x2 Vulnerability
=
```
	root@CTF:~/CTF/TUCTF/pwn/jmp# python -c "print 'a'*44+'zzzz'"|ltrace -i ./jmp 

	[0x8048441] __libc_start_main(0x804851d, 1, 0xffe1b004, 0x80485f0 <unfinished ...>

	[0x8048532] puts("What's your name?"What's your name?)                                                                           = 18

	[0x804853f] fflush(0xf7700ac0)                                                                                  = 0

	[0x804854b] gets(0xffe1af40, 47, 0x804a000, 0x8048642)                                                          = 0xffe1af40

	[0x8048557] puts("What's your favorite number?"What's your favorite number?)                                                                = 29

	[0x8048564] fflush(0xf7700ac0)                                                                                  = 0

	[0x8048578] __isoc99_scanf(0x80486af, 0x804a048, 0x804a000, 0x8048642)                                          = 0xffffffff

	[0x80485a1] printf("Hello %s, %d is an even number!\n"..., "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., 0Hello aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaazzzz, 0 is an even number!)            = 77

	[0x80485ae] fflush(0xf7700ac0)                                                                                  = 0

	[0x7a7a7a7a] --- SIGSEGV (Segmentation fault) ---

	[0xffffffffffffffff] +++ killed by SIGSEGV +++
```
It is easy to controller return address.

And it have `080483d0 <gets@plt>:` function.

So can use this function call to write bss and ret to bss to execute shellcode.

But it have a problem,When I first use gets,It can't write to bss.

But it can write in second time when use gets.

So I'm use double gets.And return start In second gets.

If return to start,program will begin again.

And just buffer overflow again and jump to bss.
