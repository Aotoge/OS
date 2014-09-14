
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
  80003c:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  800043:	e8 2c 03 00 00       	call   800374 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 36 1e 00 00       	call   801e89 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 ee 26 80 	movl   $0x8026ee,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
  800072:	e8 04 02 00 00       	call   80027b <_panic>
	if ((r = fork()) < 0)
  800077:	e8 54 11 00 00       	call   8011d0 <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 0c 27 80 	movl   $0x80270c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
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
  8000ac:	e8 72 15 00 00       	call   801623 <close>
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
  8000d6:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  8000dd:	e8 92 02 00 00       	call   800374 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 83 15 00 00       	call   801678 <dup>
			sys_yield();
  8000f5:	e8 60 0d 00 00       	call   800e5a <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 1d 15 00 00       	call   801623 <close>
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
  800134:	e8 c1 1e 00 00       	call   801ffa <pipeisclosed>
  800139:	85 c0                	test   %eax,%eax
  80013b:	74 19                	je     800156 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013d:	c7 04 24 19 27 80 00 	movl   $0x802719,(%esp)
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
  80015e:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  800165:	e8 0a 02 00 00       	call   800374 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 85 1e 00 00       	call   801ffa <pipeisclosed>
  800175:	85 c0                	test   %eax,%eax
  800177:	74 1c                	je     800195 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  800179:	c7 44 24 08 c4 26 80 	movl   $0x8026c4,0x8(%esp)
  800180:	00 
  800181:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800188:	00 
  800189:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
  800190:	e8 e6 00 00 00       	call   80027b <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800195:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 34 13 00 00       	call   8014db <fd_lookup>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 4b 27 80 	movl   $0x80274b,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
  8001c6:	e8 b0 00 00 00       	call   80027b <_panic>
	(void) fd2data(fd);
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	89 04 24             	mov    %eax,(%esp)
  8001d1:	e8 7a 12 00 00       	call   801450 <fd2data>
	cprintf("race didn't happen\n");
  8001d6:	c7 04 24 63 27 80 00 	movl   $0x802763,(%esp)
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
  800268:	e8 e9 13 00 00       	call   801656 <close_all>
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
  8002a7:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  8002ae:	e8 c1 00 00 00       	call   800374 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ba:	89 04 24             	mov    %eax,(%esp)
  8002bd:	e8 51 00 00 00       	call   800313 <vcprintf>
	cprintf("\n");
  8002c2:	c7 04 24 c1 2c 80 00 	movl   $0x802cc1,(%esp)
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
  80040c:	e8 ef 1f 00 00       	call   802400 <__udivdi3>
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
  800465:	e8 c6 20 00 00       	call   802530 <__umoddi3>
  80046a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046e:	0f be 80 a7 27 80 00 	movsbl 0x8027a7(%eax),%eax
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
  80058c:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
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
  80063f:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  800646:	85 d2                	test   %edx,%edx
  800648:	75 20                	jne    80066a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80064a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80064e:	c7 44 24 08 bf 27 80 	movl   $0x8027bf,0x8(%esp)
  800655:	00 
  800656:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	89 04 24             	mov    %eax,(%esp)
  800660:	e8 77 fe ff ff       	call   8004dc <printfmt>
  800665:	e9 c3 fe ff ff       	jmp    80052d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80066a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80066e:	c7 44 24 08 8f 2c 80 	movl   $0x802c8f,0x8(%esp)
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
  80069d:	ba b8 27 80 00       	mov    $0x8027b8,%edx
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
  800e17:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e26:	00 
  800e27:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  800ea9:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb8:	00 
  800eb9:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  800efc:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800f03:	00 
  800f04:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f0b:	00 
  800f0c:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  800f4f:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800f56:	00 
  800f57:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f5e:	00 
  800f5f:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  800fa2:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800fa9:	00 
  800faa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fb1:	00 
  800fb2:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  800ff5:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801004:	00 
  801005:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  801048:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  80104f:	00 
  801050:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801057:	00 
  801058:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  8010bd:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  8010c4:	00 
  8010c5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010cc:	00 
  8010cd:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
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
  801104:	c7 44 24 08 cc 2a 80 	movl   $0x802acc,0x8(%esp)
  80110b:	00 
  80110c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
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
  801144:	c7 44 24 08 34 2b 80 	movl   $0x802b34,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
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
  8011ae:	c7 44 24 08 4e 2b 80 	movl   $0x802b4e,0x8(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011bd:	00 
  8011be:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
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
  8011e0:	e8 01 10 00 00       	call   8021e6 <set_pgfault_handler>
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
  8011f3:	c7 44 24 08 67 2b 80 	movl   $0x802b67,0x8(%esp)
  8011fa:	00 
  8011fb:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801202:	00 
  801203:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
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
  801238:	e9 cf 01 00 00       	jmp    80140c <fork+0x23c>
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
  80124b:	0f 84 fc 00 00 00    	je     80134d <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801251:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801258:	a8 05                	test   $0x5,%al
  80125a:	0f 84 ed 00 00 00    	je     80134d <fork+0x17d>
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
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  80126c:	f6 c4 04             	test   $0x4,%ah
  80126f:	0f 85 93 00 00 00    	jne    801308 <fork+0x138>
  801275:	a9 02 08 00 00       	test   $0x802,%eax
  80127a:	0f 84 88 00 00 00    	je     801308 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801280:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801287:	00 
  801288:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80128c:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801290:	89 74 24 04          	mov    %esi,0x4(%esp)
  801294:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80129b:	e8 2d fc ff ff       	call   800ecd <sys_page_map>
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	79 20                	jns    8012c4 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  8012a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a8:	c7 44 24 08 6c 2b 80 	movl   $0x802b6c,0x8(%esp)
  8012af:	00 
  8012b0:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8012b7:	00 
  8012b8:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  8012bf:	e8 b7 ef ff ff       	call   80027b <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8012c4:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012cb:	00 
  8012cc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d7:	00 
  8012d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012dc:	89 3c 24             	mov    %edi,(%esp)
  8012df:	e8 e9 fb ff ff       	call   800ecd <sys_page_map>
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	79 65                	jns    80134d <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  8012e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ec:	c7 44 24 08 86 2b 80 	movl   $0x802b86,0x8(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8012fb:	00 
  8012fc:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  801303:	e8 73 ef ff ff       	call   80027b <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  801308:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80130d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801311:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801315:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801319:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801324:	e8 a4 fb ff ff       	call   800ecd <sys_page_map>
  801329:	85 c0                	test   %eax,%eax
  80132b:	79 20                	jns    80134d <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  80132d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801331:	c7 44 24 08 a0 2b 80 	movl   $0x802ba0,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  801348:	e8 2e ef ff ff       	call   80027b <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  80134d:	83 c3 01             	add    $0x1,%ebx
  801350:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801356:	0f 85 e1 fe ff ff    	jne    80123d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  80135c:	c7 44 24 04 4f 22 80 	movl   $0x80224f,0x4(%esp)
  801363:	00 
  801364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801367:	89 04 24             	mov    %eax,(%esp)
  80136a:	e8 aa fc ff ff       	call   801019 <sys_env_set_pgfault_upcall>
  80136f:	85 c0                	test   %eax,%eax
  801371:	79 20                	jns    801393 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801373:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801377:	c7 44 24 08 04 2b 80 	movl   $0x802b04,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  80138e:	e8 e8 ee ff ff       	call   80027b <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801393:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80139a:	00 
  80139b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013a2:	ee 
  8013a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a6:	89 04 24             	mov    %eax,(%esp)
  8013a9:	e8 cb fa ff ff       	call   800e79 <sys_page_alloc>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	79 20                	jns    8013d2 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8013b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b6:	c7 44 24 08 b2 2b 80 	movl   $0x802bb2,0x8(%esp)
  8013bd:	00 
  8013be:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8013c5:	00 
  8013c6:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  8013cd:	e8 a9 ee ff ff       	call   80027b <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8013d2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013d9:	00 
  8013da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013dd:	89 04 24             	mov    %eax,(%esp)
  8013e0:	e8 8e fb ff ff       	call   800f73 <sys_env_set_status>
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	79 20                	jns    801409 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  8013e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ed:	c7 44 24 08 ca 2b 80 	movl   $0x802bca,0x8(%esp)
  8013f4:	00 
  8013f5:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8013fc:	00 
  8013fd:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  801404:	e8 72 ee ff ff       	call   80027b <_panic>
	}

	return envid;
  801409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80140c:	83 c4 2c             	add    $0x2c,%esp
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <sfork>:

// Challenge!
int
sfork(void)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80141a:	c7 44 24 08 e5 2b 80 	movl   $0x802be5,0x8(%esp)
  801421:	00 
  801422:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  801429:	00 
  80142a:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  801431:	e8 45 ee ff ff       	call   80027b <_panic>
  801436:	66 90                	xchg   %ax,%ax
  801438:	66 90                	xchg   %ax,%ax
  80143a:	66 90                	xchg   %ax,%ax
  80143c:	66 90                	xchg   %ax,%ax
  80143e:	66 90                	xchg   %ax,%ax

00801440 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	05 00 00 00 30       	add    $0x30000000,%eax
  80144b:	c1 e8 0c             	shr    $0xc,%eax
}
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    

