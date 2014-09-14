
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
  80002c:	e8 7a 00 00 00       	call   8000ab <libmain>
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
  800045:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  80004c:	e8 e4 01 00 00       	call   800235 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 3e 28 80 	movl   $0x80283e,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 3e 28 80 00 	movl   $0x80283e,(%esp)
  800068:	e8 c8 1d 00 00       	call   801e35 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 44 28 80 	movl   $0x802844,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 5c 28 80 00 	movl   $0x80285c,(%esp)
  80008c:	e8 ab 00 00 00       	call   80013c <_panic>
	cprintf("%08x exit.\n", thisenv->env_id);
  800091:	a1 04 40 80 00       	mov    0x804004,%eax
  800096:	8b 40 48             	mov    0x48(%eax),%eax
  800099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009d:	c7 04 24 6e 28 80 00 	movl   $0x80286e,(%esp)
  8000a4:	e8 8c 01 00 00       	call   800235 <cprintf>
}
  8000a9:	c9                   	leave  
  8000aa:	c3                   	ret    

008000ab <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	83 ec 10             	sub    $0x10,%esp
  8000b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000b6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000b9:	e8 3d 0c 00 00       	call   800cfb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000be:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000c4:	39 c2                	cmp    %eax,%edx
  8000c6:	74 17                	je     8000df <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000c8:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000cd:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000d0:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000d6:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000d9:	39 c1                	cmp    %eax,%ecx
  8000db:	75 18                	jne    8000f5 <libmain+0x4a>
  8000dd:	eb 05                	jmp    8000e4 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000e4:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000e7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000ed:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000f3:	eb 0b                	jmp    800100 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000f5:	83 c2 01             	add    $0x1,%edx
  8000f8:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000fe:	75 cd                	jne    8000cd <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800100:	85 db                	test   %ebx,%ebx
  800102:	7e 07                	jle    80010b <libmain+0x60>
		binaryname = argv[0];
  800104:	8b 06                	mov    (%esi),%eax
  800106:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80010b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010f:	89 1c 24             	mov    %ebx,(%esp)
  800112:	e8 1c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800117:	e8 07 00 00 00       	call   800123 <exit>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800129:	e8 98 10 00 00       	call   8011c6 <close_all>
	sys_env_destroy(0);
  80012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800135:	e8 6f 0b 00 00       	call   800ca9 <sys_env_destroy>
}
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
  800141:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800144:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800147:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014d:	e8 a9 0b 00 00       	call   800cfb <sys_getenvid>
  800152:	8b 55 0c             	mov    0xc(%ebp),%edx
  800155:	89 54 24 10          	mov    %edx,0x10(%esp)
  800159:	8b 55 08             	mov    0x8(%ebp),%edx
  80015c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800160:	89 74 24 08          	mov    %esi,0x8(%esp)
  800164:	89 44 24 04          	mov    %eax,0x4(%esp)
  800168:	c7 04 24 84 28 80 00 	movl   $0x802884,(%esp)
  80016f:	e8 c1 00 00 00       	call   800235 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800174:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800178:	8b 45 10             	mov    0x10(%ebp),%eax
  80017b:	89 04 24             	mov    %eax,(%esp)
  80017e:	e8 51 00 00 00       	call   8001d4 <vcprintf>
	cprintf("\n");
  800183:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  80018a:	e8 a6 00 00 00       	call   800235 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018f:	cc                   	int3   
  800190:	eb fd                	jmp    80018f <_panic+0x53>

