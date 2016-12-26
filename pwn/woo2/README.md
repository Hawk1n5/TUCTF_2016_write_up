0x1 Introduction
=

```
./woo2: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=81b35c22e2090e2760cda85e8a3fe6c0808c1f4d, not stripped
```

This is ELF 64bits execution. 
```
	CANARY    : ENABLED
	
	FORTIFY   : disabled
	
	NX        : ENABLED
	
	PIE       : disabled
	
	RELRO     : Partial
```
And it have those protect.

0x2 Vulnerability
=

In the choose select,there have a secret option.0x1337
```
	=> 0x400def <makeStuff+95>:	cmp    eax,0x1337

	   0x400df4 <makeStuff+100>:	je     0x400e32 <makeStuff+162>
```
If input `4919`,it will jump to pwnMe function.

	   0x400e32 <makeStuff+162>:	mov    eax,0x0
	
	=> 0x400e37 <makeStuff+167>:	call   0x400ce1 <pwnMe>

In the pwnMe function.

`0x400ce9 <pwnMe+8>:	mov    eax,DWORD PTR [rip+0x2013d1]        # 0x6020c0 <bearOffset>`

It will get bearOffset first,If it didnt create bear,This value will be 0.

Then it will use `heap + bearOffset` to get where is bear data.
```	
	0x603000:	0x0000000000000000	0x0000000000000021
	
	0x603010:	0x0000000a61616161	0x0000000000000000
	
	0x603020:	0x0000000300000000	0x0000000000020fe1
```
(Im create a tiger type 3,name is "aaaa", bearOffset is 0,so it will get this tiger data.)

but it didn't check is bear or not.

Next step,It have a condition if your type is not 3,it will exit.
```
	0x400d01 <pwnMe+32>:	mov    eax,DWORD PTR [rax+0x14]
	
	0x400d04 <pwnMe+35>:	cmp    eax,0x3
```
And if your type is 3.it will do thins:

	0x0000000000400d14 <+51>:	mov    rax,QWORD PTR [rbp-0x8]

	0x0000000000400d18 <+55>:	call   rax

RAX is animal name.Just jump to `000000000040090d <l33tH4x0r>:` this function to get the flag.
