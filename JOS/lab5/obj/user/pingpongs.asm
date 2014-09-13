
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 16 01 00 00       	call   800147 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 d9 12 00 00       	call   80131a <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 5e                	je     8000a6 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800048:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80004e:	e8 f8 0c 00 00       	call   800d4b <sys_getenvid>
  800053:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005b:	c7 04 24 00 26 80 00 	movl   $0x802600,(%esp)
  800062:	e8 14 02 00 00       	call   80027b <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800067:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006a:	e8 dc 0c 00 00       	call   800d4b <sys_getenvid>
  80006f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 1a 26 80 00 	movl   $0x80261a,(%esp)
  80007e:	e8 f8 01 00 00       	call   80027b <cprintf>
		ipc_send(who, 0, 0, 0);
  800083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008a:	00 
  80008b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009a:	00 
  80009b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009e:	89 04 24             	mov    %eax,(%esp)
  8000a1:	e8 00 13 00 00       	call   8013a6 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b5:	00 
  8000b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 7b 12 00 00       	call   80133c <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c1:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c7:	8b 7b 48             	mov    0x48(%ebx),%edi
  8000ca:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000d5:	e8 71 0c 00 00       	call   800d4b <sys_getenvid>
  8000da:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8000de:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f1:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  8000f8:	e8 7e 01 00 00       	call   80027b <cprintf>
		if (val == 10)
  8000fd:	a1 04 40 80 00       	mov    0x804004,%eax
  800102:	83 f8 0a             	cmp    $0xa,%eax
  800105:	74 38                	je     80013f <umain+0x10c>
			return;
		++val;
  800107:	83 c0 01             	add    $0x1,%eax
  80010a:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  80010f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800116:	00 
  800117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800126:	00 
  800127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012a:	89 04 24             	mov    %eax,(%esp)
  80012d:	e8 74 12 00 00       	call   8013a6 <ipc_send>
		if (val == 10)
  800132:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  800139:	0f 85 67 ff ff ff    	jne    8000a6 <umain+0x73>
			return;
	}

}
  80013f:	83 c4 3c             	add    $0x3c,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
  80014c:	83 ec 10             	sub    $0x10,%esp
  80014f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800152:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800155:	e8 f1 0b 00 00       	call   800d4b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80015a:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800160:	39 c2                	cmp    %eax,%edx
  800162:	74 17                	je     80017b <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800164:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800169:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80016c:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800172:	8b 49 40             	mov    0x40(%ecx),%ecx
  800175:	39 c1                	cmp    %eax,%ecx
  800177:	75 18                	jne    800191 <libmain+0x4a>
  800179:	eb 05                	jmp    800180 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80017b:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800180:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800183:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800189:	89 15 08 40 80 00    	mov    %edx,0x804008
			break;
  80018f:	eb 0b                	jmp    80019c <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800191:	83 c2 01             	add    $0x1,%edx
  800194:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80019a:	75 cd                	jne    800169 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	85 db                	test   %ebx,%ebx
  80019e:	7e 07                	jle    8001a7 <libmain+0x60>
		binaryname = argv[0];
  8001a0:	8b 06                	mov    (%esi),%eax
  8001a2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001ab:	89 1c 24             	mov    %ebx,(%esp)
  8001ae:	e8 80 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001b3:	e8 07 00 00 00       	call   8001bf <exit>
}
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    

008001bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001c5:	e8 ac 14 00 00       	call   801676 <close_all>
	sys_env_destroy(0);
  8001ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001d1:	e8 23 0b 00 00       	call   800cf9 <sys_env_destroy>
}
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 14             	sub    $0x14,%esp
  8001df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e2:	8b 13                	mov    (%ebx),%edx
  8001e4:	8d 42 01             	lea    0x1(%edx),%eax
  8001e7:	89 03                	mov    %eax,(%ebx)
  8001e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f5:	75 19                	jne    800210 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001f7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001fe:	00 
  8001ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800202:	89 04 24             	mov    %eax,(%esp)
  800205:	e8 b2 0a 00 00       	call   800cbc <sys_cputs>
		b->idx = 0;
  80020a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800210:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800214:	83 c4 14             	add    $0x14,%esp
  800217:	5b                   	pop    %ebx
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800223:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022a:	00 00 00 
	b.cnt = 0;
  80022d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800234:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	89 44 24 08          	mov    %eax,0x8(%esp)
  800245:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	c7 04 24 d8 01 80 00 	movl   $0x8001d8,(%esp)
  800256:	e8 b9 01 00 00       	call   800414 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800261:	89 44 24 04          	mov    %eax,0x4(%esp)
  800265:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	e8 49 0a 00 00       	call   800cbc <sys_cputs>

	return b.cnt;
}
  800273:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800281:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800284:	89 44 24 04          	mov    %eax,0x4(%esp)
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	89 04 24             	mov    %eax,(%esp)
  80028e:	e8 87 ff ff ff       	call   80021a <vcprintf>
	va_end(ap);

	return cnt;
}
  800293:	c9                   	leave  
  800294:	c3                   	ret    
  800295:	66 90                	xchg   %ax,%ax
  800297:	66 90                	xchg   %ax,%ax
  800299:	66 90                	xchg   %ax,%ax
  80029b:	66 90                	xchg   %ax,%ax
  80029d:	66 90                	xchg   %ax,%ax
  80029f:	90                   	nop

