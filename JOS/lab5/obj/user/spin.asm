
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
  80013d:	e8 94 13 00 00       	call   8014d6 <close_all>
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
  80028c:	e8 3f 20 00 00       	call   8022d0 <__udivdi3>
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
  8002e5:	e8 16 21 00 00       	call   802400 <__umoddi3>
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
  800cae:	e8 b3 13 00 00       	call   802066 <_panic>

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
  800d40:	e8 21 13 00 00       	call   802066 <_panic>

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
  800d93:	e8 ce 12 00 00       	call   802066 <_panic>

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
  800de6:	e8 7b 12 00 00       	call   802066 <_panic>

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
  800e39:	e8 28 12 00 00       	call   802066 <_panic>

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
  800e8c:	e8 d5 11 00 00       	call   802066 <_panic>

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
  800edf:	e8 82 11 00 00       	call   802066 <_panic>

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
  800f54:	e8 0d 11 00 00       	call   802066 <_panic>

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
  800f9b:	e8 c6 10 00 00       	call   802066 <_panic>
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
  800fdb:	e8 86 10 00 00       	call   802066 <_panic>
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
  801045:	e8 1c 10 00 00       	call   802066 <_panic>
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
  801060:	e8 57 10 00 00       	call   8020bc <set_pgfault_handler>
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
  80107b:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801082:	00 
  801083:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80108a:	e8 d7 0f 00 00       	call   802066 <_panic>
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
  8010b8:	e9 cf 01 00 00       	jmp    80128c <fork+0x23c>
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
  8010cb:	0f 84 fc 00 00 00    	je     8011cd <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  8010d1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010d8:	a8 05                	test   $0x5,%al
  8010da:	0f 84 ed 00 00 00    	je     8011cd <fork+0x17d>
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
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  8010ec:	f6 c4 04             	test   $0x4,%ah
  8010ef:	0f 85 93 00 00 00    	jne    801188 <fork+0x138>
  8010f5:	a9 02 08 00 00       	test   $0x802,%eax
  8010fa:	0f 84 88 00 00 00    	je     801188 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801100:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801107:	00 
  801108:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80110c:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801110:	89 74 24 04          	mov    %esi,0x4(%esp)
  801114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80111b:	e8 2d fc ff ff       	call   800d4d <sys_page_map>
  801120:	85 c0                	test   %eax,%eax
  801122:	79 20                	jns    801144 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  801124:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801128:	c7 44 24 08 cc 29 80 	movl   $0x8029cc,0x8(%esp)
  80112f:	00 
  801130:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801137:	00 
  801138:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80113f:	e8 22 0f 00 00       	call   802066 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  801144:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80114b:	00 
  80114c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801150:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801157:	00 
  801158:	89 74 24 04          	mov    %esi,0x4(%esp)
  80115c:	89 3c 24             	mov    %edi,(%esp)
  80115f:	e8 e9 fb ff ff       	call   800d4d <sys_page_map>
  801164:	85 c0                	test   %eax,%eax
  801166:	79 65                	jns    8011cd <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  801168:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80116c:	c7 44 24 08 e6 29 80 	movl   $0x8029e6,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801183:	e8 de 0e 00 00       	call   802066 <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  801188:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80118d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801191:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801195:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801199:	89 74 24 04          	mov    %esi,0x4(%esp)
  80119d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a4:	e8 a4 fb ff ff       	call   800d4d <sys_page_map>
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	79 20                	jns    8011cd <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  8011ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011b1:	c7 44 24 08 00 2a 80 	movl   $0x802a00,0x8(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011c0:	00 
  8011c1:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  8011c8:	e8 99 0e 00 00       	call   802066 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  8011cd:	83 c3 01             	add    $0x1,%ebx
  8011d0:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8011d6:	0f 85 e1 fe ff ff    	jne    8010bd <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  8011dc:	c7 44 24 04 25 21 80 	movl   $0x802125,0x4(%esp)
  8011e3:	00 
  8011e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e7:	89 04 24             	mov    %eax,(%esp)
  8011ea:	e8 aa fc ff ff       	call   800e99 <sys_env_set_pgfault_upcall>
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	79 20                	jns    801213 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8011f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011f7:	c7 44 24 08 64 29 80 	movl   $0x802964,0x8(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  801206:	00 
  801207:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80120e:	e8 53 0e 00 00       	call   802066 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801213:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80121a:	00 
  80121b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801222:	ee 
  801223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801226:	89 04 24             	mov    %eax,(%esp)
  801229:	e8 cb fa ff ff       	call   800cf9 <sys_page_alloc>
  80122e:	85 c0                	test   %eax,%eax
  801230:	79 20                	jns    801252 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801232:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801236:	c7 44 24 08 12 2a 80 	movl   $0x802a12,0x8(%esp)
  80123d:	00 
  80123e:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801245:	00 
  801246:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  80124d:	e8 14 0e 00 00       	call   802066 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801252:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801259:	00 
  80125a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125d:	89 04 24             	mov    %eax,(%esp)
  801260:	e8 8e fb ff ff       	call   800df3 <sys_env_set_status>
  801265:	85 c0                	test   %eax,%eax
  801267:	79 20                	jns    801289 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  801269:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126d:	c7 44 24 08 2a 2a 80 	movl   $0x802a2a,0x8(%esp)
  801274:	00 
  801275:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  80127c:	00 
  80127d:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  801284:	e8 dd 0d 00 00       	call   802066 <_panic>
	}

	return envid;
  801289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80128c:	83 c4 2c             	add    $0x2c,%esp
  80128f:	5b                   	pop    %ebx
  801290:	5e                   	pop    %esi
  801291:	5f                   	pop    %edi
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <sfork>:

// Challenge!
int
sfork(void)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80129a:	c7 44 24 08 45 2a 80 	movl   $0x802a45,0x8(%esp)
  8012a1:	00 
  8012a2:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  8012a9:	00 
  8012aa:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  8012b1:	e8 b0 0d 00 00       	call   802066 <_panic>
  8012b6:	66 90                	xchg   %ax,%ax
  8012b8:	66 90                	xchg   %ax,%ax
  8012ba:	66 90                	xchg   %ax,%ax
  8012bc:	66 90                	xchg   %ax,%ax
  8012be:	66 90                	xchg   %ax,%ax

008012c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012ea:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012ef:	a8 01                	test   $0x1,%al
  8012f1:	74 34                	je     801327 <fd_alloc+0x40>
  8012f3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012f8:	a8 01                	test   $0x1,%al
  8012fa:	74 32                	je     80132e <fd_alloc+0x47>
  8012fc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801301:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801303:	89 c2                	mov    %eax,%edx
  801305:	c1 ea 16             	shr    $0x16,%edx
  801308:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80130f:	f6 c2 01             	test   $0x1,%dl
  801312:	74 1f                	je     801333 <fd_alloc+0x4c>
  801314:	89 c2                	mov    %eax,%edx
  801316:	c1 ea 0c             	shr    $0xc,%edx
  801319:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801320:	f6 c2 01             	test   $0x1,%dl
  801323:	75 1a                	jne    80133f <fd_alloc+0x58>
  801325:	eb 0c                	jmp    801333 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801327:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80132c:	eb 05                	jmp    801333 <fd_alloc+0x4c>
  80132e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 08                	mov    %ecx,(%eax)
			return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	eb 1a                	jmp    801359 <fd_alloc+0x72>
  80133f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801344:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801349:	75 b6                	jne    801301 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801354:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801361:	83 f8 1f             	cmp    $0x1f,%eax
  801364:	77 36                	ja     80139c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801366:	c1 e0 0c             	shl    $0xc,%eax
  801369:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80136e:	89 c2                	mov    %eax,%edx
  801370:	c1 ea 16             	shr    $0x16,%edx
  801373:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80137a:	f6 c2 01             	test   $0x1,%dl
  80137d:	74 24                	je     8013a3 <fd_lookup+0x48>
  80137f:	89 c2                	mov    %eax,%edx
  801381:	c1 ea 0c             	shr    $0xc,%edx
  801384:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	74 1a                	je     8013aa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	89 02                	mov    %eax,(%edx)
	return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
  80139a:	eb 13                	jmp    8013af <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a1:	eb 0c                	jmp    8013af <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a8:	eb 05                	jmp    8013af <fd_lookup+0x54>
  8013aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    

008013b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	53                   	push   %ebx
  8013b5:	83 ec 14             	sub    $0x14,%esp
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013be:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8013c4:	75 1e                	jne    8013e4 <dev_lookup+0x33>
  8013c6:	eb 0e                	jmp    8013d6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013c8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8013cd:	eb 0c                	jmp    8013db <dev_lookup+0x2a>
  8013cf:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8013d4:	eb 05                	jmp    8013db <dev_lookup+0x2a>
  8013d6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8013db:	89 03                	mov    %eax,(%ebx)
			return 0;
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e2:	eb 38                	jmp    80141c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013e4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8013ea:	74 dc                	je     8013c8 <dev_lookup+0x17>
  8013ec:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8013f2:	74 db                	je     8013cf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013f4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8013fa:	8b 52 48             	mov    0x48(%edx),%edx
  8013fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801401:	89 54 24 04          	mov    %edx,0x4(%esp)
  801405:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  80140c:	e8 e2 ed ff ff       	call   8001f3 <cprintf>
	*dev = 0;
  801411:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80141c:	83 c4 14             	add    $0x14,%esp
  80141f:	5b                   	pop    %ebx
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	56                   	push   %esi
  801426:	53                   	push   %ebx
  801427:	83 ec 20             	sub    $0x20,%esp
  80142a:	8b 75 08             	mov    0x8(%ebp),%esi
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801430:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801437:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80143d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801440:	89 04 24             	mov    %eax,(%esp)
  801443:	e8 13 ff ff ff       	call   80135b <fd_lookup>
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 05                	js     801451 <fd_close+0x2f>
	    || fd != fd2)
  80144c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80144f:	74 0c                	je     80145d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801451:	84 db                	test   %bl,%bl
  801453:	ba 00 00 00 00       	mov    $0x0,%edx
  801458:	0f 44 c2             	cmove  %edx,%eax
  80145b:	eb 3f                	jmp    80149c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80145d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801460:	89 44 24 04          	mov    %eax,0x4(%esp)
  801464:	8b 06                	mov    (%esi),%eax
  801466:	89 04 24             	mov    %eax,(%esp)
  801469:	e8 43 ff ff ff       	call   8013b1 <dev_lookup>
  80146e:	89 c3                	mov    %eax,%ebx
  801470:	85 c0                	test   %eax,%eax
  801472:	78 16                	js     80148a <fd_close+0x68>
		if (dev->dev_close)
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80147a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 07                	je     80148a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801483:	89 34 24             	mov    %esi,(%esp)
  801486:	ff d0                	call   *%eax
  801488:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80148a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80148e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801495:	e8 06 f9 ff ff       	call   800da0 <sys_page_unmap>
	return r;
  80149a:	89 d8                	mov    %ebx,%eax
}
  80149c:	83 c4 20             	add    $0x20,%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 04 24             	mov    %eax,(%esp)
  8014b6:	e8 a0 fe ff ff       	call   80135b <fd_lookup>
  8014bb:	89 c2                	mov    %eax,%edx
  8014bd:	85 d2                	test   %edx,%edx
  8014bf:	78 13                	js     8014d4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014c8:	00 
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	89 04 24             	mov    %eax,(%esp)
  8014cf:	e8 4e ff ff ff       	call   801422 <fd_close>
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <close_all>:

