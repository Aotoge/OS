/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

/*
 * 0 ~ 7, 16, 18, 19 no error code
 */
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
TRAPHANDLER_NOEC(int_9, T_COPROC);
TRAPHANDLER_NOEC(int_15, T_RES);

/*
 * Lab 3: Your code here for _alltraps
 */

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