008002a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 3c             	sub    $0x3c,%esp
  8002a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ac:	89 d7                	mov    %edx,%edi
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002b7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c8:	39 f1                	cmp    %esi,%ecx
  8002ca:	72 14                	jb     8002e0 <printnum+0x40>
  8002cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002cf:	76 0f                	jbe    8002e0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	85 f6                	test   %esi,%esi
  8002dc:	7f 60                	jg     80033e <printnum+0x9e>
  8002de:	eb 72                	jmp    800352 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002e3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8002ea:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8002ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002f9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002fd:	89 c3                	mov    %eax,%ebx
  8002ff:	89 d6                	mov    %edx,%esi
  800301:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800304:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800307:	89 54 24 08          	mov    %edx,0x8(%esp)
  80030b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80030f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800312:	89 04 24             	mov    %eax,(%esp)
  800315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031c:	e8 3f 20 00 00       	call   802360 <__udivdi3>
  800321:	89 d9                	mov    %ebx,%ecx
  800323:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800327:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80032b:	89 04 24             	mov    %eax,(%esp)
  80032e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800332:	89 fa                	mov    %edi,%edx
  800334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800337:	e8 64 ff ff ff       	call   8002a0 <printnum>
  80033c:	eb 14                	jmp    800352 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800342:	8b 45 18             	mov    0x18(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034a:	83 ee 01             	sub    $0x1,%esi
  80034d:	75 ef                	jne    80033e <printnum+0x9e>
  80034f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800352:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800356:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80035a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800360:	89 44 24 08          	mov    %eax,0x8(%esp)
  800364:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	89 04 24             	mov    %eax,(%esp)
  80036e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800371:	89 44 24 04          	mov    %eax,0x4(%esp)
  800375:	e8 16 21 00 00       	call   802490 <__umoddi3>
  80037a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037e:	0f be 80 60 26 80 00 	movsbl 0x802660(%eax),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038b:	ff d0                	call   *%eax
}
  80038d:	83 c4 3c             	add    $0x3c,%esp
  800390:	5b                   	pop    %ebx
  800391:	5e                   	pop    %esi
  800392:	5f                   	pop    %edi
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800398:	83 fa 01             	cmp    $0x1,%edx
  80039b:	7e 0e                	jle    8003ab <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80039d:	8b 10                	mov    (%eax),%edx
  80039f:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003a2:	89 08                	mov    %ecx,(%eax)
  8003a4:	8b 02                	mov    (%edx),%eax
  8003a6:	8b 52 04             	mov    0x4(%edx),%edx
  8003a9:	eb 22                	jmp    8003cd <getuint+0x38>
	else if (lflag)
  8003ab:	85 d2                	test   %edx,%edx
  8003ad:	74 10                	je     8003bf <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003af:	8b 10                	mov    (%eax),%edx
  8003b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b4:	89 08                	mov    %ecx,(%eax)
  8003b6:	8b 02                	mov    (%edx),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	eb 0e                	jmp    8003cd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003bf:	8b 10                	mov    (%eax),%edx
  8003c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 02                	mov    (%edx),%eax
  8003c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	3b 50 04             	cmp    0x4(%eax),%edx
  8003de:	73 0a                	jae    8003ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 02                	mov    %al,(%edx)
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	89 04 24             	mov    %eax,(%esp)
  80040d:	e8 02 00 00 00       	call   800414 <vprintfmt>
	va_end(ap);
}
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	57                   	push   %edi
  800418:	56                   	push   %esi
  800419:	53                   	push   %ebx
  80041a:	83 ec 3c             	sub    $0x3c,%esp
  80041d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800420:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800423:	eb 18                	jmp    80043d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800425:	85 c0                	test   %eax,%eax
  800427:	0f 84 c3 03 00 00    	je     8007f0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80042d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800431:	89 04 24             	mov    %eax,(%esp)
  800434:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800437:	89 f3                	mov    %esi,%ebx
  800439:	eb 02                	jmp    80043d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80043b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80043d:	8d 73 01             	lea    0x1(%ebx),%esi
  800440:	0f b6 03             	movzbl (%ebx),%eax
  800443:	83 f8 25             	cmp    $0x25,%eax
  800446:	75 dd                	jne    800425 <vprintfmt+0x11>
  800448:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80044c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800453:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80045a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800461:	ba 00 00 00 00       	mov    $0x0,%edx
  800466:	eb 1d                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800468:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80046a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80046e:	eb 15                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800470:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800472:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800476:	eb 0d                	jmp    800485 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80047b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8d 5e 01             	lea    0x1(%esi),%ebx
  800488:	0f b6 06             	movzbl (%esi),%eax
  80048b:	0f b6 c8             	movzbl %al,%ecx
  80048e:	83 e8 23             	sub    $0x23,%eax
  800491:	3c 55                	cmp    $0x55,%al
  800493:	0f 87 2f 03 00 00    	ja     8007c8 <vprintfmt+0x3b4>
  800499:	0f b6 c0             	movzbl %al,%eax
  80049c:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8004a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8004a9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004ad:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8004b0:	83 f9 09             	cmp    $0x9,%ecx
  8004b3:	77 50                	ja     800505 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	89 de                	mov    %ebx,%esi
  8004b7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ba:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004bd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004c0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004c4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004c7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ca:	83 fb 09             	cmp    $0x9,%ebx
  8004cd:	76 eb                	jbe    8004ba <vprintfmt+0xa6>
  8004cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004d2:	eb 33                	jmp    800507 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 48 04             	lea    0x4(%eax),%ecx
  8004da:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e4:	eb 21                	jmp    800507 <vprintfmt+0xf3>
  8004e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e9:	85 c9                	test   %ecx,%ecx
  8004eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f0:	0f 49 c1             	cmovns %ecx,%eax
  8004f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
  8004f8:	eb 8b                	jmp    800485 <vprintfmt+0x71>
  8004fa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004fc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800503:	eb 80                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800505:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80050b:	0f 89 74 ff ff ff    	jns    800485 <vprintfmt+0x71>
  800511:	e9 62 ff ff ff       	jmp    800478 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800516:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800519:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80051b:	e9 65 ff ff ff       	jmp    800485 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 50 04             	lea    0x4(%eax),%edx
  800526:	89 55 14             	mov    %edx,0x14(%ebp)
  800529:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 04 24             	mov    %eax,(%esp)
  800532:	ff 55 08             	call   *0x8(%ebp)
			break;
  800535:	e9 03 ff ff ff       	jmp    80043d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8d 50 04             	lea    0x4(%eax),%edx
  800540:	89 55 14             	mov    %edx,0x14(%ebp)
  800543:	8b 00                	mov    (%eax),%eax
  800545:	99                   	cltd   
  800546:	31 d0                	xor    %edx,%eax
  800548:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054a:	83 f8 0f             	cmp    $0xf,%eax
  80054d:	7f 0b                	jg     80055a <vprintfmt+0x146>
  80054f:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800556:	85 d2                	test   %edx,%edx
  800558:	75 20                	jne    80057a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80055a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80055e:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  800565:	00 
  800566:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	e8 77 fe ff ff       	call   8003ec <printfmt>
  800575:	e9 c3 fe ff ff       	jmp    80043d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80057a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80057e:	c7 44 24 08 67 2b 80 	movl   $0x802b67,0x8(%esp)
  800585:	00 
  800586:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 04 24             	mov    %eax,(%esp)
  800590:	e8 57 fe ff ff       	call   8003ec <printfmt>
  800595:	e9 a3 fe ff ff       	jmp    80043d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80059d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 50 04             	lea    0x4(%eax),%edx
  8005a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8005ab:	85 c0                	test   %eax,%eax
  8005ad:	ba 71 26 80 00       	mov    $0x802671,%edx
  8005b2:	0f 45 d0             	cmovne %eax,%edx
  8005b5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8005b8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8005bc:	74 04                	je     8005c2 <vprintfmt+0x1ae>
  8005be:	85 f6                	test   %esi,%esi
  8005c0:	7f 19                	jg     8005db <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c5:	8d 70 01             	lea    0x1(%eax),%esi
  8005c8:	0f b6 10             	movzbl (%eax),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	0f 85 95 00 00 00    	jne    80066b <vprintfmt+0x257>
  8005d6:	e9 85 00 00 00       	jmp    800660 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e2:	89 04 24             	mov    %eax,(%esp)
  8005e5:	e8 b8 02 00 00       	call   8008a2 <strnlen>
  8005ea:	29 c6                	sub    %eax,%esi
  8005ec:	89 f0                	mov    %esi,%eax
  8005ee:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005f1:	85 f6                	test   %esi,%esi
  8005f3:	7e cd                	jle    8005c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005f5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005fc:	89 c3                	mov    %eax,%ebx
  8005fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800602:	89 34 24             	mov    %esi,(%esp)
  800605:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800608:	83 eb 01             	sub    $0x1,%ebx
  80060b:	75 f1                	jne    8005fe <vprintfmt+0x1ea>
  80060d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800610:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800613:	eb ad                	jmp    8005c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800615:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800619:	74 1e                	je     800639 <vprintfmt+0x225>
  80061b:	0f be d2             	movsbl %dl,%edx
  80061e:	83 ea 20             	sub    $0x20,%edx
  800621:	83 fa 5e             	cmp    $0x5e,%edx
  800624:	76 13                	jbe    800639 <vprintfmt+0x225>
					putch('?', putdat);
  800626:	8b 45 0c             	mov    0xc(%ebp),%eax
  800629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800634:	ff 55 08             	call   *0x8(%ebp)
  800637:	eb 0d                	jmp    800646 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800639:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800640:	89 04 24             	mov    %eax,(%esp)
  800643:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800646:	83 ef 01             	sub    $0x1,%edi
  800649:	83 c6 01             	add    $0x1,%esi
  80064c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800650:	0f be c2             	movsbl %dl,%eax
  800653:	85 c0                	test   %eax,%eax
  800655:	75 20                	jne    800677 <vprintfmt+0x263>
  800657:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80065a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80065d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800664:	7f 25                	jg     80068b <vprintfmt+0x277>
  800666:	e9 d2 fd ff ff       	jmp    80043d <vprintfmt+0x29>
  80066b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800671:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800674:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800677:	85 db                	test   %ebx,%ebx
  800679:	78 9a                	js     800615 <vprintfmt+0x201>
  80067b:	83 eb 01             	sub    $0x1,%ebx
  80067e:	79 95                	jns    800615 <vprintfmt+0x201>
  800680:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800683:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800686:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800689:	eb d5                	jmp    800660 <vprintfmt+0x24c>
  80068b:	8b 75 08             	mov    0x8(%ebp),%esi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800694:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800698:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80069f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a1:	83 eb 01             	sub    $0x1,%ebx
  8006a4:	75 ee                	jne    800694 <vprintfmt+0x280>
  8006a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006a9:	e9 8f fd ff ff       	jmp    80043d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ae:	83 fa 01             	cmp    $0x1,%edx
  8006b1:	7e 16                	jle    8006c9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 50 08             	lea    0x8(%eax),%edx
  8006b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	eb 32                	jmp    8006fb <vprintfmt+0x2e7>
	else if (lflag)
  8006c9:	85 d2                	test   %edx,%edx
  8006cb:	74 18                	je     8006e5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d6:	8b 30                	mov    (%eax),%esi
  8006d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006db:	89 f0                	mov    %esi,%eax
  8006dd:	c1 f8 1f             	sar    $0x1f,%eax
  8006e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006e3:	eb 16                	jmp    8006fb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 04             	lea    0x4(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 30                	mov    (%eax),%esi
  8006f0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	c1 f8 1f             	sar    $0x1f,%eax
  8006f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800701:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800706:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070a:	0f 89 80 00 00 00    	jns    800790 <vprintfmt+0x37c>
				putch('-', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80071e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800721:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800724:	f7 d8                	neg    %eax
  800726:	83 d2 00             	adc    $0x0,%edx
  800729:	f7 da                	neg    %edx
			}
			base = 10;
  80072b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800730:	eb 5e                	jmp    800790 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800732:	8d 45 14             	lea    0x14(%ebp),%eax
  800735:	e8 5b fc ff ff       	call   800395 <getuint>
			base = 10;
  80073a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80073f:	eb 4f                	jmp    800790 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800741:	8d 45 14             	lea    0x14(%ebp),%eax
  800744:	e8 4c fc ff ff       	call   800395 <getuint>
			base = 8;
  800749:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80074e:	eb 40                	jmp    800790 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800754:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80075e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800762:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800769:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 50 04             	lea    0x4(%eax),%edx
  800772:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80077c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800781:	eb 0d                	jmp    800790 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	e8 0a fc ff ff       	call   800395 <getuint>
			base = 16;
  80078b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800790:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800794:	89 74 24 10          	mov    %esi,0x10(%esp)
  800798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80079b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80079f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007a3:	89 04 24             	mov    %eax,(%esp)
  8007a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007aa:	89 fa                	mov    %edi,%edx
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	e8 ec fa ff ff       	call   8002a0 <printnum>
			break;
  8007b4:	e9 84 fc ff ff       	jmp    80043d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bd:	89 0c 24             	mov    %ecx,(%esp)
  8007c0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007c3:	e9 75 fc ff ff       	jmp    80043d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007d3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007da:	0f 84 5b fc ff ff    	je     80043b <vprintfmt+0x27>
  8007e0:	89 f3                	mov    %esi,%ebx
  8007e2:	83 eb 01             	sub    $0x1,%ebx
  8007e5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007e9:	75 f7                	jne    8007e2 <vprintfmt+0x3ce>
  8007eb:	e9 4d fc ff ff       	jmp    80043d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007f0:	83 c4 3c             	add    $0x3c,%esp
  8007f3:	5b                   	pop    %ebx
  8007f4:	5e                   	pop    %esi
  8007f5:	5f                   	pop    %edi
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 28             	sub    $0x28,%esp
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800807:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80080b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800815:	85 c0                	test   %eax,%eax
  800817:	74 30                	je     800849 <vsnprintf+0x51>
  800819:	85 d2                	test   %edx,%edx
  80081b:	7e 2c                	jle    800849 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80082e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800832:	c7 04 24 cf 03 80 00 	movl   $0x8003cf,(%esp)
  800839:	e8 d6 fb ff ff       	call   800414 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800841:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	eb 05                	jmp    80084e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800849:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800859:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085d:	8b 45 10             	mov    0x10(%ebp),%eax
  800860:	89 44 24 08          	mov    %eax,0x8(%esp)
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 04 24             	mov    %eax,(%esp)
  800871:	e8 82 ff ff ff       	call   8007f8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    
  800878:	66 90                	xchg   %ax,%ax
  80087a:	66 90                	xchg   %ax,%ax
  80087c:	66 90                	xchg   %ax,%ax
  80087e:	66 90                	xchg   %ax,%ax

00800880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800886:	80 3a 00             	cmpb   $0x0,(%edx)
  800889:	74 10                	je     80089b <strlen+0x1b>
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800890:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800893:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800897:	75 f7                	jne    800890 <strlen+0x10>
  800899:	eb 05                	jmp    8008a0 <strlen+0x20>
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	74 1c                	je     8008cc <strnlen+0x2a>
  8008b0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008b3:	74 1e                	je     8008d3 <strnlen+0x31>
  8008b5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008ba:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bc:	39 ca                	cmp    %ecx,%edx
  8008be:	74 18                	je     8008d8 <strnlen+0x36>
  8008c0:	83 c2 01             	add    $0x1,%edx
  8008c3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008c8:	75 f0                	jne    8008ba <strnlen+0x18>
  8008ca:	eb 0c                	jmp    8008d8 <strnlen+0x36>
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d1:	eb 05                	jmp    8008d8 <strnlen+0x36>
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	83 c2 01             	add    $0x1,%edx
  8008ea:	83 c1 01             	add    $0x1,%ecx
  8008ed:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008f1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f4:	84 db                	test   %bl,%bl
  8008f6:	75 ef                	jne    8008e7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f8:	5b                   	pop    %ebx
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800905:	89 1c 24             	mov    %ebx,(%esp)
  800908:	e8 73 ff ff ff       	call   800880 <strlen>
	strcpy(dst + len, src);
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	89 54 24 04          	mov    %edx,0x4(%esp)
  800914:	01 d8                	add    %ebx,%eax
  800916:	89 04 24             	mov    %eax,(%esp)
  800919:	e8 bd ff ff ff       	call   8008db <strcpy>
	return dst;
}
  80091e:	89 d8                	mov    %ebx,%eax
  800920:	83 c4 08             	add    $0x8,%esp
  800923:	5b                   	pop    %ebx
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	56                   	push   %esi
  80092a:	53                   	push   %ebx
  80092b:	8b 75 08             	mov    0x8(%ebp),%esi
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800931:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800934:	85 db                	test   %ebx,%ebx
  800936:	74 17                	je     80094f <strncpy+0x29>
  800938:	01 f3                	add    %esi,%ebx
  80093a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80093c:	83 c1 01             	add    $0x1,%ecx
  80093f:	0f b6 02             	movzbl (%edx),%eax
  800942:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800945:	80 3a 01             	cmpb   $0x1,(%edx)
  800948:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094b:	39 d9                	cmp    %ebx,%ecx
  80094d:	75 ed                	jne    80093c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80094f:	89 f0                	mov    %esi,%eax
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	57                   	push   %edi
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800961:	8b 75 10             	mov    0x10(%ebp),%esi
  800964:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800966:	85 f6                	test   %esi,%esi
  800968:	74 34                	je     80099e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80096a:	83 fe 01             	cmp    $0x1,%esi
  80096d:	74 26                	je     800995 <strlcpy+0x40>
  80096f:	0f b6 0b             	movzbl (%ebx),%ecx
  800972:	84 c9                	test   %cl,%cl
  800974:	74 23                	je     800999 <strlcpy+0x44>
  800976:	83 ee 02             	sub    $0x2,%esi
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800984:	39 f2                	cmp    %esi,%edx
  800986:	74 13                	je     80099b <strlcpy+0x46>
  800988:	83 c2 01             	add    $0x1,%edx
  80098b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098f:	84 c9                	test   %cl,%cl
  800991:	75 eb                	jne    80097e <strlcpy+0x29>
  800993:	eb 06                	jmp    80099b <strlcpy+0x46>
  800995:	89 f8                	mov    %edi,%eax
  800997:	eb 02                	jmp    80099b <strlcpy+0x46>
  800999:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80099b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099e:	29 f8                	sub    %edi,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5f                   	pop    %edi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 15                	je     8009ca <strcmp+0x25>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	75 11                	jne    8009ca <strcmp+0x25>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009bf:	0f b6 01             	movzbl (%ecx),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 04                	je     8009ca <strcmp+0x25>
  8009c6:	3a 02                	cmp    (%edx),%al
  8009c8:	74 ef                	je     8009b9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 c0             	movzbl %al,%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8009e2:	85 f6                	test   %esi,%esi
  8009e4:	74 29                	je     800a0f <strncmp+0x3b>
  8009e6:	0f b6 03             	movzbl (%ebx),%eax
  8009e9:	84 c0                	test   %al,%al
  8009eb:	74 30                	je     800a1d <strncmp+0x49>
  8009ed:	3a 02                	cmp    (%edx),%al
  8009ef:	75 2c                	jne    800a1d <strncmp+0x49>
  8009f1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009f4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009f6:	89 c3                	mov    %eax,%ebx
  8009f8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009fb:	39 f0                	cmp    %esi,%eax
  8009fd:	74 17                	je     800a16 <strncmp+0x42>
  8009ff:	0f b6 08             	movzbl (%eax),%ecx
  800a02:	84 c9                	test   %cl,%cl
  800a04:	74 17                	je     800a1d <strncmp+0x49>
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	3a 0a                	cmp    (%edx),%cl
  800a0b:	74 e9                	je     8009f6 <strncmp+0x22>
  800a0d:	eb 0e                	jmp    800a1d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	eb 0f                	jmp    800a25 <strncmp+0x51>
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	eb 08                	jmp    800a25 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 03             	movzbl (%ebx),%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5e                   	pop    %esi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a33:	0f b6 18             	movzbl (%eax),%ebx
  800a36:	84 db                	test   %bl,%bl
  800a38:	74 1d                	je     800a57 <strchr+0x2e>
  800a3a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a3c:	38 d3                	cmp    %dl,%bl
  800a3e:	75 06                	jne    800a46 <strchr+0x1d>
  800a40:	eb 1a                	jmp    800a5c <strchr+0x33>
  800a42:	38 ca                	cmp    %cl,%dl
  800a44:	74 16                	je     800a5c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a46:	83 c0 01             	add    $0x1,%eax
  800a49:	0f b6 10             	movzbl (%eax),%edx
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	75 f2                	jne    800a42 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	eb 05                	jmp    800a5c <strchr+0x33>
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5c:	5b                   	pop    %ebx
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	53                   	push   %ebx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a69:	0f b6 18             	movzbl (%eax),%ebx
  800a6c:	84 db                	test   %bl,%bl
  800a6e:	74 16                	je     800a86 <strfind+0x27>
  800a70:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a72:	38 d3                	cmp    %dl,%bl
  800a74:	75 06                	jne    800a7c <strfind+0x1d>
  800a76:	eb 0e                	jmp    800a86 <strfind+0x27>
  800a78:	38 ca                	cmp    %cl,%dl
  800a7a:	74 0a                	je     800a86 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a7c:	83 c0 01             	add    $0x1,%eax
  800a7f:	0f b6 10             	movzbl (%eax),%edx
  800a82:	84 d2                	test   %dl,%dl
  800a84:	75 f2                	jne    800a78 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a86:	5b                   	pop    %ebx
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a95:	85 c9                	test   %ecx,%ecx
  800a97:	74 36                	je     800acf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a99:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9f:	75 28                	jne    800ac9 <memset+0x40>
  800aa1:	f6 c1 03             	test   $0x3,%cl
  800aa4:	75 23                	jne    800ac9 <memset+0x40>
		c &= 0xFF;
  800aa6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	c1 e3 08             	shl    $0x8,%ebx
  800aaf:	89 d6                	mov    %edx,%esi
  800ab1:	c1 e6 18             	shl    $0x18,%esi
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 10             	shl    $0x10,%eax
  800ab9:	09 f0                	or     %esi,%eax
  800abb:	09 c2                	or     %eax,%edx
  800abd:	89 d0                	mov    %edx,%eax
  800abf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac4:	fc                   	cld    
  800ac5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac7:	eb 06                	jmp    800acf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	fc                   	cld    
  800acd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acf:	89 f8                	mov    %edi,%eax
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae4:	39 c6                	cmp    %eax,%esi
  800ae6:	73 35                	jae    800b1d <memmove+0x47>
  800ae8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aeb:	39 d0                	cmp    %edx,%eax
  800aed:	73 2e                	jae    800b1d <memmove+0x47>
		s += n;
		d += n;
  800aef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800af2:	89 d6                	mov    %edx,%esi
  800af4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afc:	75 13                	jne    800b11 <memmove+0x3b>
  800afe:	f6 c1 03             	test   $0x3,%cl
  800b01:	75 0e                	jne    800b11 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b03:	83 ef 04             	sub    $0x4,%edi
  800b06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b09:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0f:	eb 09                	jmp    800b1a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 1d                	jmp    800b3a <memmove+0x64>
  800b1d:	89 f2                	mov    %esi,%edx
  800b1f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	f6 c2 03             	test   $0x3,%dl
  800b24:	75 0f                	jne    800b35 <memmove+0x5f>
  800b26:	f6 c1 03             	test   $0x3,%cl
  800b29:	75 0a                	jne    800b35 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2e:	89 c7                	mov    %eax,%edi
  800b30:	fc                   	cld    
  800b31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b33:	eb 05                	jmp    800b3a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b35:	89 c7                	mov    %eax,%edi
  800b37:	fc                   	cld    
  800b38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 04 24             	mov    %eax,(%esp)
  800b58:	e8 79 ff ff ff       	call   800ad6 <memmove>
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	57                   	push   %edi
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b71:	85 c0                	test   %eax,%eax
  800b73:	74 36                	je     800bab <memcmp+0x4c>
		if (*s1 != *s2)
  800b75:	0f b6 03             	movzbl (%ebx),%eax
  800b78:	0f b6 0e             	movzbl (%esi),%ecx
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	38 c8                	cmp    %cl,%al
  800b82:	74 1c                	je     800ba0 <memcmp+0x41>
  800b84:	eb 10                	jmp    800b96 <memcmp+0x37>
  800b86:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b8b:	83 c2 01             	add    $0x1,%edx
  800b8e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b92:	38 c8                	cmp    %cl,%al
  800b94:	74 0a                	je     800ba0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b96:	0f b6 c0             	movzbl %al,%eax
  800b99:	0f b6 c9             	movzbl %cl,%ecx
  800b9c:	29 c8                	sub    %ecx,%eax
  800b9e:	eb 10                	jmp    800bb0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba0:	39 fa                	cmp    %edi,%edx
  800ba2:	75 e2                	jne    800b86 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	eb 05                	jmp    800bb0 <memcmp+0x51>
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	53                   	push   %ebx
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	39 d0                	cmp    %edx,%eax
  800bc6:	73 13                	jae    800bdb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc8:	89 d9                	mov    %ebx,%ecx
  800bca:	38 18                	cmp    %bl,(%eax)
  800bcc:	75 06                	jne    800bd4 <memfind+0x1f>
  800bce:	eb 0b                	jmp    800bdb <memfind+0x26>
  800bd0:	38 08                	cmp    %cl,(%eax)
  800bd2:	74 07                	je     800bdb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	39 d0                	cmp    %edx,%eax
  800bd9:	75 f5                	jne    800bd0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bea:	0f b6 0a             	movzbl (%edx),%ecx
  800bed:	80 f9 09             	cmp    $0x9,%cl
  800bf0:	74 05                	je     800bf7 <strtol+0x19>
  800bf2:	80 f9 20             	cmp    $0x20,%cl
  800bf5:	75 10                	jne    800c07 <strtol+0x29>
		s++;
  800bf7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfa:	0f b6 0a             	movzbl (%edx),%ecx
  800bfd:	80 f9 09             	cmp    $0x9,%cl
  800c00:	74 f5                	je     800bf7 <strtol+0x19>
  800c02:	80 f9 20             	cmp    $0x20,%cl
  800c05:	74 f0                	je     800bf7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c07:	80 f9 2b             	cmp    $0x2b,%cl
  800c0a:	75 0a                	jne    800c16 <strtol+0x38>
		s++;
  800c0c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c14:	eb 11                	jmp    800c27 <strtol+0x49>
  800c16:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c1b:	80 f9 2d             	cmp    $0x2d,%cl
  800c1e:	75 07                	jne    800c27 <strtol+0x49>
		s++, neg = 1;
  800c20:	83 c2 01             	add    $0x1,%edx
  800c23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c27:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c2c:	75 15                	jne    800c43 <strtol+0x65>
  800c2e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c31:	75 10                	jne    800c43 <strtol+0x65>
  800c33:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c37:	75 0a                	jne    800c43 <strtol+0x65>
		s += 2, base = 16;
  800c39:	83 c2 02             	add    $0x2,%edx
  800c3c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c41:	eb 10                	jmp    800c53 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c43:	85 c0                	test   %eax,%eax
  800c45:	75 0c                	jne    800c53 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c47:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c49:	80 3a 30             	cmpb   $0x30,(%edx)
  800c4c:	75 05                	jne    800c53 <strtol+0x75>
		s++, base = 8;
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c5b:	0f b6 0a             	movzbl (%edx),%ecx
  800c5e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c61:	89 f0                	mov    %esi,%eax
  800c63:	3c 09                	cmp    $0x9,%al
  800c65:	77 08                	ja     800c6f <strtol+0x91>
			dig = *s - '0';
  800c67:	0f be c9             	movsbl %cl,%ecx
  800c6a:	83 e9 30             	sub    $0x30,%ecx
  800c6d:	eb 20                	jmp    800c8f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c6f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c72:	89 f0                	mov    %esi,%eax
  800c74:	3c 19                	cmp    $0x19,%al
  800c76:	77 08                	ja     800c80 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c78:	0f be c9             	movsbl %cl,%ecx
  800c7b:	83 e9 57             	sub    $0x57,%ecx
  800c7e:	eb 0f                	jmp    800c8f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c80:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c83:	89 f0                	mov    %esi,%eax
  800c85:	3c 19                	cmp    $0x19,%al
  800c87:	77 16                	ja     800c9f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c89:	0f be c9             	movsbl %cl,%ecx
  800c8c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c8f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c92:	7d 0f                	jge    800ca3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c94:	83 c2 01             	add    $0x1,%edx
  800c97:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c9b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c9d:	eb bc                	jmp    800c5b <strtol+0x7d>
  800c9f:	89 d8                	mov    %ebx,%eax
  800ca1:	eb 02                	jmp    800ca5 <strtol+0xc7>
  800ca3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ca5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca9:	74 05                	je     800cb0 <strtol+0xd2>
		*endptr = (char *) s;
  800cab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cae:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cb0:	f7 d8                	neg    %eax
  800cb2:	85 ff                	test   %edi,%edi
  800cb4:	0f 44 c3             	cmove  %ebx,%eax
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	89 c3                	mov    %eax,%ebx
  800ccf:	89 c7                	mov    %eax,%edi
  800cd1:	89 c6                	mov    %eax,%esi
  800cd3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_cgetc>:

int
sys_cgetc(void)
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
  800ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d07:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	89 cb                	mov    %ecx,%ebx
  800d11:	89 cf                	mov    %ecx,%edi
  800d13:	89 ce                	mov    %ecx,%esi
  800d15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d17:	85 c0                	test   %eax,%eax
  800d19:	7e 28                	jle    800d43 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d26:	00 
  800d27:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d36:	00 
  800d37:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800d3e:	e8 c3 14 00 00       	call   802206 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d43:	83 c4 2c             	add    $0x2c,%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_yield>:

void
sys_yield(void)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7a:	89 d1                	mov    %edx,%ecx
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	89 d7                	mov    %edx,%edi
  800d80:	89 d6                	mov    %edx,%esi
  800d82:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	be 00 00 00 00       	mov    $0x0,%esi
  800d97:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da5:	89 f7                	mov    %esi,%edi
  800da7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7e 28                	jle    800dd5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800db8:	00 
  800db9:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800dc0:	00 
  800dc1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dc8:	00 
  800dc9:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800dd0:	e8 31 14 00 00       	call   802206 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd5:	83 c4 2c             	add    $0x2c,%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de6:	b8 05 00 00 00       	mov    $0x5,%eax
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 28                	jle    800e28 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e04:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800e13:	00 
  800e14:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e1b:	00 
  800e1c:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800e23:	e8 de 13 00 00       	call   802206 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e28:	83 c4 2c             	add    $0x2c,%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7e 28                	jle    800e7b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800e66:	00 
  800e67:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e6e:	00 
  800e6f:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800e76:	e8 8b 13 00 00       	call   802206 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7b:	83 c4 2c             	add    $0x2c,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	b8 08 00 00 00       	mov    $0x8,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	89 df                	mov    %ebx,%edi
  800e9e:	89 de                	mov    %ebx,%esi
  800ea0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7e 28                	jle    800ece <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaa:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800eb9:	00 
  800eba:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ec1:	00 
  800ec2:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800ec9:	e8 38 13 00 00       	call   802206 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	83 c4 2c             	add    $0x2c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
  800edc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	89 de                	mov    %ebx,%esi
  800ef3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7e 28                	jle    800f21 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f04:	00 
  800f05:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800f0c:	00 
  800f0d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f14:	00 
  800f15:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800f1c:	e8 e5 12 00 00       	call   802206 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f21:	83 c4 2c             	add    $0x2c,%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f37:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	89 df                	mov    %ebx,%edi
  800f44:	89 de                	mov    %ebx,%esi
  800f46:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7e 28                	jle    800f74 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f50:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f57:	00 
  800f58:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800f5f:	00 
  800f60:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f67:	00 
  800f68:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800f6f:	e8 92 12 00 00       	call   802206 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f74:	83 c4 2c             	add    $0x2c,%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	be 00 00 00 00       	mov    $0x0,%esi
  800f87:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f98:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fad:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	89 cb                	mov    %ecx,%ebx
  800fb7:	89 cf                	mov    %ecx,%edi
  800fb9:	89 ce                	mov    %ecx,%esi
  800fbb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7e 28                	jle    800fe9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800fd4:	00 
  800fd5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fdc:	00 
  800fdd:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800fe4:	e8 1d 12 00 00       	call   802206 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe9:	83 c4 2c             	add    $0x2c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	53                   	push   %ebx
  800ff5:	83 ec 24             	sub    $0x24,%esp
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffb:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  800ffd:	89 da                	mov    %ebx,%edx
  800fff:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801002:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801009:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80100d:	74 05                	je     801014 <pgfault+0x23>
  80100f:	f6 c6 08             	test   $0x8,%dh
  801012:	75 1c                	jne    801030 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801014:	c7 44 24 08 8c 29 80 	movl   $0x80298c,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80102b:	e8 d6 11 00 00       	call   802206 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801030:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801037:	00 
  801038:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80103f:	00 
  801040:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801047:	e8 3d fd ff ff       	call   800d89 <sys_page_alloc>
  80104c:	85 c0                	test   %eax,%eax
  80104e:	79 20                	jns    801070 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801050:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801054:	c7 44 24 08 f4 29 80 	movl   $0x8029f4,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80106b:	e8 96 11 00 00       	call   802206 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801070:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801076:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80107d:	00 
  80107e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801082:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801089:	e8 48 fa ff ff       	call   800ad6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80108e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801095:	00 
  801096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80109a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010a9:	00 
  8010aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b1:	e8 27 fd ff ff       	call   800ddd <sys_page_map>
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	79 20                	jns    8010da <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8010ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010be:	c7 44 24 08 0e 2a 80 	movl   $0x802a0e,0x8(%esp)
  8010c5:	00 
  8010c6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8010cd:	00 
  8010ce:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8010d5:	e8 2c 11 00 00       	call   802206 <_panic>
	}
}
  8010da:	83 c4 24             	add    $0x24,%esp
  8010dd:	5b                   	pop    %ebx
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	53                   	push   %ebx
  8010e6:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  8010e9:	c7 04 24 f1 0f 80 00 	movl   $0x800ff1,(%esp)
  8010f0:	e8 67 11 00 00       	call   80225c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010f5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010fa:	cd 30                	int    $0x30
  8010fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8010ff:	85 c0                	test   %eax,%eax
  801101:	79 1c                	jns    80111f <fork+0x3f>
		panic("fork");
  801103:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  80110a:	00 
  80110b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801112:	00 
  801113:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80111a:	e8 e7 10 00 00       	call   802206 <_panic>
  80111f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801121:	bb 00 08 00 00       	mov    $0x800,%ebx
  801126:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80112a:	75 21                	jne    80114d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80112c:	e8 1a fc ff ff       	call   800d4b <sys_getenvid>
  801131:	25 ff 03 00 00       	and    $0x3ff,%eax
  801136:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801139:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80113e:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
  801148:	e9 c5 01 00 00       	jmp    801312 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80114d:	89 d8                	mov    %ebx,%eax
  80114f:	c1 e8 0a             	shr    $0xa,%eax
  801152:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801159:	a8 01                	test   $0x1,%al
  80115b:	0f 84 f2 00 00 00    	je     801253 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801161:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801168:	a8 05                	test   $0x5,%al
  80116a:	0f 84 e3 00 00 00    	je     801253 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801170:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801177:	89 de                	mov    %ebx,%esi
  801179:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80117c:	a9 02 08 00 00       	test   $0x802,%eax
  801181:	0f 84 88 00 00 00    	je     80120f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801187:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80118e:	00 
  80118f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801193:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801197:	89 74 24 04          	mov    %esi,0x4(%esp)
  80119b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a2:	e8 36 fc ff ff       	call   800ddd <sys_page_map>
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	79 20                	jns    8011cb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  8011ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011af:	c7 44 24 08 2c 2a 80 	movl   $0x802a2c,0x8(%esp)
  8011b6:	00 
  8011b7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8011be:	00 
  8011bf:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8011c6:	e8 3b 10 00 00       	call   802206 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8011cb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011d2:	00 
  8011d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011de:	00 
  8011df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e3:	89 3c 24             	mov    %edi,(%esp)
  8011e6:	e8 f2 fb ff ff       	call   800ddd <sys_page_map>
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	79 64                	jns    801253 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  8011ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011f3:	c7 44 24 08 46 2a 80 	movl   $0x802a46,0x8(%esp)
  8011fa:	00 
  8011fb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801202:	00 
  801203:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80120a:	e8 f7 0f 00 00       	call   802206 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80120f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801216:	00 
  801217:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80121b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80121f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122a:	e8 ae fb ff ff       	call   800ddd <sys_page_map>
  80122f:	85 c0                	test   %eax,%eax
  801231:	79 20                	jns    801253 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801233:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801237:	c7 44 24 08 60 2a 80 	movl   $0x802a60,0x8(%esp)
  80123e:	00 
  80123f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801246:	00 
  801247:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80124e:	e8 b3 0f 00 00       	call   802206 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801253:	83 c3 01             	add    $0x1,%ebx
  801256:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80125c:	0f 85 eb fe ff ff    	jne    80114d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801262:	c7 44 24 04 c5 22 80 	movl   $0x8022c5,0x4(%esp)
  801269:	00 
  80126a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80126d:	89 04 24             	mov    %eax,(%esp)
  801270:	e8 b4 fc ff ff       	call   800f29 <sys_env_set_pgfault_upcall>
  801275:	85 c0                	test   %eax,%eax
  801277:	79 20                	jns    801299 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801279:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80127d:	c7 44 24 08 c4 29 80 	movl   $0x8029c4,0x8(%esp)
  801284:	00 
  801285:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80128c:	00 
  80128d:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801294:	e8 6d 0f 00 00       	call   802206 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801299:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012a0:	00 
  8012a1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012a8:	ee 
  8012a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ac:	89 04 24             	mov    %eax,(%esp)
  8012af:	e8 d5 fa ff ff       	call   800d89 <sys_page_alloc>
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	79 20                	jns    8012d8 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8012b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012bc:	c7 44 24 08 72 2a 80 	movl   $0x802a72,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8012d3:	e8 2e 0f 00 00       	call   802206 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8012d8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012df:	00 
  8012e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e3:	89 04 24             	mov    %eax,(%esp)
  8012e6:	e8 98 fb ff ff       	call   800e83 <sys_env_set_status>
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	79 20                	jns    80130f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  8012ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f3:	c7 44 24 08 8a 2a 80 	movl   $0x802a8a,0x8(%esp)
  8012fa:	00 
  8012fb:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801302:	00 
  801303:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80130a:	e8 f7 0e 00 00       	call   802206 <_panic>
	}

	return envid;
  80130f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801312:	83 c4 2c             	add    $0x2c,%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5f                   	pop    %edi
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    

