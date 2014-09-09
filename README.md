# Operating System
This repo contains my notes, exercie solutions as well as lab solutions for the Operating System Engineering
Course. In this file, I will record my progress and the notes for the course and
solutions.

## TODO
1. add notes for lab1,2 as well as other lec-exe.

## Overview

1. [xv6](#xv6)
2. [JOS](#jos)


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
  * [Lec9: Big Files]
    * OK
  * [Lec10: xv6 log]
    * Basic OK
    * Challenge (NO)
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
  * Lab 3 : User Environments
    * Grade: 80/80
      * Part A: User Environments and Exception Handling
        * Grade: 30/30
          * [Exe1](#lab3-exe1)
          * [Exe2](#lab3-exe2)
          * [Exe4](#lab3-exe4)
          * [Exe5](#lab3-exe5)
      * Part B: Page Faults, Breakpoints Exceptions, and System Calls
        * Grade: 50/50
          * [Exe6](#lab3-exe6)
          * [Exe7](#lab3-exe7)
          * [Exe8](#lab3-exe8)
          * [Exe9](#lab3-exe9)

### Lab3 Exe1

```c
// modified mem_init() in kern/pmap.c to allocate and map envs array
// Allocate memory for envs
envs = boot_alloc(sizeof(struct Env) * NENV);
// Memory mapping
boot_map_region(kern_pgdir, UENVS, sizeof(struct Env) * NENV,
                PADDR(envs), PTE_U | PTE_P);
```

### Lab3 Exe2

```c
// Mark all environments in 'envs' as free, set their env_ids to 0,
// and insert them into the env_free_list.
// Make sure the environments are in the free list in the same order
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void env_init(void) {
  // Set up envs array
  int i = 0;
  for (i = 0; i < NENV; ++i) {
    memset(envs + i, 0, sizeof(envs[i]));
    envs[i].env_id = 0;
    envs[i].env_link = NULL;
    if (i == 0) {
      env_free_list = &envs[0];
    } else {
      envs[i-1].env_link = &envs[i];
    }
  }
  // Per-CPU part of the initialization
  env_init_percpu();
}

// 这里所做的就是建立给予环境（或者说进程）的内核映射。
// 每个进程都会有自己独立的page tabls，但是每个进程对于内核的映射部分都是一样的
static int
env_setup_vm(struct Env *e)
{
  int i;
  struct PageInfo *p = NULL;

  // Allocate a page for the page directory
  if (!(p = page_alloc(ALLOC_ZERO)))
    return -E_NO_MEM;

  // Now, set e->env_pgdir and initialize the page directory.
  //
  // Hint:
  //    - The VA space of all envs is identical above UTOP
  //      Note: so what we do here is to setup the mapping above UTOP
  //  (except at UVPT, which we've set below).
  //  See inc/memlayout.h for permissions and layout.
  //  Can you use kern_pgdir as a template?  Hint: Yes.
  //  (Make sure you got the permissions right in Lab 2.)
  //    - The initial VA below UTOP is empty.
  //    - You do not need to make any more calls to page_alloc.
  //    - Note: In general, pp_ref is not maintained for
  //  physical pages mapped only above UTOP, but env_pgdir
  //  is an exception -- you need to increment env_pgdir's
  //  pp_ref for env_free to work correctly.
  //    - The functions in kern/pmap.h are handy.

  // LAB 3: Your code here.
  ++p->pp_ref;
  e->env_pgdir = (pde_t*)page2kva(p);

  for (i = 0; i < NPDENTRIES; ++i) {
    e->env_pgdir[i] = kern_pgdir[i];
  }

  // UVPT maps the env's own page table read-only.
  // Permissions: kernel R, user R
  e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;

  return 0;
}

//
// Allocate len bytes of physical memory for environment env,
// and map it at virtual address va in the environment's address space.
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
  // Hint: It is easier to use region_alloc if the caller can pass
  //   'va' and 'len' values that are not page-aligned.
  //   You should round va down, and round (va + len) up.
  //   (Watch out for corner-cases!)
  uintptr_t va_beg = ROUNDDOWN((uintptr_t)va, PGSIZE);
  uintptr_t va_end = ROUNDUP(((uintptr_t)va) + len, PGSIZE);
  pte_t* pte;
  while (va_beg < va_end) {
    struct PageInfo *page = page_alloc(0);
    if (page_insert(e->env_pgdir, page, (void*)va_beg, PTE_W | PTE_U)) {
      panic("Page talbe couldn't be allocated") ;
    }
    va_beg += PGSIZE;
  }
}

//
// Set up the initial program binary, stack, and processor flags
// for a user process.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
//
// This function loads all loadable segments from the ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// At the same time it clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file - i.e., the program's bss section.
//
// All this is very similar to what our boot loader does, except the boot
// loader also needs to read the code from disk.  Take a look at
// boot/main.c to get ideas.
//
// Finally, this function maps one page for the program's initial stack.
//
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary, size_t size)
{
  // Hints:
  //  Load each program segment into virtual memory
  //  at the address specified in the ELF section header.
  //  You should only load segments with ph->p_type == ELF_PROG_LOAD.
  //  Each segment's virtual address can be found in ph->p_va
  //  and its size in memory can be found in ph->p_memsz.
  //  The ph->p_filesz bytes from the ELF binary, starting at
  //  'binary + ph->p_offset', should be copied to virtual address
  //  ph->p_va.  Any remaining memory bytes should be cleared to zero.
  //  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
  //  Use functions from the previous lab to allocate and map pages.
  //
  //  All page protection bits should be user read/write for now.
  //  ELF segments are not necessarily page-aligned, but you can
  //  assume for this function that no two segments will touch
  //  the same virtual page.
  //
  //  You may find a function like region_alloc useful.
  //
  //  Loading the segments is much simpler if you can move data
  //  directly into the virtual addresses stored in the ELF binary.
  //  So which page directory should be in force during
  //  this function?
  //
  //  You must also do something with the program's entry point,
  //  to make sure that the environment starts executing there.
  //  What?  (See env_run() and env_pop_tf() below.)

  // Get the beginning and end of program header table
  struct Proghdr *ph =
    (struct Proghdr *)(binary + ((struct Elf*)binary)->e_phoff);
  struct Proghdr *ph_end =
    (struct Proghdr *)(ph + ((struct Elf*)binary)->e_phnum);

  // switch to env's pgdir
  lcr3(PADDR(e->env_pgdir));

  for (; ph < ph_end; ++ph) {
    if (ph->p_type != ELF_PROG_LOAD) {
      continue;
    }
    // allocate memory for this binary
    region_alloc(e, (void*)ph->p_va, ph->p_memsz);
    // Load binary image into memory
    memcpy((void*)ph->p_va, (void*)(binary + ph->p_offset), ph->p_filesz);
    // Init .bss
    memset((void*)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);

  }

  // switch back to kern's pgdir
  lcr3(PADDR(kern_pgdir));

  // Modified env's trapframe
  // other files in trap frame is set in env_alloc.
  e->env_tf.tf_eip = ((struct Elf*)binary)->e_entry;

  // Now map one page for the program's initial stack
  // at virtual address USTACKTOP - PGSIZE.
  region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
}

//
// Allocates a new env with env_alloc, loads the named elf
// binary into it with load_icode, and sets its env_type.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size, enum EnvType type)
{
  struct Env *new_env = NULL;
  if (env_alloc(&new_env, 0)) {
    panic("cannot alloc env");
  }
  load_icode(new_env, binary, size);
  new_env->env_type = type;
}

//
// Context switch from curenv to env e.
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e)
{
  // Step 1: If this is a context switch (a new environment is running):
  //     1. Set the current environment (if any) back to
  //        ENV_RUNNABLE if it is ENV_RUNNING (think about
  //        what other states it can be in),
  //     2. Set 'curenv' to the new environment,
  //     3. Set its status to ENV_RUNNING,
  //     4. Update its 'env_runs' counter,
  //     5. Use lcr3() to switch to its address space.
  // Step 2: Use env_pop_tf() to restore the environment's
  //     registers and drop into user mode in the
  //     environment.

  // Hint: This function loads the new environment's state from
  //  e->env_tf.  Go back through the code you wrote above
  //  and make sure you have set the relevant parts of
  //  e->env_tf to sensible values.

  // LAB 3: Your code here.
  if (curenv && curenv->env_status == ENV_RUNNING) {
    curenv->env_status = ENV_RUNNABLE;
  }
  curenv = e;
  curenv->env_status = ENV_RUNNING;
  ++curenv->env_runs;
  lcr3(PADDR(e->env_pgdir));
  env_pop_tf(&e->env_tf);
}
```

### Lab3 Exe4

```c
// in trap.c
void
trap_init(void)
{
  extern struct Segdesc gdt[];
  extern long ivector_table[];
  // LAB 3: Your code here.
  int i;
  for (i = 0; i <= T_SIMDERR; ++i) {
    SETGATE(idt[i], 0, GD_KT, ivector_table[i], 0);
  }
  // Per-CPU setup
  trap_init_percpu();
}
```

```asm
# in kern/trapentry.S

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#define TRAPHANDLER(name, num)            \
  .globl name;    /* define global symbol for 'name' */ \
  .type name, @function;  /* symbol type is function */   \
  .align 2;   /* align function definition */   \
  name:     /* function starts here */    \
  pushl $(num);             \
  jmp _alltraps

#define TRAPHANDLER_NOEC(name, num)      \
  .globl name;               \
  .type name, @function;           \
  .align 2;             \
  name:               \
  pushl $0;             \
  pushl $(num);           \
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
```

### Lab3 Exe5

```c
// in kern/trap.c
static void
trap_dispatch(struct Trapframe *tf) {

  switch (tf->tf_trapno) {
    case T_PGFLT:
      page_fault_handler(tf);
      break;
  }

  // Unexpected trap: The user process or the kernel has a bug.
  print_trapframe(tf);
  if (tf->tf_cs == GD_KT)
    panic("unhandled trap in kernel");
  else {
    env_destroy(curenv);
    return;
  }
}

### Lab3 Exe6

```c
// in kern/trap.c
static void
trap_dispatch(struct Trapframe *tf) {
  switch (tf->tf_trapno) {
    case T_BRKPT:
      monitor(tf);
      break;

    case T_PGFLT:
      page_fault_handler(tf);
      break;
  }

  // Unexpected trap: The user process or the kernel has a bug.
  print_trapframe(tf);
  if (tf->tf_cs == GD_KT)
    panic("unhandled trap in kernel");
  else {
    env_destroy(curenv);
    return;
  }
}

// in kern/monitor.c
static struct Command commands[] = {
  { "help", "Display this list of commands", mon_help },
  { "kerninfo", "Display information about the kernel", mon_kerninfo },
  { "continue", "Return to the user program unti it reach a break point", mon_continue},
};

static int __exit = 0;

int mon_continue(int argc, char **argv, struct Trapframe *tf) {
  __exit = 1;
  return 0;
}

void
monitor(struct Trapframe *tf)
{
  char *buf;

  cprintf("Welcome to the JOS kernel monitor!\n");
  cprintf("Type 'help' for a list of commands.\n");

  if (tf != NULL)
    print_trapframe(tf);

  __exit = 0;
  while (!__exit) {
    buf = readline("K> ");
    if (buf != NULL)
      if (runcmd(buf, tf) < 0)
        break;
  }
}
```

### Lab3 Exe7

```c
// in kern/trapentry.S
/*
 * System Call
 */
TRAPHANDLER_NOEC(syscall_trap, T_SYSCALL);

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

// in kern/trap.c
void
trap_init(void)
{
  extern struct Segdesc gdt[];
  extern long ivector_table[];
  // LAB 3: Your code here.
  int i;
  for (i = 0; i <= T_SIMDERR; ++i) {
    SETGATE(idt[i], 0, GD_KT, ivector_table[i], 0);
  }

  // T_BRKPT is generated using software int.
  // in other words, user invoke the "int 3",
  // so the processor compare the DPL of the gate with
  // the CPL.
  SETGATE(idt[T_BRKPT], 0, GD_KT, ivector_table[T_BRKPT], 3);

  // Setting system call, the reason setting DPL as 3 is same
  // as above
  SETGATE(idt[T_SYSCALL], 0, GD_KT, ivector_table[T_SYSCALL], 3);

  // Per-CPU setup
  trap_init_percpu();
}

static void
trap_dispatch(struct Trapframe *tf)
{
  switch (tf->tf_trapno) {
    case T_BRKPT:
      monitor(tf);
      break;

    case T_PGFLT:
      page_fault_handler(tf);
      break;

    case T_SYSCALL:
      syscall(tf->tf_regs.reg_eax,
              tf->tf_regs.reg_edx,
              tf->tf_regs.reg_ecx,
              tf->tf_regs.reg_ebx,
              tf->tf_regs.reg_edi,
              tf->tf_regs.reg_esi);

      // Save the return value in %eax
      asm volatile("movl %%eax, %0\n" : "=m"(tf->tf_regs.reg_eax) ::);
      return;
  }
```

### Lab3 Exe8

```c
// in lib/libmain.c

#include <inc/lib.h>
extern void umain(int argc, char **argv);
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv) {
  // set thisenv to point at our Env structure in envs[].
  int i;
  envid_t current_id = sys_getenvid();
  for (i = 0; i < NENV; ++i) {
    if (envs[i].env_id == current_id) {
    // if (envs[i].env_status == ENV_RUNNING) {
      thisenv = envs + i;
      break;
    }
  }

  // cprintf("ID Get from sys: %d\n", current_id);
  // cprintf("ID Get by loop: %d\n", thisenv->env_id);

  // save the name of the program so that panic() can use it
  if (argc > 0)
    binaryname = argv[0];

  // call user main routine
  umain(argc, argv);

  // exit gracefully
  exit();
}
```

### Lab3 Exe9

```c
// in kern/trap.c
void
page_fault_handler(struct Trapframe *tf)
{
  uint32_t fault_va;

  // Read processor's CR2 register to find the faulting address
  fault_va = rcr2();

  // Handle kernel-mode page faults.
  if (!(tf->tf_cs & 0x11)) {
    panic("Kernel Page Fault.");
  }

  // We've already handled kernel-mode exceptions, so if we get here,
  // the page fault happened in user mode.

  // Destroy the environment that caused the fault.
  cprintf("[%08x] user fault va %08x ip %08x\n",
    curenv->env_id, fault_va, tf->tf_eip);
  print_trapframe(tf);
  env_destroy(curenv);
}

// in kern/pamp.c
// Check that an environment is allowed to access the range of memory
// [va, va+len) with permissions 'perm | PTE_P'.
// Normally 'perm' will contain PTE_U at least, but this is not required.
// 'va' and 'len' need not be page-aligned; you must test every page that
// contains any of that range.  You will test either 'len/PGSIZE',
// 'len/PGSIZE + 1', or 'len/PGSIZE + 2' pages.
//
// A user program can access a virtual address if (1) the address is below
// ULIM, and (2) the page table gives it permission.  These are exactly
// the tests you should implement here.
//
// If there is an error, set the 'user_mem_check_addr' variable to the first
// erroneous virtual address.
//
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
  // step 1 : check below ULIM
  uintptr_t va_beg = (uintptr_t)va;
  uintptr_t va_end = va_beg + len;
  if (va_beg >= ULIM || va_end >= ULIM) {
    user_mem_check_addr = (va_beg >= ULIM) ? va_beg : ULIM;
    return -E_FAULT;
  }

  // step 2 : check present & permission
  uintptr_t va_beg2 = ROUNDDOWN(va_beg, PGSIZE);
  uintptr_t va_end2 = ROUNDUP(va_end, PGSIZE);
  while (va_beg2 < va_end2) {

    // check page table is present ?
    if (!(env->env_pgdir[PDX(va_beg2)] & PTE_P)) {
      user_mem_check_addr = (va_beg2 > va_beg) ? va_beg2 : va_beg;
      return -E_FAULT;
    }

    // get current page table kernel va
    uint32_t* pt_kva = KADDR(PTE_ADDR(env->env_pgdir[PDX(va_beg2)]));

    // check page is present & permissions
    if (!((pt_kva[PTX(va_beg2)] & perm) == perm)) {
      user_mem_check_addr = (va_beg2 > va_beg) ? va_beg2 : va_beg;
      return -E_FAULT;
    }

    va_beg2 += PGSIZE;
  }
  return 0;
}

// in kern/syscall.c
// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
  // Check that the user has permission to read memory [s, s+len).
  // Destroy the environment if not.
  user_mem_assert(curenv, s, len, PTE_P | PTE_U);

  // Print the string supplied by the user.
  cprintf("%.*s", len, s);
}

// in kern/kdebug.c
// debuginfo_eip(addr, info)
//
//  Fill in the 'info' structure with information about the specified
//  instruction address, 'addr'.  Returns 0 if information was found, and
//  negative if not.  But even if it returns negative it has stored some
//  information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
  const struct Stab *stabs, *stab_end;
  const char *stabstr, *stabstr_end;
  int lfile, rfile, lfun, rfun, lline, rline;

  // Initialize *info
  info->eip_file = "<unknown>";
  info->eip_line = 0;
  info->eip_fn_name = "<unknown>";
  info->eip_fn_namelen = 9;
  info->eip_fn_addr = addr;
  info->eip_fn_narg = 0;

  // Find the relevant set of stabs
  if (addr >= ULIM) {
    stabs = __STAB_BEGIN__;
    stab_end = __STAB_END__;
    stabstr = __STABSTR_BEGIN__;
    stabstr_end = __STABSTR_END__;
  } else {
    // The user-application linker script, user/user.ld,
    // puts information about the application's stabs (equivalent
    // to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
    // __STABSTR_END__) in a structure located at virtual address
    // USTABDATA.
    const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

    /* -------------- Belongs to this Exe9 ------------ */
    // Make sure this memory is valid.
    // Return -1 if it is not.  Hint: Call user_mem_check.
    if (user_mem_check(curenv, (const void *)usd,
        sizeof(struct UserStabData), PTE_U | PTE_P) < 0) {
      return -1;
    }
    /* -------------- Belongs to this Exe9 ------------ */

    stabs = usd->stabs;
    stab_end = usd->stab_end;
    stabstr = usd->stabstr;
    stabstr_end = usd->stabstr_end;

    /* -------------- Belongs to this Exe9 ------------ */
    // Make sure the STABS and string table memory is valid.
    if (user_mem_check(curenv, (const void *)stabs,
        (uintptr_t)stab_end  - (uintptr_t)stabs, PTE_U | PTE_P) < 0) {
      return -1;
    }

    if (user_mem_check(curenv, (const void *)stabstr,
        (uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U | PTE_P) < 0) {
      return -1;
    }
    /* -------------- Belongs to this Exe9 ------------ */
  }

  // String table validity checks
  if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
    return -1;

  // Now we find the right stabs that define the function containing
  // 'eip'.  First, we find the basic source file containing 'eip'.
  // Then, we look in that source file for the function.  Then we look
  // for the line number.

  // Search the entire set of stabs for the source file (type N_SO).
  lfile = 0;
  rfile = (stab_end - stabs) - 1;
  stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  if (lfile == 0)
    return -1;

  // Search within that file's stabs for the function definition
  // (N_FUN).
  lfun = lfile;
  rfun = rfile;
  stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);

  if (lfun <= rfun) {
    // stabs[lfun] points to the function name
    // in the string table, but check bounds just in case.
    if (stabs[lfun].n_strx < stabstr_end - stabstr)
      info->eip_fn_name = stabstr + stabs[lfun].n_strx;
    info->eip_fn_addr = stabs[lfun].n_value;
    addr -= info->eip_fn_addr;
    // Search within the function definition for the line number.
    lline = lfun;
    rline = rfun;
  } else {
    // Couldn't find function stab!  Maybe we're in an assembly
    // file.  Search the whole file for the line number.
    info->eip_fn_addr = addr;
    lline = lfile;
    rline = rfile;
  }
  // Ignore stuff after the colon.
  info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;


  // Search within [lline, rline] for the line number stab.
  // If found, set info->eip_line to the right line number.
  // If not found, return -1.
  //
  // Hint:
  //  There's a particular stabs type used for line numbers.
  //  Look at the STABS documentation and <inc/stab.h> to find
  //  which one.
  // Your code here.
  stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  if (lline > rline) {
    return -1;
  }
  info->eip_line = stabs[lline].n_desc;
  // Search backwards from the line number for the relevant filename
  // stab.
  // We can't just use the "lfile" stab because inlined functions
  // can interpolate code from a different file!
  // Such included source files use the N_SOL stab type.
  while (lline >= lfile
         && stabs[lline].n_type != N_SOL
         && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
    lline--;
  if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
    info->eip_file = stabstr + stabs[lline].n_strx;


  // Set eip_fn_narg to the number of arguments taken by the function,
  // or 0 if there was no containing function.
  if (lfun < rfun)
    for (lline = lfun + 1;
         lline < rfun && stabs[lline].n_type == N_PSYM;
         lline++)
      info->eip_fn_narg++;

  return 0;
}


// Question about Why backtrace cause a kernel page fualt ?
// When backtracing to the last stack frame, ebp = 0xeebfdff0.
// and we also know that USTACKTOP = 0xeebfe000.
// When try to fecth the user arg <-> *((unsigned *)ebp + 4) (unsigned *)ebp + 4 = 0xeebfe000,
// this part is not mapped, so it cause a page fault.
// Besides, backtrace is execute in kernel mode.
// Therefore cause a kernel page fault
```

### Others
1. i386 manual page 86 about TF and RF


### Scratch Note for Chapter 6 : File System

0. Overview

```
// Important notes:
1. Each sector holds a integer number of inodes, a inode will not cross two
   sector.

// -----------------------------------------------------------------------------
// Disk Format
// -----------------------------------------------------------------------------
Format: | boot | super | inodes | bit map |  data  | log |
Sector:    0       1     2 - x    x+1 - y   y + 1    Z
the number of inodes is set in mkfs.c.

// -----------------------------------------------------------------------------
// On-Disk Layout for Log
// -----------------------------------------------------------------------------
// ----------
// header         (1 block)
// ----------
// data_block[0]
// ----------
// .
// .
// .
// ----------
// data_block[n]
// ----------

// -----------------------------------------------------------------------------
// File System Layers
// -----------------------------------------------------------------------------
                ------------------
System calls    | File Descriptors
                ------------------
Pathnames       | Recursive lookup
                ------------------
Directories     | Directory inodes
                ------------------
Files           | Inodes and block allocator
                ------------------
Transactions    | Logging
                ------------------
Blocks          | Buffer cache
                ------------------

// in-memory    |   map & caching |  on-disk
// buffer block < --------------- > sector
// inode        < --------------- > on disk inode

// "Logical Block" vs "Physics Block"
<1> bn is the "logical block", aka. the index of address array
<2> sector, the argument passed to bread, is called the physics block.
```

1. Important Data Structure

```c

// for the lowest layer: there is buffer cache for secotr (aka. block)
struct {
  struct spinlock lock;
  struct buf buf[NBUF]; // a struct for sector
  struct buf head;
} bcache;

// in-memory struct of inode
struct inode {
  uint dev;
  uint inum;
  // in-memory refernece: counts how many pointers are point to this
  // in-memory indoe
  // JUST think like a smart pointer' s refernece counter
  int ref;          
  int flags;
  
  // this part is same is on-disk inode
  short type;
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};


// for the inodes layer: there is buffer cache for inode
struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} icache;

struct logheader {
  int n;                        // number of sectors
  int sector[LOGSIZE];          // store the dst sector number
};

struct log {
  struct spinlock lock;
  int start;
  int size;
  int busy; // a transaction is active
  int dev;
  struct logheader lh;
};

```

1. Function Interface

```c
// -----------------------------------------------------------------------------
// Buffer Cache Level (aka. sector level, in file bio.c)
// -----------------------------------------------------------------------------
// Important notes:
// 1. each buffer (aka. sector) in any time can be owned by at most
// one kernel thread.

// return a buffer that corresponding to the on-disk sector.
// And the returned buffer is locked (aka. buffer->flags & B_BUSY is set)
// after using it we have to call brelse to relsese the buffer.
// so bread and brelse are used in pair.
struct buf*
bread(uint dev, uint sector);
  -> bget
  -> sleep
  -> iderw

// write buffer to disk, buffer should be locked. (aka. B_BUSY)
void
bwrite(struct buf *b);
  -> iderw

// release a B_BUSY buffer (aka. unlock the buffer)
// also put it in the front of the LRU list
void
brelse(struct buf *b);
  -> wakeup


// -----------------------------------------------------------------------------
// Files Level One: on-disk block operations by manipulating bitmap
// -----------------------------------------------------------------------------

// allocated a zeroed disk block and set its bitmap bit, return its sector number
uint
balloc(uint dev);

// clear bit map bit
void bfree(int dev, uint b);

// -----------------------------------------------------------------------------
// Files Level Two: Inode Meta Data & address array Operations
// In this level, on operation on the file raw content (aka. the no operations
// on the sector the address array points to)
// -----------------------------------------------------------------------------
// Important Note:
// What is inode: A on-disk data structure used to presnete a file.
// inode is a unnamed file.
// It contains file's meta data and a array of address (aka. sector numbers)
// which point to the actual sector holding the file content.

// Given inode nubmer return its in-memory copy (cache).
// If already cahced increase ref.
// !!!! It will not lock the inode and will not load it from
// disk. It just SIMPLEY return a pointer to the cache slot.
struct inode*
iget(uint dev, uint inum);

// Lock the given inode as well as reloading the content from disk
// if necessary
void ilock(struct inode *ip);
  -> sleep
  -> bread

// unlock
void iunlock(struct inode *ip);
  -> wakeup

// drop a reference, 
void iput(struct inode *p);
[]
// update the ondisk inode (update its meta data & address array)
// by copying the in-memory inode
iupdate(struct inode *ip);
  -> bread
  -> log_write

// Truncate inode:
// use bfree to free (aka. clear bitmap bit) all the blocks the adress
// array points to and also update ip
itrunc(struct inode *ip)
  -> bfree
  -> iupdate

// allocate a zero type inode.
struct inode*
ialloc(uint dev, short type);
  -> bread
  -> log_write
  -> iget

// Increment reference cout
struct inode*
idup(struct inode *ip);

// bmap: Map(ip, bn(aka. logical sector number)) -> on disk sector number
// !!!!!! the direct and indirect lookup is perfomred here
uint
bmap(struct inode *ip, uint bn)

// -----------------------------------------------------------------------------
// Files Level Three: read/write the raw content of inode (file)
// (aka. r/w the block the address array points to)
// -----------------------------------------------------------------------------
int
readi(struct inode *ip, char *dst, uint off, uint n);
  -> bmap
writei(struct inode *ip, char *src, uint off, uint n);
  -> bmap

// -----------------------------------------------------------------------------
// Directory Level
// -----------------------------------------------------------------------------
// Important note: directory is also a file
// so it has its inode and its content is a sequence of struct dirent.
// a directory "names" inode file.

// given a path to a file, return its
// corresponding inode pointer
struct inode*
namei(char *path)
  -> namex(path, 0, name)

// given a path to a file, return a inode pointer to its direct parent
struct inode*
nameiparent(char *path, char *name)
  -> namex(path, 1, name)

// Write a new directory (name, inum)
// This function "names" a indoe file.
int dirlink(struct inode *dp, char *name, uint inum)

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
// skipelem("/name1/name2/name3", name)
// skip the topest part of the path, that is "/name1/"
// and set name = "name1". return a pointer to the next part,
// that is "name2/name3"
char*
skipelem(char *path, char *name);

// Look up and return the inode for a path name.
// If nameiparent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
struct inode*
namex(char *path, int nameiparent, char *name)

// -----------------------------------------------------------------------------
// Logging Level
// -----------------------------------------------------------------------------
// Loggin Flow
// lock in-memory log
begin_trans()
  -> set log.busy
// copy the bp->data to the log block i and also set the in-memory log header's
// log.lh.sector[i]
log_write(bp)
  -> bread
  -> bwrite
commit_trans()
  // writeh in-memory log header to on-disk log header.
  // That is update the on-disk log.sector array
  -> write_head()
  // copy the data from log block to the block which log header sector array
  // points to. (do the acutal write)
  -> install_trans()
      -> bread
      -> bwrite
  -> set lh->n = 0
  // update head, indicate write finish
  -> write_head()
```

### Scratch Note for Lab4
0. Flow of SMP
    --------------------------
    BP
    --------------------------
    i386_init()
      -> cons_init()
      -> env_init()
      -> trap_init()
        -> trap_init_percpu()
      -> mp_init()
      -> lapic_init()
      -> pic_init()
      -> boot_aps()
    --------------------------
    AP
    --------------------------
    mp_main()
      -> lapic_init()
      -> env_init_perpcu()
      -> trap_init_percpu()

1. Difference between link address and load address.
2. curenv per cpu becuase curenv = thiscpu->cpu_env

### About system call

1. user space interface: lib/syscall.c
   
   user space system call
    -> lib/syscall.c:syscall
      -> which user INT to jump into kernel space

2. kernel space interface: kern/syscall.c
   INT jumps into trap
    -> syscall to dispatch