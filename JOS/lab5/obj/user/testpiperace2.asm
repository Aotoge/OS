
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b9 01 00 00       	call   8001ea <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  800043:	e8 2c 03 00 00       	call   800374 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 56 1e 00 00       	call   801ea9 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 0e 27 80 	movl   $0x80270e,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 17 27 80 00 	movl   $0x802717,(%esp)
  800072:	e8 04 02 00 00       	call   80027b <_panic>
	if ((r = fork()) < 0)
  800077:	e8 54 11 00 00       	call   8011d0 <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 2c 27 80 	movl   $0x80272c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 17 27 80 00 	movl   $0x802717,(%esp)
  80009d:	e8 d9 01 00 00       	call   80027b <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 75                	jne    80011b <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 62 15 00 00       	call   801613 <close>
		for (i = 0; i < 200; i++) {
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b6:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	f7 ee                	imul   %esi
  8000bf:	c1 fa 02             	sar    $0x2,%edx
  8000c2:	89 d8                	mov    %ebx,%eax
  8000c4:	c1 f8 1f             	sar    $0x1f,%eax
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	39 c3                	cmp    %eax,%ebx
  8000d0:	75 10                	jne    8000e2 <umain+0xaf>
				cprintf("%d.", i);
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  8000dd:	e8 92 02 00 00       	call   800374 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 73 15 00 00       	call   801668 <dup>
			sys_yield();
  8000f5:	e8 60 0d 00 00       	call   800e5a <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 0d 15 00 00       	call   801613 <close>
			sys_yield();
  800106:	e8 4f 0d 00 00       	call   800e5a <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010b:	83 c3 01             	add    $0x1,%ebx
  80010e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800114:	75 a5                	jne    8000bb <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800116:	e8 47 01 00 00       	call   800262 <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011b:	89 fb                	mov    %edi,%ebx
  80011d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800123:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800126:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012c:	eb 28                	jmp    800156 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 e1 1e 00 00       	call   80201a <pipeisclosed>
  800139:	85 c0                	test   %eax,%eax
  80013b:	74 19                	je     800156 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013d:	c7 04 24 39 27 80 00 	movl   $0x802739,(%esp)
  800144:	e8 2b 02 00 00       	call   800374 <cprintf>
			sys_env_destroy(r);
  800149:	89 3c 24             	mov    %edi,(%esp)
  80014c:	e8 98 0c 00 00       	call   800de9 <sys_env_destroy>
			exit();
  800151:	e8 0c 01 00 00       	call   800262 <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800156:	8b 43 54             	mov    0x54(%ebx),%eax
  800159:	83 f8 02             	cmp    $0x2,%eax
  80015c:	74 d0                	je     80012e <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015e:	c7 04 24 55 27 80 00 	movl   $0x802755,(%esp)
  800165:	e8 0a 02 00 00       	call   800374 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 a5 1e 00 00       	call   80201a <pipeisclosed>
  800175:	85 c0                	test   %eax,%eax
  800177:	74 1c                	je     800195 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  800179:	c7 44 24 08 e4 26 80 	movl   $0x8026e4,0x8(%esp)
  800180:	00 
  800181:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800188:	00 
  800189:	c7 04 24 17 27 80 00 	movl   $0x802717,(%esp)
  800190:	e8 e6 00 00 00       	call   80027b <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800195:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 24 13 00 00       	call   8014cb <fd_lookup>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 6b 27 80 	movl   $0x80276b,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 17 27 80 00 	movl   $0x802717,(%esp)
  8001c6:	e8 b0 00 00 00       	call   80027b <_panic>
	(void) fd2data(fd);
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	89 04 24             	mov    %eax,(%esp)
  8001d1:	e8 6a 12 00 00       	call   801440 <fd2data>
	cprintf("race didn't happen\n");
  8001d6:	c7 04 24 83 27 80 00 	movl   $0x802783,(%esp)
  8001dd:	e8 92 01 00 00       	call   800374 <cprintf>
}
  8001e2:	83 c4 2c             	add    $0x2c,%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 10             	sub    $0x10,%esp
  8001f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8001f8:	e8 3e 0c 00 00       	call   800e3b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8001fd:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800203:	39 c2                	cmp    %eax,%edx
  800205:	74 17                	je     80021e <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800207:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80020c:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80020f:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800215:	8b 49 40             	mov    0x40(%ecx),%ecx
  800218:	39 c1                	cmp    %eax,%ecx
  80021a:	75 18                	jne    800234 <libmain+0x4a>
  80021c:	eb 05                	jmp    800223 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800223:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800226:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80022c:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800232:	eb 0b                	jmp    80023f <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800234:	83 c2 01             	add    $0x1,%edx
  800237:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80023d:	75 cd                	jne    80020c <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7e 07                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800243:	8b 06                	mov    (%esi),%eax
  800245:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80024a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024e:	89 1c 24             	mov    %ebx,(%esp)
  800251:	e8 dd fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800256:	e8 07 00 00 00       	call   800262 <exit>
}
  80025b:	83 c4 10             	add    $0x10,%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    

00800262 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800268:	e8 d9 13 00 00       	call   801646 <close_all>
	sys_env_destroy(0);
  80026d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800274:	e8 70 0b 00 00       	call   800de9 <sys_env_destroy>
}
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800283:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800286:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80028c:	e8 aa 0b 00 00       	call   800e3b <sys_getenvid>
  800291:	8b 55 0c             	mov    0xc(%ebp),%edx
  800294:	89 54 24 10          	mov    %edx,0x10(%esp)
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80029f:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a7:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8002ae:	e8 c1 00 00 00       	call   800374 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ba:	89 04 24             	mov    %eax,(%esp)
  8002bd:	e8 51 00 00 00       	call   800313 <vcprintf>
	cprintf("\n");
  8002c2:	c7 04 24 01 2d 80 00 	movl   $0x802d01,(%esp)
  8002c9:	e8 a6 00 00 00       	call   800374 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ce:	cc                   	int3   
  8002cf:	eb fd                	jmp    8002ce <_panic+0x53>

008002d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 14             	sub    $0x14,%esp
  8002d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002db:	8b 13                	mov    (%ebx),%edx
  8002dd:	8d 42 01             	lea    0x1(%edx),%eax
  8002e0:	89 03                	mov    %eax,(%ebx)
  8002e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ee:	75 19                	jne    800309 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002f0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002f7:	00 
  8002f8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002fb:	89 04 24             	mov    %eax,(%esp)
  8002fe:	e8 a9 0a 00 00       	call   800dac <sys_cputs>
		b->idx = 0;
  800303:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800309:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030d:	83 c4 14             	add    $0x14,%esp
  800310:	5b                   	pop    %ebx
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800323:	00 00 00 
	b.cnt = 0;
  800326:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800344:	89 44 24 04          	mov    %eax,0x4(%esp)
  800348:	c7 04 24 d1 02 80 00 	movl   $0x8002d1,(%esp)
  80034f:	e8 b0 01 00 00       	call   800504 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800354:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800364:	89 04 24             	mov    %eax,(%esp)
  800367:	e8 40 0a 00 00       	call   800dac <sys_cputs>

	return b.cnt;
}
  80036c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800372:	c9                   	leave  
  800373:	c3                   	ret    

00800374 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 87 ff ff ff       	call   800313 <vcprintf>
	va_end(ap);

	return cnt;
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    
  80038e:	66 90                	xchg   %ax,%ax

00800390 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 3c             	sub    $0x3c,%esp
  800399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039c:	89 d7                	mov    %edx,%edi
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003a7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8003aa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003b8:	39 f1                	cmp    %esi,%ecx
  8003ba:	72 14                	jb     8003d0 <printnum+0x40>
  8003bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003bf:	76 0f                	jbe    8003d0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8003c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8003ca:	85 f6                	test   %esi,%esi
  8003cc:	7f 60                	jg     80042e <printnum+0x9e>
  8003ce:	eb 72                	jmp    800442 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8003da:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8003dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003e9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003ed:	89 c3                	mov    %eax,%ebx
  8003ef:	89 d6                	mov    %edx,%esi
  8003f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800402:	89 04 24             	mov    %eax,(%esp)
  800405:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800408:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040c:	e8 0f 20 00 00       	call   802420 <__udivdi3>
  800411:	89 d9                	mov    %ebx,%ecx
  800413:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800417:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800422:	89 fa                	mov    %edi,%edx
  800424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800427:	e8 64 ff ff ff       	call   800390 <printnum>
  80042c:	eb 14                	jmp    800442 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80042e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800432:	8b 45 18             	mov    0x18(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80043a:	83 ee 01             	sub    $0x1,%esi
  80043d:	75 ef                	jne    80042e <printnum+0x9e>
  80043f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800442:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800446:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80044a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800450:	89 44 24 08          	mov    %eax,0x8(%esp)
  800454:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045b:	89 04 24             	mov    %eax,(%esp)
  80045e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800461:	89 44 24 04          	mov    %eax,0x4(%esp)
  800465:	e8 e6 20 00 00       	call   802550 <__umoddi3>
  80046a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046e:	0f be 80 c7 27 80 00 	movsbl 0x8027c7(%eax),%eax
  800475:	89 04 24             	mov    %eax,(%esp)
  800478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047b:	ff d0                	call   *%eax
}
  80047d:	83 c4 3c             	add    $0x3c,%esp
  800480:	5b                   	pop    %ebx
  800481:	5e                   	pop    %esi
  800482:	5f                   	pop    %edi
  800483:	5d                   	pop    %ebp
  800484:	c3                   	ret    

00800485 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800488:	83 fa 01             	cmp    $0x1,%edx
  80048b:	7e 0e                	jle    80049b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80048d:	8b 10                	mov    (%eax),%edx
  80048f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800492:	89 08                	mov    %ecx,(%eax)
  800494:	8b 02                	mov    (%edx),%eax
  800496:	8b 52 04             	mov    0x4(%edx),%edx
  800499:	eb 22                	jmp    8004bd <getuint+0x38>
	else if (lflag)
  80049b:	85 d2                	test   %edx,%edx
  80049d:	74 10                	je     8004af <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004a4:	89 08                	mov    %ecx,(%eax)
  8004a6:	8b 02                	mov    (%edx),%eax
  8004a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ad:	eb 0e                	jmp    8004bd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004af:	8b 10                	mov    (%eax),%edx
  8004b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004b4:	89 08                	mov    %ecx,(%eax)
  8004b6:	8b 02                	mov    (%edx),%eax
  8004b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c9:	8b 10                	mov    (%eax),%edx
  8004cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ce:	73 0a                	jae    8004da <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d3:	89 08                	mov    %ecx,(%eax)
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	88 02                	mov    %al,(%edx)
}
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    

