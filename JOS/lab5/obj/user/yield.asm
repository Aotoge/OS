
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 40 21 80 00 	movl   $0x802140,(%esp)
  80004d:	e8 80 01 00 00       	call   8001d2 <cprintf>
	for (i = 0; i < 5; i++) {
  800052:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800057:	e8 5e 0c 00 00       	call   800cba <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005c:	a1 04 40 80 00       	mov    0x804004,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	c7 04 24 60 21 80 00 	movl   $0x802160,(%esp)
  800073:	e8 5a 01 00 00       	call   8001d2 <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800078:	83 c3 01             	add    $0x1,%ebx
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d7                	jne    800057 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 04 40 80 00       	mov    0x804004,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008c:	c7 04 24 8c 21 80 00 	movl   $0x80218c,(%esp)
  800093:	e8 3a 01 00 00       	call   8001d2 <cprintf>
}
  800098:	83 c4 14             	add    $0x14,%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 10             	sub    $0x10,%esp
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000ac:	e8 ea 0b 00 00       	call   800c9b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000b1:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000b7:	39 c2                	cmp    %eax,%edx
  8000b9:	74 17                	je     8000d2 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000bb:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000c0:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000c3:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000c9:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000cc:	39 c1                	cmp    %eax,%ecx
  8000ce:	75 18                	jne    8000e8 <libmain+0x4a>
  8000d0:	eb 05                	jmp    8000d7 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000d7:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000da:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000e0:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000e6:	eb 0b                	jmp    8000f3 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000e8:	83 c2 01             	add    $0x1,%edx
  8000eb:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000f1:	75 cd                	jne    8000c0 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f3:	85 db                	test   %ebx,%ebx
  8000f5:	7e 07                	jle    8000fe <libmain+0x60>
		binaryname = argv[0];
  8000f7:	8b 06                	mov    (%esi),%eax
  8000f9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800102:	89 1c 24             	mov    %ebx,(%esp)
  800105:	e8 29 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80010a:	e8 07 00 00 00       	call   800116 <exit>
}
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80011c:	e8 45 10 00 00       	call   801166 <close_all>
	sys_env_destroy(0);
  800121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800128:	e8 1c 0b 00 00       	call   800c49 <sys_env_destroy>
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	53                   	push   %ebx
  800133:	83 ec 14             	sub    $0x14,%esp
  800136:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800139:	8b 13                	mov    (%ebx),%edx
  80013b:	8d 42 01             	lea    0x1(%edx),%eax
  80013e:	89 03                	mov    %eax,(%ebx)
  800140:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800143:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800147:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014c:	75 19                	jne    800167 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80014e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800155:	00 
  800156:	8d 43 08             	lea    0x8(%ebx),%eax
  800159:	89 04 24             	mov    %eax,(%esp)
  80015c:	e8 ab 0a 00 00       	call   800c0c <sys_cputs>
		b->idx = 0;
  800161:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800167:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016b:	83 c4 14             	add    $0x14,%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5d                   	pop    %ebp
  800170:	c3                   	ret    

00800171 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80017a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800181:	00 00 00 
	b.cnt = 0;
  800184:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
  800198:	89 44 24 08          	mov    %eax,0x8(%esp)
  80019c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a6:	c7 04 24 2f 01 80 00 	movl   $0x80012f,(%esp)
  8001ad:	e8 b2 01 00 00       	call   800364 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c2:	89 04 24             	mov    %eax,(%esp)
  8001c5:	e8 42 0a 00 00       	call   800c0c <sys_cputs>

	return b.cnt;
}
  8001ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d0:	c9                   	leave  
  8001d1:	c3                   	ret    

008001d2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e2:	89 04 24             	mov    %eax,(%esp)
  8001e5:	e8 87 ff ff ff       	call   800171 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    
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
  80026c:	e8 2f 1c 00 00       	call   801ea0 <__udivdi3>
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
  8002c5:	e8 06 1d 00 00       	call   801fd0 <__umoddi3>
  8002ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ce:	0f be 80 b5 21 80 00 	movsbl 0x8021b5(%eax),%eax
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
  8003ec:	ff 24 85 00 23 80 00 	jmp    *0x802300(,%eax,4)
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
  80049f:	8b 14 85 60 24 80 00 	mov    0x802460(,%eax,4),%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	75 20                	jne    8004ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ae:	c7 44 24 08 cd 21 80 	movl   $0x8021cd,0x8(%esp)
  8004b5:	00 
  8004b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 77 fe ff ff       	call   80033c <printfmt>
  8004c5:	e9 c3 fe ff ff       	jmp    80038d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8004ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ce:	c7 44 24 08 7f 25 80 	movl   $0x80257f,0x8(%esp)
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
  8004fd:	ba c6 21 80 00       	mov    $0x8021c6,%edx
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
  800c77:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800c7e:	00 
  800c7f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c86:	00 
  800c87:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800c8e:	e8 63 10 00 00       	call   801cf6 <_panic>

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
  800d09:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800d10:	00 
  800d11:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d18:	00 
  800d19:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800d20:	e8 d1 0f 00 00       	call   801cf6 <_panic>

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
  800d5c:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800d73:	e8 7e 0f 00 00       	call   801cf6 <_panic>

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
  800daf:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800dc6:	e8 2b 0f 00 00       	call   801cf6 <_panic>

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
  800e02:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800e09:	00 
  800e0a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e11:	00 
  800e12:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800e19:	e8 d8 0e 00 00       	call   801cf6 <_panic>

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
  800e55:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800e5c:	00 
  800e5d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e64:	00 
  800e65:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800e6c:	e8 85 0e 00 00       	call   801cf6 <_panic>

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
  800ea8:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800ebf:	e8 32 0e 00 00       	call   801cf6 <_panic>

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
  800f1d:	c7 44 24 08 bf 24 80 	movl   $0x8024bf,0x8(%esp)
  800f24:	00 
  800f25:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f2c:	00 
  800f2d:	c7 04 24 dc 24 80 00 	movl   $0x8024dc,(%esp)
  800f34:	e8 bd 0d 00 00       	call   801cf6 <_panic>

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
  800f41:	66 90                	xchg   %ax,%ax
  800f43:	66 90                	xchg   %ax,%ax
  800f45:	66 90                	xchg   %ax,%ax
  800f47:	66 90                	xchg   %ax,%ax
  800f49:	66 90                	xchg   %ax,%ax
  800f4b:	66 90                	xchg   %ax,%ax
  800f4d:	66 90                	xchg   %ax,%ax
  800f4f:	90                   	nop

