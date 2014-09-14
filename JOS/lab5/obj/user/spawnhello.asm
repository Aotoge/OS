
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
  800045:	c7 04 24 c0 27 80 00 	movl   $0x8027c0,(%esp)
  80004c:	e8 cc 01 00 00       	call   80021d <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 de 27 80 	movl   $0x8027de,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 de 27 80 00 	movl   $0x8027de,(%esp)
  800068:	e8 51 1d 00 00       	call   801dbe <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 e4 27 80 	movl   $0x8027e4,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
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
  800150:	c7 04 24 18 28 80 00 	movl   $0x802818,(%esp)
  800157:	e8 c1 00 00 00       	call   80021d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800160:	8b 45 10             	mov    0x10(%ebp),%eax
  800163:	89 04 24             	mov    %eax,(%esp)
  800166:	e8 51 00 00 00       	call   8001bc <vcprintf>
	cprintf("\n");
  80016b:	c7 04 24 3e 2c 80 00 	movl   $0x802c3e,(%esp)
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
  8002bc:	e8 5f 22 00 00       	call   802520 <__udivdi3>
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
  800315:	e8 36 23 00 00       	call   802650 <__umoddi3>
  80031a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031e:	0f be 80 3b 28 80 00 	movsbl 0x80283b(%eax),%eax
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
  80043c:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
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
  8004ef:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  8004f6:	85 d2                	test   %edx,%edx
  8004f8:	75 20                	jne    80051a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004fe:	c7 44 24 08 53 28 80 	movl   $0x802853,0x8(%esp)
  800505:	00 
  800506:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 77 fe ff ff       	call   80038c <printfmt>
  800515:	e9 c3 fe ff ff       	jmp    8003dd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80051a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051e:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
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
  80054d:	ba 4c 28 80 00       	mov    $0x80284c,%edx
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
  800cc7:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800cce:	00 
  800ccf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800cd6:	00 
  800cd7:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800d59:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800dac:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800dff:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800e52:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800ea5:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800eac:	00 
  800ead:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb4:	00 
  800eb5:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800ef8:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800eff:	00 
  800f00:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f07:	00 
  800f08:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  800f6d:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800f74:	00 
  800f75:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f7c:	00 
  800f7d:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
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
  8010e5:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
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
  80133b:	c7 04 24 ad 2b 80 00 	movl   $0x802bad,(%esp)
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
  801423:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
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
  8014dc:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
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
  8015a2:	e8 e1 01 00 00       	call   801788 <open>
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
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8015db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015e2:	75 11                	jne    8015f5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015eb:	e8 a4 0e 00 00       	call   802494 <ipc_find_env>
  8015f0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8015f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015fa:	8b 40 48             	mov    0x48(%eax),%eax
  8015fd:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801603:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801607:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	c7 04 24 e6 2b 80 00 	movl   $0x802be6,(%esp)
  801616:	e8 02 ec ff ff       	call   80021d <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80161b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801622:	00 
  801623:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80162a:	00 
  80162b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80162f:	a1 00 40 80 00       	mov    0x804000,%eax
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	e8 f2 0d 00 00       	call   80242e <ipc_send>
	cprintf("ipc_send\n");
  80163c:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801643:	e8 d5 eb ff ff       	call   80021d <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801648:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80164f:	00 
  801650:	89 74 24 04          	mov    %esi,0x4(%esp)
  801654:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165b:	e8 66 0d 00 00       	call   8023c6 <ipc_recv>
}
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	5b                   	pop    %ebx
  801664:	5e                   	pop    %esi
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    

00801667 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 14             	sub    $0x14,%esp
  80166e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8b 40 0c             	mov    0xc(%eax),%eax
  801677:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b8 05 00 00 00       	mov    $0x5,%eax
  801686:	e8 44 ff ff ff       	call   8015cf <fsipc>
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	85 d2                	test   %edx,%edx
  80168f:	78 2b                	js     8016bc <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801691:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801698:	00 
  801699:	89 1c 24             	mov    %ebx,(%esp)
  80169c:	e8 da f1 ff ff       	call   80087b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016a1:	a1 80 50 80 00       	mov    0x805080,%eax
  8016a6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ac:	a1 84 50 80 00       	mov    0x805084,%eax
  8016b1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bc:	83 c4 14             	add    $0x14,%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    

008016c2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ce:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8016dd:	e8 ed fe ff ff       	call   8015cf <fsipc>
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 10             	sub    $0x10,%esp
  8016ec:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016fa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 03 00 00 00       	mov    $0x3,%eax
  80170a:	e8 c0 fe ff ff       	call   8015cf <fsipc>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	85 c0                	test   %eax,%eax
  801713:	78 6a                	js     80177f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801715:	39 c6                	cmp    %eax,%esi
  801717:	73 24                	jae    80173d <devfile_read+0x59>
  801719:	c7 44 24 0c 06 2c 80 	movl   $0x802c06,0xc(%esp)
  801720:	00 
  801721:	c7 44 24 08 0d 2c 80 	movl   $0x802c0d,0x8(%esp)
  801728:	00 
  801729:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801730:	00 
  801731:	c7 04 24 22 2c 80 00 	movl   $0x802c22,(%esp)
  801738:	e8 e7 e9 ff ff       	call   800124 <_panic>
	assert(r <= PGSIZE);
  80173d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801742:	7e 24                	jle    801768 <devfile_read+0x84>
  801744:	c7 44 24 0c 2d 2c 80 	movl   $0x802c2d,0xc(%esp)
  80174b:	00 
  80174c:	c7 44 24 08 0d 2c 80 	movl   $0x802c0d,0x8(%esp)
  801753:	00 
  801754:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80175b:	00 
  80175c:	c7 04 24 22 2c 80 00 	movl   $0x802c22,(%esp)
  801763:	e8 bc e9 ff ff       	call   800124 <_panic>
	memmove(buf, &fsipcbuf, r);
  801768:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801773:	00 
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	89 04 24             	mov    %eax,(%esp)
  80177a:	e8 f7 f2 ff ff       	call   800a76 <memmove>
	return r;
}
  80177f:	89 d8                	mov    %ebx,%eax
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	53                   	push   %ebx
  80178c:	83 ec 24             	sub    $0x24,%esp
  80178f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801792:	89 1c 24             	mov    %ebx,(%esp)
  801795:	e8 86 f0 ff ff       	call   800820 <strlen>
  80179a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80179f:	7f 60                	jg     801801 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a4:	89 04 24             	mov    %eax,(%esp)
  8017a7:	e8 1b f8 ff ff       	call   800fc7 <fd_alloc>
  8017ac:	89 c2                	mov    %eax,%edx
  8017ae:	85 d2                	test   %edx,%edx
  8017b0:	78 54                	js     801806 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b6:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017bd:	e8 b9 f0 ff ff       	call   80087b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d2:	e8 f8 fd ff ff       	call   8015cf <fsipc>
  8017d7:	89 c3                	mov    %eax,%ebx
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	79 17                	jns    8017f4 <open+0x6c>
		fd_close(fd, 0);
  8017dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017e4:	00 
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	89 04 24             	mov    %eax,(%esp)
  8017eb:	e8 12 f9 ff ff       	call   801102 <fd_close>
		return r;
  8017f0:	89 d8                	mov    %ebx,%eax
  8017f2:	eb 12                	jmp    801806 <open+0x7e>
	}
	return fd2num(fd);
  8017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f7:	89 04 24             	mov    %eax,(%esp)
  8017fa:	e8 a1 f7 ff ff       	call   800fa0 <fd2num>
  8017ff:	eb 05                	jmp    801806 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801801:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801806:	83 c4 24             	add    $0x24,%esp
  801809:	5b                   	pop    %ebx
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    
  80180c:	66 90                	xchg   %ax,%ax
  80180e:	66 90                	xchg   %ax,%ax

