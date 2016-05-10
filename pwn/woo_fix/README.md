0x1 Introduction
=

`./fixed: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=cb34b38d6ea9b2fb44d74378dba149ab584bb5a6, not stripped`

This file is same as woo2,but it have some difference.

0x2 Vulnerability
=

In this time.bearOffset default is 0xffffffff,set the value when you create bear first.

And in the deleteAnimal it can free if delete index is 0.

So first time need to create some animal which is not bear.

second time create a bear, then bearOffset will set 1.

Then delete index is 1,after delete bearOffset still is 1,It didn't reset.

So now create a tiger type is 3,and name is "aaaa",you will get some solution in woo2.
