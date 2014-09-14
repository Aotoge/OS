
obj/user/dumbfork.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 3d 02 00 00       	call   80026e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <duppage>:

// dstenv is the child's env
// addr is the va of the parent
void
duppage(envid_t dstenv, void *addr)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	// allocate a page starting at addr in child's process space
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80004e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800055:	00 
  800056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80005a:	89 34 24             	mov    %esi,(%esp)
  80005d:	e8 a7 0e 00 00       	call   800f09 <sys_page_alloc>
  800062:	85 c0                	test   %eax,%eax
  800064:	79 20                	jns    800086 <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  800066:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80006a:	c7 44 24 08 20 23 80 	movl   $0x802320,0x8(%esp)
  800071:	00 
  800072:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  800079:	00 
  80007a:	c7 04 24 33 23 80 00 	movl   $0x802333,(%esp)
  800081:	e8 79 02 00 00       	call   8002ff <_panic>

	// 								    srcenvid  srcva  dstenvid  dstva
	if ((r = sys_page_map(dstenv,   addr,      0,    UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800086:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80008d:	00 
  80008e:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800095:	00 
  800096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 b3 0e 00 00       	call   800f5d <sys_page_map>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 43 23 80 	movl   $0x802343,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 33 23 80 00 	movl   $0x802333,(%esp)
  8000c9:	e8 31 02 00 00       	call   8002ff <_panic>

	memmove(UTEMP, addr, PGSIZE);
  8000ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000d5:	00 
  8000d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000da:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000e1:	e8 70 0b 00 00       	call   800c56 <memmove>

	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000e6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000ed:	00 
  8000ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f5:	e8 b6 0e 00 00       	call   800fb0 <sys_page_unmap>
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 54 23 80 	movl   $0x802354,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 33 23 80 00 	movl   $0x802333,(%esp)
  800119:	e8 e1 01 00 00       	call   8002ff <_panic>

}
  80011e:	83 c4 20             	add    $0x20,%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <dumbfork>:

envid_t
dumbfork(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 20             	sub    $0x20,%esp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80012d:	b8 07 00 00 00       	mov    $0x7,%eax
  800132:	cd 30                	int    $0x30
  800134:	89 c6                	mov    %eax,%esi
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	
	if (envid < 0)
  800136:	85 c0                	test   %eax,%eax
  800138:	79 20                	jns    80015a <dumbfork+0x35>
		panic("sys_exofork: %e", envid);
  80013a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013e:	c7 44 24 08 67 23 80 	movl   $0x802367,0x8(%esp)
  800145:	00 
  800146:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  80014d:	00 
  80014e:	c7 04 24 33 23 80 00 	movl   $0x802333,(%esp)
  800155:	e8 a5 01 00 00       	call   8002ff <_panic>
  80015a:	89 c3                	mov    %eax,%ebx

	if (envid == 0) {
  80015c:	85 c0                	test   %eax,%eax
  80015e:	75 21                	jne    800181 <dumbfork+0x5c>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800160:	e8 66 0d 00 00       	call   800ecb <sys_getenvid>
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800172:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	e9 82 00 00 00       	jmp    800203 <dumbfork+0xde>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE) {
  800181:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800188:	b8 00 60 80 00       	mov    $0x806000,%eax
  80018d:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800192:	76 25                	jbe    8001b9 <dumbfork+0x94>
  800194:	ba 00 00 80 00       	mov    $0x800000,%edx
		duppage(envid, addr);
  800199:	89 54 24 04          	mov    %edx,0x4(%esp)
  80019d:	89 1c 24             	mov    %ebx,(%esp)
  8001a0:	e8 9b fe ff ff       	call   800040 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE) {
  8001a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001a8:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8001ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8001b1:	81 fa 00 60 80 00    	cmp    $0x806000,%edx
  8001b7:	72 e0                	jb     800199 <dumbfork+0x74>
		duppage(envid, addr);
	}

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c5:	89 34 24             	mov    %esi,(%esp)
  8001c8:	e8 73 fe ff ff       	call   800040 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001cd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001d4:	00 
  8001d5:	89 34 24             	mov    %esi,(%esp)
  8001d8:	e8 26 0e 00 00       	call   801003 <sys_env_set_status>
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	79 20                	jns    800201 <dumbfork+0xdc>
		panic("sys_env_set_status: %e", r);
  8001e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e5:	c7 44 24 08 77 23 80 	movl   $0x802377,0x8(%esp)
  8001ec:	00 
  8001ed:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8001f4:	00 
  8001f5:	c7 04 24 33 23 80 00 	movl   $0x802333,(%esp)
  8001fc:	e8 fe 00 00 00       	call   8002ff <_panic>

	return envid;
  800201:	89 f0                	mov    %esi,%eax
}
  800203:	83 c4 20             	add    $0x20,%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    

0080020a <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	56                   	push   %esi
  80020e:	53                   	push   %ebx
  80020f:	83 ec 10             	sub    $0x10,%esp
	envid_t who;
	int i;

	// fork a child process
	cprintf("in parent process and tring to fork:\n");
  800212:	c7 04 24 b0 23 80 00 	movl   $0x8023b0,(%esp)
  800219:	e8 da 01 00 00       	call   8003f8 <cprintf>
	who = dumbfork();
  80021e:	e8 02 ff ff ff       	call   800125 <dumbfork>
  800223:	89 c6                	mov    %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	eb 28                	jmp    800254 <umain+0x4a>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80022c:	b8 95 23 80 00       	mov    $0x802395,%eax
  800231:	eb 05                	jmp    800238 <umain+0x2e>
  800233:	b8 8e 23 80 00       	mov    $0x80238e,%eax
  800238:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800240:	c7 04 24 9b 23 80 00 	movl   $0x80239b,(%esp)
  800247:	e8 ac 01 00 00       	call   8003f8 <cprintf>
		sys_yield();
  80024c:	e8 99 0c 00 00       	call   800eea <sys_yield>
	// fork a child process
	cprintf("in parent process and tring to fork:\n");
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800251:	83 c3 01             	add    $0x1,%ebx
  800254:	85 f6                	test   %esi,%esi
  800256:	75 0a                	jne    800262 <umain+0x58>
  800258:	83 fb 13             	cmp    $0x13,%ebx
  80025b:	7e cf                	jle    80022c <umain+0x22>
  80025d:	8d 76 00             	lea    0x0(%esi),%esi
  800260:	eb 05                	jmp    800267 <umain+0x5d>
  800262:	83 fb 09             	cmp    $0x9,%ebx
  800265:	7e cc                	jle    800233 <umain+0x29>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    

0080026e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	83 ec 10             	sub    $0x10,%esp
  800276:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800279:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  80027c:	e8 4a 0c 00 00       	call   800ecb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800281:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800287:	39 c2                	cmp    %eax,%edx
  800289:	74 17                	je     8002a2 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80028b:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800290:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800293:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800299:	8b 49 40             	mov    0x40(%ecx),%ecx
  80029c:	39 c1                	cmp    %eax,%ecx
  80029e:	75 18                	jne    8002b8 <libmain+0x4a>
  8002a0:	eb 05                	jmp    8002a7 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8002a7:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8002aa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8002b0:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8002b6:	eb 0b                	jmp    8002c3 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8002b8:	83 c2 01             	add    $0x1,%edx
  8002bb:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8002c1:	75 cd                	jne    800290 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c3:	85 db                	test   %ebx,%ebx
  8002c5:	7e 07                	jle    8002ce <libmain+0x60>
		binaryname = argv[0];
  8002c7:	8b 06                	mov    (%esi),%eax
  8002c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002d2:	89 1c 24             	mov    %ebx,(%esp)
  8002d5:	e8 30 ff ff ff       	call   80020a <umain>

	// exit gracefully
	exit();
  8002da:	e8 07 00 00 00       	call   8002e6 <exit>
}
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	5b                   	pop    %ebx
  8002e3:	5e                   	pop    %esi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002ec:	e8 a5 10 00 00       	call   801396 <close_all>
	sys_env_destroy(0);
  8002f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002f8:	e8 7c 0b 00 00       	call   800e79 <sys_env_destroy>
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800307:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800310:	e8 b6 0b 00 00       	call   800ecb <sys_getenvid>
  800315:	8b 55 0c             	mov    0xc(%ebp),%edx
  800318:	89 54 24 10          	mov    %edx,0x10(%esp)
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800323:	89 74 24 08          	mov    %esi,0x8(%esp)
  800327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032b:	c7 04 24 e0 23 80 00 	movl   $0x8023e0,(%esp)
  800332:	e8 c1 00 00 00       	call   8003f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800337:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	e8 51 00 00 00       	call   800397 <vcprintf>
	cprintf("\n");
  800346:	c7 04 24 ab 23 80 00 	movl   $0x8023ab,(%esp)
  80034d:	e8 a6 00 00 00       	call   8003f8 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800352:	cc                   	int3   
  800353:	eb fd                	jmp    800352 <_panic+0x53>

00800355 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	53                   	push   %ebx
  800359:	83 ec 14             	sub    $0x14,%esp
  80035c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035f:	8b 13                	mov    (%ebx),%edx
  800361:	8d 42 01             	lea    0x1(%edx),%eax
  800364:	89 03                	mov    %eax,(%ebx)
  800366:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800369:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80036d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800372:	75 19                	jne    80038d <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800374:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80037b:	00 
  80037c:	8d 43 08             	lea    0x8(%ebx),%eax
  80037f:	89 04 24             	mov    %eax,(%esp)
  800382:	e8 b5 0a 00 00       	call   800e3c <sys_cputs>
		b->idx = 0;
  800387:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80038d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800391:	83 c4 14             	add    $0x14,%esp
  800394:	5b                   	pop    %ebx
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    

00800397 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a7:	00 00 00 
	b.cnt = 0;
  8003aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cc:	c7 04 24 55 03 80 00 	movl   $0x800355,(%esp)
  8003d3:	e8 bc 01 00 00       	call   800594 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003d8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003e8:	89 04 24             	mov    %eax,(%esp)
  8003eb:	e8 4c 0a 00 00       	call   800e3c <sys_cputs>

	return b.cnt;
}
  8003f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800401:	89 44 24 04          	mov    %eax,0x4(%esp)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	89 04 24             	mov    %eax,(%esp)
  80040b:	e8 87 ff ff ff       	call   800397 <vcprintf>
	va_end(ap);

	return cnt;
}
  800410:	c9                   	leave  
  800411:	c3                   	ret    
  800412:	66 90                	xchg   %ax,%ax
  800414:	66 90                	xchg   %ax,%ax
  800416:	66 90                	xchg   %ax,%ax
  800418:	66 90                	xchg   %ax,%ax
  80041a:	66 90                	xchg   %ax,%ax
  80041c:	66 90                	xchg   %ax,%ax
  80041e:	66 90                	xchg   %ax,%ax

00800420 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	57                   	push   %edi
  800424:	56                   	push   %esi
  800425:	53                   	push   %ebx
  800426:	83 ec 3c             	sub    $0x3c,%esp
  800429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042c:	89 d7                	mov    %edx,%edi
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800434:	8b 75 0c             	mov    0xc(%ebp),%esi
  800437:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80043a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800442:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800445:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800448:	39 f1                	cmp    %esi,%ecx
  80044a:	72 14                	jb     800460 <printnum+0x40>
  80044c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80044f:	76 0f                	jbe    800460 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 70 ff             	lea    -0x1(%eax),%esi
  800457:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80045a:	85 f6                	test   %esi,%esi
  80045c:	7f 60                	jg     8004be <printnum+0x9e>
  80045e:	eb 72                	jmp    8004d2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800460:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800463:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800467:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80046a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80046d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800471:	89 44 24 08          	mov    %eax,0x8(%esp)
  800475:	8b 44 24 08          	mov    0x8(%esp),%eax
  800479:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80047d:	89 c3                	mov    %eax,%ebx
  80047f:	89 d6                	mov    %edx,%esi
  800481:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800484:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800487:	89 54 24 08          	mov    %edx,0x8(%esp)
  80048b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80048f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800492:	89 04 24             	mov    %eax,(%esp)
  800495:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800498:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049c:	e8 df 1b 00 00       	call   802080 <__udivdi3>
  8004a1:	89 d9                	mov    %ebx,%ecx
  8004a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004a7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004ab:	89 04 24             	mov    %eax,(%esp)
  8004ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004b2:	89 fa                	mov    %edi,%edx
  8004b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b7:	e8 64 ff ff ff       	call   800420 <printnum>
  8004bc:	eb 14                	jmp    8004d2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c5:	89 04 24             	mov    %eax,(%esp)
  8004c8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ca:	83 ee 01             	sub    $0x1,%esi
  8004cd:	75 ef                	jne    8004be <printnum+0x9e>
  8004cf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004eb:	89 04 24             	mov    %eax,(%esp)
  8004ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f5:	e8 b6 1c 00 00       	call   8021b0 <__umoddi3>
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	0f be 80 03 24 80 00 	movsbl 0x802403(%eax),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80050b:	ff d0                	call   *%eax
}
  80050d:	83 c4 3c             	add    $0x3c,%esp
  800510:	5b                   	pop    %ebx
  800511:	5e                   	pop    %esi
  800512:	5f                   	pop    %edi
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    