00801810 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  80181c:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  801823:	e8 f5 e9 ff ff       	call   80021d <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  801828:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80182f:	00 
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 4d ff ff ff       	call   801788 <open>
  80183b:	89 c7                	mov    %eax,%edi
  80183d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801843:	85 c0                	test   %eax,%eax
  801845:	0f 88 09 05 00 00    	js     801d54 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  80184b:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  801852:	e8 c6 e9 ff ff       	call   80021d <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801857:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80185e:	00 
  80185f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801865:	89 44 24 04          	mov    %eax,0x4(%esp)
  801869:	89 3c 24             	mov    %edi,(%esp)
  80186c:	e8 07 fb ff ff       	call   801378 <readn>
  801871:	3d 00 02 00 00       	cmp    $0x200,%eax
  801876:	75 0c                	jne    801884 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  801878:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80187f:	45 4c 46 
  801882:	74 36                	je     8018ba <spawn+0xaa>
		close(fd);
  801884:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80188a:	89 04 24             	mov    %eax,(%esp)
  80188d:	e8 f1 f8 ff ff       	call   801183 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801892:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801899:	46 
  80189a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8018a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a4:	c7 04 24 52 2c 80 00 	movl   $0x802c52,(%esp)
  8018ab:	e8 6d e9 ff ff       	call   80021d <cprintf>
		return -E_NOT_EXEC;
  8018b0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8018b5:	e9 f9 04 00 00       	jmp    801db3 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  8018ba:	c7 04 24 6c 2c 80 00 	movl   $0x802c6c,(%esp)
  8018c1:	e8 57 e9 ff ff       	call   80021d <cprintf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8018c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8018cb:	cd 30                	int    $0x30
  8018cd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8018d3:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	0f 88 7b 04 00 00    	js     801d5c <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8018e1:	89 c6                	mov    %eax,%esi
  8018e3:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8018e9:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8018ec:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8018f2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8018f8:	b9 11 00 00 00       	mov    $0x11,%ecx
  8018fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018ff:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801905:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  80190b:	c7 04 24 79 2c 80 00 	movl   $0x802c79,(%esp)
  801912:	e8 06 e9 ff ff       	call   80021d <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	85 c0                	test   %eax,%eax
  80191e:	74 38                	je     801958 <spawn+0x148>
  801920:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801925:	be 00 00 00 00       	mov    $0x0,%esi
  80192a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80192d:	89 04 24             	mov    %eax,(%esp)
  801930:	e8 eb ee ff ff       	call   800820 <strlen>
  801935:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801939:	83 c3 01             	add    $0x1,%ebx
  80193c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801943:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801946:	85 c0                	test   %eax,%eax
  801948:	75 e3                	jne    80192d <spawn+0x11d>
  80194a:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801950:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801956:	eb 1e                	jmp    801976 <spawn+0x166>
  801958:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  80195f:	00 00 00 
  801962:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801969:	00 00 00 
  80196c:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801971:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801976:	bf 00 10 40 00       	mov    $0x401000,%edi
  80197b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80197d:	89 fa                	mov    %edi,%edx
  80197f:	83 e2 fc             	and    $0xfffffffc,%edx
  801982:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801989:	29 c2                	sub    %eax,%edx
  80198b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801991:	8d 42 f8             	lea    -0x8(%edx),%eax
  801994:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801999:	0f 86 cd 03 00 00    	jbe    801d6c <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80199f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019a6:	00 
  8019a7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019ae:	00 
  8019af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b6:	e8 6e f3 ff ff       	call   800d29 <sys_page_alloc>
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	0f 88 f0 03 00 00    	js     801db3 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019c3:	85 db                	test   %ebx,%ebx
  8019c5:	7e 46                	jle    801a0d <spawn+0x1fd>
  8019c7:	be 00 00 00 00       	mov    $0x0,%esi
  8019cc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8019d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  8019d5:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8019db:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8019e1:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8019e4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019eb:	89 3c 24             	mov    %edi,(%esp)
  8019ee:	e8 88 ee ff ff       	call   80087b <strcpy>
		string_store += strlen(argv[i]) + 1;
  8019f3:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8019f6:	89 04 24             	mov    %eax,(%esp)
  8019f9:	e8 22 ee ff ff       	call   800820 <strlen>
  8019fe:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a02:	83 c6 01             	add    $0x1,%esi
  801a05:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801a0b:	75 c8                	jne    8019d5 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801a0d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a13:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a19:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a20:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a26:	74 24                	je     801a4c <spawn+0x23c>
  801a28:	c7 44 24 0c ec 2c 80 	movl   $0x802cec,0xc(%esp)
  801a2f:	00 
  801a30:	c7 44 24 08 0d 2c 80 	movl   $0x802c0d,0x8(%esp)
  801a37:	00 
  801a38:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  801a3f:	00 
  801a40:	c7 04 24 85 2c 80 00 	movl   $0x802c85,(%esp)
  801a47:	e8 d8 e6 ff ff       	call   800124 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a4c:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a52:	89 c8                	mov    %ecx,%eax
  801a54:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801a59:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801a5c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a62:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a65:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801a6b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a71:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a78:	00 
  801a79:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801a80:	ee 
  801a81:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801a87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a92:	00 
  801a93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9a:	e8 de f2 ff ff       	call   800d7d <sys_page_map>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	0f 88 f4 02 00 00    	js     801d9d <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801aa9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ab0:	00 
  801ab1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab8:	e8 13 f3 ff ff       	call   800dd0 <sys_page_unmap>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	0f 88 d6 02 00 00    	js     801d9d <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801ac7:	c7 04 24 91 2c 80 00 	movl   $0x802c91,(%esp)
  801ace:	e8 4a e7 ff ff       	call   80021d <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ad3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ad9:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801ae0:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ae6:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801aed:	00 
  801aee:	0f 84 dc 01 00 00    	je     801cd0 <spawn+0x4c0>
  801af4:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801afb:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801afe:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801b04:	83 38 01             	cmpl   $0x1,(%eax)
  801b07:	0f 85 a2 01 00 00    	jne    801caf <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b0d:	89 c1                	mov    %eax,%ecx
  801b0f:	8b 40 18             	mov    0x18(%eax),%eax
  801b12:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b15:	83 f8 01             	cmp    $0x1,%eax
  801b18:	19 c0                	sbb    %eax,%eax
  801b1a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b20:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801b27:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b2e:	89 c8                	mov    %ecx,%eax
  801b30:	8b 51 04             	mov    0x4(%ecx),%edx
  801b33:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801b39:	8b 79 10             	mov    0x10(%ecx),%edi
  801b3c:	8b 49 14             	mov    0x14(%ecx),%ecx
  801b3f:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801b45:	8b 40 08             	mov    0x8(%eax),%eax
  801b48:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801b4e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b53:	74 14                	je     801b69 <spawn+0x359>
		va -= i;
  801b55:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801b5b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801b61:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801b63:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801b69:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801b70:	0f 84 39 01 00 00    	je     801caf <spawn+0x49f>
  801b76:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b7b:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801b80:	39 f7                	cmp    %esi,%edi
  801b82:	77 31                	ja     801bb5 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801b84:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8e:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801b94:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b98:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 83 f1 ff ff       	call   800d29 <sys_page_alloc>
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	0f 89 ed 00 00 00    	jns    801c9b <spawn+0x48b>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	e9 c8 01 00 00       	jmp    801d7d <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bb5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bbc:	00 
  801bbd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bc4:	00 
  801bc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bcc:	e8 58 f1 ff ff       	call   800d29 <sys_page_alloc>
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 88 9a 01 00 00    	js     801d73 <spawn+0x563>
  801bd9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801bdf:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801beb:	89 04 24             	mov    %eax,(%esp)
  801bee:	e8 6d f8 ff ff       	call   801460 <seek>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	0f 88 7c 01 00 00    	js     801d77 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801bfb:	89 fa                	mov    %edi,%edx
  801bfd:	29 f2                	sub    %esi,%edx
  801bff:	89 d0                	mov    %edx,%eax
  801c01:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  801c07:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c0c:	0f 47 c1             	cmova  %ecx,%eax
  801c0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c13:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c1a:	00 
  801c1b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c21:	89 04 24             	mov    %eax,(%esp)
  801c24:	e8 4f f7 ff ff       	call   801378 <readn>
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	0f 88 4a 01 00 00    	js     801d7b <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c31:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c37:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c3b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c41:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c45:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c56:	00 
  801c57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5e:	e8 1a f1 ff ff       	call   800d7d <sys_page_map>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	79 20                	jns    801c87 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  801c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6b:	c7 44 24 08 9e 2c 80 	movl   $0x802c9e,0x8(%esp)
  801c72:	00 
  801c73:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  801c7a:	00 
  801c7b:	c7 04 24 85 2c 80 00 	movl   $0x802c85,(%esp)
  801c82:	e8 9d e4 ff ff       	call   800124 <_panic>
			sys_page_unmap(0, UTEMP);
  801c87:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c8e:	00 
  801c8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c96:	e8 35 f1 ff ff       	call   800dd0 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ca1:	89 de                	mov    %ebx,%esi
  801ca3:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801ca9:	0f 82 d1 fe ff ff    	jb     801b80 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801caf:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801cb6:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801cbd:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cc4:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  801cca:	0f 8f 2e fe ff ff    	jg     801afe <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801cd0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cd6:	89 04 24             	mov    %eax,(%esp)
  801cd9:	e8 a5 f4 ff ff       	call   801183 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801cde:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 80 f1 ff ff       	call   800e76 <sys_env_set_trapframe>
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	79 20                	jns    801d1a <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  801cfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cfe:	c7 44 24 08 bb 2c 80 	movl   $0x802cbb,0x8(%esp)
  801d05:	00 
  801d06:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  801d0d:	00 
  801d0e:	c7 04 24 85 2c 80 00 	movl   $0x802c85,(%esp)
  801d15:	e8 0a e4 ff ff       	call   800124 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801d1a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d21:	00 
  801d22:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d28:	89 04 24             	mov    %eax,(%esp)
  801d2b:	e8 f3 f0 ff ff       	call   800e23 <sys_env_set_status>
  801d30:	85 c0                	test   %eax,%eax
  801d32:	79 30                	jns    801d64 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  801d34:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d38:	c7 44 24 08 d5 2c 80 	movl   $0x802cd5,0x8(%esp)
  801d3f:	00 
  801d40:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801d47:	00 
  801d48:	c7 04 24 85 2c 80 00 	movl   $0x802c85,(%esp)
  801d4f:	e8 d0 e3 ff ff       	call   800124 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801d54:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d5a:	eb 57                	jmp    801db3 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801d5c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d62:	eb 4f                	jmp    801db3 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  801d64:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d6a:	eb 47                	jmp    801db3 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801d6c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801d71:	eb 40                	jmp    801db3 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	eb 06                	jmp    801d7d <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	eb 02                	jmp    801d7d <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d7b:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  801d7d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d83:	89 04 24             	mov    %eax,(%esp)
  801d86:	e8 0e ef ff ff       	call   800c99 <sys_env_destroy>
	close(fd);
  801d8b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d91:	89 04 24             	mov    %eax,(%esp)
  801d94:	e8 ea f3 ff ff       	call   801183 <close>
	return r;
  801d99:	89 d8                	mov    %ebx,%eax
  801d9b:	eb 16                	jmp    801db3 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801d9d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801da4:	00 
  801da5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dac:	e8 1f f0 ff ff       	call   800dd0 <sys_page_unmap>
  801db1:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801db3:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5f                   	pop    %edi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dcb:	74 61                	je     801e2e <spawnl+0x70>
  801dcd:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801dd0:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801dd5:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801dd8:	83 c0 04             	add    $0x4,%eax
  801ddb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801ddf:	74 04                	je     801de5 <spawnl+0x27>
		argc++;
  801de1:	89 ca                	mov    %ecx,%edx
  801de3:	eb f0                	jmp    801dd5 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801de5:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  801dec:	83 e0 f0             	and    $0xfffffff0,%eax
  801def:	29 c4                	sub    %eax,%esp
  801df1:	8d 74 24 0b          	lea    0xb(%esp),%esi
  801df5:	c1 ee 02             	shr    $0x2,%esi
  801df8:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  801dff:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801e01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e04:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  801e0b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  801e12:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e13:	89 ce                	mov    %ecx,%esi
  801e15:	85 c9                	test   %ecx,%ecx
  801e17:	74 25                	je     801e3e <spawnl+0x80>
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801e1e:	83 c0 01             	add    $0x1,%eax
  801e21:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  801e25:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e28:	39 f0                	cmp    %esi,%eax
  801e2a:	75 f2                	jne    801e1e <spawnl+0x60>
  801e2c:	eb 10                	jmp    801e3e <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  801e34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801e3b:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801e3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	89 04 24             	mov    %eax,(%esp)
  801e48:	e8 c3 f9 ff ff       	call   801810 <spawn>
}
  801e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5f                   	pop    %edi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    
  801e55:	66 90                	xchg   %ax,%ax
  801e57:	66 90                	xchg   %ax,%ax
  801e59:	66 90                	xchg   %ax,%ax
  801e5b:	66 90                	xchg   %ax,%ax
  801e5d:	66 90                	xchg   %ax,%ax
  801e5f:	90                   	nop

