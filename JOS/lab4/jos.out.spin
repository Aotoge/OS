+ ld obj/kern/kernel
+ mk obj/kern/kernel.img
Could not open option rom 'sgabios.bin': No such file or directory
6828 decimal is 15254 octal!
Physical memory: 66556K available, base = 640K, extended = 65532K
Total Pages: 16639
npages = 16639, npages_basemem = 160
mp_code_beg = 7, mp_code_end = 8
Skipp 7
Oops = 684
EXTPHYSMEM = 100000
check_page_free_list(1) ok
check_page_alloc() succeeded!
check_page() succeeded!
check_kern_pgdir() succeeded!
check_page_free_list(0) ok
check_page_installed_pgdir() succeeded!
SMP: CPU 0 found 1 CPU(s)
enabled interrupts: 1 2
[00000000] new env 00001000
I am the parent.  Forking the child...
[00001000] new env 00001001
fork returnI am the parent.  Running the child...
I am the child.  Spinning...

QEMU: Terminated via GDBstub
