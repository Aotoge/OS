
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 31 00 00 00       	call   800062 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	zero = 0;
  800039:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	89 44 24 04          	mov    %eax,0x4(%esp)
  800054:	c7 04 24 00 21 80 00 	movl   $0x802100,(%esp)
  80005b:	e8 36 01 00 00       	call   800196 <cprintf>
}
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800062:	55                   	push   %ebp
  800063:	89 e5                	mov    %esp,%ebp
  800065:	56                   	push   %esi
  800066:	53                   	push   %ebx
  800067:	83 ec 10             	sub    $0x10,%esp
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800070:	e8 e6 0b 00 00       	call   800c5b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800075:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80007b:	39 c2                	cmp    %eax,%edx
  80007d:	74 17                	je     800096 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80007f:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800084:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800087:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80008d:	8b 49 40             	mov    0x40(%ecx),%ecx
  800090:	39 c1                	cmp    %eax,%ecx
  800092:	75 18                	jne    8000ac <libmain+0x4a>
  800094:	eb 05                	jmp    80009b <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800096:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80009b:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80009e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000a4:	89 15 08 40 80 00    	mov    %edx,0x804008
			break;
  8000aa:	eb 0b                	jmp    8000b7 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000ac:	83 c2 01             	add    $0x1,%edx
  8000af:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000b5:	75 cd                	jne    800084 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	85 db                	test   %ebx,%ebx
  8000b9:	7e 07                	jle    8000c2 <libmain+0x60>
		binaryname = argv[0];
  8000bb:	8b 06                	mov    (%esi),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 65 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ce:	e8 07 00 00 00       	call   8000da <exit>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5d                   	pop    %ebp
  8000d9:	c3                   	ret    

008000da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e0:	e8 41 10 00 00       	call   801126 <close_all>
	sys_env_destroy(0);
  8000e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ec:	e8 18 0b 00 00       	call   800c09 <sys_env_destroy>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 14             	sub    $0x14,%esp
  8000fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fd:	8b 13                	mov    (%ebx),%edx
  8000ff:	8d 42 01             	lea    0x1(%edx),%eax
  800102:	89 03                	mov    %eax,(%ebx)
  800104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800107:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800110:	75 19                	jne    80012b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800112:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800119:	00 
  80011a:	8d 43 08             	lea    0x8(%ebx),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 a7 0a 00 00       	call   800bcc <sys_cputs>
		b->idx = 0;
  800125:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80012b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012f:	83 c4 14             	add    $0x14,%esp
  800132:	5b                   	pop    %ebx
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    