00801e60 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	56                   	push   %esi
  801e64:	53                   	push   %ebx
  801e65:	83 ec 10             	sub    $0x10,%esp
  801e68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	89 04 24             	mov    %eax,(%esp)
  801e71:	e8 3a f1 ff ff       	call   800fb0 <fd2data>
  801e76:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e78:	c7 44 24 04 14 2d 80 	movl   $0x802d14,0x4(%esp)
  801e7f:	00 
  801e80:	89 1c 24             	mov    %ebx,(%esp)
  801e83:	e8 f3 e9 ff ff       	call   80087b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e88:	8b 46 04             	mov    0x4(%esi),%eax
  801e8b:	2b 06                	sub    (%esi),%eax
  801e8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e9a:	00 00 00 
	stat->st_dev = &devpipe;
  801e9d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ea4:	30 80 00 
	return 0;
}
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 14             	sub    $0x14,%esp
  801eba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ebd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec8:	e8 03 ef ff ff       	call   800dd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ecd:	89 1c 24             	mov    %ebx,(%esp)
  801ed0:	e8 db f0 ff ff       	call   800fb0 <fd2data>
  801ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee0:	e8 eb ee ff ff       	call   800dd0 <sys_page_unmap>
}
  801ee5:	83 c4 14             	add    $0x14,%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    