00800515 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800518:	83 fa 01             	cmp    $0x1,%edx
  80051b:	7e 0e                	jle    80052b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80051d:	8b 10                	mov    (%eax),%edx
  80051f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800522:	89 08                	mov    %ecx,(%eax)
  800524:	8b 02                	mov    (%edx),%eax
  800526:	8b 52 04             	mov    0x4(%edx),%edx
  800529:	eb 22                	jmp    80054d <getuint+0x38>
	else if (lflag)
  80052b:	85 d2                	test   %edx,%edx
  80052d:	74 10                	je     80053f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8d 4a 04             	lea    0x4(%edx),%ecx
  800534:	89 08                	mov    %ecx,(%eax)
  800536:	8b 02                	mov    (%edx),%eax
  800538:	ba 00 00 00 00       	mov    $0x0,%edx
  80053d:	eb 0e                	jmp    80054d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80053f:	8b 10                	mov    (%eax),%edx
  800541:	8d 4a 04             	lea    0x4(%edx),%ecx
  800544:	89 08                	mov    %ecx,(%eax)
  800546:	8b 02                	mov    (%edx),%eax
  800548:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80054d:	5d                   	pop    %ebp
  80054e:	c3                   	ret    

0080054f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800555:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	3b 50 04             	cmp    0x4(%eax),%edx
  80055e:	73 0a                	jae    80056a <sprintputch+0x1b>
		*b->buf++ = ch;
  800560:	8d 4a 01             	lea    0x1(%edx),%ecx
  800563:	89 08                	mov    %ecx,(%eax)
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	88 02                	mov    %al,(%edx)
}
  80056a:	5d                   	pop    %ebp
  80056b:	c3                   	ret    

0080056c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800572:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800575:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800579:	8b 45 10             	mov    0x10(%ebp),%eax
  80057c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800580:	8b 45 0c             	mov    0xc(%ebp),%eax
  800583:	89 44 24 04          	mov    %eax,0x4(%esp)
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	89 04 24             	mov    %eax,(%esp)
  80058d:	e8 02 00 00 00       	call   800594 <vprintfmt>
	va_end(ap);
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 3c             	sub    $0x3c,%esp
  80059d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005a3:	eb 18                	jmp    8005bd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005a5:	85 c0                	test   %eax,%eax
  8005a7:	0f 84 c3 03 00 00    	je     800970 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8005ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b1:	89 04 24             	mov    %eax,(%esp)
  8005b4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b7:	89 f3                	mov    %esi,%ebx
  8005b9:	eb 02                	jmp    8005bd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8005bb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005bd:	8d 73 01             	lea    0x1(%ebx),%esi
  8005c0:	0f b6 03             	movzbl (%ebx),%eax
  8005c3:	83 f8 25             	cmp    $0x25,%eax
  8005c6:	75 dd                	jne    8005a5 <vprintfmt+0x11>
  8005c8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8005cc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8005d3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8005da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e6:	eb 1d                	jmp    800605 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ea:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8005ee:	eb 15                	jmp    800605 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005f2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8005f6:	eb 0d                	jmp    800605 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005fe:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8d 5e 01             	lea    0x1(%esi),%ebx
  800608:	0f b6 06             	movzbl (%esi),%eax
  80060b:	0f b6 c8             	movzbl %al,%ecx
  80060e:	83 e8 23             	sub    $0x23,%eax
  800611:	3c 55                	cmp    $0x55,%al
  800613:	0f 87 2f 03 00 00    	ja     800948 <vprintfmt+0x3b4>
  800619:	0f b6 c0             	movzbl %al,%eax
  80061c:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800623:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800626:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800629:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80062d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800630:	83 f9 09             	cmp    $0x9,%ecx
  800633:	77 50                	ja     800685 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800635:	89 de                	mov    %ebx,%esi
  800637:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80063a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80063d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800640:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800644:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800647:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80064a:	83 fb 09             	cmp    $0x9,%ebx
  80064d:	76 eb                	jbe    80063a <vprintfmt+0xa6>
  80064f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800652:	eb 33                	jmp    800687 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 48 04             	lea    0x4(%eax),%ecx
  80065a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800662:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800664:	eb 21                	jmp    800687 <vprintfmt+0xf3>
  800666:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800669:	85 c9                	test   %ecx,%ecx
  80066b:	b8 00 00 00 00       	mov    $0x0,%eax
  800670:	0f 49 c1             	cmovns %ecx,%eax
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800676:	89 de                	mov    %ebx,%esi
  800678:	eb 8b                	jmp    800605 <vprintfmt+0x71>
  80067a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80067c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800683:	eb 80                	jmp    800605 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800685:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	0f 89 74 ff ff ff    	jns    800605 <vprintfmt+0x71>
  800691:	e9 62 ff ff ff       	jmp    8005f8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800696:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800699:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80069b:	e9 65 ff ff ff       	jmp    800605 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 50 04             	lea    0x4(%eax),%edx
  8006a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 04 24             	mov    %eax,(%esp)
  8006b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006b5:	e9 03 ff ff ff       	jmp    8005bd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 50 04             	lea    0x4(%eax),%edx
  8006c0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	99                   	cltd   
  8006c6:	31 d0                	xor    %edx,%eax
  8006c8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006ca:	83 f8 0f             	cmp    $0xf,%eax
  8006cd:	7f 0b                	jg     8006da <vprintfmt+0x146>
  8006cf:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  8006d6:	85 d2                	test   %edx,%edx
  8006d8:	75 20                	jne    8006fa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8006da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006de:	c7 44 24 08 1b 24 80 	movl   $0x80241b,0x8(%esp)
  8006e5:	00 
  8006e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 04 24             	mov    %eax,(%esp)
  8006f0:	e8 77 fe ff ff       	call   80056c <printfmt>
  8006f5:	e9 c3 fe ff ff       	jmp    8005bd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8006fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006fe:	c7 44 24 08 c2 27 80 	movl   $0x8027c2,0x8(%esp)
  800705:	00 
  800706:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	89 04 24             	mov    %eax,(%esp)
  800710:	e8 57 fe ff ff       	call   80056c <printfmt>
  800715:	e9 a3 fe ff ff       	jmp    8005bd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80071d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 50 04             	lea    0x4(%eax),%edx
  800726:	89 55 14             	mov    %edx,0x14(%ebp)
  800729:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80072b:	85 c0                	test   %eax,%eax
  80072d:	ba 14 24 80 00       	mov    $0x802414,%edx
  800732:	0f 45 d0             	cmovne %eax,%edx
  800735:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800738:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80073c:	74 04                	je     800742 <vprintfmt+0x1ae>
  80073e:	85 f6                	test   %esi,%esi
  800740:	7f 19                	jg     80075b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800742:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800745:	8d 70 01             	lea    0x1(%eax),%esi
  800748:	0f b6 10             	movzbl (%eax),%edx
  80074b:	0f be c2             	movsbl %dl,%eax
  80074e:	85 c0                	test   %eax,%eax
  800750:	0f 85 95 00 00 00    	jne    8007eb <vprintfmt+0x257>
  800756:	e9 85 00 00 00       	jmp    8007e0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80075b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	89 04 24             	mov    %eax,(%esp)
  800765:	e8 b8 02 00 00       	call   800a22 <strnlen>
  80076a:	29 c6                	sub    %eax,%esi
  80076c:	89 f0                	mov    %esi,%eax
  80076e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800771:	85 f6                	test   %esi,%esi
  800773:	7e cd                	jle    800742 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800775:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800779:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80077c:	89 c3                	mov    %eax,%ebx
  80077e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800782:	89 34 24             	mov    %esi,(%esp)
  800785:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800788:	83 eb 01             	sub    $0x1,%ebx
  80078b:	75 f1                	jne    80077e <vprintfmt+0x1ea>
  80078d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800790:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800793:	eb ad                	jmp    800742 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800795:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800799:	74 1e                	je     8007b9 <vprintfmt+0x225>
  80079b:	0f be d2             	movsbl %dl,%edx
  80079e:	83 ea 20             	sub    $0x20,%edx
  8007a1:	83 fa 5e             	cmp    $0x5e,%edx
  8007a4:	76 13                	jbe    8007b9 <vprintfmt+0x225>
					putch('?', putdat);
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ad:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007b4:	ff 55 08             	call   *0x8(%ebp)
  8007b7:	eb 0d                	jmp    8007c6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8007b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007bc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c0:	89 04 24             	mov    %eax,(%esp)
  8007c3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c6:	83 ef 01             	sub    $0x1,%edi
  8007c9:	83 c6 01             	add    $0x1,%esi
  8007cc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8007d0:	0f be c2             	movsbl %dl,%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	75 20                	jne    8007f7 <vprintfmt+0x263>
  8007d7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8007da:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	7f 25                	jg     80080b <vprintfmt+0x277>
  8007e6:	e9 d2 fd ff ff       	jmp    8005bd <vprintfmt+0x29>
  8007eb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007f1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f7:	85 db                	test   %ebx,%ebx
  8007f9:	78 9a                	js     800795 <vprintfmt+0x201>
  8007fb:	83 eb 01             	sub    $0x1,%ebx
  8007fe:	79 95                	jns    800795 <vprintfmt+0x201>
  800800:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800803:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800806:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800809:	eb d5                	jmp    8007e0 <vprintfmt+0x24c>
  80080b:	8b 75 08             	mov    0x8(%ebp),%esi
  80080e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800811:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800814:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800818:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80081f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800821:	83 eb 01             	sub    $0x1,%ebx
  800824:	75 ee                	jne    800814 <vprintfmt+0x280>
  800826:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800829:	e9 8f fd ff ff       	jmp    8005bd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80082e:	83 fa 01             	cmp    $0x1,%edx
  800831:	7e 16                	jle    800849 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8d 50 08             	lea    0x8(%eax),%edx
  800839:	89 55 14             	mov    %edx,0x14(%ebp)
  80083c:	8b 50 04             	mov    0x4(%eax),%edx
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800847:	eb 32                	jmp    80087b <vprintfmt+0x2e7>
	else if (lflag)
  800849:	85 d2                	test   %edx,%edx
  80084b:	74 18                	je     800865 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 50 04             	lea    0x4(%eax),%edx
  800853:	89 55 14             	mov    %edx,0x14(%ebp)
  800856:	8b 30                	mov    (%eax),%esi
  800858:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80085b:	89 f0                	mov    %esi,%eax
  80085d:	c1 f8 1f             	sar    $0x1f,%eax
  800860:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800863:	eb 16                	jmp    80087b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 04             	lea    0x4(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)
  80086e:	8b 30                	mov    (%eax),%esi
  800870:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800873:	89 f0                	mov    %esi,%eax
  800875:	c1 f8 1f             	sar    $0x1f,%eax
  800878:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800881:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800886:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80088a:	0f 89 80 00 00 00    	jns    800910 <vprintfmt+0x37c>
				putch('-', putdat);
  800890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800894:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80089b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008a4:	f7 d8                	neg    %eax
  8008a6:	83 d2 00             	adc    $0x0,%edx
  8008a9:	f7 da                	neg    %edx
			}
			base = 10;
  8008ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008b0:	eb 5e                	jmp    800910 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b5:	e8 5b fc ff ff       	call   800515 <getuint>
			base = 10;
  8008ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008bf:	eb 4f                	jmp    800910 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8008c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c4:	e8 4c fc ff ff       	call   800515 <getuint>
			base = 8;
  8008c9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008ce:	eb 40                	jmp    800910 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8008d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008db:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008e9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8d 50 04             	lea    0x4(%eax),%edx
  8008f2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008fc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800901:	eb 0d                	jmp    800910 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800903:	8d 45 14             	lea    0x14(%ebp),%eax
  800906:	e8 0a fc ff ff       	call   800515 <getuint>
			base = 16;
  80090b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800910:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800914:	89 74 24 10          	mov    %esi,0x10(%esp)
  800918:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80091b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80091f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800923:	89 04 24             	mov    %eax,(%esp)
  800926:	89 54 24 04          	mov    %edx,0x4(%esp)
  80092a:	89 fa                	mov    %edi,%edx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	e8 ec fa ff ff       	call   800420 <printnum>
			break;
  800934:	e9 84 fc ff ff       	jmp    8005bd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800939:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80093d:	89 0c 24             	mov    %ecx,(%esp)
  800940:	ff 55 08             	call   *0x8(%ebp)
			break;
  800943:	e9 75 fc ff ff       	jmp    8005bd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800948:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800953:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800956:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80095a:	0f 84 5b fc ff ff    	je     8005bb <vprintfmt+0x27>
  800960:	89 f3                	mov    %esi,%ebx
  800962:	83 eb 01             	sub    $0x1,%ebx
  800965:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800969:	75 f7                	jne    800962 <vprintfmt+0x3ce>
  80096b:	e9 4d fc ff ff       	jmp    8005bd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800970:	83 c4 3c             	add    $0x3c,%esp
  800973:	5b                   	pop    %ebx
  800974:	5e                   	pop    %esi
  800975:	5f                   	pop    %edi
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 28             	sub    $0x28,%esp
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80098b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800995:	85 c0                	test   %eax,%eax
  800997:	74 30                	je     8009c9 <vsnprintf+0x51>
  800999:	85 d2                	test   %edx,%edx
  80099b:	7e 2c                	jle    8009c9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b2:	c7 04 24 4f 05 80 00 	movl   $0x80054f,(%esp)
  8009b9:	e8 d6 fb ff ff       	call   800594 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c7:	eb 05                	jmp    8009ce <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	89 04 24             	mov    %eax,(%esp)
  8009f1:	e8 82 ff ff ff       	call   800978 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f6:	c9                   	leave  
  8009f7:	c3                   	ret    
  8009f8:	66 90                	xchg   %ax,%ax
  8009fa:	66 90                	xchg   %ax,%ax
  8009fc:	66 90                	xchg   %ax,%ax
  8009fe:	66 90                	xchg   %ax,%ax

