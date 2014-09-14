
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8e 00 00 00       	call   8000bf <libmain>
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
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 60 25 80 00 	movl   $0x802560,(%esp)
  80004e:	e8 a0 01 00 00       	call   8001f3 <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 f8 0f 00 00       	call   801050 <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 d8 25 80 00 	movl   $0x8025d8,(%esp)
  800065:	e8 89 01 00 00       	call   8001f3 <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 88 25 80 00 	movl   $0x802588,(%esp)
  800073:	e8 7b 01 00 00       	call   8001f3 <cprintf>
	sys_yield();
  800078:	e8 5d 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  80007d:	e8 58 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  800082:	e8 53 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  800087:	e8 4e 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 45 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  800095:	e8 40 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  80009a:	e8 3b 0c 00 00       	call   800cda <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 35 0c 00 00       	call   800cda <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 b0 25 80 00 	movl   $0x8025b0,(%esp)
  8000ac:	e8 42 01 00 00       	call   8001f3 <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 b0 0b 00 00       	call   800c69 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000cd:	e8 e9 0b 00 00       	call   800cbb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000d2:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000d8:	39 c2                	cmp    %eax,%edx
  8000da:	74 17                	je     8000f3 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000dc:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000e1:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000e4:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000ea:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000ed:	39 c1                	cmp    %eax,%ecx
  8000ef:	75 18                	jne    800109 <libmain+0x4a>
  8000f1:	eb 05                	jmp    8000f8 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000f3:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000f8:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000fb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800101:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800107:	eb 0b                	jmp    800114 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800109:	83 c2 01             	add    $0x1,%edx
  80010c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800112:	75 cd                	jne    8000e1 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800114:	85 db                	test   %ebx,%ebx
  800116:	7e 07                	jle    80011f <libmain+0x60>
		binaryname = argv[0];
  800118:	8b 06                	mov    (%esi),%eax
  80011a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80011f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 15 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80012b:	e8 07 00 00 00       	call   800137 <exit>
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	5b                   	pop    %ebx
  800134:	5e                   	pop    %esi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80013d:	e8 84 13 00 00       	call   8014c6 <close_all>
	sys_env_destroy(0);
  800142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800149:	e8 1b 0b 00 00       	call   800c69 <sys_env_destroy>
}
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	53                   	push   %ebx
  800154:	83 ec 14             	sub    $0x14,%esp
  800157:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015a:	8b 13                	mov    (%ebx),%edx
  80015c:	8d 42 01             	lea    0x1(%edx),%eax
  80015f:	89 03                	mov    %eax,(%ebx)
  800161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800164:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800168:	3d ff 00 00 00       	cmp    $0xff,%eax
  80016d:	75 19                	jne    800188 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80016f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800176:	00 
  800177:	8d 43 08             	lea    0x8(%ebx),%eax
  80017a:	89 04 24             	mov    %eax,(%esp)
  80017d:	e8 aa 0a 00 00       	call   800c2c <sys_cputs>
		b->idx = 0;
  800182:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800188:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018c:	83 c4 14             	add    $0x14,%esp
  80018f:	5b                   	pop    %ebx
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    

