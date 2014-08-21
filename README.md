# Operating System
This repo contains my notes, exercie solutions as well as lab solutions for the Operating System Engineering
Course. In this file, I will record my progress and the notes for the course and
solutions.

## xv6

```
xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix Version 6 (v6) by MIT.
xv6 loosely follows the structure and style of v6, but is implemented for a modern x86-based
multiprocessor using ANSI C.
```

#### What I did?
  * add notes to the source file
  * modified the source code to solve the exercises given in the lecture

#### Progress
  * [Lec1: shell exercise](#shell-exercise)
    * basic exercises (ok)
    * challenge exercise (no)
  * Lec2: Boot xv6 exercise (ok)
  * [Lec3: Trace system calls; add halt](#system-call)
    * Part 1
        * basic (ok)
        * print the system call arguments (no)
    * Part 2
        * basic (ok)
        * implement dup2 system call (no)
  * [Lec4: Lazy page allocation](#lazy-page-allocation)
    * part 1
        * Eliminate allocation from sbrk (ok)
    * part 2
        * Basic Lazy Allocation (ok)
        * hangle negative sbrk() arg
        * verify fork() and exit() work even if some sbrk() address have no memory allocated for them
        * Correctly handle faults on the invalid page below the stack
        * Make sure that kernel use of not-yet-allocated allocated user address works
  * [Lec5: xv6 CPU alarm](#xv6-cpu-alarm)
    * basic part (ok)
    * Save and restore the caller-saved user registers around the call to handler (ok)
    * Prevent reentrant calls to the handler (ok)
  * [Lec6: Threads and Locking](#threads-and-locking)
    * OK
  * [Lec7: User-level threads](#user-level-threads)
    * basic part (ok)
  * [Lec8: Barriers](#barriers)
    * OK

#### Shell Exercise
check inclass_sh.c for solution.

1. Executing simple commands

    ```c++
    // use the execvp(const char *file, char *const argv[]) function
    // this function will duplicate the actions the shell in searching
    // an executable file if the specified file name does not contain '/'.

    // use the int fchmod(int fd, mode_t mode) to change the access permissions
    // of the file.
    // user: read/write
    // group: read
    // other: read
    if (fchmod(fd, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) < 0) {
      perror("fchmod:");
    }
    ```

2. I/O redirection

    ```c++
    // Redirection operator `<` and `>`. Connect a command to a file.
    // `<` connects file to the command's standard input.
    // '>' connects file to the command's standard output.

    // use the dup2(int old_fd, int new_fd) function.
    // copy old_fd to new_fd, new_fd and old_fd point to the same file.

    // for redirection:
    file_fd = open(file_name, flag);
    dup2(file_fd, STDIN/STDOUT);
    close(file_fd);
    ```

3. Implement pipes

   ```
   // about int pipe(int fd[2])
   // fd[0] is used for read, fd[1] is used for write
   // fd[0] <- | PIPE | <- fd[1]
   // if fd[0] is closed, writing to pipe will receive a SIGPIPE
   // if fd[1] is closed, and it will generate a EOF for the read side
   // after the reader consumes any buffered data.

   // Baise Usage, Communicate between parent and child
   // Data flow from parent to child (one-way)
   // Dup2, Fork is the wrapper function for dup2 and fork, which handles the
   // error

   int p[2];
   if (pipe(p) < 0) {
     perror("pipe:");
   }
   if (Fork() == 0) {
     // child process
     Dup2(p[0], 0);  // connect stdin to PIPE
     close(p[0]);
     close(p[1]);
     // do something
   }
   // parent process
   Dup2(p[1], 1);  // connect stdout to PIPE
   close(p[1]);
   close(p[0]);
   // do something

   // Parent's stdout connects with Child's stdin
   ```

4. Challenge Exercise

    ```
    4.1 Implement lists of commands, sperated by ";"
    4.2 Implement sub shells by implementing "(" and ")"
    4.3 Implement running commands in the background by supporting "&" and "wait"
    ```

#### System call

1. Sytem call tracing

   ```
   modified syscall() function in syscall.c
   ```

2. Halt system call

    ```
    // create a file called halt.c and modified Makefile, and this will
    // generate a sh command: halt

    // modified syscall.c, syscall.h, usys.S (such as marco definiton...)
    // then implemnt the sys_halt() in file sysproc.c
    ```

#### Lazy Page Allocation

1. Eliminate allocation from sbrk()

    ```c++
    // modified sys_sbrk() in sysproc.c
    int addr;
    int n;
    if (argint(0, &n) < 0) {
      return -1;
    }
    addr = proc->sz;
    proc->sz += n;
    return addr;
    ```

2. Lazy Allocation

    ```c++
    // modified trap() in trap.c
    case T_PGFLT:
        // rcr2() return the address that caused the page fault
        if (lazy_page_allocation(rcr2()) < 0) {
          proc->killed = 1;
        }
        break;

    // lazy page allocation
    int lazy_page_allocation(uint addr) {
      uint a = PGROUNDDOWN(addr);
      char *mem = kalloc();
      if (mem == 0) {
        return -1;
      }
      memset(mem, 0, PGSIZE);
      if (mappages(proc->pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W | PTE_U) < 0) {
        return -1;
      }
      return 0;
    }
    ```

### xv6 CPU alarm

1. Added code in trap.c

   ```c
    if (proc->alarmtick_cnt == proc->alarmticks) {
      proc->alarmtick_cnt = 0;
      // we have to check whether tf->esp is valid or not because
      // we do write operations of the area tf->esp points to.
      if (tf->esp < KERNBASE) {
        // return address of the interrupt
        *((uint*)(tf->esp - 4))  = tf->eip;

        // save caller-saved register on user stack
        *((uint*)(tf->esp - 8))  = tf->eax;
        *((uint*)(tf->esp - 12))  = tf->ecx;
        *((uint*)(tf->esp - 16)) = tf->edx;

        // use the user stack to do some tricky things
        // install following code on the user stack
        // -------
        // movl $SYS_restore_caller_saved_reg, %eax
        // int $T_SYSCALL
        // ret           ; actually we can ommit the ret instruction.
        // -------
        // the installed code will call a system call which
        // will help restore the caller saved register
        *((uint*)(tf->esp - 20)) = 0xc340cd00;
        *((uint*)(tf->esp - 24)) = 0x000018b8;

        // set the return address of handler to the start
        // of the above code
        *((uint*)(tf->esp - 28)) = tf->esp - 24;

        // set the user stack pointer to return address of the handler
        tf->esp = tf->esp - 28;

        // when trap return, it returns to the
        // alarmhandler
        tf->eip = (uint)proc->alarmhandler;

        proc->tf = tf;
        proc->alarm_handler_running = 1;
      }
    }
  ```

2. Added code in sysproc.c

  ```c
  // the new syscall for restore caller saved registers
  int sys_restore_caller_saved_reg(void) {
    struct trapframe *tf = proc->tf;
    if (tf->esp >= KERNBASE) {
      return -1;
    }

    tf->esp = tf->esp + 8;
    tf->edx = *((uint*)tf->esp);

    tf->esp = tf->esp + 4;
    tf->ecx = *((uint*)tf->esp);

    tf->esp = tf->esp + 4;
    tf->eax = *((uint*)tf->esp);

    tf->esp = tf->esp + 4;
    tf->eip = *((uint*)tf->esp);

    tf->esp += 4;

    proc->alarm_handler_running = 0;
    return 0;
  }
  ```

### Threads and Locking

1. Use per-bucket lock and Lock cirtical region in put method.

  ```c
  static
  void put(int key, int value)
  {
    pthread_mutex_lock(_locks + (key % NBUCKET));
    struct entry *n, **p;
    for (p = &table[key%NBUCKET], n = table[key % NBUCKET]; n != 0; p = &n->next, n = n->next) {
      if (n->key > key) {
        insert(key, value, p, n);
        goto done;
      }
    }
    insert(key, value, p, n);
   done:
    pthread_mutex_unlock(_locks + (key % NBUCKET));
    return;
  }
  ```

2. Each thread only looks up its responsible keys.

  ```c
  t0 = now();
  for (i = 0; i < b; ++i) {
    struct entry *e = get(keys[b * n + i]);
    if (e == 0) ++k;
  }
  t1 = now();
  ```

### User-level threads

1. Basic Part

  ```c
  // Modified thread_create
  void
  thread_create(void (*func)())
  {
    thread_p t;

    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
      if (t->state == FREE) break;
    }
    t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
    t->sp -= 4;                              // space for return address
    * (int *) (t->sp) = (int)func;           // push return address on stack
    t->sp -= 32;                             // space for registers that thread_switch will push

    // Note: init sp in the thread stack frame
    *(int*)(t->sp + 12) = (t->sp + 32);

    t->state = RUNNABLE;
  }
  ```

  ```assembly
    ; Code in uthread_switch
      .text

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
  ```

### Barriers

  ```c
    #include <stdlib.h>
    #include <unistd.h>
    #include <stdio.h>
    #include <assert.h>
    #include <pthread.h>


    static int nthread = 1;
    static int round = 0;

    struct barrier {
      pthread_mutex_t barrier_mutex;
      pthread_cond_t barrier_cond;
      int nthread;      // Number of threads that have reached this round of the barrier
      int round;     // Barrier round
    } bstate;

    static void
    barrier_init(void)
    {
      assert(pthread_mutex_init(&bstate.barrier_mutex, NULL) == 0);
      assert(pthread_cond_init(&bstate.barrier_cond, NULL) == 0);
      bstate.nthread = 0;
    }

    static void
    barrier()
    {
      pthread_mutex_lock(&bstate.barrier_mutex);
      bstate.nthread++;
      if (bstate.nthread == nthread) {
        pthread_cond_broadcast(&bstate.barrier_cond);
        bstate.nthread = 0;
        bstate.round++;
      } else {
        pthread_cond_wait(&bstate.barrier_cond, &bstate.barrier_mutex);
      }
      pthread_mutex_unlock(&bstate.barrier_mutex);
    }
  ```

## JOS

```
A OS for the labs assgnments. Only contains pieces of skeleton code.
```

#### Progress
  * Lab 1 : C, Assembly, Tools, and Bootstrapping
    * Grade: 50/50
  * Lab 2 : Memory Management
    * Grade: 70/70