0080131a <sfork>:

// Challenge!
int
sfork(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801320:	c7 44 24 08 a5 2a 80 	movl   $0x802aa5,0x8(%esp)
  801327:	00 
  801328:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80132f:	00 
  801330:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801337:	e8 ca 0e 00 00       	call   802206 <_panic>

0080133c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
  801341:	83 ec 10             	sub    $0x10,%esp
  801344:	8b 75 08             	mov    0x8(%ebp),%esi
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  80134d:	83 f8 01             	cmp    $0x1,%eax
  801350:	19 c0                	sbb    %eax,%eax
  801352:	f7 d0                	not    %eax
  801354:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801359:	89 04 24             	mov    %eax,(%esp)
  80135c:	e8 3e fc ff ff       	call   800f9f <sys_ipc_recv>
	if (err_code < 0) {
  801361:	85 c0                	test   %eax,%eax
  801363:	79 16                	jns    80137b <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801365:	85 f6                	test   %esi,%esi
  801367:	74 06                	je     80136f <ipc_recv+0x33>
  801369:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80136f:	85 db                	test   %ebx,%ebx
  801371:	74 2c                	je     80139f <ipc_recv+0x63>
  801373:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801379:	eb 24                	jmp    80139f <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80137b:	85 f6                	test   %esi,%esi
  80137d:	74 0a                	je     801389 <ipc_recv+0x4d>
  80137f:	a1 08 40 80 00       	mov    0x804008,%eax
  801384:	8b 40 74             	mov    0x74(%eax),%eax
  801387:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801389:	85 db                	test   %ebx,%ebx
  80138b:	74 0a                	je     801397 <ipc_recv+0x5b>
  80138d:	a1 08 40 80 00       	mov    0x804008,%eax
  801392:	8b 40 78             	mov    0x78(%eax),%eax
  801395:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801397:	a1 08 40 80 00       	mov    0x804008,%eax
  80139c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	57                   	push   %edi
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 1c             	sub    $0x1c,%esp
  8013af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8013b8:	eb 25                	jmp    8013df <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8013ba:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013bd:	74 20                	je     8013df <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8013bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c3:	c7 44 24 08 bb 2a 80 	movl   $0x802abb,0x8(%esp)
  8013ca:	00 
  8013cb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8013d2:	00 
  8013d3:	c7 04 24 c7 2a 80 00 	movl   $0x802ac7,(%esp)
  8013da:	e8 27 0e 00 00       	call   802206 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8013df:	85 db                	test   %ebx,%ebx
  8013e1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8013e6:	0f 45 c3             	cmovne %ebx,%eax
  8013e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f8:	89 3c 24             	mov    %edi,(%esp)
  8013fb:	e8 7c fb ff ff       	call   800f7c <sys_ipc_try_send>
  801400:	85 c0                	test   %eax,%eax
  801402:	75 b6                	jne    8013ba <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801404:	83 c4 1c             	add    $0x1c,%esp
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5f                   	pop    %edi
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801412:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801417:	39 c8                	cmp    %ecx,%eax
  801419:	74 17                	je     801432 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80141b:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801420:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801423:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801429:	8b 52 50             	mov    0x50(%edx),%edx
  80142c:	39 ca                	cmp    %ecx,%edx
  80142e:	75 14                	jne    801444 <ipc_find_env+0x38>
  801430:	eb 05                	jmp    801437 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801437:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80143a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80143f:	8b 40 40             	mov    0x40(%eax),%eax
  801442:	eb 0e                	jmp    801452 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801444:	83 c0 01             	add    $0x1,%eax
  801447:	3d 00 04 00 00       	cmp    $0x400,%eax
  80144c:	75 d2                	jne    801420 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80144e:	66 b8 00 00          	mov    $0x0,%ax
}
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    
  801454:	66 90                	xchg   %ax,%ax
  801456:	66 90                	xchg   %ax,%ax
  801458:	66 90                	xchg   %ax,%ax
  80145a:	66 90                	xchg   %ax,%ax
  80145c:	66 90                	xchg   %ax,%ax
  80145e:	66 90                	xchg   %ax,%ax

00801460 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	05 00 00 00 30       	add    $0x30000000,%eax
  80146b:	c1 e8 0c             	shr    $0xc,%eax
}
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80147b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801480:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80148a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80148f:	a8 01                	test   $0x1,%al
  801491:	74 34                	je     8014c7 <fd_alloc+0x40>
  801493:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801498:	a8 01                	test   $0x1,%al
  80149a:	74 32                	je     8014ce <fd_alloc+0x47>
  80149c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8014a1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014a3:	89 c2                	mov    %eax,%edx
  8014a5:	c1 ea 16             	shr    $0x16,%edx
  8014a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014af:	f6 c2 01             	test   $0x1,%dl
  8014b2:	74 1f                	je     8014d3 <fd_alloc+0x4c>
  8014b4:	89 c2                	mov    %eax,%edx
  8014b6:	c1 ea 0c             	shr    $0xc,%edx
  8014b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014c0:	f6 c2 01             	test   $0x1,%dl
  8014c3:	75 1a                	jne    8014df <fd_alloc+0x58>
  8014c5:	eb 0c                	jmp    8014d3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8014c7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8014cc:	eb 05                	jmp    8014d3 <fd_alloc+0x4c>
  8014ce:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	eb 1a                	jmp    8014f9 <fd_alloc+0x72>
  8014df:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014e4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014e9:	75 b6                	jne    8014a1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014f4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801501:	83 f8 1f             	cmp    $0x1f,%eax
  801504:	77 36                	ja     80153c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801506:	c1 e0 0c             	shl    $0xc,%eax
  801509:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80150e:	89 c2                	mov    %eax,%edx
  801510:	c1 ea 16             	shr    $0x16,%edx
  801513:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80151a:	f6 c2 01             	test   $0x1,%dl
  80151d:	74 24                	je     801543 <fd_lookup+0x48>
  80151f:	89 c2                	mov    %eax,%edx
  801521:	c1 ea 0c             	shr    $0xc,%edx
  801524:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80152b:	f6 c2 01             	test   $0x1,%dl
  80152e:	74 1a                	je     80154a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	89 02                	mov    %eax,(%edx)
	return 0;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 13                	jmp    80154f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb 0c                	jmp    80154f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801543:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801548:	eb 05                	jmp    80154f <fd_lookup+0x54>
  80154a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    

