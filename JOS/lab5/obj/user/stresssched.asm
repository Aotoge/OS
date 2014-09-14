
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 f2 00 00 00       	call   800123 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 2e 0d 00 00       	call   800d7b <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 b7 10 00 00       	call   801110 <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 23                	jmp    80008a <umain+0x4a>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 1e                	je     80008a <umain+0x4a>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	89 f0                	mov    %esi,%eax
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800076:	81 c2 04 00 c0 ee    	add    $0xeec00004,%edx
  80007c:	8b 52 50             	mov    0x50(%edx),%edx
  80007f:	85 d2                	test   %edx,%edx
  800081:	75 12                	jne    800095 <umain+0x55>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  800083:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800088:	eb 1f                	jmp    8000a9 <umain+0x69>
		if (fork() == 0)
			break;
	if (i == 20) {
		sys_yield();
  80008a:	e8 0b 0d 00 00       	call   800d9a <sys_yield>
		return;
  80008f:	90                   	nop
  800090:	e9 87 00 00 00       	jmp    80011c <umain+0xdc>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	8d 90 04 00 c0 ee    	lea    -0x113ffffc(%eax),%edx
		asm volatile("pause");
  80009e:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a0:	8b 42 50             	mov    0x50(%edx),%eax
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 f7                	jne    80009e <umain+0x5e>
  8000a7:	eb da                	jmp    800083 <umain+0x43>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  8000a9:	e8 ec 0c 00 00       	call   800d9a <sys_yield>
  8000ae:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000b3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8000b9:	83 c2 01             	add    $0x1,%edx
  8000bc:	89 15 04 40 80 00    	mov    %edx,0x804004
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000c2:	83 e8 01             	sub    $0x1,%eax
  8000c5:	75 ec                	jne    8000b3 <umain+0x73>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000c7:	83 eb 01             	sub    $0x1,%ebx
  8000ca:	75 dd                	jne    8000a9 <umain+0x69>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000cc:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d1:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000d6:	74 25                	je     8000fd <umain+0xbd>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000e1:	c7 44 24 08 00 26 80 	movl   $0x802600,0x8(%esp)
  8000e8:	00 
  8000e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000f0:	00 
  8000f1:	c7 04 24 28 26 80 00 	movl   $0x802628,(%esp)
  8000f8:	e8 b7 00 00 00       	call   8001b4 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000fd:	a1 08 40 80 00       	mov    0x804008,%eax
  800102:	8b 50 5c             	mov    0x5c(%eax),%edx
  800105:	8b 40 48             	mov    0x48(%eax),%eax
  800108:	89 54 24 08          	mov    %edx,0x8(%esp)
  80010c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800110:	c7 04 24 3b 26 80 00 	movl   $0x80263b,(%esp)
  800117:	e8 91 01 00 00       	call   8002ad <cprintf>

}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
  800128:	83 ec 10             	sub    $0x10,%esp
  80012b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80012e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800131:	e8 45 0c 00 00       	call   800d7b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800136:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80013c:	39 c2                	cmp    %eax,%edx
  80013e:	74 17                	je     800157 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800140:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800145:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800148:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80014e:	8b 49 40             	mov    0x40(%ecx),%ecx
  800151:	39 c1                	cmp    %eax,%ecx
  800153:	75 18                	jne    80016d <libmain+0x4a>
  800155:	eb 05                	jmp    80015c <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80015c:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80015f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800165:	89 15 08 40 80 00    	mov    %edx,0x804008
			break;
  80016b:	eb 0b                	jmp    800178 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80016d:	83 c2 01             	add    $0x1,%edx
  800170:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800176:	75 cd                	jne    800145 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800178:	85 db                	test   %ebx,%ebx
  80017a:	7e 07                	jle    800183 <libmain+0x60>
		binaryname = argv[0];
  80017c:	8b 06                	mov    (%esi),%eax
  80017e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 b1 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80018f:	e8 07 00 00 00       	call   80019b <exit>
}
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a1:	e8 e0 13 00 00       	call   801586 <close_all>
	sys_env_destroy(0);
  8001a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ad:	e8 77 0b 00 00       	call   800d29 <sys_env_destroy>
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001bc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001bf:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001c5:	e8 b1 0b 00 00       	call   800d7b <sys_getenvid>
  8001ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001d8:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e0:	c7 04 24 64 26 80 00 	movl   $0x802664,(%esp)
  8001e7:	e8 c1 00 00 00       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 51 00 00 00       	call   80024c <vcprintf>
	cprintf("\n");
  8001fb:	c7 04 24 57 26 80 00 	movl   $0x802657,(%esp)
  800202:	e8 a6 00 00 00       	call   8002ad <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800207:	cc                   	int3   
  800208:	eb fd                	jmp    800207 <_panic+0x53>

0080020a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	53                   	push   %ebx
  80020e:	83 ec 14             	sub    $0x14,%esp
  800211:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800214:	8b 13                	mov    (%ebx),%edx
  800216:	8d 42 01             	lea    0x1(%edx),%eax
  800219:	89 03                	mov    %eax,(%ebx)
  80021b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800222:	3d ff 00 00 00       	cmp    $0xff,%eax
  800227:	75 19                	jne    800242 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800229:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800230:	00 
  800231:	8d 43 08             	lea    0x8(%ebx),%eax
  800234:	89 04 24             	mov    %eax,(%esp)
  800237:	e8 b0 0a 00 00       	call   800cec <sys_cputs>
		b->idx = 0;
  80023c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800242:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800246:	83 c4 14             	add    $0x14,%esp
  800249:	5b                   	pop    %ebx
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800255:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025c:	00 00 00 
	b.cnt = 0;
  80025f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800266:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	89 44 24 08          	mov    %eax,0x8(%esp)
  800277:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800281:	c7 04 24 0a 02 80 00 	movl   $0x80020a,(%esp)
  800288:	e8 b7 01 00 00       	call   800444 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800293:	89 44 24 04          	mov    %eax,0x4(%esp)
  800297:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029d:	89 04 24             	mov    %eax,(%esp)
  8002a0:	e8 47 0a 00 00       	call   800cec <sys_cputs>

	return b.cnt;
}
  8002a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bd:	89 04 24             	mov    %eax,(%esp)
  8002c0:	e8 87 ff ff ff       	call   80024c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    
  8002c7:	66 90                	xchg   %ax,%ax
  8002c9:	66 90                	xchg   %ax,%ax
  8002cb:	66 90                	xchg   %ax,%ax
  8002cd:	66 90                	xchg   %ax,%ax
  8002cf:	90                   	nop

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8002ea:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f8:	39 f1                	cmp    %esi,%ecx
  8002fa:	72 14                	jb     800310 <printnum+0x40>
  8002fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ff:	76 0f                	jbe    800310 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800301:	8b 45 14             	mov    0x14(%ebp),%eax
  800304:	8d 70 ff             	lea    -0x1(%eax),%esi
  800307:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80030a:	85 f6                	test   %esi,%esi
  80030c:	7f 60                	jg     80036e <printnum+0x9e>
  80030e:	eb 72                	jmp    800382 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800310:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800313:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800317:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80031a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80031d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800321:	89 44 24 08          	mov    %eax,0x8(%esp)
  800325:	8b 44 24 08          	mov    0x8(%esp),%eax
  800329:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80032d:	89 c3                	mov    %eax,%ebx
  80032f:	89 d6                	mov    %edx,%esi
  800331:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800334:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800337:	89 54 24 08          	mov    %edx,0x8(%esp)
  80033b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80033f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800342:	89 04 24             	mov    %eax,(%esp)
  800345:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034c:	e8 0f 20 00 00       	call   802360 <__udivdi3>
  800351:	89 d9                	mov    %ebx,%ecx
  800353:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800357:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80035b:	89 04 24             	mov    %eax,(%esp)
  80035e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800362:	89 fa                	mov    %edi,%edx
  800364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800367:	e8 64 ff ff ff       	call   8002d0 <printnum>
  80036c:	eb 14                	jmp    800382 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80036e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800372:	8b 45 18             	mov    0x18(%ebp),%eax
  800375:	89 04 24             	mov    %eax,(%esp)
  800378:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80037a:	83 ee 01             	sub    $0x1,%esi
  80037d:	75 ef                	jne    80036e <printnum+0x9e>
  80037f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800382:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800386:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80038a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80038d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800390:	89 44 24 08          	mov    %eax,0x8(%esp)
  800394:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a5:	e8 e6 20 00 00       	call   802490 <__umoddi3>
  8003aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ae:	0f be 80 87 26 80 00 	movsbl 0x802687(%eax),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003bb:	ff d0                	call   *%eax
}
  8003bd:	83 c4 3c             	add    $0x3c,%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5e                   	pop    %esi
  8003c2:	5f                   	pop    %edi
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    

