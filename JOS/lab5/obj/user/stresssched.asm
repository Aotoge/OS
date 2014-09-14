
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
  8000e1:	c7 44 24 08 e0 25 80 	movl   $0x8025e0,0x8(%esp)
  8000e8:	00 
  8000e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000f0:	00 
  8000f1:	c7 04 24 08 26 80 00 	movl   $0x802608,(%esp)
  8000f8:	e8 b7 00 00 00       	call   8001b4 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000fd:	a1 08 40 80 00       	mov    0x804008,%eax
  800102:	8b 50 5c             	mov    0x5c(%eax),%edx
  800105:	8b 40 48             	mov    0x48(%eax),%eax
  800108:	89 54 24 08          	mov    %edx,0x8(%esp)
  80010c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800110:	c7 04 24 1b 26 80 00 	movl   $0x80261b,(%esp)
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
  8001a1:	e8 f0 13 00 00       	call   801596 <close_all>
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
  8001e0:	c7 04 24 44 26 80 00 	movl   $0x802644,(%esp)
  8001e7:	e8 c1 00 00 00       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 51 00 00 00       	call   80024c <vcprintf>
	cprintf("\n");
  8001fb:	c7 04 24 37 26 80 00 	movl   $0x802637,(%esp)
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
  80034c:	e8 ef 1f 00 00       	call   802340 <__udivdi3>
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
  8003a5:	e8 c6 20 00 00       	call   802470 <__umoddi3>
  8003aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ae:	0f be 80 67 26 80 00 	movsbl 0x802667(%eax),%eax
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
  8004cc:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
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
  80057f:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800586:	85 d2                	test   %edx,%edx
  800588:	75 20                	jne    8005aa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80058a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058e:	c7 44 24 08 7f 26 80 	movl   $0x80267f,0x8(%esp)
  800595:	00 
  800596:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	89 04 24             	mov    %eax,(%esp)
  8005a0:	e8 77 fe ff ff       	call   80041c <printfmt>
  8005a5:	e9 c3 fe ff ff       	jmp    80046d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ae:	c7 44 24 08 4f 2b 80 	movl   $0x802b4f,0x8(%esp)
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
  8005dd:	ba 78 26 80 00       	mov    $0x802678,%edx
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
  800d57:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d66:	00 
  800d67:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800de9:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800df0:	00 
  800df1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800df8:	00 
  800df9:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800e3c:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800e43:	00 
  800e44:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e4b:	00 
  800e4c:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800e8f:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800e96:	00 
  800e97:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e9e:	00 
  800e9f:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800ee2:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800ee9:	00 
  800eea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ef1:	00 
  800ef2:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800f35:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f44:	00 
  800f45:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800f88:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  800ffd:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  801004:	00 
  801005:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80100c:	00 
  80100d:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
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
  801044:	c7 44 24 08 8c 29 80 	movl   $0x80298c,0x8(%esp)
  80104b:	00 
  80104c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801053:	00 
  801054:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
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
  801084:	c7 44 24 08 f4 29 80 	movl   $0x8029f4,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
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
  8010ee:	c7 44 24 08 0e 2a 80 	movl   $0x802a0e,0x8(%esp)
  8010f5:	00 
  8010f6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8010fd:	00 
  8010fe:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
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
  801120:	e8 01 10 00 00       	call   802126 <set_pgfault_handler>
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
  801133:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  80113a:	00 
  80113b:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801142:	00 
  801143:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
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
  801178:	e9 cf 01 00 00       	jmp    80134c <fork+0x23c>
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
  80118b:	0f 84 fc 00 00 00    	je     80128d <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801191:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801198:	a8 05                	test   $0x5,%al
  80119a:	0f 84 ed 00 00 00    	je     80128d <fork+0x17d>
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
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  8011ac:	f6 c4 04             	test   $0x4,%ah
  8011af:	0f 85 93 00 00 00    	jne    801248 <fork+0x138>
  8011b5:	a9 02 08 00 00       	test   $0x802,%eax
  8011ba:	0f 84 88 00 00 00    	je     801248 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8011c0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011c7:	00 
  8011c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011cc:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011db:	e8 2d fc ff ff       	call   800e0d <sys_page_map>
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 20                	jns    801204 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  8011e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e8:	c7 44 24 08 2c 2a 80 	movl   $0x802a2c,0x8(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8011f7:	00 
  8011f8:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8011ff:	e8 b0 ef ff ff       	call   8001b4 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  801204:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80120b:	00 
  80120c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801210:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801217:	00 
  801218:	89 74 24 04          	mov    %esi,0x4(%esp)
  80121c:	89 3c 24             	mov    %edi,(%esp)
  80121f:	e8 e9 fb ff ff       	call   800e0d <sys_page_map>
  801224:	85 c0                	test   %eax,%eax
  801226:	79 65                	jns    80128d <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  801228:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122c:	c7 44 24 08 46 2a 80 	movl   $0x802a46,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801243:	e8 6c ef ff ff       	call   8001b4 <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  801248:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80124d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801251:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801255:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801259:	89 74 24 04          	mov    %esi,0x4(%esp)
  80125d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801264:	e8 a4 fb ff ff       	call   800e0d <sys_page_map>
  801269:	85 c0                	test   %eax,%eax
  80126b:	79 20                	jns    80128d <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  80126d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801271:	c7 44 24 08 60 2a 80 	movl   $0x802a60,0x8(%esp)
  801278:	00 
  801279:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801280:	00 
  801281:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801288:	e8 27 ef ff ff       	call   8001b4 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  80128d:	83 c3 01             	add    $0x1,%ebx
  801290:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801296:	0f 85 e1 fe ff ff    	jne    80117d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  80129c:	c7 44 24 04 8f 21 80 	movl   $0x80218f,0x4(%esp)
  8012a3:	00 
  8012a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a7:	89 04 24             	mov    %eax,(%esp)
  8012aa:	e8 aa fc ff ff       	call   800f59 <sys_env_set_pgfault_upcall>
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	79 20                	jns    8012d3 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8012b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b7:	c7 44 24 08 c4 29 80 	movl   $0x8029c4,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8012ce:	e8 e1 ee ff ff       	call   8001b4 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8012d3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012da:	00 
  8012db:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012e2:	ee 
  8012e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e6:	89 04 24             	mov    %eax,(%esp)
  8012e9:	e8 cb fa ff ff       	call   800db9 <sys_page_alloc>
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	79 20                	jns    801312 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8012f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f6:	c7 44 24 08 72 2a 80 	movl   $0x802a72,0x8(%esp)
  8012fd:	00 
  8012fe:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801305:	00 
  801306:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  80130d:	e8 a2 ee ff ff       	call   8001b4 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801312:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801319:	00 
  80131a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131d:	89 04 24             	mov    %eax,(%esp)
  801320:	e8 8e fb ff ff       	call   800eb3 <sys_env_set_status>
  801325:	85 c0                	test   %eax,%eax
  801327:	79 20                	jns    801349 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  801329:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80132d:	c7 44 24 08 8a 2a 80 	movl   $0x802a8a,0x8(%esp)
  801334:	00 
  801335:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  80133c:	00 
  80133d:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801344:	e8 6b ee ff ff       	call   8001b4 <_panic>
	}

	return envid;
  801349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80134c:	83 c4 2c             	add    $0x2c,%esp
  80134f:	5b                   	pop    %ebx
  801350:	5e                   	pop    %esi
  801351:	5f                   	pop    %edi
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <sfork>:

// Challenge!
int
sfork(void)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80135a:	c7 44 24 08 a5 2a 80 	movl   $0x802aa5,0x8(%esp)
  801361:	00 
  801362:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  801369:	00 
  80136a:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  801371:	e8 3e ee ff ff       	call   8001b4 <_panic>
  801376:	66 90                	xchg   %ax,%ax
  801378:	66 90                	xchg   %ax,%ax
  80137a:	66 90                	xchg   %ax,%ax
  80137c:	66 90                	xchg   %ax,%ax
  80137e:	66 90                	xchg   %ax,%ax

00801380 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	05 00 00 00 30       	add    $0x30000000,%eax
  80138b:	c1 e8 0c             	shr    $0xc,%eax
}
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80139b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013aa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8013af:	a8 01                	test   $0x1,%al
  8013b1:	74 34                	je     8013e7 <fd_alloc+0x40>
  8013b3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013b8:	a8 01                	test   $0x1,%al
  8013ba:	74 32                	je     8013ee <fd_alloc+0x47>
  8013bc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013c1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	c1 ea 16             	shr    $0x16,%edx
  8013c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013cf:	f6 c2 01             	test   $0x1,%dl
  8013d2:	74 1f                	je     8013f3 <fd_alloc+0x4c>
  8013d4:	89 c2                	mov    %eax,%edx
  8013d6:	c1 ea 0c             	shr    $0xc,%edx
  8013d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e0:	f6 c2 01             	test   $0x1,%dl
  8013e3:	75 1a                	jne    8013ff <fd_alloc+0x58>
  8013e5:	eb 0c                	jmp    8013f3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013e7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8013ec:	eb 05                	jmp    8013f3 <fd_alloc+0x4c>
  8013ee:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fd:	eb 1a                	jmp    801419 <fd_alloc+0x72>
  8013ff:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801404:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801409:	75 b6                	jne    8013c1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801414:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801419:	5d                   	pop    %ebp
  80141a:	c3                   	ret    

0080141b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801421:	83 f8 1f             	cmp    $0x1f,%eax
  801424:	77 36                	ja     80145c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801426:	c1 e0 0c             	shl    $0xc,%eax
  801429:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80142e:	89 c2                	mov    %eax,%edx
  801430:	c1 ea 16             	shr    $0x16,%edx
  801433:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143a:	f6 c2 01             	test   $0x1,%dl
  80143d:	74 24                	je     801463 <fd_lookup+0x48>
  80143f:	89 c2                	mov    %eax,%edx
  801441:	c1 ea 0c             	shr    $0xc,%edx
  801444:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144b:	f6 c2 01             	test   $0x1,%dl
  80144e:	74 1a                	je     80146a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	89 02                	mov    %eax,(%edx)
	return 0;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	eb 13                	jmp    80146f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80145c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801461:	eb 0c                	jmp    80146f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb 05                	jmp    80146f <fd_lookup+0x54>
  80146a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 14             	sub    $0x14,%esp
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80147e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801484:	75 1e                	jne    8014a4 <dev_lookup+0x33>
  801486:	eb 0e                	jmp    801496 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801488:	b8 20 30 80 00       	mov    $0x803020,%eax
  80148d:	eb 0c                	jmp    80149b <dev_lookup+0x2a>
  80148f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801494:	eb 05                	jmp    80149b <dev_lookup+0x2a>
  801496:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80149b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a2:	eb 38                	jmp    8014dc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8014a4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8014aa:	74 dc                	je     801488 <dev_lookup+0x17>
  8014ac:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8014b2:	74 db                	je     80148f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014b4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8014ba:	8b 52 48             	mov    0x48(%edx),%edx
  8014bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014c5:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  8014cc:	e8 dc ed ff ff       	call   8002ad <cprintf>
	*dev = 0;
  8014d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014dc:	83 c4 14             	add    $0x14,%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	56                   	push   %esi
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 20             	sub    $0x20,%esp
  8014ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8014ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014fd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801500:	89 04 24             	mov    %eax,(%esp)
  801503:	e8 13 ff ff ff       	call   80141b <fd_lookup>
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 05                	js     801511 <fd_close+0x2f>
	    || fd != fd2)
  80150c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80150f:	74 0c                	je     80151d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801511:	84 db                	test   %bl,%bl
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	0f 44 c2             	cmove  %edx,%eax
  80151b:	eb 3f                	jmp    80155c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80151d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801520:	89 44 24 04          	mov    %eax,0x4(%esp)
  801524:	8b 06                	mov    (%esi),%eax
  801526:	89 04 24             	mov    %eax,(%esp)
  801529:	e8 43 ff ff ff       	call   801471 <dev_lookup>
  80152e:	89 c3                	mov    %eax,%ebx
  801530:	85 c0                	test   %eax,%eax
  801532:	78 16                	js     80154a <fd_close+0x68>
		if (dev->dev_close)
  801534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801537:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80153a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80153f:	85 c0                	test   %eax,%eax
  801541:	74 07                	je     80154a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801543:	89 34 24             	mov    %esi,(%esp)
  801546:	ff d0                	call   *%eax
  801548:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80154a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80154e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801555:	e8 06 f9 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  80155a:	89 d8                	mov    %ebx,%eax
}
  80155c:	83 c4 20             	add    $0x20,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801569:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 04 24             	mov    %eax,(%esp)
  801576:	e8 a0 fe ff ff       	call   80141b <fd_lookup>
  80157b:	89 c2                	mov    %eax,%edx
  80157d:	85 d2                	test   %edx,%edx
  80157f:	78 13                	js     801594 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801581:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801588:	00 
  801589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158c:	89 04 24             	mov    %eax,(%esp)
  80158f:	e8 4e ff ff ff       	call   8014e2 <fd_close>
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <close_all>:

void
close_all(void)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80159d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015a2:	89 1c 24             	mov    %ebx,(%esp)
  8015a5:	e8 b9 ff ff ff       	call   801563 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015aa:	83 c3 01             	add    $0x1,%ebx
  8015ad:	83 fb 20             	cmp    $0x20,%ebx
  8015b0:	75 f0                	jne    8015a2 <close_all+0xc>
		close(i);
}
  8015b2:	83 c4 14             	add    $0x14,%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	57                   	push   %edi
  8015bc:	56                   	push   %esi
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	89 04 24             	mov    %eax,(%esp)
  8015ce:	e8 48 fe ff ff       	call   80141b <fd_lookup>
  8015d3:	89 c2                	mov    %eax,%edx
  8015d5:	85 d2                	test   %edx,%edx
  8015d7:	0f 88 e1 00 00 00    	js     8016be <dup+0x106>
		return r;
	close(newfdnum);
  8015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e0:	89 04 24             	mov    %eax,(%esp)
  8015e3:	e8 7b ff ff ff       	call   801563 <close>

	newfd = INDEX2FD(newfdnum);
  8015e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015eb:	c1 e3 0c             	shl    $0xc,%ebx
  8015ee:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 91 fd ff ff       	call   801390 <fd2data>
  8015ff:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801601:	89 1c 24             	mov    %ebx,(%esp)
  801604:	e8 87 fd ff ff       	call   801390 <fd2data>
  801609:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80160b:	89 f0                	mov    %esi,%eax
  80160d:	c1 e8 16             	shr    $0x16,%eax
  801610:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801617:	a8 01                	test   $0x1,%al
  801619:	74 43                	je     80165e <dup+0xa6>
  80161b:	89 f0                	mov    %esi,%eax
  80161d:	c1 e8 0c             	shr    $0xc,%eax
  801620:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801627:	f6 c2 01             	test   $0x1,%dl
  80162a:	74 32                	je     80165e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80162c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801633:	25 07 0e 00 00       	and    $0xe07,%eax
  801638:	89 44 24 10          	mov    %eax,0x10(%esp)
  80163c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801640:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801647:	00 
  801648:	89 74 24 04          	mov    %esi,0x4(%esp)
  80164c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801653:	e8 b5 f7 ff ff       	call   800e0d <sys_page_map>
  801658:	89 c6                	mov    %eax,%esi
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 3e                	js     80169c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80165e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801661:	89 c2                	mov    %eax,%edx
  801663:	c1 ea 0c             	shr    $0xc,%edx
  801666:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80166d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801673:	89 54 24 10          	mov    %edx,0x10(%esp)
  801677:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80167b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801682:	00 
  801683:	89 44 24 04          	mov    %eax,0x4(%esp)
  801687:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168e:	e8 7a f7 ff ff       	call   800e0d <sys_page_map>
  801693:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801695:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801698:	85 f6                	test   %esi,%esi
  80169a:	79 22                	jns    8016be <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80169c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a7:	e8 b4 f7 ff ff       	call   800e60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b7:	e8 a4 f7 ff ff       	call   800e60 <sys_page_unmap>
	return r;
  8016bc:	89 f0                	mov    %esi,%eax
}
  8016be:	83 c4 3c             	add    $0x3c,%esp
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5f                   	pop    %edi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 24             	sub    $0x24,%esp
  8016cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 3c fd ff ff       	call   80141b <fd_lookup>
  8016df:	89 c2                	mov    %eax,%edx
  8016e1:	85 d2                	test   %edx,%edx
  8016e3:	78 6d                	js     801752 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	8b 00                	mov    (%eax),%eax
  8016f1:	89 04 24             	mov    %eax,(%esp)
  8016f4:	e8 78 fd ff ff       	call   801471 <dev_lookup>
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 55                	js     801752 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	8b 50 08             	mov    0x8(%eax),%edx
  801703:	83 e2 03             	and    $0x3,%edx
  801706:	83 fa 01             	cmp    $0x1,%edx
  801709:	75 23                	jne    80172e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80170b:	a1 08 40 80 00       	mov    0x804008,%eax
  801710:	8b 40 48             	mov    0x48(%eax),%eax
  801713:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	c7 04 24 fd 2a 80 00 	movl   $0x802afd,(%esp)
  801722:	e8 86 eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172c:	eb 24                	jmp    801752 <read+0x8c>
	}
	if (!dev->dev_read)
  80172e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801731:	8b 52 08             	mov    0x8(%edx),%edx
  801734:	85 d2                	test   %edx,%edx
  801736:	74 15                	je     80174d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801738:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80173f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801746:	89 04 24             	mov    %eax,(%esp)
  801749:	ff d2                	call   *%edx
  80174b:	eb 05                	jmp    801752 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80174d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801752:	83 c4 24             	add    $0x24,%esp
  801755:	5b                   	pop    %ebx
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 1c             	sub    $0x1c,%esp
  801761:	8b 7d 08             	mov    0x8(%ebp),%edi
  801764:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801767:	85 f6                	test   %esi,%esi
  801769:	74 33                	je     80179e <readn+0x46>
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
  801770:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801775:	89 f2                	mov    %esi,%edx
  801777:	29 c2                	sub    %eax,%edx
  801779:	89 54 24 08          	mov    %edx,0x8(%esp)
  80177d:	03 45 0c             	add    0xc(%ebp),%eax
  801780:	89 44 24 04          	mov    %eax,0x4(%esp)
  801784:	89 3c 24             	mov    %edi,(%esp)
  801787:	e8 3a ff ff ff       	call   8016c6 <read>
		if (m < 0)
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 1b                	js     8017ab <readn+0x53>
			return m;
		if (m == 0)
  801790:	85 c0                	test   %eax,%eax
  801792:	74 11                	je     8017a5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801794:	01 c3                	add    %eax,%ebx
  801796:	89 d8                	mov    %ebx,%eax
  801798:	39 f3                	cmp    %esi,%ebx
  80179a:	72 d9                	jb     801775 <readn+0x1d>
  80179c:	eb 0b                	jmp    8017a9 <readn+0x51>
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	eb 06                	jmp    8017ab <readn+0x53>
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	eb 02                	jmp    8017ab <readn+0x53>
  8017a9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017ab:	83 c4 1c             	add    $0x1c,%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5f                   	pop    %edi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 24             	sub    $0x24,%esp
  8017ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	89 1c 24             	mov    %ebx,(%esp)
  8017c7:	e8 4f fc ff ff       	call   80141b <fd_lookup>
  8017cc:	89 c2                	mov    %eax,%edx
  8017ce:	85 d2                	test   %edx,%edx
  8017d0:	78 68                	js     80183a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dc:	8b 00                	mov    (%eax),%eax
  8017de:	89 04 24             	mov    %eax,(%esp)
  8017e1:	e8 8b fc ff ff       	call   801471 <dev_lookup>
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 50                	js     80183a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f1:	75 23                	jne    801816 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8017f8:	8b 40 48             	mov    0x48(%eax),%eax
  8017fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801803:	c7 04 24 19 2b 80 00 	movl   $0x802b19,(%esp)
  80180a:	e8 9e ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  80180f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801814:	eb 24                	jmp    80183a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801819:	8b 52 0c             	mov    0xc(%edx),%edx
  80181c:	85 d2                	test   %edx,%edx
  80181e:	74 15                	je     801835 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801820:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801823:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801827:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	ff d2                	call   *%edx
  801833:	eb 05                	jmp    80183a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801835:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80183a:	83 c4 24             	add    $0x24,%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <seek>:

int
seek(int fdnum, off_t offset)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801846:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 04 24             	mov    %eax,(%esp)
  801853:	e8 c3 fb ff ff       	call   80141b <fd_lookup>
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 0e                	js     80186a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80185c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 24             	sub    $0x24,%esp
  801873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801876:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801879:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187d:	89 1c 24             	mov    %ebx,(%esp)
  801880:	e8 96 fb ff ff       	call   80141b <fd_lookup>
  801885:	89 c2                	mov    %eax,%edx
  801887:	85 d2                	test   %edx,%edx
  801889:	78 61                	js     8018ec <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	89 04 24             	mov    %eax,(%esp)
  80189a:	e8 d2 fb ff ff       	call   801471 <dev_lookup>
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 49                	js     8018ec <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018aa:	75 23                	jne    8018cf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018ac:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b1:	8b 40 48             	mov    0x48(%eax),%eax
  8018b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bc:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  8018c3:	e8 e5 e9 ff ff       	call   8002ad <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cd:	eb 1d                	jmp    8018ec <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d2:	8b 52 18             	mov    0x18(%edx),%edx
  8018d5:	85 d2                	test   %edx,%edx
  8018d7:	74 0e                	je     8018e7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018e0:	89 04 24             	mov    %eax,(%esp)
  8018e3:	ff d2                	call   *%edx
  8018e5:	eb 05                	jmp    8018ec <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018ec:	83 c4 24             	add    $0x24,%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 24             	sub    $0x24,%esp
  8018f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	89 04 24             	mov    %eax,(%esp)
  801909:	e8 0d fb ff ff       	call   80141b <fd_lookup>
  80190e:	89 c2                	mov    %eax,%edx
  801910:	85 d2                	test   %edx,%edx
  801912:	78 52                	js     801966 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	89 04 24             	mov    %eax,(%esp)
  801923:	e8 49 fb ff ff       	call   801471 <dev_lookup>
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 3a                	js     801966 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801933:	74 2c                	je     801961 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801935:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801938:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80193f:	00 00 00 
	stat->st_isdir = 0;
  801942:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801949:	00 00 00 
	stat->st_dev = dev;
  80194c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801952:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801959:	89 14 24             	mov    %edx,(%esp)
  80195c:	ff 50 14             	call   *0x14(%eax)
  80195f:	eb 05                	jmp    801966 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801961:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801966:	83 c4 24             	add    $0x24,%esp
  801969:	5b                   	pop    %ebx
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801974:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80197b:	00 
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	89 04 24             	mov    %eax,(%esp)
  801982:	e8 af 01 00 00       	call   801b36 <open>
  801987:	89 c3                	mov    %eax,%ebx
  801989:	85 db                	test   %ebx,%ebx
  80198b:	78 1b                	js     8019a8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	89 1c 24             	mov    %ebx,(%esp)
  801997:	e8 56 ff ff ff       	call   8018f2 <fstat>
  80199c:	89 c6                	mov    %eax,%esi
	close(fd);
  80199e:	89 1c 24             	mov    %ebx,(%esp)
  8019a1:	e8 bd fb ff ff       	call   801563 <close>
	return r;
  8019a6:	89 f0                	mov    %esi,%eax
}
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 10             	sub    $0x10,%esp
  8019b7:	89 c6                	mov    %eax,%esi
  8019b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019c2:	75 11                	jne    8019d5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019cb:	e8 de 08 00 00       	call   8022ae <ipc_find_env>
  8019d0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019d5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019dc:	00 
  8019dd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8019e4:	00 
  8019e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8019ee:	89 04 24             	mov    %eax,(%esp)
  8019f1:	e8 52 08 00 00       	call   802248 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019fd:	00 
  8019fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a09:	e8 d2 07 00 00       	call   8021e0 <ipc_recv>
}
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	53                   	push   %ebx
  801a19:	83 ec 14             	sub    $0x14,%esp
  801a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
  801a25:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a34:	e8 76 ff ff ff       	call   8019af <fsipc>
  801a39:	89 c2                	mov    %eax,%edx
  801a3b:	85 d2                	test   %edx,%edx
  801a3d:	78 2b                	js     801a6a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a3f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a46:	00 
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 bc ee ff ff       	call   80090b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a4f:	a1 80 50 80 00       	mov    0x805080,%eax
  801a54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a5a:	a1 84 50 80 00       	mov    0x805084,%eax
  801a5f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6a:	83 c4 14             	add    $0x14,%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    

00801a70 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a81:	ba 00 00 00 00       	mov    $0x0,%edx
  801a86:	b8 06 00 00 00       	mov    $0x6,%eax
  801a8b:	e8 1f ff ff ff       	call   8019af <fsipc>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	56                   	push   %esi
  801a96:	53                   	push   %ebx
  801a97:	83 ec 10             	sub    $0x10,%esp
  801a9a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aa8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab8:	e8 f2 fe ff ff       	call   8019af <fsipc>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 6a                	js     801b2d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ac3:	39 c6                	cmp    %eax,%esi
  801ac5:	73 24                	jae    801aeb <devfile_read+0x59>
  801ac7:	c7 44 24 0c 36 2b 80 	movl   $0x802b36,0xc(%esp)
  801ace:	00 
  801acf:	c7 44 24 08 3d 2b 80 	movl   $0x802b3d,0x8(%esp)
  801ad6:	00 
  801ad7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801ade:	00 
  801adf:	c7 04 24 52 2b 80 00 	movl   $0x802b52,(%esp)
  801ae6:	e8 c9 e6 ff ff       	call   8001b4 <_panic>
	assert(r <= PGSIZE);
  801aeb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af0:	7e 24                	jle    801b16 <devfile_read+0x84>
  801af2:	c7 44 24 0c 5d 2b 80 	movl   $0x802b5d,0xc(%esp)
  801af9:	00 
  801afa:	c7 44 24 08 3d 2b 80 	movl   $0x802b3d,0x8(%esp)
  801b01:	00 
  801b02:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b09:	00 
  801b0a:	c7 04 24 52 2b 80 00 	movl   $0x802b52,(%esp)
  801b11:	e8 9e e6 ff ff       	call   8001b4 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b16:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b1a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b21:	00 
  801b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b25:	89 04 24             	mov    %eax,(%esp)
  801b28:	e8 d9 ef ff ff       	call   800b06 <memmove>
	return r;
}
  801b2d:	89 d8                	mov    %ebx,%eax
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5e                   	pop    %esi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 24             	sub    $0x24,%esp
  801b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b40:	89 1c 24             	mov    %ebx,(%esp)
  801b43:	e8 68 ed ff ff       	call   8008b0 <strlen>
  801b48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4d:	7f 60                	jg     801baf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	e8 4d f8 ff ff       	call   8013a7 <fd_alloc>
  801b5a:	89 c2                	mov    %eax,%edx
  801b5c:	85 d2                	test   %edx,%edx
  801b5e:	78 54                	js     801bb4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b64:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b6b:	e8 9b ed ff ff       	call   80090b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b73:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b80:	e8 2a fe ff ff       	call   8019af <fsipc>
  801b85:	89 c3                	mov    %eax,%ebx
  801b87:	85 c0                	test   %eax,%eax
  801b89:	79 17                	jns    801ba2 <open+0x6c>
		fd_close(fd, 0);
  801b8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b92:	00 
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	e8 44 f9 ff ff       	call   8014e2 <fd_close>
		return r;
  801b9e:	89 d8                	mov    %ebx,%eax
  801ba0:	eb 12                	jmp    801bb4 <open+0x7e>
	}
	return fd2num(fd);
  801ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba5:	89 04 24             	mov    %eax,(%esp)
  801ba8:	e8 d3 f7 ff ff       	call   801380 <fd2num>
  801bad:	eb 05                	jmp    801bb4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801baf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801bb4:	83 c4 24             	add    $0x24,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	66 90                	xchg   %ax,%ax
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 10             	sub    $0x10,%esp
  801bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	89 04 24             	mov    %eax,(%esp)
  801bd1:	e8 ba f7 ff ff       	call   801390 <fd2data>
  801bd6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bd8:	c7 44 24 04 69 2b 80 	movl   $0x802b69,0x4(%esp)
  801bdf:	00 
  801be0:	89 1c 24             	mov    %ebx,(%esp)
  801be3:	e8 23 ed ff ff       	call   80090b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801be8:	8b 46 04             	mov    0x4(%esi),%eax
  801beb:	2b 06                	sub    (%esi),%eax
  801bed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bf3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bfa:	00 00 00 
	stat->st_dev = &devpipe;
  801bfd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c04:	30 80 00 
	return 0;
}
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5d                   	pop    %ebp
  801c12:	c3                   	ret    