00801551 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	53                   	push   %ebx
  801555:	83 ec 14             	sub    $0x14,%esp
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80155e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801564:	75 1e                	jne    801584 <dev_lookup+0x33>
  801566:	eb 0e                	jmp    801576 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801568:	b8 20 30 80 00       	mov    $0x803020,%eax
  80156d:	eb 0c                	jmp    80157b <dev_lookup+0x2a>
  80156f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801574:	eb 05                	jmp    80157b <dev_lookup+0x2a>
  801576:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80157b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	eb 38                	jmp    8015bc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801584:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80158a:	74 dc                	je     801568 <dev_lookup+0x17>
  80158c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801592:	74 db                	je     80156f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801594:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80159a:	8b 52 48             	mov    0x48(%edx),%edx
  80159d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015a5:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  8015ac:	e8 ca ec ff ff       	call   80027b <cprintf>
	*dev = 0;
  8015b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8015b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015bc:	83 c4 14             	add    $0x14,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    

008015c2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	83 ec 20             	sub    $0x20,%esp
  8015ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8015cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015dd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e0:	89 04 24             	mov    %eax,(%esp)
  8015e3:	e8 13 ff ff ff       	call   8014fb <fd_lookup>
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 05                	js     8015f1 <fd_close+0x2f>
	    || fd != fd2)
  8015ec:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015ef:	74 0c                	je     8015fd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015f1:	84 db                	test   %bl,%bl
  8015f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f8:	0f 44 c2             	cmove  %edx,%eax
  8015fb:	eb 3f                	jmp    80163c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801600:	89 44 24 04          	mov    %eax,0x4(%esp)
  801604:	8b 06                	mov    (%esi),%eax
  801606:	89 04 24             	mov    %eax,(%esp)
  801609:	e8 43 ff ff ff       	call   801551 <dev_lookup>
  80160e:	89 c3                	mov    %eax,%ebx
  801610:	85 c0                	test   %eax,%eax
  801612:	78 16                	js     80162a <fd_close+0x68>
		if (dev->dev_close)
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80161a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 07                	je     80162a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801623:	89 34 24             	mov    %esi,(%esp)
  801626:	ff d0                	call   *%eax
  801628:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80162a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80162e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801635:	e8 f6 f7 ff ff       	call   800e30 <sys_page_unmap>
	return r;
  80163a:	89 d8                	mov    %ebx,%eax
}
  80163c:	83 c4 20             	add    $0x20,%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801649:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 04 24             	mov    %eax,(%esp)
  801656:	e8 a0 fe ff ff       	call   8014fb <fd_lookup>
  80165b:	89 c2                	mov    %eax,%edx
  80165d:	85 d2                	test   %edx,%edx
  80165f:	78 13                	js     801674 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801661:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801668:	00 
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	89 04 24             	mov    %eax,(%esp)
  80166f:	e8 4e ff ff ff       	call   8015c2 <fd_close>
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <close_all>:

void
close_all(void)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80167d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801682:	89 1c 24             	mov    %ebx,(%esp)
  801685:	e8 b9 ff ff ff       	call   801643 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80168a:	83 c3 01             	add    $0x1,%ebx
  80168d:	83 fb 20             	cmp    $0x20,%ebx
  801690:	75 f0                	jne    801682 <close_all+0xc>
		close(i);
}
  801692:	83 c4 14             	add    $0x14,%esp
  801695:	5b                   	pop    %ebx
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    

00801698 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	57                   	push   %edi
  80169c:	56                   	push   %esi
  80169d:	53                   	push   %ebx
  80169e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	89 04 24             	mov    %eax,(%esp)
  8016ae:	e8 48 fe ff ff       	call   8014fb <fd_lookup>
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	85 d2                	test   %edx,%edx
  8016b7:	0f 88 e1 00 00 00    	js     80179e <dup+0x106>
		return r;
	close(newfdnum);
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	89 04 24             	mov    %eax,(%esp)
  8016c3:	e8 7b ff ff ff       	call   801643 <close>

	newfd = INDEX2FD(newfdnum);
  8016c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016cb:	c1 e3 0c             	shl    $0xc,%ebx
  8016ce:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d7:	89 04 24             	mov    %eax,(%esp)
  8016da:	e8 91 fd ff ff       	call   801470 <fd2data>
  8016df:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016e1:	89 1c 24             	mov    %ebx,(%esp)
  8016e4:	e8 87 fd ff ff       	call   801470 <fd2data>
  8016e9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016eb:	89 f0                	mov    %esi,%eax
  8016ed:	c1 e8 16             	shr    $0x16,%eax
  8016f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016f7:	a8 01                	test   $0x1,%al
  8016f9:	74 43                	je     80173e <dup+0xa6>
  8016fb:	89 f0                	mov    %esi,%eax
  8016fd:	c1 e8 0c             	shr    $0xc,%eax
  801700:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801707:	f6 c2 01             	test   $0x1,%dl
  80170a:	74 32                	je     80173e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80170c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801713:	25 07 0e 00 00       	and    $0xe07,%eax
  801718:	89 44 24 10          	mov    %eax,0x10(%esp)
  80171c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801720:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801727:	00 
  801728:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801733:	e8 a5 f6 ff ff       	call   800ddd <sys_page_map>
  801738:	89 c6                	mov    %eax,%esi
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 3e                	js     80177c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80173e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801741:	89 c2                	mov    %eax,%edx
  801743:	c1 ea 0c             	shr    $0xc,%edx
  801746:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801753:	89 54 24 10          	mov    %edx,0x10(%esp)
  801757:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80175b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801762:	00 
  801763:	89 44 24 04          	mov    %eax,0x4(%esp)
  801767:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80176e:	e8 6a f6 ff ff       	call   800ddd <sys_page_map>
  801773:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801778:	85 f6                	test   %esi,%esi
  80177a:	79 22                	jns    80179e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80177c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801787:	e8 a4 f6 ff ff       	call   800e30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80178c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801797:	e8 94 f6 ff ff       	call   800e30 <sys_page_unmap>
	return r;
  80179c:	89 f0                	mov    %esi,%eax
}
  80179e:	83 c4 3c             	add    $0x3c,%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 24             	sub    $0x24,%esp
  8017ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 3c fd ff ff       	call   8014fb <fd_lookup>
  8017bf:	89 c2                	mov    %eax,%edx
  8017c1:	85 d2                	test   %edx,%edx
  8017c3:	78 6d                	js     801832 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	89 04 24             	mov    %eax,(%esp)
  8017d4:	e8 78 fd ff ff       	call   801551 <dev_lookup>
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 55                	js     801832 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	8b 50 08             	mov    0x8(%eax),%edx
  8017e3:	83 e2 03             	and    $0x3,%edx
  8017e6:	83 fa 01             	cmp    $0x1,%edx
  8017e9:	75 23                	jne    80180e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8017f0:	8b 40 48             	mov    0x48(%eax),%eax
  8017f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fb:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  801802:	e8 74 ea ff ff       	call   80027b <cprintf>
		return -E_INVAL;
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180c:	eb 24                	jmp    801832 <read+0x8c>
	}
	if (!dev->dev_read)
  80180e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801811:	8b 52 08             	mov    0x8(%edx),%edx
  801814:	85 d2                	test   %edx,%edx
  801816:	74 15                	je     80182d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801818:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80181f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801822:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801826:	89 04 24             	mov    %eax,(%esp)
  801829:	ff d2                	call   *%edx
  80182b:	eb 05                	jmp    801832 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80182d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801832:	83 c4 24             	add    $0x24,%esp
  801835:	5b                   	pop    %ebx
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 1c             	sub    $0x1c,%esp
  801841:	8b 7d 08             	mov    0x8(%ebp),%edi
  801844:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801847:	85 f6                	test   %esi,%esi
  801849:	74 33                	je     80187e <readn+0x46>
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801855:	89 f2                	mov    %esi,%edx
  801857:	29 c2                	sub    %eax,%edx
  801859:	89 54 24 08          	mov    %edx,0x8(%esp)
  80185d:	03 45 0c             	add    0xc(%ebp),%eax
  801860:	89 44 24 04          	mov    %eax,0x4(%esp)
  801864:	89 3c 24             	mov    %edi,(%esp)
  801867:	e8 3a ff ff ff       	call   8017a6 <read>
		if (m < 0)
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 1b                	js     80188b <readn+0x53>
			return m;
		if (m == 0)
  801870:	85 c0                	test   %eax,%eax
  801872:	74 11                	je     801885 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801874:	01 c3                	add    %eax,%ebx
  801876:	89 d8                	mov    %ebx,%eax
  801878:	39 f3                	cmp    %esi,%ebx
  80187a:	72 d9                	jb     801855 <readn+0x1d>
  80187c:	eb 0b                	jmp    801889 <readn+0x51>
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	eb 06                	jmp    80188b <readn+0x53>
  801885:	89 d8                	mov    %ebx,%eax
  801887:	eb 02                	jmp    80188b <readn+0x53>
  801889:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80188b:	83 c4 1c             	add    $0x1c,%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5f                   	pop    %edi
  801891:	5d                   	pop    %ebp
  801892:	c3                   	ret    