008003c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c8:	83 fa 01             	cmp    $0x1,%edx
  8003cb:	7e 0e                	jle    8003db <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003cd:	8b 10                	mov    (%eax),%edx
  8003cf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003d2:	89 08                	mov    %ecx,(%eax)
  8003d4:	8b 02                	mov    (%edx),%eax
  8003d6:	8b 52 04             	mov    0x4(%edx),%edx
  8003d9:	eb 22                	jmp    8003fd <getuint+0x38>
	else if (lflag)
  8003db:	85 d2                	test   %edx,%edx
  8003dd:	74 10                	je     8003ef <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003df:	8b 10                	mov    (%eax),%edx
  8003e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e4:	89 08                	mov    %ecx,(%eax)
  8003e6:	8b 02                	mov    (%edx),%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	eb 0e                	jmp    8003fd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003ef:	8b 10                	mov    (%eax),%edx
  8003f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f4:	89 08                	mov    %ecx,(%eax)
  8003f6:	8b 02                	mov    (%edx),%eax
  8003f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800405:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800409:	8b 10                	mov    (%eax),%edx
  80040b:	3b 50 04             	cmp    0x4(%eax),%edx
  80040e:	73 0a                	jae    80041a <sprintputch+0x1b>
		*b->buf++ = ch;
  800410:	8d 4a 01             	lea    0x1(%edx),%ecx
  800413:	89 08                	mov    %ecx,(%eax)
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	88 02                	mov    %al,(%edx)
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800422:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800425:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800429:	8b 45 10             	mov    0x10(%ebp),%eax
  80042c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	89 44 24 04          	mov    %eax,0x4(%esp)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	89 04 24             	mov    %eax,(%esp)
  80043d:	e8 02 00 00 00       	call   800444 <vprintfmt>
	va_end(ap);
}
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	57                   	push   %edi
  800448:	56                   	push   %esi
  800449:	53                   	push   %ebx
  80044a:	83 ec 3c             	sub    $0x3c,%esp
  80044d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800450:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800453:	eb 18                	jmp    80046d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800455:	85 c0                	test   %eax,%eax
  800457:	0f 84 c3 03 00 00    	je     800820 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80045d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800461:	89 04 24             	mov    %eax,(%esp)
  800464:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800467:	89 f3                	mov    %esi,%ebx
  800469:	eb 02                	jmp    80046d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80046b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046d:	8d 73 01             	lea    0x1(%ebx),%esi
  800470:	0f b6 03             	movzbl (%ebx),%eax
  800473:	83 f8 25             	cmp    $0x25,%eax
  800476:	75 dd                	jne    800455 <vprintfmt+0x11>
  800478:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80047c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800483:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80048a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800491:	ba 00 00 00 00       	mov    $0x0,%edx
  800496:	eb 1d                	jmp    8004b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800498:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80049a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80049e:	eb 15                	jmp    8004b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8004a6:	eb 0d                	jmp    8004b5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ae:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004b8:	0f b6 06             	movzbl (%esi),%eax
  8004bb:	0f b6 c8             	movzbl %al,%ecx
  8004be:	83 e8 23             	sub    $0x23,%eax
  8004c1:	3c 55                	cmp    $0x55,%al
  8004c3:	0f 87 2f 03 00 00    	ja     8007f8 <vprintfmt+0x3b4>
  8004c9:	0f b6 c0             	movzbl %al,%eax
  8004cc:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8004d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8004d9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004dd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8004e0:	83 f9 09             	cmp    $0x9,%ecx
  8004e3:	77 50                	ja     800535 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	89 de                	mov    %ebx,%esi
  8004e7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ea:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004ed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004f0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004f4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004f7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004fa:	83 fb 09             	cmp    $0x9,%ebx
  8004fd:	76 eb                	jbe    8004ea <vprintfmt+0xa6>
  8004ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800502:	eb 33                	jmp    800537 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 48 04             	lea    0x4(%eax),%ecx
  80050a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800514:	eb 21                	jmp    800537 <vprintfmt+0xf3>
  800516:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800519:	85 c9                	test   %ecx,%ecx
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	0f 49 c1             	cmovns %ecx,%eax
  800523:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	89 de                	mov    %ebx,%esi
  800528:	eb 8b                	jmp    8004b5 <vprintfmt+0x71>
  80052a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80052c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800533:	eb 80                	jmp    8004b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800535:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053b:	0f 89 74 ff ff ff    	jns    8004b5 <vprintfmt+0x71>
  800541:	e9 62 ff ff ff       	jmp    8004a8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800546:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800549:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80054b:	e9 65 ff ff ff       	jmp    8004b5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 50 04             	lea    0x4(%eax),%edx
  800556:	89 55 14             	mov    %edx,0x14(%ebp)
  800559:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 04 24             	mov    %eax,(%esp)
  800562:	ff 55 08             	call   *0x8(%ebp)
			break;
  800565:	e9 03 ff ff ff       	jmp    80046d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8d 50 04             	lea    0x4(%eax),%edx
  800570:	89 55 14             	mov    %edx,0x14(%ebp)
  800573:	8b 00                	mov    (%eax),%eax
  800575:	99                   	cltd   
  800576:	31 d0                	xor    %edx,%eax
  800578:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057a:	83 f8 0f             	cmp    $0xf,%eax
  80057d:	7f 0b                	jg     80058a <vprintfmt+0x146>
  80057f:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800586:	85 d2                	test   %edx,%edx
  800588:	75 20                	jne    8005aa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80058a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058e:	c7 44 24 08 9f 26 80 	movl   $0x80269f,0x8(%esp)
  800595:	00 
  800596:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	89 04 24             	mov    %eax,(%esp)
  8005a0:	e8 77 fe ff ff       	call   80041c <printfmt>
  8005a5:	e9 c3 fe ff ff       	jmp    80046d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ae:	c7 44 24 08 8f 2b 80 	movl   $0x802b8f,0x8(%esp)
  8005b5:	00 
  8005b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	89 04 24             	mov    %eax,(%esp)
  8005c0:	e8 57 fe ff ff       	call   80041c <printfmt>
  8005c5:	e9 a3 fe ff ff       	jmp    80046d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005cd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8d 50 04             	lea    0x4(%eax),%edx
  8005d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8005db:	85 c0                	test   %eax,%eax
  8005dd:	ba 98 26 80 00       	mov    $0x802698,%edx
  8005e2:	0f 45 d0             	cmovne %eax,%edx
  8005e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8005e8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8005ec:	74 04                	je     8005f2 <vprintfmt+0x1ae>
  8005ee:	85 f6                	test   %esi,%esi
  8005f0:	7f 19                	jg     80060b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f5:	8d 70 01             	lea    0x1(%eax),%esi
  8005f8:	0f b6 10             	movzbl (%eax),%edx
  8005fb:	0f be c2             	movsbl %dl,%eax
  8005fe:	85 c0                	test   %eax,%eax
  800600:	0f 85 95 00 00 00    	jne    80069b <vprintfmt+0x257>
  800606:	e9 85 00 00 00       	jmp    800690 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80060f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800612:	89 04 24             	mov    %eax,(%esp)
  800615:	e8 b8 02 00 00       	call   8008d2 <strnlen>
  80061a:	29 c6                	sub    %eax,%esi
  80061c:	89 f0                	mov    %esi,%eax
  80061e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800621:	85 f6                	test   %esi,%esi
  800623:	7e cd                	jle    8005f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800625:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800629:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80062c:	89 c3                	mov    %eax,%ebx
  80062e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800632:	89 34 24             	mov    %esi,(%esp)
  800635:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800638:	83 eb 01             	sub    $0x1,%ebx
  80063b:	75 f1                	jne    80062e <vprintfmt+0x1ea>
  80063d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800640:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800643:	eb ad                	jmp    8005f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800649:	74 1e                	je     800669 <vprintfmt+0x225>
  80064b:	0f be d2             	movsbl %dl,%edx
  80064e:	83 ea 20             	sub    $0x20,%edx
  800651:	83 fa 5e             	cmp    $0x5e,%edx
  800654:	76 13                	jbe    800669 <vprintfmt+0x225>
					putch('?', putdat);
  800656:	8b 45 0c             	mov    0xc(%ebp),%eax
  800659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800664:	ff 55 08             	call   *0x8(%ebp)
  800667:	eb 0d                	jmp    800676 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80066c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800670:	89 04 24             	mov    %eax,(%esp)
  800673:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800676:	83 ef 01             	sub    $0x1,%edi
  800679:	83 c6 01             	add    $0x1,%esi
  80067c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800680:	0f be c2             	movsbl %dl,%eax
  800683:	85 c0                	test   %eax,%eax
  800685:	75 20                	jne    8006a7 <vprintfmt+0x263>
  800687:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80068a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80068d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800690:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800694:	7f 25                	jg     8006bb <vprintfmt+0x277>
  800696:	e9 d2 fd ff ff       	jmp    80046d <vprintfmt+0x29>
  80069b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006a1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	78 9a                	js     800645 <vprintfmt+0x201>
  8006ab:	83 eb 01             	sub    $0x1,%ebx
  8006ae:	79 95                	jns    800645 <vprintfmt+0x201>
  8006b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006b9:	eb d5                	jmp    800690 <vprintfmt+0x24c>
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006cf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d1:	83 eb 01             	sub    $0x1,%ebx
  8006d4:	75 ee                	jne    8006c4 <vprintfmt+0x280>
  8006d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006d9:	e9 8f fd ff ff       	jmp    80046d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006de:	83 fa 01             	cmp    $0x1,%edx
  8006e1:	7e 16                	jle    8006f9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 50 08             	lea    0x8(%eax),%edx
  8006e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ec:	8b 50 04             	mov    0x4(%eax),%edx
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f7:	eb 32                	jmp    80072b <vprintfmt+0x2e7>
	else if (lflag)
  8006f9:	85 d2                	test   %edx,%edx
  8006fb:	74 18                	je     800715 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	89 55 14             	mov    %edx,0x14(%ebp)
  800706:	8b 30                	mov    (%eax),%esi
  800708:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80070b:	89 f0                	mov    %esi,%eax
  80070d:	c1 f8 1f             	sar    $0x1f,%eax
  800710:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800713:	eb 16                	jmp    80072b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 50 04             	lea    0x4(%eax),%edx
  80071b:	89 55 14             	mov    %edx,0x14(%ebp)
  80071e:	8b 30                	mov    (%eax),%esi
  800720:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800723:	89 f0                	mov    %esi,%eax
  800725:	c1 f8 1f             	sar    $0x1f,%eax
  800728:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80072e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800731:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800736:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073a:	0f 89 80 00 00 00    	jns    8007c0 <vprintfmt+0x37c>
				putch('-', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80074e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800751:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800754:	f7 d8                	neg    %eax
  800756:	83 d2 00             	adc    $0x0,%edx
  800759:	f7 da                	neg    %edx
			}
			base = 10;
  80075b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800760:	eb 5e                	jmp    8007c0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	e8 5b fc ff ff       	call   8003c5 <getuint>
			base = 10;
  80076a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80076f:	eb 4f                	jmp    8007c0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
  800774:	e8 4c fc ff ff       	call   8003c5 <getuint>
			base = 8;
  800779:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80077e:	eb 40                	jmp    8007c0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800784:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80078e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800792:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800799:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ac:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007b1:	eb 0d                	jmp    8007c0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b6:	e8 0a fc ff ff       	call   8003c5 <getuint>
			base = 16;
  8007bb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007c4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007cb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d3:	89 04 24             	mov    %eax,(%esp)
  8007d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007da:	89 fa                	mov    %edi,%edx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	e8 ec fa ff ff       	call   8002d0 <printnum>
			break;
  8007e4:	e9 84 fc ff ff       	jmp    80046d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ed:	89 0c 24             	mov    %ecx,(%esp)
  8007f0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f3:	e9 75 fc ff ff       	jmp    80046d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800803:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800806:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80080a:	0f 84 5b fc ff ff    	je     80046b <vprintfmt+0x27>
  800810:	89 f3                	mov    %esi,%ebx
  800812:	83 eb 01             	sub    $0x1,%ebx
  800815:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800819:	75 f7                	jne    800812 <vprintfmt+0x3ce>
  80081b:	e9 4d fc ff ff       	jmp    80046d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800820:	83 c4 3c             	add    $0x3c,%esp
  800823:	5b                   	pop    %ebx
  800824:	5e                   	pop    %esi
  800825:	5f                   	pop    %edi
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 28             	sub    $0x28,%esp
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800834:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800837:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80083b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80083e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800845:	85 c0                	test   %eax,%eax
  800847:	74 30                	je     800879 <vsnprintf+0x51>
  800849:	85 d2                	test   %edx,%edx
  80084b:	7e 2c                	jle    800879 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	89 44 24 08          	mov    %eax,0x8(%esp)
  80085b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800862:	c7 04 24 ff 03 80 00 	movl   $0x8003ff,(%esp)
  800869:	e8 d6 fb ff ff       	call   800444 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800871:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	eb 05                	jmp    80087e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800879:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800886:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800889:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	89 44 24 08          	mov    %eax,0x8(%esp)
  800894:	8b 45 0c             	mov    0xc(%ebp),%eax
  800897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 82 ff ff ff       	call   800828 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    
  8008a8:	66 90                	xchg   %ax,%ax
  8008aa:	66 90                	xchg   %ax,%ax
  8008ac:	66 90                	xchg   %ax,%ax
  8008ae:	66 90                	xchg   %ax,%ax

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008b9:	74 10                	je     8008cb <strlen+0x1b>
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c7:	75 f7                	jne    8008c0 <strlen+0x10>
  8008c9:	eb 05                	jmp    8008d0 <strlen+0x20>
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	53                   	push   %ebx
  8008d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	74 1c                	je     8008fc <strnlen+0x2a>
  8008e0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008e3:	74 1e                	je     800903 <strnlen+0x31>
  8008e5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008ea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ec:	39 ca                	cmp    %ecx,%edx
  8008ee:	74 18                	je     800908 <strnlen+0x36>
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008f8:	75 f0                	jne    8008ea <strnlen+0x18>
  8008fa:	eb 0c                	jmp    800908 <strnlen+0x36>
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	eb 05                	jmp    800908 <strnlen+0x36>
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800908:	5b                   	pop    %ebx
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800915:	89 c2                	mov    %eax,%edx
  800917:	83 c2 01             	add    $0x1,%edx
  80091a:	83 c1 01             	add    $0x1,%ecx
  80091d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800921:	88 5a ff             	mov    %bl,-0x1(%edx)
  800924:	84 db                	test   %bl,%bl
  800926:	75 ef                	jne    800917 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800928:	5b                   	pop    %ebx
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800935:	89 1c 24             	mov    %ebx,(%esp)
  800938:	e8 73 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 54 24 04          	mov    %edx,0x4(%esp)
  800944:	01 d8                	add    %ebx,%eax
  800946:	89 04 24             	mov    %eax,(%esp)
  800949:	e8 bd ff ff ff       	call   80090b <strcpy>
	return dst;
}
  80094e:	89 d8                	mov    %ebx,%eax
  800950:	83 c4 08             	add    $0x8,%esp
  800953:	5b                   	pop    %ebx
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800961:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800964:	85 db                	test   %ebx,%ebx
  800966:	74 17                	je     80097f <strncpy+0x29>
  800968:	01 f3                	add    %esi,%ebx
  80096a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80096c:	83 c1 01             	add    $0x1,%ecx
  80096f:	0f b6 02             	movzbl (%edx),%eax
  800972:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800975:	80 3a 01             	cmpb   $0x1,(%edx)
  800978:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097b:	39 d9                	cmp    %ebx,%ecx
  80097d:	75 ed                	jne    80096c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80097f:	89 f0                	mov    %esi,%eax
  800981:	5b                   	pop    %ebx
  800982:	5e                   	pop    %esi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	57                   	push   %edi
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800991:	8b 75 10             	mov    0x10(%ebp),%esi
  800994:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800996:	85 f6                	test   %esi,%esi
  800998:	74 34                	je     8009ce <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80099a:	83 fe 01             	cmp    $0x1,%esi
  80099d:	74 26                	je     8009c5 <strlcpy+0x40>
  80099f:	0f b6 0b             	movzbl (%ebx),%ecx
  8009a2:	84 c9                	test   %cl,%cl
  8009a4:	74 23                	je     8009c9 <strlcpy+0x44>
  8009a6:	83 ee 02             	sub    $0x2,%esi
  8009a9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8009ae:	83 c0 01             	add    $0x1,%eax
  8009b1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009b4:	39 f2                	cmp    %esi,%edx
  8009b6:	74 13                	je     8009cb <strlcpy+0x46>
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009bf:	84 c9                	test   %cl,%cl
  8009c1:	75 eb                	jne    8009ae <strlcpy+0x29>
  8009c3:	eb 06                	jmp    8009cb <strlcpy+0x46>
  8009c5:	89 f8                	mov    %edi,%eax
  8009c7:	eb 02                	jmp    8009cb <strlcpy+0x46>
  8009c9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ce:	29 f8                	sub    %edi,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5e                   	pop    %esi
  8009d2:	5f                   	pop    %edi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009de:	0f b6 01             	movzbl (%ecx),%eax
  8009e1:	84 c0                	test   %al,%al
  8009e3:	74 15                	je     8009fa <strcmp+0x25>
  8009e5:	3a 02                	cmp    (%edx),%al
  8009e7:	75 11                	jne    8009fa <strcmp+0x25>
		p++, q++;
  8009e9:	83 c1 01             	add    $0x1,%ecx
  8009ec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ef:	0f b6 01             	movzbl (%ecx),%eax
  8009f2:	84 c0                	test   %al,%al
  8009f4:	74 04                	je     8009fa <strcmp+0x25>
  8009f6:	3a 02                	cmp    (%edx),%al
  8009f8:	74 ef                	je     8009e9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fa:	0f b6 c0             	movzbl %al,%eax
  8009fd:	0f b6 12             	movzbl (%edx),%edx
  800a00:	29 d0                	sub    %edx,%eax
}
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	56                   	push   %esi
  800a08:	53                   	push   %ebx
  800a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800a12:	85 f6                	test   %esi,%esi
  800a14:	74 29                	je     800a3f <strncmp+0x3b>
  800a16:	0f b6 03             	movzbl (%ebx),%eax
  800a19:	84 c0                	test   %al,%al
  800a1b:	74 30                	je     800a4d <strncmp+0x49>
  800a1d:	3a 02                	cmp    (%edx),%al
  800a1f:	75 2c                	jne    800a4d <strncmp+0x49>
  800a21:	8d 43 01             	lea    0x1(%ebx),%eax
  800a24:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800a26:	89 c3                	mov    %eax,%ebx
  800a28:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a2b:	39 f0                	cmp    %esi,%eax
  800a2d:	74 17                	je     800a46 <strncmp+0x42>
  800a2f:	0f b6 08             	movzbl (%eax),%ecx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	74 17                	je     800a4d <strncmp+0x49>
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	3a 0a                	cmp    (%edx),%cl
  800a3b:	74 e9                	je     800a26 <strncmp+0x22>
  800a3d:	eb 0e                	jmp    800a4d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	eb 0f                	jmp    800a55 <strncmp+0x51>
  800a46:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4b:	eb 08                	jmp    800a55 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4d:	0f b6 03             	movzbl (%ebx),%eax
  800a50:	0f b6 12             	movzbl (%edx),%edx
  800a53:	29 d0                	sub    %edx,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a63:	0f b6 18             	movzbl (%eax),%ebx
  800a66:	84 db                	test   %bl,%bl
  800a68:	74 1d                	je     800a87 <strchr+0x2e>
  800a6a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a6c:	38 d3                	cmp    %dl,%bl
  800a6e:	75 06                	jne    800a76 <strchr+0x1d>
  800a70:	eb 1a                	jmp    800a8c <strchr+0x33>
  800a72:	38 ca                	cmp    %cl,%dl
  800a74:	74 16                	je     800a8c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a76:	83 c0 01             	add    $0x1,%eax
  800a79:	0f b6 10             	movzbl (%eax),%edx
  800a7c:	84 d2                	test   %dl,%dl
  800a7e:	75 f2                	jne    800a72 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	eb 05                	jmp    800a8c <strchr+0x33>
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8c:	5b                   	pop    %ebx
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a99:	0f b6 18             	movzbl (%eax),%ebx
  800a9c:	84 db                	test   %bl,%bl
  800a9e:	74 16                	je     800ab6 <strfind+0x27>
  800aa0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800aa2:	38 d3                	cmp    %dl,%bl
  800aa4:	75 06                	jne    800aac <strfind+0x1d>
  800aa6:	eb 0e                	jmp    800ab6 <strfind+0x27>
  800aa8:	38 ca                	cmp    %cl,%dl
  800aaa:	74 0a                	je     800ab6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aac:	83 c0 01             	add    $0x1,%eax
  800aaf:	0f b6 10             	movzbl (%eax),%edx
  800ab2:	84 d2                	test   %dl,%dl
  800ab4:	75 f2                	jne    800aa8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ab6:	5b                   	pop    %ebx
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 36                	je     800aff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800acf:	75 28                	jne    800af9 <memset+0x40>
  800ad1:	f6 c1 03             	test   $0x3,%cl
  800ad4:	75 23                	jne    800af9 <memset+0x40>
		c &= 0xFF;
  800ad6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ada:	89 d3                	mov    %edx,%ebx
  800adc:	c1 e3 08             	shl    $0x8,%ebx
  800adf:	89 d6                	mov    %edx,%esi
  800ae1:	c1 e6 18             	shl    $0x18,%esi
  800ae4:	89 d0                	mov    %edx,%eax
  800ae6:	c1 e0 10             	shl    $0x10,%eax
  800ae9:	09 f0                	or     %esi,%eax
  800aeb:	09 c2                	or     %eax,%edx
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800af1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800af4:	fc                   	cld    
  800af5:	f3 ab                	rep stos %eax,%es:(%edi)
  800af7:	eb 06                	jmp    800aff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	fc                   	cld    
  800afd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aff:	89 f8                	mov    %edi,%eax
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b14:	39 c6                	cmp    %eax,%esi
  800b16:	73 35                	jae    800b4d <memmove+0x47>
  800b18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1b:	39 d0                	cmp    %edx,%eax
  800b1d:	73 2e                	jae    800b4d <memmove+0x47>
		s += n;
		d += n;
  800b1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b22:	89 d6                	mov    %edx,%esi
  800b24:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2c:	75 13                	jne    800b41 <memmove+0x3b>
  800b2e:	f6 c1 03             	test   $0x3,%cl
  800b31:	75 0e                	jne    800b41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b33:	83 ef 04             	sub    $0x4,%edi
  800b36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b39:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b3c:	fd                   	std    
  800b3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3f:	eb 09                	jmp    800b4a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b41:	83 ef 01             	sub    $0x1,%edi
  800b44:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b47:	fd                   	std    
  800b48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b4a:	fc                   	cld    
  800b4b:	eb 1d                	jmp    800b6a <memmove+0x64>
  800b4d:	89 f2                	mov    %esi,%edx
  800b4f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b51:	f6 c2 03             	test   $0x3,%dl
  800b54:	75 0f                	jne    800b65 <memmove+0x5f>
  800b56:	f6 c1 03             	test   $0x3,%cl
  800b59:	75 0a                	jne    800b65 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b63:	eb 05                	jmp    800b6a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	fc                   	cld    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 04 24             	mov    %eax,(%esp)
  800b88:	e8 79 ff ff ff       	call   800b06 <memmove>
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	74 36                	je     800bdb <memcmp+0x4c>
		if (*s1 != *s2)
  800ba5:	0f b6 03             	movzbl (%ebx),%eax
  800ba8:	0f b6 0e             	movzbl (%esi),%ecx
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	38 c8                	cmp    %cl,%al
  800bb2:	74 1c                	je     800bd0 <memcmp+0x41>
  800bb4:	eb 10                	jmp    800bc6 <memcmp+0x37>
  800bb6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bbb:	83 c2 01             	add    $0x1,%edx
  800bbe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800bc2:	38 c8                	cmp    %cl,%al
  800bc4:	74 0a                	je     800bd0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800bc6:	0f b6 c0             	movzbl %al,%eax
  800bc9:	0f b6 c9             	movzbl %cl,%ecx
  800bcc:	29 c8                	sub    %ecx,%eax
  800bce:	eb 10                	jmp    800be0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd0:	39 fa                	cmp    %edi,%edx
  800bd2:	75 e2                	jne    800bb6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	eb 05                	jmp    800be0 <memcmp+0x51>
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	53                   	push   %ebx
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf4:	39 d0                	cmp    %edx,%eax
  800bf6:	73 13                	jae    800c0b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf8:	89 d9                	mov    %ebx,%ecx
  800bfa:	38 18                	cmp    %bl,(%eax)
  800bfc:	75 06                	jne    800c04 <memfind+0x1f>
  800bfe:	eb 0b                	jmp    800c0b <memfind+0x26>
  800c00:	38 08                	cmp    %cl,(%eax)
  800c02:	74 07                	je     800c0b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c04:	83 c0 01             	add    $0x1,%eax
  800c07:	39 d0                	cmp    %edx,%eax
  800c09:	75 f5                	jne    800c00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c0b:	5b                   	pop    %ebx
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1a:	0f b6 0a             	movzbl (%edx),%ecx
  800c1d:	80 f9 09             	cmp    $0x9,%cl
  800c20:	74 05                	je     800c27 <strtol+0x19>
  800c22:	80 f9 20             	cmp    $0x20,%cl
  800c25:	75 10                	jne    800c37 <strtol+0x29>
		s++;
  800c27:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2a:	0f b6 0a             	movzbl (%edx),%ecx
  800c2d:	80 f9 09             	cmp    $0x9,%cl
  800c30:	74 f5                	je     800c27 <strtol+0x19>
  800c32:	80 f9 20             	cmp    $0x20,%cl
  800c35:	74 f0                	je     800c27 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c37:	80 f9 2b             	cmp    $0x2b,%cl
  800c3a:	75 0a                	jne    800c46 <strtol+0x38>
		s++;
  800c3c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c44:	eb 11                	jmp    800c57 <strtol+0x49>
  800c46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c4b:	80 f9 2d             	cmp    $0x2d,%cl
  800c4e:	75 07                	jne    800c57 <strtol+0x49>
		s++, neg = 1;
  800c50:	83 c2 01             	add    $0x1,%edx
  800c53:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c57:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c5c:	75 15                	jne    800c73 <strtol+0x65>
  800c5e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c61:	75 10                	jne    800c73 <strtol+0x65>
  800c63:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c67:	75 0a                	jne    800c73 <strtol+0x65>
		s += 2, base = 16;
  800c69:	83 c2 02             	add    $0x2,%edx
  800c6c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c71:	eb 10                	jmp    800c83 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c73:	85 c0                	test   %eax,%eax
  800c75:	75 0c                	jne    800c83 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c77:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c79:	80 3a 30             	cmpb   $0x30,(%edx)
  800c7c:	75 05                	jne    800c83 <strtol+0x75>
		s++, base = 8;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c88:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c8b:	0f b6 0a             	movzbl (%edx),%ecx
  800c8e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c91:	89 f0                	mov    %esi,%eax
  800c93:	3c 09                	cmp    $0x9,%al
  800c95:	77 08                	ja     800c9f <strtol+0x91>
			dig = *s - '0';
  800c97:	0f be c9             	movsbl %cl,%ecx
  800c9a:	83 e9 30             	sub    $0x30,%ecx
  800c9d:	eb 20                	jmp    800cbf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c9f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800ca2:	89 f0                	mov    %esi,%eax
  800ca4:	3c 19                	cmp    $0x19,%al
  800ca6:	77 08                	ja     800cb0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800ca8:	0f be c9             	movsbl %cl,%ecx
  800cab:	83 e9 57             	sub    $0x57,%ecx
  800cae:	eb 0f                	jmp    800cbf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800cb0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cb3:	89 f0                	mov    %esi,%eax
  800cb5:	3c 19                	cmp    $0x19,%al
  800cb7:	77 16                	ja     800ccf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb9:	0f be c9             	movsbl %cl,%ecx
  800cbc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cbf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cc2:	7d 0f                	jge    800cd3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cc4:	83 c2 01             	add    $0x1,%edx
  800cc7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ccb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ccd:	eb bc                	jmp    800c8b <strtol+0x7d>
  800ccf:	89 d8                	mov    %ebx,%eax
  800cd1:	eb 02                	jmp    800cd5 <strtol+0xc7>
  800cd3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd9:	74 05                	je     800ce0 <strtol+0xd2>
		*endptr = (char *) s;
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ce0:	f7 d8                	neg    %eax
  800ce2:	85 ff                	test   %edi,%edi
  800ce4:	0f 44 c3             	cmove  %ebx,%eax
}
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	89 c3                	mov    %eax,%ebx
  800cff:	89 c7                	mov    %eax,%edi
  800d01:	89 c6                	mov    %eax,%esi
  800d03:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <sys_cgetc>:

int
sys_cgetc(void)
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
  800d15:	b8 01 00 00 00       	mov    $0x1,%eax
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	89 d7                	mov    %edx,%edi
  800d20:	89 d6                	mov    %edx,%esi
  800d22:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d37:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	89 cb                	mov    %ecx,%ebx
  800d41:	89 cf                	mov    %ecx,%edi
  800d43:	89 ce                	mov    %ecx,%esi
  800d45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7e 28                	jle    800d73 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d56:	00 
  800d57:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d66:	00 
  800d67:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800d6e:	e8 41 f4 ff ff       	call   8001b4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d73:	83 c4 2c             	add    $0x2c,%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d81:	ba 00 00 00 00       	mov    $0x0,%edx
  800d86:	b8 02 00 00 00       	mov    $0x2,%eax
  800d8b:	89 d1                	mov    %edx,%ecx
  800d8d:	89 d3                	mov    %edx,%ebx
  800d8f:	89 d7                	mov    %edx,%edi
  800d91:	89 d6                	mov    %edx,%esi
  800d93:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_yield>:

void
sys_yield(void)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da0:	ba 00 00 00 00       	mov    $0x0,%edx
  800da5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800daa:	89 d1                	mov    %edx,%ecx
  800dac:	89 d3                	mov    %edx,%ebx
  800dae:	89 d7                	mov    %edx,%edi
  800db0:	89 d6                	mov    %edx,%esi
  800db2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	be 00 00 00 00       	mov    $0x0,%esi
  800dc7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd5:	89 f7                	mov    %esi,%edi
  800dd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7e 28                	jle    800e05 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800de8:	00 
  800de9:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800df0:	00 
  800df1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800df8:	00 
  800df9:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800e00:	e8 af f3 ff ff       	call   8001b4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e05:	83 c4 2c             	add    $0x2c,%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e16:	b8 05 00 00 00       	mov    $0x5,%eax
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e27:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7e 28                	jle    800e58 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e34:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e3b:	00 
  800e3c:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800e43:	00 
  800e44:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e4b:	00 
  800e4c:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800e53:	e8 5c f3 ff ff       	call   8001b4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e58:	83 c4 2c             	add    $0x2c,%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e76:	8b 55 08             	mov    0x8(%ebp),%edx
  800e79:	89 df                	mov    %ebx,%edi
  800e7b:	89 de                	mov    %ebx,%esi
  800e7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7e 28                	jle    800eab <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e87:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800e96:	00 
  800e97:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e9e:	00 
  800e9f:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ea6:	e8 09 f3 ff ff       	call   8001b4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eab:	83 c4 2c             	add    $0x2c,%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	89 de                	mov    %ebx,%esi
  800ed0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7e 28                	jle    800efe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eda:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800ee9:	00 
  800eea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ef1:	00 
  800ef2:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ef9:	e8 b6 f2 ff ff       	call   8001b4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800efe:	83 c4 2c             	add    $0x2c,%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	b8 09 00 00 00       	mov    $0x9,%eax
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7e 28                	jle    800f51 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f34:	00 
  800f35:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f44:	00 
  800f45:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800f4c:	e8 63 f2 ff ff       	call   8001b4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f51:	83 c4 2c             	add    $0x2c,%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
  800f5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 df                	mov    %ebx,%edi
  800f74:	89 de                	mov    %ebx,%esi
  800f76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7e 28                	jle    800fa4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f80:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f87:	00 
  800f88:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800f9f:	e8 10 f2 ff ff       	call   8001b4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa4:	83 c4 2c             	add    $0x2c,%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	57                   	push   %edi
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	be 00 00 00 00       	mov    $0x0,%esi
  800fb7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	89 cb                	mov    %ecx,%ebx
  800fe7:	89 cf                	mov    %ecx,%edi
  800fe9:	89 ce                	mov    %ecx,%esi
  800feb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	7e 28                	jle    801019 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  801004:	00 
  801005:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80100c:	00 
  80100d:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  801014:	e8 9b f1 ff ff       	call   8001b4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801019:	83 c4 2c             	add    $0x2c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	53                   	push   %ebx
  801025:	83 ec 24             	sub    $0x24,%esp
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80102b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80102d:	89 da                	mov    %ebx,%edx
  80102f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801032:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801039:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80103d:	74 05                	je     801044 <pgfault+0x23>
  80103f:	f6 c6 08             	test   $0x8,%dh
  801042:	75 1c                	jne    801060 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801044:	c7 44 24 08 ac 29 80 	movl   $0x8029ac,0x8(%esp)
  80104b:	00 
  80104c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801053:	00 
  801054:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80105b:	e8 54 f1 ff ff       	call   8001b4 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801060:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801067:	00 
  801068:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80106f:	00 
  801070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801077:	e8 3d fd ff ff       	call   800db9 <sys_page_alloc>
  80107c:	85 c0                	test   %eax,%eax
  80107e:	79 20                	jns    8010a0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801084:	c7 44 24 08 14 2a 80 	movl   $0x802a14,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80109b:	e8 14 f1 ff ff       	call   8001b4 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  8010a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  8010a6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010ad:	00 
  8010ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010b2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010b9:	e8 48 fa ff ff       	call   800b06 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8010be:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010c5:	00 
  8010c6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010d1:	00 
  8010d2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d9:	00 
  8010da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010e1:	e8 27 fd ff ff       	call   800e0d <sys_page_map>
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	79 20                	jns    80110a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8010ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ee:	c7 44 24 08 2e 2a 80 	movl   $0x802a2e,0x8(%esp)
  8010f5:	00 
  8010f6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8010fd:	00 
  8010fe:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801105:	e8 aa f0 ff ff       	call   8001b4 <_panic>
	}
}
  80110a:	83 c4 24             	add    $0x24,%esp
  80110d:	5b                   	pop    %ebx
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
  801116:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801119:	c7 04 24 21 10 80 00 	movl   $0x801021,(%esp)
  801120:	e8 21 10 00 00       	call   802146 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801125:	b8 07 00 00 00       	mov    $0x7,%eax
  80112a:	cd 30                	int    $0x30
  80112c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80112f:	85 c0                	test   %eax,%eax
  801131:	79 1c                	jns    80114f <fork+0x3f>
		panic("fork");
  801133:	c7 44 24 08 47 2a 80 	movl   $0x802a47,0x8(%esp)
  80113a:	00 
  80113b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801142:	00 
  801143:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80114a:	e8 65 f0 ff ff       	call   8001b4 <_panic>
  80114f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801151:	bb 00 08 00 00       	mov    $0x800,%ebx
  801156:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80115a:	75 21                	jne    80117d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80115c:	e8 1a fc ff ff       	call   800d7b <sys_getenvid>
  801161:	25 ff 03 00 00       	and    $0x3ff,%eax
  801166:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801169:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80116e:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801173:	b8 00 00 00 00       	mov    $0x0,%eax
  801178:	e9 c5 01 00 00       	jmp    801342 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	c1 e8 0a             	shr    $0xa,%eax
  801182:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801189:	a8 01                	test   $0x1,%al
  80118b:	0f 84 f2 00 00 00    	je     801283 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801191:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801198:	a8 05                	test   $0x5,%al
  80119a:	0f 84 e3 00 00 00    	je     801283 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  8011a0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011a7:	89 de                	mov    %ebx,%esi
  8011a9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  8011ac:	a9 02 08 00 00       	test   $0x802,%eax
  8011b1:	0f 84 88 00 00 00    	je     80123f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8011b7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011be:	00 
  8011bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d2:	e8 36 fc ff ff       	call   800e0d <sys_page_map>
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	79 20                	jns    8011fb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  8011db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011df:	c7 44 24 08 4c 2a 80 	movl   $0x802a4c,0x8(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8011ee:	00 
  8011ef:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  8011f6:	e8 b9 ef ff ff       	call   8001b4 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8011fb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801202:	00 
  801203:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801207:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80120e:	00 
  80120f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801213:	89 3c 24             	mov    %edi,(%esp)
  801216:	e8 f2 fb ff ff       	call   800e0d <sys_page_map>
  80121b:	85 c0                	test   %eax,%eax
  80121d:	79 64                	jns    801283 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80121f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801223:	c7 44 24 08 66 2a 80 	movl   $0x802a66,0x8(%esp)
  80122a:	00 
  80122b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801232:	00 
  801233:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80123a:	e8 75 ef ff ff       	call   8001b4 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80123f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801246:	00 
  801247:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80124b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80124f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125a:	e8 ae fb ff ff       	call   800e0d <sys_page_map>
  80125f:	85 c0                	test   %eax,%eax
  801261:	79 20                	jns    801283 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801267:	c7 44 24 08 80 2a 80 	movl   $0x802a80,0x8(%esp)
  80126e:	00 
  80126f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801276:	00 
  801277:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80127e:	e8 31 ef ff ff       	call   8001b4 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801283:	83 c3 01             	add    $0x1,%ebx
  801286:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80128c:	0f 85 eb fe ff ff    	jne    80117d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801292:	c7 44 24 04 af 21 80 	movl   $0x8021af,0x4(%esp)
  801299:	00 
  80129a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129d:	89 04 24             	mov    %eax,(%esp)
  8012a0:	e8 b4 fc ff ff       	call   800f59 <sys_env_set_pgfault_upcall>
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	79 20                	jns    8012c9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8012a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ad:	c7 44 24 08 e4 29 80 	movl   $0x8029e4,0x8(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8012bc:	00 
  8012bd:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  8012c4:	e8 eb ee ff ff       	call   8001b4 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8012c9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012d0:	00 
  8012d1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012d8:	ee 
  8012d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012dc:	89 04 24             	mov    %eax,(%esp)
  8012df:	e8 d5 fa ff ff       	call   800db9 <sys_page_alloc>
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	79 20                	jns    801308 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8012e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ec:	c7 44 24 08 92 2a 80 	movl   $0x802a92,0x8(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  8012fb:	00 
  8012fc:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801303:	e8 ac ee ff ff       	call   8001b4 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801308:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80130f:	00 
  801310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801313:	89 04 24             	mov    %eax,(%esp)
  801316:	e8 98 fb ff ff       	call   800eb3 <sys_env_set_status>
  80131b:	85 c0                	test   %eax,%eax
  80131d:	79 20                	jns    80133f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80131f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801323:	c7 44 24 08 aa 2a 80 	movl   $0x802aaa,0x8(%esp)
  80132a:	00 
  80132b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801332:	00 
  801333:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80133a:	e8 75 ee ff ff       	call   8001b4 <_panic>
	}

	return envid;
  80133f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801342:	83 c4 2c             	add    $0x2c,%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <sfork>:

// Challenge!
int
sfork(void)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801350:	c7 44 24 08 c5 2a 80 	movl   $0x802ac5,0x8(%esp)
  801357:	00 
  801358:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80135f:	00 
  801360:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801367:	e8 48 ee ff ff       	call   8001b4 <_panic>
  80136c:	66 90                	xchg   %ax,%ax
  80136e:	66 90                	xchg   %ax,%ax

00801370 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	05 00 00 00 30       	add    $0x30000000,%eax
  80137b:	c1 e8 0c             	shr    $0xc,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80138b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801390:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80139a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80139f:	a8 01                	test   $0x1,%al
  8013a1:	74 34                	je     8013d7 <fd_alloc+0x40>
  8013a3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013a8:	a8 01                	test   $0x1,%al
  8013aa:	74 32                	je     8013de <fd_alloc+0x47>
  8013ac:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013b1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	c1 ea 16             	shr    $0x16,%edx
  8013b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013bf:	f6 c2 01             	test   $0x1,%dl
  8013c2:	74 1f                	je     8013e3 <fd_alloc+0x4c>
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	c1 ea 0c             	shr    $0xc,%edx
  8013c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d0:	f6 c2 01             	test   $0x1,%dl
  8013d3:	75 1a                	jne    8013ef <fd_alloc+0x58>
  8013d5:	eb 0c                	jmp    8013e3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013d7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8013dc:	eb 05                	jmp    8013e3 <fd_alloc+0x4c>
  8013de:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8013e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ed:	eb 1a                	jmp    801409 <fd_alloc+0x72>
  8013ef:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013f4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f9:	75 b6                	jne    8013b1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801404:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801411:	83 f8 1f             	cmp    $0x1f,%eax
  801414:	77 36                	ja     80144c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801416:	c1 e0 0c             	shl    $0xc,%eax
  801419:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80141e:	89 c2                	mov    %eax,%edx
  801420:	c1 ea 16             	shr    $0x16,%edx
  801423:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80142a:	f6 c2 01             	test   $0x1,%dl
  80142d:	74 24                	je     801453 <fd_lookup+0x48>
  80142f:	89 c2                	mov    %eax,%edx
  801431:	c1 ea 0c             	shr    $0xc,%edx
  801434:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80143b:	f6 c2 01             	test   $0x1,%dl
  80143e:	74 1a                	je     80145a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801440:	8b 55 0c             	mov    0xc(%ebp),%edx
  801443:	89 02                	mov    %eax,(%edx)
	return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	eb 13                	jmp    80145f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80144c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801451:	eb 0c                	jmp    80145f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801458:	eb 05                	jmp    80145f <fd_lookup+0x54>
  80145a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	83 ec 14             	sub    $0x14,%esp
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80146e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801474:	75 1e                	jne    801494 <dev_lookup+0x33>
  801476:	eb 0e                	jmp    801486 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801478:	b8 20 30 80 00       	mov    $0x803020,%eax
  80147d:	eb 0c                	jmp    80148b <dev_lookup+0x2a>
  80147f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801484:	eb 05                	jmp    80148b <dev_lookup+0x2a>
  801486:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80148b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	eb 38                	jmp    8014cc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801494:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80149a:	74 dc                	je     801478 <dev_lookup+0x17>
  80149c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8014a2:	74 db                	je     80147f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014a4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8014aa:	8b 52 48             	mov    0x48(%edx),%edx
  8014ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014b5:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  8014bc:	e8 ec ed ff ff       	call   8002ad <cprintf>
	*dev = 0;
  8014c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014cc:	83 c4 14             	add    $0x14,%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 20             	sub    $0x20,%esp
  8014da:	8b 75 08             	mov    0x8(%ebp),%esi
  8014dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014ed:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f0:	89 04 24             	mov    %eax,(%esp)
  8014f3:	e8 13 ff ff ff       	call   80140b <fd_lookup>
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 05                	js     801501 <fd_close+0x2f>
	    || fd != fd2)
  8014fc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014ff:	74 0c                	je     80150d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801501:	84 db                	test   %bl,%bl
  801503:	ba 00 00 00 00       	mov    $0x0,%edx
  801508:	0f 44 c2             	cmove  %edx,%eax
  80150b:	eb 3f                	jmp    80154c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801510:	89 44 24 04          	mov    %eax,0x4(%esp)
  801514:	8b 06                	mov    (%esi),%eax
  801516:	89 04 24             	mov    %eax,(%esp)
  801519:	e8 43 ff ff ff       	call   801461 <dev_lookup>
  80151e:	89 c3                	mov    %eax,%ebx
  801520:	85 c0                	test   %eax,%eax
  801522:	78 16                	js     80153a <fd_close+0x68>
		if (dev->dev_close)
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80152a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 07                	je     80153a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801533:	89 34 24             	mov    %esi,(%esp)
  801536:	ff d0                	call   *%eax
  801538:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80153a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80153e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801545:	e8 16 f9 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  80154a:	89 d8                	mov    %ebx,%eax
}
  80154c:	83 c4 20             	add    $0x20,%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801559:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	89 04 24             	mov    %eax,(%esp)
  801566:	e8 a0 fe ff ff       	call   80140b <fd_lookup>
  80156b:	89 c2                	mov    %eax,%edx
  80156d:	85 d2                	test   %edx,%edx
  80156f:	78 13                	js     801584 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801571:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801578:	00 
  801579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157c:	89 04 24             	mov    %eax,(%esp)
  80157f:	e8 4e ff ff ff       	call   8014d2 <fd_close>
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <close_all>:

void
close_all(void)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80158d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801592:	89 1c 24             	mov    %ebx,(%esp)
  801595:	e8 b9 ff ff ff       	call   801553 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80159a:	83 c3 01             	add    $0x1,%ebx
  80159d:	83 fb 20             	cmp    $0x20,%ebx
  8015a0:	75 f0                	jne    801592 <close_all+0xc>
		close(i);
}
  8015a2:	83 c4 14             	add    $0x14,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    

008015a8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	57                   	push   %edi
  8015ac:	56                   	push   %esi
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	89 04 24             	mov    %eax,(%esp)
  8015be:	e8 48 fe ff ff       	call   80140b <fd_lookup>
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	85 d2                	test   %edx,%edx
  8015c7:	0f 88 e1 00 00 00    	js     8016ae <dup+0x106>
		return r;
	close(newfdnum);
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	89 04 24             	mov    %eax,(%esp)
  8015d3:	e8 7b ff ff ff       	call   801553 <close>

	newfd = INDEX2FD(newfdnum);
  8015d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015db:	c1 e3 0c             	shl    $0xc,%ebx
  8015de:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	e8 91 fd ff ff       	call   801380 <fd2data>
  8015ef:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015f1:	89 1c 24             	mov    %ebx,(%esp)
  8015f4:	e8 87 fd ff ff       	call   801380 <fd2data>
  8015f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015fb:	89 f0                	mov    %esi,%eax
  8015fd:	c1 e8 16             	shr    $0x16,%eax
  801600:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801607:	a8 01                	test   $0x1,%al
  801609:	74 43                	je     80164e <dup+0xa6>
  80160b:	89 f0                	mov    %esi,%eax
  80160d:	c1 e8 0c             	shr    $0xc,%eax
  801610:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801617:	f6 c2 01             	test   $0x1,%dl
  80161a:	74 32                	je     80164e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80161c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801623:	25 07 0e 00 00       	and    $0xe07,%eax
  801628:	89 44 24 10          	mov    %eax,0x10(%esp)
  80162c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801630:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801637:	00 
  801638:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801643:	e8 c5 f7 ff ff       	call   800e0d <sys_page_map>
  801648:	89 c6                	mov    %eax,%esi
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 3e                	js     80168c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80164e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801651:	89 c2                	mov    %eax,%edx
  801653:	c1 ea 0c             	shr    $0xc,%edx
  801656:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801663:	89 54 24 10          	mov    %edx,0x10(%esp)
  801667:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80166b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801672:	00 
  801673:	89 44 24 04          	mov    %eax,0x4(%esp)
  801677:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167e:	e8 8a f7 ff ff       	call   800e0d <sys_page_map>
  801683:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801688:	85 f6                	test   %esi,%esi
  80168a:	79 22                	jns    8016ae <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80168c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801697:	e8 c4 f7 ff ff       	call   800e60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80169c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a7:	e8 b4 f7 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  8016ac:	89 f0                	mov    %esi,%eax
}
  8016ae:	83 c4 3c             	add    $0x3c,%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5f                   	pop    %edi
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 24             	sub    $0x24,%esp
  8016bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c7:	89 1c 24             	mov    %ebx,(%esp)
  8016ca:	e8 3c fd ff ff       	call   80140b <fd_lookup>
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	85 d2                	test   %edx,%edx
  8016d3:	78 6d                	js     801742 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	89 04 24             	mov    %eax,(%esp)
  8016e4:	e8 78 fd ff ff       	call   801461 <dev_lookup>
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 55                	js     801742 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	8b 50 08             	mov    0x8(%eax),%edx
  8016f3:	83 e2 03             	and    $0x3,%edx
  8016f6:	83 fa 01             	cmp    $0x1,%edx
  8016f9:	75 23                	jne    80171e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016fb:	a1 08 40 80 00       	mov    0x804008,%eax
  801700:	8b 40 48             	mov    0x48(%eax),%eax
  801703:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170b:	c7 04 24 1d 2b 80 00 	movl   $0x802b1d,(%esp)
  801712:	e8 96 eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171c:	eb 24                	jmp    801742 <read+0x8c>
	}
	if (!dev->dev_read)
  80171e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801721:	8b 52 08             	mov    0x8(%edx),%edx
  801724:	85 d2                	test   %edx,%edx
  801726:	74 15                	je     80173d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801728:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80172f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801732:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	ff d2                	call   *%edx
  80173b:	eb 05                	jmp    801742 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80173d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801742:	83 c4 24             	add    $0x24,%esp
  801745:	5b                   	pop    %ebx
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	57                   	push   %edi
  80174c:	56                   	push   %esi
  80174d:	53                   	push   %ebx
  80174e:	83 ec 1c             	sub    $0x1c,%esp
  801751:	8b 7d 08             	mov    0x8(%ebp),%edi
  801754:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801757:	85 f6                	test   %esi,%esi
  801759:	74 33                	je     80178e <readn+0x46>
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801765:	89 f2                	mov    %esi,%edx
  801767:	29 c2                	sub    %eax,%edx
  801769:	89 54 24 08          	mov    %edx,0x8(%esp)
  80176d:	03 45 0c             	add    0xc(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	89 3c 24             	mov    %edi,(%esp)
  801777:	e8 3a ff ff ff       	call   8016b6 <read>
		if (m < 0)
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 1b                	js     80179b <readn+0x53>
			return m;
		if (m == 0)
  801780:	85 c0                	test   %eax,%eax
  801782:	74 11                	je     801795 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801784:	01 c3                	add    %eax,%ebx
  801786:	89 d8                	mov    %ebx,%eax
  801788:	39 f3                	cmp    %esi,%ebx
  80178a:	72 d9                	jb     801765 <readn+0x1d>
  80178c:	eb 0b                	jmp    801799 <readn+0x51>
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
  801793:	eb 06                	jmp    80179b <readn+0x53>
  801795:	89 d8                	mov    %ebx,%eax
  801797:	eb 02                	jmp    80179b <readn+0x53>
  801799:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80179b:	83 c4 1c             	add    $0x1c,%esp
  80179e:	5b                   	pop    %ebx
  80179f:	5e                   	pop    %esi
  8017a0:	5f                   	pop    %edi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 24             	sub    $0x24,%esp
  8017aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b4:	89 1c 24             	mov    %ebx,(%esp)
  8017b7:	e8 4f fc ff ff       	call   80140b <fd_lookup>
  8017bc:	89 c2                	mov    %eax,%edx
  8017be:	85 d2                	test   %edx,%edx
  8017c0:	78 68                	js     80182a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	8b 00                	mov    (%eax),%eax
  8017ce:	89 04 24             	mov    %eax,(%esp)
  8017d1:	e8 8b fc ff ff       	call   801461 <dev_lookup>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 50                	js     80182a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e1:	75 23                	jne    801806 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8017e8:	8b 40 48             	mov    0x48(%eax),%eax
  8017eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f3:	c7 04 24 39 2b 80 00 	movl   $0x802b39,(%esp)
  8017fa:	e8 ae ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8017ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801804:	eb 24                	jmp    80182a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801809:	8b 52 0c             	mov    0xc(%edx),%edx
  80180c:	85 d2                	test   %edx,%edx
  80180e:	74 15                	je     801825 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801813:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801817:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80181e:	89 04 24             	mov    %eax,(%esp)
  801821:	ff d2                	call   *%edx
  801823:	eb 05                	jmp    80182a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801825:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80182a:	83 c4 24             	add    $0x24,%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <seek>:

int
seek(int fdnum, off_t offset)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801836:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	89 04 24             	mov    %eax,(%esp)
  801843:	e8 c3 fb ff ff       	call   80140b <fd_lookup>
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 0e                	js     80185a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	53                   	push   %ebx
  801860:	83 ec 24             	sub    $0x24,%esp
  801863:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801866:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186d:	89 1c 24             	mov    %ebx,(%esp)
  801870:	e8 96 fb ff ff       	call   80140b <fd_lookup>
  801875:	89 c2                	mov    %eax,%edx
  801877:	85 d2                	test   %edx,%edx
  801879:	78 61                	js     8018dc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80187b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	89 04 24             	mov    %eax,(%esp)
  80188a:	e8 d2 fb ff ff       	call   801461 <dev_lookup>
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 49                	js     8018dc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80189a:	75 23                	jne    8018bf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80189c:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a1:	8b 40 48             	mov    0x48(%eax),%eax
  8018a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ac:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  8018b3:	e8 f5 e9 ff ff       	call   8002ad <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bd:	eb 1d                	jmp    8018dc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c2:	8b 52 18             	mov    0x18(%edx),%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	74 0e                	je     8018d7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d0:	89 04 24             	mov    %eax,(%esp)
  8018d3:	ff d2                	call   *%edx
  8018d5:	eb 05                	jmp    8018dc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018dc:	83 c4 24             	add    $0x24,%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	53                   	push   %ebx
  8018e6:	83 ec 24             	sub    $0x24,%esp
  8018e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 04 24             	mov    %eax,(%esp)
  8018f9:	e8 0d fb ff ff       	call   80140b <fd_lookup>
  8018fe:	89 c2                	mov    %eax,%edx
  801900:	85 d2                	test   %edx,%edx
  801902:	78 52                	js     801956 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801904:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190e:	8b 00                	mov    (%eax),%eax
  801910:	89 04 24             	mov    %eax,(%esp)
  801913:	e8 49 fb ff ff       	call   801461 <dev_lookup>
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 3a                	js     801956 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801923:	74 2c                	je     801951 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801925:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801928:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80192f:	00 00 00 
	stat->st_isdir = 0;
  801932:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801939:	00 00 00 
	stat->st_dev = dev;
  80193c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801942:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	89 14 24             	mov    %edx,(%esp)
  80194c:	ff 50 14             	call   *0x14(%eax)
  80194f:	eb 05                	jmp    801956 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801951:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801956:	83 c4 24             	add    $0x24,%esp
  801959:	5b                   	pop    %ebx
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801964:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80196b:	00 
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 e1 01 00 00       	call   801b58 <open>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	85 db                	test   %ebx,%ebx
  80197b:	78 1b                	js     801998 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80197d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801980:	89 44 24 04          	mov    %eax,0x4(%esp)
  801984:	89 1c 24             	mov    %ebx,(%esp)
  801987:	e8 56 ff ff ff       	call   8018e2 <fstat>
  80198c:	89 c6                	mov    %eax,%esi
	close(fd);
  80198e:	89 1c 24             	mov    %ebx,(%esp)
  801991:	e8 bd fb ff ff       	call   801553 <close>
	return r;
  801996:	89 f0                	mov    %esi,%eax
}
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5d                   	pop    %ebp
  80199e:	c3                   	ret    

