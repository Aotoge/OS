
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 62 00 00 00       	call   800093 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	89 44 24 04          	mov    %eax,0x4(%esp)
  800045:	c7 04 24 40 27 80 00 	movl   $0x802740,(%esp)
  80004c:	e8 cc 01 00 00       	call   80021d <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 5e 27 80 	movl   $0x80275e,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 5e 27 80 00 	movl   $0x80275e,(%esp)
  800068:	e8 e5 1c 00 00       	call   801d52 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 64 27 80 	movl   $0x802764,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  80008c:	e8 93 00 00 00       	call   800124 <_panic>
}
  800091:	c9                   	leave  
  800092:	c3                   	ret    

00800093 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 10             	sub    $0x10,%esp
  80009b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000a1:	e8 45 0c 00 00       	call   800ceb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000a6:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000ac:	39 c2                	cmp    %eax,%edx
  8000ae:	74 17                	je     8000c7 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000b0:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000b5:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000b8:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000be:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000c1:	39 c1                	cmp    %eax,%ecx
  8000c3:	75 18                	jne    8000dd <libmain+0x4a>
  8000c5:	eb 05                	jmp    8000cc <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000c7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000cc:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000cf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000d5:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000db:	eb 0b                	jmp    8000e8 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000dd:	83 c2 01             	add    $0x1,%edx
  8000e0:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000e6:	75 cd                	jne    8000b5 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e8:	85 db                	test   %ebx,%ebx
  8000ea:	7e 07                	jle    8000f3 <libmain+0x60>
		binaryname = argv[0];
  8000ec:	8b 06                	mov    (%esi),%eax
  8000ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f7:	89 1c 24             	mov    %ebx,(%esp)
  8000fa:	e8 34 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ff:	e8 07 00 00 00       	call   80010b <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800111:	e8 a0 10 00 00       	call   8011b6 <close_all>
	sys_env_destroy(0);
  800116:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011d:	e8 77 0b 00 00       	call   800c99 <sys_env_destroy>
}
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
  800129:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80012c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800135:	e8 b1 0b 00 00       	call   800ceb <sys_getenvid>
  80013a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80013d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800141:	8b 55 08             	mov    0x8(%ebp),%edx
  800144:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800148:	89 74 24 08          	mov    %esi,0x8(%esp)
  80014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800150:	c7 04 24 98 27 80 00 	movl   $0x802798,(%esp)
  800157:	e8 c1 00 00 00       	call   80021d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800160:	8b 45 10             	mov    0x10(%ebp),%eax
  800163:	89 04 24             	mov    %eax,(%esp)
  800166:	e8 51 00 00 00       	call   8001bc <vcprintf>
	cprintf("\n");
  80016b:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  800172:	e8 a6 00 00 00       	call   80021d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800177:	cc                   	int3   
  800178:	eb fd                	jmp    800177 <_panic+0x53>

0080017a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	53                   	push   %ebx
  80017e:	83 ec 14             	sub    $0x14,%esp
  800181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800184:	8b 13                	mov    (%ebx),%edx
  800186:	8d 42 01             	lea    0x1(%edx),%eax
  800189:	89 03                	mov    %eax,(%ebx)
  80018b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800192:	3d ff 00 00 00       	cmp    $0xff,%eax
  800197:	75 19                	jne    8001b2 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800199:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001a0:	00 
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	89 04 24             	mov    %eax,(%esp)
  8001a7:	e8 b0 0a 00 00       	call   800c5c <sys_cputs>
		b->idx = 0;
  8001ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001b2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b6:	83 c4 14             	add    $0x14,%esp
  8001b9:	5b                   	pop    %ebx
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cc:	00 00 00 
	b.cnt = 0;
  8001cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f1:	c7 04 24 7a 01 80 00 	movl   $0x80017a,(%esp)
  8001f8:	e8 b7 01 00 00       	call   8003b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020d:	89 04 24             	mov    %eax,(%esp)
  800210:	e8 47 0a 00 00       	call   800c5c <sys_cputs>

	return b.cnt;
}
  800215:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800223:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022a:	8b 45 08             	mov    0x8(%ebp),%eax
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 87 ff ff ff       	call   8001bc <vcprintf>
	va_end(ap);

	return cnt;
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    
  800237:	66 90                	xchg   %ax,%ax
  800239:	66 90                	xchg   %ax,%ax
  80023b:	66 90                	xchg   %ax,%ax
  80023d:	66 90                	xchg   %ax,%ax
  80023f:	90                   	nop

00800240 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 3c             	sub    $0x3c,%esp
  800249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80024c:	89 d7                	mov    %edx,%edi
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800254:	8b 75 0c             	mov    0xc(%ebp),%esi
  800257:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80025a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800262:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800265:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800268:	39 f1                	cmp    %esi,%ecx
  80026a:	72 14                	jb     800280 <printnum+0x40>
  80026c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80026f:	76 0f                	jbe    800280 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800271:	8b 45 14             	mov    0x14(%ebp),%eax
  800274:	8d 70 ff             	lea    -0x1(%eax),%esi
  800277:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80027a:	85 f6                	test   %esi,%esi
  80027c:	7f 60                	jg     8002de <printnum+0x9e>
  80027e:	eb 72                	jmp    8002f2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800280:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800283:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800287:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80028a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80028d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800291:	89 44 24 08          	mov    %eax,0x8(%esp)
  800295:	8b 44 24 08          	mov    0x8(%esp),%eax
  800299:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80029d:	89 c3                	mov    %eax,%ebx
  80029f:	89 d6                	mov    %edx,%esi
  8002a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b2:	89 04 24             	mov    %eax,(%esp)
  8002b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bc:	e8 ef 21 00 00       	call   8024b0 <__udivdi3>
  8002c1:	89 d9                	mov    %ebx,%ecx
  8002c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002c7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002cb:	89 04 24             	mov    %eax,(%esp)
  8002ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002d2:	89 fa                	mov    %edi,%edx
  8002d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d7:	e8 64 ff ff ff       	call   800240 <printnum>
  8002dc:	eb 14                	jmp    8002f2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ea:	83 ee 01             	sub    $0x1,%esi
  8002ed:	75 ef                	jne    8002de <printnum+0x9e>
  8002ef:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800300:	89 44 24 08          	mov    %eax,0x8(%esp)
  800304:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800311:	89 44 24 04          	mov    %eax,0x4(%esp)
  800315:	e8 c6 22 00 00       	call   8025e0 <__umoddi3>
  80031a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031e:	0f be 80 bb 27 80 00 	movsbl 0x8027bb(%eax),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80032b:	ff d0                	call   *%eax
}
  80032d:	83 c4 3c             	add    $0x3c,%esp
  800330:	5b                   	pop    %ebx
  800331:	5e                   	pop    %esi
  800332:	5f                   	pop    %edi
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    