00801893 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	53                   	push   %ebx
  801897:	83 ec 24             	sub    $0x24,%esp
  80189a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a4:	89 1c 24             	mov    %ebx,(%esp)
  8018a7:	e8 4f fc ff ff       	call   8014fb <fd_lookup>
  8018ac:	89 c2                	mov    %eax,%edx
  8018ae:	85 d2                	test   %edx,%edx
  8018b0:	78 68                	js     80191a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bc:	8b 00                	mov    (%eax),%eax
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 8b fc ff ff       	call   801551 <dev_lookup>
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 50                	js     80191a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018d1:	75 23                	jne    8018f6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8018d8:	8b 40 48             	mov    0x48(%eax),%eax
  8018db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	c7 04 24 31 2b 80 00 	movl   $0x802b31,(%esp)
  8018ea:	e8 8c e9 ff ff       	call   80027b <cprintf>
		return -E_INVAL;
  8018ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f4:	eb 24                	jmp    80191a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018fc:	85 d2                	test   %edx,%edx
  8018fe:	74 15                	je     801915 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801900:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	ff d2                	call   *%edx
  801913:	eb 05                	jmp    80191a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801915:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80191a:	83 c4 24             	add    $0x24,%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    

00801920 <seek>:

int
seek(int fdnum, off_t offset)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801926:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801929:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	89 04 24             	mov    %eax,(%esp)
  801933:	e8 c3 fb ff ff       	call   8014fb <fd_lookup>
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 0e                	js     80194a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	53                   	push   %ebx
  801950:	83 ec 24             	sub    $0x24,%esp
  801953:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801956:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195d:	89 1c 24             	mov    %ebx,(%esp)
  801960:	e8 96 fb ff ff       	call   8014fb <fd_lookup>
  801965:	89 c2                	mov    %eax,%edx
  801967:	85 d2                	test   %edx,%edx
  801969:	78 61                	js     8019cc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	8b 00                	mov    (%eax),%eax
  801977:	89 04 24             	mov    %eax,(%esp)
  80197a:	e8 d2 fb ff ff       	call   801551 <dev_lookup>
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 49                	js     8019cc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198a:	75 23                	jne    8019af <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80198c:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801991:	8b 40 48             	mov    0x48(%eax),%eax
  801994:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	c7 04 24 f4 2a 80 00 	movl   $0x802af4,(%esp)
  8019a3:	e8 d3 e8 ff ff       	call   80027b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ad:	eb 1d                	jmp    8019cc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b2:	8b 52 18             	mov    0x18(%edx),%edx
  8019b5:	85 d2                	test   %edx,%edx
  8019b7:	74 0e                	je     8019c7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019bc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	ff d2                	call   *%edx
  8019c5:	eb 05                	jmp    8019cc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019cc:	83 c4 24             	add    $0x24,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 24             	sub    $0x24,%esp
  8019d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	89 04 24             	mov    %eax,(%esp)
  8019e9:	e8 0d fb ff ff       	call   8014fb <fd_lookup>
  8019ee:	89 c2                	mov    %eax,%edx
  8019f0:	85 d2                	test   %edx,%edx
  8019f2:	78 52                	js     801a46 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 49 fb ff ff       	call   801551 <dev_lookup>
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 3a                	js     801a46 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a13:	74 2c                	je     801a41 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a15:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a18:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a1f:	00 00 00 
	stat->st_isdir = 0;
  801a22:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a29:	00 00 00 
	stat->st_dev = dev;
  801a2c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a39:	89 14 24             	mov    %edx,(%esp)
  801a3c:	ff 50 14             	call   *0x14(%eax)
  801a3f:	eb 05                	jmp    801a46 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a46:	83 c4 24             	add    $0x24,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a5b:	00 
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 af 01 00 00       	call   801c16 <open>
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	85 db                	test   %ebx,%ebx
  801a6b:	78 1b                	js     801a88 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a74:	89 1c 24             	mov    %ebx,(%esp)
  801a77:	e8 56 ff ff ff       	call   8019d2 <fstat>
  801a7c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a7e:	89 1c 24             	mov    %ebx,(%esp)
  801a81:	e8 bd fb ff ff       	call   801643 <close>
	return r;
  801a86:	89 f0                	mov    %esi,%eax
}
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 10             	sub    $0x10,%esp
  801a97:	89 c6                	mov    %eax,%esi
  801a99:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a9b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801aa2:	75 11                	jne    801ab5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aab:	e8 5c f9 ff ff       	call   80140c <ipc_find_env>
  801ab0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ab5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801abc:	00 
  801abd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801ac4:	00 
  801ac5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac9:	a1 00 40 80 00       	mov    0x804000,%eax
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 d0 f8 ff ff       	call   8013a6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ad6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801add:	00 
  801ade:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae9:	e8 4e f8 ff ff       	call   80133c <ipc_recv>
}
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 14             	sub    $0x14,%esp
  801afc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	8b 40 0c             	mov    0xc(%eax),%eax
  801b05:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b14:	e8 76 ff ff ff       	call   801a8f <fsipc>
  801b19:	89 c2                	mov    %eax,%edx
  801b1b:	85 d2                	test   %edx,%edx
  801b1d:	78 2b                	js     801b4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b1f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b26:	00 
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 ac ed ff ff       	call   8008db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b2f:	a1 80 50 80 00       	mov    0x805080,%eax
  801b34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b3a:	a1 84 50 80 00       	mov    0x805084,%eax
  801b3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4a:	83 c4 14             	add    $0x14,%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6b:	e8 1f ff ff ff       	call   801a8f <fsipc>
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	83 ec 10             	sub    $0x10,%esp
  801b7a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	8b 40 0c             	mov    0xc(%eax),%eax
  801b83:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b88:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	b8 03 00 00 00       	mov    $0x3,%eax
  801b98:	e8 f2 fe ff ff       	call   801a8f <fsipc>
  801b9d:	89 c3                	mov    %eax,%ebx
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 6a                	js     801c0d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ba3:	39 c6                	cmp    %eax,%esi
  801ba5:	73 24                	jae    801bcb <devfile_read+0x59>
  801ba7:	c7 44 24 0c 4e 2b 80 	movl   $0x802b4e,0xc(%esp)
  801bae:	00 
  801baf:	c7 44 24 08 55 2b 80 	movl   $0x802b55,0x8(%esp)
  801bb6:	00 
  801bb7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801bbe:	00 
  801bbf:	c7 04 24 6a 2b 80 00 	movl   $0x802b6a,(%esp)
  801bc6:	e8 3b 06 00 00       	call   802206 <_panic>
	assert(r <= PGSIZE);
  801bcb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd0:	7e 24                	jle    801bf6 <devfile_read+0x84>
  801bd2:	c7 44 24 0c 75 2b 80 	movl   $0x802b75,0xc(%esp)
  801bd9:	00 
  801bda:	c7 44 24 08 55 2b 80 	movl   $0x802b55,0x8(%esp)
  801be1:	00 
  801be2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801be9:	00 
  801bea:	c7 04 24 6a 2b 80 00 	movl   $0x802b6a,(%esp)
  801bf1:	e8 10 06 00 00       	call   802206 <_panic>
	memmove(buf, &fsipcbuf, r);
  801bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bfa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c01:	00 
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	89 04 24             	mov    %eax,(%esp)
  801c08:	e8 c9 ee ff ff       	call   800ad6 <memmove>
	return r;
}
  801c0d:	89 d8                	mov    %ebx,%eax
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 24             	sub    $0x24,%esp
  801c1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c20:	89 1c 24             	mov    %ebx,(%esp)
  801c23:	e8 58 ec ff ff       	call   800880 <strlen>
  801c28:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c2d:	7f 60                	jg     801c8f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 4d f8 ff ff       	call   801487 <fd_alloc>
  801c3a:	89 c2                	mov    %eax,%edx
  801c3c:	85 d2                	test   %edx,%edx
  801c3e:	78 54                	js     801c94 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c44:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801c4b:	e8 8b ec ff ff       	call   8008db <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c53:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c60:	e8 2a fe ff ff       	call   801a8f <fsipc>
  801c65:	89 c3                	mov    %eax,%ebx
  801c67:	85 c0                	test   %eax,%eax
  801c69:	79 17                	jns    801c82 <open+0x6c>
		fd_close(fd, 0);
  801c6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c72:	00 
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	89 04 24             	mov    %eax,(%esp)
  801c79:	e8 44 f9 ff ff       	call   8015c2 <fd_close>
		return r;
  801c7e:	89 d8                	mov    %ebx,%eax
  801c80:	eb 12                	jmp    801c94 <open+0x7e>
	}

	return fd2num(fd);
  801c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c85:	89 04 24             	mov    %eax,(%esp)
  801c88:	e8 d3 f7 ff ff       	call   801460 <fd2num>
  801c8d:	eb 05                	jmp    801c94 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c8f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c94:	83 c4 24             	add    $0x24,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 10             	sub    $0x10,%esp
  801ca8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 ba f7 ff ff       	call   801470 <fd2data>
  801cb6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cb8:	c7 44 24 04 81 2b 80 	movl   $0x802b81,0x4(%esp)
  801cbf:	00 
  801cc0:	89 1c 24             	mov    %ebx,(%esp)
  801cc3:	e8 13 ec ff ff       	call   8008db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cc8:	8b 46 04             	mov    0x4(%esi),%eax
  801ccb:	2b 06                	sub    (%esi),%eax
  801ccd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cda:	00 00 00 
	stat->st_dev = &devpipe;
  801cdd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ce4:	30 80 00 
	return 0;
}
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 14             	sub    $0x14,%esp
  801cfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d08:	e8 23 f1 ff ff       	call   800e30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d0d:	89 1c 24             	mov    %ebx,(%esp)
  801d10:	e8 5b f7 ff ff       	call   801470 <fd2data>
  801d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d20:	e8 0b f1 ff ff       	call   800e30 <sys_page_unmap>
}
  801d25:	83 c4 14             	add    $0x14,%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 2c             	sub    $0x2c,%esp
  801d34:	89 c6                	mov    %eax,%esi
  801d36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d39:	a1 08 40 80 00       	mov    0x804008,%eax
  801d3e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d41:	89 34 24             	mov    %esi,(%esp)
  801d44:	e8 cd 05 00 00       	call   802316 <pageref>
  801d49:	89 c7                	mov    %eax,%edi
  801d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 c0 05 00 00       	call   802316 <pageref>
  801d56:	39 c7                	cmp    %eax,%edi
  801d58:	0f 94 c2             	sete   %dl
  801d5b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d5e:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801d64:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d67:	39 fb                	cmp    %edi,%ebx
  801d69:	74 21                	je     801d8c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d6b:	84 d2                	test   %dl,%dl
  801d6d:	74 ca                	je     801d39 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d6f:	8b 51 58             	mov    0x58(%ecx),%edx
  801d72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d76:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d7e:	c7 04 24 88 2b 80 00 	movl   $0x802b88,(%esp)
  801d85:	e8 f1 e4 ff ff       	call   80027b <cprintf>
  801d8a:	eb ad                	jmp    801d39 <_pipeisclosed+0xe>
	}
}
  801d8c:	83 c4 2c             	add    $0x2c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 1c             	sub    $0x1c,%esp
  801d9d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801da0:	89 34 24             	mov    %esi,(%esp)
  801da3:	e8 c8 f6 ff ff       	call   801470 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801da8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dac:	74 61                	je     801e0f <devpipe_write+0x7b>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	bf 00 00 00 00       	mov    $0x0,%edi
  801db5:	eb 4a                	jmp    801e01 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801db7:	89 da                	mov    %ebx,%edx
  801db9:	89 f0                	mov    %esi,%eax
  801dbb:	e8 6b ff ff ff       	call   801d2b <_pipeisclosed>
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	75 54                	jne    801e18 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801dc4:	e8 a1 ef ff ff       	call   800d6a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dcc:	8b 0b                	mov    (%ebx),%ecx
  801dce:	8d 51 20             	lea    0x20(%ecx),%edx
  801dd1:	39 d0                	cmp    %edx,%eax
  801dd3:	73 e2                	jae    801db7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ddc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ddf:	99                   	cltd   
  801de0:	c1 ea 1b             	shr    $0x1b,%edx
  801de3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801de6:	83 e1 1f             	and    $0x1f,%ecx
  801de9:	29 d1                	sub    %edx,%ecx
  801deb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801def:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801df3:	83 c0 01             	add    $0x1,%eax
  801df6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801df9:	83 c7 01             	add    $0x1,%edi
  801dfc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dff:	74 13                	je     801e14 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e01:	8b 43 04             	mov    0x4(%ebx),%eax
  801e04:	8b 0b                	mov    (%ebx),%ecx
  801e06:	8d 51 20             	lea    0x20(%ecx),%edx
  801e09:	39 d0                	cmp    %edx,%eax
  801e0b:	73 aa                	jae    801db7 <devpipe_write+0x23>
  801e0d:	eb c6                	jmp    801dd5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e0f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e14:	89 f8                	mov    %edi,%eax
  801e16:	eb 05                	jmp    801e1d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e1d:	83 c4 1c             	add    $0x1c,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	57                   	push   %edi
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 1c             	sub    $0x1c,%esp
  801e2e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e31:	89 3c 24             	mov    %edi,(%esp)
  801e34:	e8 37 f6 ff ff       	call   801470 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3d:	74 54                	je     801e93 <devpipe_read+0x6e>
  801e3f:	89 c3                	mov    %eax,%ebx
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
  801e46:	eb 3e                	jmp    801e86 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e48:	89 f0                	mov    %esi,%eax
  801e4a:	eb 55                	jmp    801ea1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e4c:	89 da                	mov    %ebx,%edx
  801e4e:	89 f8                	mov    %edi,%eax
  801e50:	e8 d6 fe ff ff       	call   801d2b <_pipeisclosed>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 43                	jne    801e9c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e59:	e8 0c ef ff ff       	call   800d6a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e5e:	8b 03                	mov    (%ebx),%eax
  801e60:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e63:	74 e7                	je     801e4c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e65:	99                   	cltd   
  801e66:	c1 ea 1b             	shr    $0x1b,%edx
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	83 e0 1f             	and    $0x1f,%eax
  801e6e:	29 d0                	sub    %edx,%eax
  801e70:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e78:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e7b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e7e:	83 c6 01             	add    $0x1,%esi
  801e81:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e84:	74 12                	je     801e98 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801e86:	8b 03                	mov    (%ebx),%eax
  801e88:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e8b:	75 d8                	jne    801e65 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e8d:	85 f6                	test   %esi,%esi
  801e8f:	75 b7                	jne    801e48 <devpipe_read+0x23>
  801e91:	eb b9                	jmp    801e4c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e93:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e98:	89 f0                	mov    %esi,%eax
  801e9a:	eb 05                	jmp    801ea1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	89 04 24             	mov    %eax,(%esp)
  801eb7:	e8 cb f5 ff ff       	call   801487 <fd_alloc>
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	85 d2                	test   %edx,%edx
  801ec0:	0f 88 4d 01 00 00    	js     802013 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ecd:	00 
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edc:	e8 a8 ee ff ff       	call   800d89 <sys_page_alloc>
  801ee1:	89 c2                	mov    %eax,%edx
  801ee3:	85 d2                	test   %edx,%edx
  801ee5:	0f 88 28 01 00 00    	js     802013 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801eeb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eee:	89 04 24             	mov    %eax,(%esp)
  801ef1:	e8 91 f5 ff ff       	call   801487 <fd_alloc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 fe 00 00 00    	js     801ffe <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f00:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f07:	00 
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f16:	e8 6e ee ff ff       	call   800d89 <sys_page_alloc>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 d9 00 00 00    	js     801ffe <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 40 f5 ff ff       	call   801470 <fd2data>
  801f30:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f32:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f39:	00 
  801f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f45:	e8 3f ee ff ff       	call   800d89 <sys_page_alloc>
  801f4a:	89 c3                	mov    %eax,%ebx
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	0f 88 97 00 00 00    	js     801feb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f57:	89 04 24             	mov    %eax,(%esp)
  801f5a:	e8 11 f5 ff ff       	call   801470 <fd2data>
  801f5f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f66:	00 
  801f67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f72:	00 
  801f73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7e:	e8 5a ee ff ff       	call   800ddd <sys_page_map>
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 52                	js     801fdb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f89:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f9e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	89 04 24             	mov    %eax,(%esp)
  801fb9:	e8 a2 f4 ff ff       	call   801460 <fd2num>
  801fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc6:	89 04 24             	mov    %eax,(%esp)
  801fc9:	e8 92 f4 ff ff       	call   801460 <fd2num>
  801fce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	eb 38                	jmp    802013 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fdb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe6:	e8 45 ee ff ff       	call   800e30 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff9:	e8 32 ee ff ff       	call   800e30 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	89 44 24 04          	mov    %eax,0x4(%esp)
  802005:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200c:	e8 1f ee ff ff       	call   800e30 <sys_page_unmap>
  802011:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802013:	83 c4 30             	add    $0x30,%esp
  802016:	5b                   	pop    %ebx
  802017:	5e                   	pop    %esi
  802018:	5d                   	pop    %ebp
  802019:	c3                   	ret    