00801450 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80145b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801460:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80146a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80146f:	a8 01                	test   $0x1,%al
  801471:	74 34                	je     8014a7 <fd_alloc+0x40>
  801473:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801478:	a8 01                	test   $0x1,%al
  80147a:	74 32                	je     8014ae <fd_alloc+0x47>
  80147c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801481:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801483:	89 c2                	mov    %eax,%edx
  801485:	c1 ea 16             	shr    $0x16,%edx
  801488:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80148f:	f6 c2 01             	test   $0x1,%dl
  801492:	74 1f                	je     8014b3 <fd_alloc+0x4c>
  801494:	89 c2                	mov    %eax,%edx
  801496:	c1 ea 0c             	shr    $0xc,%edx
  801499:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a0:	f6 c2 01             	test   $0x1,%dl
  8014a3:	75 1a                	jne    8014bf <fd_alloc+0x58>
  8014a5:	eb 0c                	jmp    8014b3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8014a7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8014ac:	eb 05                	jmp    8014b3 <fd_alloc+0x4c>
  8014ae:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	eb 1a                	jmp    8014d9 <fd_alloc+0x72>
  8014bf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014c4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014c9:	75 b6                	jne    801481 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    

008014db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014e1:	83 f8 1f             	cmp    $0x1f,%eax
  8014e4:	77 36                	ja     80151c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014e6:	c1 e0 0c             	shl    $0xc,%eax
  8014e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014ee:	89 c2                	mov    %eax,%edx
  8014f0:	c1 ea 16             	shr    $0x16,%edx
  8014f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014fa:	f6 c2 01             	test   $0x1,%dl
  8014fd:	74 24                	je     801523 <fd_lookup+0x48>
  8014ff:	89 c2                	mov    %eax,%edx
  801501:	c1 ea 0c             	shr    $0xc,%edx
  801504:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80150b:	f6 c2 01             	test   $0x1,%dl
  80150e:	74 1a                	je     80152a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	89 02                	mov    %eax,(%edx)
	return 0;
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
  80151a:	eb 13                	jmp    80152f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80151c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801521:	eb 0c                	jmp    80152f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801528:	eb 05                	jmp    80152f <fd_lookup+0x54>
  80152a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    

00801531 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	53                   	push   %ebx
  801535:	83 ec 14             	sub    $0x14,%esp
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80153e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801544:	75 1e                	jne    801564 <dev_lookup+0x33>
  801546:	eb 0e                	jmp    801556 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801548:	b8 20 30 80 00       	mov    $0x803020,%eax
  80154d:	eb 0c                	jmp    80155b <dev_lookup+0x2a>
  80154f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801554:	eb 05                	jmp    80155b <dev_lookup+0x2a>
  801556:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80155b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 38                	jmp    80159c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801564:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80156a:	74 dc                	je     801548 <dev_lookup+0x17>
  80156c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801572:	74 db                	je     80154f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801574:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80157a:	8b 52 48             	mov    0x48(%edx),%edx
  80157d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801581:	89 54 24 04          	mov    %edx,0x4(%esp)
  801585:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  80158c:	e8 e3 ed ff ff       	call   800374 <cprintf>
	*dev = 0;
  801591:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80159c:	83 c4 14             	add    $0x14,%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	56                   	push   %esi
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 20             	sub    $0x20,%esp
  8015aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8015ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015bd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015c0:	89 04 24             	mov    %eax,(%esp)
  8015c3:	e8 13 ff ff ff       	call   8014db <fd_lookup>
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 05                	js     8015d1 <fd_close+0x2f>
	    || fd != fd2)
  8015cc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015cf:	74 0c                	je     8015dd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015d1:	84 db                	test   %bl,%bl
  8015d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d8:	0f 44 c2             	cmove  %edx,%eax
  8015db:	eb 3f                	jmp    80161c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e4:	8b 06                	mov    (%esi),%eax
  8015e6:	89 04 24             	mov    %eax,(%esp)
  8015e9:	e8 43 ff ff ff       	call   801531 <dev_lookup>
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 16                	js     80160a <fd_close+0x68>
		if (dev->dev_close)
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015fa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 07                	je     80160a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801603:	89 34 24             	mov    %esi,(%esp)
  801606:	ff d0                	call   *%eax
  801608:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80160a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80160e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801615:	e8 06 f9 ff ff       	call   800f20 <sys_page_unmap>
	return r;
  80161a:	89 d8                	mov    %ebx,%eax
}
  80161c:	83 c4 20             	add    $0x20,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	89 04 24             	mov    %eax,(%esp)
  801636:	e8 a0 fe ff ff       	call   8014db <fd_lookup>
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	85 d2                	test   %edx,%edx
  80163f:	78 13                	js     801654 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801641:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801648:	00 
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	89 04 24             	mov    %eax,(%esp)
  80164f:	e8 4e ff ff ff       	call   8015a2 <fd_close>
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <close_all>:

void
close_all(void)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	53                   	push   %ebx
  80165a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80165d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801662:	89 1c 24             	mov    %ebx,(%esp)
  801665:	e8 b9 ff ff ff       	call   801623 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80166a:	83 c3 01             	add    $0x1,%ebx
  80166d:	83 fb 20             	cmp    $0x20,%ebx
  801670:	75 f0                	jne    801662 <close_all+0xc>
		close(i);
}
  801672:	83 c4 14             	add    $0x14,%esp
  801675:	5b                   	pop    %ebx
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	57                   	push   %edi
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
  80167e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801681:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	89 04 24             	mov    %eax,(%esp)
  80168e:	e8 48 fe ff ff       	call   8014db <fd_lookup>
  801693:	89 c2                	mov    %eax,%edx
  801695:	85 d2                	test   %edx,%edx
  801697:	0f 88 e1 00 00 00    	js     80177e <dup+0x106>
		return r;
	close(newfdnum);
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 04 24             	mov    %eax,(%esp)
  8016a3:	e8 7b ff ff ff       	call   801623 <close>

	newfd = INDEX2FD(newfdnum);
  8016a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ab:	c1 e3 0c             	shl    $0xc,%ebx
  8016ae:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b7:	89 04 24             	mov    %eax,(%esp)
  8016ba:	e8 91 fd ff ff       	call   801450 <fd2data>
  8016bf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016c1:	89 1c 24             	mov    %ebx,(%esp)
  8016c4:	e8 87 fd ff ff       	call   801450 <fd2data>
  8016c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016cb:	89 f0                	mov    %esi,%eax
  8016cd:	c1 e8 16             	shr    $0x16,%eax
  8016d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016d7:	a8 01                	test   $0x1,%al
  8016d9:	74 43                	je     80171e <dup+0xa6>
  8016db:	89 f0                	mov    %esi,%eax
  8016dd:	c1 e8 0c             	shr    $0xc,%eax
  8016e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016e7:	f6 c2 01             	test   $0x1,%dl
  8016ea:	74 32                	je     80171e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016fc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801700:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801707:	00 
  801708:	89 74 24 04          	mov    %esi,0x4(%esp)
  80170c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801713:	e8 b5 f7 ff ff       	call   800ecd <sys_page_map>
  801718:	89 c6                	mov    %eax,%esi
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 3e                	js     80175c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80171e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801721:	89 c2                	mov    %eax,%edx
  801723:	c1 ea 0c             	shr    $0xc,%edx
  801726:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80172d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801733:	89 54 24 10          	mov    %edx,0x10(%esp)
  801737:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80173b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801742:	00 
  801743:	89 44 24 04          	mov    %eax,0x4(%esp)
  801747:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174e:	e8 7a f7 ff ff       	call   800ecd <sys_page_map>
  801753:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801758:	85 f6                	test   %esi,%esi
  80175a:	79 22                	jns    80177e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80175c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801767:	e8 b4 f7 ff ff       	call   800f20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80176c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801777:	e8 a4 f7 ff ff       	call   800f20 <sys_page_unmap>
	return r;
  80177c:	89 f0                	mov    %esi,%eax
}
  80177e:	83 c4 3c             	add    $0x3c,%esp
  801781:	5b                   	pop    %ebx
  801782:	5e                   	pop    %esi
  801783:	5f                   	pop    %edi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	53                   	push   %ebx
  80178a:	83 ec 24             	sub    $0x24,%esp
  80178d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801790:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801793:	89 44 24 04          	mov    %eax,0x4(%esp)
  801797:	89 1c 24             	mov    %ebx,(%esp)
  80179a:	e8 3c fd ff ff       	call   8014db <fd_lookup>
  80179f:	89 c2                	mov    %eax,%edx
  8017a1:	85 d2                	test   %edx,%edx
  8017a3:	78 6d                	js     801812 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017af:	8b 00                	mov    (%eax),%eax
  8017b1:	89 04 24             	mov    %eax,(%esp)
  8017b4:	e8 78 fd ff ff       	call   801531 <dev_lookup>
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 55                	js     801812 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	8b 50 08             	mov    0x8(%eax),%edx
  8017c3:	83 e2 03             	and    $0x3,%edx
  8017c6:	83 fa 01             	cmp    $0x1,%edx
  8017c9:	75 23                	jne    8017ee <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8017d0:	8b 40 48             	mov    0x48(%eax),%eax
  8017d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017db:	c7 04 24 3d 2c 80 00 	movl   $0x802c3d,(%esp)
  8017e2:	e8 8d eb ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  8017e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ec:	eb 24                	jmp    801812 <read+0x8c>
	}
	if (!dev->dev_read)
  8017ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f1:	8b 52 08             	mov    0x8(%edx),%edx
  8017f4:	85 d2                	test   %edx,%edx
  8017f6:	74 15                	je     80180d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801802:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801806:	89 04 24             	mov    %eax,(%esp)
  801809:	ff d2                	call   *%edx
  80180b:	eb 05                	jmp    801812 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80180d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801812:	83 c4 24             	add    $0x24,%esp
  801815:	5b                   	pop    %ebx
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	57                   	push   %edi
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 1c             	sub    $0x1c,%esp
  801821:	8b 7d 08             	mov    0x8(%ebp),%edi
  801824:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801827:	85 f6                	test   %esi,%esi
  801829:	74 33                	je     80185e <readn+0x46>
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801835:	89 f2                	mov    %esi,%edx
  801837:	29 c2                	sub    %eax,%edx
  801839:	89 54 24 08          	mov    %edx,0x8(%esp)
  80183d:	03 45 0c             	add    0xc(%ebp),%eax
  801840:	89 44 24 04          	mov    %eax,0x4(%esp)
  801844:	89 3c 24             	mov    %edi,(%esp)
  801847:	e8 3a ff ff ff       	call   801786 <read>
		if (m < 0)
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 1b                	js     80186b <readn+0x53>
			return m;
		if (m == 0)
  801850:	85 c0                	test   %eax,%eax
  801852:	74 11                	je     801865 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801854:	01 c3                	add    %eax,%ebx
  801856:	89 d8                	mov    %ebx,%eax
  801858:	39 f3                	cmp    %esi,%ebx
  80185a:	72 d9                	jb     801835 <readn+0x1d>
  80185c:	eb 0b                	jmp    801869 <readn+0x51>
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	eb 06                	jmp    80186b <readn+0x53>
  801865:	89 d8                	mov    %ebx,%eax
  801867:	eb 02                	jmp    80186b <readn+0x53>
  801869:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80186b:	83 c4 1c             	add    $0x1c,%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	83 ec 24             	sub    $0x24,%esp
  80187a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801880:	89 44 24 04          	mov    %eax,0x4(%esp)
  801884:	89 1c 24             	mov    %ebx,(%esp)
  801887:	e8 4f fc ff ff       	call   8014db <fd_lookup>
  80188c:	89 c2                	mov    %eax,%edx
  80188e:	85 d2                	test   %edx,%edx
  801890:	78 68                	js     8018fa <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801895:	89 44 24 04          	mov    %eax,0x4(%esp)
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189c:	8b 00                	mov    (%eax),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 8b fc ff ff       	call   801531 <dev_lookup>
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 50                	js     8018fa <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018b1:	75 23                	jne    8018d6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018b3:	a1 04 40 80 00       	mov    0x804004,%eax
  8018b8:	8b 40 48             	mov    0x48(%eax),%eax
  8018bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c3:	c7 04 24 59 2c 80 00 	movl   $0x802c59,(%esp)
  8018ca:	e8 a5 ea ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  8018cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d4:	eb 24                	jmp    8018fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018dc:	85 d2                	test   %edx,%edx
  8018de:	74 15                	je     8018f5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ee:	89 04 24             	mov    %eax,(%esp)
  8018f1:	ff d2                	call   *%edx
  8018f3:	eb 05                	jmp    8018fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018fa:	83 c4 24             	add    $0x24,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <seek>:

int
seek(int fdnum, off_t offset)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801906:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	89 04 24             	mov    %eax,(%esp)
  801913:	e8 c3 fb ff ff       	call   8014db <fd_lookup>
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 0e                	js     80192a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	53                   	push   %ebx
  801930:	83 ec 24             	sub    $0x24,%esp
  801933:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801936:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801939:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193d:	89 1c 24             	mov    %ebx,(%esp)
  801940:	e8 96 fb ff ff       	call   8014db <fd_lookup>
  801945:	89 c2                	mov    %eax,%edx
  801947:	85 d2                	test   %edx,%edx
  801949:	78 61                	js     8019ac <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	89 04 24             	mov    %eax,(%esp)
  80195a:	e8 d2 fb ff ff       	call   801531 <dev_lookup>
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 49                	js     8019ac <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801966:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80196a:	75 23                	jne    80198f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80196c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801971:	8b 40 48             	mov    0x48(%eax),%eax
  801974:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197c:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801983:	e8 ec e9 ff ff       	call   800374 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198d:	eb 1d                	jmp    8019ac <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80198f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801992:	8b 52 18             	mov    0x18(%edx),%edx
  801995:	85 d2                	test   %edx,%edx
  801997:	74 0e                	je     8019a7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80199c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019a0:	89 04 24             	mov    %eax,(%esp)
  8019a3:	ff d2                	call   *%edx
  8019a5:	eb 05                	jmp    8019ac <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019ac:	83 c4 24             	add    $0x24,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	53                   	push   %ebx
  8019b6:	83 ec 24             	sub    $0x24,%esp
  8019b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	89 04 24             	mov    %eax,(%esp)
  8019c9:	e8 0d fb ff ff       	call   8014db <fd_lookup>
  8019ce:	89 c2                	mov    %eax,%edx
  8019d0:	85 d2                	test   %edx,%edx
  8019d2:	78 52                	js     801a26 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	89 04 24             	mov    %eax,(%esp)
  8019e3:	e8 49 fb ff ff       	call   801531 <dev_lookup>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 3a                	js     801a26 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019f3:	74 2c                	je     801a21 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019f5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ff:	00 00 00 
	stat->st_isdir = 0;
  801a02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a09:	00 00 00 
	stat->st_dev = dev;
  801a0c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a19:	89 14 24             	mov    %edx,(%esp)
  801a1c:	ff 50 14             	call   *0x14(%eax)
  801a1f:	eb 05                	jmp    801a26 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a26:	83 c4 24             	add    $0x24,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
  801a31:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a3b:	00 
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	e8 af 01 00 00       	call   801bf6 <open>
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	85 db                	test   %ebx,%ebx
  801a4b:	78 1b                	js     801a68 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a54:	89 1c 24             	mov    %ebx,(%esp)
  801a57:	e8 56 ff ff ff       	call   8019b2 <fstat>
  801a5c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a5e:	89 1c 24             	mov    %ebx,(%esp)
  801a61:	e8 bd fb ff ff       	call   801623 <close>
	return r;
  801a66:	89 f0                	mov    %esi,%eax
}
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    

00801a6f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 10             	sub    $0x10,%esp
  801a77:	89 c6                	mov    %eax,%esi
  801a79:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a7b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a82:	75 11                	jne    801a95 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a8b:	e8 de 08 00 00       	call   80236e <ipc_find_env>
  801a90:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a95:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a9c:	00 
  801a9d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801aa4:	00 
  801aa5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aa9:	a1 00 40 80 00       	mov    0x804000,%eax
  801aae:	89 04 24             	mov    %eax,(%esp)
  801ab1:	e8 52 08 00 00       	call   802308 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ab6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801abd:	00 
  801abe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac9:	e8 d2 07 00 00       	call   8022a0 <ipc_recv>
}
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 14             	sub    $0x14,%esp
  801adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aea:	ba 00 00 00 00       	mov    $0x0,%edx
  801aef:	b8 05 00 00 00       	mov    $0x5,%eax
  801af4:	e8 76 ff ff ff       	call   801a6f <fsipc>
  801af9:	89 c2                	mov    %eax,%edx
  801afb:	85 d2                	test   %edx,%edx
  801afd:	78 2b                	js     801b2a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b06:	00 
  801b07:	89 1c 24             	mov    %ebx,(%esp)
  801b0a:	e8 bc ee ff ff       	call   8009cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b0f:	a1 80 50 80 00       	mov    0x805080,%eax
  801b14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b1a:	a1 84 50 80 00       	mov    0x805084,%eax
  801b1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	83 c4 14             	add    $0x14,%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4b:	e8 1f ff ff ff       	call   801a6f <fsipc>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	83 ec 10             	sub    $0x10,%esp
  801b5a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8b 40 0c             	mov    0xc(%eax),%eax
  801b63:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b68:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b73:	b8 03 00 00 00       	mov    $0x3,%eax
  801b78:	e8 f2 fe ff ff       	call   801a6f <fsipc>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 6a                	js     801bed <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b83:	39 c6                	cmp    %eax,%esi
  801b85:	73 24                	jae    801bab <devfile_read+0x59>
  801b87:	c7 44 24 0c 76 2c 80 	movl   $0x802c76,0xc(%esp)
  801b8e:	00 
  801b8f:	c7 44 24 08 7d 2c 80 	movl   $0x802c7d,0x8(%esp)
  801b96:	00 
  801b97:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801b9e:	00 
  801b9f:	c7 04 24 92 2c 80 00 	movl   $0x802c92,(%esp)
  801ba6:	e8 d0 e6 ff ff       	call   80027b <_panic>
	assert(r <= PGSIZE);
  801bab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb0:	7e 24                	jle    801bd6 <devfile_read+0x84>
  801bb2:	c7 44 24 0c 9d 2c 80 	movl   $0x802c9d,0xc(%esp)
  801bb9:	00 
  801bba:	c7 44 24 08 7d 2c 80 	movl   $0x802c7d,0x8(%esp)
  801bc1:	00 
  801bc2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801bc9:	00 
  801bca:	c7 04 24 92 2c 80 00 	movl   $0x802c92,(%esp)
  801bd1:	e8 a5 e6 ff ff       	call   80027b <_panic>
	memmove(buf, &fsipcbuf, r);
  801bd6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bda:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801be1:	00 
  801be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be5:	89 04 24             	mov    %eax,(%esp)
  801be8:	e8 d9 ef ff ff       	call   800bc6 <memmove>
	return r;
}
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    

00801bf6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	53                   	push   %ebx
  801bfa:	83 ec 24             	sub    $0x24,%esp
  801bfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c00:	89 1c 24             	mov    %ebx,(%esp)
  801c03:	e8 68 ed ff ff       	call   800970 <strlen>
  801c08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c0d:	7f 60                	jg     801c6f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 4d f8 ff ff       	call   801467 <fd_alloc>
  801c1a:	89 c2                	mov    %eax,%edx
  801c1c:	85 d2                	test   %edx,%edx
  801c1e:	78 54                	js     801c74 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c24:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801c2b:	e8 9b ed ff ff       	call   8009cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c40:	e8 2a fe ff ff       	call   801a6f <fsipc>
  801c45:	89 c3                	mov    %eax,%ebx
  801c47:	85 c0                	test   %eax,%eax
  801c49:	79 17                	jns    801c62 <open+0x6c>
		fd_close(fd, 0);
  801c4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c52:	00 
  801c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c56:	89 04 24             	mov    %eax,(%esp)
  801c59:	e8 44 f9 ff ff       	call   8015a2 <fd_close>
		return r;
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	eb 12                	jmp    801c74 <open+0x7e>
	}
	return fd2num(fd);
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	89 04 24             	mov    %eax,(%esp)
  801c68:	e8 d3 f7 ff ff       	call   801440 <fd2num>
  801c6d:	eb 05                	jmp    801c74 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c6f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801c74:	83 c4 24             	add    $0x24,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	66 90                	xchg   %ax,%ax
  801c7e:	66 90                	xchg   %ax,%ax