0080199f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 10             	sub    $0x10,%esp
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8019ab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019b2:	75 11                	jne    8019c5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019bb:	e8 0e 09 00 00       	call   8022ce <ipc_find_env>
  8019c0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8019c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8019ca:	8b 40 48             	mov    0x48(%eax),%eax
  8019cd:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8019d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019df:	c7 04 24 56 2b 80 00 	movl   $0x802b56,(%esp)
  8019e6:	e8 c2 e8 ff ff       	call   8002ad <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019eb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019f2:	00 
  8019f3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8019fa:	00 
  8019fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ff:	a1 00 40 80 00       	mov    0x804000,%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 5c 08 00 00       	call   802268 <ipc_send>
	cprintf("ipc_send\n");
  801a0c:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  801a13:	e8 95 e8 ff ff       	call   8002ad <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801a18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1f:	00 
  801a20:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2b:	e8 d0 07 00 00       	call   802200 <ipc_recv>
}
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    

00801a37 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 14             	sub    $0x14,%esp
  801a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	8b 40 0c             	mov    0xc(%eax),%eax
  801a47:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a51:	b8 05 00 00 00       	mov    $0x5,%eax
  801a56:	e8 44 ff ff ff       	call   80199f <fsipc>
  801a5b:	89 c2                	mov    %eax,%edx
  801a5d:	85 d2                	test   %edx,%edx
  801a5f:	78 2b                	js     801a8c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a61:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a68:	00 
  801a69:	89 1c 24             	mov    %ebx,(%esp)
  801a6c:	e8 9a ee ff ff       	call   80090b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a71:	a1 80 50 80 00       	mov    0x805080,%eax
  801a76:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a7c:	a1 84 50 80 00       	mov    0x805084,%eax
  801a81:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8c:	83 c4 14             	add    $0x14,%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    