00800135 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80013e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800145:	00 00 00 
	b.cnt = 0;
  800148:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800159:	8b 45 08             	mov    0x8(%ebp),%eax
  80015c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	c7 04 24 f3 00 80 00 	movl   $0x8000f3,(%esp)
  800171:	e8 ae 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800176:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800186:	89 04 24             	mov    %eax,(%esp)
  800189:	e8 3e 0a 00 00       	call   800bcc <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a6:	89 04 24             	mov    %eax,(%esp)
  8001a9:	e8 87 ff ff ff       	call   800135 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

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
  80022c:	e8 2f 1c 00 00       	call   801e60 <__udivdi3>
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
  800285:	e8 06 1d 00 00       	call   801f90 <__umoddi3>
  80028a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80028e:	0f be 80 18 21 80 00 	movsbl 0x802118(%eax),%eax
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
  8003ac:	ff 24 85 60 22 80 00 	jmp    *0x802260(,%eax,4)
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
  80045f:	8b 14 85 c0 23 80 00 	mov    0x8023c0(,%eax,4),%edx
  800466:	85 d2                	test   %edx,%edx
  800468:	75 20                	jne    80048a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80046a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046e:	c7 44 24 08 30 21 80 	movl   $0x802130,0x8(%esp)
  800475:	00 
  800476:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 04 24             	mov    %eax,(%esp)
  800480:	e8 77 fe ff ff       	call   8002fc <printfmt>
  800485:	e9 c3 fe ff ff       	jmp    80034d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80048a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048e:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
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
  8004bd:	ba 29 21 80 00       	mov    $0x802129,%edx
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
  800c37:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800c3e:	00 
  800c3f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c46:	00 
  800c47:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800c4e:	e8 63 10 00 00       	call   801cb6 <_panic>

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
  800cc9:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800cd0:	00 
  800cd1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800cd8:	00 
  800cd9:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800ce0:	e8 d1 0f 00 00       	call   801cb6 <_panic>

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
  800d1c:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800d23:	00 
  800d24:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d2b:	00 
  800d2c:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800d33:	e8 7e 0f 00 00       	call   801cb6 <_panic>

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
  800d6f:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800d76:	00 
  800d77:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d7e:	00 
  800d7f:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800d86:	e8 2b 0f 00 00       	call   801cb6 <_panic>

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
  800dc2:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800dc9:	00 
  800dca:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dd1:	00 
  800dd2:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800dd9:	e8 d8 0e 00 00       	call   801cb6 <_panic>

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
  800e15:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800e1c:	00 
  800e1d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e24:	00 
  800e25:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800e2c:	e8 85 0e 00 00       	call   801cb6 <_panic>

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
  800e68:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800e6f:	00 
  800e70:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e77:	00 
  800e78:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800e7f:	e8 32 0e 00 00       	call   801cb6 <_panic>

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
  800edd:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800ee4:	00 
  800ee5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eec:	00 
  800eed:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800ef4:	e8 bd 0d 00 00       	call   801cb6 <_panic>

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
  801044:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80104a:	8b 52 48             	mov    0x48(%edx),%edx
  80104d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801051:	89 54 24 04          	mov    %edx,0x4(%esp)
  801055:	c7 04 24 4c 24 80 00 	movl   $0x80244c,(%esp)
  80105c:	e8 35 f1 ff ff       	call   800196 <cprintf>
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
  80129b:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a0:	8b 40 48             	mov    0x48(%eax),%eax
  8012a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ab:	c7 04 24 8d 24 80 00 	movl   $0x80248d,(%esp)
  8012b2:	e8 df ee ff ff       	call   800196 <cprintf>
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
  801383:	a1 08 40 80 00       	mov    0x804008,%eax
  801388:	8b 40 48             	mov    0x48(%eax),%eax
  80138b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80138f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801393:	c7 04 24 a9 24 80 00 	movl   $0x8024a9,(%esp)
  80139a:	e8 f7 ed ff ff       	call   800196 <cprintf>
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
  80143c:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801441:	8b 40 48             	mov    0x48(%eax),%eax
  801444:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801448:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144c:	c7 04 24 6c 24 80 00 	movl   $0x80246c,(%esp)
  801453:	e8 3e ed ff ff       	call   800196 <cprintf>
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
  801512:	e8 af 01 00 00       	call   8016c6 <open>
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
  801547:	89 c6                	mov    %eax,%esi
  801549:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80154b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801552:	75 11                	jne    801565 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801554:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80155b:	e8 7a 08 00 00       	call   801dda <ipc_find_env>
  801560:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801565:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80156c:	00 
  80156d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801574:	00 
  801575:	89 74 24 04          	mov    %esi,0x4(%esp)
  801579:	a1 00 40 80 00       	mov    0x804000,%eax
  80157e:	89 04 24             	mov    %eax,(%esp)
  801581:	e8 ee 07 00 00       	call   801d74 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801586:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80158d:	00 
  80158e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801599:	e8 6e 07 00 00       	call   801d0c <ipc_recv>
}
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 14             	sub    $0x14,%esp
  8015ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8015c4:	e8 76 ff ff ff       	call   80153f <fsipc>
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	85 d2                	test   %edx,%edx
  8015cd:	78 2b                	js     8015fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015d6:	00 
  8015d7:	89 1c 24             	mov    %ebx,(%esp)
  8015da:	e8 0c f2 ff ff       	call   8007eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015df:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8015ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fa:	83 c4 14             	add    $0x14,%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8b 40 0c             	mov    0xc(%eax),%eax
  80160c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	b8 06 00 00 00       	mov    $0x6,%eax
  80161b:	e8 1f ff ff ff       	call   80153f <fsipc>
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	83 ec 10             	sub    $0x10,%esp
  80162a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 40 0c             	mov    0xc(%eax),%eax
  801633:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801638:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 03 00 00 00       	mov    $0x3,%eax
  801648:	e8 f2 fe ff ff       	call   80153f <fsipc>
  80164d:	89 c3                	mov    %eax,%ebx
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 6a                	js     8016bd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801653:	39 c6                	cmp    %eax,%esi
  801655:	73 24                	jae    80167b <devfile_read+0x59>
  801657:	c7 44 24 0c c6 24 80 	movl   $0x8024c6,0xc(%esp)
  80165e:	00 
  80165f:	c7 44 24 08 cd 24 80 	movl   $0x8024cd,0x8(%esp)
  801666:	00 
  801667:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80166e:	00 
  80166f:	c7 04 24 e2 24 80 00 	movl   $0x8024e2,(%esp)
  801676:	e8 3b 06 00 00       	call   801cb6 <_panic>
	assert(r <= PGSIZE);
  80167b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801680:	7e 24                	jle    8016a6 <devfile_read+0x84>
  801682:	c7 44 24 0c ed 24 80 	movl   $0x8024ed,0xc(%esp)
  801689:	00 
  80168a:	c7 44 24 08 cd 24 80 	movl   $0x8024cd,0x8(%esp)
  801691:	00 
  801692:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801699:	00 
  80169a:	c7 04 24 e2 24 80 00 	movl   $0x8024e2,(%esp)
  8016a1:	e8 10 06 00 00       	call   801cb6 <_panic>
	memmove(buf, &fsipcbuf, r);
  8016a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016aa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016b1:	00 
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	89 04 24             	mov    %eax,(%esp)
  8016b8:	e8 29 f3 ff ff       	call   8009e6 <memmove>
	return r;
}
  8016bd:	89 d8                	mov    %ebx,%eax
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 24             	sub    $0x24,%esp
  8016cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8016d0:	89 1c 24             	mov    %ebx,(%esp)
  8016d3:	e8 b8 f0 ff ff       	call   800790 <strlen>
  8016d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016dd:	7f 60                	jg     80173f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8016df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e2:	89 04 24             	mov    %eax,(%esp)
  8016e5:	e8 4d f8 ff ff       	call   800f37 <fd_alloc>
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	85 d2                	test   %edx,%edx
  8016ee:	78 54                	js     801744 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8016f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8016fb:	e8 eb f0 ff ff       	call   8007eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	b8 01 00 00 00       	mov    $0x1,%eax
  801710:	e8 2a fe ff ff       	call   80153f <fsipc>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	85 c0                	test   %eax,%eax
  801719:	79 17                	jns    801732 <open+0x6c>
		fd_close(fd, 0);
  80171b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801722:	00 
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	89 04 24             	mov    %eax,(%esp)
  801729:	e8 44 f9 ff ff       	call   801072 <fd_close>
		return r;
  80172e:	89 d8                	mov    %ebx,%eax
  801730:	eb 12                	jmp    801744 <open+0x7e>
	}
	return fd2num(fd);
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 d3 f7 ff ff       	call   800f10 <fd2num>
  80173d:	eb 05                	jmp    801744 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80173f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801744:	83 c4 24             	add    $0x24,%esp
  801747:	5b                   	pop    %ebx
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
  80174a:	66 90                	xchg   %ax,%ax
  80174c:	66 90                	xchg   %ax,%ax
  80174e:	66 90                	xchg   %ax,%ax