00801c80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
  801c88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 ba f7 ff ff       	call   801450 <fd2data>
  801c96:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c98:	c7 44 24 04 a9 2c 80 	movl   $0x802ca9,0x4(%esp)
  801c9f:	00 
  801ca0:	89 1c 24             	mov    %ebx,(%esp)
  801ca3:	e8 23 ed ff ff       	call   8009cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca8:	8b 46 04             	mov    0x4(%esi),%eax
  801cab:	2b 06                	sub    (%esi),%eax
  801cad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cba:	00 00 00 
	stat->st_dev = &devpipe;
  801cbd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cc4:	30 80 00 
	return 0;
}
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 14             	sub    $0x14,%esp
  801cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce8:	e8 33 f2 ff ff       	call   800f20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 5b f7 ff ff       	call   801450 <fd2data>
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d00:	e8 1b f2 ff ff       	call   800f20 <sys_page_unmap>
}
  801d05:	83 c4 14             	add    $0x14,%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    

00801d0b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	57                   	push   %edi
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	83 ec 2c             	sub    $0x2c,%esp
  801d14:	89 c6                	mov    %eax,%esi
  801d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d19:	a1 04 40 80 00       	mov    0x804004,%eax
  801d1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d21:	89 34 24             	mov    %esi,(%esp)
  801d24:	e8 8d 06 00 00       	call   8023b6 <pageref>
  801d29:	89 c7                	mov    %eax,%edi
  801d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 80 06 00 00       	call   8023b6 <pageref>
  801d36:	39 c7                	cmp    %eax,%edi
  801d38:	0f 94 c2             	sete   %dl
  801d3b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d3e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801d44:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d47:	39 fb                	cmp    %edi,%ebx
  801d49:	74 21                	je     801d6c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d4b:	84 d2                	test   %dl,%dl
  801d4d:	74 ca                	je     801d19 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d4f:	8b 51 58             	mov    0x58(%ecx),%edx
  801d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5e:	c7 04 24 b0 2c 80 00 	movl   $0x802cb0,(%esp)
  801d65:	e8 0a e6 ff ff       	call   800374 <cprintf>
  801d6a:	eb ad                	jmp    801d19 <_pipeisclosed+0xe>
	}
}
  801d6c:	83 c4 2c             	add    $0x2c,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	57                   	push   %edi
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 1c             	sub    $0x1c,%esp
  801d7d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801d80:	89 34 24             	mov    %esi,(%esp)
  801d83:	e8 c8 f6 ff ff       	call   801450 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d8c:	74 61                	je     801def <devpipe_write+0x7b>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	bf 00 00 00 00       	mov    $0x0,%edi
  801d95:	eb 4a                	jmp    801de1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	e8 6b ff ff ff       	call   801d0b <_pipeisclosed>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 54                	jne    801df8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801da4:	e8 b1 f0 ff ff       	call   800e5a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dac:	8b 0b                	mov    (%ebx),%ecx
  801dae:	8d 51 20             	lea    0x20(%ecx),%edx
  801db1:	39 d0                	cmp    %edx,%eax
  801db3:	73 e2                	jae    801d97 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dbc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dbf:	99                   	cltd   
  801dc0:	c1 ea 1b             	shr    $0x1b,%edx
  801dc3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801dc6:	83 e1 1f             	and    $0x1f,%ecx
  801dc9:	29 d1                	sub    %edx,%ecx
  801dcb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801dcf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801dd3:	83 c0 01             	add    $0x1,%eax
  801dd6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dd9:	83 c7 01             	add    $0x1,%edi
  801ddc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ddf:	74 13                	je     801df4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de1:	8b 43 04             	mov    0x4(%ebx),%eax
  801de4:	8b 0b                	mov    (%ebx),%ecx
  801de6:	8d 51 20             	lea    0x20(%ecx),%edx
  801de9:	39 d0                	cmp    %edx,%eax
  801deb:	73 aa                	jae    801d97 <devpipe_write+0x23>
  801ded:	eb c6                	jmp    801db5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801def:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801df4:	89 f8                	mov    %edi,%eax
  801df6:	eb 05                	jmp    801dfd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    

00801e05 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	57                   	push   %edi
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 1c             	sub    $0x1c,%esp
  801e0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e11:	89 3c 24             	mov    %edi,(%esp)
  801e14:	e8 37 f6 ff ff       	call   801450 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e1d:	74 54                	je     801e73 <devpipe_read+0x6e>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
  801e26:	eb 3e                	jmp    801e66 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e28:	89 f0                	mov    %esi,%eax
  801e2a:	eb 55                	jmp    801e81 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	89 f8                	mov    %edi,%eax
  801e30:	e8 d6 fe ff ff       	call   801d0b <_pipeisclosed>
  801e35:	85 c0                	test   %eax,%eax
  801e37:	75 43                	jne    801e7c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e39:	e8 1c f0 ff ff       	call   800e5a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e3e:	8b 03                	mov    (%ebx),%eax
  801e40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e43:	74 e7                	je     801e2c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e45:	99                   	cltd   
  801e46:	c1 ea 1b             	shr    $0x1b,%edx
  801e49:	01 d0                	add    %edx,%eax
  801e4b:	83 e0 1f             	and    $0x1f,%eax
  801e4e:	29 d0                	sub    %edx,%eax
  801e50:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e58:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e5b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e5e:	83 c6 01             	add    $0x1,%esi
  801e61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e64:	74 12                	je     801e78 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801e66:	8b 03                	mov    (%ebx),%eax
  801e68:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e6b:	75 d8                	jne    801e45 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e6d:	85 f6                	test   %esi,%esi
  801e6f:	75 b7                	jne    801e28 <devpipe_read+0x23>
  801e71:	eb b9                	jmp    801e2c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e73:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e78:	89 f0                	mov    %esi,%eax
  801e7a:	eb 05                	jmp    801e81 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e81:	83 c4 1c             	add    $0x1c,%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e94:	89 04 24             	mov    %eax,(%esp)
  801e97:	e8 cb f5 ff ff       	call   801467 <fd_alloc>
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	85 d2                	test   %edx,%edx
  801ea0:	0f 88 4d 01 00 00    	js     801ff3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ead:	00 
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebc:	e8 b8 ef ff ff       	call   800e79 <sys_page_alloc>
  801ec1:	89 c2                	mov    %eax,%edx
  801ec3:	85 d2                	test   %edx,%edx
  801ec5:	0f 88 28 01 00 00    	js     801ff3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ece:	89 04 24             	mov    %eax,(%esp)
  801ed1:	e8 91 f5 ff ff       	call   801467 <fd_alloc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 88 fe 00 00 00    	js     801fde <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee7:	00 
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef6:	e8 7e ef ff ff       	call   800e79 <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 d9 00 00 00    	js     801fde <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 40 f5 ff ff       	call   801450 <fd2data>
  801f10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f19:	00 
  801f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f25:	e8 4f ef ff ff       	call   800e79 <sys_page_alloc>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 97 00 00 00    	js     801fcb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	89 04 24             	mov    %eax,(%esp)
  801f3a:	e8 11 f5 ff ff       	call   801450 <fd2data>
  801f3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f46:	00 
  801f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f52:	00 
  801f53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5e:	e8 6a ef ff ff       	call   800ecd <sys_page_map>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 52                	js     801fbb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 a2 f4 ff ff       	call   801440 <fd2num>
  801f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 92 f4 ff ff       	call   801440 <fd2num>
  801fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	eb 38                	jmp    801ff3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 55 ef ff ff       	call   800f20 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd9:	e8 42 ef ff ff       	call   800f20 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 2f ef ff ff       	call   800f20 <sys_page_unmap>
  801ff1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801ff3:	83 c4 30             	add    $0x30,%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5e                   	pop    %esi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802000:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 c9 f4 ff ff       	call   8014db <fd_lookup>
  802012:	89 c2                	mov    %eax,%edx
  802014:	85 d2                	test   %edx,%edx
  802016:	78 15                	js     80202d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	89 04 24             	mov    %eax,(%esp)
  80201e:	e8 2d f4 ff ff       	call   801450 <fd2data>
	return _pipeisclosed(fd, p);
  802023:	89 c2                	mov    %eax,%edx
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	e8 de fc ff ff       	call   801d0b <_pipeisclosed>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    
  80202f:	90                   	nop

00802030 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802040:	c7 44 24 04 c8 2c 80 	movl   $0x802cc8,0x4(%esp)
  802047:	00 
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	89 04 24             	mov    %eax,(%esp)
  80204e:	e8 78 e9 ff ff       	call   8009cb <strcpy>
	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802066:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206a:	74 4a                	je     8020b6 <devcons_write+0x5c>
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802076:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80207c:	8b 75 10             	mov    0x10(%ebp),%esi
  80207f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802081:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802084:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802089:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80208c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802090:	03 45 0c             	add    0xc(%ebp),%eax
  802093:	89 44 24 04          	mov    %eax,0x4(%esp)
  802097:	89 3c 24             	mov    %edi,(%esp)
  80209a:	e8 27 eb ff ff       	call   800bc6 <memmove>
		sys_cputs(buf, m);
  80209f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020a3:	89 3c 24             	mov    %edi,(%esp)
  8020a6:	e8 01 ed ff ff       	call   800dac <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020ab:	01 f3                	add    %esi,%ebx
  8020ad:	89 d8                	mov    %ebx,%eax
  8020af:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020b2:	72 c8                	jb     80207c <devcons_write+0x22>
  8020b4:	eb 05                	jmp    8020bb <devcons_write+0x61>
  8020b6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020bb:	89 d8                	mov    %ebx,%eax
  8020bd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5f                   	pop    %edi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d7:	75 07                	jne    8020e0 <devcons_read+0x18>
  8020d9:	eb 28                	jmp    802103 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020db:	e8 7a ed ff ff       	call   800e5a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8020e0:	e8 e5 ec ff ff       	call   800dca <sys_cgetc>
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 f2                	je     8020db <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	78 16                	js     802103 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8020ed:	83 f8 04             	cmp    $0x4,%eax
  8020f0:	74 0c                	je     8020fe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8020f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f5:	88 02                	mov    %al,(%edx)
	return 1;
  8020f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fc:	eb 05                	jmp    802103 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802111:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802118:	00 
  802119:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211c:	89 04 24             	mov    %eax,(%esp)
  80211f:	e8 88 ec ff ff       	call   800dac <sys_cputs>
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <getchar>:

int
getchar(void)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80212c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802133:	00 
  802134:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802142:	e8 3f f6 ff ff       	call   801786 <read>
	if (r < 0)
  802147:	85 c0                	test   %eax,%eax
  802149:	78 0f                	js     80215a <getchar+0x34>
		return r;
	if (r < 1)
  80214b:	85 c0                	test   %eax,%eax
  80214d:	7e 06                	jle    802155 <getchar+0x2f>
		return -E_EOF;
	return c;
  80214f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802153:	eb 05                	jmp    80215a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802155:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802162:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802165:	89 44 24 04          	mov    %eax,0x4(%esp)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	89 04 24             	mov    %eax,(%esp)
  80216f:	e8 67 f3 ff ff       	call   8014db <fd_lookup>
  802174:	85 c0                	test   %eax,%eax
  802176:	78 11                	js     802189 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802181:	39 10                	cmp    %edx,(%eax)
  802183:	0f 94 c0             	sete   %al
  802186:	0f b6 c0             	movzbl %al,%eax
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <opencons>:

int
opencons(void)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802191:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802194:	89 04 24             	mov    %eax,(%esp)
  802197:	e8 cb f2 ff ff       	call   801467 <fd_alloc>
		return r;
  80219c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 40                	js     8021e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021a9:	00 
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b8:	e8 bc ec ff ff       	call   800e79 <sys_page_alloc>
		return r;
  8021bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 1f                	js     8021e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021c3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021d8:	89 04 24             	mov    %eax,(%esp)
  8021db:	e8 60 f2 ff ff       	call   801440 <fd2num>
  8021e0:	89 c2                	mov    %eax,%edx
}
  8021e2:	89 d0                	mov    %edx,%eax
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  8021ec:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021f3:	75 50                	jne    802245 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8021f5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021fc:	00 
  8021fd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802204:	ee 
  802205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220c:	e8 68 ec ff ff       	call   800e79 <sys_page_alloc>
  802211:	85 c0                	test   %eax,%eax
  802213:	79 1c                	jns    802231 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802215:	c7 44 24 08 d4 2c 80 	movl   $0x802cd4,0x8(%esp)
  80221c:	00 
  80221d:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802224:	00 
  802225:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  80222c:	e8 4a e0 ff ff       	call   80027b <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802231:	c7 44 24 04 4f 22 80 	movl   $0x80224f,0x4(%esp)
  802238:	00 
  802239:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802240:	e8 d4 ed ff ff       	call   801019 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80224f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802250:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802255:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802257:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80225a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80225c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802261:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802264:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802269:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80226c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80226e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802271:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802273:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802275:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80227a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80227d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802282:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802285:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802287:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80228c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80228f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802294:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802297:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802299:	83 c4 08             	add    $0x8,%esp
	popal
  80229c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80229d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80229e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80229f:	c3                   	ret    