void
close_all(void)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014e2:	89 1c 24             	mov    %ebx,(%esp)
  8014e5:	e8 b9 ff ff ff       	call   8014a3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ea:	83 c3 01             	add    $0x1,%ebx
  8014ed:	83 fb 20             	cmp    $0x20,%ebx
  8014f0:	75 f0                	jne    8014e2 <close_all+0xc>
		close(i);
}
  8014f2:	83 c4 14             	add    $0x14,%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	57                   	push   %edi
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801501:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 48 fe ff ff       	call   80135b <fd_lookup>
  801513:	89 c2                	mov    %eax,%edx
  801515:	85 d2                	test   %edx,%edx
  801517:	0f 88 e1 00 00 00    	js     8015fe <dup+0x106>
		return r;
	close(newfdnum);
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	89 04 24             	mov    %eax,(%esp)
  801523:	e8 7b ff ff ff       	call   8014a3 <close>

	newfd = INDEX2FD(newfdnum);
  801528:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80152b:	c1 e3 0c             	shl    $0xc,%ebx
  80152e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 91 fd ff ff       	call   8012d0 <fd2data>
  80153f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801541:	89 1c 24             	mov    %ebx,(%esp)
  801544:	e8 87 fd ff ff       	call   8012d0 <fd2data>
  801549:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	c1 e8 16             	shr    $0x16,%eax
  801550:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801557:	a8 01                	test   $0x1,%al
  801559:	74 43                	je     80159e <dup+0xa6>
  80155b:	89 f0                	mov    %esi,%eax
  80155d:	c1 e8 0c             	shr    $0xc,%eax
  801560:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801567:	f6 c2 01             	test   $0x1,%dl
  80156a:	74 32                	je     80159e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80156c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801573:	25 07 0e 00 00       	and    $0xe07,%eax
  801578:	89 44 24 10          	mov    %eax,0x10(%esp)
  80157c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801580:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801587:	00 
  801588:	89 74 24 04          	mov    %esi,0x4(%esp)
  80158c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801593:	e8 b5 f7 ff ff       	call   800d4d <sys_page_map>
  801598:	89 c6                	mov    %eax,%esi
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 3e                	js     8015dc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80159e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	c1 ea 0c             	shr    $0xc,%edx
  8015a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ad:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015b3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015b7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015c2:	00 
  8015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ce:	e8 7a f7 ff ff       	call   800d4d <sys_page_map>
  8015d3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015d8:	85 f6                	test   %esi,%esi
  8015da:	79 22                	jns    8015fe <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e7:	e8 b4 f7 ff ff       	call   800da0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f7:	e8 a4 f7 ff ff       	call   800da0 <sys_page_unmap>
	return r;
  8015fc:	89 f0                	mov    %esi,%eax
}
  8015fe:	83 c4 3c             	add    $0x3c,%esp
  801601:	5b                   	pop    %ebx
  801602:	5e                   	pop    %esi
  801603:	5f                   	pop    %edi
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    