00801750 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	83 ec 10             	sub    $0x10,%esp
  801758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	89 04 24             	mov    %eax,(%esp)
  801761:	e8 ba f7 ff ff       	call   800f20 <fd2data>
  801766:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801768:	c7 44 24 04 f9 24 80 	movl   $0x8024f9,0x4(%esp)
  80176f:	00 
  801770:	89 1c 24             	mov    %ebx,(%esp)
  801773:	e8 73 f0 ff ff       	call   8007eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801778:	8b 46 04             	mov    0x4(%esi),%eax
  80177b:	2b 06                	sub    (%esi),%eax
  80177d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801783:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80178a:	00 00 00 
	stat->st_dev = &devpipe;
  80178d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801794:	30 80 00 
	return 0;
}
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 14             	sub    $0x14,%esp
  8017aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b8:	e8 83 f5 ff ff       	call   800d40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 5b f7 ff ff       	call   800f20 <fd2data>
  8017c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d0:	e8 6b f5 ff ff       	call   800d40 <sys_page_unmap>
}
  8017d5:	83 c4 14             	add    $0x14,%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5d                   	pop    %ebp
  8017da:	c3                   	ret    

008017db <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 2c             	sub    $0x2c,%esp
  8017e4:	89 c6                	mov    %eax,%esi
  8017e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8017ee:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017f1:	89 34 24             	mov    %esi,(%esp)
  8017f4:	e8 29 06 00 00       	call   801e22 <pageref>
  8017f9:	89 c7                	mov    %eax,%edi
  8017fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fe:	89 04 24             	mov    %eax,(%esp)
  801801:	e8 1c 06 00 00       	call   801e22 <pageref>
  801806:	39 c7                	cmp    %eax,%edi
  801808:	0f 94 c2             	sete   %dl
  80180b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80180e:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801814:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801817:	39 fb                	cmp    %edi,%ebx
  801819:	74 21                	je     80183c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80181b:	84 d2                	test   %dl,%dl
  80181d:	74 ca                	je     8017e9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80181f:	8b 51 58             	mov    0x58(%ecx),%edx
  801822:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801826:	89 54 24 08          	mov    %edx,0x8(%esp)
  80182a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182e:	c7 04 24 00 25 80 00 	movl   $0x802500,(%esp)
  801835:	e8 5c e9 ff ff       	call   800196 <cprintf>
  80183a:	eb ad                	jmp    8017e9 <_pipeisclosed+0xe>
	}
}
  80183c:	83 c4 2c             	add    $0x2c,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5f                   	pop    %edi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	57                   	push   %edi
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	83 ec 1c             	sub    $0x1c,%esp
  80184d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801850:	89 34 24             	mov    %esi,(%esp)
  801853:	e8 c8 f6 ff ff       	call   800f20 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801858:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80185c:	74 61                	je     8018bf <devpipe_write+0x7b>
  80185e:	89 c3                	mov    %eax,%ebx
  801860:	bf 00 00 00 00       	mov    $0x0,%edi
  801865:	eb 4a                	jmp    8018b1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801867:	89 da                	mov    %ebx,%edx
  801869:	89 f0                	mov    %esi,%eax
  80186b:	e8 6b ff ff ff       	call   8017db <_pipeisclosed>
  801870:	85 c0                	test   %eax,%eax
  801872:	75 54                	jne    8018c8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801874:	e8 01 f4 ff ff       	call   800c7a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801879:	8b 43 04             	mov    0x4(%ebx),%eax
  80187c:	8b 0b                	mov    (%ebx),%ecx
  80187e:	8d 51 20             	lea    0x20(%ecx),%edx
  801881:	39 d0                	cmp    %edx,%eax
  801883:	73 e2                	jae    801867 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801888:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80188c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80188f:	99                   	cltd   
  801890:	c1 ea 1b             	shr    $0x1b,%edx
  801893:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801896:	83 e1 1f             	and    $0x1f,%ecx
  801899:	29 d1                	sub    %edx,%ecx
  80189b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80189f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8018a3:	83 c0 01             	add    $0x1,%eax
  8018a6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018a9:	83 c7 01             	add    $0x1,%edi
  8018ac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018af:	74 13                	je     8018c4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018b4:	8b 0b                	mov    (%ebx),%ecx
  8018b6:	8d 51 20             	lea    0x20(%ecx),%edx
  8018b9:	39 d0                	cmp    %edx,%eax
  8018bb:	73 aa                	jae    801867 <devpipe_write+0x23>
  8018bd:	eb c6                	jmp    801885 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018bf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8018c4:	89 f8                	mov    %edi,%eax
  8018c6:	eb 05                	jmp    8018cd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8018cd:	83 c4 1c             	add    $0x1c,%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5e                   	pop    %esi
  8018d2:	5f                   	pop    %edi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	57                   	push   %edi
  8018d9:	56                   	push   %esi
  8018da:	53                   	push   %ebx
  8018db:	83 ec 1c             	sub    $0x1c,%esp
  8018de:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018e1:	89 3c 24             	mov    %edi,(%esp)
  8018e4:	e8 37 f6 ff ff       	call   800f20 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ed:	74 54                	je     801943 <devpipe_read+0x6e>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	be 00 00 00 00       	mov    $0x0,%esi
  8018f6:	eb 3e                	jmp    801936 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8018f8:	89 f0                	mov    %esi,%eax
  8018fa:	eb 55                	jmp    801951 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018fc:	89 da                	mov    %ebx,%edx
  8018fe:	89 f8                	mov    %edi,%eax
  801900:	e8 d6 fe ff ff       	call   8017db <_pipeisclosed>
  801905:	85 c0                	test   %eax,%eax
  801907:	75 43                	jne    80194c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801909:	e8 6c f3 ff ff       	call   800c7a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80190e:	8b 03                	mov    (%ebx),%eax
  801910:	3b 43 04             	cmp    0x4(%ebx),%eax
  801913:	74 e7                	je     8018fc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801915:	99                   	cltd   
  801916:	c1 ea 1b             	shr    $0x1b,%edx
  801919:	01 d0                	add    %edx,%eax
  80191b:	83 e0 1f             	and    $0x1f,%eax
  80191e:	29 d0                	sub    %edx,%eax
  801920:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801925:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801928:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80192b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80192e:	83 c6 01             	add    $0x1,%esi
  801931:	3b 75 10             	cmp    0x10(%ebp),%esi
  801934:	74 12                	je     801948 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801936:	8b 03                	mov    (%ebx),%eax
  801938:	3b 43 04             	cmp    0x4(%ebx),%eax
  80193b:	75 d8                	jne    801915 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80193d:	85 f6                	test   %esi,%esi
  80193f:	75 b7                	jne    8018f8 <devpipe_read+0x23>
  801941:	eb b9                	jmp    8018fc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801943:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801948:	89 f0                	mov    %esi,%eax
  80194a:	eb 05                	jmp    801951 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801951:	83 c4 1c             	add    $0x1c,%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801961:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	e8 cb f5 ff ff       	call   800f37 <fd_alloc>
  80196c:	89 c2                	mov    %eax,%edx
  80196e:	85 d2                	test   %edx,%edx
  801970:	0f 88 4d 01 00 00    	js     801ac3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801976:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80197d:	00 
  80197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801981:	89 44 24 04          	mov    %eax,0x4(%esp)
  801985:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198c:	e8 08 f3 ff ff       	call   800c99 <sys_page_alloc>
  801991:	89 c2                	mov    %eax,%edx
  801993:	85 d2                	test   %edx,%edx
  801995:	0f 88 28 01 00 00    	js     801ac3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80199b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199e:	89 04 24             	mov    %eax,(%esp)
  8019a1:	e8 91 f5 ff ff       	call   800f37 <fd_alloc>
  8019a6:	89 c3                	mov    %eax,%ebx
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	0f 88 fe 00 00 00    	js     801aae <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019b7:	00 
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c6:	e8 ce f2 ff ff       	call   800c99 <sys_page_alloc>
  8019cb:	89 c3                	mov    %eax,%ebx
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	0f 88 d9 00 00 00    	js     801aae <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d8:	89 04 24             	mov    %eax,(%esp)
  8019db:	e8 40 f5 ff ff       	call   800f20 <fd2data>
  8019e0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019e9:	00 
  8019ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019f5:	e8 9f f2 ff ff       	call   800c99 <sys_page_alloc>
  8019fa:	89 c3                	mov    %eax,%ebx
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	0f 88 97 00 00 00    	js     801a9b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a07:	89 04 24             	mov    %eax,(%esp)
  801a0a:	e8 11 f5 ff ff       	call   800f20 <fd2data>
  801a0f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a16:	00 
  801a17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a22:	00 
  801a23:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2e:	e8 ba f2 ff ff       	call   800ced <sys_page_map>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 52                	js     801a8b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a39:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a42:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a57:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	89 04 24             	mov    %eax,(%esp)
  801a69:	e8 a2 f4 ff ff       	call   800f10 <fd2num>
  801a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a71:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	89 04 24             	mov    %eax,(%esp)
  801a79:	e8 92 f4 ff ff       	call   800f10 <fd2num>
  801a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a81:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 38                	jmp    801ac3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801a8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a96:	e8 a5 f2 ff ff       	call   800d40 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa9:	e8 92 f2 ff ff       	call   800d40 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abc:	e8 7f f2 ff ff       	call   800d40 <sys_page_unmap>
  801ac1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801ac3:	83 c4 30             	add    $0x30,%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5e                   	pop    %esi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    