008022a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	56                   	push   %esi
  8022a4:	53                   	push   %ebx
  8022a5:	83 ec 10             	sub    $0x10,%esp
  8022a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022b8:	0f 44 c2             	cmove  %edx,%eax
  8022bb:	89 04 24             	mov    %eax,(%esp)
  8022be:	e8 cc ed ff ff       	call   80108f <sys_ipc_recv>
	if (err_code < 0) {
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	79 16                	jns    8022dd <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8022c7:	85 f6                	test   %esi,%esi
  8022c9:	74 06                	je     8022d1 <ipc_recv+0x31>
  8022cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8022d1:	85 db                	test   %ebx,%ebx
  8022d3:	74 2c                	je     802301 <ipc_recv+0x61>
  8022d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022db:	eb 24                	jmp    802301 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8022dd:	85 f6                	test   %esi,%esi
  8022df:	74 0a                	je     8022eb <ipc_recv+0x4b>
  8022e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8022e6:	8b 40 74             	mov    0x74(%eax),%eax
  8022e9:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8022eb:	85 db                	test   %ebx,%ebx
  8022ed:	74 0a                	je     8022f9 <ipc_recv+0x59>
  8022ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8022f4:	8b 40 78             	mov    0x78(%eax),%eax
  8022f7:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8022f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8022fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	5b                   	pop    %ebx
  802305:	5e                   	pop    %esi
  802306:	5d                   	pop    %ebp
  802307:	c3                   	ret    

00802308 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	57                   	push   %edi
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	83 ec 1c             	sub    $0x1c,%esp
  802311:	8b 7d 08             	mov    0x8(%ebp),%edi
  802314:	8b 75 0c             	mov    0xc(%ebp),%esi
  802317:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80231a:	eb 25                	jmp    802341 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  80231c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80231f:	74 20                	je     802341 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802321:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802325:	c7 44 24 08 06 2d 80 	movl   $0x802d06,0x8(%esp)
  80232c:	00 
  80232d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802334:	00 
  802335:	c7 04 24 12 2d 80 00 	movl   $0x802d12,(%esp)
  80233c:	e8 3a df ff ff       	call   80027b <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802341:	85 db                	test   %ebx,%ebx
  802343:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802348:	0f 45 c3             	cmovne %ebx,%eax
  80234b:	8b 55 14             	mov    0x14(%ebp),%edx
  80234e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802352:	89 44 24 08          	mov    %eax,0x8(%esp)
  802356:	89 74 24 04          	mov    %esi,0x4(%esp)
  80235a:	89 3c 24             	mov    %edi,(%esp)
  80235d:	e8 0a ed ff ff       	call   80106c <sys_ipc_try_send>
  802362:	85 c0                	test   %eax,%eax
  802364:	75 b6                	jne    80231c <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802366:	83 c4 1c             	add    $0x1c,%esp
  802369:	5b                   	pop    %ebx
  80236a:	5e                   	pop    %esi
  80236b:	5f                   	pop    %edi
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802374:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802379:	39 c8                	cmp    %ecx,%eax
  80237b:	74 17                	je     802394 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80237d:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802382:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802385:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80238b:	8b 52 50             	mov    0x50(%edx),%edx
  80238e:	39 ca                	cmp    %ecx,%edx
  802390:	75 14                	jne    8023a6 <ipc_find_env+0x38>
  802392:	eb 05                	jmp    802399 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802399:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80239c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023a1:	8b 40 40             	mov    0x40(%eax),%eax
  8023a4:	eb 0e                	jmp    8023b4 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023a6:	83 c0 01             	add    $0x1,%eax
  8023a9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ae:	75 d2                	jne    802382 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023b0:	66 b8 00 00          	mov    $0x0,%ax
}
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    

