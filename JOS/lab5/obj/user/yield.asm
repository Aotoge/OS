
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
  800046:	c7 04 24 60 21 80 00 	movl   $0x802160,(%esp)
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
  80006c:	c7 04 24 80 21 80 00 	movl   $0x802180,(%esp)
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
  80008c:	c7 04 24 ac 21 80 00 	movl   $0x8021ac,(%esp)
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
  80026c:	e8 5f 1c 00 00       	call   801ed0 <__udivdi3>
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
  8002c5:	e8 36 1d 00 00       	call   802000 <__umoddi3>
  8002ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ce:	0f be 80 d5 21 80 00 	movsbl 0x8021d5(%eax),%eax
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
  8003ec:	ff 24 85 20 23 80 00 	jmp    *0x802320(,%eax,4)
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
  80049f:	8b 14 85 80 24 80 00 	mov    0x802480(,%eax,4),%edx
  8004a6:	85 d2                	test   %edx,%edx
  8004a8:	75 20                	jne    8004ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ae:	c7 44 24 08 ed 21 80 	movl   $0x8021ed,0x8(%esp)
  8004b5:	00 
  8004b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 77 fe ff ff       	call   80033c <printfmt>
  8004c5:	e9 c3 fe ff ff       	jmp    80038d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8004ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ce:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
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
  8004fd:	ba e6 21 80 00       	mov    $0x8021e6,%edx
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
  800c77:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800c7e:	00 
  800c7f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800c86:	00 
  800c87:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800c8e:	e8 93 10 00 00       	call   801d26 <_panic>

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
  800d09:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800d10:	00 
  800d11:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d18:	00 
  800d19:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800d20:	e8 01 10 00 00       	call   801d26 <_panic>

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
  800d5c:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800d73:	e8 ae 0f 00 00       	call   801d26 <_panic>

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
  800daf:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800dc6:	e8 5b 0f 00 00       	call   801d26 <_panic>

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
  800e02:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800e09:	00 
  800e0a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e11:	00 
  800e12:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800e19:	e8 08 0f 00 00       	call   801d26 <_panic>

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
  800e55:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800e5c:	00 
  800e5d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e64:	00 
  800e65:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800e6c:	e8 b5 0e 00 00       	call   801d26 <_panic>

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
  800ea8:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800ebf:	e8 62 0e 00 00       	call   801d26 <_panic>

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
  800f1d:	c7 44 24 08 df 24 80 	movl   $0x8024df,0x8(%esp)
  800f24:	00 
  800f25:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f2c:	00 
  800f2d:	c7 04 24 fc 24 80 00 	movl   $0x8024fc,(%esp)
  800f34:	e8 ed 0d 00 00       	call   801d26 <_panic>

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
  801095:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
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
  8012eb:	c7 04 24 4d 25 80 00 	movl   $0x80254d,(%esp)
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
  8013d3:	c7 04 24 69 25 80 00 	movl   $0x802569,(%esp)
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
  80148c:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
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
  801552:	e8 e1 01 00 00       	call   801738 <open>
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
  801587:	89 c3                	mov    %eax,%ebx
  801589:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80158b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801592:	75 11                	jne    8015a5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801594:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80159b:	e8 aa 08 00 00       	call   801e4a <ipc_find_env>
  8015a0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8015a5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015aa:	8b 40 48             	mov    0x48(%eax),%eax
  8015ad:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8015b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bf:	c7 04 24 86 25 80 00 	movl   $0x802586,(%esp)
  8015c6:	e8 07 ec ff ff       	call   8001d2 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015cb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015d2:	00 
  8015d3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015da:	00 
  8015db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015df:	a1 00 40 80 00       	mov    0x804000,%eax
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	e8 f8 07 00 00       	call   801de4 <ipc_send>
	cprintf("ipc_send\n");
  8015ec:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8015f3:	e8 da eb ff ff       	call   8001d2 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  8015f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ff:	00 
  801600:	89 74 24 04          	mov    %esi,0x4(%esp)
  801604:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80160b:	e8 6c 07 00 00       	call   801d7c <ipc_recv>
}
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	5b                   	pop    %ebx
  801614:	5e                   	pop    %esi
  801615:	5d                   	pop    %ebp
  801616:	c3                   	ret    

