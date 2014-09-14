
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 c6 00 00 00       	call   8000f7 <libmain>
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
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 4f 10 00 00       	call   801090 <fork>
  800041:	89 c3                	mov    %eax,%ebx
  800043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800046:	85 c0                	test   %eax,%eax
  800048:	74 3c                	je     800086 <umain+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004a:	e8 ac 0c 00 00       	call   800cfb <sys_getenvid>
  80004f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800053:	89 44 24 04          	mov    %eax,0x4(%esp)
  800057:	c7 04 24 e0 25 80 00 	movl   $0x8025e0,(%esp)
  80005e:	e8 c8 01 00 00       	call   80022b <cprintf>
		ipc_send(who, 0, 0, 0);
  800063:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006a:	00 
  80006b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007a:	00 
  80007b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 ce 12 00 00       	call   801354 <ipc_send>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800086:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800089:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800090:	00 
  800091:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800098:	00 
  800099:	89 34 24             	mov    %esi,(%esp)
  80009c:	e8 4b 12 00 00       	call   8012ec <ipc_recv>
  8000a1:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000a6:	e8 50 0c 00 00       	call   800cfb <sys_getenvid>
  8000ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	c7 04 24 f6 25 80 00 	movl   $0x8025f6,(%esp)
  8000be:	e8 68 01 00 00       	call   80022b <cprintf>
		if (i == 10)
  8000c3:	83 fb 0a             	cmp    $0xa,%ebx
  8000c6:	74 27                	je     8000ef <umain+0xbc>
			return;
		i++;
  8000c8:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d2:	00 
  8000d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000da:	00 
  8000db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	89 04 24             	mov    %eax,(%esp)
  8000e5:	e8 6a 12 00 00       	call   801354 <ipc_send>
		if (i == 10)
  8000ea:	83 fb 0a             	cmp    $0xa,%ebx
  8000ed:	75 9a                	jne    800089 <umain+0x56>
			return;
	}

}
  8000ef:	83 c4 2c             	add    $0x2c,%esp
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 10             	sub    $0x10,%esp
  8000ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800102:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800105:	e8 f1 0b 00 00       	call   800cfb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80010a:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800110:	39 c2                	cmp    %eax,%edx
  800112:	74 17                	je     80012b <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800114:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800119:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80011c:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800122:	8b 49 40             	mov    0x40(%ecx),%ecx
  800125:	39 c1                	cmp    %eax,%ecx
  800127:	75 18                	jne    800141 <libmain+0x4a>
  800129:	eb 05                	jmp    800130 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80012b:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800130:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800133:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800139:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80013f:	eb 0b                	jmp    80014c <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800141:	83 c2 01             	add    $0x1,%edx
  800144:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80014a:	75 cd                	jne    800119 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014c:	85 db                	test   %ebx,%ebx
  80014e:	7e 07                	jle    800157 <libmain+0x60>
		binaryname = argv[0];
  800150:	8b 06                	mov    (%esi),%eax
  800152:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800157:	89 74 24 04          	mov    %esi,0x4(%esp)
  80015b:	89 1c 24             	mov    %ebx,(%esp)
  80015e:	e8 d0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800163:	e8 07 00 00 00       	call   80016f <exit>
}
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    