00800a00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a06:	80 3a 00             	cmpb   $0x0,(%edx)
  800a09:	74 10                	je     800a1b <strlen+0x1b>
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800a10:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a17:	75 f7                	jne    800a10 <strlen+0x10>
  800a19:	eb 05                	jmp    800a20 <strlen+0x20>
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2c:	85 c9                	test   %ecx,%ecx
  800a2e:	74 1c                	je     800a4c <strnlen+0x2a>
  800a30:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a33:	74 1e                	je     800a53 <strnlen+0x31>
  800a35:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800a3a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3c:	39 ca                	cmp    %ecx,%edx
  800a3e:	74 18                	je     800a58 <strnlen+0x36>
  800a40:	83 c2 01             	add    $0x1,%edx
  800a43:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800a48:	75 f0                	jne    800a3a <strnlen+0x18>
  800a4a:	eb 0c                	jmp    800a58 <strnlen+0x36>
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	eb 05                	jmp    800a58 <strnlen+0x36>
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a58:	5b                   	pop    %ebx
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a65:	89 c2                	mov    %eax,%edx
  800a67:	83 c2 01             	add    $0x1,%edx
  800a6a:	83 c1 01             	add    $0x1,%ecx
  800a6d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a71:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a74:	84 db                	test   %bl,%bl
  800a76:	75 ef                	jne    800a67 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a78:	5b                   	pop    %ebx
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	53                   	push   %ebx
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a85:	89 1c 24             	mov    %ebx,(%esp)
  800a88:	e8 73 ff ff ff       	call   800a00 <strlen>
	strcpy(dst + len, src);
  800a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a90:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a94:	01 d8                	add    %ebx,%eax
  800a96:	89 04 24             	mov    %eax,(%esp)
  800a99:	e8 bd ff ff ff       	call   800a5b <strcpy>
	return dst;
}
  800a9e:	89 d8                	mov    %ebx,%eax
  800aa0:	83 c4 08             	add    $0x8,%esp
  800aa3:	5b                   	pop    %ebx
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 75 08             	mov    0x8(%ebp),%esi
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab4:	85 db                	test   %ebx,%ebx
  800ab6:	74 17                	je     800acf <strncpy+0x29>
  800ab8:	01 f3                	add    %esi,%ebx
  800aba:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800abc:	83 c1 01             	add    $0x1,%ecx
  800abf:	0f b6 02             	movzbl (%edx),%eax
  800ac2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac5:	80 3a 01             	cmpb   $0x1,(%edx)
  800ac8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800acb:	39 d9                	cmp    %ebx,%ecx
  800acd:	75 ed                	jne    800abc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800acf:	89 f0                	mov    %esi,%eax
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	57                   	push   %edi
  800ad9:	56                   	push   %esi
  800ada:	53                   	push   %ebx
  800adb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ade:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ae1:	8b 75 10             	mov    0x10(%ebp),%esi
  800ae4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	74 34                	je     800b1e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800aea:	83 fe 01             	cmp    $0x1,%esi
  800aed:	74 26                	je     800b15 <strlcpy+0x40>
  800aef:	0f b6 0b             	movzbl (%ebx),%ecx
  800af2:	84 c9                	test   %cl,%cl
  800af4:	74 23                	je     800b19 <strlcpy+0x44>
  800af6:	83 ee 02             	sub    $0x2,%esi
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800afe:	83 c0 01             	add    $0x1,%eax
  800b01:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b04:	39 f2                	cmp    %esi,%edx
  800b06:	74 13                	je     800b1b <strlcpy+0x46>
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b0f:	84 c9                	test   %cl,%cl
  800b11:	75 eb                	jne    800afe <strlcpy+0x29>
  800b13:	eb 06                	jmp    800b1b <strlcpy+0x46>
  800b15:	89 f8                	mov    %edi,%eax
  800b17:	eb 02                	jmp    800b1b <strlcpy+0x46>
  800b19:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b1b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b1e:	29 f8                	sub    %edi,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5f                   	pop    %edi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b2e:	0f b6 01             	movzbl (%ecx),%eax
  800b31:	84 c0                	test   %al,%al
  800b33:	74 15                	je     800b4a <strcmp+0x25>
  800b35:	3a 02                	cmp    (%edx),%al
  800b37:	75 11                	jne    800b4a <strcmp+0x25>
		p++, q++;
  800b39:	83 c1 01             	add    $0x1,%ecx
  800b3c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b3f:	0f b6 01             	movzbl (%ecx),%eax
  800b42:	84 c0                	test   %al,%al
  800b44:	74 04                	je     800b4a <strcmp+0x25>
  800b46:	3a 02                	cmp    (%edx),%al
  800b48:	74 ef                	je     800b39 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4a:	0f b6 c0             	movzbl %al,%eax
  800b4d:	0f b6 12             	movzbl (%edx),%edx
  800b50:	29 d0                	sub    %edx,%eax
}
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800b62:	85 f6                	test   %esi,%esi
  800b64:	74 29                	je     800b8f <strncmp+0x3b>
  800b66:	0f b6 03             	movzbl (%ebx),%eax
  800b69:	84 c0                	test   %al,%al
  800b6b:	74 30                	je     800b9d <strncmp+0x49>
  800b6d:	3a 02                	cmp    (%edx),%al
  800b6f:	75 2c                	jne    800b9d <strncmp+0x49>
  800b71:	8d 43 01             	lea    0x1(%ebx),%eax
  800b74:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800b76:	89 c3                	mov    %eax,%ebx
  800b78:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b7b:	39 f0                	cmp    %esi,%eax
  800b7d:	74 17                	je     800b96 <strncmp+0x42>
  800b7f:	0f b6 08             	movzbl (%eax),%ecx
  800b82:	84 c9                	test   %cl,%cl
  800b84:	74 17                	je     800b9d <strncmp+0x49>
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	3a 0a                	cmp    (%edx),%cl
  800b8b:	74 e9                	je     800b76 <strncmp+0x22>
  800b8d:	eb 0e                	jmp    800b9d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	eb 0f                	jmp    800ba5 <strncmp+0x51>
  800b96:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9b:	eb 08                	jmp    800ba5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9d:	0f b6 03             	movzbl (%ebx),%eax
  800ba0:	0f b6 12             	movzbl (%edx),%edx
  800ba3:	29 d0                	sub    %edx,%eax
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800bb3:	0f b6 18             	movzbl (%eax),%ebx
  800bb6:	84 db                	test   %bl,%bl
  800bb8:	74 1d                	je     800bd7 <strchr+0x2e>
  800bba:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800bbc:	38 d3                	cmp    %dl,%bl
  800bbe:	75 06                	jne    800bc6 <strchr+0x1d>
  800bc0:	eb 1a                	jmp    800bdc <strchr+0x33>
  800bc2:	38 ca                	cmp    %cl,%dl
  800bc4:	74 16                	je     800bdc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bc6:	83 c0 01             	add    $0x1,%eax
  800bc9:	0f b6 10             	movzbl (%eax),%edx
  800bcc:	84 d2                	test   %dl,%dl
  800bce:	75 f2                	jne    800bc2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd5:	eb 05                	jmp    800bdc <strchr+0x33>
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdc:	5b                   	pop    %ebx
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	53                   	push   %ebx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800be9:	0f b6 18             	movzbl (%eax),%ebx
  800bec:	84 db                	test   %bl,%bl
  800bee:	74 16                	je     800c06 <strfind+0x27>
  800bf0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800bf2:	38 d3                	cmp    %dl,%bl
  800bf4:	75 06                	jne    800bfc <strfind+0x1d>
  800bf6:	eb 0e                	jmp    800c06 <strfind+0x27>
  800bf8:	38 ca                	cmp    %cl,%dl
  800bfa:	74 0a                	je     800c06 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	0f b6 10             	movzbl (%eax),%edx
  800c02:	84 d2                	test   %dl,%dl
  800c04:	75 f2                	jne    800bf8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800c06:	5b                   	pop    %ebx
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c12:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c15:	85 c9                	test   %ecx,%ecx
  800c17:	74 36                	je     800c4f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1f:	75 28                	jne    800c49 <memset+0x40>
  800c21:	f6 c1 03             	test   $0x3,%cl
  800c24:	75 23                	jne    800c49 <memset+0x40>
		c &= 0xFF;
  800c26:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c2a:	89 d3                	mov    %edx,%ebx
  800c2c:	c1 e3 08             	shl    $0x8,%ebx
  800c2f:	89 d6                	mov    %edx,%esi
  800c31:	c1 e6 18             	shl    $0x18,%esi
  800c34:	89 d0                	mov    %edx,%eax
  800c36:	c1 e0 10             	shl    $0x10,%eax
  800c39:	09 f0                	or     %esi,%eax
  800c3b:	09 c2                	or     %eax,%edx
  800c3d:	89 d0                	mov    %edx,%eax
  800c3f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c41:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c44:	fc                   	cld    
  800c45:	f3 ab                	rep stos %eax,%es:(%edi)
  800c47:	eb 06                	jmp    800c4f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	fc                   	cld    
  800c4d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4f:	89 f8                	mov    %edi,%eax
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c64:	39 c6                	cmp    %eax,%esi
  800c66:	73 35                	jae    800c9d <memmove+0x47>
  800c68:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c6b:	39 d0                	cmp    %edx,%eax
  800c6d:	73 2e                	jae    800c9d <memmove+0x47>
		s += n;
		d += n;
  800c6f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c72:	89 d6                	mov    %edx,%esi
  800c74:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7c:	75 13                	jne    800c91 <memmove+0x3b>
  800c7e:	f6 c1 03             	test   $0x3,%cl
  800c81:	75 0e                	jne    800c91 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c83:	83 ef 04             	sub    $0x4,%edi
  800c86:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c89:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c8c:	fd                   	std    
  800c8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8f:	eb 09                	jmp    800c9a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c91:	83 ef 01             	sub    $0x1,%edi
  800c94:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c97:	fd                   	std    
  800c98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c9a:	fc                   	cld    
  800c9b:	eb 1d                	jmp    800cba <memmove+0x64>
  800c9d:	89 f2                	mov    %esi,%edx
  800c9f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca1:	f6 c2 03             	test   $0x3,%dl
  800ca4:	75 0f                	jne    800cb5 <memmove+0x5f>
  800ca6:	f6 c1 03             	test   $0x3,%cl
  800ca9:	75 0a                	jne    800cb5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cab:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cae:	89 c7                	mov    %eax,%edi
  800cb0:	fc                   	cld    
  800cb1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb3:	eb 05                	jmp    800cba <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cb5:	89 c7                	mov    %eax,%edi
  800cb7:	fc                   	cld    
  800cb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 04 24             	mov    %eax,(%esp)
  800cd8:	e8 79 ff ff ff       	call   800c56 <memmove>
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
  800ce5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ce8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ceb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cee:	8d 78 ff             	lea    -0x1(%eax),%edi
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	74 36                	je     800d2b <memcmp+0x4c>
		if (*s1 != *s2)
  800cf5:	0f b6 03             	movzbl (%ebx),%eax
  800cf8:	0f b6 0e             	movzbl (%esi),%ecx
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	38 c8                	cmp    %cl,%al
  800d02:	74 1c                	je     800d20 <memcmp+0x41>
  800d04:	eb 10                	jmp    800d16 <memcmp+0x37>
  800d06:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d0b:	83 c2 01             	add    $0x1,%edx
  800d0e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800d12:	38 c8                	cmp    %cl,%al
  800d14:	74 0a                	je     800d20 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800d16:	0f b6 c0             	movzbl %al,%eax
  800d19:	0f b6 c9             	movzbl %cl,%ecx
  800d1c:	29 c8                	sub    %ecx,%eax
  800d1e:	eb 10                	jmp    800d30 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d20:	39 fa                	cmp    %edi,%edx
  800d22:	75 e2                	jne    800d06 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d24:	b8 00 00 00 00       	mov    $0x0,%eax
  800d29:	eb 05                	jmp    800d30 <memcmp+0x51>
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	53                   	push   %ebx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800d3f:	89 c2                	mov    %eax,%edx
  800d41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d44:	39 d0                	cmp    %edx,%eax
  800d46:	73 13                	jae    800d5b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d48:	89 d9                	mov    %ebx,%ecx
  800d4a:	38 18                	cmp    %bl,(%eax)
  800d4c:	75 06                	jne    800d54 <memfind+0x1f>
  800d4e:	eb 0b                	jmp    800d5b <memfind+0x26>
  800d50:	38 08                	cmp    %cl,(%eax)
  800d52:	74 07                	je     800d5b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d54:	83 c0 01             	add    $0x1,%eax
  800d57:	39 d0                	cmp    %edx,%eax
  800d59:	75 f5                	jne    800d50 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d5b:	5b                   	pop    %ebx
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6a:	0f b6 0a             	movzbl (%edx),%ecx
  800d6d:	80 f9 09             	cmp    $0x9,%cl
  800d70:	74 05                	je     800d77 <strtol+0x19>
  800d72:	80 f9 20             	cmp    $0x20,%cl
  800d75:	75 10                	jne    800d87 <strtol+0x29>
		s++;
  800d77:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7a:	0f b6 0a             	movzbl (%edx),%ecx
  800d7d:	80 f9 09             	cmp    $0x9,%cl
  800d80:	74 f5                	je     800d77 <strtol+0x19>
  800d82:	80 f9 20             	cmp    $0x20,%cl
  800d85:	74 f0                	je     800d77 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d87:	80 f9 2b             	cmp    $0x2b,%cl
  800d8a:	75 0a                	jne    800d96 <strtol+0x38>
		s++;
  800d8c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d94:	eb 11                	jmp    800da7 <strtol+0x49>
  800d96:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d9b:	80 f9 2d             	cmp    $0x2d,%cl
  800d9e:	75 07                	jne    800da7 <strtol+0x49>
		s++, neg = 1;
  800da0:	83 c2 01             	add    $0x1,%edx
  800da3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800dac:	75 15                	jne    800dc3 <strtol+0x65>
  800dae:	80 3a 30             	cmpb   $0x30,(%edx)
  800db1:	75 10                	jne    800dc3 <strtol+0x65>
  800db3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db7:	75 0a                	jne    800dc3 <strtol+0x65>
		s += 2, base = 16;
  800db9:	83 c2 02             	add    $0x2,%edx
  800dbc:	b8 10 00 00 00       	mov    $0x10,%eax
  800dc1:	eb 10                	jmp    800dd3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	75 0c                	jne    800dd3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dc9:	80 3a 30             	cmpb   $0x30,(%edx)
  800dcc:	75 05                	jne    800dd3 <strtol+0x75>
		s++, base = 8;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ddb:	0f b6 0a             	movzbl (%edx),%ecx
  800dde:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800de1:	89 f0                	mov    %esi,%eax
  800de3:	3c 09                	cmp    $0x9,%al
  800de5:	77 08                	ja     800def <strtol+0x91>
			dig = *s - '0';
  800de7:	0f be c9             	movsbl %cl,%ecx
  800dea:	83 e9 30             	sub    $0x30,%ecx
  800ded:	eb 20                	jmp    800e0f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800def:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800df2:	89 f0                	mov    %esi,%eax
  800df4:	3c 19                	cmp    $0x19,%al
  800df6:	77 08                	ja     800e00 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800df8:	0f be c9             	movsbl %cl,%ecx
  800dfb:	83 e9 57             	sub    $0x57,%ecx
  800dfe:	eb 0f                	jmp    800e0f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800e00:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e03:	89 f0                	mov    %esi,%eax
  800e05:	3c 19                	cmp    $0x19,%al
  800e07:	77 16                	ja     800e1f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e09:	0f be c9             	movsbl %cl,%ecx
  800e0c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e0f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e12:	7d 0f                	jge    800e23 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e14:	83 c2 01             	add    $0x1,%edx
  800e17:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e1b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e1d:	eb bc                	jmp    800ddb <strtol+0x7d>
  800e1f:	89 d8                	mov    %ebx,%eax
  800e21:	eb 02                	jmp    800e25 <strtol+0xc7>
  800e23:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	74 05                	je     800e30 <strtol+0xd2>
		*endptr = (char *) s;
  800e2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e30:	f7 d8                	neg    %eax
  800e32:	85 ff                	test   %edi,%edi
  800e34:	0f 44 c3             	cmove  %ebx,%eax
}
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	89 c3                	mov    %eax,%ebx
  800e4f:	89 c7                	mov    %eax,%edi
  800e51:	89 c6                	mov    %eax,%esi
  800e53:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <sys_cgetc>:

int
sys_cgetc(void)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e60:	ba 00 00 00 00       	mov    $0x0,%edx
  800e65:	b8 01 00 00 00       	mov    $0x1,%eax
  800e6a:	89 d1                	mov    %edx,%ecx
  800e6c:	89 d3                	mov    %edx,%ebx
  800e6e:	89 d7                	mov    %edx,%edi
  800e70:	89 d6                	mov    %edx,%esi
  800e72:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e87:	b8 03 00 00 00       	mov    $0x3,%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 cb                	mov    %ecx,%ebx
  800e91:	89 cf                	mov    %ecx,%edi
  800e93:	89 ce                	mov    %ecx,%esi
  800e95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7e 28                	jle    800ec3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ea6:	00 
  800ea7:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  800eae:	00 
  800eaf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb6:	00 
  800eb7:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  800ebe:	e8 3c f4 ff ff       	call   8002ff <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec3:	83 c4 2c             	add    $0x2c,%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed6:	b8 02 00 00 00       	mov    $0x2,%eax
  800edb:	89 d1                	mov    %edx,%ecx
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	89 d6                	mov    %edx,%esi
  800ee3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_yield>:

void
sys_yield(void)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800efa:	89 d1                	mov    %edx,%ecx
  800efc:	89 d3                	mov    %edx,%ebx
  800efe:	89 d7                	mov    %edx,%edi
  800f00:	89 d6                	mov    %edx,%esi
  800f02:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	be 00 00 00 00       	mov    $0x0,%esi
  800f17:	b8 04 00 00 00       	mov    $0x4,%eax
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f25:	89 f7                	mov    %esi,%edi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  800f50:	e8 aa f3 ff ff       	call   8002ff <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	b8 05 00 00 00       	mov    $0x5,%eax
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f74:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f77:	8b 75 18             	mov    0x18(%ebp),%esi
  800f7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  800fa3:	e8 57 f3 ff ff       	call   8002ff <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7e 28                	jle    800ffb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fde:	00 
  800fdf:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  800ff6:	e8 04 f3 ff ff       	call   8002ff <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ffb:	83 c4 2c             	add    $0x2c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	b8 08 00 00 00       	mov    $0x8,%eax
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7e 28                	jle    80104e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801031:	00 
  801032:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  801039:	00 
  80103a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801041:	00 
  801042:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  801049:	e8 b1 f2 ff ff       	call   8002ff <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80104e:	83 c4 2c             	add    $0x2c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
  80105c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801064:	b8 09 00 00 00       	mov    $0x9,%eax
  801069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	89 df                	mov    %ebx,%edi
  801071:	89 de                	mov    %ebx,%esi
  801073:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801075:	85 c0                	test   %eax,%eax
  801077:	7e 28                	jle    8010a1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801084:	00 
  801085:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  80108c:	00 
  80108d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801094:	00 
  801095:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  80109c:	e8 5e f2 ff ff       	call   8002ff <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010a1:	83 c4 2c             	add    $0x2c,%esp
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	89 df                	mov    %ebx,%edi
  8010c4:	89 de                	mov    %ebx,%esi
  8010c6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	7e 28                	jle    8010f4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010d7:	00 
  8010d8:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  8010df:	00 
  8010e0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010e7:	00 
  8010e8:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  8010ef:	e8 0b f2 ff ff       	call   8002ff <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f4:	83 c4 2c             	add    $0x2c,%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801102:	be 00 00 00 00       	mov    $0x0,%esi
  801107:	b8 0c 00 00 00       	mov    $0xc,%eax
  80110c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
  801112:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801115:	8b 7d 14             	mov    0x14(%ebp),%edi
  801118:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
  801125:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801128:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801132:	8b 55 08             	mov    0x8(%ebp),%edx
  801135:	89 cb                	mov    %ecx,%ebx
  801137:	89 cf                	mov    %ecx,%edi
  801139:	89 ce                	mov    %ecx,%esi
  80113b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	7e 28                	jle    801169 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801141:	89 44 24 10          	mov    %eax,0x10(%esp)
  801145:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80114c:	00 
  80114d:	c7 44 24 08 ff 26 80 	movl   $0x8026ff,0x8(%esp)
  801154:	00 
  801155:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80115c:	00 
  80115d:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  801164:	e8 96 f1 ff ff       	call   8002ff <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801169:	83 c4 2c             	add    $0x2c,%esp
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    
  801171:	66 90                	xchg   %ax,%ax
  801173:	66 90                	xchg   %ax,%ax
  801175:	66 90                	xchg   %ax,%ax
  801177:	66 90                	xchg   %ax,%ax
  801179:	66 90                	xchg   %ax,%ax
  80117b:	66 90                	xchg   %ax,%ax
  80117d:	66 90                	xchg   %ax,%ax
  80117f:	90                   	nop

00801180 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	05 00 00 00 30       	add    $0x30000000,%eax
  80118b:	c1 e8 0c             	shr    $0xc,%eax
}
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80119b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011aa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8011af:	a8 01                	test   $0x1,%al
  8011b1:	74 34                	je     8011e7 <fd_alloc+0x40>
  8011b3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8011b8:	a8 01                	test   $0x1,%al
  8011ba:	74 32                	je     8011ee <fd_alloc+0x47>
  8011bc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8011c1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	c1 ea 16             	shr    $0x16,%edx
  8011c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011cf:	f6 c2 01             	test   $0x1,%dl
  8011d2:	74 1f                	je     8011f3 <fd_alloc+0x4c>
  8011d4:	89 c2                	mov    %eax,%edx
  8011d6:	c1 ea 0c             	shr    $0xc,%edx
  8011d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e0:	f6 c2 01             	test   $0x1,%dl
  8011e3:	75 1a                	jne    8011ff <fd_alloc+0x58>
  8011e5:	eb 0c                	jmp    8011f3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8011e7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8011ec:	eb 05                	jmp    8011f3 <fd_alloc+0x4c>
  8011ee:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fd:	eb 1a                	jmp    801219 <fd_alloc+0x72>
  8011ff:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801204:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801209:	75 b6                	jne    8011c1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801214:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    

