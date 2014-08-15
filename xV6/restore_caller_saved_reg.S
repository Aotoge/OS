#include "mmu.h"
#include "syscall.h"
#include "traps.h"
.globl restore_caller_saved_reg
restore_caller_saved_reg:
    # saved the caller saved registers
    movl $SYS_restore_caller_saved_reg, %eax
    int $T_SYSCALL
    ret