00801617 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	53                   	push   %ebx
  80161b:	83 ec 14             	sub    $0x14,%esp
  80161e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8b 40 0c             	mov    0xc(%eax),%eax
  801627:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80162c:	ba 00 00 00 00       	mov    $0x0,%edx
  801631:	b8 05 00 00 00       	mov    $0x5,%eax
  801636:	e8 44 ff ff ff       	call   80157f <fsipc>
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	85 d2                	test   %edx,%edx
  80163f:	78 2b                	js     80166c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801641:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801648:	00 
  801649:	89 1c 24             	mov    %ebx,(%esp)
  80164c:	e8 da f1 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801651:	a1 80 50 80 00       	mov    0x805080,%eax
  801656:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80165c:	a1 84 50 80 00       	mov    0x805084,%eax
  801661:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166c:	83 c4 14             	add    $0x14,%esp
  80166f:	5b                   	pop    %ebx
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8b 40 0c             	mov    0xc(%eax),%eax
  80167e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801683:	ba 00 00 00 00       	mov    $0x0,%edx
  801688:	b8 06 00 00 00       	mov    $0x6,%eax
  80168d:	e8 ed fe ff ff       	call   80157f <fsipc>
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	83 ec 10             	sub    $0x10,%esp
  80169c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016aa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ba:	e8 c0 fe ff ff       	call   80157f <fsipc>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 6a                	js     80172f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016c5:	39 c6                	cmp    %eax,%esi
  8016c7:	73 24                	jae    8016ed <devfile_read+0x59>
  8016c9:	c7 44 24 0c a6 25 80 	movl   $0x8025a6,0xc(%esp)
  8016d0:	00 
  8016d1:	c7 44 24 08 ad 25 80 	movl   $0x8025ad,0x8(%esp)
  8016d8:	00 
  8016d9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016e0:	00 
  8016e1:	c7 04 24 c2 25 80 00 	movl   $0x8025c2,(%esp)
  8016e8:	e8 39 06 00 00       	call   801d26 <_panic>
	assert(r <= PGSIZE);
  8016ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f2:	7e 24                	jle    801718 <devfile_read+0x84>
  8016f4:	c7 44 24 0c cd 25 80 	movl   $0x8025cd,0xc(%esp)
  8016fb:	00 
  8016fc:	c7 44 24 08 ad 25 80 	movl   $0x8025ad,0x8(%esp)
  801703:	00 
  801704:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80170b:	00 
  80170c:	c7 04 24 c2 25 80 00 	movl   $0x8025c2,(%esp)
  801713:	e8 0e 06 00 00       	call   801d26 <_panic>
	memmove(buf, &fsipcbuf, r);
  801718:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801723:	00 
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 f7 f2 ff ff       	call   800a26 <memmove>
	return r;
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
  80173c:	83 ec 24             	sub    $0x24,%esp
  80173f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801742:	89 1c 24             	mov    %ebx,(%esp)
  801745:	e8 86 f0 ff ff       	call   8007d0 <strlen>
  80174a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80174f:	7f 60                	jg     8017b1 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 1b f8 ff ff       	call   800f77 <fd_alloc>
  80175c:	89 c2                	mov    %eax,%edx
  80175e:	85 d2                	test   %edx,%edx
  801760:	78 54                	js     8017b6 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801766:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80176d:	e8 b9 f0 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177d:	b8 01 00 00 00       	mov    $0x1,%eax
  801782:	e8 f8 fd ff ff       	call   80157f <fsipc>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	85 c0                	test   %eax,%eax
  80178b:	79 17                	jns    8017a4 <open+0x6c>
		fd_close(fd, 0);
  80178d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801794:	00 
  801795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801798:	89 04 24             	mov    %eax,(%esp)
  80179b:	e8 12 f9 ff ff       	call   8010b2 <fd_close>
		return r;
  8017a0:	89 d8                	mov    %ebx,%eax
  8017a2:	eb 12                	jmp    8017b6 <open+0x7e>
	}
	return fd2num(fd);
  8017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a7:	89 04 24             	mov    %eax,(%esp)
  8017aa:	e8 a1 f7 ff ff       	call   800f50 <fd2num>
  8017af:	eb 05                	jmp    8017b6 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017b1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8017b6:	83 c4 24             	add    $0x24,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    
  8017bc:	66 90                	xchg   %ax,%ax
  8017be:	66 90                	xchg   %ax,%ax