0080121b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801221:	83 f8 1f             	cmp    $0x1f,%eax
  801224:	77 36                	ja     80125c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801226:	c1 e0 0c             	shl    $0xc,%eax
  801229:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80122e:	89 c2                	mov    %eax,%edx
  801230:	c1 ea 16             	shr    $0x16,%edx
  801233:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80123a:	f6 c2 01             	test   $0x1,%dl
  80123d:	74 24                	je     801263 <fd_lookup+0x48>
  80123f:	89 c2                	mov    %eax,%edx
  801241:	c1 ea 0c             	shr    $0xc,%edx
  801244:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124b:	f6 c2 01             	test   $0x1,%dl
  80124e:	74 1a                	je     80126a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801250:	8b 55 0c             	mov    0xc(%ebp),%edx
  801253:	89 02                	mov    %eax,(%edx)
	return 0;
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	eb 13                	jmp    80126f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80125c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801261:	eb 0c                	jmp    80126f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801263:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801268:	eb 05                	jmp    80126f <fd_lookup+0x54>
  80126a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    

00801271 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	53                   	push   %ebx
  801275:	83 ec 14             	sub    $0x14,%esp
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80127e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801284:	75 1e                	jne    8012a4 <dev_lookup+0x33>
  801286:	eb 0e                	jmp    801296 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801288:	b8 20 30 80 00       	mov    $0x803020,%eax
  80128d:	eb 0c                	jmp    80129b <dev_lookup+0x2a>
  80128f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801294:	eb 05                	jmp    80129b <dev_lookup+0x2a>
  801296:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80129b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 38                	jmp    8012dc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8012a4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8012aa:	74 dc                	je     801288 <dev_lookup+0x17>
  8012ac:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8012b2:	74 db                	je     80128f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012ba:	8b 52 48             	mov    0x48(%edx),%edx
  8012bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012c5:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8012cc:	e8 27 f1 ff ff       	call   8003f8 <cprintf>
	*dev = 0;
  8012d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8012d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012dc:	83 c4 14             	add    $0x14,%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	56                   	push   %esi
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 20             	sub    $0x20,%esp
  8012ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012fd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801300:	89 04 24             	mov    %eax,(%esp)
  801303:	e8 13 ff ff ff       	call   80121b <fd_lookup>
  801308:	85 c0                	test   %eax,%eax
  80130a:	78 05                	js     801311 <fd_close+0x2f>
	    || fd != fd2)
  80130c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80130f:	74 0c                	je     80131d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801311:	84 db                	test   %bl,%bl
  801313:	ba 00 00 00 00       	mov    $0x0,%edx
  801318:	0f 44 c2             	cmove  %edx,%eax
  80131b:	eb 3f                	jmp    80135c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80131d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801320:	89 44 24 04          	mov    %eax,0x4(%esp)
  801324:	8b 06                	mov    (%esi),%eax
  801326:	89 04 24             	mov    %eax,(%esp)
  801329:	e8 43 ff ff ff       	call   801271 <dev_lookup>
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	85 c0                	test   %eax,%eax
  801332:	78 16                	js     80134a <fd_close+0x68>
		if (dev->dev_close)
  801334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801337:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80133a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80133f:	85 c0                	test   %eax,%eax
  801341:	74 07                	je     80134a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801343:	89 34 24             	mov    %esi,(%esp)
  801346:	ff d0                	call   *%eax
  801348:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80134a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801355:	e8 56 fc ff ff       	call   800fb0 <sys_page_unmap>
	return r;
  80135a:	89 d8                	mov    %ebx,%eax
}
  80135c:	83 c4 20             	add    $0x20,%esp
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 04 24             	mov    %eax,(%esp)
  801376:	e8 a0 fe ff ff       	call   80121b <fd_lookup>
  80137b:	89 c2                	mov    %eax,%edx
  80137d:	85 d2                	test   %edx,%edx
  80137f:	78 13                	js     801394 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801388:	00 
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	89 04 24             	mov    %eax,(%esp)
  80138f:	e8 4e ff ff ff       	call   8012e2 <fd_close>
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <close_all>:

void
close_all(void)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	53                   	push   %ebx
  80139a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80139d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013a2:	89 1c 24             	mov    %ebx,(%esp)
  8013a5:	e8 b9 ff ff ff       	call   801363 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8013aa:	83 c3 01             	add    $0x1,%ebx
  8013ad:	83 fb 20             	cmp    $0x20,%ebx
  8013b0:	75 f0                	jne    8013a2 <close_all+0xc>
		close(i);
}
  8013b2:	83 c4 14             	add    $0x14,%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	57                   	push   %edi
  8013bc:	56                   	push   %esi
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 48 fe ff ff       	call   80121b <fd_lookup>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	85 d2                	test   %edx,%edx
  8013d7:	0f 88 e1 00 00 00    	js     8014be <dup+0x106>
		return r;
	close(newfdnum);
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	89 04 24             	mov    %eax,(%esp)
  8013e3:	e8 7b ff ff ff       	call   801363 <close>

	newfd = INDEX2FD(newfdnum);
  8013e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013eb:	c1 e3 0c             	shl    $0xc,%ebx
  8013ee:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f7:	89 04 24             	mov    %eax,(%esp)
  8013fa:	e8 91 fd ff ff       	call   801190 <fd2data>
  8013ff:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801401:	89 1c 24             	mov    %ebx,(%esp)
  801404:	e8 87 fd ff ff       	call   801190 <fd2data>
  801409:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80140b:	89 f0                	mov    %esi,%eax
  80140d:	c1 e8 16             	shr    $0x16,%eax
  801410:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801417:	a8 01                	test   $0x1,%al
  801419:	74 43                	je     80145e <dup+0xa6>
  80141b:	89 f0                	mov    %esi,%eax
  80141d:	c1 e8 0c             	shr    $0xc,%eax
  801420:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801427:	f6 c2 01             	test   $0x1,%dl
  80142a:	74 32                	je     80145e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80142c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801433:	25 07 0e 00 00       	and    $0xe07,%eax
  801438:	89 44 24 10          	mov    %eax,0x10(%esp)
  80143c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801440:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801447:	00 
  801448:	89 74 24 04          	mov    %esi,0x4(%esp)
  80144c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801453:	e8 05 fb ff ff       	call   800f5d <sys_page_map>
  801458:	89 c6                	mov    %eax,%esi
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 3e                	js     80149c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801461:	89 c2                	mov    %eax,%edx
  801463:	c1 ea 0c             	shr    $0xc,%edx
  801466:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80146d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801473:	89 54 24 10          	mov    %edx,0x10(%esp)
  801477:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80147b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801482:	00 
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148e:	e8 ca fa ff ff       	call   800f5d <sys_page_map>
  801493:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801498:	85 f6                	test   %esi,%esi
  80149a:	79 22                	jns    8014be <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80149c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a7:	e8 04 fb ff ff       	call   800fb0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b7:	e8 f4 fa ff ff       	call   800fb0 <sys_page_unmap>
	return r;
  8014bc:	89 f0                	mov    %esi,%eax
}
  8014be:	83 c4 3c             	add    $0x3c,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	53                   	push   %ebx
  8014ca:	83 ec 24             	sub    $0x24,%esp
  8014cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	e8 3c fd ff ff       	call   80121b <fd_lookup>
  8014df:	89 c2                	mov    %eax,%edx
  8014e1:	85 d2                	test   %edx,%edx
  8014e3:	78 6d                	js     801552 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	8b 00                	mov    (%eax),%eax
  8014f1:	89 04 24             	mov    %eax,(%esp)
  8014f4:	e8 78 fd ff ff       	call   801271 <dev_lookup>
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 55                	js     801552 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801500:	8b 50 08             	mov    0x8(%eax),%edx
  801503:	83 e2 03             	and    $0x3,%edx
  801506:	83 fa 01             	cmp    $0x1,%edx
  801509:	75 23                	jne    80152e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80150b:	a1 04 40 80 00       	mov    0x804004,%eax
  801510:	8b 40 48             	mov    0x48(%eax),%eax
  801513:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801517:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151b:	c7 04 24 70 27 80 00 	movl   $0x802770,(%esp)
  801522:	e8 d1 ee ff ff       	call   8003f8 <cprintf>
		return -E_INVAL;
  801527:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152c:	eb 24                	jmp    801552 <read+0x8c>
	}
	if (!dev->dev_read)
  80152e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801531:	8b 52 08             	mov    0x8(%edx),%edx
  801534:	85 d2                	test   %edx,%edx
  801536:	74 15                	je     80154d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801538:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80153f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801542:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801546:	89 04 24             	mov    %eax,(%esp)
  801549:	ff d2                	call   *%edx
  80154b:	eb 05                	jmp    801552 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80154d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801552:	83 c4 24             	add    $0x24,%esp
  801555:	5b                   	pop    %ebx
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	57                   	push   %edi
  80155c:	56                   	push   %esi
  80155d:	53                   	push   %ebx
  80155e:	83 ec 1c             	sub    $0x1c,%esp
  801561:	8b 7d 08             	mov    0x8(%ebp),%edi
  801564:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801567:	85 f6                	test   %esi,%esi
  801569:	74 33                	je     80159e <readn+0x46>
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
  801570:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801575:	89 f2                	mov    %esi,%edx
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 54 24 08          	mov    %edx,0x8(%esp)
  80157d:	03 45 0c             	add    0xc(%ebp),%eax
  801580:	89 44 24 04          	mov    %eax,0x4(%esp)
  801584:	89 3c 24             	mov    %edi,(%esp)
  801587:	e8 3a ff ff ff       	call   8014c6 <read>
		if (m < 0)
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 1b                	js     8015ab <readn+0x53>
			return m;
		if (m == 0)
  801590:	85 c0                	test   %eax,%eax
  801592:	74 11                	je     8015a5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801594:	01 c3                	add    %eax,%ebx
  801596:	89 d8                	mov    %ebx,%eax
  801598:	39 f3                	cmp    %esi,%ebx
  80159a:	72 d9                	jb     801575 <readn+0x1d>
  80159c:	eb 0b                	jmp    8015a9 <readn+0x51>
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	eb 06                	jmp    8015ab <readn+0x53>
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	eb 02                	jmp    8015ab <readn+0x53>
  8015a9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015ab:	83 c4 1c             	add    $0x1c,%esp
  8015ae:	5b                   	pop    %ebx
  8015af:	5e                   	pop    %esi
  8015b0:	5f                   	pop    %edi
  8015b1:	5d                   	pop    %ebp
  8015b2:	c3                   	ret    

008015b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	53                   	push   %ebx
  8015b7:	83 ec 24             	sub    $0x24,%esp
  8015ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c4:	89 1c 24             	mov    %ebx,(%esp)
  8015c7:	e8 4f fc ff ff       	call   80121b <fd_lookup>
  8015cc:	89 c2                	mov    %eax,%edx
  8015ce:	85 d2                	test   %edx,%edx
  8015d0:	78 68                	js     80163a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	8b 00                	mov    (%eax),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 8b fc ff ff       	call   801271 <dev_lookup>
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 50                	js     80163a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f1:	75 23                	jne    801616 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8015f8:	8b 40 48             	mov    0x48(%eax),%eax
  8015fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801603:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  80160a:	e8 e9 ed ff ff       	call   8003f8 <cprintf>
		return -E_INVAL;
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801614:	eb 24                	jmp    80163a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801619:	8b 52 0c             	mov    0xc(%edx),%edx
  80161c:	85 d2                	test   %edx,%edx
  80161e:	74 15                	je     801635 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80162e:	89 04 24             	mov    %eax,(%esp)
  801631:	ff d2                	call   *%edx
  801633:	eb 05                	jmp    80163a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80163a:	83 c4 24             	add    $0x24,%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <seek>:

int
seek(int fdnum, off_t offset)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801646:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801649:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	89 04 24             	mov    %eax,(%esp)
  801653:	e8 c3 fb ff ff       	call   80121b <fd_lookup>
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 0e                	js     80166a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	53                   	push   %ebx
  801670:	83 ec 24             	sub    $0x24,%esp
  801673:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801676:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167d:	89 1c 24             	mov    %ebx,(%esp)
  801680:	e8 96 fb ff ff       	call   80121b <fd_lookup>
  801685:	89 c2                	mov    %eax,%edx
  801687:	85 d2                	test   %edx,%edx
  801689:	78 61                	js     8016ec <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	89 04 24             	mov    %eax,(%esp)
  80169a:	e8 d2 fb ff ff       	call   801271 <dev_lookup>
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 49                	js     8016ec <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016aa:	75 23                	jne    8016cf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016ac:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b1:	8b 40 48             	mov    0x48(%eax),%eax
  8016b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bc:	c7 04 24 4c 27 80 00 	movl   $0x80274c,(%esp)
  8016c3:	e8 30 ed ff ff       	call   8003f8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cd:	eb 1d                	jmp    8016ec <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8016cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d2:	8b 52 18             	mov    0x18(%edx),%edx
  8016d5:	85 d2                	test   %edx,%edx
  8016d7:	74 0e                	je     8016e7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016e0:	89 04 24             	mov    %eax,(%esp)
  8016e3:	ff d2                	call   *%edx
  8016e5:	eb 05                	jmp    8016ec <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8016e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8016ec:	83 c4 24             	add    $0x24,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    

008016f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 24             	sub    $0x24,%esp
  8016f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	89 04 24             	mov    %eax,(%esp)
  801709:	e8 0d fb ff ff       	call   80121b <fd_lookup>
  80170e:	89 c2                	mov    %eax,%edx
  801710:	85 d2                	test   %edx,%edx
  801712:	78 52                	js     801766 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	89 04 24             	mov    %eax,(%esp)
  801723:	e8 49 fb ff ff       	call   801271 <dev_lookup>
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 3a                	js     801766 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801733:	74 2c                	je     801761 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801735:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801738:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80173f:	00 00 00 
	stat->st_isdir = 0;
  801742:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801749:	00 00 00 
	stat->st_dev = dev;
  80174c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801752:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801756:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801759:	89 14 24             	mov    %edx,(%esp)
  80175c:	ff 50 14             	call   *0x14(%eax)
  80175f:	eb 05                	jmp    801766 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801761:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801766:	83 c4 24             	add    $0x24,%esp
  801769:	5b                   	pop    %ebx
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801774:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80177b:	00 
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 04 24             	mov    %eax,(%esp)
  801782:	e8 af 01 00 00       	call   801936 <open>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	85 db                	test   %ebx,%ebx
  80178b:	78 1b                	js     8017a8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	89 44 24 04          	mov    %eax,0x4(%esp)
  801794:	89 1c 24             	mov    %ebx,(%esp)
  801797:	e8 56 ff ff ff       	call   8016f2 <fstat>
  80179c:	89 c6                	mov    %eax,%esi
	close(fd);
  80179e:	89 1c 24             	mov    %ebx,(%esp)
  8017a1:	e8 bd fb ff ff       	call   801363 <close>
	return r;
  8017a6:	89 f0                	mov    %esi,%eax
}
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    

008017af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 10             	sub    $0x10,%esp
  8017b7:	89 c6                	mov    %eax,%esi
  8017b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017c2:	75 11                	jne    8017d5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8017cb:	e8 24 08 00 00       	call   801ff4 <ipc_find_env>
  8017d0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017d5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017dc:	00 
  8017dd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8017e4:	00 
  8017e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8017ee:	89 04 24             	mov    %eax,(%esp)
  8017f1:	e8 98 07 00 00       	call   801f8e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017fd:	00 
  8017fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801802:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801809:	e8 18 07 00 00       	call   801f26 <ipc_recv>
}
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    

00801815 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	53                   	push   %ebx
  801819:	83 ec 14             	sub    $0x14,%esp
  80181c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 40 0c             	mov    0xc(%eax),%eax
  801825:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182a:	ba 00 00 00 00       	mov    $0x0,%edx
  80182f:	b8 05 00 00 00       	mov    $0x5,%eax
  801834:	e8 76 ff ff ff       	call   8017af <fsipc>
  801839:	89 c2                	mov    %eax,%edx
  80183b:	85 d2                	test   %edx,%edx
  80183d:	78 2b                	js     80186a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80183f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801846:	00 
  801847:	89 1c 24             	mov    %ebx,(%esp)
  80184a:	e8 0c f2 ff ff       	call   800a5b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80184f:	a1 80 50 80 00       	mov    0x805080,%eax
  801854:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80185a:	a1 84 50 80 00       	mov    0x805084,%eax
  80185f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186a:	83 c4 14             	add    $0x14,%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	8b 40 0c             	mov    0xc(%eax),%eax
  80187c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	b8 06 00 00 00       	mov    $0x6,%eax
  80188b:	e8 1f ff ff ff       	call   8017af <fsipc>
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	83 ec 10             	sub    $0x10,%esp
  80189a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018a8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8018b8:	e8 f2 fe ff ff       	call   8017af <fsipc>
  8018bd:	89 c3                	mov    %eax,%ebx
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 6a                	js     80192d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018c3:	39 c6                	cmp    %eax,%esi
  8018c5:	73 24                	jae    8018eb <devfile_read+0x59>
  8018c7:	c7 44 24 0c a9 27 80 	movl   $0x8027a9,0xc(%esp)
  8018ce:	00 
  8018cf:	c7 44 24 08 b0 27 80 	movl   $0x8027b0,0x8(%esp)
  8018d6:	00 
  8018d7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  8018de:	00 
  8018df:	c7 04 24 c5 27 80 00 	movl   $0x8027c5,(%esp)
  8018e6:	e8 14 ea ff ff       	call   8002ff <_panic>
	assert(r <= PGSIZE);
  8018eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f0:	7e 24                	jle    801916 <devfile_read+0x84>
  8018f2:	c7 44 24 0c d0 27 80 	movl   $0x8027d0,0xc(%esp)
  8018f9:	00 
  8018fa:	c7 44 24 08 b0 27 80 	movl   $0x8027b0,0x8(%esp)
  801901:	00 
  801902:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801909:	00 
  80190a:	c7 04 24 c5 27 80 00 	movl   $0x8027c5,(%esp)
  801911:	e8 e9 e9 ff ff       	call   8002ff <_panic>
	memmove(buf, &fsipcbuf, r);
  801916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801921:	00 
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	e8 29 f3 ff ff       	call   800c56 <memmove>
	return r;
}
  80192d:	89 d8                	mov    %ebx,%eax
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	53                   	push   %ebx
  80193a:	83 ec 24             	sub    $0x24,%esp
  80193d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801940:	89 1c 24             	mov    %ebx,(%esp)
  801943:	e8 b8 f0 ff ff       	call   800a00 <strlen>
  801948:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194d:	7f 60                	jg     8019af <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	e8 4d f8 ff ff       	call   8011a7 <fd_alloc>
  80195a:	89 c2                	mov    %eax,%edx
  80195c:	85 d2                	test   %edx,%edx
  80195e:	78 54                	js     8019b4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801960:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801964:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80196b:	e8 eb f0 ff ff       	call   800a5b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197b:	b8 01 00 00 00       	mov    $0x1,%eax
  801980:	e8 2a fe ff ff       	call   8017af <fsipc>
  801985:	89 c3                	mov    %eax,%ebx
  801987:	85 c0                	test   %eax,%eax
  801989:	79 17                	jns    8019a2 <open+0x6c>
		fd_close(fd, 0);
  80198b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801992:	00 
  801993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 44 f9 ff ff       	call   8012e2 <fd_close>
		return r;
  80199e:	89 d8                	mov    %ebx,%eax
  8019a0:	eb 12                	jmp    8019b4 <open+0x7e>
	}
	return fd2num(fd);
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	89 04 24             	mov    %eax,(%esp)
  8019a8:	e8 d3 f7 ff ff       	call   801180 <fd2num>
  8019ad:	eb 05                	jmp    8019b4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019af:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8019b4:	83 c4 24             	add    $0x24,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    
  8019ba:	66 90                	xchg   %ax,%ax
  8019bc:	66 90                	xchg   %ax,%ax
  8019be:	66 90                	xchg   %ax,%ax

008019c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	56                   	push   %esi
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 10             	sub    $0x10,%esp
  8019c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	89 04 24             	mov    %eax,(%esp)
  8019d1:	e8 ba f7 ff ff       	call   801190 <fd2data>
  8019d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019d8:	c7 44 24 04 dc 27 80 	movl   $0x8027dc,0x4(%esp)
  8019df:	00 
  8019e0:	89 1c 24             	mov    %ebx,(%esp)
  8019e3:	e8 73 f0 ff ff       	call   800a5b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019e8:	8b 46 04             	mov    0x4(%esi),%eax
  8019eb:	2b 06                	sub    (%esi),%eax
  8019ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019fa:	00 00 00 
	stat->st_dev = &devpipe;
  8019fd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a04:	30 80 00 
	return 0;
}
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	53                   	push   %ebx
  801a17:	83 ec 14             	sub    $0x14,%esp
  801a1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a28:	e8 83 f5 ff ff       	call   800fb0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a2d:	89 1c 24             	mov    %ebx,(%esp)
  801a30:	e8 5b f7 ff ff       	call   801190 <fd2data>
  801a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a40:	e8 6b f5 ff ff       	call   800fb0 <sys_page_unmap>
}
  801a45:	83 c4 14             	add    $0x14,%esp
  801a48:	5b                   	pop    %ebx
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	57                   	push   %edi
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	83 ec 2c             	sub    $0x2c,%esp
  801a54:	89 c6                	mov    %eax,%esi
  801a56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801a59:	a1 04 40 80 00       	mov    0x804004,%eax
  801a5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a61:	89 34 24             	mov    %esi,(%esp)
  801a64:	e8 d3 05 00 00       	call   80203c <pageref>
  801a69:	89 c7                	mov    %eax,%edi
  801a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6e:	89 04 24             	mov    %eax,(%esp)
  801a71:	e8 c6 05 00 00       	call   80203c <pageref>
  801a76:	39 c7                	cmp    %eax,%edi
  801a78:	0f 94 c2             	sete   %dl
  801a7b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801a7e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801a84:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801a87:	39 fb                	cmp    %edi,%ebx
  801a89:	74 21                	je     801aac <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801a8b:	84 d2                	test   %dl,%dl
  801a8d:	74 ca                	je     801a59 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a8f:	8b 51 58             	mov    0x58(%ecx),%edx
  801a92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a96:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9e:	c7 04 24 e3 27 80 00 	movl   $0x8027e3,(%esp)
  801aa5:	e8 4e e9 ff ff       	call   8003f8 <cprintf>
  801aaa:	eb ad                	jmp    801a59 <_pipeisclosed+0xe>
	}
}
  801aac:	83 c4 2c             	add    $0x2c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    

