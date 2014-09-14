
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 f0 11 f0       	mov    $0xf011f000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 6a 00 00 00       	call   f01000a8 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	83 ec 10             	sub    $0x10,%esp
f0100048:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004b:	83 3d 80 3e 20 f0 00 	cmpl   $0x0,0xf0203e80
f0100052:	75 46                	jne    f010009a <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f0100054:	89 35 80 3e 20 f0    	mov    %esi,0xf0203e80

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010005a:	fa                   	cli    
f010005b:	fc                   	cld    

	va_start(ap, fmt);
f010005c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010005f:	e8 ef 65 00 00       	call   f0106653 <cpunum>
f0100064:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100067:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010006b:	8b 55 08             	mov    0x8(%ebp),%edx
f010006e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100072:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100076:	c7 04 24 60 6d 10 f0 	movl   $0xf0106d60,(%esp)
f010007d:	e8 ef 40 00 00       	call   f0104171 <cprintf>
	vcprintf(fmt, ap);
f0100082:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100086:	89 34 24             	mov    %esi,(%esp)
f0100089:	e8 b0 40 00 00       	call   f010413e <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 79 7f 10 f0 	movl   $0xf0107f79,(%esp)
f0100095:	e8 d7 40 00 00       	call   f0104171 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010009a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000a1:	e8 32 09 00 00       	call   f01009d8 <monitor>
f01000a6:	eb f2                	jmp    f010009a <_panic+0x5a>

f01000a8 <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f01000a8:	55                   	push   %ebp
f01000a9:	89 e5                	mov    %esp,%ebp
f01000ab:	53                   	push   %ebx
f01000ac:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000af:	b8 08 50 24 f0       	mov    $0xf0245008,%eax
f01000b4:	2d 91 2e 20 f0       	sub    $0xf0202e91,%eax
f01000b9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01000c4:	00 
f01000c5:	c7 04 24 91 2e 20 f0 	movl   $0xf0202e91,(%esp)
f01000cc:	e8 e8 5e 00 00       	call   f0105fb9 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000d1:	e8 f4 05 00 00       	call   f01006ca <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000d6:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f01000dd:	00 
f01000de:	c7 04 24 cc 6d 10 f0 	movl   $0xf0106dcc,(%esp)
f01000e5:	e8 87 40 00 00       	call   f0104171 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f01000ea:	e8 a9 15 00 00       	call   f0101698 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f01000ef:	e8 a7 38 00 00       	call   f010399b <env_init>
	trap_init();
f01000f4:	e8 66 41 00 00       	call   f010425f <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f01000f9:	e8 3b 62 00 00       	call   f0106339 <mp_init>
	lapic_init();
f01000fe:	66 90                	xchg   %ax,%ax
f0100100:	e8 69 65 00 00       	call   f010666e <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100105:	e8 97 3f 00 00       	call   f01040a1 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010a:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f0100111:	e8 bb 67 00 00       	call   f01068d1 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100116:	83 3d 88 3e 20 f0 07 	cmpl   $0x7,0xf0203e88
f010011d:	77 24                	ja     f0100143 <i386_init+0x9b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010011f:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f0100126:	00 
f0100127:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010012e:	f0 
f010012f:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0100136:	00 
f0100137:	c7 04 24 e7 6d 10 f0 	movl   $0xf0106de7,(%esp)
f010013e:	e8 fd fe ff ff       	call   f0100040 <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100143:	b8 66 62 10 f0       	mov    $0xf0106266,%eax
f0100148:	2d ec 61 10 f0       	sub    $0xf01061ec,%eax
f010014d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100151:	c7 44 24 04 ec 61 10 	movl   $0xf01061ec,0x4(%esp)
f0100158:	f0 
f0100159:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f0100160:	e8 a1 5e 00 00       	call   f0106006 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f0100165:	6b 05 c4 43 20 f0 74 	imul   $0x74,0xf02043c4,%eax
f010016c:	05 20 40 20 f0       	add    $0xf0204020,%eax
f0100171:	3d 20 40 20 f0       	cmp    $0xf0204020,%eax
f0100176:	76 62                	jbe    f01001da <i386_init+0x132>
f0100178:	bb 20 40 20 f0       	mov    $0xf0204020,%ebx
		if (c == cpus + cpunum())  // We've started already.
f010017d:	e8 d1 64 00 00       	call   f0106653 <cpunum>
f0100182:	6b c0 74             	imul   $0x74,%eax,%eax
f0100185:	05 20 40 20 f0       	add    $0xf0204020,%eax
f010018a:	39 c3                	cmp    %eax,%ebx
f010018c:	74 39                	je     f01001c7 <i386_init+0x11f>
f010018e:	89 d8                	mov    %ebx,%eax
f0100190:	2d 20 40 20 f0       	sub    $0xf0204020,%eax
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100195:	c1 f8 02             	sar    $0x2,%eax
f0100198:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010019e:	c1 e0 0f             	shl    $0xf,%eax
f01001a1:	8d 80 00 d0 20 f0    	lea    -0xfdf3000(%eax),%eax
f01001a7:	a3 84 3e 20 f0       	mov    %eax,0xf0203e84
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f01001ac:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f01001b3:	00 
f01001b4:	0f b6 03             	movzbl (%ebx),%eax
f01001b7:	89 04 24             	mov    %eax,(%esp)
f01001ba:	e8 ff 65 00 00       	call   f01067be <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f01001bf:	8b 43 04             	mov    0x4(%ebx),%eax
f01001c2:	83 f8 01             	cmp    $0x1,%eax
f01001c5:	75 f8                	jne    f01001bf <i386_init+0x117>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001c7:	83 c3 74             	add    $0x74,%ebx
f01001ca:	6b 05 c4 43 20 f0 74 	imul   $0x74,0xf02043c4,%eax
f01001d1:	05 20 40 20 f0       	add    $0xf0204020,%eax
f01001d6:	39 c3                	cmp    %eax,%ebx
f01001d8:	72 a3                	jb     f010017d <i386_init+0xd5>

	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01001e1:	00 
f01001e2:	c7 44 24 04 92 52 01 	movl   $0x15292,0x4(%esp)
f01001e9:	00 
f01001ea:	c7 04 24 ec 41 1c f0 	movl   $0xf01c41ec,(%esp)
f01001f1:	e8 96 39 00 00       	call   f0103b8c <env_create>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01001fd:	00 
f01001fe:	c7 44 24 04 1c 4f 00 	movl   $0x4f1c,0x4(%esp)
f0100205:	00 
f0100206:	c7 04 24 f8 30 1f f0 	movl   $0xf01f30f8,(%esp)
f010020d:	e8 7a 39 00 00       	call   f0103b8c <env_create>
	kbd_intr();
	ENV_CREATE(user_primes, ENV_TYPE_USER);
#endif // TEST*

	// Schedule and run the first user environment!
	sched_yield();
f0100212:	e8 00 49 00 00       	call   f0104b17 <sched_yield>

f0100217 <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f0100217:	55                   	push   %ebp
f0100218:	89 e5                	mov    %esp,%ebp
f010021a:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f010021d:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100222:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100227:	77 20                	ja     f0100249 <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100229:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010022d:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0100234:	f0 
f0100235:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f010023c:	00 
f010023d:	c7 04 24 e7 6d 10 f0 	movl   $0xf0106de7,(%esp)
f0100244:	e8 f7 fd ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0100249:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010024e:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100251:	e8 fd 63 00 00       	call   f0106653 <cpunum>
f0100256:	89 44 24 04          	mov    %eax,0x4(%esp)
f010025a:	c7 04 24 f3 6d 10 f0 	movl   $0xf0106df3,(%esp)
f0100261:	e8 0b 3f 00 00       	call   f0104171 <cprintf>

	lapic_init();
f0100266:	e8 03 64 00 00       	call   f010666e <lapic_init>
	env_init_percpu();
f010026b:	e8 01 37 00 00       	call   f0103971 <env_init_percpu>
	trap_init_percpu();
f0100270:	e8 1b 3f 00 00       	call   f0104190 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100275:	e8 d9 63 00 00       	call   f0106653 <cpunum>
f010027a:	6b d0 74             	imul   $0x74,%eax,%edx
f010027d:	81 c2 20 40 20 f0    	add    $0xf0204020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0100283:	b8 01 00 00 00       	mov    $0x1,%eax
f0100288:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010028c:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f0100293:	e8 39 66 00 00       	call   f01068d1 <spin_lock>
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
	sched_yield();
f0100298:	e8 7a 48 00 00       	call   f0104b17 <sched_yield>

f010029d <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010029d:	55                   	push   %ebp
f010029e:	89 e5                	mov    %esp,%ebp
f01002a0:	53                   	push   %ebx
f01002a1:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f01002a4:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01002aa:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002ae:	8b 45 08             	mov    0x8(%ebp),%eax
f01002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002b5:	c7 04 24 09 6e 10 f0 	movl   $0xf0106e09,(%esp)
f01002bc:	e8 b0 3e 00 00       	call   f0104171 <cprintf>
	vcprintf(fmt, ap);
f01002c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01002c5:	8b 45 10             	mov    0x10(%ebp),%eax
f01002c8:	89 04 24             	mov    %eax,(%esp)
f01002cb:	e8 6e 3e 00 00       	call   f010413e <vcprintf>
	cprintf("\n");
f01002d0:	c7 04 24 79 7f 10 f0 	movl   $0xf0107f79,(%esp)
f01002d7:	e8 95 3e 00 00       	call   f0104171 <cprintf>
	va_end(ap);
}
f01002dc:	83 c4 14             	add    $0x14,%esp
f01002df:	5b                   	pop    %ebx
f01002e0:	5d                   	pop    %ebp
f01002e1:	c3                   	ret    
f01002e2:	66 90                	xchg   %ax,%ax
f01002e4:	66 90                	xchg   %ax,%ax
f01002e6:	66 90                	xchg   %ax,%ax
f01002e8:	66 90                	xchg   %ax,%ax
f01002ea:	66 90                	xchg   %ax,%ax
f01002ec:	66 90                	xchg   %ax,%ax
f01002ee:	66 90                	xchg   %ax,%ax

f01002f0 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01002f0:	55                   	push   %ebp
f01002f1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002f8:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002f9:	a8 01                	test   $0x1,%al
f01002fb:	74 08                	je     f0100305 <serial_proc_data+0x15>
f01002fd:	b2 f8                	mov    $0xf8,%dl
f01002ff:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100300:	0f b6 c0             	movzbl %al,%eax
f0100303:	eb 05                	jmp    f010030a <serial_proc_data+0x1a>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f010030a:	5d                   	pop    %ebp
f010030b:	c3                   	ret    

f010030c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010030c:	55                   	push   %ebp
f010030d:	89 e5                	mov    %esp,%ebp
f010030f:	53                   	push   %ebx
f0100310:	83 ec 04             	sub    $0x4,%esp
f0100313:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100315:	eb 2a                	jmp    f0100341 <cons_intr+0x35>
		if (c == 0)
f0100317:	85 d2                	test   %edx,%edx
f0100319:	74 26                	je     f0100341 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f010031b:	a1 24 32 20 f0       	mov    0xf0203224,%eax
f0100320:	8d 48 01             	lea    0x1(%eax),%ecx
f0100323:	89 0d 24 32 20 f0    	mov    %ecx,0xf0203224
f0100329:	88 90 20 30 20 f0    	mov    %dl,-0xfdfcfe0(%eax)
		if (cons.wpos == CONSBUFSIZE)
f010032f:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100335:	75 0a                	jne    f0100341 <cons_intr+0x35>
			cons.wpos = 0;
f0100337:	c7 05 24 32 20 f0 00 	movl   $0x0,0xf0203224
f010033e:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100341:	ff d3                	call   *%ebx
f0100343:	89 c2                	mov    %eax,%edx
f0100345:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100348:	75 cd                	jne    f0100317 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f010034a:	83 c4 04             	add    $0x4,%esp
f010034d:	5b                   	pop    %ebx
f010034e:	5d                   	pop    %ebp
f010034f:	c3                   	ret    

f0100350 <kbd_proc_data>:
f0100350:	ba 64 00 00 00       	mov    $0x64,%edx
f0100355:	ec                   	in     (%dx),%al
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f0100356:	a8 01                	test   $0x1,%al
f0100358:	0f 84 ef 00 00 00    	je     f010044d <kbd_proc_data+0xfd>
f010035e:	b2 60                	mov    $0x60,%dl
f0100360:	ec                   	in     (%dx),%al
f0100361:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f0100363:	3c e0                	cmp    $0xe0,%al
f0100365:	75 0d                	jne    f0100374 <kbd_proc_data+0x24>
		// E0 escape character
		shift |= E0ESC;
f0100367:	83 0d 00 30 20 f0 40 	orl    $0x40,0xf0203000
		return 0;
f010036e:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100373:	c3                   	ret    
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100374:	55                   	push   %ebp
f0100375:	89 e5                	mov    %esp,%ebp
f0100377:	53                   	push   %ebx
f0100378:	83 ec 14             	sub    $0x14,%esp

	if (data == 0xE0) {
		// E0 escape character
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
f010037b:	84 c0                	test   %al,%al
f010037d:	79 37                	jns    f01003b6 <kbd_proc_data+0x66>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f010037f:	8b 0d 00 30 20 f0    	mov    0xf0203000,%ecx
f0100385:	89 cb                	mov    %ecx,%ebx
f0100387:	83 e3 40             	and    $0x40,%ebx
f010038a:	83 e0 7f             	and    $0x7f,%eax
f010038d:	85 db                	test   %ebx,%ebx
f010038f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100392:	0f b6 d2             	movzbl %dl,%edx
f0100395:	0f b6 82 80 6f 10 f0 	movzbl -0xfef9080(%edx),%eax
f010039c:	83 c8 40             	or     $0x40,%eax
f010039f:	0f b6 c0             	movzbl %al,%eax
f01003a2:	f7 d0                	not    %eax
f01003a4:	21 c1                	and    %eax,%ecx
f01003a6:	89 0d 00 30 20 f0    	mov    %ecx,0xf0203000
		return 0;
f01003ac:	b8 00 00 00 00       	mov    $0x0,%eax
f01003b1:	e9 9d 00 00 00       	jmp    f0100453 <kbd_proc_data+0x103>
	} else if (shift & E0ESC) {
f01003b6:	8b 0d 00 30 20 f0    	mov    0xf0203000,%ecx
f01003bc:	f6 c1 40             	test   $0x40,%cl
f01003bf:	74 0e                	je     f01003cf <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01003c1:	83 c8 80             	or     $0xffffff80,%eax
f01003c4:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01003c6:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003c9:	89 0d 00 30 20 f0    	mov    %ecx,0xf0203000
	}

	shift |= shiftcode[data];
f01003cf:	0f b6 d2             	movzbl %dl,%edx
f01003d2:	0f b6 82 80 6f 10 f0 	movzbl -0xfef9080(%edx),%eax
f01003d9:	0b 05 00 30 20 f0    	or     0xf0203000,%eax
	shift ^= togglecode[data];
f01003df:	0f b6 8a 80 6e 10 f0 	movzbl -0xfef9180(%edx),%ecx
f01003e6:	31 c8                	xor    %ecx,%eax
f01003e8:	a3 00 30 20 f0       	mov    %eax,0xf0203000

	c = charcode[shift & (CTL | SHIFT)][data];
f01003ed:	89 c1                	mov    %eax,%ecx
f01003ef:	83 e1 03             	and    $0x3,%ecx
f01003f2:	8b 0c 8d 60 6e 10 f0 	mov    -0xfef91a0(,%ecx,4),%ecx
f01003f9:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01003fd:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100400:	a8 08                	test   $0x8,%al
f0100402:	74 1b                	je     f010041f <kbd_proc_data+0xcf>
		if ('a' <= c && c <= 'z')
f0100404:	89 da                	mov    %ebx,%edx
f0100406:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100409:	83 f9 19             	cmp    $0x19,%ecx
f010040c:	77 05                	ja     f0100413 <kbd_proc_data+0xc3>
			c += 'A' - 'a';
f010040e:	83 eb 20             	sub    $0x20,%ebx
f0100411:	eb 0c                	jmp    f010041f <kbd_proc_data+0xcf>
		else if ('A' <= c && c <= 'Z')
f0100413:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100416:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100419:	83 fa 19             	cmp    $0x19,%edx
f010041c:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010041f:	f7 d0                	not    %eax
f0100421:	89 c2                	mov    %eax,%edx
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100423:	89 d8                	mov    %ebx,%eax
			c += 'a' - 'A';
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100425:	f6 c2 06             	test   $0x6,%dl
f0100428:	75 29                	jne    f0100453 <kbd_proc_data+0x103>
f010042a:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100430:	75 21                	jne    f0100453 <kbd_proc_data+0x103>
		cprintf("Rebooting!\n");
f0100432:	c7 04 24 23 6e 10 f0 	movl   $0xf0106e23,(%esp)
f0100439:	e8 33 3d 00 00       	call   f0104171 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010043e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100443:	b8 03 00 00 00       	mov    $0x3,%eax
f0100448:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100449:	89 d8                	mov    %ebx,%eax
f010044b:	eb 06                	jmp    f0100453 <kbd_proc_data+0x103>
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f010044d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100452:	c3                   	ret    
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100453:	83 c4 14             	add    $0x14,%esp
f0100456:	5b                   	pop    %ebx
f0100457:	5d                   	pop    %ebp
f0100458:	c3                   	ret    

f0100459 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100459:	55                   	push   %ebp
f010045a:	89 e5                	mov    %esp,%ebp
f010045c:	57                   	push   %edi
f010045d:	56                   	push   %esi
f010045e:	53                   	push   %ebx
f010045f:	83 ec 1c             	sub    $0x1c,%esp
f0100462:	89 c7                	mov    %eax,%edi

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100464:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100469:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010046a:	a8 20                	test   $0x20,%al
f010046c:	75 27                	jne    f0100495 <cons_putc+0x3c>
f010046e:	bb 00 32 00 00       	mov    $0x3200,%ebx
f0100473:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100478:	be fd 03 00 00       	mov    $0x3fd,%esi
f010047d:	89 ca                	mov    %ecx,%edx
f010047f:	ec                   	in     (%dx),%al
f0100480:	89 ca                	mov    %ecx,%edx
f0100482:	ec                   	in     (%dx),%al
f0100483:	89 ca                	mov    %ecx,%edx
f0100485:	ec                   	in     (%dx),%al
f0100486:	89 ca                	mov    %ecx,%edx
f0100488:	ec                   	in     (%dx),%al
f0100489:	89 f2                	mov    %esi,%edx
f010048b:	ec                   	in     (%dx),%al
f010048c:	a8 20                	test   $0x20,%al
f010048e:	75 05                	jne    f0100495 <cons_putc+0x3c>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100490:	83 eb 01             	sub    $0x1,%ebx
f0100493:	75 e8                	jne    f010047d <cons_putc+0x24>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100495:	89 f8                	mov    %edi,%eax
f0100497:	0f b6 c0             	movzbl %al,%eax
f010049a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010049d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004a2:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004a3:	b2 79                	mov    $0x79,%dl
f01004a5:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004a6:	84 c0                	test   %al,%al
f01004a8:	78 27                	js     f01004d1 <cons_putc+0x78>
f01004aa:	bb 00 32 00 00       	mov    $0x3200,%ebx
f01004af:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004b4:	be 79 03 00 00       	mov    $0x379,%esi
f01004b9:	89 ca                	mov    %ecx,%edx
f01004bb:	ec                   	in     (%dx),%al
f01004bc:	89 ca                	mov    %ecx,%edx
f01004be:	ec                   	in     (%dx),%al
f01004bf:	89 ca                	mov    %ecx,%edx
f01004c1:	ec                   	in     (%dx),%al
f01004c2:	89 ca                	mov    %ecx,%edx
f01004c4:	ec                   	in     (%dx),%al
f01004c5:	89 f2                	mov    %esi,%edx
f01004c7:	ec                   	in     (%dx),%al
f01004c8:	84 c0                	test   %al,%al
f01004ca:	78 05                	js     f01004d1 <cons_putc+0x78>
f01004cc:	83 eb 01             	sub    $0x1,%ebx
f01004cf:	75 e8                	jne    f01004b9 <cons_putc+0x60>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004d1:	ba 78 03 00 00       	mov    $0x378,%edx
f01004d6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f01004da:	ee                   	out    %al,(%dx)
f01004db:	b2 7a                	mov    $0x7a,%dl
f01004dd:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004e2:	ee                   	out    %al,(%dx)
f01004e3:	b8 08 00 00 00       	mov    $0x8,%eax
f01004e8:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f01004e9:	89 fa                	mov    %edi,%edx
f01004eb:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004f1:	89 f8                	mov    %edi,%eax
f01004f3:	80 cc 07             	or     $0x7,%ah
f01004f6:	85 d2                	test   %edx,%edx
f01004f8:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f01004fb:	89 f8                	mov    %edi,%eax
f01004fd:	0f b6 c0             	movzbl %al,%eax
f0100500:	83 f8 09             	cmp    $0x9,%eax
f0100503:	74 78                	je     f010057d <cons_putc+0x124>
f0100505:	83 f8 09             	cmp    $0x9,%eax
f0100508:	7f 0b                	jg     f0100515 <cons_putc+0xbc>
f010050a:	83 f8 08             	cmp    $0x8,%eax
f010050d:	74 18                	je     f0100527 <cons_putc+0xce>
f010050f:	90                   	nop
f0100510:	e9 9c 00 00 00       	jmp    f01005b1 <cons_putc+0x158>
f0100515:	83 f8 0a             	cmp    $0xa,%eax
f0100518:	74 3d                	je     f0100557 <cons_putc+0xfe>
f010051a:	83 f8 0d             	cmp    $0xd,%eax
f010051d:	8d 76 00             	lea    0x0(%esi),%esi
f0100520:	74 3d                	je     f010055f <cons_putc+0x106>
f0100522:	e9 8a 00 00 00       	jmp    f01005b1 <cons_putc+0x158>
	case '\b':
		if (crt_pos > 0) {
f0100527:	0f b7 05 28 32 20 f0 	movzwl 0xf0203228,%eax
f010052e:	66 85 c0             	test   %ax,%ax
f0100531:	0f 84 e5 00 00 00    	je     f010061c <cons_putc+0x1c3>
			crt_pos--;
f0100537:	83 e8 01             	sub    $0x1,%eax
f010053a:	66 a3 28 32 20 f0    	mov    %ax,0xf0203228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100540:	0f b7 c0             	movzwl %ax,%eax
f0100543:	66 81 e7 00 ff       	and    $0xff00,%di
f0100548:	83 cf 20             	or     $0x20,%edi
f010054b:	8b 15 2c 32 20 f0    	mov    0xf020322c,%edx
f0100551:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100555:	eb 78                	jmp    f01005cf <cons_putc+0x176>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f0100557:	66 83 05 28 32 20 f0 	addw   $0x50,0xf0203228
f010055e:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f010055f:	0f b7 05 28 32 20 f0 	movzwl 0xf0203228,%eax
f0100566:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010056c:	c1 e8 16             	shr    $0x16,%eax
f010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100572:	c1 e0 04             	shl    $0x4,%eax
f0100575:	66 a3 28 32 20 f0    	mov    %ax,0xf0203228
f010057b:	eb 52                	jmp    f01005cf <cons_putc+0x176>
		break;
	case '\t':
		cons_putc(' ');
f010057d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100582:	e8 d2 fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f0100587:	b8 20 00 00 00       	mov    $0x20,%eax
f010058c:	e8 c8 fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f0100591:	b8 20 00 00 00       	mov    $0x20,%eax
f0100596:	e8 be fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f010059b:	b8 20 00 00 00       	mov    $0x20,%eax
f01005a0:	e8 b4 fe ff ff       	call   f0100459 <cons_putc>
		cons_putc(' ');
f01005a5:	b8 20 00 00 00       	mov    $0x20,%eax
f01005aa:	e8 aa fe ff ff       	call   f0100459 <cons_putc>
f01005af:	eb 1e                	jmp    f01005cf <cons_putc+0x176>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01005b1:	0f b7 05 28 32 20 f0 	movzwl 0xf0203228,%eax
f01005b8:	8d 50 01             	lea    0x1(%eax),%edx
f01005bb:	66 89 15 28 32 20 f0 	mov    %dx,0xf0203228
f01005c2:	0f b7 c0             	movzwl %ax,%eax
f01005c5:	8b 15 2c 32 20 f0    	mov    0xf020322c,%edx
f01005cb:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01005cf:	66 81 3d 28 32 20 f0 	cmpw   $0x7cf,0xf0203228
f01005d6:	cf 07 
f01005d8:	76 42                	jbe    f010061c <cons_putc+0x1c3>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005da:	a1 2c 32 20 f0       	mov    0xf020322c,%eax
f01005df:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f01005e6:	00 
f01005e7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005ed:	89 54 24 04          	mov    %edx,0x4(%esp)
f01005f1:	89 04 24             	mov    %eax,(%esp)
f01005f4:	e8 0d 5a 00 00       	call   f0106006 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01005f9:	8b 15 2c 32 20 f0    	mov    0xf020322c,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005ff:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f0100604:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f010060a:	83 c0 01             	add    $0x1,%eax
f010060d:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100612:	75 f0                	jne    f0100604 <cons_putc+0x1ab>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100614:	66 83 2d 28 32 20 f0 	subw   $0x50,0xf0203228
f010061b:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f010061c:	8b 0d 30 32 20 f0    	mov    0xf0203230,%ecx
f0100622:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100627:	89 ca                	mov    %ecx,%edx
f0100629:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010062a:	0f b7 1d 28 32 20 f0 	movzwl 0xf0203228,%ebx
f0100631:	8d 71 01             	lea    0x1(%ecx),%esi
f0100634:	89 d8                	mov    %ebx,%eax
f0100636:	66 c1 e8 08          	shr    $0x8,%ax
f010063a:	89 f2                	mov    %esi,%edx
f010063c:	ee                   	out    %al,(%dx)
f010063d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100642:	89 ca                	mov    %ecx,%edx
f0100644:	ee                   	out    %al,(%dx)
f0100645:	89 d8                	mov    %ebx,%eax
f0100647:	89 f2                	mov    %esi,%edx
f0100649:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010064a:	83 c4 1c             	add    $0x1c,%esp
f010064d:	5b                   	pop    %ebx
f010064e:	5e                   	pop    %esi
f010064f:	5f                   	pop    %edi
f0100650:	5d                   	pop    %ebp
f0100651:	c3                   	ret    

f0100652 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f0100652:	80 3d 34 32 20 f0 00 	cmpb   $0x0,0xf0203234
f0100659:	74 11                	je     f010066c <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f010065b:	55                   	push   %ebp
f010065c:	89 e5                	mov    %esp,%ebp
f010065e:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f0100661:	b8 f0 02 10 f0       	mov    $0xf01002f0,%eax
f0100666:	e8 a1 fc ff ff       	call   f010030c <cons_intr>
}
f010066b:	c9                   	leave  
f010066c:	f3 c3                	repz ret 

f010066e <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f010066e:	55                   	push   %ebp
f010066f:	89 e5                	mov    %esp,%ebp
f0100671:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100674:	b8 50 03 10 f0       	mov    $0xf0100350,%eax
f0100679:	e8 8e fc ff ff       	call   f010030c <cons_intr>
}
f010067e:	c9                   	leave  
f010067f:	c3                   	ret    

f0100680 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100680:	55                   	push   %ebp
f0100681:	89 e5                	mov    %esp,%ebp
f0100683:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100686:	e8 c7 ff ff ff       	call   f0100652 <serial_intr>
	kbd_intr();
f010068b:	e8 de ff ff ff       	call   f010066e <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100690:	a1 20 32 20 f0       	mov    0xf0203220,%eax
f0100695:	3b 05 24 32 20 f0    	cmp    0xf0203224,%eax
f010069b:	74 26                	je     f01006c3 <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f010069d:	8d 50 01             	lea    0x1(%eax),%edx
f01006a0:	89 15 20 32 20 f0    	mov    %edx,0xf0203220
f01006a6:	0f b6 88 20 30 20 f0 	movzbl -0xfdfcfe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f01006ad:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f01006af:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01006b5:	75 11                	jne    f01006c8 <cons_getc+0x48>
			cons.rpos = 0;
f01006b7:	c7 05 20 32 20 f0 00 	movl   $0x0,0xf0203220
f01006be:	00 00 00 
f01006c1:	eb 05                	jmp    f01006c8 <cons_getc+0x48>
		return c;
	}
	return 0;
f01006c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01006c8:	c9                   	leave  
f01006c9:	c3                   	ret    

f01006ca <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01006ca:	55                   	push   %ebp
f01006cb:	89 e5                	mov    %esp,%ebp
f01006cd:	57                   	push   %edi
f01006ce:	56                   	push   %esi
f01006cf:	53                   	push   %ebx
f01006d0:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01006d3:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006da:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006e1:	5a a5 
	if (*cp != 0xA55A) {
f01006e3:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006ea:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006ee:	74 11                	je     f0100701 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01006f0:	c7 05 30 32 20 f0 b4 	movl   $0x3b4,0xf0203230
f01006f7:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006fa:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
f01006ff:	eb 16                	jmp    f0100717 <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f0100701:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100708:	c7 05 30 32 20 f0 d4 	movl   $0x3d4,0xf0203230
f010070f:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100712:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f0100717:	8b 0d 30 32 20 f0    	mov    0xf0203230,%ecx
f010071d:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100722:	89 ca                	mov    %ecx,%edx
f0100724:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100725:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100728:	89 da                	mov    %ebx,%edx
f010072a:	ec                   	in     (%dx),%al
f010072b:	0f b6 f0             	movzbl %al,%esi
f010072e:	c1 e6 08             	shl    $0x8,%esi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100731:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100736:	89 ca                	mov    %ecx,%edx
f0100738:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100739:	89 da                	mov    %ebx,%edx
f010073b:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f010073c:	89 3d 2c 32 20 f0    	mov    %edi,0xf020322c

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f0100742:	0f b6 d8             	movzbl %al,%ebx
f0100745:	09 de                	or     %ebx,%esi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f0100747:	66 89 35 28 32 20 f0 	mov    %si,0xf0203228

static void
kbd_init(void)
{
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f010074e:	e8 1b ff ff ff       	call   f010066e <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100753:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f010075a:	25 fd ff 00 00       	and    $0xfffd,%eax
f010075f:	89 04 24             	mov    %eax,(%esp)
f0100762:	e8 cb 38 00 00       	call   f0104032 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100767:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010076c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100771:	ee                   	out    %al,(%dx)
f0100772:	b2 fb                	mov    $0xfb,%dl
f0100774:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100779:	ee                   	out    %al,(%dx)
f010077a:	b2 f8                	mov    $0xf8,%dl
f010077c:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100781:	ee                   	out    %al,(%dx)
f0100782:	b2 f9                	mov    $0xf9,%dl
f0100784:	b8 00 00 00 00       	mov    $0x0,%eax
f0100789:	ee                   	out    %al,(%dx)
f010078a:	b2 fb                	mov    $0xfb,%dl
f010078c:	b8 03 00 00 00       	mov    $0x3,%eax
f0100791:	ee                   	out    %al,(%dx)
f0100792:	b2 fc                	mov    $0xfc,%dl
f0100794:	b8 00 00 00 00       	mov    $0x0,%eax
f0100799:	ee                   	out    %al,(%dx)
f010079a:	b2 f9                	mov    $0xf9,%dl
f010079c:	b8 01 00 00 00       	mov    $0x1,%eax
f01007a1:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007a2:	b2 fd                	mov    $0xfd,%dl
f01007a4:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007a5:	3c ff                	cmp    $0xff,%al
f01007a7:	0f 95 c1             	setne  %cl
f01007aa:	88 0d 34 32 20 f0    	mov    %cl,0xf0203234
f01007b0:	b2 fa                	mov    $0xfa,%dl
f01007b2:	ec                   	in     (%dx),%al
f01007b3:	b2 f8                	mov    $0xf8,%dl
f01007b5:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01007b6:	84 c9                	test   %cl,%cl
f01007b8:	74 1d                	je     f01007d7 <cons_init+0x10d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01007ba:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f01007c1:	25 ef ff 00 00       	and    $0xffef,%eax
f01007c6:	89 04 24             	mov    %eax,(%esp)
f01007c9:	e8 64 38 00 00       	call   f0104032 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01007ce:	80 3d 34 32 20 f0 00 	cmpb   $0x0,0xf0203234
f01007d5:	75 0c                	jne    f01007e3 <cons_init+0x119>
		cprintf("Serial port does not exist!\n");
f01007d7:	c7 04 24 2f 6e 10 f0 	movl   $0xf0106e2f,(%esp)
f01007de:	e8 8e 39 00 00       	call   f0104171 <cprintf>
}
f01007e3:	83 c4 1c             	add    $0x1c,%esp
f01007e6:	5b                   	pop    %ebx
f01007e7:	5e                   	pop    %esi
f01007e8:	5f                   	pop    %edi
f01007e9:	5d                   	pop    %ebp
f01007ea:	c3                   	ret    

f01007eb <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007eb:	55                   	push   %ebp
f01007ec:	89 e5                	mov    %esp,%ebp
f01007ee:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007f1:	8b 45 08             	mov    0x8(%ebp),%eax
f01007f4:	e8 60 fc ff ff       	call   f0100459 <cons_putc>
}
f01007f9:	c9                   	leave  
f01007fa:	c3                   	ret    

f01007fb <getchar>:

int
getchar(void)
{
f01007fb:	55                   	push   %ebp
f01007fc:	89 e5                	mov    %esp,%ebp
f01007fe:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100801:	e8 7a fe ff ff       	call   f0100680 <cons_getc>
f0100806:	85 c0                	test   %eax,%eax
f0100808:	74 f7                	je     f0100801 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010080a:	c9                   	leave  
f010080b:	c3                   	ret    

f010080c <iscons>:

int
iscons(int fdnum)
{
f010080c:	55                   	push   %ebp
f010080d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f010080f:	b8 01 00 00 00       	mov    $0x1,%eax
f0100814:	5d                   	pop    %ebp
f0100815:	c3                   	ret    
f0100816:	66 90                	xchg   %ax,%ax
f0100818:	66 90                	xchg   %ax,%ax
f010081a:	66 90                	xchg   %ax,%ax
f010081c:	66 90                	xchg   %ax,%ax
f010081e:	66 90                	xchg   %ax,%ax

f0100820 <mon_continue>:
	}
	return 0;
}


int mon_continue(int argc, char **argv, struct Trapframe *tf) {
f0100820:	55                   	push   %ebp
f0100821:	89 e5                	mov    %esp,%ebp
	__exit = 1;
f0100823:	c7 05 38 32 20 f0 01 	movl   $0x1,0xf0203238
f010082a:	00 00 00 
	return 0;
}
f010082d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100832:	5d                   	pop    %ebp
f0100833:	c3                   	ret    

f0100834 <mon_help>:
static int __exit = 0;
/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100834:	55                   	push   %ebp
f0100835:	89 e5                	mov    %esp,%ebp
f0100837:	56                   	push   %esi
f0100838:	53                   	push   %ebx
f0100839:	83 ec 10             	sub    $0x10,%esp
f010083c:	bb 04 73 10 f0       	mov    $0xf0107304,%ebx
f0100841:	be 34 73 10 f0       	mov    $0xf0107334,%esi
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100846:	8b 03                	mov    (%ebx),%eax
f0100848:	89 44 24 08          	mov    %eax,0x8(%esp)
f010084c:	8b 43 fc             	mov    -0x4(%ebx),%eax
f010084f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100853:	c7 04 24 80 70 10 f0 	movl   $0xf0107080,(%esp)
f010085a:	e8 12 39 00 00       	call   f0104171 <cprintf>
f010085f:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f0100862:	39 f3                	cmp    %esi,%ebx
f0100864:	75 e0                	jne    f0100846 <mon_help+0x12>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f0100866:	b8 00 00 00 00       	mov    $0x0,%eax
f010086b:	83 c4 10             	add    $0x10,%esp
f010086e:	5b                   	pop    %ebx
f010086f:	5e                   	pop    %esi
f0100870:	5d                   	pop    %ebp
f0100871:	c3                   	ret    

f0100872 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100872:	55                   	push   %ebp
f0100873:	89 e5                	mov    %esp,%ebp
f0100875:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100878:	c7 04 24 89 70 10 f0 	movl   $0xf0107089,(%esp)
f010087f:	e8 ed 38 00 00       	call   f0104171 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100884:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f010088b:	00 
f010088c:	c7 04 24 20 71 10 f0 	movl   $0xf0107120,(%esp)
f0100893:	e8 d9 38 00 00       	call   f0104171 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100898:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f010089f:	00 
f01008a0:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01008a7:	f0 
f01008a8:	c7 04 24 48 71 10 f0 	movl   $0xf0107148,(%esp)
f01008af:	e8 bd 38 00 00       	call   f0104171 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008b4:	c7 44 24 08 57 6d 10 	movl   $0x106d57,0x8(%esp)
f01008bb:	00 
f01008bc:	c7 44 24 04 57 6d 10 	movl   $0xf0106d57,0x4(%esp)
f01008c3:	f0 
f01008c4:	c7 04 24 6c 71 10 f0 	movl   $0xf010716c,(%esp)
f01008cb:	e8 a1 38 00 00       	call   f0104171 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008d0:	c7 44 24 08 91 2e 20 	movl   $0x202e91,0x8(%esp)
f01008d7:	00 
f01008d8:	c7 44 24 04 91 2e 20 	movl   $0xf0202e91,0x4(%esp)
f01008df:	f0 
f01008e0:	c7 04 24 90 71 10 f0 	movl   $0xf0107190,(%esp)
f01008e7:	e8 85 38 00 00       	call   f0104171 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008ec:	c7 44 24 08 08 50 24 	movl   $0x245008,0x8(%esp)
f01008f3:	00 
f01008f4:	c7 44 24 04 08 50 24 	movl   $0xf0245008,0x4(%esp)
f01008fb:	f0 
f01008fc:	c7 04 24 b4 71 10 f0 	movl   $0xf01071b4,(%esp)
f0100903:	e8 69 38 00 00       	call   f0104171 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f0100908:	b8 07 54 24 f0       	mov    $0xf0245407,%eax
f010090d:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100912:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100917:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f010091d:	85 c0                	test   %eax,%eax
f010091f:	0f 48 c2             	cmovs  %edx,%eax
f0100922:	c1 f8 0a             	sar    $0xa,%eax
f0100925:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100929:	c7 04 24 d8 71 10 f0 	movl   $0xf01071d8,(%esp)
f0100930:	e8 3c 38 00 00       	call   f0104171 <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100935:	b8 00 00 00 00       	mov    $0x0,%eax
f010093a:	c9                   	leave  
f010093b:	c3                   	ret    

f010093c <mon_backtrace>:

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f010093c:	89 e8                	mov    %ebp,%eax

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	unsigned ebp = read_ebp();
	while (ebp) {
f010093e:	85 c0                	test   %eax,%eax
f0100940:	0f 84 8c 00 00 00    	je     f01009d2 <mon_backtrace+0x96>
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100946:	55                   	push   %ebp
f0100947:	89 e5                	mov    %esp,%ebp
f0100949:	57                   	push   %edi
f010094a:	56                   	push   %esi
f010094b:	53                   	push   %ebx
f010094c:	83 ec 6c             	sub    $0x6c,%esp
f010094f:	89 c3                	mov    %eax,%ebx
	unsigned ebp = read_ebp();
	while (ebp) {
		struct Eipdebuginfo info;
		unsigned eip = *((unsigned *)ebp + 1);
		debuginfo_eip(eip, &info);
f0100951:	8d 7d d0             	lea    -0x30(%ebp),%edi
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	unsigned ebp = read_ebp();
	while (ebp) {
		struct Eipdebuginfo info;
		unsigned eip = *((unsigned *)ebp + 1);
f0100954:	8b 73 04             	mov    0x4(%ebx),%esi
		debuginfo_eip(eip, &info);
f0100957:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010095b:	89 34 24             	mov    %esi,(%esp)
f010095e:	e8 43 4a 00 00       	call   f01053a6 <debuginfo_eip>
		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x %s:%d: %.*s+%d\n",
f0100963:	89 f0                	mov    %esi,%eax
f0100965:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100968:	89 44 24 30          	mov    %eax,0x30(%esp)
f010096c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010096f:	89 44 24 2c          	mov    %eax,0x2c(%esp)
f0100973:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100976:	89 44 24 28          	mov    %eax,0x28(%esp)
f010097a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010097d:	89 44 24 24          	mov    %eax,0x24(%esp)
f0100981:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100984:	89 44 24 20          	mov    %eax,0x20(%esp)
f0100988:	8b 43 18             	mov    0x18(%ebx),%eax
f010098b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f010098f:	8b 43 14             	mov    0x14(%ebx),%eax
f0100992:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100996:	8b 43 10             	mov    0x10(%ebx),%eax
f0100999:	89 44 24 14          	mov    %eax,0x14(%esp)
f010099d:	8b 43 0c             	mov    0xc(%ebx),%eax
f01009a0:	89 44 24 10          	mov    %eax,0x10(%esp)
f01009a4:	8b 43 08             	mov    0x8(%ebx),%eax
f01009a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01009ab:	89 74 24 08          	mov    %esi,0x8(%esp)
f01009af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01009b3:	c7 04 24 04 72 10 f0 	movl   $0xf0107204,(%esp)
f01009ba:	e8 b2 37 00 00       	call   f0104171 <cprintf>
			      info.eip_file,
			      info.eip_line,
			      info.eip_fn_namelen, info.eip_fn_name,
			      (char*)eip - (char*)info.eip_fn_addr);

		ebp = *(unsigned*)ebp;
f01009bf:	8b 1b                	mov    (%ebx),%ebx

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	unsigned ebp = read_ebp();
	while (ebp) {
f01009c1:	85 db                	test   %ebx,%ebx
f01009c3:	75 8f                	jne    f0100954 <mon_backtrace+0x18>
			      (char*)eip - (char*)info.eip_fn_addr);

		ebp = *(unsigned*)ebp;
	}
	return 0;
}
f01009c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01009ca:	83 c4 6c             	add    $0x6c,%esp
f01009cd:	5b                   	pop    %ebx
f01009ce:	5e                   	pop    %esi
f01009cf:	5f                   	pop    %edi
f01009d0:	5d                   	pop    %ebp
f01009d1:	c3                   	ret    
f01009d2:	b8 00 00 00 00       	mov    $0x0,%eax
f01009d7:	c3                   	ret    

f01009d8 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01009d8:	55                   	push   %ebp
f01009d9:	89 e5                	mov    %esp,%ebp
f01009db:	57                   	push   %edi
f01009dc:	56                   	push   %esi
f01009dd:	53                   	push   %ebx
f01009de:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01009e1:	c7 04 24 44 72 10 f0 	movl   $0xf0107244,(%esp)
f01009e8:	e8 84 37 00 00       	call   f0104171 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01009ed:	c7 04 24 68 72 10 f0 	movl   $0xf0107268,(%esp)
f01009f4:	e8 78 37 00 00       	call   f0104171 <cprintf>

	if (tf != NULL)
f01009f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009fd:	74 0b                	je     f0100a0a <monitor+0x32>
		print_trapframe(tf);
f01009ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a02:	89 04 24             	mov    %eax,(%esp)
f0100a05:	e8 eb 39 00 00       	call   f01043f5 <print_trapframe>

	__exit = 0;
f0100a0a:	c7 05 38 32 20 f0 00 	movl   $0x0,0xf0203238
f0100a11:	00 00 00 
	while (!__exit) {
f0100a14:	e9 0f 01 00 00       	jmp    f0100b28 <monitor+0x150>
		buf = readline("K> ");
f0100a19:	c7 04 24 a2 70 10 f0 	movl   $0xf01070a2,(%esp)
f0100a20:	e8 ab 52 00 00       	call   f0105cd0 <readline>
f0100a25:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a27:	85 c0                	test   %eax,%eax
f0100a29:	0f 84 f9 00 00 00    	je     f0100b28 <monitor+0x150>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a2f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100a36:	be 00 00 00 00       	mov    $0x0,%esi
f0100a3b:	eb 0a                	jmp    f0100a47 <monitor+0x6f>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100a3d:	c6 03 00             	movb   $0x0,(%ebx)
f0100a40:	89 f7                	mov    %esi,%edi
f0100a42:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100a45:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a47:	0f b6 03             	movzbl (%ebx),%eax
f0100a4a:	84 c0                	test   %al,%al
f0100a4c:	74 70                	je     f0100abe <monitor+0xe6>
f0100a4e:	0f be c0             	movsbl %al,%eax
f0100a51:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a55:	c7 04 24 a6 70 10 f0 	movl   $0xf01070a6,(%esp)
f0100a5c:	e8 f8 54 00 00       	call   f0105f59 <strchr>
f0100a61:	85 c0                	test   %eax,%eax
f0100a63:	75 d8                	jne    f0100a3d <monitor+0x65>
			*buf++ = 0;
		if (*buf == 0)
f0100a65:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a68:	74 54                	je     f0100abe <monitor+0xe6>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a6a:	83 fe 0f             	cmp    $0xf,%esi
f0100a6d:	8d 76 00             	lea    0x0(%esi),%esi
f0100a70:	75 19                	jne    f0100a8b <monitor+0xb3>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a72:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100a79:	00 
f0100a7a:	c7 04 24 ab 70 10 f0 	movl   $0xf01070ab,(%esp)
f0100a81:	e8 eb 36 00 00       	call   f0104171 <cprintf>
f0100a86:	e9 9d 00 00 00       	jmp    f0100b28 <monitor+0x150>
			return 0;
		}
		argv[argc++] = buf;
f0100a8b:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a8e:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a92:	0f b6 03             	movzbl (%ebx),%eax
f0100a95:	84 c0                	test   %al,%al
f0100a97:	75 0c                	jne    f0100aa5 <monitor+0xcd>
f0100a99:	eb aa                	jmp    f0100a45 <monitor+0x6d>
			buf++;
f0100a9b:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a9e:	0f b6 03             	movzbl (%ebx),%eax
f0100aa1:	84 c0                	test   %al,%al
f0100aa3:	74 a0                	je     f0100a45 <monitor+0x6d>
f0100aa5:	0f be c0             	movsbl %al,%eax
f0100aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100aac:	c7 04 24 a6 70 10 f0 	movl   $0xf01070a6,(%esp)
f0100ab3:	e8 a1 54 00 00       	call   f0105f59 <strchr>
f0100ab8:	85 c0                	test   %eax,%eax
f0100aba:	74 df                	je     f0100a9b <monitor+0xc3>
f0100abc:	eb 87                	jmp    f0100a45 <monitor+0x6d>
			buf++;
	}
	argv[argc] = 0;
f0100abe:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ac5:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100ac6:	85 f6                	test   %esi,%esi
f0100ac8:	74 5e                	je     f0100b28 <monitor+0x150>
f0100aca:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100acf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ad2:	8b 04 85 00 73 10 f0 	mov    -0xfef8d00(,%eax,4),%eax
f0100ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100add:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100ae0:	89 04 24             	mov    %eax,(%esp)
f0100ae3:	e8 ed 53 00 00       	call   f0105ed5 <strcmp>
f0100ae8:	85 c0                	test   %eax,%eax
f0100aea:	75 21                	jne    f0100b0d <monitor+0x135>
			return commands[i].func(argc, argv, tf);
f0100aec:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100aef:	8b 55 08             	mov    0x8(%ebp),%edx
f0100af2:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100af6:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f0100af9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100afd:	89 34 24             	mov    %esi,(%esp)
f0100b00:	ff 14 85 08 73 10 f0 	call   *-0xfef8cf8(,%eax,4)

	__exit = 0;
	while (!__exit) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100b07:	85 c0                	test   %eax,%eax
f0100b09:	78 2a                	js     f0100b35 <monitor+0x15d>
f0100b0b:	eb 1b                	jmp    f0100b28 <monitor+0x150>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100b0d:	83 c3 01             	add    $0x1,%ebx
f0100b10:	83 fb 04             	cmp    $0x4,%ebx
f0100b13:	75 ba                	jne    f0100acf <monitor+0xf7>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100b15:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100b18:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b1c:	c7 04 24 c8 70 10 f0 	movl   $0xf01070c8,(%esp)
f0100b23:	e8 49 36 00 00       	call   f0104171 <cprintf>

	if (tf != NULL)
		print_trapframe(tf);

	__exit = 0;
	while (!__exit) {
f0100b28:	83 3d 38 32 20 f0 00 	cmpl   $0x0,0xf0203238
f0100b2f:	0f 84 e4 fe ff ff    	je     f0100a19 <monitor+0x41>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100b35:	83 c4 5c             	add    $0x5c,%esp
f0100b38:	5b                   	pop    %ebx
f0100b39:	5e                   	pop    %esi
f0100b3a:	5f                   	pop    %edi
f0100b3b:	5d                   	pop    %ebp
f0100b3c:	c3                   	ret    
f0100b3d:	66 90                	xchg   %ax,%ax
f0100b3f:	90                   	nop

f0100b40 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b40:	89 d1                	mov    %edx,%ecx
f0100b42:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b45:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b48:	a8 01                	test   $0x1,%al
f0100b4a:	74 5d                	je     f0100ba9 <check_va2pa+0x69>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100b51:	89 c1                	mov    %eax,%ecx
f0100b53:	c1 e9 0c             	shr    $0xc,%ecx
f0100b56:	3b 0d 88 3e 20 f0    	cmp    0xf0203e88,%ecx
f0100b5c:	72 26                	jb     f0100b84 <check_va2pa+0x44>
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100b5e:	55                   	push   %ebp
f0100b5f:	89 e5                	mov    %esp,%ebp
f0100b61:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b64:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b68:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0100b6f:	f0 
f0100b70:	c7 44 24 04 d2 03 00 	movl   $0x3d2,0x4(%esp)
f0100b77:	00 
f0100b78:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100b7f:	e8 bc f4 ff ff       	call   f0100040 <_panic>

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
f0100b84:	c1 ea 0c             	shr    $0xc,%edx
f0100b87:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b8d:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100b94:	89 c2                	mov    %eax,%edx
f0100b96:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b9e:	85 d2                	test   %edx,%edx
f0100ba0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100ba5:	0f 44 c2             	cmove  %edx,%eax
f0100ba8:	c3                   	ret    
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0100ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100bae:	c3                   	ret    

f0100baf <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100baf:	83 3d 3c 32 20 f0 00 	cmpl   $0x0,0xf020323c
f0100bb6:	75 11                	jne    f0100bc9 <boot_alloc+0x1a>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100bb8:	ba 07 60 24 f0       	mov    $0xf0246007,%edx
f0100bbd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100bc3:	89 15 3c 32 20 f0    	mov    %edx,0xf020323c
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100bc9:	8b 0d 3c 32 20 f0    	mov    0xf020323c,%ecx
	nextfree += ROUNDUP(n, PGSIZE);
f0100bcf:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100bd5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100bdb:	01 ca                	add    %ecx,%edx
f0100bdd:	89 15 3c 32 20 f0    	mov    %edx,0xf020323c
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100be3:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0100be9:	77 26                	ja     f0100c11 <boot_alloc+0x62>
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100beb:	55                   	push   %ebp
f0100bec:	89 e5                	mov    %esp,%ebp
f0100bee:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100bf1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100bf5:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0100bfc:	f0 
f0100bfd:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
f0100c04:	00 
f0100c05:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100c0c:	e8 2f f4 ff ff       	call   f0100040 <_panic>
	//
	// LAB 2: Your code here.
	result = nextfree;
	nextfree += ROUNDUP(n, PGSIZE);
	// if out of memory
	if (PADDR(nextfree) > npages * PGSIZE) {
f0100c11:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f0100c16:	c1 e0 0c             	shl    $0xc,%eax
	return (physaddr_t)kva - KERNBASE;
f0100c19:	81 c2 00 00 00 10    	add    $0x10000000,%edx
		return 0;
f0100c1f:	39 c2                	cmp    %eax,%edx
f0100c21:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c26:	0f 46 c1             	cmovbe %ecx,%eax
	}
	return result;
}
f0100c29:	c3                   	ret    

f0100c2a <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0100c2a:	55                   	push   %ebp
f0100c2b:	89 e5                	mov    %esp,%ebp
f0100c2d:	57                   	push   %edi
f0100c2e:	56                   	push   %esi
f0100c2f:	53                   	push   %ebx
f0100c30:	83 ec 4c             	sub    $0x4c,%esp
f0100c33:	89 45 c0             	mov    %eax,-0x40(%ebp)
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c36:	84 c0                	test   %al,%al
f0100c38:	0f 85 83 03 00 00    	jne    f0100fc1 <check_page_free_list+0x397>
f0100c3e:	e9 92 03 00 00       	jmp    f0100fd5 <check_page_free_list+0x3ab>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f0100c43:	c7 44 24 08 30 73 10 	movl   $0xf0107330,0x8(%esp)
f0100c4a:	f0 
f0100c4b:	c7 44 24 04 00 03 00 	movl   $0x300,0x4(%esp)
f0100c52:	00 
f0100c53:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100c5a:	e8 e1 f3 ff ff       	call   f0100040 <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100c5f:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100c62:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100c65:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100c68:	89 55 e4             	mov    %edx,-0x1c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c6b:	89 c2                	mov    %eax,%edx
f0100c6d:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100c73:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100c79:	0f 95 c2             	setne  %dl
f0100c7c:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100c7f:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100c83:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100c85:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c89:	8b 00                	mov    (%eax),%eax
f0100c8b:	85 c0                	test   %eax,%eax
f0100c8d:	75 dc                	jne    f0100c6b <check_page_free_list+0x41>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0100c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100c9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100c9e:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100ca0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ca3:	a3 44 32 20 f0       	mov    %eax,0xf0203244
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ca8:	89 c3                	mov    %eax,%ebx
f0100caa:	85 c0                	test   %eax,%eax
f0100cac:	74 6c                	je     f0100d1a <check_page_free_list+0xf0>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100cae:	be 01 00 00 00       	mov    $0x1,%esi
f0100cb3:	89 d8                	mov    %ebx,%eax
f0100cb5:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0100cbb:	c1 f8 03             	sar    $0x3,%eax
f0100cbe:	c1 e0 0c             	shl    $0xc,%eax
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
f0100cc1:	89 c2                	mov    %eax,%edx
f0100cc3:	c1 ea 16             	shr    $0x16,%edx
f0100cc6:	39 f2                	cmp    %esi,%edx
f0100cc8:	73 4a                	jae    f0100d14 <check_page_free_list+0xea>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100cca:	89 c2                	mov    %eax,%edx
f0100ccc:	c1 ea 0c             	shr    $0xc,%edx
f0100ccf:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f0100cd5:	72 20                	jb     f0100cf7 <check_page_free_list+0xcd>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100cdb:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0100ce2:	f0 
f0100ce3:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0100cea:	00 
f0100ceb:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0100cf2:	e8 49 f3 ff ff       	call   f0100040 <_panic>
			memset(page2kva(pp), 0x97, 128);
f0100cf7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0100cfe:	00 
f0100cff:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0100d06:	00 
	return (void *)(pa + KERNBASE);
f0100d07:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100d0c:	89 04 24             	mov    %eax,(%esp)
f0100d0f:	e8 a5 52 00 00       	call   f0105fb9 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100d14:	8b 1b                	mov    (%ebx),%ebx
f0100d16:	85 db                	test   %ebx,%ebx
f0100d18:	75 99                	jne    f0100cb3 <check_page_free_list+0x89>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0100d1a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d1f:	e8 8b fe ff ff       	call   f0100baf <boot_alloc>
f0100d24:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d27:	8b 15 44 32 20 f0    	mov    0xf0203244,%edx
f0100d2d:	85 d2                	test   %edx,%edx
f0100d2f:	0f 84 2b 02 00 00    	je     f0100f60 <check_page_free_list+0x336>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0100d35:	8b 3d 90 3e 20 f0    	mov    0xf0203e90,%edi
f0100d3b:	39 fa                	cmp    %edi,%edx
f0100d3d:	72 43                	jb     f0100d82 <check_page_free_list+0x158>
		assert(pp < pages + npages);
f0100d3f:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f0100d44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0100d47:	8d 04 c7             	lea    (%edi,%eax,8),%eax
f0100d4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0100d4d:	39 c2                	cmp    %eax,%edx
f0100d4f:	73 5a                	jae    f0100dab <check_page_free_list+0x181>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d51:	89 7d d0             	mov    %edi,-0x30(%ebp)
f0100d54:	89 d0                	mov    %edx,%eax
f0100d56:	29 f8                	sub    %edi,%eax
f0100d58:	a8 07                	test   $0x7,%al
f0100d5a:	75 7c                	jne    f0100dd8 <check_page_free_list+0x1ae>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100d5c:	c1 f8 03             	sar    $0x3,%eax
f0100d5f:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0100d62:	85 c0                	test   %eax,%eax
f0100d64:	0f 84 9c 00 00 00    	je     f0100e06 <check_page_free_list+0x1dc>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d6a:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d6f:	0f 85 e0 00 00 00    	jne    f0100e55 <check_page_free_list+0x22b>
f0100d75:	e9 b7 00 00 00       	jmp    f0100e31 <check_page_free_list+0x207>
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0100d7a:	39 d7                	cmp    %edx,%edi
f0100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100d80:	76 24                	jbe    f0100da6 <check_page_free_list+0x17c>
f0100d82:	c7 44 24 0c 67 7c 10 	movl   $0xf0107c67,0xc(%esp)
f0100d89:	f0 
f0100d8a:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100d91:	f0 
f0100d92:	c7 44 24 04 1a 03 00 	movl   $0x31a,0x4(%esp)
f0100d99:	00 
f0100d9a:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100da1:	e8 9a f2 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100da6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100da9:	72 24                	jb     f0100dcf <check_page_free_list+0x1a5>
f0100dab:	c7 44 24 0c 88 7c 10 	movl   $0xf0107c88,0xc(%esp)
f0100db2:	f0 
f0100db3:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100dba:	f0 
f0100dbb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
f0100dc2:	00 
f0100dc3:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100dca:	e8 71 f2 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100dcf:	89 d0                	mov    %edx,%eax
f0100dd1:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100dd4:	a8 07                	test   $0x7,%al
f0100dd6:	74 24                	je     f0100dfc <check_page_free_list+0x1d2>
f0100dd8:	c7 44 24 0c 54 73 10 	movl   $0xf0107354,0xc(%esp)
f0100ddf:	f0 
f0100de0:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100de7:	f0 
f0100de8:	c7 44 24 04 1c 03 00 	movl   $0x31c,0x4(%esp)
f0100def:	00 
f0100df0:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100df7:	e8 44 f2 ff ff       	call   f0100040 <_panic>
f0100dfc:	c1 f8 03             	sar    $0x3,%eax
f0100dff:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0100e02:	85 c0                	test   %eax,%eax
f0100e04:	75 24                	jne    f0100e2a <check_page_free_list+0x200>
f0100e06:	c7 44 24 0c 9c 7c 10 	movl   $0xf0107c9c,0xc(%esp)
f0100e0d:	f0 
f0100e0e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100e15:	f0 
f0100e16:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
f0100e1d:	00 
f0100e1e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100e25:	e8 16 f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100e2a:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100e2f:	75 31                	jne    f0100e62 <check_page_free_list+0x238>
f0100e31:	c7 44 24 0c ad 7c 10 	movl   $0xf0107cad,0xc(%esp)
f0100e38:	f0 
f0100e39:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100e40:	f0 
f0100e41:	c7 44 24 04 20 03 00 	movl   $0x320,0x4(%esp)
f0100e48:	00 
f0100e49:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100e50:	e8 eb f1 ff ff       	call   f0100040 <_panic>
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0100e55:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e5a:	be 00 00 00 00       	mov    $0x0,%esi
f0100e5f:	89 5d cc             	mov    %ebx,-0x34(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
		assert(page2pa(pp) != IOPHYSMEM);
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e62:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100e67:	75 24                	jne    f0100e8d <check_page_free_list+0x263>
f0100e69:	c7 44 24 0c 88 73 10 	movl   $0xf0107388,0xc(%esp)
f0100e70:	f0 
f0100e71:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100e78:	f0 
f0100e79:	c7 44 24 04 21 03 00 	movl   $0x321,0x4(%esp)
f0100e80:	00 
f0100e81:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100e88:	e8 b3 f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100e8d:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100e92:	75 24                	jne    f0100eb8 <check_page_free_list+0x28e>
f0100e94:	c7 44 24 0c c6 7c 10 	movl   $0xf0107cc6,0xc(%esp)
f0100e9b:	f0 
f0100e9c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100ea3:	f0 
f0100ea4:	c7 44 24 04 22 03 00 	movl   $0x322,0x4(%esp)
f0100eab:	00 
f0100eac:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100eb3:	e8 88 f1 ff ff       	call   f0100040 <_panic>
f0100eb8:	89 c1                	mov    %eax,%ecx
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100eba:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100ebf:	0f 86 20 01 00 00    	jbe    f0100fe5 <check_page_free_list+0x3bb>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100ec5:	89 c3                	mov    %eax,%ebx
f0100ec7:	c1 eb 0c             	shr    $0xc,%ebx
f0100eca:	39 5d c4             	cmp    %ebx,-0x3c(%ebp)
f0100ecd:	77 20                	ja     f0100eef <check_page_free_list+0x2c5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ecf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100ed3:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0100eda:	f0 
f0100edb:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0100ee2:	00 
f0100ee3:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0100eea:	e8 51 f1 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0100eef:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0100ef5:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f0100ef8:	0f 86 f7 00 00 00    	jbe    f0100ff5 <check_page_free_list+0x3cb>
f0100efe:	c7 44 24 0c ac 73 10 	movl   $0xf01073ac,0xc(%esp)
f0100f05:	f0 
f0100f06:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100f0d:	f0 
f0100f0e:	c7 44 24 04 23 03 00 	movl   $0x323,0x4(%esp)
f0100f15:	00 
f0100f16:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100f1d:	e8 1e f1 ff ff       	call   f0100040 <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100f22:	c7 44 24 0c e0 7c 10 	movl   $0xf0107ce0,0xc(%esp)
f0100f29:	f0 
f0100f2a:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100f31:	f0 
f0100f32:	c7 44 24 04 25 03 00 	movl   $0x325,0x4(%esp)
f0100f39:	00 
f0100f3a:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100f41:	e8 fa f0 ff ff       	call   f0100040 <_panic>

		if (page2pa(pp) < EXTPHYSMEM) {
			++nfree_basemem;
f0100f46:	83 c6 01             	add    $0x1,%esi
f0100f49:	eb 04                	jmp    f0100f4f <check_page_free_list+0x325>
		} else {
			++nfree_extmem;
f0100f4b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f4f:	8b 12                	mov    (%edx),%edx
f0100f51:	85 d2                	test   %edx,%edx
f0100f53:	0f 85 21 fe ff ff    	jne    f0100d7a <check_page_free_list+0x150>
f0100f59:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		} else {
			++nfree_extmem;
		}
	}

	assert(nfree_basemem > 0);
f0100f5c:	85 f6                	test   %esi,%esi
f0100f5e:	7f 24                	jg     f0100f84 <check_page_free_list+0x35a>
f0100f60:	c7 44 24 0c fd 7c 10 	movl   $0xf0107cfd,0xc(%esp)
f0100f67:	f0 
f0100f68:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100f6f:	f0 
f0100f70:	c7 44 24 04 2e 03 00 	movl   $0x32e,0x4(%esp)
f0100f77:	00 
f0100f78:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100f7f:	e8 bc f0 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100f84:	85 db                	test   %ebx,%ebx
f0100f86:	7f 24                	jg     f0100fac <check_page_free_list+0x382>
f0100f88:	c7 44 24 0c 0f 7d 10 	movl   $0xf0107d0f,0xc(%esp)
f0100f8f:	f0 
f0100f90:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0100f97:	f0 
f0100f98:	c7 44 24 04 2f 03 00 	movl   $0x32f,0x4(%esp)
f0100f9f:	00 
f0100fa0:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0100fa7:	e8 94 f0 ff ff       	call   f0100040 <_panic>
	cprintf("check_page_free_list(%d) ok\n", only_low_memory);
f0100fac:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100faf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100fb3:	c7 04 24 20 7d 10 f0 	movl   $0xf0107d20,(%esp)
f0100fba:	e8 b2 31 00 00       	call   f0104171 <cprintf>
f0100fbf:	eb 54                	jmp    f0101015 <check_page_free_list+0x3eb>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0100fc1:	a1 44 32 20 f0       	mov    0xf0203244,%eax
f0100fc6:	85 c0                	test   %eax,%eax
f0100fc8:	0f 85 91 fc ff ff    	jne    f0100c5f <check_page_free_list+0x35>
f0100fce:	66 90                	xchg   %ax,%ax
f0100fd0:	e9 6e fc ff ff       	jmp    f0100c43 <check_page_free_list+0x19>
f0100fd5:	83 3d 44 32 20 f0 00 	cmpl   $0x0,0xf0203244
f0100fdc:	75 27                	jne    f0101005 <check_page_free_list+0x3db>
f0100fde:	66 90                	xchg   %ax,%ax
f0100fe0:	e9 5e fc ff ff       	jmp    f0100c43 <check_page_free_list+0x19>
		assert(page2pa(pp) != IOPHYSMEM);
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100fe5:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100fea:	0f 85 56 ff ff ff    	jne    f0100f46 <check_page_free_list+0x31c>
f0100ff0:	e9 2d ff ff ff       	jmp    f0100f22 <check_page_free_list+0x2f8>
f0100ff5:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100ffa:	0f 85 4b ff ff ff    	jne    f0100f4b <check_page_free_list+0x321>
f0101000:	e9 1d ff ff ff       	jmp    f0100f22 <check_page_free_list+0x2f8>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101005:	8b 1d 44 32 20 f0    	mov    0xf0203244,%ebx
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010100b:	be 00 04 00 00       	mov    $0x400,%esi
f0101010:	e9 9e fc ff ff       	jmp    f0100cb3 <check_page_free_list+0x89>
	}

	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);
	cprintf("check_page_free_list(%d) ok\n", only_low_memory);
}
f0101015:	83 c4 4c             	add    $0x4c,%esp
f0101018:	5b                   	pop    %ebx
f0101019:	5e                   	pop    %esi
f010101a:	5f                   	pop    %edi
f010101b:	5d                   	pop    %ebp
f010101c:	c3                   	ret    

f010101d <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f010101d:	55                   	push   %ebp
f010101e:	89 e5                	mov    %esp,%ebp
f0101020:	57                   	push   %edi
f0101021:	56                   	push   %esi
f0101022:	53                   	push   %ebx
f0101023:	83 ec 2c             	sub    $0x2c,%esp
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	// initially mark all are used
	for (i = 0; i < npages; ++i) {
f0101026:	8b 15 88 3e 20 f0    	mov    0xf0203e88,%edx
f010102c:	85 d2                	test   %edx,%edx
f010102e:	74 27                	je     f0101057 <page_init+0x3a>
f0101030:	b8 00 00 00 00       	mov    $0x0,%eax
		pages[i].pp_ref = 1;
f0101035:	8b 15 90 3e 20 f0    	mov    0xf0203e90,%edx
f010103b:	8d 14 c2             	lea    (%edx,%eax,8),%edx
f010103e:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
		pages[i].pp_link = 0;
f0101044:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;
	// initially mark all are used
	for (i = 0; i < npages; ++i) {
f010104a:	83 c0 01             	add    $0x1,%eax
f010104d:	8b 15 88 3e 20 f0    	mov    0xf0203e88,%edx
f0101053:	39 c2                	cmp    %eax,%edx
f0101055:	77 de                	ja     f0101035 <page_init+0x18>
		pages[i].pp_ref = 1;
		pages[i].pp_link = 0;
	}

	cprintf("npages = %d, npages_basemem = %d\n", npages, npages_basemem);
f0101057:	a1 48 32 20 f0       	mov    0xf0203248,%eax
f010105c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101060:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101064:	c7 04 24 f4 73 10 f0 	movl   $0xf01073f4,(%esp)
f010106b:	e8 01 31 00 00       	call   f0104171 <cprintf>
	// 2)
	// !!! physical page 0 is in used !!!
	// base memory is 640k => npages_basemen * PGSIZE = 640k
	// [PGSIZE, npages_basemen * PGSIZE) are free
	extern unsigned char mpentry_start[], mpentry_end[];
	uint32_t mpcode_sz = ROUNDUP(mpentry_end - mpentry_start, PGSIZE);
f0101070:	b8 65 72 10 f0       	mov    $0xf0107265,%eax
f0101075:	2d ec 61 10 f0       	sub    $0xf01061ec,%eax
	size_t mp_code_beg = MPENTRY_PADDR / PGSIZE;
	size_t mp_code_end = mp_code_beg + mpcode_sz / PGSIZE;
f010107a:	c1 e8 0c             	shr    $0xc,%eax
f010107d:	83 c0 07             	add    $0x7,%eax
f0101080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("mp_code_beg = %d, mp_code_end = %d\n", mp_code_beg, mp_code_end);
f0101083:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101087:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
f010108e:	00 
f010108f:	c7 04 24 18 74 10 f0 	movl   $0xf0107418,(%esp)
f0101096:	e8 d6 30 00 00       	call   f0104171 <cprintf>
	page_free_list = 0;
f010109b:	c7 05 44 32 20 f0 00 	movl   $0x0,0xf0203244
f01010a2:	00 00 00 
	struct PageInfo *prev = 0;
	for (i = 1; i < npages_basemem; ++i) {
f01010a5:	83 3d 48 32 20 f0 01 	cmpl   $0x1,0xf0203248
f01010ac:	0f 86 8d 00 00 00    	jbe    f010113f <page_init+0x122>
f01010b2:	be 00 00 00 00       	mov    $0x0,%esi
	uint32_t mpcode_sz = ROUNDUP(mpentry_end - mpentry_start, PGSIZE);
	size_t mp_code_beg = MPENTRY_PADDR / PGSIZE;
	size_t mp_code_end = mp_code_beg + mpcode_sz / PGSIZE;
	cprintf("mp_code_beg = %d, mp_code_end = %d\n", mp_code_beg, mp_code_end);
	page_free_list = 0;
	struct PageInfo *prev = 0;
f01010b7:	bf 00 00 00 00       	mov    $0x0,%edi
	for (i = 1; i < npages_basemem; ++i) {
f01010bc:	bb 01 00 00 00       	mov    $0x1,%ebx
		if (i >= mp_code_beg && i < mp_code_end) {
f01010c1:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01010c4:	73 17                	jae    f01010dd <page_init+0xc0>
f01010c6:	83 fb 06             	cmp    $0x6,%ebx
f01010c9:	76 12                	jbe    f01010dd <page_init+0xc0>
			cprintf("Skipp %d\n", i);
f01010cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01010cf:	c7 04 24 3d 7d 10 f0 	movl   $0xf0107d3d,(%esp)
f01010d6:	e8 96 30 00 00       	call   f0104171 <cprintf>
			continue;	
f01010db:	eb 52                	jmp    f010112f <page_init+0x112>
f01010dd:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
		}

		pages[i].pp_ref = 0;
f01010e4:	8b 15 90 3e 20 f0    	mov    0xf0203e90,%edx
f01010ea:	66 c7 44 02 04 00 00 	movw   $0x0,0x4(%edx,%eax,1)
		pages[i].pp_link = 0;
f01010f1:	c7 04 da 00 00 00 00 	movl   $0x0,(%edx,%ebx,8)
		if (!page_free_list) {
f01010f8:	83 3d 44 32 20 f0 00 	cmpl   $0x0,0xf0203244
f01010ff:	75 10                	jne    f0101111 <page_init+0xf4>
			page_free_list = &pages[i];
f0101101:	89 c2                	mov    %eax,%edx
f0101103:	03 15 90 3e 20 f0    	add    0xf0203e90,%edx
f0101109:	89 15 44 32 20 f0    	mov    %edx,0xf0203244
f010110f:	eb 16                	jmp    f0101127 <page_init+0x10a>
		} else {
			prev->pp_link = &pages[i];
f0101111:	89 c2                	mov    %eax,%edx
f0101113:	03 15 90 3e 20 f0    	add    0xf0203e90,%edx
f0101119:	89 17                	mov    %edx,(%edi)
			pages[i-1].pp_link = &pages[i];
f010111b:	8b 15 90 3e 20 f0    	mov    0xf0203e90,%edx
f0101121:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
f0101124:	89 0c 32             	mov    %ecx,(%edx,%esi,1)
		}
		prev = &pages[i];
f0101127:	03 05 90 3e 20 f0    	add    0xf0203e90,%eax
f010112d:	89 c7                	mov    %eax,%edi
	size_t mp_code_beg = MPENTRY_PADDR / PGSIZE;
	size_t mp_code_end = mp_code_beg + mpcode_sz / PGSIZE;
	cprintf("mp_code_beg = %d, mp_code_end = %d\n", mp_code_beg, mp_code_end);
	page_free_list = 0;
	struct PageInfo *prev = 0;
	for (i = 1; i < npages_basemem; ++i) {
f010112f:	83 c3 01             	add    $0x1,%ebx
f0101132:	83 c6 08             	add    $0x8,%esi
f0101135:	39 1d 48 32 20 f0    	cmp    %ebx,0xf0203248
f010113b:	77 84                	ja     f01010c1 <page_init+0xa4>
f010113d:	eb 05                	jmp    f0101144 <page_init+0x127>
f010113f:	bb 01 00 00 00       	mov    $0x1,%ebx
		}
		prev = &pages[i];
	}

	// 3) mark other free pages
	struct PageInfo *tail = &pages[i-1];
f0101144:	a1 90 3e 20 f0       	mov    0xf0203e90,%eax
f0101149:	8d 5c d8 f8          	lea    -0x8(%eax,%ebx,8),%ebx
	// boot_alloc(0) return the start address of the free block
	cprintf("Oops = %d\n", ROUNDUP(PADDR(boot_alloc(0)), PGSIZE) / PGSIZE);
f010114d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101152:	e8 58 fa ff ff       	call   f0100baf <boot_alloc>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101157:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010115c:	77 20                	ja     f010117e <page_init+0x161>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010115e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101162:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0101169:	f0 
f010116a:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
f0101171:	00 
f0101172:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101179:	e8 c2 ee ff ff       	call   f0100040 <_panic>
f010117e:	05 ff 0f 00 10       	add    $0x10000fff,%eax
f0101183:	c1 e8 0c             	shr    $0xc,%eax
f0101186:	89 44 24 04          	mov    %eax,0x4(%esp)
f010118a:	c7 04 24 47 7d 10 f0 	movl   $0xf0107d47,(%esp)
f0101191:	e8 db 2f 00 00       	call   f0104171 <cprintf>
	for (i = ROUNDUP(PADDR(boot_alloc(0)), PGSIZE) / PGSIZE; i < npages; ++i) {
f0101196:	b8 00 00 00 00       	mov    $0x0,%eax
f010119b:	e8 0f fa ff ff       	call   f0100baf <boot_alloc>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01011a0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01011a5:	77 20                	ja     f01011c7 <page_init+0x1aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01011a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01011ab:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f01011b2:	f0 
f01011b3:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
f01011ba:	00 
f01011bb:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01011c2:	e8 79 ee ff ff       	call   f0100040 <_panic>
f01011c7:	05 ff 0f 00 10       	add    $0x10000fff,%eax
f01011cc:	c1 e8 0c             	shr    $0xc,%eax
f01011cf:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f01011d5:	73 3b                	jae    f0101212 <page_init+0x1f5>
f01011d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f01011de:	89 d1                	mov    %edx,%ecx
f01011e0:	03 0d 90 3e 20 f0    	add    0xf0203e90,%ecx
f01011e6:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = 0;
f01011ec:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
		tail->pp_link = &pages[i];
f01011f2:	89 d1                	mov    %edx,%ecx
f01011f4:	03 0d 90 3e 20 f0    	add    0xf0203e90,%ecx
f01011fa:	89 0b                	mov    %ecx,(%ebx)
		tail = &pages[i];
f01011fc:	89 d3                	mov    %edx,%ebx
f01011fe:	03 1d 90 3e 20 f0    	add    0xf0203e90,%ebx

	// 3) mark other free pages
	struct PageInfo *tail = &pages[i-1];
	// boot_alloc(0) return the start address of the free block
	cprintf("Oops = %d\n", ROUNDUP(PADDR(boot_alloc(0)), PGSIZE) / PGSIZE);
	for (i = ROUNDUP(PADDR(boot_alloc(0)), PGSIZE) / PGSIZE; i < npages; ++i) {
f0101204:	83 c0 01             	add    $0x1,%eax
f0101207:	83 c2 08             	add    $0x8,%edx
f010120a:	39 05 88 3e 20 f0    	cmp    %eax,0xf0203e88
f0101210:	77 cc                	ja     f01011de <page_init+0x1c1>
		pages[i].pp_ref = 0;
		pages[i].pp_link = 0;
		tail->pp_link = &pages[i];
		tail = &pages[i];
	}
	cprintf("EXTPHYSMEM = %x\n", EXTPHYSMEM);
f0101212:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
f0101219:	00 
f010121a:	c7 04 24 52 7d 10 f0 	movl   $0xf0107d52,(%esp)
f0101221:	e8 4b 2f 00 00       	call   f0104171 <cprintf>
	// cprintf("Debug info of pages....\n");
	// cprintf("&pages[0] = %x\n", &pages[0]);
	// cprintf("&pages[npages-1] = %x\n", &pages[npages-1]);
}
f0101226:	83 c4 2c             	add    $0x2c,%esp
f0101229:	5b                   	pop    %ebx
f010122a:	5e                   	pop    %esi
f010122b:	5f                   	pop    %edi
f010122c:	5d                   	pop    %ebp
f010122d:	c3                   	ret    

f010122e <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f010122e:	55                   	push   %ebp
f010122f:	89 e5                	mov    %esp,%ebp
f0101231:	53                   	push   %ebx
f0101232:	83 ec 14             	sub    $0x14,%esp
	if (!page_free_list) {
f0101235:	8b 1d 44 32 20 f0    	mov    0xf0203244,%ebx
f010123b:	85 db                	test   %ebx,%ebx
f010123d:	74 69                	je     f01012a8 <page_alloc+0x7a>
		return NULL;
	}

	struct PageInfo *ret = page_free_list;
	page_free_list = ret->pp_link;
f010123f:	8b 03                	mov    (%ebx),%eax
f0101241:	a3 44 32 20 f0       	mov    %eax,0xf0203244

	if (alloc_flags && ALLOC_ZERO) {
		memset(page2kva(ret), 0, PGSIZE);
	}
	return ret;
f0101246:	89 d8                	mov    %ebx,%eax
	}

	struct PageInfo *ret = page_free_list;
	page_free_list = ret->pp_link;

	if (alloc_flags && ALLOC_ZERO) {
f0101248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010124c:	74 5f                	je     f01012ad <page_alloc+0x7f>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010124e:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0101254:	c1 f8 03             	sar    $0x3,%eax
f0101257:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010125a:	89 c2                	mov    %eax,%edx
f010125c:	c1 ea 0c             	shr    $0xc,%edx
f010125f:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f0101265:	72 20                	jb     f0101287 <page_alloc+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101267:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010126b:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0101272:	f0 
f0101273:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f010127a:	00 
f010127b:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0101282:	e8 b9 ed ff ff       	call   f0100040 <_panic>
		memset(page2kva(ret), 0, PGSIZE);
f0101287:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010128e:	00 
f010128f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101296:	00 
	return (void *)(pa + KERNBASE);
f0101297:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010129c:	89 04 24             	mov    %eax,(%esp)
f010129f:	e8 15 4d 00 00       	call   f0105fb9 <memset>
	}
	return ret;
f01012a4:	89 d8                	mov    %ebx,%eax
f01012a6:	eb 05                	jmp    f01012ad <page_alloc+0x7f>
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
	if (!page_free_list) {
		return NULL;
f01012a8:	b8 00 00 00 00       	mov    $0x0,%eax

	if (alloc_flags && ALLOC_ZERO) {
		memset(page2kva(ret), 0, PGSIZE);
	}
	return ret;
}
f01012ad:	83 c4 14             	add    $0x14,%esp
f01012b0:	5b                   	pop    %ebx
f01012b1:	5d                   	pop    %ebp
f01012b2:	c3                   	ret    

f01012b3 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f01012b3:	55                   	push   %ebp
f01012b4:	89 e5                	mov    %esp,%ebp
f01012b6:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp && !pp->pp_ref) {
f01012b9:	85 c0                	test   %eax,%eax
f01012bb:	74 14                	je     f01012d1 <page_free+0x1e>
f01012bd:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01012c2:	75 0d                	jne    f01012d1 <page_free+0x1e>
		pp->pp_link = page_free_list;
f01012c4:	8b 15 44 32 20 f0    	mov    0xf0203244,%edx
f01012ca:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f01012cc:	a3 44 32 20 f0       	mov    %eax,0xf0203244
	}
}
f01012d1:	5d                   	pop    %ebp
f01012d2:	c3                   	ret    

f01012d3 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f01012d3:	55                   	push   %ebp
f01012d4:	89 e5                	mov    %esp,%ebp
f01012d6:	83 ec 04             	sub    $0x4,%esp
f01012d9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f01012dc:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f01012e0:	8d 51 ff             	lea    -0x1(%ecx),%edx
f01012e3:	66 89 50 04          	mov    %dx,0x4(%eax)
f01012e7:	66 85 d2             	test   %dx,%dx
f01012ea:	75 08                	jne    f01012f4 <page_decref+0x21>
		page_free(pp);
f01012ec:	89 04 24             	mov    %eax,(%esp)
f01012ef:	e8 bf ff ff ff       	call   f01012b3 <page_free>
}
f01012f4:	c9                   	leave  
f01012f5:	c3                   	ret    

f01012f6 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01012f6:	55                   	push   %ebp
f01012f7:	89 e5                	mov    %esp,%ebp
f01012f9:	57                   	push   %edi
f01012fa:	56                   	push   %esi
f01012fb:	53                   	push   %ebx
f01012fc:	83 ec 1c             	sub    $0x1c,%esp
	pde_t *pde;
	pte_t *pgtab;

	// pde stores a pointer to the page directory entry
	// so *pde is the content of the entry
	pde = &pgdir[PDX(va)];
f01012ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101302:	c1 eb 16             	shr    $0x16,%ebx
f0101305:	c1 e3 02             	shl    $0x2,%ebx
f0101308:	03 5d 08             	add    0x8(%ebp),%ebx
	if (*pde & PTE_P) {
f010130b:	8b 3b                	mov    (%ebx),%edi
f010130d:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0101313:	74 3e                	je     f0101353 <pgdir_walk+0x5d>
		// PTE_ADDR(*pde) extract the upper 20 bits in the page dir entry,
		// it is a physical address of the page table.
		// Since kernel manipulate virtual address, we have to change the
		// physical address to the virtual address KADDR(PTE_ADDR(*pde))
		pgtab = (pte_t*)KADDR(PTE_ADDR(*pde));
f0101315:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010131b:	89 f8                	mov    %edi,%eax
f010131d:	c1 e8 0c             	shr    $0xc,%eax
f0101320:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0101326:	72 20                	jb     f0101348 <pgdir_walk+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101328:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010132c:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0101333:	f0 
f0101334:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
f010133b:	00 
f010133c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101343:	e8 f8 ec ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0101348:	81 ef 00 00 00 10    	sub    $0x10000000,%edi
f010134e:	e9 8f 00 00 00       	jmp    f01013e2 <pgdir_walk+0xec>
	} else {
		// if create = false or page_alloc false, return NULL
		struct PageInfo *page;
		if (!create || !(page = page_alloc(PGSIZE))) {
f0101353:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101357:	0f 84 94 00 00 00    	je     f01013f1 <pgdir_walk+0xfb>
f010135d:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
f0101364:	e8 c5 fe ff ff       	call   f010122e <page_alloc>
f0101369:	89 c6                	mov    %eax,%esi
f010136b:	85 c0                	test   %eax,%eax
f010136d:	0f 84 85 00 00 00    	je     f01013f8 <pgdir_walk+0x102>
			return 0;
		}
		page->pp_ref++;
f0101373:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101378:	89 c7                	mov    %eax,%edi
f010137a:	2b 3d 90 3e 20 f0    	sub    0xf0203e90,%edi
f0101380:	c1 ff 03             	sar    $0x3,%edi
f0101383:	c1 e7 0c             	shl    $0xc,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101386:	89 f8                	mov    %edi,%eax
f0101388:	c1 e8 0c             	shr    $0xc,%eax
f010138b:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0101391:	72 20                	jb     f01013b3 <pgdir_walk+0xbd>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101393:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0101397:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010139e:	f0 
f010139f:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01013a6:	00 
f01013a7:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f01013ae:	e8 8d ec ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01013b3:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

		pgtab = (pte_t*)page2kva(page); // get the actual page virtual address
		memset(pgtab, 0, PGSIZE);
f01013b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01013c0:	00 
f01013c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01013c8:	00 
f01013c9:	89 3c 24             	mov    %edi,(%esp)
f01013cc:	e8 e8 4b 00 00       	call   f0105fb9 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01013d1:	2b 35 90 3e 20 f0    	sub    0xf0203e90,%esi
f01013d7:	c1 fe 03             	sar    $0x3,%esi
f01013da:	c1 e6 0c             	shl    $0xc,%esi
		// the page dir entry contains a 20 bit physical address of a page table
		// it points to as well as the permission bits
		// The permissions here are more permissive,
		// it can be further restricted by the permission in the page table
		// entries, if necessary
		*pde = page2pa(page) | PTE_P | PTE_W | PTE_U;
f01013dd:	83 ce 07             	or     $0x7,%esi
f01013e0:	89 33                	mov    %esi,(%ebx)
	}
	return &pgtab[PTX(va)]; // return the virtual address of page table entry
f01013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01013e5:	c1 e8 0a             	shr    $0xa,%eax
f01013e8:	25 fc 0f 00 00       	and    $0xffc,%eax
f01013ed:	01 f8                	add    %edi,%eax
f01013ef:	eb 0c                	jmp    f01013fd <pgdir_walk+0x107>
		pgtab = (pte_t*)KADDR(PTE_ADDR(*pde));
	} else {
		// if create = false or page_alloc false, return NULL
		struct PageInfo *page;
		if (!create || !(page = page_alloc(PGSIZE))) {
			return 0;
f01013f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01013f6:	eb 05                	jmp    f01013fd <pgdir_walk+0x107>
f01013f8:	b8 00 00 00 00       	mov    $0x0,%eax
		// it can be further restricted by the permission in the page table
		// entries, if necessary
		*pde = page2pa(page) | PTE_P | PTE_W | PTE_U;
	}
	return &pgtab[PTX(va)]; // return the virtual address of page table entry
}
f01013fd:	83 c4 1c             	add    $0x1c,%esp
f0101400:	5b                   	pop    %ebx
f0101401:	5e                   	pop    %esi
f0101402:	5f                   	pop    %edi
f0101403:	5d                   	pop    %ebp
f0101404:	c3                   	ret    

f0101405 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f0101405:	55                   	push   %ebp
f0101406:	89 e5                	mov    %esp,%ebp
f0101408:	57                   	push   %edi
f0101409:	56                   	push   %esi
f010140a:	53                   	push   %ebx
f010140b:	83 ec 2c             	sub    $0x2c,%esp
f010140e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte_t *pte;
	uintptr_t va_beg = ROUNDDOWN(va, PGSIZE);
f0101411:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	uintptr_t pa_beg = ROUNDDOWN(pa, PGSIZE);
f0101417:	8b 45 08             	mov    0x8(%ebp),%eax
f010141a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	size = ROUNDUP(size, PGSIZE);
f010141f:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi
	while (size) {
f0101425:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f010142b:	0f 84 81 00 00 00    	je     f01014b2 <boot_map_region+0xad>
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	pte_t *pte;
	uintptr_t va_beg = ROUNDDOWN(va, PGSIZE);
f0101431:	89 d3                	mov    %edx,%ebx
f0101433:	29 d0                	sub    %edx,%eax
f0101435:	89 45 e0             	mov    %eax,-0x20(%ebp)
			panic("cannot get page table entry in boot_map_region");
		}
		if (*pte & PTE_P) {
			panic("remap in boot_map_region");
		}
		*pte = pa_beg | perm | PTE_P;
f0101438:	8b 45 0c             	mov    0xc(%ebp),%eax
f010143b:	83 c8 01             	or     $0x1,%eax
f010143e:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101441:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101444:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
	pte_t *pte;
	uintptr_t va_beg = ROUNDDOWN(va, PGSIZE);
	uintptr_t pa_beg = ROUNDDOWN(pa, PGSIZE);
	size = ROUNDUP(size, PGSIZE);
	while (size) {
		if (!(pte = pgdir_walk(pgdir, (const void*)va_beg, 1))) {
f0101447:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010144e:	00 
f010144f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101456:	89 04 24             	mov    %eax,(%esp)
f0101459:	e8 98 fe ff ff       	call   f01012f6 <pgdir_walk>
f010145e:	85 c0                	test   %eax,%eax
f0101460:	75 1c                	jne    f010147e <boot_map_region+0x79>
			panic("cannot get page table entry in boot_map_region");
f0101462:	c7 44 24 08 3c 74 10 	movl   $0xf010743c,0x8(%esp)
f0101469:	f0 
f010146a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
f0101471:	00 
f0101472:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101479:	e8 c2 eb ff ff       	call   f0100040 <_panic>
		}
		if (*pte & PTE_P) {
f010147e:	f6 00 01             	testb  $0x1,(%eax)
f0101481:	74 1c                	je     f010149f <boot_map_region+0x9a>
			panic("remap in boot_map_region");
f0101483:	c7 44 24 08 63 7d 10 	movl   $0xf0107d63,0x8(%esp)
f010148a:	f0 
f010148b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
f0101492:	00 
f0101493:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010149a:	e8 a1 eb ff ff       	call   f0100040 <_panic>
		}
		*pte = pa_beg | perm | PTE_P;
f010149f:	0b 7d dc             	or     -0x24(%ebp),%edi
f01014a2:	89 38                	mov    %edi,(%eax)
		va_beg += PGSIZE;
f01014a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
{
	pte_t *pte;
	uintptr_t va_beg = ROUNDDOWN(va, PGSIZE);
	uintptr_t pa_beg = ROUNDDOWN(pa, PGSIZE);
	size = ROUNDUP(size, PGSIZE);
	while (size) {
f01014aa:	81 ee 00 10 00 00    	sub    $0x1000,%esi
f01014b0:	75 8f                	jne    f0101441 <boot_map_region+0x3c>
		*pte = pa_beg | perm | PTE_P;
		va_beg += PGSIZE;
		pa_beg += PGSIZE;
		size -= PGSIZE;
	}
}
f01014b2:	83 c4 2c             	add    $0x2c,%esp
f01014b5:	5b                   	pop    %ebx
f01014b6:	5e                   	pop    %esi
f01014b7:	5f                   	pop    %edi
f01014b8:	5d                   	pop    %ebp
f01014b9:	c3                   	ret    

f01014ba <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01014ba:	55                   	push   %ebp
f01014bb:	89 e5                	mov    %esp,%ebp
f01014bd:	53                   	push   %ebx
f01014be:	83 ec 14             	sub    $0x14,%esp
f01014c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte;
	struct PageInfo* ret = NULL;
	pte = pgdir_walk(pgdir, va, 0);
f01014c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01014cb:	00 
f01014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014d3:	8b 45 08             	mov    0x8(%ebp),%eax
f01014d6:	89 04 24             	mov    %eax,(%esp)
f01014d9:	e8 18 fe ff ff       	call   f01012f6 <pgdir_walk>
f01014de:	89 c2                	mov    %eax,%edx
	if (pte && (*pte & PTE_P)) {
f01014e0:	85 c0                	test   %eax,%eax
f01014e2:	74 1a                	je     f01014fe <page_lookup+0x44>
f01014e4:	8b 00                	mov    (%eax),%eax
f01014e6:	a8 01                	test   $0x1,%al
f01014e8:	74 1b                	je     f0101505 <page_lookup+0x4b>
		ret = pages + (PTE_ADDR(*pte) >> PTXSHIFT);
f01014ea:	c1 e8 0c             	shr    $0xc,%eax
f01014ed:	8b 0d 90 3e 20 f0    	mov    0xf0203e90,%ecx
f01014f3:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
		if (pte_store) {
f01014f6:	85 db                	test   %ebx,%ebx
f01014f8:	74 10                	je     f010150a <page_lookup+0x50>
			*pte_store = pte;
f01014fa:	89 13                	mov    %edx,(%ebx)
f01014fc:	eb 0c                	jmp    f010150a <page_lookup+0x50>
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	pte_t *pte;
	struct PageInfo* ret = NULL;
f01014fe:	b8 00 00 00 00       	mov    $0x0,%eax
f0101503:	eb 05                	jmp    f010150a <page_lookup+0x50>
f0101505:	b8 00 00 00 00       	mov    $0x0,%eax
		if (pte_store) {
			*pte_store = pte;
		}
	}
	return ret;
}
f010150a:	83 c4 14             	add    $0x14,%esp
f010150d:	5b                   	pop    %ebx
f010150e:	5d                   	pop    %ebp
f010150f:	c3                   	ret    

f0101510 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101510:	55                   	push   %ebp
f0101511:	89 e5                	mov    %esp,%ebp
f0101513:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101516:	e8 38 51 00 00       	call   f0106653 <cpunum>
f010151b:	6b c0 74             	imul   $0x74,%eax,%eax
f010151e:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f0101525:	74 16                	je     f010153d <tlb_invalidate+0x2d>
f0101527:	e8 27 51 00 00       	call   f0106653 <cpunum>
f010152c:	6b c0 74             	imul   $0x74,%eax,%eax
f010152f:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0101535:	8b 55 08             	mov    0x8(%ebp),%edx
f0101538:	39 50 60             	cmp    %edx,0x60(%eax)
f010153b:	75 06                	jne    f0101543 <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010153d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101540:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0101543:	c9                   	leave  
f0101544:	c3                   	ret    

f0101545 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101545:	55                   	push   %ebp
f0101546:	89 e5                	mov    %esp,%ebp
f0101548:	56                   	push   %esi
f0101549:	53                   	push   %ebx
f010154a:	83 ec 20             	sub    $0x20,%esp
f010154d:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101550:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t *pte;
	struct PageInfo *page = 0;
	if (!(page = page_lookup(pgdir, va, &pte))) {
f0101553:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101556:	89 44 24 08          	mov    %eax,0x8(%esp)
f010155a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010155e:	89 1c 24             	mov    %ebx,(%esp)
f0101561:	e8 54 ff ff ff       	call   f01014ba <page_lookup>
f0101566:	85 c0                	test   %eax,%eax
f0101568:	74 1d                	je     f0101587 <page_remove+0x42>
		return;
	}
	page_decref(page);
f010156a:	89 04 24             	mov    %eax,(%esp)
f010156d:	e8 61 fd ff ff       	call   f01012d3 <page_decref>
	*pte = 0;
f0101572:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101575:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f010157b:	89 74 24 04          	mov    %esi,0x4(%esp)
f010157f:	89 1c 24             	mov    %ebx,(%esp)
f0101582:	e8 89 ff ff ff       	call   f0101510 <tlb_invalidate>
}
f0101587:	83 c4 20             	add    $0x20,%esp
f010158a:	5b                   	pop    %ebx
f010158b:	5e                   	pop    %esi
f010158c:	5d                   	pop    %ebp
f010158d:	c3                   	ret    

f010158e <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f010158e:	55                   	push   %ebp
f010158f:	89 e5                	mov    %esp,%ebp
f0101591:	57                   	push   %edi
f0101592:	56                   	push   %esi
f0101593:	53                   	push   %ebx
f0101594:	83 ec 1c             	sub    $0x1c,%esp
f0101597:	8b 75 0c             	mov    0xc(%ebp),%esi
f010159a:	8b 7d 10             	mov    0x10(%ebp),%edi
	pte_t *pte;
	if (!(pte = pgdir_walk(pgdir, va, 1))) {
f010159d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01015a4:	00 
f01015a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01015ac:	89 04 24             	mov    %eax,(%esp)
f01015af:	e8 42 fd ff ff       	call   f01012f6 <pgdir_walk>
f01015b4:	89 c3                	mov    %eax,%ebx
f01015b6:	85 c0                	test   %eax,%eax
f01015b8:	0f 84 85 00 00 00    	je     f0101643 <page_insert+0xb5>
		return -E_NO_MEM;
	}

	if (*pte & PTE_P) {
f01015be:	8b 00                	mov    (%eax),%eax
f01015c0:	a8 01                	test   $0x1,%al
f01015c2:	74 5b                	je     f010161f <page_insert+0x91>
		// when va remap to the same physical page
		if (PTE_ADDR(*pte) == page2pa(pp)) {
f01015c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01015c9:	89 f2                	mov    %esi,%edx
f01015cb:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f01015d1:	c1 fa 03             	sar    $0x3,%edx
f01015d4:	c1 e2 0c             	shl    $0xc,%edx
f01015d7:	39 d0                	cmp    %edx,%eax
f01015d9:	75 11                	jne    f01015ec <page_insert+0x5e>
			*pte = page2pa(pp) | perm | PTE_P;
f01015db:	8b 55 14             	mov    0x14(%ebp),%edx
f01015de:	83 ca 01             	or     $0x1,%edx
f01015e1:	09 d0                	or     %edx,%eax
f01015e3:	89 03                	mov    %eax,(%ebx)
		} else {
			page_remove(pgdir, va);
			*pte = page2pa(pp) | perm | PTE_P;
			pp->pp_ref++;
		}
		return 0;
f01015e5:	b8 00 00 00 00       	mov    $0x0,%eax
f01015ea:	eb 5c                	jmp    f0101648 <page_insert+0xba>
	if (*pte & PTE_P) {
		// when va remap to the same physical page
		if (PTE_ADDR(*pte) == page2pa(pp)) {
			*pte = page2pa(pp) | perm | PTE_P;
		} else {
			page_remove(pgdir, va);
f01015ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01015f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01015f3:	89 04 24             	mov    %eax,(%esp)
f01015f6:	e8 4a ff ff ff       	call   f0101545 <page_remove>
			*pte = page2pa(pp) | perm | PTE_P;
f01015fb:	8b 55 14             	mov    0x14(%ebp),%edx
f01015fe:	83 ca 01             	or     $0x1,%edx
f0101601:	89 f0                	mov    %esi,%eax
f0101603:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0101609:	c1 f8 03             	sar    $0x3,%eax
f010160c:	c1 e0 0c             	shl    $0xc,%eax
f010160f:	09 d0                	or     %edx,%eax
f0101611:	89 03                	mov    %eax,(%ebx)
			pp->pp_ref++;
f0101613:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
		}
		return 0;
f0101618:	b8 00 00 00 00       	mov    $0x0,%eax
f010161d:	eb 29                	jmp    f0101648 <page_insert+0xba>
	} else {
		*pte = page2pa(pp) | perm | PTE_P;
f010161f:	8b 55 14             	mov    0x14(%ebp),%edx
f0101622:	83 ca 01             	or     $0x1,%edx
f0101625:	89 f0                	mov    %esi,%eax
f0101627:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f010162d:	c1 f8 03             	sar    $0x3,%eax
f0101630:	c1 e0 0c             	shl    $0xc,%eax
f0101633:	09 d0                	or     %edx,%eax
f0101635:	89 03                	mov    %eax,(%ebx)
		pp->pp_ref++;
f0101637:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	}
	return 0;
f010163c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101641:	eb 05                	jmp    f0101648 <page_insert+0xba>
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	pte_t *pte;
	if (!(pte = pgdir_walk(pgdir, va, 1))) {
		return -E_NO_MEM;
f0101643:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	} else {
		*pte = page2pa(pp) | perm | PTE_P;
		pp->pp_ref++;
	}
	return 0;
}
f0101648:	83 c4 1c             	add    $0x1c,%esp
f010164b:	5b                   	pop    %ebx
f010164c:	5e                   	pop    %esi
f010164d:	5f                   	pop    %edi
f010164e:	5d                   	pop    %ebp
f010164f:	c3                   	ret    

f0101650 <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f0101650:	55                   	push   %ebp
f0101651:	89 e5                	mov    %esp,%ebp
f0101653:	56                   	push   %esi
f0101654:	53                   	push   %ebx
f0101655:	83 ec 10             	sub    $0x10,%esp
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
  void* ret = (void*)base;
f0101658:	8b 1d 00 13 12 f0    	mov    0xf0121300,%ebx
  size = ROUNDUP(size, PGSIZE);
f010165e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101661:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
f0101667:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  boot_map_region(kern_pgdir, base, size, pa, PTE_PCD | PTE_PWT | PTE_W | PTE_P);
f010166d:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0101674:	00 
f0101675:	8b 45 08             	mov    0x8(%ebp),%eax
f0101678:	89 04 24             	mov    %eax,(%esp)
f010167b:	89 f1                	mov    %esi,%ecx
f010167d:	89 da                	mov    %ebx,%edx
f010167f:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0101684:	e8 7c fd ff ff       	call   f0101405 <boot_map_region>
  base += size;
f0101689:	01 35 00 13 12 f0    	add    %esi,0xf0121300
  return ret;
}
f010168f:	89 d8                	mov    %ebx,%eax
f0101691:	83 c4 10             	add    $0x10,%esp
f0101694:	5b                   	pop    %ebx
f0101695:	5e                   	pop    %esi
f0101696:	5d                   	pop    %ebp
f0101697:	c3                   	ret    

f0101698 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101698:	55                   	push   %ebp
f0101699:	89 e5                	mov    %esp,%ebp
f010169b:	57                   	push   %edi
f010169c:	56                   	push   %esi
f010169d:	53                   	push   %ebx
f010169e:	83 ec 4c             	sub    $0x4c,%esp
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01016a1:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f01016a8:	e8 5b 29 00 00       	call   f0104008 <mc146818_read>
f01016ad:	89 c3                	mov    %eax,%ebx
f01016af:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
f01016b6:	e8 4d 29 00 00       	call   f0104008 <mc146818_read>
f01016bb:	c1 e0 08             	shl    $0x8,%eax
f01016be:	09 c3                	or     %eax,%ebx
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f01016c0:	89 d8                	mov    %ebx,%eax
f01016c2:	c1 e0 0a             	shl    $0xa,%eax
f01016c5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01016cb:	85 c0                	test   %eax,%eax
f01016cd:	0f 48 c2             	cmovs  %edx,%eax
f01016d0:	c1 f8 0c             	sar    $0xc,%eax
f01016d3:	a3 48 32 20 f0       	mov    %eax,0xf0203248
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01016d8:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f01016df:	e8 24 29 00 00       	call   f0104008 <mc146818_read>
f01016e4:	89 c3                	mov    %eax,%ebx
f01016e6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
f01016ed:	e8 16 29 00 00       	call   f0104008 <mc146818_read>
f01016f2:	c1 e0 08             	shl    $0x8,%eax
f01016f5:	09 c3                	or     %eax,%ebx
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f01016f7:	89 d8                	mov    %ebx,%eax
f01016f9:	c1 e0 0a             	shl    $0xa,%eax
f01016fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101702:	85 c0                	test   %eax,%eax
f0101704:	0f 48 c2             	cmovs  %edx,%eax
f0101707:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f010170a:	85 c0                	test   %eax,%eax
f010170c:	74 0e                	je     f010171c <mem_init+0x84>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f010170e:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0101714:	89 15 88 3e 20 f0    	mov    %edx,0xf0203e88
f010171a:	eb 0c                	jmp    f0101728 <mem_init+0x90>
	else
		npages = npages_basemem;
f010171c:	8b 15 48 32 20 f0    	mov    0xf0203248,%edx
f0101722:	89 15 88 3e 20 f0    	mov    %edx,0xf0203e88

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f0101728:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010172b:	c1 e8 0a             	shr    $0xa,%eax
f010172e:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f0101732:	a1 48 32 20 f0       	mov    0xf0203248,%eax
f0101737:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010173a:	c1 e8 0a             	shr    $0xa,%eax
f010173d:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f0101741:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f0101746:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101749:	c1 e8 0a             	shr    $0xa,%eax
f010174c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101750:	c7 04 24 6c 74 10 f0 	movl   $0xf010746c,(%esp)
f0101757:	e8 15 2a 00 00       	call   f0104171 <cprintf>
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
	cprintf("Total Pages: %d\n", npages);
f010175c:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f0101761:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101765:	c7 04 24 7c 7d 10 f0 	movl   $0xf0107d7c,(%esp)
f010176c:	e8 00 2a 00 00       	call   f0104171 <cprintf>

	// Remove this line when you're ready to test this function.

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101771:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101776:	e8 34 f4 ff ff       	call   f0100baf <boot_alloc>
f010177b:	a3 8c 3e 20 f0       	mov    %eax,0xf0203e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101780:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101787:	00 
f0101788:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010178f:	00 
f0101790:	89 04 24             	mov    %eax,(%esp)
f0101793:	e8 21 48 00 00       	call   f0105fb9 <memset>

	// So this mapping enables user code read the content of the page tables.

	// 这句话的意思是，[UVPT, UVPT + 4MB)的内存映射由page table kern_pgdir来管理。
	// page table directory 作为了 page table
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101798:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010179d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017a2:	77 20                	ja     f01017c4 <mem_init+0x12c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01017a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01017a8:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f01017af:	f0 
f01017b0:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
f01017b7:	00 
f01017b8:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01017bf:	e8 7c e8 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01017c4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017ca:	83 ca 05             	or     $0x5,%edx
f01017cd:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate an array of npages 'struct PageInfo's and store it in 'pages'.
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.
	// Your code goes here:
	pages = boot_alloc(sizeof(struct PageInfo) * npages);
f01017d3:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f01017d8:	c1 e0 03             	shl    $0x3,%eax
f01017db:	e8 cf f3 ff ff       	call   f0100baf <boot_alloc>
f01017e0:	a3 90 3e 20 f0       	mov    %eax,0xf0203e90

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	envs = boot_alloc(sizeof(struct Env) * NENV);
f01017e5:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01017ea:	e8 c0 f3 ff ff       	call   f0100baf <boot_alloc>
f01017ef:	a3 4c 32 20 f0       	mov    %eax,0xf020324c
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f01017f4:	e8 24 f8 ff ff       	call   f010101d <page_init>

	check_page_free_list(1);
f01017f9:	b8 01 00 00 00       	mov    $0x1,%eax
f01017fe:	e8 27 f4 ff ff       	call   f0100c2a <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101803:	83 3d 90 3e 20 f0 00 	cmpl   $0x0,0xf0203e90
f010180a:	75 1c                	jne    f0101828 <mem_init+0x190>
		panic("'pages' is a null pointer!");
f010180c:	c7 44 24 08 8d 7d 10 	movl   $0xf0107d8d,0x8(%esp)
f0101813:	f0 
f0101814:	c7 44 24 04 41 03 00 	movl   $0x341,0x4(%esp)
f010181b:	00 
f010181c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101823:	e8 18 e8 ff ff       	call   f0100040 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101828:	a1 44 32 20 f0       	mov    0xf0203244,%eax
f010182d:	85 c0                	test   %eax,%eax
f010182f:	74 10                	je     f0101841 <mem_init+0x1a9>
f0101831:	bb 00 00 00 00       	mov    $0x0,%ebx
		++nfree;
f0101836:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101839:	8b 00                	mov    (%eax),%eax
f010183b:	85 c0                	test   %eax,%eax
f010183d:	75 f7                	jne    f0101836 <mem_init+0x19e>
f010183f:	eb 05                	jmp    f0101846 <mem_init+0x1ae>
f0101841:	bb 00 00 00 00       	mov    $0x0,%ebx
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101846:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010184d:	e8 dc f9 ff ff       	call   f010122e <page_alloc>
f0101852:	89 c7                	mov    %eax,%edi
f0101854:	85 c0                	test   %eax,%eax
f0101856:	75 24                	jne    f010187c <mem_init+0x1e4>
f0101858:	c7 44 24 0c a8 7d 10 	movl   $0xf0107da8,0xc(%esp)
f010185f:	f0 
f0101860:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101867:	f0 
f0101868:	c7 44 24 04 49 03 00 	movl   $0x349,0x4(%esp)
f010186f:	00 
f0101870:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101877:	e8 c4 e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010187c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101883:	e8 a6 f9 ff ff       	call   f010122e <page_alloc>
f0101888:	89 c6                	mov    %eax,%esi
f010188a:	85 c0                	test   %eax,%eax
f010188c:	75 24                	jne    f01018b2 <mem_init+0x21a>
f010188e:	c7 44 24 0c be 7d 10 	movl   $0xf0107dbe,0xc(%esp)
f0101895:	f0 
f0101896:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010189d:	f0 
f010189e:	c7 44 24 04 4a 03 00 	movl   $0x34a,0x4(%esp)
f01018a5:	00 
f01018a6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01018ad:	e8 8e e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01018b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018b9:	e8 70 f9 ff ff       	call   f010122e <page_alloc>
f01018be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018c1:	85 c0                	test   %eax,%eax
f01018c3:	75 24                	jne    f01018e9 <mem_init+0x251>
f01018c5:	c7 44 24 0c d4 7d 10 	movl   $0xf0107dd4,0xc(%esp)
f01018cc:	f0 
f01018cd:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01018d4:	f0 
f01018d5:	c7 44 24 04 4b 03 00 	movl   $0x34b,0x4(%esp)
f01018dc:	00 
f01018dd:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01018e4:	e8 57 e7 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01018e9:	39 f7                	cmp    %esi,%edi
f01018eb:	75 24                	jne    f0101911 <mem_init+0x279>
f01018ed:	c7 44 24 0c ea 7d 10 	movl   $0xf0107dea,0xc(%esp)
f01018f4:	f0 
f01018f5:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01018fc:	f0 
f01018fd:	c7 44 24 04 4e 03 00 	movl   $0x34e,0x4(%esp)
f0101904:	00 
f0101905:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010190c:	e8 2f e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101914:	39 c6                	cmp    %eax,%esi
f0101916:	74 04                	je     f010191c <mem_init+0x284>
f0101918:	39 c7                	cmp    %eax,%edi
f010191a:	75 24                	jne    f0101940 <mem_init+0x2a8>
f010191c:	c7 44 24 0c a8 74 10 	movl   $0xf01074a8,0xc(%esp)
f0101923:	f0 
f0101924:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010192b:	f0 
f010192c:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
f0101933:	00 
f0101934:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010193b:	e8 00 e7 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101940:	8b 15 90 3e 20 f0    	mov    0xf0203e90,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101946:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f010194b:	c1 e0 0c             	shl    $0xc,%eax
f010194e:	89 f9                	mov    %edi,%ecx
f0101950:	29 d1                	sub    %edx,%ecx
f0101952:	c1 f9 03             	sar    $0x3,%ecx
f0101955:	c1 e1 0c             	shl    $0xc,%ecx
f0101958:	39 c1                	cmp    %eax,%ecx
f010195a:	72 24                	jb     f0101980 <mem_init+0x2e8>
f010195c:	c7 44 24 0c fc 7d 10 	movl   $0xf0107dfc,0xc(%esp)
f0101963:	f0 
f0101964:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010196b:	f0 
f010196c:	c7 44 24 04 50 03 00 	movl   $0x350,0x4(%esp)
f0101973:	00 
f0101974:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010197b:	e8 c0 e6 ff ff       	call   f0100040 <_panic>
f0101980:	89 f1                	mov    %esi,%ecx
f0101982:	29 d1                	sub    %edx,%ecx
f0101984:	c1 f9 03             	sar    $0x3,%ecx
f0101987:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f010198a:	39 c8                	cmp    %ecx,%eax
f010198c:	77 24                	ja     f01019b2 <mem_init+0x31a>
f010198e:	c7 44 24 0c 19 7e 10 	movl   $0xf0107e19,0xc(%esp)
f0101995:	f0 
f0101996:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010199d:	f0 
f010199e:	c7 44 24 04 51 03 00 	movl   $0x351,0x4(%esp)
f01019a5:	00 
f01019a6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01019ad:	e8 8e e6 ff ff       	call   f0100040 <_panic>
f01019b2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01019b5:	29 d1                	sub    %edx,%ecx
f01019b7:	89 ca                	mov    %ecx,%edx
f01019b9:	c1 fa 03             	sar    $0x3,%edx
f01019bc:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f01019bf:	39 d0                	cmp    %edx,%eax
f01019c1:	77 24                	ja     f01019e7 <mem_init+0x34f>
f01019c3:	c7 44 24 0c 36 7e 10 	movl   $0xf0107e36,0xc(%esp)
f01019ca:	f0 
f01019cb:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01019d2:	f0 
f01019d3:	c7 44 24 04 52 03 00 	movl   $0x352,0x4(%esp)
f01019da:	00 
f01019db:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01019e2:	e8 59 e6 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01019e7:	a1 44 32 20 f0       	mov    0xf0203244,%eax
f01019ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01019ef:	c7 05 44 32 20 f0 00 	movl   $0x0,0xf0203244
f01019f6:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01019f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a00:	e8 29 f8 ff ff       	call   f010122e <page_alloc>
f0101a05:	85 c0                	test   %eax,%eax
f0101a07:	74 24                	je     f0101a2d <mem_init+0x395>
f0101a09:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f0101a10:	f0 
f0101a11:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101a18:	f0 
f0101a19:	c7 44 24 04 59 03 00 	movl   $0x359,0x4(%esp)
f0101a20:	00 
f0101a21:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101a28:	e8 13 e6 ff ff       	call   f0100040 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101a2d:	89 3c 24             	mov    %edi,(%esp)
f0101a30:	e8 7e f8 ff ff       	call   f01012b3 <page_free>
	page_free(pp1);
f0101a35:	89 34 24             	mov    %esi,(%esp)
f0101a38:	e8 76 f8 ff ff       	call   f01012b3 <page_free>
	page_free(pp2);
f0101a3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a40:	89 04 24             	mov    %eax,(%esp)
f0101a43:	e8 6b f8 ff ff       	call   f01012b3 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101a48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a4f:	e8 da f7 ff ff       	call   f010122e <page_alloc>
f0101a54:	89 c6                	mov    %eax,%esi
f0101a56:	85 c0                	test   %eax,%eax
f0101a58:	75 24                	jne    f0101a7e <mem_init+0x3e6>
f0101a5a:	c7 44 24 0c a8 7d 10 	movl   $0xf0107da8,0xc(%esp)
f0101a61:	f0 
f0101a62:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101a69:	f0 
f0101a6a:	c7 44 24 04 60 03 00 	movl   $0x360,0x4(%esp)
f0101a71:	00 
f0101a72:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101a79:	e8 c2 e5 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101a7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a85:	e8 a4 f7 ff ff       	call   f010122e <page_alloc>
f0101a8a:	89 c7                	mov    %eax,%edi
f0101a8c:	85 c0                	test   %eax,%eax
f0101a8e:	75 24                	jne    f0101ab4 <mem_init+0x41c>
f0101a90:	c7 44 24 0c be 7d 10 	movl   $0xf0107dbe,0xc(%esp)
f0101a97:	f0 
f0101a98:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101a9f:	f0 
f0101aa0:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
f0101aa7:	00 
f0101aa8:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101aaf:	e8 8c e5 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101abb:	e8 6e f7 ff ff       	call   f010122e <page_alloc>
f0101ac0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ac3:	85 c0                	test   %eax,%eax
f0101ac5:	75 24                	jne    f0101aeb <mem_init+0x453>
f0101ac7:	c7 44 24 0c d4 7d 10 	movl   $0xf0107dd4,0xc(%esp)
f0101ace:	f0 
f0101acf:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101ad6:	f0 
f0101ad7:	c7 44 24 04 62 03 00 	movl   $0x362,0x4(%esp)
f0101ade:	00 
f0101adf:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101ae6:	e8 55 e5 ff ff       	call   f0100040 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101aeb:	39 fe                	cmp    %edi,%esi
f0101aed:	75 24                	jne    f0101b13 <mem_init+0x47b>
f0101aef:	c7 44 24 0c ea 7d 10 	movl   $0xf0107dea,0xc(%esp)
f0101af6:	f0 
f0101af7:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101afe:	f0 
f0101aff:	c7 44 24 04 64 03 00 	movl   $0x364,0x4(%esp)
f0101b06:	00 
f0101b07:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101b0e:	e8 2d e5 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b16:	39 c7                	cmp    %eax,%edi
f0101b18:	74 04                	je     f0101b1e <mem_init+0x486>
f0101b1a:	39 c6                	cmp    %eax,%esi
f0101b1c:	75 24                	jne    f0101b42 <mem_init+0x4aa>
f0101b1e:	c7 44 24 0c a8 74 10 	movl   $0xf01074a8,0xc(%esp)
f0101b25:	f0 
f0101b26:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101b2d:	f0 
f0101b2e:	c7 44 24 04 65 03 00 	movl   $0x365,0x4(%esp)
f0101b35:	00 
f0101b36:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101b3d:	e8 fe e4 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101b42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b49:	e8 e0 f6 ff ff       	call   f010122e <page_alloc>
f0101b4e:	85 c0                	test   %eax,%eax
f0101b50:	74 24                	je     f0101b76 <mem_init+0x4de>
f0101b52:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f0101b59:	f0 
f0101b5a:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101b61:	f0 
f0101b62:	c7 44 24 04 66 03 00 	movl   $0x366,0x4(%esp)
f0101b69:	00 
f0101b6a:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101b71:	e8 ca e4 ff ff       	call   f0100040 <_panic>
f0101b76:	89 f0                	mov    %esi,%eax
f0101b78:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0101b7e:	c1 f8 03             	sar    $0x3,%eax
f0101b81:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101b84:	89 c2                	mov    %eax,%edx
f0101b86:	c1 ea 0c             	shr    $0xc,%edx
f0101b89:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f0101b8f:	72 20                	jb     f0101bb1 <mem_init+0x519>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101b91:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101b95:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0101b9c:	f0 
f0101b9d:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101ba4:	00 
f0101ba5:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0101bac:	e8 8f e4 ff ff       	call   f0100040 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101bb1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101bb8:	00 
f0101bb9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0101bc0:	00 
	return (void *)(pa + KERNBASE);
f0101bc1:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101bc6:	89 04 24             	mov    %eax,(%esp)
f0101bc9:	e8 eb 43 00 00       	call   f0105fb9 <memset>
	page_free(pp0);
f0101bce:	89 34 24             	mov    %esi,(%esp)
f0101bd1:	e8 dd f6 ff ff       	call   f01012b3 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101bd6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101bdd:	e8 4c f6 ff ff       	call   f010122e <page_alloc>
f0101be2:	85 c0                	test   %eax,%eax
f0101be4:	75 24                	jne    f0101c0a <mem_init+0x572>
f0101be6:	c7 44 24 0c 62 7e 10 	movl   $0xf0107e62,0xc(%esp)
f0101bed:	f0 
f0101bee:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101bf5:	f0 
f0101bf6:	c7 44 24 04 6b 03 00 	movl   $0x36b,0x4(%esp)
f0101bfd:	00 
f0101bfe:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101c05:	e8 36 e4 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101c0a:	39 c6                	cmp    %eax,%esi
f0101c0c:	74 24                	je     f0101c32 <mem_init+0x59a>
f0101c0e:	c7 44 24 0c 80 7e 10 	movl   $0xf0107e80,0xc(%esp)
f0101c15:	f0 
f0101c16:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101c1d:	f0 
f0101c1e:	c7 44 24 04 6c 03 00 	movl   $0x36c,0x4(%esp)
f0101c25:	00 
f0101c26:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101c2d:	e8 0e e4 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101c32:	89 f2                	mov    %esi,%edx
f0101c34:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f0101c3a:	c1 fa 03             	sar    $0x3,%edx
f0101c3d:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101c40:	89 d0                	mov    %edx,%eax
f0101c42:	c1 e8 0c             	shr    $0xc,%eax
f0101c45:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0101c4b:	72 20                	jb     f0101c6d <mem_init+0x5d5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101c51:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0101c58:	f0 
f0101c59:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101c60:	00 
f0101c61:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0101c68:	e8 d3 e3 ff ff       	call   f0100040 <_panic>
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101c6d:	80 ba 00 00 00 f0 00 	cmpb   $0x0,-0x10000000(%edx)
f0101c74:	75 11                	jne    f0101c87 <mem_init+0x5ef>
f0101c76:	8d 82 01 00 00 f0    	lea    -0xfffffff(%edx),%eax
f0101c7c:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0101c82:	80 38 00             	cmpb   $0x0,(%eax)
f0101c85:	74 24                	je     f0101cab <mem_init+0x613>
f0101c87:	c7 44 24 0c 90 7e 10 	movl   $0xf0107e90,0xc(%esp)
f0101c8e:	f0 
f0101c8f:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101c96:	f0 
f0101c97:	c7 44 24 04 6f 03 00 	movl   $0x36f,0x4(%esp)
f0101c9e:	00 
f0101c9f:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101ca6:	e8 95 e3 ff ff       	call   f0100040 <_panic>
f0101cab:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0101cae:	39 d0                	cmp    %edx,%eax
f0101cb0:	75 d0                	jne    f0101c82 <mem_init+0x5ea>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0101cb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101cb5:	a3 44 32 20 f0       	mov    %eax,0xf0203244

	// free the pages we took
	page_free(pp0);
f0101cba:	89 34 24             	mov    %esi,(%esp)
f0101cbd:	e8 f1 f5 ff ff       	call   f01012b3 <page_free>
	page_free(pp1);
f0101cc2:	89 3c 24             	mov    %edi,(%esp)
f0101cc5:	e8 e9 f5 ff ff       	call   f01012b3 <page_free>
	page_free(pp2);
f0101cca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ccd:	89 04 24             	mov    %eax,(%esp)
f0101cd0:	e8 de f5 ff ff       	call   f01012b3 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101cd5:	a1 44 32 20 f0       	mov    0xf0203244,%eax
f0101cda:	85 c0                	test   %eax,%eax
f0101cdc:	74 09                	je     f0101ce7 <mem_init+0x64f>
		--nfree;
f0101cde:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ce1:	8b 00                	mov    (%eax),%eax
f0101ce3:	85 c0                	test   %eax,%eax
f0101ce5:	75 f7                	jne    f0101cde <mem_init+0x646>
		--nfree;
	assert(nfree == 0);
f0101ce7:	85 db                	test   %ebx,%ebx
f0101ce9:	74 24                	je     f0101d0f <mem_init+0x677>
f0101ceb:	c7 44 24 0c 9a 7e 10 	movl   $0xf0107e9a,0xc(%esp)
f0101cf2:	f0 
f0101cf3:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101cfa:	f0 
f0101cfb:	c7 44 24 04 7c 03 00 	movl   $0x37c,0x4(%esp)
f0101d02:	00 
f0101d03:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101d0a:	e8 31 e3 ff ff       	call   f0100040 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101d0f:	c7 04 24 c8 74 10 f0 	movl   $0xf01074c8,(%esp)
f0101d16:	e8 56 24 00 00       	call   f0104171 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101d1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d22:	e8 07 f5 ff ff       	call   f010122e <page_alloc>
f0101d27:	89 c6                	mov    %eax,%esi
f0101d29:	85 c0                	test   %eax,%eax
f0101d2b:	75 24                	jne    f0101d51 <mem_init+0x6b9>
f0101d2d:	c7 44 24 0c a8 7d 10 	movl   $0xf0107da8,0xc(%esp)
f0101d34:	f0 
f0101d35:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101d3c:	f0 
f0101d3d:	c7 44 24 04 e7 03 00 	movl   $0x3e7,0x4(%esp)
f0101d44:	00 
f0101d45:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101d4c:	e8 ef e2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101d51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d58:	e8 d1 f4 ff ff       	call   f010122e <page_alloc>
f0101d5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101d60:	85 c0                	test   %eax,%eax
f0101d62:	75 24                	jne    f0101d88 <mem_init+0x6f0>
f0101d64:	c7 44 24 0c be 7d 10 	movl   $0xf0107dbe,0xc(%esp)
f0101d6b:	f0 
f0101d6c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101d73:	f0 
f0101d74:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
f0101d7b:	00 
f0101d7c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101d83:	e8 b8 e2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101d88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d8f:	e8 9a f4 ff ff       	call   f010122e <page_alloc>
f0101d94:	89 c3                	mov    %eax,%ebx
f0101d96:	85 c0                	test   %eax,%eax
f0101d98:	75 24                	jne    f0101dbe <mem_init+0x726>
f0101d9a:	c7 44 24 0c d4 7d 10 	movl   $0xf0107dd4,0xc(%esp)
f0101da1:	f0 
f0101da2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101da9:	f0 
f0101daa:	c7 44 24 04 e9 03 00 	movl   $0x3e9,0x4(%esp)
f0101db1:	00 
f0101db2:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101db9:	e8 82 e2 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101dbe:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
f0101dc1:	75 24                	jne    f0101de7 <mem_init+0x74f>
f0101dc3:	c7 44 24 0c ea 7d 10 	movl   $0xf0107dea,0xc(%esp)
f0101dca:	f0 
f0101dcb:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101dd2:	f0 
f0101dd3:	c7 44 24 04 ec 03 00 	movl   $0x3ec,0x4(%esp)
f0101dda:	00 
f0101ddb:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101de2:	e8 59 e2 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101de7:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101dea:	74 04                	je     f0101df0 <mem_init+0x758>
f0101dec:	39 c6                	cmp    %eax,%esi
f0101dee:	75 24                	jne    f0101e14 <mem_init+0x77c>
f0101df0:	c7 44 24 0c a8 74 10 	movl   $0xf01074a8,0xc(%esp)
f0101df7:	f0 
f0101df8:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101dff:	f0 
f0101e00:	c7 44 24 04 ed 03 00 	movl   $0x3ed,0x4(%esp)
f0101e07:	00 
f0101e08:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101e0f:	e8 2c e2 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101e14:	a1 44 32 20 f0       	mov    0xf0203244,%eax
f0101e19:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101e1c:	c7 05 44 32 20 f0 00 	movl   $0x0,0xf0203244
f0101e23:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101e26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e2d:	e8 fc f3 ff ff       	call   f010122e <page_alloc>
f0101e32:	85 c0                	test   %eax,%eax
f0101e34:	74 24                	je     f0101e5a <mem_init+0x7c2>
f0101e36:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f0101e3d:	f0 
f0101e3e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101e45:	f0 
f0101e46:	c7 44 24 04 f4 03 00 	movl   $0x3f4,0x4(%esp)
f0101e4d:	00 
f0101e4e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101e55:	e8 e6 e1 ff ff       	call   f0100040 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101e5a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101e5d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101e61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101e68:	00 
f0101e69:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0101e6e:	89 04 24             	mov    %eax,(%esp)
f0101e71:	e8 44 f6 ff ff       	call   f01014ba <page_lookup>
f0101e76:	85 c0                	test   %eax,%eax
f0101e78:	74 24                	je     f0101e9e <mem_init+0x806>
f0101e7a:	c7 44 24 0c e8 74 10 	movl   $0xf01074e8,0xc(%esp)
f0101e81:	f0 
f0101e82:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101e89:	f0 
f0101e8a:	c7 44 24 04 f7 03 00 	movl   $0x3f7,0x4(%esp)
f0101e91:	00 
f0101e92:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101e99:	e8 a2 e1 ff ff       	call   f0100040 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101e9e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101ea5:	00 
f0101ea6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101ead:	00 
f0101eae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101eb5:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0101eba:	89 04 24             	mov    %eax,(%esp)
f0101ebd:	e8 cc f6 ff ff       	call   f010158e <page_insert>
f0101ec2:	85 c0                	test   %eax,%eax
f0101ec4:	78 24                	js     f0101eea <mem_init+0x852>
f0101ec6:	c7 44 24 0c 20 75 10 	movl   $0xf0107520,0xc(%esp)
f0101ecd:	f0 
f0101ece:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101ed5:	f0 
f0101ed6:	c7 44 24 04 fa 03 00 	movl   $0x3fa,0x4(%esp)
f0101edd:	00 
f0101ede:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101ee5:	e8 56 e1 ff ff       	call   f0100040 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101eea:	89 34 24             	mov    %esi,(%esp)
f0101eed:	e8 c1 f3 ff ff       	call   f01012b3 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101ef2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101ef9:	00 
f0101efa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101f01:	00 
f0101f02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f05:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101f09:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0101f0e:	89 04 24             	mov    %eax,(%esp)
f0101f11:	e8 78 f6 ff ff       	call   f010158e <page_insert>
f0101f16:	85 c0                	test   %eax,%eax
f0101f18:	74 24                	je     f0101f3e <mem_init+0x8a6>
f0101f1a:	c7 44 24 0c 50 75 10 	movl   $0xf0107550,0xc(%esp)
f0101f21:	f0 
f0101f22:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101f29:	f0 
f0101f2a:	c7 44 24 04 fe 03 00 	movl   $0x3fe,0x4(%esp)
f0101f31:	00 
f0101f32:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101f39:	e8 02 e1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f3e:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101f44:	a1 90 3e 20 f0       	mov    0xf0203e90,%eax
f0101f49:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101f4c:	8b 17                	mov    (%edi),%edx
f0101f4e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f54:	89 f1                	mov    %esi,%ecx
f0101f56:	29 c1                	sub    %eax,%ecx
f0101f58:	89 c8                	mov    %ecx,%eax
f0101f5a:	c1 f8 03             	sar    $0x3,%eax
f0101f5d:	c1 e0 0c             	shl    $0xc,%eax
f0101f60:	39 c2                	cmp    %eax,%edx
f0101f62:	74 24                	je     f0101f88 <mem_init+0x8f0>
f0101f64:	c7 44 24 0c 80 75 10 	movl   $0xf0107580,0xc(%esp)
f0101f6b:	f0 
f0101f6c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101f73:	f0 
f0101f74:	c7 44 24 04 ff 03 00 	movl   $0x3ff,0x4(%esp)
f0101f7b:	00 
f0101f7c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101f83:	e8 b8 e0 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101f88:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f8d:	89 f8                	mov    %edi,%eax
f0101f8f:	e8 ac eb ff ff       	call   f0100b40 <check_va2pa>
f0101f94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101f97:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0101f9a:	c1 fa 03             	sar    $0x3,%edx
f0101f9d:	c1 e2 0c             	shl    $0xc,%edx
f0101fa0:	39 d0                	cmp    %edx,%eax
f0101fa2:	74 24                	je     f0101fc8 <mem_init+0x930>
f0101fa4:	c7 44 24 0c a8 75 10 	movl   $0xf01075a8,0xc(%esp)
f0101fab:	f0 
f0101fac:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101fb3:	f0 
f0101fb4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0101fbb:	00 
f0101fbc:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101fc3:	e8 78 e0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0101fc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fcb:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101fd0:	74 24                	je     f0101ff6 <mem_init+0x95e>
f0101fd2:	c7 44 24 0c a5 7e 10 	movl   $0xf0107ea5,0xc(%esp)
f0101fd9:	f0 
f0101fda:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0101fe1:	f0 
f0101fe2:	c7 44 24 04 01 04 00 	movl   $0x401,0x4(%esp)
f0101fe9:	00 
f0101fea:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0101ff1:	e8 4a e0 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0101ff6:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101ffb:	74 24                	je     f0102021 <mem_init+0x989>
f0101ffd:	c7 44 24 0c b6 7e 10 	movl   $0xf0107eb6,0xc(%esp)
f0102004:	f0 
f0102005:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010200c:	f0 
f010200d:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
f0102014:	00 
f0102015:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010201c:	e8 1f e0 ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102021:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102028:	00 
f0102029:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102030:	00 
f0102031:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102035:	89 3c 24             	mov    %edi,(%esp)
f0102038:	e8 51 f5 ff ff       	call   f010158e <page_insert>
f010203d:	85 c0                	test   %eax,%eax
f010203f:	74 24                	je     f0102065 <mem_init+0x9cd>
f0102041:	c7 44 24 0c d8 75 10 	movl   $0xf01075d8,0xc(%esp)
f0102048:	f0 
f0102049:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102050:	f0 
f0102051:	c7 44 24 04 05 04 00 	movl   $0x405,0x4(%esp)
f0102058:	00 
f0102059:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102060:	e8 db df ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102065:	ba 00 10 00 00       	mov    $0x1000,%edx
f010206a:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010206f:	e8 cc ea ff ff       	call   f0100b40 <check_va2pa>
f0102074:	89 da                	mov    %ebx,%edx
f0102076:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f010207c:	c1 fa 03             	sar    $0x3,%edx
f010207f:	c1 e2 0c             	shl    $0xc,%edx
f0102082:	39 d0                	cmp    %edx,%eax
f0102084:	74 24                	je     f01020aa <mem_init+0xa12>
f0102086:	c7 44 24 0c 14 76 10 	movl   $0xf0107614,0xc(%esp)
f010208d:	f0 
f010208e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102095:	f0 
f0102096:	c7 44 24 04 06 04 00 	movl   $0x406,0x4(%esp)
f010209d:	00 
f010209e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01020a5:	e8 96 df ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01020aa:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01020af:	74 24                	je     f01020d5 <mem_init+0xa3d>
f01020b1:	c7 44 24 0c c7 7e 10 	movl   $0xf0107ec7,0xc(%esp)
f01020b8:	f0 
f01020b9:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01020c0:	f0 
f01020c1:	c7 44 24 04 07 04 00 	movl   $0x407,0x4(%esp)
f01020c8:	00 
f01020c9:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01020d0:	e8 6b df ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01020d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01020dc:	e8 4d f1 ff ff       	call   f010122e <page_alloc>
f01020e1:	85 c0                	test   %eax,%eax
f01020e3:	74 24                	je     f0102109 <mem_init+0xa71>
f01020e5:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f01020ec:	f0 
f01020ed:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01020f4:	f0 
f01020f5:	c7 44 24 04 0a 04 00 	movl   $0x40a,0x4(%esp)
f01020fc:	00 
f01020fd:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102104:	e8 37 df ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102109:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102110:	00 
f0102111:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102118:	00 
f0102119:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010211d:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102122:	89 04 24             	mov    %eax,(%esp)
f0102125:	e8 64 f4 ff ff       	call   f010158e <page_insert>
f010212a:	85 c0                	test   %eax,%eax
f010212c:	74 24                	je     f0102152 <mem_init+0xaba>
f010212e:	c7 44 24 0c d8 75 10 	movl   $0xf01075d8,0xc(%esp)
f0102135:	f0 
f0102136:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010213d:	f0 
f010213e:	c7 44 24 04 0d 04 00 	movl   $0x40d,0x4(%esp)
f0102145:	00 
f0102146:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010214d:	e8 ee de ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102152:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102157:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010215c:	e8 df e9 ff ff       	call   f0100b40 <check_va2pa>
f0102161:	89 da                	mov    %ebx,%edx
f0102163:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f0102169:	c1 fa 03             	sar    $0x3,%edx
f010216c:	c1 e2 0c             	shl    $0xc,%edx
f010216f:	39 d0                	cmp    %edx,%eax
f0102171:	74 24                	je     f0102197 <mem_init+0xaff>
f0102173:	c7 44 24 0c 14 76 10 	movl   $0xf0107614,0xc(%esp)
f010217a:	f0 
f010217b:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102182:	f0 
f0102183:	c7 44 24 04 0e 04 00 	movl   $0x40e,0x4(%esp)
f010218a:	00 
f010218b:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102192:	e8 a9 de ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102197:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010219c:	74 24                	je     f01021c2 <mem_init+0xb2a>
f010219e:	c7 44 24 0c c7 7e 10 	movl   $0xf0107ec7,0xc(%esp)
f01021a5:	f0 
f01021a6:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01021ad:	f0 
f01021ae:	c7 44 24 04 0f 04 00 	movl   $0x40f,0x4(%esp)
f01021b5:	00 
f01021b6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01021bd:	e8 7e de ff ff       	call   f0100040 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f01021c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01021c9:	e8 60 f0 ff ff       	call   f010122e <page_alloc>
f01021ce:	85 c0                	test   %eax,%eax
f01021d0:	74 24                	je     f01021f6 <mem_init+0xb5e>
f01021d2:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f01021d9:	f0 
f01021da:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01021e1:	f0 
f01021e2:	c7 44 24 04 13 04 00 	movl   $0x413,0x4(%esp)
f01021e9:	00 
f01021ea:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01021f1:	e8 4a de ff ff       	call   f0100040 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01021f6:	8b 15 8c 3e 20 f0    	mov    0xf0203e8c,%edx
f01021fc:	8b 02                	mov    (%edx),%eax
f01021fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102203:	89 c1                	mov    %eax,%ecx
f0102205:	c1 e9 0c             	shr    $0xc,%ecx
f0102208:	3b 0d 88 3e 20 f0    	cmp    0xf0203e88,%ecx
f010220e:	72 20                	jb     f0102230 <mem_init+0xb98>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102210:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102214:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010221b:	f0 
f010221c:	c7 44 24 04 16 04 00 	movl   $0x416,0x4(%esp)
f0102223:	00 
f0102224:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010222b:	e8 10 de ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102230:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102238:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010223f:	00 
f0102240:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102247:	00 
f0102248:	89 14 24             	mov    %edx,(%esp)
f010224b:	e8 a6 f0 ff ff       	call   f01012f6 <pgdir_walk>
f0102250:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102253:	8d 51 04             	lea    0x4(%ecx),%edx
f0102256:	39 d0                	cmp    %edx,%eax
f0102258:	74 24                	je     f010227e <mem_init+0xbe6>
f010225a:	c7 44 24 0c 44 76 10 	movl   $0xf0107644,0xc(%esp)
f0102261:	f0 
f0102262:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102269:	f0 
f010226a:	c7 44 24 04 17 04 00 	movl   $0x417,0x4(%esp)
f0102271:	00 
f0102272:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102279:	e8 c2 dd ff ff       	call   f0100040 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010227e:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0102285:	00 
f0102286:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010228d:	00 
f010228e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102292:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102297:	89 04 24             	mov    %eax,(%esp)
f010229a:	e8 ef f2 ff ff       	call   f010158e <page_insert>
f010229f:	85 c0                	test   %eax,%eax
f01022a1:	74 24                	je     f01022c7 <mem_init+0xc2f>
f01022a3:	c7 44 24 0c 84 76 10 	movl   $0xf0107684,0xc(%esp)
f01022aa:	f0 
f01022ab:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01022b2:	f0 
f01022b3:	c7 44 24 04 1a 04 00 	movl   $0x41a,0x4(%esp)
f01022ba:	00 
f01022bb:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01022c2:	e8 79 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01022c7:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
f01022cd:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022d2:	89 f8                	mov    %edi,%eax
f01022d4:	e8 67 e8 ff ff       	call   f0100b40 <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01022d9:	89 da                	mov    %ebx,%edx
f01022db:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f01022e1:	c1 fa 03             	sar    $0x3,%edx
f01022e4:	c1 e2 0c             	shl    $0xc,%edx
f01022e7:	39 d0                	cmp    %edx,%eax
f01022e9:	74 24                	je     f010230f <mem_init+0xc77>
f01022eb:	c7 44 24 0c 14 76 10 	movl   $0xf0107614,0xc(%esp)
f01022f2:	f0 
f01022f3:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01022fa:	f0 
f01022fb:	c7 44 24 04 1b 04 00 	movl   $0x41b,0x4(%esp)
f0102302:	00 
f0102303:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010230a:	e8 31 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010230f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102314:	74 24                	je     f010233a <mem_init+0xca2>
f0102316:	c7 44 24 0c c7 7e 10 	movl   $0xf0107ec7,0xc(%esp)
f010231d:	f0 
f010231e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102325:	f0 
f0102326:	c7 44 24 04 1c 04 00 	movl   $0x41c,0x4(%esp)
f010232d:	00 
f010232e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102335:	e8 06 dd ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010233a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102341:	00 
f0102342:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102349:	00 
f010234a:	89 3c 24             	mov    %edi,(%esp)
f010234d:	e8 a4 ef ff ff       	call   f01012f6 <pgdir_walk>
f0102352:	f6 00 04             	testb  $0x4,(%eax)
f0102355:	75 24                	jne    f010237b <mem_init+0xce3>
f0102357:	c7 44 24 0c c4 76 10 	movl   $0xf01076c4,0xc(%esp)
f010235e:	f0 
f010235f:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102366:	f0 
f0102367:	c7 44 24 04 1d 04 00 	movl   $0x41d,0x4(%esp)
f010236e:	00 
f010236f:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102376:	e8 c5 dc ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010237b:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102380:	f6 00 04             	testb  $0x4,(%eax)
f0102383:	75 24                	jne    f01023a9 <mem_init+0xd11>
f0102385:	c7 44 24 0c d8 7e 10 	movl   $0xf0107ed8,0xc(%esp)
f010238c:	f0 
f010238d:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102394:	f0 
f0102395:	c7 44 24 04 1e 04 00 	movl   $0x41e,0x4(%esp)
f010239c:	00 
f010239d:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01023a4:	e8 97 dc ff ff       	call   f0100040 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01023a9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01023b0:	00 
f01023b1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01023b8:	00 
f01023b9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01023bd:	89 04 24             	mov    %eax,(%esp)
f01023c0:	e8 c9 f1 ff ff       	call   f010158e <page_insert>
f01023c5:	85 c0                	test   %eax,%eax
f01023c7:	74 24                	je     f01023ed <mem_init+0xd55>
f01023c9:	c7 44 24 0c d8 75 10 	movl   $0xf01075d8,0xc(%esp)
f01023d0:	f0 
f01023d1:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01023d8:	f0 
f01023d9:	c7 44 24 04 21 04 00 	movl   $0x421,0x4(%esp)
f01023e0:	00 
f01023e1:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01023e8:	e8 53 dc ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01023ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01023f4:	00 
f01023f5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01023fc:	00 
f01023fd:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102402:	89 04 24             	mov    %eax,(%esp)
f0102405:	e8 ec ee ff ff       	call   f01012f6 <pgdir_walk>
f010240a:	f6 00 02             	testb  $0x2,(%eax)
f010240d:	75 24                	jne    f0102433 <mem_init+0xd9b>
f010240f:	c7 44 24 0c f8 76 10 	movl   $0xf01076f8,0xc(%esp)
f0102416:	f0 
f0102417:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010241e:	f0 
f010241f:	c7 44 24 04 22 04 00 	movl   $0x422,0x4(%esp)
f0102426:	00 
f0102427:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010242e:	e8 0d dc ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102433:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010243a:	00 
f010243b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102442:	00 
f0102443:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102448:	89 04 24             	mov    %eax,(%esp)
f010244b:	e8 a6 ee ff ff       	call   f01012f6 <pgdir_walk>
f0102450:	f6 00 04             	testb  $0x4,(%eax)
f0102453:	74 24                	je     f0102479 <mem_init+0xde1>
f0102455:	c7 44 24 0c 2c 77 10 	movl   $0xf010772c,0xc(%esp)
f010245c:	f0 
f010245d:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102464:	f0 
f0102465:	c7 44 24 04 23 04 00 	movl   $0x423,0x4(%esp)
f010246c:	00 
f010246d:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102474:	e8 c7 db ff ff       	call   f0100040 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102479:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102480:	00 
f0102481:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0102488:	00 
f0102489:	89 74 24 04          	mov    %esi,0x4(%esp)
f010248d:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102492:	89 04 24             	mov    %eax,(%esp)
f0102495:	e8 f4 f0 ff ff       	call   f010158e <page_insert>
f010249a:	85 c0                	test   %eax,%eax
f010249c:	78 24                	js     f01024c2 <mem_init+0xe2a>
f010249e:	c7 44 24 0c 64 77 10 	movl   $0xf0107764,0xc(%esp)
f01024a5:	f0 
f01024a6:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01024ad:	f0 
f01024ae:	c7 44 24 04 26 04 00 	movl   $0x426,0x4(%esp)
f01024b5:	00 
f01024b6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01024bd:	e8 7e db ff ff       	call   f0100040 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01024c2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01024c9:	00 
f01024ca:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01024d1:	00 
f01024d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01024d9:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f01024de:	89 04 24             	mov    %eax,(%esp)
f01024e1:	e8 a8 f0 ff ff       	call   f010158e <page_insert>
f01024e6:	85 c0                	test   %eax,%eax
f01024e8:	74 24                	je     f010250e <mem_init+0xe76>
f01024ea:	c7 44 24 0c 9c 77 10 	movl   $0xf010779c,0xc(%esp)
f01024f1:	f0 
f01024f2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01024f9:	f0 
f01024fa:	c7 44 24 04 29 04 00 	movl   $0x429,0x4(%esp)
f0102501:	00 
f0102502:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102509:	e8 32 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010250e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102515:	00 
f0102516:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010251d:	00 
f010251e:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102523:	89 04 24             	mov    %eax,(%esp)
f0102526:	e8 cb ed ff ff       	call   f01012f6 <pgdir_walk>
f010252b:	f6 00 04             	testb  $0x4,(%eax)
f010252e:	74 24                	je     f0102554 <mem_init+0xebc>
f0102530:	c7 44 24 0c 2c 77 10 	movl   $0xf010772c,0xc(%esp)
f0102537:	f0 
f0102538:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010253f:	f0 
f0102540:	c7 44 24 04 2a 04 00 	movl   $0x42a,0x4(%esp)
f0102547:	00 
f0102548:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010254f:	e8 ec da ff ff       	call   f0100040 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102554:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
f010255a:	ba 00 00 00 00       	mov    $0x0,%edx
f010255f:	89 f8                	mov    %edi,%eax
f0102561:	e8 da e5 ff ff       	call   f0100b40 <check_va2pa>
f0102566:	89 c1                	mov    %eax,%ecx
f0102568:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010256b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010256e:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0102574:	c1 f8 03             	sar    $0x3,%eax
f0102577:	c1 e0 0c             	shl    $0xc,%eax
f010257a:	39 c1                	cmp    %eax,%ecx
f010257c:	74 24                	je     f01025a2 <mem_init+0xf0a>
f010257e:	c7 44 24 0c d8 77 10 	movl   $0xf01077d8,0xc(%esp)
f0102585:	f0 
f0102586:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010258d:	f0 
f010258e:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f0102595:	00 
f0102596:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010259d:	e8 9e da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01025a2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01025a7:	89 f8                	mov    %edi,%eax
f01025a9:	e8 92 e5 ff ff       	call   f0100b40 <check_va2pa>
f01025ae:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01025b1:	74 24                	je     f01025d7 <mem_init+0xf3f>
f01025b3:	c7 44 24 0c 04 78 10 	movl   $0xf0107804,0xc(%esp)
f01025ba:	f0 
f01025bb:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01025c2:	f0 
f01025c3:	c7 44 24 04 2e 04 00 	movl   $0x42e,0x4(%esp)
f01025ca:	00 
f01025cb:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01025d2:	e8 69 da ff ff       	call   f0100040 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01025d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01025da:	66 83 78 04 02       	cmpw   $0x2,0x4(%eax)
f01025df:	74 24                	je     f0102605 <mem_init+0xf6d>
f01025e1:	c7 44 24 0c ee 7e 10 	movl   $0xf0107eee,0xc(%esp)
f01025e8:	f0 
f01025e9:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01025f0:	f0 
f01025f1:	c7 44 24 04 30 04 00 	movl   $0x430,0x4(%esp)
f01025f8:	00 
f01025f9:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102600:	e8 3b da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102605:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010260a:	74 24                	je     f0102630 <mem_init+0xf98>
f010260c:	c7 44 24 0c ff 7e 10 	movl   $0xf0107eff,0xc(%esp)
f0102613:	f0 
f0102614:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010261b:	f0 
f010261c:	c7 44 24 04 31 04 00 	movl   $0x431,0x4(%esp)
f0102623:	00 
f0102624:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010262b:	e8 10 da ff ff       	call   f0100040 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102637:	e8 f2 eb ff ff       	call   f010122e <page_alloc>
f010263c:	85 c0                	test   %eax,%eax
f010263e:	74 04                	je     f0102644 <mem_init+0xfac>
f0102640:	39 c3                	cmp    %eax,%ebx
f0102642:	74 24                	je     f0102668 <mem_init+0xfd0>
f0102644:	c7 44 24 0c 34 78 10 	movl   $0xf0107834,0xc(%esp)
f010264b:	f0 
f010264c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102653:	f0 
f0102654:	c7 44 24 04 34 04 00 	movl   $0x434,0x4(%esp)
f010265b:	00 
f010265c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102663:	e8 d8 d9 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102668:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010266f:	00 
f0102670:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102675:	89 04 24             	mov    %eax,(%esp)
f0102678:	e8 c8 ee ff ff       	call   f0101545 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010267d:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
f0102683:	ba 00 00 00 00       	mov    $0x0,%edx
f0102688:	89 f8                	mov    %edi,%eax
f010268a:	e8 b1 e4 ff ff       	call   f0100b40 <check_va2pa>
f010268f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102692:	74 24                	je     f01026b8 <mem_init+0x1020>
f0102694:	c7 44 24 0c 58 78 10 	movl   $0xf0107858,0xc(%esp)
f010269b:	f0 
f010269c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01026a3:	f0 
f01026a4:	c7 44 24 04 38 04 00 	movl   $0x438,0x4(%esp)
f01026ab:	00 
f01026ac:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01026b3:	e8 88 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026b8:	ba 00 10 00 00       	mov    $0x1000,%edx
f01026bd:	89 f8                	mov    %edi,%eax
f01026bf:	e8 7c e4 ff ff       	call   f0100b40 <check_va2pa>
f01026c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01026c7:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f01026cd:	c1 fa 03             	sar    $0x3,%edx
f01026d0:	c1 e2 0c             	shl    $0xc,%edx
f01026d3:	39 d0                	cmp    %edx,%eax
f01026d5:	74 24                	je     f01026fb <mem_init+0x1063>
f01026d7:	c7 44 24 0c 04 78 10 	movl   $0xf0107804,0xc(%esp)
f01026de:	f0 
f01026df:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01026e6:	f0 
f01026e7:	c7 44 24 04 39 04 00 	movl   $0x439,0x4(%esp)
f01026ee:	00 
f01026ef:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01026f6:	e8 45 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01026fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01026fe:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102703:	74 24                	je     f0102729 <mem_init+0x1091>
f0102705:	c7 44 24 0c a5 7e 10 	movl   $0xf0107ea5,0xc(%esp)
f010270c:	f0 
f010270d:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102714:	f0 
f0102715:	c7 44 24 04 3a 04 00 	movl   $0x43a,0x4(%esp)
f010271c:	00 
f010271d:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102724:	e8 17 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102729:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010272e:	74 24                	je     f0102754 <mem_init+0x10bc>
f0102730:	c7 44 24 0c ff 7e 10 	movl   $0xf0107eff,0xc(%esp)
f0102737:	f0 
f0102738:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010273f:	f0 
f0102740:	c7 44 24 04 3b 04 00 	movl   $0x43b,0x4(%esp)
f0102747:	00 
f0102748:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010274f:	e8 ec d8 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102754:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010275b:	00 
f010275c:	89 3c 24             	mov    %edi,(%esp)
f010275f:	e8 e1 ed ff ff       	call   f0101545 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102764:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
f010276a:	ba 00 00 00 00       	mov    $0x0,%edx
f010276f:	89 f8                	mov    %edi,%eax
f0102771:	e8 ca e3 ff ff       	call   f0100b40 <check_va2pa>
f0102776:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102779:	74 24                	je     f010279f <mem_init+0x1107>
f010277b:	c7 44 24 0c 58 78 10 	movl   $0xf0107858,0xc(%esp)
f0102782:	f0 
f0102783:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010278a:	f0 
f010278b:	c7 44 24 04 3f 04 00 	movl   $0x43f,0x4(%esp)
f0102792:	00 
f0102793:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010279a:	e8 a1 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010279f:	ba 00 10 00 00       	mov    $0x1000,%edx
f01027a4:	89 f8                	mov    %edi,%eax
f01027a6:	e8 95 e3 ff ff       	call   f0100b40 <check_va2pa>
f01027ab:	83 f8 ff             	cmp    $0xffffffff,%eax
f01027ae:	74 24                	je     f01027d4 <mem_init+0x113c>
f01027b0:	c7 44 24 0c 7c 78 10 	movl   $0xf010787c,0xc(%esp)
f01027b7:	f0 
f01027b8:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01027bf:	f0 
f01027c0:	c7 44 24 04 40 04 00 	movl   $0x440,0x4(%esp)
f01027c7:	00 
f01027c8:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01027cf:	e8 6c d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01027d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01027d7:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01027dc:	74 24                	je     f0102802 <mem_init+0x116a>
f01027de:	c7 44 24 0c 10 7f 10 	movl   $0xf0107f10,0xc(%esp)
f01027e5:	f0 
f01027e6:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01027ed:	f0 
f01027ee:	c7 44 24 04 41 04 00 	movl   $0x441,0x4(%esp)
f01027f5:	00 
f01027f6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01027fd:	e8 3e d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102802:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102807:	74 24                	je     f010282d <mem_init+0x1195>
f0102809:	c7 44 24 0c ff 7e 10 	movl   $0xf0107eff,0xc(%esp)
f0102810:	f0 
f0102811:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102818:	f0 
f0102819:	c7 44 24 04 42 04 00 	movl   $0x442,0x4(%esp)
f0102820:	00 
f0102821:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102828:	e8 13 d8 ff ff       	call   f0100040 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010282d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102834:	e8 f5 e9 ff ff       	call   f010122e <page_alloc>
f0102839:	85 c0                	test   %eax,%eax
f010283b:	74 05                	je     f0102842 <mem_init+0x11aa>
f010283d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102840:	74 24                	je     f0102866 <mem_init+0x11ce>
f0102842:	c7 44 24 0c a4 78 10 	movl   $0xf01078a4,0xc(%esp)
f0102849:	f0 
f010284a:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102851:	f0 
f0102852:	c7 44 24 04 45 04 00 	movl   $0x445,0x4(%esp)
f0102859:	00 
f010285a:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102861:	e8 da d7 ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102866:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010286d:	e8 bc e9 ff ff       	call   f010122e <page_alloc>
f0102872:	85 c0                	test   %eax,%eax
f0102874:	74 24                	je     f010289a <mem_init+0x1202>
f0102876:	c7 44 24 0c 53 7e 10 	movl   $0xf0107e53,0xc(%esp)
f010287d:	f0 
f010287e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102885:	f0 
f0102886:	c7 44 24 04 48 04 00 	movl   $0x448,0x4(%esp)
f010288d:	00 
f010288e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102895:	e8 a6 d7 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010289a:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010289f:	8b 08                	mov    (%eax),%ecx
f01028a1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01028a7:	89 f2                	mov    %esi,%edx
f01028a9:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f01028af:	c1 fa 03             	sar    $0x3,%edx
f01028b2:	c1 e2 0c             	shl    $0xc,%edx
f01028b5:	39 d1                	cmp    %edx,%ecx
f01028b7:	74 24                	je     f01028dd <mem_init+0x1245>
f01028b9:	c7 44 24 0c 80 75 10 	movl   $0xf0107580,0xc(%esp)
f01028c0:	f0 
f01028c1:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01028c8:	f0 
f01028c9:	c7 44 24 04 4b 04 00 	movl   $0x44b,0x4(%esp)
f01028d0:	00 
f01028d1:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01028d8:	e8 63 d7 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f01028dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f01028e3:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01028e8:	74 24                	je     f010290e <mem_init+0x1276>
f01028ea:	c7 44 24 0c b6 7e 10 	movl   $0xf0107eb6,0xc(%esp)
f01028f1:	f0 
f01028f2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01028f9:	f0 
f01028fa:	c7 44 24 04 4d 04 00 	movl   $0x44d,0x4(%esp)
f0102901:	00 
f0102902:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102909:	e8 32 d7 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f010290e:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102914:	89 34 24             	mov    %esi,(%esp)
f0102917:	e8 97 e9 ff ff       	call   f01012b3 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f010291c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102923:	00 
f0102924:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f010292b:	00 
f010292c:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102931:	89 04 24             	mov    %eax,(%esp)
f0102934:	e8 bd e9 ff ff       	call   f01012f6 <pgdir_walk>
f0102939:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010293c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010293f:	8b 15 8c 3e 20 f0    	mov    0xf0203e8c,%edx
f0102945:	8b 7a 04             	mov    0x4(%edx),%edi
f0102948:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010294e:	8b 0d 88 3e 20 f0    	mov    0xf0203e88,%ecx
f0102954:	89 f8                	mov    %edi,%eax
f0102956:	c1 e8 0c             	shr    $0xc,%eax
f0102959:	39 c8                	cmp    %ecx,%eax
f010295b:	72 20                	jb     f010297d <mem_init+0x12e5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010295d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0102961:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0102968:	f0 
f0102969:	c7 44 24 04 54 04 00 	movl   $0x454,0x4(%esp)
f0102970:	00 
f0102971:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102978:	e8 c3 d6 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f010297d:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0102983:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0102986:	74 24                	je     f01029ac <mem_init+0x1314>
f0102988:	c7 44 24 0c 21 7f 10 	movl   $0xf0107f21,0xc(%esp)
f010298f:	f0 
f0102990:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102997:	f0 
f0102998:	c7 44 24 04 55 04 00 	movl   $0x455,0x4(%esp)
f010299f:	00 
f01029a0:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01029a7:	e8 94 d6 ff ff       	call   f0100040 <_panic>
	kern_pgdir[PDX(va)] = 0;
f01029ac:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	pp0->pp_ref = 0;
f01029b3:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01029b9:	89 f0                	mov    %esi,%eax
f01029bb:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f01029c1:	c1 f8 03             	sar    $0x3,%eax
f01029c4:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01029c7:	89 c2                	mov    %eax,%edx
f01029c9:	c1 ea 0c             	shr    $0xc,%edx
f01029cc:	39 d1                	cmp    %edx,%ecx
f01029ce:	77 20                	ja     f01029f0 <mem_init+0x1358>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01029d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01029d4:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f01029db:	f0 
f01029dc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01029e3:	00 
f01029e4:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f01029eb:	e8 50 d6 ff ff       	call   f0100040 <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01029f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01029f7:	00 
f01029f8:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f01029ff:	00 
	return (void *)(pa + KERNBASE);
f0102a00:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102a05:	89 04 24             	mov    %eax,(%esp)
f0102a08:	e8 ac 35 00 00       	call   f0105fb9 <memset>
	page_free(pp0);
f0102a0d:	89 34 24             	mov    %esi,(%esp)
f0102a10:	e8 9e e8 ff ff       	call   f01012b3 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102a15:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102a1c:	00 
f0102a1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102a24:	00 
f0102a25:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102a2a:	89 04 24             	mov    %eax,(%esp)
f0102a2d:	e8 c4 e8 ff ff       	call   f01012f6 <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102a32:	89 f2                	mov    %esi,%edx
f0102a34:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f0102a3a:	c1 fa 03             	sar    $0x3,%edx
f0102a3d:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102a40:	89 d0                	mov    %edx,%eax
f0102a42:	c1 e8 0c             	shr    $0xc,%eax
f0102a45:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0102a4b:	72 20                	jb     f0102a6d <mem_init+0x13d5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102a4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102a51:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0102a58:	f0 
f0102a59:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102a60:	00 
f0102a61:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0102a68:	e8 d3 d5 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102a6d:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102a73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102a76:	f6 82 00 00 00 f0 01 	testb  $0x1,-0x10000000(%edx)
f0102a7d:	75 11                	jne    f0102a90 <mem_init+0x13f8>
f0102a7f:	8d 82 04 00 00 f0    	lea    -0xffffffc(%edx),%eax
f0102a85:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
f0102a8b:	f6 00 01             	testb  $0x1,(%eax)
f0102a8e:	74 24                	je     f0102ab4 <mem_init+0x141c>
f0102a90:	c7 44 24 0c 39 7f 10 	movl   $0xf0107f39,0xc(%esp)
f0102a97:	f0 
f0102a98:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102a9f:	f0 
f0102aa0:	c7 44 24 04 5f 04 00 	movl   $0x45f,0x4(%esp)
f0102aa7:	00 
f0102aa8:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102aaf:	e8 8c d5 ff ff       	call   f0100040 <_panic>
f0102ab4:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102ab7:	39 d0                	cmp    %edx,%eax
f0102ab9:	75 d0                	jne    f0102a8b <mem_init+0x13f3>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102abb:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102ac6:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// give free list back
	page_free_list = fl;
f0102acc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102acf:	a3 44 32 20 f0       	mov    %eax,0xf0203244

	// free the pages we took
	page_free(pp0);
f0102ad4:	89 34 24             	mov    %esi,(%esp)
f0102ad7:	e8 d7 e7 ff ff       	call   f01012b3 <page_free>
	page_free(pp1);
f0102adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102adf:	89 04 24             	mov    %eax,(%esp)
f0102ae2:	e8 cc e7 ff ff       	call   f01012b3 <page_free>
	page_free(pp2);
f0102ae7:	89 1c 24             	mov    %ebx,(%esp)
f0102aea:	e8 c4 e7 ff ff       	call   f01012b3 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102aef:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f0102af6:	00 
f0102af7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102afe:	e8 4d eb ff ff       	call   f0101650 <mmio_map_region>
f0102b03:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102b05:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102b0c:	00 
f0102b0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102b14:	e8 37 eb ff ff       	call   f0101650 <mmio_map_region>
f0102b19:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102b1b:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102b21:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102b26:	77 08                	ja     f0102b30 <mem_init+0x1498>
f0102b28:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102b2e:	77 24                	ja     f0102b54 <mem_init+0x14bc>
f0102b30:	c7 44 24 0c c8 78 10 	movl   $0xf01078c8,0xc(%esp)
f0102b37:	f0 
f0102b38:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102b3f:	f0 
f0102b40:	c7 44 24 04 6f 04 00 	movl   $0x46f,0x4(%esp)
f0102b47:	00 
f0102b48:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102b4f:	e8 ec d4 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102b54:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f0102b5a:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102b60:	77 08                	ja     f0102b6a <mem_init+0x14d2>
f0102b62:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102b68:	77 24                	ja     f0102b8e <mem_init+0x14f6>
f0102b6a:	c7 44 24 0c f0 78 10 	movl   $0xf01078f0,0xc(%esp)
f0102b71:	f0 
f0102b72:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102b79:	f0 
f0102b7a:	c7 44 24 04 70 04 00 	movl   $0x470,0x4(%esp)
f0102b81:	00 
f0102b82:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102b89:	e8 b2 d4 ff ff       	call   f0100040 <_panic>
f0102b8e:	89 da                	mov    %ebx,%edx
f0102b90:	09 f2                	or     %esi,%edx
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102b92:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102b98:	74 24                	je     f0102bbe <mem_init+0x1526>
f0102b9a:	c7 44 24 0c 18 79 10 	movl   $0xf0107918,0xc(%esp)
f0102ba1:	f0 
f0102ba2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102ba9:	f0 
f0102baa:	c7 44 24 04 72 04 00 	movl   $0x472,0x4(%esp)
f0102bb1:	00 
f0102bb2:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102bb9:	e8 82 d4 ff ff       	call   f0100040 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102bbe:	39 c6                	cmp    %eax,%esi
f0102bc0:	73 24                	jae    f0102be6 <mem_init+0x154e>
f0102bc2:	c7 44 24 0c 50 7f 10 	movl   $0xf0107f50,0xc(%esp)
f0102bc9:	f0 
f0102bca:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102bd1:	f0 
f0102bd2:	c7 44 24 04 74 04 00 	movl   $0x474,0x4(%esp)
f0102bd9:	00 
f0102bda:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102be1:	e8 5a d4 ff ff       	call   f0100040 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102be6:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi
f0102bec:	89 da                	mov    %ebx,%edx
f0102bee:	89 f8                	mov    %edi,%eax
f0102bf0:	e8 4b df ff ff       	call   f0100b40 <check_va2pa>
f0102bf5:	85 c0                	test   %eax,%eax
f0102bf7:	74 24                	je     f0102c1d <mem_init+0x1585>
f0102bf9:	c7 44 24 0c 40 79 10 	movl   $0xf0107940,0xc(%esp)
f0102c00:	f0 
f0102c01:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102c08:	f0 
f0102c09:	c7 44 24 04 76 04 00 	movl   $0x476,0x4(%esp)
f0102c10:	00 
f0102c11:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102c18:	e8 23 d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c1d:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102c23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102c26:	89 c2                	mov    %eax,%edx
f0102c28:	89 f8                	mov    %edi,%eax
f0102c2a:	e8 11 df ff ff       	call   f0100b40 <check_va2pa>
f0102c2f:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102c34:	74 24                	je     f0102c5a <mem_init+0x15c2>
f0102c36:	c7 44 24 0c 64 79 10 	movl   $0xf0107964,0xc(%esp)
f0102c3d:	f0 
f0102c3e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102c45:	f0 
f0102c46:	c7 44 24 04 77 04 00 	movl   $0x477,0x4(%esp)
f0102c4d:	00 
f0102c4e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102c55:	e8 e6 d3 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c5a:	89 f2                	mov    %esi,%edx
f0102c5c:	89 f8                	mov    %edi,%eax
f0102c5e:	e8 dd de ff ff       	call   f0100b40 <check_va2pa>
f0102c63:	85 c0                	test   %eax,%eax
f0102c65:	74 24                	je     f0102c8b <mem_init+0x15f3>
f0102c67:	c7 44 24 0c 94 79 10 	movl   $0xf0107994,0xc(%esp)
f0102c6e:	f0 
f0102c6f:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102c76:	f0 
f0102c77:	c7 44 24 04 78 04 00 	movl   $0x478,0x4(%esp)
f0102c7e:	00 
f0102c7f:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102c86:	e8 b5 d3 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c8b:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102c91:	89 f8                	mov    %edi,%eax
f0102c93:	e8 a8 de ff ff       	call   f0100b40 <check_va2pa>
f0102c98:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102c9b:	74 24                	je     f0102cc1 <mem_init+0x1629>
f0102c9d:	c7 44 24 0c b8 79 10 	movl   $0xf01079b8,0xc(%esp)
f0102ca4:	f0 
f0102ca5:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102cac:	f0 
f0102cad:	c7 44 24 04 79 04 00 	movl   $0x479,0x4(%esp)
f0102cb4:	00 
f0102cb5:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102cbc:	e8 7f d3 ff ff       	call   f0100040 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102cc1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102cc8:	00 
f0102cc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102ccd:	89 3c 24             	mov    %edi,(%esp)
f0102cd0:	e8 21 e6 ff ff       	call   f01012f6 <pgdir_walk>
f0102cd5:	f6 00 1a             	testb  $0x1a,(%eax)
f0102cd8:	75 24                	jne    f0102cfe <mem_init+0x1666>
f0102cda:	c7 44 24 0c e4 79 10 	movl   $0xf01079e4,0xc(%esp)
f0102ce1:	f0 
f0102ce2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102ce9:	f0 
f0102cea:	c7 44 24 04 7b 04 00 	movl   $0x47b,0x4(%esp)
f0102cf1:	00 
f0102cf2:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102cf9:	e8 42 d3 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cfe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102d05:	00 
f0102d06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102d0a:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102d0f:	89 04 24             	mov    %eax,(%esp)
f0102d12:	e8 df e5 ff ff       	call   f01012f6 <pgdir_walk>
f0102d17:	f6 00 04             	testb  $0x4,(%eax)
f0102d1a:	74 24                	je     f0102d40 <mem_init+0x16a8>
f0102d1c:	c7 44 24 0c 28 7a 10 	movl   $0xf0107a28,0xc(%esp)
f0102d23:	f0 
f0102d24:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102d2b:	f0 
f0102d2c:	c7 44 24 04 7c 04 00 	movl   $0x47c,0x4(%esp)
f0102d33:	00 
f0102d34:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102d3b:	e8 00 d3 ff ff       	call   f0100040 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102d40:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102d47:	00 
f0102d48:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102d4c:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102d51:	89 04 24             	mov    %eax,(%esp)
f0102d54:	e8 9d e5 ff ff       	call   f01012f6 <pgdir_walk>
f0102d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102d5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102d66:	00 
f0102d67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102d6e:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102d73:	89 04 24             	mov    %eax,(%esp)
f0102d76:	e8 7b e5 ff ff       	call   f01012f6 <pgdir_walk>
f0102d7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102d81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102d88:	00 
f0102d89:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102d8d:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102d92:	89 04 24             	mov    %eax,(%esp)
f0102d95:	e8 5c e5 ff ff       	call   f01012f6 <pgdir_walk>
f0102d9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102da0:	c7 04 24 62 7f 10 f0 	movl   $0xf0107f62,(%esp)
f0102da7:	e8 c5 13 00 00       	call   f0104171 <cprintf>
	// boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U | PTE_P);

	// 关于size应该是PTSIZE?还是sizeof(struct PageInfo) * npages ?
	// 根据下面check_kern_pgdir可以看出应该是 sizeof(struct PageInfo) * npages
	// 不是memlayout中所指的PTSIZE
	boot_map_region(kern_pgdir, UPAGES, sizeof(struct PageInfo) * npages,
f0102dac:	a1 90 3e 20 f0       	mov    0xf0203e90,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102db1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102db6:	77 20                	ja     f0102dd8 <mem_init+0x1740>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102db8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102dbc:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0102dc3:	f0 
f0102dc4:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
f0102dcb:	00 
f0102dcc:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102dd3:	e8 68 d2 ff ff       	call   f0100040 <_panic>
f0102dd8:	8b 0d 88 3e 20 f0    	mov    0xf0203e88,%ecx
f0102dde:	c1 e1 03             	shl    $0x3,%ecx
f0102de1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0102de8:	00 
	return (physaddr_t)kva - KERNBASE;
f0102de9:	05 00 00 00 10       	add    $0x10000000,%eax
f0102dee:	89 04 24             	mov    %eax,(%esp)
f0102df1:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102df6:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102dfb:	e8 05 e6 ff ff       	call   f0101405 <boot_map_region>
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	// Map [UENVS, UENVS + size) => Pysical [PADDR(envs) ~)
	// 根据下面check_kern_pgdir可以看出应该是 sizeof(struct Env) * NENV
	// 不是memlayout中所指的PTSIZE
	boot_map_region(kern_pgdir, UENVS, sizeof(struct Env) * NENV,
f0102e00:	a1 4c 32 20 f0       	mov    0xf020324c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102e05:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102e0a:	77 20                	ja     f0102e2c <mem_init+0x1794>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e10:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0102e17:	f0 
f0102e18:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
f0102e1f:	00 
f0102e20:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102e27:	e8 14 d2 ff ff       	call   f0100040 <_panic>
f0102e2c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0102e33:	00 
	return (physaddr_t)kva - KERNBASE;
f0102e34:	05 00 00 00 10       	add    $0x10000000,%eax
f0102e39:	89 04 24             	mov    %eax,(%esp)
f0102e3c:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102e41:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102e46:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102e4b:	e8 b5 e5 ff ff       	call   f0101405 <boot_map_region>
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
	size_t size = ROUNDUP(0xFFFFFFFF - KERNBASE + 1, PGSIZE);
	boot_map_region(kern_pgdir, KERNBASE, size, 0, PTE_W | PTE_P);
f0102e50:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102e57:	00 
f0102e58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102e5f:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102e64:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102e69:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102e6e:	e8 92 e5 ff ff       	call   f0101405 <boot_map_region>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102e73:	b8 00 50 20 f0       	mov    $0xf0205000,%eax
f0102e78:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102e7d:	0f 87 dd 07 00 00    	ja     f0103660 <mem_init+0x1fc8>
f0102e83:	eb 0d                	jmp    f0102e92 <mem_init+0x17fa>
	uint32_t per_cpu_stack_top = KSTACKTOP;
	int i = 0;
	for (; i < NCPU; ++i) {
		uint32_t per_cpu_stack_bot = per_cpu_stack_top - KSTKSIZE;
		boot_map_region(kern_pgdir, per_cpu_stack_bot, KSTKSIZE,
										PADDR((void*)percpu_kstacks[i]), PTE_W | PTE_P);
f0102e85:	89 d8                	mov    %ebx,%eax
f0102e87:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102e8d:	77 28                	ja     f0102eb7 <mem_init+0x181f>
f0102e8f:	90                   	nop
f0102e90:	eb 05                	jmp    f0102e97 <mem_init+0x17ff>
f0102e92:	b8 00 50 20 f0       	mov    $0xf0205000,%eax
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e97:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e9b:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0102ea2:	f0 
f0102ea3:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
f0102eaa:	00 
f0102eab:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102eb2:	e8 89 d1 ff ff       	call   f0100040 <_panic>
	// LAB 4: Your code here:
	uint32_t per_cpu_stack_top = KSTACKTOP;
	int i = 0;
	for (; i < NCPU; ++i) {
		uint32_t per_cpu_stack_bot = per_cpu_stack_top - KSTKSIZE;
		boot_map_region(kern_pgdir, per_cpu_stack_bot, KSTKSIZE,
f0102eb7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102ebe:	00 
f0102ebf:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102ec5:	89 04 24             	mov    %eax,(%esp)
f0102ec8:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102ecd:	89 f2                	mov    %esi,%edx
f0102ecf:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0102ed4:	e8 2c e5 ff ff       	call   f0101405 <boot_map_region>
f0102ed9:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102edf:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:
	uint32_t per_cpu_stack_top = KSTACKTOP;
	int i = 0;
	for (; i < NCPU; ++i) {
f0102ee5:	39 fb                	cmp    %edi,%ebx
f0102ee7:	75 9c                	jne    f0102e85 <mem_init+0x17ed>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0102ee9:	8b 3d 8c 3e 20 f0    	mov    0xf0203e8c,%edi

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102eef:	a1 88 3e 20 f0       	mov    0xf0203e88,%eax
f0102ef4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102ef7:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
	for (i = 0; i < n; i += PGSIZE) {
f0102efe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102f03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102f06:	75 30                	jne    f0102f38 <mem_init+0x18a0>
	}

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102f08:	8b 1d 4c 32 20 f0    	mov    0xf020324c,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102f0e:	89 de                	mov    %ebx,%esi
f0102f10:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102f15:	89 f8                	mov    %edi,%eax
f0102f17:	e8 24 dc ff ff       	call   f0100b40 <check_va2pa>
f0102f1c:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102f22:	0f 86 94 00 00 00    	jbe    f0102fbc <mem_init+0x1924>
f0102f28:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102f2d:	81 c6 00 00 40 21    	add    $0x21400000,%esi
f0102f33:	e9 a4 00 00 00       	jmp    f0102fdc <mem_init+0x1944>
	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102f38:	8b 1d 90 3e 20 f0    	mov    0xf0203e90,%ebx
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
f0102f3e:	8d b3 00 00 00 10    	lea    0x10000000(%ebx),%esi
f0102f44:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102f49:	89 f8                	mov    %edi,%eax
f0102f4b:	e8 f0 db ff ff       	call   f0100b40 <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102f50:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102f56:	77 20                	ja     f0102f78 <mem_init+0x18e0>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f58:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102f5c:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0102f63:	f0 
f0102f64:	c7 44 24 04 94 03 00 	movl   $0x394,0x4(%esp)
f0102f6b:	00 
f0102f6c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102f73:	e8 c8 d0 ff ff       	call   f0100040 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
f0102f78:	ba 00 00 00 00       	mov    $0x0,%edx
f0102f7d:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102f80:	39 c1                	cmp    %eax,%ecx
f0102f82:	74 24                	je     f0102fa8 <mem_init+0x1910>
f0102f84:	c7 44 24 0c 5c 7a 10 	movl   $0xf0107a5c,0xc(%esp)
f0102f8b:	f0 
f0102f8c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102f93:	f0 
f0102f94:	c7 44 24 04 94 03 00 	movl   $0x394,0x4(%esp)
f0102f9b:	00 
f0102f9c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102fa3:	e8 98 d0 ff ff       	call   f0100040 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
f0102fa8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0102fae:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102fb1:	0f 87 fe 06 00 00    	ja     f01036b5 <mem_init+0x201d>
f0102fb7:	e9 4c ff ff ff       	jmp    f0102f08 <mem_init+0x1870>
f0102fbc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102fc0:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0102fc7:	f0 
f0102fc8:	c7 44 24 04 9a 03 00 	movl   $0x39a,0x4(%esp)
f0102fcf:	00 
f0102fd0:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0102fd7:	e8 64 d0 ff ff       	call   f0100040 <_panic>
f0102fdc:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
	}

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102fdf:	39 d0                	cmp    %edx,%eax
f0102fe1:	74 24                	je     f0103007 <mem_init+0x196f>
f0102fe3:	c7 44 24 0c 90 7a 10 	movl   $0xf0107a90,0xc(%esp)
f0102fea:	f0 
f0102feb:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0102ff2:	f0 
f0102ff3:	c7 44 24 04 9a 03 00 	movl   $0x39a,0x4(%esp)
f0102ffa:	00 
f0102ffb:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103002:	e8 39 d0 ff ff       	call   f0100040 <_panic>
f0103007:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
	}

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f010300d:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0103013:	0f 85 8c 06 00 00    	jne    f01036a5 <mem_init+0x200d>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE) {
f0103019:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010301c:	c1 e6 0c             	shl    $0xc,%esi
f010301f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103024:	85 f6                	test   %esi,%esi
f0103026:	75 22                	jne    f010304a <mem_init+0x19b2>
f0103028:	c7 45 d0 00 50 20 f0 	movl   $0xf0205000,-0x30(%ebp)
f010302f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
f0103036:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010303b:	b8 00 50 20 f0       	mov    $0xf0205000,%eax
f0103040:	05 00 80 00 20       	add    $0x20008000,%eax
f0103045:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0103048:	eb 41                	jmp    f010308b <mem_init+0x19f3>
f010304a:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0103050:	89 f8                	mov    %edi,%eax
f0103052:	e8 e9 da ff ff       	call   f0100b40 <check_va2pa>
f0103057:	39 c3                	cmp    %eax,%ebx
f0103059:	74 24                	je     f010307f <mem_init+0x19e7>
f010305b:	c7 44 24 0c c4 7a 10 	movl   $0xf0107ac4,0xc(%esp)
f0103062:	f0 
f0103063:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010306a:	f0 
f010306b:	c7 44 24 04 9e 03 00 	movl   $0x39e,0x4(%esp)
f0103072:	00 
f0103073:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010307a:	e8 c1 cf ff ff       	call   f0100040 <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE) {
f010307f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103085:	39 f3                	cmp    %esi,%ebx
f0103087:	72 c1                	jb     f010304a <mem_init+0x19b2>
f0103089:	eb 9d                	jmp    f0103028 <mem_init+0x1990>
f010308b:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0103091:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103094:	89 f2                	mov    %esi,%edx
f0103096:	89 f8                	mov    %edi,%eax
f0103098:	e8 a3 da ff ff       	call   f0100b40 <check_va2pa>
f010309d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01030a0:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01030a6:	77 20                	ja     f01030c8 <mem_init+0x1a30>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01030ac:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f01030b3:	f0 
f01030b4:	c7 44 24 04 a7 03 00 	movl   $0x3a7,0x4(%esp)
f01030bb:	00 
f01030bc:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01030c3:	e8 78 cf ff ff       	call   f0100040 <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01030c8:	89 f3                	mov    %esi,%ebx
f01030ca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01030cd:	03 4d cc             	add    -0x34(%ebp),%ecx
f01030d0:	89 75 c8             	mov    %esi,-0x38(%ebp)
f01030d3:	89 ce                	mov    %ecx,%esi
f01030d5:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01030d8:	39 c2                	cmp    %eax,%edx
f01030da:	74 24                	je     f0103100 <mem_init+0x1a68>
f01030dc:	c7 44 24 0c ec 7a 10 	movl   $0xf0107aec,0xc(%esp)
f01030e3:	f0 
f01030e4:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01030eb:	f0 
f01030ec:	c7 44 24 04 a7 03 00 	movl   $0x3a7,0x4(%esp)
f01030f3:	00 
f01030f4:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01030fb:	e8 40 cf ff ff       	call   f0100040 <_panic>
f0103100:	81 c3 00 10 00 00    	add    $0x1000,%ebx

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103106:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0103109:	0f 85 88 05 00 00    	jne    f0103697 <mem_init+0x1fff>
f010310f:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0103112:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f0103118:	89 da                	mov    %ebx,%edx
f010311a:	89 f8                	mov    %edi,%eax
f010311c:	e8 1f da ff ff       	call   f0100b40 <check_va2pa>
f0103121:	83 f8 ff             	cmp    $0xffffffff,%eax
f0103124:	74 24                	je     f010314a <mem_init+0x1ab2>
f0103126:	c7 44 24 0c 34 7b 10 	movl   $0xf0107b34,0xc(%esp)
f010312d:	f0 
f010312e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0103135:	f0 
f0103136:	c7 44 24 04 a9 03 00 	movl   $0x3a9,0x4(%esp)
f010313d:	00 
f010313e:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103145:	e8 f6 ce ff ff       	call   f0100040 <_panic>
f010314a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103150:	39 f3                	cmp    %esi,%ebx
f0103152:	75 c4                	jne    f0103118 <mem_init+0x1a80>
f0103154:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f010315a:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0103161:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
	}

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f0103168:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f010316e:	0f 85 17 ff ff ff    	jne    f010308b <mem_init+0x19f3>
f0103174:	b8 00 00 00 00       	mov    $0x0,%eax
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0103179:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f010317f:	83 fa 04             	cmp    $0x4,%edx
f0103182:	77 2e                	ja     f01031b2 <mem_init+0x1b1a>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f0103184:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0103188:	0f 85 aa 00 00 00    	jne    f0103238 <mem_init+0x1ba0>
f010318e:	c7 44 24 0c 7b 7f 10 	movl   $0xf0107f7b,0xc(%esp)
f0103195:	f0 
f0103196:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010319d:	f0 
f010319e:	c7 44 24 04 b4 03 00 	movl   $0x3b4,0x4(%esp)
f01031a5:	00 
f01031a6:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01031ad:	e8 8e ce ff ff       	call   f0100040 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01031b2:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f01031b7:	76 55                	jbe    f010320e <mem_init+0x1b76>
				// // if (!(pgdir[i] & PTE_P)) {
				// 	cprintf("pgdir[%d] = %x\n", i, pgdir[i]);
				// // }
				assert(pgdir[i] & PTE_P);
f01031b9:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01031bc:	f6 c2 01             	test   $0x1,%dl
f01031bf:	75 24                	jne    f01031e5 <mem_init+0x1b4d>
f01031c1:	c7 44 24 0c 7b 7f 10 	movl   $0xf0107f7b,0xc(%esp)
f01031c8:	f0 
f01031c9:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01031d0:	f0 
f01031d1:	c7 44 24 04 bb 03 00 	movl   $0x3bb,0x4(%esp)
f01031d8:	00 
f01031d9:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01031e0:	e8 5b ce ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f01031e5:	f6 c2 02             	test   $0x2,%dl
f01031e8:	75 4e                	jne    f0103238 <mem_init+0x1ba0>
f01031ea:	c7 44 24 0c 8c 7f 10 	movl   $0xf0107f8c,0xc(%esp)
f01031f1:	f0 
f01031f2:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01031f9:	f0 
f01031fa:	c7 44 24 04 bc 03 00 	movl   $0x3bc,0x4(%esp)
f0103201:	00 
f0103202:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103209:	e8 32 ce ff ff       	call   f0100040 <_panic>
			} else
				assert(pgdir[i] == 0);
f010320e:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0103212:	74 24                	je     f0103238 <mem_init+0x1ba0>
f0103214:	c7 44 24 0c 9d 7f 10 	movl   $0xf0107f9d,0xc(%esp)
f010321b:	f0 
f010321c:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0103223:	f0 
f0103224:	c7 44 24 04 be 03 00 	movl   $0x3be,0x4(%esp)
f010322b:	00 
f010322c:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103233:	e8 08 ce ff ff       	call   f0100040 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0103238:	83 c0 01             	add    $0x1,%eax
f010323b:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103240:	0f 85 33 ff ff ff    	jne    f0103179 <mem_init+0x1ae1>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f0103246:	c7 04 24 58 7b 10 f0 	movl   $0xf0107b58,(%esp)
f010324d:	e8 1f 0f 00 00       	call   f0104171 <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f0103252:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0103257:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010325c:	77 20                	ja     f010327e <mem_init+0x1be6>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010325e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103262:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103269:	f0 
f010326a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
f0103271:	00 
f0103272:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103279:	e8 c2 cd ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010327e:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103283:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f0103286:	b8 00 00 00 00       	mov    $0x0,%eax
f010328b:	e8 9a d9 ff ff       	call   f0100c2a <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103290:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
f0103293:	83 e0 f3             	and    $0xfffffff3,%eax
f0103296:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f010329b:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010329e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01032a5:	e8 84 df ff ff       	call   f010122e <page_alloc>
f01032aa:	89 c3                	mov    %eax,%ebx
f01032ac:	85 c0                	test   %eax,%eax
f01032ae:	75 24                	jne    f01032d4 <mem_init+0x1c3c>
f01032b0:	c7 44 24 0c a8 7d 10 	movl   $0xf0107da8,0xc(%esp)
f01032b7:	f0 
f01032b8:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01032bf:	f0 
f01032c0:	c7 44 24 04 91 04 00 	movl   $0x491,0x4(%esp)
f01032c7:	00 
f01032c8:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01032cf:	e8 6c cd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01032d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01032db:	e8 4e df ff ff       	call   f010122e <page_alloc>
f01032e0:	89 c7                	mov    %eax,%edi
f01032e2:	85 c0                	test   %eax,%eax
f01032e4:	75 24                	jne    f010330a <mem_init+0x1c72>
f01032e6:	c7 44 24 0c be 7d 10 	movl   $0xf0107dbe,0xc(%esp)
f01032ed:	f0 
f01032ee:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01032f5:	f0 
f01032f6:	c7 44 24 04 92 04 00 	movl   $0x492,0x4(%esp)
f01032fd:	00 
f01032fe:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103305:	e8 36 cd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010330a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103311:	e8 18 df ff ff       	call   f010122e <page_alloc>
f0103316:	89 c6                	mov    %eax,%esi
f0103318:	85 c0                	test   %eax,%eax
f010331a:	75 24                	jne    f0103340 <mem_init+0x1ca8>
f010331c:	c7 44 24 0c d4 7d 10 	movl   $0xf0107dd4,0xc(%esp)
f0103323:	f0 
f0103324:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010332b:	f0 
f010332c:	c7 44 24 04 93 04 00 	movl   $0x493,0x4(%esp)
f0103333:	00 
f0103334:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010333b:	e8 00 cd ff ff       	call   f0100040 <_panic>
	page_free(pp0);
f0103340:	89 1c 24             	mov    %ebx,(%esp)
f0103343:	e8 6b df ff ff       	call   f01012b3 <page_free>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103348:	89 f8                	mov    %edi,%eax
f010334a:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0103350:	c1 f8 03             	sar    $0x3,%eax
f0103353:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103356:	89 c2                	mov    %eax,%edx
f0103358:	c1 ea 0c             	shr    $0xc,%edx
f010335b:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f0103361:	72 20                	jb     f0103383 <mem_init+0x1ceb>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103363:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103367:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010336e:	f0 
f010336f:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103376:	00 
f0103377:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f010337e:	e8 bd cc ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp1), 1, PGSIZE);
f0103383:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010338a:	00 
f010338b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0103392:	00 
	return (void *)(pa + KERNBASE);
f0103393:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103398:	89 04 24             	mov    %eax,(%esp)
f010339b:	e8 19 2c 00 00       	call   f0105fb9 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01033a0:	89 f0                	mov    %esi,%eax
f01033a2:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f01033a8:	c1 f8 03             	sar    $0x3,%eax
f01033ab:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01033ae:	89 c2                	mov    %eax,%edx
f01033b0:	c1 ea 0c             	shr    $0xc,%edx
f01033b3:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f01033b9:	72 20                	jb     f01033db <mem_init+0x1d43>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01033bf:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f01033c6:	f0 
f01033c7:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01033ce:	00 
f01033cf:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f01033d6:	e8 65 cc ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp2), 2, PGSIZE);
f01033db:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01033e2:	00 
f01033e3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f01033ea:	00 
	return (void *)(pa + KERNBASE);
f01033eb:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01033f0:	89 04 24             	mov    %eax,(%esp)
f01033f3:	e8 c1 2b 00 00       	call   f0105fb9 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f01033f8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01033ff:	00 
f0103400:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103407:	00 
f0103408:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010340c:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f0103411:	89 04 24             	mov    %eax,(%esp)
f0103414:	e8 75 e1 ff ff       	call   f010158e <page_insert>
	assert(pp1->pp_ref == 1);
f0103419:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010341e:	74 24                	je     f0103444 <mem_init+0x1dac>
f0103420:	c7 44 24 0c a5 7e 10 	movl   $0xf0107ea5,0xc(%esp)
f0103427:	f0 
f0103428:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010342f:	f0 
f0103430:	c7 44 24 04 98 04 00 	movl   $0x498,0x4(%esp)
f0103437:	00 
f0103438:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010343f:	e8 fc cb ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103444:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010344b:	01 01 01 
f010344e:	74 24                	je     f0103474 <mem_init+0x1ddc>
f0103450:	c7 44 24 0c 78 7b 10 	movl   $0xf0107b78,0xc(%esp)
f0103457:	f0 
f0103458:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010345f:	f0 
f0103460:	c7 44 24 04 99 04 00 	movl   $0x499,0x4(%esp)
f0103467:	00 
f0103468:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010346f:	e8 cc cb ff ff       	call   f0100040 <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0103474:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010347b:	00 
f010347c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103483:	00 
f0103484:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103488:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010348d:	89 04 24             	mov    %eax,(%esp)
f0103490:	e8 f9 e0 ff ff       	call   f010158e <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103495:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f010349c:	02 02 02 
f010349f:	74 24                	je     f01034c5 <mem_init+0x1e2d>
f01034a1:	c7 44 24 0c 9c 7b 10 	movl   $0xf0107b9c,0xc(%esp)
f01034a8:	f0 
f01034a9:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01034b0:	f0 
f01034b1:	c7 44 24 04 9b 04 00 	movl   $0x49b,0x4(%esp)
f01034b8:	00 
f01034b9:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01034c0:	e8 7b cb ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01034c5:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01034ca:	74 24                	je     f01034f0 <mem_init+0x1e58>
f01034cc:	c7 44 24 0c c7 7e 10 	movl   $0xf0107ec7,0xc(%esp)
f01034d3:	f0 
f01034d4:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01034db:	f0 
f01034dc:	c7 44 24 04 9c 04 00 	movl   $0x49c,0x4(%esp)
f01034e3:	00 
f01034e4:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01034eb:	e8 50 cb ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01034f0:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01034f5:	74 24                	je     f010351b <mem_init+0x1e83>
f01034f7:	c7 44 24 0c 10 7f 10 	movl   $0xf0107f10,0xc(%esp)
f01034fe:	f0 
f01034ff:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0103506:	f0 
f0103507:	c7 44 24 04 9d 04 00 	movl   $0x49d,0x4(%esp)
f010350e:	00 
f010350f:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f0103516:	e8 25 cb ff ff       	call   f0100040 <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f010351b:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103522:	03 03 03 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103525:	89 f0                	mov    %esi,%eax
f0103527:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f010352d:	c1 f8 03             	sar    $0x3,%eax
f0103530:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103533:	89 c2                	mov    %eax,%edx
f0103535:	c1 ea 0c             	shr    $0xc,%edx
f0103538:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f010353e:	72 20                	jb     f0103560 <mem_init+0x1ec8>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103540:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103544:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010354b:	f0 
f010354c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103553:	00 
f0103554:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f010355b:	e8 e0 ca ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103560:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103567:	03 03 03 
f010356a:	74 24                	je     f0103590 <mem_init+0x1ef8>
f010356c:	c7 44 24 0c c0 7b 10 	movl   $0xf0107bc0,0xc(%esp)
f0103573:	f0 
f0103574:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010357b:	f0 
f010357c:	c7 44 24 04 9f 04 00 	movl   $0x49f,0x4(%esp)
f0103583:	00 
f0103584:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010358b:	e8 b0 ca ff ff       	call   f0100040 <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103590:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103597:	00 
f0103598:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010359d:	89 04 24             	mov    %eax,(%esp)
f01035a0:	e8 a0 df ff ff       	call   f0101545 <page_remove>
	assert(pp2->pp_ref == 0);
f01035a5:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01035aa:	74 24                	je     f01035d0 <mem_init+0x1f38>
f01035ac:	c7 44 24 0c ff 7e 10 	movl   $0xf0107eff,0xc(%esp)
f01035b3:	f0 
f01035b4:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01035bb:	f0 
f01035bc:	c7 44 24 04 a1 04 00 	movl   $0x4a1,0x4(%esp)
f01035c3:	00 
f01035c4:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01035cb:	e8 70 ca ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01035d0:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f01035d5:	8b 08                	mov    (%eax),%ecx
f01035d7:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01035dd:	89 da                	mov    %ebx,%edx
f01035df:	2b 15 90 3e 20 f0    	sub    0xf0203e90,%edx
f01035e5:	c1 fa 03             	sar    $0x3,%edx
f01035e8:	c1 e2 0c             	shl    $0xc,%edx
f01035eb:	39 d1                	cmp    %edx,%ecx
f01035ed:	74 24                	je     f0103613 <mem_init+0x1f7b>
f01035ef:	c7 44 24 0c 80 75 10 	movl   $0xf0107580,0xc(%esp)
f01035f6:	f0 
f01035f7:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f01035fe:	f0 
f01035ff:	c7 44 24 04 a4 04 00 	movl   $0x4a4,0x4(%esp)
f0103606:	00 
f0103607:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010360e:	e8 2d ca ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f0103613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103619:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010361e:	74 24                	je     f0103644 <mem_init+0x1fac>
f0103620:	c7 44 24 0c b6 7e 10 	movl   $0xf0107eb6,0xc(%esp)
f0103627:	f0 
f0103628:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010362f:	f0 
f0103630:	c7 44 24 04 a6 04 00 	movl   $0x4a6,0x4(%esp)
f0103637:	00 
f0103638:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f010363f:	e8 fc c9 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f0103644:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f010364a:	89 1c 24             	mov    %ebx,(%esp)
f010364d:	e8 61 dc ff ff       	call   f01012b3 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103652:	c7 04 24 ec 7b 10 f0 	movl   $0xf0107bec,(%esp)
f0103659:	e8 13 0b 00 00       	call   f0104171 <cprintf>
f010365e:	eb 69                	jmp    f01036c9 <mem_init+0x2031>
	// LAB 4: Your code here:
	uint32_t per_cpu_stack_top = KSTACKTOP;
	int i = 0;
	for (; i < NCPU; ++i) {
		uint32_t per_cpu_stack_bot = per_cpu_stack_top - KSTKSIZE;
		boot_map_region(kern_pgdir, per_cpu_stack_bot, KSTKSIZE,
f0103660:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103667:	00 
f0103668:	c7 04 24 00 50 20 00 	movl   $0x205000,(%esp)
f010366f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103674:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103679:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
f010367e:	e8 82 dd ff ff       	call   f0101405 <boot_map_region>
f0103683:	bb 00 d0 20 f0       	mov    $0xf020d000,%ebx
f0103688:	bf 00 50 24 f0       	mov    $0xf0245000,%edi
f010368d:	be 00 80 fe ef       	mov    $0xeffe8000,%esi
f0103692:	e9 ee f7 ff ff       	jmp    f0102e85 <mem_init+0x17ed>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103697:	89 da                	mov    %ebx,%edx
f0103699:	89 f8                	mov    %edi,%eax
f010369b:	e8 a0 d4 ff ff       	call   f0100b40 <check_va2pa>
f01036a0:	e9 30 fa ff ff       	jmp    f01030d5 <mem_init+0x1a3d>
	}

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01036a5:	89 da                	mov    %ebx,%edx
f01036a7:	89 f8                	mov    %edi,%eax
f01036a9:	e8 92 d4 ff ff       	call   f0100b40 <check_va2pa>
f01036ae:	66 90                	xchg   %ax,%ax
f01036b0:	e9 27 f9 ff ff       	jmp    f0102fdc <mem_init+0x1944>
f01036b5:	81 ea 00 f0 ff 10    	sub    $0x10fff000,%edx
	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01036bb:	89 f8                	mov    %edi,%eax
f01036bd:	e8 7e d4 ff ff       	call   f0100b40 <check_va2pa>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
f01036c2:	89 da                	mov    %ebx,%edx
f01036c4:	e9 b4 f8 ff ff       	jmp    f0102f7d <mem_init+0x18e5>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f01036c9:	83 c4 4c             	add    $0x4c,%esp
f01036cc:	5b                   	pop    %ebx
f01036cd:	5e                   	pop    %esi
f01036ce:	5f                   	pop    %edi
f01036cf:	5d                   	pop    %ebp
f01036d0:	c3                   	ret    

f01036d1 <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f01036d1:	55                   	push   %ebp
f01036d2:	89 e5                	mov    %esp,%ebp
f01036d4:	57                   	push   %edi
f01036d5:	56                   	push   %esi
f01036d6:	53                   	push   %ebx
f01036d7:	83 ec 2c             	sub    $0x2c,%esp
f01036da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  // step 1 : check below ULIM
  uintptr_t va_beg = (uintptr_t)va;
  uintptr_t va_end = va_beg + len;
f01036dd:	8b 75 0c             	mov    0xc(%ebp),%esi
f01036e0:	03 75 10             	add    0x10(%ebp),%esi
  if (va_beg >= ULIM || va_end >= ULIM) {
f01036e3:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01036e9:	77 09                	ja     f01036f4 <user_mem_check+0x23>
f01036eb:	81 7d 0c ff ff 7f ef 	cmpl   $0xef7fffff,0xc(%ebp)
f01036f2:	76 1f                	jbe    f0103713 <user_mem_check+0x42>
    user_mem_check_addr = (va_beg >= ULIM) ? va_beg : ULIM;
f01036f4:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f01036fb:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f0103700:	0f 43 45 0c          	cmovae 0xc(%ebp),%eax
f0103704:	a3 40 32 20 f0       	mov    %eax,0xf0203240
    return -E_FAULT;
f0103709:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010370e:	e9 e4 00 00 00       	jmp    f01037f7 <user_mem_check+0x126>
  }

  // step 2 : check present & permission
  uintptr_t va_beg2 = ROUNDDOWN(va_beg, PGSIZE);
f0103713:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103716:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uintptr_t va_end2 = ROUNDUP(va_end, PGSIZE);
f010371b:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
f0103721:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  while (va_beg2 < va_end2) {
f0103727:	39 f0                	cmp    %esi,%eax
f0103729:	0f 83 c3 00 00 00    	jae    f01037f2 <user_mem_check+0x121>

    // check page table is present ?
    if (!(env->env_pgdir[PDX(va_beg2)] & PTE_P)) {
f010372f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103732:	8b 7a 60             	mov    0x60(%edx),%edi
f0103735:	89 c2                	mov    %eax,%edx
f0103737:	c1 ea 16             	shr    $0x16,%edx
f010373a:	8b 14 97             	mov    (%edi,%edx,4),%edx
f010373d:	f6 c2 01             	test   $0x1,%dl
f0103740:	74 2b                	je     f010376d <user_mem_check+0x9c>
      user_mem_check_addr = (va_beg2 > va_beg) ? va_beg2 : va_beg;
      return -E_FAULT;
    }

    // get current page table kernel va
    uint32_t* pt_kva = KADDR(PTE_ADDR(env->env_pgdir[PDX(va_beg2)]));
f0103742:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103748:	8b 1d 88 3e 20 f0    	mov    0xf0203e88,%ebx
f010374e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0103751:	89 d3                	mov    %edx,%ebx
f0103753:	c1 eb 0c             	shr    $0xc,%ebx
f0103756:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103759:	72 55                	jb     f01037b0 <user_mem_check+0xdf>
f010375b:	eb 33                	jmp    f0103790 <user_mem_check+0xbf>
  uintptr_t va_beg2 = ROUNDDOWN(va_beg, PGSIZE);
  uintptr_t va_end2 = ROUNDUP(va_end, PGSIZE);
  while (va_beg2 < va_end2) {

    // check page table is present ?
    if (!(env->env_pgdir[PDX(va_beg2)] & PTE_P)) {
f010375d:	89 c2                	mov    %eax,%edx
f010375f:	c1 ea 16             	shr    $0x16,%edx
f0103762:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0103765:	8b 14 97             	mov    (%edi,%edx,4),%edx
f0103768:	f6 c2 01             	test   $0x1,%dl
f010376b:	75 13                	jne    f0103780 <user_mem_check+0xaf>
      user_mem_check_addr = (va_beg2 > va_beg) ? va_beg2 : va_beg;
f010376d:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0103770:	0f 42 45 0c          	cmovb  0xc(%ebp),%eax
f0103774:	a3 40 32 20 f0       	mov    %eax,0xf0203240
      return -E_FAULT;
f0103779:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010377e:	eb 77                	jmp    f01037f7 <user_mem_check+0x126>
    }

    // get current page table kernel va
    uint32_t* pt_kva = KADDR(PTE_ADDR(env->env_pgdir[PDX(va_beg2)]));
f0103780:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0103786:	89 d3                	mov    %edx,%ebx
f0103788:	c1 eb 0c             	shr    $0xc,%ebx
f010378b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010378e:	72 23                	jb     f01037b3 <user_mem_check+0xe2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103790:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103794:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010379b:	f0 
f010379c:	c7 44 24 04 d1 02 00 	movl   $0x2d1,0x4(%esp)
f01037a3:	00 
f01037a4:	c7 04 24 4d 7c 10 f0 	movl   $0xf0107c4d,(%esp)
f01037ab:	e8 90 c8 ff ff       	call   f0100040 <_panic>
f01037b0:	89 7d e0             	mov    %edi,-0x20(%ebp)

    // check page is present & permissions
    if (!((pt_kva[PTX(va_beg2)] & perm) == perm)) {
f01037b3:	89 c3                	mov    %eax,%ebx
f01037b5:	c1 eb 0c             	shr    $0xc,%ebx
f01037b8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f01037be:	89 cf                	mov    %ecx,%edi
f01037c0:	23 bc 9a 00 00 00 f0 	and    -0x10000000(%edx,%ebx,4),%edi
f01037c7:	39 f9                	cmp    %edi,%ecx
f01037c9:	74 13                	je     f01037de <user_mem_check+0x10d>
      user_mem_check_addr = (va_beg2 > va_beg) ? va_beg2 : va_beg;
f01037cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
f01037ce:	0f 42 45 0c          	cmovb  0xc(%ebp),%eax
f01037d2:	a3 40 32 20 f0       	mov    %eax,0xf0203240
      return -E_FAULT;
f01037d7:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01037dc:	eb 19                	jmp    f01037f7 <user_mem_check+0x126>
    }

    va_beg2 += PGSIZE;
f01037de:	05 00 10 00 00       	add    $0x1000,%eax
  }

  // step 2 : check present & permission
  uintptr_t va_beg2 = ROUNDDOWN(va_beg, PGSIZE);
  uintptr_t va_end2 = ROUNDUP(va_end, PGSIZE);
  while (va_beg2 < va_end2) {
f01037e3:	39 c6                	cmp    %eax,%esi
f01037e5:	0f 87 72 ff ff ff    	ja     f010375d <user_mem_check+0x8c>
      return -E_FAULT;
    }

    va_beg2 += PGSIZE;
  }
  return 0;
f01037eb:	b8 00 00 00 00       	mov    $0x0,%eax
f01037f0:	eb 05                	jmp    f01037f7 <user_mem_check+0x126>
f01037f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01037f7:	83 c4 2c             	add    $0x2c,%esp
f01037fa:	5b                   	pop    %ebx
f01037fb:	5e                   	pop    %esi
f01037fc:	5f                   	pop    %edi
f01037fd:	5d                   	pop    %ebp
f01037fe:	c3                   	ret    

f01037ff <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f01037ff:	55                   	push   %ebp
f0103800:	89 e5                	mov    %esp,%ebp
f0103802:	53                   	push   %ebx
f0103803:	83 ec 14             	sub    $0x14,%esp
f0103806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103809:	8b 45 14             	mov    0x14(%ebp),%eax
f010380c:	83 c8 04             	or     $0x4,%eax
f010380f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103813:	8b 45 10             	mov    0x10(%ebp),%eax
f0103816:	89 44 24 08          	mov    %eax,0x8(%esp)
f010381a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010381d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103821:	89 1c 24             	mov    %ebx,(%esp)
f0103824:	e8 a8 fe ff ff       	call   f01036d1 <user_mem_check>
f0103829:	85 c0                	test   %eax,%eax
f010382b:	79 24                	jns    f0103851 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f010382d:	a1 40 32 20 f0       	mov    0xf0203240,%eax
f0103832:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103836:	8b 43 48             	mov    0x48(%ebx),%eax
f0103839:	89 44 24 04          	mov    %eax,0x4(%esp)
f010383d:	c7 04 24 18 7c 10 f0 	movl   $0xf0107c18,(%esp)
f0103844:	e8 28 09 00 00       	call   f0104171 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0103849:	89 1c 24             	mov    %ebx,(%esp)
f010384c:	e8 55 06 00 00       	call   f0103ea6 <env_destroy>
	}
}
f0103851:	83 c4 14             	add    $0x14,%esp
f0103854:	5b                   	pop    %ebx
f0103855:	5d                   	pop    %ebp
f0103856:	c3                   	ret    

f0103857 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103857:	55                   	push   %ebp
f0103858:	89 e5                	mov    %esp,%ebp
f010385a:	57                   	push   %edi
f010385b:	56                   	push   %esi
f010385c:	53                   	push   %ebx
f010385d:	83 ec 1c             	sub    $0x1c,%esp
f0103860:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	uintptr_t va_beg = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0103862:	89 d3                	mov    %edx,%ebx
f0103864:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uintptr_t va_end = ROUNDUP(((uintptr_t)va) + len, PGSIZE);
f010386a:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0103871:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	pte_t* pte;
	while (va_beg < va_end) {
f0103877:	39 f3                	cmp    %esi,%ebx
f0103879:	73 51                	jae    f01038cc <region_alloc+0x75>
		struct PageInfo *page = page_alloc(0);
f010387b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103882:	e8 a7 d9 ff ff       	call   f010122e <page_alloc>
		if (page_insert(e->env_pgdir, page, (void*)va_beg, PTE_W | PTE_U)) {
f0103887:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f010388e:	00 
f010388f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103893:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103897:	8b 47 60             	mov    0x60(%edi),%eax
f010389a:	89 04 24             	mov    %eax,(%esp)
f010389d:	e8 ec dc ff ff       	call   f010158e <page_insert>
f01038a2:	85 c0                	test   %eax,%eax
f01038a4:	74 1c                	je     f01038c2 <region_alloc+0x6b>
			panic("Page talbe couldn't be allocated")	;
f01038a6:	c7 44 24 08 ac 7f 10 	movl   $0xf0107fac,0x8(%esp)
f01038ad:	f0 
f01038ae:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
f01038b5:	00 
f01038b6:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f01038bd:	e8 7e c7 ff ff       	call   f0100040 <_panic>
		}
		va_beg += PGSIZE;
f01038c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	uintptr_t va_beg = ROUNDDOWN((uintptr_t)va, PGSIZE);
	uintptr_t va_end = ROUNDUP(((uintptr_t)va) + len, PGSIZE);
	pte_t* pte;
	while (va_beg < va_end) {
f01038c8:	39 de                	cmp    %ebx,%esi
f01038ca:	77 af                	ja     f010387b <region_alloc+0x24>
		if (page_insert(e->env_pgdir, page, (void*)va_beg, PTE_W | PTE_U)) {
			panic("Page talbe couldn't be allocated")	;
		}
		va_beg += PGSIZE;
	}
}
f01038cc:	83 c4 1c             	add    $0x1c,%esp
f01038cf:	5b                   	pop    %ebx
f01038d0:	5e                   	pop    %esi
f01038d1:	5f                   	pop    %edi
f01038d2:	5d                   	pop    %ebp
f01038d3:	c3                   	ret    

f01038d4 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01038d4:	55                   	push   %ebp
f01038d5:	89 e5                	mov    %esp,%ebp
f01038d7:	56                   	push   %esi
f01038d8:	53                   	push   %ebx
f01038d9:	8b 45 08             	mov    0x8(%ebp),%eax
f01038dc:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f01038df:	85 c0                	test   %eax,%eax
f01038e1:	75 1a                	jne    f01038fd <envid2env+0x29>
		*env_store = curenv;
f01038e3:	e8 6b 2d 00 00       	call   f0106653 <cpunum>
f01038e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01038eb:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01038f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01038f4:	89 01                	mov    %eax,(%ecx)
		return 0;
f01038f6:	b8 00 00 00 00       	mov    $0x0,%eax
f01038fb:	eb 70                	jmp    f010396d <envid2env+0x99>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f01038fd:	89 c3                	mov    %eax,%ebx
f01038ff:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103905:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103908:	03 1d 4c 32 20 f0    	add    0xf020324c,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010390e:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103912:	74 05                	je     f0103919 <envid2env+0x45>
f0103914:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103917:	74 10                	je     f0103929 <envid2env+0x55>
		*env_store = 0;
f0103919:	8b 45 0c             	mov    0xc(%ebp),%eax
f010391c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103922:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103927:	eb 44                	jmp    f010396d <envid2env+0x99>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103929:	84 d2                	test   %dl,%dl
f010392b:	74 36                	je     f0103963 <envid2env+0x8f>
f010392d:	e8 21 2d 00 00       	call   f0106653 <cpunum>
f0103932:	6b c0 74             	imul   $0x74,%eax,%eax
f0103935:	39 98 28 40 20 f0    	cmp    %ebx,-0xfdfbfd8(%eax)
f010393b:	74 26                	je     f0103963 <envid2env+0x8f>
f010393d:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103940:	e8 0e 2d 00 00       	call   f0106653 <cpunum>
f0103945:	6b c0 74             	imul   $0x74,%eax,%eax
f0103948:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f010394e:	3b 70 48             	cmp    0x48(%eax),%esi
f0103951:	74 10                	je     f0103963 <envid2env+0x8f>
		*env_store = 0;
f0103953:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103956:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010395c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103961:	eb 0a                	jmp    f010396d <envid2env+0x99>
	}

	*env_store = e;
f0103963:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103966:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103968:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010396d:	5b                   	pop    %ebx
f010396e:	5e                   	pop    %esi
f010396f:	5d                   	pop    %ebp
f0103970:	c3                   	ret    

f0103971 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103971:	55                   	push   %ebp
f0103972:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103974:	b8 20 13 12 f0       	mov    $0xf0121320,%eax
f0103979:	0f 01 10             	lgdtl  (%eax)
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	// Note:
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f010397c:	b8 23 00 00 00       	mov    $0x23,%eax
f0103981:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103983:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103985:	b0 10                	mov    $0x10,%al
f0103987:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103989:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f010398b:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	// Note: f means forward jump, 1 means jump to lable 1:
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f010398d:	ea 94 39 10 f0 08 00 	ljmp   $0x8,$0xf0103994
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103994:	b0 00                	mov    $0x0,%al
f0103996:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103999:	5d                   	pop    %ebp
f010399a:	c3                   	ret    

f010399b <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f010399b:	55                   	push   %ebp
f010399c:	89 e5                	mov    %esp,%ebp
f010399e:	56                   	push   %esi
f010399f:	53                   	push   %ebx
f01039a0:	83 ec 10             	sub    $0x10,%esp
f01039a3:	be 01 00 00 00       	mov    $0x1,%esi
f01039a8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01039ad:	eb 06                	jmp    f01039b5 <env_init+0x1a>
f01039af:	83 c3 7c             	add    $0x7c,%ebx
f01039b2:	83 c6 01             	add    $0x1,%esi
	// Set up envs array
	int i = 0;
	for (i = 0; i < NENV; ++i) {
		memset(envs + i, 0, sizeof(envs[i]));
f01039b5:	c7 44 24 08 7c 00 00 	movl   $0x7c,0x8(%esp)
f01039bc:	00 
f01039bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01039c4:	00 
f01039c5:	89 d8                	mov    %ebx,%eax
f01039c7:	03 05 4c 32 20 f0    	add    0xf020324c,%eax
f01039cd:	89 04 24             	mov    %eax,(%esp)
f01039d0:	e8 e4 25 00 00       	call   f0105fb9 <memset>
		envs[i].env_id = 0;
f01039d5:	8b 15 4c 32 20 f0    	mov    0xf020324c,%edx
f01039db:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01039de:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = NULL;
f01039e5:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
		if (i == 0) {
f01039ec:	83 fe 01             	cmp    $0x1,%esi
f01039ef:	75 08                	jne    f01039f9 <env_init+0x5e>
			env_free_list = &envs[0];
f01039f1:	89 15 50 32 20 f0    	mov    %edx,0xf0203250
f01039f7:	eb b6                	jmp    f01039af <env_init+0x14>
		} else {
			envs[i-1].env_link = &envs[i];
f01039f9:	89 44 1a c8          	mov    %eax,-0x38(%edx,%ebx,1)
void
env_init(void)
{
	// Set up envs array
	int i = 0;
	for (i = 0; i < NENV; ++i) {
f01039fd:	81 fe ff 03 00 00    	cmp    $0x3ff,%esi
f0103a03:	7e aa                	jle    f01039af <env_init+0x14>
		} else {
			envs[i-1].env_link = &envs[i];
		}
	}
	// Per-CPU part of the initialization
	env_init_percpu();
f0103a05:	e8 67 ff ff ff       	call   f0103971 <env_init_percpu>
}
f0103a0a:	83 c4 10             	add    $0x10,%esp
f0103a0d:	5b                   	pop    %ebx
f0103a0e:	5e                   	pop    %esi
f0103a0f:	5d                   	pop    %ebp
f0103a10:	c3                   	ret    

f0103a11 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103a11:	55                   	push   %ebp
f0103a12:	89 e5                	mov    %esp,%ebp
f0103a14:	53                   	push   %ebx
f0103a15:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103a18:	8b 1d 50 32 20 f0    	mov    0xf0203250,%ebx
f0103a1e:	85 db                	test   %ebx,%ebx
f0103a20:	0f 84 54 01 00 00    	je     f0103b7a <env_alloc+0x169>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103a26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103a2d:	e8 fc d7 ff ff       	call   f010122e <page_alloc>
f0103a32:	85 c0                	test   %eax,%eax
f0103a34:	0f 84 47 01 00 00    	je     f0103b81 <env_alloc+0x170>
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	++p->pp_ref;
f0103a3a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103a3f:	2b 05 90 3e 20 f0    	sub    0xf0203e90,%eax
f0103a45:	c1 f8 03             	sar    $0x3,%eax
f0103a48:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103a4b:	89 c2                	mov    %eax,%edx
f0103a4d:	c1 ea 0c             	shr    $0xc,%edx
f0103a50:	3b 15 88 3e 20 f0    	cmp    0xf0203e88,%edx
f0103a56:	72 20                	jb     f0103a78 <env_alloc+0x67>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103a58:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103a5c:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0103a63:	f0 
f0103a64:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103a6b:	00 
f0103a6c:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0103a73:	e8 c8 c5 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0103a78:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103a7d:	89 43 60             	mov    %eax,0x60(%ebx)
	e->env_pgdir = (pde_t*)page2kva(p);
f0103a80:	b8 00 00 00 00       	mov    $0x0,%eax

	for (i = 0; i < NPDENTRIES; ++i) {
		e->env_pgdir[i] = kern_pgdir[i];
f0103a85:	8b 15 8c 3e 20 f0    	mov    0xf0203e8c,%edx
f0103a8b:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f0103a8e:	8b 53 60             	mov    0x60(%ebx),%edx
f0103a91:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0103a94:	83 c0 04             	add    $0x4,%eax

	// LAB 3: Your code here.
	++p->pp_ref;
	e->env_pgdir = (pde_t*)page2kva(p);

	for (i = 0; i < NPDENTRIES; ++i) {
f0103a97:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103a9c:	75 e7                	jne    f0103a85 <env_alloc+0x74>
		e->env_pgdir[i] = kern_pgdir[i];
	}

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103a9e:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103aa1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103aa6:	77 20                	ja     f0103ac8 <env_alloc+0xb7>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103aa8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103aac:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103ab3:	f0 
f0103ab4:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
f0103abb:	00 
f0103abc:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103ac3:	e8 78 c5 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103ac8:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103ace:	83 ca 05             	or     $0x5,%edx
f0103ad1:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103ad7:	8b 43 48             	mov    0x48(%ebx),%eax
f0103ada:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103adf:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103ae4:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103ae9:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103aec:	89 da                	mov    %ebx,%edx
f0103aee:	2b 15 4c 32 20 f0    	sub    0xf020324c,%edx
f0103af4:	c1 fa 02             	sar    $0x2,%edx
f0103af7:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103afd:	09 d0                	or     %edx,%eax
f0103aff:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103b02:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b05:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103b08:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103b0f:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103b16:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103b1d:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103b24:	00 
f0103b25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103b2c:	00 
f0103b2d:	89 1c 24             	mov    %ebx,(%esp)
f0103b30:	e8 84 24 00 00       	call   f0105fb9 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103b35:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103b3b:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103b41:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103b47:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103b4e:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f0103b54:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103b5b:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103b62:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103b66:	8b 43 44             	mov    0x44(%ebx),%eax
f0103b69:	a3 50 32 20 f0       	mov    %eax,0xf0203250
	*newenv_store = e;
f0103b6e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b71:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0103b73:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b78:	eb 0c                	jmp    f0103b86 <env_alloc+0x175>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103b7a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103b7f:	eb 05                	jmp    f0103b86 <env_alloc+0x175>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f0103b81:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	env_free_list = e->env_link;
	*newenv_store = e;

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0103b86:	83 c4 14             	add    $0x14,%esp
f0103b89:	5b                   	pop    %ebx
f0103b8a:	5d                   	pop    %ebp
f0103b8b:	c3                   	ret    

f0103b8c <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size, enum EnvType type) {
f0103b8c:	55                   	push   %ebp
f0103b8d:	89 e5                	mov    %esp,%ebp
f0103b8f:	57                   	push   %edi
f0103b90:	56                   	push   %esi
f0103b91:	53                   	push   %ebx
f0103b92:	83 ec 3c             	sub    $0x3c,%esp
f0103b95:	8b 7d 08             	mov    0x8(%ebp),%edi
	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *new_env = NULL;
f0103b98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (env_alloc(&new_env, 0)) {
f0103b9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103ba6:	00 
f0103ba7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103baa:	89 04 24             	mov    %eax,(%esp)
f0103bad:	e8 5f fe ff ff       	call   f0103a11 <env_alloc>
f0103bb2:	85 c0                	test   %eax,%eax
f0103bb4:	74 1c                	je     f0103bd2 <env_create+0x46>
		panic("cannot alloc env");
f0103bb6:	c7 44 24 08 fa 7f 10 	movl   $0xf0107ffa,0x8(%esp)
f0103bbd:	f0 
f0103bbe:	c7 44 24 04 a1 01 00 	movl   $0x1a1,0x4(%esp)
f0103bc5:	00 
f0103bc6:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103bcd:	e8 6e c4 ff ff       	call   f0100040 <_panic>
	}
	load_icode(new_env, binary, size);
f0103bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)

	// Get the beginning and end of program header table
	struct Proghdr *ph =
f0103bd8:	89 fb                	mov    %edi,%ebx
f0103bda:	03 5f 1c             	add    0x1c(%edi),%ebx
		(struct Proghdr *)(binary + ((struct Elf*)binary)->e_phoff);
	struct Proghdr *ph_end =
		(struct Proghdr *)(ph + ((struct Elf*)binary)->e_phnum);
f0103bdd:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0103be1:	c1 e6 05             	shl    $0x5,%esi
	//  What?  (See env_run() and env_pop_tf() below.)

	// Get the beginning and end of program header table
	struct Proghdr *ph =
		(struct Proghdr *)(binary + ((struct Elf*)binary)->e_phoff);
	struct Proghdr *ph_end =
f0103be4:	01 de                	add    %ebx,%esi
		(struct Proghdr *)(ph + ((struct Elf*)binary)->e_phnum);

	// switch to env's pgdir
	lcr3(PADDR(e->env_pgdir));
f0103be6:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103be9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103bee:	77 20                	ja     f0103c10 <env_create+0x84>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bf0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103bf4:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103bfb:	f0 
f0103bfc:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
f0103c03:	00 
f0103c04:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103c0b:	e8 30 c4 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103c10:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103c15:	0f 22 d8             	mov    %eax,%cr3

	for (; ph < ph_end; ++ph) {
f0103c18:	39 f3                	cmp    %esi,%ebx
f0103c1a:	73 54                	jae    f0103c70 <env_create+0xe4>
		if (ph->p_type != ELF_PROG_LOAD) {
f0103c1c:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103c1f:	75 48                	jne    f0103c69 <env_create+0xdd>
			continue;
		}
		// allocate memory for this binary
		region_alloc(e, (void*)ph->p_va, ph->p_memsz);
f0103c21:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103c24:	8b 53 08             	mov    0x8(%ebx),%edx
f0103c27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103c2a:	e8 28 fc ff ff       	call   f0103857 <region_alloc>
		// Load binary image into memory
		memcpy((void*)ph->p_va, (void*)(binary + ph->p_offset), ph->p_filesz);
f0103c2f:	8b 43 10             	mov    0x10(%ebx),%eax
f0103c32:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103c36:	89 f8                	mov    %edi,%eax
f0103c38:	03 43 04             	add    0x4(%ebx),%eax
f0103c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103c3f:	8b 43 08             	mov    0x8(%ebx),%eax
f0103c42:	89 04 24             	mov    %eax,(%esp)
f0103c45:	e8 24 24 00 00       	call   f010606e <memcpy>
		// Init .bss
		memset((void*)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);
f0103c4a:	8b 43 10             	mov    0x10(%ebx),%eax
f0103c4d:	8b 53 14             	mov    0x14(%ebx),%edx
f0103c50:	29 c2                	sub    %eax,%edx
f0103c52:	89 54 24 08          	mov    %edx,0x8(%esp)
f0103c56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103c5d:	00 
f0103c5e:	03 43 08             	add    0x8(%ebx),%eax
f0103c61:	89 04 24             	mov    %eax,(%esp)
f0103c64:	e8 50 23 00 00       	call   f0105fb9 <memset>
		(struct Proghdr *)(ph + ((struct Elf*)binary)->e_phnum);

	// switch to env's pgdir
	lcr3(PADDR(e->env_pgdir));

	for (; ph < ph_end; ++ph) {
f0103c69:	83 c3 20             	add    $0x20,%ebx
f0103c6c:	39 de                	cmp    %ebx,%esi
f0103c6e:	77 ac                	ja     f0103c1c <env_create+0x90>
		memset((void*)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);

	}

	// switch back to kern's pgdir
	lcr3(PADDR(kern_pgdir));
f0103c70:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103c75:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c7a:	77 20                	ja     f0103c9c <env_create+0x110>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c80:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103c87:	f0 
f0103c88:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
f0103c8f:	00 
f0103c90:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103c97:	e8 a4 c3 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103c9c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103ca1:	0f 22 d8             	mov    %eax,%cr3

	// Modified env's trapframe
	// other files in trap frame is set in env_alloc.
	e->env_tf.tf_eip = ((struct Elf*)binary)->e_entry;
f0103ca4:	8b 47 18             	mov    0x18(%edi),%eax
f0103ca7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103caa:	89 47 30             	mov    %eax,0x30(%edi)

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	region_alloc(e, (void*)(USTACKTOP - PGSIZE), PGSIZE);
f0103cad:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103cb2:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103cb7:	89 f8                	mov    %edi,%eax
f0103cb9:	e8 99 fb ff ff       	call   f0103857 <region_alloc>
	struct Env *new_env = NULL;
	if (env_alloc(&new_env, 0)) {
		panic("cannot alloc env");
	}
	load_icode(new_env, binary, size);
	new_env->env_type = type;
f0103cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103cc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0103cc4:	89 48 50             	mov    %ecx,0x50(%eax)

	// I/O instructions are allowed only if CPL <= IOPL
	// so for a user space (CPL = 3) to execute I/O, 
	// we have to set IOPL to 3
	if (type == ENV_TYPE_FS) {
f0103cc7:	83 f9 01             	cmp    $0x1,%ecx
f0103cca:	75 07                	jne    f0103cd3 <env_create+0x147>
		new_env->env_tf.tf_eflags |= FL_IOPL_3;
f0103ccc:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
	}
}
f0103cd3:	83 c4 3c             	add    $0x3c,%esp
f0103cd6:	5b                   	pop    %ebx
f0103cd7:	5e                   	pop    %esi
f0103cd8:	5f                   	pop    %edi
f0103cd9:	5d                   	pop    %ebp
f0103cda:	c3                   	ret    

f0103cdb <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103cdb:	55                   	push   %ebp
f0103cdc:	89 e5                	mov    %esp,%ebp
f0103cde:	57                   	push   %edi
f0103cdf:	56                   	push   %esi
f0103ce0:	53                   	push   %ebx
f0103ce1:	83 ec 2c             	sub    $0x2c,%esp
f0103ce4:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103ce7:	e8 67 29 00 00       	call   f0106653 <cpunum>
f0103cec:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cef:	39 b8 28 40 20 f0    	cmp    %edi,-0xfdfbfd8(%eax)
f0103cf5:	74 09                	je     f0103d00 <env_free+0x25>
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103cf7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103cfe:	eb 36                	jmp    f0103d36 <env_free+0x5b>

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
		lcr3(PADDR(kern_pgdir));
f0103d00:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103d05:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d0a:	77 20                	ja     f0103d2c <env_free+0x51>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103d0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d10:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103d17:	f0 
f0103d18:	c7 44 24 04 bc 01 00 	movl   $0x1bc,0x4(%esp)
f0103d1f:	00 
f0103d20:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103d27:	e8 14 c3 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103d2c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103d31:	0f 22 d8             	mov    %eax,%cr3
f0103d34:	eb c1                	jmp    f0103cf7 <env_free+0x1c>
f0103d36:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103d39:	89 c8                	mov    %ecx,%eax
f0103d3b:	c1 e0 02             	shl    $0x2,%eax
f0103d3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103d41:	8b 47 60             	mov    0x60(%edi),%eax
f0103d44:	8b 34 88             	mov    (%eax,%ecx,4),%esi
f0103d47:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103d4d:	0f 84 b7 00 00 00    	je     f0103e0a <env_free+0x12f>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103d53:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103d59:	89 f0                	mov    %esi,%eax
f0103d5b:	c1 e8 0c             	shr    $0xc,%eax
f0103d5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103d61:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0103d67:	72 20                	jb     f0103d89 <env_free+0xae>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103d69:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103d6d:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0103d74:	f0 
f0103d75:	c7 44 24 04 cb 01 00 	movl   $0x1cb,0x4(%esp)
f0103d7c:	00 
f0103d7d:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103d84:	e8 b7 c2 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103d8c:	c1 e0 16             	shl    $0x16,%eax
f0103d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103d92:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103d97:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103d9e:	01 
f0103d9f:	74 17                	je     f0103db8 <env_free+0xdd>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103da1:	89 d8                	mov    %ebx,%eax
f0103da3:	c1 e0 0c             	shl    $0xc,%eax
f0103da6:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103da9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103dad:	8b 47 60             	mov    0x60(%edi),%eax
f0103db0:	89 04 24             	mov    %eax,(%esp)
f0103db3:	e8 8d d7 ff ff       	call   f0101545 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103db8:	83 c3 01             	add    $0x1,%ebx
f0103dbb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103dc1:	75 d4                	jne    f0103d97 <env_free+0xbc>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103dc3:	8b 47 60             	mov    0x60(%edi),%eax
f0103dc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103dc9:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103dd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103dd3:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0103dd9:	72 1c                	jb     f0103df7 <env_free+0x11c>
		panic("pa2page called with invalid pa");
f0103ddb:	c7 44 24 08 d0 7f 10 	movl   $0xf0107fd0,0x8(%esp)
f0103de2:	f0 
f0103de3:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103dea:	00 
f0103deb:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0103df2:	e8 49 c2 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103df7:	a1 90 3e 20 f0       	mov    0xf0203e90,%eax
f0103dfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103dff:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f0103e02:	89 04 24             	mov    %eax,(%esp)
f0103e05:	e8 c9 d4 ff ff       	call   f01012d3 <page_decref>
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103e0a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103e0e:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103e15:	0f 85 1b ff ff ff    	jne    f0103d36 <env_free+0x5b>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103e1b:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103e1e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e23:	77 20                	ja     f0103e45 <env_free+0x16a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e25:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103e29:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103e30:	f0 
f0103e31:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
f0103e38:	00 
f0103e39:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103e40:	e8 fb c1 ff ff       	call   f0100040 <_panic>
	e->env_pgdir = 0;
f0103e45:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103e4c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103e51:	c1 e8 0c             	shr    $0xc,%eax
f0103e54:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0103e5a:	72 1c                	jb     f0103e78 <env_free+0x19d>
		panic("pa2page called with invalid pa");
f0103e5c:	c7 44 24 08 d0 7f 10 	movl   $0xf0107fd0,0x8(%esp)
f0103e63:	f0 
f0103e64:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103e6b:	00 
f0103e6c:	c7 04 24 59 7c 10 f0 	movl   $0xf0107c59,(%esp)
f0103e73:	e8 c8 c1 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103e78:	8b 15 90 3e 20 f0    	mov    0xf0203e90,%edx
f0103e7e:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	page_decref(pa2page(pa));
f0103e81:	89 04 24             	mov    %eax,(%esp)
f0103e84:	e8 4a d4 ff ff       	call   f01012d3 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103e89:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103e90:	a1 50 32 20 f0       	mov    0xf0203250,%eax
f0103e95:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103e98:	89 3d 50 32 20 f0    	mov    %edi,0xf0203250
}
f0103e9e:	83 c4 2c             	add    $0x2c,%esp
f0103ea1:	5b                   	pop    %ebx
f0103ea2:	5e                   	pop    %esi
f0103ea3:	5f                   	pop    %edi
f0103ea4:	5d                   	pop    %ebp
f0103ea5:	c3                   	ret    

f0103ea6 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103ea6:	55                   	push   %ebp
f0103ea7:	89 e5                	mov    %esp,%ebp
f0103ea9:	53                   	push   %ebx
f0103eaa:	83 ec 14             	sub    $0x14,%esp
f0103ead:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103eb0:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103eb4:	75 19                	jne    f0103ecf <env_destroy+0x29>
f0103eb6:	e8 98 27 00 00       	call   f0106653 <cpunum>
f0103ebb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ebe:	39 98 28 40 20 f0    	cmp    %ebx,-0xfdfbfd8(%eax)
f0103ec4:	74 09                	je     f0103ecf <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0103ec6:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103ecd:	eb 2f                	jmp    f0103efe <env_destroy+0x58>
	}

	env_free(e);
f0103ecf:	89 1c 24             	mov    %ebx,(%esp)
f0103ed2:	e8 04 fe ff ff       	call   f0103cdb <env_free>

	if (curenv == e) {
f0103ed7:	e8 77 27 00 00       	call   f0106653 <cpunum>
f0103edc:	6b c0 74             	imul   $0x74,%eax,%eax
f0103edf:	39 98 28 40 20 f0    	cmp    %ebx,-0xfdfbfd8(%eax)
f0103ee5:	75 17                	jne    f0103efe <env_destroy+0x58>
		curenv = NULL;
f0103ee7:	e8 67 27 00 00       	call   f0106653 <cpunum>
f0103eec:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eef:	c7 80 28 40 20 f0 00 	movl   $0x0,-0xfdfbfd8(%eax)
f0103ef6:	00 00 00 
		sched_yield();
f0103ef9:	e8 19 0c 00 00       	call   f0104b17 <sched_yield>
	}
}
f0103efe:	83 c4 14             	add    $0x14,%esp
f0103f01:	5b                   	pop    %ebx
f0103f02:	5d                   	pop    %ebp
f0103f03:	c3                   	ret    

f0103f04 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103f04:	55                   	push   %ebp
f0103f05:	89 e5                	mov    %esp,%ebp
f0103f07:	53                   	push   %ebx
f0103f08:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103f0b:	e8 43 27 00 00       	call   f0106653 <cpunum>
f0103f10:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f13:	8b 98 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%ebx
f0103f19:	e8 35 27 00 00       	call   f0106653 <cpunum>
f0103f1e:	89 43 5c             	mov    %eax,0x5c(%ebx)
	__asm __volatile("movl %0,%%esp\n"
f0103f21:	8b 65 08             	mov    0x8(%ebp),%esp
f0103f24:	61                   	popa   
f0103f25:	07                   	pop    %es
f0103f26:	1f                   	pop    %ds
f0103f27:	83 c4 08             	add    $0x8,%esp
f0103f2a:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103f2b:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103f32:	f0 
f0103f33:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
f0103f3a:	00 
f0103f3b:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103f42:	e8 f9 c0 ff ff       	call   f0100040 <_panic>

f0103f47 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103f47:	55                   	push   %ebp
f0103f48:	89 e5                	mov    %esp,%ebp
f0103f4a:	53                   	push   %ebx
f0103f4b:	83 ec 14             	sub    $0x14,%esp
f0103f4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if (curenv && curenv->env_status == ENV_RUNNING) {
f0103f51:	e8 fd 26 00 00       	call   f0106653 <cpunum>
f0103f56:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f59:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f0103f60:	74 29                	je     f0103f8b <env_run+0x44>
f0103f62:	e8 ec 26 00 00       	call   f0106653 <cpunum>
f0103f67:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f6a:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0103f70:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103f74:	75 15                	jne    f0103f8b <env_run+0x44>
		curenv->env_status = ENV_RUNNABLE;
f0103f76:	e8 d8 26 00 00       	call   f0106653 <cpunum>
f0103f7b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f7e:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0103f84:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	}
	curenv = e;
f0103f8b:	e8 c3 26 00 00       	call   f0106653 <cpunum>
f0103f90:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f93:	89 98 28 40 20 f0    	mov    %ebx,-0xfdfbfd8(%eax)
	curenv->env_status = ENV_RUNNING;
f0103f99:	e8 b5 26 00 00       	call   f0106653 <cpunum>
f0103f9e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fa1:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0103fa7:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	++curenv->env_runs;
f0103fae:	e8 a0 26 00 00       	call   f0106653 <cpunum>
f0103fb3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fb6:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0103fbc:	83 40 58 01          	addl   $0x1,0x58(%eax)
	lcr3(PADDR(e->env_pgdir));
f0103fc0:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103fc3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103fc8:	77 20                	ja     f0103fea <env_run+0xa3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103fca:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103fce:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0103fd5:	f0 
f0103fd6:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
f0103fdd:	00 
f0103fde:	c7 04 24 ef 7f 10 f0 	movl   $0xf0107fef,(%esp)
f0103fe5:	e8 56 c0 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103fea:	05 00 00 00 10       	add    $0x10000000,%eax
f0103fef:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103ff2:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f0103ff9:	e8 a9 29 00 00       	call   f01069a7 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103ffe:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0104000:	89 1c 24             	mov    %ebx,(%esp)
f0104003:	e8 fc fe ff ff       	call   f0103f04 <env_pop_tf>

f0104008 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0104008:	55                   	push   %ebp
f0104009:	89 e5                	mov    %esp,%ebp
f010400b:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010400f:	ba 70 00 00 00       	mov    $0x70,%edx
f0104014:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104015:	b2 71                	mov    $0x71,%dl
f0104017:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0104018:	0f b6 c0             	movzbl %al,%eax
}
f010401b:	5d                   	pop    %ebp
f010401c:	c3                   	ret    

f010401d <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010401d:	55                   	push   %ebp
f010401e:	89 e5                	mov    %esp,%ebp
f0104020:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104024:	ba 70 00 00 00       	mov    $0x70,%edx
f0104029:	ee                   	out    %al,(%dx)
f010402a:	b2 71                	mov    $0x71,%dl
f010402c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010402f:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0104030:	5d                   	pop    %ebp
f0104031:	c3                   	ret    

f0104032 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0104032:	55                   	push   %ebp
f0104033:	89 e5                	mov    %esp,%ebp
f0104035:	56                   	push   %esi
f0104036:	53                   	push   %ebx
f0104037:	83 ec 10             	sub    $0x10,%esp
f010403a:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f010403d:	66 a3 a8 13 12 f0    	mov    %ax,0xf01213a8
	if (!didinit)
f0104043:	80 3d 54 32 20 f0 00 	cmpb   $0x0,0xf0203254
f010404a:	74 4e                	je     f010409a <irq_setmask_8259A+0x68>
f010404c:	89 c6                	mov    %eax,%esi
f010404e:	ba 21 00 00 00       	mov    $0x21,%edx
f0104053:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0104054:	66 c1 e8 08          	shr    $0x8,%ax
f0104058:	b2 a1                	mov    $0xa1,%dl
f010405a:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010405b:	c7 04 24 17 80 10 f0 	movl   $0xf0108017,(%esp)
f0104062:	e8 0a 01 00 00       	call   f0104171 <cprintf>
	for (i = 0; i < 16; i++)
f0104067:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010406c:	0f b7 f6             	movzwl %si,%esi
f010406f:	f7 d6                	not    %esi
f0104071:	0f a3 de             	bt     %ebx,%esi
f0104074:	73 10                	jae    f0104086 <irq_setmask_8259A+0x54>
			cprintf(" %d", i);
f0104076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010407a:	c7 04 24 b7 85 10 f0 	movl   $0xf01085b7,(%esp)
f0104081:	e8 eb 00 00 00       	call   f0104171 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0104086:	83 c3 01             	add    $0x1,%ebx
f0104089:	83 fb 10             	cmp    $0x10,%ebx
f010408c:	75 e3                	jne    f0104071 <irq_setmask_8259A+0x3f>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f010408e:	c7 04 24 79 7f 10 f0 	movl   $0xf0107f79,(%esp)
f0104095:	e8 d7 00 00 00       	call   f0104171 <cprintf>
}
f010409a:	83 c4 10             	add    $0x10,%esp
f010409d:	5b                   	pop    %ebx
f010409e:	5e                   	pop    %esi
f010409f:	5d                   	pop    %ebp
f01040a0:	c3                   	ret    

f01040a1 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f01040a1:	c6 05 54 32 20 f0 01 	movb   $0x1,0xf0203254
f01040a8:	ba 21 00 00 00       	mov    $0x21,%edx
f01040ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01040b2:	ee                   	out    %al,(%dx)
f01040b3:	b2 a1                	mov    $0xa1,%dl
f01040b5:	ee                   	out    %al,(%dx)
f01040b6:	b2 20                	mov    $0x20,%dl
f01040b8:	b8 11 00 00 00       	mov    $0x11,%eax
f01040bd:	ee                   	out    %al,(%dx)
f01040be:	b2 21                	mov    $0x21,%dl
f01040c0:	b8 20 00 00 00       	mov    $0x20,%eax
f01040c5:	ee                   	out    %al,(%dx)
f01040c6:	b8 04 00 00 00       	mov    $0x4,%eax
f01040cb:	ee                   	out    %al,(%dx)
f01040cc:	b8 03 00 00 00       	mov    $0x3,%eax
f01040d1:	ee                   	out    %al,(%dx)
f01040d2:	b2 a0                	mov    $0xa0,%dl
f01040d4:	b8 11 00 00 00       	mov    $0x11,%eax
f01040d9:	ee                   	out    %al,(%dx)
f01040da:	b2 a1                	mov    $0xa1,%dl
f01040dc:	b8 28 00 00 00       	mov    $0x28,%eax
f01040e1:	ee                   	out    %al,(%dx)
f01040e2:	b8 02 00 00 00       	mov    $0x2,%eax
f01040e7:	ee                   	out    %al,(%dx)
f01040e8:	b8 01 00 00 00       	mov    $0x1,%eax
f01040ed:	ee                   	out    %al,(%dx)
f01040ee:	b2 20                	mov    $0x20,%dl
f01040f0:	b8 68 00 00 00       	mov    $0x68,%eax
f01040f5:	ee                   	out    %al,(%dx)
f01040f6:	b8 0a 00 00 00       	mov    $0xa,%eax
f01040fb:	ee                   	out    %al,(%dx)
f01040fc:	b2 a0                	mov    $0xa0,%dl
f01040fe:	b8 68 00 00 00       	mov    $0x68,%eax
f0104103:	ee                   	out    %al,(%dx)
f0104104:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104109:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f010410a:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f0104111:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104115:	74 12                	je     f0104129 <pic_init+0x88>
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0104117:	55                   	push   %ebp
f0104118:	89 e5                	mov    %esp,%ebp
f010411a:	83 ec 18             	sub    $0x18,%esp

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
		irq_setmask_8259A(irq_mask_8259A);
f010411d:	0f b7 c0             	movzwl %ax,%eax
f0104120:	89 04 24             	mov    %eax,(%esp)
f0104123:	e8 0a ff ff ff       	call   f0104032 <irq_setmask_8259A>
}
f0104128:	c9                   	leave  
f0104129:	f3 c3                	repz ret 

f010412b <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f010412b:	55                   	push   %ebp
f010412c:	89 e5                	mov    %esp,%ebp
f010412e:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f0104131:	8b 45 08             	mov    0x8(%ebp),%eax
f0104134:	89 04 24             	mov    %eax,(%esp)
f0104137:	e8 af c6 ff ff       	call   f01007eb <cputchar>
	*cnt++;
}
f010413c:	c9                   	leave  
f010413d:	c3                   	ret    

f010413e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010413e:	55                   	push   %ebp
f010413f:	89 e5                	mov    %esp,%ebp
f0104141:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0104144:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010414b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010414e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104152:	8b 45 08             	mov    0x8(%ebp),%eax
f0104155:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104159:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010415c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104160:	c7 04 24 2b 41 10 f0 	movl   $0xf010412b,(%esp)
f0104167:	e8 f8 16 00 00       	call   f0105864 <vprintfmt>
	return cnt;
}
f010416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010416f:	c9                   	leave  
f0104170:	c3                   	ret    

f0104171 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104171:	55                   	push   %ebp
f0104172:	89 e5                	mov    %esp,%ebp
f0104174:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0104177:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010417a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010417e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104181:	89 04 24             	mov    %eax,(%esp)
f0104184:	e8 b5 ff ff ff       	call   f010413e <vcprintf>
	va_end(ap);

	return cnt;
}
f0104189:	c9                   	leave  
f010418a:	c3                   	ret    
f010418b:	66 90                	xchg   %ax,%ax
f010418d:	66 90                	xchg   %ax,%ax
f010418f:	90                   	nop

f0104190 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0104190:	55                   	push   %ebp
f0104191:	89 e5                	mov    %esp,%ebp
f0104193:	57                   	push   %edi
f0104194:	56                   	push   %esi
f0104195:	53                   	push   %ebx
f0104196:	83 ec 0c             	sub    $0xc,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[cpunum()] + KSTKSIZE);
f0104199:	e8 b5 24 00 00       	call   f0106653 <cpunum>
f010419e:	89 c3                	mov    %eax,%ebx
f01041a0:	e8 ae 24 00 00       	call   f0106653 <cpunum>
f01041a5:	6b db 74             	imul   $0x74,%ebx,%ebx
f01041a8:	c1 e0 0f             	shl    $0xf,%eax
f01041ab:	8d 80 00 d0 20 f0    	lea    -0xfdf3000(%eax),%eax
f01041b1:	89 83 30 40 20 f0    	mov    %eax,-0xfdfbfd0(%ebx)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f01041b7:	e8 97 24 00 00       	call   f0106653 <cpunum>
f01041bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01041bf:	66 c7 80 34 40 20 f0 	movw   $0x10,-0xfdfbfcc(%eax)
f01041c6:	10 00 
	gdt[(GD_TSS0 >> 3) + cpunum()] =
f01041c8:	e8 86 24 00 00       	call   f0106653 <cpunum>
f01041cd:	8d 58 05             	lea    0x5(%eax),%ebx
		SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate), 0);
f01041d0:	e8 7e 24 00 00       	call   f0106653 <cpunum>
f01041d5:	89 c7                	mov    %eax,%edi
f01041d7:	e8 77 24 00 00       	call   f0106653 <cpunum>
f01041dc:	89 c6                	mov    %eax,%esi
f01041de:	e8 70 24 00 00       	call   f0106653 <cpunum>
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[cpunum()] + KSTKSIZE);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
	gdt[(GD_TSS0 >> 3) + cpunum()] =
f01041e3:	66 c7 04 dd 40 13 12 	movw   $0x68,-0xfedecc0(,%ebx,8)
f01041ea:	f0 68 00 
		SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate), 0);
f01041ed:	6b ff 74             	imul   $0x74,%edi,%edi
f01041f0:	81 c7 2c 40 20 f0    	add    $0xf020402c,%edi
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[cpunum()] + KSTKSIZE);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
	gdt[(GD_TSS0 >> 3) + cpunum()] =
f01041f6:	66 89 3c dd 42 13 12 	mov    %di,-0xfedecbe(,%ebx,8)
f01041fd:	f0 
		SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate), 0);
f01041fe:	6b d6 74             	imul   $0x74,%esi,%edx
f0104201:	81 c2 2c 40 20 f0    	add    $0xf020402c,%edx
f0104207:	c1 ea 10             	shr    $0x10,%edx
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[cpunum()] + KSTKSIZE);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
	gdt[(GD_TSS0 >> 3) + cpunum()] =
f010420a:	88 14 dd 44 13 12 f0 	mov    %dl,-0xfedecbc(,%ebx,8)
f0104211:	c6 04 dd 45 13 12 f0 	movb   $0x99,-0xfedecbb(,%ebx,8)
f0104218:	99 
f0104219:	c6 04 dd 46 13 12 f0 	movb   $0x40,-0xfedecba(,%ebx,8)
f0104220:	40 
		SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate), 0);
f0104221:	6b c0 74             	imul   $0x74,%eax,%eax
f0104224:	05 2c 40 20 f0       	add    $0xf020402c,%eax
f0104229:	c1 e8 18             	shr    $0x18,%eax
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t)(percpu_kstacks[cpunum()] + KSTKSIZE);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
	gdt[(GD_TSS0 >> 3) + cpunum()] =
f010422c:	88 04 dd 47 13 12 f0 	mov    %al,-0xfedecb9(,%ebx,8)
		SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate), 0);
	gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;
f0104233:	e8 1b 24 00 00       	call   f0106653 <cpunum>
f0104238:	80 24 c5 6d 13 12 f0 	andb   $0xef,-0xfedec93(,%eax,8)
f010423f:	ef 
	ltr( ((GD_TSS0 >> 3) + cpunum()) << 3 );
f0104240:	e8 0e 24 00 00       	call   f0106653 <cpunum>
f0104245:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f010424c:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f010424f:	b8 aa 13 12 f0       	mov    $0xf01213aa,%eax
f0104254:	0f 01 18             	lidtl  (%eax)
	// ltr(GD_TSS0);
	lidt(&idt_pd);
}
f0104257:	83 c4 0c             	add    $0xc,%esp
f010425a:	5b                   	pop    %ebx
f010425b:	5e                   	pop    %esi
f010425c:	5f                   	pop    %edi
f010425d:	5d                   	pop    %ebp
f010425e:	c3                   	ret    

f010425f <trap_init>:
{
	extern struct Segdesc gdt[];
	extern long ivector_table[];
	// LAB 3: Your code here.
	int i;
	for (i = 0; i <= T_SIMDERR; ++i) {
f010425f:	b8 00 00 00 00       	mov    $0x0,%eax
		SETGATE(idt[i], 0, GD_KT, ivector_table[i], 0);
f0104264:	8b 14 85 b0 13 12 f0 	mov    -0xfedec50(,%eax,4),%edx
f010426b:	66 89 14 c5 60 32 20 	mov    %dx,-0xfdfcda0(,%eax,8)
f0104272:	f0 
f0104273:	66 c7 04 c5 62 32 20 	movw   $0x8,-0xfdfcd9e(,%eax,8)
f010427a:	f0 08 00 
f010427d:	c6 04 c5 64 32 20 f0 	movb   $0x0,-0xfdfcd9c(,%eax,8)
f0104284:	00 
f0104285:	c6 04 c5 65 32 20 f0 	movb   $0x8e,-0xfdfcd9b(,%eax,8)
f010428c:	8e 
f010428d:	c1 ea 10             	shr    $0x10,%edx
f0104290:	66 89 14 c5 66 32 20 	mov    %dx,-0xfdfcd9a(,%eax,8)
f0104297:	f0 
{
	extern struct Segdesc gdt[];
	extern long ivector_table[];
	// LAB 3: Your code here.
	int i;
	for (i = 0; i <= T_SIMDERR; ++i) {
f0104298:	83 c0 01             	add    $0x1,%eax
f010429b:	83 f8 14             	cmp    $0x14,%eax
f010429e:	75 c4                	jne    f0104264 <trap_init+0x5>

	// T_BRKPT is generated using software int.
	// in other words, user invoke the "int 3",
	// so the processor compare the DPL of the gate with
	// the CPL.
	SETGATE(idt[T_BRKPT], 0, GD_KT, ivector_table[T_BRKPT], 3);
f01042a0:	a1 bc 13 12 f0       	mov    0xf01213bc,%eax
f01042a5:	66 a3 78 32 20 f0    	mov    %ax,0xf0203278
f01042ab:	66 c7 05 7a 32 20 f0 	movw   $0x8,0xf020327a
f01042b2:	08 00 
f01042b4:	c6 05 7c 32 20 f0 00 	movb   $0x0,0xf020327c
f01042bb:	c6 05 7d 32 20 f0 ee 	movb   $0xee,0xf020327d
f01042c2:	c1 e8 10             	shr    $0x10,%eax
f01042c5:	66 a3 7e 32 20 f0    	mov    %ax,0xf020327e

	// Setting system call, the reason setting DPL as 3 is same
	// as above
	SETGATE(idt[T_SYSCALL], 0, GD_KT, ivector_table[T_SYSCALL], 3);
f01042cb:	a1 70 14 12 f0       	mov    0xf0121470,%eax
f01042d0:	66 a3 e0 33 20 f0    	mov    %ax,0xf02033e0
f01042d6:	66 c7 05 e2 33 20 f0 	movw   $0x8,0xf02033e2
f01042dd:	08 00 
f01042df:	c6 05 e4 33 20 f0 00 	movb   $0x0,0xf02033e4
f01042e6:	c6 05 e5 33 20 f0 ee 	movb   $0xee,0xf02033e5
f01042ed:	c1 e8 10             	shr    $0x10,%eax
f01042f0:	66 a3 e6 33 20 f0    	mov    %ax,0xf02033e6

	for (i = 0; i < sizeof(idt_idx) / sizeof(int); ++i) {
f01042f6:	ba 00 00 00 00       	mov    $0x0,%edx
		int idx = idt_idx[i] + IRQ_OFFSET;
f01042fb:	8b 04 95 30 84 10 f0 	mov    -0xfef7bd0(,%edx,4),%eax
f0104302:	83 c0 20             	add    $0x20,%eax
		SETGATE(idt[idx], 0, GD_KT, ivector_table[idx], 0);
f0104305:	8b 0c 85 b0 13 12 f0 	mov    -0xfedec50(,%eax,4),%ecx
f010430c:	66 89 0c c5 60 32 20 	mov    %cx,-0xfdfcda0(,%eax,8)
f0104313:	f0 
f0104314:	66 c7 04 c5 62 32 20 	movw   $0x8,-0xfdfcd9e(,%eax,8)
f010431b:	f0 08 00 
f010431e:	c6 04 c5 64 32 20 f0 	movb   $0x0,-0xfdfcd9c(,%eax,8)
f0104325:	00 
f0104326:	c6 04 c5 65 32 20 f0 	movb   $0x8e,-0xfdfcd9b(,%eax,8)
f010432d:	8e 
f010432e:	c1 e9 10             	shr    $0x10,%ecx
f0104331:	66 89 0c c5 66 32 20 	mov    %cx,-0xfdfcd9a(,%eax,8)
f0104338:	f0 

	// Setting system call, the reason setting DPL as 3 is same
	// as above
	SETGATE(idt[T_SYSCALL], 0, GD_KT, ivector_table[T_SYSCALL], 3);

	for (i = 0; i < sizeof(idt_idx) / sizeof(int); ++i) {
f0104339:	83 c2 01             	add    $0x1,%edx
f010433c:	83 fa 06             	cmp    $0x6,%edx
f010433f:	75 ba                	jne    f01042fb <trap_init+0x9c>
	IRQ_ERROR
};

void
trap_init(void)
{
f0104341:	55                   	push   %ebp
f0104342:	89 e5                	mov    %esp,%ebp
f0104344:	83 ec 08             	sub    $0x8,%esp
		int idx = idt_idx[i] + IRQ_OFFSET;
		SETGATE(idt[idx], 0, GD_KT, ivector_table[idx], 0);
	}

	// Per-CPU setup
	trap_init_percpu();
f0104347:	e8 44 fe ff ff       	call   f0104190 <trap_init_percpu>
}
f010434c:	c9                   	leave  
f010434d:	c3                   	ret    

f010434e <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010434e:	55                   	push   %ebp
f010434f:	89 e5                	mov    %esp,%ebp
f0104351:	53                   	push   %ebx
f0104352:	83 ec 14             	sub    $0x14,%esp
f0104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104358:	8b 03                	mov    (%ebx),%eax
f010435a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010435e:	c7 04 24 2b 80 10 f0 	movl   $0xf010802b,(%esp)
f0104365:	e8 07 fe ff ff       	call   f0104171 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010436a:	8b 43 04             	mov    0x4(%ebx),%eax
f010436d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104371:	c7 04 24 3a 80 10 f0 	movl   $0xf010803a,(%esp)
f0104378:	e8 f4 fd ff ff       	call   f0104171 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010437d:	8b 43 08             	mov    0x8(%ebx),%eax
f0104380:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104384:	c7 04 24 49 80 10 f0 	movl   $0xf0108049,(%esp)
f010438b:	e8 e1 fd ff ff       	call   f0104171 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104390:	8b 43 0c             	mov    0xc(%ebx),%eax
f0104393:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104397:	c7 04 24 58 80 10 f0 	movl   $0xf0108058,(%esp)
f010439e:	e8 ce fd ff ff       	call   f0104171 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01043a3:	8b 43 10             	mov    0x10(%ebx),%eax
f01043a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043aa:	c7 04 24 67 80 10 f0 	movl   $0xf0108067,(%esp)
f01043b1:	e8 bb fd ff ff       	call   f0104171 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01043b6:	8b 43 14             	mov    0x14(%ebx),%eax
f01043b9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043bd:	c7 04 24 76 80 10 f0 	movl   $0xf0108076,(%esp)
f01043c4:	e8 a8 fd ff ff       	call   f0104171 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01043c9:	8b 43 18             	mov    0x18(%ebx),%eax
f01043cc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043d0:	c7 04 24 85 80 10 f0 	movl   $0xf0108085,(%esp)
f01043d7:	e8 95 fd ff ff       	call   f0104171 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01043dc:	8b 43 1c             	mov    0x1c(%ebx),%eax
f01043df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043e3:	c7 04 24 94 80 10 f0 	movl   $0xf0108094,(%esp)
f01043ea:	e8 82 fd ff ff       	call   f0104171 <cprintf>
}
f01043ef:	83 c4 14             	add    $0x14,%esp
f01043f2:	5b                   	pop    %ebx
f01043f3:	5d                   	pop    %ebp
f01043f4:	c3                   	ret    

f01043f5 <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f01043f5:	55                   	push   %ebp
f01043f6:	89 e5                	mov    %esp,%ebp
f01043f8:	56                   	push   %esi
f01043f9:	53                   	push   %ebx
f01043fa:	83 ec 10             	sub    $0x10,%esp
f01043fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104400:	e8 4e 22 00 00       	call   f0106653 <cpunum>
f0104405:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104409:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010440d:	c7 04 24 f8 80 10 f0 	movl   $0xf01080f8,(%esp)
f0104414:	e8 58 fd ff ff       	call   f0104171 <cprintf>
	print_regs(&tf->tf_regs);
f0104419:	89 1c 24             	mov    %ebx,(%esp)
f010441c:	e8 2d ff ff ff       	call   f010434e <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104421:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104425:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104429:	c7 04 24 16 81 10 f0 	movl   $0xf0108116,(%esp)
f0104430:	e8 3c fd ff ff       	call   f0104171 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104435:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104439:	89 44 24 04          	mov    %eax,0x4(%esp)
f010443d:	c7 04 24 29 81 10 f0 	movl   $0xf0108129,(%esp)
f0104444:	e8 28 fd ff ff       	call   f0104171 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104449:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f010444c:	83 f8 13             	cmp    $0x13,%eax
f010444f:	77 09                	ja     f010445a <print_trapframe+0x65>
		return excnames[trapno];
f0104451:	8b 14 85 e0 83 10 f0 	mov    -0xfef7c20(,%eax,4),%edx
f0104458:	eb 1f                	jmp    f0104479 <print_trapframe+0x84>
	if (trapno == T_SYSCALL)
f010445a:	83 f8 30             	cmp    $0x30,%eax
f010445d:	74 15                	je     f0104474 <print_trapframe+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f010445f:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104462:	83 fa 0f             	cmp    $0xf,%edx
f0104465:	ba af 80 10 f0       	mov    $0xf01080af,%edx
f010446a:	b9 c2 80 10 f0       	mov    $0xf01080c2,%ecx
f010446f:	0f 47 d1             	cmova  %ecx,%edx
f0104472:	eb 05                	jmp    f0104479 <print_trapframe+0x84>
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f0104474:	ba a3 80 10 f0       	mov    $0xf01080a3,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104479:	89 54 24 08          	mov    %edx,0x8(%esp)
f010447d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104481:	c7 04 24 3c 81 10 f0 	movl   $0xf010813c,(%esp)
f0104488:	e8 e4 fc ff ff       	call   f0104171 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010448d:	3b 1d 60 3a 20 f0    	cmp    0xf0203a60,%ebx
f0104493:	75 19                	jne    f01044ae <print_trapframe+0xb9>
f0104495:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104499:	75 13                	jne    f01044ae <print_trapframe+0xb9>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f010449b:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010449e:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044a2:	c7 04 24 4e 81 10 f0 	movl   $0xf010814e,(%esp)
f01044a9:	e8 c3 fc ff ff       	call   f0104171 <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f01044ae:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01044b1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01044b5:	c7 04 24 5d 81 10 f0 	movl   $0xf010815d,(%esp)
f01044bc:	e8 b0 fc ff ff       	call   f0104171 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f01044c1:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01044c5:	75 51                	jne    f0104518 <print_trapframe+0x123>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f01044c7:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f01044ca:	89 c2                	mov    %eax,%edx
f01044cc:	83 e2 01             	and    $0x1,%edx
f01044cf:	ba d1 80 10 f0       	mov    $0xf01080d1,%edx
f01044d4:	b9 dc 80 10 f0       	mov    $0xf01080dc,%ecx
f01044d9:	0f 45 ca             	cmovne %edx,%ecx
f01044dc:	89 c2                	mov    %eax,%edx
f01044de:	83 e2 02             	and    $0x2,%edx
f01044e1:	ba e8 80 10 f0       	mov    $0xf01080e8,%edx
f01044e6:	be ee 80 10 f0       	mov    $0xf01080ee,%esi
f01044eb:	0f 44 d6             	cmove  %esi,%edx
f01044ee:	83 e0 04             	and    $0x4,%eax
f01044f1:	b8 f3 80 10 f0       	mov    $0xf01080f3,%eax
f01044f6:	be 57 82 10 f0       	mov    $0xf0108257,%esi
f01044fb:	0f 44 c6             	cmove  %esi,%eax
f01044fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104502:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104506:	89 44 24 04          	mov    %eax,0x4(%esp)
f010450a:	c7 04 24 6b 81 10 f0 	movl   $0xf010816b,(%esp)
f0104511:	e8 5b fc ff ff       	call   f0104171 <cprintf>
f0104516:	eb 0c                	jmp    f0104524 <print_trapframe+0x12f>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0104518:	c7 04 24 79 7f 10 f0 	movl   $0xf0107f79,(%esp)
f010451f:	e8 4d fc ff ff       	call   f0104171 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104524:	8b 43 30             	mov    0x30(%ebx),%eax
f0104527:	89 44 24 04          	mov    %eax,0x4(%esp)
f010452b:	c7 04 24 7a 81 10 f0 	movl   $0xf010817a,(%esp)
f0104532:	e8 3a fc ff ff       	call   f0104171 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104537:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010453b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010453f:	c7 04 24 89 81 10 f0 	movl   $0xf0108189,(%esp)
f0104546:	e8 26 fc ff ff       	call   f0104171 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010454b:	8b 43 38             	mov    0x38(%ebx),%eax
f010454e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104552:	c7 04 24 9c 81 10 f0 	movl   $0xf010819c,(%esp)
f0104559:	e8 13 fc ff ff       	call   f0104171 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f010455e:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104562:	74 27                	je     f010458b <print_trapframe+0x196>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104564:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104567:	89 44 24 04          	mov    %eax,0x4(%esp)
f010456b:	c7 04 24 ab 81 10 f0 	movl   $0xf01081ab,(%esp)
f0104572:	e8 fa fb ff ff       	call   f0104171 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104577:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010457b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010457f:	c7 04 24 ba 81 10 f0 	movl   $0xf01081ba,(%esp)
f0104586:	e8 e6 fb ff ff       	call   f0104171 <cprintf>
	}
}
f010458b:	83 c4 10             	add    $0x10,%esp
f010458e:	5b                   	pop    %ebx
f010458f:	5e                   	pop    %esi
f0104590:	5d                   	pop    %ebp
f0104591:	c3                   	ret    

f0104592 <page_fault_handler>:
}

// will not return
void
page_fault_handler(struct Trapframe *tf)
{
f0104592:	55                   	push   %ebp
f0104593:	89 e5                	mov    %esp,%ebp
f0104595:	57                   	push   %edi
f0104596:	56                   	push   %esi
f0104597:	53                   	push   %ebx
f0104598:	83 ec 2c             	sub    $0x2c,%esp
f010459b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010459e:	0f 20 d6             	mov    %cr2,%esi

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	if (!(tf->tf_cs & 0x11)) {
f01045a1:	f6 43 34 11          	testb  $0x11,0x34(%ebx)
f01045a5:	75 1c                	jne    f01045c3 <page_fault_handler+0x31>
		panic("Kernel Page Fault.");
f01045a7:	c7 44 24 08 cd 81 10 	movl   $0xf01081cd,0x8(%esp)
f01045ae:	f0 
f01045af:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
f01045b6:	00 
f01045b7:	c7 04 24 e0 81 10 f0 	movl   $0xf01081e0,(%esp)
f01045be:	e8 7d ba ff ff       	call   f0100040 <_panic>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	const uint32_t tf_esp_addr = (uint32_t)(tf->tf_esp); 		// trap-time esp
f01045c3:	8b 7b 3c             	mov    0x3c(%ebx),%edi

	if (!curenv->env_pgfault_upcall) {
f01045c6:	e8 88 20 00 00       	call   f0106653 <cpunum>
f01045cb:	6b c0 74             	imul   $0x74,%eax,%eax
f01045ce:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01045d4:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01045d8:	75 50                	jne    f010462a <page_fault_handler+0x98>
		// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01045da:	8b 43 30             	mov    0x30(%ebx),%eax
f01045dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			curenv->env_id, fault_va, tf->tf_eip);
f01045e0:	e8 6e 20 00 00       	call   f0106653 <cpunum>
	// LAB 4: Your code here.
	const uint32_t tf_esp_addr = (uint32_t)(tf->tf_esp); 		// trap-time esp

	if (!curenv->env_pgfault_upcall) {
		// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01045e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01045e8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01045ec:	89 74 24 08          	mov    %esi,0x8(%esp)
			curenv->env_id, fault_va, tf->tf_eip);
f01045f0:	6b c0 74             	imul   $0x74,%eax,%eax
	// LAB 4: Your code here.
	const uint32_t tf_esp_addr = (uint32_t)(tf->tf_esp); 		// trap-time esp

	if (!curenv->env_pgfault_upcall) {
		// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01045f3:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01045f9:	8b 40 48             	mov    0x48(%eax),%eax
f01045fc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104600:	c7 04 24 a4 83 10 f0 	movl   $0xf01083a4,(%esp)
f0104607:	e8 65 fb ff ff       	call   f0104171 <cprintf>
			curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
f010460c:	89 1c 24             	mov    %ebx,(%esp)
f010460f:	e8 e1 fd ff ff       	call   f01043f5 <print_trapframe>
		env_destroy(curenv);	// env_destroy will call shced_yeild
f0104614:	e8 3a 20 00 00       	call   f0106653 <cpunum>
f0104619:	6b c0 74             	imul   $0x74,%eax,%eax
f010461c:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104622:	89 04 24             	mov    %eax,(%esp)
f0104625:	e8 7c f8 ff ff       	call   f0103ea6 <env_destroy>
	}

	// !!! if user exception stack overflow, it will trigger a kernel page fautl.
	int in_user_ex_stack = ((tf_esp_addr < UXSTACKTOP) && (tf_esp_addr >= (UXSTACKTOP - PGSIZE)));
f010462a:	8d 87 00 10 40 11    	lea    0x11401000(%edi),%eax
	struct UTrapframe* utf = NULL;

	if (!in_user_ex_stack) {
		utf = (struct UTrapframe*)(UXSTACKTOP - sizeof(struct UTrapframe));
	} else {
		utf = (struct UTrapframe*)(tf_esp_addr - 4 - sizeof(struct UTrapframe));
f0104630:	83 ef 38             	sub    $0x38,%edi
f0104633:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0104638:	b8 cc ff bf ee       	mov    $0xeebfffcc,%eax
f010463d:	0f 46 c7             	cmovbe %edi,%eax
f0104640:	89 c7                	mov    %eax,%edi
f0104642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}

	// check the utrap frame address valid
	user_mem_assert(curenv, (void*)utf, sizeof(struct UTrapframe), PTE_U | PTE_P | PTE_W);
f0104645:	e8 09 20 00 00       	call   f0106653 <cpunum>
f010464a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0104651:	00 
f0104652:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0104659:	00 
f010465a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010465e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104661:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104667:	89 04 24             	mov    %eax,(%esp)
f010466a:	e8 90 f1 ff ff       	call   f01037ff <user_mem_assert>

	// setup user exception trapframe
	utf->utf_fault_va = fault_va;
f010466f:	89 37                	mov    %esi,(%edi)
	utf->utf_err = tf->tf_err;
f0104671:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104674:	89 47 04             	mov    %eax,0x4(%edi)
	utf->utf_regs = tf->tf_regs;
f0104677:	8d 7f 08             	lea    0x8(%edi),%edi
f010467a:	89 de                	mov    %ebx,%esi
f010467c:	b8 20 00 00 00       	mov    $0x20,%eax
f0104681:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0104687:	74 03                	je     f010468c <page_fault_handler+0xfa>
f0104689:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f010468a:	b0 1f                	mov    $0x1f,%al
f010468c:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0104692:	74 05                	je     f0104699 <page_fault_handler+0x107>
f0104694:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f0104696:	83 e8 02             	sub    $0x2,%eax
f0104699:	89 c1                	mov    %eax,%ecx
f010469b:	c1 e9 02             	shr    $0x2,%ecx
f010469e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01046a0:	ba 00 00 00 00       	mov    $0x0,%edx
f01046a5:	a8 02                	test   $0x2,%al
f01046a7:	74 0b                	je     f01046b4 <page_fault_handler+0x122>
f01046a9:	0f b7 16             	movzwl (%esi),%edx
f01046ac:	66 89 17             	mov    %dx,(%edi)
f01046af:	ba 02 00 00 00       	mov    $0x2,%edx
f01046b4:	a8 01                	test   $0x1,%al
f01046b6:	74 07                	je     f01046bf <page_fault_handler+0x12d>
f01046b8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
f01046bc:	88 04 17             	mov    %al,(%edi,%edx,1)
	utf->utf_eip = tf->tf_eip;
f01046bf:	8b 43 30             	mov    0x30(%ebx),%eax
f01046c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01046c5:	89 42 28             	mov    %eax,0x28(%edx)
	utf->utf_esp = tf->tf_esp;
f01046c8:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01046cb:	89 42 30             	mov    %eax,0x30(%edx)
	utf->utf_eflags = tf->tf_eflags;
f01046ce:	8b 43 38             	mov    0x38(%ebx),%eax
f01046d1:	89 42 2c             	mov    %eax,0x2c(%edx)

	// modified kernel stack trapframe
	tf->tf_esp = (uintptr_t)utf;
f01046d4:	89 53 3c             	mov    %edx,0x3c(%ebx)
	tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01046d7:	e8 77 1f 00 00       	call   f0106653 <cpunum>
f01046dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01046df:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01046e5:	8b 40 64             	mov    0x64(%eax),%eax
f01046e8:	89 43 30             	mov    %eax,0x30(%ebx)

	// restore trap frame
	// and transfer to env_pgfault_upcall
	env_run(curenv);
f01046eb:	e8 63 1f 00 00       	call   f0106653 <cpunum>
f01046f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01046f3:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01046f9:	89 04 24             	mov    %eax,(%esp)
f01046fc:	e8 46 f8 ff ff       	call   f0103f47 <env_run>

f0104701 <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0104701:	55                   	push   %ebp
f0104702:	89 e5                	mov    %esp,%ebp
f0104704:	57                   	push   %edi
f0104705:	56                   	push   %esi
f0104706:	83 ec 20             	sub    $0x20,%esp
f0104709:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f010470c:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f010470d:	83 3d 80 3e 20 f0 00 	cmpl   $0x0,0xf0203e80
f0104714:	74 01                	je     f0104717 <trap+0x16>
		asm volatile("hlt");
f0104716:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104717:	e8 37 1f 00 00       	call   f0106653 <cpunum>
f010471c:	6b d0 74             	imul   $0x74,%eax,%edx
f010471f:	81 c2 20 40 20 f0    	add    $0xf0204020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104725:	b8 01 00 00 00       	mov    $0x1,%eax
f010472a:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010472e:	83 f8 02             	cmp    $0x2,%eax
f0104731:	75 0c                	jne    f010473f <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0104733:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f010473a:	e8 92 21 00 00       	call   f01068d1 <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f010473f:	9c                   	pushf  
f0104740:	58                   	pop    %eax
		lock_kernel();

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104741:	f6 c4 02             	test   $0x2,%ah
f0104744:	74 24                	je     f010476a <trap+0x69>
f0104746:	c7 44 24 0c ec 81 10 	movl   $0xf01081ec,0xc(%esp)
f010474d:	f0 
f010474e:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f0104755:	f0 
f0104756:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
f010475d:	00 
f010475e:	c7 04 24 e0 81 10 f0 	movl   $0xf01081e0,(%esp)
f0104765:	e8 d6 b8 ff ff       	call   f0100040 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f010476a:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010476e:	83 e0 03             	and    $0x3,%eax
f0104771:	66 83 f8 03          	cmp    $0x3,%ax
f0104775:	0f 85 a7 00 00 00    	jne    f0104822 <trap+0x121>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		assert(curenv);
f010477b:	e8 d3 1e 00 00       	call   f0106653 <cpunum>
f0104780:	6b c0 74             	imul   $0x74,%eax,%eax
f0104783:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f010478a:	75 24                	jne    f01047b0 <trap+0xaf>
f010478c:	c7 44 24 0c 05 82 10 	movl   $0xf0108205,0xc(%esp)
f0104793:	f0 
f0104794:	c7 44 24 08 73 7c 10 	movl   $0xf0107c73,0x8(%esp)
f010479b:	f0 
f010479c:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
f01047a3:	00 
f01047a4:	c7 04 24 e0 81 10 f0 	movl   $0xf01081e0,(%esp)
f01047ab:	e8 90 b8 ff ff       	call   f0100040 <_panic>
f01047b0:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f01047b7:	e8 15 21 00 00       	call   f01068d1 <spin_lock>
		lock_kernel();
		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f01047bc:	e8 92 1e 00 00       	call   f0106653 <cpunum>
f01047c1:	6b c0 74             	imul   $0x74,%eax,%eax
f01047c4:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01047ca:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01047ce:	75 2d                	jne    f01047fd <trap+0xfc>
			env_free(curenv);
f01047d0:	e8 7e 1e 00 00       	call   f0106653 <cpunum>
f01047d5:	6b c0 74             	imul   $0x74,%eax,%eax
f01047d8:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01047de:	89 04 24             	mov    %eax,(%esp)
f01047e1:	e8 f5 f4 ff ff       	call   f0103cdb <env_free>
			curenv = NULL;
f01047e6:	e8 68 1e 00 00       	call   f0106653 <cpunum>
f01047eb:	6b c0 74             	imul   $0x74,%eax,%eax
f01047ee:	c7 80 28 40 20 f0 00 	movl   $0x0,-0xfdfbfd8(%eax)
f01047f5:	00 00 00 
			sched_yield();
f01047f8:	e8 1a 03 00 00       	call   f0104b17 <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f01047fd:	e8 51 1e 00 00       	call   f0106653 <cpunum>
f0104802:	6b c0 74             	imul   $0x74,%eax,%eax
f0104805:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f010480b:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104810:	89 c7                	mov    %eax,%edi
f0104812:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104814:	e8 3a 1e 00 00       	call   f0106653 <cpunum>
f0104819:	6b c0 74             	imul   $0x74,%eax,%eax
f010481c:	8b b0 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0104822:	89 35 60 3a 20 f0    	mov    %esi,0xf0203a60
}

static void
trap_dispatch(struct Trapframe *tf)
{
	switch (tf->tf_trapno) {
f0104828:	8b 46 28             	mov    0x28(%esi),%eax
f010482b:	83 f8 0e             	cmp    $0xe,%eax
f010482e:	74 20                	je     f0104850 <trap+0x14f>
f0104830:	83 f8 30             	cmp    $0x30,%eax
f0104833:	74 23                	je     f0104858 <trap+0x157>
f0104835:	83 f8 03             	cmp    $0x3,%eax
f0104838:	75 53                	jne    f010488d <trap+0x18c>
		case T_BRKPT:
			monitor(tf);
f010483a:	89 34 24             	mov    %esi,(%esp)
f010483d:	e8 96 c1 ff ff       	call   f01009d8 <monitor>
			cprintf("return from breakpoint....\n");
f0104842:	c7 04 24 0c 82 10 f0 	movl   $0xf010820c,(%esp)
f0104849:	e8 23 f9 ff ff       	call   f0104171 <cprintf>
f010484e:	eb 3d                	jmp    f010488d <trap+0x18c>
			break;

		case T_PGFLT:
			// page_fault_handler will not return
			page_fault_handler(tf);
f0104850:	89 34 24             	mov    %esi,(%esp)
f0104853:	e8 3a fd ff ff       	call   f0104592 <page_fault_handler>

		case T_SYSCALL:
			syscall(tf->tf_regs.reg_eax,
f0104858:	8b 46 04             	mov    0x4(%esi),%eax
f010485b:	89 44 24 14          	mov    %eax,0x14(%esp)
f010485f:	8b 06                	mov    (%esi),%eax
f0104861:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104865:	8b 46 10             	mov    0x10(%esi),%eax
f0104868:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010486c:	8b 46 18             	mov    0x18(%esi),%eax
f010486f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104873:	8b 46 14             	mov    0x14(%esi),%eax
f0104876:	89 44 24 04          	mov    %eax,0x4(%esp)
f010487a:	8b 46 1c             	mov    0x1c(%esi),%eax
f010487d:	89 04 24             	mov    %eax,(%esp)
f0104880:	e8 d2 03 00 00       	call   f0104c57 <syscall>
							tf->tf_regs.reg_edx,
							tf->tf_regs.reg_ecx,
							tf->tf_regs.reg_ebx,
							tf->tf_regs.reg_edi,
							tf->tf_regs.reg_esi);
			asm volatile("movl %%eax, %0\n" : "=m"(tf->tf_regs.reg_eax) ::);
f0104885:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104888:	e9 91 00 00 00       	jmp    f010491e <trap+0x21d>
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f010488d:	8b 46 28             	mov    0x28(%esi),%eax
f0104890:	83 f8 27             	cmp    $0x27,%eax
f0104893:	75 16                	jne    f01048ab <trap+0x1aa>
		cprintf("Spurious interrupt on irq 7\n");
f0104895:	c7 04 24 28 82 10 f0 	movl   $0xf0108228,(%esp)
f010489c:	e8 d0 f8 ff ff       	call   f0104171 <cprintf>
		print_trapframe(tf);
f01048a1:	89 34 24             	mov    %esi,(%esp)
f01048a4:	e8 4c fb ff ff       	call   f01043f5 <print_trapframe>
f01048a9:	eb 73                	jmp    f010491e <trap+0x21d>
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f01048ab:	83 f8 20             	cmp    $0x20,%eax
f01048ae:	66 90                	xchg   %ax,%ax
f01048b0:	75 0a                	jne    f01048bc <trap+0x1bb>
		lapic_eoi();
f01048b2:	e8 e9 1e 00 00       	call   f01067a0 <lapic_eoi>
		sched_yield();
f01048b7:	e8 5b 02 00 00       	call   f0104b17 <sched_yield>
	}

	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f01048bc:	83 f8 21             	cmp    $0x21,%eax
f01048bf:	90                   	nop
f01048c0:	75 07                	jne    f01048c9 <trap+0x1c8>
		kbd_intr();
f01048c2:	e8 a7 bd ff ff       	call   f010066e <kbd_intr>
f01048c7:	eb 55                	jmp    f010491e <trap+0x21d>
		return;
	}

	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f01048c9:	83 f8 24             	cmp    $0x24,%eax
f01048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01048d0:	75 07                	jne    f01048d9 <trap+0x1d8>
		serial_intr();
f01048d2:	e8 7b bd ff ff       	call   f0100652 <serial_intr>
f01048d7:	eb 45                	jmp    f010491e <trap+0x21d>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f01048d9:	89 34 24             	mov    %esi,(%esp)
f01048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01048e0:	e8 10 fb ff ff       	call   f01043f5 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01048e5:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01048ea:	75 1c                	jne    f0104908 <trap+0x207>
		panic("unhandled trap in kernel");
f01048ec:	c7 44 24 08 45 82 10 	movl   $0xf0108245,0x8(%esp)
f01048f3:	f0 
f01048f4:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
f01048fb:	00 
f01048fc:	c7 04 24 e0 81 10 f0 	movl   $0xf01081e0,(%esp)
f0104903:	e8 38 b7 ff ff       	call   f0100040 <_panic>
	else {
		env_destroy(curenv);
f0104908:	e8 46 1d 00 00       	call   f0106653 <cpunum>
f010490d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104910:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104916:	89 04 24             	mov    %eax,(%esp)
f0104919:	e8 88 f5 ff ff       	call   f0103ea6 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f010491e:	e8 30 1d 00 00       	call   f0106653 <cpunum>
f0104923:	6b c0 74             	imul   $0x74,%eax,%eax
f0104926:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f010492d:	74 2a                	je     f0104959 <trap+0x258>
f010492f:	e8 1f 1d 00 00       	call   f0106653 <cpunum>
f0104934:	6b c0 74             	imul   $0x74,%eax,%eax
f0104937:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f010493d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104941:	75 16                	jne    f0104959 <trap+0x258>
		env_run(curenv);
f0104943:	e8 0b 1d 00 00       	call   f0106653 <cpunum>
f0104948:	6b c0 74             	imul   $0x74,%eax,%eax
f010494b:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104951:	89 04 24             	mov    %eax,(%esp)
f0104954:	e8 ee f5 ff ff       	call   f0103f47 <env_run>
	else
		sched_yield();
f0104959:	e8 b9 01 00 00       	call   f0104b17 <sched_yield>

f010495e <divide_fault>:

/*
 * 0 ~ 7, 16, 18, 19 no error code
 */
.text
TRAPHANDLER_NOEC(divide_fault, T_DIVIDE);
f010495e:	6a 00                	push   $0x0
f0104960:	6a 00                	push   $0x0
f0104962:	e9 97 00 00 00       	jmp    f01049fe <_alltraps>
f0104967:	90                   	nop

f0104968 <debug_exception>:
TRAPHANDLER_NOEC(debug_exception, T_DEBUG);
f0104968:	6a 00                	push   $0x0
f010496a:	6a 01                	push   $0x1
f010496c:	e9 8d 00 00 00       	jmp    f01049fe <_alltraps>
f0104971:	90                   	nop

f0104972 <nmi_interrupt>:
TRAPHANDLER_NOEC(nmi_interrupt, T_NMI);
f0104972:	6a 00                	push   $0x0
f0104974:	6a 02                	push   $0x2
f0104976:	e9 83 00 00 00       	jmp    f01049fe <_alltraps>
f010497b:	90                   	nop

f010497c <breakpoint_trap>:
TRAPHANDLER_NOEC(breakpoint_trap, T_BRKPT);
f010497c:	6a 00                	push   $0x0
f010497e:	6a 03                	push   $0x3
f0104980:	eb 7c                	jmp    f01049fe <_alltraps>

f0104982 <overflow_trap>:
TRAPHANDLER_NOEC(overflow_trap, T_OFLOW);
f0104982:	6a 00                	push   $0x0
f0104984:	6a 04                	push   $0x4
f0104986:	eb 76                	jmp    f01049fe <_alltraps>

f0104988 <bounds_check_fault>:
TRAPHANDLER_NOEC(bounds_check_fault, T_BOUND);
f0104988:	6a 00                	push   $0x0
f010498a:	6a 05                	push   $0x5
f010498c:	eb 70                	jmp    f01049fe <_alltraps>

f010498e <invalid_opcode_fault>:
TRAPHANDLER_NOEC(invalid_opcode_fault, T_ILLOP);
f010498e:	6a 00                	push   $0x0
f0104990:	6a 06                	push   $0x6
f0104992:	eb 6a                	jmp    f01049fe <_alltraps>

f0104994 <device_not_available_fault>:
TRAPHANDLER_NOEC(device_not_available_fault, T_DEVICE);
f0104994:	6a 00                	push   $0x0
f0104996:	6a 07                	push   $0x7
f0104998:	eb 64                	jmp    f01049fe <_alltraps>

f010499a <floating_point_error_fault>:
TRAPHANDLER_NOEC(floating_point_error_fault, T_FPERR);
f010499a:	6a 00                	push   $0x0
f010499c:	6a 10                	push   $0x10
f010499e:	eb 5e                	jmp    f01049fe <_alltraps>

f01049a0 <machine_check_fault>:
TRAPHANDLER_NOEC(machine_check_fault, T_MCHK);
f01049a0:	6a 00                	push   $0x0
f01049a2:	6a 12                	push   $0x12
f01049a4:	eb 58                	jmp    f01049fe <_alltraps>

f01049a6 <simd_fault>:
TRAPHANDLER_NOEC(simd_fault, T_SIMDERR);
f01049a6:	6a 00                	push   $0x0
f01049a8:	6a 13                	push   $0x13
f01049aa:	eb 52                	jmp    f01049fe <_alltraps>

f01049ac <double_fault_abort>:

/*
 * 8, 10 ~ 14, 17 with error code
 */
TRAPHANDLER(double_fault_abort, T_DBLFLT);
f01049ac:	6a 08                	push   $0x8
f01049ae:	eb 4e                	jmp    f01049fe <_alltraps>

f01049b0 <invalid_tss_fault>:
TRAPHANDLER(invalid_tss_fault, T_TSS);
f01049b0:	6a 0a                	push   $0xa
f01049b2:	eb 4a                	jmp    f01049fe <_alltraps>

f01049b4 <segment_not_present_fault>:
TRAPHANDLER(segment_not_present_fault, T_SEGNP);
f01049b4:	6a 0b                	push   $0xb
f01049b6:	eb 46                	jmp    f01049fe <_alltraps>

f01049b8 <stack_exception_fault>:
TRAPHANDLER(stack_exception_fault, T_STACK);
f01049b8:	6a 0c                	push   $0xc
f01049ba:	eb 42                	jmp    f01049fe <_alltraps>

f01049bc <general_protection_fault>:
TRAPHANDLER(general_protection_fault, T_GPFLT);
f01049bc:	6a 0d                	push   $0xd
f01049be:	eb 3e                	jmp    f01049fe <_alltraps>

f01049c0 <page_fault>:
TRAPHANDLER(page_fault, T_PGFLT);
f01049c0:	6a 0e                	push   $0xe
f01049c2:	eb 3a                	jmp    f01049fe <_alltraps>

f01049c4 <align_check_fault>:
TRAPHANDLER(align_check_fault, T_ALIGN);
f01049c4:	6a 11                	push   $0x11
f01049c6:	eb 36                	jmp    f01049fe <_alltraps>

f01049c8 <reserved_9>:

/*
 * System Reserved
 */
TRAPHANDLER_NOEC(reserved_9, T_COPROC);
f01049c8:	6a 00                	push   $0x0
f01049ca:	6a 09                	push   $0x9
f01049cc:	eb 30                	jmp    f01049fe <_alltraps>

f01049ce <reserved_15>:
TRAPHANDLER_NOEC(reserved_15, T_RES);
f01049ce:	6a 00                	push   $0x0
f01049d0:	6a 0f                	push   $0xf
f01049d2:	eb 2a                	jmp    f01049fe <_alltraps>

f01049d4 <syscall_trap>:

/*
 * System Call
 */
TRAPHANDLER_NOEC(syscall_trap, T_SYSCALL);
f01049d4:	6a 00                	push   $0x0
f01049d6:	6a 30                	push   $0x30
f01049d8:	eb 24                	jmp    f01049fe <_alltraps>

f01049da <timer_int>:

/*
 * External Interrupt
 */
TRAPHANDLER_NOEC(timer_int, IRQ_TIMER + IRQ_OFFSET);
f01049da:	6a 00                	push   $0x0
f01049dc:	6a 20                	push   $0x20
f01049de:	eb 1e                	jmp    f01049fe <_alltraps>

f01049e0 <kbd_int>:
TRAPHANDLER_NOEC(kbd_int, IRQ_KBD + IRQ_OFFSET);
f01049e0:	6a 00                	push   $0x0
f01049e2:	6a 21                	push   $0x21
f01049e4:	eb 18                	jmp    f01049fe <_alltraps>

f01049e6 <serial_int>:
TRAPHANDLER_NOEC(serial_int, IRQ_SERIAL + IRQ_OFFSET);
f01049e6:	6a 00                	push   $0x0
f01049e8:	6a 24                	push   $0x24
f01049ea:	eb 12                	jmp    f01049fe <_alltraps>

f01049ec <spurious_int>:
TRAPHANDLER_NOEC(spurious_int, IRQ_SPURIOUS + IRQ_OFFSET);
f01049ec:	6a 00                	push   $0x0
f01049ee:	6a 27                	push   $0x27
f01049f0:	eb 0c                	jmp    f01049fe <_alltraps>

f01049f2 <ide_int>:
TRAPHANDLER_NOEC(ide_int, IRQ_IDE + IRQ_OFFSET);
f01049f2:	6a 00                	push   $0x0
f01049f4:	6a 2e                	push   $0x2e
f01049f6:	eb 06                	jmp    f01049fe <_alltraps>

f01049f8 <error_int>:
TRAPHANDLER_NOEC(error_int, IRQ_ERROR + IRQ_OFFSET);
f01049f8:	6a 00                	push   $0x0
f01049fa:	6a 33                	push   $0x33
f01049fc:	eb 00                	jmp    f01049fe <_alltraps>

f01049fe <_alltraps>:

.text
_alltraps:
 	# setup the remaining part of the trap frame
 	pushl %ds
f01049fe:	1e                   	push   %ds
 	pushl %es
f01049ff:	06                   	push   %es
 	pushal
f0104a00:	60                   	pusha  

 	# Load GD_KD to ds and es
 	xor %ax, %ax
f0104a01:	66 31 c0             	xor    %ax,%ax
 	movw $GD_KD, %ax
f0104a04:	66 b8 10 00          	mov    $0x10,%ax
 	movw %ax, %ds
f0104a08:	8e d8                	mov    %eax,%ds
 	movw %ax, %es
f0104a0a:	8e c0                	mov    %eax,%es

 	# Arugment passing and call trap
 	pushl %esp
f0104a0c:	54                   	push   %esp
 	call trap
f0104a0d:	e8 ef fc ff ff       	call   f0104701 <trap>

 	# resotre
 	addl $0x04, %esp
f0104a12:	83 c4 04             	add    $0x4,%esp
 	popal
f0104a15:	61                   	popa   
 	popl %es
f0104a16:	07                   	pop    %es
 	popl %ds
f0104a17:	1f                   	pop    %ds
 	# ignore the trap number and 0 padding
 	addl $0x08, %esp
f0104a18:	83 c4 08             	add    $0x8,%esp
 	iret
f0104a1b:	cf                   	iret   
f0104a1c:	66 90                	xchg   %ax,%ax
f0104a1e:	66 90                	xchg   %ax,%ax

f0104a20 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104a20:	55                   	push   %ebp
f0104a21:	89 e5                	mov    %esp,%ebp
f0104a23:	83 ec 18             	sub    $0x18,%esp
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104a26:	8b 15 4c 32 20 f0    	mov    0xf020324c,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104a2c:	8b 42 54             	mov    0x54(%edx),%eax
f0104a2f:	83 e8 01             	sub    $0x1,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104a32:	83 f8 02             	cmp    $0x2,%eax
f0104a35:	76 43                	jbe    f0104a7a <sched_halt+0x5a>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104a37:	b8 01 00 00 00       	mov    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104a3c:	8b 8a d0 00 00 00    	mov    0xd0(%edx),%ecx
f0104a42:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104a45:	83 f9 02             	cmp    $0x2,%ecx
f0104a48:	76 0f                	jbe    f0104a59 <sched_halt+0x39>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104a4a:	83 c0 01             	add    $0x1,%eax
f0104a4d:	83 c2 7c             	add    $0x7c,%edx
f0104a50:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104a55:	75 e5                	jne    f0104a3c <sched_halt+0x1c>
f0104a57:	eb 07                	jmp    f0104a60 <sched_halt+0x40>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f0104a59:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104a5e:	75 1a                	jne    f0104a7a <sched_halt+0x5a>
		cprintf("No runnable environments in the system!\n");
f0104a60:	c7 04 24 48 84 10 f0 	movl   $0xf0108448,(%esp)
f0104a67:	e8 05 f7 ff ff       	call   f0104171 <cprintf>
		while (1)
			monitor(NULL);
f0104a6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0104a73:	e8 60 bf ff ff       	call   f01009d8 <monitor>
f0104a78:	eb f2                	jmp    f0104a6c <sched_halt+0x4c>
	}
	cprintf("CPU %d is halt.\n", cpunum());
f0104a7a:	e8 d4 1b 00 00       	call   f0106653 <cpunum>
f0104a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a83:	c7 04 24 71 84 10 f0 	movl   $0xf0108471,(%esp)
f0104a8a:	e8 e2 f6 ff ff       	call   f0104171 <cprintf>
	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104a8f:	e8 bf 1b 00 00       	call   f0106653 <cpunum>
f0104a94:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a97:	c7 80 28 40 20 f0 00 	movl   $0x0,-0xfdfbfd8(%eax)
f0104a9e:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104aa1:	a1 8c 3e 20 f0       	mov    0xf0203e8c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104aa6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104aab:	77 20                	ja     f0104acd <sched_halt+0xad>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104aad:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104ab1:	c7 44 24 08 a8 6d 10 	movl   $0xf0106da8,0x8(%esp)
f0104ab8:	f0 
f0104ab9:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
f0104ac0:	00 
f0104ac1:	c7 04 24 82 84 10 f0 	movl   $0xf0108482,(%esp)
f0104ac8:	e8 73 b5 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104acd:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0104ad2:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104ad5:	e8 79 1b 00 00       	call   f0106653 <cpunum>
f0104ada:	6b d0 74             	imul   $0x74,%eax,%edx
f0104add:	81 c2 20 40 20 f0    	add    $0xf0204020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104ae3:	b8 02 00 00 00       	mov    $0x2,%eax
f0104ae8:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0104aec:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f0104af3:	e8 af 1e 00 00       	call   f01069a7 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0104af8:	f3 90                	pause  
		"movl %0, %%esp\n"
		"pushl $0\n"
		"pushl $0\n"
		"sti\n"
		"hlt\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104afa:	e8 54 1b 00 00       	call   f0106653 <cpunum>
f0104aff:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f0104b02:	8b 80 30 40 20 f0    	mov    -0xfdfbfd0(%eax),%eax
f0104b08:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104b0d:	89 c4                	mov    %eax,%esp
f0104b0f:	6a 00                	push   $0x0
f0104b11:	6a 00                	push   $0x0
f0104b13:	fb                   	sti    
f0104b14:	f4                   	hlt    
		"pushl $0\n"
		"pushl $0\n"
		"sti\n"
		"hlt\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f0104b15:	c9                   	leave  
f0104b16:	c3                   	ret    

f0104b17 <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f0104b17:	55                   	push   %ebp
f0104b18:	89 e5                	mov    %esp,%ebp
f0104b1a:	53                   	push   %ebx
f0104b1b:	83 ec 14             	sub    $0x14,%esp
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	int idx = curenv ? (curenv - envs + 1) % NENV : 0;
f0104b1e:	e8 30 1b 00 00       	call   f0106653 <cpunum>
f0104b23:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b26:	ba 00 00 00 00       	mov    $0x0,%edx
f0104b2b:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f0104b32:	74 32                	je     f0104b66 <sched_yield+0x4f>
f0104b34:	e8 1a 1b 00 00       	call   f0106653 <cpunum>
f0104b39:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b3c:	8b 90 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%edx
f0104b42:	2b 15 4c 32 20 f0    	sub    0xf020324c,%edx
f0104b48:	c1 fa 02             	sar    $0x2,%edx
f0104b4b:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0104b51:	83 c2 01             	add    $0x1,%edx
f0104b54:	89 d0                	mov    %edx,%eax
f0104b56:	c1 f8 1f             	sar    $0x1f,%eax
f0104b59:	c1 e8 16             	shr    $0x16,%eax
f0104b5c:	01 c2                	add    %eax,%edx
f0104b5e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0104b64:	29 c2                	sub    %eax,%edx
	int cnt = 0;
	while (cnt < NENV) {
		if (envs[idx].env_status == ENV_RUNNABLE) {
f0104b66:	8b 1d 4c 32 20 f0    	mov    0xf020324c,%ebx
f0104b6c:	6b ca 7c             	imul   $0x7c,%edx,%ecx
f0104b6f:	01 d9                	add    %ebx,%ecx
f0104b71:	83 79 54 02          	cmpl   $0x2,0x54(%ecx)
f0104b75:	75 72                	jne    f0104be9 <sched_yield+0xd2>
f0104b77:	eb 26                	jmp    f0104b9f <sched_yield+0x88>
f0104b79:	6b c8 7c             	imul   $0x7c,%eax,%ecx
f0104b7c:	01 d9                	add    %ebx,%ecx
f0104b7e:	83 79 54 02          	cmpl   $0x2,0x54(%ecx)
f0104b82:	74 1b                	je     f0104b9f <sched_yield+0x88>
			idle = envs + idx;
			break;
		}
		++cnt;
		idx = (idx + 1) % NENV;
f0104b84:	83 c0 01             	add    $0x1,%eax
f0104b87:	89 c1                	mov    %eax,%ecx
f0104b89:	c1 f9 1f             	sar    $0x1f,%ecx
f0104b8c:	c1 e9 16             	shr    $0x16,%ecx
f0104b8f:	01 c8                	add    %ecx,%eax
f0104b91:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104b96:	29 c8                	sub    %ecx,%eax
	// below to halt the cpu.

	// LAB 4: Your code here.
	int idx = curenv ? (curenv - envs + 1) % NENV : 0;
	int cnt = 0;
	while (cnt < NENV) {
f0104b98:	83 ea 01             	sub    $0x1,%edx
f0104b9b:	75 dc                	jne    f0104b79 <sched_yield+0x62>
f0104b9d:	eb 04                	jmp    f0104ba3 <sched_yield+0x8c>
		}
		++cnt;
		idx = (idx + 1) % NENV;
	}

	if (!idle && curenv && curenv->env_status == ENV_RUNNING) {
f0104b9f:	85 c9                	test   %ecx,%ecx
f0104ba1:	75 37                	jne    f0104bda <sched_yield+0xc3>
f0104ba3:	e8 ab 1a 00 00       	call   f0106653 <cpunum>
f0104ba8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bab:	83 b8 28 40 20 f0 00 	cmpl   $0x0,-0xfdfbfd8(%eax)
f0104bb2:	74 2e                	je     f0104be2 <sched_yield+0xcb>
f0104bb4:	e8 9a 1a 00 00       	call   f0106653 <cpunum>
f0104bb9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bbc:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104bc2:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104bc6:	75 1a                	jne    f0104be2 <sched_yield+0xcb>
		idle = curenv;
f0104bc8:	e8 86 1a 00 00       	call   f0106653 <cpunum>
f0104bcd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bd0:	8b 88 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%ecx
	}

	if (idle) {
f0104bd6:	85 c9                	test   %ecx,%ecx
f0104bd8:	74 08                	je     f0104be2 <sched_yield+0xcb>
		env_run(idle);
f0104bda:	89 0c 24             	mov    %ecx,(%esp)
f0104bdd:	e8 65 f3 ff ff       	call   f0103f47 <env_run>
	}

	// sched_halt never returns
	sched_halt();
f0104be2:	e8 39 fe ff ff       	call   f0104a20 <sched_halt>
f0104be7:	eb 1f                	jmp    f0104c08 <sched_yield+0xf1>
		if (envs[idx].env_status == ENV_RUNNABLE) {
			idle = envs + idx;
			break;
		}
		++cnt;
		idx = (idx + 1) % NENV;
f0104be9:	83 c2 01             	add    $0x1,%edx
f0104bec:	89 d1                	mov    %edx,%ecx
f0104bee:	c1 f9 1f             	sar    $0x1f,%ecx
f0104bf1:	c1 e9 16             	shr    $0x16,%ecx
f0104bf4:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
f0104bf7:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104bfc:	29 c8                	sub    %ecx,%eax
f0104bfe:	ba ff 03 00 00       	mov    $0x3ff,%edx
f0104c03:	e9 71 ff ff ff       	jmp    f0104b79 <sched_yield+0x62>
		env_run(idle);
	}

	// sched_halt never returns
	sched_halt();
}
f0104c08:	83 c4 14             	add    $0x14,%esp
f0104c0b:	5b                   	pop    %ebx
f0104c0c:	5d                   	pop    %ebp
f0104c0d:	c3                   	ret    
f0104c0e:	66 90                	xchg   %ax,%ax

f0104c10 <check_perm>:
	e->env_pgfault_upcall = func;
	return 0;
}

// return 0 means ok, < 0 error
static int check_perm(int perm) {
f0104c10:	55                   	push   %ebp
f0104c11:	89 e5                	mov    %esp,%ebp
		 0,
		 0 
	};

	int i;
	for (i = 0; i < sizeof(perm_bit) / sizeof(int); ++i) {
f0104c13:	ba 00 00 00 00       	mov    $0x0,%edx
		switch (perm_bit[i]) {
f0104c18:	8b 0c 95 60 85 10 f0 	mov    -0xfef7aa0(,%edx,4),%ecx
f0104c1f:	83 f9 ff             	cmp    $0xffffffff,%ecx
f0104c22:	74 0e                	je     f0104c32 <check_perm+0x22>
f0104c24:	83 f9 01             	cmp    $0x1,%ecx
f0104c27:	75 0e                	jne    f0104c37 <check_perm+0x27>
			case 1:
				if (!(perm & (1 << i))) {
f0104c29:	0f a3 d0             	bt     %edx,%eax
f0104c2c:	72 09                	jb     f0104c37 <check_perm+0x27>
f0104c2e:	66 90                	xchg   %ax,%ax
f0104c30:	eb 10                	jmp    f0104c42 <check_perm+0x32>
					return -E_INVAL;
				}
				break;

			case -1:
				if (perm & (1 << i)) {
f0104c32:	0f a3 d0             	bt     %edx,%eax
f0104c35:	72 12                	jb     f0104c49 <check_perm+0x39>
		 0,
		 0 
	};

	int i;
	for (i = 0; i < sizeof(perm_bit) / sizeof(int); ++i) {
f0104c37:	83 c2 01             	add    $0x1,%edx
f0104c3a:	83 fa 0c             	cmp    $0xc,%edx
f0104c3d:	75 d9                	jne    f0104c18 <check_perm+0x8>
f0104c3f:	90                   	nop
f0104c40:	eb 0e                	jmp    f0104c50 <check_perm+0x40>
		switch (perm_bit[i]) {
			case 1:
				if (!(perm & (1 << i))) {
					return -E_INVAL;
f0104c42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c47:	eb 0c                	jmp    f0104c55 <check_perm+0x45>
				}
				break;

			case -1:
				if (perm & (1 << i)) {
					return -E_INVAL;
f0104c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c4e:	eb 05                	jmp    f0104c55 <check_perm+0x45>
			default:
				break;
		}
	}

	return 0;
f0104c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104c55:	5d                   	pop    %ebp
f0104c56:	c3                   	ret    

f0104c57 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104c57:	55                   	push   %ebp
f0104c58:	89 e5                	mov    %esp,%ebp
f0104c5a:	57                   	push   %edi
f0104c5b:	56                   	push   %esi
f0104c5c:	53                   	push   %ebx
f0104c5d:	83 ec 2c             	sub    $0x2c,%esp
f0104c60:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	switch (syscallno) {
f0104c66:	83 f8 0d             	cmp    $0xd,%eax
f0104c69:	0f 87 f7 05 00 00    	ja     f0105266 <syscall+0x60f>
f0104c6f:	ff 24 85 20 85 10 f0 	jmp    *-0xfef7ae0(,%eax,4)
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
	user_mem_assert(curenv, s, len, PTE_P | PTE_U);
f0104c76:	e8 d8 19 00 00       	call   f0106653 <cpunum>
f0104c7b:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0104c82:	00 
f0104c83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104c87:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104c8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104c8e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c91:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104c97:	89 04 24             	mov    %eax,(%esp)
f0104c9a:	e8 60 eb ff ff       	call   f01037ff <user_mem_assert>

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0104c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ca6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104caa:	c7 04 24 8f 84 10 f0 	movl   $0xf010848f,(%esp)
f0104cb1:	e8 bb f4 ff ff       	call   f0104171 <cprintf>
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((const char*)a1, a2);
			return 0;
f0104cb6:	b8 00 00 00 00       	mov    $0x0,%eax
f0104cbb:	e9 b2 05 00 00       	jmp    f0105272 <syscall+0x61b>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0104cc0:	e8 bb b9 ff ff       	call   f0100680 <cons_getc>
		case SYS_cputs:
			sys_cputs((const char*)a1, a2);
			return 0;

		case SYS_cgetc:
			return sys_cgetc();
f0104cc5:	e9 a8 05 00 00       	jmp    f0105272 <syscall+0x61b>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0104cd0:	e8 7e 19 00 00       	call   f0106653 <cpunum>
f0104cd5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cd8:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104cde:	8b 40 48             	mov    0x48(%eax),%eax

		case SYS_cgetc:
			return sys_cgetc();

		case SYS_getenvid:
			return sys_getenvid();
f0104ce1:	e9 8c 05 00 00       	jmp    f0105272 <syscall+0x61b>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104ce6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104ced:	00 
f0104cee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cf8:	89 04 24             	mov    %eax,(%esp)
f0104cfb:	e8 d4 eb ff ff       	call   f01038d4 <envid2env>
		return r;
f0104d00:	89 c2                	mov    %eax,%edx
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104d02:	85 c0                	test   %eax,%eax
f0104d04:	78 6e                	js     f0104d74 <syscall+0x11d>
		return r;
	if (e == curenv) {
f0104d06:	e8 48 19 00 00       	call   f0106653 <cpunum>
f0104d0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104d0e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d11:	39 90 28 40 20 f0    	cmp    %edx,-0xfdfbfd8(%eax)
f0104d17:	75 23                	jne    f0104d3c <syscall+0xe5>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104d19:	e8 35 19 00 00       	call   f0106653 <cpunum>
f0104d1e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d21:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104d27:	8b 40 48             	mov    0x48(%eax),%eax
f0104d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104d2e:	c7 04 24 94 84 10 f0 	movl   $0xf0108494,(%esp)
f0104d35:	e8 37 f4 ff ff       	call   f0104171 <cprintf>
f0104d3a:	eb 28                	jmp    f0104d64 <syscall+0x10d>
	} else {
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104d3c:	8b 5a 48             	mov    0x48(%edx),%ebx
f0104d3f:	e8 0f 19 00 00       	call   f0106653 <cpunum>
f0104d44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104d48:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d4b:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104d51:	8b 40 48             	mov    0x48(%eax),%eax
f0104d54:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104d58:	c7 04 24 af 84 10 f0 	movl   $0xf01084af,(%esp)
f0104d5f:	e8 0d f4 ff ff       	call   f0104171 <cprintf>
	}
	env_destroy(e);
f0104d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104d67:	89 04 24             	mov    %eax,(%esp)
f0104d6a:	e8 37 f1 ff ff       	call   f0103ea6 <env_destroy>
	return 0;
f0104d6f:	ba 00 00 00 00       	mov    $0x0,%edx

		case SYS_getenvid:
			return sys_getenvid();

		case SYS_env_destroy:
			return sys_env_destroy(a1);
f0104d74:	89 d0                	mov    %edx,%eax
f0104d76:	e9 f7 04 00 00       	jmp    f0105272 <syscall+0x61b>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0104d7b:	e8 97 fd ff ff       	call   f0104b17 <sched_yield>
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.
	// LAB 4: Your code here.
	struct Env* child_env;
	int err_code = env_alloc(&child_env, curenv->env_id);
f0104d80:	e8 ce 18 00 00       	call   f0106653 <cpunum>
f0104d85:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d88:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0104d8e:	8b 40 48             	mov    0x48(%eax),%eax
f0104d91:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104d95:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104d98:	89 04 24             	mov    %eax,(%esp)
f0104d9b:	e8 71 ec ff ff       	call   f0103a11 <env_alloc>
	if (err_code < 0) {
		return err_code;
f0104da0:	89 c2                	mov    %eax,%edx
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.
	// LAB 4: Your code here.
	struct Env* child_env;
	int err_code = env_alloc(&child_env, curenv->env_id);
	if (err_code < 0) {
f0104da2:	85 c0                	test   %eax,%eax
f0104da4:	78 2e                	js     f0104dd4 <syscall+0x17d>
		return err_code;
	}
	child_env->env_status = ENV_NOT_RUNNABLE;
f0104da6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104da9:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
	child_env->env_tf = curenv->env_tf;
f0104db0:	e8 9e 18 00 00       	call   f0106653 <cpunum>
f0104db5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104db8:	8b b0 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%esi
f0104dbe:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104dc3:	89 df                	mov    %ebx,%edi
f0104dc5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	// when the child be scheded, it will restart from the trapframe
	// so we set the eax = 0, then its return value will be 0
	child_env->env_tf.tf_regs.reg_eax = 0; 
f0104dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104dca:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return child_env->env_id;
f0104dd1:	8b 50 48             	mov    0x48(%eax),%edx

		case SYS_yield:
			sys_yield();

		case SYS_exofork:
			return sys_exofork();
f0104dd4:	89 d0                	mov    %edx,%eax
f0104dd6:	e9 97 04 00 00       	jmp    f0105272 <syscall+0x61b>
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	if (((uint32_t)va) >= UTOP) {
f0104ddb:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104de1:	77 72                	ja     f0104e55 <syscall+0x1fe>
		return -E_INVAL;
	}

	if (check_perm(perm) < 0) {
f0104de3:	8b 45 14             	mov    0x14(%ebp),%eax
f0104de6:	e8 25 fe ff ff       	call   f0104c10 <check_perm>
f0104deb:	85 c0                	test   %eax,%eax
f0104ded:	78 6d                	js     f0104e5c <syscall+0x205>
		return -E_INVAL;
	}

	struct PageInfo* new_page = page_alloc(1);
f0104def:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0104df6:	e8 33 c4 ff ff       	call   f010122e <page_alloc>
f0104dfb:	89 c6                	mov    %eax,%esi
	if (!new_page) {
f0104dfd:	85 c0                	test   %eax,%eax
f0104dff:	74 62                	je     f0104e63 <syscall+0x20c>
		return -E_NO_MEM;
	}
	
	struct Env* e;
	int err_code = envid2env(envid, &e, 1);
f0104e01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104e08:	00 
f0104e09:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e10:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104e13:	89 04 24             	mov    %eax,(%esp)
f0104e16:	e8 b9 ea ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
		return err_code;
f0104e1b:	89 c1                	mov    %eax,%ecx
		return -E_NO_MEM;
	}
	
	struct Env* e;
	int err_code = envid2env(envid, &e, 1);
	if (err_code < 0) {
f0104e1d:	85 c0                	test   %eax,%eax
f0104e1f:	78 47                	js     f0104e68 <syscall+0x211>
		return err_code;
	}

	err_code = page_insert(e->env_pgdir, new_page, va, perm);
f0104e21:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e24:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104e28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104e2c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104e33:	8b 40 60             	mov    0x60(%eax),%eax
f0104e36:	89 04 24             	mov    %eax,(%esp)
f0104e39:	e8 50 c7 ff ff       	call   f010158e <page_insert>
f0104e3e:	89 c3                	mov    %eax,%ebx
	if (err_code < 0) {
		page_free(new_page);
		return err_code;
	}

	return 0;
f0104e40:	b9 00 00 00 00       	mov    $0x0,%ecx
	if (err_code < 0) {
		return err_code;
	}

	err_code = page_insert(e->env_pgdir, new_page, va, perm);
	if (err_code < 0) {
f0104e45:	85 c0                	test   %eax,%eax
f0104e47:	79 1f                	jns    f0104e68 <syscall+0x211>
		page_free(new_page);
f0104e49:	89 34 24             	mov    %esi,(%esp)
f0104e4c:	e8 62 c4 ff ff       	call   f01012b3 <page_free>
		return err_code;
f0104e51:	89 d9                	mov    %ebx,%ecx
f0104e53:	eb 13                	jmp    f0104e68 <syscall+0x211>
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	if (((uint32_t)va) >= UTOP) {
		return -E_INVAL;
f0104e55:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f0104e5a:	eb 0c                	jmp    f0104e68 <syscall+0x211>
	}

	if (check_perm(perm) < 0) {
		return -E_INVAL;
f0104e5c:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f0104e61:	eb 05                	jmp    f0104e68 <syscall+0x211>
	}

	struct PageInfo* new_page = page_alloc(1);
	if (!new_page) {
		return -E_NO_MEM;
f0104e63:	b9 fc ff ff ff       	mov    $0xfffffffc,%ecx

		case SYS_exofork:
			return sys_exofork();

		case SYS_page_alloc:
			return sys_page_alloc(a1, (void*)a2, a3);
f0104e68:	89 c8                	mov    %ecx,%eax
f0104e6a:	e9 03 04 00 00       	jmp    f0105272 <syscall+0x61b>
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	struct Env* src_e;
	struct Env* dst_e;
	int err_code = envid2env(srcenvid, &src_e, 1);
f0104e6f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104e76:	00 
f0104e77:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104e81:	89 04 24             	mov    %eax,(%esp)
f0104e84:	e8 4b ea ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
		return err_code;
f0104e89:	89 c2                	mov    %eax,%edx
	     envid_t dstenvid, void *dstva, int perm)
{
	struct Env* src_e;
	struct Env* dst_e;
	int err_code = envid2env(srcenvid, &src_e, 1);
	if (err_code < 0) {
f0104e8b:	85 c0                	test   %eax,%eax
f0104e8d:	0f 88 c9 00 00 00    	js     f0104f5c <syscall+0x305>
		return err_code;
	}

	err_code = envid2env(dstenvid, &dst_e, 1);
f0104e93:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104e9a:	00 
f0104e9b:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ea2:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ea5:	89 04 24             	mov    %eax,(%esp)
f0104ea8:	e8 27 ea ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
f0104ead:	85 c0                	test   %eax,%eax
f0104eaf:	0f 88 82 00 00 00    	js     f0104f37 <syscall+0x2e0>
		return err_code;
	}

	if (((uint32_t)srcva) >= UTOP || ((uint32_t)dstva) >= UTOP) {
f0104eb5:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104ebb:	77 7e                	ja     f0104f3b <syscall+0x2e4>
f0104ebd:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104ec4:	77 75                	ja     f0104f3b <syscall+0x2e4>
f0104ec6:	89 d8                	mov    %ebx,%eax
f0104ec8:	0b 45 18             	or     0x18(%ebp),%eax
		return -E_INVAL;
	}

	if (!IS_PAGE_ALIGNED((uint32_t)srcva) || !IS_PAGE_ALIGNED((uint32_t)dstva)) {
f0104ecb:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0104ed0:	75 70                	jne    f0104f42 <syscall+0x2eb>
		return -E_INVAL;
	}

	// find the page corresponding to srcva in src_e
	pte_t* src_pte;
	struct PageInfo* src_page = page_lookup(src_e->env_pgdir, srcva, &src_pte);
f0104ed2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ed9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104ee0:	8b 40 60             	mov    0x60(%eax),%eax
f0104ee3:	89 04 24             	mov    %eax,(%esp)
f0104ee6:	e8 cf c5 ff ff       	call   f01014ba <page_lookup>
f0104eeb:	89 c3                	mov    %eax,%ebx
	if (!src_page) {
f0104eed:	85 c0                	test   %eax,%eax
f0104eef:	74 58                	je     f0104f49 <syscall+0x2f2>
		return -E_INVAL;
	}

	if (check_perm(perm) < 0) {
f0104ef1:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104ef4:	e8 17 fd ff ff       	call   f0104c10 <check_perm>
f0104ef9:	85 c0                	test   %eax,%eax
f0104efb:	78 53                	js     f0104f50 <syscall+0x2f9>
		return -E_INVAL;
	}
	
	// the page is not writable but set write permission	
	if (!(*src_pte & PTE_W) && (perm & PTE_W)) {
f0104efd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f00:	f6 00 02             	testb  $0x2,(%eax)
f0104f03:	75 06                	jne    f0104f0b <syscall+0x2b4>
f0104f05:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104f09:	75 4c                	jne    f0104f57 <syscall+0x300>
		return -E_INVAL;
	}

	// map
	err_code = page_insert(dst_e->env_pgdir, src_page, dstva, perm);
f0104f0b:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104f0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104f12:	8b 45 18             	mov    0x18(%ebp),%eax
f0104f15:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104f19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104f1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f20:	8b 40 60             	mov    0x60(%eax),%eax
f0104f23:	89 04 24             	mov    %eax,(%esp)
f0104f26:	e8 63 c6 ff ff       	call   f010158e <page_insert>
f0104f2b:	85 c0                	test   %eax,%eax
f0104f2d:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f32:	0f 4e d0             	cmovle %eax,%edx
f0104f35:	eb 25                	jmp    f0104f5c <syscall+0x305>
		return err_code;
	}

	err_code = envid2env(dstenvid, &dst_e, 1);
	if (err_code < 0) {
		return err_code;
f0104f37:	89 c2                	mov    %eax,%edx
f0104f39:	eb 21                	jmp    f0104f5c <syscall+0x305>
	}

	if (((uint32_t)srcva) >= UTOP || ((uint32_t)dstva) >= UTOP) {
		return -E_INVAL;
f0104f3b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0104f40:	eb 1a                	jmp    f0104f5c <syscall+0x305>
	}

	if (!IS_PAGE_ALIGNED((uint32_t)srcva) || !IS_PAGE_ALIGNED((uint32_t)dstva)) {
		return -E_INVAL;
f0104f42:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0104f47:	eb 13                	jmp    f0104f5c <syscall+0x305>

	// find the page corresponding to srcva in src_e
	pte_t* src_pte;
	struct PageInfo* src_page = page_lookup(src_e->env_pgdir, srcva, &src_pte);
	if (!src_page) {
		return -E_INVAL;
f0104f49:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0104f4e:	eb 0c                	jmp    f0104f5c <syscall+0x305>
	}

	if (check_perm(perm) < 0) {
		return -E_INVAL;
f0104f50:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0104f55:	eb 05                	jmp    f0104f5c <syscall+0x305>
	}
	
	// the page is not writable but set write permission	
	if (!(*src_pte & PTE_W) && (perm & PTE_W)) {
		return -E_INVAL;
f0104f57:	ba fd ff ff ff       	mov    $0xfffffffd,%edx

		case SYS_page_alloc:
			return sys_page_alloc(a1, (void*)a2, a3);

		case SYS_page_map:
			return sys_page_map(a1, (void*)a2, a3, (void*)a4, a5);
f0104f5c:	89 d0                	mov    %edx,%eax
f0104f5e:	e9 0f 03 00 00       	jmp    f0105272 <syscall+0x61b>
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	struct Env* e;
	int err_code = envid2env(envid, &e, 1);
f0104f63:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104f6a:	00 
f0104f6b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f72:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104f75:	89 04 24             	mov    %eax,(%esp)
f0104f78:	e8 57 e9 ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
f0104f7d:	85 c0                	test   %eax,%eax
f0104f7f:	0f 88 ed 02 00 00    	js     f0105272 <syscall+0x61b>
		return err_code;
	}

	if (((uint32_t)va) >= UTOP) {
f0104f85:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104f8b:	77 24                	ja     f0104fb1 <syscall+0x35a>
		return -E_INVAL;
	}

	if (!IS_PAGE_ALIGNED((uint32_t)va)) {
f0104f8d:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0104f93:	75 26                	jne    f0104fbb <syscall+0x364>
		return -E_INVAL;
	}

	page_remove(e->env_pgdir, va);
f0104f95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f9c:	8b 40 60             	mov    0x60(%eax),%eax
f0104f9f:	89 04 24             	mov    %eax,(%esp)
f0104fa2:	e8 9e c5 ff ff       	call   f0101545 <page_remove>

	return 0;
f0104fa7:	b8 00 00 00 00       	mov    $0x0,%eax
f0104fac:	e9 c1 02 00 00       	jmp    f0105272 <syscall+0x61b>
	if (err_code < 0) {
		return err_code;
	}

	if (((uint32_t)va) >= UTOP) {
		return -E_INVAL;
f0104fb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104fb6:	e9 b7 02 00 00       	jmp    f0105272 <syscall+0x61b>
	}

	if (!IS_PAGE_ALIGNED((uint32_t)va)) {
		return -E_INVAL;
f0104fbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		case SYS_page_map:
			return sys_page_map(a1, (void*)a2, a3, (void*)a4, a5);

		case SYS_page_unmap:
			return sys_page_unmap(a1, (void*)a2);
f0104fc0:	e9 ad 02 00 00       	jmp    f0105272 <syscall+0x61b>
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
f0104fc5:	83 fb 04             	cmp    $0x4,%ebx
f0104fc8:	74 05                	je     f0104fcf <syscall+0x378>
f0104fca:	83 fb 02             	cmp    $0x2,%ebx
f0104fcd:	75 32                	jne    f0105001 <syscall+0x3aa>
		return -E_INVAL;
	}

	struct Env* e;
	int err_code = envid2env(envid, &e, 1);
f0104fcf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104fd6:	00 
f0104fd7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104fda:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104fde:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104fe1:	89 04 24             	mov    %eax,(%esp)
f0104fe4:	e8 eb e8 ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
f0104fe9:	85 c0                	test   %eax,%eax
f0104feb:	0f 88 81 02 00 00    	js     f0105272 <syscall+0x61b>
		return err_code;
	}

	e->env_status = status;
f0104ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ff4:	89 58 54             	mov    %ebx,0x54(%eax)
	return 0;
f0104ff7:	b8 00 00 00 00       	mov    $0x0,%eax
f0104ffc:	e9 71 02 00 00       	jmp    f0105272 <syscall+0x61b>
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
		return -E_INVAL;
f0105001:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105006:	e9 67 02 00 00       	jmp    f0105272 <syscall+0x61b>
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	struct Env* e;
	int err_code = envid2env(envid, &e, 1);
f010500b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105012:	00 
f0105013:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105016:	89 44 24 04          	mov    %eax,0x4(%esp)
f010501a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010501d:	89 04 24             	mov    %eax,(%esp)
f0105020:	e8 af e8 ff ff       	call   f01038d4 <envid2env>
	if (err_code < 0) {
f0105025:	85 c0                	test   %eax,%eax
f0105027:	0f 88 45 02 00 00    	js     f0105272 <syscall+0x61b>
		return err_code;
	}
	e->env_pgfault_upcall = func;
f010502d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105030:	89 58 64             	mov    %ebx,0x64(%eax)
	return 0;
f0105033:	b8 00 00 00 00       	mov    $0x0,%eax
f0105038:	e9 35 02 00 00       	jmp    f0105272 <syscall+0x61b>
{
	// LAB 4: Your code here.
	int err_code;
	struct Env* target_e;

	if ((err_code = envid2env(envid, &target_e, 0)) < 0) {
f010503d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105044:	00 
f0105045:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105048:	89 44 24 04          	mov    %eax,0x4(%esp)
f010504c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010504f:	89 04 24             	mov    %eax,(%esp)
f0105052:	e8 7d e8 ff ff       	call   f01038d4 <envid2env>
f0105057:	85 c0                	test   %eax,%eax
f0105059:	0f 88 15 01 00 00    	js     f0105174 <syscall+0x51d>
		return -E_BAD_ENV;
	}

	if (!target_e->env_ipc_recving) {
f010505f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105062:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0105066:	0f 84 12 01 00 00    	je     f010517e <syscall+0x527>
		return -E_IPC_NOT_RECV;
	}


	if (((uint32_t)srcva) < UTOP &&
f010506c:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105073:	0f 87 bc 00 00 00    	ja     f0105135 <syscall+0x4de>
f0105079:	81 78 6c ff ff bf ee 	cmpl   $0xeebfffff,0x6c(%eax)
f0105080:	0f 87 af 00 00 00    	ja     f0105135 <syscall+0x4de>
			((uint32_t)target_e->env_ipc_dstva) < UTOP) {

		if (!IS_PAGE_ALIGNED((uint32_t)srcva)) {
			return -E_INVAL;
f0105086:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax


	if (((uint32_t)srcva) < UTOP &&
			((uint32_t)target_e->env_ipc_dstva) < UTOP) {

		if (!IS_PAGE_ALIGNED((uint32_t)srcva)) {
f010508b:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0105092:	0f 85 da 01 00 00    	jne    f0105272 <syscall+0x61b>
			return -E_INVAL;
		}

		if (check_perm(perm) < 0) {
f0105098:	8b 45 18             	mov    0x18(%ebp),%eax
f010509b:	e8 70 fb ff ff       	call   f0104c10 <check_perm>
f01050a0:	89 c2                	mov    %eax,%edx
			return -E_INVAL;
f01050a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		if (!IS_PAGE_ALIGNED((uint32_t)srcva)) {
			return -E_INVAL;
		}

		if (check_perm(perm) < 0) {
f01050a7:	85 d2                	test   %edx,%edx
f01050a9:	0f 88 c3 01 00 00    	js     f0105272 <syscall+0x61b>
			return -E_INVAL;
		}

		struct PageInfo* src_page = NULL;
		pte_t* pte = NULL;
f01050af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		if (!(src_page = page_lookup(curenv->env_pgdir, srcva, &pte))) {
f01050b6:	e8 98 15 00 00       	call   f0106653 <cpunum>
f01050bb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01050be:	89 54 24 08          	mov    %edx,0x8(%esp)
f01050c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01050c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01050c9:	6b c0 74             	imul   $0x74,%eax,%eax
f01050cc:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01050d2:	8b 40 60             	mov    0x60(%eax),%eax
f01050d5:	89 04 24             	mov    %eax,(%esp)
f01050d8:	e8 dd c3 ff ff       	call   f01014ba <page_lookup>
f01050dd:	89 c2                	mov    %eax,%edx
f01050df:	85 c0                	test   %eax,%eax
f01050e1:	74 44                	je     f0105127 <syscall+0x4d0>
			return -E_INVAL;
		}

		if ((perm & PTE_W) && !(*pte & PTE_W)) {
f01050e3:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f01050e7:	74 11                	je     f01050fa <syscall+0x4a3>
			return -E_INVAL;
f01050e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		pte_t* pte = NULL;
		if (!(src_page = page_lookup(curenv->env_pgdir, srcva, &pte))) {
			return -E_INVAL;
		}

		if ((perm & PTE_W) && !(*pte & PTE_W)) {
f01050ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01050f1:	f6 01 02             	testb  $0x2,(%ecx)
f01050f4:	0f 84 78 01 00 00    	je     f0105272 <syscall+0x61b>
			return -E_INVAL;
		}

		// try page mapping
		if (target_e->env_ipc_dstva) {
f01050fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01050fd:	8b 48 6c             	mov    0x6c(%eax),%ecx
f0105100:	85 c9                	test   %ecx,%ecx
f0105102:	74 31                	je     f0105135 <syscall+0x4de>
			// map
			if ((err_code = page_insert(target_e->env_pgdir,
f0105104:	8b 7d 18             	mov    0x18(%ebp),%edi
f0105107:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010510b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010510f:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105113:	8b 40 60             	mov    0x60(%eax),%eax
f0105116:	89 04 24             	mov    %eax,(%esp)
f0105119:	e8 70 c4 ff ff       	call   f010158e <page_insert>
f010511e:	85 c0                	test   %eax,%eax
f0105120:	79 13                	jns    f0105135 <syscall+0x4de>
f0105122:	e9 4b 01 00 00       	jmp    f0105272 <syscall+0x61b>
		}

		struct PageInfo* src_page = NULL;
		pte_t* pte = NULL;
		if (!(src_page = page_lookup(curenv->env_pgdir, srcva, &pte))) {
			return -E_INVAL;
f0105127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105130:	e9 3d 01 00 00       	jmp    f0105272 <syscall+0x61b>
			}
		}
	}

	// update
	target_e->env_ipc_value = value;
f0105135:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105138:	89 5e 70             	mov    %ebx,0x70(%esi)
	target_e->env_ipc_from = curenv->env_id;
f010513b:	e8 13 15 00 00       	call   f0106653 <cpunum>
f0105140:	6b c0 74             	imul   $0x74,%eax,%eax
f0105143:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0105149:	8b 40 48             	mov    0x48(%eax),%eax
f010514c:	89 46 74             	mov    %eax,0x74(%esi)
	target_e->env_ipc_recving = 0;
f010514f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105152:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	target_e->env_status = ENV_RUNNABLE;
f0105156:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	target_e->env_tf.tf_regs.reg_eax = 0;
f010515d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	target_e->env_ipc_perm = perm;
f0105164:	8b 7d 18             	mov    0x18(%ebp),%edi
f0105167:	89 78 78             	mov    %edi,0x78(%eax)

	return 0;
f010516a:	b8 00 00 00 00       	mov    $0x0,%eax
f010516f:	e9 fe 00 00 00       	jmp    f0105272 <syscall+0x61b>
	// LAB 4: Your code here.
	int err_code;
	struct Env* target_e;

	if ((err_code = envid2env(envid, &target_e, 0)) < 0) {
		return -E_BAD_ENV;
f0105174:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105179:	e9 f4 00 00 00       	jmp    f0105272 <syscall+0x61b>
	}

	if (!target_e->env_ipc_recving) {
		return -E_IPC_NOT_RECV;
f010517e:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax

		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void*)a2);

		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void*)a3, a4);
f0105183:	e9 ea 00 00 00       	jmp    f0105272 <syscall+0x61b>
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{

	if (!IS_PAGE_ALIGNED((uint32_t)dstva)) {
f0105188:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f010518f:	0f 85 d8 00 00 00    	jne    f010526d <syscall+0x616>
		return -E_INVAL;
	}

	curenv->env_ipc_recving = 1;
f0105195:	e8 b9 14 00 00       	call   f0106653 <cpunum>
f010519a:	6b c0 74             	imul   $0x74,%eax,%eax
f010519d:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01051a3:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01051a7:	e8 a7 14 00 00       	call   f0106653 <cpunum>
f01051ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01051af:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01051b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01051b8:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f01051bb:	e8 93 14 00 00       	call   f0106653 <cpunum>
f01051c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01051c3:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01051c9:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f01051d0:	e8 42 f9 ff ff       	call   f0104b17 <sched_yield>

		case SYS_ipc_recv:
			return sys_ipc_recv((void*)a1);

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f01051d5:	89 de                	mov    %ebx,%esi
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env* e;	
	if (envid2env(envid, &e, 1) < 0) {
f01051d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01051de:	00 
f01051df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01051e2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051e6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01051e9:	89 04 24             	mov    %eax,(%esp)
f01051ec:	e8 e3 e6 ff ff       	call   f01038d4 <envid2env>
f01051f1:	85 c0                	test   %eax,%eax
f01051f3:	78 6a                	js     f010525f <syscall+0x608>
		return -E_BAD_ENV;
	}

	// check eip and esp
	if (!(tf->tf_eip >= UTEXT && tf->tf_eip < USTACKTOP &&
f01051f5:	8b 43 30             	mov    0x30(%ebx),%eax
f01051f8:	2d 00 00 80 00       	sub    $0x800000,%eax
f01051fd:	3d ff df 3f ee       	cmp    $0xee3fdfff,%eax
f0105202:	77 0f                	ja     f0105213 <syscall+0x5bc>
f0105204:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0105207:	2d 01 00 80 00       	sub    $0x800001,%eax
f010520c:	3d ff df 3f ee       	cmp    $0xee3fdfff,%eax
f0105211:	76 1c                	jbe    f010522f <syscall+0x5d8>
			 tf->tf_esp <= USTACKTOP && tf->tf_esp > UTEXT)) {
		panic("sys_env_set_trapframe:eip or esp is not valid.");
f0105213:	c7 44 24 08 d8 84 10 	movl   $0xf01084d8,0x8(%esp)
f010521a:	f0 
f010521b:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
f0105222:	00 
f0105223:	c7 04 24 c7 84 10 f0 	movl   $0xf01084c7,(%esp)
f010522a:	e8 11 ae ff ff       	call   f0100040 <_panic>
	}

	// ensure again (though env_alloc already set)
	tf->tf_ds = GD_UD | 3;
f010522f:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	tf->tf_es = GD_UD | 3;
f0105235:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	tf->tf_ss = GD_UD | 3;
f010523b:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	tf->tf_cs = GD_UT | 3;
f0105241:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	tf->tf_eflags |= FL_IF;
f0105247:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	
	e->env_tf = *tf;
f010524e:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105253:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105256:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0;
f0105258:	b8 00 00 00 00       	mov    $0x0,%eax
f010525d:	eb 13                	jmp    f0105272 <syscall+0x61b>
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env* e;	
	if (envid2env(envid, &e, 1) < 0) {
		return -E_BAD_ENV;
f010525f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		case SYS_ipc_recv:
			return sys_ipc_recv((void*)a1);

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
f0105264:	eb 0c                	jmp    f0105272 <syscall+0x61b>
	}
	return 0;
f0105266:	b8 00 00 00 00       	mov    $0x0,%eax
f010526b:	eb 05                	jmp    f0105272 <syscall+0x61b>

		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void*)a3, a4);

		case SYS_ipc_recv:
			return sys_ipc_recv((void*)a1);
f010526d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe*)a2);
	}
	return 0;
}
f0105272:	83 c4 2c             	add    $0x2c,%esp
f0105275:	5b                   	pop    %ebx
f0105276:	5e                   	pop    %esi
f0105277:	5f                   	pop    %edi
f0105278:	5d                   	pop    %ebp
f0105279:	c3                   	ret    

f010527a <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010527a:	55                   	push   %ebp
f010527b:	89 e5                	mov    %esp,%ebp
f010527d:	57                   	push   %edi
f010527e:	56                   	push   %esi
f010527f:	53                   	push   %ebx
f0105280:	83 ec 14             	sub    $0x14,%esp
f0105283:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105286:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105289:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010528c:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f010528f:	8b 1a                	mov    (%edx),%ebx
f0105291:	8b 01                	mov    (%ecx),%eax
f0105293:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (l <= r) {
f0105296:	39 c3                	cmp    %eax,%ebx
f0105298:	0f 8f 9a 00 00 00    	jg     f0105338 <stab_binsearch+0xbe>
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
f010529e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f01052a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01052a8:	01 d8                	add    %ebx,%eax
f01052aa:	89 c7                	mov    %eax,%edi
f01052ac:	c1 ef 1f             	shr    $0x1f,%edi
f01052af:	01 c7                	add    %eax,%edi
f01052b1:	d1 ff                	sar    %edi

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f01052b3:	39 df                	cmp    %ebx,%edi
f01052b5:	0f 8c c4 00 00 00    	jl     f010537f <stab_binsearch+0x105>
f01052bb:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01052be:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01052c1:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f01052c4:	0f b6 42 04          	movzbl 0x4(%edx),%eax
f01052c8:	39 f0                	cmp    %esi,%eax
f01052ca:	0f 84 b4 00 00 00    	je     f0105384 <stab_binsearch+0x10a>
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f01052d0:	89 f8                	mov    %edi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f01052d2:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f01052d5:	39 d8                	cmp    %ebx,%eax
f01052d7:	0f 8c a2 00 00 00    	jl     f010537f <stab_binsearch+0x105>
f01052dd:	0f b6 4a f8          	movzbl -0x8(%edx),%ecx
f01052e1:	83 ea 0c             	sub    $0xc,%edx
f01052e4:	39 f1                	cmp    %esi,%ecx
f01052e6:	75 ea                	jne    f01052d2 <stab_binsearch+0x58>
f01052e8:	e9 99 00 00 00       	jmp    f0105386 <stab_binsearch+0x10c>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f01052ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01052f0:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01052f2:	8d 5f 01             	lea    0x1(%edi),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01052f5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01052fc:	eb 2b                	jmp    f0105329 <stab_binsearch+0xaf>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f01052fe:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105301:	76 14                	jbe    f0105317 <stab_binsearch+0x9d>
			*region_right = m - 1;
f0105303:	83 e8 01             	sub    $0x1,%eax
f0105306:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105309:	8b 7d e0             	mov    -0x20(%ebp),%edi
f010530c:	89 07                	mov    %eax,(%edi)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f010530e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105315:	eb 12                	jmp    f0105329 <stab_binsearch+0xaf>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105317:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010531a:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f010531c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105320:	89 c3                	mov    %eax,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105322:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0105329:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f010532c:	0f 8e 73 ff ff ff    	jle    f01052a5 <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0105332:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105336:	75 0f                	jne    f0105347 <stab_binsearch+0xcd>
		*region_right = *region_left - 1;
f0105338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010533b:	8b 00                	mov    (%eax),%eax
f010533d:	83 e8 01             	sub    $0x1,%eax
f0105340:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105343:	89 06                	mov    %eax,(%esi)
f0105345:	eb 57                	jmp    f010539e <stab_binsearch+0x124>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105347:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010534a:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010534c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010534f:	8b 0f                	mov    (%edi),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105351:	39 c8                	cmp    %ecx,%eax
f0105353:	7e 23                	jle    f0105378 <stab_binsearch+0xfe>
		     l > *region_left && stabs[l].n_type != type;
f0105355:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105358:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010535b:	8d 14 97             	lea    (%edi,%edx,4),%edx
f010535e:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0105362:	39 f3                	cmp    %esi,%ebx
f0105364:	74 12                	je     f0105378 <stab_binsearch+0xfe>
		     l--)
f0105366:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105369:	39 c8                	cmp    %ecx,%eax
f010536b:	7e 0b                	jle    f0105378 <stab_binsearch+0xfe>
		     l > *region_left && stabs[l].n_type != type;
f010536d:	0f b6 5a f8          	movzbl -0x8(%edx),%ebx
f0105371:	83 ea 0c             	sub    $0xc,%edx
f0105374:	39 f3                	cmp    %esi,%ebx
f0105376:	75 ee                	jne    f0105366 <stab_binsearch+0xec>
		     l--)
			/* do nothing */;
		*region_left = l;
f0105378:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010537b:	89 06                	mov    %eax,(%esi)
f010537d:	eb 1f                	jmp    f010539e <stab_binsearch+0x124>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f010537f:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105382:	eb a5                	jmp    f0105329 <stab_binsearch+0xaf>
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f0105384:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105386:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105389:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010538c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105390:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105393:	0f 82 54 ff ff ff    	jb     f01052ed <stab_binsearch+0x73>
f0105399:	e9 60 ff ff ff       	jmp    f01052fe <stab_binsearch+0x84>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f010539e:	83 c4 14             	add    $0x14,%esp
f01053a1:	5b                   	pop    %ebx
f01053a2:	5e                   	pop    %esi
f01053a3:	5f                   	pop    %edi
f01053a4:	5d                   	pop    %ebp
f01053a5:	c3                   	ret    

f01053a6 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01053a6:	55                   	push   %ebp
f01053a7:	89 e5                	mov    %esp,%ebp
f01053a9:	57                   	push   %edi
f01053aa:	56                   	push   %esi
f01053ab:	53                   	push   %ebx
f01053ac:	83 ec 4c             	sub    $0x4c,%esp
f01053af:	8b 75 08             	mov    0x8(%ebp),%esi
f01053b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01053b5:	c7 03 90 85 10 f0    	movl   $0xf0108590,(%ebx)
	info->eip_line = 0;
f01053bb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f01053c2:	c7 43 08 90 85 10 f0 	movl   $0xf0108590,0x8(%ebx)
	info->eip_fn_namelen = 9;
f01053c9:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f01053d0:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f01053d3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01053da:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01053e0:	0f 87 cf 00 00 00    	ja     f01054b5 <debuginfo_eip+0x10f>
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		if (user_mem_check(curenv, (const void *)usd,
f01053e6:	e8 68 12 00 00       	call   f0106653 <cpunum>
f01053eb:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01053f2:	00 
f01053f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f01053fa:	00 
f01053fb:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0105402:	00 
f0105403:	6b c0 74             	imul   $0x74,%eax,%eax
f0105406:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f010540c:	89 04 24             	mov    %eax,(%esp)
f010540f:	e8 bd e2 ff ff       	call   f01036d1 <user_mem_check>
f0105414:	85 c0                	test   %eax,%eax
f0105416:	0f 88 78 02 00 00    	js     f0105694 <debuginfo_eip+0x2ee>
				sizeof(struct UserStabData), PTE_U | PTE_P) < 0) {
			return -1;
		}

		stabs = usd->stabs;
f010541c:	a1 00 00 20 00       	mov    0x200000,%eax
		stab_end = usd->stab_end;
f0105421:	8b 3d 04 00 20 00    	mov    0x200004,%edi
		stabstr = usd->stabstr;
f0105427:	8b 15 08 00 20 00    	mov    0x200008,%edx
f010542d:	89 55 c0             	mov    %edx,-0x40(%ebp)
		stabstr_end = usd->stabstr_end;
f0105430:	8b 0d 0c 00 20 00    	mov    0x20000c,%ecx
f0105436:	89 4d bc             	mov    %ecx,-0x44(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, (const void *)stabs,
f0105439:	89 f9                	mov    %edi,%ecx
f010543b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010543e:	29 c1                	sub    %eax,%ecx
f0105440:	89 4d b8             	mov    %ecx,-0x48(%ebp)
f0105443:	e8 0b 12 00 00       	call   f0106653 <cpunum>
f0105448:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f010544f:	00 
f0105450:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105457:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010545a:	89 54 24 04          	mov    %edx,0x4(%esp)
f010545e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105461:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f0105467:	89 04 24             	mov    %eax,(%esp)
f010546a:	e8 62 e2 ff ff       	call   f01036d1 <user_mem_check>
f010546f:	85 c0                	test   %eax,%eax
f0105471:	0f 88 24 02 00 00    	js     f010569b <debuginfo_eip+0x2f5>
				(uintptr_t)stab_end  - (uintptr_t)stabs, PTE_U | PTE_P) < 0) {
			return -1;
		}

		if (user_mem_check(curenv, (const void *)stabstr,
f0105477:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f010547a:	2b 4d c0             	sub    -0x40(%ebp),%ecx
f010547d:	89 4d b8             	mov    %ecx,-0x48(%ebp)
f0105480:	e8 ce 11 00 00       	call   f0106653 <cpunum>
f0105485:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f010548c:	00 
f010548d:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105490:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105494:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0105497:	89 54 24 04          	mov    %edx,0x4(%esp)
f010549b:	6b c0 74             	imul   $0x74,%eax,%eax
f010549e:	8b 80 28 40 20 f0    	mov    -0xfdfbfd8(%eax),%eax
f01054a4:	89 04 24             	mov    %eax,(%esp)
f01054a7:	e8 25 e2 ff ff       	call   f01036d1 <user_mem_check>
f01054ac:	85 c0                	test   %eax,%eax
f01054ae:	79 1f                	jns    f01054cf <debuginfo_eip+0x129>
f01054b0:	e9 ed 01 00 00       	jmp    f01056a2 <debuginfo_eip+0x2fc>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01054b5:	c7 45 bc a4 6f 11 f0 	movl   $0xf0116fa4,-0x44(%ebp)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f01054bc:	c7 45 c0 bd 37 11 f0 	movl   $0xf01137bd,-0x40(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f01054c3:	bf bc 37 11 f0       	mov    $0xf01137bc,%edi
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f01054c8:	c7 45 c4 30 8b 10 f0 	movl   $0xf0108b30,-0x3c(%ebp)
			return -1;
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01054cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01054d2:	39 45 c0             	cmp    %eax,-0x40(%ebp)
f01054d5:	0f 83 ce 01 00 00    	jae    f01056a9 <debuginfo_eip+0x303>
f01054db:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01054df:	0f 85 cb 01 00 00    	jne    f01056b0 <debuginfo_eip+0x30a>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01054e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01054ec:	2b 7d c4             	sub    -0x3c(%ebp),%edi
f01054ef:	c1 ff 02             	sar    $0x2,%edi
f01054f2:	69 c7 ab aa aa aa    	imul   $0xaaaaaaab,%edi,%eax
f01054f8:	83 e8 01             	sub    $0x1,%eax
f01054fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01054fe:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105502:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0105509:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f010550c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010550f:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105512:	89 f8                	mov    %edi,%eax
f0105514:	e8 61 fd ff ff       	call   f010527a <stab_binsearch>
	if (lfile == 0)
f0105519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010551c:	85 c0                	test   %eax,%eax
f010551e:	0f 84 93 01 00 00    	je     f01056b7 <debuginfo_eip+0x311>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105524:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105527:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010552a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010552d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105531:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105538:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010553b:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010553e:	89 f8                	mov    %edi,%eax
f0105540:	e8 35 fd ff ff       	call   f010527a <stab_binsearch>

	if (lfun <= rfun) {
f0105545:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105548:	8b 7d d8             	mov    -0x28(%ebp),%edi
f010554b:	39 f8                	cmp    %edi,%eax
f010554d:	7f 32                	jg     f0105581 <debuginfo_eip+0x1db>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010554f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105552:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0105555:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0105558:	8b 0a                	mov    (%edx),%ecx
f010555a:	89 4d b8             	mov    %ecx,-0x48(%ebp)
f010555d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105560:	2b 4d c0             	sub    -0x40(%ebp),%ecx
f0105563:	39 4d b8             	cmp    %ecx,-0x48(%ebp)
f0105566:	73 09                	jae    f0105571 <debuginfo_eip+0x1cb>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105568:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f010556b:	03 4d c0             	add    -0x40(%ebp),%ecx
f010556e:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105571:	8b 52 08             	mov    0x8(%edx),%edx
f0105574:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105577:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0105579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f010557c:	89 7d d0             	mov    %edi,-0x30(%ebp)
f010557f:	eb 0f                	jmp    f0105590 <debuginfo_eip+0x1ea>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0105581:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0105584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105587:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f010558a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010558d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105590:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0105597:	00 
f0105598:	8b 43 08             	mov    0x8(%ebx),%eax
f010559b:	89 04 24             	mov    %eax,(%esp)
f010559e:	e8 ec 09 00 00       	call   f0105f8f <strfind>
f01055a3:	2b 43 08             	sub    0x8(%ebx),%eax
f01055a6:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01055a9:	89 74 24 04          	mov    %esi,0x4(%esp)
f01055ad:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f01055b4:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01055b7:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01055ba:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f01055bd:	89 f0                	mov    %esi,%eax
f01055bf:	e8 b6 fc ff ff       	call   f010527a <stab_binsearch>
	if (lline > rline) {
f01055c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01055c7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f01055ca:	0f 8f ee 00 00 00    	jg     f01056be <debuginfo_eip+0x318>
		return -1;
	}
	info->eip_line = stabs[lline].n_desc;
f01055d0:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01055d3:	0f b7 44 86 06       	movzwl 0x6(%esi,%eax,4),%eax
f01055d8:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01055db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01055de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01055e1:	39 f9                	cmp    %edi,%ecx
f01055e3:	7c 62                	jl     f0105647 <debuginfo_eip+0x2a1>
	       && stabs[lline].n_type != N_SOL
f01055e5:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f01055e8:	c1 e0 02             	shl    $0x2,%eax
f01055eb:	8d 14 06             	lea    (%esi,%eax,1),%edx
f01055ee:	89 55 b8             	mov    %edx,-0x48(%ebp)
f01055f1:	0f b6 52 04          	movzbl 0x4(%edx),%edx
f01055f5:	80 fa 84             	cmp    $0x84,%dl
f01055f8:	74 35                	je     f010562f <debuginfo_eip+0x289>
f01055fa:	8d 44 06 f4          	lea    -0xc(%esi,%eax,1),%eax
f01055fe:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105601:	eb 1a                	jmp    f010561d <debuginfo_eip+0x277>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0105603:	83 e9 01             	sub    $0x1,%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105606:	39 f9                	cmp    %edi,%ecx
f0105608:	7c 3d                	jl     f0105647 <debuginfo_eip+0x2a1>
	       && stabs[lline].n_type != N_SOL
f010560a:	89 c6                	mov    %eax,%esi
f010560c:	83 e8 0c             	sub    $0xc,%eax
f010560f:	0f b6 50 10          	movzbl 0x10(%eax),%edx
f0105613:	80 fa 84             	cmp    $0x84,%dl
f0105616:	75 05                	jne    f010561d <debuginfo_eip+0x277>
f0105618:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010561b:	eb 12                	jmp    f010562f <debuginfo_eip+0x289>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f010561d:	80 fa 64             	cmp    $0x64,%dl
f0105620:	75 e1                	jne    f0105603 <debuginfo_eip+0x25d>
f0105622:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
f0105626:	74 db                	je     f0105603 <debuginfo_eip+0x25d>
f0105628:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010562b:	39 cf                	cmp    %ecx,%edi
f010562d:	7f 18                	jg     f0105647 <debuginfo_eip+0x2a1>
f010562f:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0105632:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105635:	8b 04 87             	mov    (%edi,%eax,4),%eax
f0105638:	8b 55 bc             	mov    -0x44(%ebp),%edx
f010563b:	2b 55 c0             	sub    -0x40(%ebp),%edx
f010563e:	39 d0                	cmp    %edx,%eax
f0105640:	73 05                	jae    f0105647 <debuginfo_eip+0x2a1>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105642:	03 45 c0             	add    -0x40(%ebp),%eax
f0105645:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105647:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010564a:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f010564d:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105652:	39 f2                	cmp    %esi,%edx
f0105654:	0f 8d 85 00 00 00    	jge    f01056df <debuginfo_eip+0x339>
		for (lline = lfun + 1;
f010565a:	8d 42 01             	lea    0x1(%edx),%eax
f010565d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105660:	39 c6                	cmp    %eax,%esi
f0105662:	7e 61                	jle    f01056c5 <debuginfo_eip+0x31f>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105664:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105667:	c1 e1 02             	shl    $0x2,%ecx
f010566a:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f010566d:	80 7c 0f 04 a0       	cmpb   $0xa0,0x4(%edi,%ecx,1)
f0105672:	75 58                	jne    f01056cc <debuginfo_eip+0x326>
f0105674:	8d 42 02             	lea    0x2(%edx),%eax
f0105677:	8d 54 0f f4          	lea    -0xc(%edi,%ecx,1),%edx
		     lline++)
			info->eip_fn_narg++;
f010567b:	83 43 14 01          	addl   $0x1,0x14(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f010567f:	39 f0                	cmp    %esi,%eax
f0105681:	74 50                	je     f01056d3 <debuginfo_eip+0x32d>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105683:	0f b6 4a 1c          	movzbl 0x1c(%edx),%ecx
f0105687:	83 c0 01             	add    $0x1,%eax
f010568a:	83 c2 0c             	add    $0xc,%edx
f010568d:	80 f9 a0             	cmp    $0xa0,%cl
f0105690:	74 e9                	je     f010567b <debuginfo_eip+0x2d5>
f0105692:	eb 46                	jmp    f01056da <debuginfo_eip+0x334>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		if (user_mem_check(curenv, (const void *)usd,
				sizeof(struct UserStabData), PTE_U | PTE_P) < 0) {
			return -1;
f0105694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105699:	eb 44                	jmp    f01056df <debuginfo_eip+0x339>

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, (const void *)stabs,
				(uintptr_t)stab_end  - (uintptr_t)stabs, PTE_U | PTE_P) < 0) {
			return -1;
f010569b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056a0:	eb 3d                	jmp    f01056df <debuginfo_eip+0x339>
		}

		if (user_mem_check(curenv, (const void *)stabstr,
				(uintptr_t)stabstr_end - (uintptr_t)stabstr, PTE_U | PTE_P) < 0) {
			return -1;
f01056a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056a7:	eb 36                	jmp    f01056df <debuginfo_eip+0x339>
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f01056a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056ae:	eb 2f                	jmp    f01056df <debuginfo_eip+0x339>
f01056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056b5:	eb 28                	jmp    f01056df <debuginfo_eip+0x339>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f01056b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056bc:	eb 21                	jmp    f01056df <debuginfo_eip+0x339>
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
	if (lline > rline) {
		return -1;
f01056be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01056c3:	eb 1a                	jmp    f01056df <debuginfo_eip+0x339>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01056c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01056ca:	eb 13                	jmp    f01056df <debuginfo_eip+0x339>
f01056cc:	b8 00 00 00 00       	mov    $0x0,%eax
f01056d1:	eb 0c                	jmp    f01056df <debuginfo_eip+0x339>
f01056d3:	b8 00 00 00 00       	mov    $0x0,%eax
f01056d8:	eb 05                	jmp    f01056df <debuginfo_eip+0x339>
f01056da:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01056df:	83 c4 4c             	add    $0x4c,%esp
f01056e2:	5b                   	pop    %ebx
f01056e3:	5e                   	pop    %esi
f01056e4:	5f                   	pop    %edi
f01056e5:	5d                   	pop    %ebp
f01056e6:	c3                   	ret    
f01056e7:	66 90                	xchg   %ax,%ax
f01056e9:	66 90                	xchg   %ax,%ax
f01056eb:	66 90                	xchg   %ax,%ax
f01056ed:	66 90                	xchg   %ax,%ax
f01056ef:	90                   	nop

f01056f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01056f0:	55                   	push   %ebp
f01056f1:	89 e5                	mov    %esp,%ebp
f01056f3:	57                   	push   %edi
f01056f4:	56                   	push   %esi
f01056f5:	53                   	push   %ebx
f01056f6:	83 ec 3c             	sub    $0x3c,%esp
f01056f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01056fc:	89 d7                	mov    %edx,%edi
f01056fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0105701:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105704:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105707:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f010570a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010570d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105712:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105715:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105718:	39 f1                	cmp    %esi,%ecx
f010571a:	72 14                	jb     f0105730 <printnum+0x40>
f010571c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f010571f:	76 0f                	jbe    f0105730 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105721:	8b 45 14             	mov    0x14(%ebp),%eax
f0105724:	8d 70 ff             	lea    -0x1(%eax),%esi
f0105727:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010572a:	85 f6                	test   %esi,%esi
f010572c:	7f 60                	jg     f010578e <printnum+0x9e>
f010572e:	eb 72                	jmp    f01057a2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105730:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105733:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0105737:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010573a:	8d 51 ff             	lea    -0x1(%ecx),%edx
f010573d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105741:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105745:	8b 44 24 08          	mov    0x8(%esp),%eax
f0105749:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010574d:	89 c3                	mov    %eax,%ebx
f010574f:	89 d6                	mov    %edx,%esi
f0105751:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105754:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105757:	89 54 24 08          	mov    %edx,0x8(%esp)
f010575b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010575f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105762:	89 04 24             	mov    %eax,(%esp)
f0105765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105768:	89 44 24 04          	mov    %eax,0x4(%esp)
f010576c:	e8 5f 13 00 00       	call   f0106ad0 <__udivdi3>
f0105771:	89 d9                	mov    %ebx,%ecx
f0105773:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105777:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010577b:	89 04 24             	mov    %eax,(%esp)
f010577e:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105782:	89 fa                	mov    %edi,%edx
f0105784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105787:	e8 64 ff ff ff       	call   f01056f0 <printnum>
f010578c:	eb 14                	jmp    f01057a2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f010578e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105792:	8b 45 18             	mov    0x18(%ebp),%eax
f0105795:	89 04 24             	mov    %eax,(%esp)
f0105798:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f010579a:	83 ee 01             	sub    $0x1,%esi
f010579d:	75 ef                	jne    f010578e <printnum+0x9e>
f010579f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01057a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01057a6:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01057aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01057ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01057b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01057b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01057b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057bb:	89 04 24             	mov    %eax,(%esp)
f01057be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01057c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01057c5:	e8 36 14 00 00       	call   f0106c00 <__umoddi3>
f01057ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01057ce:	0f be 80 9a 85 10 f0 	movsbl -0xfef7a66(%eax),%eax
f01057d5:	89 04 24             	mov    %eax,(%esp)
f01057d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057db:	ff d0                	call   *%eax
}
f01057dd:	83 c4 3c             	add    $0x3c,%esp
f01057e0:	5b                   	pop    %ebx
f01057e1:	5e                   	pop    %esi
f01057e2:	5f                   	pop    %edi
f01057e3:	5d                   	pop    %ebp
f01057e4:	c3                   	ret    

f01057e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f01057e5:	55                   	push   %ebp
f01057e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f01057e8:	83 fa 01             	cmp    $0x1,%edx
f01057eb:	7e 0e                	jle    f01057fb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f01057ed:	8b 10                	mov    (%eax),%edx
f01057ef:	8d 4a 08             	lea    0x8(%edx),%ecx
f01057f2:	89 08                	mov    %ecx,(%eax)
f01057f4:	8b 02                	mov    (%edx),%eax
f01057f6:	8b 52 04             	mov    0x4(%edx),%edx
f01057f9:	eb 22                	jmp    f010581d <getuint+0x38>
	else if (lflag)
f01057fb:	85 d2                	test   %edx,%edx
f01057fd:	74 10                	je     f010580f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f01057ff:	8b 10                	mov    (%eax),%edx
f0105801:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105804:	89 08                	mov    %ecx,(%eax)
f0105806:	8b 02                	mov    (%edx),%eax
f0105808:	ba 00 00 00 00       	mov    $0x0,%edx
f010580d:	eb 0e                	jmp    f010581d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f010580f:	8b 10                	mov    (%eax),%edx
f0105811:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105814:	89 08                	mov    %ecx,(%eax)
f0105816:	8b 02                	mov    (%edx),%eax
f0105818:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010581d:	5d                   	pop    %ebp
f010581e:	c3                   	ret    

f010581f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010581f:	55                   	push   %ebp
f0105820:	89 e5                	mov    %esp,%ebp
f0105822:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105825:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105829:	8b 10                	mov    (%eax),%edx
f010582b:	3b 50 04             	cmp    0x4(%eax),%edx
f010582e:	73 0a                	jae    f010583a <sprintputch+0x1b>
		*b->buf++ = ch;
f0105830:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105833:	89 08                	mov    %ecx,(%eax)
f0105835:	8b 45 08             	mov    0x8(%ebp),%eax
f0105838:	88 02                	mov    %al,(%edx)
}
f010583a:	5d                   	pop    %ebp
f010583b:	c3                   	ret    

f010583c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f010583c:	55                   	push   %ebp
f010583d:	89 e5                	mov    %esp,%ebp
f010583f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f0105842:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105845:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105849:	8b 45 10             	mov    0x10(%ebp),%eax
f010584c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105850:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105853:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105857:	8b 45 08             	mov    0x8(%ebp),%eax
f010585a:	89 04 24             	mov    %eax,(%esp)
f010585d:	e8 02 00 00 00       	call   f0105864 <vprintfmt>
	va_end(ap);
}
f0105862:	c9                   	leave  
f0105863:	c3                   	ret    

f0105864 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0105864:	55                   	push   %ebp
f0105865:	89 e5                	mov    %esp,%ebp
f0105867:	57                   	push   %edi
f0105868:	56                   	push   %esi
f0105869:	53                   	push   %ebx
f010586a:	83 ec 3c             	sub    $0x3c,%esp
f010586d:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105870:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105873:	eb 18                	jmp    f010588d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0105875:	85 c0                	test   %eax,%eax
f0105877:	0f 84 c3 03 00 00    	je     f0105c40 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
f010587d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105881:	89 04 24             	mov    %eax,(%esp)
f0105884:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105887:	89 f3                	mov    %esi,%ebx
f0105889:	eb 02                	jmp    f010588d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
f010588b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010588d:	8d 73 01             	lea    0x1(%ebx),%esi
f0105890:	0f b6 03             	movzbl (%ebx),%eax
f0105893:	83 f8 25             	cmp    $0x25,%eax
f0105896:	75 dd                	jne    f0105875 <vprintfmt+0x11>
f0105898:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
f010589c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f01058a3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f01058aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01058b1:	ba 00 00 00 00       	mov    $0x0,%edx
f01058b6:	eb 1d                	jmp    f01058d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01058b8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
f01058ba:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
f01058be:	eb 15                	jmp    f01058d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01058c0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01058c2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
f01058c6:	eb 0d                	jmp    f01058d5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01058c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01058cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01058ce:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01058d5:	8d 5e 01             	lea    0x1(%esi),%ebx
f01058d8:	0f b6 06             	movzbl (%esi),%eax
f01058db:	0f b6 c8             	movzbl %al,%ecx
f01058de:	83 e8 23             	sub    $0x23,%eax
f01058e1:	3c 55                	cmp    $0x55,%al
f01058e3:	0f 87 2f 03 00 00    	ja     f0105c18 <vprintfmt+0x3b4>
f01058e9:	0f b6 c0             	movzbl %al,%eax
f01058ec:	ff 24 85 e0 86 10 f0 	jmp    *-0xfef7920(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f01058f3:	8d 41 d0             	lea    -0x30(%ecx),%eax
f01058f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
f01058f9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
f01058fd:	8d 48 d0             	lea    -0x30(%eax),%ecx
f0105900:	83 f9 09             	cmp    $0x9,%ecx
f0105903:	77 50                	ja     f0105955 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105905:	89 de                	mov    %ebx,%esi
f0105907:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f010590a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
f010590d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0105910:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
f0105914:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
f0105917:	8d 58 d0             	lea    -0x30(%eax),%ebx
f010591a:	83 fb 09             	cmp    $0x9,%ebx
f010591d:	76 eb                	jbe    f010590a <vprintfmt+0xa6>
f010591f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105922:	eb 33                	jmp    f0105957 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0105924:	8b 45 14             	mov    0x14(%ebp),%eax
f0105927:	8d 48 04             	lea    0x4(%eax),%ecx
f010592a:	89 4d 14             	mov    %ecx,0x14(%ebp)
f010592d:	8b 00                	mov    (%eax),%eax
f010592f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105932:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0105934:	eb 21                	jmp    f0105957 <vprintfmt+0xf3>
f0105936:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105939:	85 c9                	test   %ecx,%ecx
f010593b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105940:	0f 49 c1             	cmovns %ecx,%eax
f0105943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105946:	89 de                	mov    %ebx,%esi
f0105948:	eb 8b                	jmp    f01058d5 <vprintfmt+0x71>
f010594a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f010594c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0105953:	eb 80                	jmp    f01058d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105955:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f0105957:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010595b:	0f 89 74 ff ff ff    	jns    f01058d5 <vprintfmt+0x71>
f0105961:	e9 62 ff ff ff       	jmp    f01058c8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0105966:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105969:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f010596b:	e9 65 ff ff ff       	jmp    f01058d5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0105970:	8b 45 14             	mov    0x14(%ebp),%eax
f0105973:	8d 50 04             	lea    0x4(%eax),%edx
f0105976:	89 55 14             	mov    %edx,0x14(%ebp)
f0105979:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010597d:	8b 00                	mov    (%eax),%eax
f010597f:	89 04 24             	mov    %eax,(%esp)
f0105982:	ff 55 08             	call   *0x8(%ebp)
			break;
f0105985:	e9 03 ff ff ff       	jmp    f010588d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
f010598a:	8b 45 14             	mov    0x14(%ebp),%eax
f010598d:	8d 50 04             	lea    0x4(%eax),%edx
f0105990:	89 55 14             	mov    %edx,0x14(%ebp)
f0105993:	8b 00                	mov    (%eax),%eax
f0105995:	99                   	cltd   
f0105996:	31 d0                	xor    %edx,%eax
f0105998:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010599a:	83 f8 0f             	cmp    $0xf,%eax
f010599d:	7f 0b                	jg     f01059aa <vprintfmt+0x146>
f010599f:	8b 14 85 40 88 10 f0 	mov    -0xfef77c0(,%eax,4),%edx
f01059a6:	85 d2                	test   %edx,%edx
f01059a8:	75 20                	jne    f01059ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
f01059aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01059ae:	c7 44 24 08 b2 85 10 	movl   $0xf01085b2,0x8(%esp)
f01059b5:	f0 
f01059b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01059bd:	89 04 24             	mov    %eax,(%esp)
f01059c0:	e8 77 fe ff ff       	call   f010583c <printfmt>
f01059c5:	e9 c3 fe ff ff       	jmp    f010588d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
f01059ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01059ce:	c7 44 24 08 85 7c 10 	movl   $0xf0107c85,0x8(%esp)
f01059d5:	f0 
f01059d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059da:	8b 45 08             	mov    0x8(%ebp),%eax
f01059dd:	89 04 24             	mov    %eax,(%esp)
f01059e0:	e8 57 fe ff ff       	call   f010583c <printfmt>
f01059e5:	e9 a3 fe ff ff       	jmp    f010588d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01059ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01059ed:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01059f0:	8b 45 14             	mov    0x14(%ebp),%eax
f01059f3:	8d 50 04             	lea    0x4(%eax),%edx
f01059f6:	89 55 14             	mov    %edx,0x14(%ebp)
f01059f9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
f01059fb:	85 c0                	test   %eax,%eax
f01059fd:	ba ab 85 10 f0       	mov    $0xf01085ab,%edx
f0105a02:	0f 45 d0             	cmovne %eax,%edx
f0105a05:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
f0105a08:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
f0105a0c:	74 04                	je     f0105a12 <vprintfmt+0x1ae>
f0105a0e:	85 f6                	test   %esi,%esi
f0105a10:	7f 19                	jg     f0105a2b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105a12:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105a15:	8d 70 01             	lea    0x1(%eax),%esi
f0105a18:	0f b6 10             	movzbl (%eax),%edx
f0105a1b:	0f be c2             	movsbl %dl,%eax
f0105a1e:	85 c0                	test   %eax,%eax
f0105a20:	0f 85 95 00 00 00    	jne    f0105abb <vprintfmt+0x257>
f0105a26:	e9 85 00 00 00       	jmp    f0105ab0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105a2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105a2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105a32:	89 04 24             	mov    %eax,(%esp)
f0105a35:	e8 98 03 00 00       	call   f0105dd2 <strnlen>
f0105a3a:	29 c6                	sub    %eax,%esi
f0105a3c:	89 f0                	mov    %esi,%eax
f0105a3e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0105a41:	85 f6                	test   %esi,%esi
f0105a43:	7e cd                	jle    f0105a12 <vprintfmt+0x1ae>
					putch(padc, putdat);
f0105a45:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
f0105a49:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105a4c:	89 c3                	mov    %eax,%ebx
f0105a4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a52:	89 34 24             	mov    %esi,(%esp)
f0105a55:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105a58:	83 eb 01             	sub    $0x1,%ebx
f0105a5b:	75 f1                	jne    f0105a4e <vprintfmt+0x1ea>
f0105a5d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0105a60:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105a63:	eb ad                	jmp    f0105a12 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0105a65:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105a69:	74 1e                	je     f0105a89 <vprintfmt+0x225>
f0105a6b:	0f be d2             	movsbl %dl,%edx
f0105a6e:	83 ea 20             	sub    $0x20,%edx
f0105a71:	83 fa 5e             	cmp    $0x5e,%edx
f0105a74:	76 13                	jbe    f0105a89 <vprintfmt+0x225>
					putch('?', putdat);
f0105a76:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a79:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a7d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0105a84:	ff 55 08             	call   *0x8(%ebp)
f0105a87:	eb 0d                	jmp    f0105a96 <vprintfmt+0x232>
				else
					putch(ch, putdat);
f0105a89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105a90:	89 04 24             	mov    %eax,(%esp)
f0105a93:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105a96:	83 ef 01             	sub    $0x1,%edi
f0105a99:	83 c6 01             	add    $0x1,%esi
f0105a9c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
f0105aa0:	0f be c2             	movsbl %dl,%eax
f0105aa3:	85 c0                	test   %eax,%eax
f0105aa5:	75 20                	jne    f0105ac7 <vprintfmt+0x263>
f0105aa7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0105aaa:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105aad:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105ab0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105ab4:	7f 25                	jg     f0105adb <vprintfmt+0x277>
f0105ab6:	e9 d2 fd ff ff       	jmp    f010588d <vprintfmt+0x29>
f0105abb:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0105abe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105ac1:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105ac4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105ac7:	85 db                	test   %ebx,%ebx
f0105ac9:	78 9a                	js     f0105a65 <vprintfmt+0x201>
f0105acb:	83 eb 01             	sub    $0x1,%ebx
f0105ace:	79 95                	jns    f0105a65 <vprintfmt+0x201>
f0105ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0105ad3:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105ad6:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105ad9:	eb d5                	jmp    f0105ab0 <vprintfmt+0x24c>
f0105adb:	8b 75 08             	mov    0x8(%ebp),%esi
f0105ade:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105ae1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0105ae4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105ae8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0105aef:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105af1:	83 eb 01             	sub    $0x1,%ebx
f0105af4:	75 ee                	jne    f0105ae4 <vprintfmt+0x280>
f0105af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105af9:	e9 8f fd ff ff       	jmp    f010588d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0105afe:	83 fa 01             	cmp    $0x1,%edx
f0105b01:	7e 16                	jle    f0105b19 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
f0105b03:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b06:	8d 50 08             	lea    0x8(%eax),%edx
f0105b09:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b0c:	8b 50 04             	mov    0x4(%eax),%edx
f0105b0f:	8b 00                	mov    (%eax),%eax
f0105b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105b14:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105b17:	eb 32                	jmp    f0105b4b <vprintfmt+0x2e7>
	else if (lflag)
f0105b19:	85 d2                	test   %edx,%edx
f0105b1b:	74 18                	je     f0105b35 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
f0105b1d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b20:	8d 50 04             	lea    0x4(%eax),%edx
f0105b23:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b26:	8b 30                	mov    (%eax),%esi
f0105b28:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0105b2b:	89 f0                	mov    %esi,%eax
f0105b2d:	c1 f8 1f             	sar    $0x1f,%eax
f0105b30:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105b33:	eb 16                	jmp    f0105b4b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
f0105b35:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b38:	8d 50 04             	lea    0x4(%eax),%edx
f0105b3b:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b3e:	8b 30                	mov    (%eax),%esi
f0105b40:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0105b43:	89 f0                	mov    %esi,%eax
f0105b45:	c1 f8 1f             	sar    $0x1f,%eax
f0105b48:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f0105b4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105b4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f0105b51:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f0105b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105b5a:	0f 89 80 00 00 00    	jns    f0105be0 <vprintfmt+0x37c>
				putch('-', putdat);
f0105b60:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105b64:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0105b6b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0105b6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105b71:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105b74:	f7 d8                	neg    %eax
f0105b76:	83 d2 00             	adc    $0x0,%edx
f0105b79:	f7 da                	neg    %edx
			}
			base = 10;
f0105b7b:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0105b80:	eb 5e                	jmp    f0105be0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0105b82:	8d 45 14             	lea    0x14(%ebp),%eax
f0105b85:	e8 5b fc ff ff       	call   f01057e5 <getuint>
			base = 10;
f0105b8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f0105b8f:	eb 4f                	jmp    f0105be0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
f0105b91:	8d 45 14             	lea    0x14(%ebp),%eax
f0105b94:	e8 4c fc ff ff       	call   f01057e5 <getuint>
			base = 8;
f0105b99:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f0105b9e:	eb 40                	jmp    f0105be0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
f0105ba0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105ba4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0105bab:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0105bae:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105bb2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0105bb9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0105bbc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105bbf:	8d 50 04             	lea    0x4(%eax),%edx
f0105bc2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0105bc5:	8b 00                	mov    (%eax),%eax
f0105bc7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0105bcc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f0105bd1:	eb 0d                	jmp    f0105be0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0105bd3:	8d 45 14             	lea    0x14(%ebp),%eax
f0105bd6:	e8 0a fc ff ff       	call   f01057e5 <getuint>
			base = 16;
f0105bdb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f0105be0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
f0105be4:	89 74 24 10          	mov    %esi,0x10(%esp)
f0105be8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105beb:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105bef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105bf3:	89 04 24             	mov    %eax,(%esp)
f0105bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105bfa:	89 fa                	mov    %edi,%edx
f0105bfc:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bff:	e8 ec fa ff ff       	call   f01056f0 <printnum>
			break;
f0105c04:	e9 84 fc ff ff       	jmp    f010588d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0105c09:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105c0d:	89 0c 24             	mov    %ecx,(%esp)
f0105c10:	ff 55 08             	call   *0x8(%ebp)
			break;
f0105c13:	e9 75 fc ff ff       	jmp    f010588d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0105c18:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105c1c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0105c23:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105c26:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
f0105c2a:	0f 84 5b fc ff ff    	je     f010588b <vprintfmt+0x27>
f0105c30:	89 f3                	mov    %esi,%ebx
f0105c32:	83 eb 01             	sub    $0x1,%ebx
f0105c35:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0105c39:	75 f7                	jne    f0105c32 <vprintfmt+0x3ce>
f0105c3b:	e9 4d fc ff ff       	jmp    f010588d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
f0105c40:	83 c4 3c             	add    $0x3c,%esp
f0105c43:	5b                   	pop    %ebx
f0105c44:	5e                   	pop    %esi
f0105c45:	5f                   	pop    %edi
f0105c46:	5d                   	pop    %ebp
f0105c47:	c3                   	ret    

f0105c48 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105c48:	55                   	push   %ebp
f0105c49:	89 e5                	mov    %esp,%ebp
f0105c4b:	83 ec 28             	sub    $0x28,%esp
f0105c4e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c51:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105c57:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105c5b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0105c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105c65:	85 c0                	test   %eax,%eax
f0105c67:	74 30                	je     f0105c99 <vsnprintf+0x51>
f0105c69:	85 d2                	test   %edx,%edx
f0105c6b:	7e 2c                	jle    f0105c99 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105c6d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c70:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105c74:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c77:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105c7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105c82:	c7 04 24 1f 58 10 f0 	movl   $0xf010581f,(%esp)
f0105c89:	e8 d6 fb ff ff       	call   f0105864 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105c91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105c97:	eb 05                	jmp    f0105c9e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0105c99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0105c9e:	c9                   	leave  
f0105c9f:	c3                   	ret    

f0105ca0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105ca0:	55                   	push   %ebp
f0105ca1:	89 e5                	mov    %esp,%ebp
f0105ca3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105ca6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105ca9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105cad:	8b 45 10             	mov    0x10(%ebp),%eax
f0105cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cbe:	89 04 24             	mov    %eax,(%esp)
f0105cc1:	e8 82 ff ff ff       	call   f0105c48 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105cc6:	c9                   	leave  
f0105cc7:	c3                   	ret    
f0105cc8:	66 90                	xchg   %ax,%ax
f0105cca:	66 90                	xchg   %ax,%ax
f0105ccc:	66 90                	xchg   %ax,%ax
f0105cce:	66 90                	xchg   %ax,%ax

f0105cd0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105cd0:	55                   	push   %ebp
f0105cd1:	89 e5                	mov    %esp,%ebp
f0105cd3:	57                   	push   %edi
f0105cd4:	56                   	push   %esi
f0105cd5:	53                   	push   %ebx
f0105cd6:	83 ec 1c             	sub    $0x1c,%esp
f0105cd9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105cdc:	85 c0                	test   %eax,%eax
f0105cde:	74 10                	je     f0105cf0 <readline+0x20>
		cprintf("%s", prompt);
f0105ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ce4:	c7 04 24 85 7c 10 f0 	movl   $0xf0107c85,(%esp)
f0105ceb:	e8 81 e4 ff ff       	call   f0104171 <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105cf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105cf7:	e8 10 ab ff ff       	call   f010080c <iscons>
f0105cfc:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0105cfe:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0105d03:	e8 f3 aa ff ff       	call   f01007fb <getchar>
f0105d08:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105d0a:	85 c0                	test   %eax,%eax
f0105d0c:	79 25                	jns    f0105d33 <readline+0x63>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105d0e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0105d13:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105d16:	0f 84 89 00 00 00    	je     f0105da5 <readline+0xd5>
				cprintf("read error: %e\n", c);
f0105d1c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105d20:	c7 04 24 9f 88 10 f0 	movl   $0xf010889f,(%esp)
f0105d27:	e8 45 e4 ff ff       	call   f0104171 <cprintf>
			return NULL;
f0105d2c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105d31:	eb 72                	jmp    f0105da5 <readline+0xd5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105d33:	83 f8 7f             	cmp    $0x7f,%eax
f0105d36:	74 05                	je     f0105d3d <readline+0x6d>
f0105d38:	83 f8 08             	cmp    $0x8,%eax
f0105d3b:	75 1a                	jne    f0105d57 <readline+0x87>
f0105d3d:	85 f6                	test   %esi,%esi
f0105d3f:	90                   	nop
f0105d40:	7e 15                	jle    f0105d57 <readline+0x87>
			if (echoing)
f0105d42:	85 ff                	test   %edi,%edi
f0105d44:	74 0c                	je     f0105d52 <readline+0x82>
				cputchar('\b');
f0105d46:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0105d4d:	e8 99 aa ff ff       	call   f01007eb <cputchar>
			i--;
f0105d52:	83 ee 01             	sub    $0x1,%esi
f0105d55:	eb ac                	jmp    f0105d03 <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105d57:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105d5d:	7f 1c                	jg     f0105d7b <readline+0xab>
f0105d5f:	83 fb 1f             	cmp    $0x1f,%ebx
f0105d62:	7e 17                	jle    f0105d7b <readline+0xab>
			if (echoing)
f0105d64:	85 ff                	test   %edi,%edi
f0105d66:	74 08                	je     f0105d70 <readline+0xa0>
				cputchar(c);
f0105d68:	89 1c 24             	mov    %ebx,(%esp)
f0105d6b:	e8 7b aa ff ff       	call   f01007eb <cputchar>
			buf[i++] = c;
f0105d70:	88 9e 80 3a 20 f0    	mov    %bl,-0xfdfc580(%esi)
f0105d76:	8d 76 01             	lea    0x1(%esi),%esi
f0105d79:	eb 88                	jmp    f0105d03 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0105d7b:	83 fb 0d             	cmp    $0xd,%ebx
f0105d7e:	74 09                	je     f0105d89 <readline+0xb9>
f0105d80:	83 fb 0a             	cmp    $0xa,%ebx
f0105d83:	0f 85 7a ff ff ff    	jne    f0105d03 <readline+0x33>
			if (echoing)
f0105d89:	85 ff                	test   %edi,%edi
f0105d8b:	74 0c                	je     f0105d99 <readline+0xc9>
				cputchar('\n');
f0105d8d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0105d94:	e8 52 aa ff ff       	call   f01007eb <cputchar>
			buf[i] = 0;
f0105d99:	c6 86 80 3a 20 f0 00 	movb   $0x0,-0xfdfc580(%esi)
			return buf;
f0105da0:	b8 80 3a 20 f0       	mov    $0xf0203a80,%eax
		}
	}
}
f0105da5:	83 c4 1c             	add    $0x1c,%esp
f0105da8:	5b                   	pop    %ebx
f0105da9:	5e                   	pop    %esi
f0105daa:	5f                   	pop    %edi
f0105dab:	5d                   	pop    %ebp
f0105dac:	c3                   	ret    
f0105dad:	66 90                	xchg   %ax,%ax
f0105daf:	90                   	nop

f0105db0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105db0:	55                   	push   %ebp
f0105db1:	89 e5                	mov    %esp,%ebp
f0105db3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105db6:	80 3a 00             	cmpb   $0x0,(%edx)
f0105db9:	74 10                	je     f0105dcb <strlen+0x1b>
f0105dbb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f0105dc0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0105dc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105dc7:	75 f7                	jne    f0105dc0 <strlen+0x10>
f0105dc9:	eb 05                	jmp    f0105dd0 <strlen+0x20>
f0105dcb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0105dd0:	5d                   	pop    %ebp
f0105dd1:	c3                   	ret    

f0105dd2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105dd2:	55                   	push   %ebp
f0105dd3:	89 e5                	mov    %esp,%ebp
f0105dd5:	53                   	push   %ebx
f0105dd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105ddc:	85 c9                	test   %ecx,%ecx
f0105dde:	74 1c                	je     f0105dfc <strnlen+0x2a>
f0105de0:	80 3b 00             	cmpb   $0x0,(%ebx)
f0105de3:	74 1e                	je     f0105e03 <strnlen+0x31>
f0105de5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
f0105dea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105dec:	39 ca                	cmp    %ecx,%edx
f0105dee:	74 18                	je     f0105e08 <strnlen+0x36>
f0105df0:	83 c2 01             	add    $0x1,%edx
f0105df3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
f0105df8:	75 f0                	jne    f0105dea <strnlen+0x18>
f0105dfa:	eb 0c                	jmp    f0105e08 <strnlen+0x36>
f0105dfc:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e01:	eb 05                	jmp    f0105e08 <strnlen+0x36>
f0105e03:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0105e08:	5b                   	pop    %ebx
f0105e09:	5d                   	pop    %ebp
f0105e0a:	c3                   	ret    

f0105e0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105e0b:	55                   	push   %ebp
f0105e0c:	89 e5                	mov    %esp,%ebp
f0105e0e:	53                   	push   %ebx
f0105e0f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105e15:	89 c2                	mov    %eax,%edx
f0105e17:	83 c2 01             	add    $0x1,%edx
f0105e1a:	83 c1 01             	add    $0x1,%ecx
f0105e1d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105e21:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105e24:	84 db                	test   %bl,%bl
f0105e26:	75 ef                	jne    f0105e17 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0105e28:	5b                   	pop    %ebx
f0105e29:	5d                   	pop    %ebp
f0105e2a:	c3                   	ret    

f0105e2b <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105e2b:	55                   	push   %ebp
f0105e2c:	89 e5                	mov    %esp,%ebp
f0105e2e:	53                   	push   %ebx
f0105e2f:	83 ec 08             	sub    $0x8,%esp
f0105e32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105e35:	89 1c 24             	mov    %ebx,(%esp)
f0105e38:	e8 73 ff ff ff       	call   f0105db0 <strlen>
	strcpy(dst + len, src);
f0105e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e40:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105e44:	01 d8                	add    %ebx,%eax
f0105e46:	89 04 24             	mov    %eax,(%esp)
f0105e49:	e8 bd ff ff ff       	call   f0105e0b <strcpy>
	return dst;
}
f0105e4e:	89 d8                	mov    %ebx,%eax
f0105e50:	83 c4 08             	add    $0x8,%esp
f0105e53:	5b                   	pop    %ebx
f0105e54:	5d                   	pop    %ebp
f0105e55:	c3                   	ret    

f0105e56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105e56:	55                   	push   %ebp
f0105e57:	89 e5                	mov    %esp,%ebp
f0105e59:	56                   	push   %esi
f0105e5a:	53                   	push   %ebx
f0105e5b:	8b 75 08             	mov    0x8(%ebp),%esi
f0105e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105e64:	85 db                	test   %ebx,%ebx
f0105e66:	74 17                	je     f0105e7f <strncpy+0x29>
f0105e68:	01 f3                	add    %esi,%ebx
f0105e6a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
f0105e6c:	83 c1 01             	add    $0x1,%ecx
f0105e6f:	0f b6 02             	movzbl (%edx),%eax
f0105e72:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105e75:	80 3a 01             	cmpb   $0x1,(%edx)
f0105e78:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105e7b:	39 d9                	cmp    %ebx,%ecx
f0105e7d:	75 ed                	jne    f0105e6c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0105e7f:	89 f0                	mov    %esi,%eax
f0105e81:	5b                   	pop    %ebx
f0105e82:	5e                   	pop    %esi
f0105e83:	5d                   	pop    %ebp
f0105e84:	c3                   	ret    

f0105e85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105e85:	55                   	push   %ebp
f0105e86:	89 e5                	mov    %esp,%ebp
f0105e88:	57                   	push   %edi
f0105e89:	56                   	push   %esi
f0105e8a:	53                   	push   %ebx
f0105e8b:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105e8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105e91:	8b 75 10             	mov    0x10(%ebp),%esi
f0105e94:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105e96:	85 f6                	test   %esi,%esi
f0105e98:	74 34                	je     f0105ece <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
f0105e9a:	83 fe 01             	cmp    $0x1,%esi
f0105e9d:	74 26                	je     f0105ec5 <strlcpy+0x40>
f0105e9f:	0f b6 0b             	movzbl (%ebx),%ecx
f0105ea2:	84 c9                	test   %cl,%cl
f0105ea4:	74 23                	je     f0105ec9 <strlcpy+0x44>
f0105ea6:	83 ee 02             	sub    $0x2,%esi
f0105ea9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
f0105eae:	83 c0 01             	add    $0x1,%eax
f0105eb1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0105eb4:	39 f2                	cmp    %esi,%edx
f0105eb6:	74 13                	je     f0105ecb <strlcpy+0x46>
f0105eb8:	83 c2 01             	add    $0x1,%edx
f0105ebb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0105ebf:	84 c9                	test   %cl,%cl
f0105ec1:	75 eb                	jne    f0105eae <strlcpy+0x29>
f0105ec3:	eb 06                	jmp    f0105ecb <strlcpy+0x46>
f0105ec5:	89 f8                	mov    %edi,%eax
f0105ec7:	eb 02                	jmp    f0105ecb <strlcpy+0x46>
f0105ec9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
f0105ecb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105ece:	29 f8                	sub    %edi,%eax
}
f0105ed0:	5b                   	pop    %ebx
f0105ed1:	5e                   	pop    %esi
f0105ed2:	5f                   	pop    %edi
f0105ed3:	5d                   	pop    %ebp
f0105ed4:	c3                   	ret    

f0105ed5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105ed5:	55                   	push   %ebp
f0105ed6:	89 e5                	mov    %esp,%ebp
f0105ed8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105edb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105ede:	0f b6 01             	movzbl (%ecx),%eax
f0105ee1:	84 c0                	test   %al,%al
f0105ee3:	74 15                	je     f0105efa <strcmp+0x25>
f0105ee5:	3a 02                	cmp    (%edx),%al
f0105ee7:	75 11                	jne    f0105efa <strcmp+0x25>
		p++, q++;
f0105ee9:	83 c1 01             	add    $0x1,%ecx
f0105eec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0105eef:	0f b6 01             	movzbl (%ecx),%eax
f0105ef2:	84 c0                	test   %al,%al
f0105ef4:	74 04                	je     f0105efa <strcmp+0x25>
f0105ef6:	3a 02                	cmp    (%edx),%al
f0105ef8:	74 ef                	je     f0105ee9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105efa:	0f b6 c0             	movzbl %al,%eax
f0105efd:	0f b6 12             	movzbl (%edx),%edx
f0105f00:	29 d0                	sub    %edx,%eax
}
f0105f02:	5d                   	pop    %ebp
f0105f03:	c3                   	ret    

f0105f04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105f04:	55                   	push   %ebp
f0105f05:	89 e5                	mov    %esp,%ebp
f0105f07:	56                   	push   %esi
f0105f08:	53                   	push   %ebx
f0105f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f0f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
f0105f12:	85 f6                	test   %esi,%esi
f0105f14:	74 29                	je     f0105f3f <strncmp+0x3b>
f0105f16:	0f b6 03             	movzbl (%ebx),%eax
f0105f19:	84 c0                	test   %al,%al
f0105f1b:	74 30                	je     f0105f4d <strncmp+0x49>
f0105f1d:	3a 02                	cmp    (%edx),%al
f0105f1f:	75 2c                	jne    f0105f4d <strncmp+0x49>
f0105f21:	8d 43 01             	lea    0x1(%ebx),%eax
f0105f24:	01 de                	add    %ebx,%esi
		n--, p++, q++;
f0105f26:	89 c3                	mov    %eax,%ebx
f0105f28:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0105f2b:	39 f0                	cmp    %esi,%eax
f0105f2d:	74 17                	je     f0105f46 <strncmp+0x42>
f0105f2f:	0f b6 08             	movzbl (%eax),%ecx
f0105f32:	84 c9                	test   %cl,%cl
f0105f34:	74 17                	je     f0105f4d <strncmp+0x49>
f0105f36:	83 c0 01             	add    $0x1,%eax
f0105f39:	3a 0a                	cmp    (%edx),%cl
f0105f3b:	74 e9                	je     f0105f26 <strncmp+0x22>
f0105f3d:	eb 0e                	jmp    f0105f4d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
f0105f3f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f44:	eb 0f                	jmp    f0105f55 <strncmp+0x51>
f0105f46:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f4b:	eb 08                	jmp    f0105f55 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105f4d:	0f b6 03             	movzbl (%ebx),%eax
f0105f50:	0f b6 12             	movzbl (%edx),%edx
f0105f53:	29 d0                	sub    %edx,%eax
}
f0105f55:	5b                   	pop    %ebx
f0105f56:	5e                   	pop    %esi
f0105f57:	5d                   	pop    %ebp
f0105f58:	c3                   	ret    

f0105f59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105f59:	55                   	push   %ebp
f0105f5a:	89 e5                	mov    %esp,%ebp
f0105f5c:	53                   	push   %ebx
f0105f5d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f60:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
f0105f63:	0f b6 18             	movzbl (%eax),%ebx
f0105f66:	84 db                	test   %bl,%bl
f0105f68:	74 1d                	je     f0105f87 <strchr+0x2e>
f0105f6a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
f0105f6c:	38 d3                	cmp    %dl,%bl
f0105f6e:	75 06                	jne    f0105f76 <strchr+0x1d>
f0105f70:	eb 1a                	jmp    f0105f8c <strchr+0x33>
f0105f72:	38 ca                	cmp    %cl,%dl
f0105f74:	74 16                	je     f0105f8c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0105f76:	83 c0 01             	add    $0x1,%eax
f0105f79:	0f b6 10             	movzbl (%eax),%edx
f0105f7c:	84 d2                	test   %dl,%dl
f0105f7e:	75 f2                	jne    f0105f72 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
f0105f80:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f85:	eb 05                	jmp    f0105f8c <strchr+0x33>
f0105f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105f8c:	5b                   	pop    %ebx
f0105f8d:	5d                   	pop    %ebp
f0105f8e:	c3                   	ret    

f0105f8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105f8f:	55                   	push   %ebp
f0105f90:	89 e5                	mov    %esp,%ebp
f0105f92:	53                   	push   %ebx
f0105f93:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f96:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
f0105f99:	0f b6 18             	movzbl (%eax),%ebx
f0105f9c:	84 db                	test   %bl,%bl
f0105f9e:	74 16                	je     f0105fb6 <strfind+0x27>
f0105fa0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
f0105fa2:	38 d3                	cmp    %dl,%bl
f0105fa4:	75 06                	jne    f0105fac <strfind+0x1d>
f0105fa6:	eb 0e                	jmp    f0105fb6 <strfind+0x27>
f0105fa8:	38 ca                	cmp    %cl,%dl
f0105faa:	74 0a                	je     f0105fb6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f0105fac:	83 c0 01             	add    $0x1,%eax
f0105faf:	0f b6 10             	movzbl (%eax),%edx
f0105fb2:	84 d2                	test   %dl,%dl
f0105fb4:	75 f2                	jne    f0105fa8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
f0105fb6:	5b                   	pop    %ebx
f0105fb7:	5d                   	pop    %ebp
f0105fb8:	c3                   	ret    

f0105fb9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105fb9:	55                   	push   %ebp
f0105fba:	89 e5                	mov    %esp,%ebp
f0105fbc:	57                   	push   %edi
f0105fbd:	56                   	push   %esi
f0105fbe:	53                   	push   %ebx
f0105fbf:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105fc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105fc5:	85 c9                	test   %ecx,%ecx
f0105fc7:	74 36                	je     f0105fff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105fc9:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105fcf:	75 28                	jne    f0105ff9 <memset+0x40>
f0105fd1:	f6 c1 03             	test   $0x3,%cl
f0105fd4:	75 23                	jne    f0105ff9 <memset+0x40>
		c &= 0xFF;
f0105fd6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105fda:	89 d3                	mov    %edx,%ebx
f0105fdc:	c1 e3 08             	shl    $0x8,%ebx
f0105fdf:	89 d6                	mov    %edx,%esi
f0105fe1:	c1 e6 18             	shl    $0x18,%esi
f0105fe4:	89 d0                	mov    %edx,%eax
f0105fe6:	c1 e0 10             	shl    $0x10,%eax
f0105fe9:	09 f0                	or     %esi,%eax
f0105feb:	09 c2                	or     %eax,%edx
f0105fed:	89 d0                	mov    %edx,%eax
f0105fef:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105ff1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0105ff4:	fc                   	cld    
f0105ff5:	f3 ab                	rep stos %eax,%es:(%edi)
f0105ff7:	eb 06                	jmp    f0105fff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105ffc:	fc                   	cld    
f0105ffd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105fff:	89 f8                	mov    %edi,%eax
f0106001:	5b                   	pop    %ebx
f0106002:	5e                   	pop    %esi
f0106003:	5f                   	pop    %edi
f0106004:	5d                   	pop    %ebp
f0106005:	c3                   	ret    

f0106006 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106006:	55                   	push   %ebp
f0106007:	89 e5                	mov    %esp,%ebp
f0106009:	57                   	push   %edi
f010600a:	56                   	push   %esi
f010600b:	8b 45 08             	mov    0x8(%ebp),%eax
f010600e:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106011:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106014:	39 c6                	cmp    %eax,%esi
f0106016:	73 35                	jae    f010604d <memmove+0x47>
f0106018:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010601b:	39 d0                	cmp    %edx,%eax
f010601d:	73 2e                	jae    f010604d <memmove+0x47>
		s += n;
		d += n;
f010601f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0106022:	89 d6                	mov    %edx,%esi
f0106024:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106026:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010602c:	75 13                	jne    f0106041 <memmove+0x3b>
f010602e:	f6 c1 03             	test   $0x3,%cl
f0106031:	75 0e                	jne    f0106041 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106033:	83 ef 04             	sub    $0x4,%edi
f0106036:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106039:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010603c:	fd                   	std    
f010603d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010603f:	eb 09                	jmp    f010604a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106041:	83 ef 01             	sub    $0x1,%edi
f0106044:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106047:	fd                   	std    
f0106048:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010604a:	fc                   	cld    
f010604b:	eb 1d                	jmp    f010606a <memmove+0x64>
f010604d:	89 f2                	mov    %esi,%edx
f010604f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106051:	f6 c2 03             	test   $0x3,%dl
f0106054:	75 0f                	jne    f0106065 <memmove+0x5f>
f0106056:	f6 c1 03             	test   $0x3,%cl
f0106059:	75 0a                	jne    f0106065 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010605b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f010605e:	89 c7                	mov    %eax,%edi
f0106060:	fc                   	cld    
f0106061:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106063:	eb 05                	jmp    f010606a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0106065:	89 c7                	mov    %eax,%edi
f0106067:	fc                   	cld    
f0106068:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010606a:	5e                   	pop    %esi
f010606b:	5f                   	pop    %edi
f010606c:	5d                   	pop    %ebp
f010606d:	c3                   	ret    

f010606e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010606e:	55                   	push   %ebp
f010606f:	89 e5                	mov    %esp,%ebp
f0106071:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106074:	8b 45 10             	mov    0x10(%ebp),%eax
f0106077:	89 44 24 08          	mov    %eax,0x8(%esp)
f010607b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010607e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106082:	8b 45 08             	mov    0x8(%ebp),%eax
f0106085:	89 04 24             	mov    %eax,(%esp)
f0106088:	e8 79 ff ff ff       	call   f0106006 <memmove>
}
f010608d:	c9                   	leave  
f010608e:	c3                   	ret    

f010608f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010608f:	55                   	push   %ebp
f0106090:	89 e5                	mov    %esp,%ebp
f0106092:	57                   	push   %edi
f0106093:	56                   	push   %esi
f0106094:	53                   	push   %ebx
f0106095:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0106098:	8b 75 0c             	mov    0xc(%ebp),%esi
f010609b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010609e:	8d 78 ff             	lea    -0x1(%eax),%edi
f01060a1:	85 c0                	test   %eax,%eax
f01060a3:	74 36                	je     f01060db <memcmp+0x4c>
		if (*s1 != *s2)
f01060a5:	0f b6 03             	movzbl (%ebx),%eax
f01060a8:	0f b6 0e             	movzbl (%esi),%ecx
f01060ab:	ba 00 00 00 00       	mov    $0x0,%edx
f01060b0:	38 c8                	cmp    %cl,%al
f01060b2:	74 1c                	je     f01060d0 <memcmp+0x41>
f01060b4:	eb 10                	jmp    f01060c6 <memcmp+0x37>
f01060b6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f01060bb:	83 c2 01             	add    $0x1,%edx
f01060be:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
f01060c2:	38 c8                	cmp    %cl,%al
f01060c4:	74 0a                	je     f01060d0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
f01060c6:	0f b6 c0             	movzbl %al,%eax
f01060c9:	0f b6 c9             	movzbl %cl,%ecx
f01060cc:	29 c8                	sub    %ecx,%eax
f01060ce:	eb 10                	jmp    f01060e0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01060d0:	39 fa                	cmp    %edi,%edx
f01060d2:	75 e2                	jne    f01060b6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01060d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01060d9:	eb 05                	jmp    f01060e0 <memcmp+0x51>
f01060db:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01060e0:	5b                   	pop    %ebx
f01060e1:	5e                   	pop    %esi
f01060e2:	5f                   	pop    %edi
f01060e3:	5d                   	pop    %ebp
f01060e4:	c3                   	ret    

f01060e5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01060e5:	55                   	push   %ebp
f01060e6:	89 e5                	mov    %esp,%ebp
f01060e8:	53                   	push   %ebx
f01060e9:	8b 45 08             	mov    0x8(%ebp),%eax
f01060ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
f01060ef:	89 c2                	mov    %eax,%edx
f01060f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01060f4:	39 d0                	cmp    %edx,%eax
f01060f6:	73 13                	jae    f010610b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
f01060f8:	89 d9                	mov    %ebx,%ecx
f01060fa:	38 18                	cmp    %bl,(%eax)
f01060fc:	75 06                	jne    f0106104 <memfind+0x1f>
f01060fe:	eb 0b                	jmp    f010610b <memfind+0x26>
f0106100:	38 08                	cmp    %cl,(%eax)
f0106102:	74 07                	je     f010610b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0106104:	83 c0 01             	add    $0x1,%eax
f0106107:	39 d0                	cmp    %edx,%eax
f0106109:	75 f5                	jne    f0106100 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f010610b:	5b                   	pop    %ebx
f010610c:	5d                   	pop    %ebp
f010610d:	c3                   	ret    

f010610e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010610e:	55                   	push   %ebp
f010610f:	89 e5                	mov    %esp,%ebp
f0106111:	57                   	push   %edi
f0106112:	56                   	push   %esi
f0106113:	53                   	push   %ebx
f0106114:	8b 55 08             	mov    0x8(%ebp),%edx
f0106117:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010611a:	0f b6 0a             	movzbl (%edx),%ecx
f010611d:	80 f9 09             	cmp    $0x9,%cl
f0106120:	74 05                	je     f0106127 <strtol+0x19>
f0106122:	80 f9 20             	cmp    $0x20,%cl
f0106125:	75 10                	jne    f0106137 <strtol+0x29>
		s++;
f0106127:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010612a:	0f b6 0a             	movzbl (%edx),%ecx
f010612d:	80 f9 09             	cmp    $0x9,%cl
f0106130:	74 f5                	je     f0106127 <strtol+0x19>
f0106132:	80 f9 20             	cmp    $0x20,%cl
f0106135:	74 f0                	je     f0106127 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106137:	80 f9 2b             	cmp    $0x2b,%cl
f010613a:	75 0a                	jne    f0106146 <strtol+0x38>
		s++;
f010613c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f010613f:	bf 00 00 00 00       	mov    $0x0,%edi
f0106144:	eb 11                	jmp    f0106157 <strtol+0x49>
f0106146:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010614b:	80 f9 2d             	cmp    $0x2d,%cl
f010614e:	75 07                	jne    f0106157 <strtol+0x49>
		s++, neg = 1;
f0106150:	83 c2 01             	add    $0x1,%edx
f0106153:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106157:	a9 ef ff ff ff       	test   $0xffffffef,%eax
f010615c:	75 15                	jne    f0106173 <strtol+0x65>
f010615e:	80 3a 30             	cmpb   $0x30,(%edx)
f0106161:	75 10                	jne    f0106173 <strtol+0x65>
f0106163:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0106167:	75 0a                	jne    f0106173 <strtol+0x65>
		s += 2, base = 16;
f0106169:	83 c2 02             	add    $0x2,%edx
f010616c:	b8 10 00 00 00       	mov    $0x10,%eax
f0106171:	eb 10                	jmp    f0106183 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
f0106173:	85 c0                	test   %eax,%eax
f0106175:	75 0c                	jne    f0106183 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106177:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106179:	80 3a 30             	cmpb   $0x30,(%edx)
f010617c:	75 05                	jne    f0106183 <strtol+0x75>
		s++, base = 8;
f010617e:	83 c2 01             	add    $0x1,%edx
f0106181:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
f0106183:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106188:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f010618b:	0f b6 0a             	movzbl (%edx),%ecx
f010618e:	8d 71 d0             	lea    -0x30(%ecx),%esi
f0106191:	89 f0                	mov    %esi,%eax
f0106193:	3c 09                	cmp    $0x9,%al
f0106195:	77 08                	ja     f010619f <strtol+0x91>
			dig = *s - '0';
f0106197:	0f be c9             	movsbl %cl,%ecx
f010619a:	83 e9 30             	sub    $0x30,%ecx
f010619d:	eb 20                	jmp    f01061bf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
f010619f:	8d 71 9f             	lea    -0x61(%ecx),%esi
f01061a2:	89 f0                	mov    %esi,%eax
f01061a4:	3c 19                	cmp    $0x19,%al
f01061a6:	77 08                	ja     f01061b0 <strtol+0xa2>
			dig = *s - 'a' + 10;
f01061a8:	0f be c9             	movsbl %cl,%ecx
f01061ab:	83 e9 57             	sub    $0x57,%ecx
f01061ae:	eb 0f                	jmp    f01061bf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
f01061b0:	8d 71 bf             	lea    -0x41(%ecx),%esi
f01061b3:	89 f0                	mov    %esi,%eax
f01061b5:	3c 19                	cmp    $0x19,%al
f01061b7:	77 16                	ja     f01061cf <strtol+0xc1>
			dig = *s - 'A' + 10;
f01061b9:	0f be c9             	movsbl %cl,%ecx
f01061bc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f01061bf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
f01061c2:	7d 0f                	jge    f01061d3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f01061c4:	83 c2 01             	add    $0x1,%edx
f01061c7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
f01061cb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
f01061cd:	eb bc                	jmp    f010618b <strtol+0x7d>
f01061cf:	89 d8                	mov    %ebx,%eax
f01061d1:	eb 02                	jmp    f01061d5 <strtol+0xc7>
f01061d3:	89 d8                	mov    %ebx,%eax

	if (endptr)
f01061d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01061d9:	74 05                	je     f01061e0 <strtol+0xd2>
		*endptr = (char *) s;
f01061db:	8b 75 0c             	mov    0xc(%ebp),%esi
f01061de:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f01061e0:	f7 d8                	neg    %eax
f01061e2:	85 ff                	test   %edi,%edi
f01061e4:	0f 44 c3             	cmove  %ebx,%eax
}
f01061e7:	5b                   	pop    %ebx
f01061e8:	5e                   	pop    %esi
f01061e9:	5f                   	pop    %edi
f01061ea:	5d                   	pop    %ebp
f01061eb:	c3                   	ret    

f01061ec <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01061ec:	fa                   	cli    

	xorw    %ax, %ax
f01061ed:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01061ef:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01061f1:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01061f3:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01061f5:	0f 01 16             	lgdtl  (%esi)
f01061f8:	74 70                	je     f010626a <mpentry_end+0x4>
	movl    %cr0, %eax
f01061fa:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01061fd:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106201:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106204:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010620a:	08 00                	or     %al,(%eax)

f010620c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f010620c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106210:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106212:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106214:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106216:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f010621a:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f010621c:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f010621e:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl    %eax, %cr3
f0106223:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0106226:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106229:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f010622e:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106231:	8b 25 84 3e 20 f0    	mov    0xf0203e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106237:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f010623c:	b8 17 02 10 f0       	mov    $0xf0100217,%eax
	call    *%eax
f0106241:	ff d0                	call   *%eax

f0106243 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106243:	eb fe                	jmp    f0106243 <spin>
f0106245:	8d 76 00             	lea    0x0(%esi),%esi

f0106248 <gdt>:
	...
f0106250:	ff                   	(bad)  
f0106251:	ff 00                	incl   (%eax)
f0106253:	00 00                	add    %al,(%eax)
f0106255:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010625c:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0106260 <gdtdesc>:
f0106260:	17                   	pop    %ss
f0106261:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0106266 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106266:	90                   	nop
f0106267:	66 90                	xchg   %ax,%ax
f0106269:	66 90                	xchg   %ax,%ax
f010626b:	66 90                	xchg   %ax,%ax
f010626d:	66 90                	xchg   %ax,%ax
f010626f:	90                   	nop

f0106270 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106270:	55                   	push   %ebp
f0106271:	89 e5                	mov    %esp,%ebp
f0106273:	56                   	push   %esi
f0106274:	53                   	push   %ebx
f0106275:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106278:	8b 0d 88 3e 20 f0    	mov    0xf0203e88,%ecx
f010627e:	89 c3                	mov    %eax,%ebx
f0106280:	c1 eb 0c             	shr    $0xc,%ebx
f0106283:	39 cb                	cmp    %ecx,%ebx
f0106285:	72 20                	jb     f01062a7 <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106287:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010628b:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0106292:	f0 
f0106293:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010629a:	00 
f010629b:	c7 04 24 3d 8a 10 f0 	movl   $0xf0108a3d,(%esp)
f01062a2:	e8 99 9d ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01062a7:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f01062ad:	01 d0                	add    %edx,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01062af:	89 c2                	mov    %eax,%edx
f01062b1:	c1 ea 0c             	shr    $0xc,%edx
f01062b4:	39 d1                	cmp    %edx,%ecx
f01062b6:	77 20                	ja     f01062d8 <mpsearch1+0x68>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01062b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01062bc:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f01062c3:	f0 
f01062c4:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f01062cb:	00 
f01062cc:	c7 04 24 3d 8a 10 f0 	movl   $0xf0108a3d,(%esp)
f01062d3:	e8 68 9d ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01062d8:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	for (; mp < end; mp++)
f01062de:	39 f3                	cmp    %esi,%ebx
f01062e0:	73 40                	jae    f0106322 <mpsearch1+0xb2>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01062e2:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01062e9:	00 
f01062ea:	c7 44 24 04 4d 8a 10 	movl   $0xf0108a4d,0x4(%esp)
f01062f1:	f0 
f01062f2:	89 1c 24             	mov    %ebx,(%esp)
f01062f5:	e8 95 fd ff ff       	call   f010608f <memcmp>
f01062fa:	85 c0                	test   %eax,%eax
f01062fc:	75 17                	jne    f0106315 <mpsearch1+0xa5>
f01062fe:	ba 00 00 00 00       	mov    $0x0,%edx
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
		sum += ((uint8_t *)addr)[i];
f0106303:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
f0106307:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106309:	83 c0 01             	add    $0x1,%eax
f010630c:	83 f8 10             	cmp    $0x10,%eax
f010630f:	75 f2                	jne    f0106303 <mpsearch1+0x93>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106311:	84 d2                	test   %dl,%dl
f0106313:	74 14                	je     f0106329 <mpsearch1+0xb9>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106315:	83 c3 10             	add    $0x10,%ebx
f0106318:	39 f3                	cmp    %esi,%ebx
f010631a:	72 c6                	jb     f01062e2 <mpsearch1+0x72>
f010631c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106320:	eb 0b                	jmp    f010632d <mpsearch1+0xbd>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106322:	b8 00 00 00 00       	mov    $0x0,%eax
f0106327:	eb 09                	jmp    f0106332 <mpsearch1+0xc2>
f0106329:	89 d8                	mov    %ebx,%eax
f010632b:	eb 05                	jmp    f0106332 <mpsearch1+0xc2>
f010632d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106332:	83 c4 10             	add    $0x10,%esp
f0106335:	5b                   	pop    %ebx
f0106336:	5e                   	pop    %esi
f0106337:	5d                   	pop    %ebp
f0106338:	c3                   	ret    

f0106339 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106339:	55                   	push   %ebp
f010633a:	89 e5                	mov    %esp,%ebp
f010633c:	57                   	push   %edi
f010633d:	56                   	push   %esi
f010633e:	53                   	push   %ebx
f010633f:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106342:	c7 05 c0 43 20 f0 20 	movl   $0xf0204020,0xf02043c0
f0106349:	40 20 f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010634c:	83 3d 88 3e 20 f0 00 	cmpl   $0x0,0xf0203e88
f0106353:	75 24                	jne    f0106379 <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106355:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f010635c:	00 
f010635d:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f0106364:	f0 
f0106365:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f010636c:	00 
f010636d:	c7 04 24 3d 8a 10 f0 	movl   $0xf0108a3d,(%esp)
f0106374:	e8 c7 9c ff ff       	call   f0100040 <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106379:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106380:	85 c0                	test   %eax,%eax
f0106382:	74 16                	je     f010639a <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f0106384:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106387:	ba 00 04 00 00       	mov    $0x400,%edx
f010638c:	e8 df fe ff ff       	call   f0106270 <mpsearch1>
f0106391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106394:	85 c0                	test   %eax,%eax
f0106396:	75 3c                	jne    f01063d4 <mp_init+0x9b>
f0106398:	eb 20                	jmp    f01063ba <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010639a:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01063a1:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01063a4:	2d 00 04 00 00       	sub    $0x400,%eax
f01063a9:	ba 00 04 00 00       	mov    $0x400,%edx
f01063ae:	e8 bd fe ff ff       	call   f0106270 <mpsearch1>
f01063b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01063b6:	85 c0                	test   %eax,%eax
f01063b8:	75 1a                	jne    f01063d4 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f01063ba:	ba 00 00 01 00       	mov    $0x10000,%edx
f01063bf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01063c4:	e8 a7 fe ff ff       	call   f0106270 <mpsearch1>
f01063c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f01063cc:	85 c0                	test   %eax,%eax
f01063ce:	0f 84 5f 02 00 00    	je     f0106633 <mp_init+0x2fa>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f01063d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01063d7:	8b 70 04             	mov    0x4(%eax),%esi
f01063da:	85 f6                	test   %esi,%esi
f01063dc:	74 06                	je     f01063e4 <mp_init+0xab>
f01063de:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f01063e2:	74 11                	je     f01063f5 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f01063e4:	c7 04 24 b0 88 10 f0 	movl   $0xf01088b0,(%esp)
f01063eb:	e8 81 dd ff ff       	call   f0104171 <cprintf>
f01063f0:	e9 3e 02 00 00       	jmp    f0106633 <mp_init+0x2fa>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01063f5:	89 f0                	mov    %esi,%eax
f01063f7:	c1 e8 0c             	shr    $0xc,%eax
f01063fa:	3b 05 88 3e 20 f0    	cmp    0xf0203e88,%eax
f0106400:	72 20                	jb     f0106422 <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106402:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106406:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f010640d:	f0 
f010640e:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f0106415:	00 
f0106416:	c7 04 24 3d 8a 10 f0 	movl   $0xf0108a3d,(%esp)
f010641d:	e8 1e 9c ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106422:	8d 9e 00 00 00 f0    	lea    -0x10000000(%esi),%ebx
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106428:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f010642f:	00 
f0106430:	c7 44 24 04 52 8a 10 	movl   $0xf0108a52,0x4(%esp)
f0106437:	f0 
f0106438:	89 1c 24             	mov    %ebx,(%esp)
f010643b:	e8 4f fc ff ff       	call   f010608f <memcmp>
f0106440:	85 c0                	test   %eax,%eax
f0106442:	74 11                	je     f0106455 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106444:	c7 04 24 e0 88 10 f0 	movl   $0xf01088e0,(%esp)
f010644b:	e8 21 dd ff ff       	call   f0104171 <cprintf>
f0106450:	e9 de 01 00 00       	jmp    f0106633 <mp_init+0x2fa>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106455:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f0106459:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
f010645d:	0f b7 f8             	movzwl %ax,%edi
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106460:	85 ff                	test   %edi,%edi
f0106462:	7e 30                	jle    f0106494 <mp_init+0x15b>
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106464:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106469:	b8 00 00 00 00       	mov    $0x0,%eax
		sum += ((uint8_t *)addr)[i];
f010646e:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f0106475:	f0 
f0106476:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106478:	83 c0 01             	add    $0x1,%eax
f010647b:	39 c7                	cmp    %eax,%edi
f010647d:	7f ef                	jg     f010646e <mp_init+0x135>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f010647f:	84 d2                	test   %dl,%dl
f0106481:	74 11                	je     f0106494 <mp_init+0x15b>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106483:	c7 04 24 14 89 10 f0 	movl   $0xf0108914,(%esp)
f010648a:	e8 e2 dc ff ff       	call   f0104171 <cprintf>
f010648f:	e9 9f 01 00 00       	jmp    f0106633 <mp_init+0x2fa>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0106494:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0106498:	3c 04                	cmp    $0x4,%al
f010649a:	74 1e                	je     f01064ba <mp_init+0x181>
f010649c:	3c 01                	cmp    $0x1,%al
f010649e:	66 90                	xchg   %ax,%ax
f01064a0:	74 18                	je     f01064ba <mp_init+0x181>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f01064a2:	0f b6 c0             	movzbl %al,%eax
f01064a5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064a9:	c7 04 24 38 89 10 f0 	movl   $0xf0108938,(%esp)
f01064b0:	e8 bc dc ff ff       	call   f0104171 <cprintf>
f01064b5:	e9 79 01 00 00       	jmp    f0106633 <mp_init+0x2fa>
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f01064ba:	0f b7 73 28          	movzwl 0x28(%ebx),%esi
f01064be:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
f01064c2:	01 df                	add    %ebx,%edi
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01064c4:	85 f6                	test   %esi,%esi
f01064c6:	7e 19                	jle    f01064e1 <mp_init+0x1a8>
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f01064c8:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f01064cd:	b8 00 00 00 00       	mov    $0x0,%eax
		sum += ((uint8_t *)addr)[i];
f01064d2:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
f01064d6:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01064d8:	83 c0 01             	add    $0x1,%eax
f01064db:	39 c6                	cmp    %eax,%esi
f01064dd:	7f f3                	jg     f01064d2 <mp_init+0x199>
f01064df:	eb 05                	jmp    f01064e6 <mp_init+0x1ad>
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f01064e1:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f01064e6:	38 53 2a             	cmp    %dl,0x2a(%ebx)
f01064e9:	74 11                	je     f01064fc <mp_init+0x1c3>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f01064eb:	c7 04 24 58 89 10 f0 	movl   $0xf0108958,(%esp)
f01064f2:	e8 7a dc ff ff       	call   f0104171 <cprintf>
f01064f7:	e9 37 01 00 00       	jmp    f0106633 <mp_init+0x2fa>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f01064fc:	85 db                	test   %ebx,%ebx
f01064fe:	0f 84 2f 01 00 00    	je     f0106633 <mp_init+0x2fa>
		return;
	ismp = 1;
f0106504:	c7 05 00 40 20 f0 01 	movl   $0x1,0xf0204000
f010650b:	00 00 00 
	lapicaddr = conf->lapicaddr;
f010650e:	8b 43 24             	mov    0x24(%ebx),%eax
f0106511:	a3 00 50 24 f0       	mov    %eax,0xf0245000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106516:	8d 7b 2c             	lea    0x2c(%ebx),%edi
f0106519:	66 83 7b 22 00       	cmpw   $0x0,0x22(%ebx)
f010651e:	0f 84 94 00 00 00    	je     f01065b8 <mp_init+0x27f>
f0106524:	be 00 00 00 00       	mov    $0x0,%esi
		switch (*p) {
f0106529:	0f b6 07             	movzbl (%edi),%eax
f010652c:	84 c0                	test   %al,%al
f010652e:	74 06                	je     f0106536 <mp_init+0x1fd>
f0106530:	3c 04                	cmp    $0x4,%al
f0106532:	77 54                	ja     f0106588 <mp_init+0x24f>
f0106534:	eb 4d                	jmp    f0106583 <mp_init+0x24a>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106536:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f010653a:	74 11                	je     f010654d <mp_init+0x214>
				bootcpu = &cpus[ncpu];
f010653c:	6b 05 c4 43 20 f0 74 	imul   $0x74,0xf02043c4,%eax
f0106543:	05 20 40 20 f0       	add    $0xf0204020,%eax
f0106548:	a3 c0 43 20 f0       	mov    %eax,0xf02043c0
			if (ncpu < NCPU) {
f010654d:	a1 c4 43 20 f0       	mov    0xf02043c4,%eax
f0106552:	83 f8 07             	cmp    $0x7,%eax
f0106555:	7f 13                	jg     f010656a <mp_init+0x231>
				cpus[ncpu].cpu_id = ncpu;
f0106557:	6b d0 74             	imul   $0x74,%eax,%edx
f010655a:	88 82 20 40 20 f0    	mov    %al,-0xfdfbfe0(%edx)
				ncpu++;
f0106560:	83 c0 01             	add    $0x1,%eax
f0106563:	a3 c4 43 20 f0       	mov    %eax,0xf02043c4
f0106568:	eb 14                	jmp    f010657e <mp_init+0x245>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f010656a:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f010656e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106572:	c7 04 24 88 89 10 f0 	movl   $0xf0108988,(%esp)
f0106579:	e8 f3 db ff ff       	call   f0104171 <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f010657e:	83 c7 14             	add    $0x14,%edi
			continue;
f0106581:	eb 26                	jmp    f01065a9 <mp_init+0x270>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106583:	83 c7 08             	add    $0x8,%edi
			continue;
f0106586:	eb 21                	jmp    f01065a9 <mp_init+0x270>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106588:	0f b6 c0             	movzbl %al,%eax
f010658b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010658f:	c7 04 24 b0 89 10 f0 	movl   $0xf01089b0,(%esp)
f0106596:	e8 d6 db ff ff       	call   f0104171 <cprintf>
			ismp = 0;
f010659b:	c7 05 00 40 20 f0 00 	movl   $0x0,0xf0204000
f01065a2:	00 00 00 
			i = conf->entry;
f01065a5:	0f b7 73 22          	movzwl 0x22(%ebx),%esi
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01065a9:	83 c6 01             	add    $0x1,%esi
f01065ac:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
f01065b0:	39 f0                	cmp    %esi,%eax
f01065b2:	0f 87 71 ff ff ff    	ja     f0106529 <mp_init+0x1f0>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f01065b8:	a1 c0 43 20 f0       	mov    0xf02043c0,%eax
f01065bd:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f01065c4:	83 3d 00 40 20 f0 00 	cmpl   $0x0,0xf0204000
f01065cb:	75 22                	jne    f01065ef <mp_init+0x2b6>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f01065cd:	c7 05 c4 43 20 f0 01 	movl   $0x1,0xf02043c4
f01065d4:	00 00 00 
		lapicaddr = 0;
f01065d7:	c7 05 00 50 24 f0 00 	movl   $0x0,0xf0245000
f01065de:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f01065e1:	c7 04 24 d0 89 10 f0 	movl   $0xf01089d0,(%esp)
f01065e8:	e8 84 db ff ff       	call   f0104171 <cprintf>
		return;
f01065ed:	eb 44                	jmp    f0106633 <mp_init+0x2fa>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f01065ef:	8b 15 c4 43 20 f0    	mov    0xf02043c4,%edx
f01065f5:	89 54 24 08          	mov    %edx,0x8(%esp)
f01065f9:	0f b6 00             	movzbl (%eax),%eax
f01065fc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106600:	c7 04 24 57 8a 10 f0 	movl   $0xf0108a57,(%esp)
f0106607:	e8 65 db ff ff       	call   f0104171 <cprintf>

	if (mp->imcrp) {
f010660c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010660f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106613:	74 1e                	je     f0106633 <mp_init+0x2fa>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106615:	c7 04 24 fc 89 10 f0 	movl   $0xf01089fc,(%esp)
f010661c:	e8 50 db ff ff       	call   f0104171 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106621:	ba 22 00 00 00       	mov    $0x22,%edx
f0106626:	b8 70 00 00 00       	mov    $0x70,%eax
f010662b:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010662c:	b2 23                	mov    $0x23,%dl
f010662e:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f010662f:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106632:	ee                   	out    %al,(%dx)
	}
}
f0106633:	83 c4 2c             	add    $0x2c,%esp
f0106636:	5b                   	pop    %ebx
f0106637:	5e                   	pop    %esi
f0106638:	5f                   	pop    %edi
f0106639:	5d                   	pop    %ebp
f010663a:	c3                   	ret    

f010663b <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f010663b:	55                   	push   %ebp
f010663c:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f010663e:	8b 0d 04 50 24 f0    	mov    0xf0245004,%ecx
f0106644:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106647:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106649:	a1 04 50 24 f0       	mov    0xf0245004,%eax
f010664e:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106651:	5d                   	pop    %ebp
f0106652:	c3                   	ret    

f0106653 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106653:	55                   	push   %ebp
f0106654:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106656:	a1 04 50 24 f0       	mov    0xf0245004,%eax
f010665b:	85 c0                	test   %eax,%eax
f010665d:	74 08                	je     f0106667 <cpunum+0x14>
		return lapic[ID] >> 24;
f010665f:	8b 40 20             	mov    0x20(%eax),%eax
f0106662:	c1 e8 18             	shr    $0x18,%eax
f0106665:	eb 05                	jmp    f010666c <cpunum+0x19>
	return 0;
f0106667:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010666c:	5d                   	pop    %ebp
f010666d:	c3                   	ret    

f010666e <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f010666e:	a1 00 50 24 f0       	mov    0xf0245000,%eax
f0106673:	85 c0                	test   %eax,%eax
f0106675:	0f 84 23 01 00 00    	je     f010679e <lapic_init+0x130>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f010667b:	55                   	push   %ebp
f010667c:	89 e5                	mov    %esp,%ebp
f010667e:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f0106681:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0106688:	00 
f0106689:	89 04 24             	mov    %eax,(%esp)
f010668c:	e8 bf af ff ff       	call   f0101650 <mmio_map_region>
f0106691:	a3 04 50 24 f0       	mov    %eax,0xf0245004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106696:	ba 27 01 00 00       	mov    $0x127,%edx
f010669b:	b8 3c 00 00 00       	mov    $0x3c,%eax
f01066a0:	e8 96 ff ff ff       	call   f010663b <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f01066a5:	ba 0b 00 00 00       	mov    $0xb,%edx
f01066aa:	b8 f8 00 00 00       	mov    $0xf8,%eax
f01066af:	e8 87 ff ff ff       	call   f010663b <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01066b4:	ba 20 00 02 00       	mov    $0x20020,%edx
f01066b9:	b8 c8 00 00 00       	mov    $0xc8,%eax
f01066be:	e8 78 ff ff ff       	call   f010663b <lapicw>
	lapicw(TICR, 10000000); 
f01066c3:	ba 80 96 98 00       	mov    $0x989680,%edx
f01066c8:	b8 e0 00 00 00       	mov    $0xe0,%eax
f01066cd:	e8 69 ff ff ff       	call   f010663b <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f01066d2:	e8 7c ff ff ff       	call   f0106653 <cpunum>
f01066d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01066da:	05 20 40 20 f0       	add    $0xf0204020,%eax
f01066df:	39 05 c0 43 20 f0    	cmp    %eax,0xf02043c0
f01066e5:	74 0f                	je     f01066f6 <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f01066e7:	ba 00 00 01 00       	mov    $0x10000,%edx
f01066ec:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01066f1:	e8 45 ff ff ff       	call   f010663b <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f01066f6:	ba 00 00 01 00       	mov    $0x10000,%edx
f01066fb:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106700:	e8 36 ff ff ff       	call   f010663b <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106705:	a1 04 50 24 f0       	mov    0xf0245004,%eax
f010670a:	8b 40 30             	mov    0x30(%eax),%eax
f010670d:	c1 e8 10             	shr    $0x10,%eax
f0106710:	3c 03                	cmp    $0x3,%al
f0106712:	76 0f                	jbe    f0106723 <lapic_init+0xb5>
		lapicw(PCINT, MASKED);
f0106714:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106719:	b8 d0 00 00 00       	mov    $0xd0,%eax
f010671e:	e8 18 ff ff ff       	call   f010663b <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106723:	ba 33 00 00 00       	mov    $0x33,%edx
f0106728:	b8 dc 00 00 00       	mov    $0xdc,%eax
f010672d:	e8 09 ff ff ff       	call   f010663b <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0106732:	ba 00 00 00 00       	mov    $0x0,%edx
f0106737:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010673c:	e8 fa fe ff ff       	call   f010663b <lapicw>
	lapicw(ESR, 0);
f0106741:	ba 00 00 00 00       	mov    $0x0,%edx
f0106746:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010674b:	e8 eb fe ff ff       	call   f010663b <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0106750:	ba 00 00 00 00       	mov    $0x0,%edx
f0106755:	b8 2c 00 00 00       	mov    $0x2c,%eax
f010675a:	e8 dc fe ff ff       	call   f010663b <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f010675f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106764:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106769:	e8 cd fe ff ff       	call   f010663b <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f010676e:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106773:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106778:	e8 be fe ff ff       	call   f010663b <lapicw>
	while(lapic[ICRLO] & DELIVS)
f010677d:	8b 15 04 50 24 f0    	mov    0xf0245004,%edx
f0106783:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106789:	f6 c4 10             	test   $0x10,%ah
f010678c:	75 f5                	jne    f0106783 <lapic_init+0x115>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f010678e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106793:	b8 20 00 00 00       	mov    $0x20,%eax
f0106798:	e8 9e fe ff ff       	call   f010663b <lapicw>
}
f010679d:	c9                   	leave  
f010679e:	f3 c3                	repz ret 

f01067a0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f01067a0:	83 3d 04 50 24 f0 00 	cmpl   $0x0,0xf0245004
f01067a7:	74 13                	je     f01067bc <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f01067a9:	55                   	push   %ebp
f01067aa:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f01067ac:	ba 00 00 00 00       	mov    $0x0,%edx
f01067b1:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01067b6:	e8 80 fe ff ff       	call   f010663b <lapicw>
}
f01067bb:	5d                   	pop    %ebp
f01067bc:	f3 c3                	repz ret 

f01067be <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f01067be:	55                   	push   %ebp
f01067bf:	89 e5                	mov    %esp,%ebp
f01067c1:	56                   	push   %esi
f01067c2:	53                   	push   %ebx
f01067c3:	83 ec 10             	sub    $0x10,%esp
f01067c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01067c9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01067cc:	ba 70 00 00 00       	mov    $0x70,%edx
f01067d1:	b8 0f 00 00 00       	mov    $0xf,%eax
f01067d6:	ee                   	out    %al,(%dx)
f01067d7:	b2 71                	mov    $0x71,%dl
f01067d9:	b8 0a 00 00 00       	mov    $0xa,%eax
f01067de:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01067df:	83 3d 88 3e 20 f0 00 	cmpl   $0x0,0xf0203e88
f01067e6:	75 24                	jne    f010680c <lapic_startap+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01067e8:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f01067ef:	00 
f01067f0:	c7 44 24 08 84 6d 10 	movl   $0xf0106d84,0x8(%esp)
f01067f7:	f0 
f01067f8:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
f01067ff:	00 
f0106800:	c7 04 24 74 8a 10 f0 	movl   $0xf0108a74,(%esp)
f0106807:	e8 34 98 ff ff       	call   f0100040 <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010680c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106813:	00 00 
	wrv[1] = addr >> 4;
f0106815:	89 f0                	mov    %esi,%eax
f0106817:	c1 e8 04             	shr    $0x4,%eax
f010681a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106820:	c1 e3 18             	shl    $0x18,%ebx
f0106823:	89 da                	mov    %ebx,%edx
f0106825:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010682a:	e8 0c fe ff ff       	call   f010663b <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010682f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106834:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106839:	e8 fd fd ff ff       	call   f010663b <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f010683e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106843:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106848:	e8 ee fd ff ff       	call   f010663b <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010684d:	c1 ee 0c             	shr    $0xc,%esi
f0106850:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0106856:	89 da                	mov    %ebx,%edx
f0106858:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010685d:	e8 d9 fd ff ff       	call   f010663b <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106862:	89 f2                	mov    %esi,%edx
f0106864:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106869:	e8 cd fd ff ff       	call   f010663b <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f010686e:	89 da                	mov    %ebx,%edx
f0106870:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106875:	e8 c1 fd ff ff       	call   f010663b <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010687a:	89 f2                	mov    %esi,%edx
f010687c:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106881:	e8 b5 fd ff ff       	call   f010663b <lapicw>
		microdelay(200);
	}
}
f0106886:	83 c4 10             	add    $0x10,%esp
f0106889:	5b                   	pop    %ebx
f010688a:	5e                   	pop    %esi
f010688b:	5d                   	pop    %ebp
f010688c:	c3                   	ret    

f010688d <lapic_ipi>:

void
lapic_ipi(int vector)
{
f010688d:	55                   	push   %ebp
f010688e:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106890:	8b 55 08             	mov    0x8(%ebp),%edx
f0106893:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106899:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010689e:	e8 98 fd ff ff       	call   f010663b <lapicw>
	while (lapic[ICRLO] & DELIVS)
f01068a3:	8b 15 04 50 24 f0    	mov    0xf0245004,%edx
f01068a9:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01068af:	f6 c4 10             	test   $0x10,%ah
f01068b2:	75 f5                	jne    f01068a9 <lapic_ipi+0x1c>
		;
}
f01068b4:	5d                   	pop    %ebp
f01068b5:	c3                   	ret    

f01068b6 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01068b6:	55                   	push   %ebp
f01068b7:	89 e5                	mov    %esp,%ebp
f01068b9:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01068bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01068c2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01068c5:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01068c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f01068cf:	5d                   	pop    %ebp
f01068d0:	c3                   	ret    

f01068d1 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f01068d1:	55                   	push   %ebp
f01068d2:	89 e5                	mov    %esp,%ebp
f01068d4:	56                   	push   %esi
f01068d5:	53                   	push   %ebx
f01068d6:	83 ec 20             	sub    $0x20,%esp
f01068d9:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f01068dc:	83 3b 00             	cmpl   $0x0,(%ebx)
f01068df:	74 14                	je     f01068f5 <spin_lock+0x24>
f01068e1:	8b 73 08             	mov    0x8(%ebx),%esi
f01068e4:	e8 6a fd ff ff       	call   f0106653 <cpunum>
f01068e9:	6b c0 74             	imul   $0x74,%eax,%eax
f01068ec:	05 20 40 20 f0       	add    $0xf0204020,%eax
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01068f1:	39 c6                	cmp    %eax,%esi
f01068f3:	74 15                	je     f010690a <spin_lock+0x39>
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f01068f5:	89 da                	mov    %ebx,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f01068f7:	b8 01 00 00 00       	mov    $0x1,%eax
f01068fc:	f0 87 03             	lock xchg %eax,(%ebx)
f01068ff:	b9 01 00 00 00       	mov    $0x1,%ecx
f0106904:	85 c0                	test   %eax,%eax
f0106906:	75 2e                	jne    f0106936 <spin_lock+0x65>
f0106908:	eb 37                	jmp    f0106941 <spin_lock+0x70>
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010690a:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010690d:	e8 41 fd ff ff       	call   f0106653 <cpunum>
f0106912:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f0106916:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010691a:	c7 44 24 08 84 8a 10 	movl   $0xf0108a84,0x8(%esp)
f0106921:	f0 
f0106922:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f0106929:	00 
f010692a:	c7 04 24 e8 8a 10 f0 	movl   $0xf0108ae8,(%esp)
f0106931:	e8 0a 97 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106936:	f3 90                	pause  
f0106938:	89 c8                	mov    %ecx,%eax
f010693a:	f0 87 02             	lock xchg %eax,(%edx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f010693d:	85 c0                	test   %eax,%eax
f010693f:	75 f5                	jne    f0106936 <spin_lock+0x65>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106941:	e8 0d fd ff ff       	call   f0106653 <cpunum>
f0106946:	6b c0 74             	imul   $0x74,%eax,%eax
f0106949:	05 20 40 20 f0       	add    $0xf0204020,%eax
f010694e:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0106951:	8d 4b 0c             	lea    0xc(%ebx),%ecx

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f0106954:	89 e8                	mov    %ebp,%eax
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106956:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f010695b:	77 34                	ja     f0106991 <spin_lock+0xc0>
f010695d:	eb 2b                	jmp    f010698a <spin_lock+0xb9>
f010695f:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106965:	76 12                	jbe    f0106979 <spin_lock+0xa8>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106967:	8b 5a 04             	mov    0x4(%edx),%ebx
f010696a:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f010696d:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f010696f:	83 c0 01             	add    $0x1,%eax
f0106972:	83 f8 0a             	cmp    $0xa,%eax
f0106975:	75 e8                	jne    f010695f <spin_lock+0x8e>
f0106977:	eb 27                	jmp    f01069a0 <spin_lock+0xcf>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0106979:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0106980:	83 c0 01             	add    $0x1,%eax
f0106983:	83 f8 09             	cmp    $0x9,%eax
f0106986:	7e f1                	jle    f0106979 <spin_lock+0xa8>
f0106988:	eb 16                	jmp    f01069a0 <spin_lock+0xcf>
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f010698a:	b8 00 00 00 00       	mov    $0x0,%eax
f010698f:	eb e8                	jmp    f0106979 <spin_lock+0xa8>
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106991:	8b 50 04             	mov    0x4(%eax),%edx
f0106994:	89 53 0c             	mov    %edx,0xc(%ebx)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106997:	8b 10                	mov    (%eax),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106999:	b8 01 00 00 00       	mov    $0x1,%eax
f010699e:	eb bf                	jmp    f010695f <spin_lock+0x8e>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f01069a0:	83 c4 20             	add    $0x20,%esp
f01069a3:	5b                   	pop    %ebx
f01069a4:	5e                   	pop    %esi
f01069a5:	5d                   	pop    %ebp
f01069a6:	c3                   	ret    

f01069a7 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01069a7:	55                   	push   %ebp
f01069a8:	89 e5                	mov    %esp,%ebp
f01069aa:	57                   	push   %edi
f01069ab:	56                   	push   %esi
f01069ac:	53                   	push   %ebx
f01069ad:	83 ec 6c             	sub    $0x6c,%esp
f01069b0:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f01069b3:	83 3b 00             	cmpl   $0x0,(%ebx)
f01069b6:	74 18                	je     f01069d0 <spin_unlock+0x29>
f01069b8:	8b 73 08             	mov    0x8(%ebx),%esi
f01069bb:	e8 93 fc ff ff       	call   f0106653 <cpunum>
f01069c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01069c3:	05 20 40 20 f0       	add    $0xf0204020,%eax
// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f01069c8:	39 c6                	cmp    %eax,%esi
f01069ca:	0f 84 d4 00 00 00    	je     f0106aa4 <spin_unlock+0xfd>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01069d0:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f01069d7:	00 
f01069d8:	8d 43 0c             	lea    0xc(%ebx),%eax
f01069db:	89 44 24 04          	mov    %eax,0x4(%esp)
f01069df:	8d 45 c0             	lea    -0x40(%ebp),%eax
f01069e2:	89 04 24             	mov    %eax,(%esp)
f01069e5:	e8 1c f6 ff ff       	call   f0106006 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f01069ea:	8b 43 08             	mov    0x8(%ebx),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01069ed:	0f b6 30             	movzbl (%eax),%esi
f01069f0:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01069f3:	e8 5b fc ff ff       	call   f0106653 <cpunum>
f01069f8:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01069fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0106a00:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106a04:	c7 04 24 b0 8a 10 f0 	movl   $0xf0108ab0,(%esp)
f0106a0b:	e8 61 d7 ff ff       	call   f0104171 <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106a10:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0106a13:	85 c0                	test   %eax,%eax
f0106a15:	74 71                	je     f0106a88 <spin_unlock+0xe1>
f0106a17:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106a1a:	8d 7d e4             	lea    -0x1c(%ebp),%edi
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106a1d:	8d 75 a8             	lea    -0x58(%ebp),%esi
f0106a20:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106a24:	89 04 24             	mov    %eax,(%esp)
f0106a27:	e8 7a e9 ff ff       	call   f01053a6 <debuginfo_eip>
f0106a2c:	85 c0                	test   %eax,%eax
f0106a2e:	78 39                	js     f0106a69 <spin_unlock+0xc2>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f0106a30:	8b 03                	mov    (%ebx),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106a32:	89 c2                	mov    %eax,%edx
f0106a34:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106a37:	89 54 24 18          	mov    %edx,0x18(%esp)
f0106a3b:	8b 55 b0             	mov    -0x50(%ebp),%edx
f0106a3e:	89 54 24 14          	mov    %edx,0x14(%esp)
f0106a42:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f0106a45:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106a49:	8b 55 ac             	mov    -0x54(%ebp),%edx
f0106a4c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106a50:	8b 55 a8             	mov    -0x58(%ebp),%edx
f0106a53:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106a57:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106a5b:	c7 04 24 f8 8a 10 f0 	movl   $0xf0108af8,(%esp)
f0106a62:	e8 0a d7 ff ff       	call   f0104171 <cprintf>
f0106a67:	eb 12                	jmp    f0106a7b <spin_unlock+0xd4>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f0106a69:	8b 03                	mov    (%ebx),%eax
f0106a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106a6f:	c7 04 24 0f 8b 10 f0 	movl   $0xf0108b0f,(%esp)
f0106a76:	e8 f6 d6 ff ff       	call   f0104171 <cprintf>
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106a7b:	39 fb                	cmp    %edi,%ebx
f0106a7d:	74 09                	je     f0106a88 <spin_unlock+0xe1>
f0106a7f:	83 c3 04             	add    $0x4,%ebx
f0106a82:	8b 03                	mov    (%ebx),%eax
f0106a84:	85 c0                	test   %eax,%eax
f0106a86:	75 98                	jne    f0106a20 <spin_unlock+0x79>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0106a88:	c7 44 24 08 17 8b 10 	movl   $0xf0108b17,0x8(%esp)
f0106a8f:	f0 
f0106a90:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0106a97:	00 
f0106a98:	c7 04 24 e8 8a 10 f0 	movl   $0xf0108ae8,(%esp)
f0106a9f:	e8 9c 95 ff ff       	call   f0100040 <_panic>
	}

	lk->pcs[0] = 0;
f0106aa4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu = 0;
f0106aab:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0106ab2:	b8 00 00 00 00       	mov    $0x0,%eax
f0106ab7:	f0 87 03             	lock xchg %eax,(%ebx)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0106aba:	83 c4 6c             	add    $0x6c,%esp
f0106abd:	5b                   	pop    %ebx
f0106abe:	5e                   	pop    %esi
f0106abf:	5f                   	pop    %edi
f0106ac0:	5d                   	pop    %ebp
f0106ac1:	c3                   	ret    
f0106ac2:	66 90                	xchg   %ax,%ax
f0106ac4:	66 90                	xchg   %ax,%ax
f0106ac6:	66 90                	xchg   %ax,%ax
f0106ac8:	66 90                	xchg   %ax,%ax
f0106aca:	66 90                	xchg   %ax,%ax
f0106acc:	66 90                	xchg   %ax,%ax
f0106ace:	66 90                	xchg   %ax,%ax

f0106ad0 <__udivdi3>:
f0106ad0:	55                   	push   %ebp
f0106ad1:	57                   	push   %edi
f0106ad2:	56                   	push   %esi
f0106ad3:	83 ec 0c             	sub    $0xc,%esp
f0106ad6:	8b 44 24 28          	mov    0x28(%esp),%eax
f0106ada:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
f0106ade:	8b 6c 24 20          	mov    0x20(%esp),%ebp
f0106ae2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0106ae6:	85 c0                	test   %eax,%eax
f0106ae8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106aec:	89 ea                	mov    %ebp,%edx
f0106aee:	89 0c 24             	mov    %ecx,(%esp)
f0106af1:	75 2d                	jne    f0106b20 <__udivdi3+0x50>
f0106af3:	39 e9                	cmp    %ebp,%ecx
f0106af5:	77 61                	ja     f0106b58 <__udivdi3+0x88>
f0106af7:	85 c9                	test   %ecx,%ecx
f0106af9:	89 ce                	mov    %ecx,%esi
f0106afb:	75 0b                	jne    f0106b08 <__udivdi3+0x38>
f0106afd:	b8 01 00 00 00       	mov    $0x1,%eax
f0106b02:	31 d2                	xor    %edx,%edx
f0106b04:	f7 f1                	div    %ecx
f0106b06:	89 c6                	mov    %eax,%esi
f0106b08:	31 d2                	xor    %edx,%edx
f0106b0a:	89 e8                	mov    %ebp,%eax
f0106b0c:	f7 f6                	div    %esi
f0106b0e:	89 c5                	mov    %eax,%ebp
f0106b10:	89 f8                	mov    %edi,%eax
f0106b12:	f7 f6                	div    %esi
f0106b14:	89 ea                	mov    %ebp,%edx
f0106b16:	83 c4 0c             	add    $0xc,%esp
f0106b19:	5e                   	pop    %esi
f0106b1a:	5f                   	pop    %edi
f0106b1b:	5d                   	pop    %ebp
f0106b1c:	c3                   	ret    
f0106b1d:	8d 76 00             	lea    0x0(%esi),%esi
f0106b20:	39 e8                	cmp    %ebp,%eax
f0106b22:	77 24                	ja     f0106b48 <__udivdi3+0x78>
f0106b24:	0f bd e8             	bsr    %eax,%ebp
f0106b27:	83 f5 1f             	xor    $0x1f,%ebp
f0106b2a:	75 3c                	jne    f0106b68 <__udivdi3+0x98>
f0106b2c:	8b 74 24 04          	mov    0x4(%esp),%esi
f0106b30:	39 34 24             	cmp    %esi,(%esp)
f0106b33:	0f 86 9f 00 00 00    	jbe    f0106bd8 <__udivdi3+0x108>
f0106b39:	39 d0                	cmp    %edx,%eax
f0106b3b:	0f 82 97 00 00 00    	jb     f0106bd8 <__udivdi3+0x108>
f0106b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106b48:	31 d2                	xor    %edx,%edx
f0106b4a:	31 c0                	xor    %eax,%eax
f0106b4c:	83 c4 0c             	add    $0xc,%esp
f0106b4f:	5e                   	pop    %esi
f0106b50:	5f                   	pop    %edi
f0106b51:	5d                   	pop    %ebp
f0106b52:	c3                   	ret    
f0106b53:	90                   	nop
f0106b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106b58:	89 f8                	mov    %edi,%eax
f0106b5a:	f7 f1                	div    %ecx
f0106b5c:	31 d2                	xor    %edx,%edx
f0106b5e:	83 c4 0c             	add    $0xc,%esp
f0106b61:	5e                   	pop    %esi
f0106b62:	5f                   	pop    %edi
f0106b63:	5d                   	pop    %ebp
f0106b64:	c3                   	ret    
f0106b65:	8d 76 00             	lea    0x0(%esi),%esi
f0106b68:	89 e9                	mov    %ebp,%ecx
f0106b6a:	8b 3c 24             	mov    (%esp),%edi
f0106b6d:	d3 e0                	shl    %cl,%eax
f0106b6f:	89 c6                	mov    %eax,%esi
f0106b71:	b8 20 00 00 00       	mov    $0x20,%eax
f0106b76:	29 e8                	sub    %ebp,%eax
f0106b78:	89 c1                	mov    %eax,%ecx
f0106b7a:	d3 ef                	shr    %cl,%edi
f0106b7c:	89 e9                	mov    %ebp,%ecx
f0106b7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106b82:	8b 3c 24             	mov    (%esp),%edi
f0106b85:	09 74 24 08          	or     %esi,0x8(%esp)
f0106b89:	89 d6                	mov    %edx,%esi
f0106b8b:	d3 e7                	shl    %cl,%edi
f0106b8d:	89 c1                	mov    %eax,%ecx
f0106b8f:	89 3c 24             	mov    %edi,(%esp)
f0106b92:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106b96:	d3 ee                	shr    %cl,%esi
f0106b98:	89 e9                	mov    %ebp,%ecx
f0106b9a:	d3 e2                	shl    %cl,%edx
f0106b9c:	89 c1                	mov    %eax,%ecx
f0106b9e:	d3 ef                	shr    %cl,%edi
f0106ba0:	09 d7                	or     %edx,%edi
f0106ba2:	89 f2                	mov    %esi,%edx
f0106ba4:	89 f8                	mov    %edi,%eax
f0106ba6:	f7 74 24 08          	divl   0x8(%esp)
f0106baa:	89 d6                	mov    %edx,%esi
f0106bac:	89 c7                	mov    %eax,%edi
f0106bae:	f7 24 24             	mull   (%esp)
f0106bb1:	39 d6                	cmp    %edx,%esi
f0106bb3:	89 14 24             	mov    %edx,(%esp)
f0106bb6:	72 30                	jb     f0106be8 <__udivdi3+0x118>
f0106bb8:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106bbc:	89 e9                	mov    %ebp,%ecx
f0106bbe:	d3 e2                	shl    %cl,%edx
f0106bc0:	39 c2                	cmp    %eax,%edx
f0106bc2:	73 05                	jae    f0106bc9 <__udivdi3+0xf9>
f0106bc4:	3b 34 24             	cmp    (%esp),%esi
f0106bc7:	74 1f                	je     f0106be8 <__udivdi3+0x118>
f0106bc9:	89 f8                	mov    %edi,%eax
f0106bcb:	31 d2                	xor    %edx,%edx
f0106bcd:	e9 7a ff ff ff       	jmp    f0106b4c <__udivdi3+0x7c>
f0106bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106bd8:	31 d2                	xor    %edx,%edx
f0106bda:	b8 01 00 00 00       	mov    $0x1,%eax
f0106bdf:	e9 68 ff ff ff       	jmp    f0106b4c <__udivdi3+0x7c>
f0106be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106be8:	8d 47 ff             	lea    -0x1(%edi),%eax
f0106beb:	31 d2                	xor    %edx,%edx
f0106bed:	83 c4 0c             	add    $0xc,%esp
f0106bf0:	5e                   	pop    %esi
f0106bf1:	5f                   	pop    %edi
f0106bf2:	5d                   	pop    %ebp
f0106bf3:	c3                   	ret    
f0106bf4:	66 90                	xchg   %ax,%ax
f0106bf6:	66 90                	xchg   %ax,%ax
f0106bf8:	66 90                	xchg   %ax,%ax
f0106bfa:	66 90                	xchg   %ax,%ax
f0106bfc:	66 90                	xchg   %ax,%ax
f0106bfe:	66 90                	xchg   %ax,%ax

f0106c00 <__umoddi3>:
f0106c00:	55                   	push   %ebp
f0106c01:	57                   	push   %edi
f0106c02:	56                   	push   %esi
f0106c03:	83 ec 14             	sub    $0x14,%esp
f0106c06:	8b 44 24 28          	mov    0x28(%esp),%eax
f0106c0a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0106c0e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
f0106c12:	89 c7                	mov    %eax,%edi
f0106c14:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c18:	8b 44 24 30          	mov    0x30(%esp),%eax
f0106c1c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0106c20:	89 34 24             	mov    %esi,(%esp)
f0106c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106c27:	85 c0                	test   %eax,%eax
f0106c29:	89 c2                	mov    %eax,%edx
f0106c2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106c2f:	75 17                	jne    f0106c48 <__umoddi3+0x48>
f0106c31:	39 fe                	cmp    %edi,%esi
f0106c33:	76 4b                	jbe    f0106c80 <__umoddi3+0x80>
f0106c35:	89 c8                	mov    %ecx,%eax
f0106c37:	89 fa                	mov    %edi,%edx
f0106c39:	f7 f6                	div    %esi
f0106c3b:	89 d0                	mov    %edx,%eax
f0106c3d:	31 d2                	xor    %edx,%edx
f0106c3f:	83 c4 14             	add    $0x14,%esp
f0106c42:	5e                   	pop    %esi
f0106c43:	5f                   	pop    %edi
f0106c44:	5d                   	pop    %ebp
f0106c45:	c3                   	ret    
f0106c46:	66 90                	xchg   %ax,%ax
f0106c48:	39 f8                	cmp    %edi,%eax
f0106c4a:	77 54                	ja     f0106ca0 <__umoddi3+0xa0>
f0106c4c:	0f bd e8             	bsr    %eax,%ebp
f0106c4f:	83 f5 1f             	xor    $0x1f,%ebp
f0106c52:	75 5c                	jne    f0106cb0 <__umoddi3+0xb0>
f0106c54:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0106c58:	39 3c 24             	cmp    %edi,(%esp)
f0106c5b:	0f 87 e7 00 00 00    	ja     f0106d48 <__umoddi3+0x148>
f0106c61:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106c65:	29 f1                	sub    %esi,%ecx
f0106c67:	19 c7                	sbb    %eax,%edi
f0106c69:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106c6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106c71:	8b 44 24 08          	mov    0x8(%esp),%eax
f0106c75:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0106c79:	83 c4 14             	add    $0x14,%esp
f0106c7c:	5e                   	pop    %esi
f0106c7d:	5f                   	pop    %edi
f0106c7e:	5d                   	pop    %ebp
f0106c7f:	c3                   	ret    
f0106c80:	85 f6                	test   %esi,%esi
f0106c82:	89 f5                	mov    %esi,%ebp
f0106c84:	75 0b                	jne    f0106c91 <__umoddi3+0x91>
f0106c86:	b8 01 00 00 00       	mov    $0x1,%eax
f0106c8b:	31 d2                	xor    %edx,%edx
f0106c8d:	f7 f6                	div    %esi
f0106c8f:	89 c5                	mov    %eax,%ebp
f0106c91:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106c95:	31 d2                	xor    %edx,%edx
f0106c97:	f7 f5                	div    %ebp
f0106c99:	89 c8                	mov    %ecx,%eax
f0106c9b:	f7 f5                	div    %ebp
f0106c9d:	eb 9c                	jmp    f0106c3b <__umoddi3+0x3b>
f0106c9f:	90                   	nop
f0106ca0:	89 c8                	mov    %ecx,%eax
f0106ca2:	89 fa                	mov    %edi,%edx
f0106ca4:	83 c4 14             	add    $0x14,%esp
f0106ca7:	5e                   	pop    %esi
f0106ca8:	5f                   	pop    %edi
f0106ca9:	5d                   	pop    %ebp
f0106caa:	c3                   	ret    
f0106cab:	90                   	nop
f0106cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106cb0:	8b 04 24             	mov    (%esp),%eax
f0106cb3:	be 20 00 00 00       	mov    $0x20,%esi
f0106cb8:	89 e9                	mov    %ebp,%ecx
f0106cba:	29 ee                	sub    %ebp,%esi
f0106cbc:	d3 e2                	shl    %cl,%edx
f0106cbe:	89 f1                	mov    %esi,%ecx
f0106cc0:	d3 e8                	shr    %cl,%eax
f0106cc2:	89 e9                	mov    %ebp,%ecx
f0106cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106cc8:	8b 04 24             	mov    (%esp),%eax
f0106ccb:	09 54 24 04          	or     %edx,0x4(%esp)
f0106ccf:	89 fa                	mov    %edi,%edx
f0106cd1:	d3 e0                	shl    %cl,%eax
f0106cd3:	89 f1                	mov    %esi,%ecx
f0106cd5:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106cd9:	8b 44 24 10          	mov    0x10(%esp),%eax
f0106cdd:	d3 ea                	shr    %cl,%edx
f0106cdf:	89 e9                	mov    %ebp,%ecx
f0106ce1:	d3 e7                	shl    %cl,%edi
f0106ce3:	89 f1                	mov    %esi,%ecx
f0106ce5:	d3 e8                	shr    %cl,%eax
f0106ce7:	89 e9                	mov    %ebp,%ecx
f0106ce9:	09 f8                	or     %edi,%eax
f0106ceb:	8b 7c 24 10          	mov    0x10(%esp),%edi
f0106cef:	f7 74 24 04          	divl   0x4(%esp)
f0106cf3:	d3 e7                	shl    %cl,%edi
f0106cf5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106cf9:	89 d7                	mov    %edx,%edi
f0106cfb:	f7 64 24 08          	mull   0x8(%esp)
f0106cff:	39 d7                	cmp    %edx,%edi
f0106d01:	89 c1                	mov    %eax,%ecx
f0106d03:	89 14 24             	mov    %edx,(%esp)
f0106d06:	72 2c                	jb     f0106d34 <__umoddi3+0x134>
f0106d08:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f0106d0c:	72 22                	jb     f0106d30 <__umoddi3+0x130>
f0106d0e:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0106d12:	29 c8                	sub    %ecx,%eax
f0106d14:	19 d7                	sbb    %edx,%edi
f0106d16:	89 e9                	mov    %ebp,%ecx
f0106d18:	89 fa                	mov    %edi,%edx
f0106d1a:	d3 e8                	shr    %cl,%eax
f0106d1c:	89 f1                	mov    %esi,%ecx
f0106d1e:	d3 e2                	shl    %cl,%edx
f0106d20:	89 e9                	mov    %ebp,%ecx
f0106d22:	d3 ef                	shr    %cl,%edi
f0106d24:	09 d0                	or     %edx,%eax
f0106d26:	89 fa                	mov    %edi,%edx
f0106d28:	83 c4 14             	add    $0x14,%esp
f0106d2b:	5e                   	pop    %esi
f0106d2c:	5f                   	pop    %edi
f0106d2d:	5d                   	pop    %ebp
f0106d2e:	c3                   	ret    
f0106d2f:	90                   	nop
f0106d30:	39 d7                	cmp    %edx,%edi
f0106d32:	75 da                	jne    f0106d0e <__umoddi3+0x10e>
f0106d34:	8b 14 24             	mov    (%esp),%edx
f0106d37:	89 c1                	mov    %eax,%ecx
f0106d39:	2b 4c 24 08          	sub    0x8(%esp),%ecx
f0106d3d:	1b 54 24 04          	sbb    0x4(%esp),%edx
f0106d41:	eb cb                	jmp    f0106d0e <__umoddi3+0x10e>
f0106d43:	90                   	nop
f0106d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106d48:	3b 44 24 0c          	cmp    0xc(%esp),%eax
f0106d4c:	0f 82 0f ff ff ff    	jb     f0106c61 <__umoddi3+0x61>
f0106d52:	e9 1a ff ff ff       	jmp    f0106c71 <__umoddi3+0x71>