008023b6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023bc:	89 d0                	mov    %edx,%eax
  8023be:	c1 e8 16             	shr    $0x16,%eax
  8023c1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023cd:	f6 c1 01             	test   $0x1,%cl
  8023d0:	74 1d                	je     8023ef <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023d2:	c1 ea 0c             	shr    $0xc,%edx
  8023d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023dc:	f6 c2 01             	test   $0x1,%dl
  8023df:	74 0e                	je     8023ef <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e1:	c1 ea 0c             	shr    $0xc,%edx
  8023e4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023eb:	ef 
  8023ec:	0f b7 c0             	movzwl %ax,%eax
}
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	66 90                	xchg   %ax,%ax
  8023f3:	66 90                	xchg   %ax,%ax
  8023f5:	66 90                	xchg   %ax,%ax
  8023f7:	66 90                	xchg   %ax,%ax
  8023f9:	66 90                	xchg   %ax,%ax
  8023fb:	66 90                	xchg   %ax,%ax
  8023fd:	66 90                	xchg   %ax,%ax
  8023ff:	90                   	nop

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	83 ec 0c             	sub    $0xc,%esp
  802406:	8b 44 24 28          	mov    0x28(%esp),%eax
  80240a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80240e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802412:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802416:	85 c0                	test   %eax,%eax
  802418:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80241c:	89 ea                	mov    %ebp,%edx
  80241e:	89 0c 24             	mov    %ecx,(%esp)
  802421:	75 2d                	jne    802450 <__udivdi3+0x50>
  802423:	39 e9                	cmp    %ebp,%ecx
  802425:	77 61                	ja     802488 <__udivdi3+0x88>
  802427:	85 c9                	test   %ecx,%ecx
  802429:	89 ce                	mov    %ecx,%esi
  80242b:	75 0b                	jne    802438 <__udivdi3+0x38>
  80242d:	b8 01 00 00 00       	mov    $0x1,%eax
  802432:	31 d2                	xor    %edx,%edx
  802434:	f7 f1                	div    %ecx
  802436:	89 c6                	mov    %eax,%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	89 e8                	mov    %ebp,%eax
  80243c:	f7 f6                	div    %esi
  80243e:	89 c5                	mov    %eax,%ebp
  802440:	89 f8                	mov    %edi,%eax
  802442:	f7 f6                	div    %esi
  802444:	89 ea                	mov    %ebp,%edx
  802446:	83 c4 0c             	add    $0xc,%esp
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	39 e8                	cmp    %ebp,%eax
  802452:	77 24                	ja     802478 <__udivdi3+0x78>
  802454:	0f bd e8             	bsr    %eax,%ebp
  802457:	83 f5 1f             	xor    $0x1f,%ebp
  80245a:	75 3c                	jne    802498 <__udivdi3+0x98>
  80245c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802460:	39 34 24             	cmp    %esi,(%esp)
  802463:	0f 86 9f 00 00 00    	jbe    802508 <__udivdi3+0x108>
  802469:	39 d0                	cmp    %edx,%eax
  80246b:	0f 82 97 00 00 00    	jb     802508 <__udivdi3+0x108>
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	31 c0                	xor    %eax,%eax
  80247c:	83 c4 0c             	add    $0xc,%esp
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    
  802483:	90                   	nop
  802484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 f8                	mov    %edi,%eax
  80248a:	f7 f1                	div    %ecx
  80248c:	31 d2                	xor    %edx,%edx
  80248e:	83 c4 0c             	add    $0xc,%esp
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	8b 3c 24             	mov    (%esp),%edi
  80249d:	d3 e0                	shl    %cl,%eax
  80249f:	89 c6                	mov    %eax,%esi
  8024a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a6:	29 e8                	sub    %ebp,%eax
  8024a8:	89 c1                	mov    %eax,%ecx
  8024aa:	d3 ef                	shr    %cl,%edi
  8024ac:	89 e9                	mov    %ebp,%ecx
  8024ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024b2:	8b 3c 24             	mov    (%esp),%edi
  8024b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024b9:	89 d6                	mov    %edx,%esi
  8024bb:	d3 e7                	shl    %cl,%edi
  8024bd:	89 c1                	mov    %eax,%ecx
  8024bf:	89 3c 24             	mov    %edi,(%esp)
  8024c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024c6:	d3 ee                	shr    %cl,%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	d3 e2                	shl    %cl,%edx
  8024cc:	89 c1                	mov    %eax,%ecx
  8024ce:	d3 ef                	shr    %cl,%edi
  8024d0:	09 d7                	or     %edx,%edi
  8024d2:	89 f2                	mov    %esi,%edx
  8024d4:	89 f8                	mov    %edi,%eax
  8024d6:	f7 74 24 08          	divl   0x8(%esp)
  8024da:	89 d6                	mov    %edx,%esi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	f7 24 24             	mull   (%esp)
  8024e1:	39 d6                	cmp    %edx,%esi
  8024e3:	89 14 24             	mov    %edx,(%esp)
  8024e6:	72 30                	jb     802518 <__udivdi3+0x118>
  8024e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	d3 e2                	shl    %cl,%edx
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 05                	jae    8024f9 <__udivdi3+0xf9>
  8024f4:	3b 34 24             	cmp    (%esp),%esi
  8024f7:	74 1f                	je     802518 <__udivdi3+0x118>
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	e9 7a ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	b8 01 00 00 00       	mov    $0x1,%eax
  80250f:	e9 68 ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	8d 47 ff             	lea    -0x1(%edi),%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	83 c4 0c             	add    $0xc,%esp
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	66 90                	xchg   %ax,%ax
  802526:	66 90                	xchg   %ax,%ax
  802528:	66 90                	xchg   %ax,%ax
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	83 ec 14             	sub    $0x14,%esp
  802536:	8b 44 24 28          	mov    0x28(%esp),%eax
  80253a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80253e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802542:	89 c7                	mov    %eax,%edi
  802544:	89 44 24 04          	mov    %eax,0x4(%esp)
  802548:	8b 44 24 30          	mov    0x30(%esp),%eax
  80254c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802550:	89 34 24             	mov    %esi,(%esp)
  802553:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802557:	85 c0                	test   %eax,%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255f:	75 17                	jne    802578 <__umoddi3+0x48>
  802561:	39 fe                	cmp    %edi,%esi
  802563:	76 4b                	jbe    8025b0 <__umoddi3+0x80>
  802565:	89 c8                	mov    %ecx,%eax
  802567:	89 fa                	mov    %edi,%edx
  802569:	f7 f6                	div    %esi
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	31 d2                	xor    %edx,%edx
  80256f:	83 c4 14             	add    $0x14,%esp
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	66 90                	xchg   %ax,%ax
  802578:	39 f8                	cmp    %edi,%eax
  80257a:	77 54                	ja     8025d0 <__umoddi3+0xa0>
  80257c:	0f bd e8             	bsr    %eax,%ebp
  80257f:	83 f5 1f             	xor    $0x1f,%ebp
  802582:	75 5c                	jne    8025e0 <__umoddi3+0xb0>
  802584:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802588:	39 3c 24             	cmp    %edi,(%esp)
  80258b:	0f 87 e7 00 00 00    	ja     802678 <__umoddi3+0x148>
  802591:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802595:	29 f1                	sub    %esi,%ecx
  802597:	19 c7                	sbb    %eax,%edi
  802599:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80259d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025a9:	83 c4 14             	add    $0x14,%esp
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	85 f6                	test   %esi,%esi
  8025b2:	89 f5                	mov    %esi,%ebp
  8025b4:	75 0b                	jne    8025c1 <__umoddi3+0x91>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f6                	div    %esi
  8025bf:	89 c5                	mov    %eax,%ebp
  8025c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025c5:	31 d2                	xor    %edx,%edx
  8025c7:	f7 f5                	div    %ebp
  8025c9:	89 c8                	mov    %ecx,%eax
  8025cb:	f7 f5                	div    %ebp
  8025cd:	eb 9c                	jmp    80256b <__umoddi3+0x3b>
  8025cf:	90                   	nop
  8025d0:	89 c8                	mov    %ecx,%eax
  8025d2:	89 fa                	mov    %edi,%edx
  8025d4:	83 c4 14             	add    $0x14,%esp
  8025d7:	5e                   	pop    %esi
  8025d8:	5f                   	pop    %edi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    
  8025db:	90                   	nop
  8025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	8b 04 24             	mov    (%esp),%eax
  8025e3:	be 20 00 00 00       	mov    $0x20,%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	29 ee                	sub    %ebp,%esi
  8025ec:	d3 e2                	shl    %cl,%edx
  8025ee:	89 f1                	mov    %esi,%ecx
  8025f0:	d3 e8                	shr    %cl,%eax
  8025f2:	89 e9                	mov    %ebp,%ecx
  8025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f8:	8b 04 24             	mov    (%esp),%eax
  8025fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025ff:	89 fa                	mov    %edi,%edx
  802601:	d3 e0                	shl    %cl,%eax
  802603:	89 f1                	mov    %esi,%ecx
  802605:	89 44 24 08          	mov    %eax,0x8(%esp)
  802609:	8b 44 24 10          	mov    0x10(%esp),%eax
  80260d:	d3 ea                	shr    %cl,%edx
  80260f:	89 e9                	mov    %ebp,%ecx
  802611:	d3 e7                	shl    %cl,%edi
  802613:	89 f1                	mov    %esi,%ecx
  802615:	d3 e8                	shr    %cl,%eax
  802617:	89 e9                	mov    %ebp,%ecx
  802619:	09 f8                	or     %edi,%eax
  80261b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80261f:	f7 74 24 04          	divl   0x4(%esp)
  802623:	d3 e7                	shl    %cl,%edi
  802625:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802629:	89 d7                	mov    %edx,%edi
  80262b:	f7 64 24 08          	mull   0x8(%esp)
  80262f:	39 d7                	cmp    %edx,%edi
  802631:	89 c1                	mov    %eax,%ecx
  802633:	89 14 24             	mov    %edx,(%esp)
  802636:	72 2c                	jb     802664 <__umoddi3+0x134>
  802638:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80263c:	72 22                	jb     802660 <__umoddi3+0x130>
  80263e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802642:	29 c8                	sub    %ecx,%eax
  802644:	19 d7                	sbb    %edx,%edi
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	89 fa                	mov    %edi,%edx
  80264a:	d3 e8                	shr    %cl,%eax
  80264c:	89 f1                	mov    %esi,%ecx
  80264e:	d3 e2                	shl    %cl,%edx
  802650:	89 e9                	mov    %ebp,%ecx
  802652:	d3 ef                	shr    %cl,%edi
  802654:	09 d0                	or     %edx,%eax
  802656:	89 fa                	mov    %edi,%edx
  802658:	83 c4 14             	add    $0x14,%esp
  80265b:	5e                   	pop    %esi
  80265c:	5f                   	pop    %edi
  80265d:	5d                   	pop    %ebp
  80265e:	c3                   	ret    
  80265f:	90                   	nop
  802660:	39 d7                	cmp    %edx,%edi
  802662:	75 da                	jne    80263e <__umoddi3+0x10e>
  802664:	8b 14 24             	mov    (%esp),%edx
  802667:	89 c1                	mov    %eax,%ecx
  802669:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80266d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802671:	eb cb                	jmp    80263e <__umoddi3+0x10e>
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80267c:	0f 82 0f ff ff ff    	jb     802591 <__umoddi3+0x61>
  802682:	e9 1a ff ff ff       	jmp    8025a1 <__umoddi3+0x71>
