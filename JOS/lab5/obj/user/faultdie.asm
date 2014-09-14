
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 65 00 00 00       	call   800096 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in handler\n");
  80003d:	c7 04 24 20 22 80 00 	movl   $0x802220,(%esp)
  800044:	e8 81 01 00 00       	call   8001ca <cprintf>
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 43 04             	mov    0x4(%ebx),%eax
  80004c:	83 e0 07             	and    $0x7,%eax
  80004f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800053:	8b 03                	mov    (%ebx),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 2c 22 80 00 	movl   $0x80222c,(%esp)
  800060:	e8 65 01 00 00       	call   8001ca <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 31 0c 00 00       	call   800c9b <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 d7 0b 00 00       	call   800c49 <sys_env_destroy>
}
  800072:	83 c4 14             	add    $0x14,%esp
  800075:	5b                   	pop    %ebx
  800076:	5d                   	pop    %ebp
  800077:	c3                   	ret    

00800078 <umain>:

void
umain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007e:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  800085:	e8 b7 0e 00 00       	call   800f41 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  80008a:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800091:	00 00 00 
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	56                   	push   %esi
  80009a:	53                   	push   %ebx
  80009b:	83 ec 10             	sub    $0x10,%esp
  80009e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000a4:	e8 f2 0b 00 00       	call   800c9b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000a9:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000af:	39 c2                	cmp    %eax,%edx
  8000b1:	74 17                	je     8000ca <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000b3:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000b8:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000bb:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000c1:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000c4:	39 c1                	cmp    %eax,%ecx
  8000c6:	75 18                	jne    8000e0 <libmain+0x4a>
  8000c8:	eb 05                	jmp    8000cf <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000cf:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000d2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000d8:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000de:	eb 0b                	jmp    8000eb <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000e0:	83 c2 01             	add    $0x1,%edx
  8000e3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000e9:	75 cd                	jne    8000b8 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000eb:	85 db                	test   %ebx,%ebx
  8000ed:	7e 07                	jle    8000f6 <libmain+0x60>
		binaryname = argv[0];
  8000ef:	8b 06                	mov    (%esi),%eax
  8000f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000fa:	89 1c 24             	mov    %ebx,(%esp)
  8000fd:	e8 76 ff ff ff       	call   800078 <umain>

	// exit gracefully
	exit();
  800102:	e8 07 00 00 00       	call   80010e <exit>
}
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800114:	e8 fd 10 00 00       	call   801216 <close_all>
	sys_env_destroy(0);
  800119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800120:	e8 24 0b 00 00       	call   800c49 <sys_env_destroy>
}
  800125:	c9                   	leave  
  800126:	c3                   	ret    

00800127 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	53                   	push   %ebx
  80012b:	83 ec 14             	sub    $0x14,%esp
  80012e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800131:	8b 13                	mov    (%ebx),%edx
  800133:	8d 42 01             	lea    0x1(%edx),%eax
  800136:	89 03                	mov    %eax,(%ebx)
  800138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800144:	75 19                	jne    80015f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800146:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80014d:	00 
  80014e:	8d 43 08             	lea    0x8(%ebx),%eax
  800151:	89 04 24             	mov    %eax,(%esp)
  800154:	e8 b3 0a 00 00       	call   800c0c <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80015f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800163:	83 c4 14             	add    $0x14,%esp
  800166:	5b                   	pop    %ebx
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800172:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800179:	00 00 00 
	b.cnt = 0;
  80017c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800183:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800186:	8b 45 0c             	mov    0xc(%ebp),%eax
  800189:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018d:	8b 45 08             	mov    0x8(%ebp),%eax
  800190:	89 44 24 08          	mov    %eax,0x8(%esp)
  800194:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	c7 04 24 27 01 80 00 	movl   $0x800127,(%esp)
  8001a5:	e8 ba 01 00 00       	call   800364 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001aa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ba:	89 04 24             	mov    %eax,(%esp)
  8001bd:	e8 4a 0a 00 00       	call   800c0c <sys_cputs>

	return b.cnt;
}
  8001c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	89 04 24             	mov    %eax,(%esp)
  8001dd:	e8 87 ff ff ff       	call   800169 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    
  8001e4:	66 90                	xchg   %ax,%ax
  8001e6:	66 90                	xchg   %ax,%ax
  8001e8:	66 90                	xchg   %ax,%ax
  8001ea:	66 90                	xchg   %ax,%ax
  8001ec:	66 90                	xchg   %ax,%ax
  8001ee:	66 90                	xchg   %ax,%ax

008001f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 3c             	sub    $0x3c,%esp
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 d7                	mov    %edx,%edi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800204:	8b 75 0c             	mov    0xc(%ebp),%esi
  800207:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80020a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800212:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800215:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800218:	39 f1                	cmp    %esi,%ecx
  80021a:	72 14                	jb     800230 <printnum+0x40>
  80021c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80021f:	76 0f                	jbe    800230 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800221:	8b 45 14             	mov    0x14(%ebp),%eax
  800224:	8d 70 ff             	lea    -0x1(%eax),%esi
  800227:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80022a:	85 f6                	test   %esi,%esi
  80022c:	7f 60                	jg     80028e <printnum+0x9e>
  80022e:	eb 72                	jmp    8002a2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800230:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800233:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800237:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80023a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80023d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800241:	89 44 24 08          	mov    %eax,0x8(%esp)
  800245:	8b 44 24 08          	mov    0x8(%esp),%eax
  800249:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80024d:	89 c3                	mov    %eax,%ebx
  80024f:	89 d6                	mov    %edx,%esi
  800251:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800254:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800257:	89 54 24 08          	mov    %edx,0x8(%esp)
  80025b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80025f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800262:	89 04 24             	mov    %eax,(%esp)
  800265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	e8 0f 1d 00 00       	call   801f80 <__udivdi3>
  800271:	89 d9                	mov    %ebx,%ecx
  800273:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800277:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800282:	89 fa                	mov    %edi,%edx
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	e8 64 ff ff ff       	call   8001f0 <printnum>
  80028c:	eb 14                	jmp    8002a2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800292:	8b 45 18             	mov    0x18(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80029a:	83 ee 01             	sub    $0x1,%esi
  80029d:	75 ef                	jne    80028e <printnum+0x9e>
  80029f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002bb:	89 04 24             	mov    %eax,(%esp)
  8002be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c5:	e8 e6 1d 00 00       	call   8020b0 <__umoddi3>
  8002ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ce:	0f be 80 52 22 80 00 	movsbl 0x802252(%eax),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002db:	ff d0                	call   *%eax
}
  8002dd:	83 c4 3c             	add    $0x3c,%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002e8:	83 fa 01             	cmp    $0x1,%edx
  8002eb:	7e 0e                	jle    8002fb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 02                	mov    (%edx),%eax
  8002f6:	8b 52 04             	mov    0x4(%edx),%edx
  8002f9:	eb 22                	jmp    80031d <getuint+0x38>
	else if (lflag)
  8002fb:	85 d2                	test   %edx,%edx
  8002fd:	74 10                	je     80030f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002ff:	8b 10                	mov    (%eax),%edx
  800301:	8d 4a 04             	lea    0x4(%edx),%ecx
  800304:	89 08                	mov    %ecx,(%eax)
  800306:	8b 02                	mov    (%edx),%eax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	eb 0e                	jmp    80031d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80030f:	8b 10                	mov    (%eax),%edx
  800311:	8d 4a 04             	lea    0x4(%edx),%ecx
  800314:	89 08                	mov    %ecx,(%eax)
  800316:	8b 02                	mov    (%edx),%eax
  800318:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800325:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	3b 50 04             	cmp    0x4(%eax),%edx
  80032e:	73 0a                	jae    80033a <sprintputch+0x1b>
		*b->buf++ = ch;
  800330:	8d 4a 01             	lea    0x1(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	88 02                	mov    %al,(%edx)
}
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800342:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800345:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	89 44 24 04          	mov    %eax,0x4(%esp)
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	89 04 24             	mov    %eax,(%esp)
  80035d:	e8 02 00 00 00       	call   800364 <vprintfmt>
	va_end(ap);
}
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	57                   	push   %edi
  800368:	56                   	push   %esi
  800369:	53                   	push   %ebx
  80036a:	83 ec 3c             	sub    $0x3c,%esp
  80036d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800370:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800373:	eb 18                	jmp    80038d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800375:	85 c0                	test   %eax,%eax
  800377:	0f 84 c3 03 00 00    	je     800740 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80037d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800381:	89 04 24             	mov    %eax,(%esp)
  800384:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800387:	89 f3                	mov    %esi,%ebx
  800389:	eb 02                	jmp    80038d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80038b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80038d:	8d 73 01             	lea    0x1(%ebx),%esi
  800390:	0f b6 03             	movzbl (%ebx),%eax
  800393:	83 f8 25             	cmp    $0x25,%eax
  800396:	75 dd                	jne    800375 <vprintfmt+0x11>
  800398:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80039c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003a3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b6:	eb 1d                	jmp    8003d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003ba:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8003be:	eb 15                	jmp    8003d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003c2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8003c6:	eb 0d                	jmp    8003d5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ce:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003d8:	0f b6 06             	movzbl (%esi),%eax
  8003db:	0f b6 c8             	movzbl %al,%ecx
  8003de:	83 e8 23             	sub    $0x23,%eax
  8003e1:	3c 55                	cmp    $0x55,%al
  8003e3:	0f 87 2f 03 00 00    	ja     800718 <vprintfmt+0x3b4>
  8003e9:	0f b6 c0             	movzbl %al,%eax
  8003ec:	ff 24 85 a0 23 80 00 	jmp    *0x8023a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003f3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8003f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8003f9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8003fd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800400:	83 f9 09             	cmp    $0x9,%ecx
  800403:	77 50                	ja     800455 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800405:	89 de                	mov    %ebx,%esi
  800407:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80040a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80040d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800410:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800414:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800417:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80041a:	83 fb 09             	cmp    $0x9,%ebx
  80041d:	76 eb                	jbe    80040a <vprintfmt+0xa6>
  80041f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800422:	eb 33                	jmp    800457 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 48 04             	lea    0x4(%eax),%ecx
  80042a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800434:	eb 21                	jmp    800457 <vprintfmt+0xf3>
  800436:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800439:	85 c9                	test   %ecx,%ecx
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	0f 49 c1             	cmovns %ecx,%eax
  800443:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
  800448:	eb 8b                	jmp    8003d5 <vprintfmt+0x71>
  80044a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80044c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800453:	eb 80                	jmp    8003d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800455:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800457:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80045b:	0f 89 74 ff ff ff    	jns    8003d5 <vprintfmt+0x71>
  800461:	e9 62 ff ff ff       	jmp    8003c8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800466:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800469:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80046b:	e9 65 ff ff ff       	jmp    8003d5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8d 50 04             	lea    0x4(%eax),%edx
  800476:	89 55 14             	mov    %edx,0x14(%ebp)
  800479:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	ff 55 08             	call   *0x8(%ebp)
			break;
  800485:	e9 03 ff ff ff       	jmp    80038d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8d 50 04             	lea    0x4(%eax),%edx
  800490:	89 55 14             	mov    %edx,0x14(%ebp)
  800493:	8b 00                	mov    (%eax),%eax
  800495:	99                   	cltd   
  800496:	31 d0                	xor    %edx,%eax
  800498:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049a:	83 f8 0f             	cmp    $0xf,%eax
  80049d:	7f 0b                	jg     8004aa <vprintfmt+0x146>
  80049f:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	75 20                	jne    8004ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ae:	c7 44 24 08 6a 22 80 	movl   $0x80226a,0x8(%esp)
  8004b5:	00 
  8004b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 77 fe ff ff       	call   80033c <printfmt>
  8004c5:	e9 c3 fe ff ff       	jmp    80038d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8004ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ce:	c7 44 24 08 73 26 80 	movl   $0x802673,0x8(%esp)
  8004d5:	00 
  8004d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 57 fe ff ff       	call   80033c <printfmt>
  8004e5:	e9 a3 fe ff ff       	jmp    80038d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ed:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	ba 63 22 80 00       	mov    $0x802263,%edx
  800502:	0f 45 d0             	cmovne %eax,%edx
  800505:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800508:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80050c:	74 04                	je     800512 <vprintfmt+0x1ae>
  80050e:	85 f6                	test   %esi,%esi
  800510:	7f 19                	jg     80052b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800512:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800515:	8d 70 01             	lea    0x1(%eax),%esi
  800518:	0f b6 10             	movzbl (%eax),%edx
  80051b:	0f be c2             	movsbl %dl,%eax
  80051e:	85 c0                	test   %eax,%eax
  800520:	0f 85 95 00 00 00    	jne    8005bb <vprintfmt+0x257>
  800526:	e9 85 00 00 00       	jmp    8005b0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80052f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800532:	89 04 24             	mov    %eax,(%esp)
  800535:	e8 b8 02 00 00       	call   8007f2 <strnlen>
  80053a:	29 c6                	sub    %eax,%esi
  80053c:	89 f0                	mov    %esi,%eax
  80053e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800541:	85 f6                	test   %esi,%esi
  800543:	7e cd                	jle    800512 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800545:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800549:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80054c:	89 c3                	mov    %eax,%ebx
  80054e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800552:	89 34 24             	mov    %esi,(%esp)
  800555:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	83 eb 01             	sub    $0x1,%ebx
  80055b:	75 f1                	jne    80054e <vprintfmt+0x1ea>
  80055d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800560:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800563:	eb ad                	jmp    800512 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800565:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800569:	74 1e                	je     800589 <vprintfmt+0x225>
  80056b:	0f be d2             	movsbl %dl,%edx
  80056e:	83 ea 20             	sub    $0x20,%edx
  800571:	83 fa 5e             	cmp    $0x5e,%edx
  800574:	76 13                	jbe    800589 <vprintfmt+0x225>
					putch('?', putdat);
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800584:	ff 55 08             	call   *0x8(%ebp)
  800587:	eb 0d                	jmp    800596 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800589:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800590:	89 04 24             	mov    %eax,(%esp)
  800593:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c6 01             	add    $0x1,%esi
  80059c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005a0:	0f be c2             	movsbl %dl,%eax
  8005a3:	85 c0                	test   %eax,%eax
  8005a5:	75 20                	jne    8005c7 <vprintfmt+0x263>
  8005a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b4:	7f 25                	jg     8005db <vprintfmt+0x277>
  8005b6:	e9 d2 fd ff ff       	jmp    80038d <vprintfmt+0x29>
  8005bb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c7:	85 db                	test   %ebx,%ebx
  8005c9:	78 9a                	js     800565 <vprintfmt+0x201>
  8005cb:	83 eb 01             	sub    $0x1,%ebx
  8005ce:	79 95                	jns    800565 <vprintfmt+0x201>
  8005d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005d9:	eb d5                	jmp    8005b0 <vprintfmt+0x24c>
  8005db:	8b 75 08             	mov    0x8(%ebp),%esi
  8005de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005ef:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f1:	83 eb 01             	sub    $0x1,%ebx
  8005f4:	75 ee                	jne    8005e4 <vprintfmt+0x280>
  8005f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f9:	e9 8f fd ff ff       	jmp    80038d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005fe:	83 fa 01             	cmp    $0x1,%edx
  800601:	7e 16                	jle    800619 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 50 08             	lea    0x8(%eax),%edx
  800609:	89 55 14             	mov    %edx,0x14(%ebp)
  80060c:	8b 50 04             	mov    0x4(%eax),%edx
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800614:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800617:	eb 32                	jmp    80064b <vprintfmt+0x2e7>
	else if (lflag)
  800619:	85 d2                	test   %edx,%edx
  80061b:	74 18                	je     800635 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 50 04             	lea    0x4(%eax),%edx
  800623:	89 55 14             	mov    %edx,0x14(%ebp)
  800626:	8b 30                	mov    (%eax),%esi
  800628:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80062b:	89 f0                	mov    %esi,%eax
  80062d:	c1 f8 1f             	sar    $0x1f,%eax
  800630:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800633:	eb 16                	jmp    80064b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 50 04             	lea    0x4(%eax),%edx
  80063b:	89 55 14             	mov    %edx,0x14(%ebp)
  80063e:	8b 30                	mov    (%eax),%esi
  800640:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800643:	89 f0                	mov    %esi,%eax
  800645:	c1 f8 1f             	sar    $0x1f,%eax
  800648:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800651:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800656:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80065a:	0f 89 80 00 00 00    	jns    8006e0 <vprintfmt+0x37c>
				putch('-', putdat);
  800660:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800664:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80066b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80066e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800671:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800674:	f7 d8                	neg    %eax
  800676:	83 d2 00             	adc    $0x0,%edx
  800679:	f7 da                	neg    %edx
			}
			base = 10;
  80067b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800680:	eb 5e                	jmp    8006e0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800682:	8d 45 14             	lea    0x14(%ebp),%eax
  800685:	e8 5b fc ff ff       	call   8002e5 <getuint>
			base = 10;
  80068a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80068f:	eb 4f                	jmp    8006e0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800691:	8d 45 14             	lea    0x14(%ebp),%eax
  800694:	e8 4c fc ff ff       	call   8002e5 <getuint>
			base = 8;
  800699:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80069e:	eb 40                	jmp    8006e0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006b9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 50 04             	lea    0x4(%eax),%edx
  8006c2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006cc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006d1:	eb 0d                	jmp    8006e0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d6:	e8 0a fc ff ff       	call   8002e5 <getuint>
			base = 16;
  8006db:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006e0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8006e4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006f3:	89 04 24             	mov    %eax,(%esp)
  8006f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006fa:	89 fa                	mov    %edi,%edx
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	e8 ec fa ff ff       	call   8001f0 <printnum>
			break;
  800704:	e9 84 fc ff ff       	jmp    80038d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800709:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070d:	89 0c 24             	mov    %ecx,(%esp)
  800710:	ff 55 08             	call   *0x8(%ebp)
			break;
  800713:	e9 75 fc ff ff       	jmp    80038d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800718:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800726:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80072a:	0f 84 5b fc ff ff    	je     80038b <vprintfmt+0x27>
  800730:	89 f3                	mov    %esi,%ebx
  800732:	83 eb 01             	sub    $0x1,%ebx
  800735:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800739:	75 f7                	jne    800732 <vprintfmt+0x3ce>
  80073b:	e9 4d fc ff ff       	jmp    80038d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800740:	83 c4 3c             	add    $0x3c,%esp
  800743:	5b                   	pop    %ebx
  800744:	5e                   	pop    %esi
  800745:	5f                   	pop    %edi
  800746:	5d                   	pop    %ebp
  800747:	c3                   	ret    

