
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2e 00 00 00       	call   80005f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  800039:	c7 04 24 20 21 80 00 	movl   $0x802120,(%esp)
  800040:	e8 4e 01 00 00       	call   800193 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800045:	a1 04 40 80 00       	mov    0x804004,%eax
  80004a:	8b 40 48             	mov    0x48(%eax),%eax
  80004d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800051:	c7 04 24 2e 21 80 00 	movl   $0x80212e,(%esp)
  800058:	e8 36 01 00 00       	call   800193 <cprintf>
}
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	83 ec 10             	sub    $0x10,%esp
  800067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  80006d:	e8 e9 0b 00 00       	call   800c5b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800072:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800078:	39 c2                	cmp    %eax,%edx
  80007a:	74 17                	je     800093 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80007c:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800081:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800084:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80008a:	8b 49 40             	mov    0x40(%ecx),%ecx
  80008d:	39 c1                	cmp    %eax,%ecx
  80008f:	75 18                	jne    8000a9 <libmain+0x4a>
  800091:	eb 05                	jmp    800098 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800093:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800098:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80009b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000a1:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000a7:	eb 0b                	jmp    8000b4 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000a9:	83 c2 01             	add    $0x1,%edx
  8000ac:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000b2:	75 cd                	jne    800081 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b4:	85 db                	test   %ebx,%ebx
  8000b6:	7e 07                	jle    8000bf <libmain+0x60>
		binaryname = argv[0];
  8000b8:	8b 06                	mov    (%esi),%eax
  8000ba:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c3:	89 1c 24             	mov    %ebx,(%esp)
  8000c6:	e8 68 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cb:	e8 07 00 00 00       	call   8000d7 <exit>
}
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000dd:	e8 44 10 00 00       	call   801126 <close_all>
	sys_env_destroy(0);
  8000e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e9:	e8 1b 0b 00 00       	call   800c09 <sys_env_destroy>
}
  8000ee:	c9                   	leave  
  8000ef:	c3                   	ret    

008000f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	53                   	push   %ebx
  8000f4:	83 ec 14             	sub    $0x14,%esp
  8000f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fa:	8b 13                	mov    (%ebx),%edx
  8000fc:	8d 42 01             	lea    0x1(%edx),%eax
  8000ff:	89 03                	mov    %eax,(%ebx)
  800101:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800104:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800108:	3d ff 00 00 00       	cmp    $0xff,%eax
  80010d:	75 19                	jne    800128 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80010f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800116:	00 
  800117:	8d 43 08             	lea    0x8(%ebx),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 aa 0a 00 00       	call   800bcc <sys_cputs>
		b->idx = 0;
  800122:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800128:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012c:	83 c4 14             	add    $0x14,%esp
  80012f:	5b                   	pop    %ebx
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80013b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800142:	00 00 00 
	b.cnt = 0;
  800145:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80014f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800152:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800156:	8b 45 08             	mov    0x8(%ebp),%eax
  800159:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800163:	89 44 24 04          	mov    %eax,0x4(%esp)
  800167:	c7 04 24 f0 00 80 00 	movl   $0x8000f0,(%esp)
  80016e:	e8 b1 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800173:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800183:	89 04 24             	mov    %eax,(%esp)
  800186:	e8 41 0a 00 00       	call   800bcc <sys_cputs>

	return b.cnt;
}
  80018b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800199:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a3:	89 04 24             	mov    %eax,(%esp)
  8001a6:	e8 87 ff ff ff       	call   800132 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
  8001ad:	66 90                	xchg   %ax,%ax
  8001af:	90                   	nop

