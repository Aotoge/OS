/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

#define TRAPHANDLER_NOEC(name, num)		   \
	.globl name;						   \
	.type name, @function;				   \
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);						\
	jmp _alltraps


/*
 * 0 ~ 7, 16, 18, 19 no error code
 */
.text
TRAPHANDLER_NOEC(divide_fault, T_DIVIDE);
TRAPHANDLER_NOEC(debug_exception, T_DEBUG);
TRAPHANDLER_NOEC(nmi_interrupt, T_NMI);
TRAPHANDLER_NOEC(breakpoint_trap, T_BRKPT);
TRAPHANDLER_NOEC(overflow_trap, T_OFLOW);
TRAPHANDLER_NOEC(bounds_check_fault, T_BOUND);
TRAPHANDLER_NOEC(invalid_opcode_fault, T_ILLOP);
TRAPHANDLER_NOEC(device_not_available_fault, T_DEVICE);
TRAPHANDLER_NOEC(floating_point_error_fault, T_FPERR);
TRAPHANDLER_NOEC(machine_check_fault, T_MCHK);
TRAPHANDLER_NOEC(simd_fault, T_SIMDERR);

/*
 * 8, 10 ~ 14, 17 with error code
 */
TRAPHANDLER(double_fault_abort, T_DBLFLT);
TRAPHANDLER(invalid_tss_fault, T_TSS);
TRAPHANDLER(segment_not_present_fault, T_SEGNP);
TRAPHANDLER(stack_exception_fault, T_STACK);
TRAPHANDLER(general_protection_fault, T_GPFLT);
TRAPHANDLER(page_fault, T_PGFLT);
TRAPHANDLER(align_check_fault, T_ALIGN);

/*
 * System Reserved
 */
TRAPHANDLER_NOEC(reserved_9, T_COPROC);
TRAPHANDLER_NOEC(reserved_15, T_RES);

/*
 * System Call
 */
TRAPHANDLER_NOEC(syscall_trap, T_SYSCALL);

.text
_alltraps:
 	# setup the remaining part of the trap frame
 	pushl %ds
 	pushl %es
 	pushal

 	# Load GD_KD to ds and es
 	xor %ax, %ax
 	movw $GD_KD, %ax
 	movw %ax, %ds
 	movw %ax, %es

 	# Arugment passing and call trap
 	pushl %esp
 	call trap

 	# resotre
 	addl $0x04, %esp
 	popal
 	popl %es
 	popl %ds
 	# ignore the trap number and 0 padding
 	addl $0x08, %esp
 	iret

.data
.global ivector_table
ivector_table:
	# 0 ~ 7
	.long divide_fault
	.long debug_exception
	.long nmi_interrupt
	.long breakpoint_trap
	.long overflow_trap
	.long bounds_check_fault
	.long invalid_opcode_fault
	.long device_not_available_fault
	# 8
	.long double_fault_abort
	# 9
	.long reserved_9
	# 10 ~ 14
	.long invalid_tss_fault
	.long segment_not_present_fault
	.long stack_exception_fault
	.long general_protection_fault
	.long page_fault
	# 15
	.long reserved_15
	# 16
	.long floating_point_error_fault
	# 17
	.long align_check_fault
	# 18 ~ 19
	.long machine_check_fault
	.long simd_fault
	# 20 ~ 47
	.long 20
	.long 21
	.long 22
	.long 23
	.long 24
	.long 25
	.long 26
	.long 27
	.long 28
	.long 29
	.long 30
	.long 31
	.long 32
	.long 33
	.long 34
	.long 35
	.long 36
	.long 37
	.long 38
	.long 39
	.long 40
	.long 41
	.long 42
	.long 43
	.long 44
	.long 45
	.long 46
	.long 47
	# 48
	.long syscall_trap