00801606 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 24             	sub    $0x24,%esp
  80160d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801613:	89 44 24 04          	mov    %eax,0x4(%esp)
  801617:	89 1c 24             	mov    %ebx,(%esp)
  80161a:	e8 3c fd ff ff       	call   80135b <fd_lookup>
  80161f:	89 c2                	mov    %eax,%edx
  801621:	85 d2                	test   %edx,%edx
  801623:	78 6d                	js     801692 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801625:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	8b 00                	mov    (%eax),%eax
  801631:	89 04 24             	mov    %eax,(%esp)
  801634:	e8 78 fd ff ff       	call   8013b1 <dev_lookup>
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 55                	js     801692 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8b 50 08             	mov    0x8(%eax),%edx
  801643:	83 e2 03             	and    $0x3,%edx
  801646:	83 fa 01             	cmp    $0x1,%edx
  801649:	75 23                	jne    80166e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80164b:	a1 04 40 80 00       	mov    0x804004,%eax
  801650:	8b 40 48             	mov    0x48(%eax),%eax
  801653:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	c7 04 24 9d 2a 80 00 	movl   $0x802a9d,(%esp)
  801662:	e8 8c eb ff ff       	call   8001f3 <cprintf>
		return -E_INVAL;
  801667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166c:	eb 24                	jmp    801692 <read+0x8c>
	}
	if (!dev->dev_read)
  80166e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801671:	8b 52 08             	mov    0x8(%edx),%edx
  801674:	85 d2                	test   %edx,%edx
  801676:	74 15                	je     80168d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801678:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80167f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801682:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801686:	89 04 24             	mov    %eax,(%esp)
  801689:	ff d2                	call   *%edx
  80168b:	eb 05                	jmp    801692 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80168d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801692:	83 c4 24             	add    $0x24,%esp
  801695:	5b                   	pop    %ebx
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    

00801698 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	57                   	push   %edi
  80169c:	56                   	push   %esi
  80169d:	53                   	push   %ebx
  80169e:	83 ec 1c             	sub    $0x1c,%esp
  8016a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a7:	85 f6                	test   %esi,%esi
  8016a9:	74 33                	je     8016de <readn+0x46>
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b5:	89 f2                	mov    %esi,%edx
  8016b7:	29 c2                	sub    %eax,%edx
  8016b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016bd:	03 45 0c             	add    0xc(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	89 3c 24             	mov    %edi,(%esp)
  8016c7:	e8 3a ff ff ff       	call   801606 <read>
		if (m < 0)
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 1b                	js     8016eb <readn+0x53>
			return m;
		if (m == 0)
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	74 11                	je     8016e5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d4:	01 c3                	add    %eax,%ebx
  8016d6:	89 d8                	mov    %ebx,%eax
  8016d8:	39 f3                	cmp    %esi,%ebx
  8016da:	72 d9                	jb     8016b5 <readn+0x1d>
  8016dc:	eb 0b                	jmp    8016e9 <readn+0x51>
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	eb 06                	jmp    8016eb <readn+0x53>
  8016e5:	89 d8                	mov    %ebx,%eax
  8016e7:	eb 02                	jmp    8016eb <readn+0x53>
  8016e9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016eb:	83 c4 1c             	add    $0x1c,%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5f                   	pop    %edi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	53                   	push   %ebx
  8016f7:	83 ec 24             	sub    $0x24,%esp
  8016fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	89 1c 24             	mov    %ebx,(%esp)
  801707:	e8 4f fc ff ff       	call   80135b <fd_lookup>
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	85 d2                	test   %edx,%edx
  801710:	78 68                	js     80177a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801712:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801715:	89 44 24 04          	mov    %eax,0x4(%esp)
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	8b 00                	mov    (%eax),%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 8b fc ff ff       	call   8013b1 <dev_lookup>
  801726:	85 c0                	test   %eax,%eax
  801728:	78 50                	js     80177a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801731:	75 23                	jne    801756 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801733:	a1 04 40 80 00       	mov    0x804004,%eax
  801738:	8b 40 48             	mov    0x48(%eax),%eax
  80173b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80173f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801743:	c7 04 24 b9 2a 80 00 	movl   $0x802ab9,(%esp)
  80174a:	e8 a4 ea ff ff       	call   8001f3 <cprintf>
		return -E_INVAL;
  80174f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801754:	eb 24                	jmp    80177a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801759:	8b 52 0c             	mov    0xc(%edx),%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	74 15                	je     801775 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801760:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801763:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801767:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80176e:	89 04 24             	mov    %eax,(%esp)
  801771:	ff d2                	call   *%edx
  801773:	eb 05                	jmp    80177a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801775:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80177a:	83 c4 24             	add    $0x24,%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <seek>:

int
seek(int fdnum, off_t offset)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801786:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801789:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	89 04 24             	mov    %eax,(%esp)
  801793:	e8 c3 fb ff ff       	call   80135b <fd_lookup>
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 0e                	js     8017aa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80179c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 24             	sub    $0x24,%esp
  8017b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 96 fb ff ff       	call   80135b <fd_lookup>
  8017c5:	89 c2                	mov    %eax,%edx
  8017c7:	85 d2                	test   %edx,%edx
  8017c9:	78 61                	js     80182c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d5:	8b 00                	mov    (%eax),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 d2 fb ff ff       	call   8013b1 <dev_lookup>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 49                	js     80182c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ea:	75 23                	jne    80180f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017ec:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017f1:	8b 40 48             	mov    0x48(%eax),%eax
  8017f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fc:	c7 04 24 7c 2a 80 00 	movl   $0x802a7c,(%esp)
  801803:	e8 eb e9 ff ff       	call   8001f3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180d:	eb 1d                	jmp    80182c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80180f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801812:	8b 52 18             	mov    0x18(%edx),%edx
  801815:	85 d2                	test   %edx,%edx
  801817:	74 0e                	je     801827 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801820:	89 04 24             	mov    %eax,(%esp)
  801823:	ff d2                	call   *%edx
  801825:	eb 05                	jmp    80182c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801827:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80182c:	83 c4 24             	add    $0x24,%esp
  80182f:	5b                   	pop    %ebx
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	53                   	push   %ebx
  801836:	83 ec 24             	sub    $0x24,%esp
  801839:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	89 04 24             	mov    %eax,(%esp)
  801849:	e8 0d fb ff ff       	call   80135b <fd_lookup>
  80184e:	89 c2                	mov    %eax,%edx
  801850:	85 d2                	test   %edx,%edx
  801852:	78 52                	js     8018a6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801854:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185e:	8b 00                	mov    (%eax),%eax
  801860:	89 04 24             	mov    %eax,(%esp)
  801863:	e8 49 fb ff ff       	call   8013b1 <dev_lookup>
  801868:	85 c0                	test   %eax,%eax
  80186a:	78 3a                	js     8018a6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801873:	74 2c                	je     8018a1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801875:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801878:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80187f:	00 00 00 
	stat->st_isdir = 0;
  801882:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801889:	00 00 00 
	stat->st_dev = dev;
  80188c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801892:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801896:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801899:	89 14 24             	mov    %edx,(%esp)
  80189c:	ff 50 14             	call   *0x14(%eax)
  80189f:	eb 05                	jmp    8018a6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018a6:	83 c4 24             	add    $0x24,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018bb:	00 
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 04 24             	mov    %eax,(%esp)
  8018c2:	e8 af 01 00 00       	call   801a76 <open>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	85 db                	test   %ebx,%ebx
  8018cb:	78 1b                	js     8018e8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d4:	89 1c 24             	mov    %ebx,(%esp)
  8018d7:	e8 56 ff ff ff       	call   801832 <fstat>
  8018dc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018de:	89 1c 24             	mov    %ebx,(%esp)
  8018e1:	e8 bd fb ff ff       	call   8014a3 <close>
	return r;
  8018e6:	89 f0                	mov    %esi,%eax
}
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    

