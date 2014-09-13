
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 f3 01 00 00       	call   800224 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  80004f:	e8 5a 03 00 00       	call   8003ae <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 ba 1f 00 00       	call   802019 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 d9 26 80 	movl   $0x8026d9,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 e2 26 80 00 	movl   $0x8026e2,(%esp)
  80007e:	e8 32 02 00 00       	call   8002b5 <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 88 11 00 00       	call   801210 <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 f6 26 80 	movl   $0x8026f6,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 e2 26 80 00 	movl   $0x8026e2,(%esp)
  8000a9:	e8 07 02 00 00       	call   8002b5 <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 b6 16 00 00       	call   801773 <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 bd 20 00 00       	call   80218a <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 ff 26 80 00 	movl   $0x8026ff,(%esp)
  8000d8:	e8 d1 02 00 00       	call   8003ae <cprintf>
				exit();
  8000dd:	e8 ba 01 00 00       	call   80029c <exit>
			}
			sys_yield();
  8000e2:	e8 b3 0d 00 00       	call   800e9a <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 64 13 00 00       	call   80146c <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 1a 27 80 00 	movl   $0x80271a,(%esp)
  800113:	e8 96 02 00 00       	call   8003ae <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  800121:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800127:	c1 ee 02             	shr    $0x2,%esi
  80012a:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	c7 04 24 25 27 80 00 	movl   $0x802725,(%esp)
  80013b:	e8 6e 02 00 00       	call   8003ae <cprintf>
	dup(p[0], 10);
  800140:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800147:	00 
  800148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014b:	89 04 24             	mov    %eax,(%esp)
  80014e:	e8 75 16 00 00       	call   8017c8 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800153:	8b 43 54             	mov    0x54(%ebx),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 1b                	jne    800176 <umain+0x136>
		dup(p[0], 10);
  80015b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800162:	00 
  800163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800166:	89 04 24             	mov    %eax,(%esp)
  800169:	e8 5a 16 00 00       	call   8017c8 <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80016e:	8b 43 54             	mov    0x54(%ebx),%eax
  800171:	83 f8 02             	cmp    $0x2,%eax
  800174:	74 e5                	je     80015b <umain+0x11b>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800176:	c7 04 24 30 27 80 00 	movl   $0x802730,(%esp)
  80017d:	e8 2c 02 00 00       	call   8003ae <cprintf>
	if (pipeisclosed(p[0]))
  800182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 fd 1f 00 00       	call   80218a <pipeisclosed>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	74 1c                	je     8001ad <umain+0x16d>
		panic("somehow the other end of p[0] got closed!");
  800191:	c7 44 24 08 8c 27 80 	movl   $0x80278c,0x8(%esp)
  800198:	00 
  800199:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8001a0:	00 
  8001a1:	c7 04 24 e2 26 80 00 	movl   $0x8026e2,(%esp)
  8001a8:	e8 08 01 00 00       	call   8002b5 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b7:	89 04 24             	mov    %eax,(%esp)
  8001ba:	e8 6c 14 00 00       	call   80162b <fd_lookup>
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	79 20                	jns    8001e3 <umain+0x1a3>
		panic("cannot look up p[0]: %e", r);
  8001c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c7:	c7 44 24 08 46 27 80 	movl   $0x802746,0x8(%esp)
  8001ce:	00 
  8001cf:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d6:	00 
  8001d7:	c7 04 24 e2 26 80 00 	movl   $0x8026e2,(%esp)
  8001de:	e8 d2 00 00 00       	call   8002b5 <_panic>
	va = fd2data(fd);
  8001e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 b2 13 00 00       	call   8015a0 <fd2data>
	if (pageref(va) != 3+1)
  8001ee:	89 04 24             	mov    %eax,(%esp)
  8001f1:	e8 d4 1b 00 00       	call   801dca <pageref>
  8001f6:	83 f8 04             	cmp    $0x4,%eax
  8001f9:	74 0e                	je     800209 <umain+0x1c9>
		cprintf("\nchild detected race\n");
  8001fb:	c7 04 24 5e 27 80 00 	movl   $0x80275e,(%esp)
  800202:	e8 a7 01 00 00       	call   8003ae <cprintf>
  800207:	eb 14                	jmp    80021d <umain+0x1dd>
	else
		cprintf("\nrace didn't happen\n", max);
  800209:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  800210:	00 
  800211:	c7 04 24 74 27 80 00 	movl   $0x802774,(%esp)
  800218:	e8 91 01 00 00       	call   8003ae <cprintf>
}
  80021d:	83 c4 20             	add    $0x20,%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5d                   	pop    %ebp
  800223:	c3                   	ret    

00800224 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	83 ec 10             	sub    $0x10,%esp
  80022c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80022f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800232:	e8 44 0c 00 00       	call   800e7b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800237:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80023d:	39 c2                	cmp    %eax,%edx
  80023f:	74 17                	je     800258 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800241:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800246:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800249:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80024f:	8b 49 40             	mov    0x40(%ecx),%ecx
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	75 18                	jne    80026e <libmain+0x4a>
  800256:	eb 05                	jmp    80025d <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800258:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80025d:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800260:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800266:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80026c:	eb 0b                	jmp    800279 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80026e:	83 c2 01             	add    $0x1,%edx
  800271:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800277:	75 cd                	jne    800246 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	85 db                	test   %ebx,%ebx
  80027b:	7e 07                	jle    800284 <libmain+0x60>
		binaryname = argv[0];
  80027d:	8b 06                	mov    (%esi),%eax
  80027f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800284:	89 74 24 04          	mov    %esi,0x4(%esp)
  800288:	89 1c 24             	mov    %ebx,(%esp)
  80028b:	e8 b0 fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800290:	e8 07 00 00 00       	call   80029c <exit>
}
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	5b                   	pop    %ebx
  800299:	5e                   	pop    %esi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    

0080029c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002a2:	e8 ff 14 00 00       	call   8017a6 <close_all>
	sys_env_destroy(0);
  8002a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002ae:	e8 76 0b 00 00       	call   800e29 <sys_env_destroy>
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002bd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002c6:	e8 b0 0b 00 00       	call   800e7b <sys_getenvid>
  8002cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d9:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e1:	c7 04 24 c0 27 80 00 	movl   $0x8027c0,(%esp)
  8002e8:	e8 c1 00 00 00       	call   8003ae <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 51 00 00 00       	call   80034d <vcprintf>
	cprintf("\n");
  8002fc:	c7 04 24 d7 26 80 00 	movl   $0x8026d7,(%esp)
  800303:	e8 a6 00 00 00       	call   8003ae <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800308:	cc                   	int3   
  800309:	eb fd                	jmp    800308 <_panic+0x53>

0080030b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	53                   	push   %ebx
  80030f:	83 ec 14             	sub    $0x14,%esp
  800312:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800315:	8b 13                	mov    (%ebx),%edx
  800317:	8d 42 01             	lea    0x1(%edx),%eax
  80031a:	89 03                	mov    %eax,(%ebx)
  80031c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80031f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800323:	3d ff 00 00 00       	cmp    $0xff,%eax
  800328:	75 19                	jne    800343 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80032a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800331:	00 
  800332:	8d 43 08             	lea    0x8(%ebx),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	e8 af 0a 00 00       	call   800dec <sys_cputs>
		b->idx = 0;
  80033d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800343:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800347:	83 c4 14             	add    $0x14,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800356:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80035d:	00 00 00 
	b.cnt = 0;
  800360:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800367:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	89 44 24 08          	mov    %eax,0x8(%esp)
  800378:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800382:	c7 04 24 0b 03 80 00 	movl   $0x80030b,(%esp)
  800389:	e8 b6 01 00 00       	call   800544 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80038e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800394:	89 44 24 04          	mov    %eax,0x4(%esp)
  800398:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	e8 46 0a 00 00       	call   800dec <sys_cputs>

	return b.cnt;
}
  8003a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	e8 87 ff ff ff       	call   80034d <vcprintf>
	va_end(ap);

	return cnt;
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    
  8003c8:	66 90                	xchg   %ax,%ax
  8003ca:	66 90                	xchg   %ax,%ax
  8003cc:	66 90                	xchg   %ax,%ax
  8003ce:	66 90                	xchg   %ax,%ax

008003d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	57                   	push   %edi
  8003d4:	56                   	push   %esi
  8003d5:	53                   	push   %ebx
  8003d6:	83 ec 3c             	sub    $0x3c,%esp
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dc:	89 d7                	mov    %edx,%edi
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8003ea:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003f8:	39 f1                	cmp    %esi,%ecx
  8003fa:	72 14                	jb     800410 <printnum+0x40>
  8003fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003ff:	76 0f                	jbe    800410 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 70 ff             	lea    -0x1(%eax),%esi
  800407:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80040a:	85 f6                	test   %esi,%esi
  80040c:	7f 60                	jg     80046e <printnum+0x9e>
  80040e:	eb 72                	jmp    800482 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800410:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800413:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800417:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80041a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80041d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800421:	89 44 24 08          	mov    %eax,0x8(%esp)
  800425:	8b 44 24 08          	mov    0x8(%esp),%eax
  800429:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80042d:	89 c3                	mov    %eax,%ebx
  80042f:	89 d6                	mov    %edx,%esi
  800431:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800434:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800437:	89 54 24 08          	mov    %edx,0x8(%esp)
  80043b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	89 04 24             	mov    %eax,(%esp)
  800445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800448:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044c:	e8 df 1f 00 00       	call   802430 <__udivdi3>
  800451:	89 d9                	mov    %ebx,%ecx
  800453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800457:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80045b:	89 04 24             	mov    %eax,(%esp)
  80045e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800462:	89 fa                	mov    %edi,%edx
  800464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800467:	e8 64 ff ff ff       	call   8003d0 <printnum>
  80046c:	eb 14                	jmp    800482 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80046e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800472:	8b 45 18             	mov    0x18(%ebp),%eax
  800475:	89 04 24             	mov    %eax,(%esp)
  800478:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80047a:	83 ee 01             	sub    $0x1,%esi
  80047d:	75 ef                	jne    80046e <printnum+0x9e>
  80047f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800482:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800486:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80048a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800490:	89 44 24 08          	mov    %eax,0x8(%esp)
  800494:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049b:	89 04 24             	mov    %eax,(%esp)
  80049e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a5:	e8 b6 20 00 00       	call   802560 <__umoddi3>
  8004aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ae:	0f be 80 e3 27 80 00 	movsbl 0x8027e3(%eax),%eax
  8004b5:	89 04 24             	mov    %eax,(%esp)
  8004b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004bb:	ff d0                	call   *%eax
}
  8004bd:	83 c4 3c             	add    $0x3c,%esp
  8004c0:	5b                   	pop    %ebx
  8004c1:	5e                   	pop    %esi
  8004c2:	5f                   	pop    %edi
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c8:	83 fa 01             	cmp    $0x1,%edx
  8004cb:	7e 0e                	jle    8004db <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004cd:	8b 10                	mov    (%eax),%edx
  8004cf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004d2:	89 08                	mov    %ecx,(%eax)
  8004d4:	8b 02                	mov    (%edx),%eax
  8004d6:	8b 52 04             	mov    0x4(%edx),%edx
  8004d9:	eb 22                	jmp    8004fd <getuint+0x38>
	else if (lflag)
  8004db:	85 d2                	test   %edx,%edx
  8004dd:	74 10                	je     8004ef <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004df:	8b 10                	mov    (%eax),%edx
  8004e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004e4:	89 08                	mov    %ecx,(%eax)
  8004e6:	8b 02                	mov    (%edx),%eax
  8004e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ed:	eb 0e                	jmp    8004fd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004ef:	8b 10                	mov    (%eax),%edx
  8004f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004f4:	89 08                	mov    %ecx,(%eax)
  8004f6:	8b 02                	mov    (%edx),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800505:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800509:	8b 10                	mov    (%eax),%edx
  80050b:	3b 50 04             	cmp    0x4(%eax),%edx
  80050e:	73 0a                	jae    80051a <sprintputch+0x1b>
		*b->buf++ = ch;
  800510:	8d 4a 01             	lea    0x1(%edx),%ecx
  800513:	89 08                	mov    %ecx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	88 02                	mov    %al,(%edx)
}
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800522:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800525:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800529:	8b 45 10             	mov    0x10(%ebp),%eax
  80052c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800530:	8b 45 0c             	mov    0xc(%ebp),%eax
  800533:	89 44 24 04          	mov    %eax,0x4(%esp)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	89 04 24             	mov    %eax,(%esp)
  80053d:	e8 02 00 00 00       	call   800544 <vprintfmt>
	va_end(ap);
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	57                   	push   %edi
  800548:	56                   	push   %esi
  800549:	53                   	push   %ebx
  80054a:	83 ec 3c             	sub    $0x3c,%esp
  80054d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800550:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800553:	eb 18                	jmp    80056d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800555:	85 c0                	test   %eax,%eax
  800557:	0f 84 c3 03 00 00    	je     800920 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80055d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800561:	89 04 24             	mov    %eax,(%esp)
  800564:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800567:	89 f3                	mov    %esi,%ebx
  800569:	eb 02                	jmp    80056d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80056b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80056d:	8d 73 01             	lea    0x1(%ebx),%esi
  800570:	0f b6 03             	movzbl (%ebx),%eax
  800573:	83 f8 25             	cmp    $0x25,%eax
  800576:	75 dd                	jne    800555 <vprintfmt+0x11>
  800578:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80057c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800583:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80058a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800591:	ba 00 00 00 00       	mov    $0x0,%edx
  800596:	eb 1d                	jmp    8005b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800598:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80059a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80059e:	eb 15                	jmp    8005b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8005a6:	eb 0d                	jmp    8005b5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ae:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8005b8:	0f b6 06             	movzbl (%esi),%eax
  8005bb:	0f b6 c8             	movzbl %al,%ecx
  8005be:	83 e8 23             	sub    $0x23,%eax
  8005c1:	3c 55                	cmp    $0x55,%al
  8005c3:	0f 87 2f 03 00 00    	ja     8008f8 <vprintfmt+0x3b4>
  8005c9:	0f b6 c0             	movzbl %al,%eax
  8005cc:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005d3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8005d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8005d9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8005dd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8005e0:	83 f9 09             	cmp    $0x9,%ecx
  8005e3:	77 50                	ja     800635 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	89 de                	mov    %ebx,%esi
  8005e7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ea:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005ed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005f0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005f4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005f7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005fa:	83 fb 09             	cmp    $0x9,%ebx
  8005fd:	76 eb                	jbe    8005ea <vprintfmt+0xa6>
  8005ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800602:	eb 33                	jmp    800637 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 48 04             	lea    0x4(%eax),%ecx
  80060a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800612:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800614:	eb 21                	jmp    800637 <vprintfmt+0xf3>
  800616:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800619:	85 c9                	test   %ecx,%ecx
  80061b:	b8 00 00 00 00       	mov    $0x0,%eax
  800620:	0f 49 c1             	cmovns %ecx,%eax
  800623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800626:	89 de                	mov    %ebx,%esi
  800628:	eb 8b                	jmp    8005b5 <vprintfmt+0x71>
  80062a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80062c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800633:	eb 80                	jmp    8005b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800635:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063b:	0f 89 74 ff ff ff    	jns    8005b5 <vprintfmt+0x71>
  800641:	e9 62 ff ff ff       	jmp    8005a8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800646:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800649:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80064b:	e9 65 ff ff ff       	jmp    8005b5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	89 55 14             	mov    %edx,0x14(%ebp)
  800659:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff 55 08             	call   *0x8(%ebp)
			break;
  800665:	e9 03 ff ff ff       	jmp    80056d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 50 04             	lea    0x4(%eax),%edx
  800670:	89 55 14             	mov    %edx,0x14(%ebp)
  800673:	8b 00                	mov    (%eax),%eax
  800675:	99                   	cltd   
  800676:	31 d0                	xor    %edx,%eax
  800678:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80067a:	83 f8 0f             	cmp    $0xf,%eax
  80067d:	7f 0b                	jg     80068a <vprintfmt+0x146>
  80067f:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  800686:	85 d2                	test   %edx,%edx
  800688:	75 20                	jne    8006aa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80068a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80068e:	c7 44 24 08 fb 27 80 	movl   $0x8027fb,0x8(%esp)
  800695:	00 
  800696:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	89 04 24             	mov    %eax,(%esp)
  8006a0:	e8 77 fe ff ff       	call   80051c <printfmt>
  8006a5:	e9 c3 fe ff ff       	jmp    80056d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8006aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ae:	c7 44 24 08 e7 2c 80 	movl   $0x802ce7,0x8(%esp)
  8006b5:	00 
  8006b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 04 24             	mov    %eax,(%esp)
  8006c0:	e8 57 fe ff ff       	call   80051c <printfmt>
  8006c5:	e9 a3 fe ff ff       	jmp    80056d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006cd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8006db:	85 c0                	test   %eax,%eax
  8006dd:	ba f4 27 80 00       	mov    $0x8027f4,%edx
  8006e2:	0f 45 d0             	cmovne %eax,%edx
  8006e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8006e8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8006ec:	74 04                	je     8006f2 <vprintfmt+0x1ae>
  8006ee:	85 f6                	test   %esi,%esi
  8006f0:	7f 19                	jg     80070b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	8d 70 01             	lea    0x1(%eax),%esi
  8006f8:	0f b6 10             	movzbl (%eax),%edx
  8006fb:	0f be c2             	movsbl %dl,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	0f 85 95 00 00 00    	jne    80079b <vprintfmt+0x257>
  800706:	e9 85 00 00 00       	jmp    800790 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80070f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800712:	89 04 24             	mov    %eax,(%esp)
  800715:	e8 b8 02 00 00       	call   8009d2 <strnlen>
  80071a:	29 c6                	sub    %eax,%esi
  80071c:	89 f0                	mov    %esi,%eax
  80071e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800721:	85 f6                	test   %esi,%esi
  800723:	7e cd                	jle    8006f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800725:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800729:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80072c:	89 c3                	mov    %eax,%ebx
  80072e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800732:	89 34 24             	mov    %esi,(%esp)
  800735:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	83 eb 01             	sub    $0x1,%ebx
  80073b:	75 f1                	jne    80072e <vprintfmt+0x1ea>
  80073d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800740:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800743:	eb ad                	jmp    8006f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800745:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800749:	74 1e                	je     800769 <vprintfmt+0x225>
  80074b:	0f be d2             	movsbl %dl,%edx
  80074e:	83 ea 20             	sub    $0x20,%edx
  800751:	83 fa 5e             	cmp    $0x5e,%edx
  800754:	76 13                	jbe    800769 <vprintfmt+0x225>
					putch('?', putdat);
  800756:	8b 45 0c             	mov    0xc(%ebp),%eax
  800759:	89 44 24 04          	mov    %eax,0x4(%esp)
  80075d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800764:	ff 55 08             	call   *0x8(%ebp)
  800767:	eb 0d                	jmp    800776 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800770:	89 04 24             	mov    %eax,(%esp)
  800773:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800776:	83 ef 01             	sub    $0x1,%edi
  800779:	83 c6 01             	add    $0x1,%esi
  80077c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800780:	0f be c2             	movsbl %dl,%eax
  800783:	85 c0                	test   %eax,%eax
  800785:	75 20                	jne    8007a7 <vprintfmt+0x263>
  800787:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80078a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80078d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800790:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800794:	7f 25                	jg     8007bb <vprintfmt+0x277>
  800796:	e9 d2 fd ff ff       	jmp    80056d <vprintfmt+0x29>
  80079b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80079e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007a1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a7:	85 db                	test   %ebx,%ebx
  8007a9:	78 9a                	js     800745 <vprintfmt+0x201>
  8007ab:	83 eb 01             	sub    $0x1,%ebx
  8007ae:	79 95                	jns    800745 <vprintfmt+0x201>
  8007b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8007b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007b9:	eb d5                	jmp    800790 <vprintfmt+0x24c>
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007cf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d1:	83 eb 01             	sub    $0x1,%ebx
  8007d4:	75 ee                	jne    8007c4 <vprintfmt+0x280>
  8007d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007d9:	e9 8f fd ff ff       	jmp    80056d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007de:	83 fa 01             	cmp    $0x1,%edx
  8007e1:	7e 16                	jle    8007f9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 50 08             	lea    0x8(%eax),%edx
  8007e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ec:	8b 50 04             	mov    0x4(%eax),%edx
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f7:	eb 32                	jmp    80082b <vprintfmt+0x2e7>
	else if (lflag)
  8007f9:	85 d2                	test   %edx,%edx
  8007fb:	74 18                	je     800815 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	89 55 14             	mov    %edx,0x14(%ebp)
  800806:	8b 30                	mov    (%eax),%esi
  800808:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80080b:	89 f0                	mov    %esi,%eax
  80080d:	c1 f8 1f             	sar    $0x1f,%eax
  800810:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800813:	eb 16                	jmp    80082b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 50 04             	lea    0x4(%eax),%edx
  80081b:	89 55 14             	mov    %edx,0x14(%ebp)
  80081e:	8b 30                	mov    (%eax),%esi
  800820:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800823:	89 f0                	mov    %esi,%eax
  800825:	c1 f8 1f             	sar    $0x1f,%eax
  800828:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800831:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800836:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80083a:	0f 89 80 00 00 00    	jns    8008c0 <vprintfmt+0x37c>
				putch('-', putdat);
  800840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800844:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80084b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800854:	f7 d8                	neg    %eax
  800856:	83 d2 00             	adc    $0x0,%edx
  800859:	f7 da                	neg    %edx
			}
			base = 10;
  80085b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800860:	eb 5e                	jmp    8008c0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
  800865:	e8 5b fc ff ff       	call   8004c5 <getuint>
			base = 10;
  80086a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80086f:	eb 4f                	jmp    8008c0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800871:	8d 45 14             	lea    0x14(%ebp),%eax
  800874:	e8 4c fc ff ff       	call   8004c5 <getuint>
			base = 8;
  800879:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80087e:	eb 40                	jmp    8008c0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800880:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800884:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80088b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80088e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800892:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800899:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008ac:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8008b1:	eb 0d                	jmp    8008c0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	e8 0a fc ff ff       	call   8004c5 <getuint>
			base = 16;
  8008bb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8008c4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8008cb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008d3:	89 04 24             	mov    %eax,(%esp)
  8008d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008da:	89 fa                	mov    %edi,%edx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	e8 ec fa ff ff       	call   8003d0 <printnum>
			break;
  8008e4:	e9 84 fc ff ff       	jmp    80056d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ed:	89 0c 24             	mov    %ecx,(%esp)
  8008f0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008f3:	e9 75 fc ff ff       	jmp    80056d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800903:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800906:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80090a:	0f 84 5b fc ff ff    	je     80056b <vprintfmt+0x27>
  800910:	89 f3                	mov    %esi,%ebx
  800912:	83 eb 01             	sub    $0x1,%ebx
  800915:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800919:	75 f7                	jne    800912 <vprintfmt+0x3ce>
  80091b:	e9 4d fc ff ff       	jmp    80056d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800920:	83 c4 3c             	add    $0x3c,%esp
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5f                   	pop    %edi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	83 ec 28             	sub    $0x28,%esp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800937:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80093b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800945:	85 c0                	test   %eax,%eax
  800947:	74 30                	je     800979 <vsnprintf+0x51>
  800949:	85 d2                	test   %edx,%edx
  80094b:	7e 2c                	jle    800979 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800954:	8b 45 10             	mov    0x10(%ebp),%eax
  800957:	89 44 24 08          	mov    %eax,0x8(%esp)
  80095b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80095e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800962:	c7 04 24 ff 04 80 00 	movl   $0x8004ff,(%esp)
  800969:	e8 d6 fb ff ff       	call   800544 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80096e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800971:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800977:	eb 05                	jmp    80097e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800979:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800986:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800989:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	89 44 24 08          	mov    %eax,0x8(%esp)
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 04 24             	mov    %eax,(%esp)
  8009a1:	e8 82 ff ff ff       	call   800928 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    
  8009a8:	66 90                	xchg   %ax,%ax
  8009aa:	66 90                	xchg   %ax,%ax
  8009ac:	66 90                	xchg   %ax,%ax
  8009ae:	66 90                	xchg   %ax,%ax

008009b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b6:	80 3a 00             	cmpb   $0x0,(%edx)
  8009b9:	74 10                	je     8009cb <strlen+0x1b>
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c7:	75 f7                	jne    8009c0 <strlen+0x10>
  8009c9:	eb 05                	jmp    8009d0 <strlen+0x20>
  8009cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	53                   	push   %ebx
  8009d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009dc:	85 c9                	test   %ecx,%ecx
  8009de:	74 1c                	je     8009fc <strnlen+0x2a>
  8009e0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009e3:	74 1e                	je     800a03 <strnlen+0x31>
  8009e5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8009ea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ec:	39 ca                	cmp    %ecx,%edx
  8009ee:	74 18                	je     800a08 <strnlen+0x36>
  8009f0:	83 c2 01             	add    $0x1,%edx
  8009f3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8009f8:	75 f0                	jne    8009ea <strnlen+0x18>
  8009fa:	eb 0c                	jmp    800a08 <strnlen+0x36>
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	eb 05                	jmp    800a08 <strnlen+0x36>
  800a03:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a08:	5b                   	pop    %ebx
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a15:	89 c2                	mov    %eax,%edx
  800a17:	83 c2 01             	add    $0x1,%edx
  800a1a:	83 c1 01             	add    $0x1,%ecx
  800a1d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a21:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a24:	84 db                	test   %bl,%bl
  800a26:	75 ef                	jne    800a17 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a28:	5b                   	pop    %ebx
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	53                   	push   %ebx
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a35:	89 1c 24             	mov    %ebx,(%esp)
  800a38:	e8 73 ff ff ff       	call   8009b0 <strlen>
	strcpy(dst + len, src);
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a44:	01 d8                	add    %ebx,%eax
  800a46:	89 04 24             	mov    %eax,(%esp)
  800a49:	e8 bd ff ff ff       	call   800a0b <strcpy>
	return dst;
}
  800a4e:	89 d8                	mov    %ebx,%eax
  800a50:	83 c4 08             	add    $0x8,%esp
  800a53:	5b                   	pop    %ebx
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
  800a5b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	74 17                	je     800a7f <strncpy+0x29>
  800a68:	01 f3                	add    %esi,%ebx
  800a6a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800a6c:	83 c1 01             	add    $0x1,%ecx
  800a6f:	0f b6 02             	movzbl (%edx),%eax
  800a72:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a75:	80 3a 01             	cmpb   $0x1,(%edx)
  800a78:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7b:	39 d9                	cmp    %ebx,%ecx
  800a7d:	75 ed                	jne    800a6c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a7f:	89 f0                	mov    %esi,%eax
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a91:	8b 75 10             	mov    0x10(%ebp),%esi
  800a94:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a96:	85 f6                	test   %esi,%esi
  800a98:	74 34                	je     800ace <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800a9a:	83 fe 01             	cmp    $0x1,%esi
  800a9d:	74 26                	je     800ac5 <strlcpy+0x40>
  800a9f:	0f b6 0b             	movzbl (%ebx),%ecx
  800aa2:	84 c9                	test   %cl,%cl
  800aa4:	74 23                	je     800ac9 <strlcpy+0x44>
  800aa6:	83 ee 02             	sub    $0x2,%esi
  800aa9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab4:	39 f2                	cmp    %esi,%edx
  800ab6:	74 13                	je     800acb <strlcpy+0x46>
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800abf:	84 c9                	test   %cl,%cl
  800ac1:	75 eb                	jne    800aae <strlcpy+0x29>
  800ac3:	eb 06                	jmp    800acb <strlcpy+0x46>
  800ac5:	89 f8                	mov    %edi,%eax
  800ac7:	eb 02                	jmp    800acb <strlcpy+0x46>
  800ac9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800acb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ace:	29 f8                	sub    %edi,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5f                   	pop    %edi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ade:	0f b6 01             	movzbl (%ecx),%eax
  800ae1:	84 c0                	test   %al,%al
  800ae3:	74 15                	je     800afa <strcmp+0x25>
  800ae5:	3a 02                	cmp    (%edx),%al
  800ae7:	75 11                	jne    800afa <strcmp+0x25>
		p++, q++;
  800ae9:	83 c1 01             	add    $0x1,%ecx
  800aec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aef:	0f b6 01             	movzbl (%ecx),%eax
  800af2:	84 c0                	test   %al,%al
  800af4:	74 04                	je     800afa <strcmp+0x25>
  800af6:	3a 02                	cmp    (%edx),%al
  800af8:	74 ef                	je     800ae9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afa:	0f b6 c0             	movzbl %al,%eax
  800afd:	0f b6 12             	movzbl (%edx),%edx
  800b00:	29 d0                	sub    %edx,%eax
}
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800b12:	85 f6                	test   %esi,%esi
  800b14:	74 29                	je     800b3f <strncmp+0x3b>
  800b16:	0f b6 03             	movzbl (%ebx),%eax
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 30                	je     800b4d <strncmp+0x49>
  800b1d:	3a 02                	cmp    (%edx),%al
  800b1f:	75 2c                	jne    800b4d <strncmp+0x49>
  800b21:	8d 43 01             	lea    0x1(%ebx),%eax
  800b24:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800b26:	89 c3                	mov    %eax,%ebx
  800b28:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b2b:	39 f0                	cmp    %esi,%eax
  800b2d:	74 17                	je     800b46 <strncmp+0x42>
  800b2f:	0f b6 08             	movzbl (%eax),%ecx
  800b32:	84 c9                	test   %cl,%cl
  800b34:	74 17                	je     800b4d <strncmp+0x49>
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	3a 0a                	cmp    (%edx),%cl
  800b3b:	74 e9                	je     800b26 <strncmp+0x22>
  800b3d:	eb 0e                	jmp    800b4d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 0f                	jmp    800b55 <strncmp+0x51>
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	eb 08                	jmp    800b55 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4d:	0f b6 03             	movzbl (%ebx),%eax
  800b50:	0f b6 12             	movzbl (%edx),%edx
  800b53:	29 d0                	sub    %edx,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b63:	0f b6 18             	movzbl (%eax),%ebx
  800b66:	84 db                	test   %bl,%bl
  800b68:	74 1d                	je     800b87 <strchr+0x2e>
  800b6a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b6c:	38 d3                	cmp    %dl,%bl
  800b6e:	75 06                	jne    800b76 <strchr+0x1d>
  800b70:	eb 1a                	jmp    800b8c <strchr+0x33>
  800b72:	38 ca                	cmp    %cl,%dl
  800b74:	74 16                	je     800b8c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	0f b6 10             	movzbl (%eax),%edx
  800b7c:	84 d2                	test   %dl,%dl
  800b7e:	75 f2                	jne    800b72 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
  800b85:	eb 05                	jmp    800b8c <strchr+0x33>
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	53                   	push   %ebx
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b99:	0f b6 18             	movzbl (%eax),%ebx
  800b9c:	84 db                	test   %bl,%bl
  800b9e:	74 16                	je     800bb6 <strfind+0x27>
  800ba0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ba2:	38 d3                	cmp    %dl,%bl
  800ba4:	75 06                	jne    800bac <strfind+0x1d>
  800ba6:	eb 0e                	jmp    800bb6 <strfind+0x27>
  800ba8:	38 ca                	cmp    %cl,%dl
  800baa:	74 0a                	je     800bb6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bac:	83 c0 01             	add    $0x1,%eax
  800baf:	0f b6 10             	movzbl (%eax),%edx
  800bb2:	84 d2                	test   %dl,%dl
  800bb4:	75 f2                	jne    800ba8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bc5:	85 c9                	test   %ecx,%ecx
  800bc7:	74 36                	je     800bff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bc9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bcf:	75 28                	jne    800bf9 <memset+0x40>
  800bd1:	f6 c1 03             	test   $0x3,%cl
  800bd4:	75 23                	jne    800bf9 <memset+0x40>
		c &= 0xFF;
  800bd6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	c1 e3 08             	shl    $0x8,%ebx
  800bdf:	89 d6                	mov    %edx,%esi
  800be1:	c1 e6 18             	shl    $0x18,%esi
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	c1 e0 10             	shl    $0x10,%eax
  800be9:	09 f0                	or     %esi,%eax
  800beb:	09 c2                	or     %eax,%edx
  800bed:	89 d0                	mov    %edx,%eax
  800bef:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bf1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bf4:	fc                   	cld    
  800bf5:	f3 ab                	rep stos %eax,%es:(%edi)
  800bf7:	eb 06                	jmp    800bff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	fc                   	cld    
  800bfd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bff:	89 f8                	mov    %edi,%eax
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c14:	39 c6                	cmp    %eax,%esi
  800c16:	73 35                	jae    800c4d <memmove+0x47>
  800c18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c1b:	39 d0                	cmp    %edx,%eax
  800c1d:	73 2e                	jae    800c4d <memmove+0x47>
		s += n;
		d += n;
  800c1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c22:	89 d6                	mov    %edx,%esi
  800c24:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c2c:	75 13                	jne    800c41 <memmove+0x3b>
  800c2e:	f6 c1 03             	test   $0x3,%cl
  800c31:	75 0e                	jne    800c41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c33:	83 ef 04             	sub    $0x4,%edi
  800c36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c39:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c3c:	fd                   	std    
  800c3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3f:	eb 09                	jmp    800c4a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c41:	83 ef 01             	sub    $0x1,%edi
  800c44:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c47:	fd                   	std    
  800c48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c4a:	fc                   	cld    
  800c4b:	eb 1d                	jmp    800c6a <memmove+0x64>
  800c4d:	89 f2                	mov    %esi,%edx
  800c4f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c51:	f6 c2 03             	test   $0x3,%dl
  800c54:	75 0f                	jne    800c65 <memmove+0x5f>
  800c56:	f6 c1 03             	test   $0x3,%cl
  800c59:	75 0a                	jne    800c65 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c5b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c5e:	89 c7                	mov    %eax,%edi
  800c60:	fc                   	cld    
  800c61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c63:	eb 05                	jmp    800c6a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c65:	89 c7                	mov    %eax,%edi
  800c67:	fc                   	cld    
  800c68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	89 04 24             	mov    %eax,(%esp)
  800c88:	e8 79 ff ff ff       	call   800c06 <memmove>
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c9e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	74 36                	je     800cdb <memcmp+0x4c>
		if (*s1 != *s2)
  800ca5:	0f b6 03             	movzbl (%ebx),%eax
  800ca8:	0f b6 0e             	movzbl (%esi),%ecx
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	38 c8                	cmp    %cl,%al
  800cb2:	74 1c                	je     800cd0 <memcmp+0x41>
  800cb4:	eb 10                	jmp    800cc6 <memcmp+0x37>
  800cb6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800cbb:	83 c2 01             	add    $0x1,%edx
  800cbe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800cc2:	38 c8                	cmp    %cl,%al
  800cc4:	74 0a                	je     800cd0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800cc6:	0f b6 c0             	movzbl %al,%eax
  800cc9:	0f b6 c9             	movzbl %cl,%ecx
  800ccc:	29 c8                	sub    %ecx,%eax
  800cce:	eb 10                	jmp    800ce0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cd0:	39 fa                	cmp    %edi,%edx
  800cd2:	75 e2                	jne    800cb6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd9:	eb 05                	jmp    800ce0 <memcmp+0x51>
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	53                   	push   %ebx
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf4:	39 d0                	cmp    %edx,%eax
  800cf6:	73 13                	jae    800d0b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf8:	89 d9                	mov    %ebx,%ecx
  800cfa:	38 18                	cmp    %bl,(%eax)
  800cfc:	75 06                	jne    800d04 <memfind+0x1f>
  800cfe:	eb 0b                	jmp    800d0b <memfind+0x26>
  800d00:	38 08                	cmp    %cl,(%eax)
  800d02:	74 07                	je     800d0b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d04:	83 c0 01             	add    $0x1,%eax
  800d07:	39 d0                	cmp    %edx,%eax
  800d09:	75 f5                	jne    800d00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1a:	0f b6 0a             	movzbl (%edx),%ecx
  800d1d:	80 f9 09             	cmp    $0x9,%cl
  800d20:	74 05                	je     800d27 <strtol+0x19>
  800d22:	80 f9 20             	cmp    $0x20,%cl
  800d25:	75 10                	jne    800d37 <strtol+0x29>
		s++;
  800d27:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2a:	0f b6 0a             	movzbl (%edx),%ecx
  800d2d:	80 f9 09             	cmp    $0x9,%cl
  800d30:	74 f5                	je     800d27 <strtol+0x19>
  800d32:	80 f9 20             	cmp    $0x20,%cl
  800d35:	74 f0                	je     800d27 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d37:	80 f9 2b             	cmp    $0x2b,%cl
  800d3a:	75 0a                	jne    800d46 <strtol+0x38>
		s++;
  800d3c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d44:	eb 11                	jmp    800d57 <strtol+0x49>
  800d46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d4b:	80 f9 2d             	cmp    $0x2d,%cl
  800d4e:	75 07                	jne    800d57 <strtol+0x49>
		s++, neg = 1;
  800d50:	83 c2 01             	add    $0x1,%edx
  800d53:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d57:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d5c:	75 15                	jne    800d73 <strtol+0x65>
  800d5e:	80 3a 30             	cmpb   $0x30,(%edx)
  800d61:	75 10                	jne    800d73 <strtol+0x65>
  800d63:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d67:	75 0a                	jne    800d73 <strtol+0x65>
		s += 2, base = 16;
  800d69:	83 c2 02             	add    $0x2,%edx
  800d6c:	b8 10 00 00 00       	mov    $0x10,%eax
  800d71:	eb 10                	jmp    800d83 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800d73:	85 c0                	test   %eax,%eax
  800d75:	75 0c                	jne    800d83 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d77:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d79:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7c:	75 05                	jne    800d83 <strtol+0x75>
		s++, base = 8;
  800d7e:	83 c2 01             	add    $0x1,%edx
  800d81:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d88:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d8b:	0f b6 0a             	movzbl (%edx),%ecx
  800d8e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d91:	89 f0                	mov    %esi,%eax
  800d93:	3c 09                	cmp    $0x9,%al
  800d95:	77 08                	ja     800d9f <strtol+0x91>
			dig = *s - '0';
  800d97:	0f be c9             	movsbl %cl,%ecx
  800d9a:	83 e9 30             	sub    $0x30,%ecx
  800d9d:	eb 20                	jmp    800dbf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800d9f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800da2:	89 f0                	mov    %esi,%eax
  800da4:	3c 19                	cmp    $0x19,%al
  800da6:	77 08                	ja     800db0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800da8:	0f be c9             	movsbl %cl,%ecx
  800dab:	83 e9 57             	sub    $0x57,%ecx
  800dae:	eb 0f                	jmp    800dbf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800db0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800db3:	89 f0                	mov    %esi,%eax
  800db5:	3c 19                	cmp    $0x19,%al
  800db7:	77 16                	ja     800dcf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800db9:	0f be c9             	movsbl %cl,%ecx
  800dbc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dbf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dc2:	7d 0f                	jge    800dd3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800dc4:	83 c2 01             	add    $0x1,%edx
  800dc7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dcb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dcd:	eb bc                	jmp    800d8b <strtol+0x7d>
  800dcf:	89 d8                	mov    %ebx,%eax
  800dd1:	eb 02                	jmp    800dd5 <strtol+0xc7>
  800dd3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd9:	74 05                	je     800de0 <strtol+0xd2>
		*endptr = (char *) s;
  800ddb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dde:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800de0:	f7 d8                	neg    %eax
  800de2:	85 ff                	test   %edi,%edi
  800de4:	0f 44 c3             	cmove  %ebx,%eax
}
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	b8 00 00 00 00       	mov    $0x0,%eax
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	89 c3                	mov    %eax,%ebx
  800dff:	89 c7                	mov    %eax,%edi
  800e01:	89 c6                	mov    %eax,%esi
  800e03:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_cgetc>:

int
sys_cgetc(void)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e10:	ba 00 00 00 00       	mov    $0x0,%edx
  800e15:	b8 01 00 00 00       	mov    $0x1,%eax
  800e1a:	89 d1                	mov    %edx,%ecx
  800e1c:	89 d3                	mov    %edx,%ebx
  800e1e:	89 d7                	mov    %edx,%edi
  800e20:	89 d6                	mov    %edx,%esi
  800e22:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e37:	b8 03 00 00 00       	mov    $0x3,%eax
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	89 cb                	mov    %ecx,%ebx
  800e41:	89 cf                	mov    %ecx,%edi
  800e43:	89 ce                	mov    %ecx,%esi
  800e45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7e 28                	jle    800e73 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e56:	00 
  800e57:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800e6e:	e8 42 f4 ff ff       	call   8002b5 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e73:	83 c4 2c             	add    $0x2c,%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	ba 00 00 00 00       	mov    $0x0,%edx
  800e86:	b8 02 00 00 00       	mov    $0x2,%eax
  800e8b:	89 d1                	mov    %edx,%ecx
  800e8d:	89 d3                	mov    %edx,%ebx
  800e8f:	89 d7                	mov    %edx,%edi
  800e91:	89 d6                	mov    %edx,%esi
  800e93:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_yield>:

void
sys_yield(void)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eaa:	89 d1                	mov    %edx,%ecx
  800eac:	89 d3                	mov    %edx,%ebx
  800eae:	89 d7                	mov    %edx,%edi
  800eb0:	89 d6                	mov    %edx,%esi
  800eb2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec2:	be 00 00 00 00       	mov    $0x0,%esi
  800ec7:	b8 04 00 00 00       	mov    $0x4,%eax
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed5:	89 f7                	mov    %esi,%edi
  800ed7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7e 28                	jle    800f05 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ee8:	00 
  800ee9:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ef8:	00 
  800ef9:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800f00:	e8 b0 f3 ff ff       	call   8002b5 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f05:	83 c4 2c             	add    $0x2c,%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f16:	b8 05 00 00 00       	mov    $0x5,%eax
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f27:	8b 75 18             	mov    0x18(%ebp),%esi
  800f2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7e 28                	jle    800f58 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f34:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800f43:	00 
  800f44:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f4b:	00 
  800f4c:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800f53:	e8 5d f3 ff ff       	call   8002b5 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f58:	83 c4 2c             	add    $0x2c,%esp
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7e 28                	jle    800fab <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f87:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f8e:	00 
  800f8f:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800f96:	00 
  800f97:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f9e:	00 
  800f9f:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800fa6:	e8 0a f3 ff ff       	call   8002b5 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fab:	83 c4 2c             	add    $0x2c,%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc1:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	89 df                	mov    %ebx,%edi
  800fce:	89 de                	mov    %ebx,%esi
  800fd0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	7e 28                	jle    800ffe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fda:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fe1:	00 
  800fe2:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  800fe9:	00 
  800fea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ff1:	00 
  800ff2:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  800ff9:	e8 b7 f2 ff ff       	call   8002b5 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ffe:	83 c4 2c             	add    $0x2c,%esp
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	57                   	push   %edi
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
  80100c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801014:	b8 09 00 00 00       	mov    $0x9,%eax
  801019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	89 df                	mov    %ebx,%edi
  801021:	89 de                	mov    %ebx,%esi
  801023:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801025:	85 c0                	test   %eax,%eax
  801027:	7e 28                	jle    801051 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801029:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801034:	00 
  801035:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  80103c:	00 
  80103d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801044:	00 
  801045:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  80104c:	e8 64 f2 ff ff       	call   8002b5 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801051:	83 c4 2c             	add    $0x2c,%esp
  801054:	5b                   	pop    %ebx
  801055:	5e                   	pop    %esi
  801056:	5f                   	pop    %edi
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	57                   	push   %edi
  80105d:	56                   	push   %esi
  80105e:	53                   	push   %ebx
  80105f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801062:	bb 00 00 00 00       	mov    $0x0,%ebx
  801067:	b8 0a 00 00 00       	mov    $0xa,%eax
  80106c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	89 df                	mov    %ebx,%edi
  801074:	89 de                	mov    %ebx,%esi
  801076:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801078:	85 c0                	test   %eax,%eax
  80107a:	7e 28                	jle    8010a4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801080:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801087:	00 
  801088:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  80108f:	00 
  801090:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801097:	00 
  801098:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  80109f:	e8 11 f2 ff ff       	call   8002b5 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a4:	83 c4 2c             	add    $0x2c,%esp
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5f                   	pop    %edi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b2:	be 00 00 00 00       	mov    $0x0,%esi
  8010b7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	57                   	push   %edi
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
  8010d5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	89 cb                	mov    %ecx,%ebx
  8010e7:	89 cf                	mov    %ecx,%edi
  8010e9:	89 ce                	mov    %ecx,%esi
  8010eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	7e 28                	jle    801119 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010fc:	00 
  8010fd:	c7 44 24 08 df 2a 80 	movl   $0x802adf,0x8(%esp)
  801104:	00 
  801105:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80110c:	00 
  80110d:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  801114:	e8 9c f1 ff ff       	call   8002b5 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801119:	83 c4 2c             	add    $0x2c,%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	53                   	push   %ebx
  801125:	83 ec 24             	sub    $0x24,%esp
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80112b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80112d:	89 da                	mov    %ebx,%edx
  80112f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801132:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801139:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80113d:	74 05                	je     801144 <pgfault+0x23>
  80113f:	f6 c6 08             	test   $0x8,%dh
  801142:	75 1c                	jne    801160 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801144:	c7 44 24 08 0c 2b 80 	movl   $0x802b0c,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80115b:	e8 55 f1 ff ff       	call   8002b5 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801160:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801167:	00 
  801168:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80116f:	00 
  801170:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801177:	e8 3d fd ff ff       	call   800eb9 <sys_page_alloc>
  80117c:	85 c0                	test   %eax,%eax
  80117e:	79 20                	jns    8011a0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801180:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801184:	c7 44 24 08 74 2b 80 	movl   $0x802b74,0x8(%esp)
  80118b:	00 
  80118c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801193:	00 
  801194:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80119b:	e8 15 f1 ff ff       	call   8002b5 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  8011a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  8011a6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011ad:	00 
  8011ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011b2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011b9:	e8 48 fa ff ff       	call   800c06 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8011be:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011c5:	00 
  8011c6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011d1:	00 
  8011d2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d9:	00 
  8011da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e1:	e8 27 fd ff ff       	call   800f0d <sys_page_map>
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	79 20                	jns    80120a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8011ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ee:	c7 44 24 08 8e 2b 80 	movl   $0x802b8e,0x8(%esp)
  8011f5:	00 
  8011f6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011fd:	00 
  8011fe:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  801205:	e8 ab f0 ff ff       	call   8002b5 <_panic>
	}
}
  80120a:	83 c4 24             	add    $0x24,%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801219:	c7 04 24 21 11 80 00 	movl   $0x801121,(%esp)
  801220:	e8 51 11 00 00       	call   802376 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801225:	b8 07 00 00 00       	mov    $0x7,%eax
  80122a:	cd 30                	int    $0x30
  80122c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80122f:	85 c0                	test   %eax,%eax
  801231:	79 1c                	jns    80124f <fork+0x3f>
		panic("fork");
  801233:	c7 44 24 08 a7 2b 80 	movl   $0x802ba7,0x8(%esp)
  80123a:	00 
  80123b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801242:	00 
  801243:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80124a:	e8 66 f0 ff ff       	call   8002b5 <_panic>
  80124f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801251:	bb 00 08 00 00       	mov    $0x800,%ebx
  801256:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80125a:	75 21                	jne    80127d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80125c:	e8 1a fc ff ff       	call   800e7b <sys_getenvid>
  801261:	25 ff 03 00 00       	and    $0x3ff,%eax
  801266:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801269:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80126e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	e9 c5 01 00 00       	jmp    801442 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80127d:	89 d8                	mov    %ebx,%eax
  80127f:	c1 e8 0a             	shr    $0xa,%eax
  801282:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801289:	a8 01                	test   $0x1,%al
  80128b:	0f 84 f2 00 00 00    	je     801383 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801291:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801298:	a8 05                	test   $0x5,%al
  80129a:	0f 84 e3 00 00 00    	je     801383 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  8012a0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012a7:	89 de                	mov    %ebx,%esi
  8012a9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  8012ac:	a9 02 08 00 00       	test   $0x802,%eax
  8012b1:	0f 84 88 00 00 00    	je     80133f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8012b7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012be:	00 
  8012bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d2:	e8 36 fc ff ff       	call   800f0d <sys_page_map>
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	79 20                	jns    8012fb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  8012db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012df:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  8012e6:	00 
  8012e7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8012ee:	00 
  8012ef:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  8012f6:	e8 ba ef ff ff       	call   8002b5 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8012fb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801302:	00 
  801303:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801307:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80130e:	00 
  80130f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801313:	89 3c 24             	mov    %edi,(%esp)
  801316:	e8 f2 fb ff ff       	call   800f0d <sys_page_map>
  80131b:	85 c0                	test   %eax,%eax
  80131d:	79 64                	jns    801383 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80131f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801323:	c7 44 24 08 c6 2b 80 	movl   $0x802bc6,0x8(%esp)
  80132a:	00 
  80132b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801332:	00 
  801333:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80133a:	e8 76 ef ff ff       	call   8002b5 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80133f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801346:	00 
  801347:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80134b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80134f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801353:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135a:	e8 ae fb ff ff       	call   800f0d <sys_page_map>
  80135f:	85 c0                	test   %eax,%eax
  801361:	79 20                	jns    801383 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801367:	c7 44 24 08 e0 2b 80 	movl   $0x802be0,0x8(%esp)
  80136e:	00 
  80136f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801376:	00 
  801377:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80137e:	e8 32 ef ff ff       	call   8002b5 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801383:	83 c3 01             	add    $0x1,%ebx
  801386:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80138c:	0f 85 eb fe ff ff    	jne    80127d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801392:	c7 44 24 04 df 23 80 	movl   $0x8023df,0x4(%esp)
  801399:	00 
  80139a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139d:	89 04 24             	mov    %eax,(%esp)
  8013a0:	e8 b4 fc ff ff       	call   801059 <sys_env_set_pgfault_upcall>
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	79 20                	jns    8013c9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8013a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ad:	c7 44 24 08 44 2b 80 	movl   $0x802b44,0x8(%esp)
  8013b4:	00 
  8013b5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013bc:	00 
  8013bd:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  8013c4:	e8 ec ee ff ff       	call   8002b5 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8013c9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013d0:	00 
  8013d1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013d8:	ee 
  8013d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013dc:	89 04 24             	mov    %eax,(%esp)
  8013df:	e8 d5 fa ff ff       	call   800eb9 <sys_page_alloc>
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	79 20                	jns    801408 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8013e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ec:	c7 44 24 08 f2 2b 80 	movl   $0x802bf2,0x8(%esp)
  8013f3:	00 
  8013f4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  8013fb:	00 
  8013fc:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  801403:	e8 ad ee ff ff       	call   8002b5 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801408:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80140f:	00 
  801410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801413:	89 04 24             	mov    %eax,(%esp)
  801416:	e8 98 fb ff ff       	call   800fb3 <sys_env_set_status>
  80141b:	85 c0                	test   %eax,%eax
  80141d:	79 20                	jns    80143f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80141f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801423:	c7 44 24 08 0a 2c 80 	movl   $0x802c0a,0x8(%esp)
  80142a:	00 
  80142b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801432:	00 
  801433:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  80143a:	e8 76 ee ff ff       	call   8002b5 <_panic>
	}

	return envid;
  80143f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801442:	83 c4 2c             	add    $0x2c,%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <sfork>:

// Challenge!
int
sfork(void)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801450:	c7 44 24 08 25 2c 80 	movl   $0x802c25,0x8(%esp)
  801457:	00 
  801458:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80145f:	00 
  801460:	c7 04 24 69 2b 80 00 	movl   $0x802b69,(%esp)
  801467:	e8 49 ee ff ff       	call   8002b5 <_panic>

0080146c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	56                   	push   %esi
  801470:	53                   	push   %ebx
  801471:	83 ec 10             	sub    $0x10,%esp
  801474:	8b 75 08             	mov    0x8(%ebp),%esi
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  80147d:	83 f8 01             	cmp    $0x1,%eax
  801480:	19 c0                	sbb    %eax,%eax
  801482:	f7 d0                	not    %eax
  801484:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801489:	89 04 24             	mov    %eax,(%esp)
  80148c:	e8 3e fc ff ff       	call   8010cf <sys_ipc_recv>
	if (err_code < 0) {
  801491:	85 c0                	test   %eax,%eax
  801493:	79 16                	jns    8014ab <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801495:	85 f6                	test   %esi,%esi
  801497:	74 06                	je     80149f <ipc_recv+0x33>
  801499:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80149f:	85 db                	test   %ebx,%ebx
  8014a1:	74 2c                	je     8014cf <ipc_recv+0x63>
  8014a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014a9:	eb 24                	jmp    8014cf <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8014ab:	85 f6                	test   %esi,%esi
  8014ad:	74 0a                	je     8014b9 <ipc_recv+0x4d>
  8014af:	a1 04 40 80 00       	mov    0x804004,%eax
  8014b4:	8b 40 74             	mov    0x74(%eax),%eax
  8014b7:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8014b9:	85 db                	test   %ebx,%ebx
  8014bb:	74 0a                	je     8014c7 <ipc_recv+0x5b>
  8014bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c2:	8b 40 78             	mov    0x78(%eax),%eax
  8014c5:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8014c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8014cc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	57                   	push   %edi
  8014da:	56                   	push   %esi
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 1c             	sub    $0x1c,%esp
  8014df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8014e8:	eb 25                	jmp    80150f <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8014ea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014ed:	74 20                	je     80150f <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8014ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014f3:	c7 44 24 08 3b 2c 80 	movl   $0x802c3b,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801502:	00 
  801503:	c7 04 24 47 2c 80 00 	movl   $0x802c47,(%esp)
  80150a:	e8 a6 ed ff ff       	call   8002b5 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80150f:	85 db                	test   %ebx,%ebx
  801511:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801516:	0f 45 c3             	cmovne %ebx,%eax
  801519:	8b 55 14             	mov    0x14(%ebp),%edx
  80151c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801520:	89 44 24 08          	mov    %eax,0x8(%esp)
  801524:	89 74 24 04          	mov    %esi,0x4(%esp)
  801528:	89 3c 24             	mov    %edi,(%esp)
  80152b:	e8 7c fb ff ff       	call   8010ac <sys_ipc_try_send>
  801530:	85 c0                	test   %eax,%eax
  801532:	75 b6                	jne    8014ea <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801534:	83 c4 1c             	add    $0x1c,%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801542:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801547:	39 c8                	cmp    %ecx,%eax
  801549:	74 17                	je     801562 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80154b:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801550:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801553:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801559:	8b 52 50             	mov    0x50(%edx),%edx
  80155c:	39 ca                	cmp    %ecx,%edx
  80155e:	75 14                	jne    801574 <ipc_find_env+0x38>
  801560:	eb 05                	jmp    801567 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801567:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80156a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80156f:	8b 40 40             	mov    0x40(%eax),%eax
  801572:	eb 0e                	jmp    801582 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801574:	83 c0 01             	add    $0x1,%eax
  801577:	3d 00 04 00 00       	cmp    $0x400,%eax
  80157c:	75 d2                	jne    801550 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80157e:	66 b8 00 00          	mov    $0x0,%ax
}
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    
  801584:	66 90                	xchg   %ax,%ax
  801586:	66 90                	xchg   %ax,%ax
  801588:	66 90                	xchg   %ax,%ax
  80158a:	66 90                	xchg   %ax,%ax
  80158c:	66 90                	xchg   %ax,%ax
  80158e:	66 90                	xchg   %ax,%ax

00801590 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	05 00 00 00 30       	add    $0x30000000,%eax
  80159b:	c1 e8 0c             	shr    $0xc,%eax
}
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    

008015b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015ba:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8015bf:	a8 01                	test   $0x1,%al
  8015c1:	74 34                	je     8015f7 <fd_alloc+0x40>
  8015c3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8015c8:	a8 01                	test   $0x1,%al
  8015ca:	74 32                	je     8015fe <fd_alloc+0x47>
  8015cc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015d1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d3:	89 c2                	mov    %eax,%edx
  8015d5:	c1 ea 16             	shr    $0x16,%edx
  8015d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	74 1f                	je     801603 <fd_alloc+0x4c>
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	c1 ea 0c             	shr    $0xc,%edx
  8015e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f0:	f6 c2 01             	test   $0x1,%dl
  8015f3:	75 1a                	jne    80160f <fd_alloc+0x58>
  8015f5:	eb 0c                	jmp    801603 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015f7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8015fc:	eb 05                	jmp    801603 <fd_alloc+0x4c>
  8015fe:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 08                	mov    %ecx,(%eax)
			return 0;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
  80160d:	eb 1a                	jmp    801629 <fd_alloc+0x72>
  80160f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801614:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801619:	75 b6                	jne    8015d1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801624:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801631:	83 f8 1f             	cmp    $0x1f,%eax
  801634:	77 36                	ja     80166c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801636:	c1 e0 0c             	shl    $0xc,%eax
  801639:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80163e:	89 c2                	mov    %eax,%edx
  801640:	c1 ea 16             	shr    $0x16,%edx
  801643:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80164a:	f6 c2 01             	test   $0x1,%dl
  80164d:	74 24                	je     801673 <fd_lookup+0x48>
  80164f:	89 c2                	mov    %eax,%edx
  801651:	c1 ea 0c             	shr    $0xc,%edx
  801654:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165b:	f6 c2 01             	test   $0x1,%dl
  80165e:	74 1a                	je     80167a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	89 02                	mov    %eax,(%edx)
	return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	eb 13                	jmp    80167f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80166c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801671:	eb 0c                	jmp    80167f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801678:	eb 05                	jmp    80167f <fd_lookup+0x54>
  80167a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
  801685:	83 ec 14             	sub    $0x14,%esp
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80168e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801694:	75 1e                	jne    8016b4 <dev_lookup+0x33>
  801696:	eb 0e                	jmp    8016a6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801698:	b8 20 30 80 00       	mov    $0x803020,%eax
  80169d:	eb 0c                	jmp    8016ab <dev_lookup+0x2a>
  80169f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8016a4:	eb 05                	jmp    8016ab <dev_lookup+0x2a>
  8016a6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8016ab:	89 03                	mov    %eax,(%ebx)
			return 0;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	eb 38                	jmp    8016ec <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8016b4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8016ba:	74 dc                	je     801698 <dev_lookup+0x17>
  8016bc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8016c2:	74 db                	je     80169f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016c4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016ca:	8b 52 48             	mov    0x48(%edx),%edx
  8016cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016d5:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  8016dc:	e8 cd ec ff ff       	call   8003ae <cprintf>
	*dev = 0;
  8016e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8016e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ec:	83 c4 14             	add    $0x14,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    

008016f2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
  8016f7:	83 ec 20             	sub    $0x20,%esp
  8016fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8016fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801707:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80170d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801710:	89 04 24             	mov    %eax,(%esp)
  801713:	e8 13 ff ff ff       	call   80162b <fd_lookup>
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 05                	js     801721 <fd_close+0x2f>
	    || fd != fd2)
  80171c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80171f:	74 0c                	je     80172d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801721:	84 db                	test   %bl,%bl
  801723:	ba 00 00 00 00       	mov    $0x0,%edx
  801728:	0f 44 c2             	cmove  %edx,%eax
  80172b:	eb 3f                	jmp    80176c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80172d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801730:	89 44 24 04          	mov    %eax,0x4(%esp)
  801734:	8b 06                	mov    (%esi),%eax
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	e8 43 ff ff ff       	call   801681 <dev_lookup>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	85 c0                	test   %eax,%eax
  801742:	78 16                	js     80175a <fd_close+0x68>
		if (dev->dev_close)
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80174a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80174f:	85 c0                	test   %eax,%eax
  801751:	74 07                	je     80175a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801753:	89 34 24             	mov    %esi,(%esp)
  801756:	ff d0                	call   *%eax
  801758:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80175a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80175e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801765:	e8 f6 f7 ff ff       	call   800f60 <sys_page_unmap>
	return r;
  80176a:	89 d8                	mov    %ebx,%eax
}
  80176c:	83 c4 20             	add    $0x20,%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	89 04 24             	mov    %eax,(%esp)
  801786:	e8 a0 fe ff ff       	call   80162b <fd_lookup>
  80178b:	89 c2                	mov    %eax,%edx
  80178d:	85 d2                	test   %edx,%edx
  80178f:	78 13                	js     8017a4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801791:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801798:	00 
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	89 04 24             	mov    %eax,(%esp)
  80179f:	e8 4e ff ff ff       	call   8016f2 <fd_close>
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <close_all>:

void
close_all(void)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017b2:	89 1c 24             	mov    %ebx,(%esp)
  8017b5:	e8 b9 ff ff ff       	call   801773 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017ba:	83 c3 01             	add    $0x1,%ebx
  8017bd:	83 fb 20             	cmp    $0x20,%ebx
  8017c0:	75 f0                	jne    8017b2 <close_all+0xc>
		close(i);
}
  8017c2:	83 c4 14             	add    $0x14,%esp
  8017c5:	5b                   	pop    %ebx
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    

008017c8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	57                   	push   %edi
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 48 fe ff ff       	call   80162b <fd_lookup>
  8017e3:	89 c2                	mov    %eax,%edx
  8017e5:	85 d2                	test   %edx,%edx
  8017e7:	0f 88 e1 00 00 00    	js     8018ce <dup+0x106>
		return r;
	close(newfdnum);
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	89 04 24             	mov    %eax,(%esp)
  8017f3:	e8 7b ff ff ff       	call   801773 <close>

	newfd = INDEX2FD(newfdnum);
  8017f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017fb:	c1 e3 0c             	shl    $0xc,%ebx
  8017fe:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 91 fd ff ff       	call   8015a0 <fd2data>
  80180f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801811:	89 1c 24             	mov    %ebx,(%esp)
  801814:	e8 87 fd ff ff       	call   8015a0 <fd2data>
  801819:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80181b:	89 f0                	mov    %esi,%eax
  80181d:	c1 e8 16             	shr    $0x16,%eax
  801820:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801827:	a8 01                	test   $0x1,%al
  801829:	74 43                	je     80186e <dup+0xa6>
  80182b:	89 f0                	mov    %esi,%eax
  80182d:	c1 e8 0c             	shr    $0xc,%eax
  801830:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801837:	f6 c2 01             	test   $0x1,%dl
  80183a:	74 32                	je     80186e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80183c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801843:	25 07 0e 00 00       	and    $0xe07,%eax
  801848:	89 44 24 10          	mov    %eax,0x10(%esp)
  80184c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801850:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801857:	00 
  801858:	89 74 24 04          	mov    %esi,0x4(%esp)
  80185c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801863:	e8 a5 f6 ff ff       	call   800f0d <sys_page_map>
  801868:	89 c6                	mov    %eax,%esi
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 3e                	js     8018ac <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801871:	89 c2                	mov    %eax,%edx
  801873:	c1 ea 0c             	shr    $0xc,%edx
  801876:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801883:	89 54 24 10          	mov    %edx,0x10(%esp)
  801887:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80188b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801892:	00 
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189e:	e8 6a f6 ff ff       	call   800f0d <sys_page_map>
  8018a3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018a8:	85 f6                	test   %esi,%esi
  8018aa:	79 22                	jns    8018ce <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b7:	e8 a4 f6 ff ff       	call   800f60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c7:	e8 94 f6 ff ff       	call   800f60 <sys_page_unmap>
	return r;
  8018cc:	89 f0                	mov    %esi,%eax
}
  8018ce:	83 c4 3c             	add    $0x3c,%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5f                   	pop    %edi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 24             	sub    $0x24,%esp
  8018dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e7:	89 1c 24             	mov    %ebx,(%esp)
  8018ea:	e8 3c fd ff ff       	call   80162b <fd_lookup>
  8018ef:	89 c2                	mov    %eax,%edx
  8018f1:	85 d2                	test   %edx,%edx
  8018f3:	78 6d                	js     801962 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	89 04 24             	mov    %eax,(%esp)
  801904:	e8 78 fd ff ff       	call   801681 <dev_lookup>
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 55                	js     801962 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	8b 50 08             	mov    0x8(%eax),%edx
  801913:	83 e2 03             	and    $0x3,%edx
  801916:	83 fa 01             	cmp    $0x1,%edx
  801919:	75 23                	jne    80193e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80191b:	a1 04 40 80 00       	mov    0x804004,%eax
  801920:	8b 40 48             	mov    0x48(%eax),%eax
  801923:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	c7 04 24 95 2c 80 00 	movl   $0x802c95,(%esp)
  801932:	e8 77 ea ff ff       	call   8003ae <cprintf>
		return -E_INVAL;
  801937:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193c:	eb 24                	jmp    801962 <read+0x8c>
	}
	if (!dev->dev_read)
  80193e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801941:	8b 52 08             	mov    0x8(%edx),%edx
  801944:	85 d2                	test   %edx,%edx
  801946:	74 15                	je     80195d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801948:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80194f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801952:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	ff d2                	call   *%edx
  80195b:	eb 05                	jmp    801962 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80195d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801962:	83 c4 24             	add    $0x24,%esp
  801965:	5b                   	pop    %ebx
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    