00800335 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800338:	83 fa 01             	cmp    $0x1,%edx
  80033b:	7e 0e                	jle    80034b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80033d:	8b 10                	mov    (%eax),%edx
  80033f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800342:	89 08                	mov    %ecx,(%eax)
  800344:	8b 02                	mov    (%edx),%eax
  800346:	8b 52 04             	mov    0x4(%edx),%edx
  800349:	eb 22                	jmp    80036d <getuint+0x38>
	else if (lflag)
  80034b:	85 d2                	test   %edx,%edx
  80034d:	74 10                	je     80035f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80034f:	8b 10                	mov    (%eax),%edx
  800351:	8d 4a 04             	lea    0x4(%edx),%ecx
  800354:	89 08                	mov    %ecx,(%eax)
  800356:	8b 02                	mov    (%edx),%eax
  800358:	ba 00 00 00 00       	mov    $0x0,%edx
  80035d:	eb 0e                	jmp    80036d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8d 4a 04             	lea    0x4(%edx),%ecx
  800364:	89 08                	mov    %ecx,(%eax)
  800366:	8b 02                	mov    (%edx),%eax
  800368:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800375:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	3b 50 04             	cmp    0x4(%eax),%edx
  80037e:	73 0a                	jae    80038a <sprintputch+0x1b>
		*b->buf++ = ch;
  800380:	8d 4a 01             	lea    0x1(%edx),%ecx
  800383:	89 08                	mov    %ecx,(%eax)
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	88 02                	mov    %al,(%edx)
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800392:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800395:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800399:	8b 45 10             	mov    0x10(%ebp),%eax
  80039c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	89 04 24             	mov    %eax,(%esp)
  8003ad:	e8 02 00 00 00       	call   8003b4 <vprintfmt>
	va_end(ap);
}
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c3:	eb 18                	jmp    8003dd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	0f 84 c3 03 00 00    	je     800790 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8003cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d7:	89 f3                	mov    %esi,%ebx
  8003d9:	eb 02                	jmp    8003dd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003db:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003dd:	8d 73 01             	lea    0x1(%ebx),%esi
  8003e0:	0f b6 03             	movzbl (%ebx),%eax
  8003e3:	83 f8 25             	cmp    $0x25,%eax
  8003e6:	75 dd                	jne    8003c5 <vprintfmt+0x11>
  8003e8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003f3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800401:	ba 00 00 00 00       	mov    $0x0,%edx
  800406:	eb 1d                	jmp    800425 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800408:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80040a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80040e:	eb 15                	jmp    800425 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800410:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800412:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800416:	eb 0d                	jmp    800425 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8d 5e 01             	lea    0x1(%esi),%ebx
  800428:	0f b6 06             	movzbl (%esi),%eax
  80042b:	0f b6 c8             	movzbl %al,%ecx
  80042e:	83 e8 23             	sub    $0x23,%eax
  800431:	3c 55                	cmp    $0x55,%al
  800433:	0f 87 2f 03 00 00    	ja     800768 <vprintfmt+0x3b4>
  800439:	0f b6 c0             	movzbl %al,%eax
  80043c:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800443:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800446:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800449:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80044d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800450:	83 f9 09             	cmp    $0x9,%ecx
  800453:	77 50                	ja     8004a5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800455:	89 de                	mov    %ebx,%esi
  800457:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80045a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80045d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800460:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800464:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800467:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80046a:	83 fb 09             	cmp    $0x9,%ebx
  80046d:	76 eb                	jbe    80045a <vprintfmt+0xa6>
  80046f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800472:	eb 33                	jmp    8004a7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 48 04             	lea    0x4(%eax),%ecx
  80047a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800482:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800484:	eb 21                	jmp    8004a7 <vprintfmt+0xf3>
  800486:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800489:	85 c9                	test   %ecx,%ecx
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	0f 49 c1             	cmovns %ecx,%eax
  800493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
  800498:	eb 8b                	jmp    800425 <vprintfmt+0x71>
  80049a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80049c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004a3:	eb 80                	jmp    800425 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ab:	0f 89 74 ff ff ff    	jns    800425 <vprintfmt+0x71>
  8004b1:	e9 62 ff ff ff       	jmp    800418 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004bb:	e9 65 ff ff ff       	jmp    800425 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8d 50 04             	lea    0x4(%eax),%edx
  8004c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 04 24             	mov    %eax,(%esp)
  8004d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d5:	e9 03 ff ff ff       	jmp    8003dd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	99                   	cltd   
  8004e6:	31 d0                	xor    %edx,%eax
  8004e8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ea:	83 f8 0f             	cmp    $0xf,%eax
  8004ed:	7f 0b                	jg     8004fa <vprintfmt+0x146>
  8004ef:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  8004f6:	85 d2                	test   %edx,%edx
  8004f8:	75 20                	jne    80051a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004fe:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  800505:	00 
  800506:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 77 fe ff ff       	call   80038c <printfmt>
  800515:	e9 c3 fe ff ff       	jmp    8003dd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80051a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051e:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800525:	00 
  800526:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 04 24             	mov    %eax,(%esp)
  800530:	e8 57 fe ff ff       	call   80038c <printfmt>
  800535:	e9 a3 fe ff ff       	jmp    8003dd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 50 04             	lea    0x4(%eax),%edx
  800546:	89 55 14             	mov    %edx,0x14(%ebp)
  800549:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80054b:	85 c0                	test   %eax,%eax
  80054d:	ba cc 27 80 00       	mov    $0x8027cc,%edx
  800552:	0f 45 d0             	cmovne %eax,%edx
  800555:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800558:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80055c:	74 04                	je     800562 <vprintfmt+0x1ae>
  80055e:	85 f6                	test   %esi,%esi
  800560:	7f 19                	jg     80057b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800562:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800565:	8d 70 01             	lea    0x1(%eax),%esi
  800568:	0f b6 10             	movzbl (%eax),%edx
  80056b:	0f be c2             	movsbl %dl,%eax
  80056e:	85 c0                	test   %eax,%eax
  800570:	0f 85 95 00 00 00    	jne    80060b <vprintfmt+0x257>
  800576:	e9 85 00 00 00       	jmp    800600 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80057f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800582:	89 04 24             	mov    %eax,(%esp)
  800585:	e8 b8 02 00 00       	call   800842 <strnlen>
  80058a:	29 c6                	sub    %eax,%esi
  80058c:	89 f0                	mov    %esi,%eax
  80058e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800591:	85 f6                	test   %esi,%esi
  800593:	7e cd                	jle    800562 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800595:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800599:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80059c:	89 c3                	mov    %eax,%ebx
  80059e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a2:	89 34 24             	mov    %esi,(%esp)
  8005a5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	83 eb 01             	sub    $0x1,%ebx
  8005ab:	75 f1                	jne    80059e <vprintfmt+0x1ea>
  8005ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005b3:	eb ad                	jmp    800562 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b9:	74 1e                	je     8005d9 <vprintfmt+0x225>
  8005bb:	0f be d2             	movsbl %dl,%edx
  8005be:	83 ea 20             	sub    $0x20,%edx
  8005c1:	83 fa 5e             	cmp    $0x5e,%edx
  8005c4:	76 13                	jbe    8005d9 <vprintfmt+0x225>
					putch('?', putdat);
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005d4:	ff 55 08             	call   *0x8(%ebp)
  8005d7:	eb 0d                	jmp    8005e6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005e0:	89 04 24             	mov    %eax,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e6:	83 ef 01             	sub    $0x1,%edi
  8005e9:	83 c6 01             	add    $0x1,%esi
  8005ec:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005f0:	0f be c2             	movsbl %dl,%eax
  8005f3:	85 c0                	test   %eax,%eax
  8005f5:	75 20                	jne    800617 <vprintfmt+0x263>
  8005f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	7f 25                	jg     80062b <vprintfmt+0x277>
  800606:	e9 d2 fd ff ff       	jmp    8003dd <vprintfmt+0x29>
  80060b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800611:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800614:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800617:	85 db                	test   %ebx,%ebx
  800619:	78 9a                	js     8005b5 <vprintfmt+0x201>
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	79 95                	jns    8005b5 <vprintfmt+0x201>
  800620:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800623:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800626:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800629:	eb d5                	jmp    800600 <vprintfmt+0x24c>
  80062b:	8b 75 08             	mov    0x8(%ebp),%esi
  80062e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800631:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800634:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800638:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80063f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800641:	83 eb 01             	sub    $0x1,%ebx
  800644:	75 ee                	jne    800634 <vprintfmt+0x280>
  800646:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800649:	e9 8f fd ff ff       	jmp    8003dd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80064e:	83 fa 01             	cmp    $0x1,%edx
  800651:	7e 16                	jle    800669 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 50 08             	lea    0x8(%eax),%edx
  800659:	89 55 14             	mov    %edx,0x14(%ebp)
  80065c:	8b 50 04             	mov    0x4(%eax),%edx
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	eb 32                	jmp    80069b <vprintfmt+0x2e7>
	else if (lflag)
  800669:	85 d2                	test   %edx,%edx
  80066b:	74 18                	je     800685 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 50 04             	lea    0x4(%eax),%edx
  800673:	89 55 14             	mov    %edx,0x14(%ebp)
  800676:	8b 30                	mov    (%eax),%esi
  800678:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80067b:	89 f0                	mov    %esi,%eax
  80067d:	c1 f8 1f             	sar    $0x1f,%eax
  800680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800683:	eb 16                	jmp    80069b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	89 55 14             	mov    %edx,0x14(%ebp)
  80068e:	8b 30                	mov    (%eax),%esi
  800690:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800693:	89 f0                	mov    %esi,%eax
  800695:	c1 f8 1f             	sar    $0x1f,%eax
  800698:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80069e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006aa:	0f 89 80 00 00 00    	jns    800730 <vprintfmt+0x37c>
				putch('-', putdat);
  8006b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006bb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006c4:	f7 d8                	neg    %eax
  8006c6:	83 d2 00             	adc    $0x0,%edx
  8006c9:	f7 da                	neg    %edx
			}
			base = 10;
  8006cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006d0:	eb 5e                	jmp    800730 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d5:	e8 5b fc ff ff       	call   800335 <getuint>
			base = 10;
  8006da:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006df:	eb 4f                	jmp    800730 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e4:	e8 4c fc ff ff       	call   800335 <getuint>
			base = 8;
  8006e9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006ee:	eb 40                	jmp    800730 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006fb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800702:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800709:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 50 04             	lea    0x4(%eax),%edx
  800712:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80071c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800721:	eb 0d                	jmp    800730 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 0a fc ff ff       	call   800335 <getuint>
			base = 16;
  80072b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800730:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800734:	89 74 24 10          	mov    %esi,0x10(%esp)
  800738:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80073b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80073f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800743:	89 04 24             	mov    %eax,(%esp)
  800746:	89 54 24 04          	mov    %edx,0x4(%esp)
  80074a:	89 fa                	mov    %edi,%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	e8 ec fa ff ff       	call   800240 <printnum>
			break;
  800754:	e9 84 fc ff ff       	jmp    8003dd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800759:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075d:	89 0c 24             	mov    %ecx,(%esp)
  800760:	ff 55 08             	call   *0x8(%ebp)
			break;
  800763:	e9 75 fc ff ff       	jmp    8003dd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800768:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800773:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800776:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80077a:	0f 84 5b fc ff ff    	je     8003db <vprintfmt+0x27>
  800780:	89 f3                	mov    %esi,%ebx
  800782:	83 eb 01             	sub    $0x1,%ebx
  800785:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800789:	75 f7                	jne    800782 <vprintfmt+0x3ce>
  80078b:	e9 4d fc ff ff       	jmp    8003dd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800790:	83 c4 3c             	add    $0x3c,%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	74 30                	je     8007e9 <vsnprintf+0x51>
  8007b9:	85 d2                	test   %edx,%edx
  8007bb:	7e 2c                	jle    8007e9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d2:	c7 04 24 6f 03 80 00 	movl   $0x80036f,(%esp)
  8007d9:	e8 d6 fb ff ff       	call   8003b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e7:	eb 05                	jmp    8007ee <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	89 44 24 08          	mov    %eax,0x8(%esp)
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	89 04 24             	mov    %eax,(%esp)
  800811:	e8 82 ff ff ff       	call   800798 <vsnprintf>
	va_end(ap);

	return rc;
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    
  800818:	66 90                	xchg   %ax,%ax
  80081a:	66 90                	xchg   %ax,%ax
  80081c:	66 90                	xchg   %ax,%ax
  80081e:	66 90                	xchg   %ax,%ax