0080016f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800175:	e8 ac 14 00 00       	call   801626 <close_all>
	sys_env_destroy(0);
  80017a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800181:	e8 23 0b 00 00       	call   800ca9 <sys_env_destroy>
}
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	53                   	push   %ebx
  80018c:	83 ec 14             	sub    $0x14,%esp
  80018f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800192:	8b 13                	mov    (%ebx),%edx
  800194:	8d 42 01             	lea    0x1(%edx),%eax
  800197:	89 03                	mov    %eax,(%ebx)
  800199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a5:	75 19                	jne    8001c0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001a7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ae:	00 
  8001af:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b2:	89 04 24             	mov    %eax,(%esp)
  8001b5:	e8 b2 0a 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  8001ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001c0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c4:	83 c4 14             	add    $0x14,%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001da:	00 00 00 
	b.cnt = 0;
  8001dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	c7 04 24 88 01 80 00 	movl   $0x800188,(%esp)
  800206:	e8 b9 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800211:	89 44 24 04          	mov    %eax,0x4(%esp)
  800215:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021b:	89 04 24             	mov    %eax,(%esp)
  80021e:	e8 49 0a 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  800223:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 87 ff ff ff       	call   8001ca <vcprintf>
	va_end(ap);

	return cnt;
}
  800243:	c9                   	leave  
  800244:	c3                   	ret    
  800245:	66 90                	xchg   %ax,%ax
  800247:	66 90                	xchg   %ax,%ax
  800249:	66 90                	xchg   %ax,%ax
  80024b:	66 90                	xchg   %ax,%ax
  80024d:	66 90                	xchg   %ax,%ax
  80024f:	90                   	nop

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 3c             	sub    $0x3c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800264:	8b 75 0c             	mov    0xc(%ebp),%esi
  800267:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800275:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800278:	39 f1                	cmp    %esi,%ecx
  80027a:	72 14                	jb     800290 <printnum+0x40>
  80027c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80027f:	76 0f                	jbe    800290 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800281:	8b 45 14             	mov    0x14(%ebp),%eax
  800284:	8d 70 ff             	lea    -0x1(%eax),%esi
  800287:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028a:	85 f6                	test   %esi,%esi
  80028c:	7f 60                	jg     8002ee <printnum+0x9e>
  80028e:	eb 72                	jmp    800302 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800290:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800293:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800297:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80029a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80029d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002a9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002ad:	89 c3                	mov    %eax,%ebx
  8002af:	89 d6                	mov    %edx,%esi
  8002b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	e8 6f 20 00 00       	call   802340 <__udivdi3>
  8002d1:	89 d9                	mov    %ebx,%ecx
  8002d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002db:	89 04 24             	mov    %eax,(%esp)
  8002de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e2:	89 fa                	mov    %edi,%edx
  8002e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e7:	e8 64 ff ff ff       	call   800250 <printnum>
  8002ec:	eb 14                	jmp    800302 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002fa:	83 ee 01             	sub    $0x1,%esi
  8002fd:	75 ef                	jne    8002ee <printnum+0x9e>
  8002ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800302:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800306:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80030a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80030d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800310:	89 44 24 08          	mov    %eax,0x8(%esp)
  800314:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	e8 46 21 00 00       	call   802470 <__umoddi3>
  80032a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80032e:	0f be 80 13 26 80 00 	movsbl 0x802613(%eax),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033b:	ff d0                	call   *%eax
}
  80033d:	83 c4 3c             	add    $0x3c,%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800348:	83 fa 01             	cmp    $0x1,%edx
  80034b:	7e 0e                	jle    80035b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80034d:	8b 10                	mov    (%eax),%edx
  80034f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800352:	89 08                	mov    %ecx,(%eax)
  800354:	8b 02                	mov    (%edx),%eax
  800356:	8b 52 04             	mov    0x4(%edx),%edx
  800359:	eb 22                	jmp    80037d <getuint+0x38>
	else if (lflag)
  80035b:	85 d2                	test   %edx,%edx
  80035d:	74 10                	je     80036f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8d 4a 04             	lea    0x4(%edx),%ecx
  800364:	89 08                	mov    %ecx,(%eax)
  800366:	8b 02                	mov    (%edx),%eax
  800368:	ba 00 00 00 00       	mov    $0x0,%edx
  80036d:	eb 0e                	jmp    80037d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80036f:	8b 10                	mov    (%eax),%edx
  800371:	8d 4a 04             	lea    0x4(%edx),%ecx
  800374:	89 08                	mov    %ecx,(%eax)
  800376:	8b 02                	mov    (%edx),%eax
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800385:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	3b 50 04             	cmp    0x4(%eax),%edx
  80038e:	73 0a                	jae    80039a <sprintputch+0x1b>
		*b->buf++ = ch;
  800390:	8d 4a 01             	lea    0x1(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	88 02                	mov    %al,(%edx)
}
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 02 00 00 00       	call   8003c4 <vprintfmt>
	va_end(ap);
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d3:	eb 18                	jmp    8003ed <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	0f 84 c3 03 00 00    	je     8007a0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8003dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e7:	89 f3                	mov    %esi,%ebx
  8003e9:	eb 02                	jmp    8003ed <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003eb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f0:	0f b6 03             	movzbl (%ebx),%eax
  8003f3:	83 f8 25             	cmp    $0x25,%eax
  8003f6:	75 dd                	jne    8003d5 <vprintfmt+0x11>
  8003f8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800403:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80040a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	eb 1d                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80041a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80041e:	eb 15                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800420:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800422:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800426:	eb 0d                	jmp    800435 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8d 5e 01             	lea    0x1(%esi),%ebx
  800438:	0f b6 06             	movzbl (%esi),%eax
  80043b:	0f b6 c8             	movzbl %al,%ecx
  80043e:	83 e8 23             	sub    $0x23,%eax
  800441:	3c 55                	cmp    $0x55,%al
  800443:	0f 87 2f 03 00 00    	ja     800778 <vprintfmt+0x3b4>
  800449:	0f b6 c0             	movzbl %al,%eax
  80044c:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800453:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800456:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800459:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80045d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800460:	83 f9 09             	cmp    $0x9,%ecx
  800463:	77 50                	ja     8004b5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	89 de                	mov    %ebx,%esi
  800467:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80046a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80046d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800470:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800474:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800477:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047a:	83 fb 09             	cmp    $0x9,%ebx
  80047d:	76 eb                	jbe    80046a <vprintfmt+0xa6>
  80047f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800482:	eb 33                	jmp    8004b7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 48 04             	lea    0x4(%eax),%ecx
  80048a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800494:	eb 21                	jmp    8004b7 <vprintfmt+0xf3>
  800496:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800499:	85 c9                	test   %ecx,%ecx
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	0f 49 c1             	cmovns %ecx,%eax
  8004a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
  8004a8:	eb 8b                	jmp    800435 <vprintfmt+0x71>
  8004aa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004ac:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b3:	eb 80                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004bb:	0f 89 74 ff ff ff    	jns    800435 <vprintfmt+0x71>
  8004c1:	e9 62 ff ff ff       	jmp    800428 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cb:	e9 65 ff ff ff       	jmp    800435 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 04 24             	mov    %eax,(%esp)
  8004e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e5:	e9 03 ff ff ff       	jmp    8003ed <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 50 04             	lea    0x4(%eax),%edx
  8004f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	99                   	cltd   
  8004f6:	31 d0                	xor    %edx,%eax
  8004f8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fa:	83 f8 0f             	cmp    $0xf,%eax
  8004fd:	7f 0b                	jg     80050a <vprintfmt+0x146>
  8004ff:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  800506:	85 d2                	test   %edx,%edx
  800508:	75 20                	jne    80052a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80050a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050e:	c7 44 24 08 2b 26 80 	movl   $0x80262b,0x8(%esp)
  800515:	00 
  800516:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 77 fe ff ff       	call   80039c <printfmt>
  800525:	e9 c3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80052a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052e:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800535:	00 
  800536:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 57 fe ff ff       	call   80039c <printfmt>
  800545:	e9 a3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 50 04             	lea    0x4(%eax),%edx
  800556:	89 55 14             	mov    %edx,0x14(%ebp)
  800559:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80055b:	85 c0                	test   %eax,%eax
  80055d:	ba 24 26 80 00       	mov    $0x802624,%edx
  800562:	0f 45 d0             	cmovne %eax,%edx
  800565:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800568:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80056c:	74 04                	je     800572 <vprintfmt+0x1ae>
  80056e:	85 f6                	test   %esi,%esi
  800570:	7f 19                	jg     80058b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800572:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800575:	8d 70 01             	lea    0x1(%eax),%esi
  800578:	0f b6 10             	movzbl (%eax),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	0f 85 95 00 00 00    	jne    80061b <vprintfmt+0x257>
  800586:	e9 85 00 00 00       	jmp    800610 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80058f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800592:	89 04 24             	mov    %eax,(%esp)
  800595:	e8 b8 02 00 00       	call   800852 <strnlen>
  80059a:	29 c6                	sub    %eax,%esi
  80059c:	89 f0                	mov    %esi,%eax
  80059e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005a1:	85 f6                	test   %esi,%esi
  8005a3:	7e cd                	jle    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005a5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ac:	89 c3                	mov    %eax,%ebx
  8005ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b2:	89 34 24             	mov    %esi,(%esp)
  8005b5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	83 eb 01             	sub    $0x1,%ebx
  8005bb:	75 f1                	jne    8005ae <vprintfmt+0x1ea>
  8005bd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c3:	eb ad                	jmp    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c9:	74 1e                	je     8005e9 <vprintfmt+0x225>
  8005cb:	0f be d2             	movsbl %dl,%edx
  8005ce:	83 ea 20             	sub    $0x20,%edx
  8005d1:	83 fa 5e             	cmp    $0x5e,%edx
  8005d4:	76 13                	jbe    8005e9 <vprintfmt+0x225>
					putch('?', putdat);
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e4:	ff 55 08             	call   *0x8(%ebp)
  8005e7:	eb 0d                	jmp    8005f6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f6:	83 ef 01             	sub    $0x1,%edi
  8005f9:	83 c6 01             	add    $0x1,%esi
  8005fc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800600:	0f be c2             	movsbl %dl,%eax
  800603:	85 c0                	test   %eax,%eax
  800605:	75 20                	jne    800627 <vprintfmt+0x263>
  800607:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80060a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800614:	7f 25                	jg     80063b <vprintfmt+0x277>
  800616:	e9 d2 fd ff ff       	jmp    8003ed <vprintfmt+0x29>
  80061b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800621:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800624:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800627:	85 db                	test   %ebx,%ebx
  800629:	78 9a                	js     8005c5 <vprintfmt+0x201>
  80062b:	83 eb 01             	sub    $0x1,%ebx
  80062e:	79 95                	jns    8005c5 <vprintfmt+0x201>
  800630:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800633:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800636:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800639:	eb d5                	jmp    800610 <vprintfmt+0x24c>
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800644:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800648:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80064f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800651:	83 eb 01             	sub    $0x1,%ebx
  800654:	75 ee                	jne    800644 <vprintfmt+0x280>
  800656:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800659:	e9 8f fd ff ff       	jmp    8003ed <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80065e:	83 fa 01             	cmp    $0x1,%edx
  800661:	7e 16                	jle    800679 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	89 55 14             	mov    %edx,0x14(%ebp)
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	eb 32                	jmp    8006ab <vprintfmt+0x2e7>
	else if (lflag)
  800679:	85 d2                	test   %edx,%edx
  80067b:	74 18                	je     800695 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)
  800686:	8b 30                	mov    (%eax),%esi
  800688:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	c1 f8 1f             	sar    $0x1f,%eax
  800690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800693:	eb 16                	jmp    8006ab <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 30                	mov    (%eax),%esi
  8006a0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	c1 f8 1f             	sar    $0x1f,%eax
  8006a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ba:	0f 89 80 00 00 00    	jns    800740 <vprintfmt+0x37c>
				putch('-', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d4:	f7 d8                	neg    %eax
  8006d6:	83 d2 00             	adc    $0x0,%edx
  8006d9:	f7 da                	neg    %edx
			}
			base = 10;
  8006db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e0:	eb 5e                	jmp    800740 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e5:	e8 5b fc ff ff       	call   800345 <getuint>
			base = 10;
  8006ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ef:	eb 4f                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f4:	e8 4c fc ff ff       	call   800345 <getuint>
			base = 8;
  8006f9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006fe:	eb 40                	jmp    800740 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80070e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800712:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800719:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800731:	eb 0d                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800733:	8d 45 14             	lea    0x14(%ebp),%eax
  800736:	e8 0a fc ff ff       	call   800345 <getuint>
			base = 16;
  80073b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800740:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800744:	89 74 24 10          	mov    %esi,0x10(%esp)
  800748:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80074b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80074f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800753:	89 04 24             	mov    %eax,(%esp)
  800756:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075a:	89 fa                	mov    %edi,%edx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	e8 ec fa ff ff       	call   800250 <printnum>
			break;
  800764:	e9 84 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800769:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076d:	89 0c 24             	mov    %ecx,(%esp)
  800770:	ff 55 08             	call   *0x8(%ebp)
			break;
  800773:	e9 75 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800778:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800783:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800786:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80078a:	0f 84 5b fc ff ff    	je     8003eb <vprintfmt+0x27>
  800790:	89 f3                	mov    %esi,%ebx
  800792:	83 eb 01             	sub    $0x1,%ebx
  800795:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800799:	75 f7                	jne    800792 <vprintfmt+0x3ce>
  80079b:	e9 4d fc ff ff       	jmp    8003ed <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007a0:	83 c4 3c             	add    $0x3c,%esp
  8007a3:	5b                   	pop    %ebx
  8007a4:	5e                   	pop    %esi
  8007a5:	5f                   	pop    %edi
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 28             	sub    $0x28,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 30                	je     8007f9 <vsnprintf+0x51>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 2c                	jle    8007f9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e2:	c7 04 24 7f 03 80 00 	movl   $0x80037f,(%esp)
  8007e9:	e8 d6 fb ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	eb 05                	jmp    8007fe <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800806:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800809:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	89 44 24 08          	mov    %eax,0x8(%esp)
  800814:	8b 45 0c             	mov    0xc(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	e8 82 ff ff ff       	call   8007a8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	80 3a 00             	cmpb   $0x0,(%edx)
  800839:	74 10                	je     80084b <strlen+0x1b>
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <strlen+0x10>
  800849:	eb 05                	jmp    800850 <strlen+0x20>
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	85 c9                	test   %ecx,%ecx
  80085e:	74 1c                	je     80087c <strnlen+0x2a>
  800860:	80 3b 00             	cmpb   $0x0,(%ebx)
  800863:	74 1e                	je     800883 <strnlen+0x31>
  800865:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80086a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086c:	39 ca                	cmp    %ecx,%edx
  80086e:	74 18                	je     800888 <strnlen+0x36>
  800870:	83 c2 01             	add    $0x1,%edx
  800873:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800878:	75 f0                	jne    80086a <strnlen+0x18>
  80087a:	eb 0c                	jmp    800888 <strnlen+0x36>
  80087c:	b8 00 00 00 00       	mov    $0x0,%eax
  800881:	eb 05                	jmp    800888 <strnlen+0x36>
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800895:	89 c2                	mov    %eax,%edx
  800897:	83 c2 01             	add    $0x1,%edx
  80089a:	83 c1 01             	add    $0x1,%ecx
  80089d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a4:	84 db                	test   %bl,%bl
  8008a6:	75 ef                	jne    800897 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b5:	89 1c 24             	mov    %ebx,(%esp)
  8008b8:	e8 73 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c4:	01 d8                	add    %ebx,%eax
  8008c6:	89 04 24             	mov    %eax,(%esp)
  8008c9:	e8 bd ff ff ff       	call   80088b <strcpy>
	return dst;
}
  8008ce:	89 d8                	mov    %ebx,%eax
  8008d0:	83 c4 08             	add    $0x8,%esp
  8008d3:	5b                   	pop    %ebx
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	8b 75 08             	mov    0x8(%ebp),%esi
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e4:	85 db                	test   %ebx,%ebx
  8008e6:	74 17                	je     8008ff <strncpy+0x29>
  8008e8:	01 f3                	add    %esi,%ebx
  8008ea:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008ec:	83 c1 01             	add    $0x1,%ecx
  8008ef:	0f b6 02             	movzbl (%edx),%eax
  8008f2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008f8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fb:	39 d9                	cmp    %ebx,%ecx
  8008fd:	75 ed                	jne    8008ec <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800911:	8b 75 10             	mov    0x10(%ebp),%esi
  800914:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800916:	85 f6                	test   %esi,%esi
  800918:	74 34                	je     80094e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80091a:	83 fe 01             	cmp    $0x1,%esi
  80091d:	74 26                	je     800945 <strlcpy+0x40>
  80091f:	0f b6 0b             	movzbl (%ebx),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	74 23                	je     800949 <strlcpy+0x44>
  800926:	83 ee 02             	sub    $0x2,%esi
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800934:	39 f2                	cmp    %esi,%edx
  800936:	74 13                	je     80094b <strlcpy+0x46>
  800938:	83 c2 01             	add    $0x1,%edx
  80093b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 eb                	jne    80092e <strlcpy+0x29>
  800943:	eb 06                	jmp    80094b <strlcpy+0x46>
  800945:	89 f8                	mov    %edi,%eax
  800947:	eb 02                	jmp    80094b <strlcpy+0x46>
  800949:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80094b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094e:	29 f8                	sub    %edi,%eax
}
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095e:	0f b6 01             	movzbl (%ecx),%eax
  800961:	84 c0                	test   %al,%al
  800963:	74 15                	je     80097a <strcmp+0x25>
  800965:	3a 02                	cmp    (%edx),%al
  800967:	75 11                	jne    80097a <strcmp+0x25>
		p++, q++;
  800969:	83 c1 01             	add    $0x1,%ecx
  80096c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80096f:	0f b6 01             	movzbl (%ecx),%eax
  800972:	84 c0                	test   %al,%al
  800974:	74 04                	je     80097a <strcmp+0x25>
  800976:	3a 02                	cmp    (%edx),%al
  800978:	74 ef                	je     800969 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097a:	0f b6 c0             	movzbl %al,%eax
  80097d:	0f b6 12             	movzbl (%edx),%edx
  800980:	29 d0                	sub    %edx,%eax
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800992:	85 f6                	test   %esi,%esi
  800994:	74 29                	je     8009bf <strncmp+0x3b>
  800996:	0f b6 03             	movzbl (%ebx),%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 30                	je     8009cd <strncmp+0x49>
  80099d:	3a 02                	cmp    (%edx),%al
  80099f:	75 2c                	jne    8009cd <strncmp+0x49>
  8009a1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009a4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ab:	39 f0                	cmp    %esi,%eax
  8009ad:	74 17                	je     8009c6 <strncmp+0x42>
  8009af:	0f b6 08             	movzbl (%eax),%ecx
  8009b2:	84 c9                	test   %cl,%cl
  8009b4:	74 17                	je     8009cd <strncmp+0x49>
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	3a 0a                	cmp    (%edx),%cl
  8009bb:	74 e9                	je     8009a6 <strncmp+0x22>
  8009bd:	eb 0e                	jmp    8009cd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	eb 0f                	jmp    8009d5 <strncmp+0x51>
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 08                	jmp    8009d5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 03             	movzbl (%ebx),%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009e3:	0f b6 18             	movzbl (%eax),%ebx
  8009e6:	84 db                	test   %bl,%bl
  8009e8:	74 1d                	je     800a07 <strchr+0x2e>
  8009ea:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009ec:	38 d3                	cmp    %dl,%bl
  8009ee:	75 06                	jne    8009f6 <strchr+0x1d>
  8009f0:	eb 1a                	jmp    800a0c <strchr+0x33>
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 16                	je     800a0c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	0f b6 10             	movzbl (%eax),%edx
  8009fc:	84 d2                	test   %dl,%dl
  8009fe:	75 f2                	jne    8009f2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb 05                	jmp    800a0c <strchr+0x33>
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0c:	5b                   	pop    %ebx
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a19:	0f b6 18             	movzbl (%eax),%ebx
  800a1c:	84 db                	test   %bl,%bl
  800a1e:	74 16                	je     800a36 <strfind+0x27>
  800a20:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a22:	38 d3                	cmp    %dl,%bl
  800a24:	75 06                	jne    800a2c <strfind+0x1d>
  800a26:	eb 0e                	jmp    800a36 <strfind+0x27>
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 0a                	je     800a36 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	0f b6 10             	movzbl (%eax),%edx
  800a32:	84 d2                	test   %dl,%dl
  800a34:	75 f2                	jne    800a28 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a45:	85 c9                	test   %ecx,%ecx
  800a47:	74 36                	je     800a7f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a49:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4f:	75 28                	jne    800a79 <memset+0x40>
  800a51:	f6 c1 03             	test   $0x3,%cl
  800a54:	75 23                	jne    800a79 <memset+0x40>
		c &= 0xFF;
  800a56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5a:	89 d3                	mov    %edx,%ebx
  800a5c:	c1 e3 08             	shl    $0x8,%ebx
  800a5f:	89 d6                	mov    %edx,%esi
  800a61:	c1 e6 18             	shl    $0x18,%esi
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	c1 e0 10             	shl    $0x10,%eax
  800a69:	09 f0                	or     %esi,%eax
  800a6b:	09 c2                	or     %eax,%edx
  800a6d:	89 d0                	mov    %edx,%eax
  800a6f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a71:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a74:	fc                   	cld    
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
  800a77:	eb 06                	jmp    800a7f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	fc                   	cld    
  800a7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7f:	89 f8                	mov    %edi,%eax
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5f                   	pop    %edi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	57                   	push   %edi
  800a8a:	56                   	push   %esi
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a94:	39 c6                	cmp    %eax,%esi
  800a96:	73 35                	jae    800acd <memmove+0x47>
  800a98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 2e                	jae    800acd <memmove+0x47>
		s += n;
		d += n;
  800a9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aac:	75 13                	jne    800ac1 <memmove+0x3b>
  800aae:	f6 c1 03             	test   $0x3,%cl
  800ab1:	75 0e                	jne    800ac1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab3:	83 ef 04             	sub    $0x4,%edi
  800ab6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800abc:	fd                   	std    
  800abd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abf:	eb 09                	jmp    800aca <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac1:	83 ef 01             	sub    $0x1,%edi
  800ac4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac7:	fd                   	std    
  800ac8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aca:	fc                   	cld    
  800acb:	eb 1d                	jmp    800aea <memmove+0x64>
  800acd:	89 f2                	mov    %esi,%edx
  800acf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0f                	jne    800ae5 <memmove+0x5f>
  800ad6:	f6 c1 03             	test   $0x3,%cl
  800ad9:	75 0a                	jne    800ae5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800adb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae3:	eb 05                	jmp    800aea <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae5:	89 c7                	mov    %eax,%edi
  800ae7:	fc                   	cld    
  800ae8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af4:	8b 45 10             	mov    0x10(%ebp),%eax
  800af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	89 04 24             	mov    %eax,(%esp)
  800b08:	e8 79 ff ff ff       	call   800a86 <memmove>
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	57                   	push   %edi
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b21:	85 c0                	test   %eax,%eax
  800b23:	74 36                	je     800b5b <memcmp+0x4c>
		if (*s1 != *s2)
  800b25:	0f b6 03             	movzbl (%ebx),%eax
  800b28:	0f b6 0e             	movzbl (%esi),%ecx
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	38 c8                	cmp    %cl,%al
  800b32:	74 1c                	je     800b50 <memcmp+0x41>
  800b34:	eb 10                	jmp    800b46 <memcmp+0x37>
  800b36:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b3b:	83 c2 01             	add    $0x1,%edx
  800b3e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b42:	38 c8                	cmp    %cl,%al
  800b44:	74 0a                	je     800b50 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b46:	0f b6 c0             	movzbl %al,%eax
  800b49:	0f b6 c9             	movzbl %cl,%ecx
  800b4c:	29 c8                	sub    %ecx,%eax
  800b4e:	eb 10                	jmp    800b60 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b50:	39 fa                	cmp    %edi,%edx
  800b52:	75 e2                	jne    800b36 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	eb 05                	jmp    800b60 <memcmp+0x51>
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	39 d0                	cmp    %edx,%eax
  800b76:	73 13                	jae    800b8b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b78:	89 d9                	mov    %ebx,%ecx
  800b7a:	38 18                	cmp    %bl,(%eax)
  800b7c:	75 06                	jne    800b84 <memfind+0x1f>
  800b7e:	eb 0b                	jmp    800b8b <memfind+0x26>
  800b80:	38 08                	cmp    %cl,(%eax)
  800b82:	74 07                	je     800b8b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	39 d0                	cmp    %edx,%eax
  800b89:	75 f5                	jne    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9a:	0f b6 0a             	movzbl (%edx),%ecx
  800b9d:	80 f9 09             	cmp    $0x9,%cl
  800ba0:	74 05                	je     800ba7 <strtol+0x19>
  800ba2:	80 f9 20             	cmp    $0x20,%cl
  800ba5:	75 10                	jne    800bb7 <strtol+0x29>
		s++;
  800ba7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baa:	0f b6 0a             	movzbl (%edx),%ecx
  800bad:	80 f9 09             	cmp    $0x9,%cl
  800bb0:	74 f5                	je     800ba7 <strtol+0x19>
  800bb2:	80 f9 20             	cmp    $0x20,%cl
  800bb5:	74 f0                	je     800ba7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bb7:	80 f9 2b             	cmp    $0x2b,%cl
  800bba:	75 0a                	jne    800bc6 <strtol+0x38>
		s++;
  800bbc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc4:	eb 11                	jmp    800bd7 <strtol+0x49>
  800bc6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bcb:	80 f9 2d             	cmp    $0x2d,%cl
  800bce:	75 07                	jne    800bd7 <strtol+0x49>
		s++, neg = 1;
  800bd0:	83 c2 01             	add    $0x1,%edx
  800bd3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bdc:	75 15                	jne    800bf3 <strtol+0x65>
  800bde:	80 3a 30             	cmpb   $0x30,(%edx)
  800be1:	75 10                	jne    800bf3 <strtol+0x65>
  800be3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be7:	75 0a                	jne    800bf3 <strtol+0x65>
		s += 2, base = 16;
  800be9:	83 c2 02             	add    $0x2,%edx
  800bec:	b8 10 00 00 00       	mov    $0x10,%eax
  800bf1:	eb 10                	jmp    800c03 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	75 0c                	jne    800c03 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfc:	75 05                	jne    800c03 <strtol+0x75>
		s++, base = 8;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c08:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c0b:	0f b6 0a             	movzbl (%edx),%ecx
  800c0e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c11:	89 f0                	mov    %esi,%eax
  800c13:	3c 09                	cmp    $0x9,%al
  800c15:	77 08                	ja     800c1f <strtol+0x91>
			dig = *s - '0';
  800c17:	0f be c9             	movsbl %cl,%ecx
  800c1a:	83 e9 30             	sub    $0x30,%ecx
  800c1d:	eb 20                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c1f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c22:	89 f0                	mov    %esi,%eax
  800c24:	3c 19                	cmp    $0x19,%al
  800c26:	77 08                	ja     800c30 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c28:	0f be c9             	movsbl %cl,%ecx
  800c2b:	83 e9 57             	sub    $0x57,%ecx
  800c2e:	eb 0f                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c30:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c33:	89 f0                	mov    %esi,%eax
  800c35:	3c 19                	cmp    $0x19,%al
  800c37:	77 16                	ja     800c4f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c39:	0f be c9             	movsbl %cl,%ecx
  800c3c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c3f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c42:	7d 0f                	jge    800c53 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c44:	83 c2 01             	add    $0x1,%edx
  800c47:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c4b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c4d:	eb bc                	jmp    800c0b <strtol+0x7d>
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	eb 02                	jmp    800c55 <strtol+0xc7>
  800c53:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xd2>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c60:	f7 d8                	neg    %eax
  800c62:	85 ff                	test   %edi,%edi
  800c64:	0f 44 c3             	cmove  %ebx,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7e 28                	jle    800cf3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cd6:	00 
  800cd7:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800cde:	00 
  800cdf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ce6:	00 
  800ce7:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800cee:	e8 f3 14 00 00       	call   8021e6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf3:	83 c4 2c             	add    $0x2c,%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
  800d06:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0b:	89 d1                	mov    %edx,%ecx
  800d0d:	89 d3                	mov    %edx,%ebx
  800d0f:	89 d7                	mov    %edx,%edi
  800d11:	89 d6                	mov    %edx,%esi
  800d13:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_yield>:

void
sys_yield(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d20:	ba 00 00 00 00       	mov    $0x0,%edx
  800d25:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d42:	be 00 00 00 00       	mov    $0x0,%esi
  800d47:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d55:	89 f7                	mov    %esi,%edi
  800d57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800d80:	e8 61 14 00 00       	call   8021e6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da7:	8b 75 18             	mov    0x18(%ebp),%esi
  800daa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800dd3:	e8 0e 14 00 00       	call   8021e6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 06 00 00 00       	mov    $0x6,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800e26:	e8 bb 13 00 00       	call   8021e6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 08 00 00 00       	mov    $0x8,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800e79:	e8 68 13 00 00       	call   8021e6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	b8 09 00 00 00       	mov    $0x9,%eax
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7e 28                	jle    800ed1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ead:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800ebc:	00 
  800ebd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ec4:	00 
  800ec5:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800ecc:	e8 15 13 00 00       	call   8021e6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed1:	83 c4 2c             	add    $0x2c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7e 28                	jle    800f24 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f00:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f07:	00 
  800f08:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800f0f:	00 
  800f10:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f17:	00 
  800f18:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800f1f:	e8 c2 12 00 00       	call   8021e6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f24:	83 c4 2c             	add    $0x2c,%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	be 00 00 00 00       	mov    $0x0,%esi
  800f37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f48:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	89 cb                	mov    %ecx,%ebx
  800f67:	89 cf                	mov    %ecx,%edi
  800f69:	89 ce                	mov    %ecx,%esi
  800f6b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	7e 28                	jle    800f99 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f71:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f75:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f7c:	00 
  800f7d:	c7 44 24 08 1f 29 80 	movl   $0x80291f,0x8(%esp)
  800f84:	00 
  800f85:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f8c:	00 
  800f8d:	c7 04 24 3c 29 80 00 	movl   $0x80293c,(%esp)
  800f94:	e8 4d 12 00 00       	call   8021e6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f99:	83 c4 2c             	add    $0x2c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 24             	sub    $0x24,%esp
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fab:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  800fad:	89 da                	mov    %ebx,%edx
  800faf:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  800fb2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  800fb9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fbd:	74 05                	je     800fc4 <pgfault+0x23>
  800fbf:	f6 c6 08             	test   $0x8,%dh
  800fc2:	75 1c                	jne    800fe0 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  800fc4:	c7 44 24 08 4c 29 80 	movl   $0x80294c,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  800fdb:	e8 06 12 00 00       	call   8021e6 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  800fe0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fef:	00 
  800ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ff7:	e8 3d fd ff ff       	call   800d39 <sys_page_alloc>
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	79 20                	jns    801020 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801000:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801004:	c7 44 24 08 b4 29 80 	movl   $0x8029b4,0x8(%esp)
  80100b:	00 
  80100c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801013:	00 
  801014:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  80101b:	e8 c6 11 00 00       	call   8021e6 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801020:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801026:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80102d:	00 
  80102e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801032:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801039:	e8 48 fa ff ff       	call   800a86 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80103e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801045:	00 
  801046:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80104a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801061:	e8 27 fd ff ff       	call   800d8d <sys_page_map>
  801066:	85 c0                	test   %eax,%eax
  801068:	79 20                	jns    80108a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80106a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80106e:	c7 44 24 08 ce 29 80 	movl   $0x8029ce,0x8(%esp)
  801075:	00 
  801076:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80107d:	00 
  80107e:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  801085:	e8 5c 11 00 00       	call   8021e6 <_panic>
	}
}
  80108a:	83 c4 24             	add    $0x24,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801099:	c7 04 24 a1 0f 80 00 	movl   $0x800fa1,(%esp)
  8010a0:	e8 97 11 00 00       	call   80223c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010a5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010aa:	cd 30                	int    $0x30
  8010ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	79 1c                	jns    8010cf <fork+0x3f>
		panic("fork");
  8010b3:	c7 44 24 08 e7 29 80 	movl   $0x8029e7,0x8(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  8010c2:	00 
  8010c3:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  8010ca:	e8 17 11 00 00       	call   8021e6 <_panic>
  8010cf:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  8010d1:	bb 00 08 00 00       	mov    $0x800,%ebx
  8010d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010da:	75 21                	jne    8010fd <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  8010dc:	e8 1a fc ff ff       	call   800cfb <sys_getenvid>
  8010e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ee:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	e9 c5 01 00 00       	jmp    8012c2 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	c1 e8 0a             	shr    $0xa,%eax
  801102:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801109:	a8 01                	test   $0x1,%al
  80110b:	0f 84 f2 00 00 00    	je     801203 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801111:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801118:	a8 05                	test   $0x5,%al
  80111a:	0f 84 e3 00 00 00    	je     801203 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801120:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801127:	89 de                	mov    %ebx,%esi
  801129:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80112c:	a9 02 08 00 00       	test   $0x802,%eax
  801131:	0f 84 88 00 00 00    	je     8011bf <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801137:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80113e:	00 
  80113f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801143:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801147:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801152:	e8 36 fc ff ff       	call   800d8d <sys_page_map>
  801157:	85 c0                	test   %eax,%eax
  801159:	79 20                	jns    80117b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80115b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115f:	c7 44 24 08 ec 29 80 	movl   $0x8029ec,0x8(%esp)
  801166:	00 
  801167:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80116e:	00 
  80116f:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  801176:	e8 6b 10 00 00       	call   8021e6 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80117b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801182:	00 
  801183:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801187:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80118e:	00 
  80118f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801193:	89 3c 24             	mov    %edi,(%esp)
  801196:	e8 f2 fb ff ff       	call   800d8d <sys_page_map>
  80119b:	85 c0                	test   %eax,%eax
  80119d:	79 64                	jns    801203 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80119f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011a3:	c7 44 24 08 06 2a 80 	movl   $0x802a06,0x8(%esp)
  8011aa:	00 
  8011ab:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8011b2:	00 
  8011b3:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  8011ba:	e8 27 10 00 00       	call   8021e6 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8011bf:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8011c6:	00 
  8011c7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011da:	e8 ae fb ff ff       	call   800d8d <sys_page_map>
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	79 20                	jns    801203 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  8011e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e7:	c7 44 24 08 20 2a 80 	movl   $0x802a20,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  8011fe:	e8 e3 0f 00 00       	call   8021e6 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801203:	83 c3 01             	add    $0x1,%ebx
  801206:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80120c:	0f 85 eb fe ff ff    	jne    8010fd <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801212:	c7 44 24 04 a5 22 80 	movl   $0x8022a5,0x4(%esp)
  801219:	00 
  80121a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121d:	89 04 24             	mov    %eax,(%esp)
  801220:	e8 b4 fc ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
  801225:	85 c0                	test   %eax,%eax
  801227:	79 20                	jns    801249 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801229:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122d:	c7 44 24 08 84 29 80 	movl   $0x802984,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  801244:	e8 9d 0f 00 00       	call   8021e6 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801249:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801250:	00 
  801251:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801258:	ee 
  801259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125c:	89 04 24             	mov    %eax,(%esp)
  80125f:	e8 d5 fa ff ff       	call   800d39 <sys_page_alloc>
  801264:	85 c0                	test   %eax,%eax
  801266:	79 20                	jns    801288 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126c:	c7 44 24 08 32 2a 80 	movl   $0x802a32,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  801283:	e8 5e 0f 00 00       	call   8021e6 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801288:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80128f:	00 
  801290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801293:	89 04 24             	mov    %eax,(%esp)
  801296:	e8 98 fb ff ff       	call   800e33 <sys_env_set_status>
  80129b:	85 c0                	test   %eax,%eax
  80129d:	79 20                	jns    8012bf <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80129f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a3:	c7 44 24 08 4a 2a 80 	movl   $0x802a4a,0x8(%esp)
  8012aa:	00 
  8012ab:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  8012b2:	00 
  8012b3:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  8012ba:	e8 27 0f 00 00       	call   8021e6 <_panic>
	}

	return envid;
  8012bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8012c2:	83 c4 2c             	add    $0x2c,%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <sfork>:

// Challenge!
int
sfork(void)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012d0:	c7 44 24 08 65 2a 80 	movl   $0x802a65,0x8(%esp)
  8012d7:	00 
  8012d8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  8012df:	00 
  8012e0:	c7 04 24 a9 29 80 00 	movl   $0x8029a9,(%esp)
  8012e7:	e8 fa 0e 00 00       	call   8021e6 <_panic>

008012ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	83 ec 10             	sub    $0x10,%esp
  8012f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801304:	0f 44 c2             	cmove  %edx,%eax
  801307:	89 04 24             	mov    %eax,(%esp)
  80130a:	e8 40 fc ff ff       	call   800f4f <sys_ipc_recv>
	if (err_code < 0) {
  80130f:	85 c0                	test   %eax,%eax
  801311:	79 16                	jns    801329 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801313:	85 f6                	test   %esi,%esi
  801315:	74 06                	je     80131d <ipc_recv+0x31>
  801317:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80131d:	85 db                	test   %ebx,%ebx
  80131f:	74 2c                	je     80134d <ipc_recv+0x61>
  801321:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801327:	eb 24                	jmp    80134d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801329:	85 f6                	test   %esi,%esi
  80132b:	74 0a                	je     801337 <ipc_recv+0x4b>
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	8b 40 74             	mov    0x74(%eax),%eax
  801335:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801337:	85 db                	test   %ebx,%ebx
  801339:	74 0a                	je     801345 <ipc_recv+0x59>
  80133b:	a1 04 40 80 00       	mov    0x804004,%eax
  801340:	8b 40 78             	mov    0x78(%eax),%eax
  801343:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801345:	a1 04 40 80 00       	mov    0x804004,%eax
  80134a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	5b                   	pop    %ebx
  801351:	5e                   	pop    %esi
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	83 ec 1c             	sub    $0x1c,%esp
  80135d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801360:	8b 75 0c             	mov    0xc(%ebp),%esi
  801363:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801366:	eb 25                	jmp    80138d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801368:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80136b:	74 20                	je     80138d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  80136d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801371:	c7 44 24 08 7b 2a 80 	movl   $0x802a7b,0x8(%esp)
  801378:	00 
  801379:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801380:	00 
  801381:	c7 04 24 87 2a 80 00 	movl   $0x802a87,(%esp)
  801388:	e8 59 0e 00 00       	call   8021e6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80138d:	85 db                	test   %ebx,%ebx
  80138f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801394:	0f 45 c3             	cmovne %ebx,%eax
  801397:	8b 55 14             	mov    0x14(%ebp),%edx
  80139a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80139e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a6:	89 3c 24             	mov    %edi,(%esp)
  8013a9:	e8 7e fb ff ff       	call   800f2c <sys_ipc_try_send>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	75 b6                	jne    801368 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8013b2:	83 c4 1c             	add    $0x1c,%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8013c0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8013c5:	39 c8                	cmp    %ecx,%eax
  8013c7:	74 17                	je     8013e0 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8013c9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8013ce:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013d1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013d7:	8b 52 50             	mov    0x50(%edx),%edx
  8013da:	39 ca                	cmp    %ecx,%edx
  8013dc:	75 14                	jne    8013f2 <ipc_find_env+0x38>
  8013de:	eb 05                	jmp    8013e5 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8013e5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013e8:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8013ed:	8b 40 40             	mov    0x40(%eax),%eax
  8013f0:	eb 0e                	jmp    801400 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8013f2:	83 c0 01             	add    $0x1,%eax
  8013f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013fa:	75 d2                	jne    8013ce <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8013fc:	66 b8 00 00          	mov    $0x0,%ax
}
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
  801402:	66 90                	xchg   %ax,%ax
  801404:	66 90                	xchg   %ax,%ax
  801406:	66 90                	xchg   %ax,%ax
  801408:	66 90                	xchg   %ax,%ax
  80140a:	66 90                	xchg   %ax,%ax
  80140c:	66 90                	xchg   %ax,%ax
  80140e:	66 90                	xchg   %ax,%ax

