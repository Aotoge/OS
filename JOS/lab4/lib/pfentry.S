#include <inc/mmu.h>
#include <inc/memlayout.h>

// Page fault upcall entrypoint.

// This is where we ask the kernel to redirect us to whenever we cause
// a page fault in user space (see the call to sys_set_pgfault_handler
// in pgfault.c).
//
// When a page fault actually occurs, the kernel switches our ESP to
// point to the user exception stack if we're not already on the user
// exception stack, and then it pushes a UTrapframe onto our user
// exception stack:
//
//	trap-time esp
//	trap-time eflags
//	trap-time eip
//	utf_regs.reg_eax
//	...
//	utf_regs.reg_esi
//	utf_regs.reg_edi
//	utf_err (error code)
//	utf_fault_va            <-- %esp
//
// If this is a recursive fault, the kernel will reserve for us a
// blank word above the trap-time esp for scratch work when we unwind
// the recursive call.
//
// We then have call up to the appropriate page fault handler in C
// code, pointed to by the global variable '_pgfault_handler'.

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
	movl _pgfault_handler, %eax
	call *%eax
	addl $4, %esp			// pop function argument
	
	// Now the C page fault handler has returned and you must return
	// to the trap time state.
	// Push trap-time %eip onto the trap-time stack.
	//
	// Explanation:
	//   We must prepare the trap-time stack for our eventual return to
	//   re-execute the instruction that faulted.
	//   Unfortunately, we can't return directly from the exception stack:
	//   We can't call 'jmp', since that requires that we load the address
	//   into a register, and all registers must have their trap-time
	//   values after the return.
	//   We can't call 'ret' from the exception stack either, since if we
	//   did, %esp would have the wrong value.
	//   So instead, we push the trap-time %eip onto the *trap-time* stack!
	//   Below we'll switch to that stack and call 'ret', which will
	//   restore %eip to its pre-fault value.
	//
	//   In the case of a recursive fault on the exception stack,
	//   note that the word we're pushing now will fit in the
	//   blank word that the kernel reserved for us.
	//
	// Throughout the remaining code, think carefully about what
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	

	// ecx = utf->eip
	movl $0xa, %esi
	movl (%ebx, %esi, 4), %ecx

	// edx = &utf->esp
	movl $0xc, %esi
	leal (%ebx, %esi, 4), %edx

	// eax = utf->esp
	movl (%edx), %eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
	movl %eax, (%edx)  					// *edx = eax

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)

	// rearrange utf
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
	movl (%ebx, %esi, 4), %eax 

	// ecx = &utf->eip
	movl $0xa, %esi
	leal (%ebx, %esi, 4), %ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
	leal (%ebx, %esi, 4), %ecx

	// eax = utf->esp
	movl $0xc, %esi
	movl (%ebx, %esi, 4), %eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
	popal

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret