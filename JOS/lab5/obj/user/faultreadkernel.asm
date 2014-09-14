
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 e0 20 80 00 	movl   $0x8020e0,(%esp)
  800049:	e8 36 01 00 00       	call   800184 <cprintf>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  80005e:	e8 e8 0b 00 00       	call   800c4b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800063:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800069:	39 c2                	cmp    %eax,%edx
  80006b:	74 17                	je     800084 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80006d:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800072:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800075:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80007b:	8b 49 40             	mov    0x40(%ecx),%ecx
  80007e:	39 c1                	cmp    %eax,%ecx
  800080:	75 18                	jne    80009a <libmain+0x4a>
  800082:	eb 05                	jmp    800089 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800084:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800089:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80008c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800092:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800098:	eb 0b                	jmp    8000a5 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80009a:	83 c2 01             	add    $0x1,%edx
  80009d:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000a3:	75 cd                	jne    800072 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x60>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b4:	89 1c 24             	mov    %ebx,(%esp)
  8000b7:	e8 77 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000bc:	e8 07 00 00 00       	call   8000c8 <exit>
}
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	5b                   	pop    %ebx
  8000c5:	5e                   	pop    %esi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ce:	e8 43 10 00 00       	call   801116 <close_all>
	sys_env_destroy(0);
  8000d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000da:	e8 1a 0b 00 00       	call   800bf9 <sys_env_destroy>
}
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 14             	sub    $0x14,%esp
  8000e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000eb:	8b 13                	mov    (%ebx),%edx
  8000ed:	8d 42 01             	lea    0x1(%edx),%eax
  8000f0:	89 03                	mov    %eax,(%ebx)
  8000f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fe:	75 19                	jne    800119 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800100:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800107:	00 
  800108:	8d 43 08             	lea    0x8(%ebx),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 a9 0a 00 00       	call   800bbc <sys_cputs>
		b->idx = 0;
  800113:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	83 c4 14             	add    $0x14,%esp
  800120:	5b                   	pop    %ebx
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80012c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800133:	00 00 00 
	b.cnt = 0;
  800136:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800140:	8b 45 0c             	mov    0xc(%ebp),%eax
  800143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800147:	8b 45 08             	mov    0x8(%ebp),%eax
  80014a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80014e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800154:	89 44 24 04          	mov    %eax,0x4(%esp)
  800158:	c7 04 24 e1 00 80 00 	movl   $0x8000e1,(%esp)
  80015f:	e8 b0 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800164:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80016a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 40 0a 00 00       	call   800bbc <sys_cputs>

	return b.cnt;
}
  80017c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	8b 45 08             	mov    0x8(%ebp),%eax
  800194:	89 04 24             	mov    %eax,(%esp)
  800197:	e8 87 ff ff ff       	call   800123 <vcprintf>
	va_end(ap);

	return cnt;
}
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    
  80019e:	66 90                	xchg   %ax,%ax

008001a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	57                   	push   %edi
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
  8001a6:	83 ec 3c             	sub    $0x3c,%esp
  8001a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001ac:	89 d7                	mov    %edx,%edi
  8001ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8001b7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8001ba:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c8:	39 f1                	cmp    %esi,%ecx
  8001ca:	72 14                	jb     8001e0 <printnum+0x40>
  8001cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001cf:	76 0f                	jbe    8001e0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001d4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8001d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001da:	85 f6                	test   %esi,%esi
  8001dc:	7f 60                	jg     80023e <printnum+0x9e>
  8001de:	eb 72                	jmp    800252 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001e3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8001ea:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8001ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001f9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001fd:	89 c3                	mov    %eax,%ebx
  8001ff:	89 d6                	mov    %edx,%esi
  800201:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800204:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800207:	89 54 24 08          	mov    %edx,0x8(%esp)
  80020b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80020f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800212:	89 04 24             	mov    %eax,(%esp)
  800215:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021c:	e8 2f 1c 00 00       	call   801e50 <__udivdi3>
  800221:	89 d9                	mov    %ebx,%ecx
  800223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800227:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80022b:	89 04 24             	mov    %eax,(%esp)
  80022e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800232:	89 fa                	mov    %edi,%edx
  800234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800237:	e8 64 ff ff ff       	call   8001a0 <printnum>
  80023c:	eb 14                	jmp    800252 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800242:	8b 45 18             	mov    0x18(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80024a:	83 ee 01             	sub    $0x1,%esi
  80024d:	75 ef                	jne    80023e <printnum+0x9e>
  80024f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800252:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800256:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80025a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80025d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800260:	89 44 24 08          	mov    %eax,0x8(%esp)
  800264:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800271:	89 44 24 04          	mov    %eax,0x4(%esp)
  800275:	e8 06 1d 00 00       	call   801f80 <__umoddi3>
  80027a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80027e:	0f be 80 11 21 80 00 	movsbl 0x802111(%eax),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	ff d0                	call   *%eax
}
  80028d:	83 c4 3c             	add    $0x3c,%esp
  800290:	5b                   	pop    %ebx
  800291:	5e                   	pop    %esi
  800292:	5f                   	pop    %edi
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800298:	83 fa 01             	cmp    $0x1,%edx
  80029b:	7e 0e                	jle    8002ab <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80029d:	8b 10                	mov    (%eax),%edx
  80029f:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 02                	mov    (%edx),%eax
  8002a6:	8b 52 04             	mov    0x4(%edx),%edx
  8002a9:	eb 22                	jmp    8002cd <getuint+0x38>
	else if (lflag)
  8002ab:	85 d2                	test   %edx,%edx
  8002ad:	74 10                	je     8002bf <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002af:	8b 10                	mov    (%eax),%edx
  8002b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b4:	89 08                	mov    %ecx,(%eax)
  8002b6:	8b 02                	mov    (%edx),%eax
  8002b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002bd:	eb 0e                	jmp    8002cd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002bf:	8b 10                	mov    (%eax),%edx
  8002c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c4:	89 08                	mov    %ecx,(%eax)
  8002c6:	8b 02                	mov    (%edx),%eax
  8002c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	3b 50 04             	cmp    0x4(%eax),%edx
  8002de:	73 0a                	jae    8002ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e3:	89 08                	mov    %ecx,(%eax)
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	88 02                	mov    %al,(%edx)
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	89 44 24 04          	mov    %eax,0x4(%esp)
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	89 04 24             	mov    %eax,(%esp)
  80030d:	e8 02 00 00 00       	call   800314 <vprintfmt>
	va_end(ap);
}
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 3c             	sub    $0x3c,%esp
  80031d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800320:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800323:	eb 18                	jmp    80033d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800325:	85 c0                	test   %eax,%eax
  800327:	0f 84 c3 03 00 00    	je     8006f0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80032d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800331:	89 04 24             	mov    %eax,(%esp)
  800334:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800337:	89 f3                	mov    %esi,%ebx
  800339:	eb 02                	jmp    80033d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80033b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80033d:	8d 73 01             	lea    0x1(%ebx),%esi
  800340:	0f b6 03             	movzbl (%ebx),%eax
  800343:	83 f8 25             	cmp    $0x25,%eax
  800346:	75 dd                	jne    800325 <vprintfmt+0x11>
  800348:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80034c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800353:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80035a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	eb 1d                	jmp    800385 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800368:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80036a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80036e:	eb 15                	jmp    800385 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800370:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800372:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800376:	eb 0d                	jmp    800385 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80037b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8d 5e 01             	lea    0x1(%esi),%ebx
  800388:	0f b6 06             	movzbl (%esi),%eax
  80038b:	0f b6 c8             	movzbl %al,%ecx
  80038e:	83 e8 23             	sub    $0x23,%eax
  800391:	3c 55                	cmp    $0x55,%al
  800393:	0f 87 2f 03 00 00    	ja     8006c8 <vprintfmt+0x3b4>
  800399:	0f b6 c0             	movzbl %al,%eax
  80039c:	ff 24 85 60 22 80 00 	jmp    *0x802260(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003a3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8003a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8003a9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003ad:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8003b0:	83 f9 09             	cmp    $0x9,%ecx
  8003b3:	77 50                	ja     800405 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	89 de                	mov    %ebx,%esi
  8003b7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ba:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8003bd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003c0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003c4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003c7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ca:	83 fb 09             	cmp    $0x9,%ebx
  8003cd:	76 eb                	jbe    8003ba <vprintfmt+0xa6>
  8003cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8003d2:	eb 33                	jmp    800407 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8d 48 04             	lea    0x4(%eax),%ecx
  8003da:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003e4:	eb 21                	jmp    800407 <vprintfmt+0xf3>
  8003e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e9:	85 c9                	test   %ecx,%ecx
  8003eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f0:	0f 49 c1             	cmovns %ecx,%eax
  8003f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	89 de                	mov    %ebx,%esi
  8003f8:	eb 8b                	jmp    800385 <vprintfmt+0x71>
  8003fa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003fc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800403:	eb 80                	jmp    800385 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800405:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800407:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80040b:	0f 89 74 ff ff ff    	jns    800385 <vprintfmt+0x71>
  800411:	e9 62 ff ff ff       	jmp    800378 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800416:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800419:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80041b:	e9 65 ff ff ff       	jmp    800385 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8d 50 04             	lea    0x4(%eax),%edx
  800426:	89 55 14             	mov    %edx,0x14(%ebp)
  800429:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 04 24             	mov    %eax,(%esp)
  800432:	ff 55 08             	call   *0x8(%ebp)
			break;
  800435:	e9 03 ff ff ff       	jmp    80033d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80043a:	8b 45 14             	mov    0x14(%ebp),%eax
  80043d:	8d 50 04             	lea    0x4(%eax),%edx
  800440:	89 55 14             	mov    %edx,0x14(%ebp)
  800443:	8b 00                	mov    (%eax),%eax
  800445:	99                   	cltd   
  800446:	31 d0                	xor    %edx,%eax
  800448:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044a:	83 f8 0f             	cmp    $0xf,%eax
  80044d:	7f 0b                	jg     80045a <vprintfmt+0x146>
  80044f:	8b 14 85 c0 23 80 00 	mov    0x8023c0(,%eax,4),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	75 20                	jne    80047a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80045a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045e:	c7 44 24 08 29 21 80 	movl   $0x802129,0x8(%esp)
  800465:	00 
  800466:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 04 24             	mov    %eax,(%esp)
  800470:	e8 77 fe ff ff       	call   8002ec <printfmt>
  800475:	e9 c3 fe ff ff       	jmp    80033d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80047a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047e:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800485:	00 
  800486:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 04 24             	mov    %eax,(%esp)
  800490:	e8 57 fe ff ff       	call   8002ec <printfmt>
  800495:	e9 a3 fe ff ff       	jmp    80033d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80049d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a3:	8d 50 04             	lea    0x4(%eax),%edx
  8004a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	ba 22 21 80 00       	mov    $0x802122,%edx
  8004b2:	0f 45 d0             	cmovne %eax,%edx
  8004b5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8004b8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8004bc:	74 04                	je     8004c2 <vprintfmt+0x1ae>
  8004be:	85 f6                	test   %esi,%esi
  8004c0:	7f 19                	jg     8004db <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c5:	8d 70 01             	lea    0x1(%eax),%esi
  8004c8:	0f b6 10             	movzbl (%eax),%edx
  8004cb:	0f be c2             	movsbl %dl,%eax
  8004ce:	85 c0                	test   %eax,%eax
  8004d0:	0f 85 95 00 00 00    	jne    80056b <vprintfmt+0x257>
  8004d6:	e9 85 00 00 00       	jmp    800560 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e2:	89 04 24             	mov    %eax,(%esp)
  8004e5:	e8 b8 02 00 00       	call   8007a2 <strnlen>
  8004ea:	29 c6                	sub    %eax,%esi
  8004ec:	89 f0                	mov    %esi,%eax
  8004ee:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	7e cd                	jle    8004c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8004f5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8004f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004fc:	89 c3                	mov    %eax,%ebx
  8004fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800502:	89 34 24             	mov    %esi,(%esp)
  800505:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800508:	83 eb 01             	sub    $0x1,%ebx
  80050b:	75 f1                	jne    8004fe <vprintfmt+0x1ea>
  80050d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800510:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800513:	eb ad                	jmp    8004c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800515:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800519:	74 1e                	je     800539 <vprintfmt+0x225>
  80051b:	0f be d2             	movsbl %dl,%edx
  80051e:	83 ea 20             	sub    $0x20,%edx
  800521:	83 fa 5e             	cmp    $0x5e,%edx
  800524:	76 13                	jbe    800539 <vprintfmt+0x225>
					putch('?', putdat);
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800534:	ff 55 08             	call   *0x8(%ebp)
  800537:	eb 0d                	jmp    800546 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800546:	83 ef 01             	sub    $0x1,%edi
  800549:	83 c6 01             	add    $0x1,%esi
  80054c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800550:	0f be c2             	movsbl %dl,%eax
  800553:	85 c0                	test   %eax,%eax
  800555:	75 20                	jne    800577 <vprintfmt+0x263>
  800557:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80055a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80055d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800564:	7f 25                	jg     80058b <vprintfmt+0x277>
  800566:	e9 d2 fd ff ff       	jmp    80033d <vprintfmt+0x29>
  80056b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800571:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800574:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800577:	85 db                	test   %ebx,%ebx
  800579:	78 9a                	js     800515 <vprintfmt+0x201>
  80057b:	83 eb 01             	sub    $0x1,%ebx
  80057e:	79 95                	jns    800515 <vprintfmt+0x201>
  800580:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800583:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800586:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800589:	eb d5                	jmp    800560 <vprintfmt+0x24c>
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800594:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800598:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80059f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	75 ee                	jne    800594 <vprintfmt+0x280>
  8005a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005a9:	e9 8f fd ff ff       	jmp    80033d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005ae:	83 fa 01             	cmp    $0x1,%edx
  8005b1:	7e 16                	jle    8005c9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8d 50 08             	lea    0x8(%eax),%edx
  8005b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c7:	eb 32                	jmp    8005fb <vprintfmt+0x2e7>
	else if (lflag)
  8005c9:	85 d2                	test   %edx,%edx
  8005cb:	74 18                	je     8005e5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8d 50 04             	lea    0x4(%eax),%edx
  8005d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d6:	8b 30                	mov    (%eax),%esi
  8005d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005db:	89 f0                	mov    %esi,%eax
  8005dd:	c1 f8 1f             	sar    $0x1f,%eax
  8005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e3:	eb 16                	jmp    8005fb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ee:	8b 30                	mov    (%eax),%esi
  8005f0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005f3:	89 f0                	mov    %esi,%eax
  8005f5:	c1 f8 1f             	sar    $0x1f,%eax
  8005f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800601:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800606:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80060a:	0f 89 80 00 00 00    	jns    800690 <vprintfmt+0x37c>
				putch('-', putdat);
  800610:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800614:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80061b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80061e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800624:	f7 d8                	neg    %eax
  800626:	83 d2 00             	adc    $0x0,%edx
  800629:	f7 da                	neg    %edx
			}
			base = 10;
  80062b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800630:	eb 5e                	jmp    800690 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800632:	8d 45 14             	lea    0x14(%ebp),%eax
  800635:	e8 5b fc ff ff       	call   800295 <getuint>
			base = 10;
  80063a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80063f:	eb 4f                	jmp    800690 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800641:	8d 45 14             	lea    0x14(%ebp),%eax
  800644:	e8 4c fc ff ff       	call   800295 <getuint>
			base = 8;
  800649:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80064e:	eb 40                	jmp    800690 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800650:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800654:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80065b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80065e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800662:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800669:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80067c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800681:	eb 0d                	jmp    800690 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800683:	8d 45 14             	lea    0x14(%ebp),%eax
  800686:	e8 0a fc ff ff       	call   800295 <getuint>
			base = 16;
  80068b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800690:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800694:	89 74 24 10          	mov    %esi,0x10(%esp)
  800698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80069b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80069f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006a3:	89 04 24             	mov    %eax,(%esp)
  8006a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006aa:	89 fa                	mov    %edi,%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	e8 ec fa ff ff       	call   8001a0 <printnum>
			break;
  8006b4:	e9 84 fc ff ff       	jmp    80033d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bd:	89 0c 24             	mov    %ecx,(%esp)
  8006c0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006c3:	e9 75 fc ff ff       	jmp    80033d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006d3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8006da:	0f 84 5b fc ff ff    	je     80033b <vprintfmt+0x27>
  8006e0:	89 f3                	mov    %esi,%ebx
  8006e2:	83 eb 01             	sub    $0x1,%ebx
  8006e5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006e9:	75 f7                	jne    8006e2 <vprintfmt+0x3ce>
  8006eb:	e9 4d fc ff ff       	jmp    80033d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8006f0:	83 c4 3c             	add    $0x3c,%esp
  8006f3:	5b                   	pop    %ebx
  8006f4:	5e                   	pop    %esi
  8006f5:	5f                   	pop    %edi
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 28             	sub    $0x28,%esp
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800707:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80070b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800715:	85 c0                	test   %eax,%eax
  800717:	74 30                	je     800749 <vsnprintf+0x51>
  800719:	85 d2                	test   %edx,%edx
  80071b:	7e 2c                	jle    800749 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800724:	8b 45 10             	mov    0x10(%ebp),%eax
  800727:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800732:	c7 04 24 cf 02 80 00 	movl   $0x8002cf,(%esp)
  800739:	e8 d6 fb ff ff       	call   800314 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800741:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800747:	eb 05                	jmp    80074e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800749:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800756:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800759:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80075d:	8b 45 10             	mov    0x10(%ebp),%eax
  800760:	89 44 24 08          	mov    %eax,0x8(%esp)
  800764:	8b 45 0c             	mov    0xc(%ebp),%eax
  800767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	e8 82 ff ff ff       	call   8006f8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800776:	c9                   	leave  
  800777:	c3                   	ret    
  800778:	66 90                	xchg   %ax,%ax
  80077a:	66 90                	xchg   %ax,%ax
  80077c:	66 90                	xchg   %ax,%ax
  80077e:	66 90                	xchg   %ax,%ax