00801ab4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	57                   	push   %edi
  801ab8:	56                   	push   %esi
  801ab9:	53                   	push   %ebx
  801aba:	83 ec 1c             	sub    $0x1c,%esp
  801abd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ac0:	89 34 24             	mov    %esi,(%esp)
  801ac3:	e8 c8 f6 ff ff       	call   801190 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801acc:	74 61                	je     801b2f <devpipe_write+0x7b>
  801ace:	89 c3                	mov    %eax,%ebx
  801ad0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad5:	eb 4a                	jmp    801b21 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ad7:	89 da                	mov    %ebx,%edx
  801ad9:	89 f0                	mov    %esi,%eax
  801adb:	e8 6b ff ff ff       	call   801a4b <_pipeisclosed>
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	75 54                	jne    801b38 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ae4:	e8 01 f4 ff ff       	call   800eea <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ae9:	8b 43 04             	mov    0x4(%ebx),%eax
  801aec:	8b 0b                	mov    (%ebx),%ecx
  801aee:	8d 51 20             	lea    0x20(%ecx),%edx
  801af1:	39 d0                	cmp    %edx,%eax
  801af3:	73 e2                	jae    801ad7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801afc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801aff:	99                   	cltd   
  801b00:	c1 ea 1b             	shr    $0x1b,%edx
  801b03:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801b06:	83 e1 1f             	and    $0x1f,%ecx
  801b09:	29 d1                	sub    %edx,%ecx
  801b0b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801b0f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801b13:	83 c0 01             	add    $0x1,%eax
  801b16:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b19:	83 c7 01             	add    $0x1,%edi
  801b1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b1f:	74 13                	je     801b34 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b21:	8b 43 04             	mov    0x4(%ebx),%eax
  801b24:	8b 0b                	mov    (%ebx),%ecx
  801b26:	8d 51 20             	lea    0x20(%ecx),%edx
  801b29:	39 d0                	cmp    %edx,%eax
  801b2b:	73 aa                	jae    801ad7 <devpipe_write+0x23>
  801b2d:	eb c6                	jmp    801af5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b2f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b34:	89 f8                	mov    %edi,%eax
  801b36:	eb 05                	jmp    801b3d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801b3d:	83 c4 1c             	add    $0x1c,%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5f                   	pop    %edi
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	57                   	push   %edi
  801b49:	56                   	push   %esi
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 1c             	sub    $0x1c,%esp
  801b4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801b51:	89 3c 24             	mov    %edi,(%esp)
  801b54:	e8 37 f6 ff ff       	call   801190 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b5d:	74 54                	je     801bb3 <devpipe_read+0x6e>
  801b5f:	89 c3                	mov    %eax,%ebx
  801b61:	be 00 00 00 00       	mov    $0x0,%esi
  801b66:	eb 3e                	jmp    801ba6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801b68:	89 f0                	mov    %esi,%eax
  801b6a:	eb 55                	jmp    801bc1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801b6c:	89 da                	mov    %ebx,%edx
  801b6e:	89 f8                	mov    %edi,%eax
  801b70:	e8 d6 fe ff ff       	call   801a4b <_pipeisclosed>
  801b75:	85 c0                	test   %eax,%eax
  801b77:	75 43                	jne    801bbc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b79:	e8 6c f3 ff ff       	call   800eea <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b7e:	8b 03                	mov    (%ebx),%eax
  801b80:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b83:	74 e7                	je     801b6c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b85:	99                   	cltd   
  801b86:	c1 ea 1b             	shr    $0x1b,%edx
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	83 e0 1f             	and    $0x1f,%eax
  801b8e:	29 d0                	sub    %edx,%eax
  801b90:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b98:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b9b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b9e:	83 c6 01             	add    $0x1,%esi
  801ba1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ba4:	74 12                	je     801bb8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ba6:	8b 03                	mov    (%ebx),%eax
  801ba8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bab:	75 d8                	jne    801b85 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801bad:	85 f6                	test   %esi,%esi
  801baf:	75 b7                	jne    801b68 <devpipe_read+0x23>
  801bb1:	eb b9                	jmp    801b6c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801bb8:	89 f0                	mov    %esi,%eax
  801bba:	eb 05                	jmp    801bc1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801bc1:	83 c4 1c             	add    $0x1c,%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5f                   	pop    %edi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801bd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 cb f5 ff ff       	call   8011a7 <fd_alloc>
  801bdc:	89 c2                	mov    %eax,%edx
  801bde:	85 d2                	test   %edx,%edx
  801be0:	0f 88 4d 01 00 00    	js     801d33 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bed:	00 
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfc:	e8 08 f3 ff ff       	call   800f09 <sys_page_alloc>
  801c01:	89 c2                	mov    %eax,%edx
  801c03:	85 d2                	test   %edx,%edx
  801c05:	0f 88 28 01 00 00    	js     801d33 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 91 f5 ff ff       	call   8011a7 <fd_alloc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	0f 88 fe 00 00 00    	js     801d1e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c20:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c27:	00 
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c36:	e8 ce f2 ff ff       	call   800f09 <sys_page_alloc>
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	0f 88 d9 00 00 00    	js     801d1e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c48:	89 04 24             	mov    %eax,(%esp)
  801c4b:	e8 40 f5 ff ff       	call   801190 <fd2data>
  801c50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c59:	00 
  801c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c65:	e8 9f f2 ff ff       	call   800f09 <sys_page_alloc>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	0f 88 97 00 00 00    	js     801d0b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c77:	89 04 24             	mov    %eax,(%esp)
  801c7a:	e8 11 f5 ff ff       	call   801190 <fd2data>
  801c7f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801c86:	00 
  801c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c92:	00 
  801c93:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9e:	e8 ba f2 ff ff       	call   800f5d <sys_page_map>
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 52                	js     801cfb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ca9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cbe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	89 04 24             	mov    %eax,(%esp)
  801cd9:	e8 a2 f4 ff ff       	call   801180 <fd2num>
  801cde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 92 f4 ff ff       	call   801180 <fd2num>
  801cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	eb 38                	jmp    801d33 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801cfb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d06:	e8 a5 f2 ff ff       	call   800fb0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d19:	e8 92 f2 ff ff       	call   800fb0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2c:	e8 7f f2 ff ff       	call   800fb0 <sys_page_unmap>
  801d31:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801d33:	83 c4 30             	add    $0x30,%esp
  801d36:	5b                   	pop    %ebx
  801d37:	5e                   	pop    %esi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    

00801d3a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	89 04 24             	mov    %eax,(%esp)
  801d4d:	e8 c9 f4 ff ff       	call   80121b <fd_lookup>
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	85 d2                	test   %edx,%edx
  801d56:	78 15                	js     801d6d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5b:	89 04 24             	mov    %eax,(%esp)
  801d5e:	e8 2d f4 ff ff       	call   801190 <fd2data>
	return _pipeisclosed(fd, p);
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	e8 de fc ff ff       	call   801a4b <_pipeisclosed>
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    
  801d6f:	90                   	nop

00801d70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801d80:	c7 44 24 04 fb 27 80 	movl   $0x8027fb,0x4(%esp)
  801d87:	00 
  801d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8b:	89 04 24             	mov    %eax,(%esp)
  801d8e:	e8 c8 ec ff ff       	call   800a5b <strcpy>
	return 0;
}
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	57                   	push   %edi
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801daa:	74 4a                	je     801df6 <devcons_write+0x5c>
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
  801db1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801db6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801dbc:	8b 75 10             	mov    0x10(%ebp),%esi
  801dbf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801dc1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801dc4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801dc9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801dcc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801dd0:	03 45 0c             	add    0xc(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	89 3c 24             	mov    %edi,(%esp)
  801dda:	e8 77 ee ff ff       	call   800c56 <memmove>
		sys_cputs(buf, m);
  801ddf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801de3:	89 3c 24             	mov    %edi,(%esp)
  801de6:	e8 51 f0 ff ff       	call   800e3c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801deb:	01 f3                	add    %esi,%ebx
  801ded:	89 d8                	mov    %ebx,%eax
  801def:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801df2:	72 c8                	jb     801dbc <devcons_write+0x22>
  801df4:	eb 05                	jmp    801dfb <devcons_write+0x61>
  801df6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801dfb:	89 d8                	mov    %ebx,%eax
  801dfd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5e                   	pop    %esi
  801e05:	5f                   	pop    %edi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    

00801e08 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e17:	75 07                	jne    801e20 <devcons_read+0x18>
  801e19:	eb 28                	jmp    801e43 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e1b:	e8 ca f0 ff ff       	call   800eea <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e20:	e8 35 f0 ff ff       	call   800e5a <sys_cgetc>
  801e25:	85 c0                	test   %eax,%eax
  801e27:	74 f2                	je     801e1b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 16                	js     801e43 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e2d:	83 f8 04             	cmp    $0x4,%eax
  801e30:	74 0c                	je     801e3e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	88 02                	mov    %al,(%edx)
	return 1;
  801e37:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3c:	eb 05                	jmp    801e43 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e58:	00 
  801e59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e5c:	89 04 24             	mov    %eax,(%esp)
  801e5f:	e8 d8 ef ff ff       	call   800e3c <sys_cputs>
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <getchar>:

int
getchar(void)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e73:	00 
  801e74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e82:	e8 3f f6 ff ff       	call   8014c6 <read>
	if (r < 0)
  801e87:	85 c0                	test   %eax,%eax
  801e89:	78 0f                	js     801e9a <getchar+0x34>
		return r;
	if (r < 1)
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	7e 06                	jle    801e95 <getchar+0x2f>
		return -E_EOF;
	return c;
  801e8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e93:	eb 05                	jmp    801e9a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	89 04 24             	mov    %eax,(%esp)
  801eaf:	e8 67 f3 ff ff       	call   80121b <fd_lookup>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 11                	js     801ec9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ec1:	39 10                	cmp    %edx,(%eax)
  801ec3:	0f 94 c0             	sete   %al
  801ec6:	0f b6 c0             	movzbl %al,%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <opencons>:

int
opencons(void)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed4:	89 04 24             	mov    %eax,(%esp)
  801ed7:	e8 cb f2 ff ff       	call   8011a7 <fd_alloc>
		return r;
  801edc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 40                	js     801f22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ee2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee9:	00 
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef8:	e8 0c f0 ff ff       	call   800f09 <sys_page_alloc>
		return r;
  801efd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 1f                	js     801f22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f03:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 60 f2 ff ff       	call   801180 <fd2num>
  801f20:	89 c2                	mov    %eax,%edx
}
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	83 ec 10             	sub    $0x10,%esp
  801f2e:	8b 75 08             	mov    0x8(%ebp),%esi
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801f37:	85 c0                	test   %eax,%eax
  801f39:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f3e:	0f 44 c2             	cmove  %edx,%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 d6 f1 ff ff       	call   80111f <sys_ipc_recv>
	if (err_code < 0) {
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	79 16                	jns    801f63 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801f4d:	85 f6                	test   %esi,%esi
  801f4f:	74 06                	je     801f57 <ipc_recv+0x31>
  801f51:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801f57:	85 db                	test   %ebx,%ebx
  801f59:	74 2c                	je     801f87 <ipc_recv+0x61>
  801f5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801f61:	eb 24                	jmp    801f87 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801f63:	85 f6                	test   %esi,%esi
  801f65:	74 0a                	je     801f71 <ipc_recv+0x4b>
  801f67:	a1 04 40 80 00       	mov    0x804004,%eax
  801f6c:	8b 40 74             	mov    0x74(%eax),%eax
  801f6f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801f71:	85 db                	test   %ebx,%ebx
  801f73:	74 0a                	je     801f7f <ipc_recv+0x59>
  801f75:	a1 04 40 80 00       	mov    0x804004,%eax
  801f7a:	8b 40 78             	mov    0x78(%eax),%eax
  801f7d:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801f7f:	a1 04 40 80 00       	mov    0x804004,%eax
  801f84:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	5b                   	pop    %ebx
  801f8b:	5e                   	pop    %esi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    

00801f8e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	53                   	push   %ebx
  801f94:	83 ec 1c             	sub    $0x1c,%esp
  801f97:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801fa0:	eb 25                	jmp    801fc7 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801fa2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fa5:	74 20                	je     801fc7 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fab:	c7 44 24 08 07 28 80 	movl   $0x802807,0x8(%esp)
  801fb2:	00 
  801fb3:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801fba:	00 
  801fbb:	c7 04 24 13 28 80 00 	movl   $0x802813,(%esp)
  801fc2:	e8 38 e3 ff ff       	call   8002ff <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801fc7:	85 db                	test   %ebx,%ebx
  801fc9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fce:	0f 45 c3             	cmovne %ebx,%eax
  801fd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801fd4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe0:	89 3c 24             	mov    %edi,(%esp)
  801fe3:	e8 14 f1 ff ff       	call   8010fc <sys_ipc_try_send>
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	75 b6                	jne    801fa2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801ffa:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801fff:	39 c8                	cmp    %ecx,%eax
  802001:	74 17                	je     80201a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802003:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802008:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80200b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802011:	8b 52 50             	mov    0x50(%edx),%edx
  802014:	39 ca                	cmp    %ecx,%edx
  802016:	75 14                	jne    80202c <ipc_find_env+0x38>
  802018:	eb 05                	jmp    80201f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80201f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802022:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802027:	8b 40 40             	mov    0x40(%eax),%eax
  80202a:	eb 0e                	jmp    80203a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80202c:	83 c0 01             	add    $0x1,%eax
  80202f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802034:	75 d2                	jne    802008 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802036:	66 b8 00 00          	mov    $0x0,%ax
}
  80203a:	5d                   	pop    %ebp
  80203b:	c3                   	ret    