00800192 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	53                   	push   %ebx
  800196:	83 ec 14             	sub    $0x14,%esp
  800199:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019c:	8b 13                	mov    (%ebx),%edx
  80019e:	8d 42 01             	lea    0x1(%edx),%eax
  8001a1:	89 03                	mov    %eax,(%ebx)
  8001a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001af:	75 19                	jne    8001ca <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001b8:	00 
  8001b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bc:	89 04 24             	mov    %eax,(%esp)
  8001bf:	e8 a8 0a 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  8001c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ca:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ce:	83 c4 14             	add    $0x14,%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e4:	00 00 00 
	b.cnt = 0;
  8001e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800205:	89 44 24 04          	mov    %eax,0x4(%esp)
  800209:	c7 04 24 92 01 80 00 	movl   $0x800192,(%esp)
  800210:	e8 af 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800215:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	e8 3f 0a 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  80022d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800242:	8b 45 08             	mov    0x8(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 87 ff ff ff       	call   8001d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    
  80024f:	90                   	nop

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 3c             	sub    $0x3c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800264:	8b 75 0c             	mov    0xc(%ebp),%esi
  800267:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800275:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800278:	39 f1                	cmp    %esi,%ecx
  80027a:	72 14                	jb     800290 <printnum+0x40>
  80027c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80027f:	76 0f                	jbe    800290 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800281:	8b 45 14             	mov    0x14(%ebp),%eax
  800284:	8d 70 ff             	lea    -0x1(%eax),%esi
  800287:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028a:	85 f6                	test   %esi,%esi
  80028c:	7f 60                	jg     8002ee <printnum+0x9e>
  80028e:	eb 72                	jmp    800302 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800290:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800293:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800297:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80029a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80029d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002a9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002ad:	89 c3                	mov    %eax,%ebx
  8002af:	89 d6                	mov    %edx,%esi
  8002b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	e8 bf 22 00 00       	call   802590 <__udivdi3>
  8002d1:	89 d9                	mov    %ebx,%ecx
  8002d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002db:	89 04 24             	mov    %eax,(%esp)
  8002de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e2:	89 fa                	mov    %edi,%edx
  8002e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e7:	e8 64 ff ff ff       	call   800250 <printnum>
  8002ec:	eb 14                	jmp    800302 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002fa:	83 ee 01             	sub    $0x1,%esi
  8002fd:	75 ef                	jne    8002ee <printnum+0x9e>
  8002ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800302:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800306:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80030a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80030d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800310:	89 44 24 08          	mov    %eax,0x8(%esp)
  800314:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	e8 96 23 00 00       	call   8026c0 <__umoddi3>
  80032a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80032e:	0f be 80 a7 28 80 00 	movsbl 0x8028a7(%eax),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033b:	ff d0                	call   *%eax
}
  80033d:	83 c4 3c             	add    $0x3c,%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800348:	83 fa 01             	cmp    $0x1,%edx
  80034b:	7e 0e                	jle    80035b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80034d:	8b 10                	mov    (%eax),%edx
  80034f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800352:	89 08                	mov    %ecx,(%eax)
  800354:	8b 02                	mov    (%edx),%eax
  800356:	8b 52 04             	mov    0x4(%edx),%edx
  800359:	eb 22                	jmp    80037d <getuint+0x38>
	else if (lflag)
  80035b:	85 d2                	test   %edx,%edx
  80035d:	74 10                	je     80036f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8d 4a 04             	lea    0x4(%edx),%ecx
  800364:	89 08                	mov    %ecx,(%eax)
  800366:	8b 02                	mov    (%edx),%eax
  800368:	ba 00 00 00 00       	mov    $0x0,%edx
  80036d:	eb 0e                	jmp    80037d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80036f:	8b 10                	mov    (%eax),%edx
  800371:	8d 4a 04             	lea    0x4(%edx),%ecx
  800374:	89 08                	mov    %ecx,(%eax)
  800376:	8b 02                	mov    (%edx),%eax
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800385:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	3b 50 04             	cmp    0x4(%eax),%edx
  80038e:	73 0a                	jae    80039a <sprintputch+0x1b>
		*b->buf++ = ch;
  800390:	8d 4a 01             	lea    0x1(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	88 02                	mov    %al,(%edx)
}
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 02 00 00 00       	call   8003c4 <vprintfmt>
	va_end(ap);
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d3:	eb 18                	jmp    8003ed <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	0f 84 c3 03 00 00    	je     8007a0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8003dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e7:	89 f3                	mov    %esi,%ebx
  8003e9:	eb 02                	jmp    8003ed <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003eb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f0:	0f b6 03             	movzbl (%ebx),%eax
  8003f3:	83 f8 25             	cmp    $0x25,%eax
  8003f6:	75 dd                	jne    8003d5 <vprintfmt+0x11>
  8003f8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800403:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80040a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	eb 1d                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80041a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80041e:	eb 15                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800420:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800422:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800426:	eb 0d                	jmp    800435 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8d 5e 01             	lea    0x1(%esi),%ebx
  800438:	0f b6 06             	movzbl (%esi),%eax
  80043b:	0f b6 c8             	movzbl %al,%ecx
  80043e:	83 e8 23             	sub    $0x23,%eax
  800441:	3c 55                	cmp    $0x55,%al
  800443:	0f 87 2f 03 00 00    	ja     800778 <vprintfmt+0x3b4>
  800449:	0f b6 c0             	movzbl %al,%eax
  80044c:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800453:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800456:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800459:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80045d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800460:	83 f9 09             	cmp    $0x9,%ecx
  800463:	77 50                	ja     8004b5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	89 de                	mov    %ebx,%esi
  800467:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80046a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80046d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800470:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800474:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800477:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047a:	83 fb 09             	cmp    $0x9,%ebx
  80047d:	76 eb                	jbe    80046a <vprintfmt+0xa6>
  80047f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800482:	eb 33                	jmp    8004b7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 48 04             	lea    0x4(%eax),%ecx
  80048a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800494:	eb 21                	jmp    8004b7 <vprintfmt+0xf3>
  800496:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800499:	85 c9                	test   %ecx,%ecx
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	0f 49 c1             	cmovns %ecx,%eax
  8004a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
  8004a8:	eb 8b                	jmp    800435 <vprintfmt+0x71>
  8004aa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004ac:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b3:	eb 80                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004bb:	0f 89 74 ff ff ff    	jns    800435 <vprintfmt+0x71>
  8004c1:	e9 62 ff ff ff       	jmp    800428 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cb:	e9 65 ff ff ff       	jmp    800435 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 04 24             	mov    %eax,(%esp)
  8004e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e5:	e9 03 ff ff ff       	jmp    8003ed <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 50 04             	lea    0x4(%eax),%edx
  8004f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	99                   	cltd   
  8004f6:	31 d0                	xor    %edx,%eax
  8004f8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fa:	83 f8 0f             	cmp    $0xf,%eax
  8004fd:	7f 0b                	jg     80050a <vprintfmt+0x146>
  8004ff:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  800506:	85 d2                	test   %edx,%edx
  800508:	75 20                	jne    80052a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80050a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050e:	c7 44 24 08 bf 28 80 	movl   $0x8028bf,0x8(%esp)
  800515:	00 
  800516:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 77 fe ff ff       	call   80039c <printfmt>
  800525:	e9 c3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80052a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052e:	c7 44 24 08 5f 2c 80 	movl   $0x802c5f,0x8(%esp)
  800535:	00 
  800536:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 57 fe ff ff       	call   80039c <printfmt>
  800545:	e9 a3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 50 04             	lea    0x4(%eax),%edx
  800556:	89 55 14             	mov    %edx,0x14(%ebp)
  800559:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80055b:	85 c0                	test   %eax,%eax
  80055d:	ba b8 28 80 00       	mov    $0x8028b8,%edx
  800562:	0f 45 d0             	cmovne %eax,%edx
  800565:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800568:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80056c:	74 04                	je     800572 <vprintfmt+0x1ae>
  80056e:	85 f6                	test   %esi,%esi
  800570:	7f 19                	jg     80058b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800572:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800575:	8d 70 01             	lea    0x1(%eax),%esi
  800578:	0f b6 10             	movzbl (%eax),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	0f 85 95 00 00 00    	jne    80061b <vprintfmt+0x257>
  800586:	e9 85 00 00 00       	jmp    800610 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80058f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800592:	89 04 24             	mov    %eax,(%esp)
  800595:	e8 b8 02 00 00       	call   800852 <strnlen>
  80059a:	29 c6                	sub    %eax,%esi
  80059c:	89 f0                	mov    %esi,%eax
  80059e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005a1:	85 f6                	test   %esi,%esi
  8005a3:	7e cd                	jle    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005a5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ac:	89 c3                	mov    %eax,%ebx
  8005ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b2:	89 34 24             	mov    %esi,(%esp)
  8005b5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	83 eb 01             	sub    $0x1,%ebx
  8005bb:	75 f1                	jne    8005ae <vprintfmt+0x1ea>
  8005bd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c3:	eb ad                	jmp    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c9:	74 1e                	je     8005e9 <vprintfmt+0x225>
  8005cb:	0f be d2             	movsbl %dl,%edx
  8005ce:	83 ea 20             	sub    $0x20,%edx
  8005d1:	83 fa 5e             	cmp    $0x5e,%edx
  8005d4:	76 13                	jbe    8005e9 <vprintfmt+0x225>
					putch('?', putdat);
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e4:	ff 55 08             	call   *0x8(%ebp)
  8005e7:	eb 0d                	jmp    8005f6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f6:	83 ef 01             	sub    $0x1,%edi
  8005f9:	83 c6 01             	add    $0x1,%esi
  8005fc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800600:	0f be c2             	movsbl %dl,%eax
  800603:	85 c0                	test   %eax,%eax
  800605:	75 20                	jne    800627 <vprintfmt+0x263>
  800607:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80060a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800614:	7f 25                	jg     80063b <vprintfmt+0x277>
  800616:	e9 d2 fd ff ff       	jmp    8003ed <vprintfmt+0x29>
  80061b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800621:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800624:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800627:	85 db                	test   %ebx,%ebx
  800629:	78 9a                	js     8005c5 <vprintfmt+0x201>
  80062b:	83 eb 01             	sub    $0x1,%ebx
  80062e:	79 95                	jns    8005c5 <vprintfmt+0x201>
  800630:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800633:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800636:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800639:	eb d5                	jmp    800610 <vprintfmt+0x24c>
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800644:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800648:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80064f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800651:	83 eb 01             	sub    $0x1,%ebx
  800654:	75 ee                	jne    800644 <vprintfmt+0x280>
  800656:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800659:	e9 8f fd ff ff       	jmp    8003ed <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80065e:	83 fa 01             	cmp    $0x1,%edx
  800661:	7e 16                	jle    800679 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	89 55 14             	mov    %edx,0x14(%ebp)
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	eb 32                	jmp    8006ab <vprintfmt+0x2e7>
	else if (lflag)
  800679:	85 d2                	test   %edx,%edx
  80067b:	74 18                	je     800695 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)
  800686:	8b 30                	mov    (%eax),%esi
  800688:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	c1 f8 1f             	sar    $0x1f,%eax
  800690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800693:	eb 16                	jmp    8006ab <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 30                	mov    (%eax),%esi
  8006a0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	c1 f8 1f             	sar    $0x1f,%eax
  8006a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ba:	0f 89 80 00 00 00    	jns    800740 <vprintfmt+0x37c>
				putch('-', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d4:	f7 d8                	neg    %eax
  8006d6:	83 d2 00             	adc    $0x0,%edx
  8006d9:	f7 da                	neg    %edx
			}
			base = 10;
  8006db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e0:	eb 5e                	jmp    800740 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e5:	e8 5b fc ff ff       	call   800345 <getuint>
			base = 10;
  8006ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ef:	eb 4f                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f4:	e8 4c fc ff ff       	call   800345 <getuint>
			base = 8;
  8006f9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006fe:	eb 40                	jmp    800740 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80070e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800712:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800719:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800731:	eb 0d                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800733:	8d 45 14             	lea    0x14(%ebp),%eax
  800736:	e8 0a fc ff ff       	call   800345 <getuint>
			base = 16;
  80073b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800740:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800744:	89 74 24 10          	mov    %esi,0x10(%esp)
  800748:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80074b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80074f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800753:	89 04 24             	mov    %eax,(%esp)
  800756:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075a:	89 fa                	mov    %edi,%edx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	e8 ec fa ff ff       	call   800250 <printnum>
			break;
  800764:	e9 84 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800769:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076d:	89 0c 24             	mov    %ecx,(%esp)
  800770:	ff 55 08             	call   *0x8(%ebp)
			break;
  800773:	e9 75 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800778:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800783:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800786:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80078a:	0f 84 5b fc ff ff    	je     8003eb <vprintfmt+0x27>
  800790:	89 f3                	mov    %esi,%ebx
  800792:	83 eb 01             	sub    $0x1,%ebx
  800795:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800799:	75 f7                	jne    800792 <vprintfmt+0x3ce>
  80079b:	e9 4d fc ff ff       	jmp    8003ed <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007a0:	83 c4 3c             	add    $0x3c,%esp
  8007a3:	5b                   	pop    %ebx
  8007a4:	5e                   	pop    %esi
  8007a5:	5f                   	pop    %edi
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 28             	sub    $0x28,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 30                	je     8007f9 <vsnprintf+0x51>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 2c                	jle    8007f9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e2:	c7 04 24 7f 03 80 00 	movl   $0x80037f,(%esp)
  8007e9:	e8 d6 fb ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	eb 05                	jmp    8007fe <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800806:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800809:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	89 44 24 08          	mov    %eax,0x8(%esp)
  800814:	8b 45 0c             	mov    0xc(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	e8 82 ff ff ff       	call   8007a8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	80 3a 00             	cmpb   $0x0,(%edx)
  800839:	74 10                	je     80084b <strlen+0x1b>
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <strlen+0x10>
  800849:	eb 05                	jmp    800850 <strlen+0x20>
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	85 c9                	test   %ecx,%ecx
  80085e:	74 1c                	je     80087c <strnlen+0x2a>
  800860:	80 3b 00             	cmpb   $0x0,(%ebx)
  800863:	74 1e                	je     800883 <strnlen+0x31>
  800865:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80086a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086c:	39 ca                	cmp    %ecx,%edx
  80086e:	74 18                	je     800888 <strnlen+0x36>
  800870:	83 c2 01             	add    $0x1,%edx
  800873:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800878:	75 f0                	jne    80086a <strnlen+0x18>
  80087a:	eb 0c                	jmp    800888 <strnlen+0x36>
  80087c:	b8 00 00 00 00       	mov    $0x0,%eax
  800881:	eb 05                	jmp    800888 <strnlen+0x36>
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800895:	89 c2                	mov    %eax,%edx
  800897:	83 c2 01             	add    $0x1,%edx
  80089a:	83 c1 01             	add    $0x1,%ecx
  80089d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a4:	84 db                	test   %bl,%bl
  8008a6:	75 ef                	jne    800897 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b5:	89 1c 24             	mov    %ebx,(%esp)
  8008b8:	e8 73 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c4:	01 d8                	add    %ebx,%eax
  8008c6:	89 04 24             	mov    %eax,(%esp)
  8008c9:	e8 bd ff ff ff       	call   80088b <strcpy>
	return dst;
}
  8008ce:	89 d8                	mov    %ebx,%eax
  8008d0:	83 c4 08             	add    $0x8,%esp
  8008d3:	5b                   	pop    %ebx
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	8b 75 08             	mov    0x8(%ebp),%esi
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e4:	85 db                	test   %ebx,%ebx
  8008e6:	74 17                	je     8008ff <strncpy+0x29>
  8008e8:	01 f3                	add    %esi,%ebx
  8008ea:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008ec:	83 c1 01             	add    $0x1,%ecx
  8008ef:	0f b6 02             	movzbl (%edx),%eax
  8008f2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008f8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fb:	39 d9                	cmp    %ebx,%ecx
  8008fd:	75 ed                	jne    8008ec <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800911:	8b 75 10             	mov    0x10(%ebp),%esi
  800914:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800916:	85 f6                	test   %esi,%esi
  800918:	74 34                	je     80094e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80091a:	83 fe 01             	cmp    $0x1,%esi
  80091d:	74 26                	je     800945 <strlcpy+0x40>
  80091f:	0f b6 0b             	movzbl (%ebx),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	74 23                	je     800949 <strlcpy+0x44>
  800926:	83 ee 02             	sub    $0x2,%esi
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800934:	39 f2                	cmp    %esi,%edx
  800936:	74 13                	je     80094b <strlcpy+0x46>
  800938:	83 c2 01             	add    $0x1,%edx
  80093b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 eb                	jne    80092e <strlcpy+0x29>
  800943:	eb 06                	jmp    80094b <strlcpy+0x46>
  800945:	89 f8                	mov    %edi,%eax
  800947:	eb 02                	jmp    80094b <strlcpy+0x46>
  800949:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80094b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094e:	29 f8                	sub    %edi,%eax
}
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095e:	0f b6 01             	movzbl (%ecx),%eax
  800961:	84 c0                	test   %al,%al
  800963:	74 15                	je     80097a <strcmp+0x25>
  800965:	3a 02                	cmp    (%edx),%al
  800967:	75 11                	jne    80097a <strcmp+0x25>
		p++, q++;
  800969:	83 c1 01             	add    $0x1,%ecx
  80096c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80096f:	0f b6 01             	movzbl (%ecx),%eax
  800972:	84 c0                	test   %al,%al
  800974:	74 04                	je     80097a <strcmp+0x25>
  800976:	3a 02                	cmp    (%edx),%al
  800978:	74 ef                	je     800969 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097a:	0f b6 c0             	movzbl %al,%eax
  80097d:	0f b6 12             	movzbl (%edx),%edx
  800980:	29 d0                	sub    %edx,%eax
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800992:	85 f6                	test   %esi,%esi
  800994:	74 29                	je     8009bf <strncmp+0x3b>
  800996:	0f b6 03             	movzbl (%ebx),%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 30                	je     8009cd <strncmp+0x49>
  80099d:	3a 02                	cmp    (%edx),%al
  80099f:	75 2c                	jne    8009cd <strncmp+0x49>
  8009a1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009a4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ab:	39 f0                	cmp    %esi,%eax
  8009ad:	74 17                	je     8009c6 <strncmp+0x42>
  8009af:	0f b6 08             	movzbl (%eax),%ecx
  8009b2:	84 c9                	test   %cl,%cl
  8009b4:	74 17                	je     8009cd <strncmp+0x49>
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	3a 0a                	cmp    (%edx),%cl
  8009bb:	74 e9                	je     8009a6 <strncmp+0x22>
  8009bd:	eb 0e                	jmp    8009cd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	eb 0f                	jmp    8009d5 <strncmp+0x51>
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 08                	jmp    8009d5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 03             	movzbl (%ebx),%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009e3:	0f b6 18             	movzbl (%eax),%ebx
  8009e6:	84 db                	test   %bl,%bl
  8009e8:	74 1d                	je     800a07 <strchr+0x2e>
  8009ea:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009ec:	38 d3                	cmp    %dl,%bl
  8009ee:	75 06                	jne    8009f6 <strchr+0x1d>
  8009f0:	eb 1a                	jmp    800a0c <strchr+0x33>
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 16                	je     800a0c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	0f b6 10             	movzbl (%eax),%edx
  8009fc:	84 d2                	test   %dl,%dl
  8009fe:	75 f2                	jne    8009f2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb 05                	jmp    800a0c <strchr+0x33>
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0c:	5b                   	pop    %ebx
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a19:	0f b6 18             	movzbl (%eax),%ebx
  800a1c:	84 db                	test   %bl,%bl
  800a1e:	74 16                	je     800a36 <strfind+0x27>
  800a20:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a22:	38 d3                	cmp    %dl,%bl
  800a24:	75 06                	jne    800a2c <strfind+0x1d>
  800a26:	eb 0e                	jmp    800a36 <strfind+0x27>
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 0a                	je     800a36 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	0f b6 10             	movzbl (%eax),%edx
  800a32:	84 d2                	test   %dl,%dl
  800a34:	75 f2                	jne    800a28 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a45:	85 c9                	test   %ecx,%ecx
  800a47:	74 36                	je     800a7f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a49:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4f:	75 28                	jne    800a79 <memset+0x40>
  800a51:	f6 c1 03             	test   $0x3,%cl
  800a54:	75 23                	jne    800a79 <memset+0x40>
		c &= 0xFF;
  800a56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5a:	89 d3                	mov    %edx,%ebx
  800a5c:	c1 e3 08             	shl    $0x8,%ebx
  800a5f:	89 d6                	mov    %edx,%esi
  800a61:	c1 e6 18             	shl    $0x18,%esi
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	c1 e0 10             	shl    $0x10,%eax
  800a69:	09 f0                	or     %esi,%eax
  800a6b:	09 c2                	or     %eax,%edx
  800a6d:	89 d0                	mov    %edx,%eax
  800a6f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a71:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a74:	fc                   	cld    
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
  800a77:	eb 06                	jmp    800a7f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	fc                   	cld    
  800a7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7f:	89 f8                	mov    %edi,%eax
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5f                   	pop    %edi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	57                   	push   %edi
  800a8a:	56                   	push   %esi
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a94:	39 c6                	cmp    %eax,%esi
  800a96:	73 35                	jae    800acd <memmove+0x47>
  800a98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 2e                	jae    800acd <memmove+0x47>
		s += n;
		d += n;
  800a9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aac:	75 13                	jne    800ac1 <memmove+0x3b>
  800aae:	f6 c1 03             	test   $0x3,%cl
  800ab1:	75 0e                	jne    800ac1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab3:	83 ef 04             	sub    $0x4,%edi
  800ab6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800abc:	fd                   	std    
  800abd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abf:	eb 09                	jmp    800aca <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac1:	83 ef 01             	sub    $0x1,%edi
  800ac4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac7:	fd                   	std    
  800ac8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aca:	fc                   	cld    
  800acb:	eb 1d                	jmp    800aea <memmove+0x64>
  800acd:	89 f2                	mov    %esi,%edx
  800acf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0f                	jne    800ae5 <memmove+0x5f>
  800ad6:	f6 c1 03             	test   $0x3,%cl
  800ad9:	75 0a                	jne    800ae5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800adb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae3:	eb 05                	jmp    800aea <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae5:	89 c7                	mov    %eax,%edi
  800ae7:	fc                   	cld    
  800ae8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af4:	8b 45 10             	mov    0x10(%ebp),%eax
  800af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	89 04 24             	mov    %eax,(%esp)
  800b08:	e8 79 ff ff ff       	call   800a86 <memmove>
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	57                   	push   %edi
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b21:	85 c0                	test   %eax,%eax
  800b23:	74 36                	je     800b5b <memcmp+0x4c>
		if (*s1 != *s2)
  800b25:	0f b6 03             	movzbl (%ebx),%eax
  800b28:	0f b6 0e             	movzbl (%esi),%ecx
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	38 c8                	cmp    %cl,%al
  800b32:	74 1c                	je     800b50 <memcmp+0x41>
  800b34:	eb 10                	jmp    800b46 <memcmp+0x37>
  800b36:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b3b:	83 c2 01             	add    $0x1,%edx
  800b3e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b42:	38 c8                	cmp    %cl,%al
  800b44:	74 0a                	je     800b50 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b46:	0f b6 c0             	movzbl %al,%eax
  800b49:	0f b6 c9             	movzbl %cl,%ecx
  800b4c:	29 c8                	sub    %ecx,%eax
  800b4e:	eb 10                	jmp    800b60 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b50:	39 fa                	cmp    %edi,%edx
  800b52:	75 e2                	jne    800b36 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	eb 05                	jmp    800b60 <memcmp+0x51>
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	39 d0                	cmp    %edx,%eax
  800b76:	73 13                	jae    800b8b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b78:	89 d9                	mov    %ebx,%ecx
  800b7a:	38 18                	cmp    %bl,(%eax)
  800b7c:	75 06                	jne    800b84 <memfind+0x1f>
  800b7e:	eb 0b                	jmp    800b8b <memfind+0x26>
  800b80:	38 08                	cmp    %cl,(%eax)
  800b82:	74 07                	je     800b8b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	39 d0                	cmp    %edx,%eax
  800b89:	75 f5                	jne    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9a:	0f b6 0a             	movzbl (%edx),%ecx
  800b9d:	80 f9 09             	cmp    $0x9,%cl
  800ba0:	74 05                	je     800ba7 <strtol+0x19>
  800ba2:	80 f9 20             	cmp    $0x20,%cl
  800ba5:	75 10                	jne    800bb7 <strtol+0x29>
		s++;
  800ba7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baa:	0f b6 0a             	movzbl (%edx),%ecx
  800bad:	80 f9 09             	cmp    $0x9,%cl
  800bb0:	74 f5                	je     800ba7 <strtol+0x19>
  800bb2:	80 f9 20             	cmp    $0x20,%cl
  800bb5:	74 f0                	je     800ba7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bb7:	80 f9 2b             	cmp    $0x2b,%cl
  800bba:	75 0a                	jne    800bc6 <strtol+0x38>
		s++;
  800bbc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc4:	eb 11                	jmp    800bd7 <strtol+0x49>
  800bc6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bcb:	80 f9 2d             	cmp    $0x2d,%cl
  800bce:	75 07                	jne    800bd7 <strtol+0x49>
		s++, neg = 1;
  800bd0:	83 c2 01             	add    $0x1,%edx
  800bd3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bdc:	75 15                	jne    800bf3 <strtol+0x65>
  800bde:	80 3a 30             	cmpb   $0x30,(%edx)
  800be1:	75 10                	jne    800bf3 <strtol+0x65>
  800be3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be7:	75 0a                	jne    800bf3 <strtol+0x65>
		s += 2, base = 16;
  800be9:	83 c2 02             	add    $0x2,%edx
  800bec:	b8 10 00 00 00       	mov    $0x10,%eax
  800bf1:	eb 10                	jmp    800c03 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	75 0c                	jne    800c03 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfc:	75 05                	jne    800c03 <strtol+0x75>
		s++, base = 8;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c08:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c0b:	0f b6 0a             	movzbl (%edx),%ecx
  800c0e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c11:	89 f0                	mov    %esi,%eax
  800c13:	3c 09                	cmp    $0x9,%al
  800c15:	77 08                	ja     800c1f <strtol+0x91>
			dig = *s - '0';
  800c17:	0f be c9             	movsbl %cl,%ecx
  800c1a:	83 e9 30             	sub    $0x30,%ecx
  800c1d:	eb 20                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c1f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c22:	89 f0                	mov    %esi,%eax
  800c24:	3c 19                	cmp    $0x19,%al
  800c26:	77 08                	ja     800c30 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c28:	0f be c9             	movsbl %cl,%ecx
  800c2b:	83 e9 57             	sub    $0x57,%ecx
  800c2e:	eb 0f                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c30:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c33:	89 f0                	mov    %esi,%eax
  800c35:	3c 19                	cmp    $0x19,%al
  800c37:	77 16                	ja     800c4f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c39:	0f be c9             	movsbl %cl,%ecx
  800c3c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c3f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c42:	7d 0f                	jge    800c53 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c44:	83 c2 01             	add    $0x1,%edx
  800c47:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c4b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c4d:	eb bc                	jmp    800c0b <strtol+0x7d>
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	eb 02                	jmp    800c55 <strtol+0xc7>
  800c53:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xd2>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c60:	f7 d8                	neg    %eax
  800c62:	85 ff                	test   %edi,%edi
  800c64:	0f 44 c3             	cmove  %ebx,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7e 28                	jle    800cf3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cd6:	00 
  800cd7:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800cde:	00 
  800cdf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ce6:	00 
  800ce7:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800cee:	e8 49 f4 ff ff       	call   80013c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf3:	83 c4 2c             	add    $0x2c,%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
  800d06:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0b:	89 d1                	mov    %edx,%ecx
  800d0d:	89 d3                	mov    %edx,%ebx
  800d0f:	89 d7                	mov    %edx,%edi
  800d11:	89 d6                	mov    %edx,%esi
  800d13:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_yield>:

void
sys_yield(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d20:	ba 00 00 00 00       	mov    $0x0,%edx
  800d25:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d42:	be 00 00 00 00       	mov    $0x0,%esi
  800d47:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d55:	89 f7                	mov    %esi,%edi
  800d57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800d80:	e8 b7 f3 ff ff       	call   80013c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da7:	8b 75 18             	mov    0x18(%ebp),%esi
  800daa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800dd3:	e8 64 f3 ff ff       	call   80013c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 06 00 00 00       	mov    $0x6,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800e26:	e8 11 f3 ff ff       	call   80013c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 08 00 00 00       	mov    $0x8,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800e79:	e8 be f2 ff ff       	call   80013c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	b8 09 00 00 00       	mov    $0x9,%eax
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7e 28                	jle    800ed1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ead:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800ebc:	00 
  800ebd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ec4:	00 
  800ec5:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800ecc:	e8 6b f2 ff ff       	call   80013c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed1:	83 c4 2c             	add    $0x2c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7e 28                	jle    800f24 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f00:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f07:	00 
  800f08:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800f0f:	00 
  800f10:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f17:	00 
  800f18:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800f1f:	e8 18 f2 ff ff       	call   80013c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f24:	83 c4 2c             	add    $0x2c,%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	be 00 00 00 00       	mov    $0x0,%esi
  800f37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f48:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	89 cb                	mov    %ecx,%ebx
  800f67:	89 cf                	mov    %ecx,%edi
  800f69:	89 ce                	mov    %ecx,%esi
  800f6b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	7e 28                	jle    800f99 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f71:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f75:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f7c:	00 
  800f7d:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800f84:	00 
  800f85:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f8c:	00 
  800f8d:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800f94:	e8 a3 f1 ff ff       	call   80013c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f99:	83 c4 2c             	add    $0x2c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
  800fa1:	66 90                	xchg   %ax,%ax
  800fa3:	66 90                	xchg   %ax,%ax
  800fa5:	66 90                	xchg   %ax,%ax
  800fa7:	66 90                	xchg   %ax,%ax
  800fa9:	66 90                	xchg   %ax,%ax
  800fab:	66 90                	xchg   %ax,%ax
  800fad:	66 90                	xchg   %ax,%ax
  800faf:	90                   	nop

00800fb0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fda:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800fdf:	a8 01                	test   $0x1,%al
  800fe1:	74 34                	je     801017 <fd_alloc+0x40>
  800fe3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800fe8:	a8 01                	test   $0x1,%al
  800fea:	74 32                	je     80101e <fd_alloc+0x47>
  800fec:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800ff1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff3:	89 c2                	mov    %eax,%edx
  800ff5:	c1 ea 16             	shr    $0x16,%edx
  800ff8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fff:	f6 c2 01             	test   $0x1,%dl
  801002:	74 1f                	je     801023 <fd_alloc+0x4c>
  801004:	89 c2                	mov    %eax,%edx
  801006:	c1 ea 0c             	shr    $0xc,%edx
  801009:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801010:	f6 c2 01             	test   $0x1,%dl
  801013:	75 1a                	jne    80102f <fd_alloc+0x58>
  801015:	eb 0c                	jmp    801023 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801017:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80101c:	eb 05                	jmp    801023 <fd_alloc+0x4c>
  80101e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	89 08                	mov    %ecx,(%eax)
			return 0;
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
  80102d:	eb 1a                	jmp    801049 <fd_alloc+0x72>
  80102f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801034:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801039:	75 b6                	jne    800ff1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801044:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801051:	83 f8 1f             	cmp    $0x1f,%eax
  801054:	77 36                	ja     80108c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801056:	c1 e0 0c             	shl    $0xc,%eax
  801059:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80105e:	89 c2                	mov    %eax,%edx
  801060:	c1 ea 16             	shr    $0x16,%edx
  801063:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106a:	f6 c2 01             	test   $0x1,%dl
  80106d:	74 24                	je     801093 <fd_lookup+0x48>
  80106f:	89 c2                	mov    %eax,%edx
  801071:	c1 ea 0c             	shr    $0xc,%edx
  801074:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107b:	f6 c2 01             	test   $0x1,%dl
  80107e:	74 1a                	je     80109a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801080:	8b 55 0c             	mov    0xc(%ebp),%edx
  801083:	89 02                	mov    %eax,(%edx)
	return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
  80108a:	eb 13                	jmp    80109f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80108c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801091:	eb 0c                	jmp    80109f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801093:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801098:	eb 05                	jmp    80109f <fd_lookup+0x54>
  80109a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 14             	sub    $0x14,%esp
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8010ae:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8010b4:	75 1e                	jne    8010d4 <dev_lookup+0x33>
  8010b6:	eb 0e                	jmp    8010c6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010b8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8010bd:	eb 0c                	jmp    8010cb <dev_lookup+0x2a>
  8010bf:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8010c4:	eb 05                	jmp    8010cb <dev_lookup+0x2a>
  8010c6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8010cb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d2:	eb 38                	jmp    80110c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8010d4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8010da:	74 dc                	je     8010b8 <dev_lookup+0x17>
  8010dc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8010e2:	74 db                	je     8010bf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010ea:	8b 52 48             	mov    0x48(%edx),%edx
  8010ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010f5:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  8010fc:	e8 34 f1 ff ff       	call   800235 <cprintf>
	*dev = 0;
  801101:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801107:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80110c:	83 c4 14             	add    $0x14,%esp
  80110f:	5b                   	pop    %ebx
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	83 ec 20             	sub    $0x20,%esp
  80111a:	8b 75 08             	mov    0x8(%ebp),%esi
  80111d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801120:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801123:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801127:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80112d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801130:	89 04 24             	mov    %eax,(%esp)
  801133:	e8 13 ff ff ff       	call   80104b <fd_lookup>
  801138:	85 c0                	test   %eax,%eax
  80113a:	78 05                	js     801141 <fd_close+0x2f>
	    || fd != fd2)
  80113c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80113f:	74 0c                	je     80114d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801141:	84 db                	test   %bl,%bl
  801143:	ba 00 00 00 00       	mov    $0x0,%edx
  801148:	0f 44 c2             	cmove  %edx,%eax
  80114b:	eb 3f                	jmp    80118c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80114d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801150:	89 44 24 04          	mov    %eax,0x4(%esp)
  801154:	8b 06                	mov    (%esi),%eax
  801156:	89 04 24             	mov    %eax,(%esp)
  801159:	e8 43 ff ff ff       	call   8010a1 <dev_lookup>
  80115e:	89 c3                	mov    %eax,%ebx
  801160:	85 c0                	test   %eax,%eax
  801162:	78 16                	js     80117a <fd_close+0x68>
		if (dev->dev_close)
  801164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801167:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80116a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80116f:	85 c0                	test   %eax,%eax
  801171:	74 07                	je     80117a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801173:	89 34 24             	mov    %esi,(%esp)
  801176:	ff d0                	call   *%eax
  801178:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80117a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801185:	e8 56 fc ff ff       	call   800de0 <sys_page_unmap>
	return r;
  80118a:	89 d8                	mov    %ebx,%eax
}
  80118c:	83 c4 20             	add    $0x20,%esp
  80118f:	5b                   	pop    %ebx
  801190:	5e                   	pop    %esi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801199:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	89 04 24             	mov    %eax,(%esp)
  8011a6:	e8 a0 fe ff ff       	call   80104b <fd_lookup>
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	85 d2                	test   %edx,%edx
  8011af:	78 13                	js     8011c4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011b8:	00 
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	89 04 24             	mov    %eax,(%esp)
  8011bf:	e8 4e ff ff ff       	call   801112 <fd_close>
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <close_all>:

void
close_all(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	53                   	push   %ebx
  8011ca:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d2:	89 1c 24             	mov    %ebx,(%esp)
  8011d5:	e8 b9 ff ff ff       	call   801193 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011da:	83 c3 01             	add    $0x1,%ebx
  8011dd:	83 fb 20             	cmp    $0x20,%ebx
  8011e0:	75 f0                	jne    8011d2 <close_all+0xc>
		close(i);
}
  8011e2:	83 c4 14             	add    $0x14,%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	89 04 24             	mov    %eax,(%esp)
  8011fe:	e8 48 fe ff ff       	call   80104b <fd_lookup>
  801203:	89 c2                	mov    %eax,%edx
  801205:	85 d2                	test   %edx,%edx
  801207:	0f 88 e1 00 00 00    	js     8012ee <dup+0x106>
		return r;
	close(newfdnum);
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 04 24             	mov    %eax,(%esp)
  801213:	e8 7b ff ff ff       	call   801193 <close>

	newfd = INDEX2FD(newfdnum);
  801218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80121b:	c1 e3 0c             	shl    $0xc,%ebx
  80121e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801227:	89 04 24             	mov    %eax,(%esp)
  80122a:	e8 91 fd ff ff       	call   800fc0 <fd2data>
  80122f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801231:	89 1c 24             	mov    %ebx,(%esp)
  801234:	e8 87 fd ff ff       	call   800fc0 <fd2data>
  801239:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80123b:	89 f0                	mov    %esi,%eax
  80123d:	c1 e8 16             	shr    $0x16,%eax
  801240:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801247:	a8 01                	test   $0x1,%al
  801249:	74 43                	je     80128e <dup+0xa6>
  80124b:	89 f0                	mov    %esi,%eax
  80124d:	c1 e8 0c             	shr    $0xc,%eax
  801250:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801257:	f6 c2 01             	test   $0x1,%dl
  80125a:	74 32                	je     80128e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801263:	25 07 0e 00 00       	and    $0xe07,%eax
  801268:	89 44 24 10          	mov    %eax,0x10(%esp)
  80126c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801270:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801277:	00 
  801278:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801283:	e8 05 fb ff ff       	call   800d8d <sys_page_map>
  801288:	89 c6                	mov    %eax,%esi
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 3e                	js     8012cc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80128e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801291:	89 c2                	mov    %eax,%edx
  801293:	c1 ea 0c             	shr    $0xc,%edx
  801296:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b2:	00 
  8012b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012be:	e8 ca fa ff ff       	call   800d8d <sys_page_map>
  8012c3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012c8:	85 f6                	test   %esi,%esi
  8012ca:	79 22                	jns    8012ee <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 04 fb ff ff       	call   800de0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e7:	e8 f4 fa ff ff       	call   800de0 <sys_page_unmap>
	return r;
  8012ec:	89 f0                	mov    %esi,%eax
}
  8012ee:	83 c4 3c             	add    $0x3c,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	53                   	push   %ebx
  8012fa:	83 ec 24             	sub    $0x24,%esp
  8012fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801300:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801303:	89 44 24 04          	mov    %eax,0x4(%esp)
  801307:	89 1c 24             	mov    %ebx,(%esp)
  80130a:	e8 3c fd ff ff       	call   80104b <fd_lookup>
  80130f:	89 c2                	mov    %eax,%edx
  801311:	85 d2                	test   %edx,%edx
  801313:	78 6d                	js     801382 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	89 04 24             	mov    %eax,(%esp)
  801324:	e8 78 fd ff ff       	call   8010a1 <dev_lookup>
  801329:	85 c0                	test   %eax,%eax
  80132b:	78 55                	js     801382 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	8b 50 08             	mov    0x8(%eax),%edx
  801333:	83 e2 03             	and    $0x3,%edx
  801336:	83 fa 01             	cmp    $0x1,%edx
  801339:	75 23                	jne    80135e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80133b:	a1 04 40 80 00       	mov    0x804004,%eax
  801340:	8b 40 48             	mov    0x48(%eax),%eax
  801343:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134b:	c7 04 24 0d 2c 80 00 	movl   $0x802c0d,(%esp)
  801352:	e8 de ee ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  801357:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135c:	eb 24                	jmp    801382 <read+0x8c>
	}
	if (!dev->dev_read)
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	8b 52 08             	mov    0x8(%edx),%edx
  801364:	85 d2                	test   %edx,%edx
  801366:	74 15                	je     80137d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80136f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801372:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801376:	89 04 24             	mov    %eax,(%esp)
  801379:	ff d2                	call   *%edx
  80137b:	eb 05                	jmp    801382 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80137d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801382:	83 c4 24             	add    $0x24,%esp
  801385:	5b                   	pop    %ebx
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	57                   	push   %edi
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
  80138e:	83 ec 1c             	sub    $0x1c,%esp
  801391:	8b 7d 08             	mov    0x8(%ebp),%edi
  801394:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801397:	85 f6                	test   %esi,%esi
  801399:	74 33                	je     8013ce <readn+0x46>
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a5:	89 f2                	mov    %esi,%edx
  8013a7:	29 c2                	sub    %eax,%edx
  8013a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013ad:	03 45 0c             	add    0xc(%ebp),%eax
  8013b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b4:	89 3c 24             	mov    %edi,(%esp)
  8013b7:	e8 3a ff ff ff       	call   8012f6 <read>
		if (m < 0)
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 1b                	js     8013db <readn+0x53>
			return m;
		if (m == 0)
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	74 11                	je     8013d5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013c4:	01 c3                	add    %eax,%ebx
  8013c6:	89 d8                	mov    %ebx,%eax
  8013c8:	39 f3                	cmp    %esi,%ebx
  8013ca:	72 d9                	jb     8013a5 <readn+0x1d>
  8013cc:	eb 0b                	jmp    8013d9 <readn+0x51>
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d3:	eb 06                	jmp    8013db <readn+0x53>
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	eb 02                	jmp    8013db <readn+0x53>
  8013d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013db:	83 c4 1c             	add    $0x1c,%esp
  8013de:	5b                   	pop    %ebx
  8013df:	5e                   	pop    %esi
  8013e0:	5f                   	pop    %edi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	53                   	push   %ebx
  8013e7:	83 ec 24             	sub    $0x24,%esp
  8013ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f4:	89 1c 24             	mov    %ebx,(%esp)
  8013f7:	e8 4f fc ff ff       	call   80104b <fd_lookup>
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	85 d2                	test   %edx,%edx
  801400:	78 68                	js     80146a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801405:	89 44 24 04          	mov    %eax,0x4(%esp)
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	89 04 24             	mov    %eax,(%esp)
  801411:	e8 8b fc ff ff       	call   8010a1 <dev_lookup>
  801416:	85 c0                	test   %eax,%eax
  801418:	78 50                	js     80146a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801421:	75 23                	jne    801446 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801423:	a1 04 40 80 00       	mov    0x804004,%eax
  801428:	8b 40 48             	mov    0x48(%eax),%eax
  80142b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801433:	c7 04 24 29 2c 80 00 	movl   $0x802c29,(%esp)
  80143a:	e8 f6 ed ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb 24                	jmp    80146a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 52 0c             	mov    0xc(%edx),%edx
  80144c:	85 d2                	test   %edx,%edx
  80144e:	74 15                	je     801465 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801450:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80145e:	89 04 24             	mov    %eax,(%esp)
  801461:	ff d2                	call   *%edx
  801463:	eb 05                	jmp    80146a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801465:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80146a:	83 c4 24             	add    $0x24,%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <seek>:

int
seek(int fdnum, off_t offset)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801476:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	89 04 24             	mov    %eax,(%esp)
  801483:	e8 c3 fb ff ff       	call   80104b <fd_lookup>
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 0e                	js     80149a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801492:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	83 ec 24             	sub    $0x24,%esp
  8014a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ad:	89 1c 24             	mov    %ebx,(%esp)
  8014b0:	e8 96 fb ff ff       	call   80104b <fd_lookup>
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	85 d2                	test   %edx,%edx
  8014b9:	78 61                	js     80151c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c5:	8b 00                	mov    (%eax),%eax
  8014c7:	89 04 24             	mov    %eax,(%esp)
  8014ca:	e8 d2 fb ff ff       	call   8010a1 <dev_lookup>
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 49                	js     80151c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014da:	75 23                	jne    8014ff <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014dc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e1:	8b 40 48             	mov    0x48(%eax),%eax
  8014e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ec:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  8014f3:	e8 3d ed ff ff       	call   800235 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fd:	eb 1d                	jmp    80151c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	8b 52 18             	mov    0x18(%edx),%edx
  801505:	85 d2                	test   %edx,%edx
  801507:	74 0e                	je     801517 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	ff d2                	call   *%edx
  801515:	eb 05                	jmp    80151c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801517:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80151c:	83 c4 24             	add    $0x24,%esp
  80151f:	5b                   	pop    %ebx
  801520:	5d                   	pop    %ebp
  801521:	c3                   	ret    

00801522 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	53                   	push   %ebx
  801526:	83 ec 24             	sub    $0x24,%esp
  801529:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 04 24             	mov    %eax,(%esp)
  801539:	e8 0d fb ff ff       	call   80104b <fd_lookup>
  80153e:	89 c2                	mov    %eax,%edx
  801540:	85 d2                	test   %edx,%edx
  801542:	78 52                	js     801596 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801544:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801547:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	89 04 24             	mov    %eax,(%esp)
  801553:	e8 49 fb ff ff       	call   8010a1 <dev_lookup>
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 3a                	js     801596 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801563:	74 2c                	je     801591 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801565:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801568:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80156f:	00 00 00 
	stat->st_isdir = 0;
  801572:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801579:	00 00 00 
	stat->st_dev = dev;
  80157c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801582:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801586:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801589:	89 14 24             	mov    %edx,(%esp)
  80158c:	ff 50 14             	call   *0x14(%eax)
  80158f:	eb 05                	jmp    801596 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801591:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801596:	83 c4 24             	add    $0x24,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ab:	00 
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	89 04 24             	mov    %eax,(%esp)
  8015b2:	e8 af 01 00 00       	call   801766 <open>
  8015b7:	89 c3                	mov    %eax,%ebx
  8015b9:	85 db                	test   %ebx,%ebx
  8015bb:	78 1b                	js     8015d8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c4:	89 1c 24             	mov    %ebx,(%esp)
  8015c7:	e8 56 ff ff ff       	call   801522 <fstat>
  8015cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ce:	89 1c 24             	mov    %ebx,(%esp)
  8015d1:	e8 bd fb ff ff       	call   801193 <close>
	return r;
  8015d6:	89 f0                	mov    %esi,%eax
}
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 10             	sub    $0x10,%esp
  8015e7:	89 c6                	mov    %eax,%esi
  8015e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015eb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015f2:	75 11                	jne    801605 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015fb:	e8 04 0f 00 00       	call   802504 <ipc_find_env>
  801600:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801605:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80160c:	00 
  80160d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801614:	00 
  801615:	89 74 24 04          	mov    %esi,0x4(%esp)
  801619:	a1 00 40 80 00       	mov    0x804000,%eax
  80161e:	89 04 24             	mov    %eax,(%esp)
  801621:	e8 78 0e 00 00       	call   80249e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801626:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80162d:	00 
  80162e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801639:	e8 f8 0d 00 00       	call   802436 <ipc_recv>
}
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	5b                   	pop    %ebx
  801642:	5e                   	pop    %esi
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    