00800780 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800786:	80 3a 00             	cmpb   $0x0,(%edx)
  800789:	74 10                	je     80079b <strlen+0x1b>
  80078b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800790:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800793:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800797:	75 f7                	jne    800790 <strlen+0x10>
  800799:	eb 05                	jmp    8007a0 <strlen+0x20>
  80079b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	53                   	push   %ebx
  8007a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ac:	85 c9                	test   %ecx,%ecx
  8007ae:	74 1c                	je     8007cc <strnlen+0x2a>
  8007b0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007b3:	74 1e                	je     8007d3 <strnlen+0x31>
  8007b5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8007ba:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bc:	39 ca                	cmp    %ecx,%edx
  8007be:	74 18                	je     8007d8 <strnlen+0x36>
  8007c0:	83 c2 01             	add    $0x1,%edx
  8007c3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8007c8:	75 f0                	jne    8007ba <strnlen+0x18>
  8007ca:	eb 0c                	jmp    8007d8 <strnlen+0x36>
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d1:	eb 05                	jmp    8007d8 <strnlen+0x36>
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	53                   	push   %ebx
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	83 c2 01             	add    $0x1,%edx
  8007ea:	83 c1 01             	add    $0x1,%ecx
  8007ed:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f4:	84 db                	test   %bl,%bl
  8007f6:	75 ef                	jne    8007e7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f8:	5b                   	pop    %ebx
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	53                   	push   %ebx
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800805:	89 1c 24             	mov    %ebx,(%esp)
  800808:	e8 73 ff ff ff       	call   800780 <strlen>
	strcpy(dst + len, src);
  80080d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800810:	89 54 24 04          	mov    %edx,0x4(%esp)
  800814:	01 d8                	add    %ebx,%eax
  800816:	89 04 24             	mov    %eax,(%esp)
  800819:	e8 bd ff ff ff       	call   8007db <strcpy>
	return dst;
}
  80081e:	89 d8                	mov    %ebx,%eax
  800820:	83 c4 08             	add    $0x8,%esp
  800823:	5b                   	pop    %ebx
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	56                   	push   %esi
  80082a:	53                   	push   %ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800831:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800834:	85 db                	test   %ebx,%ebx
  800836:	74 17                	je     80084f <strncpy+0x29>
  800838:	01 f3                	add    %esi,%ebx
  80083a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80083c:	83 c1 01             	add    $0x1,%ecx
  80083f:	0f b6 02             	movzbl (%edx),%eax
  800842:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800845:	80 3a 01             	cmpb   $0x1,(%edx)
  800848:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80084b:	39 d9                	cmp    %ebx,%ecx
  80084d:	75 ed                	jne    80083c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80084f:	89 f0                	mov    %esi,%eax
  800851:	5b                   	pop    %ebx
  800852:	5e                   	pop    %esi
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	57                   	push   %edi
  800859:	56                   	push   %esi
  80085a:	53                   	push   %ebx
  80085b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80085e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800861:	8b 75 10             	mov    0x10(%ebp),%esi
  800864:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800866:	85 f6                	test   %esi,%esi
  800868:	74 34                	je     80089e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80086a:	83 fe 01             	cmp    $0x1,%esi
  80086d:	74 26                	je     800895 <strlcpy+0x40>
  80086f:	0f b6 0b             	movzbl (%ebx),%ecx
  800872:	84 c9                	test   %cl,%cl
  800874:	74 23                	je     800899 <strlcpy+0x44>
  800876:	83 ee 02             	sub    $0x2,%esi
  800879:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80087e:	83 c0 01             	add    $0x1,%eax
  800881:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800884:	39 f2                	cmp    %esi,%edx
  800886:	74 13                	je     80089b <strlcpy+0x46>
  800888:	83 c2 01             	add    $0x1,%edx
  80088b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80088f:	84 c9                	test   %cl,%cl
  800891:	75 eb                	jne    80087e <strlcpy+0x29>
  800893:	eb 06                	jmp    80089b <strlcpy+0x46>
  800895:	89 f8                	mov    %edi,%eax
  800897:	eb 02                	jmp    80089b <strlcpy+0x46>
  800899:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80089b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80089e:	29 f8                	sub    %edi,%eax
}
  8008a0:	5b                   	pop    %ebx
  8008a1:	5e                   	pop    %esi
  8008a2:	5f                   	pop    %edi
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ae:	0f b6 01             	movzbl (%ecx),%eax
  8008b1:	84 c0                	test   %al,%al
  8008b3:	74 15                	je     8008ca <strcmp+0x25>
  8008b5:	3a 02                	cmp    (%edx),%al
  8008b7:	75 11                	jne    8008ca <strcmp+0x25>
		p++, q++;
  8008b9:	83 c1 01             	add    $0x1,%ecx
  8008bc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008bf:	0f b6 01             	movzbl (%ecx),%eax
  8008c2:	84 c0                	test   %al,%al
  8008c4:	74 04                	je     8008ca <strcmp+0x25>
  8008c6:	3a 02                	cmp    (%edx),%al
  8008c8:	74 ef                	je     8008b9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ca:	0f b6 c0             	movzbl %al,%eax
  8008cd:	0f b6 12             	movzbl (%edx),%edx
  8008d0:	29 d0                	sub    %edx,%eax
}
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	56                   	push   %esi
  8008d8:	53                   	push   %ebx
  8008d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008df:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8008e2:	85 f6                	test   %esi,%esi
  8008e4:	74 29                	je     80090f <strncmp+0x3b>
  8008e6:	0f b6 03             	movzbl (%ebx),%eax
  8008e9:	84 c0                	test   %al,%al
  8008eb:	74 30                	je     80091d <strncmp+0x49>
  8008ed:	3a 02                	cmp    (%edx),%al
  8008ef:	75 2c                	jne    80091d <strncmp+0x49>
  8008f1:	8d 43 01             	lea    0x1(%ebx),%eax
  8008f4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8008f6:	89 c3                	mov    %eax,%ebx
  8008f8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008fb:	39 f0                	cmp    %esi,%eax
  8008fd:	74 17                	je     800916 <strncmp+0x42>
  8008ff:	0f b6 08             	movzbl (%eax),%ecx
  800902:	84 c9                	test   %cl,%cl
  800904:	74 17                	je     80091d <strncmp+0x49>
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	3a 0a                	cmp    (%edx),%cl
  80090b:	74 e9                	je     8008f6 <strncmp+0x22>
  80090d:	eb 0e                	jmp    80091d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	eb 0f                	jmp    800925 <strncmp+0x51>
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 08                	jmp    800925 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091d:	0f b6 03             	movzbl (%ebx),%eax
  800920:	0f b6 12             	movzbl (%edx),%edx
  800923:	29 d0                	sub    %edx,%eax
}
  800925:	5b                   	pop    %ebx
  800926:	5e                   	pop    %esi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	53                   	push   %ebx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800933:	0f b6 18             	movzbl (%eax),%ebx
  800936:	84 db                	test   %bl,%bl
  800938:	74 1d                	je     800957 <strchr+0x2e>
  80093a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80093c:	38 d3                	cmp    %dl,%bl
  80093e:	75 06                	jne    800946 <strchr+0x1d>
  800940:	eb 1a                	jmp    80095c <strchr+0x33>
  800942:	38 ca                	cmp    %cl,%dl
  800944:	74 16                	je     80095c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800946:	83 c0 01             	add    $0x1,%eax
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	84 d2                	test   %dl,%dl
  80094e:	75 f2                	jne    800942 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
  800955:	eb 05                	jmp    80095c <strchr+0x33>
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095c:	5b                   	pop    %ebx
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	53                   	push   %ebx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800969:	0f b6 18             	movzbl (%eax),%ebx
  80096c:	84 db                	test   %bl,%bl
  80096e:	74 16                	je     800986 <strfind+0x27>
  800970:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800972:	38 d3                	cmp    %dl,%bl
  800974:	75 06                	jne    80097c <strfind+0x1d>
  800976:	eb 0e                	jmp    800986 <strfind+0x27>
  800978:	38 ca                	cmp    %cl,%dl
  80097a:	74 0a                	je     800986 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	0f b6 10             	movzbl (%eax),%edx
  800982:	84 d2                	test   %dl,%dl
  800984:	75 f2                	jne    800978 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800986:	5b                   	pop    %ebx
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	57                   	push   %edi
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800992:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800995:	85 c9                	test   %ecx,%ecx
  800997:	74 36                	je     8009cf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800999:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099f:	75 28                	jne    8009c9 <memset+0x40>
  8009a1:	f6 c1 03             	test   $0x3,%cl
  8009a4:	75 23                	jne    8009c9 <memset+0x40>
		c &= 0xFF;
  8009a6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009aa:	89 d3                	mov    %edx,%ebx
  8009ac:	c1 e3 08             	shl    $0x8,%ebx
  8009af:	89 d6                	mov    %edx,%esi
  8009b1:	c1 e6 18             	shl    $0x18,%esi
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 10             	shl    $0x10,%eax
  8009b9:	09 f0                	or     %esi,%eax
  8009bb:	09 c2                	or     %eax,%edx
  8009bd:	89 d0                	mov    %edx,%eax
  8009bf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009c4:	fc                   	cld    
  8009c5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c7:	eb 06                	jmp    8009cf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	fc                   	cld    
  8009cd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cf:	89 f8                	mov    %edi,%eax
  8009d1:	5b                   	pop    %ebx
  8009d2:	5e                   	pop    %esi
  8009d3:	5f                   	pop    %edi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	57                   	push   %edi
  8009da:	56                   	push   %esi
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e4:	39 c6                	cmp    %eax,%esi
  8009e6:	73 35                	jae    800a1d <memmove+0x47>
  8009e8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009eb:	39 d0                	cmp    %edx,%eax
  8009ed:	73 2e                	jae    800a1d <memmove+0x47>
		s += n;
		d += n;
  8009ef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009f2:	89 d6                	mov    %edx,%esi
  8009f4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fc:	75 13                	jne    800a11 <memmove+0x3b>
  8009fe:	f6 c1 03             	test   $0x3,%cl
  800a01:	75 0e                	jne    800a11 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a03:	83 ef 04             	sub    $0x4,%edi
  800a06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a09:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a0c:	fd                   	std    
  800a0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0f:	eb 09                	jmp    800a1a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a11:	83 ef 01             	sub    $0x1,%edi
  800a14:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a17:	fd                   	std    
  800a18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1a:	fc                   	cld    
  800a1b:	eb 1d                	jmp    800a3a <memmove+0x64>
  800a1d:	89 f2                	mov    %esi,%edx
  800a1f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a21:	f6 c2 03             	test   $0x3,%dl
  800a24:	75 0f                	jne    800a35 <memmove+0x5f>
  800a26:	f6 c1 03             	test   $0x3,%cl
  800a29:	75 0a                	jne    800a35 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a2b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a2e:	89 c7                	mov    %eax,%edi
  800a30:	fc                   	cld    
  800a31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a33:	eb 05                	jmp    800a3a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a35:	89 c7                	mov    %eax,%edi
  800a37:	fc                   	cld    
  800a38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a3a:	5e                   	pop    %esi
  800a3b:	5f                   	pop    %edi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a44:	8b 45 10             	mov    0x10(%ebp),%eax
  800a47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 04 24             	mov    %eax,(%esp)
  800a58:	e8 79 ff ff ff       	call   8009d6 <memmove>
}
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800a71:	85 c0                	test   %eax,%eax
  800a73:	74 36                	je     800aab <memcmp+0x4c>
		if (*s1 != *s2)
  800a75:	0f b6 03             	movzbl (%ebx),%eax
  800a78:	0f b6 0e             	movzbl (%esi),%ecx
  800a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a80:	38 c8                	cmp    %cl,%al
  800a82:	74 1c                	je     800aa0 <memcmp+0x41>
  800a84:	eb 10                	jmp    800a96 <memcmp+0x37>
  800a86:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800a8b:	83 c2 01             	add    $0x1,%edx
  800a8e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800a92:	38 c8                	cmp    %cl,%al
  800a94:	74 0a                	je     800aa0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800a96:	0f b6 c0             	movzbl %al,%eax
  800a99:	0f b6 c9             	movzbl %cl,%ecx
  800a9c:	29 c8                	sub    %ecx,%eax
  800a9e:	eb 10                	jmp    800ab0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa0:	39 fa                	cmp    %edi,%edx
  800aa2:	75 e2                	jne    800a86 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	eb 05                	jmp    800ab0 <memcmp+0x51>
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	53                   	push   %ebx
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800abf:	89 c2                	mov    %eax,%edx
  800ac1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac4:	39 d0                	cmp    %edx,%eax
  800ac6:	73 13                	jae    800adb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac8:	89 d9                	mov    %ebx,%ecx
  800aca:	38 18                	cmp    %bl,(%eax)
  800acc:	75 06                	jne    800ad4 <memfind+0x1f>
  800ace:	eb 0b                	jmp    800adb <memfind+0x26>
  800ad0:	38 08                	cmp    %cl,(%eax)
  800ad2:	74 07                	je     800adb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	39 d0                	cmp    %edx,%eax
  800ad9:	75 f5                	jne    800ad0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800adb:	5b                   	pop    %ebx
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	57                   	push   %edi
  800ae2:	56                   	push   %esi
  800ae3:	53                   	push   %ebx
  800ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aea:	0f b6 0a             	movzbl (%edx),%ecx
  800aed:	80 f9 09             	cmp    $0x9,%cl
  800af0:	74 05                	je     800af7 <strtol+0x19>
  800af2:	80 f9 20             	cmp    $0x20,%cl
  800af5:	75 10                	jne    800b07 <strtol+0x29>
		s++;
  800af7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afa:	0f b6 0a             	movzbl (%edx),%ecx
  800afd:	80 f9 09             	cmp    $0x9,%cl
  800b00:	74 f5                	je     800af7 <strtol+0x19>
  800b02:	80 f9 20             	cmp    $0x20,%cl
  800b05:	74 f0                	je     800af7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b07:	80 f9 2b             	cmp    $0x2b,%cl
  800b0a:	75 0a                	jne    800b16 <strtol+0x38>
		s++;
  800b0c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b14:	eb 11                	jmp    800b27 <strtol+0x49>
  800b16:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b1b:	80 f9 2d             	cmp    $0x2d,%cl
  800b1e:	75 07                	jne    800b27 <strtol+0x49>
		s++, neg = 1;
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b27:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b2c:	75 15                	jne    800b43 <strtol+0x65>
  800b2e:	80 3a 30             	cmpb   $0x30,(%edx)
  800b31:	75 10                	jne    800b43 <strtol+0x65>
  800b33:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b37:	75 0a                	jne    800b43 <strtol+0x65>
		s += 2, base = 16;
  800b39:	83 c2 02             	add    $0x2,%edx
  800b3c:	b8 10 00 00 00       	mov    $0x10,%eax
  800b41:	eb 10                	jmp    800b53 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800b43:	85 c0                	test   %eax,%eax
  800b45:	75 0c                	jne    800b53 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b47:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b49:	80 3a 30             	cmpb   $0x30,(%edx)
  800b4c:	75 05                	jne    800b53 <strtol+0x75>
		s++, base = 8;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b58:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b5b:	0f b6 0a             	movzbl (%edx),%ecx
  800b5e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b61:	89 f0                	mov    %esi,%eax
  800b63:	3c 09                	cmp    $0x9,%al
  800b65:	77 08                	ja     800b6f <strtol+0x91>
			dig = *s - '0';
  800b67:	0f be c9             	movsbl %cl,%ecx
  800b6a:	83 e9 30             	sub    $0x30,%ecx
  800b6d:	eb 20                	jmp    800b8f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800b6f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b72:	89 f0                	mov    %esi,%eax
  800b74:	3c 19                	cmp    $0x19,%al
  800b76:	77 08                	ja     800b80 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800b78:	0f be c9             	movsbl %cl,%ecx
  800b7b:	83 e9 57             	sub    $0x57,%ecx
  800b7e:	eb 0f                	jmp    800b8f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800b80:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b83:	89 f0                	mov    %esi,%eax
  800b85:	3c 19                	cmp    $0x19,%al
  800b87:	77 16                	ja     800b9f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800b89:	0f be c9             	movsbl %cl,%ecx
  800b8c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b8f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b92:	7d 0f                	jge    800ba3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b94:	83 c2 01             	add    $0x1,%edx
  800b97:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b9b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b9d:	eb bc                	jmp    800b5b <strtol+0x7d>
  800b9f:	89 d8                	mov    %ebx,%eax
  800ba1:	eb 02                	jmp    800ba5 <strtol+0xc7>
  800ba3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ba5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba9:	74 05                	je     800bb0 <strtol+0xd2>
		*endptr = (char *) s;
  800bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bae:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bb0:	f7 d8                	neg    %eax
  800bb2:	85 ff                	test   %edi,%edi
  800bb4:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bca:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcd:	89 c3                	mov    %eax,%ebx
  800bcf:	89 c7                	mov    %eax,%edi
  800bd1:	89 c6                	mov    %eax,%esi
  800bd3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <sys_cgetc>:

int
sys_cgetc(void)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	57                   	push   %edi
  800bde:	56                   	push   %esi
  800bdf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be0:	ba 00 00 00 00       	mov    $0x0,%edx
  800be5:	b8 01 00 00 00       	mov    $0x1,%eax
  800bea:	89 d1                	mov    %edx,%ecx
  800bec:	89 d3                	mov    %edx,%ebx
  800bee:	89 d7                	mov    %edx,%edi
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	89 cb                	mov    %ecx,%ebx
  800c11:	89 cf                	mov    %ecx,%edi
  800c13:	89 ce                	mov    %ecx,%esi
  800c15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c17:	85 c0                	test   %eax,%eax
  800c19:	7e 28                	jle    800c43 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c1f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c26:	00 
  800c27:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800c2e:	00 
  800c2f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c36:	00 
  800c37:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800c3e:	e8 63 10 00 00       	call   801ca6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c43:	83 c4 2c             	add    $0x2c,%esp
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_yield>:

void
sys_yield(void)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c70:	ba 00 00 00 00       	mov    $0x0,%edx
  800c75:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c7a:	89 d1                	mov    %edx,%ecx
  800c7c:	89 d3                	mov    %edx,%ebx
  800c7e:	89 d7                	mov    %edx,%edi
  800c80:	89 d6                	mov    %edx,%esi
  800c82:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c92:	be 00 00 00 00       	mov    $0x0,%esi
  800c97:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca5:	89 f7                	mov    %esi,%edi
  800ca7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7e 28                	jle    800cd5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb8:	00 
  800cb9:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800cc8:	00 
  800cc9:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800cd0:	e8 d1 0f 00 00       	call   801ca6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd5:	83 c4 2c             	add    $0x2c,%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce6:	b8 05 00 00 00       	mov    $0x5,%eax
  800ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7e 28                	jle    800d28 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d04:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d0b:	00 
  800d0c:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800d13:	00 
  800d14:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d1b:	00 
  800d1c:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800d23:	e8 7e 0f 00 00       	call   801ca6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d28:	83 c4 2c             	add    $0x2c,%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7e 28                	jle    800d7b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800d76:	e8 2b 0f 00 00       	call   801ca6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7b:	83 c4 2c             	add    $0x2c,%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	b8 08 00 00 00       	mov    $0x8,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800dc9:	e8 d8 0e 00 00       	call   801ca6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dce:	83 c4 2c             	add    $0x2c,%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de4:	b8 09 00 00 00       	mov    $0x9,%eax
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	89 df                	mov    %ebx,%edi
  800df1:	89 de                	mov    %ebx,%esi
  800df3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df5:	85 c0                	test   %eax,%eax
  800df7:	7e 28                	jle    800e21 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e04:	00 
  800e05:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800e0c:	00 
  800e0d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e14:	00 
  800e15:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800e1c:	e8 85 0e 00 00       	call   801ca6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e21:	83 c4 2c             	add    $0x2c,%esp
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e37:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 df                	mov    %ebx,%edi
  800e44:	89 de                	mov    %ebx,%esi
  800e46:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7e 28                	jle    800e74 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e50:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e57:	00 
  800e58:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800e5f:	00 
  800e60:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e67:	00 
  800e68:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800e6f:	e8 32 0e 00 00       	call   801ca6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e74:	83 c4 2c             	add    $0x2c,%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e98:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ead:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	89 cb                	mov    %ecx,%ebx
  800eb7:	89 cf                	mov    %ecx,%edi
  800eb9:	89 ce                	mov    %ecx,%esi
  800ebb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7e 28                	jle    800ee9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ecc:	00 
  800ecd:	c7 44 24 08 1f 24 80 	movl   $0x80241f,0x8(%esp)
  800ed4:	00 
  800ed5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800edc:	00 
  800edd:	c7 04 24 3c 24 80 00 	movl   $0x80243c,(%esp)
  800ee4:	e8 bd 0d 00 00       	call   801ca6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee9:	83 c4 2c             	add    $0x2c,%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
  800ef1:	66 90                	xchg   %ax,%ax
  800ef3:	66 90                	xchg   %ax,%ax
  800ef5:	66 90                	xchg   %ax,%ax
  800ef7:	66 90                	xchg   %ax,%ax
  800ef9:	66 90                	xchg   %ax,%ax
  800efb:	66 90                	xchg   %ax,%ax
  800efd:	66 90                	xchg   %ax,%ax
  800eff:	90                   	nop