00801eeb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	57                   	push   %edi
  801eef:	56                   	push   %esi
  801ef0:	53                   	push   %ebx
  801ef1:	83 ec 2c             	sub    $0x2c,%esp
  801ef4:	89 c6                	mov    %eax,%esi
  801ef6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ef9:	a1 04 40 80 00       	mov    0x804004,%eax
  801efe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f01:	89 34 24             	mov    %esi,(%esp)
  801f04:	e8 d3 05 00 00       	call   8024dc <pageref>
  801f09:	89 c7                	mov    %eax,%edi
  801f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f0e:	89 04 24             	mov    %eax,(%esp)
  801f11:	e8 c6 05 00 00       	call   8024dc <pageref>
  801f16:	39 c7                	cmp    %eax,%edi
  801f18:	0f 94 c2             	sete   %dl
  801f1b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f1e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801f24:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f27:	39 fb                	cmp    %edi,%ebx
  801f29:	74 21                	je     801f4c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f2b:	84 d2                	test   %dl,%dl
  801f2d:	74 ca                	je     801ef9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f2f:	8b 51 58             	mov    0x58(%ecx),%edx
  801f32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f3e:	c7 04 24 1b 2d 80 00 	movl   $0x802d1b,(%esp)
  801f45:	e8 d3 e2 ff ff       	call   80021d <cprintf>
  801f4a:	eb ad                	jmp    801ef9 <_pipeisclosed+0xe>
	}
}
  801f4c:	83 c4 2c             	add    $0x2c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	57                   	push   %edi
  801f58:	56                   	push   %esi
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 1c             	sub    $0x1c,%esp
  801f5d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f60:	89 34 24             	mov    %esi,(%esp)
  801f63:	e8 48 f0 ff ff       	call   800fb0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f6c:	74 61                	je     801fcf <devpipe_write+0x7b>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	bf 00 00 00 00       	mov    $0x0,%edi
  801f75:	eb 4a                	jmp    801fc1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f77:	89 da                	mov    %ebx,%edx
  801f79:	89 f0                	mov    %esi,%eax
  801f7b:	e8 6b ff ff ff       	call   801eeb <_pipeisclosed>
  801f80:	85 c0                	test   %eax,%eax
  801f82:	75 54                	jne    801fd8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f84:	e8 81 ed ff ff       	call   800d0a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f89:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8c:	8b 0b                	mov    (%ebx),%ecx
  801f8e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f91:	39 d0                	cmp    %edx,%eax
  801f93:	73 e2                	jae    801f77 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f98:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f9c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f9f:	99                   	cltd   
  801fa0:	c1 ea 1b             	shr    $0x1b,%edx
  801fa3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fa6:	83 e1 1f             	and    $0x1f,%ecx
  801fa9:	29 d1                	sub    %edx,%ecx
  801fab:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801faf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fb3:	83 c0 01             	add    $0x1,%eax
  801fb6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fb9:	83 c7 01             	add    $0x1,%edi
  801fbc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fbf:	74 13                	je     801fd4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fc1:	8b 43 04             	mov    0x4(%ebx),%eax
  801fc4:	8b 0b                	mov    (%ebx),%ecx
  801fc6:	8d 51 20             	lea    0x20(%ecx),%edx
  801fc9:	39 d0                	cmp    %edx,%eax
  801fcb:	73 aa                	jae    801f77 <devpipe_write+0x23>
  801fcd:	eb c6                	jmp    801f95 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fcf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fd4:	89 f8                	mov    %edi,%eax
  801fd6:	eb 05                	jmp    801fdd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fdd:	83 c4 1c             	add    $0x1c,%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5f                   	pop    %edi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	57                   	push   %edi
  801fe9:	56                   	push   %esi
  801fea:	53                   	push   %ebx
  801feb:	83 ec 1c             	sub    $0x1c,%esp
  801fee:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ff1:	89 3c 24             	mov    %edi,(%esp)
  801ff4:	e8 b7 ef ff ff       	call   800fb0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffd:	74 54                	je     802053 <devpipe_read+0x6e>
  801fff:	89 c3                	mov    %eax,%ebx
  802001:	be 00 00 00 00       	mov    $0x0,%esi
  802006:	eb 3e                	jmp    802046 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802008:	89 f0                	mov    %esi,%eax
  80200a:	eb 55                	jmp    802061 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80200c:	89 da                	mov    %ebx,%edx
  80200e:	89 f8                	mov    %edi,%eax
  802010:	e8 d6 fe ff ff       	call   801eeb <_pipeisclosed>
  802015:	85 c0                	test   %eax,%eax
  802017:	75 43                	jne    80205c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802019:	e8 ec ec ff ff       	call   800d0a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80201e:	8b 03                	mov    (%ebx),%eax
  802020:	3b 43 04             	cmp    0x4(%ebx),%eax
  802023:	74 e7                	je     80200c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802025:	99                   	cltd   
  802026:	c1 ea 1b             	shr    $0x1b,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	83 e0 1f             	and    $0x1f,%eax
  80202e:	29 d0                	sub    %edx,%eax
  802030:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802038:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80203b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203e:	83 c6 01             	add    $0x1,%esi
  802041:	3b 75 10             	cmp    0x10(%ebp),%esi
  802044:	74 12                	je     802058 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802046:	8b 03                	mov    (%ebx),%eax
  802048:	3b 43 04             	cmp    0x4(%ebx),%eax
  80204b:	75 d8                	jne    802025 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80204d:	85 f6                	test   %esi,%esi
  80204f:	75 b7                	jne    802008 <devpipe_read+0x23>
  802051:	eb b9                	jmp    80200c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802053:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802058:	89 f0                	mov    %esi,%eax
  80205a:	eb 05                	jmp    802061 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802061:	83 c4 1c             	add    $0x1c,%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	56                   	push   %esi
  80206d:	53                   	push   %ebx
  80206e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802074:	89 04 24             	mov    %eax,(%esp)
  802077:	e8 4b ef ff ff       	call   800fc7 <fd_alloc>
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	0f 88 4d 01 00 00    	js     8021d3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802086:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80208d:	00 
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	89 44 24 04          	mov    %eax,0x4(%esp)
  802095:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209c:	e8 88 ec ff ff       	call   800d29 <sys_page_alloc>
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	85 d2                	test   %edx,%edx
  8020a5:	0f 88 28 01 00 00    	js     8021d3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 11 ef ff ff       	call   800fc7 <fd_alloc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 fe 00 00 00    	js     8021be <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c7:	00 
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d6:	e8 4e ec ff ff       	call   800d29 <sys_page_alloc>
  8020db:	89 c3                	mov    %eax,%ebx
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	0f 88 d9 00 00 00    	js     8021be <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	89 04 24             	mov    %eax,(%esp)
  8020eb:	e8 c0 ee ff ff       	call   800fb0 <fd2data>
  8020f0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020f9:	00 
  8020fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802105:	e8 1f ec ff ff       	call   800d29 <sys_page_alloc>
  80210a:	89 c3                	mov    %eax,%ebx
  80210c:	85 c0                	test   %eax,%eax
  80210e:	0f 88 97 00 00 00    	js     8021ab <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	89 04 24             	mov    %eax,(%esp)
  80211a:	e8 91 ee ff ff       	call   800fb0 <fd2data>
  80211f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802126:	00 
  802127:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80212b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802132:	00 
  802133:	89 74 24 04          	mov    %esi,0x4(%esp)
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 3a ec ff ff       	call   800d7d <sys_page_map>
  802143:	89 c3                	mov    %eax,%ebx
  802145:	85 c0                	test   %eax,%eax
  802147:	78 52                	js     80219b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802149:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80215e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	89 04 24             	mov    %eax,(%esp)
  802179:	e8 22 ee ff ff       	call   800fa0 <fd2num>
  80217e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802181:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	89 04 24             	mov    %eax,(%esp)
  802189:	e8 12 ee ff ff       	call   800fa0 <fd2num>
  80218e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802191:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	eb 38                	jmp    8021d3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80219b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80219f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a6:	e8 25 ec ff ff       	call   800dd0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b9:	e8 12 ec ff ff       	call   800dd0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021cc:	e8 ff eb ff ff       	call   800dd0 <sys_page_unmap>
  8021d1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021d3:	83 c4 30             	add    $0x30,%esp
  8021d6:	5b                   	pop    %ebx
  8021d7:	5e                   	pop    %esi
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    