008004dc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	89 04 24             	mov    %eax,(%esp)
  8004fd:	e8 02 00 00 00       	call   800504 <vprintfmt>
	va_end(ap);
}
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	83 ec 3c             	sub    $0x3c,%esp
  80050d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800510:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800513:	eb 18                	jmp    80052d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800515:	85 c0                	test   %eax,%eax
  800517:	0f 84 c3 03 00 00    	je     8008e0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80051d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800521:	89 04 24             	mov    %eax,(%esp)
  800524:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800527:	89 f3                	mov    %esi,%ebx
  800529:	eb 02                	jmp    80052d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80052b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	8d 73 01             	lea    0x1(%ebx),%esi
  800530:	0f b6 03             	movzbl (%ebx),%eax
  800533:	83 f8 25             	cmp    $0x25,%eax
  800536:	75 dd                	jne    800515 <vprintfmt+0x11>
  800538:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80053c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800543:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80054a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	eb 1d                	jmp    800575 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800558:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80055a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80055e:	eb 15                	jmp    800575 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800560:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800562:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800566:	eb 0d                	jmp    800575 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8d 5e 01             	lea    0x1(%esi),%ebx
  800578:	0f b6 06             	movzbl (%esi),%eax
  80057b:	0f b6 c8             	movzbl %al,%ecx
  80057e:	83 e8 23             	sub    $0x23,%eax
  800581:	3c 55                	cmp    $0x55,%al
  800583:	0f 87 2f 03 00 00    	ja     8008b8 <vprintfmt+0x3b4>
  800589:	0f b6 c0             	movzbl %al,%eax
  80058c:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800593:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800596:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800599:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80059d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8005a0:	83 f9 09             	cmp    $0x9,%ecx
  8005a3:	77 50                	ja     8005f5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	89 de                	mov    %ebx,%esi
  8005a7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005aa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005ad:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005b0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005b4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005b7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ba:	83 fb 09             	cmp    $0x9,%ebx
  8005bd:	76 eb                	jbe    8005aa <vprintfmt+0xa6>
  8005bf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c2:	eb 33                	jmp    8005f7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 48 04             	lea    0x4(%eax),%ecx
  8005ca:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005d4:	eb 21                	jmp    8005f7 <vprintfmt+0xf3>
  8005d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d9:	85 c9                	test   %ecx,%ecx
  8005db:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e0:	0f 49 c1             	cmovns %ecx,%eax
  8005e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	89 de                	mov    %ebx,%esi
  8005e8:	eb 8b                	jmp    800575 <vprintfmt+0x71>
  8005ea:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005ec:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005f3:	eb 80                	jmp    800575 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fb:	0f 89 74 ff ff ff    	jns    800575 <vprintfmt+0x71>
  800601:	e9 62 ff ff ff       	jmp    800568 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800606:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800609:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80060b:	e9 65 ff ff ff       	jmp    800575 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	89 55 14             	mov    %edx,0x14(%ebp)
  800619:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	ff 55 08             	call   *0x8(%ebp)
			break;
  800625:	e9 03 ff ff ff       	jmp    80052d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 50 04             	lea    0x4(%eax),%edx
  800630:	89 55 14             	mov    %edx,0x14(%ebp)
  800633:	8b 00                	mov    (%eax),%eax
  800635:	99                   	cltd   
  800636:	31 d0                	xor    %edx,%eax
  800638:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063a:	83 f8 0f             	cmp    $0xf,%eax
  80063d:	7f 0b                	jg     80064a <vprintfmt+0x146>
  80063f:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  800646:	85 d2                	test   %edx,%edx
  800648:	75 20                	jne    80066a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80064a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80064e:	c7 44 24 08 df 27 80 	movl   $0x8027df,0x8(%esp)
  800655:	00 
  800656:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	89 04 24             	mov    %eax,(%esp)
  800660:	e8 77 fe ff ff       	call   8004dc <printfmt>
  800665:	e9 c3 fe ff ff       	jmp    80052d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80066a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80066e:	c7 44 24 08 cf 2c 80 	movl   $0x802ccf,0x8(%esp)
  800675:	00 
  800676:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 04 24             	mov    %eax,(%esp)
  800680:	e8 57 fe ff ff       	call   8004dc <printfmt>
  800685:	e9 a3 fe ff ff       	jmp    80052d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80068d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 50 04             	lea    0x4(%eax),%edx
  800696:	89 55 14             	mov    %edx,0x14(%ebp)
  800699:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80069b:	85 c0                	test   %eax,%eax
  80069d:	ba d8 27 80 00       	mov    $0x8027d8,%edx
  8006a2:	0f 45 d0             	cmovne %eax,%edx
  8006a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8006a8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8006ac:	74 04                	je     8006b2 <vprintfmt+0x1ae>
  8006ae:	85 f6                	test   %esi,%esi
  8006b0:	7f 19                	jg     8006cb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b5:	8d 70 01             	lea    0x1(%eax),%esi
  8006b8:	0f b6 10             	movzbl (%eax),%edx
  8006bb:	0f be c2             	movsbl %dl,%eax
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	0f 85 95 00 00 00    	jne    80075b <vprintfmt+0x257>
  8006c6:	e9 85 00 00 00       	jmp    800750 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d2:	89 04 24             	mov    %eax,(%esp)
  8006d5:	e8 b8 02 00 00       	call   800992 <strnlen>
  8006da:	29 c6                	sub    %eax,%esi
  8006dc:	89 f0                	mov    %esi,%eax
  8006de:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006e1:	85 f6                	test   %esi,%esi
  8006e3:	7e cd                	jle    8006b2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8006e5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8006e9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006ec:	89 c3                	mov    %eax,%ebx
  8006ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f2:	89 34 24             	mov    %esi,(%esp)
  8006f5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f8:	83 eb 01             	sub    $0x1,%ebx
  8006fb:	75 f1                	jne    8006ee <vprintfmt+0x1ea>
  8006fd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800700:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800703:	eb ad                	jmp    8006b2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800705:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800709:	74 1e                	je     800729 <vprintfmt+0x225>
  80070b:	0f be d2             	movsbl %dl,%edx
  80070e:	83 ea 20             	sub    $0x20,%edx
  800711:	83 fa 5e             	cmp    $0x5e,%edx
  800714:	76 13                	jbe    800729 <vprintfmt+0x225>
					putch('?', putdat);
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800724:	ff 55 08             	call   *0x8(%ebp)
  800727:	eb 0d                	jmp    800736 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800729:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80072c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800730:	89 04 24             	mov    %eax,(%esp)
  800733:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800736:	83 ef 01             	sub    $0x1,%edi
  800739:	83 c6 01             	add    $0x1,%esi
  80073c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800740:	0f be c2             	movsbl %dl,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	75 20                	jne    800767 <vprintfmt+0x263>
  800747:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80074a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80074d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800750:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800754:	7f 25                	jg     80077b <vprintfmt+0x277>
  800756:	e9 d2 fd ff ff       	jmp    80052d <vprintfmt+0x29>
  80075b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80075e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800761:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800764:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800767:	85 db                	test   %ebx,%ebx
  800769:	78 9a                	js     800705 <vprintfmt+0x201>
  80076b:	83 eb 01             	sub    $0x1,%ebx
  80076e:	79 95                	jns    800705 <vprintfmt+0x201>
  800770:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800773:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800776:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800779:	eb d5                	jmp    800750 <vprintfmt+0x24c>
  80077b:	8b 75 08             	mov    0x8(%ebp),%esi
  80077e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800781:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800784:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800788:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80078f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800791:	83 eb 01             	sub    $0x1,%ebx
  800794:	75 ee                	jne    800784 <vprintfmt+0x280>
  800796:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800799:	e9 8f fd ff ff       	jmp    80052d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80079e:	83 fa 01             	cmp    $0x1,%edx
  8007a1:	7e 16                	jle    8007b9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 50 08             	lea    0x8(%eax),%edx
  8007a9:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ac:	8b 50 04             	mov    0x4(%eax),%edx
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b7:	eb 32                	jmp    8007eb <vprintfmt+0x2e7>
	else if (lflag)
  8007b9:	85 d2                	test   %edx,%edx
  8007bb:	74 18                	je     8007d5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c6:	8b 30                	mov    (%eax),%esi
  8007c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	c1 f8 1f             	sar    $0x1f,%eax
  8007d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d3:	eb 16                	jmp    8007eb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 50 04             	lea    0x4(%eax),%edx
  8007db:	89 55 14             	mov    %edx,0x14(%ebp)
  8007de:	8b 30                	mov    (%eax),%esi
  8007e0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007e3:	89 f0                	mov    %esi,%eax
  8007e5:	c1 f8 1f             	sar    $0x1f,%eax
  8007e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007f1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007fa:	0f 89 80 00 00 00    	jns    800880 <vprintfmt+0x37c>
				putch('-', putdat);
  800800:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800804:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80080b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80080e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800811:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800814:	f7 d8                	neg    %eax
  800816:	83 d2 00             	adc    $0x0,%edx
  800819:	f7 da                	neg    %edx
			}
			base = 10;
  80081b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800820:	eb 5e                	jmp    800880 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800822:	8d 45 14             	lea    0x14(%ebp),%eax
  800825:	e8 5b fc ff ff       	call   800485 <getuint>
			base = 10;
  80082a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80082f:	eb 4f                	jmp    800880 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800831:	8d 45 14             	lea    0x14(%ebp),%eax
  800834:	e8 4c fc ff ff       	call   800485 <getuint>
			base = 8;
  800839:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80083e:	eb 40                	jmp    800880 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800844:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80084b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80084e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800852:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800859:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 50 04             	lea    0x4(%eax),%edx
  800862:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800865:	8b 00                	mov    (%eax),%eax
  800867:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80086c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800871:	eb 0d                	jmp    800880 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800873:	8d 45 14             	lea    0x14(%ebp),%eax
  800876:	e8 0a fc ff ff       	call   800485 <getuint>
			base = 16;
  80087b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800880:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800884:	89 74 24 10          	mov    %esi,0x10(%esp)
  800888:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80088b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80088f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800893:	89 04 24             	mov    %eax,(%esp)
  800896:	89 54 24 04          	mov    %edx,0x4(%esp)
  80089a:	89 fa                	mov    %edi,%edx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	e8 ec fa ff ff       	call   800390 <printnum>
			break;
  8008a4:	e9 84 fc ff ff       	jmp    80052d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ad:	89 0c 24             	mov    %ecx,(%esp)
  8008b0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b3:	e9 75 fc ff ff       	jmp    80052d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008bc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008ca:	0f 84 5b fc ff ff    	je     80052b <vprintfmt+0x27>
  8008d0:	89 f3                	mov    %esi,%ebx
  8008d2:	83 eb 01             	sub    $0x1,%ebx
  8008d5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008d9:	75 f7                	jne    8008d2 <vprintfmt+0x3ce>
  8008db:	e9 4d fc ff ff       	jmp    80052d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8008e0:	83 c4 3c             	add    $0x3c,%esp
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5f                   	pop    %edi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 28             	sub    $0x28,%esp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800905:	85 c0                	test   %eax,%eax
  800907:	74 30                	je     800939 <vsnprintf+0x51>
  800909:	85 d2                	test   %edx,%edx
  80090b:	7e 2c                	jle    800939 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800914:	8b 45 10             	mov    0x10(%ebp),%eax
  800917:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800922:	c7 04 24 bf 04 80 00 	movl   $0x8004bf,(%esp)
  800929:	e8 d6 fb ff ff       	call   800504 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80092e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800931:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800937:	eb 05                	jmp    80093e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800939:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800946:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800949:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	89 44 24 08          	mov    %eax,0x8(%esp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 04 24             	mov    %eax,(%esp)
  800961:	e8 82 ff ff ff       	call   8008e8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    
  800968:	66 90                	xchg   %ax,%ax
  80096a:	66 90                	xchg   %ax,%ax
  80096c:	66 90                	xchg   %ax,%ax
  80096e:	66 90                	xchg   %ax,%ax

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	80 3a 00             	cmpb   $0x0,(%edx)
  800979:	74 10                	je     80098b <strlen+0x1b>
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800980:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800987:	75 f7                	jne    800980 <strlen+0x10>
  800989:	eb 05                	jmp    800990 <strlen+0x20>
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	53                   	push   %ebx
  800996:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099c:	85 c9                	test   %ecx,%ecx
  80099e:	74 1c                	je     8009bc <strnlen+0x2a>
  8009a0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009a3:	74 1e                	je     8009c3 <strnlen+0x31>
  8009a5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8009aa:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ac:	39 ca                	cmp    %ecx,%edx
  8009ae:	74 18                	je     8009c8 <strnlen+0x36>
  8009b0:	83 c2 01             	add    $0x1,%edx
  8009b3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8009b8:	75 f0                	jne    8009aa <strnlen+0x18>
  8009ba:	eb 0c                	jmp    8009c8 <strnlen+0x36>
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c1:	eb 05                	jmp    8009c8 <strnlen+0x36>
  8009c3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d5:	89 c2                	mov    %eax,%edx
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	83 c1 01             	add    $0x1,%ecx
  8009dd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009e1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e4:	84 db                	test   %bl,%bl
  8009e6:	75 ef                	jne    8009d7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	53                   	push   %ebx
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f5:	89 1c 24             	mov    %ebx,(%esp)
  8009f8:	e8 73 ff ff ff       	call   800970 <strlen>
	strcpy(dst + len, src);
  8009fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a00:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a04:	01 d8                	add    %ebx,%eax
  800a06:	89 04 24             	mov    %eax,(%esp)
  800a09:	e8 bd ff ff ff       	call   8009cb <strcpy>
	return dst;
}
  800a0e:	89 d8                	mov    %ebx,%eax
  800a10:	83 c4 08             	add    $0x8,%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a24:	85 db                	test   %ebx,%ebx
  800a26:	74 17                	je     800a3f <strncpy+0x29>
  800a28:	01 f3                	add    %esi,%ebx
  800a2a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800a2c:	83 c1 01             	add    $0x1,%ecx
  800a2f:	0f b6 02             	movzbl (%edx),%eax
  800a32:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a35:	80 3a 01             	cmpb   $0x1,(%edx)
  800a38:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3b:	39 d9                	cmp    %ebx,%ecx
  800a3d:	75 ed                	jne    800a2c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a3f:	89 f0                	mov    %esi,%eax
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	57                   	push   %edi
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a51:	8b 75 10             	mov    0x10(%ebp),%esi
  800a54:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a56:	85 f6                	test   %esi,%esi
  800a58:	74 34                	je     800a8e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800a5a:	83 fe 01             	cmp    $0x1,%esi
  800a5d:	74 26                	je     800a85 <strlcpy+0x40>
  800a5f:	0f b6 0b             	movzbl (%ebx),%ecx
  800a62:	84 c9                	test   %cl,%cl
  800a64:	74 23                	je     800a89 <strlcpy+0x44>
  800a66:	83 ee 02             	sub    $0x2,%esi
  800a69:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a74:	39 f2                	cmp    %esi,%edx
  800a76:	74 13                	je     800a8b <strlcpy+0x46>
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a7f:	84 c9                	test   %cl,%cl
  800a81:	75 eb                	jne    800a6e <strlcpy+0x29>
  800a83:	eb 06                	jmp    800a8b <strlcpy+0x46>
  800a85:	89 f8                	mov    %edi,%eax
  800a87:	eb 02                	jmp    800a8b <strlcpy+0x46>
  800a89:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a8b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8e:	29 f8                	sub    %edi,%eax
}
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5f                   	pop    %edi
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9e:	0f b6 01             	movzbl (%ecx),%eax
  800aa1:	84 c0                	test   %al,%al
  800aa3:	74 15                	je     800aba <strcmp+0x25>
  800aa5:	3a 02                	cmp    (%edx),%al
  800aa7:	75 11                	jne    800aba <strcmp+0x25>
		p++, q++;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aaf:	0f b6 01             	movzbl (%ecx),%eax
  800ab2:	84 c0                	test   %al,%al
  800ab4:	74 04                	je     800aba <strcmp+0x25>
  800ab6:	3a 02                	cmp    (%edx),%al
  800ab8:	74 ef                	je     800aa9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aba:	0f b6 c0             	movzbl %al,%eax
  800abd:	0f b6 12             	movzbl (%edx),%edx
  800ac0:	29 d0                	sub    %edx,%eax
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	74 29                	je     800aff <strncmp+0x3b>
  800ad6:	0f b6 03             	movzbl (%ebx),%eax
  800ad9:	84 c0                	test   %al,%al
  800adb:	74 30                	je     800b0d <strncmp+0x49>
  800add:	3a 02                	cmp    (%edx),%al
  800adf:	75 2c                	jne    800b0d <strncmp+0x49>
  800ae1:	8d 43 01             	lea    0x1(%ebx),%eax
  800ae4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800ae6:	89 c3                	mov    %eax,%ebx
  800ae8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800aeb:	39 f0                	cmp    %esi,%eax
  800aed:	74 17                	je     800b06 <strncmp+0x42>
  800aef:	0f b6 08             	movzbl (%eax),%ecx
  800af2:	84 c9                	test   %cl,%cl
  800af4:	74 17                	je     800b0d <strncmp+0x49>
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	3a 0a                	cmp    (%edx),%cl
  800afb:	74 e9                	je     800ae6 <strncmp+0x22>
  800afd:	eb 0e                	jmp    800b0d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	eb 0f                	jmp    800b15 <strncmp+0x51>
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0b:	eb 08                	jmp    800b15 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0d:	0f b6 03             	movzbl (%ebx),%eax
  800b10:	0f b6 12             	movzbl (%edx),%edx
  800b13:	29 d0                	sub    %edx,%eax
}
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b23:	0f b6 18             	movzbl (%eax),%ebx
  800b26:	84 db                	test   %bl,%bl
  800b28:	74 1d                	je     800b47 <strchr+0x2e>
  800b2a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b2c:	38 d3                	cmp    %dl,%bl
  800b2e:	75 06                	jne    800b36 <strchr+0x1d>
  800b30:	eb 1a                	jmp    800b4c <strchr+0x33>
  800b32:	38 ca                	cmp    %cl,%dl
  800b34:	74 16                	je     800b4c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	0f b6 10             	movzbl (%eax),%edx
  800b3c:	84 d2                	test   %dl,%dl
  800b3e:	75 f2                	jne    800b32 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	eb 05                	jmp    800b4c <strchr+0x33>
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4c:	5b                   	pop    %ebx
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	53                   	push   %ebx
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b59:	0f b6 18             	movzbl (%eax),%ebx
  800b5c:	84 db                	test   %bl,%bl
  800b5e:	74 16                	je     800b76 <strfind+0x27>
  800b60:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b62:	38 d3                	cmp    %dl,%bl
  800b64:	75 06                	jne    800b6c <strfind+0x1d>
  800b66:	eb 0e                	jmp    800b76 <strfind+0x27>
  800b68:	38 ca                	cmp    %cl,%dl
  800b6a:	74 0a                	je     800b76 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b6c:	83 c0 01             	add    $0x1,%eax
  800b6f:	0f b6 10             	movzbl (%eax),%edx
  800b72:	84 d2                	test   %dl,%dl
  800b74:	75 f2                	jne    800b68 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800b76:	5b                   	pop    %ebx
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b85:	85 c9                	test   %ecx,%ecx
  800b87:	74 36                	je     800bbf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b89:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8f:	75 28                	jne    800bb9 <memset+0x40>
  800b91:	f6 c1 03             	test   $0x3,%cl
  800b94:	75 23                	jne    800bb9 <memset+0x40>
		c &= 0xFF;
  800b96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b9a:	89 d3                	mov    %edx,%ebx
  800b9c:	c1 e3 08             	shl    $0x8,%ebx
  800b9f:	89 d6                	mov    %edx,%esi
  800ba1:	c1 e6 18             	shl    $0x18,%esi
  800ba4:	89 d0                	mov    %edx,%eax
  800ba6:	c1 e0 10             	shl    $0x10,%eax
  800ba9:	09 f0                	or     %esi,%eax
  800bab:	09 c2                	or     %eax,%edx
  800bad:	89 d0                	mov    %edx,%eax
  800baf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bb4:	fc                   	cld    
  800bb5:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb7:	eb 06                	jmp    800bbf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	fc                   	cld    
  800bbd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbf:	89 f8                	mov    %edi,%eax
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd4:	39 c6                	cmp    %eax,%esi
  800bd6:	73 35                	jae    800c0d <memmove+0x47>
  800bd8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bdb:	39 d0                	cmp    %edx,%eax
  800bdd:	73 2e                	jae    800c0d <memmove+0x47>
		s += n;
		d += n;
  800bdf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800be2:	89 d6                	mov    %edx,%esi
  800be4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bec:	75 13                	jne    800c01 <memmove+0x3b>
  800bee:	f6 c1 03             	test   $0x3,%cl
  800bf1:	75 0e                	jne    800c01 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf3:	83 ef 04             	sub    $0x4,%edi
  800bf6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bfc:	fd                   	std    
  800bfd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bff:	eb 09                	jmp    800c0a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c01:	83 ef 01             	sub    $0x1,%edi
  800c04:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c07:	fd                   	std    
  800c08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0a:	fc                   	cld    
  800c0b:	eb 1d                	jmp    800c2a <memmove+0x64>
  800c0d:	89 f2                	mov    %esi,%edx
  800c0f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c11:	f6 c2 03             	test   $0x3,%dl
  800c14:	75 0f                	jne    800c25 <memmove+0x5f>
  800c16:	f6 c1 03             	test   $0x3,%cl
  800c19:	75 0a                	jne    800c25 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c1e:	89 c7                	mov    %eax,%edi
  800c20:	fc                   	cld    
  800c21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c23:	eb 05                	jmp    800c2a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	fc                   	cld    
  800c28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	89 04 24             	mov    %eax,(%esp)
  800c48:	e8 79 ff ff ff       	call   800bc6 <memmove>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800c61:	85 c0                	test   %eax,%eax
  800c63:	74 36                	je     800c9b <memcmp+0x4c>
		if (*s1 != *s2)
  800c65:	0f b6 03             	movzbl (%ebx),%eax
  800c68:	0f b6 0e             	movzbl (%esi),%ecx
  800c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c70:	38 c8                	cmp    %cl,%al
  800c72:	74 1c                	je     800c90 <memcmp+0x41>
  800c74:	eb 10                	jmp    800c86 <memcmp+0x37>
  800c76:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c82:	38 c8                	cmp    %cl,%al
  800c84:	74 0a                	je     800c90 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800c86:	0f b6 c0             	movzbl %al,%eax
  800c89:	0f b6 c9             	movzbl %cl,%ecx
  800c8c:	29 c8                	sub    %ecx,%eax
  800c8e:	eb 10                	jmp    800ca0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c90:	39 fa                	cmp    %edi,%edx
  800c92:	75 e2                	jne    800c76 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c94:	b8 00 00 00 00       	mov    $0x0,%eax
  800c99:	eb 05                	jmp    800ca0 <memcmp+0x51>
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	53                   	push   %ebx
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 13                	jae    800ccb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	89 d9                	mov    %ebx,%ecx
  800cba:	38 18                	cmp    %bl,(%eax)
  800cbc:	75 06                	jne    800cc4 <memfind+0x1f>
  800cbe:	eb 0b                	jmp    800ccb <memfind+0x26>
  800cc0:	38 08                	cmp    %cl,(%eax)
  800cc2:	74 07                	je     800ccb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cc4:	83 c0 01             	add    $0x1,%eax
  800cc7:	39 d0                	cmp    %edx,%eax
  800cc9:	75 f5                	jne    800cc0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cda:	0f b6 0a             	movzbl (%edx),%ecx
  800cdd:	80 f9 09             	cmp    $0x9,%cl
  800ce0:	74 05                	je     800ce7 <strtol+0x19>
  800ce2:	80 f9 20             	cmp    $0x20,%cl
  800ce5:	75 10                	jne    800cf7 <strtol+0x29>
		s++;
  800ce7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cea:	0f b6 0a             	movzbl (%edx),%ecx
  800ced:	80 f9 09             	cmp    $0x9,%cl
  800cf0:	74 f5                	je     800ce7 <strtol+0x19>
  800cf2:	80 f9 20             	cmp    $0x20,%cl
  800cf5:	74 f0                	je     800ce7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cf7:	80 f9 2b             	cmp    $0x2b,%cl
  800cfa:	75 0a                	jne    800d06 <strtol+0x38>
		s++;
  800cfc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800cff:	bf 00 00 00 00       	mov    $0x0,%edi
  800d04:	eb 11                	jmp    800d17 <strtol+0x49>
  800d06:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d0b:	80 f9 2d             	cmp    $0x2d,%cl
  800d0e:	75 07                	jne    800d17 <strtol+0x49>
		s++, neg = 1;
  800d10:	83 c2 01             	add    $0x1,%edx
  800d13:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d17:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d1c:	75 15                	jne    800d33 <strtol+0x65>
  800d1e:	80 3a 30             	cmpb   $0x30,(%edx)
  800d21:	75 10                	jne    800d33 <strtol+0x65>
  800d23:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d27:	75 0a                	jne    800d33 <strtol+0x65>
		s += 2, base = 16;
  800d29:	83 c2 02             	add    $0x2,%edx
  800d2c:	b8 10 00 00 00       	mov    $0x10,%eax
  800d31:	eb 10                	jmp    800d43 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800d33:	85 c0                	test   %eax,%eax
  800d35:	75 0c                	jne    800d43 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d37:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d39:	80 3a 30             	cmpb   $0x30,(%edx)
  800d3c:	75 05                	jne    800d43 <strtol+0x75>
		s++, base = 8;
  800d3e:	83 c2 01             	add    $0x1,%edx
  800d41:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d48:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d4b:	0f b6 0a             	movzbl (%edx),%ecx
  800d4e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d51:	89 f0                	mov    %esi,%eax
  800d53:	3c 09                	cmp    $0x9,%al
  800d55:	77 08                	ja     800d5f <strtol+0x91>
			dig = *s - '0';
  800d57:	0f be c9             	movsbl %cl,%ecx
  800d5a:	83 e9 30             	sub    $0x30,%ecx
  800d5d:	eb 20                	jmp    800d7f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800d5f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d62:	89 f0                	mov    %esi,%eax
  800d64:	3c 19                	cmp    $0x19,%al
  800d66:	77 08                	ja     800d70 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800d68:	0f be c9             	movsbl %cl,%ecx
  800d6b:	83 e9 57             	sub    $0x57,%ecx
  800d6e:	eb 0f                	jmp    800d7f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800d70:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d73:	89 f0                	mov    %esi,%eax
  800d75:	3c 19                	cmp    $0x19,%al
  800d77:	77 16                	ja     800d8f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d79:	0f be c9             	movsbl %cl,%ecx
  800d7c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d7f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d82:	7d 0f                	jge    800d93 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d84:	83 c2 01             	add    $0x1,%edx
  800d87:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d8b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d8d:	eb bc                	jmp    800d4b <strtol+0x7d>
  800d8f:	89 d8                	mov    %ebx,%eax
  800d91:	eb 02                	jmp    800d95 <strtol+0xc7>
  800d93:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d99:	74 05                	je     800da0 <strtol+0xd2>
		*endptr = (char *) s;
  800d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d9e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800da0:	f7 d8                	neg    %eax
  800da2:	85 ff                	test   %edi,%edi
  800da4:	0f 44 c3             	cmove  %ebx,%eax
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	89 c3                	mov    %eax,%ebx
  800dbf:	89 c7                	mov    %eax,%edi
  800dc1:	89 c6                	mov    %eax,%esi
  800dc3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <sys_cgetc>:

int
sys_cgetc(void)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 01 00 00 00       	mov    $0x1,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	89 cb                	mov    %ecx,%ebx
  800e01:	89 cf                	mov    %ecx,%edi
  800e03:	89 ce                	mov    %ecx,%esi
  800e05:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7e 28                	jle    800e33 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e16:	00 
  800e17:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e26:	00 
  800e27:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800e2e:	e8 48 f4 ff ff       	call   80027b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e33:	83 c4 2c             	add    $0x2c,%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e41:	ba 00 00 00 00       	mov    $0x0,%edx
  800e46:	b8 02 00 00 00       	mov    $0x2,%eax
  800e4b:	89 d1                	mov    %edx,%ecx
  800e4d:	89 d3                	mov    %edx,%ebx
  800e4f:	89 d7                	mov    %edx,%edi
  800e51:	89 d6                	mov    %edx,%esi
  800e53:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <sys_yield>:

void
sys_yield(void)
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
  800e65:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e6a:	89 d1                	mov    %edx,%ecx
  800e6c:	89 d3                	mov    %edx,%ebx
  800e6e:	89 d7                	mov    %edx,%edi
  800e70:	89 d6                	mov    %edx,%esi
  800e72:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	89 f7                	mov    %esi,%edi
  800e97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7e 28                	jle    800ec5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ea8:	00 
  800ea9:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb8:	00 
  800eb9:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800ec0:	e8 b6 f3 ff ff       	call   80027b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ec5:	83 c4 2c             	add    $0x2c,%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed6:	b8 05 00 00 00       	mov    $0x5,%eax
  800edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee7:	8b 75 18             	mov    0x18(%ebp),%esi
  800eea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7e 28                	jle    800f18 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800efb:	00 
  800efc:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800f03:	00 
  800f04:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f0b:	00 
  800f0c:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800f13:	e8 63 f3 ff ff       	call   80027b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f18:	83 c4 2c             	add    $0x2c,%esp
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	89 df                	mov    %ebx,%edi
  800f3b:	89 de                	mov    %ebx,%esi
  800f3d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7e 28                	jle    800f6b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f47:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800f56:	00 
  800f57:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f5e:	00 
  800f5f:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800f66:	e8 10 f3 ff ff       	call   80027b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f6b:	83 c4 2c             	add    $0x2c,%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	b8 08 00 00 00       	mov    $0x8,%eax
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7e 28                	jle    800fbe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fa1:	00 
  800fa2:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800fa9:	00 
  800faa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fb1:	00 
  800fb2:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800fb9:	e8 bd f2 ff ff       	call   80027b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fbe:	83 c4 2c             	add    $0x2c,%esp
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
  800fcc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	89 de                	mov    %ebx,%esi
  800fe3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	7e 28                	jle    801011 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fed:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ff4:	00 
  800ff5:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801004:	00 
  801005:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  80100c:	e8 6a f2 ff ff       	call   80027b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801011:	83 c4 2c             	add    $0x2c,%esp
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	b8 0a 00 00 00       	mov    $0xa,%eax
  80102c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	89 df                	mov    %ebx,%edi
  801034:	89 de                	mov    %ebx,%esi
  801036:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7e 28                	jle    801064 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801040:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801047:	00 
  801048:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  80104f:	00 
  801050:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801057:	00 
  801058:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  80105f:	e8 17 f2 ff ff       	call   80027b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801064:	83 c4 2c             	add    $0x2c,%esp
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5f                   	pop    %edi
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801072:	be 00 00 00 00       	mov    $0x0,%esi
  801077:	b8 0c 00 00 00       	mov    $0xc,%eax
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	8b 55 08             	mov    0x8(%ebp),%edx
  801082:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801085:	8b 7d 14             	mov    0x14(%ebp),%edi
  801088:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    