00801a92 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa8:	b8 06 00 00 00       	mov    $0x6,%eax
  801aad:	e8 ed fe ff ff       	call   80199f <fsipc>
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	56                   	push   %esi
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 10             	sub    $0x10,%esp
  801abc:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aca:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad5:	b8 03 00 00 00       	mov    $0x3,%eax
  801ada:	e8 c0 fe ff ff       	call   80199f <fsipc>
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 6a                	js     801b4f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ae5:	39 c6                	cmp    %eax,%esi
  801ae7:	73 24                	jae    801b0d <devfile_read+0x59>
  801ae9:	c7 44 24 0c 76 2b 80 	movl   $0x802b76,0xc(%esp)
  801af0:	00 
  801af1:	c7 44 24 08 7d 2b 80 	movl   $0x802b7d,0x8(%esp)
  801af8:	00 
  801af9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b00:	00 
  801b01:	c7 04 24 92 2b 80 00 	movl   $0x802b92,(%esp)
  801b08:	e8 a7 e6 ff ff       	call   8001b4 <_panic>
	assert(r <= PGSIZE);
  801b0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b12:	7e 24                	jle    801b38 <devfile_read+0x84>
  801b14:	c7 44 24 0c 9d 2b 80 	movl   $0x802b9d,0xc(%esp)
  801b1b:	00 
  801b1c:	c7 44 24 08 7d 2b 80 	movl   $0x802b7d,0x8(%esp)
  801b23:	00 
  801b24:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801b2b:	00 
  801b2c:	c7 04 24 92 2b 80 00 	movl   $0x802b92,(%esp)
  801b33:	e8 7c e6 ff ff       	call   8001b4 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b43:	00 
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	89 04 24             	mov    %eax,(%esp)
  801b4a:	e8 b7 ef ff ff       	call   800b06 <memmove>
	return r;
}
  801b4f:	89 d8                	mov    %ebx,%eax
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    