00800748 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 28             	sub    $0x28,%esp
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800757:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80075b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80075e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800765:	85 c0                	test   %eax,%eax
  800767:	74 30                	je     800799 <vsnprintf+0x51>
  800769:	85 d2                	test   %edx,%edx
  80076b:	7e 2c                	jle    800799 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800774:	8b 45 10             	mov    0x10(%ebp),%eax
  800777:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800782:	c7 04 24 1f 03 80 00 	movl   $0x80031f,(%esp)
  800789:	e8 d6 fb ff ff       	call   800364 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800791:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800797:	eb 05                	jmp    80079e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	89 04 24             	mov    %eax,(%esp)
  8007c1:	e8 82 ff ff ff       	call   800748 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    
  8007c8:	66 90                	xchg   %ax,%ax
  8007ca:	66 90                	xchg   %ax,%ax
  8007cc:	66 90                	xchg   %ax,%ax
  8007ce:	66 90                	xchg   %ax,%ax

008007d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d6:	80 3a 00             	cmpb   $0x0,(%edx)
  8007d9:	74 10                	je     8007eb <strlen+0x1b>
  8007db:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8007e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e7:	75 f7                	jne    8007e0 <strlen+0x10>
  8007e9:	eb 05                	jmp    8007f0 <strlen+0x20>
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	85 c9                	test   %ecx,%ecx
  8007fe:	74 1c                	je     80081c <strnlen+0x2a>
  800800:	80 3b 00             	cmpb   $0x0,(%ebx)
  800803:	74 1e                	je     800823 <strnlen+0x31>
  800805:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80080a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080c:	39 ca                	cmp    %ecx,%edx
  80080e:	74 18                	je     800828 <strnlen+0x36>
  800810:	83 c2 01             	add    $0x1,%edx
  800813:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800818:	75 f0                	jne    80080a <strnlen+0x18>
  80081a:	eb 0c                	jmp    800828 <strnlen+0x36>
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	eb 05                	jmp    800828 <strnlen+0x36>
  800823:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800828:	5b                   	pop    %ebx
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800835:	89 c2                	mov    %eax,%edx
  800837:	83 c2 01             	add    $0x1,%edx
  80083a:	83 c1 01             	add    $0x1,%ecx
  80083d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800841:	88 5a ff             	mov    %bl,-0x1(%edx)
  800844:	84 db                	test   %bl,%bl
  800846:	75 ef                	jne    800837 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800848:	5b                   	pop    %ebx
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800855:	89 1c 24             	mov    %ebx,(%esp)
  800858:	e8 73 ff ff ff       	call   8007d0 <strlen>
	strcpy(dst + len, src);
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800860:	89 54 24 04          	mov    %edx,0x4(%esp)
  800864:	01 d8                	add    %ebx,%eax
  800866:	89 04 24             	mov    %eax,(%esp)
  800869:	e8 bd ff ff ff       	call   80082b <strcpy>
	return dst;
}
  80086e:	89 d8                	mov    %ebx,%eax
  800870:	83 c4 08             	add    $0x8,%esp
  800873:	5b                   	pop    %ebx
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800884:	85 db                	test   %ebx,%ebx
  800886:	74 17                	je     80089f <strncpy+0x29>
  800888:	01 f3                	add    %esi,%ebx
  80088a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80088c:	83 c1 01             	add    $0x1,%ecx
  80088f:	0f b6 02             	movzbl (%edx),%eax
  800892:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800895:	80 3a 01             	cmpb   $0x1,(%edx)
  800898:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089b:	39 d9                	cmp    %ebx,%ecx
  80089d:	75 ed                	jne    80088c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80089f:	89 f0                	mov    %esi,%eax
  8008a1:	5b                   	pop    %ebx
  8008a2:	5e                   	pop    %esi
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	57                   	push   %edi
  8008a9:	56                   	push   %esi
  8008aa:	53                   	push   %ebx
  8008ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008b1:	8b 75 10             	mov    0x10(%ebp),%esi
  8008b4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b6:	85 f6                	test   %esi,%esi
  8008b8:	74 34                	je     8008ee <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8008ba:	83 fe 01             	cmp    $0x1,%esi
  8008bd:	74 26                	je     8008e5 <strlcpy+0x40>
  8008bf:	0f b6 0b             	movzbl (%ebx),%ecx
  8008c2:	84 c9                	test   %cl,%cl
  8008c4:	74 23                	je     8008e9 <strlcpy+0x44>
  8008c6:	83 ee 02             	sub    $0x2,%esi
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8008ce:	83 c0 01             	add    $0x1,%eax
  8008d1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008d4:	39 f2                	cmp    %esi,%edx
  8008d6:	74 13                	je     8008eb <strlcpy+0x46>
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008df:	84 c9                	test   %cl,%cl
  8008e1:	75 eb                	jne    8008ce <strlcpy+0x29>
  8008e3:	eb 06                	jmp    8008eb <strlcpy+0x46>
  8008e5:	89 f8                	mov    %edi,%eax
  8008e7:	eb 02                	jmp    8008eb <strlcpy+0x46>
  8008e9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ee:	29 f8                	sub    %edi,%eax
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5f                   	pop    %edi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fe:	0f b6 01             	movzbl (%ecx),%eax
  800901:	84 c0                	test   %al,%al
  800903:	74 15                	je     80091a <strcmp+0x25>
  800905:	3a 02                	cmp    (%edx),%al
  800907:	75 11                	jne    80091a <strcmp+0x25>
		p++, q++;
  800909:	83 c1 01             	add    $0x1,%ecx
  80090c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80090f:	0f b6 01             	movzbl (%ecx),%eax
  800912:	84 c0                	test   %al,%al
  800914:	74 04                	je     80091a <strcmp+0x25>
  800916:	3a 02                	cmp    (%edx),%al
  800918:	74 ef                	je     800909 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091a:	0f b6 c0             	movzbl %al,%eax
  80091d:	0f b6 12             	movzbl (%edx),%edx
  800920:	29 d0                	sub    %edx,%eax
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	56                   	push   %esi
  800928:	53                   	push   %ebx
  800929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800932:	85 f6                	test   %esi,%esi
  800934:	74 29                	je     80095f <strncmp+0x3b>
  800936:	0f b6 03             	movzbl (%ebx),%eax
  800939:	84 c0                	test   %al,%al
  80093b:	74 30                	je     80096d <strncmp+0x49>
  80093d:	3a 02                	cmp    (%edx),%al
  80093f:	75 2c                	jne    80096d <strncmp+0x49>
  800941:	8d 43 01             	lea    0x1(%ebx),%eax
  800944:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800946:	89 c3                	mov    %eax,%ebx
  800948:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80094b:	39 f0                	cmp    %esi,%eax
  80094d:	74 17                	je     800966 <strncmp+0x42>
  80094f:	0f b6 08             	movzbl (%eax),%ecx
  800952:	84 c9                	test   %cl,%cl
  800954:	74 17                	je     80096d <strncmp+0x49>
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	3a 0a                	cmp    (%edx),%cl
  80095b:	74 e9                	je     800946 <strncmp+0x22>
  80095d:	eb 0e                	jmp    80096d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	eb 0f                	jmp    800975 <strncmp+0x51>
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 08                	jmp    800975 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096d:	0f b6 03             	movzbl (%ebx),%eax
  800970:	0f b6 12             	movzbl (%edx),%edx
  800973:	29 d0                	sub    %edx,%eax
}
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800983:	0f b6 18             	movzbl (%eax),%ebx
  800986:	84 db                	test   %bl,%bl
  800988:	74 1d                	je     8009a7 <strchr+0x2e>
  80098a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80098c:	38 d3                	cmp    %dl,%bl
  80098e:	75 06                	jne    800996 <strchr+0x1d>
  800990:	eb 1a                	jmp    8009ac <strchr+0x33>
  800992:	38 ca                	cmp    %cl,%dl
  800994:	74 16                	je     8009ac <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	0f b6 10             	movzbl (%eax),%edx
  80099c:	84 d2                	test   %dl,%dl
  80099e:	75 f2                	jne    800992 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	eb 05                	jmp    8009ac <strchr+0x33>
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	53                   	push   %ebx
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009b9:	0f b6 18             	movzbl (%eax),%ebx
  8009bc:	84 db                	test   %bl,%bl
  8009be:	74 16                	je     8009d6 <strfind+0x27>
  8009c0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009c2:	38 d3                	cmp    %dl,%bl
  8009c4:	75 06                	jne    8009cc <strfind+0x1d>
  8009c6:	eb 0e                	jmp    8009d6 <strfind+0x27>
  8009c8:	38 ca                	cmp    %cl,%dl
  8009ca:	74 0a                	je     8009d6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	0f b6 10             	movzbl (%eax),%edx
  8009d2:	84 d2                	test   %dl,%dl
  8009d4:	75 f2                	jne    8009c8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  8009d6:	5b                   	pop    %ebx
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	57                   	push   %edi
  8009dd:	56                   	push   %esi
  8009de:	53                   	push   %ebx
  8009df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e5:	85 c9                	test   %ecx,%ecx
  8009e7:	74 36                	je     800a1f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009e9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ef:	75 28                	jne    800a19 <memset+0x40>
  8009f1:	f6 c1 03             	test   $0x3,%cl
  8009f4:	75 23                	jne    800a19 <memset+0x40>
		c &= 0xFF;
  8009f6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fa:	89 d3                	mov    %edx,%ebx
  8009fc:	c1 e3 08             	shl    $0x8,%ebx
  8009ff:	89 d6                	mov    %edx,%esi
  800a01:	c1 e6 18             	shl    $0x18,%esi
  800a04:	89 d0                	mov    %edx,%eax
  800a06:	c1 e0 10             	shl    $0x10,%eax
  800a09:	09 f0                	or     %esi,%eax
  800a0b:	09 c2                	or     %eax,%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a11:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a14:	fc                   	cld    
  800a15:	f3 ab                	rep stos %eax,%es:(%edi)
  800a17:	eb 06                	jmp    800a1f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	fc                   	cld    
  800a1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1f:	89 f8                	mov    %edi,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a34:	39 c6                	cmp    %eax,%esi
  800a36:	73 35                	jae    800a6d <memmove+0x47>
  800a38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3b:	39 d0                	cmp    %edx,%eax
  800a3d:	73 2e                	jae    800a6d <memmove+0x47>
		s += n;
		d += n;
  800a3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4c:	75 13                	jne    800a61 <memmove+0x3b>
  800a4e:	f6 c1 03             	test   $0x3,%cl
  800a51:	75 0e                	jne    800a61 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a53:	83 ef 04             	sub    $0x4,%edi
  800a56:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a59:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a5c:	fd                   	std    
  800a5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5f:	eb 09                	jmp    800a6a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a61:	83 ef 01             	sub    $0x1,%edi
  800a64:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a67:	fd                   	std    
  800a68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6a:	fc                   	cld    
  800a6b:	eb 1d                	jmp    800a8a <memmove+0x64>
  800a6d:	89 f2                	mov    %esi,%edx
  800a6f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a71:	f6 c2 03             	test   $0x3,%dl
  800a74:	75 0f                	jne    800a85 <memmove+0x5f>
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	75 0a                	jne    800a85 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a7e:	89 c7                	mov    %eax,%edi
  800a80:	fc                   	cld    
  800a81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a83:	eb 05                	jmp    800a8a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a85:	89 c7                	mov    %eax,%edi
  800a87:	fc                   	cld    
  800a88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a8a:	5e                   	pop    %esi
  800a8b:	5f                   	pop    %edi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a94:	8b 45 10             	mov    0x10(%ebp),%eax
  800a97:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 04 24             	mov    %eax,(%esp)
  800aa8:	e8 79 ff ff ff       	call   800a26 <memmove>
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ab8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abe:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 36                	je     800afb <memcmp+0x4c>
		if (*s1 != *s2)
  800ac5:	0f b6 03             	movzbl (%ebx),%eax
  800ac8:	0f b6 0e             	movzbl (%esi),%ecx
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	38 c8                	cmp    %cl,%al
  800ad2:	74 1c                	je     800af0 <memcmp+0x41>
  800ad4:	eb 10                	jmp    800ae6 <memcmp+0x37>
  800ad6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800ae2:	38 c8                	cmp    %cl,%al
  800ae4:	74 0a                	je     800af0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800ae6:	0f b6 c0             	movzbl %al,%eax
  800ae9:	0f b6 c9             	movzbl %cl,%ecx
  800aec:	29 c8                	sub    %ecx,%eax
  800aee:	eb 10                	jmp    800b00 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af0:	39 fa                	cmp    %edi,%edx
  800af2:	75 e2                	jne    800ad6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
  800af9:	eb 05                	jmp    800b00 <memcmp+0x51>
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b14:	39 d0                	cmp    %edx,%eax
  800b16:	73 13                	jae    800b2b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b18:	89 d9                	mov    %ebx,%ecx
  800b1a:	38 18                	cmp    %bl,(%eax)
  800b1c:	75 06                	jne    800b24 <memfind+0x1f>
  800b1e:	eb 0b                	jmp    800b2b <memfind+0x26>
  800b20:	38 08                	cmp    %cl,(%eax)
  800b22:	74 07                	je     800b2b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	39 d0                	cmp    %edx,%eax
  800b29:	75 f5                	jne    800b20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	57                   	push   %edi
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3a:	0f b6 0a             	movzbl (%edx),%ecx
  800b3d:	80 f9 09             	cmp    $0x9,%cl
  800b40:	74 05                	je     800b47 <strtol+0x19>
  800b42:	80 f9 20             	cmp    $0x20,%cl
  800b45:	75 10                	jne    800b57 <strtol+0x29>
		s++;
  800b47:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4a:	0f b6 0a             	movzbl (%edx),%ecx
  800b4d:	80 f9 09             	cmp    $0x9,%cl
  800b50:	74 f5                	je     800b47 <strtol+0x19>
  800b52:	80 f9 20             	cmp    $0x20,%cl
  800b55:	74 f0                	je     800b47 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b57:	80 f9 2b             	cmp    $0x2b,%cl
  800b5a:	75 0a                	jne    800b66 <strtol+0x38>
		s++;
  800b5c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b64:	eb 11                	jmp    800b77 <strtol+0x49>
  800b66:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b6b:	80 f9 2d             	cmp    $0x2d,%cl
  800b6e:	75 07                	jne    800b77 <strtol+0x49>
		s++, neg = 1;
  800b70:	83 c2 01             	add    $0x1,%edx
  800b73:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b77:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b7c:	75 15                	jne    800b93 <strtol+0x65>
  800b7e:	80 3a 30             	cmpb   $0x30,(%edx)
  800b81:	75 10                	jne    800b93 <strtol+0x65>
  800b83:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b87:	75 0a                	jne    800b93 <strtol+0x65>
		s += 2, base = 16;
  800b89:	83 c2 02             	add    $0x2,%edx
  800b8c:	b8 10 00 00 00       	mov    $0x10,%eax
  800b91:	eb 10                	jmp    800ba3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800b93:	85 c0                	test   %eax,%eax
  800b95:	75 0c                	jne    800ba3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b97:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b99:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9c:	75 05                	jne    800ba3 <strtol+0x75>
		s++, base = 8;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ba3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bab:	0f b6 0a             	movzbl (%edx),%ecx
  800bae:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bb1:	89 f0                	mov    %esi,%eax
  800bb3:	3c 09                	cmp    $0x9,%al
  800bb5:	77 08                	ja     800bbf <strtol+0x91>
			dig = *s - '0';
  800bb7:	0f be c9             	movsbl %cl,%ecx
  800bba:	83 e9 30             	sub    $0x30,%ecx
  800bbd:	eb 20                	jmp    800bdf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800bbf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bc2:	89 f0                	mov    %esi,%eax
  800bc4:	3c 19                	cmp    $0x19,%al
  800bc6:	77 08                	ja     800bd0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800bc8:	0f be c9             	movsbl %cl,%ecx
  800bcb:	83 e9 57             	sub    $0x57,%ecx
  800bce:	eb 0f                	jmp    800bdf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800bd0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bd3:	89 f0                	mov    %esi,%eax
  800bd5:	3c 19                	cmp    $0x19,%al
  800bd7:	77 16                	ja     800bef <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd9:	0f be c9             	movsbl %cl,%ecx
  800bdc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bdf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800be2:	7d 0f                	jge    800bf3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800be4:	83 c2 01             	add    $0x1,%edx
  800be7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800beb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bed:	eb bc                	jmp    800bab <strtol+0x7d>
  800bef:	89 d8                	mov    %ebx,%eax
  800bf1:	eb 02                	jmp    800bf5 <strtol+0xc7>
  800bf3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf9:	74 05                	je     800c00 <strtol+0xd2>
		*endptr = (char *) s;
  800bfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfe:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c00:	f7 d8                	neg    %eax
  800c02:	85 ff                	test   %edi,%edi
  800c04:	0f 44 c3             	cmove  %ebx,%eax
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	89 c3                	mov    %eax,%ebx
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	89 c6                	mov    %eax,%esi
  800c23:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3a:	89 d1                	mov    %edx,%ecx
  800c3c:	89 d3                	mov    %edx,%ebx
  800c3e:	89 d7                	mov    %edx,%edi
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c57:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5f:	89 cb                	mov    %ecx,%ebx
  800c61:	89 cf                	mov    %ecx,%edi
  800c63:	89 ce                	mov    %ecx,%esi
  800c65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7e 28                	jle    800c93 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c76:	00 
  800c77:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800c7e:	00 
  800c7f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c86:	00 
  800c87:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800c8e:	e8 43 11 00 00       	call   801dd6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c93:	83 c4 2c             	add    $0x2c,%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cab:	89 d1                	mov    %edx,%ecx
  800cad:	89 d3                	mov    %edx,%ebx
  800caf:	89 d7                	mov    %edx,%edi
  800cb1:	89 d6                	mov    %edx,%esi
  800cb3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_yield>:

void
sys_yield(void)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cca:	89 d1                	mov    %edx,%ecx
  800ccc:	89 d3                	mov    %edx,%ebx
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	89 d6                	mov    %edx,%esi
  800cd2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce2:	be 00 00 00 00       	mov    $0x0,%esi
  800ce7:	b8 04 00 00 00       	mov    $0x4,%eax
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf5:	89 f7                	mov    %esi,%edi
  800cf7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	7e 28                	jle    800d25 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d01:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d08:	00 
  800d09:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800d10:	00 
  800d11:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d18:	00 
  800d19:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800d20:	e8 b1 10 00 00       	call   801dd6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d25:	83 c4 2c             	add    $0x2c,%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d36:	b8 05 00 00 00       	mov    $0x5,%eax
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d47:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7e 28                	jle    800d78 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d54:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d5b:	00 
  800d5c:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800d73:	e8 5e 10 00 00       	call   801dd6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d78:	83 c4 2c             	add    $0x2c,%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7e 28                	jle    800dcb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dae:	00 
  800daf:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800dc6:	e8 0b 10 00 00       	call   801dd6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcb:	83 c4 2c             	add    $0x2c,%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	b8 08 00 00 00       	mov    $0x8,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7e 28                	jle    800e1e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfa:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e01:	00 
  800e02:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800e09:	00 
  800e0a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e11:	00 
  800e12:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800e19:	e8 b8 0f 00 00       	call   801dd6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1e:	83 c4 2c             	add    $0x2c,%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e34:	b8 09 00 00 00       	mov    $0x9,%eax
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	89 de                	mov    %ebx,%esi
  800e43:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7e 28                	jle    800e71 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e54:	00 
  800e55:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800e5c:	00 
  800e5d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e64:	00 
  800e65:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800e6c:	e8 65 0f 00 00       	call   801dd6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e71:	83 c4 2c             	add    $0x2c,%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7e 28                	jle    800ec4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ea7:	00 
  800ea8:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800ebf:	e8 12 0f 00 00       	call   801dd6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec4:	83 c4 2c             	add    $0x2c,%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	be 00 00 00 00       	mov    $0x0,%esi
  800ed7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	89 cb                	mov    %ecx,%ebx
  800f07:	89 cf                	mov    %ecx,%edi
  800f09:	89 ce                	mov    %ecx,%esi
  800f0b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7e 28                	jle    800f39 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f11:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f15:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f1c:	00 
  800f1d:	c7 44 24 08 5f 25 80 	movl   $0x80255f,0x8(%esp)
  800f24:	00 
  800f25:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f2c:	00 
  800f2d:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  800f34:	e8 9d 0e 00 00       	call   801dd6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f39:	83 c4 2c             	add    $0x2c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  800f47:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800f4e:	75 50                	jne    800fa0 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  800f50:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f57:	00 
  800f58:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800f5f:	ee 
  800f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f67:	e8 6d fd ff ff       	call   800cd9 <sys_page_alloc>
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	79 1c                	jns    800f8c <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  800f70:	c7 44 24 08 8c 25 80 	movl   $0x80258c,0x8(%esp)
  800f77:	00 
  800f78:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  800f7f:	00 
  800f80:	c7 04 24 b0 25 80 00 	movl   $0x8025b0,(%esp)
  800f87:	e8 4a 0e 00 00       	call   801dd6 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  800f8c:	c7 44 24 04 aa 0f 80 	movl   $0x800faa,0x4(%esp)
  800f93:	00 
  800f94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f9b:	e8 d9 fe ff ff       	call   800e79 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800faa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fab:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800fb0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fb2:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  800fb5:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  800fb7:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  800fbc:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  800fbf:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  800fc4:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  800fc7:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  800fc9:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  800fcc:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  800fce:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  800fd0:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  800fd5:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  800fd8:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  800fdd:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  800fe0:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  800fe2:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  800fe7:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  800fea:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  800fef:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  800ff2:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  800ff4:	83 c4 08             	add    $0x8,%esp
	popal
  800ff7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  800ff8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800ff9:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800ffa:	c3                   	ret    
  800ffb:	66 90                	xchg   %ax,%ax
  800ffd:	66 90                	xchg   %ax,%ax
  800fff:	90                   	nop