00800f50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	05 00 00 00 30       	add    $0x30000000,%eax
  800f5b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f70:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f7a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800f7f:	a8 01                	test   $0x1,%al
  800f81:	74 34                	je     800fb7 <fd_alloc+0x40>
  800f83:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800f88:	a8 01                	test   $0x1,%al
  800f8a:	74 32                	je     800fbe <fd_alloc+0x47>
  800f8c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800f91:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f93:	89 c2                	mov    %eax,%edx
  800f95:	c1 ea 16             	shr    $0x16,%edx
  800f98:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f9f:	f6 c2 01             	test   $0x1,%dl
  800fa2:	74 1f                	je     800fc3 <fd_alloc+0x4c>
  800fa4:	89 c2                	mov    %eax,%edx
  800fa6:	c1 ea 0c             	shr    $0xc,%edx
  800fa9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb0:	f6 c2 01             	test   $0x1,%dl
  800fb3:	75 1a                	jne    800fcf <fd_alloc+0x58>
  800fb5:	eb 0c                	jmp    800fc3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fb7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  800fbc:	eb 05                	jmp    800fc3 <fd_alloc+0x4c>
  800fbe:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 08                	mov    %ecx,(%eax)
			return 0;
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcd:	eb 1a                	jmp    800fe9 <fd_alloc+0x72>
  800fcf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fd4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fd9:	75 b6                	jne    800f91 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fe4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ff1:	83 f8 1f             	cmp    $0x1f,%eax
  800ff4:	77 36                	ja     80102c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ff6:	c1 e0 0c             	shl    $0xc,%eax
  800ff9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 16             	shr    $0x16,%edx
  801003:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 24                	je     801033 <fd_lookup+0x48>
  80100f:	89 c2                	mov    %eax,%edx
  801011:	c1 ea 0c             	shr    $0xc,%edx
  801014:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80101b:	f6 c2 01             	test   $0x1,%dl
  80101e:	74 1a                	je     80103a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	89 02                	mov    %eax,(%edx)
	return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 13                	jmp    80103f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80102c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801031:	eb 0c                	jmp    80103f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801033:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801038:	eb 05                	jmp    80103f <fd_lookup+0x54>
  80103a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	53                   	push   %ebx
  801045:	83 ec 14             	sub    $0x14,%esp
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80104e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801054:	75 1e                	jne    801074 <dev_lookup+0x33>
  801056:	eb 0e                	jmp    801066 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801058:	b8 20 30 80 00       	mov    $0x803020,%eax
  80105d:	eb 0c                	jmp    80106b <dev_lookup+0x2a>
  80105f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801064:	eb 05                	jmp    80106b <dev_lookup+0x2a>
  801066:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80106b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
  801072:	eb 38                	jmp    8010ac <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801074:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80107a:	74 dc                	je     801058 <dev_lookup+0x17>
  80107c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801082:	74 db                	je     80105f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801084:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80108a:	8b 52 48             	mov    0x48(%edx),%edx
  80108d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801091:	89 54 24 04          	mov    %edx,0x4(%esp)
  801095:	c7 04 24 ec 24 80 00 	movl   $0x8024ec,(%esp)
  80109c:	e8 31 f1 ff ff       	call   8001d2 <cprintf>
	*dev = 0;
  8010a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010ac:	83 c4 14             	add    $0x14,%esp
  8010af:	5b                   	pop    %ebx
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	56                   	push   %esi
  8010b6:	53                   	push   %ebx
  8010b7:	83 ec 20             	sub    $0x20,%esp
  8010ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8010bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010cd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d0:	89 04 24             	mov    %eax,(%esp)
  8010d3:	e8 13 ff ff ff       	call   800feb <fd_lookup>
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 05                	js     8010e1 <fd_close+0x2f>
	    || fd != fd2)
  8010dc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010df:	74 0c                	je     8010ed <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010e1:	84 db                	test   %bl,%bl
  8010e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e8:	0f 44 c2             	cmove  %edx,%eax
  8010eb:	eb 3f                	jmp    80112c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f4:	8b 06                	mov    (%esi),%eax
  8010f6:	89 04 24             	mov    %eax,(%esp)
  8010f9:	e8 43 ff ff ff       	call   801041 <dev_lookup>
  8010fe:	89 c3                	mov    %eax,%ebx
  801100:	85 c0                	test   %eax,%eax
  801102:	78 16                	js     80111a <fd_close+0x68>
		if (dev->dev_close)
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80110a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80110f:	85 c0                	test   %eax,%eax
  801111:	74 07                	je     80111a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801113:	89 34 24             	mov    %esi,(%esp)
  801116:	ff d0                	call   *%eax
  801118:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80111a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801125:	e8 56 fc ff ff       	call   800d80 <sys_page_unmap>
	return r;
  80112a:	89 d8                	mov    %ebx,%eax
}
  80112c:	83 c4 20             	add    $0x20,%esp
  80112f:	5b                   	pop    %ebx
  801130:	5e                   	pop    %esi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80113c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	89 04 24             	mov    %eax,(%esp)
  801146:	e8 a0 fe ff ff       	call   800feb <fd_lookup>
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	85 d2                	test   %edx,%edx
  80114f:	78 13                	js     801164 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801151:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801158:	00 
  801159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115c:	89 04 24             	mov    %eax,(%esp)
  80115f:	e8 4e ff ff ff       	call   8010b2 <fd_close>
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <close_all>:

void
close_all(void)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	53                   	push   %ebx
  80116a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80116d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801172:	89 1c 24             	mov    %ebx,(%esp)
  801175:	e8 b9 ff ff ff       	call   801133 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80117a:	83 c3 01             	add    $0x1,%ebx
  80117d:	83 fb 20             	cmp    $0x20,%ebx
  801180:	75 f0                	jne    801172 <close_all+0xc>
		close(i);
}
  801182:	83 c4 14             	add    $0x14,%esp
  801185:	5b                   	pop    %ebx
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801191:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801194:	89 44 24 04          	mov    %eax,0x4(%esp)
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	89 04 24             	mov    %eax,(%esp)
  80119e:	e8 48 fe ff ff       	call   800feb <fd_lookup>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	85 d2                	test   %edx,%edx
  8011a7:	0f 88 e1 00 00 00    	js     80128e <dup+0x106>
		return r;
	close(newfdnum);
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	89 04 24             	mov    %eax,(%esp)
  8011b3:	e8 7b ff ff ff       	call   801133 <close>

	newfd = INDEX2FD(newfdnum);
  8011b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011bb:	c1 e3 0c             	shl    $0xc,%ebx
  8011be:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c7:	89 04 24             	mov    %eax,(%esp)
  8011ca:	e8 91 fd ff ff       	call   800f60 <fd2data>
  8011cf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8011d1:	89 1c 24             	mov    %ebx,(%esp)
  8011d4:	e8 87 fd ff ff       	call   800f60 <fd2data>
  8011d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011db:	89 f0                	mov    %esi,%eax
  8011dd:	c1 e8 16             	shr    $0x16,%eax
  8011e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011e7:	a8 01                	test   $0x1,%al
  8011e9:	74 43                	je     80122e <dup+0xa6>
  8011eb:	89 f0                	mov    %esi,%eax
  8011ed:	c1 e8 0c             	shr    $0xc,%eax
  8011f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011f7:	f6 c2 01             	test   $0x1,%dl
  8011fa:	74 32                	je     80122e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801203:	25 07 0e 00 00       	and    $0xe07,%eax
  801208:	89 44 24 10          	mov    %eax,0x10(%esp)
  80120c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801210:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801217:	00 
  801218:	89 74 24 04          	mov    %esi,0x4(%esp)
  80121c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801223:	e8 05 fb ff ff       	call   800d2d <sys_page_map>
  801228:	89 c6                	mov    %eax,%esi
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 3e                	js     80126c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80122e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801231:	89 c2                	mov    %eax,%edx
  801233:	c1 ea 0c             	shr    $0xc,%edx
  801236:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801243:	89 54 24 10          	mov    %edx,0x10(%esp)
  801247:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80124b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801252:	00 
  801253:	89 44 24 04          	mov    %eax,0x4(%esp)
  801257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125e:	e8 ca fa ff ff       	call   800d2d <sys_page_map>
  801263:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801268:	85 f6                	test   %esi,%esi
  80126a:	79 22                	jns    80128e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80126c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801277:	e8 04 fb ff ff       	call   800d80 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80127c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801287:	e8 f4 fa ff ff       	call   800d80 <sys_page_unmap>
	return r;
  80128c:	89 f0                	mov    %esi,%eax
}
  80128e:	83 c4 3c             	add    $0x3c,%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 24             	sub    $0x24,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a7:	89 1c 24             	mov    %ebx,(%esp)
  8012aa:	e8 3c fd ff ff       	call   800feb <fd_lookup>
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	85 d2                	test   %edx,%edx
  8012b3:	78 6d                	js     801322 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bf:	8b 00                	mov    (%eax),%eax
  8012c1:	89 04 24             	mov    %eax,(%esp)
  8012c4:	e8 78 fd ff ff       	call   801041 <dev_lookup>
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 55                	js     801322 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d0:	8b 50 08             	mov    0x8(%eax),%edx
  8012d3:	83 e2 03             	and    $0x3,%edx
  8012d6:	83 fa 01             	cmp    $0x1,%edx
  8012d9:	75 23                	jne    8012fe <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012db:	a1 04 40 80 00       	mov    0x804004,%eax
  8012e0:	8b 40 48             	mov    0x48(%eax),%eax
  8012e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012eb:	c7 04 24 2d 25 80 00 	movl   $0x80252d,(%esp)
  8012f2:	e8 db ee ff ff       	call   8001d2 <cprintf>
		return -E_INVAL;
  8012f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fc:	eb 24                	jmp    801322 <read+0x8c>
	}
	if (!dev->dev_read)
  8012fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801301:	8b 52 08             	mov    0x8(%edx),%edx
  801304:	85 d2                	test   %edx,%edx
  801306:	74 15                	je     80131d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801308:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80130f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801312:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801316:	89 04 24             	mov    %eax,(%esp)
  801319:	ff d2                	call   *%edx
  80131b:	eb 05                	jmp    801322 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80131d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801322:	83 c4 24             	add    $0x24,%esp
  801325:	5b                   	pop    %ebx
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	57                   	push   %edi
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	83 ec 1c             	sub    $0x1c,%esp
  801331:	8b 7d 08             	mov    0x8(%ebp),%edi
  801334:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801337:	85 f6                	test   %esi,%esi
  801339:	74 33                	je     80136e <readn+0x46>
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
  801340:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801345:	89 f2                	mov    %esi,%edx
  801347:	29 c2                	sub    %eax,%edx
  801349:	89 54 24 08          	mov    %edx,0x8(%esp)
  80134d:	03 45 0c             	add    0xc(%ebp),%eax
  801350:	89 44 24 04          	mov    %eax,0x4(%esp)
  801354:	89 3c 24             	mov    %edi,(%esp)
  801357:	e8 3a ff ff ff       	call   801296 <read>
		if (m < 0)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 1b                	js     80137b <readn+0x53>
			return m;
		if (m == 0)
  801360:	85 c0                	test   %eax,%eax
  801362:	74 11                	je     801375 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801364:	01 c3                	add    %eax,%ebx
  801366:	89 d8                	mov    %ebx,%eax
  801368:	39 f3                	cmp    %esi,%ebx
  80136a:	72 d9                	jb     801345 <readn+0x1d>
  80136c:	eb 0b                	jmp    801379 <readn+0x51>
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
  801373:	eb 06                	jmp    80137b <readn+0x53>
  801375:	89 d8                	mov    %ebx,%eax
  801377:	eb 02                	jmp    80137b <readn+0x53>
  801379:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80137b:	83 c4 1c             	add    $0x1c,%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5f                   	pop    %edi
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	53                   	push   %ebx
  801387:	83 ec 24             	sub    $0x24,%esp
  80138a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801390:	89 44 24 04          	mov    %eax,0x4(%esp)
  801394:	89 1c 24             	mov    %ebx,(%esp)
  801397:	e8 4f fc ff ff       	call   800feb <fd_lookup>
  80139c:	89 c2                	mov    %eax,%edx
  80139e:	85 d2                	test   %edx,%edx
  8013a0:	78 68                	js     80140a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	89 04 24             	mov    %eax,(%esp)
  8013b1:	e8 8b fc ff ff       	call   801041 <dev_lookup>
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 50                	js     80140a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c1:	75 23                	jne    8013e6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c8:	8b 40 48             	mov    0x48(%eax),%eax
  8013cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d3:	c7 04 24 49 25 80 00 	movl   $0x802549,(%esp)
  8013da:	e8 f3 ed ff ff       	call   8001d2 <cprintf>
		return -E_INVAL;
  8013df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e4:	eb 24                	jmp    80140a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ec:	85 d2                	test   %edx,%edx
  8013ee:	74 15                	je     801405 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013fe:	89 04 24             	mov    %eax,(%esp)
  801401:	ff d2                	call   *%edx
  801403:	eb 05                	jmp    80140a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801405:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80140a:	83 c4 24             	add    $0x24,%esp
  80140d:	5b                   	pop    %ebx
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <seek>:

int
seek(int fdnum, off_t offset)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801416:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 04 24             	mov    %eax,(%esp)
  801423:	e8 c3 fb ff ff       	call   800feb <fd_lookup>
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 0e                	js     80143a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80142c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801432:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	53                   	push   %ebx
  801440:	83 ec 24             	sub    $0x24,%esp
  801443:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144d:	89 1c 24             	mov    %ebx,(%esp)
  801450:	e8 96 fb ff ff       	call   800feb <fd_lookup>
  801455:	89 c2                	mov    %eax,%edx
  801457:	85 d2                	test   %edx,%edx
  801459:	78 61                	js     8014bc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	89 04 24             	mov    %eax,(%esp)
  80146a:	e8 d2 fb ff ff       	call   801041 <dev_lookup>
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 49                	js     8014bc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80147a:	75 23                	jne    80149f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80147c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801481:	8b 40 48             	mov    0x48(%eax),%eax
  801484:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801488:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148c:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  801493:	e8 3a ed ff ff       	call   8001d2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801498:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149d:	eb 1d                	jmp    8014bc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80149f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a2:	8b 52 18             	mov    0x18(%edx),%edx
  8014a5:	85 d2                	test   %edx,%edx
  8014a7:	74 0e                	je     8014b7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014b0:	89 04 24             	mov    %eax,(%esp)
  8014b3:	ff d2                	call   *%edx
  8014b5:	eb 05                	jmp    8014bc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014bc:	83 c4 24             	add    $0x24,%esp
  8014bf:	5b                   	pop    %ebx
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    