00801b58 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 24             	sub    $0x24,%esp
  801b5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b62:	89 1c 24             	mov    %ebx,(%esp)
  801b65:	e8 46 ed ff ff       	call   8008b0 <strlen>
  801b6a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b6f:	7f 60                	jg     801bd1 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b74:	89 04 24             	mov    %eax,(%esp)
  801b77:	e8 1b f8 ff ff       	call   801397 <fd_alloc>
  801b7c:	89 c2                	mov    %eax,%edx
  801b7e:	85 d2                	test   %edx,%edx
  801b80:	78 54                	js     801bd6 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b86:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b8d:	e8 79 ed ff ff       	call   80090b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	e8 f8 fd ff ff       	call   80199f <fsipc>
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	79 17                	jns    801bc4 <open+0x6c>
		fd_close(fd, 0);
  801bad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bb4:	00 
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	89 04 24             	mov    %eax,(%esp)
  801bbb:	e8 12 f9 ff ff       	call   8014d2 <fd_close>
		return r;
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	eb 12                	jmp    801bd6 <open+0x7e>
	}
	return fd2num(fd);
  801bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc7:	89 04 24             	mov    %eax,(%esp)
  801bca:	e8 a1 f7 ff ff       	call   801370 <fd2num>
  801bcf:	eb 05                	jmp    801bd6 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bd1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801bd6:	83 c4 24             	add    $0x24,%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	66 90                	xchg   %ax,%ax
  801bde:	66 90                	xchg   %ax,%ax

00801be0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	83 ec 10             	sub    $0x10,%esp
  801be8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	89 04 24             	mov    %eax,(%esp)
  801bf1:	e8 8a f7 ff ff       	call   801380 <fd2data>
  801bf6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bf8:	c7 44 24 04 a9 2b 80 	movl   $0x802ba9,0x4(%esp)
  801bff:	00 
  801c00:	89 1c 24             	mov    %ebx,(%esp)
  801c03:	e8 03 ed ff ff       	call   80090b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c08:	8b 46 04             	mov    0x4(%esi),%eax
  801c0b:	2b 06                	sub    (%esi),%eax
  801c0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c1a:	00 00 00 
	stat->st_dev = &devpipe;
  801c1d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c24:	30 80 00 
	return 0;
}
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    

00801c33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 14             	sub    $0x14,%esp
  801c3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c3d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c48:	e8 13 f2 ff ff       	call   800e60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c4d:	89 1c 24             	mov    %ebx,(%esp)
  801c50:	e8 2b f7 ff ff       	call   801380 <fd2data>
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c60:	e8 fb f1 ff ff       	call   800e60 <sys_page_unmap>
}
  801c65:	83 c4 14             	add    $0x14,%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 2c             	sub    $0x2c,%esp
  801c74:	89 c6                	mov    %eax,%esi
  801c76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801c79:	a1 08 40 80 00       	mov    0x804008,%eax
  801c7e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c81:	89 34 24             	mov    %esi,(%esp)
  801c84:	e8 8d 06 00 00       	call   802316 <pageref>
  801c89:	89 c7                	mov    %eax,%edi
  801c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 80 06 00 00       	call   802316 <pageref>
  801c96:	39 c7                	cmp    %eax,%edi
  801c98:	0f 94 c2             	sete   %dl
  801c9b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801c9e:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801ca4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801ca7:	39 fb                	cmp    %edi,%ebx
  801ca9:	74 21                	je     801ccc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801cab:	84 d2                	test   %dl,%dl
  801cad:	74 ca                	je     801c79 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801caf:	8b 51 58             	mov    0x58(%ecx),%edx
  801cb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cbe:	c7 04 24 b0 2b 80 00 	movl   $0x802bb0,(%esp)
  801cc5:	e8 e3 e5 ff ff       	call   8002ad <cprintf>
  801cca:	eb ad                	jmp    801c79 <_pipeisclosed+0xe>
	}
}
  801ccc:	83 c4 2c             	add    $0x2c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	57                   	push   %edi
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 1c             	sub    $0x1c,%esp
  801cdd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ce0:	89 34 24             	mov    %esi,(%esp)
  801ce3:	e8 98 f6 ff ff       	call   801380 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cec:	74 61                	je     801d4f <devpipe_write+0x7b>
  801cee:	89 c3                	mov    %eax,%ebx
  801cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf5:	eb 4a                	jmp    801d41 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801cf7:	89 da                	mov    %ebx,%edx
  801cf9:	89 f0                	mov    %esi,%eax
  801cfb:	e8 6b ff ff ff       	call   801c6b <_pipeisclosed>
  801d00:	85 c0                	test   %eax,%eax
  801d02:	75 54                	jne    801d58 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801d04:	e8 91 f0 ff ff       	call   800d9a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d09:	8b 43 04             	mov    0x4(%ebx),%eax
  801d0c:	8b 0b                	mov    (%ebx),%ecx
  801d0e:	8d 51 20             	lea    0x20(%ecx),%edx
  801d11:	39 d0                	cmp    %edx,%eax
  801d13:	73 e2                	jae    801cf7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d18:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d1c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d1f:	99                   	cltd   
  801d20:	c1 ea 1b             	shr    $0x1b,%edx
  801d23:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801d26:	83 e1 1f             	and    $0x1f,%ecx
  801d29:	29 d1                	sub    %edx,%ecx
  801d2b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801d2f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801d33:	83 c0 01             	add    $0x1,%eax
  801d36:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d39:	83 c7 01             	add    $0x1,%edi
  801d3c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d3f:	74 13                	je     801d54 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d41:	8b 43 04             	mov    0x4(%ebx),%eax
  801d44:	8b 0b                	mov    (%ebx),%ecx
  801d46:	8d 51 20             	lea    0x20(%ecx),%edx
  801d49:	39 d0                	cmp    %edx,%eax
  801d4b:	73 aa                	jae    801cf7 <devpipe_write+0x23>
  801d4d:	eb c6                	jmp    801d15 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d4f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801d54:	89 f8                	mov    %edi,%eax
  801d56:	eb 05                	jmp    801d5d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d5d:	83 c4 1c             	add    $0x1c,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5f                   	pop    %edi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    

00801d65 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	57                   	push   %edi
  801d69:	56                   	push   %esi
  801d6a:	53                   	push   %ebx
  801d6b:	83 ec 1c             	sub    $0x1c,%esp
  801d6e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d71:	89 3c 24             	mov    %edi,(%esp)
  801d74:	e8 07 f6 ff ff       	call   801380 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d7d:	74 54                	je     801dd3 <devpipe_read+0x6e>
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	be 00 00 00 00       	mov    $0x0,%esi
  801d86:	eb 3e                	jmp    801dc6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801d88:	89 f0                	mov    %esi,%eax
  801d8a:	eb 55                	jmp    801de1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d8c:	89 da                	mov    %ebx,%edx
  801d8e:	89 f8                	mov    %edi,%eax
  801d90:	e8 d6 fe ff ff       	call   801c6b <_pipeisclosed>
  801d95:	85 c0                	test   %eax,%eax
  801d97:	75 43                	jne    801ddc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801d99:	e8 fc ef ff ff       	call   800d9a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801d9e:	8b 03                	mov    (%ebx),%eax
  801da0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801da3:	74 e7                	je     801d8c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801da5:	99                   	cltd   
  801da6:	c1 ea 1b             	shr    $0x1b,%edx
  801da9:	01 d0                	add    %edx,%eax
  801dab:	83 e0 1f             	and    $0x1f,%eax
  801dae:	29 d0                	sub    %edx,%eax
  801db0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dbb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dbe:	83 c6 01             	add    $0x1,%esi
  801dc1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc4:	74 12                	je     801dd8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801dc6:	8b 03                	mov    (%ebx),%eax
  801dc8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dcb:	75 d8                	jne    801da5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801dcd:	85 f6                	test   %esi,%esi
  801dcf:	75 b7                	jne    801d88 <devpipe_read+0x23>
  801dd1:	eb b9                	jmp    801d8c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dd3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801dd8:	89 f0                	mov    %esi,%eax
  801dda:	eb 05                	jmp    801de1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801de1:	83 c4 1c             	add    $0x1c,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	56                   	push   %esi
  801ded:	53                   	push   %ebx
  801dee:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801df1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df4:	89 04 24             	mov    %eax,(%esp)
  801df7:	e8 9b f5 ff ff       	call   801397 <fd_alloc>
  801dfc:	89 c2                	mov    %eax,%edx
  801dfe:	85 d2                	test   %edx,%edx
  801e00:	0f 88 4d 01 00 00    	js     801f53 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e0d:	00 
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1c:	e8 98 ef ff ff       	call   800db9 <sys_page_alloc>
  801e21:	89 c2                	mov    %eax,%edx
  801e23:	85 d2                	test   %edx,%edx
  801e25:	0f 88 28 01 00 00    	js     801f53 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2e:	89 04 24             	mov    %eax,(%esp)
  801e31:	e8 61 f5 ff ff       	call   801397 <fd_alloc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 fe 00 00 00    	js     801f3e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e40:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e47:	00 
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e56:	e8 5e ef ff ff       	call   800db9 <sys_page_alloc>
  801e5b:	89 c3                	mov    %eax,%ebx
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	0f 88 d9 00 00 00    	js     801f3e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	89 04 24             	mov    %eax,(%esp)
  801e6b:	e8 10 f5 ff ff       	call   801380 <fd2data>
  801e70:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e79:	00 
  801e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e85:	e8 2f ef ff ff       	call   800db9 <sys_page_alloc>
  801e8a:	89 c3                	mov    %eax,%ebx
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	0f 88 97 00 00 00    	js     801f2b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e97:	89 04 24             	mov    %eax,(%esp)
  801e9a:	e8 e1 f4 ff ff       	call   801380 <fd2data>
  801e9f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801ea6:	00 
  801ea7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eb2:	00 
  801eb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebe:	e8 4a ef ff ff       	call   800e0d <sys_page_map>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	78 52                	js     801f1b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ec9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ede:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 72 f4 ff ff       	call   801370 <fd2num>
  801efe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f01:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	89 04 24             	mov    %eax,(%esp)
  801f09:	e8 62 f4 ff ff       	call   801370 <fd2num>
  801f0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f11:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
  801f19:	eb 38                	jmp    801f53 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801f1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f26:	e8 35 ef ff ff       	call   800e60 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f39:	e8 22 ef ff ff       	call   800e60 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4c:	e8 0f ef ff ff       	call   800e60 <sys_page_unmap>
  801f51:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801f53:	83 c4 30             	add    $0x30,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	89 04 24             	mov    %eax,(%esp)
  801f6d:	e8 99 f4 ff ff       	call   80140b <fd_lookup>
  801f72:	89 c2                	mov    %eax,%edx
  801f74:	85 d2                	test   %edx,%edx
  801f76:	78 15                	js     801f8d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	89 04 24             	mov    %eax,(%esp)
  801f7e:	e8 fd f3 ff ff       	call   801380 <fd2data>
	return _pipeisclosed(fd, p);
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	e8 de fc ff ff       	call   801c6b <_pipeisclosed>
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    
  801f8f:	90                   	nop