00800f00 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	05 00 00 00 30       	add    $0x30000000,%eax
  800f0b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f2a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800f2f:	a8 01                	test   $0x1,%al
  800f31:	74 34                	je     800f67 <fd_alloc+0x40>
  800f33:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800f38:	a8 01                	test   $0x1,%al
  800f3a:	74 32                	je     800f6e <fd_alloc+0x47>
  800f3c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f41:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	c1 ea 16             	shr    $0x16,%edx
  800f48:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4f:	f6 c2 01             	test   $0x1,%dl
  800f52:	74 1f                	je     800f73 <fd_alloc+0x4c>
  800f54:	89 c2                	mov    %eax,%edx
  800f56:	c1 ea 0c             	shr    $0xc,%edx
  800f59:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f60:	f6 c2 01             	test   $0x1,%dl
  800f63:	75 1a                	jne    800f7f <fd_alloc+0x58>
  800f65:	eb 0c                	jmp    800f73 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f67:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800f6c:	eb 05                	jmp    800f73 <fd_alloc+0x4c>
  800f6e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 08                	mov    %ecx,(%eax)
			return 0;
  800f78:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7d:	eb 1a                	jmp    800f99 <fd_alloc+0x72>
  800f7f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f84:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f89:	75 b6                	jne    800f41 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f94:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fa1:	83 f8 1f             	cmp    $0x1f,%eax
  800fa4:	77 36                	ja     800fdc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fa6:	c1 e0 0c             	shl    $0xc,%eax
  800fa9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fae:	89 c2                	mov    %eax,%edx
  800fb0:	c1 ea 16             	shr    $0x16,%edx
  800fb3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fba:	f6 c2 01             	test   $0x1,%dl
  800fbd:	74 24                	je     800fe3 <fd_lookup+0x48>
  800fbf:	89 c2                	mov    %eax,%edx
  800fc1:	c1 ea 0c             	shr    $0xc,%edx
  800fc4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fcb:	f6 c2 01             	test   $0x1,%dl
  800fce:	74 1a                	je     800fea <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb 13                	jmp    800fef <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe1:	eb 0c                	jmp    800fef <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fe3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe8:	eb 05                	jmp    800fef <fd_lookup+0x54>
  800fea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	53                   	push   %ebx
  800ff5:	83 ec 14             	sub    $0x14,%esp
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800ffe:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801004:	75 1e                	jne    801024 <dev_lookup+0x33>
  801006:	eb 0e                	jmp    801016 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801008:	b8 20 30 80 00       	mov    $0x803020,%eax
  80100d:	eb 0c                	jmp    80101b <dev_lookup+0x2a>
  80100f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801014:	eb 05                	jmp    80101b <dev_lookup+0x2a>
  801016:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80101b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
  801022:	eb 38                	jmp    80105c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801024:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80102a:	74 dc                	je     801008 <dev_lookup+0x17>
  80102c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801032:	74 db                	je     80100f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801034:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80103a:	8b 52 48             	mov    0x48(%edx),%edx
  80103d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801041:	89 54 24 04          	mov    %edx,0x4(%esp)
  801045:	c7 04 24 4c 24 80 00 	movl   $0x80244c,(%esp)
  80104c:	e8 33 f1 ff ff       	call   800184 <cprintf>
	*dev = 0;
  801051:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105c:	83 c4 14             	add    $0x14,%esp
  80105f:	5b                   	pop    %ebx
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
  801067:	83 ec 20             	sub    $0x20,%esp
  80106a:	8b 75 08             	mov    0x8(%ebp),%esi
  80106d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801073:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801077:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80107d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801080:	89 04 24             	mov    %eax,(%esp)
  801083:	e8 13 ff ff ff       	call   800f9b <fd_lookup>
  801088:	85 c0                	test   %eax,%eax
  80108a:	78 05                	js     801091 <fd_close+0x2f>
	    || fd != fd2)
  80108c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80108f:	74 0c                	je     80109d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801091:	84 db                	test   %bl,%bl
  801093:	ba 00 00 00 00       	mov    $0x0,%edx
  801098:	0f 44 c2             	cmove  %edx,%eax
  80109b:	eb 3f                	jmp    8010dc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a4:	8b 06                	mov    (%esi),%eax
  8010a6:	89 04 24             	mov    %eax,(%esp)
  8010a9:	e8 43 ff ff ff       	call   800ff1 <dev_lookup>
  8010ae:	89 c3                	mov    %eax,%ebx
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	78 16                	js     8010ca <fd_close+0x68>
		if (dev->dev_close)
  8010b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	74 07                	je     8010ca <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010c3:	89 34 24             	mov    %esi,(%esp)
  8010c6:	ff d0                	call   *%eax
  8010c8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010d5:	e8 56 fc ff ff       	call   800d30 <sys_page_unmap>
	return r;
  8010da:	89 d8                	mov    %ebx,%eax
}
  8010dc:	83 c4 20             	add    $0x20,%esp
  8010df:	5b                   	pop    %ebx
  8010e0:	5e                   	pop    %esi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	89 04 24             	mov    %eax,(%esp)
  8010f6:	e8 a0 fe ff ff       	call   800f9b <fd_lookup>
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	85 d2                	test   %edx,%edx
  8010ff:	78 13                	js     801114 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801101:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801108:	00 
  801109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110c:	89 04 24             	mov    %eax,(%esp)
  80110f:	e8 4e ff ff ff       	call   801062 <fd_close>
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <close_all>:

void
close_all(void)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	53                   	push   %ebx
  80111a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801122:	89 1c 24             	mov    %ebx,(%esp)
  801125:	e8 b9 ff ff ff       	call   8010e3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80112a:	83 c3 01             	add    $0x1,%ebx
  80112d:	83 fb 20             	cmp    $0x20,%ebx
  801130:	75 f0                	jne    801122 <close_all+0xc>
		close(i);
}
  801132:	83 c4 14             	add    $0x14,%esp
  801135:	5b                   	pop    %ebx
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	57                   	push   %edi
  80113c:	56                   	push   %esi
  80113d:	53                   	push   %ebx
  80113e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801141:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801144:	89 44 24 04          	mov    %eax,0x4(%esp)
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	89 04 24             	mov    %eax,(%esp)
  80114e:	e8 48 fe ff ff       	call   800f9b <fd_lookup>
  801153:	89 c2                	mov    %eax,%edx
  801155:	85 d2                	test   %edx,%edx
  801157:	0f 88 e1 00 00 00    	js     80123e <dup+0x106>
		return r;
	close(newfdnum);
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	89 04 24             	mov    %eax,(%esp)
  801163:	e8 7b ff ff ff       	call   8010e3 <close>

	newfd = INDEX2FD(newfdnum);
  801168:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80116b:	c1 e3 0c             	shl    $0xc,%ebx
  80116e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801177:	89 04 24             	mov    %eax,(%esp)
  80117a:	e8 91 fd ff ff       	call   800f10 <fd2data>
  80117f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801181:	89 1c 24             	mov    %ebx,(%esp)
  801184:	e8 87 fd ff ff       	call   800f10 <fd2data>
  801189:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80118b:	89 f0                	mov    %esi,%eax
  80118d:	c1 e8 16             	shr    $0x16,%eax
  801190:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801197:	a8 01                	test   $0x1,%al
  801199:	74 43                	je     8011de <dup+0xa6>
  80119b:	89 f0                	mov    %esi,%eax
  80119d:	c1 e8 0c             	shr    $0xc,%eax
  8011a0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a7:	f6 c2 01             	test   $0x1,%dl
  8011aa:	74 32                	je     8011de <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c7:	00 
  8011c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d3:	e8 05 fb ff ff       	call   800cdd <sys_page_map>
  8011d8:	89 c6                	mov    %eax,%esi
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	78 3e                	js     80121c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	c1 ea 0c             	shr    $0xc,%edx
  8011e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ed:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801202:	00 
  801203:	89 44 24 04          	mov    %eax,0x4(%esp)
  801207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80120e:	e8 ca fa ff ff       	call   800cdd <sys_page_map>
  801213:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801218:	85 f6                	test   %esi,%esi
  80121a:	79 22                	jns    80123e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80121c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801227:	e8 04 fb ff ff       	call   800d30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80122c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801237:	e8 f4 fa ff ff       	call   800d30 <sys_page_unmap>
	return r;
  80123c:	89 f0                	mov    %esi,%eax
}
  80123e:	83 c4 3c             	add    $0x3c,%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	53                   	push   %ebx
  80124a:	83 ec 24             	sub    $0x24,%esp
  80124d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801250:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801253:	89 44 24 04          	mov    %eax,0x4(%esp)
  801257:	89 1c 24             	mov    %ebx,(%esp)
  80125a:	e8 3c fd ff ff       	call   800f9b <fd_lookup>
  80125f:	89 c2                	mov    %eax,%edx
  801261:	85 d2                	test   %edx,%edx
  801263:	78 6d                	js     8012d2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	89 04 24             	mov    %eax,(%esp)
  801274:	e8 78 fd ff ff       	call   800ff1 <dev_lookup>
  801279:	85 c0                	test   %eax,%eax
  80127b:	78 55                	js     8012d2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	8b 50 08             	mov    0x8(%eax),%edx
  801283:	83 e2 03             	and    $0x3,%edx
  801286:	83 fa 01             	cmp    $0x1,%edx
  801289:	75 23                	jne    8012ae <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80128b:	a1 04 40 80 00       	mov    0x804004,%eax
  801290:	8b 40 48             	mov    0x48(%eax),%eax
  801293:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801297:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129b:	c7 04 24 8d 24 80 00 	movl   $0x80248d,(%esp)
  8012a2:	e8 dd ee ff ff       	call   800184 <cprintf>
		return -E_INVAL;
  8012a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ac:	eb 24                	jmp    8012d2 <read+0x8c>
	}
	if (!dev->dev_read)
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	8b 52 08             	mov    0x8(%edx),%edx
  8012b4:	85 d2                	test   %edx,%edx
  8012b6:	74 15                	je     8012cd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012c6:	89 04 24             	mov    %eax,(%esp)
  8012c9:	ff d2                	call   *%edx
  8012cb:	eb 05                	jmp    8012d2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012d2:	83 c4 24             	add    $0x24,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	57                   	push   %edi
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 1c             	sub    $0x1c,%esp
  8012e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012e7:	85 f6                	test   %esi,%esi
  8012e9:	74 33                	je     80131e <readn+0x46>
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f5:	89 f2                	mov    %esi,%edx
  8012f7:	29 c2                	sub    %eax,%edx
  8012f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012fd:	03 45 0c             	add    0xc(%ebp),%eax
  801300:	89 44 24 04          	mov    %eax,0x4(%esp)
  801304:	89 3c 24             	mov    %edi,(%esp)
  801307:	e8 3a ff ff ff       	call   801246 <read>
		if (m < 0)
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 1b                	js     80132b <readn+0x53>
			return m;
		if (m == 0)
  801310:	85 c0                	test   %eax,%eax
  801312:	74 11                	je     801325 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801314:	01 c3                	add    %eax,%ebx
  801316:	89 d8                	mov    %ebx,%eax
  801318:	39 f3                	cmp    %esi,%ebx
  80131a:	72 d9                	jb     8012f5 <readn+0x1d>
  80131c:	eb 0b                	jmp    801329 <readn+0x51>
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
  801323:	eb 06                	jmp    80132b <readn+0x53>
  801325:	89 d8                	mov    %ebx,%eax
  801327:	eb 02                	jmp    80132b <readn+0x53>
  801329:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80132b:	83 c4 1c             	add    $0x1c,%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5f                   	pop    %edi
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 24             	sub    $0x24,%esp
  80133a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801340:	89 44 24 04          	mov    %eax,0x4(%esp)
  801344:	89 1c 24             	mov    %ebx,(%esp)
  801347:	e8 4f fc ff ff       	call   800f9b <fd_lookup>
  80134c:	89 c2                	mov    %eax,%edx
  80134e:	85 d2                	test   %edx,%edx
  801350:	78 68                	js     8013ba <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801355:	89 44 24 04          	mov    %eax,0x4(%esp)
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	89 04 24             	mov    %eax,(%esp)
  801361:	e8 8b fc ff ff       	call   800ff1 <dev_lookup>
  801366:	85 c0                	test   %eax,%eax
  801368:	78 50                	js     8013ba <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80136a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801371:	75 23                	jne    801396 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801373:	a1 04 40 80 00       	mov    0x804004,%eax
  801378:	8b 40 48             	mov    0x48(%eax),%eax
  80137b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80137f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801383:	c7 04 24 a9 24 80 00 	movl   $0x8024a9,(%esp)
  80138a:	e8 f5 ed ff ff       	call   800184 <cprintf>
		return -E_INVAL;
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801394:	eb 24                	jmp    8013ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801399:	8b 52 0c             	mov    0xc(%edx),%edx
  80139c:	85 d2                	test   %edx,%edx
  80139e:	74 15                	je     8013b5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ae:	89 04 24             	mov    %eax,(%esp)
  8013b1:	ff d2                	call   *%edx
  8013b3:	eb 05                	jmp    8013ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013ba:	83 c4 24             	add    $0x24,%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    

008013c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	89 04 24             	mov    %eax,(%esp)
  8013d3:	e8 c3 fb ff ff       	call   800f9b <fd_lookup>
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	78 0e                	js     8013ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	53                   	push   %ebx
  8013f0:	83 ec 24             	sub    $0x24,%esp
  8013f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fd:	89 1c 24             	mov    %ebx,(%esp)
  801400:	e8 96 fb ff ff       	call   800f9b <fd_lookup>
  801405:	89 c2                	mov    %eax,%edx
  801407:	85 d2                	test   %edx,%edx
  801409:	78 61                	js     80146c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801415:	8b 00                	mov    (%eax),%eax
  801417:	89 04 24             	mov    %eax,(%esp)
  80141a:	e8 d2 fb ff ff       	call   800ff1 <dev_lookup>
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 49                	js     80146c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801426:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142a:	75 23                	jne    80144f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80142c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801431:	8b 40 48             	mov    0x48(%eax),%eax
  801434:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143c:	c7 04 24 6c 24 80 00 	movl   $0x80246c,(%esp)
  801443:	e8 3c ed ff ff       	call   800184 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144d:	eb 1d                	jmp    80146c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80144f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801452:	8b 52 18             	mov    0x18(%edx),%edx
  801455:	85 d2                	test   %edx,%edx
  801457:	74 0e                	je     801467 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801459:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801460:	89 04 24             	mov    %eax,(%esp)
  801463:	ff d2                	call   *%edx
  801465:	eb 05                	jmp    80146c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801467:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80146c:	83 c4 24             	add    $0x24,%esp
  80146f:	5b                   	pop    %ebx
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    

00801472 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	53                   	push   %ebx
  801476:	83 ec 24             	sub    $0x24,%esp
  801479:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	89 04 24             	mov    %eax,(%esp)
  801489:	e8 0d fb ff ff       	call   800f9b <fd_lookup>
  80148e:	89 c2                	mov    %eax,%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	78 52                	js     8014e6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	89 04 24             	mov    %eax,(%esp)
  8014a3:	e8 49 fb ff ff       	call   800ff1 <dev_lookup>
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 3a                	js     8014e6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014af:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014b3:	74 2c                	je     8014e1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014b5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014b8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014bf:	00 00 00 
	stat->st_isdir = 0;
  8014c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014c9:	00 00 00 
	stat->st_dev = dev;
  8014cc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d9:	89 14 24             	mov    %edx,(%esp)
  8014dc:	ff 50 14             	call   *0x14(%eax)
  8014df:	eb 05                	jmp    8014e6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014e6:	83 c4 24             	add    $0x24,%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
  8014f1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014fb:	00 
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 04 24             	mov    %eax,(%esp)
  801502:	e8 af 01 00 00       	call   8016b6 <open>
  801507:	89 c3                	mov    %eax,%ebx
  801509:	85 db                	test   %ebx,%ebx
  80150b:	78 1b                	js     801528 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	89 44 24 04          	mov    %eax,0x4(%esp)
  801514:	89 1c 24             	mov    %ebx,(%esp)
  801517:	e8 56 ff ff ff       	call   801472 <fstat>
  80151c:	89 c6                	mov    %eax,%esi
	close(fd);
  80151e:	89 1c 24             	mov    %ebx,(%esp)
  801521:	e8 bd fb ff ff       	call   8010e3 <close>
	return r;
  801526:	89 f0                	mov    %esi,%eax
}
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	5b                   	pop    %ebx
  80152c:	5e                   	pop    %esi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 10             	sub    $0x10,%esp
  801537:	89 c6                	mov    %eax,%esi
  801539:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80153b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801542:	75 11                	jne    801555 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801544:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80154b:	e8 7a 08 00 00       	call   801dca <ipc_find_env>
  801550:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801555:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80155c:	00 
  80155d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801564:	00 
  801565:	89 74 24 04          	mov    %esi,0x4(%esp)
  801569:	a1 00 40 80 00       	mov    0x804000,%eax
  80156e:	89 04 24             	mov    %eax,(%esp)
  801571:	e8 ee 07 00 00       	call   801d64 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801576:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157d:	00 
  80157e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801589:	e8 6e 07 00 00       	call   801cfc <ipc_recv>
}
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 14             	sub    $0x14,%esp
  80159c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b8 05 00 00 00       	mov    $0x5,%eax
  8015b4:	e8 76 ff ff ff       	call   80152f <fsipc>
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	85 d2                	test   %edx,%edx
  8015bd:	78 2b                	js     8015ea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015bf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015c6:	00 
  8015c7:	89 1c 24             	mov    %ebx,(%esp)
  8015ca:	e8 0c f2 ff ff       	call   8007db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8015d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015da:	a1 84 50 80 00       	mov    0x805084,%eax
  8015df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	83 c4 14             	add    $0x14,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801601:	ba 00 00 00 00       	mov    $0x0,%edx
  801606:	b8 06 00 00 00       	mov    $0x6,%eax
  80160b:	e8 1f ff ff ff       	call   80152f <fsipc>
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	83 ec 10             	sub    $0x10,%esp
  80161a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	8b 40 0c             	mov    0xc(%eax),%eax
  801623:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801628:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	b8 03 00 00 00       	mov    $0x3,%eax
  801638:	e8 f2 fe ff ff       	call   80152f <fsipc>
  80163d:	89 c3                	mov    %eax,%ebx
  80163f:	85 c0                	test   %eax,%eax
  801641:	78 6a                	js     8016ad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801643:	39 c6                	cmp    %eax,%esi
  801645:	73 24                	jae    80166b <devfile_read+0x59>
  801647:	c7 44 24 0c c6 24 80 	movl   $0x8024c6,0xc(%esp)
  80164e:	00 
  80164f:	c7 44 24 08 cd 24 80 	movl   $0x8024cd,0x8(%esp)
  801656:	00 
  801657:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80165e:	00 
  80165f:	c7 04 24 e2 24 80 00 	movl   $0x8024e2,(%esp)
  801666:	e8 3b 06 00 00       	call   801ca6 <_panic>
	assert(r <= PGSIZE);
  80166b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801670:	7e 24                	jle    801696 <devfile_read+0x84>
  801672:	c7 44 24 0c ed 24 80 	movl   $0x8024ed,0xc(%esp)
  801679:	00 
  80167a:	c7 44 24 08 cd 24 80 	movl   $0x8024cd,0x8(%esp)
  801681:	00 
  801682:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801689:	00 
  80168a:	c7 04 24 e2 24 80 00 	movl   $0x8024e2,(%esp)
  801691:	e8 10 06 00 00       	call   801ca6 <_panic>
	memmove(buf, &fsipcbuf, r);
  801696:	89 44 24 08          	mov    %eax,0x8(%esp)
  80169a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016a1:	00 
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	89 04 24             	mov    %eax,(%esp)
  8016a8:	e8 29 f3 ff ff       	call   8009d6 <memmove>
	return r;
}
  8016ad:	89 d8                	mov    %ebx,%eax
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	5b                   	pop    %ebx
  8016b3:	5e                   	pop    %esi
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 24             	sub    $0x24,%esp
  8016bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8016c0:	89 1c 24             	mov    %ebx,(%esp)
  8016c3:	e8 b8 f0 ff ff       	call   800780 <strlen>
  8016c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016cd:	7f 60                	jg     80172f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8016cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d2:	89 04 24             	mov    %eax,(%esp)
  8016d5:	e8 4d f8 ff ff       	call   800f27 <fd_alloc>
  8016da:	89 c2                	mov    %eax,%edx
  8016dc:	85 d2                	test   %edx,%edx
  8016de:	78 54                	js     801734 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8016e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016e4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8016eb:	e8 eb f0 ff ff       	call   8007db <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801700:	e8 2a fe ff ff       	call   80152f <fsipc>
  801705:	89 c3                	mov    %eax,%ebx
  801707:	85 c0                	test   %eax,%eax
  801709:	79 17                	jns    801722 <open+0x6c>
		fd_close(fd, 0);
  80170b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801712:	00 
  801713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801716:	89 04 24             	mov    %eax,(%esp)
  801719:	e8 44 f9 ff ff       	call   801062 <fd_close>
		return r;
  80171e:	89 d8                	mov    %ebx,%eax
  801720:	eb 12                	jmp    801734 <open+0x7e>
	}
	return fd2num(fd);
  801722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801725:	89 04 24             	mov    %eax,(%esp)
  801728:	e8 d3 f7 ff ff       	call   800f00 <fd2num>
  80172d:	eb 05                	jmp    801734 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80172f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801734:	83 c4 24             	add    $0x24,%esp
  801737:	5b                   	pop    %ebx
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    
  80173a:	66 90                	xchg   %ax,%ax
  80173c:	66 90                	xchg   %ax,%ax
  80173e:	66 90                	xchg   %ax,%ax

00801740 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 10             	sub    $0x10,%esp
  801748:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	89 04 24             	mov    %eax,(%esp)
  801751:	e8 ba f7 ff ff       	call   800f10 <fd2data>
  801756:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801758:	c7 44 24 04 f9 24 80 	movl   $0x8024f9,0x4(%esp)
  80175f:	00 
  801760:	89 1c 24             	mov    %ebx,(%esp)
  801763:	e8 73 f0 ff ff       	call   8007db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801768:	8b 46 04             	mov    0x4(%esi),%eax
  80176b:	2b 06                	sub    (%esi),%eax
  80176d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801773:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80177a:	00 00 00 
	stat->st_dev = &devpipe;
  80177d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801784:	30 80 00 
	return 0;
}
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	53                   	push   %ebx
  801797:	83 ec 14             	sub    $0x14,%esp
  80179a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80179d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a8:	e8 83 f5 ff ff       	call   800d30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017ad:	89 1c 24             	mov    %ebx,(%esp)
  8017b0:	e8 5b f7 ff ff       	call   800f10 <fd2data>
  8017b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c0:	e8 6b f5 ff ff       	call   800d30 <sys_page_unmap>
}
  8017c5:	83 c4 14             	add    $0x14,%esp
  8017c8:	5b                   	pop    %ebx
  8017c9:	5d                   	pop    %ebp
  8017ca:	c3                   	ret    

008017cb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	57                   	push   %edi
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 2c             	sub    $0x2c,%esp
  8017d4:	89 c6                	mov    %eax,%esi
  8017d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8017de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017e1:	89 34 24             	mov    %esi,(%esp)
  8017e4:	e8 29 06 00 00       	call   801e12 <pageref>
  8017e9:	89 c7                	mov    %eax,%edi
  8017eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ee:	89 04 24             	mov    %eax,(%esp)
  8017f1:	e8 1c 06 00 00       	call   801e12 <pageref>
  8017f6:	39 c7                	cmp    %eax,%edi
  8017f8:	0f 94 c2             	sete   %dl
  8017fb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8017fe:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801804:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801807:	39 fb                	cmp    %edi,%ebx
  801809:	74 21                	je     80182c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80180b:	84 d2                	test   %dl,%dl
  80180d:	74 ca                	je     8017d9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80180f:	8b 51 58             	mov    0x58(%ecx),%edx
  801812:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801816:	89 54 24 08          	mov    %edx,0x8(%esp)
  80181a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80181e:	c7 04 24 00 25 80 00 	movl   $0x802500,(%esp)
  801825:	e8 5a e9 ff ff       	call   800184 <cprintf>
  80182a:	eb ad                	jmp    8017d9 <_pipeisclosed+0xe>
	}
}
  80182c:	83 c4 2c             	add    $0x2c,%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5f                   	pop    %edi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	57                   	push   %edi
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	83 ec 1c             	sub    $0x1c,%esp
  80183d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801840:	89 34 24             	mov    %esi,(%esp)
  801843:	e8 c8 f6 ff ff       	call   800f10 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801848:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80184c:	74 61                	je     8018af <devpipe_write+0x7b>
  80184e:	89 c3                	mov    %eax,%ebx
  801850:	bf 00 00 00 00       	mov    $0x0,%edi
  801855:	eb 4a                	jmp    8018a1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801857:	89 da                	mov    %ebx,%edx
  801859:	89 f0                	mov    %esi,%eax
  80185b:	e8 6b ff ff ff       	call   8017cb <_pipeisclosed>
  801860:	85 c0                	test   %eax,%eax
  801862:	75 54                	jne    8018b8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801864:	e8 01 f4 ff ff       	call   800c6a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801869:	8b 43 04             	mov    0x4(%ebx),%eax
  80186c:	8b 0b                	mov    (%ebx),%ecx
  80186e:	8d 51 20             	lea    0x20(%ecx),%edx
  801871:	39 d0                	cmp    %edx,%eax
  801873:	73 e2                	jae    801857 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801875:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801878:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80187c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80187f:	99                   	cltd   
  801880:	c1 ea 1b             	shr    $0x1b,%edx
  801883:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801886:	83 e1 1f             	and    $0x1f,%ecx
  801889:	29 d1                	sub    %edx,%ecx
  80188b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80188f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801893:	83 c0 01             	add    $0x1,%eax
  801896:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801899:	83 c7 01             	add    $0x1,%edi
  80189c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80189f:	74 13                	je     8018b4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018a4:	8b 0b                	mov    (%ebx),%ecx
  8018a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8018a9:	39 d0                	cmp    %edx,%eax
  8018ab:	73 aa                	jae    801857 <devpipe_write+0x23>
  8018ad:	eb c6                	jmp    801875 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8018b4:	89 f8                	mov    %edi,%eax
  8018b6:	eb 05                	jmp    8018bd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8018bd:	83 c4 1c             	add    $0x1c,%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5f                   	pop    %edi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 1c             	sub    $0x1c,%esp
  8018ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018d1:	89 3c 24             	mov    %edi,(%esp)
  8018d4:	e8 37 f6 ff ff       	call   800f10 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018dd:	74 54                	je     801933 <devpipe_read+0x6e>
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	be 00 00 00 00       	mov    $0x0,%esi
  8018e6:	eb 3e                	jmp    801926 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8018e8:	89 f0                	mov    %esi,%eax
  8018ea:	eb 55                	jmp    801941 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018ec:	89 da                	mov    %ebx,%edx
  8018ee:	89 f8                	mov    %edi,%eax
  8018f0:	e8 d6 fe ff ff       	call   8017cb <_pipeisclosed>
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	75 43                	jne    80193c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8018f9:	e8 6c f3 ff ff       	call   800c6a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8018fe:	8b 03                	mov    (%ebx),%eax
  801900:	3b 43 04             	cmp    0x4(%ebx),%eax
  801903:	74 e7                	je     8018ec <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801905:	99                   	cltd   
  801906:	c1 ea 1b             	shr    $0x1b,%edx
  801909:	01 d0                	add    %edx,%eax
  80190b:	83 e0 1f             	and    $0x1f,%eax
  80190e:	29 d0                	sub    %edx,%eax
  801910:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801915:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801918:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80191b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80191e:	83 c6 01             	add    $0x1,%esi
  801921:	3b 75 10             	cmp    0x10(%ebp),%esi
  801924:	74 12                	je     801938 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801926:	8b 03                	mov    (%ebx),%eax
  801928:	3b 43 04             	cmp    0x4(%ebx),%eax
  80192b:	75 d8                	jne    801905 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80192d:	85 f6                	test   %esi,%esi
  80192f:	75 b7                	jne    8018e8 <devpipe_read+0x23>
  801931:	eb b9                	jmp    8018ec <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801933:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801938:	89 f0                	mov    %esi,%eax
  80193a:	eb 05                	jmp    801941 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801941:	83 c4 1c             	add    $0x1c,%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
  80194e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801951:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 cb f5 ff ff       	call   800f27 <fd_alloc>
  80195c:	89 c2                	mov    %eax,%edx
  80195e:	85 d2                	test   %edx,%edx
  801960:	0f 88 4d 01 00 00    	js     801ab3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801966:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80196d:	00 
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	89 44 24 04          	mov    %eax,0x4(%esp)
  801975:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197c:	e8 08 f3 ff ff       	call   800c89 <sys_page_alloc>
  801981:	89 c2                	mov    %eax,%edx
  801983:	85 d2                	test   %edx,%edx
  801985:	0f 88 28 01 00 00    	js     801ab3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80198b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198e:	89 04 24             	mov    %eax,(%esp)
  801991:	e8 91 f5 ff ff       	call   800f27 <fd_alloc>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	85 c0                	test   %eax,%eax
  80199a:	0f 88 fe 00 00 00    	js     801a9e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019a7:	00 
  8019a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b6:	e8 ce f2 ff ff       	call   800c89 <sys_page_alloc>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	0f 88 d9 00 00 00    	js     801a9e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	89 04 24             	mov    %eax,(%esp)
  8019cb:	e8 40 f5 ff ff       	call   800f10 <fd2data>
  8019d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019d9:	00 
  8019da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e5:	e8 9f f2 ff ff       	call   800c89 <sys_page_alloc>
  8019ea:	89 c3                	mov    %eax,%ebx
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	0f 88 97 00 00 00    	js     801a8b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f7:	89 04 24             	mov    %eax,(%esp)
  8019fa:	e8 11 f5 ff ff       	call   800f10 <fd2data>
  8019ff:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a06:	00 
  801a07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a12:	00 
  801a13:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a1e:	e8 ba f2 ff ff       	call   800cdd <sys_page_map>
  801a23:	89 c3                	mov    %eax,%ebx
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 52                	js     801a7b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a29:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a3e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a56:	89 04 24             	mov    %eax,(%esp)
  801a59:	e8 a2 f4 ff ff       	call   800f00 <fd2num>
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a66:	89 04 24             	mov    %eax,(%esp)
  801a69:	e8 92 f4 ff ff       	call   800f00 <fd2num>
  801a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a71:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	eb 38                	jmp    801ab3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801a7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a86:	e8 a5 f2 ff ff       	call   800d30 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a99:	e8 92 f2 ff ff       	call   800d30 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aac:	e8 7f f2 ff ff       	call   800d30 <sys_page_unmap>
  801ab1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801ab3:	83 c4 30             	add    $0x30,%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5e                   	pop    %esi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    

00801aba <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ac0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	89 04 24             	mov    %eax,(%esp)
  801acd:	e8 c9 f4 ff ff       	call   800f9b <fd_lookup>
  801ad2:	89 c2                	mov    %eax,%edx
  801ad4:	85 d2                	test   %edx,%edx
  801ad6:	78 15                	js     801aed <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 2d f4 ff ff       	call   800f10 <fd2data>
	return _pipeisclosed(fd, p);
  801ae3:	89 c2                	mov    %eax,%edx
  801ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae8:	e8 de fc ff ff       	call   8017cb <_pipeisclosed>
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
  801aef:	90                   	nop

00801af0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b00:	c7 44 24 04 18 25 80 	movl   $0x802518,0x4(%esp)
  801b07:	00 
  801b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	e8 c8 ec ff ff       	call   8007db <strcpy>
	return 0;
}
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b2a:	74 4a                	je     801b76 <devcons_write+0x5c>
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b31:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b36:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b3c:	8b 75 10             	mov    0x10(%ebp),%esi
  801b3f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801b41:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b44:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b49:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b4c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801b50:	03 45 0c             	add    0xc(%ebp),%eax
  801b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b57:	89 3c 24             	mov    %edi,(%esp)
  801b5a:	e8 77 ee ff ff       	call   8009d6 <memmove>
		sys_cputs(buf, m);
  801b5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b63:	89 3c 24             	mov    %edi,(%esp)
  801b66:	e8 51 f0 ff ff       	call   800bbc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b6b:	01 f3                	add    %esi,%ebx
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b72:	72 c8                	jb     801b3c <devcons_write+0x22>
  801b74:	eb 05                	jmp    801b7b <devcons_write+0x61>
  801b76:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801b7b:	89 d8                	mov    %ebx,%eax
  801b7d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5f                   	pop    %edi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    

00801b88 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801b93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b97:	75 07                	jne    801ba0 <devcons_read+0x18>
  801b99:	eb 28                	jmp    801bc3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801b9b:	e8 ca f0 ff ff       	call   800c6a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ba0:	e8 35 f0 ff ff       	call   800bda <sys_cgetc>
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	74 f2                	je     801b9b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 16                	js     801bc3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801bad:	83 f8 04             	cmp    $0x4,%eax
  801bb0:	74 0c                	je     801bbe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	88 02                	mov    %al,(%edx)
	return 1;
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	eb 05                	jmp    801bc3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801bd1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801bd8:	00 
  801bd9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bdc:	89 04 24             	mov    %eax,(%esp)
  801bdf:	e8 d8 ef ff ff       	call   800bbc <sys_cputs>
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <getchar>:

int
getchar(void)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801bf3:	00 
  801bf4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c02:	e8 3f f6 ff ff       	call   801246 <read>
	if (r < 0)
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 0f                	js     801c1a <getchar+0x34>
		return r;
	if (r < 1)
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	7e 06                	jle    801c15 <getchar+0x2f>
		return -E_EOF;
	return c;
  801c0f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c13:	eb 05                	jmp    801c1a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c15:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 67 f3 ff ff       	call   800f9b <fd_lookup>
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 11                	js     801c49 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c41:	39 10                	cmp    %edx,(%eax)
  801c43:	0f 94 c0             	sete   %al
  801c46:	0f b6 c0             	movzbl %al,%eax
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <opencons>:

int
opencons(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c54:	89 04 24             	mov    %eax,(%esp)
  801c57:	e8 cb f2 ff ff       	call   800f27 <fd_alloc>
		return r;
  801c5c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 40                	js     801ca2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c69:	00 
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c78:	e8 0c f0 ff ff       	call   800c89 <sys_page_alloc>
		return r;
  801c7d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	78 1f                	js     801ca2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801c83:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c98:	89 04 24             	mov    %eax,(%esp)
  801c9b:	e8 60 f2 ff ff       	call   800f00 <fd2num>
  801ca0:	89 c2                	mov    %eax,%edx
}
  801ca2:	89 d0                	mov    %edx,%eax
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	56                   	push   %esi
  801caa:	53                   	push   %ebx
  801cab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801cae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cb1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801cb7:	e8 8f ef ff ff       	call   800c4b <sys_getenvid>
  801cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbf:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cca:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd2:	c7 04 24 24 25 80 00 	movl   $0x802524,(%esp)
  801cd9:	e8 a6 e4 ff ff       	call   800184 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce5:	89 04 24             	mov    %eax,(%esp)
  801ce8:	e8 36 e4 ff ff       	call   800123 <vcprintf>
	cprintf("\n");
  801ced:	c7 04 24 11 25 80 00 	movl   $0x802511,(%esp)
  801cf4:	e8 8b e4 ff ff       	call   800184 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cf9:	cc                   	int3   
  801cfa:	eb fd                	jmp    801cf9 <_panic+0x53>

00801cfc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	56                   	push   %esi
  801d00:	53                   	push   %ebx
  801d01:	83 ec 10             	sub    $0x10,%esp
  801d04:	8b 75 08             	mov    0x8(%ebp),%esi
  801d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d14:	0f 44 c2             	cmove  %edx,%eax
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 80 f1 ff ff       	call   800e9f <sys_ipc_recv>
	if (err_code < 0) {
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	79 16                	jns    801d39 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d23:	85 f6                	test   %esi,%esi
  801d25:	74 06                	je     801d2d <ipc_recv+0x31>
  801d27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d2d:	85 db                	test   %ebx,%ebx
  801d2f:	74 2c                	je     801d5d <ipc_recv+0x61>
  801d31:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d37:	eb 24                	jmp    801d5d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d39:	85 f6                	test   %esi,%esi
  801d3b:	74 0a                	je     801d47 <ipc_recv+0x4b>
  801d3d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d42:	8b 40 74             	mov    0x74(%eax),%eax
  801d45:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d47:	85 db                	test   %ebx,%ebx
  801d49:	74 0a                	je     801d55 <ipc_recv+0x59>
  801d4b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d50:	8b 40 78             	mov    0x78(%eax),%eax
  801d53:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d55:	a1 04 40 80 00       	mov    0x804004,%eax
  801d5a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	57                   	push   %edi
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	83 ec 1c             	sub    $0x1c,%esp
  801d6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d76:	eb 25                	jmp    801d9d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d78:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d7b:	74 20                	je     801d9d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d81:	c7 44 24 08 48 25 80 	movl   $0x802548,0x8(%esp)
  801d88:	00 
  801d89:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801d90:	00 
  801d91:	c7 04 24 54 25 80 00 	movl   $0x802554,(%esp)
  801d98:	e8 09 ff ff ff       	call   801ca6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d9d:	85 db                	test   %ebx,%ebx
  801d9f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801da4:	0f 45 c3             	cmovne %ebx,%eax
  801da7:	8b 55 14             	mov    0x14(%ebp),%edx
  801daa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801db6:	89 3c 24             	mov    %edi,(%esp)
  801db9:	e8 be f0 ff ff       	call   800e7c <sys_ipc_try_send>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 b6                	jne    801d78 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801dc2:	83 c4 1c             	add    $0x1c,%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5f                   	pop    %edi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801dd0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801dd5:	39 c8                	cmp    %ecx,%eax
  801dd7:	74 17                	je     801df0 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dde:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801de1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801de7:	8b 52 50             	mov    0x50(%edx),%edx
  801dea:	39 ca                	cmp    %ecx,%edx
  801dec:	75 14                	jne    801e02 <ipc_find_env+0x38>
  801dee:	eb 05                	jmp    801df5 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801df5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801df8:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801dfd:	8b 40 40             	mov    0x40(%eax),%eax
  801e00:	eb 0e                	jmp    801e10 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e02:	83 c0 01             	add    $0x1,%eax
  801e05:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e0a:	75 d2                	jne    801dde <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e0c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e18:	89 d0                	mov    %edx,%eax
  801e1a:	c1 e8 16             	shr    $0x16,%eax
  801e1d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e29:	f6 c1 01             	test   $0x1,%cl
  801e2c:	74 1d                	je     801e4b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e2e:	c1 ea 0c             	shr    $0xc,%edx
  801e31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e38:	f6 c2 01             	test   $0x1,%dl
  801e3b:	74 0e                	je     801e4b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e3d:	c1 ea 0c             	shr    $0xc,%edx
  801e40:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e47:	ef 
  801e48:	0f b7 c0             	movzwl %ax,%eax
}
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
  801e4d:	66 90                	xchg   %ax,%ax
  801e4f:	90                   	nop