00801aca <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ad0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	e8 c9 f4 ff ff       	call   800fab <fd_lookup>
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	85 d2                	test   %edx,%edx
  801ae6:	78 15                	js     801afd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aeb:	89 04 24             	mov    %eax,(%esp)
  801aee:	e8 2d f4 ff ff       	call   800f20 <fd2data>
	return _pipeisclosed(fd, p);
  801af3:	89 c2                	mov    %eax,%edx
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	e8 de fc ff ff       	call   8017db <_pipeisclosed>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    
  801aff:	90                   	nop

00801b00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b10:	c7 44 24 04 18 25 80 	movl   $0x802518,0x4(%esp)
  801b17:	00 
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	89 04 24             	mov    %eax,(%esp)
  801b1e:	e8 c8 ec ff ff       	call   8007eb <strcpy>
	return 0;
}
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	57                   	push   %edi
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b3a:	74 4a                	je     801b86 <devcons_write+0x5c>
  801b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b41:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b46:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b4c:	8b 75 10             	mov    0x10(%ebp),%esi
  801b4f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801b51:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b54:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b59:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b5c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801b60:	03 45 0c             	add    0xc(%ebp),%eax
  801b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b67:	89 3c 24             	mov    %edi,(%esp)
  801b6a:	e8 77 ee ff ff       	call   8009e6 <memmove>
		sys_cputs(buf, m);
  801b6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b73:	89 3c 24             	mov    %edi,(%esp)
  801b76:	e8 51 f0 ff ff       	call   800bcc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b7b:	01 f3                	add    %esi,%ebx
  801b7d:	89 d8                	mov    %ebx,%eax
  801b7f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b82:	72 c8                	jb     801b4c <devcons_write+0x22>
  801b84:	eb 05                	jmp    801b8b <devcons_write+0x61>
  801b86:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    