008001b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	57                   	push   %edi
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 3c             	sub    $0x3c,%esp
  8001b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001bc:	89 d7                	mov    %edx,%edi
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8001c7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8001ca:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d8:	39 f1                	cmp    %esi,%ecx
  8001da:	72 14                	jb     8001f0 <printnum+0x40>
  8001dc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001df:	76 0f                	jbe    8001f0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8001e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001ea:	85 f6                	test   %esi,%esi
  8001ec:	7f 60                	jg     80024e <printnum+0x9e>
  8001ee:	eb 72                	jmp    800262 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001f3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8001fa:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8001fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800201:	89 44 24 08          	mov    %eax,0x8(%esp)
  800205:	8b 44 24 08          	mov    0x8(%esp),%eax
  800209:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80020d:	89 c3                	mov    %eax,%ebx
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800214:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800217:	89 54 24 08          	mov    %edx,0x8(%esp)
  80021b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022c:	e8 5f 1c 00 00       	call   801e90 <__udivdi3>
  800231:	89 d9                	mov    %ebx,%ecx
  800233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800237:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800242:	89 fa                	mov    %edi,%edx
  800244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800247:	e8 64 ff ff ff       	call   8001b0 <printnum>
  80024c:	eb 14                	jmp    800262 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800252:	8b 45 18             	mov    0x18(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80025a:	83 ee 01             	sub    $0x1,%esi
  80025d:	75 ef                	jne    80024e <printnum+0x9e>
  80025f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800262:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800266:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80026a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80026d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800270:	89 44 24 08          	mov    %eax,0x8(%esp)
  800274:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800281:	89 44 24 04          	mov    %eax,0x4(%esp)
  800285:	e8 36 1d 00 00       	call   801fc0 <__umoddi3>
  80028a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80028e:	0f be 80 4f 21 80 00 	movsbl 0x80214f(%eax),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029b:	ff d0                	call   *%eax
}
  80029d:	83 c4 3c             	add    $0x3c,%esp
  8002a0:	5b                   	pop    %ebx
  8002a1:	5e                   	pop    %esi
  8002a2:	5f                   	pop    %edi
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002a8:	83 fa 01             	cmp    $0x1,%edx
  8002ab:	7e 0e                	jle    8002bb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002ad:	8b 10                	mov    (%eax),%edx
  8002af:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 02                	mov    (%edx),%eax
  8002b6:	8b 52 04             	mov    0x4(%edx),%edx
  8002b9:	eb 22                	jmp    8002dd <getuint+0x38>
	else if (lflag)
  8002bb:	85 d2                	test   %edx,%edx
  8002bd:	74 10                	je     8002cf <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002bf:	8b 10                	mov    (%eax),%edx
  8002c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c4:	89 08                	mov    %ecx,(%eax)
  8002c6:	8b 02                	mov    (%edx),%eax
  8002c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cd:	eb 0e                	jmp    8002dd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 02                	mov    (%edx),%eax
  8002d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ee:	73 0a                	jae    8002fa <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f3:	89 08                	mov    %ecx,(%eax)
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f8:	88 02                	mov    %al,(%edx)
}
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800302:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800305:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800309:	8b 45 10             	mov    0x10(%ebp),%eax
  80030c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	89 44 24 04          	mov    %eax,0x4(%esp)
  800317:	8b 45 08             	mov    0x8(%ebp),%eax
  80031a:	89 04 24             	mov    %eax,(%esp)
  80031d:	e8 02 00 00 00       	call   800324 <vprintfmt>
	va_end(ap);
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	57                   	push   %edi
  800328:	56                   	push   %esi
  800329:	53                   	push   %ebx
  80032a:	83 ec 3c             	sub    $0x3c,%esp
  80032d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800330:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800333:	eb 18                	jmp    80034d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 84 c3 03 00 00    	je     800700 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80033d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800341:	89 04 24             	mov    %eax,(%esp)
  800344:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800347:	89 f3                	mov    %esi,%ebx
  800349:	eb 02                	jmp    80034d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80034b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80034d:	8d 73 01             	lea    0x1(%ebx),%esi
  800350:	0f b6 03             	movzbl (%ebx),%eax
  800353:	83 f8 25             	cmp    $0x25,%eax
  800356:	75 dd                	jne    800335 <vprintfmt+0x11>
  800358:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80035c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800363:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80036a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800371:	ba 00 00 00 00       	mov    $0x0,%edx
  800376:	eb 1d                	jmp    800395 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800378:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80037a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80037e:	eb 15                	jmp    800395 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800380:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800382:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800386:	eb 0d                	jmp    800395 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8d 5e 01             	lea    0x1(%esi),%ebx
  800398:	0f b6 06             	movzbl (%esi),%eax
  80039b:	0f b6 c8             	movzbl %al,%ecx
  80039e:	83 e8 23             	sub    $0x23,%eax
  8003a1:	3c 55                	cmp    $0x55,%al
  8003a3:	0f 87 2f 03 00 00    	ja     8006d8 <vprintfmt+0x3b4>
  8003a9:	0f b6 c0             	movzbl %al,%eax
  8003ac:	ff 24 85 a0 22 80 00 	jmp    *0x8022a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003b3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8003b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8003b9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003bd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8003c0:	83 f9 09             	cmp    $0x9,%ecx
  8003c3:	77 50                	ja     800415 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	89 de                	mov    %ebx,%esi
  8003c7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ca:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003cd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003d0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003d4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003d7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003da:	83 fb 09             	cmp    $0x9,%ebx
  8003dd:	76 eb                	jbe    8003ca <vprintfmt+0xa6>
  8003df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003e2:	eb 33                	jmp    800417 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e7:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ea:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003f4:	eb 21                	jmp    800417 <vprintfmt+0xf3>
  8003f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f9:	85 c9                	test   %ecx,%ecx
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	0f 49 c1             	cmovns %ecx,%eax
  800403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800406:	89 de                	mov    %ebx,%esi
  800408:	eb 8b                	jmp    800395 <vprintfmt+0x71>
  80040a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80040c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800413:	eb 80                	jmp    800395 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800415:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800417:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80041b:	0f 89 74 ff ff ff    	jns    800395 <vprintfmt+0x71>
  800421:	e9 62 ff ff ff       	jmp    800388 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800426:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800429:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80042b:	e9 65 ff ff ff       	jmp    800395 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8d 50 04             	lea    0x4(%eax),%edx
  800436:	89 55 14             	mov    %edx,0x14(%ebp)
  800439:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	89 04 24             	mov    %eax,(%esp)
  800442:	ff 55 08             	call   *0x8(%ebp)
			break;
  800445:	e9 03 ff ff ff       	jmp    80034d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80044a:	8b 45 14             	mov    0x14(%ebp),%eax
  80044d:	8d 50 04             	lea    0x4(%eax),%edx
  800450:	89 55 14             	mov    %edx,0x14(%ebp)
  800453:	8b 00                	mov    (%eax),%eax
  800455:	99                   	cltd   
  800456:	31 d0                	xor    %edx,%eax
  800458:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045a:	83 f8 0f             	cmp    $0xf,%eax
  80045d:	7f 0b                	jg     80046a <vprintfmt+0x146>
  80045f:	8b 14 85 00 24 80 00 	mov    0x802400(,%eax,4),%edx
  800466:	85 d2                	test   %edx,%edx
  800468:	75 20                	jne    80048a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80046a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046e:	c7 44 24 08 67 21 80 	movl   $0x802167,0x8(%esp)
  800475:	00 
  800476:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 04 24             	mov    %eax,(%esp)
  800480:	e8 77 fe ff ff       	call   8002fc <printfmt>
  800485:	e9 c3 fe ff ff       	jmp    80034d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80048a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048e:	c7 44 24 08 3f 25 80 	movl   $0x80253f,0x8(%esp)
  800495:	00 
  800496:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 04 24             	mov    %eax,(%esp)
  8004a0:	e8 57 fe ff ff       	call   8002fc <printfmt>
  8004a5:	e9 a3 fe ff ff       	jmp    80034d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ad:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	ba 60 21 80 00       	mov    $0x802160,%edx
  8004c2:	0f 45 d0             	cmovne %eax,%edx
  8004c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8004c8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8004cc:	74 04                	je     8004d2 <vprintfmt+0x1ae>
  8004ce:	85 f6                	test   %esi,%esi
  8004d0:	7f 19                	jg     8004eb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d5:	8d 70 01             	lea    0x1(%eax),%esi
  8004d8:	0f b6 10             	movzbl (%eax),%edx
  8004db:	0f be c2             	movsbl %dl,%eax
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	0f 85 95 00 00 00    	jne    80057b <vprintfmt+0x257>
  8004e6:	e9 85 00 00 00       	jmp    800570 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f2:	89 04 24             	mov    %eax,(%esp)
  8004f5:	e8 b8 02 00 00       	call   8007b2 <strnlen>
  8004fa:	29 c6                	sub    %eax,%esi
  8004fc:	89 f0                	mov    %esi,%eax
  8004fe:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800501:	85 f6                	test   %esi,%esi
  800503:	7e cd                	jle    8004d2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800505:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800509:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80050c:	89 c3                	mov    %eax,%ebx
  80050e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800512:	89 34 24             	mov    %esi,(%esp)
  800515:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	83 eb 01             	sub    $0x1,%ebx
  80051b:	75 f1                	jne    80050e <vprintfmt+0x1ea>
  80051d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800520:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800523:	eb ad                	jmp    8004d2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800525:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800529:	74 1e                	je     800549 <vprintfmt+0x225>
  80052b:	0f be d2             	movsbl %dl,%edx
  80052e:	83 ea 20             	sub    $0x20,%edx
  800531:	83 fa 5e             	cmp    $0x5e,%edx
  800534:	76 13                	jbe    800549 <vprintfmt+0x225>
					putch('?', putdat);
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800544:	ff 55 08             	call   *0x8(%ebp)
  800547:	eb 0d                	jmp    800556 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800556:	83 ef 01             	sub    $0x1,%edi
  800559:	83 c6 01             	add    $0x1,%esi
  80055c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800560:	0f be c2             	movsbl %dl,%eax
  800563:	85 c0                	test   %eax,%eax
  800565:	75 20                	jne    800587 <vprintfmt+0x263>
  800567:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80056a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80056d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800570:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800574:	7f 25                	jg     80059b <vprintfmt+0x277>
  800576:	e9 d2 fd ff ff       	jmp    80034d <vprintfmt+0x29>
  80057b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800581:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800584:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800587:	85 db                	test   %ebx,%ebx
  800589:	78 9a                	js     800525 <vprintfmt+0x201>
  80058b:	83 eb 01             	sub    $0x1,%ebx
  80058e:	79 95                	jns    800525 <vprintfmt+0x201>
  800590:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800593:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800596:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800599:	eb d5                	jmp    800570 <vprintfmt+0x24c>
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005af:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b1:	83 eb 01             	sub    $0x1,%ebx
  8005b4:	75 ee                	jne    8005a4 <vprintfmt+0x280>
  8005b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005b9:	e9 8f fd ff ff       	jmp    80034d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005be:	83 fa 01             	cmp    $0x1,%edx
  8005c1:	7e 16                	jle    8005d9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 50 08             	lea    0x8(%eax),%edx
  8005c9:	89 55 14             	mov    %edx,0x14(%ebp)
  8005cc:	8b 50 04             	mov    0x4(%eax),%edx
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	eb 32                	jmp    80060b <vprintfmt+0x2e7>
	else if (lflag)
  8005d9:	85 d2                	test   %edx,%edx
  8005db:	74 18                	je     8005f5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 50 04             	lea    0x4(%eax),%edx
  8005e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e6:	8b 30                	mov    (%eax),%esi
  8005e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005eb:	89 f0                	mov    %esi,%eax
  8005ed:	c1 f8 1f             	sar    $0x1f,%eax
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f3:	eb 16                	jmp    80060b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 50 04             	lea    0x4(%eax),%edx
  8005fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fe:	8b 30                	mov    (%eax),%esi
  800600:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800603:	89 f0                	mov    %esi,%eax
  800605:	c1 f8 1f             	sar    $0x1f,%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800611:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800616:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061a:	0f 89 80 00 00 00    	jns    8006a0 <vprintfmt+0x37c>
				putch('-', putdat);
  800620:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800624:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80062e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800631:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800634:	f7 d8                	neg    %eax
  800636:	83 d2 00             	adc    $0x0,%edx
  800639:	f7 da                	neg    %edx
			}
			base = 10;
  80063b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800640:	eb 5e                	jmp    8006a0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800642:	8d 45 14             	lea    0x14(%ebp),%eax
  800645:	e8 5b fc ff ff       	call   8002a5 <getuint>
			base = 10;
  80064a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80064f:	eb 4f                	jmp    8006a0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800651:	8d 45 14             	lea    0x14(%ebp),%eax
  800654:	e8 4c fc ff ff       	call   8002a5 <getuint>
			base = 8;
  800659:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80065e:	eb 40                	jmp    8006a0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800660:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800664:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80066b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80066e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800672:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800679:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 50 04             	lea    0x4(%eax),%edx
  800682:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800685:	8b 00                	mov    (%eax),%eax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80068c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800691:	eb 0d                	jmp    8006a0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800693:	8d 45 14             	lea    0x14(%ebp),%eax
  800696:	e8 0a fc ff ff       	call   8002a5 <getuint>
			base = 16;
  80069b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8006a4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006ab:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b3:	89 04 24             	mov    %eax,(%esp)
  8006b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ba:	89 fa                	mov    %edi,%edx
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	e8 ec fa ff ff       	call   8001b0 <printnum>
			break;
  8006c4:	e9 84 fc ff ff       	jmp    80034d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cd:	89 0c 24             	mov    %ecx,(%esp)
  8006d0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006d3:	e9 75 fc ff ff       	jmp    80034d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006e3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006ea:	0f 84 5b fc ff ff    	je     80034b <vprintfmt+0x27>
  8006f0:	89 f3                	mov    %esi,%ebx
  8006f2:	83 eb 01             	sub    $0x1,%ebx
  8006f5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006f9:	75 f7                	jne    8006f2 <vprintfmt+0x3ce>
  8006fb:	e9 4d fc ff ff       	jmp    80034d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800700:	83 c4 3c             	add    $0x3c,%esp
  800703:	5b                   	pop    %ebx
  800704:	5e                   	pop    %esi
  800705:	5f                   	pop    %edi
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	83 ec 28             	sub    $0x28,%esp
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800714:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800717:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80071b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800725:	85 c0                	test   %eax,%eax
  800727:	74 30                	je     800759 <vsnprintf+0x51>
  800729:	85 d2                	test   %edx,%edx
  80072b:	7e 2c                	jle    800759 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800734:	8b 45 10             	mov    0x10(%ebp),%eax
  800737:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800742:	c7 04 24 df 02 80 00 	movl   $0x8002df,(%esp)
  800749:	e8 d6 fb ff ff       	call   800324 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80074e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800751:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800757:	eb 05                	jmp    80075e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800766:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800769:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	89 44 24 08          	mov    %eax,0x8(%esp)
  800774:	8b 45 0c             	mov    0xc(%ebp),%eax
  800777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 82 ff ff ff       	call   800708 <vsnprintf>
	va_end(ap);

	return rc;
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    
  800788:	66 90                	xchg   %ax,%ax
  80078a:	66 90                	xchg   %ax,%ax
  80078c:	66 90                	xchg   %ax,%ax
  80078e:	66 90                	xchg   %ax,%ax

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	80 3a 00             	cmpb   $0x0,(%edx)
  800799:	74 10                	je     8007ab <strlen+0x1b>
  80079b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8007a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a7:	75 f7                	jne    8007a0 <strlen+0x10>
  8007a9:	eb 05                	jmp    8007b0 <strlen+0x20>
  8007ab:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	53                   	push   %ebx
  8007b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bc:	85 c9                	test   %ecx,%ecx
  8007be:	74 1c                	je     8007dc <strnlen+0x2a>
  8007c0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007c3:	74 1e                	je     8007e3 <strnlen+0x31>
  8007c5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8007ca:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cc:	39 ca                	cmp    %ecx,%edx
  8007ce:	74 18                	je     8007e8 <strnlen+0x36>
  8007d0:	83 c2 01             	add    $0x1,%edx
  8007d3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8007d8:	75 f0                	jne    8007ca <strnlen+0x18>
  8007da:	eb 0c                	jmp    8007e8 <strnlen+0x36>
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	eb 05                	jmp    8007e8 <strnlen+0x36>
  8007e3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007e8:	5b                   	pop    %ebx
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f5:	89 c2                	mov    %eax,%edx
  8007f7:	83 c2 01             	add    $0x1,%edx
  8007fa:	83 c1 01             	add    $0x1,%ecx
  8007fd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800801:	88 5a ff             	mov    %bl,-0x1(%edx)
  800804:	84 db                	test   %bl,%bl
  800806:	75 ef                	jne    8007f7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800808:	5b                   	pop    %ebx
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	53                   	push   %ebx
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800815:	89 1c 24             	mov    %ebx,(%esp)
  800818:	e8 73 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  80081d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800820:	89 54 24 04          	mov    %edx,0x4(%esp)
  800824:	01 d8                	add    %ebx,%eax
  800826:	89 04 24             	mov    %eax,(%esp)
  800829:	e8 bd ff ff ff       	call   8007eb <strcpy>
	return dst;
}
  80082e:	89 d8                	mov    %ebx,%eax
  800830:	83 c4 08             	add    $0x8,%esp
  800833:	5b                   	pop    %ebx
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	56                   	push   %esi
  80083a:	53                   	push   %ebx
  80083b:	8b 75 08             	mov    0x8(%ebp),%esi
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800841:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800844:	85 db                	test   %ebx,%ebx
  800846:	74 17                	je     80085f <strncpy+0x29>
  800848:	01 f3                	add    %esi,%ebx
  80084a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80084c:	83 c1 01             	add    $0x1,%ecx
  80084f:	0f b6 02             	movzbl (%edx),%eax
  800852:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800855:	80 3a 01             	cmpb   $0x1,(%edx)
  800858:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80085b:	39 d9                	cmp    %ebx,%ecx
  80085d:	75 ed                	jne    80084c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80085f:	89 f0                	mov    %esi,%eax
  800861:	5b                   	pop    %ebx
  800862:	5e                   	pop    %esi
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	57                   	push   %edi
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80086e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800871:	8b 75 10             	mov    0x10(%ebp),%esi
  800874:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800876:	85 f6                	test   %esi,%esi
  800878:	74 34                	je     8008ae <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80087a:	83 fe 01             	cmp    $0x1,%esi
  80087d:	74 26                	je     8008a5 <strlcpy+0x40>
  80087f:	0f b6 0b             	movzbl (%ebx),%ecx
  800882:	84 c9                	test   %cl,%cl
  800884:	74 23                	je     8008a9 <strlcpy+0x44>
  800886:	83 ee 02             	sub    $0x2,%esi
  800889:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80088e:	83 c0 01             	add    $0x1,%eax
  800891:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800894:	39 f2                	cmp    %esi,%edx
  800896:	74 13                	je     8008ab <strlcpy+0x46>
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80089f:	84 c9                	test   %cl,%cl
  8008a1:	75 eb                	jne    80088e <strlcpy+0x29>
  8008a3:	eb 06                	jmp    8008ab <strlcpy+0x46>
  8008a5:	89 f8                	mov    %edi,%eax
  8008a7:	eb 02                	jmp    8008ab <strlcpy+0x46>
  8008a9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ae:	29 f8                	sub    %edi,%eax
}
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5f                   	pop    %edi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008be:	0f b6 01             	movzbl (%ecx),%eax
  8008c1:	84 c0                	test   %al,%al
  8008c3:	74 15                	je     8008da <strcmp+0x25>
  8008c5:	3a 02                	cmp    (%edx),%al
  8008c7:	75 11                	jne    8008da <strcmp+0x25>
		p++, q++;
  8008c9:	83 c1 01             	add    $0x1,%ecx
  8008cc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008cf:	0f b6 01             	movzbl (%ecx),%eax
  8008d2:	84 c0                	test   %al,%al
  8008d4:	74 04                	je     8008da <strcmp+0x25>
  8008d6:	3a 02                	cmp    (%edx),%al
  8008d8:	74 ef                	je     8008c9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008da:	0f b6 c0             	movzbl %al,%eax
  8008dd:	0f b6 12             	movzbl (%edx),%edx
  8008e0:	29 d0                	sub    %edx,%eax
}
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8008f2:	85 f6                	test   %esi,%esi
  8008f4:	74 29                	je     80091f <strncmp+0x3b>
  8008f6:	0f b6 03             	movzbl (%ebx),%eax
  8008f9:	84 c0                	test   %al,%al
  8008fb:	74 30                	je     80092d <strncmp+0x49>
  8008fd:	3a 02                	cmp    (%edx),%al
  8008ff:	75 2c                	jne    80092d <strncmp+0x49>
  800901:	8d 43 01             	lea    0x1(%ebx),%eax
  800904:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800906:	89 c3                	mov    %eax,%ebx
  800908:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80090b:	39 f0                	cmp    %esi,%eax
  80090d:	74 17                	je     800926 <strncmp+0x42>
  80090f:	0f b6 08             	movzbl (%eax),%ecx
  800912:	84 c9                	test   %cl,%cl
  800914:	74 17                	je     80092d <strncmp+0x49>
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	3a 0a                	cmp    (%edx),%cl
  80091b:	74 e9                	je     800906 <strncmp+0x22>
  80091d:	eb 0e                	jmp    80092d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
  800924:	eb 0f                	jmp    800935 <strncmp+0x51>
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	eb 08                	jmp    800935 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80092d:	0f b6 03             	movzbl (%ebx),%eax
  800930:	0f b6 12             	movzbl (%edx),%edx
  800933:	29 d0                	sub    %edx,%eax
}
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800943:	0f b6 18             	movzbl (%eax),%ebx
  800946:	84 db                	test   %bl,%bl
  800948:	74 1d                	je     800967 <strchr+0x2e>
  80094a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80094c:	38 d3                	cmp    %dl,%bl
  80094e:	75 06                	jne    800956 <strchr+0x1d>
  800950:	eb 1a                	jmp    80096c <strchr+0x33>
  800952:	38 ca                	cmp    %cl,%dl
  800954:	74 16                	je     80096c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	0f b6 10             	movzbl (%eax),%edx
  80095c:	84 d2                	test   %dl,%dl
  80095e:	75 f2                	jne    800952 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	eb 05                	jmp    80096c <strchr+0x33>
  800967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096c:	5b                   	pop    %ebx
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	53                   	push   %ebx
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800979:	0f b6 18             	movzbl (%eax),%ebx
  80097c:	84 db                	test   %bl,%bl
  80097e:	74 16                	je     800996 <strfind+0x27>
  800980:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800982:	38 d3                	cmp    %dl,%bl
  800984:	75 06                	jne    80098c <strfind+0x1d>
  800986:	eb 0e                	jmp    800996 <strfind+0x27>
  800988:	38 ca                	cmp    %cl,%dl
  80098a:	74 0a                	je     800996 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	0f b6 10             	movzbl (%eax),%edx
  800992:	84 d2                	test   %dl,%dl
  800994:	75 f2                	jne    800988 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800996:	5b                   	pop    %ebx
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	57                   	push   %edi
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a5:	85 c9                	test   %ecx,%ecx
  8009a7:	74 36                	je     8009df <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009af:	75 28                	jne    8009d9 <memset+0x40>
  8009b1:	f6 c1 03             	test   $0x3,%cl
  8009b4:	75 23                	jne    8009d9 <memset+0x40>
		c &= 0xFF;
  8009b6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ba:	89 d3                	mov    %edx,%ebx
  8009bc:	c1 e3 08             	shl    $0x8,%ebx
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	c1 e6 18             	shl    $0x18,%esi
  8009c4:	89 d0                	mov    %edx,%eax
  8009c6:	c1 e0 10             	shl    $0x10,%eax
  8009c9:	09 f0                	or     %esi,%eax
  8009cb:	09 c2                	or     %eax,%edx
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009d4:	fc                   	cld    
  8009d5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d7:	eb 06                	jmp    8009df <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	fc                   	cld    
  8009dd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009df:	89 f8                	mov    %edi,%eax
  8009e1:	5b                   	pop    %ebx
  8009e2:	5e                   	pop    %esi
  8009e3:	5f                   	pop    %edi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	57                   	push   %edi
  8009ea:	56                   	push   %esi
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f4:	39 c6                	cmp    %eax,%esi
  8009f6:	73 35                	jae    800a2d <memmove+0x47>
  8009f8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fb:	39 d0                	cmp    %edx,%eax
  8009fd:	73 2e                	jae    800a2d <memmove+0x47>
		s += n;
		d += n;
  8009ff:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a02:	89 d6                	mov    %edx,%esi
  800a04:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a06:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0c:	75 13                	jne    800a21 <memmove+0x3b>
  800a0e:	f6 c1 03             	test   $0x3,%cl
  800a11:	75 0e                	jne    800a21 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a13:	83 ef 04             	sub    $0x4,%edi
  800a16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a19:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a1c:	fd                   	std    
  800a1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1f:	eb 09                	jmp    800a2a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a21:	83 ef 01             	sub    $0x1,%edi
  800a24:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a27:	fd                   	std    
  800a28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2a:	fc                   	cld    
  800a2b:	eb 1d                	jmp    800a4a <memmove+0x64>
  800a2d:	89 f2                	mov    %esi,%edx
  800a2f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a31:	f6 c2 03             	test   $0x3,%dl
  800a34:	75 0f                	jne    800a45 <memmove+0x5f>
  800a36:	f6 c1 03             	test   $0x3,%cl
  800a39:	75 0a                	jne    800a45 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a3e:	89 c7                	mov    %eax,%edi
  800a40:	fc                   	cld    
  800a41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a43:	eb 05                	jmp    800a4a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a45:	89 c7                	mov    %eax,%edi
  800a47:	fc                   	cld    
  800a48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a4a:	5e                   	pop    %esi
  800a4b:	5f                   	pop    %edi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a54:	8b 45 10             	mov    0x10(%ebp),%eax
  800a57:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	89 04 24             	mov    %eax,(%esp)
  800a68:	e8 79 ff ff ff       	call   8009e6 <memmove>
}
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a7e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800a81:	85 c0                	test   %eax,%eax
  800a83:	74 36                	je     800abb <memcmp+0x4c>
		if (*s1 != *s2)
  800a85:	0f b6 03             	movzbl (%ebx),%eax
  800a88:	0f b6 0e             	movzbl (%esi),%ecx
  800a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a90:	38 c8                	cmp    %cl,%al
  800a92:	74 1c                	je     800ab0 <memcmp+0x41>
  800a94:	eb 10                	jmp    800aa6 <memcmp+0x37>
  800a96:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800aa2:	38 c8                	cmp    %cl,%al
  800aa4:	74 0a                	je     800ab0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800aa6:	0f b6 c0             	movzbl %al,%eax
  800aa9:	0f b6 c9             	movzbl %cl,%ecx
  800aac:	29 c8                	sub    %ecx,%eax
  800aae:	eb 10                	jmp    800ac0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab0:	39 fa                	cmp    %edi,%edx
  800ab2:	75 e2                	jne    800a96 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab9:	eb 05                	jmp    800ac0 <memcmp+0x51>
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	39 d0                	cmp    %edx,%eax
  800ad6:	73 13                	jae    800aeb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad8:	89 d9                	mov    %ebx,%ecx
  800ada:	38 18                	cmp    %bl,(%eax)
  800adc:	75 06                	jne    800ae4 <memfind+0x1f>
  800ade:	eb 0b                	jmp    800aeb <memfind+0x26>
  800ae0:	38 08                	cmp    %cl,(%eax)
  800ae2:	74 07                	je     800aeb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae4:	83 c0 01             	add    $0x1,%eax
  800ae7:	39 d0                	cmp    %edx,%eax
  800ae9:	75 f5                	jne    800ae0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aeb:	5b                   	pop    %ebx
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afa:	0f b6 0a             	movzbl (%edx),%ecx
  800afd:	80 f9 09             	cmp    $0x9,%cl
  800b00:	74 05                	je     800b07 <strtol+0x19>
  800b02:	80 f9 20             	cmp    $0x20,%cl
  800b05:	75 10                	jne    800b17 <strtol+0x29>
		s++;
  800b07:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0a:	0f b6 0a             	movzbl (%edx),%ecx
  800b0d:	80 f9 09             	cmp    $0x9,%cl
  800b10:	74 f5                	je     800b07 <strtol+0x19>
  800b12:	80 f9 20             	cmp    $0x20,%cl
  800b15:	74 f0                	je     800b07 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b17:	80 f9 2b             	cmp    $0x2b,%cl
  800b1a:	75 0a                	jne    800b26 <strtol+0x38>
		s++;
  800b1c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b1f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b24:	eb 11                	jmp    800b37 <strtol+0x49>
  800b26:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b2b:	80 f9 2d             	cmp    $0x2d,%cl
  800b2e:	75 07                	jne    800b37 <strtol+0x49>
		s++, neg = 1;
  800b30:	83 c2 01             	add    $0x1,%edx
  800b33:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b37:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b3c:	75 15                	jne    800b53 <strtol+0x65>
  800b3e:	80 3a 30             	cmpb   $0x30,(%edx)
  800b41:	75 10                	jne    800b53 <strtol+0x65>
  800b43:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b47:	75 0a                	jne    800b53 <strtol+0x65>
		s += 2, base = 16;
  800b49:	83 c2 02             	add    $0x2,%edx
  800b4c:	b8 10 00 00 00       	mov    $0x10,%eax
  800b51:	eb 10                	jmp    800b63 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800b53:	85 c0                	test   %eax,%eax
  800b55:	75 0c                	jne    800b63 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b57:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b59:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5c:	75 05                	jne    800b63 <strtol+0x75>
		s++, base = 8;
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b68:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b6b:	0f b6 0a             	movzbl (%edx),%ecx
  800b6e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b71:	89 f0                	mov    %esi,%eax
  800b73:	3c 09                	cmp    $0x9,%al
  800b75:	77 08                	ja     800b7f <strtol+0x91>
			dig = *s - '0';
  800b77:	0f be c9             	movsbl %cl,%ecx
  800b7a:	83 e9 30             	sub    $0x30,%ecx
  800b7d:	eb 20                	jmp    800b9f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800b7f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b82:	89 f0                	mov    %esi,%eax
  800b84:	3c 19                	cmp    $0x19,%al
  800b86:	77 08                	ja     800b90 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800b88:	0f be c9             	movsbl %cl,%ecx
  800b8b:	83 e9 57             	sub    $0x57,%ecx
  800b8e:	eb 0f                	jmp    800b9f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800b90:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	3c 19                	cmp    $0x19,%al
  800b97:	77 16                	ja     800baf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b99:	0f be c9             	movsbl %cl,%ecx
  800b9c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b9f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ba2:	7d 0f                	jge    800bb3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ba4:	83 c2 01             	add    $0x1,%edx
  800ba7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bab:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bad:	eb bc                	jmp    800b6b <strtol+0x7d>
  800baf:	89 d8                	mov    %ebx,%eax
  800bb1:	eb 02                	jmp    800bb5 <strtol+0xc7>
  800bb3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	74 05                	je     800bc0 <strtol+0xd2>
		*endptr = (char *) s;
  800bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbe:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bc0:	f7 d8                	neg    %eax
  800bc2:	85 ff                	test   %edi,%edi
  800bc4:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bda:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdd:	89 c3                	mov    %eax,%ebx
  800bdf:	89 c7                	mov    %eax,%edi
  800be1:	89 c6                	mov    %eax,%esi
  800be3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <sys_cgetc>:

int
sys_cgetc(void)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	57                   	push   %edi
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfa:	89 d1                	mov    %edx,%ecx
  800bfc:	89 d3                	mov    %edx,%ebx
  800bfe:	89 d7                	mov    %edx,%edi
  800c00:	89 d6                	mov    %edx,%esi
  800c02:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c17:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	89 cb                	mov    %ecx,%ebx
  800c21:	89 cf                	mov    %ecx,%edi
  800c23:	89 ce                	mov    %ecx,%esi
  800c25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c27:	85 c0                	test   %eax,%eax
  800c29:	7e 28                	jle    800c53 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c2f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c36:	00 
  800c37:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800c3e:	00 
  800c3f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c46:	00 
  800c47:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800c4e:	e8 93 10 00 00       	call   801ce6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c53:	83 c4 2c             	add    $0x2c,%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6b:	89 d1                	mov    %edx,%ecx
  800c6d:	89 d3                	mov    %edx,%ebx
  800c6f:	89 d7                	mov    %edx,%edi
  800c71:	89 d6                	mov    %edx,%esi
  800c73:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_yield>:

void
sys_yield(void)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca2:	be 00 00 00 00       	mov    $0x0,%esi
  800ca7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb5:	89 f7                	mov    %esi,%edi
  800cb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	7e 28                	jle    800ce5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc8:	00 
  800cc9:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800cd0:	00 
  800cd1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800cd8:	00 
  800cd9:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800ce0:	e8 01 10 00 00       	call   801ce6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ce5:	83 c4 2c             	add    $0x2c,%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf6:	b8 05 00 00 00       	mov    $0x5,%eax
  800cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d04:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d07:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7e 28                	jle    800d38 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d14:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d1b:	00 
  800d1c:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800d23:	00 
  800d24:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d2b:	00 
  800d2c:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800d33:	e8 ae 0f 00 00       	call   801ce6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d38:	83 c4 2c             	add    $0x2c,%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	89 df                	mov    %ebx,%edi
  800d5b:	89 de                	mov    %ebx,%esi
  800d5d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7e 28                	jle    800d8b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d67:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d6e:	00 
  800d6f:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800d76:	00 
  800d77:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d7e:	00 
  800d7f:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800d86:	e8 5b 0f 00 00       	call   801ce6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d8b:	83 c4 2c             	add    $0x2c,%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	b8 08 00 00 00       	mov    $0x8,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7e 28                	jle    800dde <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dba:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dc1:	00 
  800dc2:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800dc9:	00 
  800dca:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dd1:	00 
  800dd2:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800dd9:	e8 08 0f 00 00       	call   801ce6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dde:	83 c4 2c             	add    $0x2c,%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800def:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df4:	b8 09 00 00 00       	mov    $0x9,%eax
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	89 df                	mov    %ebx,%edi
  800e01:	89 de                	mov    %ebx,%esi
  800e03:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	7e 28                	jle    800e31 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e14:	00 
  800e15:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800e1c:	00 
  800e1d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e24:	00 
  800e25:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800e2c:	e8 b5 0e 00 00       	call   801ce6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e31:	83 c4 2c             	add    $0x2c,%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	89 df                	mov    %ebx,%edi
  800e54:	89 de                	mov    %ebx,%esi
  800e56:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	7e 28                	jle    800e84 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e60:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e67:	00 
  800e68:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800e6f:	00 
  800e70:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e77:	00 
  800e78:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800e7f:	e8 62 0e 00 00       	call   801ce6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e84:	83 c4 2c             	add    $0x2c,%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e92:	be 00 00 00 00       	mov    $0x0,%esi
  800e97:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	89 cb                	mov    %ecx,%ebx
  800ec7:	89 cf                	mov    %ecx,%edi
  800ec9:	89 ce                	mov    %ecx,%esi
  800ecb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7e 28                	jle    800ef9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800edc:	00 
  800edd:	c7 44 24 08 5f 24 80 	movl   $0x80245f,0x8(%esp)
  800ee4:	00 
  800ee5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eec:	00 
  800eed:	c7 04 24 7c 24 80 00 	movl   $0x80247c,(%esp)
  800ef4:	e8 ed 0d 00 00       	call   801ce6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef9:	83 c4 2c             	add    $0x2c,%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
  800f01:	66 90                	xchg   %ax,%ax
  800f03:	66 90                	xchg   %ax,%ax
  800f05:	66 90                	xchg   %ax,%ax
  800f07:	66 90                	xchg   %ax,%ax
  800f09:	66 90                	xchg   %ax,%ax
  800f0b:	66 90                	xchg   %ax,%ax
  800f0d:	66 90                	xchg   %ax,%ax
  800f0f:	90                   	nop