00801645 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 14             	sub    $0x14,%esp
  80164c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
  801655:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	b8 05 00 00 00       	mov    $0x5,%eax
  801664:	e8 76 ff ff ff       	call   8015df <fsipc>
  801669:	89 c2                	mov    %eax,%edx
  80166b:	85 d2                	test   %edx,%edx
  80166d:	78 2b                	js     80169a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80166f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801676:	00 
  801677:	89 1c 24             	mov    %ebx,(%esp)
  80167a:	e8 0c f2 ff ff       	call   80088b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80167f:	a1 80 50 80 00       	mov    0x805080,%eax
  801684:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168a:	a1 84 50 80 00       	mov    0x805084,%eax
  80168f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	83 c4 14             	add    $0x14,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8016bb:	e8 1f ff ff ff       	call   8015df <fsipc>
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 10             	sub    $0x10,%esp
  8016ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e8:	e8 f2 fe ff ff       	call   8015df <fsipc>
  8016ed:	89 c3                	mov    %eax,%ebx
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 6a                	js     80175d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016f3:	39 c6                	cmp    %eax,%esi
  8016f5:	73 24                	jae    80171b <devfile_read+0x59>
  8016f7:	c7 44 24 0c 46 2c 80 	movl   $0x802c46,0xc(%esp)
  8016fe:	00 
  8016ff:	c7 44 24 08 4d 2c 80 	movl   $0x802c4d,0x8(%esp)
  801706:	00 
  801707:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80170e:	00 
  80170f:	c7 04 24 62 2c 80 00 	movl   $0x802c62,(%esp)
  801716:	e8 21 ea ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  80171b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801720:	7e 24                	jle    801746 <devfile_read+0x84>
  801722:	c7 44 24 0c 6d 2c 80 	movl   $0x802c6d,0xc(%esp)
  801729:	00 
  80172a:	c7 44 24 08 4d 2c 80 	movl   $0x802c4d,0x8(%esp)
  801731:	00 
  801732:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801739:	00 
  80173a:	c7 04 24 62 2c 80 00 	movl   $0x802c62,(%esp)
  801741:	e8 f6 e9 ff ff       	call   80013c <_panic>
	memmove(buf, &fsipcbuf, r);
  801746:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801751:	00 
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	89 04 24             	mov    %eax,(%esp)
  801758:	e8 29 f3 ff ff       	call   800a86 <memmove>
	return r;
}
  80175d:	89 d8                	mov    %ebx,%eax
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	53                   	push   %ebx
  80176a:	83 ec 24             	sub    $0x24,%esp
  80176d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801770:	89 1c 24             	mov    %ebx,(%esp)
  801773:	e8 b8 f0 ff ff       	call   800830 <strlen>
  801778:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80177d:	7f 60                	jg     8017df <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80177f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801782:	89 04 24             	mov    %eax,(%esp)
  801785:	e8 4d f8 ff ff       	call   800fd7 <fd_alloc>
  80178a:	89 c2                	mov    %eax,%edx
  80178c:	85 d2                	test   %edx,%edx
  80178e:	78 54                	js     8017e4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801790:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801794:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80179b:	e8 eb f0 ff ff       	call   80088b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b0:	e8 2a fe ff ff       	call   8015df <fsipc>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	79 17                	jns    8017d2 <open+0x6c>
		fd_close(fd, 0);
  8017bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017c2:	00 
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	89 04 24             	mov    %eax,(%esp)
  8017c9:	e8 44 f9 ff ff       	call   801112 <fd_close>
		return r;
  8017ce:	89 d8                	mov    %ebx,%eax
  8017d0:	eb 12                	jmp    8017e4 <open+0x7e>
	}
	return fd2num(fd);
  8017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 d3 f7 ff ff       	call   800fb0 <fd2num>
  8017dd:	eb 05                	jmp    8017e4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017df:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8017e4:	83 c4 24             	add    $0x24,%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    
  8017ea:	66 90                	xchg   %ax,%ax
  8017ec:	66 90                	xchg   %ax,%ax
  8017ee:	66 90                	xchg   %ax,%ax