00800820 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800826:	80 3a 00             	cmpb   $0x0,(%edx)
  800829:	74 10                	je     80083b <strlen+0x1b>
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800830:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800837:	75 f7                	jne    800830 <strlen+0x10>
  800839:	eb 05                	jmp    800840 <strlen+0x20>
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	53                   	push   %ebx
  800846:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084c:	85 c9                	test   %ecx,%ecx
  80084e:	74 1c                	je     80086c <strnlen+0x2a>
  800850:	80 3b 00             	cmpb   $0x0,(%ebx)
  800853:	74 1e                	je     800873 <strnlen+0x31>
  800855:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80085a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	39 ca                	cmp    %ecx,%edx
  80085e:	74 18                	je     800878 <strnlen+0x36>
  800860:	83 c2 01             	add    $0x1,%edx
  800863:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800868:	75 f0                	jne    80085a <strnlen+0x18>
  80086a:	eb 0c                	jmp    800878 <strnlen+0x36>
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
  800871:	eb 05                	jmp    800878 <strnlen+0x36>
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800885:	89 c2                	mov    %eax,%edx
  800887:	83 c2 01             	add    $0x1,%edx
  80088a:	83 c1 01             	add    $0x1,%ecx
  80088d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800891:	88 5a ff             	mov    %bl,-0x1(%edx)
  800894:	84 db                	test   %bl,%bl
  800896:	75 ef                	jne    800887 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800898:	5b                   	pop    %ebx
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	53                   	push   %ebx
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a5:	89 1c 24             	mov    %ebx,(%esp)
  8008a8:	e8 73 ff ff ff       	call   800820 <strlen>
	strcpy(dst + len, src);
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	89 04 24             	mov    %eax,(%esp)
  8008b9:	e8 bd ff ff ff       	call   80087b <strcpy>
	return dst;
}
  8008be:	89 d8                	mov    %ebx,%eax
  8008c0:	83 c4 08             	add    $0x8,%esp
  8008c3:	5b                   	pop    %ebx
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
  8008cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d4:	85 db                	test   %ebx,%ebx
  8008d6:	74 17                	je     8008ef <strncpy+0x29>
  8008d8:	01 f3                	add    %esi,%ebx
  8008da:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008dc:	83 c1 01             	add    $0x1,%ecx
  8008df:	0f b6 02             	movzbl (%edx),%eax
  8008e2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008e8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008eb:	39 d9                	cmp    %ebx,%ecx
  8008ed:	75 ed                	jne    8008dc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	5b                   	pop    %ebx
  8008f2:	5e                   	pop    %esi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	57                   	push   %edi
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800901:	8b 75 10             	mov    0x10(%ebp),%esi
  800904:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800906:	85 f6                	test   %esi,%esi
  800908:	74 34                	je     80093e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80090a:	83 fe 01             	cmp    $0x1,%esi
  80090d:	74 26                	je     800935 <strlcpy+0x40>
  80090f:	0f b6 0b             	movzbl (%ebx),%ecx
  800912:	84 c9                	test   %cl,%cl
  800914:	74 23                	je     800939 <strlcpy+0x44>
  800916:	83 ee 02             	sub    $0x2,%esi
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80091e:	83 c0 01             	add    $0x1,%eax
  800921:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800924:	39 f2                	cmp    %esi,%edx
  800926:	74 13                	je     80093b <strlcpy+0x46>
  800928:	83 c2 01             	add    $0x1,%edx
  80092b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80092f:	84 c9                	test   %cl,%cl
  800931:	75 eb                	jne    80091e <strlcpy+0x29>
  800933:	eb 06                	jmp    80093b <strlcpy+0x46>
  800935:	89 f8                	mov    %edi,%eax
  800937:	eb 02                	jmp    80093b <strlcpy+0x46>
  800939:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80093b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80093e:	29 f8                	sub    %edi,%eax
}
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5f                   	pop    %edi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80094e:	0f b6 01             	movzbl (%ecx),%eax
  800951:	84 c0                	test   %al,%al
  800953:	74 15                	je     80096a <strcmp+0x25>
  800955:	3a 02                	cmp    (%edx),%al
  800957:	75 11                	jne    80096a <strcmp+0x25>
		p++, q++;
  800959:	83 c1 01             	add    $0x1,%ecx
  80095c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095f:	0f b6 01             	movzbl (%ecx),%eax
  800962:	84 c0                	test   %al,%al
  800964:	74 04                	je     80096a <strcmp+0x25>
  800966:	3a 02                	cmp    (%edx),%al
  800968:	74 ef                	je     800959 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096a:	0f b6 c0             	movzbl %al,%eax
  80096d:	0f b6 12             	movzbl (%edx),%edx
  800970:	29 d0                	sub    %edx,%eax
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	56                   	push   %esi
  800978:	53                   	push   %ebx
  800979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800982:	85 f6                	test   %esi,%esi
  800984:	74 29                	je     8009af <strncmp+0x3b>
  800986:	0f b6 03             	movzbl (%ebx),%eax
  800989:	84 c0                	test   %al,%al
  80098b:	74 30                	je     8009bd <strncmp+0x49>
  80098d:	3a 02                	cmp    (%edx),%al
  80098f:	75 2c                	jne    8009bd <strncmp+0x49>
  800991:	8d 43 01             	lea    0x1(%ebx),%eax
  800994:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800996:	89 c3                	mov    %eax,%ebx
  800998:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80099b:	39 f0                	cmp    %esi,%eax
  80099d:	74 17                	je     8009b6 <strncmp+0x42>
  80099f:	0f b6 08             	movzbl (%eax),%ecx
  8009a2:	84 c9                	test   %cl,%cl
  8009a4:	74 17                	je     8009bd <strncmp+0x49>
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	3a 0a                	cmp    (%edx),%cl
  8009ab:	74 e9                	je     800996 <strncmp+0x22>
  8009ad:	eb 0e                	jmp    8009bd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	eb 0f                	jmp    8009c5 <strncmp+0x51>
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	eb 08                	jmp    8009c5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bd:	0f b6 03             	movzbl (%ebx),%eax
  8009c0:	0f b6 12             	movzbl (%edx),%edx
  8009c3:	29 d0                	sub    %edx,%eax
}
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	53                   	push   %ebx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009d3:	0f b6 18             	movzbl (%eax),%ebx
  8009d6:	84 db                	test   %bl,%bl
  8009d8:	74 1d                	je     8009f7 <strchr+0x2e>
  8009da:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009dc:	38 d3                	cmp    %dl,%bl
  8009de:	75 06                	jne    8009e6 <strchr+0x1d>
  8009e0:	eb 1a                	jmp    8009fc <strchr+0x33>
  8009e2:	38 ca                	cmp    %cl,%dl
  8009e4:	74 16                	je     8009fc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	0f b6 10             	movzbl (%eax),%edx
  8009ec:	84 d2                	test   %dl,%dl
  8009ee:	75 f2                	jne    8009e2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f5:	eb 05                	jmp    8009fc <strchr+0x33>
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	53                   	push   %ebx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a09:	0f b6 18             	movzbl (%eax),%ebx
  800a0c:	84 db                	test   %bl,%bl
  800a0e:	74 16                	je     800a26 <strfind+0x27>
  800a10:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a12:	38 d3                	cmp    %dl,%bl
  800a14:	75 06                	jne    800a1c <strfind+0x1d>
  800a16:	eb 0e                	jmp    800a26 <strfind+0x27>
  800a18:	38 ca                	cmp    %cl,%dl
  800a1a:	74 0a                	je     800a26 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	0f b6 10             	movzbl (%eax),%edx
  800a22:	84 d2                	test   %dl,%dl
  800a24:	75 f2                	jne    800a18 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a26:	5b                   	pop    %ebx
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	57                   	push   %edi
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a35:	85 c9                	test   %ecx,%ecx
  800a37:	74 36                	je     800a6f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3f:	75 28                	jne    800a69 <memset+0x40>
  800a41:	f6 c1 03             	test   $0x3,%cl
  800a44:	75 23                	jne    800a69 <memset+0x40>
		c &= 0xFF;
  800a46:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4a:	89 d3                	mov    %edx,%ebx
  800a4c:	c1 e3 08             	shl    $0x8,%ebx
  800a4f:	89 d6                	mov    %edx,%esi
  800a51:	c1 e6 18             	shl    $0x18,%esi
  800a54:	89 d0                	mov    %edx,%eax
  800a56:	c1 e0 10             	shl    $0x10,%eax
  800a59:	09 f0                	or     %esi,%eax
  800a5b:	09 c2                	or     %eax,%edx
  800a5d:	89 d0                	mov    %edx,%eax
  800a5f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a61:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a64:	fc                   	cld    
  800a65:	f3 ab                	rep stos %eax,%es:(%edi)
  800a67:	eb 06                	jmp    800a6f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	fc                   	cld    
  800a6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6f:	89 f8                	mov    %edi,%eax
  800a71:	5b                   	pop    %ebx
  800a72:	5e                   	pop    %esi
  800a73:	5f                   	pop    %edi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a84:	39 c6                	cmp    %eax,%esi
  800a86:	73 35                	jae    800abd <memmove+0x47>
  800a88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8b:	39 d0                	cmp    %edx,%eax
  800a8d:	73 2e                	jae    800abd <memmove+0x47>
		s += n;
		d += n;
  800a8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a92:	89 d6                	mov    %edx,%esi
  800a94:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9c:	75 13                	jne    800ab1 <memmove+0x3b>
  800a9e:	f6 c1 03             	test   $0x3,%cl
  800aa1:	75 0e                	jne    800ab1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa3:	83 ef 04             	sub    $0x4,%edi
  800aa6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aac:	fd                   	std    
  800aad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aaf:	eb 09                	jmp    800aba <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ab1:	83 ef 01             	sub    $0x1,%edi
  800ab4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab7:	fd                   	std    
  800ab8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aba:	fc                   	cld    
  800abb:	eb 1d                	jmp    800ada <memmove+0x64>
  800abd:	89 f2                	mov    %esi,%edx
  800abf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac1:	f6 c2 03             	test   $0x3,%dl
  800ac4:	75 0f                	jne    800ad5 <memmove+0x5f>
  800ac6:	f6 c1 03             	test   $0x3,%cl
  800ac9:	75 0a                	jne    800ad5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800acb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	fc                   	cld    
  800ad1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad3:	eb 05                	jmp    800ada <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad5:	89 c7                	mov    %eax,%edi
  800ad7:	fc                   	cld    
  800ad8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	89 04 24             	mov    %eax,(%esp)
  800af8:	e8 79 ff ff ff       	call   800a76 <memmove>
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	57                   	push   %edi
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b08:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b11:	85 c0                	test   %eax,%eax
  800b13:	74 36                	je     800b4b <memcmp+0x4c>
		if (*s1 != *s2)
  800b15:	0f b6 03             	movzbl (%ebx),%eax
  800b18:	0f b6 0e             	movzbl (%esi),%ecx
  800b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b20:	38 c8                	cmp    %cl,%al
  800b22:	74 1c                	je     800b40 <memcmp+0x41>
  800b24:	eb 10                	jmp    800b36 <memcmp+0x37>
  800b26:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b2b:	83 c2 01             	add    $0x1,%edx
  800b2e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b32:	38 c8                	cmp    %cl,%al
  800b34:	74 0a                	je     800b40 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b36:	0f b6 c0             	movzbl %al,%eax
  800b39:	0f b6 c9             	movzbl %cl,%ecx
  800b3c:	29 c8                	sub    %ecx,%eax
  800b3e:	eb 10                	jmp    800b50 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b40:	39 fa                	cmp    %edi,%edx
  800b42:	75 e2                	jne    800b26 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	eb 05                	jmp    800b50 <memcmp+0x51>
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b5f:	89 c2                	mov    %eax,%edx
  800b61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b64:	39 d0                	cmp    %edx,%eax
  800b66:	73 13                	jae    800b7b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b68:	89 d9                	mov    %ebx,%ecx
  800b6a:	38 18                	cmp    %bl,(%eax)
  800b6c:	75 06                	jne    800b74 <memfind+0x1f>
  800b6e:	eb 0b                	jmp    800b7b <memfind+0x26>
  800b70:	38 08                	cmp    %cl,(%eax)
  800b72:	74 07                	je     800b7b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b74:	83 c0 01             	add    $0x1,%eax
  800b77:	39 d0                	cmp    %edx,%eax
  800b79:	75 f5                	jne    800b70 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	57                   	push   %edi
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8a:	0f b6 0a             	movzbl (%edx),%ecx
  800b8d:	80 f9 09             	cmp    $0x9,%cl
  800b90:	74 05                	je     800b97 <strtol+0x19>
  800b92:	80 f9 20             	cmp    $0x20,%cl
  800b95:	75 10                	jne    800ba7 <strtol+0x29>
		s++;
  800b97:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9a:	0f b6 0a             	movzbl (%edx),%ecx
  800b9d:	80 f9 09             	cmp    $0x9,%cl
  800ba0:	74 f5                	je     800b97 <strtol+0x19>
  800ba2:	80 f9 20             	cmp    $0x20,%cl
  800ba5:	74 f0                	je     800b97 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba7:	80 f9 2b             	cmp    $0x2b,%cl
  800baa:	75 0a                	jne    800bb6 <strtol+0x38>
		s++;
  800bac:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800baf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb4:	eb 11                	jmp    800bc7 <strtol+0x49>
  800bb6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bbb:	80 f9 2d             	cmp    $0x2d,%cl
  800bbe:	75 07                	jne    800bc7 <strtol+0x49>
		s++, neg = 1;
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bcc:	75 15                	jne    800be3 <strtol+0x65>
  800bce:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd1:	75 10                	jne    800be3 <strtol+0x65>
  800bd3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bd7:	75 0a                	jne    800be3 <strtol+0x65>
		s += 2, base = 16;
  800bd9:	83 c2 02             	add    $0x2,%edx
  800bdc:	b8 10 00 00 00       	mov    $0x10,%eax
  800be1:	eb 10                	jmp    800bf3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800be3:	85 c0                	test   %eax,%eax
  800be5:	75 0c                	jne    800bf3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bec:	75 05                	jne    800bf3 <strtol+0x75>
		s++, base = 8;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bfb:	0f b6 0a             	movzbl (%edx),%ecx
  800bfe:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c01:	89 f0                	mov    %esi,%eax
  800c03:	3c 09                	cmp    $0x9,%al
  800c05:	77 08                	ja     800c0f <strtol+0x91>
			dig = *s - '0';
  800c07:	0f be c9             	movsbl %cl,%ecx
  800c0a:	83 e9 30             	sub    $0x30,%ecx
  800c0d:	eb 20                	jmp    800c2f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c0f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c12:	89 f0                	mov    %esi,%eax
  800c14:	3c 19                	cmp    $0x19,%al
  800c16:	77 08                	ja     800c20 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c18:	0f be c9             	movsbl %cl,%ecx
  800c1b:	83 e9 57             	sub    $0x57,%ecx
  800c1e:	eb 0f                	jmp    800c2f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c20:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c23:	89 f0                	mov    %esi,%eax
  800c25:	3c 19                	cmp    $0x19,%al
  800c27:	77 16                	ja     800c3f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c29:	0f be c9             	movsbl %cl,%ecx
  800c2c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c2f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c32:	7d 0f                	jge    800c43 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c34:	83 c2 01             	add    $0x1,%edx
  800c37:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c3b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c3d:	eb bc                	jmp    800bfb <strtol+0x7d>
  800c3f:	89 d8                	mov    %ebx,%eax
  800c41:	eb 02                	jmp    800c45 <strtol+0xc7>
  800c43:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	74 05                	je     800c50 <strtol+0xd2>
		*endptr = (char *) s;
  800c4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c50:	f7 d8                	neg    %eax
  800c52:	85 ff                	test   %edi,%edi
  800c54:	0f 44 c3             	cmove  %ebx,%eax
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	89 c3                	mov    %eax,%ebx
  800c6f:	89 c7                	mov    %eax,%edi
  800c71:	89 c6                	mov    %eax,%esi
  800c73:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_cgetc>:

int
sys_cgetc(void)
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
  800c85:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	89 cb                	mov    %ecx,%ebx
  800cb1:	89 cf                	mov    %ecx,%edi
  800cb3:	89 ce                	mov    %ecx,%esi
  800cb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	7e 28                	jle    800ce3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cc6:	00 
  800cc7:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800cce:	00 
  800ccf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800cd6:	00 
  800cd7:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800cde:	e8 41 f4 ff ff       	call   800124 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce3:	83 c4 2c             	add    $0x2c,%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfb:	89 d1                	mov    %edx,%ecx
  800cfd:	89 d3                	mov    %edx,%ebx
  800cff:	89 d7                	mov    %edx,%edi
  800d01:	89 d6                	mov    %edx,%esi
  800d03:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <sys_yield>:

void
sys_yield(void)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
  800d15:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	89 d7                	mov    %edx,%edi
  800d20:	89 d6                	mov    %edx,%esi
  800d22:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d32:	be 00 00 00 00       	mov    $0x0,%esi
  800d37:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d45:	89 f7                	mov    %esi,%edi
  800d47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7e 28                	jle    800d75 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d51:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d58:	00 
  800d59:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800d70:	e8 af f3 ff ff       	call   800124 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d75:	83 c4 2c             	add    $0x2c,%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d86:	b8 05 00 00 00       	mov    $0x5,%eax
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d97:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7e 28                	jle    800dc8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dab:	00 
  800dac:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800dc3:	e8 5c f3 ff ff       	call   800124 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc8:	83 c4 2c             	add    $0x2c,%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	b8 06 00 00 00       	mov    $0x6,%eax
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 28                	jle    800e1b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dfe:	00 
  800dff:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800e16:	e8 09 f3 ff ff       	call   800124 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1b:	83 c4 2c             	add    $0x2c,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	b8 08 00 00 00       	mov    $0x8,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7e 28                	jle    800e6e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e51:	00 
  800e52:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800e69:	e8 b6 f2 ff ff       	call   800124 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6e:	83 c4 2c             	add    $0x2c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e84:	b8 09 00 00 00       	mov    $0x9,%eax
  800e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 df                	mov    %ebx,%edi
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7e 28                	jle    800ec1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e99:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ea4:	00 
  800ea5:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800eac:	00 
  800ead:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb4:	00 
  800eb5:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800ebc:	e8 63 f2 ff ff       	call   800124 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ec1:	83 c4 2c             	add    $0x2c,%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7e 28                	jle    800f14 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eec:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef7:	00 
  800ef8:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800eff:	00 
  800f00:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f07:	00 
  800f08:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800f0f:	e8 10 f2 ff ff       	call   800124 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f14:	83 c4 2c             	add    $0x2c,%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	be 00 00 00 00       	mov    $0x0,%esi
  800f27:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f38:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	89 cb                	mov    %ecx,%ebx
  800f57:	89 cf                	mov    %ecx,%edi
  800f59:	89 ce                	mov    %ecx,%esi
  800f5b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7e 28                	jle    800f89 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f61:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f65:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 08 bf 2a 80 	movl   $0x802abf,0x8(%esp)
  800f74:	00 
  800f75:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f7c:	00 
  800f7d:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800f84:	e8 9b f1 ff ff       	call   800124 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f89:	83 c4 2c             	add    $0x2c,%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
  800f91:	66 90                	xchg   %ax,%ax
  800f93:	66 90                	xchg   %ax,%ax
  800f95:	66 90                	xchg   %ax,%ax
  800f97:	66 90                	xchg   %ax,%ax
  800f99:	66 90                	xchg   %ax,%ax
  800f9b:	66 90                	xchg   %ax,%ax
  800f9d:	66 90                	xchg   %ax,%ax
  800f9f:	90                   	nop