00800f10 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	05 00 00 00 30       	add    $0x30000000,%eax
  800f1b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f30:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f3a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800f3f:	a8 01                	test   $0x1,%al
  800f41:	74 34                	je     800f77 <fd_alloc+0x40>
  800f43:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800f48:	a8 01                	test   $0x1,%al
  800f4a:	74 32                	je     800f7e <fd_alloc+0x47>
  800f4c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f51:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 16             	shr    $0x16,%edx
  800f58:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5f:	f6 c2 01             	test   $0x1,%dl
  800f62:	74 1f                	je     800f83 <fd_alloc+0x4c>
  800f64:	89 c2                	mov    %eax,%edx
  800f66:	c1 ea 0c             	shr    $0xc,%edx
  800f69:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f70:	f6 c2 01             	test   $0x1,%dl
  800f73:	75 1a                	jne    800f8f <fd_alloc+0x58>
  800f75:	eb 0c                	jmp    800f83 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f77:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800f7c:	eb 05                	jmp    800f83 <fd_alloc+0x4c>
  800f7e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 08                	mov    %ecx,(%eax)
			return 0;
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	eb 1a                	jmp    800fa9 <fd_alloc+0x72>
  800f8f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f94:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f99:	75 b6                	jne    800f51 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fa4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb1:	83 f8 1f             	cmp    $0x1f,%eax
  800fb4:	77 36                	ja     800fec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb6:	c1 e0 0c             	shl    $0xc,%eax
  800fb9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	c1 ea 16             	shr    $0x16,%edx
  800fc3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fca:	f6 c2 01             	test   $0x1,%dl
  800fcd:	74 24                	je     800ff3 <fd_lookup+0x48>
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	c1 ea 0c             	shr    $0xc,%edx
  800fd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdb:	f6 c2 01             	test   $0x1,%dl
  800fde:	74 1a                	je     800ffa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fea:	eb 13                	jmp    800fff <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb 0c                	jmp    800fff <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb 05                	jmp    800fff <fd_lookup+0x54>
  800ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	53                   	push   %ebx
  801005:	83 ec 14             	sub    $0x14,%esp
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80100e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801014:	75 1e                	jne    801034 <dev_lookup+0x33>
  801016:	eb 0e                	jmp    801026 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801018:	b8 20 30 80 00       	mov    $0x803020,%eax
  80101d:	eb 0c                	jmp    80102b <dev_lookup+0x2a>
  80101f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801024:	eb 05                	jmp    80102b <dev_lookup+0x2a>
  801026:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80102b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80102d:	b8 00 00 00 00       	mov    $0x0,%eax
  801032:	eb 38                	jmp    80106c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801034:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80103a:	74 dc                	je     801018 <dev_lookup+0x17>
  80103c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801042:	74 db                	je     80101f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801044:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80104a:	8b 52 48             	mov    0x48(%edx),%edx
  80104d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801051:	89 54 24 04          	mov    %edx,0x4(%esp)
  801055:	c7 04 24 8c 24 80 00 	movl   $0x80248c,(%esp)
  80105c:	e8 32 f1 ff ff       	call   800193 <cprintf>
	*dev = 0;
  801061:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80106c:	83 c4 14             	add    $0x14,%esp
  80106f:	5b                   	pop    %ebx
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	83 ec 20             	sub    $0x20,%esp
  80107a:	8b 75 08             	mov    0x8(%ebp),%esi
  80107d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801080:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801083:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801087:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80108d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801090:	89 04 24             	mov    %eax,(%esp)
  801093:	e8 13 ff ff ff       	call   800fab <fd_lookup>
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 05                	js     8010a1 <fd_close+0x2f>
	    || fd != fd2)
  80109c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80109f:	74 0c                	je     8010ad <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010a1:	84 db                	test   %bl,%bl
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	0f 44 c2             	cmove  %edx,%eax
  8010ab:	eb 3f                	jmp    8010ec <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b4:	8b 06                	mov    (%esi),%eax
  8010b6:	89 04 24             	mov    %eax,(%esp)
  8010b9:	e8 43 ff ff ff       	call   801001 <dev_lookup>
  8010be:	89 c3                	mov    %eax,%ebx
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 16                	js     8010da <fd_close+0x68>
		if (dev->dev_close)
  8010c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	74 07                	je     8010da <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010d3:	89 34 24             	mov    %esi,(%esp)
  8010d6:	ff d0                	call   *%eax
  8010d8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010e5:	e8 56 fc ff ff       	call   800d40 <sys_page_unmap>
	return r;
  8010ea:	89 d8                	mov    %ebx,%eax
}
  8010ec:	83 c4 20             	add    $0x20,%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 04 24             	mov    %eax,(%esp)
  801106:	e8 a0 fe ff ff       	call   800fab <fd_lookup>
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	85 d2                	test   %edx,%edx
  80110f:	78 13                	js     801124 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801111:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801118:	00 
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	89 04 24             	mov    %eax,(%esp)
  80111f:	e8 4e ff ff ff       	call   801072 <fd_close>
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <close_all>:

void
close_all(void)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	53                   	push   %ebx
  80112a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80112d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801132:	89 1c 24             	mov    %ebx,(%esp)
  801135:	e8 b9 ff ff ff       	call   8010f3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80113a:	83 c3 01             	add    $0x1,%ebx
  80113d:	83 fb 20             	cmp    $0x20,%ebx
  801140:	75 f0                	jne    801132 <close_all+0xc>
		close(i);
}
  801142:	83 c4 14             	add    $0x14,%esp
  801145:	5b                   	pop    %ebx
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801151:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801154:	89 44 24 04          	mov    %eax,0x4(%esp)
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 04 24             	mov    %eax,(%esp)
  80115e:	e8 48 fe ff ff       	call   800fab <fd_lookup>
  801163:	89 c2                	mov    %eax,%edx
  801165:	85 d2                	test   %edx,%edx
  801167:	0f 88 e1 00 00 00    	js     80124e <dup+0x106>
		return r;
	close(newfdnum);
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	89 04 24             	mov    %eax,(%esp)
  801173:	e8 7b ff ff ff       	call   8010f3 <close>

	newfd = INDEX2FD(newfdnum);
  801178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80117b:	c1 e3 0c             	shl    $0xc,%ebx
  80117e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801187:	89 04 24             	mov    %eax,(%esp)
  80118a:	e8 91 fd ff ff       	call   800f20 <fd2data>
  80118f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801191:	89 1c 24             	mov    %ebx,(%esp)
  801194:	e8 87 fd ff ff       	call   800f20 <fd2data>
  801199:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80119b:	89 f0                	mov    %esi,%eax
  80119d:	c1 e8 16             	shr    $0x16,%eax
  8011a0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011a7:	a8 01                	test   $0x1,%al
  8011a9:	74 43                	je     8011ee <dup+0xa6>
  8011ab:	89 f0                	mov    %esi,%eax
  8011ad:	c1 e8 0c             	shr    $0xc,%eax
  8011b0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011b7:	f6 c2 01             	test   $0x1,%dl
  8011ba:	74 32                	je     8011ee <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011d7:	00 
  8011d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e3:	e8 05 fb ff ff       	call   800ced <sys_page_map>
  8011e8:	89 c6                	mov    %eax,%esi
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 3e                	js     80122c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 ea 0c             	shr    $0xc,%edx
  8011f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801203:	89 54 24 10          	mov    %edx,0x10(%esp)
  801207:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80120b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801212:	00 
  801213:	89 44 24 04          	mov    %eax,0x4(%esp)
  801217:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121e:	e8 ca fa ff ff       	call   800ced <sys_page_map>
  801223:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801228:	85 f6                	test   %esi,%esi
  80122a:	79 22                	jns    80124e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80122c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801237:	e8 04 fb ff ff       	call   800d40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80123c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801247:	e8 f4 fa ff ff       	call   800d40 <sys_page_unmap>
	return r;
  80124c:	89 f0                	mov    %esi,%eax
}
  80124e:	83 c4 3c             	add    $0x3c,%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	53                   	push   %ebx
  80125a:	83 ec 24             	sub    $0x24,%esp
  80125d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801260:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801263:	89 44 24 04          	mov    %eax,0x4(%esp)
  801267:	89 1c 24             	mov    %ebx,(%esp)
  80126a:	e8 3c fd ff ff       	call   800fab <fd_lookup>
  80126f:	89 c2                	mov    %eax,%edx
  801271:	85 d2                	test   %edx,%edx
  801273:	78 6d                	js     8012e2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	89 04 24             	mov    %eax,(%esp)
  801284:	e8 78 fd ff ff       	call   801001 <dev_lookup>
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 55                	js     8012e2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	8b 50 08             	mov    0x8(%eax),%edx
  801293:	83 e2 03             	and    $0x3,%edx
  801296:	83 fa 01             	cmp    $0x1,%edx
  801299:	75 23                	jne    8012be <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80129b:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a0:	8b 40 48             	mov    0x48(%eax),%eax
  8012a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ab:	c7 04 24 cd 24 80 00 	movl   $0x8024cd,(%esp)
  8012b2:	e8 dc ee ff ff       	call   800193 <cprintf>
		return -E_INVAL;
  8012b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bc:	eb 24                	jmp    8012e2 <read+0x8c>
	}
	if (!dev->dev_read)
  8012be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c1:	8b 52 08             	mov    0x8(%edx),%edx
  8012c4:	85 d2                	test   %edx,%edx
  8012c6:	74 15                	je     8012dd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012d6:	89 04 24             	mov    %eax,(%esp)
  8012d9:	ff d2                	call   *%edx
  8012db:	eb 05                	jmp    8012e2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012e2:	83 c4 24             	add    $0x24,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 1c             	sub    $0x1c,%esp
  8012f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012f7:	85 f6                	test   %esi,%esi
  8012f9:	74 33                	je     80132e <readn+0x46>
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801305:	89 f2                	mov    %esi,%edx
  801307:	29 c2                	sub    %eax,%edx
  801309:	89 54 24 08          	mov    %edx,0x8(%esp)
  80130d:	03 45 0c             	add    0xc(%ebp),%eax
  801310:	89 44 24 04          	mov    %eax,0x4(%esp)
  801314:	89 3c 24             	mov    %edi,(%esp)
  801317:	e8 3a ff ff ff       	call   801256 <read>
		if (m < 0)
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 1b                	js     80133b <readn+0x53>
			return m;
		if (m == 0)
  801320:	85 c0                	test   %eax,%eax
  801322:	74 11                	je     801335 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801324:	01 c3                	add    %eax,%ebx
  801326:	89 d8                	mov    %ebx,%eax
  801328:	39 f3                	cmp    %esi,%ebx
  80132a:	72 d9                	jb     801305 <readn+0x1d>
  80132c:	eb 0b                	jmp    801339 <readn+0x51>
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
  801333:	eb 06                	jmp    80133b <readn+0x53>
  801335:	89 d8                	mov    %ebx,%eax
  801337:	eb 02                	jmp    80133b <readn+0x53>
  801339:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80133b:	83 c4 1c             	add    $0x1c,%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5f                   	pop    %edi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	53                   	push   %ebx
  801347:	83 ec 24             	sub    $0x24,%esp
  80134a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801350:	89 44 24 04          	mov    %eax,0x4(%esp)
  801354:	89 1c 24             	mov    %ebx,(%esp)
  801357:	e8 4f fc ff ff       	call   800fab <fd_lookup>
  80135c:	89 c2                	mov    %eax,%edx
  80135e:	85 d2                	test   %edx,%edx
  801360:	78 68                	js     8013ca <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801362:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801365:	89 44 24 04          	mov    %eax,0x4(%esp)
  801369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	89 04 24             	mov    %eax,(%esp)
  801371:	e8 8b fc ff ff       	call   801001 <dev_lookup>
  801376:	85 c0                	test   %eax,%eax
  801378:	78 50                	js     8013ca <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801381:	75 23                	jne    8013a6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801383:	a1 04 40 80 00       	mov    0x804004,%eax
  801388:	8b 40 48             	mov    0x48(%eax),%eax
  80138b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80138f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801393:	c7 04 24 e9 24 80 00 	movl   $0x8024e9,(%esp)
  80139a:	e8 f4 ed ff ff       	call   800193 <cprintf>
		return -E_INVAL;
  80139f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a4:	eb 24                	jmp    8013ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	74 15                	je     8013c5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013be:	89 04 24             	mov    %eax,(%esp)
  8013c1:	ff d2                	call   *%edx
  8013c3:	eb 05                	jmp    8013ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013ca:	83 c4 24             	add    $0x24,%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	89 04 24             	mov    %eax,(%esp)
  8013e3:	e8 c3 fb ff ff       	call   800fab <fd_lookup>
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	78 0e                	js     8013fa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	53                   	push   %ebx
  801400:	83 ec 24             	sub    $0x24,%esp
  801403:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801406:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801409:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140d:	89 1c 24             	mov    %ebx,(%esp)
  801410:	e8 96 fb ff ff       	call   800fab <fd_lookup>
  801415:	89 c2                	mov    %eax,%edx
  801417:	85 d2                	test   %edx,%edx
  801419:	78 61                	js     80147c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	8b 00                	mov    (%eax),%eax
  801427:	89 04 24             	mov    %eax,(%esp)
  80142a:	e8 d2 fb ff ff       	call   801001 <dev_lookup>
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 49                	js     80147c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80143a:	75 23                	jne    80145f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80143c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801441:	8b 40 48             	mov    0x48(%eax),%eax
  801444:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801448:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144c:	c7 04 24 ac 24 80 00 	movl   $0x8024ac,(%esp)
  801453:	e8 3b ed ff ff       	call   800193 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb 1d                	jmp    80147c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80145f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801462:	8b 52 18             	mov    0x18(%edx),%edx
  801465:	85 d2                	test   %edx,%edx
  801467:	74 0e                	je     801477 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801469:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801470:	89 04 24             	mov    %eax,(%esp)
  801473:	ff d2                	call   *%edx
  801475:	eb 05                	jmp    80147c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801477:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80147c:	83 c4 24             	add    $0x24,%esp
  80147f:	5b                   	pop    %ebx
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	53                   	push   %ebx
  801486:	83 ec 24             	sub    $0x24,%esp
  801489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	89 04 24             	mov    %eax,(%esp)
  801499:	e8 0d fb ff ff       	call   800fab <fd_lookup>
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	78 52                	js     8014f6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ae:	8b 00                	mov    (%eax),%eax
  8014b0:	89 04 24             	mov    %eax,(%esp)
  8014b3:	e8 49 fb ff ff       	call   801001 <dev_lookup>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 3a                	js     8014f6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014c3:	74 2c                	je     8014f1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014cf:	00 00 00 
	stat->st_isdir = 0;
  8014d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d9:	00 00 00 
	stat->st_dev = dev;
  8014dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e9:	89 14 24             	mov    %edx,(%esp)
  8014ec:	ff 50 14             	call   *0x14(%eax)
  8014ef:	eb 05                	jmp    8014f6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014f6:	83 c4 24             	add    $0x24,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	56                   	push   %esi
  801500:	53                   	push   %ebx
  801501:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801504:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80150b:	00 
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	89 04 24             	mov    %eax,(%esp)
  801512:	e8 e1 01 00 00       	call   8016f8 <open>
  801517:	89 c3                	mov    %eax,%ebx
  801519:	85 db                	test   %ebx,%ebx
  80151b:	78 1b                	js     801538 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	89 44 24 04          	mov    %eax,0x4(%esp)
  801524:	89 1c 24             	mov    %ebx,(%esp)
  801527:	e8 56 ff ff ff       	call   801482 <fstat>
  80152c:	89 c6                	mov    %eax,%esi
	close(fd);
  80152e:	89 1c 24             	mov    %ebx,(%esp)
  801531:	e8 bd fb ff ff       	call   8010f3 <close>
	return r;
  801536:	89 f0                	mov    %esi,%eax
}
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
  801544:	83 ec 10             	sub    $0x10,%esp
  801547:	89 c3                	mov    %eax,%ebx
  801549:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80154b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801552:	75 11                	jne    801565 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801554:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80155b:	e8 aa 08 00 00       	call   801e0a <ipc_find_env>
  801560:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801565:	a1 04 40 80 00       	mov    0x804004,%eax
  80156a:	8b 40 48             	mov    0x48(%eax),%eax
  80156d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801573:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801577:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80157b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157f:	c7 04 24 06 25 80 00 	movl   $0x802506,(%esp)
  801586:	e8 08 ec ff ff       	call   800193 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80158b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801592:	00 
  801593:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80159a:	00 
  80159b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80159f:	a1 00 40 80 00       	mov    0x804000,%eax
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 f8 07 00 00       	call   801da4 <ipc_send>
	cprintf("ipc_send\n");
  8015ac:	c7 04 24 1c 25 80 00 	movl   $0x80251c,(%esp)
  8015b3:	e8 db eb ff ff       	call   800193 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  8015b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015bf:	00 
  8015c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cb:	e8 6c 07 00 00       	call   801d3c <ipc_recv>
}
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5d                   	pop    %ebp
  8015d6:	c3                   	ret    