0080203c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802042:	89 d0                	mov    %edx,%eax
  802044:	c1 e8 16             	shr    $0x16,%eax
  802047:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802053:	f6 c1 01             	test   $0x1,%cl
  802056:	74 1d                	je     802075 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802058:	c1 ea 0c             	shr    $0xc,%edx
  80205b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802062:	f6 c2 01             	test   $0x1,%dl
  802065:	74 0e                	je     802075 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802067:	c1 ea 0c             	shr    $0xc,%edx
  80206a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802071:	ef 
  802072:	0f b7 c0             	movzwl %ax,%eax
}
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    
  802077:	66 90                	xchg   %ax,%ax
  802079:	66 90                	xchg   %ax,%ax
  80207b:	66 90                	xchg   %ax,%ax
  80207d:	66 90                	xchg   %ax,%ax
  80207f:	90                   	nop

00802080 <__udivdi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	8b 44 24 28          	mov    0x28(%esp),%eax
  80208a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80208e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802092:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802096:	85 c0                	test   %eax,%eax
  802098:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80209c:	89 ea                	mov    %ebp,%edx
  80209e:	89 0c 24             	mov    %ecx,(%esp)
  8020a1:	75 2d                	jne    8020d0 <__udivdi3+0x50>
  8020a3:	39 e9                	cmp    %ebp,%ecx
  8020a5:	77 61                	ja     802108 <__udivdi3+0x88>
  8020a7:	85 c9                	test   %ecx,%ecx
  8020a9:	89 ce                	mov    %ecx,%esi
  8020ab:	75 0b                	jne    8020b8 <__udivdi3+0x38>
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b2:	31 d2                	xor    %edx,%edx
  8020b4:	f7 f1                	div    %ecx
  8020b6:	89 c6                	mov    %eax,%esi
  8020b8:	31 d2                	xor    %edx,%edx
  8020ba:	89 e8                	mov    %ebp,%eax
  8020bc:	f7 f6                	div    %esi
  8020be:	89 c5                	mov    %eax,%ebp
  8020c0:	89 f8                	mov    %edi,%eax
  8020c2:	f7 f6                	div    %esi
  8020c4:	89 ea                	mov    %ebp,%edx
  8020c6:	83 c4 0c             	add    $0xc,%esp
  8020c9:	5e                   	pop    %esi
  8020ca:	5f                   	pop    %edi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    
  8020cd:	8d 76 00             	lea    0x0(%esi),%esi
  8020d0:	39 e8                	cmp    %ebp,%eax
  8020d2:	77 24                	ja     8020f8 <__udivdi3+0x78>
  8020d4:	0f bd e8             	bsr    %eax,%ebp
  8020d7:	83 f5 1f             	xor    $0x1f,%ebp
  8020da:	75 3c                	jne    802118 <__udivdi3+0x98>
  8020dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8020e0:	39 34 24             	cmp    %esi,(%esp)
  8020e3:	0f 86 9f 00 00 00    	jbe    802188 <__udivdi3+0x108>
  8020e9:	39 d0                	cmp    %edx,%eax
  8020eb:	0f 82 97 00 00 00    	jb     802188 <__udivdi3+0x108>
  8020f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020f8:	31 d2                	xor    %edx,%edx
  8020fa:	31 c0                	xor    %eax,%eax
  8020fc:	83 c4 0c             	add    $0xc,%esp
  8020ff:	5e                   	pop    %esi
  802100:	5f                   	pop    %edi
  802101:	5d                   	pop    %ebp
  802102:	c3                   	ret    
  802103:	90                   	nop
  802104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802108:	89 f8                	mov    %edi,%eax
  80210a:	f7 f1                	div    %ecx
  80210c:	31 d2                	xor    %edx,%edx
  80210e:	83 c4 0c             	add    $0xc,%esp
  802111:	5e                   	pop    %esi
  802112:	5f                   	pop    %edi
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    
  802115:	8d 76 00             	lea    0x0(%esi),%esi
  802118:	89 e9                	mov    %ebp,%ecx
  80211a:	8b 3c 24             	mov    (%esp),%edi
  80211d:	d3 e0                	shl    %cl,%eax
  80211f:	89 c6                	mov    %eax,%esi
  802121:	b8 20 00 00 00       	mov    $0x20,%eax
  802126:	29 e8                	sub    %ebp,%eax
  802128:	89 c1                	mov    %eax,%ecx
  80212a:	d3 ef                	shr    %cl,%edi
  80212c:	89 e9                	mov    %ebp,%ecx
  80212e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802132:	8b 3c 24             	mov    (%esp),%edi
  802135:	09 74 24 08          	or     %esi,0x8(%esp)
  802139:	89 d6                	mov    %edx,%esi
  80213b:	d3 e7                	shl    %cl,%edi
  80213d:	89 c1                	mov    %eax,%ecx
  80213f:	89 3c 24             	mov    %edi,(%esp)
  802142:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802146:	d3 ee                	shr    %cl,%esi
  802148:	89 e9                	mov    %ebp,%ecx
  80214a:	d3 e2                	shl    %cl,%edx
  80214c:	89 c1                	mov    %eax,%ecx
  80214e:	d3 ef                	shr    %cl,%edi
  802150:	09 d7                	or     %edx,%edi
  802152:	89 f2                	mov    %esi,%edx
  802154:	89 f8                	mov    %edi,%eax
  802156:	f7 74 24 08          	divl   0x8(%esp)
  80215a:	89 d6                	mov    %edx,%esi
  80215c:	89 c7                	mov    %eax,%edi
  80215e:	f7 24 24             	mull   (%esp)
  802161:	39 d6                	cmp    %edx,%esi
  802163:	89 14 24             	mov    %edx,(%esp)
  802166:	72 30                	jb     802198 <__udivdi3+0x118>
  802168:	8b 54 24 04          	mov    0x4(%esp),%edx
  80216c:	89 e9                	mov    %ebp,%ecx
  80216e:	d3 e2                	shl    %cl,%edx
  802170:	39 c2                	cmp    %eax,%edx
  802172:	73 05                	jae    802179 <__udivdi3+0xf9>
  802174:	3b 34 24             	cmp    (%esp),%esi
  802177:	74 1f                	je     802198 <__udivdi3+0x118>
  802179:	89 f8                	mov    %edi,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	e9 7a ff ff ff       	jmp    8020fc <__udivdi3+0x7c>
  802182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802188:	31 d2                	xor    %edx,%edx
  80218a:	b8 01 00 00 00       	mov    $0x1,%eax
  80218f:	e9 68 ff ff ff       	jmp    8020fc <__udivdi3+0x7c>
  802194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802198:	8d 47 ff             	lea    -0x1(%edi),%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	83 c4 0c             	add    $0xc,%esp
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    
  8021a4:	66 90                	xchg   %ax,%ax
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	83 ec 14             	sub    $0x14,%esp
  8021b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8021ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8021be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8021c2:	89 c7                	mov    %eax,%edi
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8021cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8021d0:	89 34 24             	mov    %esi,(%esp)
  8021d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	89 c2                	mov    %eax,%edx
  8021db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021df:	75 17                	jne    8021f8 <__umoddi3+0x48>
  8021e1:	39 fe                	cmp    %edi,%esi
  8021e3:	76 4b                	jbe    802230 <__umoddi3+0x80>
  8021e5:	89 c8                	mov    %ecx,%eax
  8021e7:	89 fa                	mov    %edi,%edx
  8021e9:	f7 f6                	div    %esi
  8021eb:	89 d0                	mov    %edx,%eax
  8021ed:	31 d2                	xor    %edx,%edx
  8021ef:	83 c4 14             	add    $0x14,%esp
  8021f2:	5e                   	pop    %esi
  8021f3:	5f                   	pop    %edi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	39 f8                	cmp    %edi,%eax
  8021fa:	77 54                	ja     802250 <__umoddi3+0xa0>
  8021fc:	0f bd e8             	bsr    %eax,%ebp
  8021ff:	83 f5 1f             	xor    $0x1f,%ebp
  802202:	75 5c                	jne    802260 <__umoddi3+0xb0>
  802204:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802208:	39 3c 24             	cmp    %edi,(%esp)
  80220b:	0f 87 e7 00 00 00    	ja     8022f8 <__umoddi3+0x148>
  802211:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802215:	29 f1                	sub    %esi,%ecx
  802217:	19 c7                	sbb    %eax,%edi
  802219:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80221d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802221:	8b 44 24 08          	mov    0x8(%esp),%eax
  802225:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802229:	83 c4 14             	add    $0x14,%esp
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	85 f6                	test   %esi,%esi
  802232:	89 f5                	mov    %esi,%ebp
  802234:	75 0b                	jne    802241 <__umoddi3+0x91>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f6                	div    %esi
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	8b 44 24 04          	mov    0x4(%esp),%eax
  802245:	31 d2                	xor    %edx,%edx
  802247:	f7 f5                	div    %ebp
  802249:	89 c8                	mov    %ecx,%eax
  80224b:	f7 f5                	div    %ebp
  80224d:	eb 9c                	jmp    8021eb <__umoddi3+0x3b>
  80224f:	90                   	nop
  802250:	89 c8                	mov    %ecx,%eax
  802252:	89 fa                	mov    %edi,%edx
  802254:	83 c4 14             	add    $0x14,%esp
  802257:	5e                   	pop    %esi
  802258:	5f                   	pop    %edi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    
  80225b:	90                   	nop
  80225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802260:	8b 04 24             	mov    (%esp),%eax
  802263:	be 20 00 00 00       	mov    $0x20,%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	29 ee                	sub    %ebp,%esi
  80226c:	d3 e2                	shl    %cl,%edx
  80226e:	89 f1                	mov    %esi,%ecx
  802270:	d3 e8                	shr    %cl,%eax
  802272:	89 e9                	mov    %ebp,%ecx
  802274:	89 44 24 04          	mov    %eax,0x4(%esp)
  802278:	8b 04 24             	mov    (%esp),%eax
  80227b:	09 54 24 04          	or     %edx,0x4(%esp)
  80227f:	89 fa                	mov    %edi,%edx
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 f1                	mov    %esi,%ecx
  802285:	89 44 24 08          	mov    %eax,0x8(%esp)
  802289:	8b 44 24 10          	mov    0x10(%esp),%eax
  80228d:	d3 ea                	shr    %cl,%edx
  80228f:	89 e9                	mov    %ebp,%ecx
  802291:	d3 e7                	shl    %cl,%edi
  802293:	89 f1                	mov    %esi,%ecx
  802295:	d3 e8                	shr    %cl,%eax
  802297:	89 e9                	mov    %ebp,%ecx
  802299:	09 f8                	or     %edi,%eax
  80229b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80229f:	f7 74 24 04          	divl   0x4(%esp)
  8022a3:	d3 e7                	shl    %cl,%edi
  8022a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022a9:	89 d7                	mov    %edx,%edi
  8022ab:	f7 64 24 08          	mull   0x8(%esp)
  8022af:	39 d7                	cmp    %edx,%edi
  8022b1:	89 c1                	mov    %eax,%ecx
  8022b3:	89 14 24             	mov    %edx,(%esp)
  8022b6:	72 2c                	jb     8022e4 <__umoddi3+0x134>
  8022b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8022bc:	72 22                	jb     8022e0 <__umoddi3+0x130>
  8022be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8022c2:	29 c8                	sub    %ecx,%eax
  8022c4:	19 d7                	sbb    %edx,%edi
  8022c6:	89 e9                	mov    %ebp,%ecx
  8022c8:	89 fa                	mov    %edi,%edx
  8022ca:	d3 e8                	shr    %cl,%eax
  8022cc:	89 f1                	mov    %esi,%ecx
  8022ce:	d3 e2                	shl    %cl,%edx
  8022d0:	89 e9                	mov    %ebp,%ecx
  8022d2:	d3 ef                	shr    %cl,%edi
  8022d4:	09 d0                	or     %edx,%eax
  8022d6:	89 fa                	mov    %edi,%edx
  8022d8:	83 c4 14             	add    $0x14,%esp
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
  8022df:	90                   	nop
  8022e0:	39 d7                	cmp    %edx,%edi
  8022e2:	75 da                	jne    8022be <__umoddi3+0x10e>
  8022e4:	8b 14 24             	mov    (%esp),%edx
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8022ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8022f1:	eb cb                	jmp    8022be <__umoddi3+0x10e>
  8022f3:	90                   	nop
  8022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8022fc:	0f 82 0f ff ff ff    	jb     802211 <__umoddi3+0x61>
  802302:	e9 1a ff ff ff       	jmp    802221 <__umoddi3+0x71>