00801000 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	05 00 00 00 30       	add    $0x30000000,%eax
  80100b:	c1 e8 0c             	shr    $0xc,%eax
}
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80101b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801020:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80102a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80102f:	a8 01                	test   $0x1,%al
  801031:	74 34                	je     801067 <fd_alloc+0x40>
  801033:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801038:	a8 01                	test   $0x1,%al
  80103a:	74 32                	je     80106e <fd_alloc+0x47>
  80103c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801041:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801043:	89 c2                	mov    %eax,%edx
  801045:	c1 ea 16             	shr    $0x16,%edx
  801048:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	74 1f                	je     801073 <fd_alloc+0x4c>
  801054:	89 c2                	mov    %eax,%edx
  801056:	c1 ea 0c             	shr    $0xc,%edx
  801059:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801060:	f6 c2 01             	test   $0x1,%dl
  801063:	75 1a                	jne    80107f <fd_alloc+0x58>
  801065:	eb 0c                	jmp    801073 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801067:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80106c:	eb 05                	jmp    801073 <fd_alloc+0x4c>
  80106e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 08                	mov    %ecx,(%eax)
			return 0;
  801078:	b8 00 00 00 00       	mov    $0x0,%eax
  80107d:	eb 1a                	jmp    801099 <fd_alloc+0x72>
  80107f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801084:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801089:	75 b6                	jne    801041 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801094:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a1:	83 f8 1f             	cmp    $0x1f,%eax
  8010a4:	77 36                	ja     8010dc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a6:	c1 e0 0c             	shl    $0xc,%eax
  8010a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ae:	89 c2                	mov    %eax,%edx
  8010b0:	c1 ea 16             	shr    $0x16,%edx
  8010b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ba:	f6 c2 01             	test   $0x1,%dl
  8010bd:	74 24                	je     8010e3 <fd_lookup+0x48>
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	c1 ea 0c             	shr    $0xc,%edx
  8010c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cb:	f6 c2 01             	test   $0x1,%dl
  8010ce:	74 1a                	je     8010ea <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb 13                	jmp    8010ef <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e1:	eb 0c                	jmp    8010ef <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e8:	eb 05                	jmp    8010ef <fd_lookup+0x54>
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    

008010f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 14             	sub    $0x14,%esp
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8010fe:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801104:	75 1e                	jne    801124 <dev_lookup+0x33>
  801106:	eb 0e                	jmp    801116 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801108:	b8 20 30 80 00       	mov    $0x803020,%eax
  80110d:	eb 0c                	jmp    80111b <dev_lookup+0x2a>
  80110f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801114:	eb 05                	jmp    80111b <dev_lookup+0x2a>
  801116:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80111b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
  801122:	eb 38                	jmp    80115c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801124:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80112a:	74 dc                	je     801108 <dev_lookup+0x17>
  80112c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801132:	74 db                	je     80110f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801134:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80113a:	8b 52 48             	mov    0x48(%edx),%edx
  80113d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801141:	89 54 24 04          	mov    %edx,0x4(%esp)
  801145:	c7 04 24 c0 25 80 00 	movl   $0x8025c0,(%esp)
  80114c:	e8 79 f0 ff ff       	call   8001ca <cprintf>
	*dev = 0;
  801151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80115c:	83 c4 14             	add    $0x14,%esp
  80115f:	5b                   	pop    %ebx
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	56                   	push   %esi
  801166:	53                   	push   %ebx
  801167:	83 ec 20             	sub    $0x20,%esp
  80116a:	8b 75 08             	mov    0x8(%ebp),%esi
  80116d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801173:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801177:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80117d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801180:	89 04 24             	mov    %eax,(%esp)
  801183:	e8 13 ff ff ff       	call   80109b <fd_lookup>
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 05                	js     801191 <fd_close+0x2f>
	    || fd != fd2)
  80118c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80118f:	74 0c                	je     80119d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801191:	84 db                	test   %bl,%bl
  801193:	ba 00 00 00 00       	mov    $0x0,%edx
  801198:	0f 44 c2             	cmove  %edx,%eax
  80119b:	eb 3f                	jmp    8011dc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80119d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a4:	8b 06                	mov    (%esi),%eax
  8011a6:	89 04 24             	mov    %eax,(%esp)
  8011a9:	e8 43 ff ff ff       	call   8010f1 <dev_lookup>
  8011ae:	89 c3                	mov    %eax,%ebx
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 16                	js     8011ca <fd_close+0x68>
		if (dev->dev_close)
  8011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	74 07                	je     8011ca <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011c3:	89 34 24             	mov    %esi,(%esp)
  8011c6:	ff d0                	call   *%eax
  8011c8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d5:	e8 a6 fb ff ff       	call   800d80 <sys_page_unmap>
	return r;
  8011da:	89 d8                	mov    %ebx,%eax
}
  8011dc:	83 c4 20             	add    $0x20,%esp
  8011df:	5b                   	pop    %ebx
  8011e0:	5e                   	pop    %esi
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    

008011e3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	89 04 24             	mov    %eax,(%esp)
  8011f6:	e8 a0 fe ff ff       	call   80109b <fd_lookup>
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	85 d2                	test   %edx,%edx
  8011ff:	78 13                	js     801214 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801208:	00 
  801209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120c:	89 04 24             	mov    %eax,(%esp)
  80120f:	e8 4e ff ff ff       	call   801162 <fd_close>
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <close_all>:

void
close_all(void)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	53                   	push   %ebx
  80121a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80121d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801222:	89 1c 24             	mov    %ebx,(%esp)
  801225:	e8 b9 ff ff ff       	call   8011e3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80122a:	83 c3 01             	add    $0x1,%ebx
  80122d:	83 fb 20             	cmp    $0x20,%ebx
  801230:	75 f0                	jne    801222 <close_all+0xc>
		close(i);
}
  801232:	83 c4 14             	add    $0x14,%esp
  801235:	5b                   	pop    %ebx
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	57                   	push   %edi
  80123c:	56                   	push   %esi
  80123d:	53                   	push   %ebx
  80123e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801241:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801244:	89 44 24 04          	mov    %eax,0x4(%esp)
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 04 24             	mov    %eax,(%esp)
  80124e:	e8 48 fe ff ff       	call   80109b <fd_lookup>
  801253:	89 c2                	mov    %eax,%edx
  801255:	85 d2                	test   %edx,%edx
  801257:	0f 88 e1 00 00 00    	js     80133e <dup+0x106>
		return r;
	close(newfdnum);
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	89 04 24             	mov    %eax,(%esp)
  801263:	e8 7b ff ff ff       	call   8011e3 <close>

	newfd = INDEX2FD(newfdnum);
  801268:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80126b:	c1 e3 0c             	shl    $0xc,%ebx
  80126e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801277:	89 04 24             	mov    %eax,(%esp)
  80127a:	e8 91 fd ff ff       	call   801010 <fd2data>
  80127f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801281:	89 1c 24             	mov    %ebx,(%esp)
  801284:	e8 87 fd ff ff       	call   801010 <fd2data>
  801289:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80128b:	89 f0                	mov    %esi,%eax
  80128d:	c1 e8 16             	shr    $0x16,%eax
  801290:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801297:	a8 01                	test   $0x1,%al
  801299:	74 43                	je     8012de <dup+0xa6>
  80129b:	89 f0                	mov    %esi,%eax
  80129d:	c1 e8 0c             	shr    $0xc,%eax
  8012a0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a7:	f6 c2 01             	test   $0x1,%dl
  8012aa:	74 32                	je     8012de <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c7:	00 
  8012c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d3:	e8 55 fa ff ff       	call   800d2d <sys_page_map>
  8012d8:	89 c6                	mov    %eax,%esi
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 3e                	js     80131c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	c1 ea 0c             	shr    $0xc,%edx
  8012e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ed:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801302:	00 
  801303:	89 44 24 04          	mov    %eax,0x4(%esp)
  801307:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130e:	e8 1a fa ff ff       	call   800d2d <sys_page_map>
  801313:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801318:	85 f6                	test   %esi,%esi
  80131a:	79 22                	jns    80133e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80131c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801327:	e8 54 fa ff ff       	call   800d80 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80132c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801330:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801337:	e8 44 fa ff ff       	call   800d80 <sys_page_unmap>
	return r;
  80133c:	89 f0                	mov    %esi,%eax
}
  80133e:	83 c4 3c             	add    $0x3c,%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    

00801346 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	53                   	push   %ebx
  80134a:	83 ec 24             	sub    $0x24,%esp
  80134d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801353:	89 44 24 04          	mov    %eax,0x4(%esp)
  801357:	89 1c 24             	mov    %ebx,(%esp)
  80135a:	e8 3c fd ff ff       	call   80109b <fd_lookup>
  80135f:	89 c2                	mov    %eax,%edx
  801361:	85 d2                	test   %edx,%edx
  801363:	78 6d                	js     8013d2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801365:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	89 04 24             	mov    %eax,(%esp)
  801374:	e8 78 fd ff ff       	call   8010f1 <dev_lookup>
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 55                	js     8013d2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801380:	8b 50 08             	mov    0x8(%eax),%edx
  801383:	83 e2 03             	and    $0x3,%edx
  801386:	83 fa 01             	cmp    $0x1,%edx
  801389:	75 23                	jne    8013ae <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138b:	a1 04 40 80 00       	mov    0x804004,%eax
  801390:	8b 40 48             	mov    0x48(%eax),%eax
  801393:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139b:	c7 04 24 01 26 80 00 	movl   $0x802601,(%esp)
  8013a2:	e8 23 ee ff ff       	call   8001ca <cprintf>
		return -E_INVAL;
  8013a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ac:	eb 24                	jmp    8013d2 <read+0x8c>
	}
	if (!dev->dev_read)
  8013ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b1:	8b 52 08             	mov    0x8(%edx),%edx
  8013b4:	85 d2                	test   %edx,%edx
  8013b6:	74 15                	je     8013cd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013c6:	89 04 24             	mov    %eax,(%esp)
  8013c9:	ff d2                	call   *%edx
  8013cb:	eb 05                	jmp    8013d2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013d2:	83 c4 24             	add    $0x24,%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	57                   	push   %edi
  8013dc:	56                   	push   %esi
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 1c             	sub    $0x1c,%esp
  8013e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e7:	85 f6                	test   %esi,%esi
  8013e9:	74 33                	je     80141e <readn+0x46>
  8013eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f5:	89 f2                	mov    %esi,%edx
  8013f7:	29 c2                	sub    %eax,%edx
  8013f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013fd:	03 45 0c             	add    0xc(%ebp),%eax
  801400:	89 44 24 04          	mov    %eax,0x4(%esp)
  801404:	89 3c 24             	mov    %edi,(%esp)
  801407:	e8 3a ff ff ff       	call   801346 <read>
		if (m < 0)
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 1b                	js     80142b <readn+0x53>
			return m;
		if (m == 0)
  801410:	85 c0                	test   %eax,%eax
  801412:	74 11                	je     801425 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801414:	01 c3                	add    %eax,%ebx
  801416:	89 d8                	mov    %ebx,%eax
  801418:	39 f3                	cmp    %esi,%ebx
  80141a:	72 d9                	jb     8013f5 <readn+0x1d>
  80141c:	eb 0b                	jmp    801429 <readn+0x51>
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	eb 06                	jmp    80142b <readn+0x53>
  801425:	89 d8                	mov    %ebx,%eax
  801427:	eb 02                	jmp    80142b <readn+0x53>
  801429:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80142b:	83 c4 1c             	add    $0x1c,%esp
  80142e:	5b                   	pop    %ebx
  80142f:	5e                   	pop    %esi
  801430:	5f                   	pop    %edi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	53                   	push   %ebx
  801437:	83 ec 24             	sub    $0x24,%esp
  80143a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801440:	89 44 24 04          	mov    %eax,0x4(%esp)
  801444:	89 1c 24             	mov    %ebx,(%esp)
  801447:	e8 4f fc ff ff       	call   80109b <fd_lookup>
  80144c:	89 c2                	mov    %eax,%edx
  80144e:	85 d2                	test   %edx,%edx
  801450:	78 68                	js     8014ba <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801452:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801455:	89 44 24 04          	mov    %eax,0x4(%esp)
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	8b 00                	mov    (%eax),%eax
  80145e:	89 04 24             	mov    %eax,(%esp)
  801461:	e8 8b fc ff ff       	call   8010f1 <dev_lookup>
  801466:	85 c0                	test   %eax,%eax
  801468:	78 50                	js     8014ba <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801471:	75 23                	jne    801496 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801473:	a1 04 40 80 00       	mov    0x804004,%eax
  801478:	8b 40 48             	mov    0x48(%eax),%eax
  80147b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801483:	c7 04 24 1d 26 80 00 	movl   $0x80261d,(%esp)
  80148a:	e8 3b ed ff ff       	call   8001ca <cprintf>
		return -E_INVAL;
  80148f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801494:	eb 24                	jmp    8014ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801499:	8b 52 0c             	mov    0xc(%edx),%edx
  80149c:	85 d2                	test   %edx,%edx
  80149e:	74 15                	je     8014b5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ae:	89 04 24             	mov    %eax,(%esp)
  8014b1:	ff d2                	call   *%edx
  8014b3:	eb 05                	jmp    8014ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ba:	83 c4 24             	add    $0x24,%esp
  8014bd:	5b                   	pop    %ebx
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	89 04 24             	mov    %eax,(%esp)
  8014d3:	e8 c3 fb ff ff       	call   80109b <fd_lookup>
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 0e                	js     8014ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 24             	sub    $0x24,%esp
  8014f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fd:	89 1c 24             	mov    %ebx,(%esp)
  801500:	e8 96 fb ff ff       	call   80109b <fd_lookup>
  801505:	89 c2                	mov    %eax,%edx
  801507:	85 d2                	test   %edx,%edx
  801509:	78 61                	js     80156c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 d2 fb ff ff       	call   8010f1 <dev_lookup>
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 49                	js     80156c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152a:	75 23                	jne    80154f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80152c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801531:	8b 40 48             	mov    0x48(%eax),%eax
  801534:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153c:	c7 04 24 e0 25 80 00 	movl   $0x8025e0,(%esp)
  801543:	e8 82 ec ff ff       	call   8001ca <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154d:	eb 1d                	jmp    80156c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801552:	8b 52 18             	mov    0x18(%edx),%edx
  801555:	85 d2                	test   %edx,%edx
  801557:	74 0e                	je     801567 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801559:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80155c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	ff d2                	call   *%edx
  801565:	eb 05                	jmp    80156c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801567:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80156c:	83 c4 24             	add    $0x24,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	53                   	push   %ebx
  801576:	83 ec 24             	sub    $0x24,%esp
  801579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 04 24             	mov    %eax,(%esp)
  801589:	e8 0d fb ff ff       	call   80109b <fd_lookup>
  80158e:	89 c2                	mov    %eax,%edx
  801590:	85 d2                	test   %edx,%edx
  801592:	78 52                	js     8015e6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 49 fb ff ff       	call   8010f1 <dev_lookup>
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 3a                	js     8015e6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b3:	74 2c                	je     8015e1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015b8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015bf:	00 00 00 
	stat->st_isdir = 0;
  8015c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015c9:	00 00 00 
	stat->st_dev = dev;
  8015cc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d9:	89 14 24             	mov    %edx,(%esp)
  8015dc:	ff 50 14             	call   *0x14(%eax)
  8015df:	eb 05                	jmp    8015e6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015e6:	83 c4 24             	add    $0x24,%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	56                   	push   %esi
  8015f0:	53                   	push   %ebx
  8015f1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015fb:	00 
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	89 04 24             	mov    %eax,(%esp)
  801602:	e8 e1 01 00 00       	call   8017e8 <open>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	85 db                	test   %ebx,%ebx
  80160b:	78 1b                	js     801628 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	89 44 24 04          	mov    %eax,0x4(%esp)
  801614:	89 1c 24             	mov    %ebx,(%esp)
  801617:	e8 56 ff ff ff       	call   801572 <fstat>
  80161c:	89 c6                	mov    %eax,%esi
	close(fd);
  80161e:	89 1c 24             	mov    %ebx,(%esp)
  801621:	e8 bd fb ff ff       	call   8011e3 <close>
	return r;
  801626:	89 f0                	mov    %esi,%eax
}
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	5b                   	pop    %ebx
  80162c:	5e                   	pop    %esi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    