00801968 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	57                   	push   %edi
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	83 ec 1c             	sub    $0x1c,%esp
  801971:	8b 7d 08             	mov    0x8(%ebp),%edi
  801974:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801977:	85 f6                	test   %esi,%esi
  801979:	74 33                	je     8019ae <readn+0x46>
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
  801980:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801985:	89 f2                	mov    %esi,%edx
  801987:	29 c2                	sub    %eax,%edx
  801989:	89 54 24 08          	mov    %edx,0x8(%esp)
  80198d:	03 45 0c             	add    0xc(%ebp),%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	89 3c 24             	mov    %edi,(%esp)
  801997:	e8 3a ff ff ff       	call   8018d6 <read>
		if (m < 0)
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 1b                	js     8019bb <readn+0x53>
			return m;
		if (m == 0)
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	74 11                	je     8019b5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019a4:	01 c3                	add    %eax,%ebx
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	39 f3                	cmp    %esi,%ebx
  8019aa:	72 d9                	jb     801985 <readn+0x1d>
  8019ac:	eb 0b                	jmp    8019b9 <readn+0x51>
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	eb 06                	jmp    8019bb <readn+0x53>
  8019b5:	89 d8                	mov    %ebx,%eax
  8019b7:	eb 02                	jmp    8019bb <readn+0x53>
  8019b9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019bb:	83 c4 1c             	add    $0x1c,%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5f                   	pop    %edi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 24             	sub    $0x24,%esp
  8019ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d4:	89 1c 24             	mov    %ebx,(%esp)
  8019d7:	e8 4f fc ff ff       	call   80162b <fd_lookup>
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	85 d2                	test   %edx,%edx
  8019e0:	78 68                	js     801a4a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	89 04 24             	mov    %eax,(%esp)
  8019f1:	e8 8b fc ff ff       	call   801681 <dev_lookup>
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 50                	js     801a4a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a01:	75 23                	jne    801a26 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a03:	a1 04 40 80 00       	mov    0x804004,%eax
  801a08:	8b 40 48             	mov    0x48(%eax),%eax
  801a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a13:	c7 04 24 b1 2c 80 00 	movl   $0x802cb1,(%esp)
  801a1a:	e8 8f e9 ff ff       	call   8003ae <cprintf>
		return -E_INVAL;
  801a1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a24:	eb 24                	jmp    801a4a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a29:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2c:	85 d2                	test   %edx,%edx
  801a2e:	74 15                	je     801a45 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a3e:	89 04 24             	mov    %eax,(%esp)
  801a41:	ff d2                	call   *%edx
  801a43:	eb 05                	jmp    801a4a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a4a:	83 c4 24             	add    $0x24,%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a56:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	89 04 24             	mov    %eax,(%esp)
  801a63:	e8 c3 fb ff ff       	call   80162b <fd_lookup>
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 0e                	js     801a7a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 24             	sub    $0x24,%esp
  801a83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	89 1c 24             	mov    %ebx,(%esp)
  801a90:	e8 96 fb ff ff       	call   80162b <fd_lookup>
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	85 d2                	test   %edx,%edx
  801a99:	78 61                	js     801afc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	89 04 24             	mov    %eax,(%esp)
  801aaa:	e8 d2 fb ff ff       	call   801681 <dev_lookup>
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 49                	js     801afc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aba:	75 23                	jne    801adf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801abc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ac1:	8b 40 48             	mov    0x48(%eax),%eax
  801ac4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acc:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  801ad3:	e8 d6 e8 ff ff       	call   8003ae <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801ad8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801add:	eb 1d                	jmp    801afc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae2:	8b 52 18             	mov    0x18(%edx),%edx
  801ae5:	85 d2                	test   %edx,%edx
  801ae7:	74 0e                	je     801af7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af0:	89 04 24             	mov    %eax,(%esp)
  801af3:	ff d2                	call   *%edx
  801af5:	eb 05                	jmp    801afc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801af7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801afc:	83 c4 24             	add    $0x24,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5d                   	pop    %ebp
  801b01:	c3                   	ret    

00801b02 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	53                   	push   %ebx
  801b06:	83 ec 24             	sub    $0x24,%esp
  801b09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	89 04 24             	mov    %eax,(%esp)
  801b19:	e8 0d fb ff ff       	call   80162b <fd_lookup>
  801b1e:	89 c2                	mov    %eax,%edx
  801b20:	85 d2                	test   %edx,%edx
  801b22:	78 52                	js     801b76 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	89 04 24             	mov    %eax,(%esp)
  801b33:	e8 49 fb ff ff       	call   801681 <dev_lookup>
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 3a                	js     801b76 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b43:	74 2c                	je     801b71 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b45:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b48:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b4f:	00 00 00 
	stat->st_isdir = 0;
  801b52:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b59:	00 00 00 
	stat->st_dev = dev;
  801b5c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b69:	89 14 24             	mov    %edx,(%esp)
  801b6c:	ff 50 14             	call   *0x14(%eax)
  801b6f:	eb 05                	jmp    801b76 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b76:	83 c4 24             	add    $0x24,%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b8b:	00 
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 af 01 00 00       	call   801d46 <open>
  801b97:	89 c3                	mov    %eax,%ebx
  801b99:	85 db                	test   %ebx,%ebx
  801b9b:	78 1b                	js     801bb8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	89 1c 24             	mov    %ebx,(%esp)
  801ba7:	e8 56 ff ff ff       	call   801b02 <fstat>
  801bac:	89 c6                	mov    %eax,%esi
	close(fd);
  801bae:	89 1c 24             	mov    %ebx,(%esp)
  801bb1:	e8 bd fb ff ff       	call   801773 <close>
	return r;
  801bb6:	89 f0                	mov    %esi,%eax
}
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 10             	sub    $0x10,%esp
  801bc7:	89 c6                	mov    %eax,%esi
  801bc9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bcb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801bd2:	75 11                	jne    801be5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bdb:	e8 5c f9 ff ff       	call   80153c <ipc_find_env>
  801be0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801be5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bec:	00 
  801bed:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801bf4:	00 
  801bf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bf9:	a1 00 40 80 00       	mov    0x804000,%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 d0 f8 ff ff       	call   8014d6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c0d:	00 
  801c0e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c19:	e8 4e f8 ff ff       	call   80146c <ipc_recv>
}
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	53                   	push   %ebx
  801c29:	83 ec 14             	sub    $0x14,%esp
  801c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	8b 40 0c             	mov    0xc(%eax),%eax
  801c35:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c44:	e8 76 ff ff ff       	call   801bbf <fsipc>
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	85 d2                	test   %edx,%edx
  801c4d:	78 2b                	js     801c7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c4f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c56:	00 
  801c57:	89 1c 24             	mov    %ebx,(%esp)
  801c5a:	e8 ac ed ff ff       	call   800a0b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c5f:	a1 80 50 80 00       	mov    0x805080,%eax
  801c64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c6a:	a1 84 50 80 00       	mov    0x805084,%eax
  801c6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7a:	83 c4 14             	add    $0x14,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
  801c96:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9b:	e8 1f ff ff ff       	call   801bbf <fsipc>
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 10             	sub    $0x10,%esp
  801caa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801cb8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc8:	e8 f2 fe ff ff       	call   801bbf <fsipc>
  801ccd:	89 c3                	mov    %eax,%ebx
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 6a                	js     801d3d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cd3:	39 c6                	cmp    %eax,%esi
  801cd5:	73 24                	jae    801cfb <devfile_read+0x59>
  801cd7:	c7 44 24 0c ce 2c 80 	movl   $0x802cce,0xc(%esp)
  801cde:	00 
  801cdf:	c7 44 24 08 d5 2c 80 	movl   $0x802cd5,0x8(%esp)
  801ce6:	00 
  801ce7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801cee:	00 
  801cef:	c7 04 24 ea 2c 80 00 	movl   $0x802cea,(%esp)
  801cf6:	e8 ba e5 ff ff       	call   8002b5 <_panic>
	assert(r <= PGSIZE);
  801cfb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d00:	7e 24                	jle    801d26 <devfile_read+0x84>
  801d02:	c7 44 24 0c f5 2c 80 	movl   $0x802cf5,0xc(%esp)
  801d09:	00 
  801d0a:	c7 44 24 08 d5 2c 80 	movl   $0x802cd5,0x8(%esp)
  801d11:	00 
  801d12:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801d19:	00 
  801d1a:	c7 04 24 ea 2c 80 00 	movl   $0x802cea,(%esp)
  801d21:	e8 8f e5 ff ff       	call   8002b5 <_panic>
	memmove(buf, &fsipcbuf, r);
  801d26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d31:	00 
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	89 04 24             	mov    %eax,(%esp)
  801d38:	e8 c9 ee ff ff       	call   800c06 <memmove>
	return r;
}
  801d3d:	89 d8                	mov    %ebx,%eax
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    

00801d46 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	53                   	push   %ebx
  801d4a:	83 ec 24             	sub    $0x24,%esp
  801d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d50:	89 1c 24             	mov    %ebx,(%esp)
  801d53:	e8 58 ec ff ff       	call   8009b0 <strlen>
  801d58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d5d:	7f 60                	jg     801dbf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d62:	89 04 24             	mov    %eax,(%esp)
  801d65:	e8 4d f8 ff ff       	call   8015b7 <fd_alloc>
  801d6a:	89 c2                	mov    %eax,%edx
  801d6c:	85 d2                	test   %edx,%edx
  801d6e:	78 54                	js     801dc4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d74:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d7b:	e8 8b ec ff ff       	call   800a0b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d83:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d90:	e8 2a fe ff ff       	call   801bbf <fsipc>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	79 17                	jns    801db2 <open+0x6c>
		fd_close(fd, 0);
  801d9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da2:	00 
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	89 04 24             	mov    %eax,(%esp)
  801da9:	e8 44 f9 ff ff       	call   8016f2 <fd_close>
		return r;
  801dae:	89 d8                	mov    %ebx,%eax
  801db0:	eb 12                	jmp    801dc4 <open+0x7e>
	}

	return fd2num(fd);
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	89 04 24             	mov    %eax,(%esp)
  801db8:	e8 d3 f7 ff ff       	call   801590 <fd2num>
  801dbd:	eb 05                	jmp    801dc4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dbf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801dc4:	83 c4 24             	add    $0x24,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dd0:	89 d0                	mov    %edx,%eax
  801dd2:	c1 e8 16             	shr    $0x16,%eax
  801dd5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801de1:	f6 c1 01             	test   $0x1,%cl
  801de4:	74 1d                	je     801e03 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801de6:	c1 ea 0c             	shr    $0xc,%edx
  801de9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801df0:	f6 c2 01             	test   $0x1,%dl
  801df3:	74 0e                	je     801e03 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801df5:	c1 ea 0c             	shr    $0xc,%edx
  801df8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801dff:	ef 
  801e00:	0f b7 c0             	movzwl %ax,%eax
}
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	66 90                	xchg   %ax,%ax
  801e07:	66 90                	xchg   %ax,%ax
  801e09:	66 90                	xchg   %ax,%ax
  801e0b:	66 90                	xchg   %ax,%ax
  801e0d:	66 90                	xchg   %ax,%ax
  801e0f:	90                   	nop

