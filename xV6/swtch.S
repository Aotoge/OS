# Context switch
#
#   void swtch(struct context **old, struct context *new);
#
# Save current register context in old
# and then load register context from new.

# stack layout of saved old context
# -----
# return address of swtch (it is the eip)
# ebp
# ebx
# esi
# edi
# -----

.globl swtch
swtch:
  movl 4(%esp), %eax              # old
  movl 8(%esp), %edx              # new

  # Save old callee-save registers
  pushl %ebp
  pushl %ebx
  pushl %esi
  pushl %edi

  # Switch stacks
  movl %esp, (%eax)               # *old = esp
  movl %edx, %esp                 # esp = new

  # Load new callee-save registers
  popl %edi
  popl %esi
  popl %ebx
  popl %ebp
  ret