008018ef <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 10             	sub    $0x10,%esp
  8018f7:	89 c6                	mov    %eax,%esi
  8018f9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018fb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801902:	75 11                	jne    801915 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80190b:	e8 34 09 00 00       	call   802244 <ipc_find_env>
  801910:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801915:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80191c:	00 
  80191d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801924:	00 
  801925:	89 74 24 04          	mov    %esi,0x4(%esp)
  801929:	a1 00 40 80 00       	mov    0x804000,%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 a8 08 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801936:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80193d:	00 
  80193e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801949:	e8 28 08 00 00       	call   802176 <ipc_recv>
}
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	5b                   	pop    %ebx
  801952:	5e                   	pop    %esi
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    

00801955 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	53                   	push   %ebx
  801959:	83 ec 14             	sub    $0x14,%esp
  80195c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8b 40 0c             	mov    0xc(%eax),%eax
  801965:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80196a:	ba 00 00 00 00       	mov    $0x0,%edx
  80196f:	b8 05 00 00 00       	mov    $0x5,%eax
  801974:	e8 76 ff ff ff       	call   8018ef <fsipc>
  801979:	89 c2                	mov    %eax,%edx
  80197b:	85 d2                	test   %edx,%edx
  80197d:	78 2b                	js     8019aa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80197f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801986:	00 
  801987:	89 1c 24             	mov    %ebx,(%esp)
  80198a:	e8 bc ee ff ff       	call   80084b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80198f:	a1 80 50 80 00       	mov    0x805080,%eax
  801994:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80199a:	a1 84 50 80 00       	mov    0x805084,%eax
  80199f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019aa:	83 c4 14             	add    $0x14,%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    

008019b0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019cb:	e8 1f ff ff ff       	call   8018ef <fsipc>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 10             	sub    $0x10,%esp
  8019da:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019e8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f8:	e8 f2 fe ff ff       	call   8018ef <fsipc>
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 6a                	js     801a6d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a03:	39 c6                	cmp    %eax,%esi
  801a05:	73 24                	jae    801a2b <devfile_read+0x59>
  801a07:	c7 44 24 0c d6 2a 80 	movl   $0x802ad6,0xc(%esp)
  801a0e:	00 
  801a0f:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801a16:	00 
  801a17:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801a1e:	00 
  801a1f:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801a26:	e8 3b 06 00 00       	call   802066 <_panic>
	assert(r <= PGSIZE);
  801a2b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a30:	7e 24                	jle    801a56 <devfile_read+0x84>
  801a32:	c7 44 24 0c fd 2a 80 	movl   $0x802afd,0xc(%esp)
  801a39:	00 
  801a3a:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801a41:	00 
  801a42:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801a49:	00 
  801a4a:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801a51:	e8 10 06 00 00       	call   802066 <_panic>
	memmove(buf, &fsipcbuf, r);
  801a56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a5a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a61:	00 
  801a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a65:	89 04 24             	mov    %eax,(%esp)
  801a68:	e8 d9 ef ff ff       	call   800a46 <memmove>
	return r;
}
  801a6d:	89 d8                	mov    %ebx,%eax
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	5b                   	pop    %ebx
  801a73:	5e                   	pop    %esi
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 24             	sub    $0x24,%esp
  801a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a80:	89 1c 24             	mov    %ebx,(%esp)
  801a83:	e8 68 ed ff ff       	call   8007f0 <strlen>
  801a88:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a8d:	7f 60                	jg     801aef <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a92:	89 04 24             	mov    %eax,(%esp)
  801a95:	e8 4d f8 ff ff       	call   8012e7 <fd_alloc>
  801a9a:	89 c2                	mov    %eax,%edx
  801a9c:	85 d2                	test   %edx,%edx
  801a9e:	78 54                	js     801af4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801aa0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801aab:	e8 9b ed ff ff       	call   80084b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac0:	e8 2a fe ff ff       	call   8018ef <fsipc>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	79 17                	jns    801ae2 <open+0x6c>
		fd_close(fd, 0);
  801acb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ad2:	00 
  801ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 44 f9 ff ff       	call   801422 <fd_close>
		return r;
  801ade:	89 d8                	mov    %ebx,%eax
  801ae0:	eb 12                	jmp    801af4 <open+0x7e>
	}
	return fd2num(fd);
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	89 04 24             	mov    %eax,(%esp)
  801ae8:	e8 d3 f7 ff ff       	call   8012c0 <fd2num>
  801aed:	eb 05                	jmp    801af4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801aef:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801af4:	83 c4 24             	add    $0x24,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	66 90                	xchg   %ax,%ax
  801afe:	66 90                	xchg   %ax,%ax

00801b00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 10             	sub    $0x10,%esp
  801b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 ba f7 ff ff       	call   8012d0 <fd2data>
  801b16:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b18:	c7 44 24 04 09 2b 80 	movl   $0x802b09,0x4(%esp)
  801b1f:	00 
  801b20:	89 1c 24             	mov    %ebx,(%esp)
  801b23:	e8 23 ed ff ff       	call   80084b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b28:	8b 46 04             	mov    0x4(%esi),%eax
  801b2b:	2b 06                	sub    (%esi),%eax
  801b2d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b33:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3a:	00 00 00 
	stat->st_dev = &devpipe;
  801b3d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b44:	30 80 00 
	return 0;
}
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	53                   	push   %ebx
  801b57:	83 ec 14             	sub    $0x14,%esp
  801b5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b68:	e8 33 f2 ff ff       	call   800da0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b6d:	89 1c 24             	mov    %ebx,(%esp)
  801b70:	e8 5b f7 ff ff       	call   8012d0 <fd2data>
  801b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b80:	e8 1b f2 ff ff       	call   800da0 <sys_page_unmap>
}
  801b85:	83 c4 14             	add    $0x14,%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    

00801b8b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	57                   	push   %edi
  801b8f:	56                   	push   %esi
  801b90:	53                   	push   %ebx
  801b91:	83 ec 2c             	sub    $0x2c,%esp
  801b94:	89 c6                	mov    %eax,%esi
  801b96:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b99:	a1 04 40 80 00       	mov    0x804004,%eax
  801b9e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ba1:	89 34 24             	mov    %esi,(%esp)
  801ba4:	e8 e3 06 00 00       	call   80228c <pageref>
  801ba9:	89 c7                	mov    %eax,%edi
  801bab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bae:	89 04 24             	mov    %eax,(%esp)
  801bb1:	e8 d6 06 00 00       	call   80228c <pageref>
  801bb6:	39 c7                	cmp    %eax,%edi
  801bb8:	0f 94 c2             	sete   %dl
  801bbb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801bbe:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801bc4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801bc7:	39 fb                	cmp    %edi,%ebx
  801bc9:	74 21                	je     801bec <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801bcb:	84 d2                	test   %dl,%dl
  801bcd:	74 ca                	je     801b99 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bcf:	8b 51 58             	mov    0x58(%ecx),%edx
  801bd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bda:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bde:	c7 04 24 10 2b 80 00 	movl   $0x802b10,(%esp)
  801be5:	e8 09 e6 ff ff       	call   8001f3 <cprintf>
  801bea:	eb ad                	jmp    801b99 <_pipeisclosed+0xe>
	}
}
  801bec:	83 c4 2c             	add    $0x2c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    

