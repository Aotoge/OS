# include "mmu.h"
#include "syscall.h"
#include "traps.h"
.globl protect_caller
protect_caller:
    # saved the caller saved registers
    movl $SYS_handler_ret, %eax
    int $T_SYSCALL
    ret
    # pushl %eax
    # pushl %ecx
    # pushl %edx
    # call *0xc(%esp)
    # popl %edx
    # popl %ecx
    # popl %eax
    # add 0x4, %esp
    # ret

#   # Build trap frame.
#   pushl %ds
#   pushl %es
#   pushl %fs
#   pushl %gs
#   pushal

#   # Set up data and per-cpu segments.
#   movw $(SEG_KDATA<<3), %ax
#   movw %ax, %ds
#   movw %ax, %es
#   movw $(SEG_KCPU<<3), %ax
#   movw %ax, %fs
#   movw %ax, %gs

#   # Call trap(tf), where tf=%esp
#   pushl %esp # argument passing, tf = %esp
#   call trap
#   addl $4, %esp # ignore the tf

#   # Return falls through to trapret...
# .globl trapret
# trapret:
#   popal
#   popl %gs
#   popl %fs
#   popl %es
#   popl %ds
#   addl $0x8, %esp  # trapno and errcode
#   iret