008015d7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	53                   	push   %ebx
  8015db:	83 ec 14             	sub    $0x14,%esp
  8015de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f1:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f6:	e8 44 ff ff ff       	call   80153f <fsipc>
  8015fb:	89 c2                	mov    %eax,%edx
  8015fd:	85 d2                	test   %edx,%edx
  8015ff:	78 2b                	js     80162c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801601:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801608:	00 
  801609:	89 1c 24             	mov    %ebx,(%esp)
  80160c:	e8 da f1 ff ff       	call   8007eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801611:	a1 80 50 80 00       	mov    0x805080,%eax
  801616:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80161c:	a1 84 50 80 00       	mov    0x805084,%eax
  801621:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162c:	83 c4 14             	add    $0x14,%esp
  80162f:	5b                   	pop    %ebx
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8b 40 0c             	mov    0xc(%eax),%eax
  80163e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	b8 06 00 00 00       	mov    $0x6,%eax
  80164d:	e8 ed fe ff ff       	call   80153f <fsipc>
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 10             	sub    $0x10,%esp
  80165c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8b 40 0c             	mov    0xc(%eax),%eax
  801665:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80166a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	b8 03 00 00 00       	mov    $0x3,%eax
  80167a:	e8 c0 fe ff ff       	call   80153f <fsipc>
  80167f:	89 c3                	mov    %eax,%ebx
  801681:	85 c0                	test   %eax,%eax
  801683:	78 6a                	js     8016ef <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801685:	39 c6                	cmp    %eax,%esi
  801687:	73 24                	jae    8016ad <devfile_read+0x59>
  801689:	c7 44 24 0c 26 25 80 	movl   $0x802526,0xc(%esp)
  801690:	00 
  801691:	c7 44 24 08 2d 25 80 	movl   $0x80252d,0x8(%esp)
  801698:	00 
  801699:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016a0:	00 
  8016a1:	c7 04 24 42 25 80 00 	movl   $0x802542,(%esp)
  8016a8:	e8 39 06 00 00       	call   801ce6 <_panic>
	assert(r <= PGSIZE);
  8016ad:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016b2:	7e 24                	jle    8016d8 <devfile_read+0x84>
  8016b4:	c7 44 24 0c 4d 25 80 	movl   $0x80254d,0xc(%esp)
  8016bb:	00 
  8016bc:	c7 44 24 08 2d 25 80 	movl   $0x80252d,0x8(%esp)
  8016c3:	00 
  8016c4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8016cb:	00 
  8016cc:	c7 04 24 42 25 80 00 	movl   $0x802542,(%esp)
  8016d3:	e8 0e 06 00 00       	call   801ce6 <_panic>
	memmove(buf, &fsipcbuf, r);
  8016d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016dc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016e3:	00 
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	89 04 24             	mov    %eax,(%esp)
  8016ea:	e8 f7 f2 ff ff       	call   8009e6 <memmove>
	return r;
}
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	53                   	push   %ebx
  8016fc:	83 ec 24             	sub    $0x24,%esp
  8016ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801702:	89 1c 24             	mov    %ebx,(%esp)
  801705:	e8 86 f0 ff ff       	call   800790 <strlen>
  80170a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80170f:	7f 60                	jg     801771 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801711:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801714:	89 04 24             	mov    %eax,(%esp)
  801717:	e8 1b f8 ff ff       	call   800f37 <fd_alloc>
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	85 d2                	test   %edx,%edx
  801720:	78 54                	js     801776 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801722:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801726:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80172d:	e8 b9 f0 ff ff       	call   8007eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80173a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173d:	b8 01 00 00 00       	mov    $0x1,%eax
  801742:	e8 f8 fd ff ff       	call   80153f <fsipc>
  801747:	89 c3                	mov    %eax,%ebx
  801749:	85 c0                	test   %eax,%eax
  80174b:	79 17                	jns    801764 <open+0x6c>
		fd_close(fd, 0);
  80174d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801754:	00 
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	89 04 24             	mov    %eax,(%esp)
  80175b:	e8 12 f9 ff ff       	call   801072 <fd_close>
		return r;
  801760:	89 d8                	mov    %ebx,%eax
  801762:	eb 12                	jmp    801776 <open+0x7e>
	}
	return fd2num(fd);
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	89 04 24             	mov    %eax,(%esp)
  80176a:	e8 a1 f7 ff ff       	call   800f10 <fd2num>
  80176f:	eb 05                	jmp    801776 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801771:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801776:	83 c4 24             	add    $0x24,%esp
  801779:	5b                   	pop    %ebx
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    
  80177c:	66 90                	xchg   %ax,%ax
  80177e:	66 90                	xchg   %ax,%ax

00801780 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	83 ec 10             	sub    $0x10,%esp
  801788:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	89 04 24             	mov    %eax,(%esp)
  801791:	e8 8a f7 ff ff       	call   800f20 <fd2data>
  801796:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801798:	c7 44 24 04 59 25 80 	movl   $0x802559,0x4(%esp)
  80179f:	00 
  8017a0:	89 1c 24             	mov    %ebx,(%esp)
  8017a3:	e8 43 f0 ff ff       	call   8007eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017a8:	8b 46 04             	mov    0x4(%esi),%eax
  8017ab:	2b 06                	sub    (%esi),%eax
  8017ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ba:	00 00 00 
	stat->st_dev = &devpipe;
  8017bd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017c4:	30 80 00 
	return 0;
}
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 14             	sub    $0x14,%esp
  8017da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e8:	e8 53 f5 ff ff       	call   800d40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017ed:	89 1c 24             	mov    %ebx,(%esp)
  8017f0:	e8 2b f7 ff ff       	call   800f20 <fd2data>
  8017f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801800:	e8 3b f5 ff ff       	call   800d40 <sys_page_unmap>
}
  801805:	83 c4 14             	add    $0x14,%esp
  801808:	5b                   	pop    %ebx
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	57                   	push   %edi
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	83 ec 2c             	sub    $0x2c,%esp
  801814:	89 c6                	mov    %eax,%esi
  801816:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801819:	a1 04 40 80 00       	mov    0x804004,%eax
  80181e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801821:	89 34 24             	mov    %esi,(%esp)
  801824:	e8 29 06 00 00       	call   801e52 <pageref>
  801829:	89 c7                	mov    %eax,%edi
  80182b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	e8 1c 06 00 00       	call   801e52 <pageref>
  801836:	39 c7                	cmp    %eax,%edi
  801838:	0f 94 c2             	sete   %dl
  80183b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80183e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801844:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801847:	39 fb                	cmp    %edi,%ebx
  801849:	74 21                	je     80186c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80184b:	84 d2                	test   %dl,%dl
  80184d:	74 ca                	je     801819 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80184f:	8b 51 58             	mov    0x58(%ecx),%edx
  801852:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801856:	89 54 24 08          	mov    %edx,0x8(%esp)
  80185a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80185e:	c7 04 24 60 25 80 00 	movl   $0x802560,(%esp)
  801865:	e8 29 e9 ff ff       	call   800193 <cprintf>
  80186a:	eb ad                	jmp    801819 <_pipeisclosed+0xe>
	}
}
  80186c:	83 c4 2c             	add    $0x2c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    

00801874 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	57                   	push   %edi
  801878:	56                   	push   %esi
  801879:	53                   	push   %ebx
  80187a:	83 ec 1c             	sub    $0x1c,%esp
  80187d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801880:	89 34 24             	mov    %esi,(%esp)
  801883:	e8 98 f6 ff ff       	call   800f20 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801888:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188c:	74 61                	je     8018ef <devpipe_write+0x7b>
  80188e:	89 c3                	mov    %eax,%ebx
  801890:	bf 00 00 00 00       	mov    $0x0,%edi
  801895:	eb 4a                	jmp    8018e1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801897:	89 da                	mov    %ebx,%edx
  801899:	89 f0                	mov    %esi,%eax
  80189b:	e8 6b ff ff ff       	call   80180b <_pipeisclosed>
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	75 54                	jne    8018f8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018a4:	e8 d1 f3 ff ff       	call   800c7a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8018ac:	8b 0b                	mov    (%ebx),%ecx
  8018ae:	8d 51 20             	lea    0x20(%ecx),%edx
  8018b1:	39 d0                	cmp    %edx,%eax
  8018b3:	73 e2                	jae    801897 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018bc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018bf:	99                   	cltd   
  8018c0:	c1 ea 1b             	shr    $0x1b,%edx
  8018c3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8018c6:	83 e1 1f             	and    $0x1f,%ecx
  8018c9:	29 d1                	sub    %edx,%ecx
  8018cb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8018cf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8018d3:	83 c0 01             	add    $0x1,%eax
  8018d6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018d9:	83 c7 01             	add    $0x1,%edi
  8018dc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018df:	74 13                	je     8018f4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018e4:	8b 0b                	mov    (%ebx),%ecx
  8018e6:	8d 51 20             	lea    0x20(%ecx),%edx
  8018e9:	39 d0                	cmp    %edx,%eax
  8018eb:	73 aa                	jae    801897 <devpipe_write+0x23>
  8018ed:	eb c6                	jmp    8018b5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8018f4:	89 f8                	mov    %edi,%eax
  8018f6:	eb 05                	jmp    8018fd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8018fd:	83 c4 1c             	add    $0x1c,%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5f                   	pop    %edi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	57                   	push   %edi
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	83 ec 1c             	sub    $0x1c,%esp
  80190e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801911:	89 3c 24             	mov    %edi,(%esp)
  801914:	e8 07 f6 ff ff       	call   800f20 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801919:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80191d:	74 54                	je     801973 <devpipe_read+0x6e>
  80191f:	89 c3                	mov    %eax,%ebx
  801921:	be 00 00 00 00       	mov    $0x0,%esi
  801926:	eb 3e                	jmp    801966 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801928:	89 f0                	mov    %esi,%eax
  80192a:	eb 55                	jmp    801981 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80192c:	89 da                	mov    %ebx,%edx
  80192e:	89 f8                	mov    %edi,%eax
  801930:	e8 d6 fe ff ff       	call   80180b <_pipeisclosed>
  801935:	85 c0                	test   %eax,%eax
  801937:	75 43                	jne    80197c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801939:	e8 3c f3 ff ff       	call   800c7a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80193e:	8b 03                	mov    (%ebx),%eax
  801940:	3b 43 04             	cmp    0x4(%ebx),%eax
  801943:	74 e7                	je     80192c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801945:	99                   	cltd   
  801946:	c1 ea 1b             	shr    $0x1b,%edx
  801949:	01 d0                	add    %edx,%eax
  80194b:	83 e0 1f             	and    $0x1f,%eax
  80194e:	29 d0                	sub    %edx,%eax
  801950:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801955:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801958:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80195b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80195e:	83 c6 01             	add    $0x1,%esi
  801961:	3b 75 10             	cmp    0x10(%ebp),%esi
  801964:	74 12                	je     801978 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801966:	8b 03                	mov    (%ebx),%eax
  801968:	3b 43 04             	cmp    0x4(%ebx),%eax
  80196b:	75 d8                	jne    801945 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80196d:	85 f6                	test   %esi,%esi
  80196f:	75 b7                	jne    801928 <devpipe_read+0x23>
  801971:	eb b9                	jmp    80192c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801973:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801978:	89 f0                	mov    %esi,%eax
  80197a:	eb 05                	jmp    801981 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801981:	83 c4 1c             	add    $0x1c,%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5f                   	pop    %edi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801991:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 9b f5 ff ff       	call   800f37 <fd_alloc>
  80199c:	89 c2                	mov    %eax,%edx
  80199e:	85 d2                	test   %edx,%edx
  8019a0:	0f 88 4d 01 00 00    	js     801af3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019ad:	00 
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019bc:	e8 d8 f2 ff ff       	call   800c99 <sys_page_alloc>
  8019c1:	89 c2                	mov    %eax,%edx
  8019c3:	85 d2                	test   %edx,%edx
  8019c5:	0f 88 28 01 00 00    	js     801af3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8019cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ce:	89 04 24             	mov    %eax,(%esp)
  8019d1:	e8 61 f5 ff ff       	call   800f37 <fd_alloc>
  8019d6:	89 c3                	mov    %eax,%ebx
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	0f 88 fe 00 00 00    	js     801ade <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019e7:	00 
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019f6:	e8 9e f2 ff ff       	call   800c99 <sys_page_alloc>
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	0f 88 d9 00 00 00    	js     801ade <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a08:	89 04 24             	mov    %eax,(%esp)
  801a0b:	e8 10 f5 ff ff       	call   800f20 <fd2data>
  801a10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a19:	00 
  801a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a25:	e8 6f f2 ff ff       	call   800c99 <sys_page_alloc>
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	0f 88 97 00 00 00    	js     801acb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a37:	89 04 24             	mov    %eax,(%esp)
  801a3a:	e8 e1 f4 ff ff       	call   800f20 <fd2data>
  801a3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a46:	00 
  801a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a52:	00 
  801a53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5e:	e8 8a f2 ff ff       	call   800ced <sys_page_map>
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 52                	js     801abb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 72 f4 ff ff       	call   800f10 <fd2num>
  801a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	89 04 24             	mov    %eax,(%esp)
  801aa9:	e8 62 f4 ff ff       	call   800f10 <fd2num>
  801aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	eb 38                	jmp    801af3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801abb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac6:	e8 75 f2 ff ff       	call   800d40 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad9:	e8 62 f2 ff ff       	call   800d40 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aec:	e8 4f f2 ff ff       	call   800d40 <sys_page_unmap>
  801af1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801af3:	83 c4 30             	add    $0x30,%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	89 04 24             	mov    %eax,(%esp)
  801b0d:	e8 99 f4 ff ff       	call   800fab <fd_lookup>
  801b12:	89 c2                	mov    %eax,%edx
  801b14:	85 d2                	test   %edx,%edx
  801b16:	78 15                	js     801b2d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	89 04 24             	mov    %eax,(%esp)
  801b1e:	e8 fd f3 ff ff       	call   800f20 <fd2data>
	return _pipeisclosed(fd, p);
  801b23:	89 c2                	mov    %eax,%edx
  801b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b28:	e8 de fc ff ff       	call   80180b <_pipeisclosed>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    
  801b2f:	90                   	nop