008017c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
  8017c5:	83 ec 10             	sub    $0x10,%esp
  8017c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 04 24             	mov    %eax,(%esp)
  8017d1:	e8 8a f7 ff ff       	call   800f60 <fd2data>
  8017d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017d8:	c7 44 24 04 d9 25 80 	movl   $0x8025d9,0x4(%esp)
  8017df:	00 
  8017e0:	89 1c 24             	mov    %ebx,(%esp)
  8017e3:	e8 43 f0 ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017e8:	8b 46 04             	mov    0x4(%esi),%eax
  8017eb:	2b 06                	sub    (%esi),%eax
  8017ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017fa:	00 00 00 
	stat->st_dev = &devpipe;
  8017fd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801804:	30 80 00 
	return 0;
}
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 14             	sub    $0x14,%esp
  80181a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80181d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801821:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801828:	e8 53 f5 ff ff       	call   800d80 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80182d:	89 1c 24             	mov    %ebx,(%esp)
  801830:	e8 2b f7 ff ff       	call   800f60 <fd2data>
  801835:	89 44 24 04          	mov    %eax,0x4(%esp)
  801839:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801840:	e8 3b f5 ff ff       	call   800d80 <sys_page_unmap>
}
  801845:	83 c4 14             	add    $0x14,%esp
  801848:	5b                   	pop    %ebx
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 2c             	sub    $0x2c,%esp
  801854:	89 c6                	mov    %eax,%esi
  801856:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801859:	a1 04 40 80 00       	mov    0x804004,%eax
  80185e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801861:	89 34 24             	mov    %esi,(%esp)
  801864:	e8 29 06 00 00       	call   801e92 <pageref>
  801869:	89 c7                	mov    %eax,%edi
  80186b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 1c 06 00 00       	call   801e92 <pageref>
  801876:	39 c7                	cmp    %eax,%edi
  801878:	0f 94 c2             	sete   %dl
  80187b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80187e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801884:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801887:	39 fb                	cmp    %edi,%ebx
  801889:	74 21                	je     8018ac <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80188b:	84 d2                	test   %dl,%dl
  80188d:	74 ca                	je     801859 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80188f:	8b 51 58             	mov    0x58(%ecx),%edx
  801892:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801896:	89 54 24 08          	mov    %edx,0x8(%esp)
  80189a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80189e:	c7 04 24 e0 25 80 00 	movl   $0x8025e0,(%esp)
  8018a5:	e8 28 e9 ff ff       	call   8001d2 <cprintf>
  8018aa:	eb ad                	jmp    801859 <_pipeisclosed+0xe>
	}
}
  8018ac:	83 c4 2c             	add    $0x2c,%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5f                   	pop    %edi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    

008018b4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	57                   	push   %edi
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 1c             	sub    $0x1c,%esp
  8018bd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018c0:	89 34 24             	mov    %esi,(%esp)
  8018c3:	e8 98 f6 ff ff       	call   800f60 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018cc:	74 61                	je     80192f <devpipe_write+0x7b>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d5:	eb 4a                	jmp    801921 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8018d7:	89 da                	mov    %ebx,%edx
  8018d9:	89 f0                	mov    %esi,%eax
  8018db:	e8 6b ff ff ff       	call   80184b <_pipeisclosed>
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	75 54                	jne    801938 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8018e4:	e8 d1 f3 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018e9:	8b 43 04             	mov    0x4(%ebx),%eax
  8018ec:	8b 0b                	mov    (%ebx),%ecx
  8018ee:	8d 51 20             	lea    0x20(%ecx),%edx
  8018f1:	39 d0                	cmp    %edx,%eax
  8018f3:	73 e2                	jae    8018d7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018fc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018ff:	99                   	cltd   
  801900:	c1 ea 1b             	shr    $0x1b,%edx
  801903:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801906:	83 e1 1f             	and    $0x1f,%ecx
  801909:	29 d1                	sub    %edx,%ecx
  80190b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80190f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801913:	83 c0 01             	add    $0x1,%eax
  801916:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801919:	83 c7 01             	add    $0x1,%edi
  80191c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80191f:	74 13                	je     801934 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801921:	8b 43 04             	mov    0x4(%ebx),%eax
  801924:	8b 0b                	mov    (%ebx),%ecx
  801926:	8d 51 20             	lea    0x20(%ecx),%edx
  801929:	39 d0                	cmp    %edx,%eax
  80192b:	73 aa                	jae    8018d7 <devpipe_write+0x23>
  80192d:	eb c6                	jmp    8018f5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80192f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801934:	89 f8                	mov    %edi,%eax
  801936:	eb 05                	jmp    80193d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80193d:	83 c4 1c             	add    $0x1c,%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5f                   	pop    %edi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	57                   	push   %edi
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	83 ec 1c             	sub    $0x1c,%esp
  80194e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801951:	89 3c 24             	mov    %edi,(%esp)
  801954:	e8 07 f6 ff ff       	call   800f60 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801959:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80195d:	74 54                	je     8019b3 <devpipe_read+0x6e>
  80195f:	89 c3                	mov    %eax,%ebx
  801961:	be 00 00 00 00       	mov    $0x0,%esi
  801966:	eb 3e                	jmp    8019a6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801968:	89 f0                	mov    %esi,%eax
  80196a:	eb 55                	jmp    8019c1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80196c:	89 da                	mov    %ebx,%edx
  80196e:	89 f8                	mov    %edi,%eax
  801970:	e8 d6 fe ff ff       	call   80184b <_pipeisclosed>
  801975:	85 c0                	test   %eax,%eax
  801977:	75 43                	jne    8019bc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801979:	e8 3c f3 ff ff       	call   800cba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80197e:	8b 03                	mov    (%ebx),%eax
  801980:	3b 43 04             	cmp    0x4(%ebx),%eax
  801983:	74 e7                	je     80196c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801985:	99                   	cltd   
  801986:	c1 ea 1b             	shr    $0x1b,%edx
  801989:	01 d0                	add    %edx,%eax
  80198b:	83 e0 1f             	and    $0x1f,%eax
  80198e:	29 d0                	sub    %edx,%eax
  801990:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801998:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80199b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80199e:	83 c6 01             	add    $0x1,%esi
  8019a1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019a4:	74 12                	je     8019b8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8019a6:	8b 03                	mov    (%ebx),%eax
  8019a8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019ab:	75 d8                	jne    801985 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019ad:	85 f6                	test   %esi,%esi
  8019af:	75 b7                	jne    801968 <devpipe_read+0x23>
  8019b1:	eb b9                	jmp    80196c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019b3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019b8:	89 f0                	mov    %esi,%eax
  8019ba:	eb 05                	jmp    8019c1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8019c1:	83 c4 1c             	add    $0x1c,%esp
  8019c4:	5b                   	pop    %ebx
  8019c5:	5e                   	pop    %esi
  8019c6:	5f                   	pop    %edi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    