00801b98 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801b9e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801ba3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba7:	75 07                	jne    801bb0 <devcons_read+0x18>
  801ba9:	eb 28                	jmp    801bd3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801bab:	e8 ca f0 ff ff       	call   800c7a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801bb0:	e8 35 f0 ff ff       	call   800bea <sys_cgetc>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	74 f2                	je     801bab <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 16                	js     801bd3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801bbd:	83 f8 04             	cmp    $0x4,%eax
  801bc0:	74 0c                	je     801bce <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	88 02                	mov    %al,(%edx)
	return 1;
  801bc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcc:	eb 05                	jmp    801bd3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801be1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801be8:	00 
  801be9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bec:	89 04 24             	mov    %eax,(%esp)
  801bef:	e8 d8 ef ff ff       	call   800bcc <sys_cputs>
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <getchar>:

int
getchar(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bfc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c03:	00 
  801c04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c12:	e8 3f f6 ff ff       	call   801256 <read>
	if (r < 0)
  801c17:	85 c0                	test   %eax,%eax
  801c19:	78 0f                	js     801c2a <getchar+0x34>
		return r;
	if (r < 1)
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	7e 06                	jle    801c25 <getchar+0x2f>
		return -E_EOF;
	return c;
  801c1f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c23:	eb 05                	jmp    801c2a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	89 04 24             	mov    %eax,(%esp)
  801c3f:	e8 67 f3 ff ff       	call   800fab <fd_lookup>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 11                	js     801c59 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c51:	39 10                	cmp    %edx,(%eax)
  801c53:	0f 94 c0             	sete   %al
  801c56:	0f b6 c0             	movzbl %al,%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <opencons>:

int
opencons(void)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 cb f2 ff ff       	call   800f37 <fd_alloc>
		return r;
  801c6c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 40                	js     801cb2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c79:	00 
  801c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c88:	e8 0c f0 ff ff       	call   800c99 <sys_page_alloc>
		return r;
  801c8d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 1f                	js     801cb2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801c93:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ca8:	89 04 24             	mov    %eax,(%esp)
  801cab:	e8 60 f2 ff ff       	call   800f10 <fd2num>
  801cb0:	89 c2                	mov    %eax,%edx
}
  801cb2:	89 d0                	mov    %edx,%eax
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801cbe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cc1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801cc7:	e8 8f ef ff ff       	call   800c5b <sys_getenvid>
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cda:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce2:	c7 04 24 24 25 80 00 	movl   $0x802524,(%esp)
  801ce9:	e8 a8 e4 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf5:	89 04 24             	mov    %eax,(%esp)
  801cf8:	e8 38 e4 ff ff       	call   800135 <vcprintf>
	cprintf("\n");
  801cfd:	c7 04 24 0c 21 80 00 	movl   $0x80210c,(%esp)
  801d04:	e8 8d e4 ff ff       	call   800196 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d09:	cc                   	int3   
  801d0a:	eb fd                	jmp    801d09 <_panic+0x53>