00801b30 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b40:	c7 44 24 04 78 25 80 	movl   $0x802578,0x4(%esp)
  801b47:	00 
  801b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4b:	89 04 24             	mov    %eax,(%esp)
  801b4e:	e8 98 ec ff ff       	call   8007eb <strcpy>
	return 0;
}
  801b53:	b8 00 00 00 00       	mov    $0x0,%eax
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b6a:	74 4a                	je     801bb6 <devcons_write+0x5c>
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b71:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b76:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b7c:	8b 75 10             	mov    0x10(%ebp),%esi
  801b7f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801b81:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b84:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b89:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b8c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801b90:	03 45 0c             	add    0xc(%ebp),%eax
  801b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b97:	89 3c 24             	mov    %edi,(%esp)
  801b9a:	e8 47 ee ff ff       	call   8009e6 <memmove>
		sys_cputs(buf, m);
  801b9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba3:	89 3c 24             	mov    %edi,(%esp)
  801ba6:	e8 21 f0 ff ff       	call   800bcc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bab:	01 f3                	add    %esi,%ebx
  801bad:	89 d8                	mov    %ebx,%eax
  801baf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801bb2:	72 c8                	jb     801b7c <devcons_write+0x22>
  801bb4:	eb 05                	jmp    801bbb <devcons_write+0x61>
  801bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    

00801bc8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801bd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd7:	75 07                	jne    801be0 <devcons_read+0x18>
  801bd9:	eb 28                	jmp    801c03 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801bdb:	e8 9a f0 ff ff       	call   800c7a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801be0:	e8 05 f0 ff ff       	call   800bea <sys_cgetc>
  801be5:	85 c0                	test   %eax,%eax
  801be7:	74 f2                	je     801bdb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801be9:	85 c0                	test   %eax,%eax
  801beb:	78 16                	js     801c03 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801bed:	83 f8 04             	cmp    $0x4,%eax
  801bf0:	74 0c                	je     801bfe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf5:	88 02                	mov    %al,(%edx)
	return 1;
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	eb 05                	jmp    801c03 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c18:	00 
  801c19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 a8 ef ff ff       	call   800bcc <sys_cputs>
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <getchar>:

int
getchar(void)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c2c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c33:	00 
  801c34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c42:	e8 0f f6 ff ff       	call   801256 <read>
	if (r < 0)
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 0f                	js     801c5a <getchar+0x34>
		return r;
	if (r < 1)
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	7e 06                	jle    801c55 <getchar+0x2f>
		return -E_EOF;
	return c;
  801c4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c53:	eb 05                	jmp    801c5a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	89 04 24             	mov    %eax,(%esp)
  801c6f:	e8 37 f3 ff ff       	call   800fab <fd_lookup>
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 11                	js     801c89 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c81:	39 10                	cmp    %edx,(%eax)
  801c83:	0f 94 c0             	sete   %al
  801c86:	0f b6 c0             	movzbl %al,%eax
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <opencons>:

int
opencons(void)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c94:	89 04 24             	mov    %eax,(%esp)
  801c97:	e8 9b f2 ff ff       	call   800f37 <fd_alloc>
		return r;
  801c9c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 40                	js     801ce2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ca2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ca9:	00 
  801caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb8:	e8 dc ef ff ff       	call   800c99 <sys_page_alloc>
		return r;
  801cbd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 1f                	js     801ce2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801cc3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cd8:	89 04 24             	mov    %eax,(%esp)
  801cdb:	e8 30 f2 ff ff       	call   800f10 <fd2num>
  801ce0:	89 c2                	mov    %eax,%edx
}
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801cee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cf1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801cf7:	e8 5f ef ff ff       	call   800c5b <sys_getenvid>
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d03:	8b 55 08             	mov    0x8(%ebp),%edx
  801d06:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d0a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d12:	c7 04 24 84 25 80 00 	movl   $0x802584,(%esp)
  801d19:	e8 75 e4 ff ff       	call   800193 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d22:	8b 45 10             	mov    0x10(%ebp),%eax
  801d25:	89 04 24             	mov    %eax,(%esp)
  801d28:	e8 05 e4 ff ff       	call   800132 <vcprintf>
	cprintf("\n");
  801d2d:	c7 04 24 71 25 80 00 	movl   $0x802571,(%esp)
  801d34:	e8 5a e4 ff ff       	call   800193 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d39:	cc                   	int3   
  801d3a:	eb fd                	jmp    801d39 <_panic+0x53>

00801d3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	56                   	push   %esi
  801d40:	53                   	push   %ebx
  801d41:	83 ec 10             	sub    $0x10,%esp
  801d44:	8b 75 08             	mov    0x8(%ebp),%esi
  801d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d54:	0f 44 c2             	cmove  %edx,%eax
  801d57:	89 04 24             	mov    %eax,(%esp)
  801d5a:	e8 50 f1 ff ff       	call   800eaf <sys_ipc_recv>
	if (err_code < 0) {
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	79 16                	jns    801d79 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d63:	85 f6                	test   %esi,%esi
  801d65:	74 06                	je     801d6d <ipc_recv+0x31>
  801d67:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d6d:	85 db                	test   %ebx,%ebx
  801d6f:	74 2c                	je     801d9d <ipc_recv+0x61>
  801d71:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d77:	eb 24                	jmp    801d9d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d79:	85 f6                	test   %esi,%esi
  801d7b:	74 0a                	je     801d87 <ipc_recv+0x4b>
  801d7d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d82:	8b 40 74             	mov    0x74(%eax),%eax
  801d85:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d87:	85 db                	test   %ebx,%ebx
  801d89:	74 0a                	je     801d95 <ipc_recv+0x59>
  801d8b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d90:	8b 40 78             	mov    0x78(%eax),%eax
  801d93:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d95:	a1 04 40 80 00       	mov    0x804004,%eax
  801d9a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	57                   	push   %edi
  801da8:	56                   	push   %esi
  801da9:	53                   	push   %ebx
  801daa:	83 ec 1c             	sub    $0x1c,%esp
  801dad:	8b 7d 08             	mov    0x8(%ebp),%edi
  801db0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801db3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801db6:	eb 25                	jmp    801ddd <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801db8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dbb:	74 20                	je     801ddd <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801dbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc1:	c7 44 24 08 a8 25 80 	movl   $0x8025a8,0x8(%esp)
  801dc8:	00 
  801dc9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801dd0:	00 
  801dd1:	c7 04 24 b4 25 80 00 	movl   $0x8025b4,(%esp)
  801dd8:	e8 09 ff ff ff       	call   801ce6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ddd:	85 db                	test   %ebx,%ebx
  801ddf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801de4:	0f 45 c3             	cmovne %ebx,%eax
  801de7:	8b 55 14             	mov    0x14(%ebp),%edx
  801dea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801df6:	89 3c 24             	mov    %edi,(%esp)
  801df9:	e8 8e f0 ff ff       	call   800e8c <sys_ipc_try_send>
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	75 b6                	jne    801db8 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801e02:	83 c4 1c             	add    $0x1c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e10:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e15:	39 c8                	cmp    %ecx,%eax
  801e17:	74 17                	je     801e30 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e19:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e1e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e21:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e27:	8b 52 50             	mov    0x50(%edx),%edx
  801e2a:	39 ca                	cmp    %ecx,%edx
  801e2c:	75 14                	jne    801e42 <ipc_find_env+0x38>
  801e2e:	eb 05                	jmp    801e35 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e35:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e38:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e3d:	8b 40 40             	mov    0x40(%eax),%eax
  801e40:	eb 0e                	jmp    801e50 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e42:	83 c0 01             	add    $0x1,%eax
  801e45:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e4a:	75 d2                	jne    801e1e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e4c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    

00801e52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	c1 e8 16             	shr    $0x16,%eax
  801e5d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e69:	f6 c1 01             	test   $0x1,%cl
  801e6c:	74 1d                	je     801e8b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e6e:	c1 ea 0c             	shr    $0xc,%edx
  801e71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e78:	f6 c2 01             	test   $0x1,%dl
  801e7b:	74 0e                	je     801e8b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e7d:	c1 ea 0c             	shr    $0xc,%edx
  801e80:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e87:	ef 
  801e88:	0f b7 c0             	movzwl %ax,%eax
}
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    
  801e8d:	66 90                	xchg   %ax,%ax
  801e8f:	90                   	nop