00800192 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80019b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a2:	00 00 00 
	b.cnt = 0;
  8001a5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ac:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c7:	c7 04 24 50 01 80 00 	movl   $0x800150,(%esp)
  8001ce:	e8 b1 01 00 00       	call   800384 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001dd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e3:	89 04 24             	mov    %eax,(%esp)
  8001e6:	e8 41 0a 00 00       	call   800c2c <sys_cputs>

	return b.cnt;
}
  8001eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800200:	8b 45 08             	mov    0x8(%ebp),%eax
  800203:	89 04 24             	mov    %eax,(%esp)
  800206:	e8 87 ff ff ff       	call   800192 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020b:	c9                   	leave  
  80020c:	c3                   	ret    
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 3c             	sub    $0x3c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
  800227:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800232:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800235:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800238:	39 f1                	cmp    %esi,%ecx
  80023a:	72 14                	jb     800250 <printnum+0x40>
  80023c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80023f:	76 0f                	jbe    800250 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800241:	8b 45 14             	mov    0x14(%ebp),%eax
  800244:	8d 70 ff             	lea    -0x1(%eax),%esi
  800247:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80024a:	85 f6                	test   %esi,%esi
  80024c:	7f 60                	jg     8002ae <printnum+0x9e>
  80024e:	eb 72                	jmp    8002c2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800250:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800253:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800257:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80025a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80025d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800261:	89 44 24 08          	mov    %eax,0x8(%esp)
  800265:	8b 44 24 08          	mov    0x8(%esp),%eax
  800269:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80026d:	89 c3                	mov    %eax,%ebx
  80026f:	89 d6                	mov    %edx,%esi
  800271:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800274:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800277:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	89 04 24             	mov    %eax,(%esp)
  800285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028c:	e8 2f 20 00 00       	call   8022c0 <__udivdi3>
  800291:	89 d9                	mov    %ebx,%ecx
  800293:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800297:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029b:	89 04 24             	mov    %eax,(%esp)
  80029e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a7:	e8 64 ff ff ff       	call   800210 <printnum>
  8002ac:	eb 14                	jmp    8002c2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ba:	83 ee 01             	sub    $0x1,%esi
  8002bd:	75 ef                	jne    8002ae <printnum+0x9e>
  8002bf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002db:	89 04 24             	mov    %eax,(%esp)
  8002de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e5:	e8 06 21 00 00       	call   8023f0 <__umoddi3>
  8002ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ee:	0f be 80 00 26 80 00 	movsbl 0x802600(%eax),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fb:	ff d0                	call   *%eax
}
  8002fd:	83 c4 3c             	add    $0x3c,%esp
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800308:	83 fa 01             	cmp    $0x1,%edx
  80030b:	7e 0e                	jle    80031b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800312:	89 08                	mov    %ecx,(%eax)
  800314:	8b 02                	mov    (%edx),%eax
  800316:	8b 52 04             	mov    0x4(%edx),%edx
  800319:	eb 22                	jmp    80033d <getuint+0x38>
	else if (lflag)
  80031b:	85 d2                	test   %edx,%edx
  80031d:	74 10                	je     80032f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80031f:	8b 10                	mov    (%eax),%edx
  800321:	8d 4a 04             	lea    0x4(%edx),%ecx
  800324:	89 08                	mov    %ecx,(%eax)
  800326:	8b 02                	mov    (%edx),%eax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	eb 0e                	jmp    80033d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80032f:	8b 10                	mov    (%eax),%edx
  800331:	8d 4a 04             	lea    0x4(%edx),%ecx
  800334:	89 08                	mov    %ecx,(%eax)
  800336:	8b 02                	mov    (%edx),%eax
  800338:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800345:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	3b 50 04             	cmp    0x4(%eax),%edx
  80034e:	73 0a                	jae    80035a <sprintputch+0x1b>
		*b->buf++ = ch;
  800350:	8d 4a 01             	lea    0x1(%edx),%ecx
  800353:	89 08                	mov    %ecx,(%eax)
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	88 02                	mov    %al,(%edx)
}
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800362:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800365:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800369:	8b 45 10             	mov    0x10(%ebp),%eax
  80036c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	89 44 24 04          	mov    %eax,0x4(%esp)
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	89 04 24             	mov    %eax,(%esp)
  80037d:	e8 02 00 00 00       	call   800384 <vprintfmt>
	va_end(ap);
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 3c             	sub    $0x3c,%esp
  80038d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800390:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800393:	eb 18                	jmp    8003ad <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800395:	85 c0                	test   %eax,%eax
  800397:	0f 84 c3 03 00 00    	je     800760 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80039d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a1:	89 04 24             	mov    %eax,(%esp)
  8003a4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a7:	89 f3                	mov    %esi,%ebx
  8003a9:	eb 02                	jmp    8003ad <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003ab:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ad:	8d 73 01             	lea    0x1(%ebx),%esi
  8003b0:	0f b6 03             	movzbl (%ebx),%eax
  8003b3:	83 f8 25             	cmp    $0x25,%eax
  8003b6:	75 dd                	jne    800395 <vprintfmt+0x11>
  8003b8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003c3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d6:	eb 1d                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003da:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8003de:	eb 15                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8003e6:	eb 0d                	jmp    8003f5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ee:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003f8:	0f b6 06             	movzbl (%esi),%eax
  8003fb:	0f b6 c8             	movzbl %al,%ecx
  8003fe:	83 e8 23             	sub    $0x23,%eax
  800401:	3c 55                	cmp    $0x55,%al
  800403:	0f 87 2f 03 00 00    	ja     800738 <vprintfmt+0x3b4>
  800409:	0f b6 c0             	movzbl %al,%eax
  80040c:	ff 24 85 40 27 80 00 	jmp    *0x802740(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800413:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800419:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80041d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800420:	83 f9 09             	cmp    $0x9,%ecx
  800423:	77 50                	ja     800475 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800425:	89 de                	mov    %ebx,%esi
  800427:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80042a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80042d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800430:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800434:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800437:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80043a:	83 fb 09             	cmp    $0x9,%ebx
  80043d:	76 eb                	jbe    80042a <vprintfmt+0xa6>
  80043f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800442:	eb 33                	jmp    800477 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 48 04             	lea    0x4(%eax),%ecx
  80044a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800454:	eb 21                	jmp    800477 <vprintfmt+0xf3>
  800456:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800459:	85 c9                	test   %ecx,%ecx
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c1             	cmovns %ecx,%eax
  800463:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	89 de                	mov    %ebx,%esi
  800468:	eb 8b                	jmp    8003f5 <vprintfmt+0x71>
  80046a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800473:	eb 80                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800475:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800477:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80047b:	0f 89 74 ff ff ff    	jns    8003f5 <vprintfmt+0x71>
  800481:	e9 62 ff ff ff       	jmp    8003e8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800486:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800489:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80048b:	e9 65 ff ff ff       	jmp    8003f5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	89 55 14             	mov    %edx,0x14(%ebp)
  800499:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 04 24             	mov    %eax,(%esp)
  8004a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004a5:	e9 03 ff ff ff       	jmp    8003ad <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8d 50 04             	lea    0x4(%eax),%edx
  8004b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	99                   	cltd   
  8004b6:	31 d0                	xor    %edx,%eax
  8004b8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ba:	83 f8 0f             	cmp    $0xf,%eax
  8004bd:	7f 0b                	jg     8004ca <vprintfmt+0x146>
  8004bf:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  8004c6:	85 d2                	test   %edx,%edx
  8004c8:	75 20                	jne    8004ea <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ce:	c7 44 24 08 18 26 80 	movl   $0x802618,0x8(%esp)
  8004d5:	00 
  8004d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 77 fe ff ff       	call   80035c <printfmt>
  8004e5:	e9 c3 fe ff ff       	jmp    8003ad <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8004ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ee:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  8004f5:	00 
  8004f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 57 fe ff ff       	call   80035c <printfmt>
  800505:	e9 a3 fe ff ff       	jmp    8003ad <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80050d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 50 04             	lea    0x4(%eax),%edx
  800516:	89 55 14             	mov    %edx,0x14(%ebp)
  800519:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80051b:	85 c0                	test   %eax,%eax
  80051d:	ba 11 26 80 00       	mov    $0x802611,%edx
  800522:	0f 45 d0             	cmovne %eax,%edx
  800525:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800528:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80052c:	74 04                	je     800532 <vprintfmt+0x1ae>
  80052e:	85 f6                	test   %esi,%esi
  800530:	7f 19                	jg     80054b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	8d 70 01             	lea    0x1(%eax),%esi
  800538:	0f b6 10             	movzbl (%eax),%edx
  80053b:	0f be c2             	movsbl %dl,%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	0f 85 95 00 00 00    	jne    8005db <vprintfmt+0x257>
  800546:	e9 85 00 00 00       	jmp    8005d0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80054f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800552:	89 04 24             	mov    %eax,(%esp)
  800555:	e8 b8 02 00 00       	call   800812 <strnlen>
  80055a:	29 c6                	sub    %eax,%esi
  80055c:	89 f0                	mov    %esi,%eax
  80055e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800561:	85 f6                	test   %esi,%esi
  800563:	7e cd                	jle    800532 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800565:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800569:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80056c:	89 c3                	mov    %eax,%ebx
  80056e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800572:	89 34 24             	mov    %esi,(%esp)
  800575:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	75 f1                	jne    80056e <vprintfmt+0x1ea>
  80057d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800580:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800583:	eb ad                	jmp    800532 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800589:	74 1e                	je     8005a9 <vprintfmt+0x225>
  80058b:	0f be d2             	movsbl %dl,%edx
  80058e:	83 ea 20             	sub    $0x20,%edx
  800591:	83 fa 5e             	cmp    $0x5e,%edx
  800594:	76 13                	jbe    8005a9 <vprintfmt+0x225>
					putch('?', putdat);
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a4:	ff 55 08             	call   *0x8(%ebp)
  8005a7:	eb 0d                	jmp    8005b6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c6 01             	add    $0x1,%esi
  8005bc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005c0:	0f be c2             	movsbl %dl,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 20                	jne    8005e7 <vprintfmt+0x263>
  8005c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d4:	7f 25                	jg     8005fb <vprintfmt+0x277>
  8005d6:	e9 d2 fd ff ff       	jmp    8003ad <vprintfmt+0x29>
  8005db:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e7:	85 db                	test   %ebx,%ebx
  8005e9:	78 9a                	js     800585 <vprintfmt+0x201>
  8005eb:	83 eb 01             	sub    $0x1,%ebx
  8005ee:	79 95                	jns    800585 <vprintfmt+0x201>
  8005f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f9:	eb d5                	jmp    8005d0 <vprintfmt+0x24c>
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800604:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800608:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80060f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800611:	83 eb 01             	sub    $0x1,%ebx
  800614:	75 ee                	jne    800604 <vprintfmt+0x280>
  800616:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800619:	e9 8f fd ff ff       	jmp    8003ad <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061e:	83 fa 01             	cmp    $0x1,%edx
  800621:	7e 16                	jle    800639 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 50 08             	lea    0x8(%eax),%edx
  800629:	89 55 14             	mov    %edx,0x14(%ebp)
  80062c:	8b 50 04             	mov    0x4(%eax),%edx
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800634:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800637:	eb 32                	jmp    80066b <vprintfmt+0x2e7>
	else if (lflag)
  800639:	85 d2                	test   %edx,%edx
  80063b:	74 18                	je     800655 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 50 04             	lea    0x4(%eax),%edx
  800643:	89 55 14             	mov    %edx,0x14(%ebp)
  800646:	8b 30                	mov    (%eax),%esi
  800648:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80064b:	89 f0                	mov    %esi,%eax
  80064d:	c1 f8 1f             	sar    $0x1f,%eax
  800650:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800653:	eb 16                	jmp    80066b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 50 04             	lea    0x4(%eax),%edx
  80065b:	89 55 14             	mov    %edx,0x14(%ebp)
  80065e:	8b 30                	mov    (%eax),%esi
  800660:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800663:	89 f0                	mov    %esi,%eax
  800665:	c1 f8 1f             	sar    $0x1f,%eax
  800668:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80066e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800671:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800676:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067a:	0f 89 80 00 00 00    	jns    800700 <vprintfmt+0x37c>
				putch('-', putdat);
  800680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800684:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80068b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80068e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800691:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800694:	f7 d8                	neg    %eax
  800696:	83 d2 00             	adc    $0x0,%edx
  800699:	f7 da                	neg    %edx
			}
			base = 10;
  80069b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006a0:	eb 5e                	jmp    800700 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a5:	e8 5b fc ff ff       	call   800305 <getuint>
			base = 10;
  8006aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006af:	eb 4f                	jmp    800700 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b4:	e8 4c fc ff ff       	call   800305 <getuint>
			base = 8;
  8006b9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006be:	eb 40                	jmp    800700 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006d9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ec:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006f1:	eb 0d                	jmp    800700 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 0a fc ff ff       	call   800305 <getuint>
			base = 16;
  8006fb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800700:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800704:	89 74 24 10          	mov    %esi,0x10(%esp)
  800708:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80070b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80070f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800713:	89 04 24             	mov    %eax,(%esp)
  800716:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071a:	89 fa                	mov    %edi,%edx
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	e8 ec fa ff ff       	call   800210 <printnum>
			break;
  800724:	e9 84 fc ff ff       	jmp    8003ad <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800729:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072d:	89 0c 24             	mov    %ecx,(%esp)
  800730:	ff 55 08             	call   *0x8(%ebp)
			break;
  800733:	e9 75 fc ff ff       	jmp    8003ad <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800738:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800743:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800746:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80074a:	0f 84 5b fc ff ff    	je     8003ab <vprintfmt+0x27>
  800750:	89 f3                	mov    %esi,%ebx
  800752:	83 eb 01             	sub    $0x1,%ebx
  800755:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800759:	75 f7                	jne    800752 <vprintfmt+0x3ce>
  80075b:	e9 4d fc ff ff       	jmp    8003ad <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800760:	83 c4 3c             	add    $0x3c,%esp
  800763:	5b                   	pop    %ebx
  800764:	5e                   	pop    %esi
  800765:	5f                   	pop    %edi
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	83 ec 28             	sub    $0x28,%esp
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800774:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800777:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800785:	85 c0                	test   %eax,%eax
  800787:	74 30                	je     8007b9 <vsnprintf+0x51>
  800789:	85 d2                	test   %edx,%edx
  80078b:	7e 2c                	jle    8007b9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a2:	c7 04 24 3f 03 80 00 	movl   $0x80033f,(%esp)
  8007a9:	e8 d6 fb ff ff       	call   800384 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b7:	eb 05                	jmp    8007be <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	89 04 24             	mov    %eax,(%esp)
  8007e1:	e8 82 ff ff ff       	call   800768 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    
  8007e8:	66 90                	xchg   %ax,%ax
  8007ea:	66 90                	xchg   %ax,%ax
  8007ec:	66 90                	xchg   %ax,%ax
  8007ee:	66 90                	xchg   %ax,%ax

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	80 3a 00             	cmpb   $0x0,(%edx)
  8007f9:	74 10                	je     80080b <strlen+0x1b>
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800807:	75 f7                	jne    800800 <strlen+0x10>
  800809:	eb 05                	jmp    800810 <strlen+0x20>
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081c:	85 c9                	test   %ecx,%ecx
  80081e:	74 1c                	je     80083c <strnlen+0x2a>
  800820:	80 3b 00             	cmpb   $0x0,(%ebx)
  800823:	74 1e                	je     800843 <strnlen+0x31>
  800825:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80082a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082c:	39 ca                	cmp    %ecx,%edx
  80082e:	74 18                	je     800848 <strnlen+0x36>
  800830:	83 c2 01             	add    $0x1,%edx
  800833:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800838:	75 f0                	jne    80082a <strnlen+0x18>
  80083a:	eb 0c                	jmp    800848 <strnlen+0x36>
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb 05                	jmp    800848 <strnlen+0x36>
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800848:	5b                   	pop    %ebx
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800855:	89 c2                	mov    %eax,%edx
  800857:	83 c2 01             	add    $0x1,%edx
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800861:	88 5a ff             	mov    %bl,-0x1(%edx)
  800864:	84 db                	test   %bl,%bl
  800866:	75 ef                	jne    800857 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800875:	89 1c 24             	mov    %ebx,(%esp)
  800878:	e8 73 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800880:	89 54 24 04          	mov    %edx,0x4(%esp)
  800884:	01 d8                	add    %ebx,%eax
  800886:	89 04 24             	mov    %eax,(%esp)
  800889:	e8 bd ff ff ff       	call   80084b <strcpy>
	return dst;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	83 c4 08             	add    $0x8,%esp
  800893:	5b                   	pop    %ebx
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a4:	85 db                	test   %ebx,%ebx
  8008a6:	74 17                	je     8008bf <strncpy+0x29>
  8008a8:	01 f3                	add    %esi,%ebx
  8008aa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008ac:	83 c1 01             	add    $0x1,%ecx
  8008af:	0f b6 02             	movzbl (%edx),%eax
  8008b2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008b8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008bb:	39 d9                	cmp    %ebx,%ecx
  8008bd:	75 ed                	jne    8008ac <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008bf:	89 f0                	mov    %esi,%eax
  8008c1:	5b                   	pop    %ebx
  8008c2:	5e                   	pop    %esi
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	57                   	push   %edi
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
  8008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d1:	8b 75 10             	mov    0x10(%ebp),%esi
  8008d4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	74 34                	je     80090e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8008da:	83 fe 01             	cmp    $0x1,%esi
  8008dd:	74 26                	je     800905 <strlcpy+0x40>
  8008df:	0f b6 0b             	movzbl (%ebx),%ecx
  8008e2:	84 c9                	test   %cl,%cl
  8008e4:	74 23                	je     800909 <strlcpy+0x44>
  8008e6:	83 ee 02             	sub    $0x2,%esi
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8008ee:	83 c0 01             	add    $0x1,%eax
  8008f1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008f4:	39 f2                	cmp    %esi,%edx
  8008f6:	74 13                	je     80090b <strlcpy+0x46>
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ff:	84 c9                	test   %cl,%cl
  800901:	75 eb                	jne    8008ee <strlcpy+0x29>
  800903:	eb 06                	jmp    80090b <strlcpy+0x46>
  800905:	89 f8                	mov    %edi,%eax
  800907:	eb 02                	jmp    80090b <strlcpy+0x46>
  800909:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090e:	29 f8                	sub    %edi,%eax
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5f                   	pop    %edi
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091e:	0f b6 01             	movzbl (%ecx),%eax
  800921:	84 c0                	test   %al,%al
  800923:	74 15                	je     80093a <strcmp+0x25>
  800925:	3a 02                	cmp    (%edx),%al
  800927:	75 11                	jne    80093a <strcmp+0x25>
		p++, q++;
  800929:	83 c1 01             	add    $0x1,%ecx
  80092c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092f:	0f b6 01             	movzbl (%ecx),%eax
  800932:	84 c0                	test   %al,%al
  800934:	74 04                	je     80093a <strcmp+0x25>
  800936:	3a 02                	cmp    (%edx),%al
  800938:	74 ef                	je     800929 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093a:	0f b6 c0             	movzbl %al,%eax
  80093d:	0f b6 12             	movzbl (%edx),%edx
  800940:	29 d0                	sub    %edx,%eax
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	56                   	push   %esi
  800948:	53                   	push   %ebx
  800949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800952:	85 f6                	test   %esi,%esi
  800954:	74 29                	je     80097f <strncmp+0x3b>
  800956:	0f b6 03             	movzbl (%ebx),%eax
  800959:	84 c0                	test   %al,%al
  80095b:	74 30                	je     80098d <strncmp+0x49>
  80095d:	3a 02                	cmp    (%edx),%al
  80095f:	75 2c                	jne    80098d <strncmp+0x49>
  800961:	8d 43 01             	lea    0x1(%ebx),%eax
  800964:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800966:	89 c3                	mov    %eax,%ebx
  800968:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096b:	39 f0                	cmp    %esi,%eax
  80096d:	74 17                	je     800986 <strncmp+0x42>
  80096f:	0f b6 08             	movzbl (%eax),%ecx
  800972:	84 c9                	test   %cl,%cl
  800974:	74 17                	je     80098d <strncmp+0x49>
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	3a 0a                	cmp    (%edx),%cl
  80097b:	74 e9                	je     800966 <strncmp+0x22>
  80097d:	eb 0e                	jmp    80098d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80097f:	b8 00 00 00 00       	mov    $0x0,%eax
  800984:	eb 0f                	jmp    800995 <strncmp+0x51>
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb 08                	jmp    800995 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80098d:	0f b6 03             	movzbl (%ebx),%eax
  800990:	0f b6 12             	movzbl (%edx),%edx
  800993:	29 d0                	sub    %edx,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009a3:	0f b6 18             	movzbl (%eax),%ebx
  8009a6:	84 db                	test   %bl,%bl
  8009a8:	74 1d                	je     8009c7 <strchr+0x2e>
  8009aa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009ac:	38 d3                	cmp    %dl,%bl
  8009ae:	75 06                	jne    8009b6 <strchr+0x1d>
  8009b0:	eb 1a                	jmp    8009cc <strchr+0x33>
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 16                	je     8009cc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	0f b6 10             	movzbl (%eax),%edx
  8009bc:	84 d2                	test   %dl,%dl
  8009be:	75 f2                	jne    8009b2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	eb 05                	jmp    8009cc <strchr+0x33>
  8009c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cc:	5b                   	pop    %ebx
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009d9:	0f b6 18             	movzbl (%eax),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 16                	je     8009f6 <strfind+0x27>
  8009e0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009e2:	38 d3                	cmp    %dl,%bl
  8009e4:	75 06                	jne    8009ec <strfind+0x1d>
  8009e6:	eb 0e                	jmp    8009f6 <strfind+0x27>
  8009e8:	38 ca                	cmp    %cl,%dl
  8009ea:	74 0a                	je     8009f6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	0f b6 10             	movzbl (%eax),%edx
  8009f2:	84 d2                	test   %dl,%dl
  8009f4:	75 f2                	jne    8009e8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	57                   	push   %edi
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a05:	85 c9                	test   %ecx,%ecx
  800a07:	74 36                	je     800a3f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0f:	75 28                	jne    800a39 <memset+0x40>
  800a11:	f6 c1 03             	test   $0x3,%cl
  800a14:	75 23                	jne    800a39 <memset+0x40>
		c &= 0xFF;
  800a16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1a:	89 d3                	mov    %edx,%ebx
  800a1c:	c1 e3 08             	shl    $0x8,%ebx
  800a1f:	89 d6                	mov    %edx,%esi
  800a21:	c1 e6 18             	shl    $0x18,%esi
  800a24:	89 d0                	mov    %edx,%eax
  800a26:	c1 e0 10             	shl    $0x10,%eax
  800a29:	09 f0                	or     %esi,%eax
  800a2b:	09 c2                	or     %eax,%edx
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a31:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a34:	fc                   	cld    
  800a35:	f3 ab                	rep stos %eax,%es:(%edi)
  800a37:	eb 06                	jmp    800a3f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	fc                   	cld    
  800a3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5f                   	pop    %edi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	57                   	push   %edi
  800a4a:	56                   	push   %esi
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a54:	39 c6                	cmp    %eax,%esi
  800a56:	73 35                	jae    800a8d <memmove+0x47>
  800a58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5b:	39 d0                	cmp    %edx,%eax
  800a5d:	73 2e                	jae    800a8d <memmove+0x47>
		s += n;
		d += n;
  800a5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a62:	89 d6                	mov    %edx,%esi
  800a64:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6c:	75 13                	jne    800a81 <memmove+0x3b>
  800a6e:	f6 c1 03             	test   $0x3,%cl
  800a71:	75 0e                	jne    800a81 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a73:	83 ef 04             	sub    $0x4,%edi
  800a76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a79:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a7c:	fd                   	std    
  800a7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7f:	eb 09                	jmp    800a8a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a81:	83 ef 01             	sub    $0x1,%edi
  800a84:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a87:	fd                   	std    
  800a88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8a:	fc                   	cld    
  800a8b:	eb 1d                	jmp    800aaa <memmove+0x64>
  800a8d:	89 f2                	mov    %esi,%edx
  800a8f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	f6 c2 03             	test   $0x3,%dl
  800a94:	75 0f                	jne    800aa5 <memmove+0x5f>
  800a96:	f6 c1 03             	test   $0x3,%cl
  800a99:	75 0a                	jne    800aa5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	fc                   	cld    
  800aa1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa3:	eb 05                	jmp    800aaa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	fc                   	cld    
  800aa8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 04 24             	mov    %eax,(%esp)
  800ac8:	e8 79 ff ff ff       	call   800a46 <memmove>
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
  800ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ade:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 36                	je     800b1b <memcmp+0x4c>
		if (*s1 != *s2)
  800ae5:	0f b6 03             	movzbl (%ebx),%eax
  800ae8:	0f b6 0e             	movzbl (%esi),%ecx
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	38 c8                	cmp    %cl,%al
  800af2:	74 1c                	je     800b10 <memcmp+0x41>
  800af4:	eb 10                	jmp    800b06 <memcmp+0x37>
  800af6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800afb:	83 c2 01             	add    $0x1,%edx
  800afe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b02:	38 c8                	cmp    %cl,%al
  800b04:	74 0a                	je     800b10 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b06:	0f b6 c0             	movzbl %al,%eax
  800b09:	0f b6 c9             	movzbl %cl,%ecx
  800b0c:	29 c8                	sub    %ecx,%eax
  800b0e:	eb 10                	jmp    800b20 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b10:	39 fa                	cmp    %edi,%edx
  800b12:	75 e2                	jne    800af6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	eb 05                	jmp    800b20 <memcmp+0x51>
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5f                   	pop    %edi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	53                   	push   %ebx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	39 d0                	cmp    %edx,%eax
  800b36:	73 13                	jae    800b4b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b38:	89 d9                	mov    %ebx,%ecx
  800b3a:	38 18                	cmp    %bl,(%eax)
  800b3c:	75 06                	jne    800b44 <memfind+0x1f>
  800b3e:	eb 0b                	jmp    800b4b <memfind+0x26>
  800b40:	38 08                	cmp    %cl,(%eax)
  800b42:	74 07                	je     800b4b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	39 d0                	cmp    %edx,%eax
  800b49:	75 f5                	jne    800b40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5a:	0f b6 0a             	movzbl (%edx),%ecx
  800b5d:	80 f9 09             	cmp    $0x9,%cl
  800b60:	74 05                	je     800b67 <strtol+0x19>
  800b62:	80 f9 20             	cmp    $0x20,%cl
  800b65:	75 10                	jne    800b77 <strtol+0x29>
		s++;
  800b67:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6a:	0f b6 0a             	movzbl (%edx),%ecx
  800b6d:	80 f9 09             	cmp    $0x9,%cl
  800b70:	74 f5                	je     800b67 <strtol+0x19>
  800b72:	80 f9 20             	cmp    $0x20,%cl
  800b75:	74 f0                	je     800b67 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b77:	80 f9 2b             	cmp    $0x2b,%cl
  800b7a:	75 0a                	jne    800b86 <strtol+0x38>
		s++;
  800b7c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b84:	eb 11                	jmp    800b97 <strtol+0x49>
  800b86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b8b:	80 f9 2d             	cmp    $0x2d,%cl
  800b8e:	75 07                	jne    800b97 <strtol+0x49>
		s++, neg = 1;
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b97:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b9c:	75 15                	jne    800bb3 <strtol+0x65>
  800b9e:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba1:	75 10                	jne    800bb3 <strtol+0x65>
  800ba3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba7:	75 0a                	jne    800bb3 <strtol+0x65>
		s += 2, base = 16;
  800ba9:	83 c2 02             	add    $0x2,%edx
  800bac:	b8 10 00 00 00       	mov    $0x10,%eax
  800bb1:	eb 10                	jmp    800bc3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	75 0c                	jne    800bc3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bbc:	75 05                	jne    800bc3 <strtol+0x75>
		s++, base = 8;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bcb:	0f b6 0a             	movzbl (%edx),%ecx
  800bce:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bd1:	89 f0                	mov    %esi,%eax
  800bd3:	3c 09                	cmp    $0x9,%al
  800bd5:	77 08                	ja     800bdf <strtol+0x91>
			dig = *s - '0';
  800bd7:	0f be c9             	movsbl %cl,%ecx
  800bda:	83 e9 30             	sub    $0x30,%ecx
  800bdd:	eb 20                	jmp    800bff <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800bdf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800be2:	89 f0                	mov    %esi,%eax
  800be4:	3c 19                	cmp    $0x19,%al
  800be6:	77 08                	ja     800bf0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800be8:	0f be c9             	movsbl %cl,%ecx
  800beb:	83 e9 57             	sub    $0x57,%ecx
  800bee:	eb 0f                	jmp    800bff <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800bf0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bf3:	89 f0                	mov    %esi,%eax
  800bf5:	3c 19                	cmp    $0x19,%al
  800bf7:	77 16                	ja     800c0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf9:	0f be c9             	movsbl %cl,%ecx
  800bfc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bff:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c02:	7d 0f                	jge    800c13 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c0b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c0d:	eb bc                	jmp    800bcb <strtol+0x7d>
  800c0f:	89 d8                	mov    %ebx,%eax
  800c11:	eb 02                	jmp    800c15 <strtol+0xc7>
  800c13:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c19:	74 05                	je     800c20 <strtol+0xd2>
		*endptr = (char *) s;
  800c1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c20:	f7 d8                	neg    %eax
  800c22:	85 ff                	test   %edi,%edi
  800c24:	0f 44 c3             	cmove  %ebx,%eax
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	89 c3                	mov    %eax,%ebx
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	89 c6                	mov    %eax,%esi
  800c43:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5a:	89 d1                	mov    %edx,%ecx
  800c5c:	89 d3                	mov    %edx,%ebx
  800c5e:	89 d7                	mov    %edx,%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c77:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	89 cb                	mov    %ecx,%ebx
  800c81:	89 cf                	mov    %ecx,%edi
  800c83:	89 ce                	mov    %ecx,%esi
  800c85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7e 28                	jle    800cb3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c96:	00 
  800c97:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800c9e:	00 
  800c9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ca6:	00 
  800ca7:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800cae:	e8 a3 13 00 00       	call   802056 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cb3:	83 c4 2c             	add    $0x2c,%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc6:	b8 02 00 00 00       	mov    $0x2,%eax
  800ccb:	89 d1                	mov    %edx,%ecx
  800ccd:	89 d3                	mov    %edx,%ebx
  800ccf:	89 d7                	mov    %edx,%edi
  800cd1:	89 d6                	mov    %edx,%esi
  800cd3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_yield>:

void
sys_yield(void)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d02:	be 00 00 00 00       	mov    $0x0,%esi
  800d07:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d15:	89 f7                	mov    %esi,%edi
  800d17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7e 28                	jle    800d45 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d21:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d28:	00 
  800d29:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800d30:	00 
  800d31:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d38:	00 
  800d39:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800d40:	e8 11 13 00 00       	call   802056 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d45:	83 c4 2c             	add    $0x2c,%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d56:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d67:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7e 28                	jle    800d98 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d74:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d7b:	00 
  800d7c:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800d83:	00 
  800d84:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d8b:	00 
  800d8c:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800d93:	e8 be 12 00 00       	call   802056 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d98:	83 c4 2c             	add    $0x2c,%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dae:	b8 06 00 00 00       	mov    $0x6,%eax
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	89 de                	mov    %ebx,%esi
  800dbd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7e 28                	jle    800deb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dce:	00 
  800dcf:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dde:	00 
  800ddf:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800de6:	e8 6b 12 00 00       	call   802056 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	83 c4 2c             	add    $0x2c,%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	b8 08 00 00 00       	mov    $0x8,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7e 28                	jle    800e3e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e21:	00 
  800e22:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800e29:	00 
  800e2a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e31:	00 
  800e32:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800e39:	e8 18 12 00 00       	call   802056 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3e:	83 c4 2c             	add    $0x2c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	b8 09 00 00 00       	mov    $0x9,%eax
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7e 28                	jle    800e91 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e69:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e74:	00 
  800e75:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800e7c:	00 
  800e7d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e84:	00 
  800e85:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800e8c:	e8 c5 11 00 00       	call   802056 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e91:	83 c4 2c             	add    $0x2c,%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	89 df                	mov    %ebx,%edi
  800eb4:	89 de                	mov    %ebx,%esi
  800eb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7e 28                	jle    800ee4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ed7:	00 
  800ed8:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800edf:	e8 72 11 00 00       	call   802056 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee4:	83 c4 2c             	add    $0x2c,%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef2:	be 00 00 00 00       	mov    $0x0,%esi
  800ef7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f05:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f08:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	89 cb                	mov    %ecx,%ebx
  800f27:	89 cf                	mov    %ecx,%edi
  800f29:	89 ce                	mov    %ecx,%esi
  800f2b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	7e 28                	jle    800f59 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f35:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  800f44:	00 
  800f45:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f4c:	00 
  800f4d:	c7 04 24 1c 29 80 00 	movl   $0x80291c,(%esp)
  800f54:	e8 fd 10 00 00       	call   802056 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f59:	83 c4 2c             	add    $0x2c,%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	53                   	push   %ebx
  800f65:	83 ec 24             	sub    $0x24,%esp
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f6b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  800f6d:	89 da                	mov    %ebx,%edx
  800f6f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  800f72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  800f79:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f7d:	74 05                	je     800f84 <pgfault+0x23>
  800f7f:	f6 c6 08             	test   $0x8,%dh
  800f82:	75 1c                	jne    800fa0 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  800f84:	c7 44 24 08 2c 29 80 	movl   $0x80292c,0x8(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800f93:	00 
  800f94:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  800f9b:	e8 b6 10 00 00       	call   802056 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  800fa0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fa7:	00 
  800fa8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800faf:	00 
  800fb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fb7:	e8 3d fd ff ff       	call   800cf9 <sys_page_alloc>
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	79 20                	jns    800fe0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  800fc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fc4:	c7 44 24 08 94 29 80 	movl   $0x802994,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  800fdb:	e8 76 10 00 00       	call   802056 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  800fe0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  800fe6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800fed:	00 
  800fee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ff2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  800ff9:	e8 48 fa ff ff       	call   800a46 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  800ffe:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801005:	00 
  801006:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80100a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801011:	00 
  801012:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801019:	00 
  80101a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801021:	e8 27 fd ff ff       	call   800d4d <sys_page_map>
  801026:	85 c0                	test   %eax,%eax
  801028:	79 20                	jns    80104a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80102a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80102e:	c7 44 24 08 ae 29 80 	movl   $0x8029ae,0x8(%esp)
  801035:	00 
  801036:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80103d:	00 
  80103e:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801045:	e8 0c 10 00 00       	call   802056 <_panic>
	}
}
  80104a:	83 c4 24             	add    $0x24,%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	53                   	push   %ebx
  801056:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801059:	c7 04 24 61 0f 80 00 	movl   $0x800f61,(%esp)
  801060:	e8 47 10 00 00       	call   8020ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801065:	b8 07 00 00 00       	mov    $0x7,%eax
  80106a:	cd 30                	int    $0x30
  80106c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80106f:	85 c0                	test   %eax,%eax
  801071:	79 1c                	jns    80108f <fork+0x3f>
		panic("fork");
  801073:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  80107a:	00 
  80107b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801082:	00 
  801083:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80108a:	e8 c7 0f 00 00       	call   802056 <_panic>
  80108f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801091:	bb 00 08 00 00       	mov    $0x800,%ebx
  801096:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80109a:	75 21                	jne    8010bd <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80109c:	e8 1a fc ff ff       	call   800cbb <sys_getenvid>
  8010a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ae:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b8:	e9 c5 01 00 00       	jmp    801282 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  8010bd:	89 d8                	mov    %ebx,%eax
  8010bf:	c1 e8 0a             	shr    $0xa,%eax
  8010c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c9:	a8 01                	test   $0x1,%al
  8010cb:	0f 84 f2 00 00 00    	je     8011c3 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  8010d1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010d8:	a8 05                	test   $0x5,%al
  8010da:	0f 84 e3 00 00 00    	je     8011c3 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  8010e0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010e7:	89 de                	mov    %ebx,%esi
  8010e9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  8010ec:	a9 02 08 00 00       	test   $0x802,%eax
  8010f1:	0f 84 88 00 00 00    	je     80117f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8010f7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8010fe:	00 
  8010ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801103:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801107:	89 74 24 04          	mov    %esi,0x4(%esp)
  80110b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801112:	e8 36 fc ff ff       	call   800d4d <sys_page_map>
  801117:	85 c0                	test   %eax,%eax
  801119:	79 20                	jns    80113b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80111b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80111f:	c7 44 24 08 cc 29 80 	movl   $0x8029cc,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801136:	e8 1b 0f 00 00       	call   802056 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80113b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801142:	00 
  801143:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801147:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80114e:	00 
  80114f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801153:	89 3c 24             	mov    %edi,(%esp)
  801156:	e8 f2 fb ff ff       	call   800d4d <sys_page_map>
  80115b:	85 c0                	test   %eax,%eax
  80115d:	79 64                	jns    8011c3 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80115f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801163:	c7 44 24 08 e6 29 80 	movl   $0x8029e6,0x8(%esp)
  80116a:	00 
  80116b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801172:	00 
  801173:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80117a:	e8 d7 0e 00 00       	call   802056 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80117f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801186:	00 
  801187:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80118b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80118f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80119a:	e8 ae fb ff ff       	call   800d4d <sys_page_map>
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	79 20                	jns    8011c3 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  8011a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011a7:	c7 44 24 08 00 2a 80 	movl   $0x802a00,0x8(%esp)
  8011ae:	00 
  8011af:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  8011b6:	00 
  8011b7:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  8011be:	e8 93 0e 00 00       	call   802056 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  8011c3:	83 c3 01             	add    $0x1,%ebx
  8011c6:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8011cc:	0f 85 eb fe ff ff    	jne    8010bd <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  8011d2:	c7 44 24 04 15 21 80 	movl   $0x802115,0x4(%esp)
  8011d9:	00 
  8011da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011dd:	89 04 24             	mov    %eax,(%esp)
  8011e0:	e8 b4 fc ff ff       	call   800e99 <sys_env_set_pgfault_upcall>
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 20                	jns    801209 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8011e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ed:	c7 44 24 08 64 29 80 	movl   $0x802964,0x8(%esp)
  8011f4:	00 
  8011f5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8011fc:	00 
  8011fd:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801204:	e8 4d 0e 00 00       	call   802056 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801209:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801210:	00 
  801211:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801218:	ee 
  801219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121c:	89 04 24             	mov    %eax,(%esp)
  80121f:	e8 d5 fa ff ff       	call   800cf9 <sys_page_alloc>
  801224:	85 c0                	test   %eax,%eax
  801226:	79 20                	jns    801248 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801228:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122c:	c7 44 24 08 12 2a 80 	movl   $0x802a12,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801243:	e8 0e 0e 00 00       	call   802056 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801248:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80124f:	00 
  801250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801253:	89 04 24             	mov    %eax,(%esp)
  801256:	e8 98 fb ff ff       	call   800df3 <sys_env_set_status>
  80125b:	85 c0                	test   %eax,%eax
  80125d:	79 20                	jns    80127f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80125f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801263:	c7 44 24 08 2a 2a 80 	movl   $0x802a2a,0x8(%esp)
  80126a:	00 
  80126b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801272:	00 
  801273:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80127a:	e8 d7 0d 00 00       	call   802056 <_panic>
	}

	return envid;
  80127f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801282:	83 c4 2c             	add    $0x2c,%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <sfork>:

// Challenge!
int
sfork(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801290:	c7 44 24 08 45 2a 80 	movl   $0x802a45,0x8(%esp)
  801297:	00 
  801298:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80129f:	00 
  8012a0:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  8012a7:	e8 aa 0d 00 00       	call   802056 <_panic>
  8012ac:	66 90                	xchg   %ax,%ax
  8012ae:	66 90                	xchg   %ax,%ax

008012b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012da:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012df:	a8 01                	test   $0x1,%al
  8012e1:	74 34                	je     801317 <fd_alloc+0x40>
  8012e3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012e8:	a8 01                	test   $0x1,%al
  8012ea:	74 32                	je     80131e <fd_alloc+0x47>
  8012ec:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8012f1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012f3:	89 c2                	mov    %eax,%edx
  8012f5:	c1 ea 16             	shr    $0x16,%edx
  8012f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ff:	f6 c2 01             	test   $0x1,%dl
  801302:	74 1f                	je     801323 <fd_alloc+0x4c>
  801304:	89 c2                	mov    %eax,%edx
  801306:	c1 ea 0c             	shr    $0xc,%edx
  801309:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801310:	f6 c2 01             	test   $0x1,%dl
  801313:	75 1a                	jne    80132f <fd_alloc+0x58>
  801315:	eb 0c                	jmp    801323 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801317:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80131c:	eb 05                	jmp    801323 <fd_alloc+0x4c>
  80131e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	89 08                	mov    %ecx,(%eax)
			return 0;
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
  80132d:	eb 1a                	jmp    801349 <fd_alloc+0x72>
  80132f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801334:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801339:	75 b6                	jne    8012f1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801344:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801351:	83 f8 1f             	cmp    $0x1f,%eax
  801354:	77 36                	ja     80138c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801356:	c1 e0 0c             	shl    $0xc,%eax
  801359:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80135e:	89 c2                	mov    %eax,%edx
  801360:	c1 ea 16             	shr    $0x16,%edx
  801363:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136a:	f6 c2 01             	test   $0x1,%dl
  80136d:	74 24                	je     801393 <fd_lookup+0x48>
  80136f:	89 c2                	mov    %eax,%edx
  801371:	c1 ea 0c             	shr    $0xc,%edx
  801374:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137b:	f6 c2 01             	test   $0x1,%dl
  80137e:	74 1a                	je     80139a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801380:	8b 55 0c             	mov    0xc(%ebp),%edx
  801383:	89 02                	mov    %eax,(%edx)
	return 0;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
  80138a:	eb 13                	jmp    80139f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80138c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801391:	eb 0c                	jmp    80139f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801398:	eb 05                	jmp    80139f <fd_lookup+0x54>
  80139a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 14             	sub    $0x14,%esp
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013ae:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8013b4:	75 1e                	jne    8013d4 <dev_lookup+0x33>
  8013b6:	eb 0e                	jmp    8013c6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013b8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8013bd:	eb 0c                	jmp    8013cb <dev_lookup+0x2a>
  8013bf:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8013c4:	eb 05                	jmp    8013cb <dev_lookup+0x2a>
  8013c6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8013cb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	eb 38                	jmp    80140c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013d4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8013da:	74 dc                	je     8013b8 <dev_lookup+0x17>
  8013dc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8013e2:	74 db                	je     8013bf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013e4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8013ea:	8b 52 48             	mov    0x48(%edx),%edx
  8013ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013f5:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  8013fc:	e8 f2 ed ff ff       	call   8001f3 <cprintf>
	*dev = 0;
  801401:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80140c:	83 c4 14             	add    $0x14,%esp
  80140f:	5b                   	pop    %ebx
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
  801417:	83 ec 20             	sub    $0x20,%esp
  80141a:	8b 75 08             	mov    0x8(%ebp),%esi
  80141d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801420:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801427:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80142d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801430:	89 04 24             	mov    %eax,(%esp)
  801433:	e8 13 ff ff ff       	call   80134b <fd_lookup>
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 05                	js     801441 <fd_close+0x2f>
	    || fd != fd2)
  80143c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80143f:	74 0c                	je     80144d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801441:	84 db                	test   %bl,%bl
  801443:	ba 00 00 00 00       	mov    $0x0,%edx
  801448:	0f 44 c2             	cmove  %edx,%eax
  80144b:	eb 3f                	jmp    80148c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80144d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801450:	89 44 24 04          	mov    %eax,0x4(%esp)
  801454:	8b 06                	mov    (%esi),%eax
  801456:	89 04 24             	mov    %eax,(%esp)
  801459:	e8 43 ff ff ff       	call   8013a1 <dev_lookup>
  80145e:	89 c3                	mov    %eax,%ebx
  801460:	85 c0                	test   %eax,%eax
  801462:	78 16                	js     80147a <fd_close+0x68>
		if (dev->dev_close)
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801467:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80146a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 07                	je     80147a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801473:	89 34 24             	mov    %esi,(%esp)
  801476:	ff d0                	call   *%eax
  801478:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80147a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80147e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801485:	e8 16 f9 ff ff       	call   800da0 <sys_page_unmap>
	return r;
  80148a:	89 d8                	mov    %ebx,%eax
}
  80148c:	83 c4 20             	add    $0x20,%esp
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801499:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	89 04 24             	mov    %eax,(%esp)
  8014a6:	e8 a0 fe ff ff       	call   80134b <fd_lookup>
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	85 d2                	test   %edx,%edx
  8014af:	78 13                	js     8014c4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014b8:	00 
  8014b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bc:	89 04 24             	mov    %eax,(%esp)
  8014bf:	e8 4e ff ff ff       	call   801412 <fd_close>
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <close_all>:

void
close_all(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	53                   	push   %ebx
  8014ca:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d2:	89 1c 24             	mov    %ebx,(%esp)
  8014d5:	e8 b9 ff ff ff       	call   801493 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014da:	83 c3 01             	add    $0x1,%ebx
  8014dd:	83 fb 20             	cmp    $0x20,%ebx
  8014e0:	75 f0                	jne    8014d2 <close_all+0xc>
		close(i);
}
  8014e2:	83 c4 14             	add    $0x14,%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	89 04 24             	mov    %eax,(%esp)
  8014fe:	e8 48 fe ff ff       	call   80134b <fd_lookup>
  801503:	89 c2                	mov    %eax,%edx
  801505:	85 d2                	test   %edx,%edx
  801507:	0f 88 e1 00 00 00    	js     8015ee <dup+0x106>
		return r;
	close(newfdnum);
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 7b ff ff ff       	call   801493 <close>

	newfd = INDEX2FD(newfdnum);
  801518:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80151b:	c1 e3 0c             	shl    $0xc,%ebx
  80151e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 91 fd ff ff       	call   8012c0 <fd2data>
  80152f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801531:	89 1c 24             	mov    %ebx,(%esp)
  801534:	e8 87 fd ff ff       	call   8012c0 <fd2data>
  801539:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80153b:	89 f0                	mov    %esi,%eax
  80153d:	c1 e8 16             	shr    $0x16,%eax
  801540:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801547:	a8 01                	test   $0x1,%al
  801549:	74 43                	je     80158e <dup+0xa6>
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	c1 e8 0c             	shr    $0xc,%eax
  801550:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801557:	f6 c2 01             	test   $0x1,%dl
  80155a:	74 32                	je     80158e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80155c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801563:	25 07 0e 00 00       	and    $0xe07,%eax
  801568:	89 44 24 10          	mov    %eax,0x10(%esp)
  80156c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801570:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801577:	00 
  801578:	89 74 24 04          	mov    %esi,0x4(%esp)
  80157c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801583:	e8 c5 f7 ff ff       	call   800d4d <sys_page_map>
  801588:	89 c6                	mov    %eax,%esi
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 3e                	js     8015cc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80158e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801591:	89 c2                	mov    %eax,%edx
  801593:	c1 ea 0c             	shr    $0xc,%edx
  801596:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015b2:	00 
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015be:	e8 8a f7 ff ff       	call   800d4d <sys_page_map>
  8015c3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015c8:	85 f6                	test   %esi,%esi
  8015ca:	79 22                	jns    8015ee <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d7:	e8 c4 f7 ff ff       	call   800da0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e7:	e8 b4 f7 ff ff       	call   800da0 <sys_page_unmap>
	return r;
  8015ec:	89 f0                	mov    %esi,%eax
}
  8015ee:	83 c4 3c             	add    $0x3c,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5f                   	pop    %edi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 24             	sub    $0x24,%esp
  8015fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801600:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801603:	89 44 24 04          	mov    %eax,0x4(%esp)
  801607:	89 1c 24             	mov    %ebx,(%esp)
  80160a:	e8 3c fd ff ff       	call   80134b <fd_lookup>
  80160f:	89 c2                	mov    %eax,%edx
  801611:	85 d2                	test   %edx,%edx
  801613:	78 6d                	js     801682 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801615:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 78 fd ff ff       	call   8013a1 <dev_lookup>
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 55                	js     801682 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	8b 50 08             	mov    0x8(%eax),%edx
  801633:	83 e2 03             	and    $0x3,%edx
  801636:	83 fa 01             	cmp    $0x1,%edx
  801639:	75 23                	jne    80165e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80163b:	a1 04 40 80 00       	mov    0x804004,%eax
  801640:	8b 40 48             	mov    0x48(%eax),%eax
  801643:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164b:	c7 04 24 9d 2a 80 00 	movl   $0x802a9d,(%esp)
  801652:	e8 9c eb ff ff       	call   8001f3 <cprintf>
		return -E_INVAL;
  801657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165c:	eb 24                	jmp    801682 <read+0x8c>
	}
	if (!dev->dev_read)
  80165e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801661:	8b 52 08             	mov    0x8(%edx),%edx
  801664:	85 d2                	test   %edx,%edx
  801666:	74 15                	je     80167d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801668:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80166f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801672:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801676:	89 04 24             	mov    %eax,(%esp)
  801679:	ff d2                	call   *%edx
  80167b:	eb 05                	jmp    801682 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80167d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801682:	83 c4 24             	add    $0x24,%esp
  801685:	5b                   	pop    %ebx
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	57                   	push   %edi
  80168c:	56                   	push   %esi
  80168d:	53                   	push   %ebx
  80168e:	83 ec 1c             	sub    $0x1c,%esp
  801691:	8b 7d 08             	mov    0x8(%ebp),%edi
  801694:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801697:	85 f6                	test   %esi,%esi
  801699:	74 33                	je     8016ce <readn+0x46>
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a5:	89 f2                	mov    %esi,%edx
  8016a7:	29 c2                	sub    %eax,%edx
  8016a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016ad:	03 45 0c             	add    0xc(%ebp),%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	89 3c 24             	mov    %edi,(%esp)
  8016b7:	e8 3a ff ff ff       	call   8015f6 <read>
		if (m < 0)
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 1b                	js     8016db <readn+0x53>
			return m;
		if (m == 0)
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	74 11                	je     8016d5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016c4:	01 c3                	add    %eax,%ebx
  8016c6:	89 d8                	mov    %ebx,%eax
  8016c8:	39 f3                	cmp    %esi,%ebx
  8016ca:	72 d9                	jb     8016a5 <readn+0x1d>
  8016cc:	eb 0b                	jmp    8016d9 <readn+0x51>
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	eb 06                	jmp    8016db <readn+0x53>
  8016d5:	89 d8                	mov    %ebx,%eax
  8016d7:	eb 02                	jmp    8016db <readn+0x53>
  8016d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016db:	83 c4 1c             	add    $0x1c,%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 24             	sub    $0x24,%esp
  8016ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	89 1c 24             	mov    %ebx,(%esp)
  8016f7:	e8 4f fc ff ff       	call   80134b <fd_lookup>
  8016fc:	89 c2                	mov    %eax,%edx
  8016fe:	85 d2                	test   %edx,%edx
  801700:	78 68                	js     80176a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801702:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801705:	89 44 24 04          	mov    %eax,0x4(%esp)
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 8b fc ff ff       	call   8013a1 <dev_lookup>
  801716:	85 c0                	test   %eax,%eax
  801718:	78 50                	js     80176a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801721:	75 23                	jne    801746 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801723:	a1 04 40 80 00       	mov    0x804004,%eax
  801728:	8b 40 48             	mov    0x48(%eax),%eax
  80172b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801733:	c7 04 24 b9 2a 80 00 	movl   $0x802ab9,(%esp)
  80173a:	e8 b4 ea ff ff       	call   8001f3 <cprintf>
		return -E_INVAL;
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801744:	eb 24                	jmp    80176a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801749:	8b 52 0c             	mov    0xc(%edx),%edx
  80174c:	85 d2                	test   %edx,%edx
  80174e:	74 15                	je     801765 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801750:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801753:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801757:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80175e:	89 04 24             	mov    %eax,(%esp)
  801761:	ff d2                	call   *%edx
  801763:	eb 05                	jmp    80176a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801765:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80176a:	83 c4 24             	add    $0x24,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <seek>:

int
seek(int fdnum, off_t offset)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801776:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	89 04 24             	mov    %eax,(%esp)
  801783:	e8 c3 fb ff ff       	call   80134b <fd_lookup>
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 0e                	js     80179a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80178c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 24             	sub    $0x24,%esp
  8017a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ad:	89 1c 24             	mov    %ebx,(%esp)
  8017b0:	e8 96 fb ff ff       	call   80134b <fd_lookup>
  8017b5:	89 c2                	mov    %eax,%edx
  8017b7:	85 d2                	test   %edx,%edx
  8017b9:	78 61                	js     80181c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 d2 fb ff ff       	call   8013a1 <dev_lookup>
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 49                	js     80181c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017da:	75 23                	jne    8017ff <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017dc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e1:	8b 40 48             	mov    0x48(%eax),%eax
  8017e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ec:	c7 04 24 7c 2a 80 00 	movl   $0x802a7c,(%esp)
  8017f3:	e8 fb e9 ff ff       	call   8001f3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fd:	eb 1d                	jmp    80181c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	8b 52 18             	mov    0x18(%edx),%edx
  801805:	85 d2                	test   %edx,%edx
  801807:	74 0e                	je     801817 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801809:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801810:	89 04 24             	mov    %eax,(%esp)
  801813:	ff d2                	call   *%edx
  801815:	eb 05                	jmp    80181c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801817:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80181c:	83 c4 24             	add    $0x24,%esp
  80181f:	5b                   	pop    %ebx
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    

00801822 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	53                   	push   %ebx
  801826:	83 ec 24             	sub    $0x24,%esp
  801829:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	89 04 24             	mov    %eax,(%esp)
  801839:	e8 0d fb ff ff       	call   80134b <fd_lookup>
  80183e:	89 c2                	mov    %eax,%edx
  801840:	85 d2                	test   %edx,%edx
  801842:	78 52                	js     801896 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801844:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184e:	8b 00                	mov    (%eax),%eax
  801850:	89 04 24             	mov    %eax,(%esp)
  801853:	e8 49 fb ff ff       	call   8013a1 <dev_lookup>
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 3a                	js     801896 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801863:	74 2c                	je     801891 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801865:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801868:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80186f:	00 00 00 
	stat->st_isdir = 0;
  801872:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801879:	00 00 00 
	stat->st_dev = dev;
  80187c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801882:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801886:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801889:	89 14 24             	mov    %edx,(%esp)
  80188c:	ff 50 14             	call   *0x14(%eax)
  80188f:	eb 05                	jmp    801896 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801896:	83 c4 24             	add    $0x24,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ab:	00 
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 af 01 00 00       	call   801a66 <open>
  8018b7:	89 c3                	mov    %eax,%ebx
  8018b9:	85 db                	test   %ebx,%ebx
  8018bb:	78 1b                	js     8018d8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c4:	89 1c 24             	mov    %ebx,(%esp)
  8018c7:	e8 56 ff ff ff       	call   801822 <fstat>
  8018cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ce:	89 1c 24             	mov    %ebx,(%esp)
  8018d1:	e8 bd fb ff ff       	call   801493 <close>
	return r;
  8018d6:	89 f0                	mov    %esi,%eax
}
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5d                   	pop    %ebp
  8018de:	c3                   	ret    