008019c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	56                   	push   %esi
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8019d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d4:	89 04 24             	mov    %eax,(%esp)
  8019d7:	e8 9b f5 ff ff       	call   800f77 <fd_alloc>
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	85 d2                	test   %edx,%edx
  8019e0:	0f 88 4d 01 00 00    	js     801b33 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019ed:	00 
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fc:	e8 d8 f2 ff ff       	call   800cd9 <sys_page_alloc>
  801a01:	89 c2                	mov    %eax,%edx
  801a03:	85 d2                	test   %edx,%edx
  801a05:	0f 88 28 01 00 00    	js     801b33 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801a0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0e:	89 04 24             	mov    %eax,(%esp)
  801a11:	e8 61 f5 ff ff       	call   800f77 <fd_alloc>
  801a16:	89 c3                	mov    %eax,%ebx
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	0f 88 fe 00 00 00    	js     801b1e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a20:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a27:	00 
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a36:	e8 9e f2 ff ff       	call   800cd9 <sys_page_alloc>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	0f 88 d9 00 00 00    	js     801b1e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 10 f5 ff ff       	call   800f60 <fd2data>
  801a50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a59:	00 
  801a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a65:	e8 6f f2 ff ff       	call   800cd9 <sys_page_alloc>
  801a6a:	89 c3                	mov    %eax,%ebx
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	0f 88 97 00 00 00    	js     801b0b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	e8 e1 f4 ff ff       	call   800f60 <fd2data>
  801a7f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a86:	00 
  801a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a92:	00 
  801a93:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9e:	e8 8a f2 ff ff       	call   800d2d <sys_page_map>
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 52                	js     801afb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801aa9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801abe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 72 f4 ff ff       	call   800f50 <fd2num>
  801ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae6:	89 04 24             	mov    %eax,(%esp)
  801ae9:	e8 62 f4 ff ff       	call   800f50 <fd2num>
  801aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
  801af9:	eb 38                	jmp    801b33 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801afb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b06:	e8 75 f2 ff ff       	call   800d80 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b19:	e8 62 f2 ff ff       	call   800d80 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2c:	e8 4f f2 ff ff       	call   800d80 <sys_page_unmap>
  801b31:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801b33:	83 c4 30             	add    $0x30,%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5e                   	pop    %esi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 99 f4 ff ff       	call   800feb <fd_lookup>
  801b52:	89 c2                	mov    %eax,%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	78 15                	js     801b6d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	89 04 24             	mov    %eax,(%esp)
  801b5e:	e8 fd f3 ff ff       	call   800f60 <fd2data>
	return _pipeisclosed(fd, p);
  801b63:	89 c2                	mov    %eax,%edx
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	e8 de fc ff ff       	call   80184b <_pipeisclosed>
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    
  801b6f:	90                   	nop

00801b70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b80:	c7 44 24 04 f8 25 80 	movl   $0x8025f8,0x4(%esp)
  801b87:	00 
  801b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8b:	89 04 24             	mov    %eax,(%esp)
  801b8e:	e8 98 ec ff ff       	call   80082b <strcpy>
	return 0;
}
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	57                   	push   %edi
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801baa:	74 4a                	je     801bf6 <devcons_write+0x5c>
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bbc:	8b 75 10             	mov    0x10(%ebp),%esi
  801bbf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801bc1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801bc4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801bc9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801bcc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801bd0:	03 45 0c             	add    0xc(%ebp),%eax
  801bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd7:	89 3c 24             	mov    %edi,(%esp)
  801bda:	e8 47 ee ff ff       	call   800a26 <memmove>
		sys_cputs(buf, m);
  801bdf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801be3:	89 3c 24             	mov    %edi,(%esp)
  801be6:	e8 21 f0 ff ff       	call   800c0c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801beb:	01 f3                	add    %esi,%ebx
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801bf2:	72 c8                	jb     801bbc <devcons_write+0x22>
  801bf4:	eb 05                	jmp    801bfb <devcons_write+0x61>
  801bf6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801c13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c17:	75 07                	jne    801c20 <devcons_read+0x18>
  801c19:	eb 28                	jmp    801c43 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801c1b:	e8 9a f0 ff ff       	call   800cba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c20:	e8 05 f0 ff ff       	call   800c2a <sys_cgetc>
  801c25:	85 c0                	test   %eax,%eax
  801c27:	74 f2                	je     801c1b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 16                	js     801c43 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801c2d:	83 f8 04             	cmp    $0x4,%eax
  801c30:	74 0c                	je     801c3e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	88 02                	mov    %al,(%edx)
	return 1;
  801c37:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3c:	eb 05                	jmp    801c43 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c58:	00 
  801c59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	e8 a8 ef ff ff       	call   800c0c <sys_cputs>
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <getchar>:

int
getchar(void)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c73:	00 
  801c74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c82:	e8 0f f6 ff ff       	call   801296 <read>
	if (r < 0)
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 0f                	js     801c9a <getchar+0x34>
		return r;
	if (r < 1)
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	7e 06                	jle    801c95 <getchar+0x2f>
		return -E_EOF;
	return c;
  801c8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c93:	eb 05                	jmp    801c9a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	89 04 24             	mov    %eax,(%esp)
  801caf:	e8 37 f3 ff ff       	call   800feb <fd_lookup>
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 11                	js     801cc9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cc1:	39 10                	cmp    %edx,(%eax)
  801cc3:	0f 94 c0             	sete   %al
  801cc6:	0f b6 c0             	movzbl %al,%eax
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <opencons>:

int
opencons(void)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801cd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 9b f2 ff ff       	call   800f77 <fd_alloc>
		return r;
  801cdc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 40                	js     801d22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ce2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ce9:	00 
  801cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf8:	e8 dc ef ff ff       	call   800cd9 <sys_page_alloc>
		return r;
  801cfd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 1f                	js     801d22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d03:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d18:	89 04 24             	mov    %eax,(%esp)
  801d1b:	e8 30 f2 ff ff       	call   800f50 <fd2num>
  801d20:	89 c2                	mov    %eax,%edx
}
  801d22:	89 d0                	mov    %edx,%eax
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	56                   	push   %esi
  801d2a:	53                   	push   %ebx
  801d2b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801d2e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d31:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d37:	e8 5f ef ff ff       	call   800c9b <sys_getenvid>
  801d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d43:	8b 55 08             	mov    0x8(%ebp),%edx
  801d46:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d4a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d52:	c7 04 24 04 26 80 00 	movl   $0x802604,(%esp)
  801d59:	e8 74 e4 ff ff       	call   8001d2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	89 04 24             	mov    %eax,(%esp)
  801d68:	e8 04 e4 ff ff       	call   800171 <vcprintf>
	cprintf("\n");
  801d6d:	c7 04 24 f1 25 80 00 	movl   $0x8025f1,(%esp)
  801d74:	e8 59 e4 ff ff       	call   8001d2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d79:	cc                   	int3   
  801d7a:	eb fd                	jmp    801d79 <_panic+0x53>