00801e90 <__udivdi3>:
  801e90:	55                   	push   %ebp
  801e91:	57                   	push   %edi
  801e92:	56                   	push   %esi
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801ea2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801eac:	89 ea                	mov    %ebp,%edx
  801eae:	89 0c 24             	mov    %ecx,(%esp)
  801eb1:	75 2d                	jne    801ee0 <__udivdi3+0x50>
  801eb3:	39 e9                	cmp    %ebp,%ecx
  801eb5:	77 61                	ja     801f18 <__udivdi3+0x88>
  801eb7:	85 c9                	test   %ecx,%ecx
  801eb9:	89 ce                	mov    %ecx,%esi
  801ebb:	75 0b                	jne    801ec8 <__udivdi3+0x38>
  801ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec2:	31 d2                	xor    %edx,%edx
  801ec4:	f7 f1                	div    %ecx
  801ec6:	89 c6                	mov    %eax,%esi
  801ec8:	31 d2                	xor    %edx,%edx
  801eca:	89 e8                	mov    %ebp,%eax
  801ecc:	f7 f6                	div    %esi
  801ece:	89 c5                	mov    %eax,%ebp
  801ed0:	89 f8                	mov    %edi,%eax
  801ed2:	f7 f6                	div    %esi
  801ed4:	89 ea                	mov    %ebp,%edx
  801ed6:	83 c4 0c             	add    $0xc,%esp
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	39 e8                	cmp    %ebp,%eax
  801ee2:	77 24                	ja     801f08 <__udivdi3+0x78>
  801ee4:	0f bd e8             	bsr    %eax,%ebp
  801ee7:	83 f5 1f             	xor    $0x1f,%ebp
  801eea:	75 3c                	jne    801f28 <__udivdi3+0x98>
  801eec:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ef0:	39 34 24             	cmp    %esi,(%esp)
  801ef3:	0f 86 9f 00 00 00    	jbe    801f98 <__udivdi3+0x108>
  801ef9:	39 d0                	cmp    %edx,%eax
  801efb:	0f 82 97 00 00 00    	jb     801f98 <__udivdi3+0x108>
  801f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f08:	31 d2                	xor    %edx,%edx
  801f0a:	31 c0                	xor    %eax,%eax
  801f0c:	83 c4 0c             	add    $0xc,%esp
  801f0f:	5e                   	pop    %esi
  801f10:	5f                   	pop    %edi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    
  801f13:	90                   	nop
  801f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f18:	89 f8                	mov    %edi,%eax
  801f1a:	f7 f1                	div    %ecx
  801f1c:	31 d2                	xor    %edx,%edx
  801f1e:	83 c4 0c             	add    $0xc,%esp
  801f21:	5e                   	pop    %esi
  801f22:	5f                   	pop    %edi
  801f23:	5d                   	pop    %ebp
  801f24:	c3                   	ret    
  801f25:	8d 76 00             	lea    0x0(%esi),%esi
  801f28:	89 e9                	mov    %ebp,%ecx
  801f2a:	8b 3c 24             	mov    (%esp),%edi
  801f2d:	d3 e0                	shl    %cl,%eax
  801f2f:	89 c6                	mov    %eax,%esi
  801f31:	b8 20 00 00 00       	mov    $0x20,%eax
  801f36:	29 e8                	sub    %ebp,%eax
  801f38:	89 c1                	mov    %eax,%ecx
  801f3a:	d3 ef                	shr    %cl,%edi
  801f3c:	89 e9                	mov    %ebp,%ecx
  801f3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f42:	8b 3c 24             	mov    (%esp),%edi
  801f45:	09 74 24 08          	or     %esi,0x8(%esp)
  801f49:	89 d6                	mov    %edx,%esi
  801f4b:	d3 e7                	shl    %cl,%edi
  801f4d:	89 c1                	mov    %eax,%ecx
  801f4f:	89 3c 24             	mov    %edi,(%esp)
  801f52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f56:	d3 ee                	shr    %cl,%esi
  801f58:	89 e9                	mov    %ebp,%ecx
  801f5a:	d3 e2                	shl    %cl,%edx
  801f5c:	89 c1                	mov    %eax,%ecx
  801f5e:	d3 ef                	shr    %cl,%edi
  801f60:	09 d7                	or     %edx,%edi
  801f62:	89 f2                	mov    %esi,%edx
  801f64:	89 f8                	mov    %edi,%eax
  801f66:	f7 74 24 08          	divl   0x8(%esp)
  801f6a:	89 d6                	mov    %edx,%esi
  801f6c:	89 c7                	mov    %eax,%edi
  801f6e:	f7 24 24             	mull   (%esp)
  801f71:	39 d6                	cmp    %edx,%esi
  801f73:	89 14 24             	mov    %edx,(%esp)
  801f76:	72 30                	jb     801fa8 <__udivdi3+0x118>
  801f78:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f7c:	89 e9                	mov    %ebp,%ecx
  801f7e:	d3 e2                	shl    %cl,%edx
  801f80:	39 c2                	cmp    %eax,%edx
  801f82:	73 05                	jae    801f89 <__udivdi3+0xf9>
  801f84:	3b 34 24             	cmp    (%esp),%esi
  801f87:	74 1f                	je     801fa8 <__udivdi3+0x118>
  801f89:	89 f8                	mov    %edi,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	e9 7a ff ff ff       	jmp    801f0c <__udivdi3+0x7c>
  801f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f98:	31 d2                	xor    %edx,%edx
  801f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9f:	e9 68 ff ff ff       	jmp    801f0c <__udivdi3+0x7c>
  801fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fa8:	8d 47 ff             	lea    -0x1(%edi),%eax
  801fab:	31 d2                	xor    %edx,%edx
  801fad:	83 c4 0c             	add    $0xc,%esp
  801fb0:	5e                   	pop    %esi
  801fb1:	5f                   	pop    %edi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    
  801fb4:	66 90                	xchg   %ax,%ax
  801fb6:	66 90                	xchg   %ax,%ax
  801fb8:	66 90                	xchg   %ax,%ax
  801fba:	66 90                	xchg   %ax,%ax
  801fbc:	66 90                	xchg   %ax,%ax
  801fbe:	66 90                	xchg   %ax,%ax

00801fc0 <__umoddi3>:
  801fc0:	55                   	push   %ebp
  801fc1:	57                   	push   %edi
  801fc2:	56                   	push   %esi
  801fc3:	83 ec 14             	sub    $0x14,%esp
  801fc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801fca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fd2:	89 c7                	mov    %eax,%edi
  801fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fdc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fe0:	89 34 24             	mov    %esi,(%esp)
  801fe3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	89 c2                	mov    %eax,%edx
  801feb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fef:	75 17                	jne    802008 <__umoddi3+0x48>
  801ff1:	39 fe                	cmp    %edi,%esi
  801ff3:	76 4b                	jbe    802040 <__umoddi3+0x80>
  801ff5:	89 c8                	mov    %ecx,%eax
  801ff7:	89 fa                	mov    %edi,%edx
  801ff9:	f7 f6                	div    %esi
  801ffb:	89 d0                	mov    %edx,%eax
  801ffd:	31 d2                	xor    %edx,%edx
  801fff:	83 c4 14             	add    $0x14,%esp
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	66 90                	xchg   %ax,%ax
  802008:	39 f8                	cmp    %edi,%eax
  80200a:	77 54                	ja     802060 <__umoddi3+0xa0>
  80200c:	0f bd e8             	bsr    %eax,%ebp
  80200f:	83 f5 1f             	xor    $0x1f,%ebp
  802012:	75 5c                	jne    802070 <__umoddi3+0xb0>
  802014:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802018:	39 3c 24             	cmp    %edi,(%esp)
  80201b:	0f 87 e7 00 00 00    	ja     802108 <__umoddi3+0x148>
  802021:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802025:	29 f1                	sub    %esi,%ecx
  802027:	19 c7                	sbb    %eax,%edi
  802029:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80202d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802031:	8b 44 24 08          	mov    0x8(%esp),%eax
  802035:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802039:	83 c4 14             	add    $0x14,%esp
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    
  802040:	85 f6                	test   %esi,%esi
  802042:	89 f5                	mov    %esi,%ebp
  802044:	75 0b                	jne    802051 <__umoddi3+0x91>
  802046:	b8 01 00 00 00       	mov    $0x1,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f6                	div    %esi
  80204f:	89 c5                	mov    %eax,%ebp
  802051:	8b 44 24 04          	mov    0x4(%esp),%eax
  802055:	31 d2                	xor    %edx,%edx
  802057:	f7 f5                	div    %ebp
  802059:	89 c8                	mov    %ecx,%eax
  80205b:	f7 f5                	div    %ebp
  80205d:	eb 9c                	jmp    801ffb <__umoddi3+0x3b>
  80205f:	90                   	nop
  802060:	89 c8                	mov    %ecx,%eax
  802062:	89 fa                	mov    %edi,%edx
  802064:	83 c4 14             	add    $0x14,%esp
  802067:	5e                   	pop    %esi
  802068:	5f                   	pop    %edi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    
  80206b:	90                   	nop
  80206c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802070:	8b 04 24             	mov    (%esp),%eax
  802073:	be 20 00 00 00       	mov    $0x20,%esi
  802078:	89 e9                	mov    %ebp,%ecx
  80207a:	29 ee                	sub    %ebp,%esi
  80207c:	d3 e2                	shl    %cl,%edx
  80207e:	89 f1                	mov    %esi,%ecx
  802080:	d3 e8                	shr    %cl,%eax
  802082:	89 e9                	mov    %ebp,%ecx
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	8b 04 24             	mov    (%esp),%eax
  80208b:	09 54 24 04          	or     %edx,0x4(%esp)
  80208f:	89 fa                	mov    %edi,%edx
  802091:	d3 e0                	shl    %cl,%eax
  802093:	89 f1                	mov    %esi,%ecx
  802095:	89 44 24 08          	mov    %eax,0x8(%esp)
  802099:	8b 44 24 10          	mov    0x10(%esp),%eax
  80209d:	d3 ea                	shr    %cl,%edx
  80209f:	89 e9                	mov    %ebp,%ecx
  8020a1:	d3 e7                	shl    %cl,%edi
  8020a3:	89 f1                	mov    %esi,%ecx
  8020a5:	d3 e8                	shr    %cl,%eax
  8020a7:	89 e9                	mov    %ebp,%ecx
  8020a9:	09 f8                	or     %edi,%eax
  8020ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8020af:	f7 74 24 04          	divl   0x4(%esp)
  8020b3:	d3 e7                	shl    %cl,%edi
  8020b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020b9:	89 d7                	mov    %edx,%edi
  8020bb:	f7 64 24 08          	mull   0x8(%esp)
  8020bf:	39 d7                	cmp    %edx,%edi
  8020c1:	89 c1                	mov    %eax,%ecx
  8020c3:	89 14 24             	mov    %edx,(%esp)
  8020c6:	72 2c                	jb     8020f4 <__umoddi3+0x134>
  8020c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8020cc:	72 22                	jb     8020f0 <__umoddi3+0x130>
  8020ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020d2:	29 c8                	sub    %ecx,%eax
  8020d4:	19 d7                	sbb    %edx,%edi
  8020d6:	89 e9                	mov    %ebp,%ecx
  8020d8:	89 fa                	mov    %edi,%edx
  8020da:	d3 e8                	shr    %cl,%eax
  8020dc:	89 f1                	mov    %esi,%ecx
  8020de:	d3 e2                	shl    %cl,%edx
  8020e0:	89 e9                	mov    %ebp,%ecx
  8020e2:	d3 ef                	shr    %cl,%edi
  8020e4:	09 d0                	or     %edx,%eax
  8020e6:	89 fa                	mov    %edi,%edx
  8020e8:	83 c4 14             	add    $0x14,%esp
  8020eb:	5e                   	pop    %esi
  8020ec:	5f                   	pop    %edi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    
  8020ef:	90                   	nop
  8020f0:	39 d7                	cmp    %edx,%edi
  8020f2:	75 da                	jne    8020ce <__umoddi3+0x10e>
  8020f4:	8b 14 24             	mov    (%esp),%edx
  8020f7:	89 c1                	mov    %eax,%ecx
  8020f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802101:	eb cb                	jmp    8020ce <__umoddi3+0x10e>
  802103:	90                   	nop
  802104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802108:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80210c:	0f 82 0f ff ff ff    	jb     802021 <__umoddi3+0x61>
  802112:	e9 1a ff ff ff       	jmp    802031 <__umoddi3+0x71>