0080162f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 10             	sub    $0x10,%esp
  801637:	89 c3                	mov    %eax,%ebx
  801639:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80163b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801642:	75 11                	jne    801655 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80164b:	e8 aa 08 00 00       	call   801efa <ipc_find_env>
  801650:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801655:	a1 04 40 80 00       	mov    0x804004,%eax
  80165a:	8b 40 48             	mov    0x48(%eax),%eax
  80165d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801663:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801667:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80166b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166f:	c7 04 24 3a 26 80 00 	movl   $0x80263a,(%esp)
  801676:	e8 4f eb ff ff       	call   8001ca <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80167b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801682:	00 
  801683:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80168a:	00 
  80168b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80168f:	a1 00 40 80 00       	mov    0x804000,%eax
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 f8 07 00 00       	call   801e94 <ipc_send>
	cprintf("ipc_send\n");
  80169c:	c7 04 24 50 26 80 00 	movl   $0x802650,(%esp)
  8016a3:	e8 22 eb ff ff       	call   8001ca <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  8016a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016af:	00 
  8016b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bb:	e8 6c 07 00 00       	call   801e2c <ipc_recv>
}
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 14             	sub    $0x14,%esp
  8016ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e6:	e8 44 ff ff ff       	call   80162f <fsipc>
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	85 d2                	test   %edx,%edx
  8016ef:	78 2b                	js     80171c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f1:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016f8:	00 
  8016f9:	89 1c 24             	mov    %ebx,(%esp)
  8016fc:	e8 2a f1 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801701:	a1 80 50 80 00       	mov    0x805080,%eax
  801706:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80170c:	a1 84 50 80 00       	mov    0x805084,%eax
  801711:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171c:	83 c4 14             	add    $0x14,%esp
  80171f:	5b                   	pop    %ebx
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8b 40 0c             	mov    0xc(%eax),%eax
  80172e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801733:	ba 00 00 00 00       	mov    $0x0,%edx
  801738:	b8 06 00 00 00       	mov    $0x6,%eax
  80173d:	e8 ed fe ff ff       	call   80162f <fsipc>
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	83 ec 10             	sub    $0x10,%esp
  80174c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80175a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	b8 03 00 00 00       	mov    $0x3,%eax
  80176a:	e8 c0 fe ff ff       	call   80162f <fsipc>
  80176f:	89 c3                	mov    %eax,%ebx
  801771:	85 c0                	test   %eax,%eax
  801773:	78 6a                	js     8017df <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801775:	39 c6                	cmp    %eax,%esi
  801777:	73 24                	jae    80179d <devfile_read+0x59>
  801779:	c7 44 24 0c 5a 26 80 	movl   $0x80265a,0xc(%esp)
  801780:	00 
  801781:	c7 44 24 08 61 26 80 	movl   $0x802661,0x8(%esp)
  801788:	00 
  801789:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801790:	00 
  801791:	c7 04 24 76 26 80 00 	movl   $0x802676,(%esp)
  801798:	e8 39 06 00 00       	call   801dd6 <_panic>
	assert(r <= PGSIZE);
  80179d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a2:	7e 24                	jle    8017c8 <devfile_read+0x84>
  8017a4:	c7 44 24 0c 81 26 80 	movl   $0x802681,0xc(%esp)
  8017ab:	00 
  8017ac:	c7 44 24 08 61 26 80 	movl   $0x802661,0x8(%esp)
  8017b3:	00 
  8017b4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8017bb:	00 
  8017bc:	c7 04 24 76 26 80 00 	movl   $0x802676,(%esp)
  8017c3:	e8 0e 06 00 00       	call   801dd6 <_panic>
	memmove(buf, &fsipcbuf, r);
  8017c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017cc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d3:	00 
  8017d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 47 f2 ff ff       	call   800a26 <memmove>
	return r;
}
  8017df:	89 d8                	mov    %ebx,%eax
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	5b                   	pop    %ebx
  8017e5:	5e                   	pop    %esi
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	53                   	push   %ebx
  8017ec:	83 ec 24             	sub    $0x24,%esp
  8017ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017f2:	89 1c 24             	mov    %ebx,(%esp)
  8017f5:	e8 d6 ef ff ff       	call   8007d0 <strlen>
  8017fa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ff:	7f 60                	jg     801861 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801804:	89 04 24             	mov    %eax,(%esp)
  801807:	e8 1b f8 ff ff       	call   801027 <fd_alloc>
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	85 d2                	test   %edx,%edx
  801810:	78 54                	js     801866 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801816:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80181d:	e8 09 f0 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80182a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182d:	b8 01 00 00 00       	mov    $0x1,%eax
  801832:	e8 f8 fd ff ff       	call   80162f <fsipc>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	85 c0                	test   %eax,%eax
  80183b:	79 17                	jns    801854 <open+0x6c>
		fd_close(fd, 0);
  80183d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801844:	00 
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	89 04 24             	mov    %eax,(%esp)
  80184b:	e8 12 f9 ff ff       	call   801162 <fd_close>
		return r;
  801850:	89 d8                	mov    %ebx,%eax
  801852:	eb 12                	jmp    801866 <open+0x7e>
	}
	return fd2num(fd);
  801854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801857:	89 04 24             	mov    %eax,(%esp)
  80185a:	e8 a1 f7 ff ff       	call   801000 <fd2num>
  80185f:	eb 05                	jmp    801866 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801861:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801866:	83 c4 24             	add    $0x24,%esp
  801869:	5b                   	pop    %ebx
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
  80186c:	66 90                	xchg   %ax,%ax
  80186e:	66 90                	xchg   %ax,%ax

00801870 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 10             	sub    $0x10,%esp
  801878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 8a f7 ff ff       	call   801010 <fd2data>
  801886:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801888:	c7 44 24 04 8d 26 80 	movl   $0x80268d,0x4(%esp)
  80188f:	00 
  801890:	89 1c 24             	mov    %ebx,(%esp)
  801893:	e8 93 ef ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801898:	8b 46 04             	mov    0x4(%esi),%eax
  80189b:	2b 06                	sub    (%esi),%eax
  80189d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018aa:	00 00 00 
	stat->st_dev = &devpipe;
  8018ad:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018b4:	30 80 00 
	return 0;
}
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    

008018c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	53                   	push   %ebx
  8018c7:	83 ec 14             	sub    $0x14,%esp
  8018ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d8:	e8 a3 f4 ff ff       	call   800d80 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018dd:	89 1c 24             	mov    %ebx,(%esp)
  8018e0:	e8 2b f7 ff ff       	call   801010 <fd2data>
  8018e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f0:	e8 8b f4 ff ff       	call   800d80 <sys_page_unmap>
}
  8018f5:	83 c4 14             	add    $0x14,%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	57                   	push   %edi
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	83 ec 2c             	sub    $0x2c,%esp
  801904:	89 c6                	mov    %eax,%esi
  801906:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801909:	a1 04 40 80 00       	mov    0x804004,%eax
  80190e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801911:	89 34 24             	mov    %esi,(%esp)
  801914:	e8 29 06 00 00       	call   801f42 <pageref>
  801919:	89 c7                	mov    %eax,%edi
  80191b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 1c 06 00 00       	call   801f42 <pageref>
  801926:	39 c7                	cmp    %eax,%edi
  801928:	0f 94 c2             	sete   %dl
  80192b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80192e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801934:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801937:	39 fb                	cmp    %edi,%ebx
  801939:	74 21                	je     80195c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80193b:	84 d2                	test   %dl,%dl
  80193d:	74 ca                	je     801909 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80193f:	8b 51 58             	mov    0x58(%ecx),%edx
  801942:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801946:	89 54 24 08          	mov    %edx,0x8(%esp)
  80194a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80194e:	c7 04 24 94 26 80 00 	movl   $0x802694,(%esp)
  801955:	e8 70 e8 ff ff       	call   8001ca <cprintf>
  80195a:	eb ad                	jmp    801909 <_pipeisclosed+0xe>
	}
}
  80195c:	83 c4 2c             	add    $0x2c,%esp
  80195f:	5b                   	pop    %ebx
  801960:	5e                   	pop    %esi
  801961:	5f                   	pop    %edi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    

00801964 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	57                   	push   %edi
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
  80196a:	83 ec 1c             	sub    $0x1c,%esp
  80196d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801970:	89 34 24             	mov    %esi,(%esp)
  801973:	e8 98 f6 ff ff       	call   801010 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801978:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80197c:	74 61                	je     8019df <devpipe_write+0x7b>
  80197e:	89 c3                	mov    %eax,%ebx
  801980:	bf 00 00 00 00       	mov    $0x0,%edi
  801985:	eb 4a                	jmp    8019d1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801987:	89 da                	mov    %ebx,%edx
  801989:	89 f0                	mov    %esi,%eax
  80198b:	e8 6b ff ff ff       	call   8018fb <_pipeisclosed>
  801990:	85 c0                	test   %eax,%eax
  801992:	75 54                	jne    8019e8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801994:	e8 21 f3 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801999:	8b 43 04             	mov    0x4(%ebx),%eax
  80199c:	8b 0b                	mov    (%ebx),%ecx
  80199e:	8d 51 20             	lea    0x20(%ecx),%edx
  8019a1:	39 d0                	cmp    %edx,%eax
  8019a3:	73 e2                	jae    801987 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019ac:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019af:	99                   	cltd   
  8019b0:	c1 ea 1b             	shr    $0x1b,%edx
  8019b3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8019b6:	83 e1 1f             	and    $0x1f,%ecx
  8019b9:	29 d1                	sub    %edx,%ecx
  8019bb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8019bf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8019c3:	83 c0 01             	add    $0x1,%eax
  8019c6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019c9:	83 c7 01             	add    $0x1,%edi
  8019cc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019cf:	74 13                	je     8019e4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019d4:	8b 0b                	mov    (%ebx),%ecx
  8019d6:	8d 51 20             	lea    0x20(%ecx),%edx
  8019d9:	39 d0                	cmp    %edx,%eax
  8019db:	73 aa                	jae    801987 <devpipe_write+0x23>
  8019dd:	eb c6                	jmp    8019a5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019df:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019e4:	89 f8                	mov    %edi,%eax
  8019e6:	eb 05                	jmp    8019ed <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8019ed:	83 c4 1c             	add    $0x1c,%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5f                   	pop    %edi
  8019f3:	5d                   	pop    %ebp
  8019f4:	c3                   	ret    