008021da <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	89 04 24             	mov    %eax,(%esp)
  8021ed:	e8 49 ee ff ff       	call   80103b <fd_lookup>
  8021f2:	89 c2                	mov    %eax,%edx
  8021f4:	85 d2                	test   %edx,%edx
  8021f6:	78 15                	js     80220d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	89 04 24             	mov    %eax,(%esp)
  8021fe:	e8 ad ed ff ff       	call   800fb0 <fd2data>
	return _pipeisclosed(fd, p);
  802203:	89 c2                	mov    %eax,%edx
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	e8 de fc ff ff       	call   801eeb <_pipeisclosed>
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    
  80220f:	90                   	nop

00802210 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802220:	c7 44 24 04 33 2d 80 	movl   $0x802d33,0x4(%esp)
  802227:	00 
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	89 04 24             	mov    %eax,(%esp)
  80222e:	e8 48 e6 ff ff       	call   80087b <strcpy>
	return 0;
}
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	57                   	push   %edi
  80223e:	56                   	push   %esi
  80223f:	53                   	push   %ebx
  802240:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80224a:	74 4a                	je     802296 <devcons_write+0x5c>
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
  802251:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802256:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80225c:	8b 75 10             	mov    0x10(%ebp),%esi
  80225f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802261:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802264:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802269:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80226c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802270:	03 45 0c             	add    0xc(%ebp),%eax
  802273:	89 44 24 04          	mov    %eax,0x4(%esp)
  802277:	89 3c 24             	mov    %edi,(%esp)
  80227a:	e8 f7 e7 ff ff       	call   800a76 <memmove>
		sys_cputs(buf, m);
  80227f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802283:	89 3c 24             	mov    %edi,(%esp)
  802286:	e8 d1 e9 ff ff       	call   800c5c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80228b:	01 f3                	add    %esi,%ebx
  80228d:	89 d8                	mov    %ebx,%eax
  80228f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802292:	72 c8                	jb     80225c <devcons_write+0x22>
  802294:	eb 05                	jmp    80229b <devcons_write+0x61>
  802296:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80229b:	89 d8                	mov    %ebx,%eax
  80229d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022a3:	5b                   	pop    %ebx
  8022a4:	5e                   	pop    %esi
  8022a5:	5f                   	pop    %edi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    