0080201a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802020:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802023:	89 44 24 04          	mov    %eax,0x4(%esp)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	89 04 24             	mov    %eax,(%esp)
  80202d:	e8 c9 f4 ff ff       	call   8014fb <fd_lookup>
  802032:	89 c2                	mov    %eax,%edx
  802034:	85 d2                	test   %edx,%edx
  802036:	78 15                	js     80204d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	89 04 24             	mov    %eax,(%esp)
  80203e:	e8 2d f4 ff ff       	call   801470 <fd2data>
	return _pipeisclosed(fd, p);
  802043:	89 c2                	mov    %eax,%edx
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	e8 de fc ff ff       	call   801d2b <_pipeisclosed>
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    
  80204f:	90                   	nop

00802050 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802060:	c7 44 24 04 a0 2b 80 	movl   $0x802ba0,0x4(%esp)
  802067:	00 
  802068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206b:	89 04 24             	mov    %eax,(%esp)
  80206e:	e8 68 e8 ff ff       	call   8008db <strcpy>
	return 0;
}
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	57                   	push   %edi
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802086:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208a:	74 4a                	je     8020d6 <devcons_write+0x5c>
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802096:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80209c:	8b 75 10             	mov    0x10(%ebp),%esi
  80209f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8020a1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020a4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020a9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020ac:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020b0:	03 45 0c             	add    0xc(%ebp),%eax
  8020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b7:	89 3c 24             	mov    %edi,(%esp)
  8020ba:	e8 17 ea ff ff       	call   800ad6 <memmove>
		sys_cputs(buf, m);
  8020bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c3:	89 3c 24             	mov    %edi,(%esp)
  8020c6:	e8 f1 eb ff ff       	call   800cbc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020cb:	01 f3                	add    %esi,%ebx
  8020cd:	89 d8                	mov    %ebx,%eax
  8020cf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020d2:	72 c8                	jb     80209c <devcons_write+0x22>
  8020d4:	eb 05                	jmp    8020db <devcons_write+0x61>
  8020d6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    

008020e8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f7:	75 07                	jne    802100 <devcons_read+0x18>
  8020f9:	eb 28                	jmp    802123 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020fb:	e8 6a ec ff ff       	call   800d6a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802100:	e8 d5 eb ff ff       	call   800cda <sys_cgetc>
  802105:	85 c0                	test   %eax,%eax
  802107:	74 f2                	je     8020fb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 16                	js     802123 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80210d:	83 f8 04             	cmp    $0x4,%eax
  802110:	74 0c                	je     80211e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802112:	8b 55 0c             	mov    0xc(%ebp),%edx
  802115:	88 02                	mov    %al,(%edx)
	return 1;
  802117:	b8 01 00 00 00       	mov    $0x1,%eax
  80211c:	eb 05                	jmp    802123 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802138:	00 
  802139:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 78 eb ff ff       	call   800cbc <sys_cputs>
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <getchar>:

int
getchar(void)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80214c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802153:	00 
  802154:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802162:	e8 3f f6 ff ff       	call   8017a6 <read>
	if (r < 0)
  802167:	85 c0                	test   %eax,%eax
  802169:	78 0f                	js     80217a <getchar+0x34>
		return r;
	if (r < 1)
  80216b:	85 c0                	test   %eax,%eax
  80216d:	7e 06                	jle    802175 <getchar+0x2f>
		return -E_EOF;
	return c;
  80216f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802173:	eb 05                	jmp    80217a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802175:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 67 f3 ff ff       	call   8014fb <fd_lookup>
  802194:	85 c0                	test   %eax,%eax
  802196:	78 11                	js     8021a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021a1:	39 10                	cmp    %edx,(%eax)
  8021a3:	0f 94 c0             	sete   %al
  8021a6:	0f b6 c0             	movzbl %al,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <opencons>:

int
opencons(void)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 cb f2 ff ff       	call   801487 <fd_alloc>
		return r;
  8021bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 40                	js     802202 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021c9:	00 
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d8:	e8 ac eb ff ff       	call   800d89 <sys_page_alloc>
		return r;
  8021dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 1f                	js     802202 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021e3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f8:	89 04 24             	mov    %eax,(%esp)
  8021fb:	e8 60 f2 ff ff       	call   801460 <fd2num>
  802200:	89 c2                	mov    %eax,%edx
}
  802202:	89 d0                	mov    %edx,%eax
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	56                   	push   %esi
  80220a:	53                   	push   %ebx
  80220b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80220e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802211:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802217:	e8 2f eb ff ff       	call   800d4b <sys_getenvid>
  80221c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802223:	8b 55 08             	mov    0x8(%ebp),%edx
  802226:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80222a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80222e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802232:	c7 04 24 ac 2b 80 00 	movl   $0x802bac,(%esp)
  802239:	e8 3d e0 ff ff       	call   80027b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80223e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802242:	8b 45 10             	mov    0x10(%ebp),%eax
  802245:	89 04 24             	mov    %eax,(%esp)
  802248:	e8 cd df ff ff       	call   80021a <vcprintf>
	cprintf("\n");
  80224d:	c7 04 24 99 2b 80 00 	movl   $0x802b99,(%esp)
  802254:	e8 22 e0 ff ff       	call   80027b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802259:	cc                   	int3   
  80225a:	eb fd                	jmp    802259 <_panic+0x53>

0080225c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  802262:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802269:	75 50                	jne    8022bb <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80226b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802272:	00 
  802273:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80227a:	ee 
  80227b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802282:	e8 02 eb ff ff       	call   800d89 <sys_page_alloc>
  802287:	85 c0                	test   %eax,%eax
  802289:	79 1c                	jns    8022a7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  80228b:	c7 44 24 08 d0 2b 80 	movl   $0x802bd0,0x8(%esp)
  802292:	00 
  802293:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80229a:	00 
  80229b:	c7 04 24 f4 2b 80 00 	movl   $0x802bf4,(%esp)
  8022a2:	e8 5f ff ff ff       	call   802206 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8022a7:	c7 44 24 04 c5 22 80 	movl   $0x8022c5,0x4(%esp)
  8022ae:	00 
  8022af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b6:	e8 6e ec ff ff       	call   800f29 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022c5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022c6:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022cb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022cd:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8022d0:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8022d2:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8022d7:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8022da:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8022df:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8022e2:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8022e4:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8022e7:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8022e9:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8022eb:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8022f0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8022f3:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8022f8:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8022fb:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8022fd:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  802302:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  802305:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80230a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  80230d:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  80230f:	83 c4 08             	add    $0x8,%esp
	popal
  802312:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802313:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802314:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802315:	c3                   	ret    

00802316 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80231c:	89 d0                	mov    %edx,%eax
  80231e:	c1 e8 16             	shr    $0x16,%eax
  802321:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80232d:	f6 c1 01             	test   $0x1,%cl
  802330:	74 1d                	je     80234f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802332:	c1 ea 0c             	shr    $0xc,%edx
  802335:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80233c:	f6 c2 01             	test   $0x1,%dl
  80233f:	74 0e                	je     80234f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802341:	c1 ea 0c             	shr    $0xc,%edx
  802344:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80234b:	ef 
  80234c:	0f b7 c0             	movzwl %ax,%eax
}
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	66 90                	xchg   %ax,%ax
  802353:	66 90                	xchg   %ax,%ax
  802355:	66 90                	xchg   %ax,%ax
  802357:	66 90                	xchg   %ax,%ax
  802359:	66 90                	xchg   %ax,%ax
  80235b:	66 90                	xchg   %ax,%ax
  80235d:	66 90                	xchg   %ax,%ax
  80235f:	90                   	nop