008018df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	83 ec 10             	sub    $0x10,%esp
  8018e7:	89 c6                	mov    %eax,%esi
  8018e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018eb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018f2:	75 11                	jne    801905 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8018fb:	e8 34 09 00 00       	call   802234 <ipc_find_env>
  801900:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801905:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80190c:	00 
  80190d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801914:	00 
  801915:	89 74 24 04          	mov    %esi,0x4(%esp)
  801919:	a1 00 40 80 00       	mov    0x804000,%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 a8 08 00 00       	call   8021ce <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801926:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80192d:	00 
  80192e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801939:	e8 28 08 00 00       	call   802166 <ipc_recv>
}
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	53                   	push   %ebx
  801949:	83 ec 14             	sub    $0x14,%esp
  80194c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
  801955:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	b8 05 00 00 00       	mov    $0x5,%eax
  801964:	e8 76 ff ff ff       	call   8018df <fsipc>
  801969:	89 c2                	mov    %eax,%edx
  80196b:	85 d2                	test   %edx,%edx
  80196d:	78 2b                	js     80199a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80196f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801976:	00 
  801977:	89 1c 24             	mov    %ebx,(%esp)
  80197a:	e8 cc ee ff ff       	call   80084b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80197f:	a1 80 50 80 00       	mov    0x805080,%eax
  801984:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80198a:	a1 84 50 80 00       	mov    0x805084,%eax
  80198f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199a:	83 c4 14             	add    $0x14,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019bb:	e8 1f ff ff ff       	call   8018df <fsipc>
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 10             	sub    $0x10,%esp
  8019ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019d8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8019e8:	e8 f2 fe ff ff       	call   8018df <fsipc>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 6a                	js     801a5d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8019f3:	39 c6                	cmp    %eax,%esi
  8019f5:	73 24                	jae    801a1b <devfile_read+0x59>
  8019f7:	c7 44 24 0c d6 2a 80 	movl   $0x802ad6,0xc(%esp)
  8019fe:	00 
  8019ff:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801a06:	00 
  801a07:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801a0e:	00 
  801a0f:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801a16:	e8 3b 06 00 00       	call   802056 <_panic>
	assert(r <= PGSIZE);
  801a1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a20:	7e 24                	jle    801a46 <devfile_read+0x84>
  801a22:	c7 44 24 0c fd 2a 80 	movl   $0x802afd,0xc(%esp)
  801a29:	00 
  801a2a:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801a31:	00 
  801a32:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801a39:	00 
  801a3a:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801a41:	e8 10 06 00 00       	call   802056 <_panic>
	memmove(buf, &fsipcbuf, r);
  801a46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a51:	00 
  801a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a55:	89 04 24             	mov    %eax,(%esp)
  801a58:	e8 e9 ef ff ff       	call   800a46 <memmove>
	return r;
}
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 24             	sub    $0x24,%esp
  801a6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a70:	89 1c 24             	mov    %ebx,(%esp)
  801a73:	e8 78 ed ff ff       	call   8007f0 <strlen>
  801a78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a7d:	7f 60                	jg     801adf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	e8 4d f8 ff ff       	call   8012d7 <fd_alloc>
  801a8a:	89 c2                	mov    %eax,%edx
  801a8c:	85 d2                	test   %edx,%edx
  801a8e:	78 54                	js     801ae4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a94:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801a9b:	e8 ab ed ff ff       	call   80084b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aab:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab0:	e8 2a fe ff ff       	call   8018df <fsipc>
  801ab5:	89 c3                	mov    %eax,%ebx
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	79 17                	jns    801ad2 <open+0x6c>
		fd_close(fd, 0);
  801abb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ac2:	00 
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	89 04 24             	mov    %eax,(%esp)
  801ac9:	e8 44 f9 ff ff       	call   801412 <fd_close>
		return r;
  801ace:	89 d8                	mov    %ebx,%eax
  801ad0:	eb 12                	jmp    801ae4 <open+0x7e>
	}
	return fd2num(fd);
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	89 04 24             	mov    %eax,(%esp)
  801ad8:	e8 d3 f7 ff ff       	call   8012b0 <fd2num>
  801add:	eb 05                	jmp    801ae4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801adf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801ae4:	83 c4 24             	add    $0x24,%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	66 90                	xchg   %ax,%ax
  801aee:	66 90                	xchg   %ax,%ax

00801af0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	83 ec 10             	sub    $0x10,%esp
  801af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	89 04 24             	mov    %eax,(%esp)
  801b01:	e8 ba f7 ff ff       	call   8012c0 <fd2data>
  801b06:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b08:	c7 44 24 04 09 2b 80 	movl   $0x802b09,0x4(%esp)
  801b0f:	00 
  801b10:	89 1c 24             	mov    %ebx,(%esp)
  801b13:	e8 33 ed ff ff       	call   80084b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b18:	8b 46 04             	mov    0x4(%esi),%eax
  801b1b:	2b 06                	sub    (%esi),%eax
  801b1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b2a:	00 00 00 
	stat->st_dev = &devpipe;
  801b2d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b34:	30 80 00 
	return 0;
}
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	53                   	push   %ebx
  801b47:	83 ec 14             	sub    $0x14,%esp
  801b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b58:	e8 43 f2 ff ff       	call   800da0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b5d:	89 1c 24             	mov    %ebx,(%esp)
  801b60:	e8 5b f7 ff ff       	call   8012c0 <fd2data>
  801b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b70:	e8 2b f2 ff ff       	call   800da0 <sys_page_unmap>
}
  801b75:	83 c4 14             	add    $0x14,%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	57                   	push   %edi
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	83 ec 2c             	sub    $0x2c,%esp
  801b84:	89 c6                	mov    %eax,%esi
  801b86:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b89:	a1 04 40 80 00       	mov    0x804004,%eax
  801b8e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b91:	89 34 24             	mov    %esi,(%esp)
  801b94:	e8 e3 06 00 00       	call   80227c <pageref>
  801b99:	89 c7                	mov    %eax,%edi
  801b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 d6 06 00 00       	call   80227c <pageref>
  801ba6:	39 c7                	cmp    %eax,%edi
  801ba8:	0f 94 c2             	sete   %dl
  801bab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801bae:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801bb4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801bb7:	39 fb                	cmp    %edi,%ebx
  801bb9:	74 21                	je     801bdc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801bbb:	84 d2                	test   %dl,%dl
  801bbd:	74 ca                	je     801b89 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbf:	8b 51 58             	mov    0x58(%ecx),%edx
  801bc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bce:	c7 04 24 10 2b 80 00 	movl   $0x802b10,(%esp)
  801bd5:	e8 19 e6 ff ff       	call   8001f3 <cprintf>
  801bda:	eb ad                	jmp    801b89 <_pipeisclosed+0xe>
	}
}
  801bdc:	83 c4 2c             	add    $0x2c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	57                   	push   %edi
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	83 ec 1c             	sub    $0x1c,%esp
  801bed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bf0:	89 34 24             	mov    %esi,(%esp)
  801bf3:	e8 c8 f6 ff ff       	call   8012c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bfc:	74 61                	je     801c5f <devpipe_write+0x7b>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	bf 00 00 00 00       	mov    $0x0,%edi
  801c05:	eb 4a                	jmp    801c51 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c07:	89 da                	mov    %ebx,%edx
  801c09:	89 f0                	mov    %esi,%eax
  801c0b:	e8 6b ff ff ff       	call   801b7b <_pipeisclosed>
  801c10:	85 c0                	test   %eax,%eax
  801c12:	75 54                	jne    801c68 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c14:	e8 c1 f0 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c19:	8b 43 04             	mov    0x4(%ebx),%eax
  801c1c:	8b 0b                	mov    (%ebx),%ecx
  801c1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801c21:	39 d0                	cmp    %edx,%eax
  801c23:	73 e2                	jae    801c07 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c28:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c2c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c2f:	99                   	cltd   
  801c30:	c1 ea 1b             	shr    $0x1b,%edx
  801c33:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801c36:	83 e1 1f             	and    $0x1f,%ecx
  801c39:	29 d1                	sub    %edx,%ecx
  801c3b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801c3f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801c43:	83 c0 01             	add    $0x1,%eax
  801c46:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c49:	83 c7 01             	add    $0x1,%edi
  801c4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c4f:	74 13                	je     801c64 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c51:	8b 43 04             	mov    0x4(%ebx),%eax
  801c54:	8b 0b                	mov    (%ebx),%ecx
  801c56:	8d 51 20             	lea    0x20(%ecx),%edx
  801c59:	39 d0                	cmp    %edx,%eax
  801c5b:	73 aa                	jae    801c07 <devpipe_write+0x23>
  801c5d:	eb c6                	jmp    801c25 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c5f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c64:	89 f8                	mov    %edi,%eax
  801c66:	eb 05                	jmp    801c6d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c6d:	83 c4 1c             	add    $0x1c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    

00801c75 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	57                   	push   %edi
  801c79:	56                   	push   %esi
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 1c             	sub    $0x1c,%esp
  801c7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c81:	89 3c 24             	mov    %edi,(%esp)
  801c84:	e8 37 f6 ff ff       	call   8012c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c8d:	74 54                	je     801ce3 <devpipe_read+0x6e>
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	be 00 00 00 00       	mov    $0x0,%esi
  801c96:	eb 3e                	jmp    801cd6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801c98:	89 f0                	mov    %esi,%eax
  801c9a:	eb 55                	jmp    801cf1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c9c:	89 da                	mov    %ebx,%edx
  801c9e:	89 f8                	mov    %edi,%eax
  801ca0:	e8 d6 fe ff ff       	call   801b7b <_pipeisclosed>
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	75 43                	jne    801cec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ca9:	e8 2c f0 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cae:	8b 03                	mov    (%ebx),%eax
  801cb0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cb3:	74 e7                	je     801c9c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb5:	99                   	cltd   
  801cb6:	c1 ea 1b             	shr    $0x1b,%edx
  801cb9:	01 d0                	add    %edx,%eax
  801cbb:	83 e0 1f             	and    $0x1f,%eax
  801cbe:	29 d0                	sub    %edx,%eax
  801cc0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ccb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cce:	83 c6 01             	add    $0x1,%esi
  801cd1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cd4:	74 12                	je     801ce8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801cd6:	8b 03                	mov    (%ebx),%eax
  801cd8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cdb:	75 d8                	jne    801cb5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801cdd:	85 f6                	test   %esi,%esi
  801cdf:	75 b7                	jne    801c98 <devpipe_read+0x23>
  801ce1:	eb b9                	jmp    801c9c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ce3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ce8:	89 f0                	mov    %esi,%eax
  801cea:	eb 05                	jmp    801cf1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801cf1:	83 c4 1c             	add    $0x1c,%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5f                   	pop    %edi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    