008017f0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	57                   	push   %edi
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
  8017fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open. %s\n", prog);
  8017ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801803:	c7 04 24 79 2c 80 00 	movl   $0x802c79,(%esp)
  80180a:	e8 26 ea ff ff       	call   800235 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0) {
  80180f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801816:	00 
  801817:	89 1c 24             	mov    %ebx,(%esp)
  80181a:	e8 47 ff ff ff       	call   801766 <open>
  80181f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801825:	85 c0                	test   %eax,%eax
  801827:	79 17                	jns    801840 <spawn+0x50>
		cprintf("cannot\n");
  801829:	c7 04 24 83 2c 80 00 	movl   $0x802c83,(%esp)
  801830:	e8 00 ea ff ff       	call   800235 <cprintf>
		return r;
  801835:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80183b:	e9 ea 05 00 00       	jmp    801e2a <spawn+0x63a>
	}
	fd = r;

	cprintf("read elf header.\n");
  801840:	c7 04 24 8b 2c 80 00 	movl   $0x802c8b,(%esp)
  801847:	e8 e9 e9 ff ff       	call   800235 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80184c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801853:	00 
  801854:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80185a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801864:	89 04 24             	mov    %eax,(%esp)
  801867:	e8 1c fb ff ff       	call   801388 <readn>
  80186c:	3d 00 02 00 00       	cmp    $0x200,%eax
  801871:	75 0c                	jne    80187f <spawn+0x8f>
	    || elf->e_magic != ELF_MAGIC) {
  801873:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80187a:	45 4c 46 
  80187d:	74 36                	je     8018b5 <spawn+0xc5>
		close(fd);
  80187f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 06 f9 ff ff       	call   801193 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80188d:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801894:	46 
  801895:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	c7 04 24 9d 2c 80 00 	movl   $0x802c9d,(%esp)
  8018a6:	e8 8a e9 ff ff       	call   800235 <cprintf>
		return -E_NOT_EXEC;
  8018ab:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8018b0:	e9 75 05 00 00       	jmp    801e2a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
  8018b5:	c7 04 24 b7 2c 80 00 	movl   $0x802cb7,(%esp)
  8018bc:	e8 74 e9 ff ff       	call   800235 <cprintf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8018c1:	b8 07 00 00 00       	mov    $0x7,%eax
  8018c6:	cd 30                	int    $0x30
  8018c8:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8018ce:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	0f 88 ff 04 00 00    	js     801ddb <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8018dc:	89 c6                	mov    %eax,%esi
  8018de:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8018e4:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8018e7:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8018ed:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8018f3:	b9 11 00 00 00       	mov    $0x11,%ecx
  8018f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018fa:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801900:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  801906:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  80190d:	e8 23 e9 ff ff       	call   800235 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801912:	8b 45 0c             	mov    0xc(%ebp),%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	85 c0                	test   %eax,%eax
  801919:	74 38                	je     801953 <spawn+0x163>
  80191b:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801920:	be 00 00 00 00       	mov    $0x0,%esi
  801925:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801928:	89 04 24             	mov    %eax,(%esp)
  80192b:	e8 00 ef ff ff       	call   800830 <strlen>
  801930:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801934:	83 c3 01             	add    $0x1,%ebx
  801937:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80193e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801941:	85 c0                	test   %eax,%eax
  801943:	75 e3                	jne    801928 <spawn+0x138>
  801945:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80194b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801951:	eb 1e                	jmp    801971 <spawn+0x181>
  801953:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  80195a:	00 00 00 
  80195d:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801964:	00 00 00 
  801967:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80196c:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801971:	bf 00 10 40 00       	mov    $0x401000,%edi
  801976:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801978:	89 fa                	mov    %edi,%edx
  80197a:	83 e2 fc             	and    $0xfffffffc,%edx
  80197d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80198c:	8d 42 f8             	lea    -0x8(%edx),%eax
  80198f:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801994:	0f 86 49 04 00 00    	jbe    801de3 <spawn+0x5f3>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80199a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019a1:	00 
  8019a2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019a9:	00 
  8019aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b1:	e8 83 f3 ff ff       	call   800d39 <sys_page_alloc>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	0f 88 6c 04 00 00    	js     801e2a <spawn+0x63a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019be:	85 db                	test   %ebx,%ebx
  8019c0:	7e 46                	jle    801a08 <spawn+0x218>
  8019c2:	be 00 00 00 00       	mov    $0x0,%esi
  8019c7:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8019cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  8019d0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8019d6:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8019dc:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8019df:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	89 3c 24             	mov    %edi,(%esp)
  8019e9:	e8 9d ee ff ff       	call   80088b <strcpy>
		string_store += strlen(argv[i]) + 1;
  8019ee:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8019f1:	89 04 24             	mov    %eax,(%esp)
  8019f4:	e8 37 ee ff ff       	call   800830 <strlen>
  8019f9:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019fd:	83 c6 01             	add    $0x1,%esi
  801a00:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801a06:	75 c8                	jne    8019d0 <spawn+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801a08:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a0e:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801a14:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a1b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a21:	74 24                	je     801a47 <spawn+0x257>
  801a23:	c7 44 24 0c 48 2d 80 	movl   $0x802d48,0xc(%esp)
  801a2a:	00 
  801a2b:	c7 44 24 08 4d 2c 80 	movl   $0x802c4d,0x8(%esp)
  801a32:	00 
  801a33:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  801a3a:	00 
  801a3b:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  801a42:	e8 f5 e6 ff ff       	call   80013c <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a47:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a4d:	89 c8                	mov    %ecx,%eax
  801a4f:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801a54:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801a57:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a5d:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a60:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801a66:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a6c:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a73:	00 
  801a74:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801a7b:	ee 
  801a7c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801a82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a86:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a8d:	00 
  801a8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a95:	e8 f3 f2 ff ff       	call   800d8d <sys_page_map>
  801a9a:	89 c3                	mov    %eax,%ebx
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	0f 88 70 03 00 00    	js     801e14 <spawn+0x624>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801aa4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801aab:	00 
  801aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab3:	e8 28 f3 ff ff       	call   800de0 <sys_page_unmap>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 88 52 03 00 00    	js     801e14 <spawn+0x624>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801ac2:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  801ac9:	e8 67 e7 ff ff       	call   800235 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ace:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ad4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801adb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ae1:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801ae8:	00 
  801ae9:	0f 84 dc 01 00 00    	je     801ccb <spawn+0x4db>
  801aef:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801af6:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801af9:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801aff:	83 38 01             	cmpl   $0x1,(%eax)
  801b02:	0f 85 a2 01 00 00    	jne    801caa <spawn+0x4ba>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b08:	89 c1                	mov    %eax,%ecx
  801b0a:	8b 40 18             	mov    0x18(%eax),%eax
  801b0d:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b10:	83 f8 01             	cmp    $0x1,%eax
  801b13:	19 c0                	sbb    %eax,%eax
  801b15:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b1b:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801b22:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b29:	89 c8                	mov    %ecx,%eax
  801b2b:	8b 51 04             	mov    0x4(%ecx),%edx
  801b2e:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801b34:	8b 79 10             	mov    0x10(%ecx),%edi
  801b37:	8b 49 14             	mov    0x14(%ecx),%ecx
  801b3a:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801b40:	8b 40 08             	mov    0x8(%eax),%eax
  801b43:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801b49:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b4e:	74 14                	je     801b64 <spawn+0x374>
		va -= i;
  801b50:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801b56:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801b5c:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801b5e:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801b64:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801b6b:	0f 84 39 01 00 00    	je     801caa <spawn+0x4ba>
  801b71:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b76:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801b7b:	39 f7                	cmp    %esi,%edi
  801b7d:	77 31                	ja     801bb0 <spawn+0x3c0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801b7f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b85:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b89:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801b8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b93:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b99:	89 04 24             	mov    %eax,(%esp)
  801b9c:	e8 98 f1 ff ff       	call   800d39 <sys_page_alloc>
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	0f 89 ed 00 00 00    	jns    801c96 <spawn+0x4a6>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	e9 44 02 00 00       	jmp    801df4 <spawn+0x604>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bb0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bb7:	00 
  801bb8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bbf:	00 
  801bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc7:	e8 6d f1 ff ff       	call   800d39 <sys_page_alloc>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 88 16 02 00 00    	js     801dea <spawn+0x5fa>
  801bd4:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801bda:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 82 f8 ff ff       	call   801470 <seek>
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	0f 88 f8 01 00 00    	js     801dee <spawn+0x5fe>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801bf6:	89 f9                	mov    %edi,%ecx
  801bf8:	29 f1                	sub    %esi,%ecx
  801bfa:	89 c8                	mov    %ecx,%eax
  801bfc:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801c02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c07:	0f 47 c2             	cmova  %edx,%eax
  801c0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c15:	00 
  801c16:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 64 f7 ff ff       	call   801388 <readn>
  801c24:	85 c0                	test   %eax,%eax
  801c26:	0f 88 c6 01 00 00    	js     801df2 <spawn+0x602>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c2c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c32:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c36:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c3c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c40:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c51:	00 
  801c52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c59:	e8 2f f1 ff ff       	call   800d8d <sys_page_map>
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	79 20                	jns    801c82 <spawn+0x492>
				panic("spawn: sys_page_map data: %e", r);
  801c62:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c66:	c7 44 24 08 e9 2c 80 	movl   $0x802ce9,0x8(%esp)
  801c6d:	00 
  801c6e:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  801c75:	00 
  801c76:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  801c7d:	e8 ba e4 ff ff       	call   80013c <_panic>
			sys_page_unmap(0, UTEMP);
  801c82:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c89:	00 
  801c8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c91:	e8 4a f1 ff ff       	call   800de0 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c96:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c9c:	89 de                	mov    %ebx,%esi
  801c9e:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801ca4:	0f 82 d1 fe ff ff    	jb     801b7b <spawn+0x38b>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801caa:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801cb1:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801cb8:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cbf:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  801cc5:	0f 8f 2e fe ff ff    	jg     801af9 <spawn+0x309>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801ccb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 ba f4 ff ff       	call   801193 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
  801cd9:	bb 00 08 00 00       	mov    $0x800,%ebx
  801cde:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {

		if (!(uvpd[pn_beg >> 10] & (PTE_P | PTE_U))) {
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	c1 e8 0a             	shr    $0xa,%eax
  801ce9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cf0:	a8 05                	test   $0x5,%al
  801cf2:	74 52                	je     801d46 <spawn+0x556>
			continue;
		}

		const pte_t pte = uvpt[pn_beg];
  801cf4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax

		if (pte & PTE_SHARE) {
  801cfb:	f6 c4 04             	test   $0x4,%ah
  801cfe:	74 46                	je     801d46 <spawn+0x556>
  801d00:	89 da                	mov    %ebx,%edx
  801d02:	c1 e2 0c             	shl    $0xc,%edx
			void* va = (void*) (pn_beg * PGSIZE);
			int perm = pte & PTE_SYSCALL;
  801d05:	25 07 0e 00 00       	and    $0xe07,%eax
			int err_code;
			if ((err_code = sys_page_map(0, va, child, va, perm)) < 0) {
  801d0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d12:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d16:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d21:	e8 67 f0 ff ff       	call   800d8d <sys_page_map>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	79 1c                	jns    801d46 <spawn+0x556>
				panic("copy_shared_pages:sys_page_map");
  801d2a:	c7 44 24 08 70 2d 80 	movl   $0x802d70,0x8(%esp)
  801d31:	00 
  801d32:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  801d39:	00 
  801d3a:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  801d41:	e8 f6 e3 ff ff       	call   80013c <_panic>
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801d46:	83 c3 01             	add    $0x1,%ebx
  801d49:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801d4f:	75 93                	jne    801ce4 <spawn+0x4f4>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d51:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d61:	89 04 24             	mov    %eax,(%esp)
  801d64:	e8 1d f1 ff ff       	call   800e86 <sys_env_set_trapframe>
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	79 20                	jns    801d8d <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);
  801d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d71:	c7 44 24 08 06 2d 80 	movl   $0x802d06,0x8(%esp)
  801d78:	00 
  801d79:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  801d80:	00 
  801d81:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  801d88:	e8 af e3 ff ff       	call   80013c <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801d8d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d94:	00 
  801d95:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d9b:	89 04 24             	mov    %eax,(%esp)
  801d9e:	e8 90 f0 ff ff       	call   800e33 <sys_env_set_status>
  801da3:	85 c0                	test   %eax,%eax
  801da5:	79 20                	jns    801dc7 <spawn+0x5d7>
		panic("sys_env_set_status: %e", r);
  801da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dab:	c7 44 24 08 20 2d 80 	movl   $0x802d20,0x8(%esp)
  801db2:	00 
  801db3:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  801dba:	00 
  801dbb:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  801dc2:	e8 75 e3 ff ff       	call   80013c <_panic>

	cprintf("spawn return.\n");
  801dc7:	c7 04 24 37 2d 80 00 	movl   $0x802d37,(%esp)
  801dce:	e8 62 e4 ff ff       	call   800235 <cprintf>
	return child;
  801dd3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dd9:	eb 4f                	jmp    801e2a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801ddb:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801de1:	eb 47                	jmp    801e2a <spawn+0x63a>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801de3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801de8:	eb 40                	jmp    801e2a <spawn+0x63a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801dea:	89 c3                	mov    %eax,%ebx
  801dec:	eb 06                	jmp    801df4 <spawn+0x604>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801dee:	89 c3                	mov    %eax,%ebx
  801df0:	eb 02                	jmp    801df4 <spawn+0x604>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801df2:	89 c3                	mov    %eax,%ebx

	cprintf("spawn return.\n");
	return child;

error:
	sys_env_destroy(child);
  801df4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dfa:	89 04 24             	mov    %eax,(%esp)
  801dfd:	e8 a7 ee ff ff       	call   800ca9 <sys_env_destroy>
	close(fd);
  801e02:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e08:	89 04 24             	mov    %eax,(%esp)
  801e0b:	e8 83 f3 ff ff       	call   801193 <close>
	return r;
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	eb 16                	jmp    801e2a <spawn+0x63a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801e14:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e1b:	00 
  801e1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e23:	e8 b8 ef ff ff       	call   800de0 <sys_page_unmap>
  801e28:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801e2a:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    

00801e35 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	57                   	push   %edi
  801e39:	56                   	push   %esi
  801e3a:	53                   	push   %ebx
  801e3b:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e42:	74 61                	je     801ea5 <spawnl+0x70>
  801e44:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801e47:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801e4c:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e4f:	83 c0 04             	add    $0x4,%eax
  801e52:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801e56:	74 04                	je     801e5c <spawnl+0x27>
		argc++;
  801e58:	89 ca                	mov    %ecx,%edx
  801e5a:	eb f0                	jmp    801e4c <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801e5c:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  801e63:	83 e0 f0             	and    $0xfffffff0,%eax
  801e66:	29 c4                	sub    %eax,%esp
  801e68:	8d 74 24 0b          	lea    0xb(%esp),%esi
  801e6c:	c1 ee 02             	shr    $0x2,%esi
  801e6f:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  801e76:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801e78:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e7b:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  801e82:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  801e89:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e8a:	89 ce                	mov    %ecx,%esi
  801e8c:	85 c9                	test   %ecx,%ecx
  801e8e:	74 25                	je     801eb5 <spawnl+0x80>
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801e95:	83 c0 01             	add    $0x1,%eax
  801e98:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  801e9c:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e9f:	39 f0                	cmp    %esi,%eax
  801ea1:	75 f2                	jne    801e95 <spawnl+0x60>
  801ea3:	eb 10                	jmp    801eb5 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  801ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  801eab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801eb2:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801eb5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 2c f9 ff ff       	call   8017f0 <spawn>
}
  801ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    
  801ecc:	66 90                	xchg   %ax,%ax
  801ece:	66 90                	xchg   %ax,%ax

00801ed0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
  801ed8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 da f0 ff ff       	call   800fc0 <fd2data>
  801ee6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ee8:	c7 44 24 04 90 2d 80 	movl   $0x802d90,0x4(%esp)
  801eef:	00 
  801ef0:	89 1c 24             	mov    %ebx,(%esp)
  801ef3:	e8 93 e9 ff ff       	call   80088b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ef8:	8b 46 04             	mov    0x4(%esi),%eax
  801efb:	2b 06                	sub    (%esi),%eax
  801efd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f03:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f0a:	00 00 00 
	stat->st_dev = &devpipe;
  801f0d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801f14:	30 80 00 
	return 0;
}
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	53                   	push   %ebx
  801f27:	83 ec 14             	sub    $0x14,%esp
  801f2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f38:	e8 a3 ee ff ff       	call   800de0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f3d:	89 1c 24             	mov    %ebx,(%esp)
  801f40:	e8 7b f0 ff ff       	call   800fc0 <fd2data>
  801f45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f50:	e8 8b ee ff ff       	call   800de0 <sys_page_unmap>
}
  801f55:	83 c4 14             	add    $0x14,%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	57                   	push   %edi
  801f5f:	56                   	push   %esi
  801f60:	53                   	push   %ebx
  801f61:	83 ec 2c             	sub    $0x2c,%esp
  801f64:	89 c6                	mov    %eax,%esi
  801f66:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f69:	a1 04 40 80 00       	mov    0x804004,%eax
  801f6e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f71:	89 34 24             	mov    %esi,(%esp)
  801f74:	e8 d3 05 00 00       	call   80254c <pageref>
  801f79:	89 c7                	mov    %eax,%edi
  801f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7e:	89 04 24             	mov    %eax,(%esp)
  801f81:	e8 c6 05 00 00       	call   80254c <pageref>
  801f86:	39 c7                	cmp    %eax,%edi
  801f88:	0f 94 c2             	sete   %dl
  801f8b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f8e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801f94:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f97:	39 fb                	cmp    %edi,%ebx
  801f99:	74 21                	je     801fbc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f9b:	84 d2                	test   %dl,%dl
  801f9d:	74 ca                	je     801f69 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f9f:	8b 51 58             	mov    0x58(%ecx),%edx
  801fa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fa6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801faa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fae:	c7 04 24 97 2d 80 00 	movl   $0x802d97,(%esp)
  801fb5:	e8 7b e2 ff ff       	call   800235 <cprintf>
  801fba:	eb ad                	jmp    801f69 <_pipeisclosed+0xe>
	}
}
  801fbc:	83 c4 2c             	add    $0x2c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	57                   	push   %edi
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 1c             	sub    $0x1c,%esp
  801fcd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fd0:	89 34 24             	mov    %esi,(%esp)
  801fd3:	e8 e8 ef ff ff       	call   800fc0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fdc:	74 61                	je     80203f <devpipe_write+0x7b>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe5:	eb 4a                	jmp    802031 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fe7:	89 da                	mov    %ebx,%edx
  801fe9:	89 f0                	mov    %esi,%eax
  801feb:	e8 6b ff ff ff       	call   801f5b <_pipeisclosed>
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	75 54                	jne    802048 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ff4:	e8 21 ed ff ff       	call   800d1a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ff9:	8b 43 04             	mov    0x4(%ebx),%eax
  801ffc:	8b 0b                	mov    (%ebx),%ecx
  801ffe:	8d 51 20             	lea    0x20(%ecx),%edx
  802001:	39 d0                	cmp    %edx,%eax
  802003:	73 e2                	jae    801fe7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802008:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80200c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80200f:	99                   	cltd   
  802010:	c1 ea 1b             	shr    $0x1b,%edx
  802013:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802016:	83 e1 1f             	and    $0x1f,%ecx
  802019:	29 d1                	sub    %edx,%ecx
  80201b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80201f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802023:	83 c0 01             	add    $0x1,%eax
  802026:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802029:	83 c7 01             	add    $0x1,%edi
  80202c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80202f:	74 13                	je     802044 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802031:	8b 43 04             	mov    0x4(%ebx),%eax
  802034:	8b 0b                	mov    (%ebx),%ecx
  802036:	8d 51 20             	lea    0x20(%ecx),%edx
  802039:	39 d0                	cmp    %edx,%eax
  80203b:	73 aa                	jae    801fe7 <devpipe_write+0x23>
  80203d:	eb c6                	jmp    802005 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802044:	89 f8                	mov    %edi,%eax
  802046:	eb 05                	jmp    80204d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80204d:	83 c4 1c             	add    $0x1c,%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    