0080108f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	57                   	push   %edi
  801093:	56                   	push   %esi
  801094:	53                   	push   %ebx
  801095:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801098:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109d:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a5:	89 cb                	mov    %ecx,%ebx
  8010a7:	89 cf                	mov    %ecx,%edi
  8010a9:	89 ce                	mov    %ecx,%esi
  8010ab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	7e 28                	jle    8010d9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010bc:	00 
  8010bd:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  8010c4:	00 
  8010c5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010cc:	00 
  8010cd:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  8010d4:	e8 a2 f1 ff ff       	call   80027b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010d9:	83 c4 2c             	add    $0x2c,%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 24             	sub    $0x24,%esp
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010eb:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  8010ed:	89 da                	mov    %ebx,%edx
  8010ef:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  8010f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  8010f9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010fd:	74 05                	je     801104 <pgfault+0x23>
  8010ff:	f6 c6 08             	test   $0x8,%dh
  801102:	75 1c                	jne    801120 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801104:	c7 44 24 08 ec 2a 80 	movl   $0x802aec,0x8(%esp)
  80110b:	00 
  80110c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  80111b:	e8 5b f1 ff ff       	call   80027b <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801120:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801127:	00 
  801128:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80112f:	00 
  801130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801137:	e8 3d fd ff ff       	call   800e79 <sys_page_alloc>
  80113c:	85 c0                	test   %eax,%eax
  80113e:	79 20                	jns    801160 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801140:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801144:	c7 44 24 08 54 2b 80 	movl   $0x802b54,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  80115b:	e8 1b f1 ff ff       	call   80027b <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801160:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801166:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80116d:	00 
  80116e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801172:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801179:	e8 48 fa ff ff       	call   800bc6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80117e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801185:	00 
  801186:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80118a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801191:	00 
  801192:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801199:	00 
  80119a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a1:	e8 27 fd ff ff       	call   800ecd <sys_page_map>
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	79 20                	jns    8011ca <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8011aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ae:	c7 44 24 08 6e 2b 80 	movl   $0x802b6e,0x8(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011bd:	00 
  8011be:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8011c5:	e8 b1 f0 ff ff       	call   80027b <_panic>
	}
}
  8011ca:	83 c4 24             	add    $0x24,%esp
  8011cd:	5b                   	pop    %ebx
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  8011d9:	c7 04 24 e1 10 80 00 	movl   $0x8010e1,(%esp)
  8011e0:	e8 21 10 00 00       	call   802206 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ea:	cd 30                	int    $0x30
  8011ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	79 1c                	jns    80120f <fork+0x3f>
		panic("fork");
  8011f3:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  8011fa:	00 
  8011fb:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801202:	00 
  801203:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  80120a:	e8 6c f0 ff ff       	call   80027b <_panic>
  80120f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801211:	bb 00 08 00 00       	mov    $0x800,%ebx
  801216:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80121a:	75 21                	jne    80123d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80121c:	e8 1a fc ff ff       	call   800e3b <sys_getenvid>
  801221:	25 ff 03 00 00       	and    $0x3ff,%eax
  801226:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801229:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80122e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801233:	b8 00 00 00 00       	mov    $0x0,%eax
  801238:	e9 c5 01 00 00       	jmp    801402 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80123d:	89 d8                	mov    %ebx,%eax
  80123f:	c1 e8 0a             	shr    $0xa,%eax
  801242:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801249:	a8 01                	test   $0x1,%al
  80124b:	0f 84 f2 00 00 00    	je     801343 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801251:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801258:	a8 05                	test   $0x5,%al
  80125a:	0f 84 e3 00 00 00    	je     801343 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801260:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801267:	89 de                	mov    %ebx,%esi
  801269:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80126c:	a9 02 08 00 00       	test   $0x802,%eax
  801271:	0f 84 88 00 00 00    	je     8012ff <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801277:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80127e:	00 
  80127f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801283:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801287:	89 74 24 04          	mov    %esi,0x4(%esp)
  80128b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801292:	e8 36 fc ff ff       	call   800ecd <sys_page_map>
  801297:	85 c0                	test   %eax,%eax
  801299:	79 20                	jns    8012bb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80129b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129f:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  8012a6:	00 
  8012a7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8012ae:	00 
  8012af:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8012b6:	e8 c0 ef ff ff       	call   80027b <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8012bb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012c2:	00 
  8012c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012ce:	00 
  8012cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d3:	89 3c 24             	mov    %edi,(%esp)
  8012d6:	e8 f2 fb ff ff       	call   800ecd <sys_page_map>
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	79 64                	jns    801343 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  8012df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e3:	c7 44 24 08 a6 2b 80 	movl   $0x802ba6,0x8(%esp)
  8012ea:	00 
  8012eb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8012f2:	00 
  8012f3:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8012fa:	e8 7c ef ff ff       	call   80027b <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8012ff:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801306:	00 
  801307:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80130b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80130f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801313:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80131a:	e8 ae fb ff ff       	call   800ecd <sys_page_map>
  80131f:	85 c0                	test   %eax,%eax
  801321:	79 20                	jns    801343 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801323:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801327:	c7 44 24 08 c0 2b 80 	movl   $0x802bc0,0x8(%esp)
  80132e:	00 
  80132f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801336:	00 
  801337:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  80133e:	e8 38 ef ff ff       	call   80027b <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801343:	83 c3 01             	add    $0x1,%ebx
  801346:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80134c:	0f 85 eb fe ff ff    	jne    80123d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801352:	c7 44 24 04 6f 22 80 	movl   $0x80226f,0x4(%esp)
  801359:	00 
  80135a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80135d:	89 04 24             	mov    %eax,(%esp)
  801360:	e8 b4 fc ff ff       	call   801019 <sys_env_set_pgfault_upcall>
  801365:	85 c0                	test   %eax,%eax
  801367:	79 20                	jns    801389 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801369:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80136d:	c7 44 24 08 24 2b 80 	movl   $0x802b24,0x8(%esp)
  801374:	00 
  801375:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80137c:	00 
  80137d:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  801384:	e8 f2 ee ff ff       	call   80027b <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801389:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801390:	00 
  801391:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801398:	ee 
  801399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139c:	89 04 24             	mov    %eax,(%esp)
  80139f:	e8 d5 fa ff ff       	call   800e79 <sys_page_alloc>
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	79 20                	jns    8013c8 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8013a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ac:	c7 44 24 08 d2 2b 80 	movl   $0x802bd2,0x8(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  8013bb:	00 
  8013bc:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8013c3:	e8 b3 ee ff ff       	call   80027b <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8013c8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013cf:	00 
  8013d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d3:	89 04 24             	mov    %eax,(%esp)
  8013d6:	e8 98 fb ff ff       	call   800f73 <sys_env_set_status>
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	79 20                	jns    8013ff <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  8013df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e3:	c7 44 24 08 ea 2b 80 	movl   $0x802bea,0x8(%esp)
  8013ea:	00 
  8013eb:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  8013f2:	00 
  8013f3:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8013fa:	e8 7c ee ff ff       	call   80027b <_panic>
	}

	return envid;
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801402:	83 c4 2c             	add    $0x2c,%esp
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5f                   	pop    %edi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    

0080140a <sfork>:

// Challenge!
int
sfork(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801410:	c7 44 24 08 05 2c 80 	movl   $0x802c05,0x8(%esp)
  801417:	00 
  801418:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80141f:	00 
  801420:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  801427:	e8 4f ee ff ff       	call   80027b <_panic>
  80142c:	66 90                	xchg   %ax,%ax
  80142e:	66 90                	xchg   %ax,%ax

00801430 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80144b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801450:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80145a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80145f:	a8 01                	test   $0x1,%al
  801461:	74 34                	je     801497 <fd_alloc+0x40>
  801463:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801468:	a8 01                	test   $0x1,%al
  80146a:	74 32                	je     80149e <fd_alloc+0x47>
  80146c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801471:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801473:	89 c2                	mov    %eax,%edx
  801475:	c1 ea 16             	shr    $0x16,%edx
  801478:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80147f:	f6 c2 01             	test   $0x1,%dl
  801482:	74 1f                	je     8014a3 <fd_alloc+0x4c>
  801484:	89 c2                	mov    %eax,%edx
  801486:	c1 ea 0c             	shr    $0xc,%edx
  801489:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801490:	f6 c2 01             	test   $0x1,%dl
  801493:	75 1a                	jne    8014af <fd_alloc+0x58>
  801495:	eb 0c                	jmp    8014a3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801497:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80149c:	eb 05                	jmp    8014a3 <fd_alloc+0x4c>
  80149e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	eb 1a                	jmp    8014c9 <fd_alloc+0x72>
  8014af:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014b4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b9:	75 b6                	jne    801471 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014c4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014d1:	83 f8 1f             	cmp    $0x1f,%eax
  8014d4:	77 36                	ja     80150c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014d6:	c1 e0 0c             	shl    $0xc,%eax
  8014d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	c1 ea 16             	shr    $0x16,%edx
  8014e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014ea:	f6 c2 01             	test   $0x1,%dl
  8014ed:	74 24                	je     801513 <fd_lookup+0x48>
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	c1 ea 0c             	shr    $0xc,%edx
  8014f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014fb:	f6 c2 01             	test   $0x1,%dl
  8014fe:	74 1a                	je     80151a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801500:	8b 55 0c             	mov    0xc(%ebp),%edx
  801503:	89 02                	mov    %eax,(%edx)
	return 0;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
  80150a:	eb 13                	jmp    80151f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb 0c                	jmp    80151f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801513:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801518:	eb 05                	jmp    80151f <fd_lookup+0x54>
  80151a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	53                   	push   %ebx
  801525:	83 ec 14             	sub    $0x14,%esp
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80152e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801534:	75 1e                	jne    801554 <dev_lookup+0x33>
  801536:	eb 0e                	jmp    801546 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801538:	b8 20 30 80 00       	mov    $0x803020,%eax
  80153d:	eb 0c                	jmp    80154b <dev_lookup+0x2a>
  80153f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801544:	eb 05                	jmp    80154b <dev_lookup+0x2a>
  801546:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80154b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 38                	jmp    80158c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801554:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80155a:	74 dc                	je     801538 <dev_lookup+0x17>
  80155c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801562:	74 db                	je     80153f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801564:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80156a:	8b 52 48             	mov    0x48(%edx),%edx
  80156d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801571:	89 54 24 04          	mov    %edx,0x4(%esp)
  801575:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  80157c:	e8 f3 ed ff ff       	call   800374 <cprintf>
	*dev = 0;
  801581:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801587:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80158c:	83 c4 14             	add    $0x14,%esp
  80158f:	5b                   	pop    %ebx
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    

00801592 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
  801597:	83 ec 20             	sub    $0x20,%esp
  80159a:	8b 75 08             	mov    0x8(%ebp),%esi
  80159d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015ad:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b0:	89 04 24             	mov    %eax,(%esp)
  8015b3:	e8 13 ff ff ff       	call   8014cb <fd_lookup>
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 05                	js     8015c1 <fd_close+0x2f>
	    || fd != fd2)
  8015bc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015bf:	74 0c                	je     8015cd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015c1:	84 db                	test   %bl,%bl
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	0f 44 c2             	cmove  %edx,%eax
  8015cb:	eb 3f                	jmp    80160c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d4:	8b 06                	mov    (%esi),%eax
  8015d6:	89 04 24             	mov    %eax,(%esp)
  8015d9:	e8 43 ff ff ff       	call   801521 <dev_lookup>
  8015de:	89 c3                	mov    %eax,%ebx
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 16                	js     8015fa <fd_close+0x68>
		if (dev->dev_close)
  8015e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015ea:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	74 07                	je     8015fa <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015f3:	89 34 24             	mov    %esi,(%esp)
  8015f6:	ff d0                	call   *%eax
  8015f8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801605:	e8 16 f9 ff ff       	call   800f20 <sys_page_unmap>
	return r;
  80160a:	89 d8                	mov    %ebx,%eax
}
  80160c:	83 c4 20             	add    $0x20,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 04 24             	mov    %eax,(%esp)
  801626:	e8 a0 fe ff ff       	call   8014cb <fd_lookup>
  80162b:	89 c2                	mov    %eax,%edx
  80162d:	85 d2                	test   %edx,%edx
  80162f:	78 13                	js     801644 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801631:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801638:	00 
  801639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163c:	89 04 24             	mov    %eax,(%esp)
  80163f:	e8 4e ff ff ff       	call   801592 <fd_close>
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <close_all>:

void
close_all(void)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	53                   	push   %ebx
  80164a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80164d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801652:	89 1c 24             	mov    %ebx,(%esp)
  801655:	e8 b9 ff ff ff       	call   801613 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80165a:	83 c3 01             	add    $0x1,%ebx
  80165d:	83 fb 20             	cmp    $0x20,%ebx
  801660:	75 f0                	jne    801652 <close_all+0xc>
		close(i);
}
  801662:	83 c4 14             	add    $0x14,%esp
  801665:	5b                   	pop    %ebx
  801666:	5d                   	pop    %ebp
  801667:	c3                   	ret    

00801668 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	57                   	push   %edi
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801671:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	89 04 24             	mov    %eax,(%esp)
  80167e:	e8 48 fe ff ff       	call   8014cb <fd_lookup>
  801683:	89 c2                	mov    %eax,%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	0f 88 e1 00 00 00    	js     80176e <dup+0x106>
		return r;
	close(newfdnum);
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 7b ff ff ff       	call   801613 <close>

	newfd = INDEX2FD(newfdnum);
  801698:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80169b:	c1 e3 0c             	shl    $0xc,%ebx
  80169e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a7:	89 04 24             	mov    %eax,(%esp)
  8016aa:	e8 91 fd ff ff       	call   801440 <fd2data>
  8016af:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016b1:	89 1c 24             	mov    %ebx,(%esp)
  8016b4:	e8 87 fd ff ff       	call   801440 <fd2data>
  8016b9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016bb:	89 f0                	mov    %esi,%eax
  8016bd:	c1 e8 16             	shr    $0x16,%eax
  8016c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c7:	a8 01                	test   $0x1,%al
  8016c9:	74 43                	je     80170e <dup+0xa6>
  8016cb:	89 f0                	mov    %esi,%eax
  8016cd:	c1 e8 0c             	shr    $0xc,%eax
  8016d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016d7:	f6 c2 01             	test   $0x1,%dl
  8016da:	74 32                	je     80170e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f7:	00 
  8016f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801703:	e8 c5 f7 ff ff       	call   800ecd <sys_page_map>
  801708:	89 c6                	mov    %eax,%esi
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 3e                	js     80174c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80170e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801711:	89 c2                	mov    %eax,%edx
  801713:	c1 ea 0c             	shr    $0xc,%edx
  801716:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80171d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801723:	89 54 24 10          	mov    %edx,0x10(%esp)
  801727:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80172b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801732:	00 
  801733:	89 44 24 04          	mov    %eax,0x4(%esp)
  801737:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173e:	e8 8a f7 ff ff       	call   800ecd <sys_page_map>
  801743:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801745:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801748:	85 f6                	test   %esi,%esi
  80174a:	79 22                	jns    80176e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80174c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801757:	e8 c4 f7 ff ff       	call   800f20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80175c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801767:	e8 b4 f7 ff ff       	call   800f20 <sys_page_unmap>
	return r;
  80176c:	89 f0                	mov    %esi,%eax
}
  80176e:	83 c4 3c             	add    $0x3c,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	53                   	push   %ebx
  80177a:	83 ec 24             	sub    $0x24,%esp
  80177d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801780:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801783:	89 44 24 04          	mov    %eax,0x4(%esp)
  801787:	89 1c 24             	mov    %ebx,(%esp)
  80178a:	e8 3c fd ff ff       	call   8014cb <fd_lookup>
  80178f:	89 c2                	mov    %eax,%edx
  801791:	85 d2                	test   %edx,%edx
  801793:	78 6d                	js     801802 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801795:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	89 04 24             	mov    %eax,(%esp)
  8017a4:	e8 78 fd ff ff       	call   801521 <dev_lookup>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 55                	js     801802 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b0:	8b 50 08             	mov    0x8(%eax),%edx
  8017b3:	83 e2 03             	and    $0x3,%edx
  8017b6:	83 fa 01             	cmp    $0x1,%edx
  8017b9:	75 23                	jne    8017de <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8017c0:	8b 40 48             	mov    0x48(%eax),%eax
  8017c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cb:	c7 04 24 5d 2c 80 00 	movl   $0x802c5d,(%esp)
  8017d2:	e8 9d eb ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  8017d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017dc:	eb 24                	jmp    801802 <read+0x8c>
	}
	if (!dev->dev_read)
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 52 08             	mov    0x8(%edx),%edx
  8017e4:	85 d2                	test   %edx,%edx
  8017e6:	74 15                	je     8017fd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017f6:	89 04 24             	mov    %eax,(%esp)
  8017f9:	ff d2                	call   *%edx
  8017fb:	eb 05                	jmp    801802 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801802:	83 c4 24             	add    $0x24,%esp
  801805:	5b                   	pop    %ebx
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	57                   	push   %edi
  80180c:	56                   	push   %esi
  80180d:	53                   	push   %ebx
  80180e:	83 ec 1c             	sub    $0x1c,%esp
  801811:	8b 7d 08             	mov    0x8(%ebp),%edi
  801814:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801817:	85 f6                	test   %esi,%esi
  801819:	74 33                	je     80184e <readn+0x46>
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801825:	89 f2                	mov    %esi,%edx
  801827:	29 c2                	sub    %eax,%edx
  801829:	89 54 24 08          	mov    %edx,0x8(%esp)
  80182d:	03 45 0c             	add    0xc(%ebp),%eax
  801830:	89 44 24 04          	mov    %eax,0x4(%esp)
  801834:	89 3c 24             	mov    %edi,(%esp)
  801837:	e8 3a ff ff ff       	call   801776 <read>
		if (m < 0)
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 1b                	js     80185b <readn+0x53>
			return m;
		if (m == 0)
  801840:	85 c0                	test   %eax,%eax
  801842:	74 11                	je     801855 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801844:	01 c3                	add    %eax,%ebx
  801846:	89 d8                	mov    %ebx,%eax
  801848:	39 f3                	cmp    %esi,%ebx
  80184a:	72 d9                	jb     801825 <readn+0x1d>
  80184c:	eb 0b                	jmp    801859 <readn+0x51>
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	eb 06                	jmp    80185b <readn+0x53>
  801855:	89 d8                	mov    %ebx,%eax
  801857:	eb 02                	jmp    80185b <readn+0x53>
  801859:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80185b:	83 c4 1c             	add    $0x1c,%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 24             	sub    $0x24,%esp
  80186a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801870:	89 44 24 04          	mov    %eax,0x4(%esp)
  801874:	89 1c 24             	mov    %ebx,(%esp)
  801877:	e8 4f fc ff ff       	call   8014cb <fd_lookup>
  80187c:	89 c2                	mov    %eax,%edx
  80187e:	85 d2                	test   %edx,%edx
  801880:	78 68                	js     8018ea <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801885:	89 44 24 04          	mov    %eax,0x4(%esp)
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	8b 00                	mov    (%eax),%eax
  80188e:	89 04 24             	mov    %eax,(%esp)
  801891:	e8 8b fc ff ff       	call   801521 <dev_lookup>
  801896:	85 c0                	test   %eax,%eax
  801898:	78 50                	js     8018ea <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a1:	75 23                	jne    8018c6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8018a8:	8b 40 48             	mov    0x48(%eax),%eax
  8018ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	c7 04 24 79 2c 80 00 	movl   $0x802c79,(%esp)
  8018ba:	e8 b5 ea ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  8018bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c4:	eb 24                	jmp    8018ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018cc:	85 d2                	test   %edx,%edx
  8018ce:	74 15                	je     8018e5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018de:	89 04 24             	mov    %eax,(%esp)
  8018e1:	ff d2                	call   *%edx
  8018e3:	eb 05                	jmp    8018ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ea:	83 c4 24             	add    $0x24,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	89 04 24             	mov    %eax,(%esp)
  801903:	e8 c3 fb ff ff       	call   8014cb <fd_lookup>
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 0e                	js     80191a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	53                   	push   %ebx
  801920:	83 ec 24             	sub    $0x24,%esp
  801923:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801926:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801929:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192d:	89 1c 24             	mov    %ebx,(%esp)
  801930:	e8 96 fb ff ff       	call   8014cb <fd_lookup>
  801935:	89 c2                	mov    %eax,%edx
  801937:	85 d2                	test   %edx,%edx
  801939:	78 61                	js     80199c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 d2 fb ff ff       	call   801521 <dev_lookup>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 49                	js     80199c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80195a:	75 23                	jne    80197f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80195c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801961:	8b 40 48             	mov    0x48(%eax),%eax
  801964:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  801973:	e8 fc e9 ff ff       	call   800374 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80197d:	eb 1d                	jmp    80199c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80197f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801982:	8b 52 18             	mov    0x18(%edx),%edx
  801985:	85 d2                	test   %edx,%edx
  801987:	74 0e                	je     801997 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80198c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801990:	89 04 24             	mov    %eax,(%esp)
  801993:	ff d2                	call   *%edx
  801995:	eb 05                	jmp    80199c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801997:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80199c:	83 c4 24             	add    $0x24,%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 24             	sub    $0x24,%esp
  8019a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	89 04 24             	mov    %eax,(%esp)
  8019b9:	e8 0d fb ff ff       	call   8014cb <fd_lookup>
  8019be:	89 c2                	mov    %eax,%edx
  8019c0:	85 d2                	test   %edx,%edx
  8019c2:	78 52                	js     801a16 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	8b 00                	mov    (%eax),%eax
  8019d0:	89 04 24             	mov    %eax,(%esp)
  8019d3:	e8 49 fb ff ff       	call   801521 <dev_lookup>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 3a                	js     801a16 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019e3:	74 2c                	je     801a11 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ef:	00 00 00 
	stat->st_isdir = 0;
  8019f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f9:	00 00 00 
	stat->st_dev = dev;
  8019fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a09:	89 14 24             	mov    %edx,(%esp)
  801a0c:	ff 50 14             	call   *0x14(%eax)
  801a0f:	eb 05                	jmp    801a16 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a16:	83 c4 24             	add    $0x24,%esp
  801a19:	5b                   	pop    %ebx
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    