00801410 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	05 00 00 00 30       	add    $0x30000000,%eax
  80141b:	c1 e8 0c             	shr    $0xc,%eax
}
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80142b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801430:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80143a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80143f:	a8 01                	test   $0x1,%al
  801441:	74 34                	je     801477 <fd_alloc+0x40>
  801443:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801448:	a8 01                	test   $0x1,%al
  80144a:	74 32                	je     80147e <fd_alloc+0x47>
  80144c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801451:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801453:	89 c2                	mov    %eax,%edx
  801455:	c1 ea 16             	shr    $0x16,%edx
  801458:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80145f:	f6 c2 01             	test   $0x1,%dl
  801462:	74 1f                	je     801483 <fd_alloc+0x4c>
  801464:	89 c2                	mov    %eax,%edx
  801466:	c1 ea 0c             	shr    $0xc,%edx
  801469:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801470:	f6 c2 01             	test   $0x1,%dl
  801473:	75 1a                	jne    80148f <fd_alloc+0x58>
  801475:	eb 0c                	jmp    801483 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801477:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80147c:	eb 05                	jmp    801483 <fd_alloc+0x4c>
  80147e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	89 08                	mov    %ecx,(%eax)
			return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
  80148d:	eb 1a                	jmp    8014a9 <fd_alloc+0x72>
  80148f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801494:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801499:	75 b6                	jne    801451 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014a4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    

008014ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014b1:	83 f8 1f             	cmp    $0x1f,%eax
  8014b4:	77 36                	ja     8014ec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014b6:	c1 e0 0c             	shl    $0xc,%eax
  8014b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014be:	89 c2                	mov    %eax,%edx
  8014c0:	c1 ea 16             	shr    $0x16,%edx
  8014c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014ca:	f6 c2 01             	test   $0x1,%dl
  8014cd:	74 24                	je     8014f3 <fd_lookup+0x48>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	c1 ea 0c             	shr    $0xc,%edx
  8014d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014db:	f6 c2 01             	test   $0x1,%dl
  8014de:	74 1a                	je     8014fa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	eb 13                	jmp    8014ff <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f1:	eb 0c                	jmp    8014ff <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f8:	eb 05                	jmp    8014ff <fd_lookup+0x54>
  8014fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	53                   	push   %ebx
  801505:	83 ec 14             	sub    $0x14,%esp
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80150e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801514:	75 1e                	jne    801534 <dev_lookup+0x33>
  801516:	eb 0e                	jmp    801526 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801518:	b8 20 30 80 00       	mov    $0x803020,%eax
  80151d:	eb 0c                	jmp    80152b <dev_lookup+0x2a>
  80151f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801524:	eb 05                	jmp    80152b <dev_lookup+0x2a>
  801526:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80152b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	eb 38                	jmp    80156c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801534:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80153a:	74 dc                	je     801518 <dev_lookup+0x17>
  80153c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801542:	74 db                	je     80151f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801544:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80154a:	8b 52 48             	mov    0x48(%edx),%edx
  80154d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801551:	89 54 24 04          	mov    %edx,0x4(%esp)
  801555:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  80155c:	e8 ca ec ff ff       	call   80022b <cprintf>
	*dev = 0;
  801561:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156c:	83 c4 14             	add    $0x14,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
  801577:	83 ec 20             	sub    $0x20,%esp
  80157a:	8b 75 08             	mov    0x8(%ebp),%esi
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801580:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801583:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801587:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80158d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801590:	89 04 24             	mov    %eax,(%esp)
  801593:	e8 13 ff ff ff       	call   8014ab <fd_lookup>
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 05                	js     8015a1 <fd_close+0x2f>
	    || fd != fd2)
  80159c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80159f:	74 0c                	je     8015ad <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015a1:	84 db                	test   %bl,%bl
  8015a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a8:	0f 44 c2             	cmove  %edx,%eax
  8015ab:	eb 3f                	jmp    8015ec <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b4:	8b 06                	mov    (%esi),%eax
  8015b6:	89 04 24             	mov    %eax,(%esp)
  8015b9:	e8 43 ff ff ff       	call   801501 <dev_lookup>
  8015be:	89 c3                	mov    %eax,%ebx
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 16                	js     8015da <fd_close+0x68>
		if (dev->dev_close)
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 07                	je     8015da <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015d3:	89 34 24             	mov    %esi,(%esp)
  8015d6:	ff d0                	call   *%eax
  8015d8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e5:	e8 f6 f7 ff ff       	call   800de0 <sys_page_unmap>
	return r;
  8015ea:	89 d8                	mov    %ebx,%eax
}
  8015ec:	83 c4 20             	add    $0x20,%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 a0 fe ff ff       	call   8014ab <fd_lookup>
  80160b:	89 c2                	mov    %eax,%edx
  80160d:	85 d2                	test   %edx,%edx
  80160f:	78 13                	js     801624 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801611:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801618:	00 
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	89 04 24             	mov    %eax,(%esp)
  80161f:	e8 4e ff ff ff       	call   801572 <fd_close>
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <close_all>:

void
close_all(void)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	53                   	push   %ebx
  80162a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80162d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801632:	89 1c 24             	mov    %ebx,(%esp)
  801635:	e8 b9 ff ff ff       	call   8015f3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80163a:	83 c3 01             	add    $0x1,%ebx
  80163d:	83 fb 20             	cmp    $0x20,%ebx
  801640:	75 f0                	jne    801632 <close_all+0xc>
		close(i);
}
  801642:	83 c4 14             	add    $0x14,%esp
  801645:	5b                   	pop    %ebx
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	57                   	push   %edi
  80164c:	56                   	push   %esi
  80164d:	53                   	push   %ebx
  80164e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801651:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	89 04 24             	mov    %eax,(%esp)
  80165e:	e8 48 fe ff ff       	call   8014ab <fd_lookup>
  801663:	89 c2                	mov    %eax,%edx
  801665:	85 d2                	test   %edx,%edx
  801667:	0f 88 e1 00 00 00    	js     80174e <dup+0x106>
		return r;
	close(newfdnum);
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	e8 7b ff ff ff       	call   8015f3 <close>

	newfd = INDEX2FD(newfdnum);
  801678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80167b:	c1 e3 0c             	shl    $0xc,%ebx
  80167e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801687:	89 04 24             	mov    %eax,(%esp)
  80168a:	e8 91 fd ff ff       	call   801420 <fd2data>
  80168f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801691:	89 1c 24             	mov    %ebx,(%esp)
  801694:	e8 87 fd ff ff       	call   801420 <fd2data>
  801699:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169b:	89 f0                	mov    %esi,%eax
  80169d:	c1 e8 16             	shr    $0x16,%eax
  8016a0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a7:	a8 01                	test   $0x1,%al
  8016a9:	74 43                	je     8016ee <dup+0xa6>
  8016ab:	89 f0                	mov    %esi,%eax
  8016ad:	c1 e8 0c             	shr    $0xc,%eax
  8016b0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016b7:	f6 c2 01             	test   $0x1,%dl
  8016ba:	74 32                	je     8016ee <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016d7:	00 
  8016d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e3:	e8 a5 f6 ff ff       	call   800d8d <sys_page_map>
  8016e8:	89 c6                	mov    %eax,%esi
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	78 3e                	js     80172c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	c1 ea 0c             	shr    $0xc,%edx
  8016f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016fd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801703:	89 54 24 10          	mov    %edx,0x10(%esp)
  801707:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80170b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801712:	00 
  801713:	89 44 24 04          	mov    %eax,0x4(%esp)
  801717:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171e:	e8 6a f6 ff ff       	call   800d8d <sys_page_map>
  801723:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801728:	85 f6                	test   %esi,%esi
  80172a:	79 22                	jns    80174e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80172c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801737:	e8 a4 f6 ff ff       	call   800de0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80173c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801747:	e8 94 f6 ff ff       	call   800de0 <sys_page_unmap>
	return r;
  80174c:	89 f0                	mov    %esi,%eax
}
  80174e:	83 c4 3c             	add    $0x3c,%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5f                   	pop    %edi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	53                   	push   %ebx
  80175a:	83 ec 24             	sub    $0x24,%esp
  80175d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801760:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801763:	89 44 24 04          	mov    %eax,0x4(%esp)
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 3c fd ff ff       	call   8014ab <fd_lookup>
  80176f:	89 c2                	mov    %eax,%edx
  801771:	85 d2                	test   %edx,%edx
  801773:	78 6d                	js     8017e2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	89 04 24             	mov    %eax,(%esp)
  801784:	e8 78 fd ff ff       	call   801501 <dev_lookup>
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 55                	js     8017e2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801790:	8b 50 08             	mov    0x8(%eax),%edx
  801793:	83 e2 03             	and    $0x3,%edx
  801796:	83 fa 01             	cmp    $0x1,%edx
  801799:	75 23                	jne    8017be <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80179b:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a0:	8b 40 48             	mov    0x48(%eax),%eax
  8017a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ab:	c7 04 24 d5 2a 80 00 	movl   $0x802ad5,(%esp)
  8017b2:	e8 74 ea ff ff       	call   80022b <cprintf>
		return -E_INVAL;
  8017b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bc:	eb 24                	jmp    8017e2 <read+0x8c>
	}
	if (!dev->dev_read)
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	8b 52 08             	mov    0x8(%edx),%edx
  8017c4:	85 d2                	test   %edx,%edx
  8017c6:	74 15                	je     8017dd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017d6:	89 04 24             	mov    %eax,(%esp)
  8017d9:	ff d2                	call   *%edx
  8017db:	eb 05                	jmp    8017e2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017e2:	83 c4 24             	add    $0x24,%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017f7:	85 f6                	test   %esi,%esi
  8017f9:	74 33                	je     80182e <readn+0x46>
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801805:	89 f2                	mov    %esi,%edx
  801807:	29 c2                	sub    %eax,%edx
  801809:	89 54 24 08          	mov    %edx,0x8(%esp)
  80180d:	03 45 0c             	add    0xc(%ebp),%eax
  801810:	89 44 24 04          	mov    %eax,0x4(%esp)
  801814:	89 3c 24             	mov    %edi,(%esp)
  801817:	e8 3a ff ff ff       	call   801756 <read>
		if (m < 0)
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 1b                	js     80183b <readn+0x53>
			return m;
		if (m == 0)
  801820:	85 c0                	test   %eax,%eax
  801822:	74 11                	je     801835 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801824:	01 c3                	add    %eax,%ebx
  801826:	89 d8                	mov    %ebx,%eax
  801828:	39 f3                	cmp    %esi,%ebx
  80182a:	72 d9                	jb     801805 <readn+0x1d>
  80182c:	eb 0b                	jmp    801839 <readn+0x51>
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	eb 06                	jmp    80183b <readn+0x53>
  801835:	89 d8                	mov    %ebx,%eax
  801837:	eb 02                	jmp    80183b <readn+0x53>
  801839:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80183b:	83 c4 1c             	add    $0x1c,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	83 ec 24             	sub    $0x24,%esp
  80184a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801850:	89 44 24 04          	mov    %eax,0x4(%esp)
  801854:	89 1c 24             	mov    %ebx,(%esp)
  801857:	e8 4f fc ff ff       	call   8014ab <fd_lookup>
  80185c:	89 c2                	mov    %eax,%edx
  80185e:	85 d2                	test   %edx,%edx
  801860:	78 68                	js     8018ca <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801865:	89 44 24 04          	mov    %eax,0x4(%esp)
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 8b fc ff ff       	call   801501 <dev_lookup>
  801876:	85 c0                	test   %eax,%eax
  801878:	78 50                	js     8018ca <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801881:	75 23                	jne    8018a6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801883:	a1 04 40 80 00       	mov    0x804004,%eax
  801888:	8b 40 48             	mov    0x48(%eax),%eax
  80188b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80188f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801893:	c7 04 24 f1 2a 80 00 	movl   $0x802af1,(%esp)
  80189a:	e8 8c e9 ff ff       	call   80022b <cprintf>
		return -E_INVAL;
  80189f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a4:	eb 24                	jmp    8018ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ac:	85 d2                	test   %edx,%edx
  8018ae:	74 15                	je     8018c5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	ff d2                	call   *%edx
  8018c3:	eb 05                	jmp    8018ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ca:	83 c4 24             	add    $0x24,%esp
  8018cd:	5b                   	pop    %ebx
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    

008018d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	89 04 24             	mov    %eax,(%esp)
  8018e3:	e8 c3 fb ff ff       	call   8014ab <fd_lookup>
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	78 0e                	js     8018fa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	53                   	push   %ebx
  801900:	83 ec 24             	sub    $0x24,%esp
  801903:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801906:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190d:	89 1c 24             	mov    %ebx,(%esp)
  801910:	e8 96 fb ff ff       	call   8014ab <fd_lookup>
  801915:	89 c2                	mov    %eax,%edx
  801917:	85 d2                	test   %edx,%edx
  801919:	78 61                	js     80197c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	8b 00                	mov    (%eax),%eax
  801927:	89 04 24             	mov    %eax,(%esp)
  80192a:	e8 d2 fb ff ff       	call   801501 <dev_lookup>
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 49                	js     80197c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801936:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193a:	75 23                	jne    80195f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80193c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801941:	8b 40 48             	mov    0x48(%eax),%eax
  801944:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194c:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  801953:	e8 d3 e8 ff ff       	call   80022b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195d:	eb 1d                	jmp    80197c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80195f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801962:	8b 52 18             	mov    0x18(%edx),%edx
  801965:	85 d2                	test   %edx,%edx
  801967:	74 0e                	je     801977 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	ff d2                	call   *%edx
  801975:	eb 05                	jmp    80197c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801977:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80197c:	83 c4 24             	add    $0x24,%esp
  80197f:	5b                   	pop    %ebx
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    

00801982 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	53                   	push   %ebx
  801986:	83 ec 24             	sub    $0x24,%esp
  801989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 0d fb ff ff       	call   8014ab <fd_lookup>
  80199e:	89 c2                	mov    %eax,%edx
  8019a0:	85 d2                	test   %edx,%edx
  8019a2:	78 52                	js     8019f6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	89 04 24             	mov    %eax,(%esp)
  8019b3:	e8 49 fb ff ff       	call   801501 <dev_lookup>
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 3a                	js     8019f6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019c3:	74 2c                	je     8019f1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019cf:	00 00 00 
	stat->st_isdir = 0;
  8019d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019d9:	00 00 00 
	stat->st_dev = dev;
  8019dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e9:	89 14 24             	mov    %edx,(%esp)
  8019ec:	ff 50 14             	call   *0x14(%eax)
  8019ef:	eb 05                	jmp    8019f6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019f6:	83 c4 24             	add    $0x24,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
  801a01:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a0b:	00 
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	89 04 24             	mov    %eax,(%esp)
  801a12:	e8 e1 01 00 00       	call   801bf8 <open>
  801a17:	89 c3                	mov    %eax,%ebx
  801a19:	85 db                	test   %ebx,%ebx
  801a1b:	78 1b                	js     801a38 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	89 1c 24             	mov    %ebx,(%esp)
  801a27:	e8 56 ff ff ff       	call   801982 <fstat>
  801a2c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a2e:	89 1c 24             	mov    %ebx,(%esp)
  801a31:	e8 bd fb ff ff       	call   8015f3 <close>
	return r;
  801a36:	89 f0                	mov    %esi,%eax
}
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	83 ec 10             	sub    $0x10,%esp
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a4b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a52:	75 11                	jne    801a65 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a5b:	e8 5a f9 ff ff       	call   8013ba <ipc_find_env>
  801a60:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801a65:	a1 04 40 80 00       	mov    0x804004,%eax
  801a6a:	8b 40 48             	mov    0x48(%eax),%eax
  801a6d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801a73:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7f:	c7 04 24 0e 2b 80 00 	movl   $0x802b0e,(%esp)
  801a86:	e8 a0 e7 ff ff       	call   80022b <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a8b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a92:	00 
  801a93:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801a9a:	00 
  801a9b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9f:	a1 00 40 80 00       	mov    0x804000,%eax
  801aa4:	89 04 24             	mov    %eax,(%esp)
  801aa7:	e8 a8 f8 ff ff       	call   801354 <ipc_send>
	cprintf("ipc_send\n");
  801aac:	c7 04 24 24 2b 80 00 	movl   $0x802b24,(%esp)
  801ab3:	e8 73 e7 ff ff       	call   80022b <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801ab8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801abf:	00 
  801ac0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801acb:	e8 1c f8 ff ff       	call   8012ec <ipc_recv>
}
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	53                   	push   %ebx
  801adb:	83 ec 14             	sub    $0x14,%esp
  801ade:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aec:	ba 00 00 00 00       	mov    $0x0,%edx
  801af1:	b8 05 00 00 00       	mov    $0x5,%eax
  801af6:	e8 44 ff ff ff       	call   801a3f <fsipc>
  801afb:	89 c2                	mov    %eax,%edx
  801afd:	85 d2                	test   %edx,%edx
  801aff:	78 2b                	js     801b2c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b01:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b08:	00 
  801b09:	89 1c 24             	mov    %ebx,(%esp)
  801b0c:	e8 7a ed ff ff       	call   80088b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b11:	a1 80 50 80 00       	mov    0x805080,%eax
  801b16:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b1c:	a1 84 50 80 00       	mov    0x805084,%eax
  801b21:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2c:	83 c4 14             	add    $0x14,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5d                   	pop    %ebp
  801b31:	c3                   	ret    

00801b32 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b43:	ba 00 00 00 00       	mov    $0x0,%edx
  801b48:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4d:	e8 ed fe ff ff       	call   801a3f <fsipc>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	83 ec 10             	sub    $0x10,%esp
  801b5c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	8b 40 0c             	mov    0xc(%eax),%eax
  801b65:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b6a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
  801b75:	b8 03 00 00 00       	mov    $0x3,%eax
  801b7a:	e8 c0 fe ff ff       	call   801a3f <fsipc>
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 6a                	js     801bef <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b85:	39 c6                	cmp    %eax,%esi
  801b87:	73 24                	jae    801bad <devfile_read+0x59>
  801b89:	c7 44 24 0c 2e 2b 80 	movl   $0x802b2e,0xc(%esp)
  801b90:	00 
  801b91:	c7 44 24 08 35 2b 80 	movl   $0x802b35,0x8(%esp)
  801b98:	00 
  801b99:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ba0:	00 
  801ba1:	c7 04 24 4a 2b 80 00 	movl   $0x802b4a,(%esp)
  801ba8:	e8 39 06 00 00       	call   8021e6 <_panic>
	assert(r <= PGSIZE);
  801bad:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb2:	7e 24                	jle    801bd8 <devfile_read+0x84>
  801bb4:	c7 44 24 0c 55 2b 80 	movl   $0x802b55,0xc(%esp)
  801bbb:	00 
  801bbc:	c7 44 24 08 35 2b 80 	movl   $0x802b35,0x8(%esp)
  801bc3:	00 
  801bc4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801bcb:	00 
  801bcc:	c7 04 24 4a 2b 80 00 	movl   $0x802b4a,(%esp)
  801bd3:	e8 0e 06 00 00       	call   8021e6 <_panic>
	memmove(buf, &fsipcbuf, r);
  801bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bdc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801be3:	00 
  801be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be7:	89 04 24             	mov    %eax,(%esp)
  801bea:	e8 97 ee ff ff       	call   800a86 <memmove>
	return r;
}
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    