008022a8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8022b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b7:	75 07                	jne    8022c0 <devcons_read+0x18>
  8022b9:	eb 28                	jmp    8022e3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022bb:	e8 4a ea ff ff       	call   800d0a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022c0:	e8 b5 e9 ff ff       	call   800c7a <sys_cgetc>
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 f2                	je     8022bb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	78 16                	js     8022e3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022cd:	83 f8 04             	cmp    $0x4,%eax
  8022d0:	74 0c                	je     8022de <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8022d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d5:	88 02                	mov    %al,(%edx)
	return 1;
  8022d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022dc:	eb 05                	jmp    8022e3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022f8:	00 
  8022f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022fc:	89 04 24             	mov    %eax,(%esp)
  8022ff:	e8 58 e9 ff ff       	call   800c5c <sys_cputs>
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <getchar>:

int
getchar(void)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80230c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802313:	00 
  802314:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802322:	e8 bf ef ff ff       	call   8012e6 <read>
	if (r < 0)
  802327:	85 c0                	test   %eax,%eax
  802329:	78 0f                	js     80233a <getchar+0x34>
		return r;
	if (r < 1)
  80232b:	85 c0                	test   %eax,%eax
  80232d:	7e 06                	jle    802335 <getchar+0x2f>
		return -E_EOF;
	return c;
  80232f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802333:	eb 05                	jmp    80233a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802335:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802342:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802345:	89 44 24 04          	mov    %eax,0x4(%esp)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	89 04 24             	mov    %eax,(%esp)
  80234f:	e8 e7 ec ff ff       	call   80103b <fd_lookup>
  802354:	85 c0                	test   %eax,%eax
  802356:	78 11                	js     802369 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802361:	39 10                	cmp    %edx,(%eax)
  802363:	0f 94 c0             	sete   %al
  802366:	0f b6 c0             	movzbl %al,%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <opencons>:

int
opencons(void)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802371:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802374:	89 04 24             	mov    %eax,(%esp)
  802377:	e8 4b ec ff ff       	call   800fc7 <fd_alloc>
		return r;
  80237c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80237e:	85 c0                	test   %eax,%eax
  802380:	78 40                	js     8023c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802382:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802389:	00 
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802398:	e8 8c e9 ff ff       	call   800d29 <sys_page_alloc>
		return r;
  80239d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	78 1f                	js     8023c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023a3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023b8:	89 04 24             	mov    %eax,(%esp)
  8023bb:	e8 e0 eb ff ff       	call   800fa0 <fd2num>
  8023c0:	89 c2                	mov    %eax,%edx
}
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	56                   	push   %esi
  8023ca:	53                   	push   %ebx
  8023cb:	83 ec 10             	sub    $0x10,%esp
  8023ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023de:	0f 44 c2             	cmove  %edx,%eax
  8023e1:	89 04 24             	mov    %eax,(%esp)
  8023e4:	e8 56 eb ff ff       	call   800f3f <sys_ipc_recv>
	if (err_code < 0) {
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	79 16                	jns    802403 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8023ed:	85 f6                	test   %esi,%esi
  8023ef:	74 06                	je     8023f7 <ipc_recv+0x31>
  8023f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8023f7:	85 db                	test   %ebx,%ebx
  8023f9:	74 2c                	je     802427 <ipc_recv+0x61>
  8023fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802401:	eb 24                	jmp    802427 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802403:	85 f6                	test   %esi,%esi
  802405:	74 0a                	je     802411 <ipc_recv+0x4b>
  802407:	a1 04 40 80 00       	mov    0x804004,%eax
  80240c:	8b 40 74             	mov    0x74(%eax),%eax
  80240f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802411:	85 db                	test   %ebx,%ebx
  802413:	74 0a                	je     80241f <ipc_recv+0x59>
  802415:	a1 04 40 80 00       	mov    0x804004,%eax
  80241a:	8b 40 78             	mov    0x78(%eax),%eax
  80241d:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80241f:	a1 04 40 80 00       	mov    0x804004,%eax
  802424:	8b 40 70             	mov    0x70(%eax),%eax
}
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 7d 08             	mov    0x8(%ebp),%edi
  80243a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80243d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802440:	eb 25                	jmp    802467 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802442:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802445:	74 20                	je     802467 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244b:	c7 44 24 08 3f 2d 80 	movl   $0x802d3f,0x8(%esp)
  802452:	00 
  802453:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80245a:	00 
  80245b:	c7 04 24 4b 2d 80 00 	movl   $0x802d4b,(%esp)
  802462:	e8 bd dc ff ff       	call   800124 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802467:	85 db                	test   %ebx,%ebx
  802469:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80246e:	0f 45 c3             	cmovne %ebx,%eax
  802471:	8b 55 14             	mov    0x14(%ebp),%edx
  802474:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802478:	89 44 24 08          	mov    %eax,0x8(%esp)
  80247c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802480:	89 3c 24             	mov    %edi,(%esp)
  802483:	e8 94 ea ff ff       	call   800f1c <sys_ipc_try_send>
  802488:	85 c0                	test   %eax,%eax
  80248a:	75 b6                	jne    802442 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    

00802494 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80249a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80249f:	39 c8                	cmp    %ecx,%eax
  8024a1:	74 17                	je     8024ba <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024a3:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8024a8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024ab:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024b1:	8b 52 50             	mov    0x50(%edx),%edx
  8024b4:	39 ca                	cmp    %ecx,%edx
  8024b6:	75 14                	jne    8024cc <ipc_find_env+0x38>
  8024b8:	eb 05                	jmp    8024bf <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8024bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024c2:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024c7:	8b 40 40             	mov    0x40(%eax),%eax
  8024ca:	eb 0e                	jmp    8024da <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024cc:	83 c0 01             	add    $0x1,%eax
  8024cf:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024d4:	75 d2                	jne    8024a8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024d6:	66 b8 00 00          	mov    $0x0,%ax
}
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    