00801a1c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	56                   	push   %esi
  801a20:	53                   	push   %ebx
  801a21:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a24:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a2b:	00 
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	89 04 24             	mov    %eax,(%esp)
  801a32:	e8 e1 01 00 00       	call   801c18 <open>
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	85 db                	test   %ebx,%ebx
  801a3b:	78 1b                	js     801a58 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a44:	89 1c 24             	mov    %ebx,(%esp)
  801a47:	e8 56 ff ff ff       	call   8019a2 <fstat>
  801a4c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a4e:	89 1c 24             	mov    %ebx,(%esp)
  801a51:	e8 bd fb ff ff       	call   801613 <close>
	return r;
  801a56:	89 f0                	mov    %esi,%eax
}
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 10             	sub    $0x10,%esp
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a6b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a72:	75 11                	jne    801a85 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a7b:	e8 0e 09 00 00       	call   80238e <ipc_find_env>
  801a80:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801a85:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8a:	8b 40 48             	mov    0x48(%eax),%eax
  801a8d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801a93:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	c7 04 24 96 2c 80 00 	movl   $0x802c96,(%esp)
  801aa6:	e8 c9 e8 ff ff       	call   800374 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801aab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ab2:	00 
  801ab3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801aba:	00 
  801abb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801abf:	a1 00 40 80 00       	mov    0x804000,%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 5c 08 00 00       	call   802328 <ipc_send>
	cprintf("ipc_send\n");
  801acc:	c7 04 24 ac 2c 80 00 	movl   $0x802cac,(%esp)
  801ad3:	e8 9c e8 ff ff       	call   800374 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801ad8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801adf:	00 
  801ae0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ae4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aeb:	e8 d0 07 00 00       	call   8022c0 <ipc_recv>
}
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 14             	sub    $0x14,%esp
  801afe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	8b 40 0c             	mov    0xc(%eax),%eax
  801b07:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b11:	b8 05 00 00 00       	mov    $0x5,%eax
  801b16:	e8 44 ff ff ff       	call   801a5f <fsipc>
  801b1b:	89 c2                	mov    %eax,%edx
  801b1d:	85 d2                	test   %edx,%edx
  801b1f:	78 2b                	js     801b4c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b21:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b28:	00 
  801b29:	89 1c 24             	mov    %ebx,(%esp)
  801b2c:	e8 9a ee ff ff       	call   8009cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b31:	a1 80 50 80 00       	mov    0x805080,%eax
  801b36:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b3c:	a1 84 50 80 00       	mov    0x805084,%eax
  801b41:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4c:	83 c4 14             	add    $0x14,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5d                   	pop    %ebp
  801b51:	c3                   	ret    

00801b52 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b63:	ba 00 00 00 00       	mov    $0x0,%edx
  801b68:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6d:	e8 ed fe ff ff       	call   801a5f <fsipc>
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	56                   	push   %esi
  801b78:	53                   	push   %ebx
  801b79:	83 ec 10             	sub    $0x10,%esp
  801b7c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8b 40 0c             	mov    0xc(%eax),%eax
  801b85:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b8a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b90:	ba 00 00 00 00       	mov    $0x0,%edx
  801b95:	b8 03 00 00 00       	mov    $0x3,%eax
  801b9a:	e8 c0 fe ff ff       	call   801a5f <fsipc>
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 6a                	js     801c0f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ba5:	39 c6                	cmp    %eax,%esi
  801ba7:	73 24                	jae    801bcd <devfile_read+0x59>
  801ba9:	c7 44 24 0c b6 2c 80 	movl   $0x802cb6,0xc(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 08 bd 2c 80 	movl   $0x802cbd,0x8(%esp)
  801bb8:	00 
  801bb9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801bc0:	00 
  801bc1:	c7 04 24 d2 2c 80 00 	movl   $0x802cd2,(%esp)
  801bc8:	e8 ae e6 ff ff       	call   80027b <_panic>
	assert(r <= PGSIZE);
  801bcd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd2:	7e 24                	jle    801bf8 <devfile_read+0x84>
  801bd4:	c7 44 24 0c dd 2c 80 	movl   $0x802cdd,0xc(%esp)
  801bdb:	00 
  801bdc:	c7 44 24 08 bd 2c 80 	movl   $0x802cbd,0x8(%esp)
  801be3:	00 
  801be4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801beb:	00 
  801bec:	c7 04 24 d2 2c 80 00 	movl   $0x802cd2,(%esp)
  801bf3:	e8 83 e6 ff ff       	call   80027b <_panic>
	memmove(buf, &fsipcbuf, r);
  801bf8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bfc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c03:	00 
  801c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c07:	89 04 24             	mov    %eax,(%esp)
  801c0a:	e8 b7 ef ff ff       	call   800bc6 <memmove>
	return r;
}
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    

00801c18 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 24             	sub    $0x24,%esp
  801c1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c22:	89 1c 24             	mov    %ebx,(%esp)
  801c25:	e8 46 ed ff ff       	call   800970 <strlen>
  801c2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c2f:	7f 60                	jg     801c91 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c34:	89 04 24             	mov    %eax,(%esp)
  801c37:	e8 1b f8 ff ff       	call   801457 <fd_alloc>
  801c3c:	89 c2                	mov    %eax,%edx
  801c3e:	85 d2                	test   %edx,%edx
  801c40:	78 54                	js     801c96 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c46:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801c4d:	e8 79 ed ff ff       	call   8009cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	e8 f8 fd ff ff       	call   801a5f <fsipc>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	79 17                	jns    801c84 <open+0x6c>
		fd_close(fd, 0);
  801c6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c74:	00 
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	89 04 24             	mov    %eax,(%esp)
  801c7b:	e8 12 f9 ff ff       	call   801592 <fd_close>
		return r;
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	eb 12                	jmp    801c96 <open+0x7e>
	}
	return fd2num(fd);
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	e8 a1 f7 ff ff       	call   801430 <fd2num>
  801c8f:	eb 05                	jmp    801c96 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c91:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801c96:	83 c4 24             	add    $0x24,%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 10             	sub    $0x10,%esp
  801ca8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 8a f7 ff ff       	call   801440 <fd2data>
  801cb6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cb8:	c7 44 24 04 e9 2c 80 	movl   $0x802ce9,0x4(%esp)
  801cbf:	00 
  801cc0:	89 1c 24             	mov    %ebx,(%esp)
  801cc3:	e8 03 ed ff ff       	call   8009cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cc8:	8b 46 04             	mov    0x4(%esi),%eax
  801ccb:	2b 06                	sub    (%esi),%eax
  801ccd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cda:	00 00 00 
	stat->st_dev = &devpipe;
  801cdd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ce4:	30 80 00 
	return 0;
}
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 14             	sub    $0x14,%esp
  801cfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d08:	e8 13 f2 ff ff       	call   800f20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d0d:	89 1c 24             	mov    %ebx,(%esp)
  801d10:	e8 2b f7 ff ff       	call   801440 <fd2data>
  801d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d20:	e8 fb f1 ff ff       	call   800f20 <sys_page_unmap>
}
  801d25:	83 c4 14             	add    $0x14,%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 2c             	sub    $0x2c,%esp
  801d34:	89 c6                	mov    %eax,%esi
  801d36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d39:	a1 04 40 80 00       	mov    0x804004,%eax
  801d3e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d41:	89 34 24             	mov    %esi,(%esp)
  801d44:	e8 8d 06 00 00       	call   8023d6 <pageref>
  801d49:	89 c7                	mov    %eax,%edi
  801d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 80 06 00 00       	call   8023d6 <pageref>
  801d56:	39 c7                	cmp    %eax,%edi
  801d58:	0f 94 c2             	sete   %dl
  801d5b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d5e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801d64:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d67:	39 fb                	cmp    %edi,%ebx
  801d69:	74 21                	je     801d8c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d6b:	84 d2                	test   %dl,%dl
  801d6d:	74 ca                	je     801d39 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d6f:	8b 51 58             	mov    0x58(%ecx),%edx
  801d72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d76:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d7e:	c7 04 24 f0 2c 80 00 	movl   $0x802cf0,(%esp)
  801d85:	e8 ea e5 ff ff       	call   800374 <cprintf>
  801d8a:	eb ad                	jmp    801d39 <_pipeisclosed+0xe>
	}
}
  801d8c:	83 c4 2c             	add    $0x2c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 1c             	sub    $0x1c,%esp
  801d9d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801da0:	89 34 24             	mov    %esi,(%esp)
  801da3:	e8 98 f6 ff ff       	call   801440 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801da8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dac:	74 61                	je     801e0f <devpipe_write+0x7b>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	bf 00 00 00 00       	mov    $0x0,%edi
  801db5:	eb 4a                	jmp    801e01 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801db7:	89 da                	mov    %ebx,%edx
  801db9:	89 f0                	mov    %esi,%eax
  801dbb:	e8 6b ff ff ff       	call   801d2b <_pipeisclosed>
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	75 54                	jne    801e18 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801dc4:	e8 91 f0 ff ff       	call   800e5a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dcc:	8b 0b                	mov    (%ebx),%ecx
  801dce:	8d 51 20             	lea    0x20(%ecx),%edx
  801dd1:	39 d0                	cmp    %edx,%eax
  801dd3:	73 e2                	jae    801db7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ddc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ddf:	99                   	cltd   
  801de0:	c1 ea 1b             	shr    $0x1b,%edx
  801de3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801de6:	83 e1 1f             	and    $0x1f,%ecx
  801de9:	29 d1                	sub    %edx,%ecx
  801deb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801def:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801df3:	83 c0 01             	add    $0x1,%eax
  801df6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801df9:	83 c7 01             	add    $0x1,%edi
  801dfc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dff:	74 13                	je     801e14 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e01:	8b 43 04             	mov    0x4(%ebx),%eax
  801e04:	8b 0b                	mov    (%ebx),%ecx
  801e06:	8d 51 20             	lea    0x20(%ecx),%edx
  801e09:	39 d0                	cmp    %edx,%eax
  801e0b:	73 aa                	jae    801db7 <devpipe_write+0x23>
  801e0d:	eb c6                	jmp    801dd5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e0f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e14:	89 f8                	mov    %edi,%eax
  801e16:	eb 05                	jmp    801e1d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e1d:	83 c4 1c             	add    $0x1c,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	57                   	push   %edi
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 1c             	sub    $0x1c,%esp
  801e2e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e31:	89 3c 24             	mov    %edi,(%esp)
  801e34:	e8 07 f6 ff ff       	call   801440 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3d:	74 54                	je     801e93 <devpipe_read+0x6e>
  801e3f:	89 c3                	mov    %eax,%ebx
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
  801e46:	eb 3e                	jmp    801e86 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e48:	89 f0                	mov    %esi,%eax
  801e4a:	eb 55                	jmp    801ea1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e4c:	89 da                	mov    %ebx,%edx
  801e4e:	89 f8                	mov    %edi,%eax
  801e50:	e8 d6 fe ff ff       	call   801d2b <_pipeisclosed>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 43                	jne    801e9c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e59:	e8 fc ef ff ff       	call   800e5a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e5e:	8b 03                	mov    (%ebx),%eax
  801e60:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e63:	74 e7                	je     801e4c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e65:	99                   	cltd   
  801e66:	c1 ea 1b             	shr    $0x1b,%edx
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	83 e0 1f             	and    $0x1f,%eax
  801e6e:	29 d0                	sub    %edx,%eax
  801e70:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e78:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e7b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e7e:	83 c6 01             	add    $0x1,%esi
  801e81:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e84:	74 12                	je     801e98 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801e86:	8b 03                	mov    (%ebx),%eax
  801e88:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e8b:	75 d8                	jne    801e65 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e8d:	85 f6                	test   %esi,%esi
  801e8f:	75 b7                	jne    801e48 <devpipe_read+0x23>
  801e91:	eb b9                	jmp    801e4c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e93:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e98:	89 f0                	mov    %esi,%eax
  801e9a:	eb 05                	jmp    801ea1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	89 04 24             	mov    %eax,(%esp)
  801eb7:	e8 9b f5 ff ff       	call   801457 <fd_alloc>
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	85 d2                	test   %edx,%edx
  801ec0:	0f 88 4d 01 00 00    	js     802013 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ecd:	00 
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edc:	e8 98 ef ff ff       	call   800e79 <sys_page_alloc>
  801ee1:	89 c2                	mov    %eax,%edx
  801ee3:	85 d2                	test   %edx,%edx
  801ee5:	0f 88 28 01 00 00    	js     802013 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801eeb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eee:	89 04 24             	mov    %eax,(%esp)
  801ef1:	e8 61 f5 ff ff       	call   801457 <fd_alloc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 fe 00 00 00    	js     801ffe <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f00:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f07:	00 
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f16:	e8 5e ef ff ff       	call   800e79 <sys_page_alloc>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 d9 00 00 00    	js     801ffe <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 10 f5 ff ff       	call   801440 <fd2data>
  801f30:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f32:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f39:	00 
  801f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f45:	e8 2f ef ff ff       	call   800e79 <sys_page_alloc>
  801f4a:	89 c3                	mov    %eax,%ebx
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	0f 88 97 00 00 00    	js     801feb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f57:	89 04 24             	mov    %eax,(%esp)
  801f5a:	e8 e1 f4 ff ff       	call   801440 <fd2data>
  801f5f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f66:	00 
  801f67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f72:	00 
  801f73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7e:	e8 4a ef ff ff       	call   800ecd <sys_page_map>
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 52                	js     801fdb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f89:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f9e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	89 04 24             	mov    %eax,(%esp)
  801fb9:	e8 72 f4 ff ff       	call   801430 <fd2num>
  801fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc6:	89 04 24             	mov    %eax,(%esp)
  801fc9:	e8 62 f4 ff ff       	call   801430 <fd2num>
  801fce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	eb 38                	jmp    802013 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fdb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe6:	e8 35 ef ff ff       	call   800f20 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff9:	e8 22 ef ff ff       	call   800f20 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	89 44 24 04          	mov    %eax,0x4(%esp)
  802005:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200c:	e8 0f ef ff ff       	call   800f20 <sys_page_unmap>
  802011:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802013:	83 c4 30             	add    $0x30,%esp
  802016:	5b                   	pop    %ebx
  802017:	5e                   	pop    %esi
  802018:	5d                   	pop    %ebp
  802019:	c3                   	ret    