00801f90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    

00801f9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801fa0:	c7 44 24 04 c8 2b 80 	movl   $0x802bc8,0x4(%esp)
  801fa7:	00 
  801fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fab:	89 04 24             	mov    %eax,(%esp)
  801fae:	e8 58 e9 ff ff       	call   80090b <strcpy>
	return 0;
}
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	57                   	push   %edi
  801fbe:	56                   	push   %esi
  801fbf:	53                   	push   %ebx
  801fc0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fca:	74 4a                	je     802016 <devcons_write+0x5c>
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fd6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fdc:	8b 75 10             	mov    0x10(%ebp),%esi
  801fdf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801fe1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fe4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801fe9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fec:	89 74 24 08          	mov    %esi,0x8(%esp)
  801ff0:	03 45 0c             	add    0xc(%ebp),%eax
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	89 3c 24             	mov    %edi,(%esp)
  801ffa:	e8 07 eb ff ff       	call   800b06 <memmove>
		sys_cputs(buf, m);
  801fff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802003:	89 3c 24             	mov    %edi,(%esp)
  802006:	e8 e1 ec ff ff       	call   800cec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80200b:	01 f3                	add    %esi,%ebx
  80200d:	89 d8                	mov    %ebx,%eax
  80200f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802012:	72 c8                	jb     801fdc <devcons_write+0x22>
  802014:	eb 05                	jmp    80201b <devcons_write+0x61>
  802016:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80201b:	89 d8                	mov    %ebx,%eax
  80201d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5f                   	pop    %edi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    

00802028 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802033:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802037:	75 07                	jne    802040 <devcons_read+0x18>
  802039:	eb 28                	jmp    802063 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80203b:	e8 5a ed ff ff       	call   800d9a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802040:	e8 c5 ec ff ff       	call   800d0a <sys_cgetc>
  802045:	85 c0                	test   %eax,%eax
  802047:	74 f2                	je     80203b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802049:	85 c0                	test   %eax,%eax
  80204b:	78 16                	js     802063 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80204d:	83 f8 04             	cmp    $0x4,%eax
  802050:	74 0c                	je     80205e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	88 02                	mov    %al,(%edx)
	return 1;
  802057:	b8 01 00 00 00       	mov    $0x1,%eax
  80205c:	eb 05                	jmp    802063 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802071:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802078:	00 
  802079:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207c:	89 04 24             	mov    %eax,(%esp)
  80207f:	e8 68 ec ff ff       	call   800cec <sys_cputs>
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <getchar>:

int
getchar(void)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80208c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802093:	00 
  802094:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802097:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a2:	e8 0f f6 ff ff       	call   8016b6 <read>
	if (r < 0)
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	78 0f                	js     8020ba <getchar+0x34>
		return r;
	if (r < 1)
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	7e 06                	jle    8020b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8020af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8020b3:	eb 05                	jmp    8020ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8020b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	89 04 24             	mov    %eax,(%esp)
  8020cf:	e8 37 f3 ff ff       	call   80140b <fd_lookup>
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 11                	js     8020e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020e1:	39 10                	cmp    %edx,(%eax)
  8020e3:	0f 94 c0             	sete   %al
  8020e6:	0f b6 c0             	movzbl %al,%eax
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <opencons>:

int
opencons(void)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f4:	89 04 24             	mov    %eax,(%esp)
  8020f7:	e8 9b f2 ff ff       	call   801397 <fd_alloc>
		return r;
  8020fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 40                	js     802142 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802102:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802109:	00 
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802111:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802118:	e8 9c ec ff ff       	call   800db9 <sys_page_alloc>
		return r;
  80211d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 1f                	js     802142 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802123:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802138:	89 04 24             	mov    %eax,(%esp)
  80213b:	e8 30 f2 ff ff       	call   801370 <fd2num>
  802140:	89 c2                	mov    %eax,%edx
}
  802142:	89 d0                	mov    %edx,%eax
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80214c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802153:	75 50                	jne    8021a5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802155:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80215c:	00 
  80215d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802164:	ee 
  802165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216c:	e8 48 ec ff ff       	call   800db9 <sys_page_alloc>
  802171:	85 c0                	test   %eax,%eax
  802173:	79 1c                	jns    802191 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802175:	c7 44 24 08 d4 2b 80 	movl   $0x802bd4,0x8(%esp)
  80217c:	00 
  80217d:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802184:	00 
  802185:	c7 04 24 f8 2b 80 00 	movl   $0x802bf8,(%esp)
  80218c:	e8 23 e0 ff ff       	call   8001b4 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802191:	c7 44 24 04 af 21 80 	movl   $0x8021af,0x4(%esp)
  802198:	00 
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 b4 ed ff ff       	call   800f59 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021af:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021b0:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021b5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021b7:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8021ba:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8021bc:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8021c1:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8021c4:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8021c9:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8021cc:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8021ce:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8021d1:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8021d3:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8021d5:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8021da:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8021dd:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8021e2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8021e5:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8021e7:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8021ec:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8021ef:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8021f4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8021f7:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8021f9:	83 c4 08             	add    $0x8,%esp
	popal
  8021fc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8021fd:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021fe:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8021ff:	c3                   	ret    

00802200 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	56                   	push   %esi
  802204:	53                   	push   %ebx
  802205:	83 ec 10             	sub    $0x10,%esp
  802208:	8b 75 08             	mov    0x8(%ebp),%esi
  80220b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  802211:	85 c0                	test   %eax,%eax
  802213:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802218:	0f 44 c2             	cmove  %edx,%eax
  80221b:	89 04 24             	mov    %eax,(%esp)
  80221e:	e8 ac ed ff ff       	call   800fcf <sys_ipc_recv>
	if (err_code < 0) {
  802223:	85 c0                	test   %eax,%eax
  802225:	79 16                	jns    80223d <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802227:	85 f6                	test   %esi,%esi
  802229:	74 06                	je     802231 <ipc_recv+0x31>
  80222b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802231:	85 db                	test   %ebx,%ebx
  802233:	74 2c                	je     802261 <ipc_recv+0x61>
  802235:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223b:	eb 24                	jmp    802261 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80223d:	85 f6                	test   %esi,%esi
  80223f:	74 0a                	je     80224b <ipc_recv+0x4b>
  802241:	a1 08 40 80 00       	mov    0x804008,%eax
  802246:	8b 40 74             	mov    0x74(%eax),%eax
  802249:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80224b:	85 db                	test   %ebx,%ebx
  80224d:	74 0a                	je     802259 <ipc_recv+0x59>
  80224f:	a1 08 40 80 00       	mov    0x804008,%eax
  802254:	8b 40 78             	mov    0x78(%eax),%eax
  802257:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802259:	a1 08 40 80 00       	mov    0x804008,%eax
  80225e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    

00802268 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	57                   	push   %edi
  80226c:	56                   	push   %esi
  80226d:	53                   	push   %ebx
  80226e:	83 ec 1c             	sub    $0x1c,%esp
  802271:	8b 7d 08             	mov    0x8(%ebp),%edi
  802274:	8b 75 0c             	mov    0xc(%ebp),%esi
  802277:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80227a:	eb 25                	jmp    8022a1 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  80227c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227f:	74 20                	je     8022a1 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802281:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802285:	c7 44 24 08 06 2c 80 	movl   $0x802c06,0x8(%esp)
  80228c:	00 
  80228d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802294:	00 
  802295:	c7 04 24 12 2c 80 00 	movl   $0x802c12,(%esp)
  80229c:	e8 13 df ff ff       	call   8001b4 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8022a1:	85 db                	test   %ebx,%ebx
  8022a3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022a8:	0f 45 c3             	cmovne %ebx,%eax
  8022ab:	8b 55 14             	mov    0x14(%ebp),%edx
  8022ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ba:	89 3c 24             	mov    %edi,(%esp)
  8022bd:	e8 ea ec ff ff       	call   800fac <sys_ipc_try_send>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 b6                	jne    80227c <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8022c6:	83 c4 1c             	add    $0x1c,%esp
  8022c9:	5b                   	pop    %ebx
  8022ca:	5e                   	pop    %esi
  8022cb:	5f                   	pop    %edi
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    

008022ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8022d4:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8022d9:	39 c8                	cmp    %ecx,%eax
  8022db:	74 17                	je     8022f4 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022dd:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8022e2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022eb:	8b 52 50             	mov    0x50(%edx),%edx
  8022ee:	39 ca                	cmp    %ecx,%edx
  8022f0:	75 14                	jne    802306 <ipc_find_env+0x38>
  8022f2:	eb 05                	jmp    8022f9 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8022f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022fc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802301:	8b 40 40             	mov    0x40(%eax),%eax
  802304:	eb 0e                	jmp    802314 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802306:	83 c0 01             	add    $0x1,%eax
  802309:	3d 00 04 00 00       	cmp    $0x400,%eax
  80230e:	75 d2                	jne    8022e2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802310:	66 b8 00 00          	mov    $0x0,%ax
}
  802314:	5d                   	pop    %ebp
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