00801d0c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	83 ec 10             	sub    $0x10,%esp
  801d14:	8b 75 08             	mov    0x8(%ebp),%esi
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d24:	0f 44 c2             	cmove  %edx,%eax
  801d27:	89 04 24             	mov    %eax,(%esp)
  801d2a:	e8 80 f1 ff ff       	call   800eaf <sys_ipc_recv>
	if (err_code < 0) {
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	79 16                	jns    801d49 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d33:	85 f6                	test   %esi,%esi
  801d35:	74 06                	je     801d3d <ipc_recv+0x31>
  801d37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d3d:	85 db                	test   %ebx,%ebx
  801d3f:	74 2c                	je     801d6d <ipc_recv+0x61>
  801d41:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d47:	eb 24                	jmp    801d6d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d49:	85 f6                	test   %esi,%esi
  801d4b:	74 0a                	je     801d57 <ipc_recv+0x4b>
  801d4d:	a1 08 40 80 00       	mov    0x804008,%eax
  801d52:	8b 40 74             	mov    0x74(%eax),%eax
  801d55:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d57:	85 db                	test   %ebx,%ebx
  801d59:	74 0a                	je     801d65 <ipc_recv+0x59>
  801d5b:	a1 08 40 80 00       	mov    0x804008,%eax
  801d60:	8b 40 78             	mov    0x78(%eax),%eax
  801d63:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d65:	a1 08 40 80 00       	mov    0x804008,%eax
  801d6a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	57                   	push   %edi
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 1c             	sub    $0x1c,%esp
  801d7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d80:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d86:	eb 25                	jmp    801dad <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d8b:	74 20                	je     801dad <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d91:	c7 44 24 08 48 25 80 	movl   $0x802548,0x8(%esp)
  801d98:	00 
  801d99:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801da0:	00 
  801da1:	c7 04 24 54 25 80 00 	movl   $0x802554,(%esp)
  801da8:	e8 09 ff ff ff       	call   801cb6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801dad:	85 db                	test   %ebx,%ebx
  801daf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801db4:	0f 45 c3             	cmovne %ebx,%eax
  801db7:	8b 55 14             	mov    0x14(%ebp),%edx
  801dba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dc6:	89 3c 24             	mov    %edi,(%esp)
  801dc9:	e8 be f0 ff ff       	call   800e8c <sys_ipc_try_send>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	75 b6                	jne    801d88 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801dd2:	83 c4 1c             	add    $0x1c,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801de0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801de5:	39 c8                	cmp    %ecx,%eax
  801de7:	74 17                	je     801e00 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dee:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801df1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801df7:	8b 52 50             	mov    0x50(%edx),%edx
  801dfa:	39 ca                	cmp    %ecx,%edx
  801dfc:	75 14                	jne    801e12 <ipc_find_env+0x38>
  801dfe:	eb 05                	jmp    801e05 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e05:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e08:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e0d:	8b 40 40             	mov    0x40(%eax),%eax
  801e10:	eb 0e                	jmp    801e20 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e12:	83 c0 01             	add    $0x1,%eax
  801e15:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e1a:	75 d2                	jne    801dee <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e1c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	c1 e8 16             	shr    $0x16,%eax
  801e2d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e39:	f6 c1 01             	test   $0x1,%cl
  801e3c:	74 1d                	je     801e5b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e3e:	c1 ea 0c             	shr    $0xc,%edx
  801e41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e48:	f6 c2 01             	test   $0x1,%dl
  801e4b:	74 0e                	je     801e5b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e4d:	c1 ea 0c             	shr    $0xc,%edx
  801e50:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e57:	ef 
  801e58:	0f b7 c0             	movzwl %ax,%eax
}
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
  801e5d:	66 90                	xchg   %ax,%ax
  801e5f:	90                   	nop