00801bf4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	57                   	push   %edi
  801bf8:	56                   	push   %esi
  801bf9:	53                   	push   %ebx
  801bfa:	83 ec 1c             	sub    $0x1c,%esp
  801bfd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c00:	89 34 24             	mov    %esi,(%esp)
  801c03:	e8 c8 f6 ff ff       	call   8012d0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c0c:	74 61                	je     801c6f <devpipe_write+0x7b>
  801c0e:	89 c3                	mov    %eax,%ebx
  801c10:	bf 00 00 00 00       	mov    $0x0,%edi
  801c15:	eb 4a                	jmp    801c61 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c17:	89 da                	mov    %ebx,%edx
  801c19:	89 f0                	mov    %esi,%eax
  801c1b:	e8 6b ff ff ff       	call   801b8b <_pipeisclosed>
  801c20:	85 c0                	test   %eax,%eax
  801c22:	75 54                	jne    801c78 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c24:	e8 b1 f0 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c29:	8b 43 04             	mov    0x4(%ebx),%eax
  801c2c:	8b 0b                	mov    (%ebx),%ecx
  801c2e:	8d 51 20             	lea    0x20(%ecx),%edx
  801c31:	39 d0                	cmp    %edx,%eax
  801c33:	73 e2                	jae    801c17 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c38:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c3c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c3f:	99                   	cltd   
  801c40:	c1 ea 1b             	shr    $0x1b,%edx
  801c43:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801c46:	83 e1 1f             	and    $0x1f,%ecx
  801c49:	29 d1                	sub    %edx,%ecx
  801c4b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801c4f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801c53:	83 c0 01             	add    $0x1,%eax
  801c56:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c59:	83 c7 01             	add    $0x1,%edi
  801c5c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c5f:	74 13                	je     801c74 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c61:	8b 43 04             	mov    0x4(%ebx),%eax
  801c64:	8b 0b                	mov    (%ebx),%ecx
  801c66:	8d 51 20             	lea    0x20(%ecx),%edx
  801c69:	39 d0                	cmp    %edx,%eax
  801c6b:	73 aa                	jae    801c17 <devpipe_write+0x23>
  801c6d:	eb c6                	jmp    801c35 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c6f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c74:	89 f8                	mov    %edi,%eax
  801c76:	eb 05                	jmp    801c7d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    

00801c85 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	57                   	push   %edi
  801c89:	56                   	push   %esi
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 1c             	sub    $0x1c,%esp
  801c8e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c91:	89 3c 24             	mov    %edi,(%esp)
  801c94:	e8 37 f6 ff ff       	call   8012d0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c9d:	74 54                	je     801cf3 <devpipe_read+0x6e>
  801c9f:	89 c3                	mov    %eax,%ebx
  801ca1:	be 00 00 00 00       	mov    $0x0,%esi
  801ca6:	eb 3e                	jmp    801ce6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ca8:	89 f0                	mov    %esi,%eax
  801caa:	eb 55                	jmp    801d01 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801cac:	89 da                	mov    %ebx,%edx
  801cae:	89 f8                	mov    %edi,%eax
  801cb0:	e8 d6 fe ff ff       	call   801b8b <_pipeisclosed>
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	75 43                	jne    801cfc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801cb9:	e8 1c f0 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cbe:	8b 03                	mov    (%ebx),%eax
  801cc0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc3:	74 e7                	je     801cac <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cc5:	99                   	cltd   
  801cc6:	c1 ea 1b             	shr    $0x1b,%edx
  801cc9:	01 d0                	add    %edx,%eax
  801ccb:	83 e0 1f             	and    $0x1f,%eax
  801cce:	29 d0                	sub    %edx,%eax
  801cd0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cd8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cdb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cde:	83 c6 01             	add    $0x1,%esi
  801ce1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce4:	74 12                	je     801cf8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ce6:	8b 03                	mov    (%ebx),%eax
  801ce8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ceb:	75 d8                	jne    801cc5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ced:	85 f6                	test   %esi,%esi
  801cef:	75 b7                	jne    801ca8 <devpipe_read+0x23>
  801cf1:	eb b9                	jmp    801cac <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cf3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801cf8:	89 f0                	mov    %esi,%eax
  801cfa:	eb 05                	jmp    801d01 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d01:	83 c4 1c             	add    $0x1c,%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	56                   	push   %esi
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d14:	89 04 24             	mov    %eax,(%esp)
  801d17:	e8 cb f5 ff ff       	call   8012e7 <fd_alloc>
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	85 d2                	test   %edx,%edx
  801d20:	0f 88 4d 01 00 00    	js     801e73 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d2d:	00 
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3c:	e8 b8 ef ff ff       	call   800cf9 <sys_page_alloc>
  801d41:	89 c2                	mov    %eax,%edx
  801d43:	85 d2                	test   %edx,%edx
  801d45:	0f 88 28 01 00 00    	js     801e73 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 91 f5 ff ff       	call   8012e7 <fd_alloc>
  801d56:	89 c3                	mov    %eax,%ebx
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	0f 88 fe 00 00 00    	js     801e5e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d60:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d67:	00 
  801d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d76:	e8 7e ef ff ff       	call   800cf9 <sys_page_alloc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	0f 88 d9 00 00 00    	js     801e5e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 40 f5 ff ff       	call   8012d0 <fd2data>
  801d90:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d99:	00 
  801d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da5:	e8 4f ef ff ff       	call   800cf9 <sys_page_alloc>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	85 c0                	test   %eax,%eax
  801dae:	0f 88 97 00 00 00    	js     801e4b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db7:	89 04 24             	mov    %eax,(%esp)
  801dba:	e8 11 f5 ff ff       	call   8012d0 <fd2data>
  801dbf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801dc6:	00 
  801dc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dcb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dd2:	00 
  801dd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dde:	e8 6a ef ff ff       	call   800d4d <sys_page_map>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	85 c0                	test   %eax,%eax
  801de7:	78 52                	js     801e3b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801de9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801dfe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e07:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	89 04 24             	mov    %eax,(%esp)
  801e19:	e8 a2 f4 ff ff       	call   8012c0 <fd2num>
  801e1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e21:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 92 f4 ff ff       	call   8012c0 <fd2num>
  801e2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e31:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	eb 38                	jmp    801e73 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801e3b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e46:	e8 55 ef ff ff       	call   800da0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e59:	e8 42 ef ff ff       	call   800da0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6c:	e8 2f ef ff ff       	call   800da0 <sys_page_unmap>
  801e71:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801e73:	83 c4 30             	add    $0x30,%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5e                   	pop    %esi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	89 04 24             	mov    %eax,(%esp)
  801e8d:	e8 c9 f4 ff ff       	call   80135b <fd_lookup>
  801e92:	89 c2                	mov    %eax,%edx
  801e94:	85 d2                	test   %edx,%edx
  801e96:	78 15                	js     801ead <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	89 04 24             	mov    %eax,(%esp)
  801e9e:	e8 2d f4 ff ff       	call   8012d0 <fd2data>
	return _pipeisclosed(fd, p);
  801ea3:	89 c2                	mov    %eax,%edx
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	e8 de fc ff ff       	call   801b8b <_pipeisclosed>
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    
  801eaf:	90                   	nop