008014c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 24             	sub    $0x24,%esp
  8014c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	89 04 24             	mov    %eax,(%esp)
  8014d9:	e8 0d fb ff ff       	call   800feb <fd_lookup>
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	85 d2                	test   %edx,%edx
  8014e2:	78 52                	js     801536 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	89 04 24             	mov    %eax,(%esp)
  8014f3:	e8 49 fb ff ff       	call   801041 <dev_lookup>
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 3a                	js     801536 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ff:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801503:	74 2c                	je     801531 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801505:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801508:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80150f:	00 00 00 
	stat->st_isdir = 0;
  801512:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801519:	00 00 00 
	stat->st_dev = dev;
  80151c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801522:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801526:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801529:	89 14 24             	mov    %edx,(%esp)
  80152c:	ff 50 14             	call   *0x14(%eax)
  80152f:	eb 05                	jmp    801536 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801531:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801536:	83 c4 24             	add    $0x24,%esp
  801539:	5b                   	pop    %ebx
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	56                   	push   %esi
  801540:	53                   	push   %ebx
  801541:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801544:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80154b:	00 
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	89 04 24             	mov    %eax,(%esp)
  801552:	e8 af 01 00 00       	call   801706 <open>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	85 db                	test   %ebx,%ebx
  80155b:	78 1b                	js     801578 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	89 44 24 04          	mov    %eax,0x4(%esp)
  801564:	89 1c 24             	mov    %ebx,(%esp)
  801567:	e8 56 ff ff ff       	call   8014c2 <fstat>
  80156c:	89 c6                	mov    %eax,%esi
	close(fd);
  80156e:	89 1c 24             	mov    %ebx,(%esp)
  801571:	e8 bd fb ff ff       	call   801133 <close>
	return r;
  801576:	89 f0                	mov    %esi,%eax
}
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	56                   	push   %esi
  801583:	53                   	push   %ebx
  801584:	83 ec 10             	sub    $0x10,%esp
  801587:	89 c6                	mov    %eax,%esi
  801589:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801592:	75 11                	jne    8015a5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801594:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80159b:	e8 7a 08 00 00       	call   801e1a <ipc_find_env>
  8015a0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015ac:	00 
  8015ad:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015b4:	00 
  8015b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b9:	a1 00 40 80 00       	mov    0x804000,%eax
  8015be:	89 04 24             	mov    %eax,(%esp)
  8015c1:	e8 ee 07 00 00       	call   801db4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cd:	00 
  8015ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d9:	e8 6e 07 00 00       	call   801d4c <ipc_recv>
}
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 14             	sub    $0x14,%esp
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801604:	e8 76 ff ff ff       	call   80157f <fsipc>
  801609:	89 c2                	mov    %eax,%edx
  80160b:	85 d2                	test   %edx,%edx
  80160d:	78 2b                	js     80163a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80160f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801616:	00 
  801617:	89 1c 24             	mov    %ebx,(%esp)
  80161a:	e8 0c f2 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80161f:	a1 80 50 80 00       	mov    0x805080,%eax
  801624:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80162a:	a1 84 50 80 00       	mov    0x805084,%eax
  80162f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163a:	83 c4 14             	add    $0x14,%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8b 40 0c             	mov    0xc(%eax),%eax
  80164c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	b8 06 00 00 00       	mov    $0x6,%eax
  80165b:	e8 1f ff ff ff       	call   80157f <fsipc>
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	56                   	push   %esi
  801666:	53                   	push   %ebx
  801667:	83 ec 10             	sub    $0x10,%esp
  80166a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8b 40 0c             	mov    0xc(%eax),%eax
  801673:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801678:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80167e:	ba 00 00 00 00       	mov    $0x0,%edx
  801683:	b8 03 00 00 00       	mov    $0x3,%eax
  801688:	e8 f2 fe ff ff       	call   80157f <fsipc>
  80168d:	89 c3                	mov    %eax,%ebx
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 6a                	js     8016fd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801693:	39 c6                	cmp    %eax,%esi
  801695:	73 24                	jae    8016bb <devfile_read+0x59>
  801697:	c7 44 24 0c 66 25 80 	movl   $0x802566,0xc(%esp)
  80169e:	00 
  80169f:	c7 44 24 08 6d 25 80 	movl   $0x80256d,0x8(%esp)
  8016a6:	00 
  8016a7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  8016ae:	00 
  8016af:	c7 04 24 82 25 80 00 	movl   $0x802582,(%esp)
  8016b6:	e8 3b 06 00 00       	call   801cf6 <_panic>
	assert(r <= PGSIZE);
  8016bb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c0:	7e 24                	jle    8016e6 <devfile_read+0x84>
  8016c2:	c7 44 24 0c 8d 25 80 	movl   $0x80258d,0xc(%esp)
  8016c9:	00 
  8016ca:	c7 44 24 08 6d 25 80 	movl   $0x80256d,0x8(%esp)
  8016d1:	00 
  8016d2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016d9:	00 
  8016da:	c7 04 24 82 25 80 00 	movl   $0x802582,(%esp)
  8016e1:	e8 10 06 00 00       	call   801cf6 <_panic>
	memmove(buf, &fsipcbuf, r);
  8016e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ea:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016f1:	00 
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	89 04 24             	mov    %eax,(%esp)
  8016f8:	e8 29 f3 ff ff       	call   800a26 <memmove>
	return r;
}
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	53                   	push   %ebx
  80170a:	83 ec 24             	sub    $0x24,%esp
  80170d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801710:	89 1c 24             	mov    %ebx,(%esp)
  801713:	e8 b8 f0 ff ff       	call   8007d0 <strlen>
  801718:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80171d:	7f 60                	jg     80177f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80171f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801722:	89 04 24             	mov    %eax,(%esp)
  801725:	e8 4d f8 ff ff       	call   800f77 <fd_alloc>
  80172a:	89 c2                	mov    %eax,%edx
  80172c:	85 d2                	test   %edx,%edx
  80172e:	78 54                	js     801784 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801730:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801734:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80173b:	e8 eb f0 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801740:	8b 45 0c             	mov    0xc(%ebp),%eax
  801743:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174b:	b8 01 00 00 00       	mov    $0x1,%eax
  801750:	e8 2a fe ff ff       	call   80157f <fsipc>
  801755:	89 c3                	mov    %eax,%ebx
  801757:	85 c0                	test   %eax,%eax
  801759:	79 17                	jns    801772 <open+0x6c>
		fd_close(fd, 0);
  80175b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801762:	00 
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	89 04 24             	mov    %eax,(%esp)
  801769:	e8 44 f9 ff ff       	call   8010b2 <fd_close>
		return r;
  80176e:	89 d8                	mov    %ebx,%eax
  801770:	eb 12                	jmp    801784 <open+0x7e>
	}
	return fd2num(fd);
  801772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801775:	89 04 24             	mov    %eax,(%esp)
  801778:	e8 d3 f7 ff ff       	call   800f50 <fd2num>
  80177d:	eb 05                	jmp    801784 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80177f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801784:	83 c4 24             	add    $0x24,%esp
  801787:	5b                   	pop    %ebx
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
  80178a:	66 90                	xchg   %ax,%ax
  80178c:	66 90                	xchg   %ax,%ax
  80178e:	66 90                	xchg   %ax,%ax

00801790 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	56                   	push   %esi
  801794:	53                   	push   %ebx
  801795:	83 ec 10             	sub    $0x10,%esp
  801798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	89 04 24             	mov    %eax,(%esp)
  8017a1:	e8 ba f7 ff ff       	call   800f60 <fd2data>
  8017a6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017a8:	c7 44 24 04 99 25 80 	movl   $0x802599,0x4(%esp)
  8017af:	00 
  8017b0:	89 1c 24             	mov    %ebx,(%esp)
  8017b3:	e8 73 f0 ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017b8:	8b 46 04             	mov    0x4(%esi),%eax
  8017bb:	2b 06                	sub    (%esi),%eax
  8017bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ca:	00 00 00 
	stat->st_dev = &devpipe;
  8017cd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017d4:	30 80 00 
	return 0;
}
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5d                   	pop    %ebp
  8017e2:	c3                   	ret    