00801e60 <__udivdi3>:
  801e60:	55                   	push   %ebp
  801e61:	57                   	push   %edi
  801e62:	56                   	push   %esi
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e6a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e6e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e72:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e76:	85 c0                	test   %eax,%eax
  801e78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e7c:	89 ea                	mov    %ebp,%edx
  801e7e:	89 0c 24             	mov    %ecx,(%esp)
  801e81:	75 2d                	jne    801eb0 <__udivdi3+0x50>
  801e83:	39 e9                	cmp    %ebp,%ecx
  801e85:	77 61                	ja     801ee8 <__udivdi3+0x88>
  801e87:	85 c9                	test   %ecx,%ecx
  801e89:	89 ce                	mov    %ecx,%esi
  801e8b:	75 0b                	jne    801e98 <__udivdi3+0x38>
  801e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e92:	31 d2                	xor    %edx,%edx
  801e94:	f7 f1                	div    %ecx
  801e96:	89 c6                	mov    %eax,%esi
  801e98:	31 d2                	xor    %edx,%edx
  801e9a:	89 e8                	mov    %ebp,%eax
  801e9c:	f7 f6                	div    %esi
  801e9e:	89 c5                	mov    %eax,%ebp
  801ea0:	89 f8                	mov    %edi,%eax
  801ea2:	f7 f6                	div    %esi
  801ea4:	89 ea                	mov    %ebp,%edx
  801ea6:	83 c4 0c             	add    $0xc,%esp
  801ea9:	5e                   	pop    %esi
  801eaa:	5f                   	pop    %edi
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    
  801ead:	8d 76 00             	lea    0x0(%esi),%esi
  801eb0:	39 e8                	cmp    %ebp,%eax
  801eb2:	77 24                	ja     801ed8 <__udivdi3+0x78>
  801eb4:	0f bd e8             	bsr    %eax,%ebp
  801eb7:	83 f5 1f             	xor    $0x1f,%ebp
  801eba:	75 3c                	jne    801ef8 <__udivdi3+0x98>
  801ebc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ec0:	39 34 24             	cmp    %esi,(%esp)
  801ec3:	0f 86 9f 00 00 00    	jbe    801f68 <__udivdi3+0x108>
  801ec9:	39 d0                	cmp    %edx,%eax
  801ecb:	0f 82 97 00 00 00    	jb     801f68 <__udivdi3+0x108>
  801ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ed8:	31 d2                	xor    %edx,%edx
  801eda:	31 c0                	xor    %eax,%eax
  801edc:	83 c4 0c             	add    $0xc,%esp
  801edf:	5e                   	pop    %esi
  801ee0:	5f                   	pop    %edi
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    
  801ee3:	90                   	nop
  801ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	89 f8                	mov    %edi,%eax
  801eea:	f7 f1                	div    %ecx
  801eec:	31 d2                	xor    %edx,%edx
  801eee:	83 c4 0c             	add    $0xc,%esp
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	8d 76 00             	lea    0x0(%esi),%esi
  801ef8:	89 e9                	mov    %ebp,%ecx
  801efa:	8b 3c 24             	mov    (%esp),%edi
  801efd:	d3 e0                	shl    %cl,%eax
  801eff:	89 c6                	mov    %eax,%esi
  801f01:	b8 20 00 00 00       	mov    $0x20,%eax
  801f06:	29 e8                	sub    %ebp,%eax
  801f08:	89 c1                	mov    %eax,%ecx
  801f0a:	d3 ef                	shr    %cl,%edi
  801f0c:	89 e9                	mov    %ebp,%ecx
  801f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f12:	8b 3c 24             	mov    (%esp),%edi
  801f15:	09 74 24 08          	or     %esi,0x8(%esp)
  801f19:	89 d6                	mov    %edx,%esi
  801f1b:	d3 e7                	shl    %cl,%edi
  801f1d:	89 c1                	mov    %eax,%ecx
  801f1f:	89 3c 24             	mov    %edi,(%esp)
  801f22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f26:	d3 ee                	shr    %cl,%esi
  801f28:	89 e9                	mov    %ebp,%ecx
  801f2a:	d3 e2                	shl    %cl,%edx
  801f2c:	89 c1                	mov    %eax,%ecx
  801f2e:	d3 ef                	shr    %cl,%edi
  801f30:	09 d7                	or     %edx,%edi
  801f32:	89 f2                	mov    %esi,%edx
  801f34:	89 f8                	mov    %edi,%eax
  801f36:	f7 74 24 08          	divl   0x8(%esp)
  801f3a:	89 d6                	mov    %edx,%esi
  801f3c:	89 c7                	mov    %eax,%edi
  801f3e:	f7 24 24             	mull   (%esp)
  801f41:	39 d6                	cmp    %edx,%esi
  801f43:	89 14 24             	mov    %edx,(%esp)
  801f46:	72 30                	jb     801f78 <__udivdi3+0x118>
  801f48:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f4c:	89 e9                	mov    %ebp,%ecx
  801f4e:	d3 e2                	shl    %cl,%edx
  801f50:	39 c2                	cmp    %eax,%edx
  801f52:	73 05                	jae    801f59 <__udivdi3+0xf9>
  801f54:	3b 34 24             	cmp    (%esp),%esi
  801f57:	74 1f                	je     801f78 <__udivdi3+0x118>
  801f59:	89 f8                	mov    %edi,%eax
  801f5b:	31 d2                	xor    %edx,%edx
  801f5d:	e9 7a ff ff ff       	jmp    801edc <__udivdi3+0x7c>
  801f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f68:	31 d2                	xor    %edx,%edx
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	e9 68 ff ff ff       	jmp    801edc <__udivdi3+0x7c>
  801f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f78:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	83 c4 0c             	add    $0xc,%esp
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    
  801f84:	66 90                	xchg   %ax,%ax
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	66 90                	xchg   %ax,%ax
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	66 90                	xchg   %ax,%ax
  801f8e:	66 90                	xchg   %ax,%ax