00801eb0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ec0:	c7 44 24 04 28 2b 80 	movl   $0x802b28,0x4(%esp)
  801ec7:	00 
  801ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecb:	89 04 24             	mov    %eax,(%esp)
  801ece:	e8 78 e9 ff ff       	call   80084b <strcpy>
	return 0;
}
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ee6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eea:	74 4a                	je     801f36 <devcons_write+0x5c>
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ef6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801efc:	8b 75 10             	mov    0x10(%ebp),%esi
  801eff:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801f01:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f04:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801f09:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f0c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f10:	03 45 0c             	add    0xc(%ebp),%eax
  801f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f17:	89 3c 24             	mov    %edi,(%esp)
  801f1a:	e8 27 eb ff ff       	call   800a46 <memmove>
		sys_cputs(buf, m);
  801f1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f23:	89 3c 24             	mov    %edi,(%esp)
  801f26:	e8 01 ed ff ff       	call   800c2c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f2b:	01 f3                	add    %esi,%ebx
  801f2d:	89 d8                	mov    %ebx,%eax
  801f2f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801f32:	72 c8                	jb     801efc <devcons_write+0x22>
  801f34:	eb 05                	jmp    801f3b <devcons_write+0x61>
  801f36:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f57:	75 07                	jne    801f60 <devcons_read+0x18>
  801f59:	eb 28                	jmp    801f83 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f5b:	e8 7a ed ff ff       	call   800cda <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f60:	e8 e5 ec ff ff       	call   800c4a <sys_cgetc>
  801f65:	85 c0                	test   %eax,%eax
  801f67:	74 f2                	je     801f5b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 16                	js     801f83 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f6d:	83 f8 04             	cmp    $0x4,%eax
  801f70:	74 0c                	je     801f7e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	88 02                	mov    %al,(%edx)
	return 1;
  801f77:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7c:	eb 05                	jmp    801f83 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f98:	00 
  801f99:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f9c:	89 04 24             	mov    %eax,(%esp)
  801f9f:	e8 88 ec ff ff       	call   800c2c <sys_cputs>
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <getchar>:

int
getchar(void)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801fac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fb3:	00 
  801fb4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc2:	e8 3f f6 ff ff       	call   801606 <read>
	if (r < 0)
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 0f                	js     801fda <getchar+0x34>
		return r;
	if (r < 1)
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	7e 06                	jle    801fd5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801fcf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fd3:	eb 05                	jmp    801fda <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801fd5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	89 04 24             	mov    %eax,(%esp)
  801fef:	e8 67 f3 ff ff       	call   80135b <fd_lookup>
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 11                	js     802009 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802001:	39 10                	cmp    %edx,(%eax)
  802003:	0f 94 c0             	sete   %al
  802006:	0f b6 c0             	movzbl %al,%eax
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <opencons>:

int
opencons(void)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802011:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802014:	89 04 24             	mov    %eax,(%esp)
  802017:	e8 cb f2 ff ff       	call   8012e7 <fd_alloc>
		return r;
  80201c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 40                	js     802062 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802022:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802029:	00 
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802031:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802038:	e8 bc ec ff ff       	call   800cf9 <sys_page_alloc>
		return r;
  80203d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 1f                	js     802062 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802043:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802058:	89 04 24             	mov    %eax,(%esp)
  80205b:	e8 60 f2 ff ff       	call   8012c0 <fd2num>
  802060:	89 c2                	mov    %eax,%edx
}
  802062:	89 d0                	mov    %edx,%eax
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80206e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802071:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802077:	e8 3f ec ff ff       	call   800cbb <sys_getenvid>
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802083:	8b 55 08             	mov    0x8(%ebp),%edx
  802086:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80208a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80208e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802092:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  802099:	e8 55 e1 ff ff       	call   8001f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80209e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a5:	89 04 24             	mov    %eax,(%esp)
  8020a8:	e8 e5 e0 ff ff       	call   800192 <vcprintf>
	cprintf("\n");
  8020ad:	c7 04 24 f4 25 80 00 	movl   $0x8025f4,(%esp)
  8020b4:	e8 3a e1 ff ff       	call   8001f3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020b9:	cc                   	int3   
  8020ba:	eb fd                	jmp    8020b9 <_panic+0x53>

008020bc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  8020c2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020c9:	75 50                	jne    80211b <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8020cb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020d2:	00 
  8020d3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8020da:	ee 
  8020db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e2:	e8 12 ec ff ff       	call   800cf9 <sys_page_alloc>
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	79 1c                	jns    802107 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8020eb:	c7 44 24 08 58 2b 80 	movl   $0x802b58,0x8(%esp)
  8020f2:	00 
  8020f3:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8020fa:	00 
  8020fb:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  802102:	e8 5f ff ff ff       	call   802066 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802107:	c7 44 24 04 25 21 80 	movl   $0x802125,0x4(%esp)
  80210e:	00 
  80210f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802116:	e8 7e ed ff ff       	call   800e99 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802125:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802126:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80212b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80212d:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  802130:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  802132:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802137:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80213a:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  80213f:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  802142:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  802144:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802147:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802149:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  80214b:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  802150:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  802153:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802158:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  80215b:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  80215d:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  802162:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  802165:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80216a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  80216d:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  80216f:	83 c4 08             	add    $0x8,%esp
	popal
  802172:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802173:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802174:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802175:	c3                   	ret    