00801c13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	53                   	push   %ebx
  801c17:	83 ec 14             	sub    $0x14,%esp
  801c1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c28:	e8 33 f2 ff ff       	call   800e60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c2d:	89 1c 24             	mov    %ebx,(%esp)
  801c30:	e8 5b f7 ff ff       	call   801390 <fd2data>
  801c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c40:	e8 1b f2 ff ff       	call   800e60 <sys_page_unmap>
}
  801c45:	83 c4 14             	add    $0x14,%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	57                   	push   %edi
  801c4f:	56                   	push   %esi
  801c50:	53                   	push   %ebx
  801c51:	83 ec 2c             	sub    $0x2c,%esp
  801c54:	89 c6                	mov    %eax,%esi
  801c56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801c59:	a1 08 40 80 00       	mov    0x804008,%eax
  801c5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c61:	89 34 24             	mov    %esi,(%esp)
  801c64:	e8 8d 06 00 00       	call   8022f6 <pageref>
  801c69:	89 c7                	mov    %eax,%edi
  801c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c6e:	89 04 24             	mov    %eax,(%esp)
  801c71:	e8 80 06 00 00       	call   8022f6 <pageref>
  801c76:	39 c7                	cmp    %eax,%edi
  801c78:	0f 94 c2             	sete   %dl
  801c7b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801c7e:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801c84:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801c87:	39 fb                	cmp    %edi,%ebx
  801c89:	74 21                	je     801cac <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c8b:	84 d2                	test   %dl,%dl
  801c8d:	74 ca                	je     801c59 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c8f:	8b 51 58             	mov    0x58(%ecx),%edx
  801c92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c96:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c9e:	c7 04 24 70 2b 80 00 	movl   $0x802b70,(%esp)
  801ca5:	e8 03 e6 ff ff       	call   8002ad <cprintf>
  801caa:	eb ad                	jmp    801c59 <_pipeisclosed+0xe>
	}
}
  801cac:	83 c4 2c             	add    $0x2c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	57                   	push   %edi
  801cb8:	56                   	push   %esi
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 1c             	sub    $0x1c,%esp
  801cbd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801cc0:	89 34 24             	mov    %esi,(%esp)
  801cc3:	e8 c8 f6 ff ff       	call   801390 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccc:	74 61                	je     801d2f <devpipe_write+0x7b>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd5:	eb 4a                	jmp    801d21 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801cd7:	89 da                	mov    %ebx,%edx
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	e8 6b ff ff ff       	call   801c4b <_pipeisclosed>
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 54                	jne    801d38 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ce4:	e8 b1 f0 ff ff       	call   800d9a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ce9:	8b 43 04             	mov    0x4(%ebx),%eax
  801cec:	8b 0b                	mov    (%ebx),%ecx
  801cee:	8d 51 20             	lea    0x20(%ecx),%edx
  801cf1:	39 d0                	cmp    %edx,%eax
  801cf3:	73 e2                	jae    801cd7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cf8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cfc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cff:	99                   	cltd   
  801d00:	c1 ea 1b             	shr    $0x1b,%edx
  801d03:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801d06:	83 e1 1f             	and    $0x1f,%ecx
  801d09:	29 d1                	sub    %edx,%ecx
  801d0b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801d0f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801d13:	83 c0 01             	add    $0x1,%eax
  801d16:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d19:	83 c7 01             	add    $0x1,%edi
  801d1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d1f:	74 13                	je     801d34 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d21:	8b 43 04             	mov    0x4(%ebx),%eax
  801d24:	8b 0b                	mov    (%ebx),%ecx
  801d26:	8d 51 20             	lea    0x20(%ecx),%edx
  801d29:	39 d0                	cmp    %edx,%eax
  801d2b:	73 aa                	jae    801cd7 <devpipe_write+0x23>
  801d2d:	eb c6                	jmp    801cf5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d2f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801d34:	89 f8                	mov    %edi,%eax
  801d36:	eb 05                	jmp    801d3d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d3d:	83 c4 1c             	add    $0x1c,%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	57                   	push   %edi
  801d49:	56                   	push   %esi
  801d4a:	53                   	push   %ebx
  801d4b:	83 ec 1c             	sub    $0x1c,%esp
  801d4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d51:	89 3c 24             	mov    %edi,(%esp)
  801d54:	e8 37 f6 ff ff       	call   801390 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d5d:	74 54                	je     801db3 <devpipe_read+0x6e>
  801d5f:	89 c3                	mov    %eax,%ebx
  801d61:	be 00 00 00 00       	mov    $0x0,%esi
  801d66:	eb 3e                	jmp    801da6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801d68:	89 f0                	mov    %esi,%eax
  801d6a:	eb 55                	jmp    801dc1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d6c:	89 da                	mov    %ebx,%edx
  801d6e:	89 f8                	mov    %edi,%eax
  801d70:	e8 d6 fe ff ff       	call   801c4b <_pipeisclosed>
  801d75:	85 c0                	test   %eax,%eax
  801d77:	75 43                	jne    801dbc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801d79:	e8 1c f0 ff ff       	call   800d9a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801d7e:	8b 03                	mov    (%ebx),%eax
  801d80:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d83:	74 e7                	je     801d6c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d85:	99                   	cltd   
  801d86:	c1 ea 1b             	shr    $0x1b,%edx
  801d89:	01 d0                	add    %edx,%eax
  801d8b:	83 e0 1f             	and    $0x1f,%eax
  801d8e:	29 d0                	sub    %edx,%eax
  801d90:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d98:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d9b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d9e:	83 c6 01             	add    $0x1,%esi
  801da1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da4:	74 12                	je     801db8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801da6:	8b 03                	mov    (%ebx),%eax
  801da8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dab:	75 d8                	jne    801d85 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801dad:	85 f6                	test   %esi,%esi
  801daf:	75 b7                	jne    801d68 <devpipe_read+0x23>
  801db1:	eb b9                	jmp    801d6c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801db3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801db8:	89 f0                	mov    %esi,%eax
  801dba:	eb 05                	jmp    801dc1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801dd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd4:	89 04 24             	mov    %eax,(%esp)
  801dd7:	e8 cb f5 ff ff       	call   8013a7 <fd_alloc>
  801ddc:	89 c2                	mov    %eax,%edx
  801dde:	85 d2                	test   %edx,%edx
  801de0:	0f 88 4d 01 00 00    	js     801f33 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ded:	00 
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dfc:	e8 b8 ef ff ff       	call   800db9 <sys_page_alloc>
  801e01:	89 c2                	mov    %eax,%edx
  801e03:	85 d2                	test   %edx,%edx
  801e05:	0f 88 28 01 00 00    	js     801f33 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 91 f5 ff ff       	call   8013a7 <fd_alloc>
  801e16:	89 c3                	mov    %eax,%ebx
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	0f 88 fe 00 00 00    	js     801f1e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e20:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e27:	00 
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e36:	e8 7e ef ff ff       	call   800db9 <sys_page_alloc>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	0f 88 d9 00 00 00    	js     801f1e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	89 04 24             	mov    %eax,(%esp)
  801e4b:	e8 40 f5 ff ff       	call   801390 <fd2data>
  801e50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e59:	00 
  801e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e65:	e8 4f ef ff ff       	call   800db9 <sys_page_alloc>
  801e6a:	89 c3                	mov    %eax,%ebx
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 88 97 00 00 00    	js     801f0b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e77:	89 04 24             	mov    %eax,(%esp)
  801e7a:	e8 11 f5 ff ff       	call   801390 <fd2data>
  801e7f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801e86:	00 
  801e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e92:	00 
  801e93:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9e:	e8 6a ef ff ff       	call   800e0d <sys_page_map>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 52                	js     801efb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ea9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ebe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	89 04 24             	mov    %eax,(%esp)
  801ed9:	e8 a2 f4 ff ff       	call   801380 <fd2num>
  801ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee6:	89 04 24             	mov    %eax,(%esp)
  801ee9:	e8 92 f4 ff ff       	call   801380 <fd2num>
  801eee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef9:	eb 38                	jmp    801f33 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801efb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f06:	e8 55 ef ff ff       	call   800e60 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f19:	e8 42 ef ff ff       	call   800e60 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f2c:	e8 2f ef ff ff       	call   800e60 <sys_page_unmap>
  801f31:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801f33:	83 c4 30             	add    $0x30,%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	89 04 24             	mov    %eax,(%esp)
  801f4d:	e8 c9 f4 ff ff       	call   80141b <fd_lookup>
  801f52:	89 c2                	mov    %eax,%edx
  801f54:	85 d2                	test   %edx,%edx
  801f56:	78 15                	js     801f6d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	89 04 24             	mov    %eax,(%esp)
  801f5e:	e8 2d f4 ff ff       	call   801390 <fd2data>
	return _pipeisclosed(fd, p);
  801f63:	89 c2                	mov    %eax,%edx
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	e8 de fc ff ff       	call   801c4b <_pipeisclosed>
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    
  801f6f:	90                   	nop