0080201a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802020:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802023:	89 44 24 04          	mov    %eax,0x4(%esp)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	89 04 24             	mov    %eax,(%esp)
  80202d:	e8 99 f4 ff ff       	call   8014cb <fd_lookup>
  802032:	89 c2                	mov    %eax,%edx
  802034:	85 d2                	test   %edx,%edx
  802036:	78 15                	js     80204d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	89 04 24             	mov    %eax,(%esp)
  80203e:	e8 fd f3 ff ff       	call   801440 <fd2data>
	return _pipeisclosed(fd, p);
  802043:	89 c2                	mov    %eax,%edx
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	e8 de fc ff ff       	call   801d2b <_pipeisclosed>
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    
  80204f:	90                   	nop

00802050 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802060:	c7 44 24 04 08 2d 80 	movl   $0x802d08,0x4(%esp)
  802067:	00 
  802068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206b:	89 04 24             	mov    %eax,(%esp)
  80206e:	e8 58 e9 ff ff       	call   8009cb <strcpy>
	return 0;
}
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	57                   	push   %edi
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802086:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208a:	74 4a                	je     8020d6 <devcons_write+0x5c>
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802096:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80209c:	8b 75 10             	mov    0x10(%ebp),%esi
  80209f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8020a1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020a4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020a9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020ac:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020b0:	03 45 0c             	add    0xc(%ebp),%eax
  8020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b7:	89 3c 24             	mov    %edi,(%esp)
  8020ba:	e8 07 eb ff ff       	call   800bc6 <memmove>
		sys_cputs(buf, m);
  8020bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c3:	89 3c 24             	mov    %edi,(%esp)
  8020c6:	e8 e1 ec ff ff       	call   800dac <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020cb:	01 f3                	add    %esi,%ebx
  8020cd:	89 d8                	mov    %ebx,%eax
  8020cf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020d2:	72 c8                	jb     80209c <devcons_write+0x22>
  8020d4:	eb 05                	jmp    8020db <devcons_write+0x61>
  8020d6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    

008020e8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f7:	75 07                	jne    802100 <devcons_read+0x18>
  8020f9:	eb 28                	jmp    802123 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020fb:	e8 5a ed ff ff       	call   800e5a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802100:	e8 c5 ec ff ff       	call   800dca <sys_cgetc>
  802105:	85 c0                	test   %eax,%eax
  802107:	74 f2                	je     8020fb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 16                	js     802123 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80210d:	83 f8 04             	cmp    $0x4,%eax
  802110:	74 0c                	je     80211e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802112:	8b 55 0c             	mov    0xc(%ebp),%edx
  802115:	88 02                	mov    %al,(%edx)
	return 1;
  802117:	b8 01 00 00 00       	mov    $0x1,%eax
  80211c:	eb 05                	jmp    802123 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802138:	00 
  802139:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 68 ec ff ff       	call   800dac <sys_cputs>
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <getchar>:

int
getchar(void)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80214c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802153:	00 
  802154:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802162:	e8 0f f6 ff ff       	call   801776 <read>
	if (r < 0)
  802167:	85 c0                	test   %eax,%eax
  802169:	78 0f                	js     80217a <getchar+0x34>
		return r;
	if (r < 1)
  80216b:	85 c0                	test   %eax,%eax
  80216d:	7e 06                	jle    802175 <getchar+0x2f>
		return -E_EOF;
	return c;
  80216f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802173:	eb 05                	jmp    80217a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802175:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 37 f3 ff ff       	call   8014cb <fd_lookup>
  802194:	85 c0                	test   %eax,%eax
  802196:	78 11                	js     8021a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021a1:	39 10                	cmp    %edx,(%eax)
  8021a3:	0f 94 c0             	sete   %al
  8021a6:	0f b6 c0             	movzbl %al,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <opencons>:

int
opencons(void)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 9b f2 ff ff       	call   801457 <fd_alloc>
		return r;
  8021bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 40                	js     802202 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021c9:	00 
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d8:	e8 9c ec ff ff       	call   800e79 <sys_page_alloc>
		return r;
  8021dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 1f                	js     802202 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021e3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f8:	89 04 24             	mov    %eax,(%esp)
  8021fb:	e8 30 f2 ff ff       	call   801430 <fd2num>
  802200:	89 c2                	mov    %eax,%edx
}
  802202:	89 d0                	mov    %edx,%eax
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80220c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802213:	75 50                	jne    802265 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802215:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80221c:	00 
  80221d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802224:	ee 
  802225:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222c:	e8 48 ec ff ff       	call   800e79 <sys_page_alloc>
  802231:	85 c0                	test   %eax,%eax
  802233:	79 1c                	jns    802251 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802235:	c7 44 24 08 14 2d 80 	movl   $0x802d14,0x8(%esp)
  80223c:	00 
  80223d:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802244:	00 
  802245:	c7 04 24 38 2d 80 00 	movl   $0x802d38,(%esp)
  80224c:	e8 2a e0 ff ff       	call   80027b <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802251:	c7 44 24 04 6f 22 80 	movl   $0x80226f,0x4(%esp)
  802258:	00 
  802259:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802260:	e8 b4 ed ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80226f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802270:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802275:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802277:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80227a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80227c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802281:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802284:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802289:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80228c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80228e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802291:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802293:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802295:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80229a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80229d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8022a2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8022a5:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8022a7:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8022ac:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8022af:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8022b4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8022b7:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8022b9:	83 c4 08             	add    $0x8,%esp
	popal
  8022bc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8022bd:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022be:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022bf:	c3                   	ret    