008017e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 14             	sub    $0x14,%esp
  8017ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f8:	e8 83 f5 ff ff       	call   800d80 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017fd:	89 1c 24             	mov    %ebx,(%esp)
  801800:	e8 5b f7 ff ff       	call   800f60 <fd2data>
  801805:	89 44 24 04          	mov    %eax,0x4(%esp)
  801809:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801810:	e8 6b f5 ff ff       	call   800d80 <sys_page_unmap>
}
  801815:	83 c4 14             	add    $0x14,%esp
  801818:	5b                   	pop    %ebx
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	57                   	push   %edi
  80181f:	56                   	push   %esi
  801820:	53                   	push   %ebx
  801821:	83 ec 2c             	sub    $0x2c,%esp
  801824:	89 c6                	mov    %eax,%esi
  801826:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801829:	a1 04 40 80 00       	mov    0x804004,%eax
  80182e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801831:	89 34 24             	mov    %esi,(%esp)
  801834:	e8 29 06 00 00       	call   801e62 <pageref>
  801839:	89 c7                	mov    %eax,%edi
  80183b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183e:	89 04 24             	mov    %eax,(%esp)
  801841:	e8 1c 06 00 00       	call   801e62 <pageref>
  801846:	39 c7                	cmp    %eax,%edi
  801848:	0f 94 c2             	sete   %dl
  80184b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80184e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801854:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801857:	39 fb                	cmp    %edi,%ebx
  801859:	74 21                	je     80187c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80185b:	84 d2                	test   %dl,%dl
  80185d:	74 ca                	je     801829 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80185f:	8b 51 58             	mov    0x58(%ecx),%edx
  801862:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801866:	89 54 24 08          	mov    %edx,0x8(%esp)
  80186a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80186e:	c7 04 24 a0 25 80 00 	movl   $0x8025a0,(%esp)
  801875:	e8 58 e9 ff ff       	call   8001d2 <cprintf>
  80187a:	eb ad                	jmp    801829 <_pipeisclosed+0xe>
	}
}
  80187c:	83 c4 2c             	add    $0x2c,%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5f                   	pop    %edi
  801882:	5d                   	pop    %ebp
  801883:	c3                   	ret    

00801884 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	57                   	push   %edi
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	83 ec 1c             	sub    $0x1c,%esp
  80188d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801890:	89 34 24             	mov    %esi,(%esp)
  801893:	e8 c8 f6 ff ff       	call   800f60 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	74 61                	je     8018ff <devpipe_write+0x7b>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a5:	eb 4a                	jmp    8018f1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8018a7:	89 da                	mov    %ebx,%edx
  8018a9:	89 f0                	mov    %esi,%eax
  8018ab:	e8 6b ff ff ff       	call   80181b <_pipeisclosed>
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	75 54                	jne    801908 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018b4:	e8 01 f4 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018b9:	8b 43 04             	mov    0x4(%ebx),%eax
  8018bc:	8b 0b                	mov    (%ebx),%ecx
  8018be:	8d 51 20             	lea    0x20(%ecx),%edx
  8018c1:	39 d0                	cmp    %edx,%eax
  8018c3:	73 e2                	jae    8018a7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018cc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018cf:	99                   	cltd   
  8018d0:	c1 ea 1b             	shr    $0x1b,%edx
  8018d3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8018d6:	83 e1 1f             	and    $0x1f,%ecx
  8018d9:	29 d1                	sub    %edx,%ecx
  8018db:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8018df:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8018e3:	83 c0 01             	add    $0x1,%eax
  8018e6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018e9:	83 c7 01             	add    $0x1,%edi
  8018ec:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018ef:	74 13                	je     801904 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018f1:	8b 43 04             	mov    0x4(%ebx),%eax
  8018f4:	8b 0b                	mov    (%ebx),%ecx
  8018f6:	8d 51 20             	lea    0x20(%ecx),%edx
  8018f9:	39 d0                	cmp    %edx,%eax
  8018fb:	73 aa                	jae    8018a7 <devpipe_write+0x23>
  8018fd:	eb c6                	jmp    8018c5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018ff:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801904:	89 f8                	mov    %edi,%eax
  801906:	eb 05                	jmp    80190d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80190d:	83 c4 1c             	add    $0x1c,%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5f                   	pop    %edi
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    

00801915 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	57                   	push   %edi
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
  80191b:	83 ec 1c             	sub    $0x1c,%esp
  80191e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801921:	89 3c 24             	mov    %edi,(%esp)
  801924:	e8 37 f6 ff ff       	call   800f60 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801929:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192d:	74 54                	je     801983 <devpipe_read+0x6e>
  80192f:	89 c3                	mov    %eax,%ebx
  801931:	be 00 00 00 00       	mov    $0x0,%esi
  801936:	eb 3e                	jmp    801976 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801938:	89 f0                	mov    %esi,%eax
  80193a:	eb 55                	jmp    801991 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80193c:	89 da                	mov    %ebx,%edx
  80193e:	89 f8                	mov    %edi,%eax
  801940:	e8 d6 fe ff ff       	call   80181b <_pipeisclosed>
  801945:	85 c0                	test   %eax,%eax
  801947:	75 43                	jne    80198c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801949:	e8 6c f3 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80194e:	8b 03                	mov    (%ebx),%eax
  801950:	3b 43 04             	cmp    0x4(%ebx),%eax
  801953:	74 e7                	je     80193c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801955:	99                   	cltd   
  801956:	c1 ea 1b             	shr    $0x1b,%edx
  801959:	01 d0                	add    %edx,%eax
  80195b:	83 e0 1f             	and    $0x1f,%eax
  80195e:	29 d0                	sub    %edx,%eax
  801960:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801965:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801968:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80196b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80196e:	83 c6 01             	add    $0x1,%esi
  801971:	3b 75 10             	cmp    0x10(%ebp),%esi
  801974:	74 12                	je     801988 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801976:	8b 03                	mov    (%ebx),%eax
  801978:	3b 43 04             	cmp    0x4(%ebx),%eax
  80197b:	75 d8                	jne    801955 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80197d:	85 f6                	test   %esi,%esi
  80197f:	75 b7                	jne    801938 <devpipe_read+0x23>
  801981:	eb b9                	jmp    80193c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801983:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801988:	89 f0                	mov    %esi,%eax
  80198a:	eb 05                	jmp    801991 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801991:	83 c4 1c             	add    $0x1c,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	56                   	push   %esi
  80199d:	53                   	push   %ebx
  80199e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8019a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 cb f5 ff ff       	call   800f77 <fd_alloc>
  8019ac:	89 c2                	mov    %eax,%edx
  8019ae:	85 d2                	test   %edx,%edx
  8019b0:	0f 88 4d 01 00 00    	js     801b03 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019b6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019bd:	00 
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cc:	e8 08 f3 ff ff       	call   800cd9 <sys_page_alloc>
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	85 d2                	test   %edx,%edx
  8019d5:	0f 88 28 01 00 00    	js     801b03 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8019db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	e8 91 f5 ff ff       	call   800f77 <fd_alloc>
  8019e6:	89 c3                	mov    %eax,%ebx
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	0f 88 fe 00 00 00    	js     801aee <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019f7:	00 
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a06:	e8 ce f2 ff ff       	call   800cd9 <sys_page_alloc>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	0f 88 d9 00 00 00    	js     801aee <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a18:	89 04 24             	mov    %eax,(%esp)
  801a1b:	e8 40 f5 ff ff       	call   800f60 <fd2data>
  801a20:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a22:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a29:	00 
  801a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a35:	e8 9f f2 ff ff       	call   800cd9 <sys_page_alloc>
  801a3a:	89 c3                	mov    %eax,%ebx
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	0f 88 97 00 00 00    	js     801adb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	89 04 24             	mov    %eax,(%esp)
  801a4a:	e8 11 f5 ff ff       	call   800f60 <fd2data>
  801a4f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a56:	00 
  801a57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a62:	00 
  801a63:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6e:	e8 ba f2 ff ff       	call   800d2d <sys_page_map>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 52                	js     801acb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a79:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a8e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a97:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa6:	89 04 24             	mov    %eax,(%esp)
  801aa9:	e8 a2 f4 ff ff       	call   800f50 <fd2num>
  801aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab6:	89 04 24             	mov    %eax,(%esp)
  801ab9:	e8 92 f4 ff ff       	call   800f50 <fd2num>
  801abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac9:	eb 38                	jmp    801b03 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801acb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801acf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad6:	e8 a5 f2 ff ff       	call   800d80 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae9:	e8 92 f2 ff ff       	call   800d80 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afc:	e8 7f f2 ff ff       	call   800d80 <sys_page_unmap>
  801b01:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801b03:	83 c4 30             	add    $0x30,%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	89 04 24             	mov    %eax,(%esp)
  801b1d:	e8 c9 f4 ff ff       	call   800feb <fd_lookup>
  801b22:	89 c2                	mov    %eax,%edx
  801b24:	85 d2                	test   %edx,%edx
  801b26:	78 15                	js     801b3d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	e8 2d f4 ff ff       	call   800f60 <fd2data>
	return _pipeisclosed(fd, p);
  801b33:	89 c2                	mov    %eax,%edx
  801b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b38:	e8 de fc ff ff       	call   80181b <_pipeisclosed>
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    
  801b3f:	90                   	nop

00801b40 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b50:	c7 44 24 04 b8 25 80 	movl   $0x8025b8,0x4(%esp)
  801b57:	00 
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	89 04 24             	mov    %eax,(%esp)
  801b5e:	e8 c8 ec ff ff       	call   80082b <strcpy>
	return 0;
}
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b7a:	74 4a                	je     801bc6 <devcons_write+0x5c>
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b81:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b8c:	8b 75 10             	mov    0x10(%ebp),%esi
  801b8f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801b91:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b94:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b99:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b9c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801ba0:	03 45 0c             	add    0xc(%ebp),%eax
  801ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba7:	89 3c 24             	mov    %edi,(%esp)
  801baa:	e8 77 ee ff ff       	call   800a26 <memmove>
		sys_cputs(buf, m);
  801baf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb3:	89 3c 24             	mov    %edi,(%esp)
  801bb6:	e8 51 f0 ff ff       	call   800c0c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bbb:	01 f3                	add    %esi,%ebx
  801bbd:	89 d8                	mov    %ebx,%eax
  801bbf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801bc2:	72 c8                	jb     801b8c <devcons_write+0x22>
  801bc4:	eb 05                	jmp    801bcb <devcons_write+0x61>
  801bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801bcb:	89 d8                	mov    %ebx,%eax
  801bcd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801be3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801be7:	75 07                	jne    801bf0 <devcons_read+0x18>
  801be9:	eb 28                	jmp    801c13 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801beb:	e8 ca f0 ff ff       	call   800cba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801bf0:	e8 35 f0 ff ff       	call   800c2a <sys_cgetc>
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	74 f2                	je     801beb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 16                	js     801c13 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801bfd:	83 f8 04             	cmp    $0x4,%eax
  801c00:	74 0c                	je     801c0e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	88 02                	mov    %al,(%edx)
	return 1;
  801c07:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0c:	eb 05                	jmp    801c13 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c28:	00 
  801c29:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 d8 ef ff ff       	call   800c0c <sys_cputs>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <getchar>:

int
getchar(void)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c43:	00 
  801c44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c52:	e8 3f f6 ff ff       	call   801296 <read>
	if (r < 0)
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 0f                	js     801c6a <getchar+0x34>
		return r;
	if (r < 1)
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	7e 06                	jle    801c65 <getchar+0x2f>
		return -E_EOF;
	return c;
  801c5f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c63:	eb 05                	jmp    801c6a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c65:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	89 04 24             	mov    %eax,(%esp)
  801c7f:	e8 67 f3 ff ff       	call   800feb <fd_lookup>
  801c84:	85 c0                	test   %eax,%eax
  801c86:	78 11                	js     801c99 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c91:	39 10                	cmp    %edx,(%eax)
  801c93:	0f 94 c0             	sete   %al
  801c96:	0f b6 c0             	movzbl %al,%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <opencons>:

int
opencons(void)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ca1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	e8 cb f2 ff ff       	call   800f77 <fd_alloc>
		return r;
  801cac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	78 40                	js     801cf2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cb2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cb9:	00 
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cc8:	e8 0c f0 ff ff       	call   800cd9 <sys_page_alloc>
		return r;
  801ccd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 1f                	js     801cf2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801cd3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ce8:	89 04 24             	mov    %eax,(%esp)
  801ceb:	e8 60 f2 ff ff       	call   800f50 <fd2num>
  801cf0:	89 c2                	mov    %eax,%edx
}
  801cf2:	89 d0                	mov    %edx,%eax
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801cfe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d01:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d07:	e8 8f ef ff ff       	call   800c9b <sys_getenvid>
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d13:	8b 55 08             	mov    0x8(%ebp),%edx
  801d16:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d1a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d22:	c7 04 24 c4 25 80 00 	movl   $0x8025c4,(%esp)
  801d29:	e8 a4 e4 ff ff       	call   8001d2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d2e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d32:	8b 45 10             	mov    0x10(%ebp),%eax
  801d35:	89 04 24             	mov    %eax,(%esp)
  801d38:	e8 34 e4 ff ff       	call   800171 <vcprintf>
	cprintf("\n");
  801d3d:	c7 04 24 b1 25 80 00 	movl   $0x8025b1,(%esp)
  801d44:	e8 89 e4 ff ff       	call   8001d2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d49:	cc                   	int3   
  801d4a:	eb fd                	jmp    801d49 <_panic+0x53>

00801d4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	56                   	push   %esi
  801d50:	53                   	push   %ebx
  801d51:	83 ec 10             	sub    $0x10,%esp
  801d54:	8b 75 08             	mov    0x8(%ebp),%esi
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d64:	0f 44 c2             	cmove  %edx,%eax
  801d67:	89 04 24             	mov    %eax,(%esp)
  801d6a:	e8 80 f1 ff ff       	call   800eef <sys_ipc_recv>
	if (err_code < 0) {
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	79 16                	jns    801d89 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d73:	85 f6                	test   %esi,%esi
  801d75:	74 06                	je     801d7d <ipc_recv+0x31>
  801d77:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d7d:	85 db                	test   %ebx,%ebx
  801d7f:	74 2c                	je     801dad <ipc_recv+0x61>
  801d81:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d87:	eb 24                	jmp    801dad <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d89:	85 f6                	test   %esi,%esi
  801d8b:	74 0a                	je     801d97 <ipc_recv+0x4b>
  801d8d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d92:	8b 40 74             	mov    0x74(%eax),%eax
  801d95:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d97:	85 db                	test   %ebx,%ebx
  801d99:	74 0a                	je     801da5 <ipc_recv+0x59>
  801d9b:	a1 04 40 80 00       	mov    0x804004,%eax
  801da0:	8b 40 78             	mov    0x78(%eax),%eax
  801da3:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801da5:	a1 04 40 80 00       	mov    0x804004,%eax
  801daa:	8b 40 70             	mov    0x70(%eax),%eax
}
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    