00800fa0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fab:	c1 e8 0c             	shr    $0xc,%eax
}
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800fbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fca:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800fcf:	a8 01                	test   $0x1,%al
  800fd1:	74 34                	je     801007 <fd_alloc+0x40>
  800fd3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800fd8:	a8 01                	test   $0x1,%al
  800fda:	74 32                	je     80100e <fd_alloc+0x47>
  800fdc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800fe1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	c1 ea 16             	shr    $0x16,%edx
  800fe8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fef:	f6 c2 01             	test   $0x1,%dl
  800ff2:	74 1f                	je     801013 <fd_alloc+0x4c>
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	c1 ea 0c             	shr    $0xc,%edx
  800ff9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801000:	f6 c2 01             	test   $0x1,%dl
  801003:	75 1a                	jne    80101f <fd_alloc+0x58>
  801005:	eb 0c                	jmp    801013 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801007:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80100c:	eb 05                	jmp    801013 <fd_alloc+0x4c>
  80100e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 08                	mov    %ecx,(%eax)
			return 0;
  801018:	b8 00 00 00 00       	mov    $0x0,%eax
  80101d:	eb 1a                	jmp    801039 <fd_alloc+0x72>
  80101f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801024:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801029:	75 b6                	jne    800fe1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801034:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801041:	83 f8 1f             	cmp    $0x1f,%eax
  801044:	77 36                	ja     80107c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801046:	c1 e0 0c             	shl    $0xc,%eax
  801049:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104e:	89 c2                	mov    %eax,%edx
  801050:	c1 ea 16             	shr    $0x16,%edx
  801053:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105a:	f6 c2 01             	test   $0x1,%dl
  80105d:	74 24                	je     801083 <fd_lookup+0x48>
  80105f:	89 c2                	mov    %eax,%edx
  801061:	c1 ea 0c             	shr    $0xc,%edx
  801064:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106b:	f6 c2 01             	test   $0x1,%dl
  80106e:	74 1a                	je     80108a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801070:	8b 55 0c             	mov    0xc(%ebp),%edx
  801073:	89 02                	mov    %eax,(%edx)
	return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	eb 13                	jmp    80108f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801081:	eb 0c                	jmp    80108f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801083:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801088:	eb 05                	jmp    80108f <fd_lookup+0x54>
  80108a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	53                   	push   %ebx
  801095:	83 ec 14             	sub    $0x14,%esp
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80109e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8010a4:	75 1e                	jne    8010c4 <dev_lookup+0x33>
  8010a6:	eb 0e                	jmp    8010b6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010a8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8010ad:	eb 0c                	jmp    8010bb <dev_lookup+0x2a>
  8010af:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8010b4:	eb 05                	jmp    8010bb <dev_lookup+0x2a>
  8010b6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8010bb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c2:	eb 38                	jmp    8010fc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8010c4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8010ca:	74 dc                	je     8010a8 <dev_lookup+0x17>
  8010cc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8010d2:	74 db                	je     8010af <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010d4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010da:	8b 52 48             	mov    0x48(%edx),%edx
  8010dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010e5:	c7 04 24 ec 2a 80 00 	movl   $0x802aec,(%esp)
  8010ec:	e8 2c f1 ff ff       	call   80021d <cprintf>
	*dev = 0;
  8010f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010fc:	83 c4 14             	add    $0x14,%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
  801107:	83 ec 20             	sub    $0x20,%esp
  80110a:	8b 75 08             	mov    0x8(%ebp),%esi
  80110d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801113:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801117:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801120:	89 04 24             	mov    %eax,(%esp)
  801123:	e8 13 ff ff ff       	call   80103b <fd_lookup>
  801128:	85 c0                	test   %eax,%eax
  80112a:	78 05                	js     801131 <fd_close+0x2f>
	    || fd != fd2)
  80112c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80112f:	74 0c                	je     80113d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801131:	84 db                	test   %bl,%bl
  801133:	ba 00 00 00 00       	mov    $0x0,%edx
  801138:	0f 44 c2             	cmove  %edx,%eax
  80113b:	eb 3f                	jmp    80117c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80113d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801140:	89 44 24 04          	mov    %eax,0x4(%esp)
  801144:	8b 06                	mov    (%esi),%eax
  801146:	89 04 24             	mov    %eax,(%esp)
  801149:	e8 43 ff ff ff       	call   801091 <dev_lookup>
  80114e:	89 c3                	mov    %eax,%ebx
  801150:	85 c0                	test   %eax,%eax
  801152:	78 16                	js     80116a <fd_close+0x68>
		if (dev->dev_close)
  801154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801157:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80115f:	85 c0                	test   %eax,%eax
  801161:	74 07                	je     80116a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801163:	89 34 24             	mov    %esi,(%esp)
  801166:	ff d0                	call   *%eax
  801168:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80116a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80116e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801175:	e8 56 fc ff ff       	call   800dd0 <sys_page_unmap>
	return r;
  80117a:	89 d8                	mov    %ebx,%eax
}
  80117c:	83 c4 20             	add    $0x20,%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801189:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 04 24             	mov    %eax,(%esp)
  801196:	e8 a0 fe ff ff       	call   80103b <fd_lookup>
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	85 d2                	test   %edx,%edx
  80119f:	78 13                	js     8011b4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011a8:	00 
  8011a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ac:	89 04 24             	mov    %eax,(%esp)
  8011af:	e8 4e ff ff ff       	call   801102 <fd_close>
}
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <close_all>:

void
close_all(void)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	53                   	push   %ebx
  8011ba:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011c2:	89 1c 24             	mov    %ebx,(%esp)
  8011c5:	e8 b9 ff ff ff       	call   801183 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ca:	83 c3 01             	add    $0x1,%ebx
  8011cd:	83 fb 20             	cmp    $0x20,%ebx
  8011d0:	75 f0                	jne    8011c2 <close_all+0xc>
		close(i);
}
  8011d2:	83 c4 14             	add    $0x14,%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	89 04 24             	mov    %eax,(%esp)
  8011ee:	e8 48 fe ff ff       	call   80103b <fd_lookup>
  8011f3:	89 c2                	mov    %eax,%edx
  8011f5:	85 d2                	test   %edx,%edx
  8011f7:	0f 88 e1 00 00 00    	js     8012de <dup+0x106>
		return r;
	close(newfdnum);
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	89 04 24             	mov    %eax,(%esp)
  801203:	e8 7b ff ff ff       	call   801183 <close>

	newfd = INDEX2FD(newfdnum);
  801208:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80120b:	c1 e3 0c             	shl    $0xc,%ebx
  80120e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801217:	89 04 24             	mov    %eax,(%esp)
  80121a:	e8 91 fd ff ff       	call   800fb0 <fd2data>
  80121f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801221:	89 1c 24             	mov    %ebx,(%esp)
  801224:	e8 87 fd ff ff       	call   800fb0 <fd2data>
  801229:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80122b:	89 f0                	mov    %esi,%eax
  80122d:	c1 e8 16             	shr    $0x16,%eax
  801230:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801237:	a8 01                	test   $0x1,%al
  801239:	74 43                	je     80127e <dup+0xa6>
  80123b:	89 f0                	mov    %esi,%eax
  80123d:	c1 e8 0c             	shr    $0xc,%eax
  801240:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801247:	f6 c2 01             	test   $0x1,%dl
  80124a:	74 32                	je     80127e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80124c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801253:	25 07 0e 00 00       	and    $0xe07,%eax
  801258:	89 44 24 10          	mov    %eax,0x10(%esp)
  80125c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801260:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801267:	00 
  801268:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801273:	e8 05 fb ff ff       	call   800d7d <sys_page_map>
  801278:	89 c6                	mov    %eax,%esi
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 3e                	js     8012bc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80127e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 ea 0c             	shr    $0xc,%edx
  801286:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80128d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801293:	89 54 24 10          	mov    %edx,0x10(%esp)
  801297:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80129b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a2:	00 
  8012a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ae:	e8 ca fa ff ff       	call   800d7d <sys_page_map>
  8012b3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012b8:	85 f6                	test   %esi,%esi
  8012ba:	79 22                	jns    8012de <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c7:	e8 04 fb ff ff       	call   800dd0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 f4 fa ff ff       	call   800dd0 <sys_page_unmap>
	return r;
  8012dc:	89 f0                	mov    %esi,%eax
}
  8012de:	83 c4 3c             	add    $0x3c,%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    

008012e6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 24             	sub    $0x24,%esp
  8012ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f7:	89 1c 24             	mov    %ebx,(%esp)
  8012fa:	e8 3c fd ff ff       	call   80103b <fd_lookup>
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	85 d2                	test   %edx,%edx
  801303:	78 6d                	js     801372 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801308:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130f:	8b 00                	mov    (%eax),%eax
  801311:	89 04 24             	mov    %eax,(%esp)
  801314:	e8 78 fd ff ff       	call   801091 <dev_lookup>
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 55                	js     801372 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801320:	8b 50 08             	mov    0x8(%eax),%edx
  801323:	83 e2 03             	and    $0x3,%edx
  801326:	83 fa 01             	cmp    $0x1,%edx
  801329:	75 23                	jne    80134e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80132b:	a1 04 40 80 00       	mov    0x804004,%eax
  801330:	8b 40 48             	mov    0x48(%eax),%eax
  801333:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133b:	c7 04 24 2d 2b 80 00 	movl   $0x802b2d,(%esp)
  801342:	e8 d6 ee ff ff       	call   80021d <cprintf>
		return -E_INVAL;
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134c:	eb 24                	jmp    801372 <read+0x8c>
	}
	if (!dev->dev_read)
  80134e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801351:	8b 52 08             	mov    0x8(%edx),%edx
  801354:	85 d2                	test   %edx,%edx
  801356:	74 15                	je     80136d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801358:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80135f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801366:	89 04 24             	mov    %eax,(%esp)
  801369:	ff d2                	call   *%edx
  80136b:	eb 05                	jmp    801372 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80136d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801372:	83 c4 24             	add    $0x24,%esp
  801375:	5b                   	pop    %ebx
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    

00801378 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 1c             	sub    $0x1c,%esp
  801381:	8b 7d 08             	mov    0x8(%ebp),%edi
  801384:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801387:	85 f6                	test   %esi,%esi
  801389:	74 33                	je     8013be <readn+0x46>
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801395:	89 f2                	mov    %esi,%edx
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139d:	03 45 0c             	add    0xc(%ebp),%eax
  8013a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a4:	89 3c 24             	mov    %edi,(%esp)
  8013a7:	e8 3a ff ff ff       	call   8012e6 <read>
		if (m < 0)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 1b                	js     8013cb <readn+0x53>
			return m;
		if (m == 0)
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	74 11                	je     8013c5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b4:	01 c3                	add    %eax,%ebx
  8013b6:	89 d8                	mov    %ebx,%eax
  8013b8:	39 f3                	cmp    %esi,%ebx
  8013ba:	72 d9                	jb     801395 <readn+0x1d>
  8013bc:	eb 0b                	jmp    8013c9 <readn+0x51>
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	eb 06                	jmp    8013cb <readn+0x53>
  8013c5:	89 d8                	mov    %ebx,%eax
  8013c7:	eb 02                	jmp    8013cb <readn+0x53>
  8013c9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013cb:	83 c4 1c             	add    $0x1c,%esp
  8013ce:	5b                   	pop    %ebx
  8013cf:	5e                   	pop    %esi
  8013d0:	5f                   	pop    %edi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 24             	sub    $0x24,%esp
  8013da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e4:	89 1c 24             	mov    %ebx,(%esp)
  8013e7:	e8 4f fc ff ff       	call   80103b <fd_lookup>
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	85 d2                	test   %edx,%edx
  8013f0:	78 68                	js     80145a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fc:	8b 00                	mov    (%eax),%eax
  8013fe:	89 04 24             	mov    %eax,(%esp)
  801401:	e8 8b fc ff ff       	call   801091 <dev_lookup>
  801406:	85 c0                	test   %eax,%eax
  801408:	78 50                	js     80145a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80140a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801411:	75 23                	jne    801436 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	8b 40 48             	mov    0x48(%eax),%eax
  80141b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80141f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801423:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  80142a:	e8 ee ed ff ff       	call   80021d <cprintf>
		return -E_INVAL;
  80142f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801434:	eb 24                	jmp    80145a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801439:	8b 52 0c             	mov    0xc(%edx),%edx
  80143c:	85 d2                	test   %edx,%edx
  80143e:	74 15                	je     801455 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801440:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801443:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80144e:	89 04 24             	mov    %eax,(%esp)
  801451:	ff d2                	call   *%edx
  801453:	eb 05                	jmp    80145a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801455:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80145a:	83 c4 24             	add    $0x24,%esp
  80145d:	5b                   	pop    %ebx
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <seek>:

int
seek(int fdnum, off_t offset)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801466:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	89 04 24             	mov    %eax,(%esp)
  801473:	e8 c3 fb ff ff       	call   80103b <fd_lookup>
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 0e                	js     80148a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80147c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	53                   	push   %ebx
  801490:	83 ec 24             	sub    $0x24,%esp
  801493:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801496:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149d:	89 1c 24             	mov    %ebx,(%esp)
  8014a0:	e8 96 fb ff ff       	call   80103b <fd_lookup>
  8014a5:	89 c2                	mov    %eax,%edx
  8014a7:	85 d2                	test   %edx,%edx
  8014a9:	78 61                	js     80150c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	89 04 24             	mov    %eax,(%esp)
  8014ba:	e8 d2 fb ff ff       	call   801091 <dev_lookup>
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 49                	js     80150c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ca:	75 23                	jne    8014ef <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014cc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d1:	8b 40 48             	mov    0x48(%eax),%eax
  8014d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dc:	c7 04 24 0c 2b 80 00 	movl   $0x802b0c,(%esp)
  8014e3:	e8 35 ed ff ff       	call   80021d <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ed:	eb 1d                	jmp    80150c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f2:	8b 52 18             	mov    0x18(%edx),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	74 0e                	je     801507 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801500:	89 04 24             	mov    %eax,(%esp)
  801503:	ff d2                	call   *%edx
  801505:	eb 05                	jmp    80150c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801507:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80150c:	83 c4 24             	add    $0x24,%esp
  80150f:	5b                   	pop    %ebx
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	53                   	push   %ebx
  801516:	83 ec 24             	sub    $0x24,%esp
  801519:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	89 04 24             	mov    %eax,(%esp)
  801529:	e8 0d fb ff ff       	call   80103b <fd_lookup>
  80152e:	89 c2                	mov    %eax,%edx
  801530:	85 d2                	test   %edx,%edx
  801532:	78 52                	js     801586 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	89 04 24             	mov    %eax,(%esp)
  801543:	e8 49 fb ff ff       	call   801091 <dev_lookup>
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 3a                	js     801586 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801553:	74 2c                	je     801581 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801555:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801558:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80155f:	00 00 00 
	stat->st_isdir = 0;
  801562:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801569:	00 00 00 
	stat->st_dev = dev;
  80156c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801572:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801576:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801579:	89 14 24             	mov    %edx,(%esp)
  80157c:	ff 50 14             	call   *0x14(%eax)
  80157f:	eb 05                	jmp    801586 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801581:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801586:	83 c4 24             	add    $0x24,%esp
  801589:	5b                   	pop    %ebx
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801594:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80159b:	00 
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 af 01 00 00       	call   801756 <open>
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	85 db                	test   %ebx,%ebx
  8015ab:	78 1b                	js     8015c8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b4:	89 1c 24             	mov    %ebx,(%esp)
  8015b7:	e8 56 ff ff ff       	call   801512 <fstat>
  8015bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015be:	89 1c 24             	mov    %ebx,(%esp)
  8015c1:	e8 bd fb ff ff       	call   801183 <close>
	return r;
  8015c6:	89 f0                	mov    %esi,%eax
}
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 10             	sub    $0x10,%esp
  8015d7:	89 c6                	mov    %eax,%esi
  8015d9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015e2:	75 11                	jne    8015f5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015eb:	e8 36 0e 00 00       	call   802426 <ipc_find_env>
  8015f0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015f5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015fc:	00 
  8015fd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801604:	00 
  801605:	89 74 24 04          	mov    %esi,0x4(%esp)
  801609:	a1 00 40 80 00       	mov    0x804000,%eax
  80160e:	89 04 24             	mov    %eax,(%esp)
  801611:	e8 aa 0d 00 00       	call   8023c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801616:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80161d:	00 
  80161e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801622:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801629:	e8 28 0d 00 00       	call   802356 <ipc_recv>
}
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 14             	sub    $0x14,%esp
  80163c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 40 0c             	mov    0xc(%eax),%eax
  801645:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80164a:	ba 00 00 00 00       	mov    $0x0,%edx
  80164f:	b8 05 00 00 00       	mov    $0x5,%eax
  801654:	e8 76 ff ff ff       	call   8015cf <fsipc>
  801659:	89 c2                	mov    %eax,%edx
  80165b:	85 d2                	test   %edx,%edx
  80165d:	78 2b                	js     80168a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80165f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801666:	00 
  801667:	89 1c 24             	mov    %ebx,(%esp)
  80166a:	e8 0c f2 ff ff       	call   80087b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80166f:	a1 80 50 80 00       	mov    0x805080,%eax
  801674:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80167a:	a1 84 50 80 00       	mov    0x805084,%eax
  80167f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168a:	83 c4 14             	add    $0x14,%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8b 40 0c             	mov    0xc(%eax),%eax
  80169c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ab:	e8 1f ff ff ff       	call   8015cf <fsipc>
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 10             	sub    $0x10,%esp
  8016ba:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016c8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d8:	e8 f2 fe ff ff       	call   8015cf <fsipc>
  8016dd:	89 c3                	mov    %eax,%ebx
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 6a                	js     80174d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016e3:	39 c6                	cmp    %eax,%esi
  8016e5:	73 24                	jae    80170b <devfile_read+0x59>
  8016e7:	c7 44 24 0c 66 2b 80 	movl   $0x802b66,0xc(%esp)
  8016ee:	00 
  8016ef:	c7 44 24 08 6d 2b 80 	movl   $0x802b6d,0x8(%esp)
  8016f6:	00 
  8016f7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8016fe:	00 
  8016ff:	c7 04 24 82 2b 80 00 	movl   $0x802b82,(%esp)
  801706:	e8 19 ea ff ff       	call   800124 <_panic>
	assert(r <= PGSIZE);
  80170b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801710:	7e 24                	jle    801736 <devfile_read+0x84>
  801712:	c7 44 24 0c 8d 2b 80 	movl   $0x802b8d,0xc(%esp)
  801719:	00 
  80171a:	c7 44 24 08 6d 2b 80 	movl   $0x802b6d,0x8(%esp)
  801721:	00 
  801722:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801729:	00 
  80172a:	c7 04 24 82 2b 80 00 	movl   $0x802b82,(%esp)
  801731:	e8 ee e9 ff ff       	call   800124 <_panic>
	memmove(buf, &fsipcbuf, r);
  801736:	89 44 24 08          	mov    %eax,0x8(%esp)
  80173a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801741:	00 
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	89 04 24             	mov    %eax,(%esp)
  801748:	e8 29 f3 ff ff       	call   800a76 <memmove>
	return r;
}
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	53                   	push   %ebx
  80175a:	83 ec 24             	sub    $0x24,%esp
  80175d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801760:	89 1c 24             	mov    %ebx,(%esp)
  801763:	e8 b8 f0 ff ff       	call   800820 <strlen>
  801768:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80176d:	7f 60                	jg     8017cf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80176f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801772:	89 04 24             	mov    %eax,(%esp)
  801775:	e8 4d f8 ff ff       	call   800fc7 <fd_alloc>
  80177a:	89 c2                	mov    %eax,%edx
  80177c:	85 d2                	test   %edx,%edx
  80177e:	78 54                	js     8017d4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801780:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801784:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80178b:	e8 eb f0 ff ff       	call   80087b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801790:	8b 45 0c             	mov    0xc(%ebp),%eax
  801793:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179b:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a0:	e8 2a fe ff ff       	call   8015cf <fsipc>
  8017a5:	89 c3                	mov    %eax,%ebx
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	79 17                	jns    8017c2 <open+0x6c>
		fd_close(fd, 0);
  8017ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017b2:	00 
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	89 04 24             	mov    %eax,(%esp)
  8017b9:	e8 44 f9 ff ff       	call   801102 <fd_close>
		return r;
  8017be:	89 d8                	mov    %ebx,%eax
  8017c0:	eb 12                	jmp    8017d4 <open+0x7e>
	}

	return fd2num(fd);
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	89 04 24             	mov    %eax,(%esp)
  8017c8:	e8 d3 f7 ff ff       	call   800fa0 <fd2num>
  8017cd:	eb 05                	jmp    8017d4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017cf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017d4:	83 c4 24             	add    $0x24,%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    
  8017da:	66 90                	xchg   %ax,%ax
  8017dc:	66 90                	xchg   %ax,%ax
  8017de:	66 90                	xchg   %ax,%ax