00801cf9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	56                   	push   %esi
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d04:	89 04 24             	mov    %eax,(%esp)
  801d07:	e8 cb f5 ff ff       	call   8012d7 <fd_alloc>
  801d0c:	89 c2                	mov    %eax,%edx
  801d0e:	85 d2                	test   %edx,%edx
  801d10:	0f 88 4d 01 00 00    	js     801e63 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d1d:	00 
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2c:	e8 c8 ef ff ff       	call   800cf9 <sys_page_alloc>
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	85 d2                	test   %edx,%edx
  801d35:	0f 88 28 01 00 00    	js     801e63 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3e:	89 04 24             	mov    %eax,(%esp)
  801d41:	e8 91 f5 ff ff       	call   8012d7 <fd_alloc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	0f 88 fe 00 00 00    	js     801e4e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d50:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d57:	00 
  801d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d66:	e8 8e ef ff ff       	call   800cf9 <sys_page_alloc>
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	0f 88 d9 00 00 00    	js     801e4e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	89 04 24             	mov    %eax,(%esp)
  801d7b:	e8 40 f5 ff ff       	call   8012c0 <fd2data>
  801d80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d89:	00 
  801d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d95:	e8 5f ef ff ff       	call   800cf9 <sys_page_alloc>
  801d9a:	89 c3                	mov    %eax,%ebx
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	0f 88 97 00 00 00    	js     801e3b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da7:	89 04 24             	mov    %eax,(%esp)
  801daa:	e8 11 f5 ff ff       	call   8012c0 <fd2data>
  801daf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801db6:	00 
  801db7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dc2:	00 
  801dc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dce:	e8 7a ef ff ff       	call   800d4d <sys_page_map>
  801dd3:	89 c3                	mov    %eax,%ebx
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	78 52                	js     801e2b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801dd9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801dee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 a2 f4 ff ff       	call   8012b0 <fd2num>
  801e0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e11:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	89 04 24             	mov    %eax,(%esp)
  801e19:	e8 92 f4 ff ff       	call   8012b0 <fd2num>
  801e1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e21:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	eb 38                	jmp    801e63 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801e2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e36:	e8 65 ef ff ff       	call   800da0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e49:	e8 52 ef ff ff       	call   800da0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5c:	e8 3f ef ff ff       	call   800da0 <sys_page_unmap>
  801e61:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801e63:	83 c4 30             	add    $0x30,%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	89 04 24             	mov    %eax,(%esp)
  801e7d:	e8 c9 f4 ff ff       	call   80134b <fd_lookup>
  801e82:	89 c2                	mov    %eax,%edx
  801e84:	85 d2                	test   %edx,%edx
  801e86:	78 15                	js     801e9d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 2d f4 ff ff       	call   8012c0 <fd2data>
	return _pipeisclosed(fd, p);
  801e93:	89 c2                	mov    %eax,%edx
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	e8 de fc ff ff       	call   801b7b <_pipeisclosed>
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    
  801e9f:	90                   	nop

00801ea0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    

00801eaa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801eb0:	c7 44 24 04 28 2b 80 	movl   $0x802b28,0x4(%esp)
  801eb7:	00 
  801eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebb:	89 04 24             	mov    %eax,(%esp)
  801ebe:	e8 88 e9 ff ff       	call   80084b <strcpy>
	return 0;
}
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	57                   	push   %edi
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eda:	74 4a                	je     801f26 <devcons_write+0x5c>
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ee6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801eec:	8b 75 10             	mov    0x10(%ebp),%esi
  801eef:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801ef1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ef4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ef9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801efc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f00:	03 45 0c             	add    0xc(%ebp),%eax
  801f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f07:	89 3c 24             	mov    %edi,(%esp)
  801f0a:	e8 37 eb ff ff       	call   800a46 <memmove>
		sys_cputs(buf, m);
  801f0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f13:	89 3c 24             	mov    %edi,(%esp)
  801f16:	e8 11 ed ff ff       	call   800c2c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f1b:	01 f3                	add    %esi,%ebx
  801f1d:	89 d8                	mov    %ebx,%eax
  801f1f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801f22:	72 c8                	jb     801eec <devcons_write+0x22>
  801f24:	eb 05                	jmp    801f2b <devcons_write+0x61>
  801f26:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f2b:	89 d8                	mov    %ebx,%eax
  801f2d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f47:	75 07                	jne    801f50 <devcons_read+0x18>
  801f49:	eb 28                	jmp    801f73 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f4b:	e8 8a ed ff ff       	call   800cda <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f50:	e8 f5 ec ff ff       	call   800c4a <sys_cgetc>
  801f55:	85 c0                	test   %eax,%eax
  801f57:	74 f2                	je     801f4b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 16                	js     801f73 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f5d:	83 f8 04             	cmp    $0x4,%eax
  801f60:	74 0c                	je     801f6e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	88 02                	mov    %al,(%edx)
	return 1;
  801f67:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6c:	eb 05                	jmp    801f73 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f88:	00 
  801f89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f8c:	89 04 24             	mov    %eax,(%esp)
  801f8f:	e8 98 ec ff ff       	call   800c2c <sys_cputs>
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <getchar>:

int
getchar(void)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fa3:	00 
  801fa4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb2:	e8 3f f6 ff ff       	call   8015f6 <read>
	if (r < 0)
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	78 0f                	js     801fca <getchar+0x34>
		return r;
	if (r < 1)
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	7e 06                	jle    801fc5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801fbf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fc3:	eb 05                	jmp    801fca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801fc5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	89 04 24             	mov    %eax,(%esp)
  801fdf:	e8 67 f3 ff ff       	call   80134b <fd_lookup>
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 11                	js     801ff9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff1:	39 10                	cmp    %edx,(%eax)
  801ff3:	0f 94 c0             	sete   %al
  801ff6:	0f b6 c0             	movzbl %al,%eax
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <opencons>:

int
opencons(void)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802001:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802004:	89 04 24             	mov    %eax,(%esp)
  802007:	e8 cb f2 ff ff       	call   8012d7 <fd_alloc>
		return r;
  80200c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 40                	js     802052 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802012:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802019:	00 
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802021:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802028:	e8 cc ec ff ff       	call   800cf9 <sys_page_alloc>
		return r;
  80202d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 1f                	js     802052 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802033:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802048:	89 04 24             	mov    %eax,(%esp)
  80204b:	e8 60 f2 ff ff       	call   8012b0 <fd2num>
  802050:	89 c2                	mov    %eax,%edx
}
  802052:	89 d0                	mov    %edx,%eax
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	56                   	push   %esi
  80205a:	53                   	push   %ebx
  80205b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80205e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802061:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802067:	e8 4f ec ff ff       	call   800cbb <sys_getenvid>
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802073:	8b 55 08             	mov    0x8(%ebp),%edx
  802076:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80207a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80207e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802082:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  802089:	e8 65 e1 ff ff       	call   8001f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80208e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802092:	8b 45 10             	mov    0x10(%ebp),%eax
  802095:	89 04 24             	mov    %eax,(%esp)
  802098:	e8 f5 e0 ff ff       	call   800192 <vcprintf>
	cprintf("\n");
  80209d:	c7 04 24 f4 25 80 00 	movl   $0x8025f4,(%esp)
  8020a4:	e8 4a e1 ff ff       	call   8001f3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020a9:	cc                   	int3   
  8020aa:	eb fd                	jmp    8020a9 <_panic+0x53>

008020ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  8020b2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020b9:	75 50                	jne    80210b <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8020bb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020c2:	00 
  8020c3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8020ca:	ee 
  8020cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d2:	e8 22 ec ff ff       	call   800cf9 <sys_page_alloc>
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	79 1c                	jns    8020f7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8020db:	c7 44 24 08 58 2b 80 	movl   $0x802b58,0x8(%esp)
  8020e2:	00 
  8020e3:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8020ea:	00 
  8020eb:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  8020f2:	e8 5f ff ff ff       	call   802056 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8020f7:	c7 44 24 04 15 21 80 	movl   $0x802115,0x4(%esp)
  8020fe:	00 
  8020ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802106:	e8 8e ed ff ff       	call   800e99 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802115:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802116:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80211b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80211d:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  802120:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  802122:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802127:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80212a:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  80212f:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  802132:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  802134:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802137:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802139:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  80213b:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  802140:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  802143:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802148:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  80214b:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  80214d:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  802152:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  802155:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80215a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  80215d:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  80215f:	83 c4 08             	add    $0x8,%esp
	popal
  802162:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802163:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802164:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802165:	c3                   	ret    

00802166 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	56                   	push   %esi
  80216a:	53                   	push   %ebx
  80216b:	83 ec 10             	sub    $0x10,%esp
  80216e:	8b 75 08             	mov    0x8(%ebp),%esi
  802171:	8b 45 0c             	mov    0xc(%ebp),%eax
  802174:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802177:	85 c0                	test   %eax,%eax
  802179:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80217e:	0f 44 c2             	cmove  %edx,%eax
  802181:	89 04 24             	mov    %eax,(%esp)
  802184:	e8 86 ed ff ff       	call   800f0f <sys_ipc_recv>
	if (err_code < 0) {
  802189:	85 c0                	test   %eax,%eax
  80218b:	79 16                	jns    8021a3 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80218d:	85 f6                	test   %esi,%esi
  80218f:	74 06                	je     802197 <ipc_recv+0x31>
  802191:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802197:	85 db                	test   %ebx,%ebx
  802199:	74 2c                	je     8021c7 <ipc_recv+0x61>
  80219b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021a1:	eb 24                	jmp    8021c7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8021a3:	85 f6                	test   %esi,%esi
  8021a5:	74 0a                	je     8021b1 <ipc_recv+0x4b>
  8021a7:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ac:	8b 40 74             	mov    0x74(%eax),%eax
  8021af:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8021b1:	85 db                	test   %ebx,%ebx
  8021b3:	74 0a                	je     8021bf <ipc_recv+0x59>
  8021b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ba:	8b 40 78             	mov    0x78(%eax),%eax
  8021bd:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8021bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8021c4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	5b                   	pop    %ebx
  8021cb:	5e                   	pop    %esi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8021e0:	eb 25                	jmp    802207 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8021e2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021e5:	74 20                	je     802207 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8021e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021eb:	c7 44 24 08 8a 2b 80 	movl   $0x802b8a,0x8(%esp)
  8021f2:	00 
  8021f3:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8021fa:	00 
  8021fb:	c7 04 24 96 2b 80 00 	movl   $0x802b96,(%esp)
  802202:	e8 4f fe ff ff       	call   802056 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802207:	85 db                	test   %ebx,%ebx
  802209:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80220e:	0f 45 c3             	cmovne %ebx,%eax
  802211:	8b 55 14             	mov    0x14(%ebp),%edx
  802214:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80221c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802220:	89 3c 24             	mov    %edi,(%esp)
  802223:	e8 c4 ec ff ff       	call   800eec <sys_ipc_try_send>
  802228:	85 c0                	test   %eax,%eax
  80222a:	75 b6                	jne    8021e2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80223a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80223f:	39 c8                	cmp    %ecx,%eax
  802241:	74 17                	je     80225a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802243:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802248:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80224b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802251:	8b 52 50             	mov    0x50(%edx),%edx
  802254:	39 ca                	cmp    %ecx,%edx
  802256:	75 14                	jne    80226c <ipc_find_env+0x38>
  802258:	eb 05                	jmp    80225f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80225f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802262:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802267:	8b 40 40             	mov    0x40(%eax),%eax
  80226a:	eb 0e                	jmp    80227a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80226c:	83 c0 01             	add    $0x1,%eax
  80226f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802274:	75 d2                	jne    802248 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802276:	66 b8 00 00          	mov    $0x0,%ax
}
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    