00801db4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	57                   	push   %edi
  801db8:	56                   	push   %esi
  801db9:	53                   	push   %ebx
  801dba:	83 ec 1c             	sub    $0x1c,%esp
  801dbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801dc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801dc6:	eb 25                	jmp    801ded <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801dc8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dcb:	74 20                	je     801ded <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801dcd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd1:	c7 44 24 08 e8 25 80 	movl   $0x8025e8,0x8(%esp)
  801dd8:	00 
  801dd9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801de0:	00 
  801de1:	c7 04 24 f4 25 80 00 	movl   $0x8025f4,(%esp)
  801de8:	e8 09 ff ff ff       	call   801cf6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ded:	85 db                	test   %ebx,%ebx
  801def:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801df4:	0f 45 c3             	cmovne %ebx,%eax
  801df7:	8b 55 14             	mov    0x14(%ebp),%edx
  801dfa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e02:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e06:	89 3c 24             	mov    %edi,(%esp)
  801e09:	e8 be f0 ff ff       	call   800ecc <sys_ipc_try_send>
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	75 b6                	jne    801dc8 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801e12:	83 c4 1c             	add    $0x1c,%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e20:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e25:	39 c8                	cmp    %ecx,%eax
  801e27:	74 17                	je     801e40 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e29:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e2e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e31:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e37:	8b 52 50             	mov    0x50(%edx),%edx
  801e3a:	39 ca                	cmp    %ecx,%edx
  801e3c:	75 14                	jne    801e52 <ipc_find_env+0x38>
  801e3e:	eb 05                	jmp    801e45 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e45:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e48:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e4d:	8b 40 40             	mov    0x40(%eax),%eax
  801e50:	eb 0e                	jmp    801e60 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e52:	83 c0 01             	add    $0x1,%eax
  801e55:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e5a:	75 d2                	jne    801e2e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e5c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    

00801e62 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	c1 e8 16             	shr    $0x16,%eax
  801e6d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e79:	f6 c1 01             	test   $0x1,%cl
  801e7c:	74 1d                	je     801e9b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e7e:	c1 ea 0c             	shr    $0xc,%edx
  801e81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e88:	f6 c2 01             	test   $0x1,%dl
  801e8b:	74 0e                	je     801e9b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e8d:	c1 ea 0c             	shr    $0xc,%edx
  801e90:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e97:	ef 
  801e98:	0f b7 c0             	movzwl %ax,%eax
}
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	66 90                	xchg   %ax,%ax
  801e9f:	90                   	nop

00801ea0 <__udivdi3>:
  801ea0:	55                   	push   %ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801eaa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801eae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801eb2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ebc:	89 ea                	mov    %ebp,%edx
  801ebe:	89 0c 24             	mov    %ecx,(%esp)
  801ec1:	75 2d                	jne    801ef0 <__udivdi3+0x50>
  801ec3:	39 e9                	cmp    %ebp,%ecx
  801ec5:	77 61                	ja     801f28 <__udivdi3+0x88>
  801ec7:	85 c9                	test   %ecx,%ecx
  801ec9:	89 ce                	mov    %ecx,%esi
  801ecb:	75 0b                	jne    801ed8 <__udivdi3+0x38>
  801ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed2:	31 d2                	xor    %edx,%edx
  801ed4:	f7 f1                	div    %ecx
  801ed6:	89 c6                	mov    %eax,%esi
  801ed8:	31 d2                	xor    %edx,%edx
  801eda:	89 e8                	mov    %ebp,%eax
  801edc:	f7 f6                	div    %esi
  801ede:	89 c5                	mov    %eax,%ebp
  801ee0:	89 f8                	mov    %edi,%eax
  801ee2:	f7 f6                	div    %esi
  801ee4:	89 ea                	mov    %ebp,%edx
  801ee6:	83 c4 0c             	add    $0xc,%esp
  801ee9:	5e                   	pop    %esi
  801eea:	5f                   	pop    %edi
  801eeb:	5d                   	pop    %ebp
  801eec:	c3                   	ret    
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	39 e8                	cmp    %ebp,%eax
  801ef2:	77 24                	ja     801f18 <__udivdi3+0x78>
  801ef4:	0f bd e8             	bsr    %eax,%ebp
  801ef7:	83 f5 1f             	xor    $0x1f,%ebp
  801efa:	75 3c                	jne    801f38 <__udivdi3+0x98>
  801efc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f00:	39 34 24             	cmp    %esi,(%esp)
  801f03:	0f 86 9f 00 00 00    	jbe    801fa8 <__udivdi3+0x108>
  801f09:	39 d0                	cmp    %edx,%eax
  801f0b:	0f 82 97 00 00 00    	jb     801fa8 <__udivdi3+0x108>
  801f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f18:	31 d2                	xor    %edx,%edx
  801f1a:	31 c0                	xor    %eax,%eax
  801f1c:	83 c4 0c             	add    $0xc,%esp
  801f1f:	5e                   	pop    %esi
  801f20:	5f                   	pop    %edi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    
  801f23:	90                   	nop
  801f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f28:	89 f8                	mov    %edi,%eax
  801f2a:	f7 f1                	div    %ecx
  801f2c:	31 d2                	xor    %edx,%edx
  801f2e:	83 c4 0c             	add    $0xc,%esp
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	89 e9                	mov    %ebp,%ecx
  801f3a:	8b 3c 24             	mov    (%esp),%edi
  801f3d:	d3 e0                	shl    %cl,%eax
  801f3f:	89 c6                	mov    %eax,%esi
  801f41:	b8 20 00 00 00       	mov    $0x20,%eax
  801f46:	29 e8                	sub    %ebp,%eax
  801f48:	89 c1                	mov    %eax,%ecx
  801f4a:	d3 ef                	shr    %cl,%edi
  801f4c:	89 e9                	mov    %ebp,%ecx
  801f4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f52:	8b 3c 24             	mov    (%esp),%edi
  801f55:	09 74 24 08          	or     %esi,0x8(%esp)
  801f59:	89 d6                	mov    %edx,%esi
  801f5b:	d3 e7                	shl    %cl,%edi
  801f5d:	89 c1                	mov    %eax,%ecx
  801f5f:	89 3c 24             	mov    %edi,(%esp)
  801f62:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f66:	d3 ee                	shr    %cl,%esi
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	d3 e2                	shl    %cl,%edx
  801f6c:	89 c1                	mov    %eax,%ecx
  801f6e:	d3 ef                	shr    %cl,%edi
  801f70:	09 d7                	or     %edx,%edi
  801f72:	89 f2                	mov    %esi,%edx
  801f74:	89 f8                	mov    %edi,%eax
  801f76:	f7 74 24 08          	divl   0x8(%esp)
  801f7a:	89 d6                	mov    %edx,%esi
  801f7c:	89 c7                	mov    %eax,%edi
  801f7e:	f7 24 24             	mull   (%esp)
  801f81:	39 d6                	cmp    %edx,%esi
  801f83:	89 14 24             	mov    %edx,(%esp)
  801f86:	72 30                	jb     801fb8 <__udivdi3+0x118>
  801f88:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f8c:	89 e9                	mov    %ebp,%ecx
  801f8e:	d3 e2                	shl    %cl,%edx
  801f90:	39 c2                	cmp    %eax,%edx
  801f92:	73 05                	jae    801f99 <__udivdi3+0xf9>
  801f94:	3b 34 24             	cmp    (%esp),%esi
  801f97:	74 1f                	je     801fb8 <__udivdi3+0x118>
  801f99:	89 f8                	mov    %edi,%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	e9 7a ff ff ff       	jmp    801f1c <__udivdi3+0x7c>
  801fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fa8:	31 d2                	xor    %edx,%edx
  801faa:	b8 01 00 00 00       	mov    $0x1,%eax
  801faf:	e9 68 ff ff ff       	jmp    801f1c <__udivdi3+0x7c>
  801fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fb8:	8d 47 ff             	lea    -0x1(%edi),%eax
  801fbb:	31 d2                	xor    %edx,%edx
  801fbd:	83 c4 0c             	add    $0xc,%esp
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    
  801fc4:	66 90                	xchg   %ax,%ax
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	66 90                	xchg   %ax,%ax
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	66 90                	xchg   %ax,%ax
  801fce:	66 90                	xchg   %ax,%ax