00802176 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	56                   	push   %esi
  80217a:	53                   	push   %ebx
  80217b:	83 ec 10             	sub    $0x10,%esp
  80217e:	8b 75 08             	mov    0x8(%ebp),%esi
  802181:	8b 45 0c             	mov    0xc(%ebp),%eax
  802184:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802187:	85 c0                	test   %eax,%eax
  802189:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80218e:	0f 44 c2             	cmove  %edx,%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 76 ed ff ff       	call   800f0f <sys_ipc_recv>
	if (err_code < 0) {
  802199:	85 c0                	test   %eax,%eax
  80219b:	79 16                	jns    8021b3 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80219d:	85 f6                	test   %esi,%esi
  80219f:	74 06                	je     8021a7 <ipc_recv+0x31>
  8021a1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8021a7:	85 db                	test   %ebx,%ebx
  8021a9:	74 2c                	je     8021d7 <ipc_recv+0x61>
  8021ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021b1:	eb 24                	jmp    8021d7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8021b3:	85 f6                	test   %esi,%esi
  8021b5:	74 0a                	je     8021c1 <ipc_recv+0x4b>
  8021b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8021bc:	8b 40 74             	mov    0x74(%eax),%eax
  8021bf:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8021c1:	85 db                	test   %ebx,%ebx
  8021c3:	74 0a                	je     8021cf <ipc_recv+0x59>
  8021c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ca:	8b 40 78             	mov    0x78(%eax),%eax
  8021cd:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8021cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8021d4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	5b                   	pop    %ebx
  8021db:	5e                   	pop    %esi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 1c             	sub    $0x1c,%esp
  8021e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8021f0:	eb 25                	jmp    802217 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8021f2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f5:	74 20                	je     802217 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8021f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021fb:	c7 44 24 08 8a 2b 80 	movl   $0x802b8a,0x8(%esp)
  802202:	00 
  802203:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80220a:	00 
  80220b:	c7 04 24 96 2b 80 00 	movl   $0x802b96,(%esp)
  802212:	e8 4f fe ff ff       	call   802066 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802217:	85 db                	test   %ebx,%ebx
  802219:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80221e:	0f 45 c3             	cmovne %ebx,%eax
  802221:	8b 55 14             	mov    0x14(%ebp),%edx
  802224:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802228:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802230:	89 3c 24             	mov    %edi,(%esp)
  802233:	e8 b4 ec ff ff       	call   800eec <sys_ipc_try_send>
  802238:	85 c0                	test   %eax,%eax
  80223a:	75 b6                	jne    8021f2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80223c:	83 c4 1c             	add    $0x1c,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    

00802244 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80224a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80224f:	39 c8                	cmp    %ecx,%eax
  802251:	74 17                	je     80226a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802253:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802258:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80225b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802261:	8b 52 50             	mov    0x50(%edx),%edx
  802264:	39 ca                	cmp    %ecx,%edx
  802266:	75 14                	jne    80227c <ipc_find_env+0x38>
  802268:	eb 05                	jmp    80226f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80226f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802272:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802277:	8b 40 40             	mov    0x40(%eax),%eax
  80227a:	eb 0e                	jmp    80228a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80227c:	83 c0 01             	add    $0x1,%eax
  80227f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802284:	75 d2                	jne    802258 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802286:	66 b8 00 00          	mov    $0x0,%ax
}
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    

0080228c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802292:	89 d0                	mov    %edx,%eax
  802294:	c1 e8 16             	shr    $0x16,%eax
  802297:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022a3:	f6 c1 01             	test   $0x1,%cl
  8022a6:	74 1d                	je     8022c5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8022a8:	c1 ea 0c             	shr    $0xc,%edx
  8022ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022b2:	f6 c2 01             	test   $0x1,%dl
  8022b5:	74 0e                	je     8022c5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022b7:	c1 ea 0c             	shr    $0xc,%edx
  8022ba:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022c1:	ef 
  8022c2:	0f b7 c0             	movzwl %ax,%eax
}
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    
  8022c7:	66 90                	xchg   %ax,%ax
  8022c9:	66 90                	xchg   %ax,%ax
  8022cb:	66 90                	xchg   %ax,%ax
  8022cd:	66 90                	xchg   %ax,%ax
  8022cf:	90                   	nop