00801d7c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	83 ec 10             	sub    $0x10,%esp
  801d84:	8b 75 08             	mov    0x8(%ebp),%esi
  801d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d94:	0f 44 c2             	cmove  %edx,%eax
  801d97:	89 04 24             	mov    %eax,(%esp)
  801d9a:	e8 50 f1 ff ff       	call   800eef <sys_ipc_recv>
	if (err_code < 0) {
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	79 16                	jns    801db9 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801da3:	85 f6                	test   %esi,%esi
  801da5:	74 06                	je     801dad <ipc_recv+0x31>
  801da7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801dad:	85 db                	test   %ebx,%ebx
  801daf:	74 2c                	je     801ddd <ipc_recv+0x61>
  801db1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801db7:	eb 24                	jmp    801ddd <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801db9:	85 f6                	test   %esi,%esi
  801dbb:	74 0a                	je     801dc7 <ipc_recv+0x4b>
  801dbd:	a1 04 40 80 00       	mov    0x804004,%eax
  801dc2:	8b 40 74             	mov    0x74(%eax),%eax
  801dc5:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801dc7:	85 db                	test   %ebx,%ebx
  801dc9:	74 0a                	je     801dd5 <ipc_recv+0x59>
  801dcb:	a1 04 40 80 00       	mov    0x804004,%eax
  801dd0:	8b 40 78             	mov    0x78(%eax),%eax
  801dd3:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801dd5:	a1 04 40 80 00       	mov    0x804004,%eax
  801dda:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	57                   	push   %edi
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	83 ec 1c             	sub    $0x1c,%esp
  801ded:	8b 7d 08             	mov    0x8(%ebp),%edi
  801df0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801df6:	eb 25                	jmp    801e1d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801df8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dfb:	74 20                	je     801e1d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e01:	c7 44 24 08 28 26 80 	movl   $0x802628,0x8(%esp)
  801e08:	00 
  801e09:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e10:	00 
  801e11:	c7 04 24 34 26 80 00 	movl   $0x802634,(%esp)
  801e18:	e8 09 ff ff ff       	call   801d26 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e1d:	85 db                	test   %ebx,%ebx
  801e1f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e24:	0f 45 c3             	cmovne %ebx,%eax
  801e27:	8b 55 14             	mov    0x14(%ebp),%edx
  801e2a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e32:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e36:	89 3c 24             	mov    %edi,(%esp)
  801e39:	e8 8e f0 ff ff       	call   800ecc <sys_ipc_try_send>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	75 b6                	jne    801df8 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801e42:	83 c4 1c             	add    $0x1c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    

00801e4a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e50:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e55:	39 c8                	cmp    %ecx,%eax
  801e57:	74 17                	je     801e70 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e5e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e61:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e67:	8b 52 50             	mov    0x50(%edx),%edx
  801e6a:	39 ca                	cmp    %ecx,%edx
  801e6c:	75 14                	jne    801e82 <ipc_find_env+0x38>
  801e6e:	eb 05                	jmp    801e75 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e75:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e78:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e7d:	8b 40 40             	mov    0x40(%eax),%eax
  801e80:	eb 0e                	jmp    801e90 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e82:	83 c0 01             	add    $0x1,%eax
  801e85:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e8a:	75 d2                	jne    801e5e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e8c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e98:	89 d0                	mov    %edx,%eax
  801e9a:	c1 e8 16             	shr    $0x16,%eax
  801e9d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ea9:	f6 c1 01             	test   $0x1,%cl
  801eac:	74 1d                	je     801ecb <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801eae:	c1 ea 0c             	shr    $0xc,%edx
  801eb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801eb8:	f6 c2 01             	test   $0x1,%dl
  801ebb:	74 0e                	je     801ecb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ebd:	c1 ea 0c             	shr    $0xc,%edx
  801ec0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ec7:	ef 
  801ec8:	0f b7 c0             	movzwl %ax,%eax
}
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	66 90                	xchg   %ax,%ax
  801ecf:	90                   	nop