00801e50 <__udivdi3>:
  801e50:	55                   	push   %ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e66:	85 c0                	test   %eax,%eax
  801e68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e6c:	89 ea                	mov    %ebp,%edx
  801e6e:	89 0c 24             	mov    %ecx,(%esp)
  801e71:	75 2d                	jne    801ea0 <__udivdi3+0x50>
  801e73:	39 e9                	cmp    %ebp,%ecx
  801e75:	77 61                	ja     801ed8 <__udivdi3+0x88>
  801e77:	85 c9                	test   %ecx,%ecx
  801e79:	89 ce                	mov    %ecx,%esi
  801e7b:	75 0b                	jne    801e88 <__udivdi3+0x38>
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	f7 f1                	div    %ecx
  801e86:	89 c6                	mov    %eax,%esi
  801e88:	31 d2                	xor    %edx,%edx
  801e8a:	89 e8                	mov    %ebp,%eax
  801e8c:	f7 f6                	div    %esi
  801e8e:	89 c5                	mov    %eax,%ebp
  801e90:	89 f8                	mov    %edi,%eax
  801e92:	f7 f6                	div    %esi
  801e94:	89 ea                	mov    %ebp,%edx
  801e96:	83 c4 0c             	add    $0xc,%esp
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	39 e8                	cmp    %ebp,%eax
  801ea2:	77 24                	ja     801ec8 <__udivdi3+0x78>
  801ea4:	0f bd e8             	bsr    %eax,%ebp
  801ea7:	83 f5 1f             	xor    $0x1f,%ebp
  801eaa:	75 3c                	jne    801ee8 <__udivdi3+0x98>
  801eac:	8b 74 24 04          	mov    0x4(%esp),%esi
  801eb0:	39 34 24             	cmp    %esi,(%esp)
  801eb3:	0f 86 9f 00 00 00    	jbe    801f58 <__udivdi3+0x108>
  801eb9:	39 d0                	cmp    %edx,%eax
  801ebb:	0f 82 97 00 00 00    	jb     801f58 <__udivdi3+0x108>
  801ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ec8:	31 d2                	xor    %edx,%edx
  801eca:	31 c0                	xor    %eax,%eax
  801ecc:	83 c4 0c             	add    $0xc,%esp
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
  801ed3:	90                   	nop
  801ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ed8:	89 f8                	mov    %edi,%eax
  801eda:	f7 f1                	div    %ecx
  801edc:	31 d2                	xor    %edx,%edx
  801ede:	83 c4 0c             	add    $0xc,%esp
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
  801ee5:	8d 76 00             	lea    0x0(%esi),%esi
  801ee8:	89 e9                	mov    %ebp,%ecx
  801eea:	8b 3c 24             	mov    (%esp),%edi
  801eed:	d3 e0                	shl    %cl,%eax
  801eef:	89 c6                	mov    %eax,%esi
  801ef1:	b8 20 00 00 00       	mov    $0x20,%eax
  801ef6:	29 e8                	sub    %ebp,%eax
  801ef8:	89 c1                	mov    %eax,%ecx
  801efa:	d3 ef                	shr    %cl,%edi
  801efc:	89 e9                	mov    %ebp,%ecx
  801efe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f02:	8b 3c 24             	mov    (%esp),%edi
  801f05:	09 74 24 08          	or     %esi,0x8(%esp)
  801f09:	89 d6                	mov    %edx,%esi
  801f0b:	d3 e7                	shl    %cl,%edi
  801f0d:	89 c1                	mov    %eax,%ecx
  801f0f:	89 3c 24             	mov    %edi,(%esp)
  801f12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f16:	d3 ee                	shr    %cl,%esi
  801f18:	89 e9                	mov    %ebp,%ecx
  801f1a:	d3 e2                	shl    %cl,%edx
  801f1c:	89 c1                	mov    %eax,%ecx
  801f1e:	d3 ef                	shr    %cl,%edi
  801f20:	09 d7                	or     %edx,%edi
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	89 f8                	mov    %edi,%eax
  801f26:	f7 74 24 08          	divl   0x8(%esp)
  801f2a:	89 d6                	mov    %edx,%esi
  801f2c:	89 c7                	mov    %eax,%edi
  801f2e:	f7 24 24             	mull   (%esp)
  801f31:	39 d6                	cmp    %edx,%esi
  801f33:	89 14 24             	mov    %edx,(%esp)
  801f36:	72 30                	jb     801f68 <__udivdi3+0x118>
  801f38:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f3c:	89 e9                	mov    %ebp,%ecx
  801f3e:	d3 e2                	shl    %cl,%edx
  801f40:	39 c2                	cmp    %eax,%edx
  801f42:	73 05                	jae    801f49 <__udivdi3+0xf9>
  801f44:	3b 34 24             	cmp    (%esp),%esi
  801f47:	74 1f                	je     801f68 <__udivdi3+0x118>
  801f49:	89 f8                	mov    %edi,%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	e9 7a ff ff ff       	jmp    801ecc <__udivdi3+0x7c>
  801f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f58:	31 d2                	xor    %edx,%edx
  801f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5f:	e9 68 ff ff ff       	jmp    801ecc <__udivdi3+0x7c>
  801f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f68:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	83 c4 0c             	add    $0xc,%esp
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
  801f74:	66 90                	xchg   %ax,%ax
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	66 90                	xchg   %ax,%ax
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	66 90                	xchg   %ax,%ax
  801f7e:	66 90                	xchg   %ax,%ax

00801f80 <__umoddi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	83 ec 14             	sub    $0x14,%esp
  801f86:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801f92:	89 c7                	mov    %eax,%edi
  801f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f98:	8b 44 24 30          	mov    0x30(%esp),%eax
  801f9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fa0:	89 34 24             	mov    %esi,(%esp)
  801fa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801faf:	75 17                	jne    801fc8 <__umoddi3+0x48>
  801fb1:	39 fe                	cmp    %edi,%esi
  801fb3:	76 4b                	jbe    802000 <__umoddi3+0x80>
  801fb5:	89 c8                	mov    %ecx,%eax
  801fb7:	89 fa                	mov    %edi,%edx
  801fb9:	f7 f6                	div    %esi
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	31 d2                	xor    %edx,%edx
  801fbf:	83 c4 14             	add    $0x14,%esp
  801fc2:	5e                   	pop    %esi
  801fc3:	5f                   	pop    %edi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	39 f8                	cmp    %edi,%eax
  801fca:	77 54                	ja     802020 <__umoddi3+0xa0>
  801fcc:	0f bd e8             	bsr    %eax,%ebp
  801fcf:	83 f5 1f             	xor    $0x1f,%ebp
  801fd2:	75 5c                	jne    802030 <__umoddi3+0xb0>
  801fd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fd8:	39 3c 24             	cmp    %edi,(%esp)
  801fdb:	0f 87 e7 00 00 00    	ja     8020c8 <__umoddi3+0x148>
  801fe1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fe5:	29 f1                	sub    %esi,%ecx
  801fe7:	19 c7                	sbb    %eax,%edi
  801fe9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ff1:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801ff9:	83 c4 14             	add    $0x14,%esp
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    
  802000:	85 f6                	test   %esi,%esi
  802002:	89 f5                	mov    %esi,%ebp
  802004:	75 0b                	jne    802011 <__umoddi3+0x91>
  802006:	b8 01 00 00 00       	mov    $0x1,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	f7 f6                	div    %esi
  80200f:	89 c5                	mov    %eax,%ebp
  802011:	8b 44 24 04          	mov    0x4(%esp),%eax
  802015:	31 d2                	xor    %edx,%edx
  802017:	f7 f5                	div    %ebp
  802019:	89 c8                	mov    %ecx,%eax
  80201b:	f7 f5                	div    %ebp
  80201d:	eb 9c                	jmp    801fbb <__umoddi3+0x3b>
  80201f:	90                   	nop
  802020:	89 c8                	mov    %ecx,%eax
  802022:	89 fa                	mov    %edi,%edx
  802024:	83 c4 14             	add    $0x14,%esp
  802027:	5e                   	pop    %esi
  802028:	5f                   	pop    %edi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    
  80202b:	90                   	nop
  80202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802030:	8b 04 24             	mov    (%esp),%eax
  802033:	be 20 00 00 00       	mov    $0x20,%esi
  802038:	89 e9                	mov    %ebp,%ecx
  80203a:	29 ee                	sub    %ebp,%esi
  80203c:	d3 e2                	shl    %cl,%edx
  80203e:	89 f1                	mov    %esi,%ecx
  802040:	d3 e8                	shr    %cl,%eax
  802042:	89 e9                	mov    %ebp,%ecx
  802044:	89 44 24 04          	mov    %eax,0x4(%esp)
  802048:	8b 04 24             	mov    (%esp),%eax
  80204b:	09 54 24 04          	or     %edx,0x4(%esp)
  80204f:	89 fa                	mov    %edi,%edx
  802051:	d3 e0                	shl    %cl,%eax
  802053:	89 f1                	mov    %esi,%ecx
  802055:	89 44 24 08          	mov    %eax,0x8(%esp)
  802059:	8b 44 24 10          	mov    0x10(%esp),%eax
  80205d:	d3 ea                	shr    %cl,%edx
  80205f:	89 e9                	mov    %ebp,%ecx
  802061:	d3 e7                	shl    %cl,%edi
  802063:	89 f1                	mov    %esi,%ecx
  802065:	d3 e8                	shr    %cl,%eax
  802067:	89 e9                	mov    %ebp,%ecx
  802069:	09 f8                	or     %edi,%eax
  80206b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80206f:	f7 74 24 04          	divl   0x4(%esp)
  802073:	d3 e7                	shl    %cl,%edi
  802075:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802079:	89 d7                	mov    %edx,%edi
  80207b:	f7 64 24 08          	mull   0x8(%esp)
  80207f:	39 d7                	cmp    %edx,%edi
  802081:	89 c1                	mov    %eax,%ecx
  802083:	89 14 24             	mov    %edx,(%esp)
  802086:	72 2c                	jb     8020b4 <__umoddi3+0x134>
  802088:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80208c:	72 22                	jb     8020b0 <__umoddi3+0x130>
  80208e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802092:	29 c8                	sub    %ecx,%eax
  802094:	19 d7                	sbb    %edx,%edi
  802096:	89 e9                	mov    %ebp,%ecx
  802098:	89 fa                	mov    %edi,%edx
  80209a:	d3 e8                	shr    %cl,%eax
  80209c:	89 f1                	mov    %esi,%ecx
  80209e:	d3 e2                	shl    %cl,%edx
  8020a0:	89 e9                	mov    %ebp,%ecx
  8020a2:	d3 ef                	shr    %cl,%edi
  8020a4:	09 d0                	or     %edx,%eax
  8020a6:	89 fa                	mov    %edi,%edx
  8020a8:	83 c4 14             	add    $0x14,%esp
  8020ab:	5e                   	pop    %esi
  8020ac:	5f                   	pop    %edi
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    
  8020af:	90                   	nop
  8020b0:	39 d7                	cmp    %edx,%edi
  8020b2:	75 da                	jne    80208e <__umoddi3+0x10e>
  8020b4:	8b 14 24             	mov    (%esp),%edx
  8020b7:	89 c1                	mov    %eax,%ecx
  8020b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020c1:	eb cb                	jmp    80208e <__umoddi3+0x10e>
  8020c3:	90                   	nop
  8020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020cc:	0f 82 0f ff ff ff    	jb     801fe1 <__umoddi3+0x61>
  8020d2:	e9 1a ff ff ff       	jmp    801ff1 <__umoddi3+0x71>