008022c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 10             	sub    $0x10,%esp
  8022c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022d8:	0f 44 c2             	cmove  %edx,%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 ac ed ff ff       	call   80108f <sys_ipc_recv>
	if (err_code < 0) {
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	79 16                	jns    8022fd <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8022e7:	85 f6                	test   %esi,%esi
  8022e9:	74 06                	je     8022f1 <ipc_recv+0x31>
  8022eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8022f1:	85 db                	test   %ebx,%ebx
  8022f3:	74 2c                	je     802321 <ipc_recv+0x61>
  8022f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022fb:	eb 24                	jmp    802321 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8022fd:	85 f6                	test   %esi,%esi
  8022ff:	74 0a                	je     80230b <ipc_recv+0x4b>
  802301:	a1 04 40 80 00       	mov    0x804004,%eax
  802306:	8b 40 74             	mov    0x74(%eax),%eax
  802309:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80230b:	85 db                	test   %ebx,%ebx
  80230d:	74 0a                	je     802319 <ipc_recv+0x59>
  80230f:	a1 04 40 80 00       	mov    0x804004,%eax
  802314:	8b 40 78             	mov    0x78(%eax),%eax
  802317:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802319:	a1 04 40 80 00       	mov    0x804004,%eax
  80231e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	5b                   	pop    %ebx
  802325:	5e                   	pop    %esi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    

00802328 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	57                   	push   %edi
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 1c             	sub    $0x1c,%esp
  802331:	8b 7d 08             	mov    0x8(%ebp),%edi
  802334:	8b 75 0c             	mov    0xc(%ebp),%esi
  802337:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80233a:	eb 25                	jmp    802361 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  80233c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80233f:	74 20                	je     802361 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802341:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802345:	c7 44 24 08 46 2d 80 	movl   $0x802d46,0x8(%esp)
  80234c:	00 
  80234d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802354:	00 
  802355:	c7 04 24 52 2d 80 00 	movl   $0x802d52,(%esp)
  80235c:	e8 1a df ff ff       	call   80027b <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802361:	85 db                	test   %ebx,%ebx
  802363:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802368:	0f 45 c3             	cmovne %ebx,%eax
  80236b:	8b 55 14             	mov    0x14(%ebp),%edx
  80236e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802372:	89 44 24 08          	mov    %eax,0x8(%esp)
  802376:	89 74 24 04          	mov    %esi,0x4(%esp)
  80237a:	89 3c 24             	mov    %edi,(%esp)
  80237d:	e8 ea ec ff ff       	call   80106c <sys_ipc_try_send>
  802382:	85 c0                	test   %eax,%eax
  802384:	75 b6                	jne    80233c <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802386:	83 c4 1c             	add    $0x1c,%esp
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802394:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802399:	39 c8                	cmp    %ecx,%eax
  80239b:	74 17                	je     8023b4 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8023a2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023ab:	8b 52 50             	mov    0x50(%edx),%edx
  8023ae:	39 ca                	cmp    %ecx,%edx
  8023b0:	75 14                	jne    8023c6 <ipc_find_env+0x38>
  8023b2:	eb 05                	jmp    8023b9 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8023b9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023bc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023c1:	8b 40 40             	mov    0x40(%eax),%eax
  8023c4:	eb 0e                	jmp    8023d4 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023c6:	83 c0 01             	add    $0x1,%eax
  8023c9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ce:	75 d2                	jne    8023a2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023d0:	66 b8 00 00          	mov    $0x0,%ax
}
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023dc:	89 d0                	mov    %edx,%eax
  8023de:	c1 e8 16             	shr    $0x16,%eax
  8023e1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023e8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ed:	f6 c1 01             	test   $0x1,%cl
  8023f0:	74 1d                	je     80240f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023f2:	c1 ea 0c             	shr    $0xc,%edx
  8023f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023fc:	f6 c2 01             	test   $0x1,%dl
  8023ff:	74 0e                	je     80240f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802401:	c1 ea 0c             	shr    $0xc,%edx
  802404:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80240b:	ef 
  80240c:	0f b7 c0             	movzwl %ax,%eax
}
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	66 90                	xchg   %ax,%ax
  802413:	66 90                	xchg   %ax,%ax
  802415:	66 90                	xchg   %ax,%ax
  802417:	66 90                	xchg   %ax,%ax
  802419:	66 90                	xchg   %ax,%ax
  80241b:	66 90                	xchg   %ax,%ax
  80241d:	66 90                	xchg   %ax,%ax
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	8b 44 24 28          	mov    0x28(%esp),%eax
  80242a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80242e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802432:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802436:	85 c0                	test   %eax,%eax
  802438:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80243c:	89 ea                	mov    %ebp,%edx
  80243e:	89 0c 24             	mov    %ecx,(%esp)
  802441:	75 2d                	jne    802470 <__udivdi3+0x50>
  802443:	39 e9                	cmp    %ebp,%ecx
  802445:	77 61                	ja     8024a8 <__udivdi3+0x88>
  802447:	85 c9                	test   %ecx,%ecx
  802449:	89 ce                	mov    %ecx,%esi
  80244b:	75 0b                	jne    802458 <__udivdi3+0x38>
  80244d:	b8 01 00 00 00       	mov    $0x1,%eax
  802452:	31 d2                	xor    %edx,%edx
  802454:	f7 f1                	div    %ecx
  802456:	89 c6                	mov    %eax,%esi
  802458:	31 d2                	xor    %edx,%edx
  80245a:	89 e8                	mov    %ebp,%eax
  80245c:	f7 f6                	div    %esi
  80245e:	89 c5                	mov    %eax,%ebp
  802460:	89 f8                	mov    %edi,%eax
  802462:	f7 f6                	div    %esi
  802464:	89 ea                	mov    %ebp,%edx
  802466:	83 c4 0c             	add    $0xc,%esp
  802469:	5e                   	pop    %esi
  80246a:	5f                   	pop    %edi
  80246b:	5d                   	pop    %ebp
  80246c:	c3                   	ret    
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	39 e8                	cmp    %ebp,%eax
  802472:	77 24                	ja     802498 <__udivdi3+0x78>
  802474:	0f bd e8             	bsr    %eax,%ebp
  802477:	83 f5 1f             	xor    $0x1f,%ebp
  80247a:	75 3c                	jne    8024b8 <__udivdi3+0x98>
  80247c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802480:	39 34 24             	cmp    %esi,(%esp)
  802483:	0f 86 9f 00 00 00    	jbe    802528 <__udivdi3+0x108>
  802489:	39 d0                	cmp    %edx,%eax
  80248b:	0f 82 97 00 00 00    	jb     802528 <__udivdi3+0x108>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	31 d2                	xor    %edx,%edx
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	83 c4 0c             	add    $0xc,%esp
  80249f:	5e                   	pop    %esi
  8024a0:	5f                   	pop    %edi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    
  8024a3:	90                   	nop
  8024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 f8                	mov    %edi,%eax
  8024aa:	f7 f1                	div    %ecx
  8024ac:	31 d2                	xor    %edx,%edx
  8024ae:	83 c4 0c             	add    $0xc,%esp
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    
  8024b5:	8d 76 00             	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	8b 3c 24             	mov    (%esp),%edi
  8024bd:	d3 e0                	shl    %cl,%eax
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c6:	29 e8                	sub    %ebp,%eax
  8024c8:	89 c1                	mov    %eax,%ecx
  8024ca:	d3 ef                	shr    %cl,%edi
  8024cc:	89 e9                	mov    %ebp,%ecx
  8024ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024d2:	8b 3c 24             	mov    (%esp),%edi
  8024d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024d9:	89 d6                	mov    %edx,%esi
  8024db:	d3 e7                	shl    %cl,%edi
  8024dd:	89 c1                	mov    %eax,%ecx
  8024df:	89 3c 24             	mov    %edi,(%esp)
  8024e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024e6:	d3 ee                	shr    %cl,%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	d3 e2                	shl    %cl,%edx
  8024ec:	89 c1                	mov    %eax,%ecx
  8024ee:	d3 ef                	shr    %cl,%edi
  8024f0:	09 d7                	or     %edx,%edi
  8024f2:	89 f2                	mov    %esi,%edx
  8024f4:	89 f8                	mov    %edi,%eax
  8024f6:	f7 74 24 08          	divl   0x8(%esp)
  8024fa:	89 d6                	mov    %edx,%esi
  8024fc:	89 c7                	mov    %eax,%edi
  8024fe:	f7 24 24             	mull   (%esp)
  802501:	39 d6                	cmp    %edx,%esi
  802503:	89 14 24             	mov    %edx,(%esp)
  802506:	72 30                	jb     802538 <__udivdi3+0x118>
  802508:	8b 54 24 04          	mov    0x4(%esp),%edx
  80250c:	89 e9                	mov    %ebp,%ecx
  80250e:	d3 e2                	shl    %cl,%edx
  802510:	39 c2                	cmp    %eax,%edx
  802512:	73 05                	jae    802519 <__udivdi3+0xf9>
  802514:	3b 34 24             	cmp    (%esp),%esi
  802517:	74 1f                	je     802538 <__udivdi3+0x118>
  802519:	89 f8                	mov    %edi,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	e9 7a ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	b8 01 00 00 00       	mov    $0x1,%eax
  80252f:	e9 68 ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	8d 47 ff             	lea    -0x1(%edi),%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	83 c4 0c             	add    $0xc,%esp
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
  802544:	66 90                	xchg   %ax,%ax
  802546:	66 90                	xchg   %ax,%ax
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	83 ec 14             	sub    $0x14,%esp
  802556:	8b 44 24 28          	mov    0x28(%esp),%eax
  80255a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80255e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802562:	89 c7                	mov    %eax,%edi
  802564:	89 44 24 04          	mov    %eax,0x4(%esp)
  802568:	8b 44 24 30          	mov    0x30(%esp),%eax
  80256c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802570:	89 34 24             	mov    %esi,(%esp)
  802573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802577:	85 c0                	test   %eax,%eax
  802579:	89 c2                	mov    %eax,%edx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	75 17                	jne    802598 <__umoddi3+0x48>
  802581:	39 fe                	cmp    %edi,%esi
  802583:	76 4b                	jbe    8025d0 <__umoddi3+0x80>
  802585:	89 c8                	mov    %ecx,%eax
  802587:	89 fa                	mov    %edi,%edx
  802589:	f7 f6                	div    %esi
  80258b:	89 d0                	mov    %edx,%eax
  80258d:	31 d2                	xor    %edx,%edx
  80258f:	83 c4 14             	add    $0x14,%esp
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	66 90                	xchg   %ax,%ax
  802598:	39 f8                	cmp    %edi,%eax
  80259a:	77 54                	ja     8025f0 <__umoddi3+0xa0>
  80259c:	0f bd e8             	bsr    %eax,%ebp
  80259f:	83 f5 1f             	xor    $0x1f,%ebp
  8025a2:	75 5c                	jne    802600 <__umoddi3+0xb0>
  8025a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025a8:	39 3c 24             	cmp    %edi,(%esp)
  8025ab:	0f 87 e7 00 00 00    	ja     802698 <__umoddi3+0x148>
  8025b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025b5:	29 f1                	sub    %esi,%ecx
  8025b7:	19 c7                	sbb    %eax,%edi
  8025b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025c9:	83 c4 14             	add    $0x14,%esp
  8025cc:	5e                   	pop    %esi
  8025cd:	5f                   	pop    %edi
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    
  8025d0:	85 f6                	test   %esi,%esi
  8025d2:	89 f5                	mov    %esi,%ebp
  8025d4:	75 0b                	jne    8025e1 <__umoddi3+0x91>
  8025d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f6                	div    %esi
  8025df:	89 c5                	mov    %eax,%ebp
  8025e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025e5:	31 d2                	xor    %edx,%edx
  8025e7:	f7 f5                	div    %ebp
  8025e9:	89 c8                	mov    %ecx,%eax
  8025eb:	f7 f5                	div    %ebp
  8025ed:	eb 9c                	jmp    80258b <__umoddi3+0x3b>
  8025ef:	90                   	nop
  8025f0:	89 c8                	mov    %ecx,%eax
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	83 c4 14             	add    $0x14,%esp
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
  8025fb:	90                   	nop
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	8b 04 24             	mov    (%esp),%eax
  802603:	be 20 00 00 00       	mov    $0x20,%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	29 ee                	sub    %ebp,%esi
  80260c:	d3 e2                	shl    %cl,%edx
  80260e:	89 f1                	mov    %esi,%ecx
  802610:	d3 e8                	shr    %cl,%eax
  802612:	89 e9                	mov    %ebp,%ecx
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 04 24             	mov    (%esp),%eax
  80261b:	09 54 24 04          	or     %edx,0x4(%esp)
  80261f:	89 fa                	mov    %edi,%edx
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 f1                	mov    %esi,%ecx
  802625:	89 44 24 08          	mov    %eax,0x8(%esp)
  802629:	8b 44 24 10          	mov    0x10(%esp),%eax
  80262d:	d3 ea                	shr    %cl,%edx
  80262f:	89 e9                	mov    %ebp,%ecx
  802631:	d3 e7                	shl    %cl,%edi
  802633:	89 f1                	mov    %esi,%ecx
  802635:	d3 e8                	shr    %cl,%eax
  802637:	89 e9                	mov    %ebp,%ecx
  802639:	09 f8                	or     %edi,%eax
  80263b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80263f:	f7 74 24 04          	divl   0x4(%esp)
  802643:	d3 e7                	shl    %cl,%edi
  802645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802649:	89 d7                	mov    %edx,%edi
  80264b:	f7 64 24 08          	mull   0x8(%esp)
  80264f:	39 d7                	cmp    %edx,%edi
  802651:	89 c1                	mov    %eax,%ecx
  802653:	89 14 24             	mov    %edx,(%esp)
  802656:	72 2c                	jb     802684 <__umoddi3+0x134>
  802658:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80265c:	72 22                	jb     802680 <__umoddi3+0x130>
  80265e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802662:	29 c8                	sub    %ecx,%eax
  802664:	19 d7                	sbb    %edx,%edi
  802666:	89 e9                	mov    %ebp,%ecx
  802668:	89 fa                	mov    %edi,%edx
  80266a:	d3 e8                	shr    %cl,%eax
  80266c:	89 f1                	mov    %esi,%ecx
  80266e:	d3 e2                	shl    %cl,%edx
  802670:	89 e9                	mov    %ebp,%ecx
  802672:	d3 ef                	shr    %cl,%edi
  802674:	09 d0                	or     %edx,%eax
  802676:	89 fa                	mov    %edi,%edx
  802678:	83 c4 14             	add    $0x14,%esp
  80267b:	5e                   	pop    %esi
  80267c:	5f                   	pop    %edi
  80267d:	5d                   	pop    %ebp
  80267e:	c3                   	ret    
  80267f:	90                   	nop
  802680:	39 d7                	cmp    %edx,%edi
  802682:	75 da                	jne    80265e <__umoddi3+0x10e>
  802684:	8b 14 24             	mov    (%esp),%edx
  802687:	89 c1                	mov    %eax,%ecx
  802689:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80268d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802691:	eb cb                	jmp    80265e <__umoddi3+0x10e>
  802693:	90                   	nop
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80269c:	0f 82 0f ff ff ff    	jb     8025b1 <__umoddi3+0x61>
  8026a2:	e9 1a ff ff ff       	jmp    8025c1 <__umoddi3+0x71>