008022d0 <__udivdi3>:
  8022d0:	55                   	push   %ebp
  8022d1:	57                   	push   %edi
  8022d2:	56                   	push   %esi
  8022d3:	83 ec 0c             	sub    $0xc,%esp
  8022d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8022da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8022de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8022e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022ec:	89 ea                	mov    %ebp,%edx
  8022ee:	89 0c 24             	mov    %ecx,(%esp)
  8022f1:	75 2d                	jne    802320 <__udivdi3+0x50>
  8022f3:	39 e9                	cmp    %ebp,%ecx
  8022f5:	77 61                	ja     802358 <__udivdi3+0x88>
  8022f7:	85 c9                	test   %ecx,%ecx
  8022f9:	89 ce                	mov    %ecx,%esi
  8022fb:	75 0b                	jne    802308 <__udivdi3+0x38>
  8022fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802302:	31 d2                	xor    %edx,%edx
  802304:	f7 f1                	div    %ecx
  802306:	89 c6                	mov    %eax,%esi
  802308:	31 d2                	xor    %edx,%edx
  80230a:	89 e8                	mov    %ebp,%eax
  80230c:	f7 f6                	div    %esi
  80230e:	89 c5                	mov    %eax,%ebp
  802310:	89 f8                	mov    %edi,%eax
  802312:	f7 f6                	div    %esi
  802314:	89 ea                	mov    %ebp,%edx
  802316:	83 c4 0c             	add    $0xc,%esp
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	39 e8                	cmp    %ebp,%eax
  802322:	77 24                	ja     802348 <__udivdi3+0x78>
  802324:	0f bd e8             	bsr    %eax,%ebp
  802327:	83 f5 1f             	xor    $0x1f,%ebp
  80232a:	75 3c                	jne    802368 <__udivdi3+0x98>
  80232c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802330:	39 34 24             	cmp    %esi,(%esp)
  802333:	0f 86 9f 00 00 00    	jbe    8023d8 <__udivdi3+0x108>
  802339:	39 d0                	cmp    %edx,%eax
  80233b:	0f 82 97 00 00 00    	jb     8023d8 <__udivdi3+0x108>
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	31 d2                	xor    %edx,%edx
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	83 c4 0c             	add    $0xc,%esp
  80234f:	5e                   	pop    %esi
  802350:	5f                   	pop    %edi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
  802353:	90                   	nop
  802354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 f8                	mov    %edi,%eax
  80235a:	f7 f1                	div    %ecx
  80235c:	31 d2                	xor    %edx,%edx
  80235e:	83 c4 0c             	add    $0xc,%esp
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 e9                	mov    %ebp,%ecx
  80236a:	8b 3c 24             	mov    (%esp),%edi
  80236d:	d3 e0                	shl    %cl,%eax
  80236f:	89 c6                	mov    %eax,%esi
  802371:	b8 20 00 00 00       	mov    $0x20,%eax
  802376:	29 e8                	sub    %ebp,%eax
  802378:	89 c1                	mov    %eax,%ecx
  80237a:	d3 ef                	shr    %cl,%edi
  80237c:	89 e9                	mov    %ebp,%ecx
  80237e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802382:	8b 3c 24             	mov    (%esp),%edi
  802385:	09 74 24 08          	or     %esi,0x8(%esp)
  802389:	89 d6                	mov    %edx,%esi
  80238b:	d3 e7                	shl    %cl,%edi
  80238d:	89 c1                	mov    %eax,%ecx
  80238f:	89 3c 24             	mov    %edi,(%esp)
  802392:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802396:	d3 ee                	shr    %cl,%esi
  802398:	89 e9                	mov    %ebp,%ecx
  80239a:	d3 e2                	shl    %cl,%edx
  80239c:	89 c1                	mov    %eax,%ecx
  80239e:	d3 ef                	shr    %cl,%edi
  8023a0:	09 d7                	or     %edx,%edi
  8023a2:	89 f2                	mov    %esi,%edx
  8023a4:	89 f8                	mov    %edi,%eax
  8023a6:	f7 74 24 08          	divl   0x8(%esp)
  8023aa:	89 d6                	mov    %edx,%esi
  8023ac:	89 c7                	mov    %eax,%edi
  8023ae:	f7 24 24             	mull   (%esp)
  8023b1:	39 d6                	cmp    %edx,%esi
  8023b3:	89 14 24             	mov    %edx,(%esp)
  8023b6:	72 30                	jb     8023e8 <__udivdi3+0x118>
  8023b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023bc:	89 e9                	mov    %ebp,%ecx
  8023be:	d3 e2                	shl    %cl,%edx
  8023c0:	39 c2                	cmp    %eax,%edx
  8023c2:	73 05                	jae    8023c9 <__udivdi3+0xf9>
  8023c4:	3b 34 24             	cmp    (%esp),%esi
  8023c7:	74 1f                	je     8023e8 <__udivdi3+0x118>
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	e9 7a ff ff ff       	jmp    80234c <__udivdi3+0x7c>
  8023d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023d8:	31 d2                	xor    %edx,%edx
  8023da:	b8 01 00 00 00       	mov    $0x1,%eax
  8023df:	e9 68 ff ff ff       	jmp    80234c <__udivdi3+0x7c>
  8023e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	83 c4 0c             	add    $0xc,%esp
  8023f0:	5e                   	pop    %esi
  8023f1:	5f                   	pop    %edi
  8023f2:	5d                   	pop    %ebp
  8023f3:	c3                   	ret    
  8023f4:	66 90                	xchg   %ax,%ax
  8023f6:	66 90                	xchg   %ax,%ax
  8023f8:	66 90                	xchg   %ax,%ax
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	83 ec 14             	sub    $0x14,%esp
  802406:	8b 44 24 28          	mov    0x28(%esp),%eax
  80240a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80240e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802412:	89 c7                	mov    %eax,%edi
  802414:	89 44 24 04          	mov    %eax,0x4(%esp)
  802418:	8b 44 24 30          	mov    0x30(%esp),%eax
  80241c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802420:	89 34 24             	mov    %esi,(%esp)
  802423:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802427:	85 c0                	test   %eax,%eax
  802429:	89 c2                	mov    %eax,%edx
  80242b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80242f:	75 17                	jne    802448 <__umoddi3+0x48>
  802431:	39 fe                	cmp    %edi,%esi
  802433:	76 4b                	jbe    802480 <__umoddi3+0x80>
  802435:	89 c8                	mov    %ecx,%eax
  802437:	89 fa                	mov    %edi,%edx
  802439:	f7 f6                	div    %esi
  80243b:	89 d0                	mov    %edx,%eax
  80243d:	31 d2                	xor    %edx,%edx
  80243f:	83 c4 14             	add    $0x14,%esp
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	66 90                	xchg   %ax,%ax
  802448:	39 f8                	cmp    %edi,%eax
  80244a:	77 54                	ja     8024a0 <__umoddi3+0xa0>
  80244c:	0f bd e8             	bsr    %eax,%ebp
  80244f:	83 f5 1f             	xor    $0x1f,%ebp
  802452:	75 5c                	jne    8024b0 <__umoddi3+0xb0>
  802454:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802458:	39 3c 24             	cmp    %edi,(%esp)
  80245b:	0f 87 e7 00 00 00    	ja     802548 <__umoddi3+0x148>
  802461:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802465:	29 f1                	sub    %esi,%ecx
  802467:	19 c7                	sbb    %eax,%edi
  802469:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80246d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802471:	8b 44 24 08          	mov    0x8(%esp),%eax
  802475:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802479:	83 c4 14             	add    $0x14,%esp
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    
  802480:	85 f6                	test   %esi,%esi
  802482:	89 f5                	mov    %esi,%ebp
  802484:	75 0b                	jne    802491 <__umoddi3+0x91>
  802486:	b8 01 00 00 00       	mov    $0x1,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f6                	div    %esi
  80248f:	89 c5                	mov    %eax,%ebp
  802491:	8b 44 24 04          	mov    0x4(%esp),%eax
  802495:	31 d2                	xor    %edx,%edx
  802497:	f7 f5                	div    %ebp
  802499:	89 c8                	mov    %ecx,%eax
  80249b:	f7 f5                	div    %ebp
  80249d:	eb 9c                	jmp    80243b <__umoddi3+0x3b>
  80249f:	90                   	nop
  8024a0:	89 c8                	mov    %ecx,%eax
  8024a2:	89 fa                	mov    %edi,%edx
  8024a4:	83 c4 14             	add    $0x14,%esp
  8024a7:	5e                   	pop    %esi
  8024a8:	5f                   	pop    %edi
  8024a9:	5d                   	pop    %ebp
  8024aa:	c3                   	ret    
  8024ab:	90                   	nop
  8024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b0:	8b 04 24             	mov    (%esp),%eax
  8024b3:	be 20 00 00 00       	mov    $0x20,%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	29 ee                	sub    %ebp,%esi
  8024bc:	d3 e2                	shl    %cl,%edx
  8024be:	89 f1                	mov    %esi,%ecx
  8024c0:	d3 e8                	shr    %cl,%eax
  8024c2:	89 e9                	mov    %ebp,%ecx
  8024c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c8:	8b 04 24             	mov    (%esp),%eax
  8024cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8024cf:	89 fa                	mov    %edi,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 f1                	mov    %esi,%ecx
  8024d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8024dd:	d3 ea                	shr    %cl,%edx
  8024df:	89 e9                	mov    %ebp,%ecx
  8024e1:	d3 e7                	shl    %cl,%edi
  8024e3:	89 f1                	mov    %esi,%ecx
  8024e5:	d3 e8                	shr    %cl,%eax
  8024e7:	89 e9                	mov    %ebp,%ecx
  8024e9:	09 f8                	or     %edi,%eax
  8024eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8024ef:	f7 74 24 04          	divl   0x4(%esp)
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024f9:	89 d7                	mov    %edx,%edi
  8024fb:	f7 64 24 08          	mull   0x8(%esp)
  8024ff:	39 d7                	cmp    %edx,%edi
  802501:	89 c1                	mov    %eax,%ecx
  802503:	89 14 24             	mov    %edx,(%esp)
  802506:	72 2c                	jb     802534 <__umoddi3+0x134>
  802508:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80250c:	72 22                	jb     802530 <__umoddi3+0x130>
  80250e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802512:	29 c8                	sub    %ecx,%eax
  802514:	19 d7                	sbb    %edx,%edi
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	89 fa                	mov    %edi,%edx
  80251a:	d3 e8                	shr    %cl,%eax
  80251c:	89 f1                	mov    %esi,%ecx
  80251e:	d3 e2                	shl    %cl,%edx
  802520:	89 e9                	mov    %ebp,%ecx
  802522:	d3 ef                	shr    %cl,%edi
  802524:	09 d0                	or     %edx,%eax
  802526:	89 fa                	mov    %edi,%edx
  802528:	83 c4 14             	add    $0x14,%esp
  80252b:	5e                   	pop    %esi
  80252c:	5f                   	pop    %edi
  80252d:	5d                   	pop    %ebp
  80252e:	c3                   	ret    
  80252f:	90                   	nop
  802530:	39 d7                	cmp    %edx,%edi
  802532:	75 da                	jne    80250e <__umoddi3+0x10e>
  802534:	8b 14 24             	mov    (%esp),%edx
  802537:	89 c1                	mov    %eax,%ecx
  802539:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80253d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802541:	eb cb                	jmp    80250e <__umoddi3+0x10e>
  802543:	90                   	nop
  802544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802548:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80254c:	0f 82 0f ff ff ff    	jb     802461 <__umoddi3+0x61>
  802552:	e9 1a ff ff ff       	jmp    802471 <__umoddi3+0x71>