00802360 <__udivdi3>:
  802360:	55                   	push   %ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	8b 44 24 28          	mov    0x28(%esp),%eax
  80236a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80236e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802372:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802376:	85 c0                	test   %eax,%eax
  802378:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80237c:	89 ea                	mov    %ebp,%edx
  80237e:	89 0c 24             	mov    %ecx,(%esp)
  802381:	75 2d                	jne    8023b0 <__udivdi3+0x50>
  802383:	39 e9                	cmp    %ebp,%ecx
  802385:	77 61                	ja     8023e8 <__udivdi3+0x88>
  802387:	85 c9                	test   %ecx,%ecx
  802389:	89 ce                	mov    %ecx,%esi
  80238b:	75 0b                	jne    802398 <__udivdi3+0x38>
  80238d:	b8 01 00 00 00       	mov    $0x1,%eax
  802392:	31 d2                	xor    %edx,%edx
  802394:	f7 f1                	div    %ecx
  802396:	89 c6                	mov    %eax,%esi
  802398:	31 d2                	xor    %edx,%edx
  80239a:	89 e8                	mov    %ebp,%eax
  80239c:	f7 f6                	div    %esi
  80239e:	89 c5                	mov    %eax,%ebp
  8023a0:	89 f8                	mov    %edi,%eax
  8023a2:	f7 f6                	div    %esi
  8023a4:	89 ea                	mov    %ebp,%edx
  8023a6:	83 c4 0c             	add    $0xc,%esp
  8023a9:	5e                   	pop    %esi
  8023aa:	5f                   	pop    %edi
  8023ab:	5d                   	pop    %ebp
  8023ac:	c3                   	ret    
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	39 e8                	cmp    %ebp,%eax
  8023b2:	77 24                	ja     8023d8 <__udivdi3+0x78>
  8023b4:	0f bd e8             	bsr    %eax,%ebp
  8023b7:	83 f5 1f             	xor    $0x1f,%ebp
  8023ba:	75 3c                	jne    8023f8 <__udivdi3+0x98>
  8023bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8023c0:	39 34 24             	cmp    %esi,(%esp)
  8023c3:	0f 86 9f 00 00 00    	jbe    802468 <__udivdi3+0x108>
  8023c9:	39 d0                	cmp    %edx,%eax
  8023cb:	0f 82 97 00 00 00    	jb     802468 <__udivdi3+0x108>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	31 d2                	xor    %edx,%edx
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	83 c4 0c             	add    $0xc,%esp
  8023df:	5e                   	pop    %esi
  8023e0:	5f                   	pop    %edi
  8023e1:	5d                   	pop    %ebp
  8023e2:	c3                   	ret    
  8023e3:	90                   	nop
  8023e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 f8                	mov    %edi,%eax
  8023ea:	f7 f1                	div    %ecx
  8023ec:	31 d2                	xor    %edx,%edx
  8023ee:	83 c4 0c             	add    $0xc,%esp
  8023f1:	5e                   	pop    %esi
  8023f2:	5f                   	pop    %edi
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	89 e9                	mov    %ebp,%ecx
  8023fa:	8b 3c 24             	mov    (%esp),%edi
  8023fd:	d3 e0                	shl    %cl,%eax
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	b8 20 00 00 00       	mov    $0x20,%eax
  802406:	29 e8                	sub    %ebp,%eax
  802408:	89 c1                	mov    %eax,%ecx
  80240a:	d3 ef                	shr    %cl,%edi
  80240c:	89 e9                	mov    %ebp,%ecx
  80240e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802412:	8b 3c 24             	mov    (%esp),%edi
  802415:	09 74 24 08          	or     %esi,0x8(%esp)
  802419:	89 d6                	mov    %edx,%esi
  80241b:	d3 e7                	shl    %cl,%edi
  80241d:	89 c1                	mov    %eax,%ecx
  80241f:	89 3c 24             	mov    %edi,(%esp)
  802422:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802426:	d3 ee                	shr    %cl,%esi
  802428:	89 e9                	mov    %ebp,%ecx
  80242a:	d3 e2                	shl    %cl,%edx
  80242c:	89 c1                	mov    %eax,%ecx
  80242e:	d3 ef                	shr    %cl,%edi
  802430:	09 d7                	or     %edx,%edi
  802432:	89 f2                	mov    %esi,%edx
  802434:	89 f8                	mov    %edi,%eax
  802436:	f7 74 24 08          	divl   0x8(%esp)
  80243a:	89 d6                	mov    %edx,%esi
  80243c:	89 c7                	mov    %eax,%edi
  80243e:	f7 24 24             	mull   (%esp)
  802441:	39 d6                	cmp    %edx,%esi
  802443:	89 14 24             	mov    %edx,(%esp)
  802446:	72 30                	jb     802478 <__udivdi3+0x118>
  802448:	8b 54 24 04          	mov    0x4(%esp),%edx
  80244c:	89 e9                	mov    %ebp,%ecx
  80244e:	d3 e2                	shl    %cl,%edx
  802450:	39 c2                	cmp    %eax,%edx
  802452:	73 05                	jae    802459 <__udivdi3+0xf9>
  802454:	3b 34 24             	cmp    (%esp),%esi
  802457:	74 1f                	je     802478 <__udivdi3+0x118>
  802459:	89 f8                	mov    %edi,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	e9 7a ff ff ff       	jmp    8023dc <__udivdi3+0x7c>
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	b8 01 00 00 00       	mov    $0x1,%eax
  80246f:	e9 68 ff ff ff       	jmp    8023dc <__udivdi3+0x7c>
  802474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802478:	8d 47 ff             	lea    -0x1(%edi),%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	83 c4 0c             	add    $0xc,%esp
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    
  802484:	66 90                	xchg   %ax,%ax
  802486:	66 90                	xchg   %ax,%ax
  802488:	66 90                	xchg   %ax,%ax
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__umoddi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	83 ec 14             	sub    $0x14,%esp
  802496:	8b 44 24 28          	mov    0x28(%esp),%eax
  80249a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80249e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8024ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8024b0:	89 34 24             	mov    %esi,(%esp)
  8024b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	89 c2                	mov    %eax,%edx
  8024bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024bf:	75 17                	jne    8024d8 <__umoddi3+0x48>
  8024c1:	39 fe                	cmp    %edi,%esi
  8024c3:	76 4b                	jbe    802510 <__umoddi3+0x80>
  8024c5:	89 c8                	mov    %ecx,%eax
  8024c7:	89 fa                	mov    %edi,%edx
  8024c9:	f7 f6                	div    %esi
  8024cb:	89 d0                	mov    %edx,%eax
  8024cd:	31 d2                	xor    %edx,%edx
  8024cf:	83 c4 14             	add    $0x14,%esp
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	39 f8                	cmp    %edi,%eax
  8024da:	77 54                	ja     802530 <__umoddi3+0xa0>
  8024dc:	0f bd e8             	bsr    %eax,%ebp
  8024df:	83 f5 1f             	xor    $0x1f,%ebp
  8024e2:	75 5c                	jne    802540 <__umoddi3+0xb0>
  8024e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024e8:	39 3c 24             	cmp    %edi,(%esp)
  8024eb:	0f 87 e7 00 00 00    	ja     8025d8 <__umoddi3+0x148>
  8024f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024f5:	29 f1                	sub    %esi,%ecx
  8024f7:	19 c7                	sbb    %eax,%edi
  8024f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802501:	8b 44 24 08          	mov    0x8(%esp),%eax
  802505:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802509:	83 c4 14             	add    $0x14,%esp
  80250c:	5e                   	pop    %esi
  80250d:	5f                   	pop    %edi
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    
  802510:	85 f6                	test   %esi,%esi
  802512:	89 f5                	mov    %esi,%ebp
  802514:	75 0b                	jne    802521 <__umoddi3+0x91>
  802516:	b8 01 00 00 00       	mov    $0x1,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f6                	div    %esi
  80251f:	89 c5                	mov    %eax,%ebp
  802521:	8b 44 24 04          	mov    0x4(%esp),%eax
  802525:	31 d2                	xor    %edx,%edx
  802527:	f7 f5                	div    %ebp
  802529:	89 c8                	mov    %ecx,%eax
  80252b:	f7 f5                	div    %ebp
  80252d:	eb 9c                	jmp    8024cb <__umoddi3+0x3b>
  80252f:	90                   	nop
  802530:	89 c8                	mov    %ecx,%eax
  802532:	89 fa                	mov    %edi,%edx
  802534:	83 c4 14             	add    $0x14,%esp
  802537:	5e                   	pop    %esi
  802538:	5f                   	pop    %edi
  802539:	5d                   	pop    %ebp
  80253a:	c3                   	ret    
  80253b:	90                   	nop
  80253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802540:	8b 04 24             	mov    (%esp),%eax
  802543:	be 20 00 00 00       	mov    $0x20,%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	29 ee                	sub    %ebp,%esi
  80254c:	d3 e2                	shl    %cl,%edx
  80254e:	89 f1                	mov    %esi,%ecx
  802550:	d3 e8                	shr    %cl,%eax
  802552:	89 e9                	mov    %ebp,%ecx
  802554:	89 44 24 04          	mov    %eax,0x4(%esp)
  802558:	8b 04 24             	mov    (%esp),%eax
  80255b:	09 54 24 04          	or     %edx,0x4(%esp)
  80255f:	89 fa                	mov    %edi,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 f1                	mov    %esi,%ecx
  802565:	89 44 24 08          	mov    %eax,0x8(%esp)
  802569:	8b 44 24 10          	mov    0x10(%esp),%eax
  80256d:	d3 ea                	shr    %cl,%edx
  80256f:	89 e9                	mov    %ebp,%ecx
  802571:	d3 e7                	shl    %cl,%edi
  802573:	89 f1                	mov    %esi,%ecx
  802575:	d3 e8                	shr    %cl,%eax
  802577:	89 e9                	mov    %ebp,%ecx
  802579:	09 f8                	or     %edi,%eax
  80257b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80257f:	f7 74 24 04          	divl   0x4(%esp)
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802589:	89 d7                	mov    %edx,%edi
  80258b:	f7 64 24 08          	mull   0x8(%esp)
  80258f:	39 d7                	cmp    %edx,%edi
  802591:	89 c1                	mov    %eax,%ecx
  802593:	89 14 24             	mov    %edx,(%esp)
  802596:	72 2c                	jb     8025c4 <__umoddi3+0x134>
  802598:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80259c:	72 22                	jb     8025c0 <__umoddi3+0x130>
  80259e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8025a2:	29 c8                	sub    %ecx,%eax
  8025a4:	19 d7                	sbb    %edx,%edi
  8025a6:	89 e9                	mov    %ebp,%ecx
  8025a8:	89 fa                	mov    %edi,%edx
  8025aa:	d3 e8                	shr    %cl,%eax
  8025ac:	89 f1                	mov    %esi,%ecx
  8025ae:	d3 e2                	shl    %cl,%edx
  8025b0:	89 e9                	mov    %ebp,%ecx
  8025b2:	d3 ef                	shr    %cl,%edi
  8025b4:	09 d0                	or     %edx,%eax
  8025b6:	89 fa                	mov    %edi,%edx
  8025b8:	83 c4 14             	add    $0x14,%esp
  8025bb:	5e                   	pop    %esi
  8025bc:	5f                   	pop    %edi
  8025bd:	5d                   	pop    %ebp
  8025be:	c3                   	ret    
  8025bf:	90                   	nop
  8025c0:	39 d7                	cmp    %edx,%edi
  8025c2:	75 da                	jne    80259e <__umoddi3+0x10e>
  8025c4:	8b 14 24             	mov    (%esp),%edx
  8025c7:	89 c1                	mov    %eax,%ecx
  8025c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8025cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025d1:	eb cb                	jmp    80259e <__umoddi3+0x10e>
  8025d3:	90                   	nop
  8025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025dc:	0f 82 0f ff ff ff    	jb     8024f1 <__umoddi3+0x61>
  8025e2:	e9 1a ff ff ff       	jmp    802501 <__umoddi3+0x71>