00801f90 <__umoddi3>:
  801f90:	55                   	push   %ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	83 ec 14             	sub    $0x14,%esp
  801f96:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fa2:	89 c7                	mov    %eax,%edi
  801fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fb0:	89 34 24             	mov    %esi,(%esp)
  801fb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fbf:	75 17                	jne    801fd8 <__umoddi3+0x48>
  801fc1:	39 fe                	cmp    %edi,%esi
  801fc3:	76 4b                	jbe    802010 <__umoddi3+0x80>
  801fc5:	89 c8                	mov    %ecx,%eax
  801fc7:	89 fa                	mov    %edi,%edx
  801fc9:	f7 f6                	div    %esi
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	31 d2                	xor    %edx,%edx
  801fcf:	83 c4 14             	add    $0x14,%esp
  801fd2:	5e                   	pop    %esi
  801fd3:	5f                   	pop    %edi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	39 f8                	cmp    %edi,%eax
  801fda:	77 54                	ja     802030 <__umoddi3+0xa0>
  801fdc:	0f bd e8             	bsr    %eax,%ebp
  801fdf:	83 f5 1f             	xor    $0x1f,%ebp
  801fe2:	75 5c                	jne    802040 <__umoddi3+0xb0>
  801fe4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fe8:	39 3c 24             	cmp    %edi,(%esp)
  801feb:	0f 87 e7 00 00 00    	ja     8020d8 <__umoddi3+0x148>
  801ff1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801ff5:	29 f1                	sub    %esi,%ecx
  801ff7:	19 c7                	sbb    %eax,%edi
  801ff9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ffd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802001:	8b 44 24 08          	mov    0x8(%esp),%eax
  802005:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802009:	83 c4 14             	add    $0x14,%esp
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    
  802010:	85 f6                	test   %esi,%esi
  802012:	89 f5                	mov    %esi,%ebp
  802014:	75 0b                	jne    802021 <__umoddi3+0x91>
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	31 d2                	xor    %edx,%edx
  80201d:	f7 f6                	div    %esi
  80201f:	89 c5                	mov    %eax,%ebp
  802021:	8b 44 24 04          	mov    0x4(%esp),%eax
  802025:	31 d2                	xor    %edx,%edx
  802027:	f7 f5                	div    %ebp
  802029:	89 c8                	mov    %ecx,%eax
  80202b:	f7 f5                	div    %ebp
  80202d:	eb 9c                	jmp    801fcb <__umoddi3+0x3b>
  80202f:	90                   	nop
  802030:	89 c8                	mov    %ecx,%eax
  802032:	89 fa                	mov    %edi,%edx
  802034:	83 c4 14             	add    $0x14,%esp
  802037:	5e                   	pop    %esi
  802038:	5f                   	pop    %edi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    
  80203b:	90                   	nop
  80203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802040:	8b 04 24             	mov    (%esp),%eax
  802043:	be 20 00 00 00       	mov    $0x20,%esi
  802048:	89 e9                	mov    %ebp,%ecx
  80204a:	29 ee                	sub    %ebp,%esi
  80204c:	d3 e2                	shl    %cl,%edx
  80204e:	89 f1                	mov    %esi,%ecx
  802050:	d3 e8                	shr    %cl,%eax
  802052:	89 e9                	mov    %ebp,%ecx
  802054:	89 44 24 04          	mov    %eax,0x4(%esp)
  802058:	8b 04 24             	mov    (%esp),%eax
  80205b:	09 54 24 04          	or     %edx,0x4(%esp)
  80205f:	89 fa                	mov    %edi,%edx
  802061:	d3 e0                	shl    %cl,%eax
  802063:	89 f1                	mov    %esi,%ecx
  802065:	89 44 24 08          	mov    %eax,0x8(%esp)
  802069:	8b 44 24 10          	mov    0x10(%esp),%eax
  80206d:	d3 ea                	shr    %cl,%edx
  80206f:	89 e9                	mov    %ebp,%ecx
  802071:	d3 e7                	shl    %cl,%edi
  802073:	89 f1                	mov    %esi,%ecx
  802075:	d3 e8                	shr    %cl,%eax
  802077:	89 e9                	mov    %ebp,%ecx
  802079:	09 f8                	or     %edi,%eax
  80207b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80207f:	f7 74 24 04          	divl   0x4(%esp)
  802083:	d3 e7                	shl    %cl,%edi
  802085:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802089:	89 d7                	mov    %edx,%edi
  80208b:	f7 64 24 08          	mull   0x8(%esp)
  80208f:	39 d7                	cmp    %edx,%edi
  802091:	89 c1                	mov    %eax,%ecx
  802093:	89 14 24             	mov    %edx,(%esp)
  802096:	72 2c                	jb     8020c4 <__umoddi3+0x134>
  802098:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80209c:	72 22                	jb     8020c0 <__umoddi3+0x130>
  80209e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020a2:	29 c8                	sub    %ecx,%eax
  8020a4:	19 d7                	sbb    %edx,%edi
  8020a6:	89 e9                	mov    %ebp,%ecx
  8020a8:	89 fa                	mov    %edi,%edx
  8020aa:	d3 e8                	shr    %cl,%eax
  8020ac:	89 f1                	mov    %esi,%ecx
  8020ae:	d3 e2                	shl    %cl,%edx
  8020b0:	89 e9                	mov    %ebp,%ecx
  8020b2:	d3 ef                	shr    %cl,%edi
  8020b4:	09 d0                	or     %edx,%eax
  8020b6:	89 fa                	mov    %edi,%edx
  8020b8:	83 c4 14             	add    $0x14,%esp
  8020bb:	5e                   	pop    %esi
  8020bc:	5f                   	pop    %edi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    
  8020bf:	90                   	nop
  8020c0:	39 d7                	cmp    %edx,%edi
  8020c2:	75 da                	jne    80209e <__umoddi3+0x10e>
  8020c4:	8b 14 24             	mov    (%esp),%edx
  8020c7:	89 c1                	mov    %eax,%ecx
  8020c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020d1:	eb cb                	jmp    80209e <__umoddi3+0x10e>
  8020d3:	90                   	nop
  8020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020dc:	0f 82 0f ff ff ff    	jb     801ff1 <__umoddi3+0x61>
  8020e2:	e9 1a ff ff ff       	jmp    802001 <__umoddi3+0x71>