00801bf8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	53                   	push   %ebx
  801bfc:	83 ec 24             	sub    $0x24,%esp
  801bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c02:	89 1c 24             	mov    %ebx,(%esp)
  801c05:	e8 26 ec ff ff       	call   800830 <strlen>
  801c0a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c0f:	7f 60                	jg     801c71 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 1b f8 ff ff       	call   801437 <fd_alloc>
  801c1c:	89 c2                	mov    %eax,%edx
  801c1e:	85 d2                	test   %edx,%edx
  801c20:	78 54                	js     801c76 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c26:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801c2d:	e8 59 ec ff ff       	call   80088b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c42:	e8 f8 fd ff ff       	call   801a3f <fsipc>
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	79 17                	jns    801c64 <open+0x6c>
		fd_close(fd, 0);
  801c4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c54:	00 
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	89 04 24             	mov    %eax,(%esp)
  801c5b:	e8 12 f9 ff ff       	call   801572 <fd_close>
		return r;
  801c60:	89 d8                	mov    %ebx,%eax
  801c62:	eb 12                	jmp    801c76 <open+0x7e>
	}
	return fd2num(fd);
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	89 04 24             	mov    %eax,(%esp)
  801c6a:	e8 a1 f7 ff ff       	call   801410 <fd2num>
  801c6f:	eb 05                	jmp    801c76 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c71:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801c76:	83 c4 24             	add    $0x24,%esp
  801c79:	5b                   	pop    %ebx
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
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
  801c91:	e8 8a f7 ff ff       	call   801420 <fd2data>
  801c96:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c98:	c7 44 24 04 61 2b 80 	movl   $0x802b61,0x4(%esp)
  801c9f:	00 
  801ca0:	89 1c 24             	mov    %ebx,(%esp)
  801ca3:	e8 e3 eb ff ff       	call   80088b <strcpy>
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
  801ce8:	e8 f3 f0 ff ff       	call   800de0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 2b f7 ff ff       	call   801420 <fd2data>
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d00:	e8 db f0 ff ff       	call   800de0 <sys_page_unmap>
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
  801d24:	e8 cd 05 00 00       	call   8022f6 <pageref>
  801d29:	89 c7                	mov    %eax,%edi
  801d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 c0 05 00 00       	call   8022f6 <pageref>
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
  801d5e:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  801d65:	e8 c1 e4 ff ff       	call   80022b <cprintf>
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
  801d83:	e8 98 f6 ff ff       	call   801420 <fd2data>
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
  801da4:	e8 71 ef ff ff       	call   800d1a <sys_yield>
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
  801e14:	e8 07 f6 ff ff       	call   801420 <fd2data>
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
  801e39:	e8 dc ee ff ff       	call   800d1a <sys_yield>
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
  801e97:	e8 9b f5 ff ff       	call   801437 <fd_alloc>
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	85 d2                	test   %edx,%edx
  801ea0:	0f 88 4d 01 00 00    	js     801ff3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ead:	00 
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebc:	e8 78 ee ff ff       	call   800d39 <sys_page_alloc>
  801ec1:	89 c2                	mov    %eax,%edx
  801ec3:	85 d2                	test   %edx,%edx
  801ec5:	0f 88 28 01 00 00    	js     801ff3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ece:	89 04 24             	mov    %eax,(%esp)
  801ed1:	e8 61 f5 ff ff       	call   801437 <fd_alloc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 88 fe 00 00 00    	js     801fde <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee7:	00 
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef6:	e8 3e ee ff ff       	call   800d39 <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 d9 00 00 00    	js     801fde <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 10 f5 ff ff       	call   801420 <fd2data>
  801f10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f19:	00 
  801f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f25:	e8 0f ee ff ff       	call   800d39 <sys_page_alloc>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 97 00 00 00    	js     801fcb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	89 04 24             	mov    %eax,(%esp)
  801f3a:	e8 e1 f4 ff ff       	call   801420 <fd2data>
  801f3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f46:	00 
  801f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f52:	00 
  801f53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5e:	e8 2a ee ff ff       	call   800d8d <sys_page_map>
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
  801f99:	e8 72 f4 ff ff       	call   801410 <fd2num>
  801f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 62 f4 ff ff       	call   801410 <fd2num>
  801fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	eb 38                	jmp    801ff3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 15 ee ff ff       	call   800de0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd9:	e8 02 ee ff ff       	call   800de0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 ef ed ff ff       	call   800de0 <sys_page_unmap>
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
  80200d:	e8 99 f4 ff ff       	call   8014ab <fd_lookup>
  802012:	89 c2                	mov    %eax,%edx
  802014:	85 d2                	test   %edx,%edx
  802016:	78 15                	js     80202d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	89 04 24             	mov    %eax,(%esp)
  80201e:	e8 fd f3 ff ff       	call   801420 <fd2data>
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
  802040:	c7 44 24 04 80 2b 80 	movl   $0x802b80,0x4(%esp)
  802047:	00 
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	89 04 24             	mov    %eax,(%esp)
  80204e:	e8 38 e8 ff ff       	call   80088b <strcpy>
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
  80209a:	e8 e7 e9 ff ff       	call   800a86 <memmove>
		sys_cputs(buf, m);
  80209f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020a3:	89 3c 24             	mov    %edi,(%esp)
  8020a6:	e8 c1 eb ff ff       	call   800c6c <sys_cputs>
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
  8020db:	e8 3a ec ff ff       	call   800d1a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8020e0:	e8 a5 eb ff ff       	call   800c8a <sys_cgetc>
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
  80211f:	e8 48 eb ff ff       	call   800c6c <sys_cputs>
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
  802142:	e8 0f f6 ff ff       	call   801756 <read>
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
  80216f:	e8 37 f3 ff ff       	call   8014ab <fd_lookup>
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
  802197:	e8 9b f2 ff ff       	call   801437 <fd_alloc>
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
  8021b8:	e8 7c eb ff ff       	call   800d39 <sys_page_alloc>
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
  8021db:	e8 30 f2 ff ff       	call   801410 <fd2num>
  8021e0:	89 c2                	mov    %eax,%edx
}
  8021e2:	89 d0                	mov    %edx,%eax
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	56                   	push   %esi
  8021ea:	53                   	push   %ebx
  8021eb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8021ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021f1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021f7:	e8 ff ea ff ff       	call   800cfb <sys_getenvid>
  8021fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ff:	89 54 24 10          	mov    %edx,0x10(%esp)
  802203:	8b 55 08             	mov    0x8(%ebp),%edx
  802206:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80220a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80220e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802212:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  802219:	e8 0d e0 ff ff       	call   80022b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80221e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802222:	8b 45 10             	mov    0x10(%ebp),%eax
  802225:	89 04 24             	mov    %eax,(%esp)
  802228:	e8 9d df ff ff       	call   8001ca <vcprintf>
	cprintf("\n");
  80222d:	c7 04 24 79 2b 80 00 	movl   $0x802b79,(%esp)
  802234:	e8 f2 df ff ff       	call   80022b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802239:	cc                   	int3   
  80223a:	eb fd                	jmp    802239 <_panic+0x53>

0080223c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  802242:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802249:	75 50                	jne    80229b <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80224b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802252:	00 
  802253:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80225a:	ee 
  80225b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802262:	e8 d2 ea ff ff       	call   800d39 <sys_page_alloc>
  802267:	85 c0                	test   %eax,%eax
  802269:	79 1c                	jns    802287 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  80226b:	c7 44 24 08 b0 2b 80 	movl   $0x802bb0,0x8(%esp)
  802272:	00 
  802273:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80227a:	00 
  80227b:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  802282:	e8 5f ff ff ff       	call   8021e6 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802287:	c7 44 24 04 a5 22 80 	movl   $0x8022a5,0x4(%esp)
  80228e:	00 
  80228f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802296:	e8 3e ec ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022a5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022a6:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022ab:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022ad:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8022b0:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8022b2:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8022b7:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8022ba:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8022bf:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8022c2:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8022c4:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8022c7:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8022c9:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8022cb:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8022d0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8022d3:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8022d8:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8022db:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8022dd:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8022e2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8022e5:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8022ea:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8022ed:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8022ef:	83 c4 08             	add    $0x8,%esp
	popal
  8022f2:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8022f3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022f4:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022f5:	c3                   	ret    

