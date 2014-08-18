#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

extern int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
int lazy_allocation(uint addr);
// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  // My-Note-Begin
  // SETGATE(gate, =1 trap | =0 interrupt, Code Segment Seletector, Offset of the handler, priviledge)
  // My-Note-End
  // init all entries of IDT to interrupt gate
  // segoment selector points ot hte kernel code segment
  // offset is the vectors[i] (interrupt handler)
  // priviledge is 0
  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);

  // set the T_SYSCALL entry to trap gate
  // segoment selector points ot the kernel code segment
  // offset is the vectors[i]
  // priviledge is 3, so user can call it
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

// Load the IDT (Interrupt Descriptor Table)
void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }

    // My-Note-Begin
    // Should I loop through all the process?
    // My-Note-End
    if (proc && ((tf->cs & 3) == 3) && proc->alarmhandler
        && !proc->alarm_handler_running) {
      ++(proc->alarmtick_cnt);
      // My-Note-Begin
      // Basic Impl, doesn't save caller register
      // cprintf("cnt = %d\n", proc->alarmtick_cnt);
      // if (proc->alarmtick_cnt == proc->alarmticks) {
      //   // cprintf("inside\n");
      //   if (tf->esp < KERNBASE) {
      //     proc->alarmtick_cnt = 0;
      //     // modify the user space stack as well as the trap stack
      //     tf->esp = tf->esp - 4;
      //     *((uint*)tf->esp) = tf->eip;
      //     tf->eip = (uint)proc->alarmhandler;
      //     proc->tf = tf;
      //   }
      // }
      // My-Note-End

      // My-Note-Begin
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
          // ret
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
    }
    lapiceoi();
    break;

  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT:
    // Ori-Stuff
    // cprintf("Oops pid %d %s: trap %d err %d on cpu %d "
    //         "eip 0x%x addr 0x%x--kill proc\n",
    //         proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
    //         rcr2());
    // proc->killed = 1;

    // cprintf("Page Fault at address %x\n", rcr2());
    if (lazy_allocation(rcr2()) < 0) {
      proc->killed = 1;
    }
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
            rcr2());
    proc->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}

int lazy_allocation(uint addr) {
  uint a = PGROUNDDOWN(addr);
  char *mem = kalloc(); // allocate a page
  if (mem == 0) {
    cprintf("lazy allocation out of memory\n");
    return -1;
  }
  memset(mem, 0, PGSIZE);
  if (mappages(proc->pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W | PTE_U) < 0) {
    cprintf("mappages error\n");
    return -1;
  }
  return 0;
}