00801f70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    

00801f7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801f80:	c7 44 24 04 88 2b 80 	movl   $0x802b88,0x4(%esp)
  801f87:	00 
  801f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8b:	89 04 24             	mov    %eax,(%esp)
  801f8e:	e8 78 e9 ff ff       	call   80090b <strcpy>
	return 0;
}
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	57                   	push   %edi
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801faa:	74 4a                	je     801ff6 <devcons_write+0x5c>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fbc:	8b 75 10             	mov    0x10(%ebp),%esi
  801fbf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801fc1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fc4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801fc9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fcc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801fd0:	03 45 0c             	add    0xc(%ebp),%eax
  801fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd7:	89 3c 24             	mov    %edi,(%esp)
  801fda:	e8 27 eb ff ff       	call   800b06 <memmove>
		sys_cputs(buf, m);
  801fdf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe3:	89 3c 24             	mov    %edi,(%esp)
  801fe6:	e8 01 ed ff ff       	call   800cec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801feb:	01 f3                	add    %esi,%ebx
  801fed:	89 d8                	mov    %ebx,%eax
  801fef:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ff2:	72 c8                	jb     801fbc <devcons_write+0x22>
  801ff4:	eb 05                	jmp    801ffb <devcons_write+0x61>
  801ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801ffb:	89 d8                	mov    %ebx,%eax
  801ffd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802003:	5b                   	pop    %ebx
  802004:	5e                   	pop    %esi
  802005:	5f                   	pop    %edi
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    

00802008 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802017:	75 07                	jne    802020 <devcons_read+0x18>
  802019:	eb 28                	jmp    802043 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80201b:	e8 7a ed ff ff       	call   800d9a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802020:	e8 e5 ec ff ff       	call   800d0a <sys_cgetc>
  802025:	85 c0                	test   %eax,%eax
  802027:	74 f2                	je     80201b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 16                	js     802043 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80202d:	83 f8 04             	cmp    $0x4,%eax
  802030:	74 0c                	je     80203e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	88 02                	mov    %al,(%edx)
	return 1;
  802037:	b8 01 00 00 00       	mov    $0x1,%eax
  80203c:	eb 05                	jmp    802043 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802051:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802058:	00 
  802059:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205c:	89 04 24             	mov    %eax,(%esp)
  80205f:	e8 88 ec ff ff       	call   800cec <sys_cputs>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <getchar>:

int
getchar(void)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80206c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802073:	00 
  802074:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802082:	e8 3f f6 ff ff       	call   8016c6 <read>
	if (r < 0)
  802087:	85 c0                	test   %eax,%eax
  802089:	78 0f                	js     80209a <getchar+0x34>
		return r;
	if (r < 1)
  80208b:	85 c0                	test   %eax,%eax
  80208d:	7e 06                	jle    802095 <getchar+0x2f>
		return -E_EOF;
	return c;
  80208f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802093:	eb 05                	jmp    80209a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802095:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	89 04 24             	mov    %eax,(%esp)
  8020af:	e8 67 f3 ff ff       	call   80141b <fd_lookup>
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 11                	js     8020c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c1:	39 10                	cmp    %edx,(%eax)
  8020c3:	0f 94 c0             	sete   %al
  8020c6:	0f b6 c0             	movzbl %al,%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <opencons>:

int
opencons(void)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d4:	89 04 24             	mov    %eax,(%esp)
  8020d7:	e8 cb f2 ff ff       	call   8013a7 <fd_alloc>
		return r;
  8020dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 40                	js     802122 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020e9:	00 
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f8:	e8 bc ec ff ff       	call   800db9 <sys_page_alloc>
		return r;
  8020fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ff:	85 c0                	test   %eax,%eax
  802101:	78 1f                	js     802122 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802103:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802118:	89 04 24             	mov    %eax,(%esp)
  80211b:	e8 60 f2 ff ff       	call   801380 <fd2num>
  802120:	89 c2                	mov    %eax,%edx
}
  802122:	89 d0                	mov    %edx,%eax
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80212c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802133:	75 50                	jne    802185 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802135:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80213c:	00 
  80213d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802144:	ee 
  802145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80214c:	e8 68 ec ff ff       	call   800db9 <sys_page_alloc>
  802151:	85 c0                	test   %eax,%eax
  802153:	79 1c                	jns    802171 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802155:	c7 44 24 08 94 2b 80 	movl   $0x802b94,0x8(%esp)
  80215c:	00 
  80215d:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802164:	00 
  802165:	c7 04 24 b8 2b 80 00 	movl   $0x802bb8,(%esp)
  80216c:	e8 43 e0 ff ff       	call   8001b4 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802171:	c7 44 24 04 8f 21 80 	movl   $0x80218f,0x4(%esp)
  802178:	00 
  802179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802180:	e8 d4 ed ff ff       	call   800f59 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80218f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802190:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802195:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802197:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80219a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80219c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8021a1:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8021a4:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8021a9:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8021ac:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8021ae:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8021b1:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8021b3:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8021b5:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8021ba:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8021bd:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8021c2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8021c5:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8021c7:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8021cc:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8021cf:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8021d4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8021d7:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8021d9:	83 c4 08             	add    $0x8,%esp
	popal
  8021dc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8021dd:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021de:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8021df:	c3                   	ret    