008017e0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	57                   	push   %edi
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
  8017e6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8017ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017f3:	00 
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	89 04 24             	mov    %eax,(%esp)
  8017fa:	e8 57 ff ff ff       	call   801756 <open>
  8017ff:	89 c1                	mov    %eax,%ecx
  801801:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801807:	85 c0                	test   %eax,%eax
  801809:	0f 88 d9 04 00 00    	js     801ce8 <spawn+0x508>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80180f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801816:	00 
  801817:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	89 0c 24             	mov    %ecx,(%esp)
  801824:	e8 4f fb ff ff       	call   801378 <readn>
  801829:	3d 00 02 00 00       	cmp    $0x200,%eax
  80182e:	75 0c                	jne    80183c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801830:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801837:	45 4c 46 
  80183a:	74 36                	je     801872 <spawn+0x92>
		close(fd);
  80183c:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 39 f9 ff ff       	call   801183 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80184a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801851:	46 
  801852:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185c:	c7 04 24 99 2b 80 00 	movl   $0x802b99,(%esp)
  801863:	e8 b5 e9 ff ff       	call   80021d <cprintf>
		return -E_NOT_EXEC;
  801868:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80186d:	e9 d5 04 00 00       	jmp    801d47 <spawn+0x567>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801872:	b8 07 00 00 00       	mov    $0x7,%eax
  801877:	cd 30                	int    $0x30
  801879:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80187f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801885:	85 c0                	test   %eax,%eax
  801887:	0f 88 63 04 00 00    	js     801cf0 <spawn+0x510>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80188d:	89 c6                	mov    %eax,%esi
  80188f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801895:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801898:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80189e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8018a4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8018a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018ab:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8018b1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ba:	8b 00                	mov    (%eax),%eax
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	74 38                	je     8018f8 <spawn+0x118>
  8018c0:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8018c5:	be 00 00 00 00       	mov    $0x0,%esi
  8018ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8018cd:	89 04 24             	mov    %eax,(%esp)
  8018d0:	e8 4b ef ff ff       	call   800820 <strlen>
  8018d5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018d9:	83 c3 01             	add    $0x1,%ebx
  8018dc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8018e3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	75 e3                	jne    8018cd <spawn+0xed>
  8018ea:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8018f0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8018f6:	eb 1e                	jmp    801916 <spawn+0x136>
  8018f8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  8018ff:	00 00 00 
  801902:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801909:	00 00 00 
  80190c:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801911:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801916:	bf 00 10 40 00       	mov    $0x401000,%edi
  80191b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80191d:	89 fa                	mov    %edi,%edx
  80191f:	83 e2 fc             	and    $0xfffffffc,%edx
  801922:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801929:	29 c2                	sub    %eax,%edx
  80192b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801931:	8d 42 f8             	lea    -0x8(%edx),%eax
  801934:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801939:	0f 86 c1 03 00 00    	jbe    801d00 <spawn+0x520>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80193f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801946:	00 
  801947:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80194e:	00 
  80194f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801956:	e8 ce f3 ff ff       	call   800d29 <sys_page_alloc>
  80195b:	85 c0                	test   %eax,%eax
  80195d:	0f 88 e4 03 00 00    	js     801d47 <spawn+0x567>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801963:	85 db                	test   %ebx,%ebx
  801965:	7e 46                	jle    8019ad <spawn+0x1cd>
  801967:	be 00 00 00 00       	mov    $0x0,%esi
  80196c:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  801975:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80197b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801981:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801984:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198b:	89 3c 24             	mov    %edi,(%esp)
  80198e:	e8 e8 ee ff ff       	call   80087b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801993:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 82 ee ff ff       	call   800820 <strlen>
  80199e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019a2:	83 c6 01             	add    $0x1,%esi
  8019a5:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  8019ab:	75 c8                	jne    801975 <spawn+0x195>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8019ad:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8019b3:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8019b9:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019c0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8019c6:	74 24                	je     8019ec <spawn+0x20c>
  8019c8:	c7 44 24 0c 10 2c 80 	movl   $0x802c10,0xc(%esp)
  8019cf:	00 
  8019d0:	c7 44 24 08 6d 2b 80 	movl   $0x802b6d,0x8(%esp)
  8019d7:	00 
  8019d8:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  8019df:	00 
  8019e0:	c7 04 24 b3 2b 80 00 	movl   $0x802bb3,(%esp)
  8019e7:	e8 38 e7 ff ff       	call   800124 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8019ec:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8019f2:	89 c8                	mov    %ecx,%eax
  8019f4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8019f9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8019fc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a02:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a05:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801a0b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a11:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a18:	00 
  801a19:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801a20:	ee 
  801a21:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801a27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a32:	00 
  801a33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3a:	e8 3e f3 ff ff       	call   800d7d <sys_page_map>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	85 c0                	test   %eax,%eax
  801a43:	0f 88 e8 02 00 00    	js     801d31 <spawn+0x551>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801a49:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a50:	00 
  801a51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a58:	e8 73 f3 ff ff       	call   800dd0 <sys_page_unmap>
  801a5d:	89 c3                	mov    %eax,%ebx
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	0f 88 ca 02 00 00    	js     801d31 <spawn+0x551>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801a67:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801a6d:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801a74:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a7a:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801a81:	00 
  801a82:	0f 84 dc 01 00 00    	je     801c64 <spawn+0x484>
  801a88:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801a8f:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801a92:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801a98:	83 38 01             	cmpl   $0x1,(%eax)
  801a9b:	0f 85 a2 01 00 00    	jne    801c43 <spawn+0x463>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801aa1:	89 c1                	mov    %eax,%ecx
  801aa3:	8b 40 18             	mov    0x18(%eax),%eax
  801aa6:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801aa9:	83 f8 01             	cmp    $0x1,%eax
  801aac:	19 c0                	sbb    %eax,%eax
  801aae:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ab4:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801abb:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ac2:	89 c8                	mov    %ecx,%eax
  801ac4:	8b 51 04             	mov    0x4(%ecx),%edx
  801ac7:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801acd:	8b 79 10             	mov    0x10(%ecx),%edi
  801ad0:	8b 49 14             	mov    0x14(%ecx),%ecx
  801ad3:	89 8d 90 fd ff ff    	mov    %ecx,-0x270(%ebp)
  801ad9:	8b 40 08             	mov    0x8(%eax),%eax
  801adc:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801ae2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ae7:	74 14                	je     801afd <spawn+0x31d>
		va -= i;
  801ae9:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801aef:	01 85 90 fd ff ff    	add    %eax,-0x270(%ebp)
		filesz += i;
  801af5:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801af7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801afd:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  801b04:	0f 84 39 01 00 00    	je     801c43 <spawn+0x463>
  801b0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b0f:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801b14:	39 f7                	cmp    %esi,%edi
  801b16:	77 31                	ja     801b49 <spawn+0x369>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801b18:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b22:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801b28:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 ef f1 ff ff       	call   800d29 <sys_page_alloc>
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	0f 89 ed 00 00 00    	jns    801c2f <spawn+0x44f>
  801b42:	89 c3                	mov    %eax,%ebx
  801b44:	e9 c8 01 00 00       	jmp    801d11 <spawn+0x531>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b49:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b50:	00 
  801b51:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b58:	00 
  801b59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b60:	e8 c4 f1 ff ff       	call   800d29 <sys_page_alloc>
  801b65:	85 c0                	test   %eax,%eax
  801b67:	0f 88 9a 01 00 00    	js     801d07 <spawn+0x527>
  801b6d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b73:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b79:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 d9 f8 ff ff       	call   801460 <seek>
  801b87:	85 c0                	test   %eax,%eax
  801b89:	0f 88 7c 01 00 00    	js     801d0b <spawn+0x52b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b8f:	89 fa                	mov    %edi,%edx
  801b91:	29 f2                	sub    %esi,%edx
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  801b9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ba0:	0f 47 c1             	cmova  %ecx,%eax
  801ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bae:	00 
  801baf:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801bb5:	89 04 24             	mov    %eax,(%esp)
  801bb8:	e8 bb f7 ff ff       	call   801378 <readn>
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	0f 88 4a 01 00 00    	js     801d0f <spawn+0x52f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801bc5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801bcb:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bcf:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801bd5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bd9:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bea:	00 
  801beb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf2:	e8 86 f1 ff ff       	call   800d7d <sys_page_map>
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	79 20                	jns    801c1b <spawn+0x43b>
				panic("spawn: sys_page_map data: %e", r);
  801bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bff:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  801c06:	00 
  801c07:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801c0e:	00 
  801c0f:	c7 04 24 b3 2b 80 00 	movl   $0x802bb3,(%esp)
  801c16:	e8 09 e5 ff ff       	call   800124 <_panic>
			sys_page_unmap(0, UTEMP);
  801c1b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c22:	00 
  801c23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2a:	e8 a1 f1 ff ff       	call   800dd0 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c35:	89 de                	mov    %ebx,%esi
  801c37:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801c3d:	0f 82 d1 fe ff ff    	jb     801b14 <spawn+0x334>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c43:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801c4a:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801c51:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c58:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  801c5e:	0f 8f 2e fe ff ff    	jg     801a92 <spawn+0x2b2>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801c64:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801c6a:	89 04 24             	mov    %eax,(%esp)
  801c6d:	e8 11 f5 ff ff       	call   801183 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c72:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c82:	89 04 24             	mov    %eax,(%esp)
  801c85:	e8 ec f1 ff ff       	call   800e76 <sys_env_set_trapframe>
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	79 20                	jns    801cae <spawn+0x4ce>
		panic("sys_env_set_trapframe: %e", r);
  801c8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c92:	c7 44 24 08 dc 2b 80 	movl   $0x802bdc,0x8(%esp)
  801c99:	00 
  801c9a:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801ca1:	00 
  801ca2:	c7 04 24 b3 2b 80 00 	movl   $0x802bb3,(%esp)
  801ca9:	e8 76 e4 ff ff       	call   800124 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801cae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801cb5:	00 
  801cb6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cbc:	89 04 24             	mov    %eax,(%esp)
  801cbf:	e8 5f f1 ff ff       	call   800e23 <sys_env_set_status>
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	79 30                	jns    801cf8 <spawn+0x518>
		panic("sys_env_set_status: %e", r);
  801cc8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccc:	c7 44 24 08 f6 2b 80 	movl   $0x802bf6,0x8(%esp)
  801cd3:	00 
  801cd4:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801cdb:	00 
  801cdc:	c7 04 24 b3 2b 80 00 	movl   $0x802bb3,(%esp)
  801ce3:	e8 3c e4 ff ff       	call   800124 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801ce8:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801cee:	eb 57                	jmp    801d47 <spawn+0x567>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801cf0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cf6:	eb 4f                	jmp    801d47 <spawn+0x567>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801cf8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cfe:	eb 47                	jmp    801d47 <spawn+0x567>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801d00:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801d05:	eb 40                	jmp    801d47 <spawn+0x567>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d07:	89 c3                	mov    %eax,%ebx
  801d09:	eb 06                	jmp    801d11 <spawn+0x531>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	eb 02                	jmp    801d11 <spawn+0x531>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d0f:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801d11:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 7a ef ff ff       	call   800c99 <sys_env_destroy>
	close(fd);
  801d1f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d25:	89 04 24             	mov    %eax,(%esp)
  801d28:	e8 56 f4 ff ff       	call   801183 <close>
	return r;
  801d2d:	89 d8                	mov    %ebx,%eax
  801d2f:	eb 16                	jmp    801d47 <spawn+0x567>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801d31:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d38:	00 
  801d39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d40:	e8 8b f0 ff ff       	call   800dd0 <sys_page_unmap>
  801d45:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801d47:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5f                   	pop    %edi
  801d50:	5d                   	pop    %ebp
  801d51:	c3                   	ret    

00801d52 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	57                   	push   %edi
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d5f:	74 61                	je     801dc2 <spawnl+0x70>
  801d61:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801d64:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801d69:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801d6c:	83 c0 04             	add    $0x4,%eax
  801d6f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801d73:	74 04                	je     801d79 <spawnl+0x27>
		argc++;
  801d75:	89 ca                	mov    %ecx,%edx
  801d77:	eb f0                	jmp    801d69 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801d79:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  801d80:	83 e0 f0             	and    $0xfffffff0,%eax
  801d83:	29 c4                	sub    %eax,%esp
  801d85:	8d 74 24 0b          	lea    0xb(%esp),%esi
  801d89:	c1 ee 02             	shr    $0x2,%esi
  801d8c:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  801d93:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801d95:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d98:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  801d9f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  801da6:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801da7:	89 ce                	mov    %ecx,%esi
  801da9:	85 c9                	test   %ecx,%ecx
  801dab:	74 25                	je     801dd2 <spawnl+0x80>
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801db2:	83 c0 01             	add    $0x1,%eax
  801db5:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  801db9:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801dbc:	39 f0                	cmp    %esi,%eax
  801dbe:	75 f2                	jne    801db2 <spawnl+0x60>
  801dc0:	eb 10                	jmp    801dd2 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  801dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  801dc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801dcf:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801dd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	89 04 24             	mov    %eax,(%esp)
  801ddc:	e8 ff f9 ff ff       	call   8017e0 <spawn>
}
  801de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
  801de9:	66 90                	xchg   %ax,%ax
  801deb:	66 90                	xchg   %ax,%ax
  801ded:	66 90                	xchg   %ax,%ax
  801def:	90                   	nop

00801df0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	83 ec 10             	sub    $0x10,%esp
  801df8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 aa f1 ff ff       	call   800fb0 <fd2data>
  801e06:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e08:	c7 44 24 04 38 2c 80 	movl   $0x802c38,0x4(%esp)
  801e0f:	00 
  801e10:	89 1c 24             	mov    %ebx,(%esp)
  801e13:	e8 63 ea ff ff       	call   80087b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e18:	8b 46 04             	mov    0x4(%esi),%eax
  801e1b:	2b 06                	sub    (%esi),%eax
  801e1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e2a:	00 00 00 
	stat->st_dev = &devpipe;
  801e2d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801e34:	30 80 00 
	return 0;
}
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	53                   	push   %ebx
  801e47:	83 ec 14             	sub    $0x14,%esp
  801e4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e58:	e8 73 ef ff ff       	call   800dd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e5d:	89 1c 24             	mov    %ebx,(%esp)
  801e60:	e8 4b f1 ff ff       	call   800fb0 <fd2data>
  801e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e70:	e8 5b ef ff ff       	call   800dd0 <sys_page_unmap>
}
  801e75:	83 c4 14             	add    $0x14,%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5d                   	pop    %ebp
  801e7a:	c3                   	ret    

00801e7b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	57                   	push   %edi
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	83 ec 2c             	sub    $0x2c,%esp
  801e84:	89 c6                	mov    %eax,%esi
  801e86:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e89:	a1 04 40 80 00       	mov    0x804004,%eax
  801e8e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e91:	89 34 24             	mov    %esi,(%esp)
  801e94:	e8 d5 05 00 00       	call   80246e <pageref>
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9e:	89 04 24             	mov    %eax,(%esp)
  801ea1:	e8 c8 05 00 00       	call   80246e <pageref>
  801ea6:	39 c7                	cmp    %eax,%edi
  801ea8:	0f 94 c2             	sete   %dl
  801eab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801eae:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801eb4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801eb7:	39 fb                	cmp    %edi,%ebx
  801eb9:	74 21                	je     801edc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ebb:	84 d2                	test   %dl,%dl
  801ebd:	74 ca                	je     801e89 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ebf:	8b 51 58             	mov    0x58(%ecx),%edx
  801ec2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ec6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ece:	c7 04 24 3f 2c 80 00 	movl   $0x802c3f,(%esp)
  801ed5:	e8 43 e3 ff ff       	call   80021d <cprintf>
  801eda:	eb ad                	jmp    801e89 <_pipeisclosed+0xe>
	}
}
  801edc:	83 c4 2c             	add    $0x2c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	57                   	push   %edi
  801ee8:	56                   	push   %esi
  801ee9:	53                   	push   %ebx
  801eea:	83 ec 1c             	sub    $0x1c,%esp
  801eed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ef0:	89 34 24             	mov    %esi,(%esp)
  801ef3:	e8 b8 f0 ff ff       	call   800fb0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ef8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801efc:	74 61                	je     801f5f <devpipe_write+0x7b>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	bf 00 00 00 00       	mov    $0x0,%edi
  801f05:	eb 4a                	jmp    801f51 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f07:	89 da                	mov    %ebx,%edx
  801f09:	89 f0                	mov    %esi,%eax
  801f0b:	e8 6b ff ff ff       	call   801e7b <_pipeisclosed>
  801f10:	85 c0                	test   %eax,%eax
  801f12:	75 54                	jne    801f68 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f14:	e8 f1 ed ff ff       	call   800d0a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f19:	8b 43 04             	mov    0x4(%ebx),%eax
  801f1c:	8b 0b                	mov    (%ebx),%ecx
  801f1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f21:	39 d0                	cmp    %edx,%eax
  801f23:	73 e2                	jae    801f07 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f28:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f2c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f2f:	99                   	cltd   
  801f30:	c1 ea 1b             	shr    $0x1b,%edx
  801f33:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f36:	83 e1 1f             	and    $0x1f,%ecx
  801f39:	29 d1                	sub    %edx,%ecx
  801f3b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f3f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f43:	83 c0 01             	add    $0x1,%eax
  801f46:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f49:	83 c7 01             	add    $0x1,%edi
  801f4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f4f:	74 13                	je     801f64 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f51:	8b 43 04             	mov    0x4(%ebx),%eax
  801f54:	8b 0b                	mov    (%ebx),%ecx
  801f56:	8d 51 20             	lea    0x20(%ecx),%edx
  801f59:	39 d0                	cmp    %edx,%eax
  801f5b:	73 aa                	jae    801f07 <devpipe_write+0x23>
  801f5d:	eb c6                	jmp    801f25 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f5f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f64:	89 f8                	mov    %edi,%eax
  801f66:	eb 05                	jmp    801f6d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    