008019f5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	57                   	push   %edi
  8019f9:	56                   	push   %esi
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 1c             	sub    $0x1c,%esp
  8019fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a01:	89 3c 24             	mov    %edi,(%esp)
  801a04:	e8 07 f6 ff ff       	call   801010 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0d:	74 54                	je     801a63 <devpipe_read+0x6e>
  801a0f:	89 c3                	mov    %eax,%ebx
  801a11:	be 00 00 00 00       	mov    $0x0,%esi
  801a16:	eb 3e                	jmp    801a56 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a18:	89 f0                	mov    %esi,%eax
  801a1a:	eb 55                	jmp    801a71 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a1c:	89 da                	mov    %ebx,%edx
  801a1e:	89 f8                	mov    %edi,%eax
  801a20:	e8 d6 fe ff ff       	call   8018fb <_pipeisclosed>
  801a25:	85 c0                	test   %eax,%eax
  801a27:	75 43                	jne    801a6c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a29:	e8 8c f2 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a2e:	8b 03                	mov    (%ebx),%eax
  801a30:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a33:	74 e7                	je     801a1c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a35:	99                   	cltd   
  801a36:	c1 ea 1b             	shr    $0x1b,%edx
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	83 e0 1f             	and    $0x1f,%eax
  801a3e:	29 d0                	sub    %edx,%eax
  801a40:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a48:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a4b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a4e:	83 c6 01             	add    $0x1,%esi
  801a51:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a54:	74 12                	je     801a68 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801a56:	8b 03                	mov    (%ebx),%eax
  801a58:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a5b:	75 d8                	jne    801a35 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a5d:	85 f6                	test   %esi,%esi
  801a5f:	75 b7                	jne    801a18 <devpipe_read+0x23>
  801a61:	eb b9                	jmp    801a1c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a63:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a68:	89 f0                	mov    %esi,%eax
  801a6a:	eb 05                	jmp    801a71 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801a71:	83 c4 1c             	add    $0x1c,%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	e8 9b f5 ff ff       	call   801027 <fd_alloc>
  801a8c:	89 c2                	mov    %eax,%edx
  801a8e:	85 d2                	test   %edx,%edx
  801a90:	0f 88 4d 01 00 00    	js     801be3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a96:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a9d:	00 
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aac:	e8 28 f2 ff ff       	call   800cd9 <sys_page_alloc>
  801ab1:	89 c2                	mov    %eax,%edx
  801ab3:	85 d2                	test   %edx,%edx
  801ab5:	0f 88 28 01 00 00    	js     801be3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801abb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 61 f5 ff ff       	call   801027 <fd_alloc>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	0f 88 fe 00 00 00    	js     801bce <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ad7:	00 
  801ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae6:	e8 ee f1 ff ff       	call   800cd9 <sys_page_alloc>
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	85 c0                	test   %eax,%eax
  801aef:	0f 88 d9 00 00 00    	js     801bce <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	89 04 24             	mov    %eax,(%esp)
  801afb:	e8 10 f5 ff ff       	call   801010 <fd2data>
  801b00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b09:	00 
  801b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b15:	e8 bf f1 ff ff       	call   800cd9 <sys_page_alloc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	0f 88 97 00 00 00    	js     801bbb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b27:	89 04 24             	mov    %eax,(%esp)
  801b2a:	e8 e1 f4 ff ff       	call   801010 <fd2data>
  801b2f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b36:	00 
  801b37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b42:	00 
  801b43:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4e:	e8 da f1 ff ff       	call   800d2d <sys_page_map>
  801b53:	89 c3                	mov    %eax,%ebx
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 52                	js     801bab <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b59:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b6e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	89 04 24             	mov    %eax,(%esp)
  801b89:	e8 72 f4 ff ff       	call   801000 <fd2num>
  801b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	e8 62 f4 ff ff       	call   801000 <fd2num>
  801b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba9:	eb 38                	jmp    801be3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801bab:	89 74 24 04          	mov    %esi,0x4(%esp)
  801baf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bb6:	e8 c5 f1 ff ff       	call   800d80 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc9:	e8 b2 f1 ff ff       	call   800d80 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdc:	e8 9f f1 ff ff       	call   800d80 <sys_page_unmap>
  801be1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801be3:	83 c4 30             	add    $0x30,%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    

00801bea <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	89 04 24             	mov    %eax,(%esp)
  801bfd:	e8 99 f4 ff ff       	call   80109b <fd_lookup>
  801c02:	89 c2                	mov    %eax,%edx
  801c04:	85 d2                	test   %edx,%edx
  801c06:	78 15                	js     801c1d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0b:	89 04 24             	mov    %eax,(%esp)
  801c0e:	e8 fd f3 ff ff       	call   801010 <fd2data>
	return _pipeisclosed(fd, p);
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c18:	e8 de fc ff ff       	call   8018fb <_pipeisclosed>
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    
  801c1f:	90                   	nop

00801c20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    

00801c2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c30:	c7 44 24 04 ac 26 80 	movl   $0x8026ac,0x4(%esp)
  801c37:	00 
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	89 04 24             	mov    %eax,(%esp)
  801c3e:	e8 e8 eb ff ff       	call   80082b <strcpy>
	return 0;
}
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c5a:	74 4a                	je     801ca6 <devcons_write+0x5c>
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c61:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c66:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c6c:	8b 75 10             	mov    0x10(%ebp),%esi
  801c6f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801c71:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c74:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801c79:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c7c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c80:	03 45 0c             	add    0xc(%ebp),%eax
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	89 3c 24             	mov    %edi,(%esp)
  801c8a:	e8 97 ed ff ff       	call   800a26 <memmove>
		sys_cputs(buf, m);
  801c8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c93:	89 3c 24             	mov    %edi,(%esp)
  801c96:	e8 71 ef ff ff       	call   800c0c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c9b:	01 f3                	add    %esi,%ebx
  801c9d:	89 d8                	mov    %ebx,%eax
  801c9f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ca2:	72 c8                	jb     801c6c <devcons_write+0x22>
  801ca4:	eb 05                	jmp    801cab <devcons_write+0x61>
  801ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    

00801cb8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801cc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc7:	75 07                	jne    801cd0 <devcons_read+0x18>
  801cc9:	eb 28                	jmp    801cf3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ccb:	e8 ea ef ff ff       	call   800cba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cd0:	e8 55 ef ff ff       	call   800c2a <sys_cgetc>
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	74 f2                	je     801ccb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 16                	js     801cf3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801cdd:	83 f8 04             	cmp    $0x4,%eax
  801ce0:	74 0c                	je     801cee <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce5:	88 02                	mov    %al,(%edx)
	return 1;
  801ce7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cec:	eb 05                	jmp    801cf3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d08:	00 
  801d09:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d0c:	89 04 24             	mov    %eax,(%esp)
  801d0f:	e8 f8 ee ff ff       	call   800c0c <sys_cputs>
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <getchar>:

int
getchar(void)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d23:	00 
  801d24:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d32:	e8 0f f6 ff ff       	call   801346 <read>
	if (r < 0)
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 0f                	js     801d4a <getchar+0x34>
		return r;
	if (r < 1)
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	7e 06                	jle    801d45 <getchar+0x2f>
		return -E_EOF;
	return c;
  801d3f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801d43:	eb 05                	jmp    801d4a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801d45:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	89 04 24             	mov    %eax,(%esp)
  801d5f:	e8 37 f3 ff ff       	call   80109b <fd_lookup>
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 11                	js     801d79 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d71:	39 10                	cmp    %edx,(%eax)
  801d73:	0f 94 c0             	sete   %al
  801d76:	0f b6 c0             	movzbl %al,%eax
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <opencons>:

int
opencons(void)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d84:	89 04 24             	mov    %eax,(%esp)
  801d87:	e8 9b f2 ff ff       	call   801027 <fd_alloc>
		return r;
  801d8c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 40                	js     801dd2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d92:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d99:	00 
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da8:	e8 2c ef ff ff       	call   800cd9 <sys_page_alloc>
		return r;
  801dad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 1f                	js     801dd2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801db3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801dc8:	89 04 24             	mov    %eax,(%esp)
  801dcb:	e8 30 f2 ff ff       	call   801000 <fd2num>
  801dd0:	89 c2                	mov    %eax,%edx
}
  801dd2:	89 d0                	mov    %edx,%eax
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	56                   	push   %esi
  801dda:	53                   	push   %ebx
  801ddb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801dde:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801de1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801de7:	e8 af ee ff ff       	call   800c9b <sys_getenvid>
  801dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801def:	89 54 24 10          	mov    %edx,0x10(%esp)
  801df3:	8b 55 08             	mov    0x8(%ebp),%edx
  801df6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dfa:	89 74 24 08          	mov    %esi,0x8(%esp)
  801dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e02:	c7 04 24 b8 26 80 00 	movl   $0x8026b8,(%esp)
  801e09:	e8 bc e3 ff ff       	call   8001ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e0e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e12:	8b 45 10             	mov    0x10(%ebp),%eax
  801e15:	89 04 24             	mov    %eax,(%esp)
  801e18:	e8 4c e3 ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  801e1d:	c7 04 24 a5 26 80 00 	movl   $0x8026a5,(%esp)
  801e24:	e8 a1 e3 ff ff       	call   8001ca <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e29:	cc                   	int3   
  801e2a:	eb fd                	jmp    801e29 <_panic+0x53>

00801e2c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	56                   	push   %esi
  801e30:	53                   	push   %ebx
  801e31:	83 ec 10             	sub    $0x10,%esp
  801e34:	8b 75 08             	mov    0x8(%ebp),%esi
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e44:	0f 44 c2             	cmove  %edx,%eax
  801e47:	89 04 24             	mov    %eax,(%esp)
  801e4a:	e8 a0 f0 ff ff       	call   800eef <sys_ipc_recv>
	if (err_code < 0) {
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	79 16                	jns    801e69 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801e53:	85 f6                	test   %esi,%esi
  801e55:	74 06                	je     801e5d <ipc_recv+0x31>
  801e57:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e5d:	85 db                	test   %ebx,%ebx
  801e5f:	74 2c                	je     801e8d <ipc_recv+0x61>
  801e61:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e67:	eb 24                	jmp    801e8d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e69:	85 f6                	test   %esi,%esi
  801e6b:	74 0a                	je     801e77 <ipc_recv+0x4b>
  801e6d:	a1 04 40 80 00       	mov    0x804004,%eax
  801e72:	8b 40 74             	mov    0x74(%eax),%eax
  801e75:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e77:	85 db                	test   %ebx,%ebx
  801e79:	74 0a                	je     801e85 <ipc_recv+0x59>
  801e7b:	a1 04 40 80 00       	mov    0x804004,%eax
  801e80:	8b 40 78             	mov    0x78(%eax),%eax
  801e83:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801e85:	a1 04 40 80 00       	mov    0x804004,%eax
  801e8a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    

00801e94 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	57                   	push   %edi
  801e98:	56                   	push   %esi
  801e99:	53                   	push   %ebx
  801e9a:	83 ec 1c             	sub    $0x1c,%esp
  801e9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ea0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ea6:	eb 25                	jmp    801ecd <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801ea8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801eab:	74 20                	je     801ecd <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801ead:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb1:	c7 44 24 08 dc 26 80 	movl   $0x8026dc,0x8(%esp)
  801eb8:	00 
  801eb9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801ec0:	00 
  801ec1:	c7 04 24 e8 26 80 00 	movl   $0x8026e8,(%esp)
  801ec8:	e8 09 ff ff ff       	call   801dd6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ecd:	85 db                	test   %ebx,%ebx
  801ecf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ed4:	0f 45 c3             	cmovne %ebx,%eax
  801ed7:	8b 55 14             	mov    0x14(%ebp),%edx
  801eda:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ede:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee6:	89 3c 24             	mov    %edi,(%esp)
  801ee9:	e8 de ef ff ff       	call   800ecc <sys_ipc_try_send>
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	75 b6                	jne    801ea8 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801ef2:	83 c4 1c             	add    $0x1c,%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f00:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f05:	39 c8                	cmp    %ecx,%eax
  801f07:	74 17                	je     801f20 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f0e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f11:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f17:	8b 52 50             	mov    0x50(%edx),%edx
  801f1a:	39 ca                	cmp    %ecx,%edx
  801f1c:	75 14                	jne    801f32 <ipc_find_env+0x38>
  801f1e:	eb 05                	jmp    801f25 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f25:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f28:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f2d:	8b 40 40             	mov    0x40(%eax),%eax
  801f30:	eb 0e                	jmp    801f40 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f32:	83 c0 01             	add    $0x1,%eax
  801f35:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f3a:	75 d2                	jne    801f0e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f3c:	66 b8 00 00          	mov    $0x0,%ax
}
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	c1 e8 16             	shr    $0x16,%eax
  801f4d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f59:	f6 c1 01             	test   $0x1,%cl
  801f5c:	74 1d                	je     801f7b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f5e:	c1 ea 0c             	shr    $0xc,%edx
  801f61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f68:	f6 c2 01             	test   $0x1,%dl
  801f6b:	74 0e                	je     801f7b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f6d:	c1 ea 0c             	shr    $0xc,%edx
  801f70:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f77:	ef 
  801f78:	0f b7 c0             	movzwl %ax,%eax
}
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    
  801f7d:	66 90                	xchg   %ax,%ax
  801f7f:	90                   	nop