00801e10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	83 ec 10             	sub    $0x10,%esp
  801e18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	89 04 24             	mov    %eax,(%esp)
  801e21:	e8 7a f7 ff ff       	call   8015a0 <fd2data>
  801e26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e28:	c7 44 24 04 01 2d 80 	movl   $0x802d01,0x4(%esp)
  801e2f:	00 
  801e30:	89 1c 24             	mov    %ebx,(%esp)
  801e33:	e8 d3 eb ff ff       	call   800a0b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e38:	8b 46 04             	mov    0x4(%esi),%eax
  801e3b:	2b 06                	sub    (%esi),%eax
  801e3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e4a:	00 00 00 
	stat->st_dev = &devpipe;
  801e4d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801e54:	30 80 00 
	return 0;
}
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    

00801e63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	53                   	push   %ebx
  801e67:	83 ec 14             	sub    $0x14,%esp
  801e6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e6d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e78:	e8 e3 f0 ff ff       	call   800f60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e7d:	89 1c 24             	mov    %ebx,(%esp)
  801e80:	e8 1b f7 ff ff       	call   8015a0 <fd2data>
  801e85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e90:	e8 cb f0 ff ff       	call   800f60 <sys_page_unmap>
}
  801e95:	83 c4 14             	add    $0x14,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	57                   	push   %edi
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 2c             	sub    $0x2c,%esp
  801ea4:	89 c6                	mov    %eax,%esi
  801ea6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ea9:	a1 04 40 80 00       	mov    0x804004,%eax
  801eae:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eb1:	89 34 24             	mov    %esi,(%esp)
  801eb4:	e8 11 ff ff ff       	call   801dca <pageref>
  801eb9:	89 c7                	mov    %eax,%edi
  801ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ebe:	89 04 24             	mov    %eax,(%esp)
  801ec1:	e8 04 ff ff ff       	call   801dca <pageref>
  801ec6:	39 c7                	cmp    %eax,%edi
  801ec8:	0f 94 c2             	sete   %dl
  801ecb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801ece:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801ed4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801ed7:	39 fb                	cmp    %edi,%ebx
  801ed9:	74 21                	je     801efc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801edb:	84 d2                	test   %dl,%dl
  801edd:	74 ca                	je     801ea9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801edf:	8b 51 58             	mov    0x58(%ecx),%edx
  801ee2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ee6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eee:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  801ef5:	e8 b4 e4 ff ff       	call   8003ae <cprintf>
  801efa:	eb ad                	jmp    801ea9 <_pipeisclosed+0xe>
	}
}
  801efc:	83 c4 2c             	add    $0x2c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 1c             	sub    $0x1c,%esp
  801f0d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f10:	89 34 24             	mov    %esi,(%esp)
  801f13:	e8 88 f6 ff ff       	call   8015a0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f1c:	74 61                	je     801f7f <devpipe_write+0x7b>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	bf 00 00 00 00       	mov    $0x0,%edi
  801f25:	eb 4a                	jmp    801f71 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f27:	89 da                	mov    %ebx,%edx
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	e8 6b ff ff ff       	call   801e9b <_pipeisclosed>
  801f30:	85 c0                	test   %eax,%eax
  801f32:	75 54                	jne    801f88 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f34:	e8 61 ef ff ff       	call   800e9a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f39:	8b 43 04             	mov    0x4(%ebx),%eax
  801f3c:	8b 0b                	mov    (%ebx),%ecx
  801f3e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f41:	39 d0                	cmp    %edx,%eax
  801f43:	73 e2                	jae    801f27 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f48:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f4c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f4f:	99                   	cltd   
  801f50:	c1 ea 1b             	shr    $0x1b,%edx
  801f53:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f56:	83 e1 1f             	and    $0x1f,%ecx
  801f59:	29 d1                	sub    %edx,%ecx
  801f5b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f5f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f63:	83 c0 01             	add    $0x1,%eax
  801f66:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f69:	83 c7 01             	add    $0x1,%edi
  801f6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f6f:	74 13                	je     801f84 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f71:	8b 43 04             	mov    0x4(%ebx),%eax
  801f74:	8b 0b                	mov    (%ebx),%ecx
  801f76:	8d 51 20             	lea    0x20(%ecx),%edx
  801f79:	39 d0                	cmp    %edx,%eax
  801f7b:	73 aa                	jae    801f27 <devpipe_write+0x23>
  801f7d:	eb c6                	jmp    801f45 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f7f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f84:	89 f8                	mov    %edi,%eax
  801f86:	eb 05                	jmp    801f8d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f8d:	83 c4 1c             	add    $0x1c,%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5f                   	pop    %edi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    

00801f95 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	57                   	push   %edi
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 1c             	sub    $0x1c,%esp
  801f9e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fa1:	89 3c 24             	mov    %edi,(%esp)
  801fa4:	e8 f7 f5 ff ff       	call   8015a0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fad:	74 54                	je     802003 <devpipe_read+0x6e>
  801faf:	89 c3                	mov    %eax,%ebx
  801fb1:	be 00 00 00 00       	mov    $0x0,%esi
  801fb6:	eb 3e                	jmp    801ff6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801fb8:	89 f0                	mov    %esi,%eax
  801fba:	eb 55                	jmp    802011 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fbc:	89 da                	mov    %ebx,%edx
  801fbe:	89 f8                	mov    %edi,%eax
  801fc0:	e8 d6 fe ff ff       	call   801e9b <_pipeisclosed>
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 43                	jne    80200c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fc9:	e8 cc ee ff ff       	call   800e9a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fce:	8b 03                	mov    (%ebx),%eax
  801fd0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fd3:	74 e7                	je     801fbc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fd5:	99                   	cltd   
  801fd6:	c1 ea 1b             	shr    $0x1b,%edx
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	83 e0 1f             	and    $0x1f,%eax
  801fde:	29 d0                	sub    %edx,%eax
  801fe0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801feb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fee:	83 c6 01             	add    $0x1,%esi
  801ff1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff4:	74 12                	je     802008 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ff6:	8b 03                	mov    (%ebx),%eax
  801ff8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ffb:	75 d8                	jne    801fd5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ffd:	85 f6                	test   %esi,%esi
  801fff:	75 b7                	jne    801fb8 <devpipe_read+0x23>
  802001:	eb b9                	jmp    801fbc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802003:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802008:	89 f0                	mov    %esi,%eax
  80200a:	eb 05                	jmp    802011 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802011:	83 c4 1c             	add    $0x1c,%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5f                   	pop    %edi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	56                   	push   %esi
  80201d:	53                   	push   %ebx
  80201e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802021:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802024:	89 04 24             	mov    %eax,(%esp)
  802027:	e8 8b f5 ff ff       	call   8015b7 <fd_alloc>
  80202c:	89 c2                	mov    %eax,%edx
  80202e:	85 d2                	test   %edx,%edx
  802030:	0f 88 4d 01 00 00    	js     802183 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802036:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80203d:	00 
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	89 44 24 04          	mov    %eax,0x4(%esp)
  802045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80204c:	e8 68 ee ff ff       	call   800eb9 <sys_page_alloc>
  802051:	89 c2                	mov    %eax,%edx
  802053:	85 d2                	test   %edx,%edx
  802055:	0f 88 28 01 00 00    	js     802183 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80205b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80205e:	89 04 24             	mov    %eax,(%esp)
  802061:	e8 51 f5 ff ff       	call   8015b7 <fd_alloc>
  802066:	89 c3                	mov    %eax,%ebx
  802068:	85 c0                	test   %eax,%eax
  80206a:	0f 88 fe 00 00 00    	js     80216e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802070:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802077:	00 
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802086:	e8 2e ee ff ff       	call   800eb9 <sys_page_alloc>
  80208b:	89 c3                	mov    %eax,%ebx
  80208d:	85 c0                	test   %eax,%eax
  80208f:	0f 88 d9 00 00 00    	js     80216e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	89 04 24             	mov    %eax,(%esp)
  80209b:	e8 00 f5 ff ff       	call   8015a0 <fd2data>
  8020a0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020a9:	00 
  8020aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b5:	e8 ff ed ff ff       	call   800eb9 <sys_page_alloc>
  8020ba:	89 c3                	mov    %eax,%ebx
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	0f 88 97 00 00 00    	js     80215b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	89 04 24             	mov    %eax,(%esp)
  8020ca:	e8 d1 f4 ff ff       	call   8015a0 <fd2data>
  8020cf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020d6:	00 
  8020d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020e2:	00 
  8020e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ee:	e8 1a ee ff ff       	call   800f0d <sys_page_map>
  8020f3:	89 c3                	mov    %eax,%ebx
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	78 52                	js     80214b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020f9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80210e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 62 f4 ff ff       	call   801590 <fd2num>
  80212e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802131:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 52 f4 ff ff       	call   801590 <fd2num>
  80213e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802141:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
  802149:	eb 38                	jmp    802183 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80214b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80214f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802156:	e8 05 ee ff ff       	call   800f60 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802169:	e8 f2 ed ff ff       	call   800f60 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217c:	e8 df ed ff ff       	call   800f60 <sys_page_unmap>
  802181:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802183:	83 c4 30             	add    $0x30,%esp
  802186:	5b                   	pop    %ebx
  802187:	5e                   	pop    %esi
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    

0080218a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802190:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802193:	89 44 24 04          	mov    %eax,0x4(%esp)
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	e8 89 f4 ff ff       	call   80162b <fd_lookup>
  8021a2:	89 c2                	mov    %eax,%edx
  8021a4:	85 d2                	test   %edx,%edx
  8021a6:	78 15                	js     8021bd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	89 04 24             	mov    %eax,(%esp)
  8021ae:	e8 ed f3 ff ff       	call   8015a0 <fd2data>
	return _pipeisclosed(fd, p);
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	e8 de fc ff ff       	call   801e9b <_pipeisclosed>
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    
  8021bf:	90                   	nop

008021c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021d0:	c7 44 24 04 20 2d 80 	movl   $0x802d20,0x4(%esp)
  8021d7:	00 
  8021d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021db:	89 04 24             	mov    %eax,(%esp)
  8021de:	e8 28 e8 ff ff       	call   800a0b <strcpy>
	return 0;
}
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021fa:	74 4a                	je     802246 <devcons_write+0x5c>
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802206:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80220c:	8b 75 10             	mov    0x10(%ebp),%esi
  80220f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802211:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802214:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802219:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80221c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802220:	03 45 0c             	add    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	89 3c 24             	mov    %edi,(%esp)
  80222a:	e8 d7 e9 ff ff       	call   800c06 <memmove>
		sys_cputs(buf, m);
  80222f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802233:	89 3c 24             	mov    %edi,(%esp)
  802236:	e8 b1 eb ff ff       	call   800dec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80223b:	01 f3                	add    %esi,%ebx
  80223d:	89 d8                	mov    %ebx,%eax
  80223f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802242:	72 c8                	jb     80220c <devcons_write+0x22>
  802244:	eb 05                	jmp    80224b <devcons_write+0x61>
  802246:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80224b:	89 d8                	mov    %ebx,%eax
  80224d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5f                   	pop    %edi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802267:	75 07                	jne    802270 <devcons_read+0x18>
  802269:	eb 28                	jmp    802293 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80226b:	e8 2a ec ff ff       	call   800e9a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802270:	e8 95 eb ff ff       	call   800e0a <sys_cgetc>
  802275:	85 c0                	test   %eax,%eax
  802277:	74 f2                	je     80226b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 16                	js     802293 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80227d:	83 f8 04             	cmp    $0x4,%eax
  802280:	74 0c                	je     80228e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802282:	8b 55 0c             	mov    0xc(%ebp),%edx
  802285:	88 02                	mov    %al,(%edx)
	return 1;
  802287:	b8 01 00 00 00       	mov    $0x1,%eax
  80228c:	eb 05                	jmp    802293 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022a8:	00 
  8022a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ac:	89 04 24             	mov    %eax,(%esp)
  8022af:	e8 38 eb ff ff       	call   800dec <sys_cputs>
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <getchar>:

int
getchar(void)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022c3:	00 
  8022c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d2:	e8 ff f5 ff ff       	call   8018d6 <read>
	if (r < 0)
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 0f                	js     8022ea <getchar+0x34>
		return r;
	if (r < 1)
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	7e 06                	jle    8022e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022e3:	eb 05                	jmp    8022ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	89 04 24             	mov    %eax,(%esp)
  8022ff:	e8 27 f3 ff ff       	call   80162b <fd_lookup>
  802304:	85 c0                	test   %eax,%eax
  802306:	78 11                	js     802319 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802311:	39 10                	cmp    %edx,(%eax)
  802313:	0f 94 c0             	sete   %al
  802316:	0f b6 c0             	movzbl %al,%eax
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <opencons>:

int
opencons(void)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802324:	89 04 24             	mov    %eax,(%esp)
  802327:	e8 8b f2 ff ff       	call   8015b7 <fd_alloc>
		return r;
  80232c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 40                	js     802372 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802332:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802339:	00 
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802341:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802348:	e8 6c eb ff ff       	call   800eb9 <sys_page_alloc>
		return r;
  80234d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 1f                	js     802372 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802353:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802368:	89 04 24             	mov    %eax,(%esp)
  80236b:	e8 20 f2 ff ff       	call   801590 <fd2num>
  802370:	89 c2                	mov    %eax,%edx
}
  802372:	89 d0                	mov    %edx,%eax
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80237c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802383:	75 50                	jne    8023d5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802385:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80238c:	00 
  80238d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802394:	ee 
  802395:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239c:	e8 18 eb ff ff       	call   800eb9 <sys_page_alloc>
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	79 1c                	jns    8023c1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8023a5:	c7 44 24 08 2c 2d 80 	movl   $0x802d2c,0x8(%esp)
  8023ac:	00 
  8023ad:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8023b4:	00 
  8023b5:	c7 04 24 50 2d 80 00 	movl   $0x802d50,(%esp)
  8023bc:	e8 f4 de ff ff       	call   8002b5 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023c1:	c7 44 24 04 df 23 80 	movl   $0x8023df,0x4(%esp)
  8023c8:	00 
  8023c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d0:	e8 84 ec ff ff       	call   801059 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023df:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023e0:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023e5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023e7:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8023ea:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8023ec:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8023f1:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8023f4:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8023f9:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8023fc:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8023fe:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802401:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802403:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802405:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80240a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80240d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802412:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802415:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802417:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80241c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80241f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802424:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802427:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802429:	83 c4 08             	add    $0x8,%esp
	popal
  80242c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80242d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80242e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80242f:	c3                   	ret    

00802430 <__udivdi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80243a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80243e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802442:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802446:	85 c0                	test   %eax,%eax
  802448:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80244c:	89 ea                	mov    %ebp,%edx
  80244e:	89 0c 24             	mov    %ecx,(%esp)
  802451:	75 2d                	jne    802480 <__udivdi3+0x50>
  802453:	39 e9                	cmp    %ebp,%ecx
  802455:	77 61                	ja     8024b8 <__udivdi3+0x88>
  802457:	85 c9                	test   %ecx,%ecx
  802459:	89 ce                	mov    %ecx,%esi
  80245b:	75 0b                	jne    802468 <__udivdi3+0x38>
  80245d:	b8 01 00 00 00       	mov    $0x1,%eax
  802462:	31 d2                	xor    %edx,%edx
  802464:	f7 f1                	div    %ecx
  802466:	89 c6                	mov    %eax,%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	89 e8                	mov    %ebp,%eax
  80246c:	f7 f6                	div    %esi
  80246e:	89 c5                	mov    %eax,%ebp
  802470:	89 f8                	mov    %edi,%eax
  802472:	f7 f6                	div    %esi
  802474:	89 ea                	mov    %ebp,%edx
  802476:	83 c4 0c             	add    $0xc,%esp
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	39 e8                	cmp    %ebp,%eax
  802482:	77 24                	ja     8024a8 <__udivdi3+0x78>
  802484:	0f bd e8             	bsr    %eax,%ebp
  802487:	83 f5 1f             	xor    $0x1f,%ebp
  80248a:	75 3c                	jne    8024c8 <__udivdi3+0x98>
  80248c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802490:	39 34 24             	cmp    %esi,(%esp)
  802493:	0f 86 9f 00 00 00    	jbe    802538 <__udivdi3+0x108>
  802499:	39 d0                	cmp    %edx,%eax
  80249b:	0f 82 97 00 00 00    	jb     802538 <__udivdi3+0x108>
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	83 c4 0c             	add    $0xc,%esp
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
  8024b3:	90                   	nop
  8024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 f8                	mov    %edi,%eax
  8024ba:	f7 f1                	div    %ecx
  8024bc:	31 d2                	xor    %edx,%edx
  8024be:	83 c4 0c             	add    $0xc,%esp
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	8b 3c 24             	mov    (%esp),%edi
  8024cd:	d3 e0                	shl    %cl,%eax
  8024cf:	89 c6                	mov    %eax,%esi
  8024d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d6:	29 e8                	sub    %ebp,%eax
  8024d8:	89 c1                	mov    %eax,%ecx
  8024da:	d3 ef                	shr    %cl,%edi
  8024dc:	89 e9                	mov    %ebp,%ecx
  8024de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024e2:	8b 3c 24             	mov    (%esp),%edi
  8024e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024e9:	89 d6                	mov    %edx,%esi
  8024eb:	d3 e7                	shl    %cl,%edi
  8024ed:	89 c1                	mov    %eax,%ecx
  8024ef:	89 3c 24             	mov    %edi,(%esp)
  8024f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024f6:	d3 ee                	shr    %cl,%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	d3 e2                	shl    %cl,%edx
  8024fc:	89 c1                	mov    %eax,%ecx
  8024fe:	d3 ef                	shr    %cl,%edi
  802500:	09 d7                	or     %edx,%edi
  802502:	89 f2                	mov    %esi,%edx
  802504:	89 f8                	mov    %edi,%eax
  802506:	f7 74 24 08          	divl   0x8(%esp)
  80250a:	89 d6                	mov    %edx,%esi
  80250c:	89 c7                	mov    %eax,%edi
  80250e:	f7 24 24             	mull   (%esp)
  802511:	39 d6                	cmp    %edx,%esi
  802513:	89 14 24             	mov    %edx,(%esp)
  802516:	72 30                	jb     802548 <__udivdi3+0x118>
  802518:	8b 54 24 04          	mov    0x4(%esp),%edx
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	d3 e2                	shl    %cl,%edx
  802520:	39 c2                	cmp    %eax,%edx
  802522:	73 05                	jae    802529 <__udivdi3+0xf9>
  802524:	3b 34 24             	cmp    (%esp),%esi
  802527:	74 1f                	je     802548 <__udivdi3+0x118>
  802529:	89 f8                	mov    %edi,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	e9 7a ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	b8 01 00 00 00       	mov    $0x1,%eax
  80253f:	e9 68 ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802548:	8d 47 ff             	lea    -0x1(%edi),%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	83 c4 0c             	add    $0xc,%esp
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	66 90                	xchg   %ax,%ax
  802556:	66 90                	xchg   %ax,%ax
  802558:	66 90                	xchg   %ax,%ax
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	66 90                	xchg   %ax,%ax
  80255e:	66 90                	xchg   %ax,%ax

00802560 <__umoddi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	83 ec 14             	sub    $0x14,%esp
  802566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80256a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80256e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802572:	89 c7                	mov    %eax,%edi
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	8b 44 24 30          	mov    0x30(%esp),%eax
  80257c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802580:	89 34 24             	mov    %esi,(%esp)
  802583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802587:	85 c0                	test   %eax,%eax
  802589:	89 c2                	mov    %eax,%edx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	75 17                	jne    8025a8 <__umoddi3+0x48>
  802591:	39 fe                	cmp    %edi,%esi
  802593:	76 4b                	jbe    8025e0 <__umoddi3+0x80>
  802595:	89 c8                	mov    %ecx,%eax
  802597:	89 fa                	mov    %edi,%edx
  802599:	f7 f6                	div    %esi
  80259b:	89 d0                	mov    %edx,%eax
  80259d:	31 d2                	xor    %edx,%edx
  80259f:	83 c4 14             	add    $0x14,%esp
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	66 90                	xchg   %ax,%ax
  8025a8:	39 f8                	cmp    %edi,%eax
  8025aa:	77 54                	ja     802600 <__umoddi3+0xa0>
  8025ac:	0f bd e8             	bsr    %eax,%ebp
  8025af:	83 f5 1f             	xor    $0x1f,%ebp
  8025b2:	75 5c                	jne    802610 <__umoddi3+0xb0>
  8025b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025b8:	39 3c 24             	cmp    %edi,(%esp)
  8025bb:	0f 87 e7 00 00 00    	ja     8026a8 <__umoddi3+0x148>
  8025c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025c5:	29 f1                	sub    %esi,%ecx
  8025c7:	19 c7                	sbb    %eax,%edi
  8025c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025d9:	83 c4 14             	add    $0x14,%esp
  8025dc:	5e                   	pop    %esi
  8025dd:	5f                   	pop    %edi
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    
  8025e0:	85 f6                	test   %esi,%esi
  8025e2:	89 f5                	mov    %esi,%ebp
  8025e4:	75 0b                	jne    8025f1 <__umoddi3+0x91>
  8025e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f6                	div    %esi
  8025ef:	89 c5                	mov    %eax,%ebp
  8025f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f5:	31 d2                	xor    %edx,%edx
  8025f7:	f7 f5                	div    %ebp
  8025f9:	89 c8                	mov    %ecx,%eax
  8025fb:	f7 f5                	div    %ebp
  8025fd:	eb 9c                	jmp    80259b <__umoddi3+0x3b>
  8025ff:	90                   	nop
  802600:	89 c8                	mov    %ecx,%eax
  802602:	89 fa                	mov    %edi,%edx
  802604:	83 c4 14             	add    $0x14,%esp
  802607:	5e                   	pop    %esi
  802608:	5f                   	pop    %edi
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    
  80260b:	90                   	nop
  80260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802610:	8b 04 24             	mov    (%esp),%eax
  802613:	be 20 00 00 00       	mov    $0x20,%esi
  802618:	89 e9                	mov    %ebp,%ecx
  80261a:	29 ee                	sub    %ebp,%esi
  80261c:	d3 e2                	shl    %cl,%edx
  80261e:	89 f1                	mov    %esi,%ecx
  802620:	d3 e8                	shr    %cl,%eax
  802622:	89 e9                	mov    %ebp,%ecx
  802624:	89 44 24 04          	mov    %eax,0x4(%esp)
  802628:	8b 04 24             	mov    (%esp),%eax
  80262b:	09 54 24 04          	or     %edx,0x4(%esp)
  80262f:	89 fa                	mov    %edi,%edx
  802631:	d3 e0                	shl    %cl,%eax
  802633:	89 f1                	mov    %esi,%ecx
  802635:	89 44 24 08          	mov    %eax,0x8(%esp)
  802639:	8b 44 24 10          	mov    0x10(%esp),%eax
  80263d:	d3 ea                	shr    %cl,%edx
  80263f:	89 e9                	mov    %ebp,%ecx
  802641:	d3 e7                	shl    %cl,%edi
  802643:	89 f1                	mov    %esi,%ecx
  802645:	d3 e8                	shr    %cl,%eax
  802647:	89 e9                	mov    %ebp,%ecx
  802649:	09 f8                	or     %edi,%eax
  80264b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80264f:	f7 74 24 04          	divl   0x4(%esp)
  802653:	d3 e7                	shl    %cl,%edi
  802655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802659:	89 d7                	mov    %edx,%edi
  80265b:	f7 64 24 08          	mull   0x8(%esp)
  80265f:	39 d7                	cmp    %edx,%edi
  802661:	89 c1                	mov    %eax,%ecx
  802663:	89 14 24             	mov    %edx,(%esp)
  802666:	72 2c                	jb     802694 <__umoddi3+0x134>
  802668:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80266c:	72 22                	jb     802690 <__umoddi3+0x130>
  80266e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802672:	29 c8                	sub    %ecx,%eax
  802674:	19 d7                	sbb    %edx,%edi
  802676:	89 e9                	mov    %ebp,%ecx
  802678:	89 fa                	mov    %edi,%edx
  80267a:	d3 e8                	shr    %cl,%eax
  80267c:	89 f1                	mov    %esi,%ecx
  80267e:	d3 e2                	shl    %cl,%edx
  802680:	89 e9                	mov    %ebp,%ecx
  802682:	d3 ef                	shr    %cl,%edi
  802684:	09 d0                	or     %edx,%eax
  802686:	89 fa                	mov    %edi,%edx
  802688:	83 c4 14             	add    $0x14,%esp
  80268b:	5e                   	pop    %esi
  80268c:	5f                   	pop    %edi
  80268d:	5d                   	pop    %ebp
  80268e:	c3                   	ret    
  80268f:	90                   	nop
  802690:	39 d7                	cmp    %edx,%edi
  802692:	75 da                	jne    80266e <__umoddi3+0x10e>
  802694:	8b 14 24             	mov    (%esp),%edx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80269d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026a1:	eb cb                	jmp    80266e <__umoddi3+0x10e>
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ac:	0f 82 0f ff ff ff    	jb     8025c1 <__umoddi3+0x61>
  8026b2:	e9 1a ff ff ff       	jmp    8025d1 <__umoddi3+0x71>