00802055 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	57                   	push   %edi
  802059:	56                   	push   %esi
  80205a:	53                   	push   %ebx
  80205b:	83 ec 1c             	sub    $0x1c,%esp
  80205e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802061:	89 3c 24             	mov    %edi,(%esp)
  802064:	e8 57 ef ff ff       	call   800fc0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802069:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206d:	74 54                	je     8020c3 <devpipe_read+0x6e>
  80206f:	89 c3                	mov    %eax,%ebx
  802071:	be 00 00 00 00       	mov    $0x0,%esi
  802076:	eb 3e                	jmp    8020b6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802078:	89 f0                	mov    %esi,%eax
  80207a:	eb 55                	jmp    8020d1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80207c:	89 da                	mov    %ebx,%edx
  80207e:	89 f8                	mov    %edi,%eax
  802080:	e8 d6 fe ff ff       	call   801f5b <_pipeisclosed>
  802085:	85 c0                	test   %eax,%eax
  802087:	75 43                	jne    8020cc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802089:	e8 8c ec ff ff       	call   800d1a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80208e:	8b 03                	mov    (%ebx),%eax
  802090:	3b 43 04             	cmp    0x4(%ebx),%eax
  802093:	74 e7                	je     80207c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802095:	99                   	cltd   
  802096:	c1 ea 1b             	shr    $0x1b,%edx
  802099:	01 d0                	add    %edx,%eax
  80209b:	83 e0 1f             	and    $0x1f,%eax
  80209e:	29 d0                	sub    %edx,%eax
  8020a0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020ab:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020ae:	83 c6 01             	add    $0x1,%esi
  8020b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b4:	74 12                	je     8020c8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8020b6:	8b 03                	mov    (%ebx),%eax
  8020b8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020bb:	75 d8                	jne    802095 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020bd:	85 f6                	test   %esi,%esi
  8020bf:	75 b7                	jne    802078 <devpipe_read+0x23>
  8020c1:	eb b9                	jmp    80207c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020c3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020c8:	89 f0                	mov    %esi,%eax
  8020ca:	eb 05                	jmp    8020d1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020d1:	83 c4 1c             	add    $0x1c,%esp
  8020d4:	5b                   	pop    %ebx
  8020d5:	5e                   	pop    %esi
  8020d6:	5f                   	pop    %edi
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    

008020d9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	56                   	push   %esi
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e4:	89 04 24             	mov    %eax,(%esp)
  8020e7:	e8 eb ee ff ff       	call   800fd7 <fd_alloc>
  8020ec:	89 c2                	mov    %eax,%edx
  8020ee:	85 d2                	test   %edx,%edx
  8020f0:	0f 88 4d 01 00 00    	js     802243 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020fd:	00 
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	89 44 24 04          	mov    %eax,0x4(%esp)
  802105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210c:	e8 28 ec ff ff       	call   800d39 <sys_page_alloc>
  802111:	89 c2                	mov    %eax,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	0f 88 28 01 00 00    	js     802243 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80211b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 b1 ee ff ff       	call   800fd7 <fd_alloc>
  802126:	89 c3                	mov    %eax,%ebx
  802128:	85 c0                	test   %eax,%eax
  80212a:	0f 88 fe 00 00 00    	js     80222e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802130:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802137:	00 
  802138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802146:	e8 ee eb ff ff       	call   800d39 <sys_page_alloc>
  80214b:	89 c3                	mov    %eax,%ebx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	0f 88 d9 00 00 00    	js     80222e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	89 04 24             	mov    %eax,(%esp)
  80215b:	e8 60 ee ff ff       	call   800fc0 <fd2data>
  802160:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802162:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802169:	00 
  80216a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802175:	e8 bf eb ff ff       	call   800d39 <sys_page_alloc>
  80217a:	89 c3                	mov    %eax,%ebx
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 88 97 00 00 00    	js     80221b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	e8 31 ee ff ff       	call   800fc0 <fd2data>
  80218f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802196:	00 
  802197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80219b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021a2:	00 
  8021a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ae:	e8 da eb ff ff       	call   800d8d <sys_page_map>
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	78 52                	js     80220b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021b9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021ce:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 c2 ed ff ff       	call   800fb0 <fd2num>
  8021ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	89 04 24             	mov    %eax,(%esp)
  8021f9:	e8 b2 ed ff ff       	call   800fb0 <fd2num>
  8021fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802201:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
  802209:	eb 38                	jmp    802243 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80220b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80220f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802216:	e8 c5 eb ff ff       	call   800de0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802229:	e8 b2 eb ff ff       	call   800de0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	89 44 24 04          	mov    %eax,0x4(%esp)
  802235:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223c:	e8 9f eb ff ff       	call   800de0 <sys_page_unmap>
  802241:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802243:	83 c4 30             	add    $0x30,%esp
  802246:	5b                   	pop    %ebx
  802247:	5e                   	pop    %esi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802250:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	89 04 24             	mov    %eax,(%esp)
  80225d:	e8 e9 ed ff ff       	call   80104b <fd_lookup>
  802262:	89 c2                	mov    %eax,%edx
  802264:	85 d2                	test   %edx,%edx
  802266:	78 15                	js     80227d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	89 04 24             	mov    %eax,(%esp)
  80226e:	e8 4d ed ff ff       	call   800fc0 <fd2data>
	return _pipeisclosed(fd, p);
  802273:	89 c2                	mov    %eax,%edx
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	e8 de fc ff ff       	call   801f5b <_pipeisclosed>
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    
  80227f:	90                   	nop

00802280 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	5d                   	pop    %ebp
  802289:	c3                   	ret    

0080228a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802290:	c7 44 24 04 af 2d 80 	movl   $0x802daf,0x4(%esp)
  802297:	00 
  802298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229b:	89 04 24             	mov    %eax,(%esp)
  80229e:	e8 e8 e5 ff ff       	call   80088b <strcpy>
	return 0;
}
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	57                   	push   %edi
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ba:	74 4a                	je     802306 <devcons_write+0x5c>
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022cc:	8b 75 10             	mov    0x10(%ebp),%esi
  8022cf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8022d1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022d4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022d9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022dc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022e0:	03 45 0c             	add    0xc(%ebp),%eax
  8022e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e7:	89 3c 24             	mov    %edi,(%esp)
  8022ea:	e8 97 e7 ff ff       	call   800a86 <memmove>
		sys_cputs(buf, m);
  8022ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f3:	89 3c 24             	mov    %edi,(%esp)
  8022f6:	e8 71 e9 ff ff       	call   800c6c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022fb:	01 f3                	add    %esi,%ebx
  8022fd:	89 d8                	mov    %ebx,%eax
  8022ff:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802302:	72 c8                	jb     8022cc <devcons_write+0x22>
  802304:	eb 05                	jmp    80230b <devcons_write+0x61>
  802306:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80230b:	89 d8                	mov    %ebx,%eax
  80230d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5f                   	pop    %edi
  802316:	5d                   	pop    %ebp
  802317:	c3                   	ret    

00802318 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802323:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802327:	75 07                	jne    802330 <devcons_read+0x18>
  802329:	eb 28                	jmp    802353 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80232b:	e8 ea e9 ff ff       	call   800d1a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802330:	e8 55 e9 ff ff       	call   800c8a <sys_cgetc>
  802335:	85 c0                	test   %eax,%eax
  802337:	74 f2                	je     80232b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802339:	85 c0                	test   %eax,%eax
  80233b:	78 16                	js     802353 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80233d:	83 f8 04             	cmp    $0x4,%eax
  802340:	74 0c                	je     80234e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802342:	8b 55 0c             	mov    0xc(%ebp),%edx
  802345:	88 02                	mov    %al,(%edx)
	return 1;
  802347:	b8 01 00 00 00       	mov    $0x1,%eax
  80234c:	eb 05                	jmp    802353 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802361:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802368:	00 
  802369:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80236c:	89 04 24             	mov    %eax,(%esp)
  80236f:	e8 f8 e8 ff ff       	call   800c6c <sys_cputs>
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <getchar>:

int
getchar(void)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80237c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802383:	00 
  802384:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802392:	e8 5f ef ff ff       	call   8012f6 <read>
	if (r < 0)
  802397:	85 c0                	test   %eax,%eax
  802399:	78 0f                	js     8023aa <getchar+0x34>
		return r;
	if (r < 1)
  80239b:	85 c0                	test   %eax,%eax
  80239d:	7e 06                	jle    8023a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80239f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023a3:	eb 05                	jmp    8023aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 04 24             	mov    %eax,(%esp)
  8023bf:	e8 87 ec ff ff       	call   80104b <fd_lookup>
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	78 11                	js     8023d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8023d1:	39 10                	cmp    %edx,(%eax)
  8023d3:	0f 94 c0             	sete   %al
  8023d6:	0f b6 c0             	movzbl %al,%eax
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <opencons>:

int
opencons(void)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e4:	89 04 24             	mov    %eax,(%esp)
  8023e7:	e8 eb eb ff ff       	call   800fd7 <fd_alloc>
		return r;
  8023ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 40                	js     802432 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f9:	00 
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802401:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802408:	e8 2c e9 ff ff       	call   800d39 <sys_page_alloc>
		return r;
  80240d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 1f                	js     802432 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802413:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802428:	89 04 24             	mov    %eax,(%esp)
  80242b:	e8 80 eb ff ff       	call   800fb0 <fd2num>
  802430:	89 c2                	mov    %eax,%edx
}
  802432:	89 d0                	mov    %edx,%eax
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	56                   	push   %esi
  80243a:	53                   	push   %ebx
  80243b:	83 ec 10             	sub    $0x10,%esp
  80243e:	8b 75 08             	mov    0x8(%ebp),%esi
  802441:	8b 45 0c             	mov    0xc(%ebp),%eax
  802444:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802447:	85 c0                	test   %eax,%eax
  802449:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80244e:	0f 44 c2             	cmove  %edx,%eax
  802451:	89 04 24             	mov    %eax,(%esp)
  802454:	e8 f6 ea ff ff       	call   800f4f <sys_ipc_recv>
	if (err_code < 0) {
  802459:	85 c0                	test   %eax,%eax
  80245b:	79 16                	jns    802473 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80245d:	85 f6                	test   %esi,%esi
  80245f:	74 06                	je     802467 <ipc_recv+0x31>
  802461:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802467:	85 db                	test   %ebx,%ebx
  802469:	74 2c                	je     802497 <ipc_recv+0x61>
  80246b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802471:	eb 24                	jmp    802497 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802473:	85 f6                	test   %esi,%esi
  802475:	74 0a                	je     802481 <ipc_recv+0x4b>
  802477:	a1 04 40 80 00       	mov    0x804004,%eax
  80247c:	8b 40 74             	mov    0x74(%eax),%eax
  80247f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802481:	85 db                	test   %ebx,%ebx
  802483:	74 0a                	je     80248f <ipc_recv+0x59>
  802485:	a1 04 40 80 00       	mov    0x804004,%eax
  80248a:	8b 40 78             	mov    0x78(%eax),%eax
  80248d:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80248f:	a1 04 40 80 00       	mov    0x804004,%eax
  802494:	8b 40 70             	mov    0x70(%eax),%eax
}
  802497:	83 c4 10             	add    $0x10,%esp
  80249a:	5b                   	pop    %ebx
  80249b:	5e                   	pop    %esi
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    

0080249e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	57                   	push   %edi
  8024a2:	56                   	push   %esi
  8024a3:	53                   	push   %ebx
  8024a4:	83 ec 1c             	sub    $0x1c,%esp
  8024a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8024b0:	eb 25                	jmp    8024d7 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8024b2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b5:	74 20                	je     8024d7 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8024b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024bb:	c7 44 24 08 bb 2d 80 	movl   $0x802dbb,0x8(%esp)
  8024c2:	00 
  8024c3:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8024ca:	00 
  8024cb:	c7 04 24 c7 2d 80 00 	movl   $0x802dc7,(%esp)
  8024d2:	e8 65 dc ff ff       	call   80013c <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8024d7:	85 db                	test   %ebx,%ebx
  8024d9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024de:	0f 45 c3             	cmovne %ebx,%eax
  8024e1:	8b 55 14             	mov    0x14(%ebp),%edx
  8024e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f0:	89 3c 24             	mov    %edi,(%esp)
  8024f3:	e8 34 ea ff ff       	call   800f2c <sys_ipc_try_send>
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 b6                	jne    8024b2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80250a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80250f:	39 c8                	cmp    %ecx,%eax
  802511:	74 17                	je     80252a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802513:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802518:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80251b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802521:	8b 52 50             	mov    0x50(%edx),%edx
  802524:	39 ca                	cmp    %ecx,%edx
  802526:	75 14                	jne    80253c <ipc_find_env+0x38>
  802528:	eb 05                	jmp    80252f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80252a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80252f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802532:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802537:	8b 40 40             	mov    0x40(%eax),%eax
  80253a:	eb 0e                	jmp    80254a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80253c:	83 c0 01             	add    $0x1,%eax
  80253f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802544:	75 d2                	jne    802518 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802546:	66 b8 00 00          	mov    $0x0,%ax
}
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    