00801f75 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	57                   	push   %edi
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	83 ec 1c             	sub    $0x1c,%esp
  801f7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f81:	89 3c 24             	mov    %edi,(%esp)
  801f84:	e8 27 f0 ff ff       	call   800fb0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8d:	74 54                	je     801fe3 <devpipe_read+0x6e>
  801f8f:	89 c3                	mov    %eax,%ebx
  801f91:	be 00 00 00 00       	mov    $0x0,%esi
  801f96:	eb 3e                	jmp    801fd6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f98:	89 f0                	mov    %esi,%eax
  801f9a:	eb 55                	jmp    801ff1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f9c:	89 da                	mov    %ebx,%edx
  801f9e:	89 f8                	mov    %edi,%eax
  801fa0:	e8 d6 fe ff ff       	call   801e7b <_pipeisclosed>
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	75 43                	jne    801fec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fa9:	e8 5c ed ff ff       	call   800d0a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fae:	8b 03                	mov    (%ebx),%eax
  801fb0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb3:	74 e7                	je     801f9c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fb5:	99                   	cltd   
  801fb6:	c1 ea 1b             	shr    $0x1b,%edx
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	83 e0 1f             	and    $0x1f,%eax
  801fbe:	29 d0                	sub    %edx,%eax
  801fc0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fcb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fce:	83 c6 01             	add    $0x1,%esi
  801fd1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd4:	74 12                	je     801fe8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801fd6:	8b 03                	mov    (%ebx),%eax
  801fd8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fdb:	75 d8                	jne    801fb5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fdd:	85 f6                	test   %esi,%esi
  801fdf:	75 b7                	jne    801f98 <devpipe_read+0x23>
  801fe1:	eb b9                	jmp    801f9c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fe3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fe8:	89 f0                	mov    %esi,%eax
  801fea:	eb 05                	jmp    801ff1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ff1:	83 c4 1c             	add    $0x1c,%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5f                   	pop    %edi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	56                   	push   %esi
  801ffd:	53                   	push   %ebx
  801ffe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802001:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802004:	89 04 24             	mov    %eax,(%esp)
  802007:	e8 bb ef ff ff       	call   800fc7 <fd_alloc>
  80200c:	89 c2                	mov    %eax,%edx
  80200e:	85 d2                	test   %edx,%edx
  802010:	0f 88 4d 01 00 00    	js     802163 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802016:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80201d:	00 
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	89 44 24 04          	mov    %eax,0x4(%esp)
  802025:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202c:	e8 f8 ec ff ff       	call   800d29 <sys_page_alloc>
  802031:	89 c2                	mov    %eax,%edx
  802033:	85 d2                	test   %edx,%edx
  802035:	0f 88 28 01 00 00    	js     802163 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80203b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 81 ef ff ff       	call   800fc7 <fd_alloc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	0f 88 fe 00 00 00    	js     80214e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802050:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802057:	00 
  802058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802066:	e8 be ec ff ff       	call   800d29 <sys_page_alloc>
  80206b:	89 c3                	mov    %eax,%ebx
  80206d:	85 c0                	test   %eax,%eax
  80206f:	0f 88 d9 00 00 00    	js     80214e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	89 04 24             	mov    %eax,(%esp)
  80207b:	e8 30 ef ff ff       	call   800fb0 <fd2data>
  802080:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802082:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802089:	00 
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802095:	e8 8f ec ff ff       	call   800d29 <sys_page_alloc>
  80209a:	89 c3                	mov    %eax,%ebx
  80209c:	85 c0                	test   %eax,%eax
  80209e:	0f 88 97 00 00 00    	js     80213b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	89 04 24             	mov    %eax,(%esp)
  8020aa:	e8 01 ef ff ff       	call   800fb0 <fd2data>
  8020af:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020b6:	00 
  8020b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020c2:	00 
  8020c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ce:	e8 aa ec ff ff       	call   800d7d <sys_page_map>
  8020d3:	89 c3                	mov    %eax,%ebx
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	78 52                	js     80212b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020d9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020ee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 92 ee ff ff       	call   800fa0 <fd2num>
  80210e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802111:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	89 04 24             	mov    %eax,(%esp)
  802119:	e8 82 ee ff ff       	call   800fa0 <fd2num>
  80211e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802121:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	eb 38                	jmp    802163 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80212b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80212f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802136:	e8 95 ec ff ff       	call   800dd0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80213b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802149:	e8 82 ec ff ff       	call   800dd0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 44 24 04          	mov    %eax,0x4(%esp)
  802155:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215c:	e8 6f ec ff ff       	call   800dd0 <sys_page_unmap>
  802161:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802163:	83 c4 30             	add    $0x30,%esp
  802166:	5b                   	pop    %ebx
  802167:	5e                   	pop    %esi
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802173:	89 44 24 04          	mov    %eax,0x4(%esp)
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	89 04 24             	mov    %eax,(%esp)
  80217d:	e8 b9 ee ff ff       	call   80103b <fd_lookup>
  802182:	89 c2                	mov    %eax,%edx
  802184:	85 d2                	test   %edx,%edx
  802186:	78 15                	js     80219d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	89 04 24             	mov    %eax,(%esp)
  80218e:	e8 1d ee ff ff       	call   800fb0 <fd2data>
	return _pipeisclosed(fd, p);
  802193:	89 c2                	mov    %eax,%edx
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	e8 de fc ff ff       	call   801e7b <_pipeisclosed>
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    
  80219f:	90                   	nop

008021a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    

008021aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021b0:	c7 44 24 04 57 2c 80 	movl   $0x802c57,0x4(%esp)
  8021b7:	00 
  8021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bb:	89 04 24             	mov    %eax,(%esp)
  8021be:	e8 b8 e6 ff ff       	call   80087b <strcpy>
	return 0;
}
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	57                   	push   %edi
  8021ce:	56                   	push   %esi
  8021cf:	53                   	push   %ebx
  8021d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021da:	74 4a                	je     802226 <devcons_write+0x5c>
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021ec:	8b 75 10             	mov    0x10(%ebp),%esi
  8021ef:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8021f1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021f4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021f9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021fc:	89 74 24 08          	mov    %esi,0x8(%esp)
  802200:	03 45 0c             	add    0xc(%ebp),%eax
  802203:	89 44 24 04          	mov    %eax,0x4(%esp)
  802207:	89 3c 24             	mov    %edi,(%esp)
  80220a:	e8 67 e8 ff ff       	call   800a76 <memmove>
		sys_cputs(buf, m);
  80220f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802213:	89 3c 24             	mov    %edi,(%esp)
  802216:	e8 41 ea ff ff       	call   800c5c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80221b:	01 f3                	add    %esi,%ebx
  80221d:	89 d8                	mov    %ebx,%eax
  80221f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802222:	72 c8                	jb     8021ec <devcons_write+0x22>
  802224:	eb 05                	jmp    80222b <devcons_write+0x61>
  802226:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80222b:	89 d8                	mov    %ebx,%eax
  80222d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    

00802238 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802243:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802247:	75 07                	jne    802250 <devcons_read+0x18>
  802249:	eb 28                	jmp    802273 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80224b:	e8 ba ea ff ff       	call   800d0a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802250:	e8 25 ea ff ff       	call   800c7a <sys_cgetc>
  802255:	85 c0                	test   %eax,%eax
  802257:	74 f2                	je     80224b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802259:	85 c0                	test   %eax,%eax
  80225b:	78 16                	js     802273 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80225d:	83 f8 04             	cmp    $0x4,%eax
  802260:	74 0c                	je     80226e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802262:	8b 55 0c             	mov    0xc(%ebp),%edx
  802265:	88 02                	mov    %al,(%edx)
	return 1;
  802267:	b8 01 00 00 00       	mov    $0x1,%eax
  80226c:	eb 05                	jmp    802273 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802288:	00 
  802289:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80228c:	89 04 24             	mov    %eax,(%esp)
  80228f:	e8 c8 e9 ff ff       	call   800c5c <sys_cputs>
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <getchar>:

int
getchar(void)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80229c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022a3:	00 
  8022a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b2:	e8 2f f0 ff ff       	call   8012e6 <read>
	if (r < 0)
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 0f                	js     8022ca <getchar+0x34>
		return r;
	if (r < 1)
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	7e 06                	jle    8022c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022c3:	eb 05                	jmp    8022ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	89 04 24             	mov    %eax,(%esp)
  8022df:	e8 57 ed ff ff       	call   80103b <fd_lookup>
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	78 11                	js     8022f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022f1:	39 10                	cmp    %edx,(%eax)
  8022f3:	0f 94 c0             	sete   %al
  8022f6:	0f b6 c0             	movzbl %al,%eax
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <opencons>:

int
opencons(void)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802301:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802304:	89 04 24             	mov    %eax,(%esp)
  802307:	e8 bb ec ff ff       	call   800fc7 <fd_alloc>
		return r;
  80230c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80230e:	85 c0                	test   %eax,%eax
  802310:	78 40                	js     802352 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802312:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802319:	00 
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802321:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802328:	e8 fc e9 ff ff       	call   800d29 <sys_page_alloc>
		return r;
  80232d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 1f                	js     802352 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802333:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802348:	89 04 24             	mov    %eax,(%esp)
  80234b:	e8 50 ec ff ff       	call   800fa0 <fd2num>
  802350:	89 c2                	mov    %eax,%edx
}
  802352:	89 d0                	mov    %edx,%eax
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	56                   	push   %esi
  80235a:	53                   	push   %ebx
  80235b:	83 ec 10             	sub    $0x10,%esp
  80235e:	8b 75 08             	mov    0x8(%ebp),%esi
  802361:	8b 45 0c             	mov    0xc(%ebp),%eax
  802364:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  802367:	83 f8 01             	cmp    $0x1,%eax
  80236a:	19 c0                	sbb    %eax,%eax
  80236c:	f7 d0                	not    %eax
  80236e:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  802373:	89 04 24             	mov    %eax,(%esp)
  802376:	e8 c4 eb ff ff       	call   800f3f <sys_ipc_recv>
	if (err_code < 0) {
  80237b:	85 c0                	test   %eax,%eax
  80237d:	79 16                	jns    802395 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  80237f:	85 f6                	test   %esi,%esi
  802381:	74 06                	je     802389 <ipc_recv+0x33>
  802383:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802389:	85 db                	test   %ebx,%ebx
  80238b:	74 2c                	je     8023b9 <ipc_recv+0x63>
  80238d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802393:	eb 24                	jmp    8023b9 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802395:	85 f6                	test   %esi,%esi
  802397:	74 0a                	je     8023a3 <ipc_recv+0x4d>
  802399:	a1 04 40 80 00       	mov    0x804004,%eax
  80239e:	8b 40 74             	mov    0x74(%eax),%eax
  8023a1:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8023a3:	85 db                	test   %ebx,%ebx
  8023a5:	74 0a                	je     8023b1 <ipc_recv+0x5b>
  8023a7:	a1 04 40 80 00       	mov    0x804004,%eax
  8023ac:	8b 40 78             	mov    0x78(%eax),%eax
  8023af:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8023b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8023b6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023b9:	83 c4 10             	add    $0x10,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    

008023c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	57                   	push   %edi
  8023c4:	56                   	push   %esi
  8023c5:	53                   	push   %ebx
  8023c6:	83 ec 1c             	sub    $0x1c,%esp
  8023c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8023d2:	eb 25                	jmp    8023f9 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8023d4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023d7:	74 20                	je     8023f9 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8023d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023dd:	c7 44 24 08 63 2c 80 	movl   $0x802c63,0x8(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8023ec:	00 
  8023ed:	c7 04 24 6f 2c 80 00 	movl   $0x802c6f,(%esp)
  8023f4:	e8 2b dd ff ff       	call   800124 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8023f9:	85 db                	test   %ebx,%ebx
  8023fb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802400:	0f 45 c3             	cmovne %ebx,%eax
  802403:	8b 55 14             	mov    0x14(%ebp),%edx
  802406:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80240a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80240e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802412:	89 3c 24             	mov    %edi,(%esp)
  802415:	e8 02 eb ff ff       	call   800f1c <sys_ipc_try_send>
  80241a:	85 c0                	test   %eax,%eax
  80241c:	75 b6                	jne    8023d4 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    

00802426 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80242c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802431:	39 c8                	cmp    %ecx,%eax
  802433:	74 17                	je     80244c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802435:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80243a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80243d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802443:	8b 52 50             	mov    0x50(%edx),%edx
  802446:	39 ca                	cmp    %ecx,%edx
  802448:	75 14                	jne    80245e <ipc_find_env+0x38>
  80244a:	eb 05                	jmp    802451 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802451:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802454:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802459:	8b 40 40             	mov    0x40(%eax),%eax
  80245c:	eb 0e                	jmp    80246c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80245e:	83 c0 01             	add    $0x1,%eax
  802461:	3d 00 04 00 00       	cmp    $0x400,%eax
  802466:	75 d2                	jne    80243a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802468:	66 b8 00 00          	mov    $0x0,%ax
}
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802474:	89 d0                	mov    %edx,%eax
  802476:	c1 e8 16             	shr    $0x16,%eax
  802479:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802485:	f6 c1 01             	test   $0x1,%cl
  802488:	74 1d                	je     8024a7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80248a:	c1 ea 0c             	shr    $0xc,%edx
  80248d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802494:	f6 c2 01             	test   $0x1,%dl
  802497:	74 0e                	je     8024a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802499:	c1 ea 0c             	shr    $0xc,%edx
  80249c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024a3:	ef 
  8024a4:	0f b7 c0             	movzwl %ax,%eax
}
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    
  8024a9:	66 90                	xchg   %ax,%ax
  8024ab:	66 90                	xchg   %ax,%ax
  8024ad:	66 90                	xchg   %ax,%ax
  8024af:	90                   	nop

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024cc:	89 ea                	mov    %ebp,%edx
  8024ce:	89 0c 24             	mov    %ecx,(%esp)
  8024d1:	75 2d                	jne    802500 <__udivdi3+0x50>
  8024d3:	39 e9                	cmp    %ebp,%ecx
  8024d5:	77 61                	ja     802538 <__udivdi3+0x88>
  8024d7:	85 c9                	test   %ecx,%ecx
  8024d9:	89 ce                	mov    %ecx,%esi
  8024db:	75 0b                	jne    8024e8 <__udivdi3+0x38>
  8024dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e2:	31 d2                	xor    %edx,%edx
  8024e4:	f7 f1                	div    %ecx
  8024e6:	89 c6                	mov    %eax,%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	89 e8                	mov    %ebp,%eax
  8024ec:	f7 f6                	div    %esi
  8024ee:	89 c5                	mov    %eax,%ebp
  8024f0:	89 f8                	mov    %edi,%eax
  8024f2:	f7 f6                	div    %esi
  8024f4:	89 ea                	mov    %ebp,%edx
  8024f6:	83 c4 0c             	add    $0xc,%esp
  8024f9:	5e                   	pop    %esi
  8024fa:	5f                   	pop    %edi
  8024fb:	5d                   	pop    %ebp
  8024fc:	c3                   	ret    
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	39 e8                	cmp    %ebp,%eax
  802502:	77 24                	ja     802528 <__udivdi3+0x78>
  802504:	0f bd e8             	bsr    %eax,%ebp
  802507:	83 f5 1f             	xor    $0x1f,%ebp
  80250a:	75 3c                	jne    802548 <__udivdi3+0x98>
  80250c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802510:	39 34 24             	cmp    %esi,(%esp)
  802513:	0f 86 9f 00 00 00    	jbe    8025b8 <__udivdi3+0x108>
  802519:	39 d0                	cmp    %edx,%eax
  80251b:	0f 82 97 00 00 00    	jb     8025b8 <__udivdi3+0x108>
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	31 c0                	xor    %eax,%eax
  80252c:	83 c4 0c             	add    $0xc,%esp
  80252f:	5e                   	pop    %esi
  802530:	5f                   	pop    %edi
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    
  802533:	90                   	nop
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 f8                	mov    %edi,%eax
  80253a:	f7 f1                	div    %ecx
  80253c:	31 d2                	xor    %edx,%edx
  80253e:	83 c4 0c             	add    $0xc,%esp
  802541:	5e                   	pop    %esi
  802542:	5f                   	pop    %edi
  802543:	5d                   	pop    %ebp
  802544:	c3                   	ret    
  802545:	8d 76 00             	lea    0x0(%esi),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	8b 3c 24             	mov    (%esp),%edi
  80254d:	d3 e0                	shl    %cl,%eax
  80254f:	89 c6                	mov    %eax,%esi
  802551:	b8 20 00 00 00       	mov    $0x20,%eax
  802556:	29 e8                	sub    %ebp,%eax
  802558:	89 c1                	mov    %eax,%ecx
  80255a:	d3 ef                	shr    %cl,%edi
  80255c:	89 e9                	mov    %ebp,%ecx
  80255e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802562:	8b 3c 24             	mov    (%esp),%edi
  802565:	09 74 24 08          	or     %esi,0x8(%esp)
  802569:	89 d6                	mov    %edx,%esi
  80256b:	d3 e7                	shl    %cl,%edi
  80256d:	89 c1                	mov    %eax,%ecx
  80256f:	89 3c 24             	mov    %edi,(%esp)
  802572:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802576:	d3 ee                	shr    %cl,%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	d3 e2                	shl    %cl,%edx
  80257c:	89 c1                	mov    %eax,%ecx
  80257e:	d3 ef                	shr    %cl,%edi
  802580:	09 d7                	or     %edx,%edi
  802582:	89 f2                	mov    %esi,%edx
  802584:	89 f8                	mov    %edi,%eax
  802586:	f7 74 24 08          	divl   0x8(%esp)
  80258a:	89 d6                	mov    %edx,%esi
  80258c:	89 c7                	mov    %eax,%edi
  80258e:	f7 24 24             	mull   (%esp)
  802591:	39 d6                	cmp    %edx,%esi
  802593:	89 14 24             	mov    %edx,(%esp)
  802596:	72 30                	jb     8025c8 <__udivdi3+0x118>
  802598:	8b 54 24 04          	mov    0x4(%esp),%edx
  80259c:	89 e9                	mov    %ebp,%ecx
  80259e:	d3 e2                	shl    %cl,%edx
  8025a0:	39 c2                	cmp    %eax,%edx
  8025a2:	73 05                	jae    8025a9 <__udivdi3+0xf9>
  8025a4:	3b 34 24             	cmp    (%esp),%esi
  8025a7:	74 1f                	je     8025c8 <__udivdi3+0x118>
  8025a9:	89 f8                	mov    %edi,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	e9 7a ff ff ff       	jmp    80252c <__udivdi3+0x7c>
  8025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b8:	31 d2                	xor    %edx,%edx
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bf:	e9 68 ff ff ff       	jmp    80252c <__udivdi3+0x7c>
  8025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	83 c4 0c             	add    $0xc,%esp
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    
  8025d4:	66 90                	xchg   %ax,%ax
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	66 90                	xchg   %ax,%ax
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <__umoddi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	83 ec 14             	sub    $0x14,%esp
  8025e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025f2:	89 c7                	mov    %eax,%edi
  8025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802600:	89 34 24             	mov    %esi,(%esp)
  802603:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802607:	85 c0                	test   %eax,%eax
  802609:	89 c2                	mov    %eax,%edx
  80260b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80260f:	75 17                	jne    802628 <__umoddi3+0x48>
  802611:	39 fe                	cmp    %edi,%esi
  802613:	76 4b                	jbe    802660 <__umoddi3+0x80>
  802615:	89 c8                	mov    %ecx,%eax
  802617:	89 fa                	mov    %edi,%edx
  802619:	f7 f6                	div    %esi
  80261b:	89 d0                	mov    %edx,%eax
  80261d:	31 d2                	xor    %edx,%edx
  80261f:	83 c4 14             	add    $0x14,%esp
  802622:	5e                   	pop    %esi
  802623:	5f                   	pop    %edi
  802624:	5d                   	pop    %ebp
  802625:	c3                   	ret    
  802626:	66 90                	xchg   %ax,%ax
  802628:	39 f8                	cmp    %edi,%eax
  80262a:	77 54                	ja     802680 <__umoddi3+0xa0>
  80262c:	0f bd e8             	bsr    %eax,%ebp
  80262f:	83 f5 1f             	xor    $0x1f,%ebp
  802632:	75 5c                	jne    802690 <__umoddi3+0xb0>
  802634:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802638:	39 3c 24             	cmp    %edi,(%esp)
  80263b:	0f 87 e7 00 00 00    	ja     802728 <__umoddi3+0x148>
  802641:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802645:	29 f1                	sub    %esi,%ecx
  802647:	19 c7                	sbb    %eax,%edi
  802649:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80264d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802651:	8b 44 24 08          	mov    0x8(%esp),%eax
  802655:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802659:	83 c4 14             	add    $0x14,%esp
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    
  802660:	85 f6                	test   %esi,%esi
  802662:	89 f5                	mov    %esi,%ebp
  802664:	75 0b                	jne    802671 <__umoddi3+0x91>
  802666:	b8 01 00 00 00       	mov    $0x1,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	f7 f6                	div    %esi
  80266f:	89 c5                	mov    %eax,%ebp
  802671:	8b 44 24 04          	mov    0x4(%esp),%eax
  802675:	31 d2                	xor    %edx,%edx
  802677:	f7 f5                	div    %ebp
  802679:	89 c8                	mov    %ecx,%eax
  80267b:	f7 f5                	div    %ebp
  80267d:	eb 9c                	jmp    80261b <__umoddi3+0x3b>
  80267f:	90                   	nop
  802680:	89 c8                	mov    %ecx,%eax
  802682:	89 fa                	mov    %edi,%edx
  802684:	83 c4 14             	add    $0x14,%esp
  802687:	5e                   	pop    %esi
  802688:	5f                   	pop    %edi
  802689:	5d                   	pop    %ebp
  80268a:	c3                   	ret    
  80268b:	90                   	nop
  80268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802690:	8b 04 24             	mov    (%esp),%eax
  802693:	be 20 00 00 00       	mov    $0x20,%esi
  802698:	89 e9                	mov    %ebp,%ecx
  80269a:	29 ee                	sub    %ebp,%esi
  80269c:	d3 e2                	shl    %cl,%edx
  80269e:	89 f1                	mov    %esi,%ecx
  8026a0:	d3 e8                	shr    %cl,%eax
  8026a2:	89 e9                	mov    %ebp,%ecx
  8026a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a8:	8b 04 24             	mov    (%esp),%eax
  8026ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8026af:	89 fa                	mov    %edi,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 f1                	mov    %esi,%ecx
  8026b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026bd:	d3 ea                	shr    %cl,%edx
  8026bf:	89 e9                	mov    %ebp,%ecx
  8026c1:	d3 e7                	shl    %cl,%edi
  8026c3:	89 f1                	mov    %esi,%ecx
  8026c5:	d3 e8                	shr    %cl,%eax
  8026c7:	89 e9                	mov    %ebp,%ecx
  8026c9:	09 f8                	or     %edi,%eax
  8026cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026cf:	f7 74 24 04          	divl   0x4(%esp)
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026d9:	89 d7                	mov    %edx,%edi
  8026db:	f7 64 24 08          	mull   0x8(%esp)
  8026df:	39 d7                	cmp    %edx,%edi
  8026e1:	89 c1                	mov    %eax,%ecx
  8026e3:	89 14 24             	mov    %edx,(%esp)
  8026e6:	72 2c                	jb     802714 <__umoddi3+0x134>
  8026e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026ec:	72 22                	jb     802710 <__umoddi3+0x130>
  8026ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026f2:	29 c8                	sub    %ecx,%eax
  8026f4:	19 d7                	sbb    %edx,%edi
  8026f6:	89 e9                	mov    %ebp,%ecx
  8026f8:	89 fa                	mov    %edi,%edx
  8026fa:	d3 e8                	shr    %cl,%eax
  8026fc:	89 f1                	mov    %esi,%ecx
  8026fe:	d3 e2                	shl    %cl,%edx
  802700:	89 e9                	mov    %ebp,%ecx
  802702:	d3 ef                	shr    %cl,%edi
  802704:	09 d0                	or     %edx,%eax
  802706:	89 fa                	mov    %edi,%edx
  802708:	83 c4 14             	add    $0x14,%esp
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    
  80270f:	90                   	nop
  802710:	39 d7                	cmp    %edx,%edi
  802712:	75 da                	jne    8026ee <__umoddi3+0x10e>
  802714:	8b 14 24             	mov    (%esp),%edx
  802717:	89 c1                	mov    %eax,%ecx
  802719:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80271d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802721:	eb cb                	jmp    8026ee <__umoddi3+0x10e>
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80272c:	0f 82 0f ff ff ff    	jb     802641 <__umoddi3+0x61>
  802732:	e9 1a ff ff ff       	jmp    802651 <__umoddi3+0x71>