0080227c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802282:	89 d0                	mov    %edx,%eax
  802284:	c1 e8 16             	shr    $0x16,%eax
  802287:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802293:	f6 c1 01             	test   $0x1,%cl
  802296:	74 1d                	je     8022b5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802298:	c1 ea 0c             	shr    $0xc,%edx
  80229b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022a2:	f6 c2 01             	test   $0x1,%dl
  8022a5:	74 0e                	je     8022b5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a7:	c1 ea 0c             	shr    $0xc,%edx
  8022aa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022b1:	ef 
  8022b2:	0f b7 c0             	movzwl %ax,%eax
}
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    
  8022b7:	66 90                	xchg   %ax,%ax
  8022b9:	66 90                	xchg   %ax,%ax
  8022bb:	66 90                	xchg   %ax,%ax
  8022bd:	66 90                	xchg   %ax,%ax
  8022bf:	90                   	nop

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	83 ec 0c             	sub    $0xc,%esp
  8022c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8022ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8022ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8022d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022dc:	89 ea                	mov    %ebp,%edx
  8022de:	89 0c 24             	mov    %ecx,(%esp)
  8022e1:	75 2d                	jne    802310 <__udivdi3+0x50>
  8022e3:	39 e9                	cmp    %ebp,%ecx
  8022e5:	77 61                	ja     802348 <__udivdi3+0x88>
  8022e7:	85 c9                	test   %ecx,%ecx
  8022e9:	89 ce                	mov    %ecx,%esi
  8022eb:	75 0b                	jne    8022f8 <__udivdi3+0x38>
  8022ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f2:	31 d2                	xor    %edx,%edx
  8022f4:	f7 f1                	div    %ecx
  8022f6:	89 c6                	mov    %eax,%esi
  8022f8:	31 d2                	xor    %edx,%edx
  8022fa:	89 e8                	mov    %ebp,%eax
  8022fc:	f7 f6                	div    %esi
  8022fe:	89 c5                	mov    %eax,%ebp
  802300:	89 f8                	mov    %edi,%eax
  802302:	f7 f6                	div    %esi
  802304:	89 ea                	mov    %ebp,%edx
  802306:	83 c4 0c             	add    $0xc,%esp
  802309:	5e                   	pop    %esi
  80230a:	5f                   	pop    %edi
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	39 e8                	cmp    %ebp,%eax
  802312:	77 24                	ja     802338 <__udivdi3+0x78>
  802314:	0f bd e8             	bsr    %eax,%ebp
  802317:	83 f5 1f             	xor    $0x1f,%ebp
  80231a:	75 3c                	jne    802358 <__udivdi3+0x98>
  80231c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802320:	39 34 24             	cmp    %esi,(%esp)
  802323:	0f 86 9f 00 00 00    	jbe    8023c8 <__udivdi3+0x108>
  802329:	39 d0                	cmp    %edx,%eax
  80232b:	0f 82 97 00 00 00    	jb     8023c8 <__udivdi3+0x108>
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	31 d2                	xor    %edx,%edx
  80233a:	31 c0                	xor    %eax,%eax
  80233c:	83 c4 0c             	add    $0xc,%esp
  80233f:	5e                   	pop    %esi
  802340:	5f                   	pop    %edi
  802341:	5d                   	pop    %ebp
  802342:	c3                   	ret    
  802343:	90                   	nop
  802344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 f8                	mov    %edi,%eax
  80234a:	f7 f1                	div    %ecx
  80234c:	31 d2                	xor    %edx,%edx
  80234e:	83 c4 0c             	add    $0xc,%esp
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 e9                	mov    %ebp,%ecx
  80235a:	8b 3c 24             	mov    (%esp),%edi
  80235d:	d3 e0                	shl    %cl,%eax
  80235f:	89 c6                	mov    %eax,%esi
  802361:	b8 20 00 00 00       	mov    $0x20,%eax
  802366:	29 e8                	sub    %ebp,%eax
  802368:	89 c1                	mov    %eax,%ecx
  80236a:	d3 ef                	shr    %cl,%edi
  80236c:	89 e9                	mov    %ebp,%ecx
  80236e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802372:	8b 3c 24             	mov    (%esp),%edi
  802375:	09 74 24 08          	or     %esi,0x8(%esp)
  802379:	89 d6                	mov    %edx,%esi
  80237b:	d3 e7                	shl    %cl,%edi
  80237d:	89 c1                	mov    %eax,%ecx
  80237f:	89 3c 24             	mov    %edi,(%esp)
  802382:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802386:	d3 ee                	shr    %cl,%esi
  802388:	89 e9                	mov    %ebp,%ecx
  80238a:	d3 e2                	shl    %cl,%edx
  80238c:	89 c1                	mov    %eax,%ecx
  80238e:	d3 ef                	shr    %cl,%edi
  802390:	09 d7                	or     %edx,%edi
  802392:	89 f2                	mov    %esi,%edx
  802394:	89 f8                	mov    %edi,%eax
  802396:	f7 74 24 08          	divl   0x8(%esp)
  80239a:	89 d6                	mov    %edx,%esi
  80239c:	89 c7                	mov    %eax,%edi
  80239e:	f7 24 24             	mull   (%esp)
  8023a1:	39 d6                	cmp    %edx,%esi
  8023a3:	89 14 24             	mov    %edx,(%esp)
  8023a6:	72 30                	jb     8023d8 <__udivdi3+0x118>
  8023a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023ac:	89 e9                	mov    %ebp,%ecx
  8023ae:	d3 e2                	shl    %cl,%edx
  8023b0:	39 c2                	cmp    %eax,%edx
  8023b2:	73 05                	jae    8023b9 <__udivdi3+0xf9>
  8023b4:	3b 34 24             	cmp    (%esp),%esi
  8023b7:	74 1f                	je     8023d8 <__udivdi3+0x118>
  8023b9:	89 f8                	mov    %edi,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	e9 7a ff ff ff       	jmp    80233c <__udivdi3+0x7c>
  8023c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023c8:	31 d2                	xor    %edx,%edx
  8023ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cf:	e9 68 ff ff ff       	jmp    80233c <__udivdi3+0x7c>
  8023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	83 c4 0c             	add    $0xc,%esp
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    
  8023e4:	66 90                	xchg   %ax,%ax
  8023e6:	66 90                	xchg   %ax,%ax
  8023e8:	66 90                	xchg   %ax,%ax
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <__umoddi3>:
  8023f0:	55                   	push   %ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	83 ec 14             	sub    $0x14,%esp
  8023f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802402:	89 c7                	mov    %eax,%edi
  802404:	89 44 24 04          	mov    %eax,0x4(%esp)
  802408:	8b 44 24 30          	mov    0x30(%esp),%eax
  80240c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802410:	89 34 24             	mov    %esi,(%esp)
  802413:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802417:	85 c0                	test   %eax,%eax
  802419:	89 c2                	mov    %eax,%edx
  80241b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80241f:	75 17                	jne    802438 <__umoddi3+0x48>
  802421:	39 fe                	cmp    %edi,%esi
  802423:	76 4b                	jbe    802470 <__umoddi3+0x80>
  802425:	89 c8                	mov    %ecx,%eax
  802427:	89 fa                	mov    %edi,%edx
  802429:	f7 f6                	div    %esi
  80242b:	89 d0                	mov    %edx,%eax
  80242d:	31 d2                	xor    %edx,%edx
  80242f:	83 c4 14             	add    $0x14,%esp
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	66 90                	xchg   %ax,%ax
  802438:	39 f8                	cmp    %edi,%eax
  80243a:	77 54                	ja     802490 <__umoddi3+0xa0>
  80243c:	0f bd e8             	bsr    %eax,%ebp
  80243f:	83 f5 1f             	xor    $0x1f,%ebp
  802442:	75 5c                	jne    8024a0 <__umoddi3+0xb0>
  802444:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802448:	39 3c 24             	cmp    %edi,(%esp)
  80244b:	0f 87 e7 00 00 00    	ja     802538 <__umoddi3+0x148>
  802451:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802455:	29 f1                	sub    %esi,%ecx
  802457:	19 c7                	sbb    %eax,%edi
  802459:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80245d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802461:	8b 44 24 08          	mov    0x8(%esp),%eax
  802465:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802469:	83 c4 14             	add    $0x14,%esp
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	85 f6                	test   %esi,%esi
  802472:	89 f5                	mov    %esi,%ebp
  802474:	75 0b                	jne    802481 <__umoddi3+0x91>
  802476:	b8 01 00 00 00       	mov    $0x1,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f6                	div    %esi
  80247f:	89 c5                	mov    %eax,%ebp
  802481:	8b 44 24 04          	mov    0x4(%esp),%eax
  802485:	31 d2                	xor    %edx,%edx
  802487:	f7 f5                	div    %ebp
  802489:	89 c8                	mov    %ecx,%eax
  80248b:	f7 f5                	div    %ebp
  80248d:	eb 9c                	jmp    80242b <__umoddi3+0x3b>
  80248f:	90                   	nop
  802490:	89 c8                	mov    %ecx,%eax
  802492:	89 fa                	mov    %edi,%edx
  802494:	83 c4 14             	add    $0x14,%esp
  802497:	5e                   	pop    %esi
  802498:	5f                   	pop    %edi
  802499:	5d                   	pop    %ebp
  80249a:	c3                   	ret    
  80249b:	90                   	nop
  80249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a0:	8b 04 24             	mov    (%esp),%eax
  8024a3:	be 20 00 00 00       	mov    $0x20,%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	29 ee                	sub    %ebp,%esi
  8024ac:	d3 e2                	shl    %cl,%edx
  8024ae:	89 f1                	mov    %esi,%ecx
  8024b0:	d3 e8                	shr    %cl,%eax
  8024b2:	89 e9                	mov    %ebp,%ecx
  8024b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b8:	8b 04 24             	mov    (%esp),%eax
  8024bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8024bf:	89 fa                	mov    %edi,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 f1                	mov    %esi,%ecx
  8024c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8024cd:	d3 ea                	shr    %cl,%edx
  8024cf:	89 e9                	mov    %ebp,%ecx
  8024d1:	d3 e7                	shl    %cl,%edi
  8024d3:	89 f1                	mov    %esi,%ecx
  8024d5:	d3 e8                	shr    %cl,%eax
  8024d7:	89 e9                	mov    %ebp,%ecx
  8024d9:	09 f8                	or     %edi,%eax
  8024db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8024df:	f7 74 24 04          	divl   0x4(%esp)
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024e9:	89 d7                	mov    %edx,%edi
  8024eb:	f7 64 24 08          	mull   0x8(%esp)
  8024ef:	39 d7                	cmp    %edx,%edi
  8024f1:	89 c1                	mov    %eax,%ecx
  8024f3:	89 14 24             	mov    %edx,(%esp)
  8024f6:	72 2c                	jb     802524 <__umoddi3+0x134>
  8024f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8024fc:	72 22                	jb     802520 <__umoddi3+0x130>
  8024fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802502:	29 c8                	sub    %ecx,%eax
  802504:	19 d7                	sbb    %edx,%edi
  802506:	89 e9                	mov    %ebp,%ecx
  802508:	89 fa                	mov    %edi,%edx
  80250a:	d3 e8                	shr    %cl,%eax
  80250c:	89 f1                	mov    %esi,%ecx
  80250e:	d3 e2                	shl    %cl,%edx
  802510:	89 e9                	mov    %ebp,%ecx
  802512:	d3 ef                	shr    %cl,%edi
  802514:	09 d0                	or     %edx,%eax
  802516:	89 fa                	mov    %edi,%edx
  802518:	83 c4 14             	add    $0x14,%esp
  80251b:	5e                   	pop    %esi
  80251c:	5f                   	pop    %edi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    
  80251f:	90                   	nop
  802520:	39 d7                	cmp    %edx,%edi
  802522:	75 da                	jne    8024fe <__umoddi3+0x10e>
  802524:	8b 14 24             	mov    (%esp),%edx
  802527:	89 c1                	mov    %eax,%ecx
  802529:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80252d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802531:	eb cb                	jmp    8024fe <__umoddi3+0x10e>
  802533:	90                   	nop
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80253c:	0f 82 0f ff ff ff    	jb     802451 <__umoddi3+0x61>
  802542:	e9 1a ff ff ff       	jmp    802461 <__umoddi3+0x71>