00801ed0 <__udivdi3>:
  801ed0:	55                   	push   %ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801eda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801ede:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801ee2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801eec:	89 ea                	mov    %ebp,%edx
  801eee:	89 0c 24             	mov    %ecx,(%esp)
  801ef1:	75 2d                	jne    801f20 <__udivdi3+0x50>
  801ef3:	39 e9                	cmp    %ebp,%ecx
  801ef5:	77 61                	ja     801f58 <__udivdi3+0x88>
  801ef7:	85 c9                	test   %ecx,%ecx
  801ef9:	89 ce                	mov    %ecx,%esi
  801efb:	75 0b                	jne    801f08 <__udivdi3+0x38>
  801efd:	b8 01 00 00 00       	mov    $0x1,%eax
  801f02:	31 d2                	xor    %edx,%edx
  801f04:	f7 f1                	div    %ecx
  801f06:	89 c6                	mov    %eax,%esi
  801f08:	31 d2                	xor    %edx,%edx
  801f0a:	89 e8                	mov    %ebp,%eax
  801f0c:	f7 f6                	div    %esi
  801f0e:	89 c5                	mov    %eax,%ebp
  801f10:	89 f8                	mov    %edi,%eax
  801f12:	f7 f6                	div    %esi
  801f14:	89 ea                	mov    %ebp,%edx
  801f16:	83 c4 0c             	add    $0xc,%esp
  801f19:	5e                   	pop    %esi
  801f1a:	5f                   	pop    %edi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    
  801f1d:	8d 76 00             	lea    0x0(%esi),%esi
  801f20:	39 e8                	cmp    %ebp,%eax
  801f22:	77 24                	ja     801f48 <__udivdi3+0x78>
  801f24:	0f bd e8             	bsr    %eax,%ebp
  801f27:	83 f5 1f             	xor    $0x1f,%ebp
  801f2a:	75 3c                	jne    801f68 <__udivdi3+0x98>
  801f2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f30:	39 34 24             	cmp    %esi,(%esp)
  801f33:	0f 86 9f 00 00 00    	jbe    801fd8 <__udivdi3+0x108>
  801f39:	39 d0                	cmp    %edx,%eax
  801f3b:	0f 82 97 00 00 00    	jb     801fd8 <__udivdi3+0x108>
  801f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f48:	31 d2                	xor    %edx,%edx
  801f4a:	31 c0                	xor    %eax,%eax
  801f4c:	83 c4 0c             	add    $0xc,%esp
  801f4f:	5e                   	pop    %esi
  801f50:	5f                   	pop    %edi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    
  801f53:	90                   	nop
  801f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f58:	89 f8                	mov    %edi,%eax
  801f5a:	f7 f1                	div    %ecx
  801f5c:	31 d2                	xor    %edx,%edx
  801f5e:	83 c4 0c             	add    $0xc,%esp
  801f61:	5e                   	pop    %esi
  801f62:	5f                   	pop    %edi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    
  801f65:	8d 76 00             	lea    0x0(%esi),%esi
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	8b 3c 24             	mov    (%esp),%edi
  801f6d:	d3 e0                	shl    %cl,%eax
  801f6f:	89 c6                	mov    %eax,%esi
  801f71:	b8 20 00 00 00       	mov    $0x20,%eax
  801f76:	29 e8                	sub    %ebp,%eax
  801f78:	89 c1                	mov    %eax,%ecx
  801f7a:	d3 ef                	shr    %cl,%edi
  801f7c:	89 e9                	mov    %ebp,%ecx
  801f7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f82:	8b 3c 24             	mov    (%esp),%edi
  801f85:	09 74 24 08          	or     %esi,0x8(%esp)
  801f89:	89 d6                	mov    %edx,%esi
  801f8b:	d3 e7                	shl    %cl,%edi
  801f8d:	89 c1                	mov    %eax,%ecx
  801f8f:	89 3c 24             	mov    %edi,(%esp)
  801f92:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f96:	d3 ee                	shr    %cl,%esi
  801f98:	89 e9                	mov    %ebp,%ecx
  801f9a:	d3 e2                	shl    %cl,%edx
  801f9c:	89 c1                	mov    %eax,%ecx
  801f9e:	d3 ef                	shr    %cl,%edi
  801fa0:	09 d7                	or     %edx,%edi
  801fa2:	89 f2                	mov    %esi,%edx
  801fa4:	89 f8                	mov    %edi,%eax
  801fa6:	f7 74 24 08          	divl   0x8(%esp)
  801faa:	89 d6                	mov    %edx,%esi
  801fac:	89 c7                	mov    %eax,%edi
  801fae:	f7 24 24             	mull   (%esp)
  801fb1:	39 d6                	cmp    %edx,%esi
  801fb3:	89 14 24             	mov    %edx,(%esp)
  801fb6:	72 30                	jb     801fe8 <__udivdi3+0x118>
  801fb8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fbc:	89 e9                	mov    %ebp,%ecx
  801fbe:	d3 e2                	shl    %cl,%edx
  801fc0:	39 c2                	cmp    %eax,%edx
  801fc2:	73 05                	jae    801fc9 <__udivdi3+0xf9>
  801fc4:	3b 34 24             	cmp    (%esp),%esi
  801fc7:	74 1f                	je     801fe8 <__udivdi3+0x118>
  801fc9:	89 f8                	mov    %edi,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	e9 7a ff ff ff       	jmp    801f4c <__udivdi3+0x7c>
  801fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fd8:	31 d2                	xor    %edx,%edx
  801fda:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdf:	e9 68 ff ff ff       	jmp    801f4c <__udivdi3+0x7c>
  801fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fe8:	8d 47 ff             	lea    -0x1(%edi),%eax
  801feb:	31 d2                	xor    %edx,%edx
  801fed:	83 c4 0c             	add    $0xc,%esp
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	66 90                	xchg   %ax,%ax
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	66 90                	xchg   %ax,%ax
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <__umoddi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	83 ec 14             	sub    $0x14,%esp
  802006:	8b 44 24 28          	mov    0x28(%esp),%eax
  80200a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80200e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802012:	89 c7                	mov    %eax,%edi
  802014:	89 44 24 04          	mov    %eax,0x4(%esp)
  802018:	8b 44 24 30          	mov    0x30(%esp),%eax
  80201c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802020:	89 34 24             	mov    %esi,(%esp)
  802023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802027:	85 c0                	test   %eax,%eax
  802029:	89 c2                	mov    %eax,%edx
  80202b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80202f:	75 17                	jne    802048 <__umoddi3+0x48>
  802031:	39 fe                	cmp    %edi,%esi
  802033:	76 4b                	jbe    802080 <__umoddi3+0x80>
  802035:	89 c8                	mov    %ecx,%eax
  802037:	89 fa                	mov    %edi,%edx
  802039:	f7 f6                	div    %esi
  80203b:	89 d0                	mov    %edx,%eax
  80203d:	31 d2                	xor    %edx,%edx
  80203f:	83 c4 14             	add    $0x14,%esp
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    
  802046:	66 90                	xchg   %ax,%ax
  802048:	39 f8                	cmp    %edi,%eax
  80204a:	77 54                	ja     8020a0 <__umoddi3+0xa0>
  80204c:	0f bd e8             	bsr    %eax,%ebp
  80204f:	83 f5 1f             	xor    $0x1f,%ebp
  802052:	75 5c                	jne    8020b0 <__umoddi3+0xb0>
  802054:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802058:	39 3c 24             	cmp    %edi,(%esp)
  80205b:	0f 87 e7 00 00 00    	ja     802148 <__umoddi3+0x148>
  802061:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802065:	29 f1                	sub    %esi,%ecx
  802067:	19 c7                	sbb    %eax,%edi
  802069:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80206d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802071:	8b 44 24 08          	mov    0x8(%esp),%eax
  802075:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802079:	83 c4 14             	add    $0x14,%esp
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    
  802080:	85 f6                	test   %esi,%esi
  802082:	89 f5                	mov    %esi,%ebp
  802084:	75 0b                	jne    802091 <__umoddi3+0x91>
  802086:	b8 01 00 00 00       	mov    $0x1,%eax
  80208b:	31 d2                	xor    %edx,%edx
  80208d:	f7 f6                	div    %esi
  80208f:	89 c5                	mov    %eax,%ebp
  802091:	8b 44 24 04          	mov    0x4(%esp),%eax
  802095:	31 d2                	xor    %edx,%edx
  802097:	f7 f5                	div    %ebp
  802099:	89 c8                	mov    %ecx,%eax
  80209b:	f7 f5                	div    %ebp
  80209d:	eb 9c                	jmp    80203b <__umoddi3+0x3b>
  80209f:	90                   	nop
  8020a0:	89 c8                	mov    %ecx,%eax
  8020a2:	89 fa                	mov    %edi,%edx
  8020a4:	83 c4 14             	add    $0x14,%esp
  8020a7:	5e                   	pop    %esi
  8020a8:	5f                   	pop    %edi
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    
  8020ab:	90                   	nop
  8020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020b0:	8b 04 24             	mov    (%esp),%eax
  8020b3:	be 20 00 00 00       	mov    $0x20,%esi
  8020b8:	89 e9                	mov    %ebp,%ecx
  8020ba:	29 ee                	sub    %ebp,%esi
  8020bc:	d3 e2                	shl    %cl,%edx
  8020be:	89 f1                	mov    %esi,%ecx
  8020c0:	d3 e8                	shr    %cl,%eax
  8020c2:	89 e9                	mov    %ebp,%ecx
  8020c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c8:	8b 04 24             	mov    (%esp),%eax
  8020cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8020cf:	89 fa                	mov    %edi,%edx
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 f1                	mov    %esi,%ecx
  8020d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8020dd:	d3 ea                	shr    %cl,%edx
  8020df:	89 e9                	mov    %ebp,%ecx
  8020e1:	d3 e7                	shl    %cl,%edi
  8020e3:	89 f1                	mov    %esi,%ecx
  8020e5:	d3 e8                	shr    %cl,%eax
  8020e7:	89 e9                	mov    %ebp,%ecx
  8020e9:	09 f8                	or     %edi,%eax
  8020eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8020ef:	f7 74 24 04          	divl   0x4(%esp)
  8020f3:	d3 e7                	shl    %cl,%edi
  8020f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020f9:	89 d7                	mov    %edx,%edi
  8020fb:	f7 64 24 08          	mull   0x8(%esp)
  8020ff:	39 d7                	cmp    %edx,%edi
  802101:	89 c1                	mov    %eax,%ecx
  802103:	89 14 24             	mov    %edx,(%esp)
  802106:	72 2c                	jb     802134 <__umoddi3+0x134>
  802108:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80210c:	72 22                	jb     802130 <__umoddi3+0x130>
  80210e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802112:	29 c8                	sub    %ecx,%eax
  802114:	19 d7                	sbb    %edx,%edi
  802116:	89 e9                	mov    %ebp,%ecx
  802118:	89 fa                	mov    %edi,%edx
  80211a:	d3 e8                	shr    %cl,%eax
  80211c:	89 f1                	mov    %esi,%ecx
  80211e:	d3 e2                	shl    %cl,%edx
  802120:	89 e9                	mov    %ebp,%ecx
  802122:	d3 ef                	shr    %cl,%edi
  802124:	09 d0                	or     %edx,%eax
  802126:	89 fa                	mov    %edi,%edx
  802128:	83 c4 14             	add    $0x14,%esp
  80212b:	5e                   	pop    %esi
  80212c:	5f                   	pop    %edi
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    
  80212f:	90                   	nop
  802130:	39 d7                	cmp    %edx,%edi
  802132:	75 da                	jne    80210e <__umoddi3+0x10e>
  802134:	8b 14 24             	mov    (%esp),%edx
  802137:	89 c1                	mov    %eax,%ecx
  802139:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80213d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802141:	eb cb                	jmp    80210e <__umoddi3+0x10e>
  802143:	90                   	nop
  802144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802148:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80214c:	0f 82 0f ff ff ff    	jb     802061 <__umoddi3+0x61>
  802152:	e9 1a ff ff ff       	jmp    802071 <__umoddi3+0x71>