008024dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	c1 e8 16             	shr    $0x16,%eax
  8024e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024f3:	f6 c1 01             	test   $0x1,%cl
  8024f6:	74 1d                	je     802515 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024f8:	c1 ea 0c             	shr    $0xc,%edx
  8024fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802502:	f6 c2 01             	test   $0x1,%dl
  802505:	74 0e                	je     802515 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802507:	c1 ea 0c             	shr    $0xc,%edx
  80250a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802511:	ef 
  802512:	0f b7 c0             	movzwl %ax,%eax
}
  802515:	5d                   	pop    %ebp
  802516:	c3                   	ret    
  802517:	66 90                	xchg   %ax,%ax
  802519:	66 90                	xchg   %ax,%ax
  80251b:	66 90                	xchg   %ax,%ax
  80251d:	66 90                	xchg   %ax,%ax
  80251f:	90                   	nop

00802520 <__udivdi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	8b 44 24 28          	mov    0x28(%esp),%eax
  80252a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80252e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802532:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802536:	85 c0                	test   %eax,%eax
  802538:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80253c:	89 ea                	mov    %ebp,%edx
  80253e:	89 0c 24             	mov    %ecx,(%esp)
  802541:	75 2d                	jne    802570 <__udivdi3+0x50>
  802543:	39 e9                	cmp    %ebp,%ecx
  802545:	77 61                	ja     8025a8 <__udivdi3+0x88>
  802547:	85 c9                	test   %ecx,%ecx
  802549:	89 ce                	mov    %ecx,%esi
  80254b:	75 0b                	jne    802558 <__udivdi3+0x38>
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	31 d2                	xor    %edx,%edx
  802554:	f7 f1                	div    %ecx
  802556:	89 c6                	mov    %eax,%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	89 e8                	mov    %ebp,%eax
  80255c:	f7 f6                	div    %esi
  80255e:	89 c5                	mov    %eax,%ebp
  802560:	89 f8                	mov    %edi,%eax
  802562:	f7 f6                	div    %esi
  802564:	89 ea                	mov    %ebp,%edx
  802566:	83 c4 0c             	add    $0xc,%esp
  802569:	5e                   	pop    %esi
  80256a:	5f                   	pop    %edi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	39 e8                	cmp    %ebp,%eax
  802572:	77 24                	ja     802598 <__udivdi3+0x78>
  802574:	0f bd e8             	bsr    %eax,%ebp
  802577:	83 f5 1f             	xor    $0x1f,%ebp
  80257a:	75 3c                	jne    8025b8 <__udivdi3+0x98>
  80257c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802580:	39 34 24             	cmp    %esi,(%esp)
  802583:	0f 86 9f 00 00 00    	jbe    802628 <__udivdi3+0x108>
  802589:	39 d0                	cmp    %edx,%eax
  80258b:	0f 82 97 00 00 00    	jb     802628 <__udivdi3+0x108>
  802591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	31 c0                	xor    %eax,%eax
  80259c:	83 c4 0c             	add    $0xc,%esp
  80259f:	5e                   	pop    %esi
  8025a0:	5f                   	pop    %edi
  8025a1:	5d                   	pop    %ebp
  8025a2:	c3                   	ret    
  8025a3:	90                   	nop
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	89 f8                	mov    %edi,%eax
  8025aa:	f7 f1                	div    %ecx
  8025ac:	31 d2                	xor    %edx,%edx
  8025ae:	83 c4 0c             	add    $0xc,%esp
  8025b1:	5e                   	pop    %esi
  8025b2:	5f                   	pop    %edi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    
  8025b5:	8d 76 00             	lea    0x0(%esi),%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	8b 3c 24             	mov    (%esp),%edi
  8025bd:	d3 e0                	shl    %cl,%eax
  8025bf:	89 c6                	mov    %eax,%esi
  8025c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025c6:	29 e8                	sub    %ebp,%eax
  8025c8:	89 c1                	mov    %eax,%ecx
  8025ca:	d3 ef                	shr    %cl,%edi
  8025cc:	89 e9                	mov    %ebp,%ecx
  8025ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025d2:	8b 3c 24             	mov    (%esp),%edi
  8025d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025d9:	89 d6                	mov    %edx,%esi
  8025db:	d3 e7                	shl    %cl,%edi
  8025dd:	89 c1                	mov    %eax,%ecx
  8025df:	89 3c 24             	mov    %edi,(%esp)
  8025e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025e6:	d3 ee                	shr    %cl,%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	d3 e2                	shl    %cl,%edx
  8025ec:	89 c1                	mov    %eax,%ecx
  8025ee:	d3 ef                	shr    %cl,%edi
  8025f0:	09 d7                	or     %edx,%edi
  8025f2:	89 f2                	mov    %esi,%edx
  8025f4:	89 f8                	mov    %edi,%eax
  8025f6:	f7 74 24 08          	divl   0x8(%esp)
  8025fa:	89 d6                	mov    %edx,%esi
  8025fc:	89 c7                	mov    %eax,%edi
  8025fe:	f7 24 24             	mull   (%esp)
  802601:	39 d6                	cmp    %edx,%esi
  802603:	89 14 24             	mov    %edx,(%esp)
  802606:	72 30                	jb     802638 <__udivdi3+0x118>
  802608:	8b 54 24 04          	mov    0x4(%esp),%edx
  80260c:	89 e9                	mov    %ebp,%ecx
  80260e:	d3 e2                	shl    %cl,%edx
  802610:	39 c2                	cmp    %eax,%edx
  802612:	73 05                	jae    802619 <__udivdi3+0xf9>
  802614:	3b 34 24             	cmp    (%esp),%esi
  802617:	74 1f                	je     802638 <__udivdi3+0x118>
  802619:	89 f8                	mov    %edi,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	e9 7a ff ff ff       	jmp    80259c <__udivdi3+0x7c>
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	31 d2                	xor    %edx,%edx
  80262a:	b8 01 00 00 00       	mov    $0x1,%eax
  80262f:	e9 68 ff ff ff       	jmp    80259c <__udivdi3+0x7c>
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	8d 47 ff             	lea    -0x1(%edi),%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	83 c4 0c             	add    $0xc,%esp
  802640:	5e                   	pop    %esi
  802641:	5f                   	pop    %edi
  802642:	5d                   	pop    %ebp
  802643:	c3                   	ret    
  802644:	66 90                	xchg   %ax,%ax
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__umoddi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	83 ec 14             	sub    $0x14,%esp
  802656:	8b 44 24 28          	mov    0x28(%esp),%eax
  80265a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80265e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802662:	89 c7                	mov    %eax,%edi
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	8b 44 24 30          	mov    0x30(%esp),%eax
  80266c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802670:	89 34 24             	mov    %esi,(%esp)
  802673:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802677:	85 c0                	test   %eax,%eax
  802679:	89 c2                	mov    %eax,%edx
  80267b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80267f:	75 17                	jne    802698 <__umoddi3+0x48>
  802681:	39 fe                	cmp    %edi,%esi
  802683:	76 4b                	jbe    8026d0 <__umoddi3+0x80>
  802685:	89 c8                	mov    %ecx,%eax
  802687:	89 fa                	mov    %edi,%edx
  802689:	f7 f6                	div    %esi
  80268b:	89 d0                	mov    %edx,%eax
  80268d:	31 d2                	xor    %edx,%edx
  80268f:	83 c4 14             	add    $0x14,%esp
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    
  802696:	66 90                	xchg   %ax,%ax
  802698:	39 f8                	cmp    %edi,%eax
  80269a:	77 54                	ja     8026f0 <__umoddi3+0xa0>
  80269c:	0f bd e8             	bsr    %eax,%ebp
  80269f:	83 f5 1f             	xor    $0x1f,%ebp
  8026a2:	75 5c                	jne    802700 <__umoddi3+0xb0>
  8026a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8026a8:	39 3c 24             	cmp    %edi,(%esp)
  8026ab:	0f 87 e7 00 00 00    	ja     802798 <__umoddi3+0x148>
  8026b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026b5:	29 f1                	sub    %esi,%ecx
  8026b7:	19 c7                	sbb    %eax,%edi
  8026b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026c9:	83 c4 14             	add    $0x14,%esp
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	85 f6                	test   %esi,%esi
  8026d2:	89 f5                	mov    %esi,%ebp
  8026d4:	75 0b                	jne    8026e1 <__umoddi3+0x91>
  8026d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026db:	31 d2                	xor    %edx,%edx
  8026dd:	f7 f6                	div    %esi
  8026df:	89 c5                	mov    %eax,%ebp
  8026e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026e5:	31 d2                	xor    %edx,%edx
  8026e7:	f7 f5                	div    %ebp
  8026e9:	89 c8                	mov    %ecx,%eax
  8026eb:	f7 f5                	div    %ebp
  8026ed:	eb 9c                	jmp    80268b <__umoddi3+0x3b>
  8026ef:	90                   	nop
  8026f0:	89 c8                	mov    %ecx,%eax
  8026f2:	89 fa                	mov    %edi,%edx
  8026f4:	83 c4 14             	add    $0x14,%esp
  8026f7:	5e                   	pop    %esi
  8026f8:	5f                   	pop    %edi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    
  8026fb:	90                   	nop
  8026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802700:	8b 04 24             	mov    (%esp),%eax
  802703:	be 20 00 00 00       	mov    $0x20,%esi
  802708:	89 e9                	mov    %ebp,%ecx
  80270a:	29 ee                	sub    %ebp,%esi
  80270c:	d3 e2                	shl    %cl,%edx
  80270e:	89 f1                	mov    %esi,%ecx
  802710:	d3 e8                	shr    %cl,%eax
  802712:	89 e9                	mov    %ebp,%ecx
  802714:	89 44 24 04          	mov    %eax,0x4(%esp)
  802718:	8b 04 24             	mov    (%esp),%eax
  80271b:	09 54 24 04          	or     %edx,0x4(%esp)
  80271f:	89 fa                	mov    %edi,%edx
  802721:	d3 e0                	shl    %cl,%eax
  802723:	89 f1                	mov    %esi,%ecx
  802725:	89 44 24 08          	mov    %eax,0x8(%esp)
  802729:	8b 44 24 10          	mov    0x10(%esp),%eax
  80272d:	d3 ea                	shr    %cl,%edx
  80272f:	89 e9                	mov    %ebp,%ecx
  802731:	d3 e7                	shl    %cl,%edi
  802733:	89 f1                	mov    %esi,%ecx
  802735:	d3 e8                	shr    %cl,%eax
  802737:	89 e9                	mov    %ebp,%ecx
  802739:	09 f8                	or     %edi,%eax
  80273b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80273f:	f7 74 24 04          	divl   0x4(%esp)
  802743:	d3 e7                	shl    %cl,%edi
  802745:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802749:	89 d7                	mov    %edx,%edi
  80274b:	f7 64 24 08          	mull   0x8(%esp)
  80274f:	39 d7                	cmp    %edx,%edi
  802751:	89 c1                	mov    %eax,%ecx
  802753:	89 14 24             	mov    %edx,(%esp)
  802756:	72 2c                	jb     802784 <__umoddi3+0x134>
  802758:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80275c:	72 22                	jb     802780 <__umoddi3+0x130>
  80275e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802762:	29 c8                	sub    %ecx,%eax
  802764:	19 d7                	sbb    %edx,%edi
  802766:	89 e9                	mov    %ebp,%ecx
  802768:	89 fa                	mov    %edi,%edx
  80276a:	d3 e8                	shr    %cl,%eax
  80276c:	89 f1                	mov    %esi,%ecx
  80276e:	d3 e2                	shl    %cl,%edx
  802770:	89 e9                	mov    %ebp,%ecx
  802772:	d3 ef                	shr    %cl,%edi
  802774:	09 d0                	or     %edx,%eax
  802776:	89 fa                	mov    %edi,%edx
  802778:	83 c4 14             	add    $0x14,%esp
  80277b:	5e                   	pop    %esi
  80277c:	5f                   	pop    %edi
  80277d:	5d                   	pop    %ebp
  80277e:	c3                   	ret    
  80277f:	90                   	nop
  802780:	39 d7                	cmp    %edx,%edi
  802782:	75 da                	jne    80275e <__umoddi3+0x10e>
  802784:	8b 14 24             	mov    (%esp),%edx
  802787:	89 c1                	mov    %eax,%ecx
  802789:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80278d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802791:	eb cb                	jmp    80275e <__umoddi3+0x10e>
  802793:	90                   	nop
  802794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802798:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80279c:	0f 82 0f ff ff ff    	jb     8026b1 <__umoddi3+0x61>
  8027a2:	e9 1a ff ff ff       	jmp    8026c1 <__umoddi3+0x71>