0080254c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802552:	89 d0                	mov    %edx,%eax
  802554:	c1 e8 16             	shr    $0x16,%eax
  802557:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802563:	f6 c1 01             	test   $0x1,%cl
  802566:	74 1d                	je     802585 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802568:	c1 ea 0c             	shr    $0xc,%edx
  80256b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802572:	f6 c2 01             	test   $0x1,%dl
  802575:	74 0e                	je     802585 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802577:	c1 ea 0c             	shr    $0xc,%edx
  80257a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802581:	ef 
  802582:	0f b7 c0             	movzwl %ax,%eax
}
  802585:	5d                   	pop    %ebp
  802586:	c3                   	ret    
  802587:	66 90                	xchg   %ax,%ax
  802589:	66 90                	xchg   %ax,%ax
  80258b:	66 90                	xchg   %ax,%ax
  80258d:	66 90                	xchg   %ax,%ax
  80258f:	90                   	nop

00802590 <__udivdi3>:
  802590:	55                   	push   %ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	8b 44 24 28          	mov    0x28(%esp),%eax
  80259a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80259e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025ac:	89 ea                	mov    %ebp,%edx
  8025ae:	89 0c 24             	mov    %ecx,(%esp)
  8025b1:	75 2d                	jne    8025e0 <__udivdi3+0x50>
  8025b3:	39 e9                	cmp    %ebp,%ecx
  8025b5:	77 61                	ja     802618 <__udivdi3+0x88>
  8025b7:	85 c9                	test   %ecx,%ecx
  8025b9:	89 ce                	mov    %ecx,%esi
  8025bb:	75 0b                	jne    8025c8 <__udivdi3+0x38>
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	31 d2                	xor    %edx,%edx
  8025c4:	f7 f1                	div    %ecx
  8025c6:	89 c6                	mov    %eax,%esi
  8025c8:	31 d2                	xor    %edx,%edx
  8025ca:	89 e8                	mov    %ebp,%eax
  8025cc:	f7 f6                	div    %esi
  8025ce:	89 c5                	mov    %eax,%ebp
  8025d0:	89 f8                	mov    %edi,%eax
  8025d2:	f7 f6                	div    %esi
  8025d4:	89 ea                	mov    %ebp,%edx
  8025d6:	83 c4 0c             	add    $0xc,%esp
  8025d9:	5e                   	pop    %esi
  8025da:	5f                   	pop    %edi
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	39 e8                	cmp    %ebp,%eax
  8025e2:	77 24                	ja     802608 <__udivdi3+0x78>
  8025e4:	0f bd e8             	bsr    %eax,%ebp
  8025e7:	83 f5 1f             	xor    $0x1f,%ebp
  8025ea:	75 3c                	jne    802628 <__udivdi3+0x98>
  8025ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025f0:	39 34 24             	cmp    %esi,(%esp)
  8025f3:	0f 86 9f 00 00 00    	jbe    802698 <__udivdi3+0x108>
  8025f9:	39 d0                	cmp    %edx,%eax
  8025fb:	0f 82 97 00 00 00    	jb     802698 <__udivdi3+0x108>
  802601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802608:	31 d2                	xor    %edx,%edx
  80260a:	31 c0                	xor    %eax,%eax
  80260c:	83 c4 0c             	add    $0xc,%esp
  80260f:	5e                   	pop    %esi
  802610:	5f                   	pop    %edi
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    
  802613:	90                   	nop
  802614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802618:	89 f8                	mov    %edi,%eax
  80261a:	f7 f1                	div    %ecx
  80261c:	31 d2                	xor    %edx,%edx
  80261e:	83 c4 0c             	add    $0xc,%esp
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	8b 3c 24             	mov    (%esp),%edi
  80262d:	d3 e0                	shl    %cl,%eax
  80262f:	89 c6                	mov    %eax,%esi
  802631:	b8 20 00 00 00       	mov    $0x20,%eax
  802636:	29 e8                	sub    %ebp,%eax
  802638:	89 c1                	mov    %eax,%ecx
  80263a:	d3 ef                	shr    %cl,%edi
  80263c:	89 e9                	mov    %ebp,%ecx
  80263e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802642:	8b 3c 24             	mov    (%esp),%edi
  802645:	09 74 24 08          	or     %esi,0x8(%esp)
  802649:	89 d6                	mov    %edx,%esi
  80264b:	d3 e7                	shl    %cl,%edi
  80264d:	89 c1                	mov    %eax,%ecx
  80264f:	89 3c 24             	mov    %edi,(%esp)
  802652:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802656:	d3 ee                	shr    %cl,%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	d3 e2                	shl    %cl,%edx
  80265c:	89 c1                	mov    %eax,%ecx
  80265e:	d3 ef                	shr    %cl,%edi
  802660:	09 d7                	or     %edx,%edi
  802662:	89 f2                	mov    %esi,%edx
  802664:	89 f8                	mov    %edi,%eax
  802666:	f7 74 24 08          	divl   0x8(%esp)
  80266a:	89 d6                	mov    %edx,%esi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	f7 24 24             	mull   (%esp)
  802671:	39 d6                	cmp    %edx,%esi
  802673:	89 14 24             	mov    %edx,(%esp)
  802676:	72 30                	jb     8026a8 <__udivdi3+0x118>
  802678:	8b 54 24 04          	mov    0x4(%esp),%edx
  80267c:	89 e9                	mov    %ebp,%ecx
  80267e:	d3 e2                	shl    %cl,%edx
  802680:	39 c2                	cmp    %eax,%edx
  802682:	73 05                	jae    802689 <__udivdi3+0xf9>
  802684:	3b 34 24             	cmp    (%esp),%esi
  802687:	74 1f                	je     8026a8 <__udivdi3+0x118>
  802689:	89 f8                	mov    %edi,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	e9 7a ff ff ff       	jmp    80260c <__udivdi3+0x7c>
  802692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802698:	31 d2                	xor    %edx,%edx
  80269a:	b8 01 00 00 00       	mov    $0x1,%eax
  80269f:	e9 68 ff ff ff       	jmp    80260c <__udivdi3+0x7c>
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	83 c4 0c             	add    $0xc,%esp
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    
  8026b4:	66 90                	xchg   %ax,%ax
  8026b6:	66 90                	xchg   %ax,%ax
  8026b8:	66 90                	xchg   %ax,%ax
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <__umoddi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	83 ec 14             	sub    $0x14,%esp
  8026c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026d2:	89 c7                	mov    %eax,%edi
  8026d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026e0:	89 34 24             	mov    %esi,(%esp)
  8026e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	89 c2                	mov    %eax,%edx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	75 17                	jne    802708 <__umoddi3+0x48>
  8026f1:	39 fe                	cmp    %edi,%esi
  8026f3:	76 4b                	jbe    802740 <__umoddi3+0x80>
  8026f5:	89 c8                	mov    %ecx,%eax
  8026f7:	89 fa                	mov    %edi,%edx
  8026f9:	f7 f6                	div    %esi
  8026fb:	89 d0                	mov    %edx,%eax
  8026fd:	31 d2                	xor    %edx,%edx
  8026ff:	83 c4 14             	add    $0x14,%esp
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    
  802706:	66 90                	xchg   %ax,%ax
  802708:	39 f8                	cmp    %edi,%eax
  80270a:	77 54                	ja     802760 <__umoddi3+0xa0>
  80270c:	0f bd e8             	bsr    %eax,%ebp
  80270f:	83 f5 1f             	xor    $0x1f,%ebp
  802712:	75 5c                	jne    802770 <__umoddi3+0xb0>
  802714:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802718:	39 3c 24             	cmp    %edi,(%esp)
  80271b:	0f 87 e7 00 00 00    	ja     802808 <__umoddi3+0x148>
  802721:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802725:	29 f1                	sub    %esi,%ecx
  802727:	19 c7                	sbb    %eax,%edi
  802729:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80272d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802731:	8b 44 24 08          	mov    0x8(%esp),%eax
  802735:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802739:	83 c4 14             	add    $0x14,%esp
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	85 f6                	test   %esi,%esi
  802742:	89 f5                	mov    %esi,%ebp
  802744:	75 0b                	jne    802751 <__umoddi3+0x91>
  802746:	b8 01 00 00 00       	mov    $0x1,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f6                	div    %esi
  80274f:	89 c5                	mov    %eax,%ebp
  802751:	8b 44 24 04          	mov    0x4(%esp),%eax
  802755:	31 d2                	xor    %edx,%edx
  802757:	f7 f5                	div    %ebp
  802759:	89 c8                	mov    %ecx,%eax
  80275b:	f7 f5                	div    %ebp
  80275d:	eb 9c                	jmp    8026fb <__umoddi3+0x3b>
  80275f:	90                   	nop
  802760:	89 c8                	mov    %ecx,%eax
  802762:	89 fa                	mov    %edi,%edx
  802764:	83 c4 14             	add    $0x14,%esp
  802767:	5e                   	pop    %esi
  802768:	5f                   	pop    %edi
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    
  80276b:	90                   	nop
  80276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802770:	8b 04 24             	mov    (%esp),%eax
  802773:	be 20 00 00 00       	mov    $0x20,%esi
  802778:	89 e9                	mov    %ebp,%ecx
  80277a:	29 ee                	sub    %ebp,%esi
  80277c:	d3 e2                	shl    %cl,%edx
  80277e:	89 f1                	mov    %esi,%ecx
  802780:	d3 e8                	shr    %cl,%eax
  802782:	89 e9                	mov    %ebp,%ecx
  802784:	89 44 24 04          	mov    %eax,0x4(%esp)
  802788:	8b 04 24             	mov    (%esp),%eax
  80278b:	09 54 24 04          	or     %edx,0x4(%esp)
  80278f:	89 fa                	mov    %edi,%edx
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 f1                	mov    %esi,%ecx
  802795:	89 44 24 08          	mov    %eax,0x8(%esp)
  802799:	8b 44 24 10          	mov    0x10(%esp),%eax
  80279d:	d3 ea                	shr    %cl,%edx
  80279f:	89 e9                	mov    %ebp,%ecx
  8027a1:	d3 e7                	shl    %cl,%edi
  8027a3:	89 f1                	mov    %esi,%ecx
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	89 e9                	mov    %ebp,%ecx
  8027a9:	09 f8                	or     %edi,%eax
  8027ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027af:	f7 74 24 04          	divl   0x4(%esp)
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027b9:	89 d7                	mov    %edx,%edi
  8027bb:	f7 64 24 08          	mull   0x8(%esp)
  8027bf:	39 d7                	cmp    %edx,%edi
  8027c1:	89 c1                	mov    %eax,%ecx
  8027c3:	89 14 24             	mov    %edx,(%esp)
  8027c6:	72 2c                	jb     8027f4 <__umoddi3+0x134>
  8027c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027cc:	72 22                	jb     8027f0 <__umoddi3+0x130>
  8027ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027d2:	29 c8                	sub    %ecx,%eax
  8027d4:	19 d7                	sbb    %edx,%edi
  8027d6:	89 e9                	mov    %ebp,%ecx
  8027d8:	89 fa                	mov    %edi,%edx
  8027da:	d3 e8                	shr    %cl,%eax
  8027dc:	89 f1                	mov    %esi,%ecx
  8027de:	d3 e2                	shl    %cl,%edx
  8027e0:	89 e9                	mov    %ebp,%ecx
  8027e2:	d3 ef                	shr    %cl,%edi
  8027e4:	09 d0                	or     %edx,%eax
  8027e6:	89 fa                	mov    %edi,%edx
  8027e8:	83 c4 14             	add    $0x14,%esp
  8027eb:	5e                   	pop    %esi
  8027ec:	5f                   	pop    %edi
  8027ed:	5d                   	pop    %ebp
  8027ee:	c3                   	ret    
  8027ef:	90                   	nop
  8027f0:	39 d7                	cmp    %edx,%edi
  8027f2:	75 da                	jne    8027ce <__umoddi3+0x10e>
  8027f4:	8b 14 24             	mov    (%esp),%edx
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802801:	eb cb                	jmp    8027ce <__umoddi3+0x10e>
  802803:	90                   	nop
  802804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802808:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80280c:	0f 82 0f ff ff ff    	jb     802721 <__umoddi3+0x61>
  802812:	e9 1a ff ff ff       	jmp    802731 <__umoddi3+0x71>