00801fd0 <__umoddi3>:
  801fd0:	55                   	push   %ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	83 ec 14             	sub    $0x14,%esp
  801fd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801fda:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fde:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801ff0:	89 34 24             	mov    %esi,(%esp)
  801ff3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	89 c2                	mov    %eax,%edx
  801ffb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fff:	75 17                	jne    802018 <__umoddi3+0x48>
  802001:	39 fe                	cmp    %edi,%esi
  802003:	76 4b                	jbe    802050 <__umoddi3+0x80>
  802005:	89 c8                	mov    %ecx,%eax
  802007:	89 fa                	mov    %edi,%edx
  802009:	f7 f6                	div    %esi
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	31 d2                	xor    %edx,%edx
  80200f:	83 c4 14             	add    $0x14,%esp
  802012:	5e                   	pop    %esi
  802013:	5f                   	pop    %edi
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    
  802016:	66 90                	xchg   %ax,%ax
  802018:	39 f8                	cmp    %edi,%eax
  80201a:	77 54                	ja     802070 <__umoddi3+0xa0>
  80201c:	0f bd e8             	bsr    %eax,%ebp
  80201f:	83 f5 1f             	xor    $0x1f,%ebp
  802022:	75 5c                	jne    802080 <__umoddi3+0xb0>
  802024:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802028:	39 3c 24             	cmp    %edi,(%esp)
  80202b:	0f 87 e7 00 00 00    	ja     802118 <__umoddi3+0x148>
  802031:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802035:	29 f1                	sub    %esi,%ecx
  802037:	19 c7                	sbb    %eax,%edi
  802039:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80203d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802041:	8b 44 24 08          	mov    0x8(%esp),%eax
  802045:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802049:	83 c4 14             	add    $0x14,%esp
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	85 f6                	test   %esi,%esi
  802052:	89 f5                	mov    %esi,%ebp
  802054:	75 0b                	jne    802061 <__umoddi3+0x91>
  802056:	b8 01 00 00 00       	mov    $0x1,%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	f7 f6                	div    %esi
  80205f:	89 c5                	mov    %eax,%ebp
  802061:	8b 44 24 04          	mov    0x4(%esp),%eax
  802065:	31 d2                	xor    %edx,%edx
  802067:	f7 f5                	div    %ebp
  802069:	89 c8                	mov    %ecx,%eax
  80206b:	f7 f5                	div    %ebp
  80206d:	eb 9c                	jmp    80200b <__umoddi3+0x3b>
  80206f:	90                   	nop
  802070:	89 c8                	mov    %ecx,%eax
  802072:	89 fa                	mov    %edi,%edx
  802074:	83 c4 14             	add    $0x14,%esp
  802077:	5e                   	pop    %esi
  802078:	5f                   	pop    %edi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    
  80207b:	90                   	nop
  80207c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802080:	8b 04 24             	mov    (%esp),%eax
  802083:	be 20 00 00 00       	mov    $0x20,%esi
  802088:	89 e9                	mov    %ebp,%ecx
  80208a:	29 ee                	sub    %ebp,%esi
  80208c:	d3 e2                	shl    %cl,%edx
  80208e:	89 f1                	mov    %esi,%ecx
  802090:	d3 e8                	shr    %cl,%eax
  802092:	89 e9                	mov    %ebp,%ecx
  802094:	89 44 24 04          	mov    %eax,0x4(%esp)
  802098:	8b 04 24             	mov    (%esp),%eax
  80209b:	09 54 24 04          	or     %edx,0x4(%esp)
  80209f:	89 fa                	mov    %edi,%edx
  8020a1:	d3 e0                	shl    %cl,%eax
  8020a3:	89 f1                	mov    %esi,%ecx
  8020a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8020ad:	d3 ea                	shr    %cl,%edx
  8020af:	89 e9                	mov    %ebp,%ecx
  8020b1:	d3 e7                	shl    %cl,%edi
  8020b3:	89 f1                	mov    %esi,%ecx
  8020b5:	d3 e8                	shr    %cl,%eax
  8020b7:	89 e9                	mov    %ebp,%ecx
  8020b9:	09 f8                	or     %edi,%eax
  8020bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8020bf:	f7 74 24 04          	divl   0x4(%esp)
  8020c3:	d3 e7                	shl    %cl,%edi
  8020c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020c9:	89 d7                	mov    %edx,%edi
  8020cb:	f7 64 24 08          	mull   0x8(%esp)
  8020cf:	39 d7                	cmp    %edx,%edi
  8020d1:	89 c1                	mov    %eax,%ecx
  8020d3:	89 14 24             	mov    %edx,(%esp)
  8020d6:	72 2c                	jb     802104 <__umoddi3+0x134>
  8020d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8020dc:	72 22                	jb     802100 <__umoddi3+0x130>
  8020de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020e2:	29 c8                	sub    %ecx,%eax
  8020e4:	19 d7                	sbb    %edx,%edi
  8020e6:	89 e9                	mov    %ebp,%ecx
  8020e8:	89 fa                	mov    %edi,%edx
  8020ea:	d3 e8                	shr    %cl,%eax
  8020ec:	89 f1                	mov    %esi,%ecx
  8020ee:	d3 e2                	shl    %cl,%edx
  8020f0:	89 e9                	mov    %ebp,%ecx
  8020f2:	d3 ef                	shr    %cl,%edi
  8020f4:	09 d0                	or     %edx,%eax
  8020f6:	89 fa                	mov    %edi,%edx
  8020f8:	83 c4 14             	add    $0x14,%esp
  8020fb:	5e                   	pop    %esi
  8020fc:	5f                   	pop    %edi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    
  8020ff:	90                   	nop
  802100:	39 d7                	cmp    %edx,%edi
  802102:	75 da                	jne    8020de <__umoddi3+0x10e>
  802104:	8b 14 24             	mov    (%esp),%edx
  802107:	89 c1                	mov    %eax,%ecx
  802109:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80210d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802111:	eb cb                	jmp    8020de <__umoddi3+0x10e>
  802113:	90                   	nop
  802114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802118:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80211c:	0f 82 0f ff ff ff    	jb     802031 <__umoddi3+0x61>
  802122:	e9 1a ff ff ff       	jmp    802041 <__umoddi3+0x71>