00801f80 <__udivdi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801f8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801f92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f96:	85 c0                	test   %eax,%eax
  801f98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f9c:	89 ea                	mov    %ebp,%edx
  801f9e:	89 0c 24             	mov    %ecx,(%esp)
  801fa1:	75 2d                	jne    801fd0 <__udivdi3+0x50>
  801fa3:	39 e9                	cmp    %ebp,%ecx
  801fa5:	77 61                	ja     802008 <__udivdi3+0x88>
  801fa7:	85 c9                	test   %ecx,%ecx
  801fa9:	89 ce                	mov    %ecx,%esi
  801fab:	75 0b                	jne    801fb8 <__udivdi3+0x38>
  801fad:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb2:	31 d2                	xor    %edx,%edx
  801fb4:	f7 f1                	div    %ecx
  801fb6:	89 c6                	mov    %eax,%esi
  801fb8:	31 d2                	xor    %edx,%edx
  801fba:	89 e8                	mov    %ebp,%eax
  801fbc:	f7 f6                	div    %esi
  801fbe:	89 c5                	mov    %eax,%ebp
  801fc0:	89 f8                	mov    %edi,%eax
  801fc2:	f7 f6                	div    %esi
  801fc4:	89 ea                	mov    %ebp,%edx
  801fc6:	83 c4 0c             	add    $0xc,%esp
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	39 e8                	cmp    %ebp,%eax
  801fd2:	77 24                	ja     801ff8 <__udivdi3+0x78>
  801fd4:	0f bd e8             	bsr    %eax,%ebp
  801fd7:	83 f5 1f             	xor    $0x1f,%ebp
  801fda:	75 3c                	jne    802018 <__udivdi3+0x98>
  801fdc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801fe0:	39 34 24             	cmp    %esi,(%esp)
  801fe3:	0f 86 9f 00 00 00    	jbe    802088 <__udivdi3+0x108>
  801fe9:	39 d0                	cmp    %edx,%eax
  801feb:	0f 82 97 00 00 00    	jb     802088 <__udivdi3+0x108>
  801ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ff8:	31 d2                	xor    %edx,%edx
  801ffa:	31 c0                	xor    %eax,%eax
  801ffc:	83 c4 0c             	add    $0xc,%esp
  801fff:	5e                   	pop    %esi
  802000:	5f                   	pop    %edi
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    
  802003:	90                   	nop
  802004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802008:	89 f8                	mov    %edi,%eax
  80200a:	f7 f1                	div    %ecx
  80200c:	31 d2                	xor    %edx,%edx
  80200e:	83 c4 0c             	add    $0xc,%esp
  802011:	5e                   	pop    %esi
  802012:	5f                   	pop    %edi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    
  802015:	8d 76 00             	lea    0x0(%esi),%esi
  802018:	89 e9                	mov    %ebp,%ecx
  80201a:	8b 3c 24             	mov    (%esp),%edi
  80201d:	d3 e0                	shl    %cl,%eax
  80201f:	89 c6                	mov    %eax,%esi
  802021:	b8 20 00 00 00       	mov    $0x20,%eax
  802026:	29 e8                	sub    %ebp,%eax
  802028:	89 c1                	mov    %eax,%ecx
  80202a:	d3 ef                	shr    %cl,%edi
  80202c:	89 e9                	mov    %ebp,%ecx
  80202e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802032:	8b 3c 24             	mov    (%esp),%edi
  802035:	09 74 24 08          	or     %esi,0x8(%esp)
  802039:	89 d6                	mov    %edx,%esi
  80203b:	d3 e7                	shl    %cl,%edi
  80203d:	89 c1                	mov    %eax,%ecx
  80203f:	89 3c 24             	mov    %edi,(%esp)
  802042:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802046:	d3 ee                	shr    %cl,%esi
  802048:	89 e9                	mov    %ebp,%ecx
  80204a:	d3 e2                	shl    %cl,%edx
  80204c:	89 c1                	mov    %eax,%ecx
  80204e:	d3 ef                	shr    %cl,%edi
  802050:	09 d7                	or     %edx,%edi
  802052:	89 f2                	mov    %esi,%edx
  802054:	89 f8                	mov    %edi,%eax
  802056:	f7 74 24 08          	divl   0x8(%esp)
  80205a:	89 d6                	mov    %edx,%esi
  80205c:	89 c7                	mov    %eax,%edi
  80205e:	f7 24 24             	mull   (%esp)
  802061:	39 d6                	cmp    %edx,%esi
  802063:	89 14 24             	mov    %edx,(%esp)
  802066:	72 30                	jb     802098 <__udivdi3+0x118>
  802068:	8b 54 24 04          	mov    0x4(%esp),%edx
  80206c:	89 e9                	mov    %ebp,%ecx
  80206e:	d3 e2                	shl    %cl,%edx
  802070:	39 c2                	cmp    %eax,%edx
  802072:	73 05                	jae    802079 <__udivdi3+0xf9>
  802074:	3b 34 24             	cmp    (%esp),%esi
  802077:	74 1f                	je     802098 <__udivdi3+0x118>
  802079:	89 f8                	mov    %edi,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	e9 7a ff ff ff       	jmp    801ffc <__udivdi3+0x7c>
  802082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802088:	31 d2                	xor    %edx,%edx
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	e9 68 ff ff ff       	jmp    801ffc <__udivdi3+0x7c>
  802094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802098:	8d 47 ff             	lea    -0x1(%edi),%eax
  80209b:	31 d2                	xor    %edx,%edx
  80209d:	83 c4 0c             	add    $0xc,%esp
  8020a0:	5e                   	pop    %esi
  8020a1:	5f                   	pop    %edi
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    
  8020a4:	66 90                	xchg   %ax,%ax
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	66 90                	xchg   %ax,%ax
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	66 90                	xchg   %ax,%ax
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <__umoddi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	83 ec 14             	sub    $0x14,%esp
  8020b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8020ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8020be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8020c2:	89 c7                	mov    %eax,%edi
  8020c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8020cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8020d0:	89 34 24             	mov    %esi,(%esp)
  8020d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	89 c2                	mov    %eax,%edx
  8020db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020df:	75 17                	jne    8020f8 <__umoddi3+0x48>
  8020e1:	39 fe                	cmp    %edi,%esi
  8020e3:	76 4b                	jbe    802130 <__umoddi3+0x80>
  8020e5:	89 c8                	mov    %ecx,%eax
  8020e7:	89 fa                	mov    %edi,%edx
  8020e9:	f7 f6                	div    %esi
  8020eb:	89 d0                	mov    %edx,%eax
  8020ed:	31 d2                	xor    %edx,%edx
  8020ef:	83 c4 14             	add    $0x14,%esp
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	39 f8                	cmp    %edi,%eax
  8020fa:	77 54                	ja     802150 <__umoddi3+0xa0>
  8020fc:	0f bd e8             	bsr    %eax,%ebp
  8020ff:	83 f5 1f             	xor    $0x1f,%ebp
  802102:	75 5c                	jne    802160 <__umoddi3+0xb0>
  802104:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802108:	39 3c 24             	cmp    %edi,(%esp)
  80210b:	0f 87 e7 00 00 00    	ja     8021f8 <__umoddi3+0x148>
  802111:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802115:	29 f1                	sub    %esi,%ecx
  802117:	19 c7                	sbb    %eax,%edi
  802119:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80211d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802121:	8b 44 24 08          	mov    0x8(%esp),%eax
  802125:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802129:	83 c4 14             	add    $0x14,%esp
  80212c:	5e                   	pop    %esi
  80212d:	5f                   	pop    %edi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    
  802130:	85 f6                	test   %esi,%esi
  802132:	89 f5                	mov    %esi,%ebp
  802134:	75 0b                	jne    802141 <__umoddi3+0x91>
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	f7 f6                	div    %esi
  80213f:	89 c5                	mov    %eax,%ebp
  802141:	8b 44 24 04          	mov    0x4(%esp),%eax
  802145:	31 d2                	xor    %edx,%edx
  802147:	f7 f5                	div    %ebp
  802149:	89 c8                	mov    %ecx,%eax
  80214b:	f7 f5                	div    %ebp
  80214d:	eb 9c                	jmp    8020eb <__umoddi3+0x3b>
  80214f:	90                   	nop
  802150:	89 c8                	mov    %ecx,%eax
  802152:	89 fa                	mov    %edi,%edx
  802154:	83 c4 14             	add    $0x14,%esp
  802157:	5e                   	pop    %esi
  802158:	5f                   	pop    %edi
  802159:	5d                   	pop    %ebp
  80215a:	c3                   	ret    
  80215b:	90                   	nop
  80215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802160:	8b 04 24             	mov    (%esp),%eax
  802163:	be 20 00 00 00       	mov    $0x20,%esi
  802168:	89 e9                	mov    %ebp,%ecx
  80216a:	29 ee                	sub    %ebp,%esi
  80216c:	d3 e2                	shl    %cl,%edx
  80216e:	89 f1                	mov    %esi,%ecx
  802170:	d3 e8                	shr    %cl,%eax
  802172:	89 e9                	mov    %ebp,%ecx
  802174:	89 44 24 04          	mov    %eax,0x4(%esp)
  802178:	8b 04 24             	mov    (%esp),%eax
  80217b:	09 54 24 04          	or     %edx,0x4(%esp)
  80217f:	89 fa                	mov    %edi,%edx
  802181:	d3 e0                	shl    %cl,%eax
  802183:	89 f1                	mov    %esi,%ecx
  802185:	89 44 24 08          	mov    %eax,0x8(%esp)
  802189:	8b 44 24 10          	mov    0x10(%esp),%eax
  80218d:	d3 ea                	shr    %cl,%edx
  80218f:	89 e9                	mov    %ebp,%ecx
  802191:	d3 e7                	shl    %cl,%edi
  802193:	89 f1                	mov    %esi,%ecx
  802195:	d3 e8                	shr    %cl,%eax
  802197:	89 e9                	mov    %ebp,%ecx
  802199:	09 f8                	or     %edi,%eax
  80219b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80219f:	f7 74 24 04          	divl   0x4(%esp)
  8021a3:	d3 e7                	shl    %cl,%edi
  8021a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021a9:	89 d7                	mov    %edx,%edi
  8021ab:	f7 64 24 08          	mull   0x8(%esp)
  8021af:	39 d7                	cmp    %edx,%edi
  8021b1:	89 c1                	mov    %eax,%ecx
  8021b3:	89 14 24             	mov    %edx,(%esp)
  8021b6:	72 2c                	jb     8021e4 <__umoddi3+0x134>
  8021b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8021bc:	72 22                	jb     8021e0 <__umoddi3+0x130>
  8021be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8021c2:	29 c8                	sub    %ecx,%eax
  8021c4:	19 d7                	sbb    %edx,%edi
  8021c6:	89 e9                	mov    %ebp,%ecx
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	d3 e8                	shr    %cl,%eax
  8021cc:	89 f1                	mov    %esi,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	89 e9                	mov    %ebp,%ecx
  8021d2:	d3 ef                	shr    %cl,%edi
  8021d4:	09 d0                	or     %edx,%eax
  8021d6:	89 fa                	mov    %edi,%edx
  8021d8:	83 c4 14             	add    $0x14,%esp
  8021db:	5e                   	pop    %esi
  8021dc:	5f                   	pop    %edi
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    
  8021df:	90                   	nop
  8021e0:	39 d7                	cmp    %edx,%edi
  8021e2:	75 da                	jne    8021be <__umoddi3+0x10e>
  8021e4:	8b 14 24             	mov    (%esp),%edx
  8021e7:	89 c1                	mov    %eax,%ecx
  8021e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8021ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8021f1:	eb cb                	jmp    8021be <__umoddi3+0x10e>
  8021f3:	90                   	nop
  8021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8021fc:	0f 82 0f ff ff ff    	jb     802111 <__umoddi3+0x61>
  802202:	e9 1a ff ff ff       	jmp    802121 <__umoddi3+0x71>
