    .text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register, which should be caller saved.
 */
    .globl thread_switch
thread_switch:

    ; store current thread context
    pushal

    ; current_thread->sp = esp
    movl current_thread, %eax
    movl %esp, (%eax)

    ; esp = next_thread->sp
    movl next_thread, %eax
    movl (%eax), %esp

    ; current_thread = next_thread
    movl %eax, current_thread

    ; next_thread = 0
    movl $0x0, next_thread

    ; resotre next thread context
    popal

    ret