008022f6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022fc:	89 d0                	mov    %edx,%eax
  8022fe:	c1 e8 16             	shr    $0x16,%eax
  802301:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802308:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80230d:	f6 c1 01             	test   $0x1,%cl
  802310:	74 1d                	je     80232f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802312:	c1 ea 0c             	shr    $0xc,%edx
  802315:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80231c:	f6 c2 01             	test   $0x1,%dl
  80231f:	74 0e                	je     80232f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802321:	c1 ea 0c             	shr    $0xc,%edx
  802324:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80232b:	ef 
  80232c:	0f b7 c0             	movzwl %ax,%eax
}
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	66 90                	xchg   %ax,%ax
  802333:	66 90                	xchg   %ax,%ax
  802335:	66 90                	xchg   %ax,%ax
  802337:	66 90                	xchg   %ax,%ax
  802339:	66 90                	xchg   %ax,%ax
  80233b:	66 90                	xchg   %ax,%ax
  80233d:	66 90                	xchg   %ax,%ax
  80233f:	90                   	nop

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	8b 44 24 28          	mov    0x28(%esp),%eax
  80234a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80234e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802352:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802356:	85 c0                	test   %eax,%eax
  802358:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80235c:	89 ea                	mov    %ebp,%edx
  80235e:	89 0c 24             	mov    %ecx,(%esp)
  802361:	75 2d                	jne    802390 <__udivdi3+0x50>
  802363:	39 e9                	cmp    %ebp,%ecx
  802365:	77 61                	ja     8023c8 <__udivdi3+0x88>
  802367:	85 c9                	test   %ecx,%ecx
  802369:	89 ce                	mov    %ecx,%esi
  80236b:	75 0b                	jne    802378 <__udivdi3+0x38>
  80236d:	b8 01 00 00 00       	mov    $0x1,%eax
  802372:	31 d2                	xor    %edx,%edx
  802374:	f7 f1                	div    %ecx
  802376:	89 c6                	mov    %eax,%esi
  802378:	31 d2                	xor    %edx,%edx
  80237a:	89 e8                	mov    %ebp,%eax
  80237c:	f7 f6                	div    %esi
  80237e:	89 c5                	mov    %eax,%ebp
  802380:	89 f8                	mov    %edi,%eax
  802382:	f7 f6                	div    %esi
  802384:	89 ea                	mov    %ebp,%edx
  802386:	83 c4 0c             	add    $0xc,%esp
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	39 e8                	cmp    %ebp,%eax
  802392:	77 24                	ja     8023b8 <__udivdi3+0x78>
  802394:	0f bd e8             	bsr    %eax,%ebp
  802397:	83 f5 1f             	xor    $0x1f,%ebp
  80239a:	75 3c                	jne    8023d8 <__udivdi3+0x98>
  80239c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8023a0:	39 34 24             	cmp    %esi,(%esp)
  8023a3:	0f 86 9f 00 00 00    	jbe    802448 <__udivdi3+0x108>
  8023a9:	39 d0                	cmp    %edx,%eax
  8023ab:	0f 82 97 00 00 00    	jb     802448 <__udivdi3+0x108>
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	31 d2                	xor    %edx,%edx
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	83 c4 0c             	add    $0xc,%esp
  8023bf:	5e                   	pop    %esi
  8023c0:	5f                   	pop    %edi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
  8023c3:	90                   	nop
  8023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 f8                	mov    %edi,%eax
  8023ca:	f7 f1                	div    %ecx
  8023cc:	31 d2                	xor    %edx,%edx
  8023ce:	83 c4 0c             	add    $0xc,%esp
  8023d1:	5e                   	pop    %esi
  8023d2:	5f                   	pop    %edi
  8023d3:	5d                   	pop    %ebp
  8023d4:	c3                   	ret    
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	8b 3c 24             	mov    (%esp),%edi
  8023dd:	d3 e0                	shl    %cl,%eax
  8023df:	89 c6                	mov    %eax,%esi
  8023e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e6:	29 e8                	sub    %ebp,%eax
  8023e8:	89 c1                	mov    %eax,%ecx
  8023ea:	d3 ef                	shr    %cl,%edi
  8023ec:	89 e9                	mov    %ebp,%ecx
  8023ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023f2:	8b 3c 24             	mov    (%esp),%edi
  8023f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8023f9:	89 d6                	mov    %edx,%esi
  8023fb:	d3 e7                	shl    %cl,%edi
  8023fd:	89 c1                	mov    %eax,%ecx
  8023ff:	89 3c 24             	mov    %edi,(%esp)
  802402:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802406:	d3 ee                	shr    %cl,%esi
  802408:	89 e9                	mov    %ebp,%ecx
  80240a:	d3 e2                	shl    %cl,%edx
  80240c:	89 c1                	mov    %eax,%ecx
  80240e:	d3 ef                	shr    %cl,%edi
  802410:	09 d7                	or     %edx,%edi
  802412:	89 f2                	mov    %esi,%edx
  802414:	89 f8                	mov    %edi,%eax
  802416:	f7 74 24 08          	divl   0x8(%esp)
  80241a:	89 d6                	mov    %edx,%esi
  80241c:	89 c7                	mov    %eax,%edi
  80241e:	f7 24 24             	mull   (%esp)
  802421:	39 d6                	cmp    %edx,%esi
  802423:	89 14 24             	mov    %edx,(%esp)
  802426:	72 30                	jb     802458 <__udivdi3+0x118>
  802428:	8b 54 24 04          	mov    0x4(%esp),%edx
  80242c:	89 e9                	mov    %ebp,%ecx
  80242e:	d3 e2                	shl    %cl,%edx
  802430:	39 c2                	cmp    %eax,%edx
  802432:	73 05                	jae    802439 <__udivdi3+0xf9>
  802434:	3b 34 24             	cmp    (%esp),%esi
  802437:	74 1f                	je     802458 <__udivdi3+0x118>
  802439:	89 f8                	mov    %edi,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	e9 7a ff ff ff       	jmp    8023bc <__udivdi3+0x7c>
  802442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	e9 68 ff ff ff       	jmp    8023bc <__udivdi3+0x7c>
  802454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802458:	8d 47 ff             	lea    -0x1(%edi),%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	83 c4 0c             	add    $0xc,%esp
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	66 90                	xchg   %ax,%ax
  802466:	66 90                	xchg   %ax,%ax
  802468:	66 90                	xchg   %ax,%ax
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__umoddi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	83 ec 14             	sub    $0x14,%esp
  802476:	8b 44 24 28          	mov    0x28(%esp),%eax
  80247a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80247e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802482:	89 c7                	mov    %eax,%edi
  802484:	89 44 24 04          	mov    %eax,0x4(%esp)
  802488:	8b 44 24 30          	mov    0x30(%esp),%eax
  80248c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802490:	89 34 24             	mov    %esi,(%esp)
  802493:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802497:	85 c0                	test   %eax,%eax
  802499:	89 c2                	mov    %eax,%edx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	75 17                	jne    8024b8 <__umoddi3+0x48>
  8024a1:	39 fe                	cmp    %edi,%esi
  8024a3:	76 4b                	jbe    8024f0 <__umoddi3+0x80>
  8024a5:	89 c8                	mov    %ecx,%eax
  8024a7:	89 fa                	mov    %edi,%edx
  8024a9:	f7 f6                	div    %esi
  8024ab:	89 d0                	mov    %edx,%eax
  8024ad:	31 d2                	xor    %edx,%edx
  8024af:	83 c4 14             	add    $0x14,%esp
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	39 f8                	cmp    %edi,%eax
  8024ba:	77 54                	ja     802510 <__umoddi3+0xa0>
  8024bc:	0f bd e8             	bsr    %eax,%ebp
  8024bf:	83 f5 1f             	xor    $0x1f,%ebp
  8024c2:	75 5c                	jne    802520 <__umoddi3+0xb0>
  8024c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024c8:	39 3c 24             	cmp    %edi,(%esp)
  8024cb:	0f 87 e7 00 00 00    	ja     8025b8 <__umoddi3+0x148>
  8024d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024d5:	29 f1                	sub    %esi,%ecx
  8024d7:	19 c7                	sbb    %eax,%edi
  8024d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024e9:	83 c4 14             	add    $0x14,%esp
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	85 f6                	test   %esi,%esi
  8024f2:	89 f5                	mov    %esi,%ebp
  8024f4:	75 0b                	jne    802501 <__umoddi3+0x91>
  8024f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	f7 f6                	div    %esi
  8024ff:	89 c5                	mov    %eax,%ebp
  802501:	8b 44 24 04          	mov    0x4(%esp),%eax
  802505:	31 d2                	xor    %edx,%edx
  802507:	f7 f5                	div    %ebp
  802509:	89 c8                	mov    %ecx,%eax
  80250b:	f7 f5                	div    %ebp
  80250d:	eb 9c                	jmp    8024ab <__umoddi3+0x3b>
  80250f:	90                   	nop
  802510:	89 c8                	mov    %ecx,%eax
  802512:	89 fa                	mov    %edi,%edx
  802514:	83 c4 14             	add    $0x14,%esp
  802517:	5e                   	pop    %esi
  802518:	5f                   	pop    %edi
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    
  80251b:	90                   	nop
  80251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802520:	8b 04 24             	mov    (%esp),%eax
  802523:	be 20 00 00 00       	mov    $0x20,%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	29 ee                	sub    %ebp,%esi
  80252c:	d3 e2                	shl    %cl,%edx
  80252e:	89 f1                	mov    %esi,%ecx
  802530:	d3 e8                	shr    %cl,%eax
  802532:	89 e9                	mov    %ebp,%ecx
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	8b 04 24             	mov    (%esp),%eax
  80253b:	09 54 24 04          	or     %edx,0x4(%esp)
  80253f:	89 fa                	mov    %edi,%edx
  802541:	d3 e0                	shl    %cl,%eax
  802543:	89 f1                	mov    %esi,%ecx
  802545:	89 44 24 08          	mov    %eax,0x8(%esp)
  802549:	8b 44 24 10          	mov    0x10(%esp),%eax
  80254d:	d3 ea                	shr    %cl,%edx
  80254f:	89 e9                	mov    %ebp,%ecx
  802551:	d3 e7                	shl    %cl,%edi
  802553:	89 f1                	mov    %esi,%ecx
  802555:	d3 e8                	shr    %cl,%eax
  802557:	89 e9                	mov    %ebp,%ecx
  802559:	09 f8                	or     %edi,%eax
  80255b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80255f:	f7 74 24 04          	divl   0x4(%esp)
  802563:	d3 e7                	shl    %cl,%edi
  802565:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802569:	89 d7                	mov    %edx,%edi
  80256b:	f7 64 24 08          	mull   0x8(%esp)
  80256f:	39 d7                	cmp    %edx,%edi
  802571:	89 c1                	mov    %eax,%ecx
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 2c                	jb     8025a4 <__umoddi3+0x134>
  802578:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80257c:	72 22                	jb     8025a0 <__umoddi3+0x130>
  80257e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802582:	29 c8                	sub    %ecx,%eax
  802584:	19 d7                	sbb    %edx,%edi
  802586:	89 e9                	mov    %ebp,%ecx
  802588:	89 fa                	mov    %edi,%edx
  80258a:	d3 e8                	shr    %cl,%eax
  80258c:	89 f1                	mov    %esi,%ecx
  80258e:	d3 e2                	shl    %cl,%edx
  802590:	89 e9                	mov    %ebp,%ecx
  802592:	d3 ef                	shr    %cl,%edi
  802594:	09 d0                	or     %edx,%eax
  802596:	89 fa                	mov    %edi,%edx
  802598:	83 c4 14             	add    $0x14,%esp
  80259b:	5e                   	pop    %esi
  80259c:	5f                   	pop    %edi
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    
  80259f:	90                   	nop
  8025a0:	39 d7                	cmp    %edx,%edi
  8025a2:	75 da                	jne    80257e <__umoddi3+0x10e>
  8025a4:	8b 14 24             	mov    (%esp),%edx
  8025a7:	89 c1                	mov    %eax,%ecx
  8025a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8025ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025b1:	eb cb                	jmp    80257e <__umoddi3+0x10e>
  8025b3:	90                   	nop
  8025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025bc:	0f 82 0f ff ff ff    	jb     8024d1 <__umoddi3+0x61>
  8025c2:	e9 1a ff ff ff       	jmp    8024e1 <__umoddi3+0x71>