008021e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	56                   	push   %esi
  8021e4:	53                   	push   %ebx
  8021e5:	83 ec 10             	sub    $0x10,%esp
  8021e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f8:	0f 44 c2             	cmove  %edx,%eax
  8021fb:	89 04 24             	mov    %eax,(%esp)
  8021fe:	e8 cc ed ff ff       	call   800fcf <sys_ipc_recv>
	if (err_code < 0) {
  802203:	85 c0                	test   %eax,%eax
  802205:	79 16                	jns    80221d <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802207:	85 f6                	test   %esi,%esi
  802209:	74 06                	je     802211 <ipc_recv+0x31>
  80220b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802211:	85 db                	test   %ebx,%ebx
  802213:	74 2c                	je     802241 <ipc_recv+0x61>
  802215:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80221b:	eb 24                	jmp    802241 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80221d:	85 f6                	test   %esi,%esi
  80221f:	74 0a                	je     80222b <ipc_recv+0x4b>
  802221:	a1 08 40 80 00       	mov    0x804008,%eax
  802226:	8b 40 74             	mov    0x74(%eax),%eax
  802229:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80222b:	85 db                	test   %ebx,%ebx
  80222d:	74 0a                	je     802239 <ipc_recv+0x59>
  80222f:	a1 08 40 80 00       	mov    0x804008,%eax
  802234:	8b 40 78             	mov    0x78(%eax),%eax
  802237:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802239:	a1 08 40 80 00       	mov    0x804008,%eax
  80223e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5d                   	pop    %ebp
  802247:	c3                   	ret    

00802248 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	57                   	push   %edi
  80224c:	56                   	push   %esi
  80224d:	53                   	push   %ebx
  80224e:	83 ec 1c             	sub    $0x1c,%esp
  802251:	8b 7d 08             	mov    0x8(%ebp),%edi
  802254:	8b 75 0c             	mov    0xc(%ebp),%esi
  802257:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80225a:	eb 25                	jmp    802281 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  80225c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80225f:	74 20                	je     802281 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802265:	c7 44 24 08 c6 2b 80 	movl   $0x802bc6,0x8(%esp)
  80226c:	00 
  80226d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802274:	00 
  802275:	c7 04 24 d2 2b 80 00 	movl   $0x802bd2,(%esp)
  80227c:	e8 33 df ff ff       	call   8001b4 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802281:	85 db                	test   %ebx,%ebx
  802283:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802288:	0f 45 c3             	cmovne %ebx,%eax
  80228b:	8b 55 14             	mov    0x14(%ebp),%edx
  80228e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802292:	89 44 24 08          	mov    %eax,0x8(%esp)
  802296:	89 74 24 04          	mov    %esi,0x4(%esp)
  80229a:	89 3c 24             	mov    %edi,(%esp)
  80229d:	e8 0a ed ff ff       	call   800fac <sys_ipc_try_send>
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	75 b6                	jne    80225c <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8022a6:	83 c4 1c             	add    $0x1c,%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5f                   	pop    %edi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8022b4:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8022b9:	39 c8                	cmp    %ecx,%eax
  8022bb:	74 17                	je     8022d4 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022bd:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8022c2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022cb:	8b 52 50             	mov    0x50(%edx),%edx
  8022ce:	39 ca                	cmp    %ecx,%edx
  8022d0:	75 14                	jne    8022e6 <ipc_find_env+0x38>
  8022d2:	eb 05                	jmp    8022d9 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8022d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022dc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8022e1:	8b 40 40             	mov    0x40(%eax),%eax
  8022e4:	eb 0e                	jmp    8022f4 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022e6:	83 c0 01             	add    $0x1,%eax
  8022e9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ee:	75 d2                	jne    8022c2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8022f0:	66 b8 00 00          	mov    $0x0,%ax
}
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022fc:	89 d0                	mov    %edx,%eax
  8022fe:	c1 e8 16             	shr    $0x16,%eax
  802301:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802308:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80230d:	f6 c1 01             	test   $0x1,%cl
  802310:	74 1d                	je     80232f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802312:	c1 ea 0c             	shr    $0xc,%edx
  802315:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80231c:	f6 c2 01             	test   $0x1,%dl
  80231f:	74 0e                	je     80232f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802321:	c1 ea 0c             	shr    $0xc,%edx
  802324:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80232b:	ef 
  80232c:	0f b7 c0             	movzwl %ax,%eax
}
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	66 90                	xchg   %ax,%ax
  802333:	66 90                	xchg   %ax,%ax
  802335:	66 90                	xchg   %ax,%ax
  802337:	66 90                	xchg   %ax,%ax
  802339:	66 90                	xchg   %ax,%ax
  80233b:	66 90                	xchg   %ax,%ax
  80233d:	66 90                	xchg   %ax,%ax
  80233f:	90                   	nop

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	8b 44 24 28          	mov    0x28(%esp),%eax
  80234a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80234e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802352:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802356:	85 c0                	test   %eax,%eax
  802358:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80235c:	89 ea                	mov    %ebp,%edx
  80235e:	89 0c 24             	mov    %ecx,(%esp)
  802361:	75 2d                	jne    802390 <__udivdi3+0x50>
  802363:	39 e9                	cmp    %ebp,%ecx
  802365:	77 61                	ja     8023c8 <__udivdi3+0x88>
  802367:	85 c9                	test   %ecx,%ecx
  802369:	89 ce                	mov    %ecx,%esi
  80236b:	75 0b                	jne    802378 <__udivdi3+0x38>
  80236d:	b8 01 00 00 00       	mov    $0x1,%eax
  802372:	31 d2                	xor    %edx,%edx
  802374:	f7 f1                	div    %ecx
  802376:	89 c6                	mov    %eax,%esi
  802378:	31 d2                	xor    %edx,%edx
  80237a:	89 e8                	mov    %ebp,%eax
  80237c:	f7 f6                	div    %esi
  80237e:	89 c5                	mov    %eax,%ebp
  802380:	89 f8                	mov    %edi,%eax
  802382:	f7 f6                	div    %esi
  802384:	89 ea                	mov    %ebp,%edx
  802386:	83 c4 0c             	add    $0xc,%esp
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	39 e8                	cmp    %ebp,%eax
  802392:	77 24                	ja     8023b8 <__udivdi3+0x78>
  802394:	0f bd e8             	bsr    %eax,%ebp
  802397:	83 f5 1f             	xor    $0x1f,%ebp
  80239a:	75 3c                	jne    8023d8 <__udivdi3+0x98>
  80239c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8023a0:	39 34 24             	cmp    %esi,(%esp)
  8023a3:	0f 86 9f 00 00 00    	jbe    802448 <__udivdi3+0x108>
  8023a9:	39 d0                	cmp    %edx,%eax
  8023ab:	0f 82 97 00 00 00    	jb     802448 <__udivdi3+0x108>
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	31 d2                	xor    %edx,%edx
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	83 c4 0c             	add    $0xc,%esp
  8023bf:	5e                   	pop    %esi
  8023c0:	5f                   	pop    %edi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
  8023c3:	90                   	nop
  8023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 f8                	mov    %edi,%eax
  8023ca:	f7 f1                	div    %ecx
  8023cc:	31 d2                	xor    %edx,%edx
  8023ce:	83 c4 0c             	add    $0xc,%esp
  8023d1:	5e                   	pop    %esi
  8023d2:	5f                   	pop    %edi
  8023d3:	5d                   	pop    %ebp
  8023d4:	c3                   	ret    
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	8b 3c 24             	mov    (%esp),%edi
  8023dd:	d3 e0                	shl    %cl,%eax
  8023df:	89 c6                	mov    %eax,%esi
  8023e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e6:	29 e8                	sub    %ebp,%eax
  8023e8:	89 c1                	mov    %eax,%ecx
  8023ea:	d3 ef                	shr    %cl,%edi
  8023ec:	89 e9                	mov    %ebp,%ecx
  8023ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023f2:	8b 3c 24             	mov    (%esp),%edi
  8023f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8023f9:	89 d6                	mov    %edx,%esi
  8023fb:	d3 e7                	shl    %cl,%edi
  8023fd:	89 c1                	mov    %eax,%ecx
  8023ff:	89 3c 24             	mov    %edi,(%esp)
  802402:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802406:	d3 ee                	shr    %cl,%esi
  802408:	89 e9                	mov    %ebp,%ecx
  80240a:	d3 e2                	shl    %cl,%edx
  80240c:	89 c1                	mov    %eax,%ecx
  80240e:	d3 ef                	shr    %cl,%edi
  802410:	09 d7                	or     %edx,%edi
  802412:	89 f2                	mov    %esi,%edx
  802414:	89 f8                	mov    %edi,%eax
  802416:	f7 74 24 08          	divl   0x8(%esp)
  80241a:	89 d6                	mov    %edx,%esi
  80241c:	89 c7                	mov    %eax,%edi
  80241e:	f7 24 24             	mull   (%esp)
  802421:	39 d6                	cmp    %edx,%esi
  802423:	89 14 24             	mov    %edx,(%esp)
  802426:	72 30                	jb     802458 <__udivdi3+0x118>
  802428:	8b 54 24 04          	mov    0x4(%esp),%edx
  80242c:	89 e9                	mov    %ebp,%ecx
  80242e:	d3 e2                	shl    %cl,%edx
  802430:	39 c2                	cmp    %eax,%edx
  802432:	73 05                	jae    802439 <__udivdi3+0xf9>
  802434:	3b 34 24             	cmp    (%esp),%esi
  802437:	74 1f                	je     802458 <__udivdi3+0x118>
  802439:	89 f8                	mov    %edi,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	e9 7a ff ff ff       	jmp    8023bc <__udivdi3+0x7c>
  802442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	e9 68 ff ff ff       	jmp    8023bc <__udivdi3+0x7c>
  802454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802458:	8d 47 ff             	lea    -0x1(%edi),%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	83 c4 0c             	add    $0xc,%esp
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	66 90                	xchg   %ax,%ax
  802466:	66 90                	xchg   %ax,%ax
  802468:	66 90                	xchg   %ax,%ax
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__umoddi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	83 ec 14             	sub    $0x14,%esp
  802476:	8b 44 24 28          	mov    0x28(%esp),%eax
  80247a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80247e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802482:	89 c7                	mov    %eax,%edi
  802484:	89 44 24 04          	mov    %eax,0x4(%esp)
  802488:	8b 44 24 30          	mov    0x30(%esp),%eax
  80248c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802490:	89 34 24             	mov    %esi,(%esp)
  802493:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802497:	85 c0                	test   %eax,%eax
  802499:	89 c2                	mov    %eax,%edx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	75 17                	jne    8024b8 <__umoddi3+0x48>
  8024a1:	39 fe                	cmp    %edi,%esi
  8024a3:	76 4b                	jbe    8024f0 <__umoddi3+0x80>
  8024a5:	89 c8                	mov    %ecx,%eax
  8024a7:	89 fa                	mov    %edi,%edx
  8024a9:	f7 f6                	div    %esi
  8024ab:	89 d0                	mov    %edx,%eax
  8024ad:	31 d2                	xor    %edx,%edx
  8024af:	83 c4 14             	add    $0x14,%esp
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	39 f8                	cmp    %edi,%eax
  8024ba:	77 54                	ja     802510 <__umoddi3+0xa0>
  8024bc:	0f bd e8             	bsr    %eax,%ebp
  8024bf:	83 f5 1f             	xor    $0x1f,%ebp
  8024c2:	75 5c                	jne    802520 <__umoddi3+0xb0>
  8024c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024c8:	39 3c 24             	cmp    %edi,(%esp)
  8024cb:	0f 87 e7 00 00 00    	ja     8025b8 <__umoddi3+0x148>
  8024d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024d5:	29 f1                	sub    %esi,%ecx
  8024d7:	19 c7                	sbb    %eax,%edi
  8024d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024e9:	83 c4 14             	add    $0x14,%esp
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	85 f6                	test   %esi,%esi
  8024f2:	89 f5                	mov    %esi,%ebp
  8024f4:	75 0b                	jne    802501 <__umoddi3+0x91>
  8024f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	f7 f6                	div    %esi
  8024ff:	89 c5                	mov    %eax,%ebp
  802501:	8b 44 24 04          	mov    0x4(%esp),%eax
  802505:	31 d2                	xor    %edx,%edx
  802507:	f7 f5                	div    %ebp
  802509:	89 c8                	mov    %ecx,%eax
  80250b:	f7 f5                	div    %ebp
  80250d:	eb 9c                	jmp    8024ab <__umoddi3+0x3b>
  80250f:	90                   	nop
  802510:	89 c8                	mov    %ecx,%eax
  802512:	89 fa                	mov    %edi,%edx
  802514:	83 c4 14             	add    $0x14,%esp
  802517:	5e                   	pop    %esi
  802518:	5f                   	pop    %edi
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    
  80251b:	90                   	nop
  80251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802520:	8b 04 24             	mov    (%esp),%eax
  802523:	be 20 00 00 00       	mov    $0x20,%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	29 ee                	sub    %ebp,%esi
  80252c:	d3 e2                	shl    %cl,%edx
  80252e:	89 f1                	mov    %esi,%ecx
  802530:	d3 e8                	shr    %cl,%eax
  802532:	89 e9                	mov    %ebp,%ecx
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	8b 04 24             	mov    (%esp),%eax
  80253b:	09 54 24 04          	or     %edx,0x4(%esp)
  80253f:	89 fa                	mov    %edi,%edx
  802541:	d3 e0                	shl    %cl,%eax
  802543:	89 f1                	mov    %esi,%ecx
  802545:	89 44 24 08          	mov    %eax,0x8(%esp)
  802549:	8b 44 24 10          	mov    0x10(%esp),%eax
  80254d:	d3 ea                	shr    %cl,%edx
  80254f:	89 e9                	mov    %ebp,%ecx
  802551:	d3 e7                	shl    %cl,%edi
  802553:	89 f1                	mov    %esi,%ecx
  802555:	d3 e8                	shr    %cl,%eax
  802557:	89 e9                	mov    %ebp,%ecx
  802559:	09 f8                	or     %edi,%eax
  80255b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80255f:	f7 74 24 04          	divl   0x4(%esp)
  802563:	d3 e7                	shl    %cl,%edi
  802565:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802569:	89 d7                	mov    %edx,%edi
  80256b:	f7 64 24 08          	mull   0x8(%esp)
  80256f:	39 d7                	cmp    %edx,%edi
  802571:	89 c1                	mov    %eax,%ecx
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 2c                	jb     8025a4 <__umoddi3+0x134>
  802578:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80257c:	72 22                	jb     8025a0 <__umoddi3+0x130>
  80257e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802582:	29 c8                	sub    %ecx,%eax
  802584:	19 d7                	sbb    %edx,%edi
  802586:	89 e9                	mov    %ebp,%ecx
  802588:	89 fa                	mov    %edi,%edx
  80258a:	d3 e8                	shr    %cl,%eax
  80258c:	89 f1                	mov    %esi,%ecx
  80258e:	d3 e2                	shl    %cl,%edx
  802590:	89 e9                	mov    %ebp,%ecx
  802592:	d3 ef                	shr    %cl,%edi
  802594:	09 d0                	or     %edx,%eax
  802596:	89 fa                	mov    %edi,%edx
  802598:	83 c4 14             	add    $0x14,%esp
  80259b:	5e                   	pop    %esi
  80259c:	5f                   	pop    %edi
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    
  80259f:	90                   	nop
  8025a0:	39 d7                	cmp    %edx,%edi
  8025a2:	75 da                	jne    80257e <__umoddi3+0x10e>
  8025a4:	8b 14 24             	mov    (%esp),%edx
  8025a7:	89 c1                	mov    %eax,%ecx
  8025a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8025ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025b1:	eb cb                	jmp    80257e <__umoddi3+0x10e>
  8025b3:	90                   	nop
  8025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025bc:	0f 82 0f ff ff ff    	jb     8024d1 <__umoddi3+0x61>
  8025c2:	e9 1a ff ff ff       	jmp    8024e1 <__umoddi3+0x71>
