
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 17 01 00 00       	call   800148 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800046:	00 
  800047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004e:	00 
  80004f:	89 34 24             	mov    %esi,(%esp)
  800052:	e8 35 13 00 00       	call   80138c <ipc_recv>
  800057:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800059:	a1 04 40 80 00       	mov    0x804004,%eax
  80005e:	8b 40 5c             	mov    0x5c(%eax),%eax
  800061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	c7 04 24 20 26 80 00 	movl   $0x802620,(%esp)
  800070:	e8 5d 02 00 00       	call   8002d2 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800075:	e8 b6 10 00 00       	call   801130 <fork>
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	85 c0                	test   %eax,%eax
  80007e:	79 20                	jns    8000a0 <primeproc+0x6d>
		panic("fork: %e", id);
  800080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800084:	c7 44 24 08 2c 26 80 	movl   $0x80262c,0x8(%esp)
  80008b:	00 
  80008c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800093:	00 
  800094:	c7 04 24 35 26 80 00 	movl   $0x802635,(%esp)
  80009b:	e8 39 01 00 00       	call   8001d9 <_panic>
	if (id == 0)
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	74 9b                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	89 34 24             	mov    %esi,(%esp)
  8000ba:	e8 cd 12 00 00       	call   80138c <ipc_recv>
  8000bf:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c1:	99                   	cltd   
  8000c2:	f7 fb                	idiv   %ebx
  8000c4:	85 d2                	test   %edx,%edx
  8000c6:	74 df                	je     8000a7 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d7:	00 
  8000d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000dc:	89 3c 24             	mov    %edi,(%esp)
  8000df:	e8 10 13 00 00       	call   8013f4 <ipc_send>
  8000e4:	eb c1                	jmp    8000a7 <primeproc+0x74>

008000e6 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ee:	e8 3d 10 00 00       	call   801130 <fork>
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 20                	jns    800119 <umain+0x33>
		panic("fork: %e", id);
  8000f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fd:	c7 44 24 08 2c 26 80 	movl   $0x80262c,0x8(%esp)
  800104:	00 
  800105:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 35 26 80 00 	movl   $0x802635,(%esp)
  800114:	e8 c0 00 00 00       	call   8001d9 <_panic>
	if (id == 0)
  800119:	bb 02 00 00 00       	mov    $0x2,%ebx
  80011e:	85 c0                	test   %eax,%eax
  800120:	75 05                	jne    800127 <umain+0x41>
		primeproc();
  800122:	e8 0c ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800136:	00 
  800137:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013b:	89 34 24             	mov    %esi,(%esp)
  80013e:	e8 b1 12 00 00       	call   8013f4 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	eb df                	jmp    800127 <umain+0x41>

00800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 10             	sub    $0x10,%esp
  800150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800153:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800156:	e8 40 0c 00 00       	call   800d9b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80015b:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800161:	39 c2                	cmp    %eax,%edx
  800163:	74 17                	je     80017c <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800165:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80016a:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80016d:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800173:	8b 49 40             	mov    0x40(%ecx),%ecx
  800176:	39 c1                	cmp    %eax,%ecx
  800178:	75 18                	jne    800192 <libmain+0x4a>
  80017a:	eb 05                	jmp    800181 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80017c:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800181:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800184:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80018a:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800190:	eb 0b                	jmp    80019d <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800192:	83 c2 01             	add    $0x1,%edx
  800195:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80019b:	75 cd                	jne    80016a <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	85 db                	test   %ebx,%ebx
  80019f:	7e 07                	jle    8001a8 <libmain+0x60>
		binaryname = argv[0];
  8001a1:	8b 06                	mov    (%esi),%eax
  8001a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001ac:	89 1c 24             	mov    %ebx,(%esp)
  8001af:	e8 32 ff ff ff       	call   8000e6 <umain>

	// exit gracefully
	exit();
  8001b4:	e8 07 00 00 00       	call   8001c0 <exit>
}
  8001b9:	83 c4 10             	add    $0x10,%esp
  8001bc:	5b                   	pop    %ebx
  8001bd:	5e                   	pop    %esi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    

008001c0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001c6:	e8 fb 14 00 00       	call   8016c6 <close_all>
	sys_env_destroy(0);
  8001cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001d2:	e8 72 0b 00 00       	call   800d49 <sys_env_destroy>
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001e1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001ea:	e8 ac 0b 00 00       	call   800d9b <sys_getenvid>
  8001ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001fd:	89 74 24 08          	mov    %esi,0x8(%esp)
  800201:	89 44 24 04          	mov    %eax,0x4(%esp)
  800205:	c7 04 24 50 26 80 00 	movl   $0x802650,(%esp)
  80020c:	e8 c1 00 00 00       	call   8002d2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800211:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800215:	8b 45 10             	mov    0x10(%ebp),%eax
  800218:	89 04 24             	mov    %eax,(%esp)
  80021b:	e8 51 00 00 00       	call   800271 <vcprintf>
	cprintf("\n");
  800220:	c7 04 24 d9 2b 80 00 	movl   $0x802bd9,(%esp)
  800227:	e8 a6 00 00 00       	call   8002d2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80022c:	cc                   	int3   
  80022d:	eb fd                	jmp    80022c <_panic+0x53>

0080022f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	53                   	push   %ebx
  800233:	83 ec 14             	sub    $0x14,%esp
  800236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800239:	8b 13                	mov    (%ebx),%edx
  80023b:	8d 42 01             	lea    0x1(%edx),%eax
  80023e:	89 03                	mov    %eax,(%ebx)
  800240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800243:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800247:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024c:	75 19                	jne    800267 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80024e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800255:	00 
  800256:	8d 43 08             	lea    0x8(%ebx),%eax
  800259:	89 04 24             	mov    %eax,(%esp)
  80025c:	e8 ab 0a 00 00       	call   800d0c <sys_cputs>
		b->idx = 0;
  800261:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800267:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026b:	83 c4 14             	add    $0x14,%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    

00800271 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80027a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800281:	00 00 00 
	b.cnt = 0;
  800284:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800295:	8b 45 08             	mov    0x8(%ebp),%eax
  800298:	89 44 24 08          	mov    %eax,0x8(%esp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a6:	c7 04 24 2f 02 80 00 	movl   $0x80022f,(%esp)
  8002ad:	e8 b2 01 00 00       	call   800464 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	e8 42 0a 00 00       	call   800d0c <sys_cputs>

	return b.cnt;
}
  8002ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	89 04 24             	mov    %eax,(%esp)
  8002e5:	e8 87 ff ff ff       	call   800271 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    
  8002ec:	66 90                	xchg   %ax,%ax
  8002ee:	66 90                	xchg   %ax,%ax

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 3c             	sub    $0x3c,%esp
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	89 d7                	mov    %edx,%edi
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800304:	8b 75 0c             	mov    0xc(%ebp),%esi
  800307:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80030a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800312:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800315:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800318:	39 f1                	cmp    %esi,%ecx
  80031a:	72 14                	jb     800330 <printnum+0x40>
  80031c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80031f:	76 0f                	jbe    800330 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800321:	8b 45 14             	mov    0x14(%ebp),%eax
  800324:	8d 70 ff             	lea    -0x1(%eax),%esi
  800327:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80032a:	85 f6                	test   %esi,%esi
  80032c:	7f 60                	jg     80038e <printnum+0x9e>
  80032e:	eb 72                	jmp    8003a2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800330:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800333:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800337:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80033a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80033d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800341:	89 44 24 08          	mov    %eax,0x8(%esp)
  800345:	8b 44 24 08          	mov    0x8(%esp),%eax
  800349:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80034d:	89 c3                	mov    %eax,%ebx
  80034f:	89 d6                	mov    %edx,%esi
  800351:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800354:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800357:	89 54 24 08          	mov    %edx,0x8(%esp)
  80035b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80035f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800362:	89 04 24             	mov    %eax,(%esp)
  800365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036c:	e8 0f 20 00 00       	call   802380 <__udivdi3>
  800371:	89 d9                	mov    %ebx,%ecx
  800373:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800377:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80037b:	89 04 24             	mov    %eax,(%esp)
  80037e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800382:	89 fa                	mov    %edi,%edx
  800384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800387:	e8 64 ff ff ff       	call   8002f0 <printnum>
  80038c:	eb 14                	jmp    8003a2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800392:	8b 45 18             	mov    0x18(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039a:	83 ee 01             	sub    $0x1,%esi
  80039d:	75 ef                	jne    80038e <printnum+0x9e>
  80039f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c5:	e8 e6 20 00 00       	call   8024b0 <__umoddi3>
  8003ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ce:	0f be 80 73 26 80 00 	movsbl 0x802673(%eax),%eax
  8003d5:	89 04 24             	mov    %eax,(%esp)
  8003d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003db:	ff d0                	call   *%eax
}
  8003dd:	83 c4 3c             	add    $0x3c,%esp
  8003e0:	5b                   	pop    %ebx
  8003e1:	5e                   	pop    %esi
  8003e2:	5f                   	pop    %edi
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e8:	83 fa 01             	cmp    $0x1,%edx
  8003eb:	7e 0e                	jle    8003fb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003f2:	89 08                	mov    %ecx,(%eax)
  8003f4:	8b 02                	mov    (%edx),%eax
  8003f6:	8b 52 04             	mov    0x4(%edx),%edx
  8003f9:	eb 22                	jmp    80041d <getuint+0x38>
	else if (lflag)
  8003fb:	85 d2                	test   %edx,%edx
  8003fd:	74 10                	je     80040f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8d 4a 04             	lea    0x4(%edx),%ecx
  800404:	89 08                	mov    %ecx,(%eax)
  800406:	8b 02                	mov    (%edx),%eax
  800408:	ba 00 00 00 00       	mov    $0x0,%edx
  80040d:	eb 0e                	jmp    80041d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80040f:	8b 10                	mov    (%eax),%edx
  800411:	8d 4a 04             	lea    0x4(%edx),%ecx
  800414:	89 08                	mov    %ecx,(%eax)
  800416:	8b 02                	mov    (%edx),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800425:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800429:	8b 10                	mov    (%eax),%edx
  80042b:	3b 50 04             	cmp    0x4(%eax),%edx
  80042e:	73 0a                	jae    80043a <sprintputch+0x1b>
		*b->buf++ = ch;
  800430:	8d 4a 01             	lea    0x1(%edx),%ecx
  800433:	89 08                	mov    %ecx,(%eax)
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	88 02                	mov    %al,(%edx)
}
  80043a:	5d                   	pop    %ebp
  80043b:	c3                   	ret    

0080043c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
  80043f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800442:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800445:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800449:	8b 45 10             	mov    0x10(%ebp),%eax
  80044c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
  800453:	89 44 24 04          	mov    %eax,0x4(%esp)
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	e8 02 00 00 00       	call   800464 <vprintfmt>
	va_end(ap);
}
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	57                   	push   %edi
  800468:	56                   	push   %esi
  800469:	53                   	push   %ebx
  80046a:	83 ec 3c             	sub    $0x3c,%esp
  80046d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800470:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800473:	eb 18                	jmp    80048d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800475:	85 c0                	test   %eax,%eax
  800477:	0f 84 c3 03 00 00    	je     800840 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80047d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800481:	89 04 24             	mov    %eax,(%esp)
  800484:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800487:	89 f3                	mov    %esi,%ebx
  800489:	eb 02                	jmp    80048d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80048b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80048d:	8d 73 01             	lea    0x1(%ebx),%esi
  800490:	0f b6 03             	movzbl (%ebx),%eax
  800493:	83 f8 25             	cmp    $0x25,%eax
  800496:	75 dd                	jne    800475 <vprintfmt+0x11>
  800498:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80049c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004a3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b6:	eb 1d                	jmp    8004d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ba:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8004be:	eb 15                	jmp    8004d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8004c6:	eb 0d                	jmp    8004d5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ce:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004d8:	0f b6 06             	movzbl (%esi),%eax
  8004db:	0f b6 c8             	movzbl %al,%ecx
  8004de:	83 e8 23             	sub    $0x23,%eax
  8004e1:	3c 55                	cmp    $0x55,%al
  8004e3:	0f 87 2f 03 00 00    	ja     800818 <vprintfmt+0x3b4>
  8004e9:	0f b6 c0             	movzbl %al,%eax
  8004ec:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004f3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8004f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8004f9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004fd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800500:	83 f9 09             	cmp    $0x9,%ecx
  800503:	77 50                	ja     800555 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800505:	89 de                	mov    %ebx,%esi
  800507:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80050d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800510:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800514:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800517:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80051a:	83 fb 09             	cmp    $0x9,%ebx
  80051d:	76 eb                	jbe    80050a <vprintfmt+0xa6>
  80051f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800522:	eb 33                	jmp    800557 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 48 04             	lea    0x4(%eax),%ecx
  80052a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800534:	eb 21                	jmp    800557 <vprintfmt+0xf3>
  800536:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800539:	85 c9                	test   %ecx,%ecx
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	0f 49 c1             	cmovns %ecx,%eax
  800543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800546:	89 de                	mov    %ebx,%esi
  800548:	eb 8b                	jmp    8004d5 <vprintfmt+0x71>
  80054a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80054c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800553:	eb 80                	jmp    8004d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800555:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055b:	0f 89 74 ff ff ff    	jns    8004d5 <vprintfmt+0x71>
  800561:	e9 62 ff ff ff       	jmp    8004c8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800566:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800569:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80056b:	e9 65 ff ff ff       	jmp    8004d5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 50 04             	lea    0x4(%eax),%edx
  800576:	89 55 14             	mov    %edx,0x14(%ebp)
  800579:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff 55 08             	call   *0x8(%ebp)
			break;
  800585:	e9 03 ff ff ff       	jmp    80048d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 50 04             	lea    0x4(%eax),%edx
  800590:	89 55 14             	mov    %edx,0x14(%ebp)
  800593:	8b 00                	mov    (%eax),%eax
  800595:	99                   	cltd   
  800596:	31 d0                	xor    %edx,%eax
  800598:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80059a:	83 f8 0f             	cmp    $0xf,%eax
  80059d:	7f 0b                	jg     8005aa <vprintfmt+0x146>
  80059f:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  8005a6:	85 d2                	test   %edx,%edx
  8005a8:	75 20                	jne    8005ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8005aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ae:	c7 44 24 08 8b 26 80 	movl   $0x80268b,0x8(%esp)
  8005b5:	00 
  8005b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	89 04 24             	mov    %eax,(%esp)
  8005c0:	e8 77 fe ff ff       	call   80043c <printfmt>
  8005c5:	e9 c3 fe ff ff       	jmp    80048d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ce:	c7 44 24 08 a7 2b 80 	movl   $0x802ba7,0x8(%esp)
  8005d5:	00 
  8005d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	89 04 24             	mov    %eax,(%esp)
  8005e0:	e8 57 fe ff ff       	call   80043c <printfmt>
  8005e5:	e9 a3 fe ff ff       	jmp    80048d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ed:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 50 04             	lea    0x4(%eax),%edx
  8005f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8005fb:	85 c0                	test   %eax,%eax
  8005fd:	ba 84 26 80 00       	mov    $0x802684,%edx
  800602:	0f 45 d0             	cmovne %eax,%edx
  800605:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800608:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80060c:	74 04                	je     800612 <vprintfmt+0x1ae>
  80060e:	85 f6                	test   %esi,%esi
  800610:	7f 19                	jg     80062b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800612:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800615:	8d 70 01             	lea    0x1(%eax),%esi
  800618:	0f b6 10             	movzbl (%eax),%edx
  80061b:	0f be c2             	movsbl %dl,%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	0f 85 95 00 00 00    	jne    8006bb <vprintfmt+0x257>
  800626:	e9 85 00 00 00       	jmp    8006b0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80062b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80062f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800632:	89 04 24             	mov    %eax,(%esp)
  800635:	e8 b8 02 00 00       	call   8008f2 <strnlen>
  80063a:	29 c6                	sub    %eax,%esi
  80063c:	89 f0                	mov    %esi,%eax
  80063e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800641:	85 f6                	test   %esi,%esi
  800643:	7e cd                	jle    800612 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800645:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800649:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80064c:	89 c3                	mov    %eax,%ebx
  80064e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800652:	89 34 24             	mov    %esi,(%esp)
  800655:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800658:	83 eb 01             	sub    $0x1,%ebx
  80065b:	75 f1                	jne    80064e <vprintfmt+0x1ea>
  80065d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800660:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800663:	eb ad                	jmp    800612 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800665:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800669:	74 1e                	je     800689 <vprintfmt+0x225>
  80066b:	0f be d2             	movsbl %dl,%edx
  80066e:	83 ea 20             	sub    $0x20,%edx
  800671:	83 fa 5e             	cmp    $0x5e,%edx
  800674:	76 13                	jbe    800689 <vprintfmt+0x225>
					putch('?', putdat);
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80067d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800684:	ff 55 08             	call   *0x8(%ebp)
  800687:	eb 0d                	jmp    800696 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800696:	83 ef 01             	sub    $0x1,%edi
  800699:	83 c6 01             	add    $0x1,%esi
  80069c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006a0:	0f be c2             	movsbl %dl,%eax
  8006a3:	85 c0                	test   %eax,%eax
  8006a5:	75 20                	jne    8006c7 <vprintfmt+0x263>
  8006a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b4:	7f 25                	jg     8006db <vprintfmt+0x277>
  8006b6:	e9 d2 fd ff ff       	jmp    80048d <vprintfmt+0x29>
  8006bb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006c4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c7:	85 db                	test   %ebx,%ebx
  8006c9:	78 9a                	js     800665 <vprintfmt+0x201>
  8006cb:	83 eb 01             	sub    $0x1,%ebx
  8006ce:	79 95                	jns    800665 <vprintfmt+0x201>
  8006d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006d9:	eb d5                	jmp    8006b0 <vprintfmt+0x24c>
  8006db:	8b 75 08             	mov    0x8(%ebp),%esi
  8006de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ef:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f1:	83 eb 01             	sub    $0x1,%ebx
  8006f4:	75 ee                	jne    8006e4 <vprintfmt+0x280>
  8006f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006f9:	e9 8f fd ff ff       	jmp    80048d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006fe:	83 fa 01             	cmp    $0x1,%edx
  800701:	7e 16                	jle    800719 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 50 08             	lea    0x8(%eax),%edx
  800709:	89 55 14             	mov    %edx,0x14(%ebp)
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	eb 32                	jmp    80074b <vprintfmt+0x2e7>
	else if (lflag)
  800719:	85 d2                	test   %edx,%edx
  80071b:	74 18                	je     800735 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 50 04             	lea    0x4(%eax),%edx
  800723:	89 55 14             	mov    %edx,0x14(%ebp)
  800726:	8b 30                	mov    (%eax),%esi
  800728:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80072b:	89 f0                	mov    %esi,%eax
  80072d:	c1 f8 1f             	sar    $0x1f,%eax
  800730:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800733:	eb 16                	jmp    80074b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 50 04             	lea    0x4(%eax),%edx
  80073b:	89 55 14             	mov    %edx,0x14(%ebp)
  80073e:	8b 30                	mov    (%eax),%esi
  800740:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800743:	89 f0                	mov    %esi,%eax
  800745:	c1 f8 1f             	sar    $0x1f,%eax
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80074b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80074e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800751:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800756:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80075a:	0f 89 80 00 00 00    	jns    8007e0 <vprintfmt+0x37c>
				putch('-', putdat);
  800760:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800764:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80076b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80076e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800771:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800774:	f7 d8                	neg    %eax
  800776:	83 d2 00             	adc    $0x0,%edx
  800779:	f7 da                	neg    %edx
			}
			base = 10;
  80077b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800780:	eb 5e                	jmp    8007e0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800782:	8d 45 14             	lea    0x14(%ebp),%eax
  800785:	e8 5b fc ff ff       	call   8003e5 <getuint>
			base = 10;
  80078a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80078f:	eb 4f                	jmp    8007e0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800791:	8d 45 14             	lea    0x14(%ebp),%eax
  800794:	e8 4c fc ff ff       	call   8003e5 <getuint>
			base = 8;
  800799:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80079e:	eb 40                	jmp    8007e0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ab:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007b9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 50 04             	lea    0x4(%eax),%edx
  8007c2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007cc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007d1:	eb 0d                	jmp    8007e0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	e8 0a fc ff ff       	call   8003e5 <getuint>
			base = 16;
  8007db:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007e0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007e4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007f3:	89 04 24             	mov    %eax,(%esp)
  8007f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007fa:	89 fa                	mov    %edi,%edx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	e8 ec fa ff ff       	call   8002f0 <printnum>
			break;
  800804:	e9 84 fc ff ff       	jmp    80048d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800809:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080d:	89 0c 24             	mov    %ecx,(%esp)
  800810:	ff 55 08             	call   *0x8(%ebp)
			break;
  800813:	e9 75 fc ff ff       	jmp    80048d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800818:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800823:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800826:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80082a:	0f 84 5b fc ff ff    	je     80048b <vprintfmt+0x27>
  800830:	89 f3                	mov    %esi,%ebx
  800832:	83 eb 01             	sub    $0x1,%ebx
  800835:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800839:	75 f7                	jne    800832 <vprintfmt+0x3ce>
  80083b:	e9 4d fc ff ff       	jmp    80048d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800840:	83 c4 3c             	add    $0x3c,%esp
  800843:	5b                   	pop    %ebx
  800844:	5e                   	pop    %esi
  800845:	5f                   	pop    %edi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 28             	sub    $0x28,%esp
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800857:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800865:	85 c0                	test   %eax,%eax
  800867:	74 30                	je     800899 <vsnprintf+0x51>
  800869:	85 d2                	test   %edx,%edx
  80086b:	7e 2c                	jle    800899 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80087e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800882:	c7 04 24 1f 04 80 00 	movl   $0x80041f,(%esp)
  800889:	e8 d6 fb ff ff       	call   800464 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800891:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800897:	eb 05                	jmp    80089e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	89 04 24             	mov    %eax,(%esp)
  8008c1:	e8 82 ff ff ff       	call   800848 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    
  8008c8:	66 90                	xchg   %ax,%ax
  8008ca:	66 90                	xchg   %ax,%ax
  8008cc:	66 90                	xchg   %ax,%ax
  8008ce:	66 90                	xchg   %ax,%ax

008008d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008d9:	74 10                	je     8008eb <strlen+0x1b>
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e7:	75 f7                	jne    8008e0 <strlen+0x10>
  8008e9:	eb 05                	jmp    8008f0 <strlen+0x20>
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fc:	85 c9                	test   %ecx,%ecx
  8008fe:	74 1c                	je     80091c <strnlen+0x2a>
  800900:	80 3b 00             	cmpb   $0x0,(%ebx)
  800903:	74 1e                	je     800923 <strnlen+0x31>
  800905:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80090a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090c:	39 ca                	cmp    %ecx,%edx
  80090e:	74 18                	je     800928 <strnlen+0x36>
  800910:	83 c2 01             	add    $0x1,%edx
  800913:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800918:	75 f0                	jne    80090a <strnlen+0x18>
  80091a:	eb 0c                	jmp    800928 <strnlen+0x36>
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb 05                	jmp    800928 <strnlen+0x36>
  800923:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800928:	5b                   	pop    %ebx
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800935:	89 c2                	mov    %eax,%edx
  800937:	83 c2 01             	add    $0x1,%edx
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800941:	88 5a ff             	mov    %bl,-0x1(%edx)
  800944:	84 db                	test   %bl,%bl
  800946:	75 ef                	jne    800937 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800955:	89 1c 24             	mov    %ebx,(%esp)
  800958:	e8 73 ff ff ff       	call   8008d0 <strlen>
	strcpy(dst + len, src);
  80095d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800960:	89 54 24 04          	mov    %edx,0x4(%esp)
  800964:	01 d8                	add    %ebx,%eax
  800966:	89 04 24             	mov    %eax,(%esp)
  800969:	e8 bd ff ff ff       	call   80092b <strcpy>
	return dst;
}
  80096e:	89 d8                	mov    %ebx,%eax
  800970:	83 c4 08             	add    $0x8,%esp
  800973:	5b                   	pop    %ebx
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800981:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800984:	85 db                	test   %ebx,%ebx
  800986:	74 17                	je     80099f <strncpy+0x29>
  800988:	01 f3                	add    %esi,%ebx
  80098a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80098c:	83 c1 01             	add    $0x1,%ecx
  80098f:	0f b6 02             	movzbl (%edx),%eax
  800992:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800995:	80 3a 01             	cmpb   $0x1,(%edx)
  800998:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099b:	39 d9                	cmp    %ebx,%ecx
  80099d:	75 ed                	jne    80098c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80099f:	89 f0                	mov    %esi,%eax
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	57                   	push   %edi
  8009a9:	56                   	push   %esi
  8009aa:	53                   	push   %ebx
  8009ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009b1:	8b 75 10             	mov    0x10(%ebp),%esi
  8009b4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	74 34                	je     8009ee <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8009ba:	83 fe 01             	cmp    $0x1,%esi
  8009bd:	74 26                	je     8009e5 <strlcpy+0x40>
  8009bf:	0f b6 0b             	movzbl (%ebx),%ecx
  8009c2:	84 c9                	test   %cl,%cl
  8009c4:	74 23                	je     8009e9 <strlcpy+0x44>
  8009c6:	83 ee 02             	sub    $0x2,%esi
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8009ce:	83 c0 01             	add    $0x1,%eax
  8009d1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d4:	39 f2                	cmp    %esi,%edx
  8009d6:	74 13                	je     8009eb <strlcpy+0x46>
  8009d8:	83 c2 01             	add    $0x1,%edx
  8009db:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009df:	84 c9                	test   %cl,%cl
  8009e1:	75 eb                	jne    8009ce <strlcpy+0x29>
  8009e3:	eb 06                	jmp    8009eb <strlcpy+0x46>
  8009e5:	89 f8                	mov    %edi,%eax
  8009e7:	eb 02                	jmp    8009eb <strlcpy+0x46>
  8009e9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ee:	29 f8                	sub    %edi,%eax
}
  8009f0:	5b                   	pop    %ebx
  8009f1:	5e                   	pop    %esi
  8009f2:	5f                   	pop    %edi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009fe:	0f b6 01             	movzbl (%ecx),%eax
  800a01:	84 c0                	test   %al,%al
  800a03:	74 15                	je     800a1a <strcmp+0x25>
  800a05:	3a 02                	cmp    (%edx),%al
  800a07:	75 11                	jne    800a1a <strcmp+0x25>
		p++, q++;
  800a09:	83 c1 01             	add    $0x1,%ecx
  800a0c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0f:	0f b6 01             	movzbl (%ecx),%eax
  800a12:	84 c0                	test   %al,%al
  800a14:	74 04                	je     800a1a <strcmp+0x25>
  800a16:	3a 02                	cmp    (%edx),%al
  800a18:	74 ef                	je     800a09 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1a:	0f b6 c0             	movzbl %al,%eax
  800a1d:	0f b6 12             	movzbl (%edx),%edx
  800a20:	29 d0                	sub    %edx,%eax
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	56                   	push   %esi
  800a28:	53                   	push   %ebx
  800a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800a32:	85 f6                	test   %esi,%esi
  800a34:	74 29                	je     800a5f <strncmp+0x3b>
  800a36:	0f b6 03             	movzbl (%ebx),%eax
  800a39:	84 c0                	test   %al,%al
  800a3b:	74 30                	je     800a6d <strncmp+0x49>
  800a3d:	3a 02                	cmp    (%edx),%al
  800a3f:	75 2c                	jne    800a6d <strncmp+0x49>
  800a41:	8d 43 01             	lea    0x1(%ebx),%eax
  800a44:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800a46:	89 c3                	mov    %eax,%ebx
  800a48:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a4b:	39 f0                	cmp    %esi,%eax
  800a4d:	74 17                	je     800a66 <strncmp+0x42>
  800a4f:	0f b6 08             	movzbl (%eax),%ecx
  800a52:	84 c9                	test   %cl,%cl
  800a54:	74 17                	je     800a6d <strncmp+0x49>
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	3a 0a                	cmp    (%edx),%cl
  800a5b:	74 e9                	je     800a46 <strncmp+0x22>
  800a5d:	eb 0e                	jmp    800a6d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a64:	eb 0f                	jmp    800a75 <strncmp+0x51>
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6b:	eb 08                	jmp    800a75 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6d:	0f b6 03             	movzbl (%ebx),%eax
  800a70:	0f b6 12             	movzbl (%edx),%edx
  800a73:	29 d0                	sub    %edx,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	53                   	push   %ebx
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a83:	0f b6 18             	movzbl (%eax),%ebx
  800a86:	84 db                	test   %bl,%bl
  800a88:	74 1d                	je     800aa7 <strchr+0x2e>
  800a8a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a8c:	38 d3                	cmp    %dl,%bl
  800a8e:	75 06                	jne    800a96 <strchr+0x1d>
  800a90:	eb 1a                	jmp    800aac <strchr+0x33>
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 16                	je     800aac <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	0f b6 10             	movzbl (%eax),%edx
  800a9c:	84 d2                	test   %dl,%dl
  800a9e:	75 f2                	jne    800a92 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	eb 05                	jmp    800aac <strchr+0x33>
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aac:	5b                   	pop    %ebx
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	53                   	push   %ebx
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ab9:	0f b6 18             	movzbl (%eax),%ebx
  800abc:	84 db                	test   %bl,%bl
  800abe:	74 16                	je     800ad6 <strfind+0x27>
  800ac0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ac2:	38 d3                	cmp    %dl,%bl
  800ac4:	75 06                	jne    800acc <strfind+0x1d>
  800ac6:	eb 0e                	jmp    800ad6 <strfind+0x27>
  800ac8:	38 ca                	cmp    %cl,%dl
  800aca:	74 0a                	je     800ad6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800acc:	83 c0 01             	add    $0x1,%eax
  800acf:	0f b6 10             	movzbl (%eax),%edx
  800ad2:	84 d2                	test   %dl,%dl
  800ad4:	75 f2                	jne    800ac8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae5:	85 c9                	test   %ecx,%ecx
  800ae7:	74 36                	je     800b1f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aef:	75 28                	jne    800b19 <memset+0x40>
  800af1:	f6 c1 03             	test   $0x3,%cl
  800af4:	75 23                	jne    800b19 <memset+0x40>
		c &= 0xFF;
  800af6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afa:	89 d3                	mov    %edx,%ebx
  800afc:	c1 e3 08             	shl    $0x8,%ebx
  800aff:	89 d6                	mov    %edx,%esi
  800b01:	c1 e6 18             	shl    $0x18,%esi
  800b04:	89 d0                	mov    %edx,%eax
  800b06:	c1 e0 10             	shl    $0x10,%eax
  800b09:	09 f0                	or     %esi,%eax
  800b0b:	09 c2                	or     %eax,%edx
  800b0d:	89 d0                	mov    %edx,%eax
  800b0f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b11:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b14:	fc                   	cld    
  800b15:	f3 ab                	rep stos %eax,%es:(%edi)
  800b17:	eb 06                	jmp    800b1f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	fc                   	cld    
  800b1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1f:	89 f8                	mov    %edi,%eax
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b34:	39 c6                	cmp    %eax,%esi
  800b36:	73 35                	jae    800b6d <memmove+0x47>
  800b38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b3b:	39 d0                	cmp    %edx,%eax
  800b3d:	73 2e                	jae    800b6d <memmove+0x47>
		s += n;
		d += n;
  800b3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b42:	89 d6                	mov    %edx,%esi
  800b44:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b4c:	75 13                	jne    800b61 <memmove+0x3b>
  800b4e:	f6 c1 03             	test   $0x3,%cl
  800b51:	75 0e                	jne    800b61 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b53:	83 ef 04             	sub    $0x4,%edi
  800b56:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b59:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b5c:	fd                   	std    
  800b5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5f:	eb 09                	jmp    800b6a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b61:	83 ef 01             	sub    $0x1,%edi
  800b64:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b67:	fd                   	std    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6a:	fc                   	cld    
  800b6b:	eb 1d                	jmp    800b8a <memmove+0x64>
  800b6d:	89 f2                	mov    %esi,%edx
  800b6f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b71:	f6 c2 03             	test   $0x3,%dl
  800b74:	75 0f                	jne    800b85 <memmove+0x5f>
  800b76:	f6 c1 03             	test   $0x3,%cl
  800b79:	75 0a                	jne    800b85 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	fc                   	cld    
  800b81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b83:	eb 05                	jmp    800b8a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b85:	89 c7                	mov    %eax,%edi
  800b87:	fc                   	cld    
  800b88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8a:	5e                   	pop    %esi
  800b8b:	5f                   	pop    %edi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b94:	8b 45 10             	mov    0x10(%ebp),%eax
  800b97:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 04 24             	mov    %eax,(%esp)
  800ba8:	e8 79 ff ff ff       	call   800b26 <memmove>
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbe:	8d 78 ff             	lea    -0x1(%eax),%edi
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	74 36                	je     800bfb <memcmp+0x4c>
		if (*s1 != *s2)
  800bc5:	0f b6 03             	movzbl (%ebx),%eax
  800bc8:	0f b6 0e             	movzbl (%esi),%ecx
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	38 c8                	cmp    %cl,%al
  800bd2:	74 1c                	je     800bf0 <memcmp+0x41>
  800bd4:	eb 10                	jmp    800be6 <memcmp+0x37>
  800bd6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bdb:	83 c2 01             	add    $0x1,%edx
  800bde:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800be2:	38 c8                	cmp    %cl,%al
  800be4:	74 0a                	je     800bf0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800be6:	0f b6 c0             	movzbl %al,%eax
  800be9:	0f b6 c9             	movzbl %cl,%ecx
  800bec:	29 c8                	sub    %ecx,%eax
  800bee:	eb 10                	jmp    800c00 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf0:	39 fa                	cmp    %edi,%edx
  800bf2:	75 e2                	jne    800bd6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	eb 05                	jmp    800c00 <memcmp+0x51>
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	53                   	push   %ebx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c14:	39 d0                	cmp    %edx,%eax
  800c16:	73 13                	jae    800c2b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c18:	89 d9                	mov    %ebx,%ecx
  800c1a:	38 18                	cmp    %bl,(%eax)
  800c1c:	75 06                	jne    800c24 <memfind+0x1f>
  800c1e:	eb 0b                	jmp    800c2b <memfind+0x26>
  800c20:	38 08                	cmp    %cl,(%eax)
  800c22:	74 07                	je     800c2b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c24:	83 c0 01             	add    $0x1,%eax
  800c27:	39 d0                	cmp    %edx,%eax
  800c29:	75 f5                	jne    800c20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3a:	0f b6 0a             	movzbl (%edx),%ecx
  800c3d:	80 f9 09             	cmp    $0x9,%cl
  800c40:	74 05                	je     800c47 <strtol+0x19>
  800c42:	80 f9 20             	cmp    $0x20,%cl
  800c45:	75 10                	jne    800c57 <strtol+0x29>
		s++;
  800c47:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 0a             	movzbl (%edx),%ecx
  800c4d:	80 f9 09             	cmp    $0x9,%cl
  800c50:	74 f5                	je     800c47 <strtol+0x19>
  800c52:	80 f9 20             	cmp    $0x20,%cl
  800c55:	74 f0                	je     800c47 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c57:	80 f9 2b             	cmp    $0x2b,%cl
  800c5a:	75 0a                	jne    800c66 <strtol+0x38>
		s++;
  800c5c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c64:	eb 11                	jmp    800c77 <strtol+0x49>
  800c66:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c6b:	80 f9 2d             	cmp    $0x2d,%cl
  800c6e:	75 07                	jne    800c77 <strtol+0x49>
		s++, neg = 1;
  800c70:	83 c2 01             	add    $0x1,%edx
  800c73:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c77:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c7c:	75 15                	jne    800c93 <strtol+0x65>
  800c7e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c81:	75 10                	jne    800c93 <strtol+0x65>
  800c83:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c87:	75 0a                	jne    800c93 <strtol+0x65>
		s += 2, base = 16;
  800c89:	83 c2 02             	add    $0x2,%edx
  800c8c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c91:	eb 10                	jmp    800ca3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c93:	85 c0                	test   %eax,%eax
  800c95:	75 0c                	jne    800ca3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c97:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c99:	80 3a 30             	cmpb   $0x30,(%edx)
  800c9c:	75 05                	jne    800ca3 <strtol+0x75>
		s++, base = 8;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cab:	0f b6 0a             	movzbl (%edx),%ecx
  800cae:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cb1:	89 f0                	mov    %esi,%eax
  800cb3:	3c 09                	cmp    $0x9,%al
  800cb5:	77 08                	ja     800cbf <strtol+0x91>
			dig = *s - '0';
  800cb7:	0f be c9             	movsbl %cl,%ecx
  800cba:	83 e9 30             	sub    $0x30,%ecx
  800cbd:	eb 20                	jmp    800cdf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800cbf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cc2:	89 f0                	mov    %esi,%eax
  800cc4:	3c 19                	cmp    $0x19,%al
  800cc6:	77 08                	ja     800cd0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800cc8:	0f be c9             	movsbl %cl,%ecx
  800ccb:	83 e9 57             	sub    $0x57,%ecx
  800cce:	eb 0f                	jmp    800cdf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800cd0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cd3:	89 f0                	mov    %esi,%eax
  800cd5:	3c 19                	cmp    $0x19,%al
  800cd7:	77 16                	ja     800cef <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd9:	0f be c9             	movsbl %cl,%ecx
  800cdc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cdf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ce2:	7d 0f                	jge    800cf3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ce4:	83 c2 01             	add    $0x1,%edx
  800ce7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ceb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ced:	eb bc                	jmp    800cab <strtol+0x7d>
  800cef:	89 d8                	mov    %ebx,%eax
  800cf1:	eb 02                	jmp    800cf5 <strtol+0xc7>
  800cf3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	74 05                	je     800d00 <strtol+0xd2>
		*endptr = (char *) s;
  800cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfe:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d00:	f7 d8                	neg    %eax
  800d02:	85 ff                	test   %edi,%edi
  800d04:	0f 44 c3             	cmove  %ebx,%eax
}
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d12:	b8 00 00 00 00       	mov    $0x0,%eax
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	89 c3                	mov    %eax,%ebx
  800d1f:	89 c7                	mov    %eax,%edi
  800d21:	89 c6                	mov    %eax,%esi
  800d23:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3a:	89 d1                	mov    %edx,%ecx
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	89 d7                	mov    %edx,%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d57:	b8 03 00 00 00       	mov    $0x3,%eax
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	89 cb                	mov    %ecx,%ebx
  800d61:	89 cf                	mov    %ecx,%edi
  800d63:	89 ce                	mov    %ecx,%esi
  800d65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7e 28                	jle    800d93 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d76:	00 
  800d77:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800d7e:	00 
  800d7f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d86:	00 
  800d87:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800d8e:	e8 46 f4 ff ff       	call   8001d9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d93:	83 c4 2c             	add    $0x2c,%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dab:	89 d1                	mov    %edx,%ecx
  800dad:	89 d3                	mov    %edx,%ebx
  800daf:	89 d7                	mov    %edx,%edi
  800db1:	89 d6                	mov    %edx,%esi
  800db3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_yield>:

void
sys_yield(void)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dca:	89 d1                	mov    %edx,%ecx
  800dcc:	89 d3                	mov    %edx,%ebx
  800dce:	89 d7                	mov    %edx,%edi
  800dd0:	89 d6                	mov    %edx,%esi
  800dd2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de2:	be 00 00 00 00       	mov    $0x0,%esi
  800de7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df5:	89 f7                	mov    %esi,%edi
  800df7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7e 28                	jle    800e25 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e01:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e08:	00 
  800e09:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800e10:	00 
  800e11:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e18:	00 
  800e19:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800e20:	e8 b4 f3 ff ff       	call   8001d9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e25:	83 c4 2c             	add    $0x2c,%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e36:	b8 05 00 00 00       	mov    $0x5,%eax
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e47:	8b 75 18             	mov    0x18(%ebp),%esi
  800e4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	7e 28                	jle    800e78 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e54:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e5b:	00 
  800e5c:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800e63:	00 
  800e64:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e6b:	00 
  800e6c:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800e73:	e8 61 f3 ff ff       	call   8001d9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e78:	83 c4 2c             	add    $0x2c,%esp
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 df                	mov    %ebx,%edi
  800e9b:	89 de                	mov    %ebx,%esi
  800e9d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	7e 28                	jle    800ecb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800eae:	00 
  800eaf:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800eb6:	00 
  800eb7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ebe:	00 
  800ebf:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ec6:	e8 0e f3 ff ff       	call   8001d9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ecb:	83 c4 2c             	add    $0x2c,%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	89 de                	mov    %ebx,%esi
  800ef0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7e 28                	jle    800f1e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efa:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f01:	00 
  800f02:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800f09:	00 
  800f0a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f11:	00 
  800f12:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800f19:	e8 bb f2 ff ff       	call   8001d9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f1e:	83 c4 2c             	add    $0x2c,%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f34:	b8 09 00 00 00       	mov    $0x9,%eax
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	89 de                	mov    %ebx,%esi
  800f43:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f45:	85 c0                	test   %eax,%eax
  800f47:	7e 28                	jle    800f71 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f54:	00 
  800f55:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800f5c:	00 
  800f5d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f64:	00 
  800f65:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800f6c:	e8 68 f2 ff ff       	call   8001d9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f71:	83 c4 2c             	add    $0x2c,%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	89 df                	mov    %ebx,%edi
  800f94:	89 de                	mov    %ebx,%esi
  800f96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	7e 28                	jle    800fc4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fa7:	00 
  800fa8:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800faf:	00 
  800fb0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fb7:	00 
  800fb8:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800fbf:	e8 15 f2 ff ff       	call   8001d9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc4:	83 c4 2c             	add    $0x2c,%esp
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	be 00 00 00 00       	mov    $0x0,%esi
  800fd7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5f                   	pop    %edi
  800fed:	5d                   	pop    %ebp
  800fee:	c3                   	ret    

00800fef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	57                   	push   %edi
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
  800ff5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffd:	b8 0d 00 00 00       	mov    $0xd,%eax
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	89 cb                	mov    %ecx,%ebx
  801007:	89 cf                	mov    %ecx,%edi
  801009:	89 ce                	mov    %ecx,%esi
  80100b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80100d:	85 c0                	test   %eax,%eax
  80100f:	7e 28                	jle    801039 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801011:	89 44 24 10          	mov    %eax,0x10(%esp)
  801015:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80101c:	00 
  80101d:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  801024:	00 
  801025:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80102c:	00 
  80102d:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  801034:	e8 a0 f1 ff ff       	call   8001d9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801039:	83 c4 2c             	add    $0x2c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	53                   	push   %ebx
  801045:	83 ec 24             	sub    $0x24,%esp
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80104b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80104d:	89 da                	mov    %ebx,%edx
  80104f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801052:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801059:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80105d:	74 05                	je     801064 <pgfault+0x23>
  80105f:	f6 c6 08             	test   $0x8,%dh
  801062:	75 1c                	jne    801080 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801064:	c7 44 24 08 ac 29 80 	movl   $0x8029ac,0x8(%esp)
  80106b:	00 
  80106c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801073:	00 
  801074:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80107b:	e8 59 f1 ff ff       	call   8001d9 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801080:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801087:	00 
  801088:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80108f:	00 
  801090:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801097:	e8 3d fd ff ff       	call   800dd9 <sys_page_alloc>
  80109c:	85 c0                	test   %eax,%eax
  80109e:	79 20                	jns    8010c0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  8010a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010a4:	c7 44 24 08 14 2a 80 	movl   $0x802a14,0x8(%esp)
  8010ab:	00 
  8010ac:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8010b3:	00 
  8010b4:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  8010bb:	e8 19 f1 ff ff       	call   8001d9 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  8010c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  8010c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010cd:	00 
  8010ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010d2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010d9:	e8 48 fa ff ff       	call   800b26 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8010de:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010e5:	00 
  8010e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010f9:	00 
  8010fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801101:	e8 27 fd ff ff       	call   800e2d <sys_page_map>
  801106:	85 c0                	test   %eax,%eax
  801108:	79 20                	jns    80112a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80110a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80110e:	c7 44 24 08 2e 2a 80 	movl   $0x802a2e,0x8(%esp)
  801115:	00 
  801116:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80111d:	00 
  80111e:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801125:	e8 af f0 ff ff       	call   8001d9 <_panic>
	}
}
  80112a:	83 c4 24             	add    $0x24,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	57                   	push   %edi
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
  801136:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801139:	c7 04 24 41 10 80 00 	movl   $0x801041,(%esp)
  801140:	e8 41 11 00 00       	call   802286 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801145:	b8 07 00 00 00       	mov    $0x7,%eax
  80114a:	cd 30                	int    $0x30
  80114c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80114f:	85 c0                	test   %eax,%eax
  801151:	79 1c                	jns    80116f <fork+0x3f>
		panic("fork");
  801153:	c7 44 24 08 47 2a 80 	movl   $0x802a47,0x8(%esp)
  80115a:	00 
  80115b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801162:	00 
  801163:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80116a:	e8 6a f0 ff ff       	call   8001d9 <_panic>
  80116f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801171:	bb 00 08 00 00       	mov    $0x800,%ebx
  801176:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80117a:	75 21                	jne    80119d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80117c:	e8 1a fc ff ff       	call   800d9b <sys_getenvid>
  801181:	25 ff 03 00 00       	and    $0x3ff,%eax
  801186:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801189:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80118e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
  801198:	e9 c5 01 00 00       	jmp    801362 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80119d:	89 d8                	mov    %ebx,%eax
  80119f:	c1 e8 0a             	shr    $0xa,%eax
  8011a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011a9:	a8 01                	test   $0x1,%al
  8011ab:	0f 84 f2 00 00 00    	je     8012a3 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  8011b1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011b8:	a8 05                	test   $0x5,%al
  8011ba:	0f 84 e3 00 00 00    	je     8012a3 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  8011c0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011c7:	89 de                	mov    %ebx,%esi
  8011c9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  8011cc:	a9 02 08 00 00       	test   $0x802,%eax
  8011d1:	0f 84 88 00 00 00    	je     80125f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8011d7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011de:	00 
  8011df:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f2:	e8 36 fc ff ff       	call   800e2d <sys_page_map>
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	79 20                	jns    80121b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  8011fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ff:	c7 44 24 08 4c 2a 80 	movl   $0x802a4c,0x8(%esp)
  801206:	00 
  801207:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80120e:	00 
  80120f:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801216:	e8 be ef ff ff       	call   8001d9 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80121b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801222:	00 
  801223:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801227:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80122e:	00 
  80122f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801233:	89 3c 24             	mov    %edi,(%esp)
  801236:	e8 f2 fb ff ff       	call   800e2d <sys_page_map>
  80123b:	85 c0                	test   %eax,%eax
  80123d:	79 64                	jns    8012a3 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80123f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801243:	c7 44 24 08 66 2a 80 	movl   $0x802a66,0x8(%esp)
  80124a:	00 
  80124b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801252:	00 
  801253:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80125a:	e8 7a ef ff ff       	call   8001d9 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80125f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801266:	00 
  801267:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80126b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80126f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127a:	e8 ae fb ff ff       	call   800e2d <sys_page_map>
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 20                	jns    8012a3 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801287:	c7 44 24 08 80 2a 80 	movl   $0x802a80,0x8(%esp)
  80128e:	00 
  80128f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801296:	00 
  801297:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80129e:	e8 36 ef ff ff       	call   8001d9 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  8012a3:	83 c3 01             	add    $0x1,%ebx
  8012a6:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8012ac:	0f 85 eb fe ff ff    	jne    80119d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  8012b2:	c7 44 24 04 ef 22 80 	movl   $0x8022ef,0x4(%esp)
  8012b9:	00 
  8012ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012bd:	89 04 24             	mov    %eax,(%esp)
  8012c0:	e8 b4 fc ff ff       	call   800f79 <sys_env_set_pgfault_upcall>
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	79 20                	jns    8012e9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8012c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cd:	c7 44 24 08 e4 29 80 	movl   $0x8029e4,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  8012e4:	e8 f0 ee ff ff       	call   8001d9 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8012e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012f0:	00 
  8012f1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012f8:	ee 
  8012f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fc:	89 04 24             	mov    %eax,(%esp)
  8012ff:	e8 d5 fa ff ff       	call   800dd9 <sys_page_alloc>
  801304:	85 c0                	test   %eax,%eax
  801306:	79 20                	jns    801328 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801308:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80130c:	c7 44 24 08 92 2a 80 	movl   $0x802a92,0x8(%esp)
  801313:	00 
  801314:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80131b:	00 
  80131c:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801323:	e8 b1 ee ff ff       	call   8001d9 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801328:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80132f:	00 
  801330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801333:	89 04 24             	mov    %eax,(%esp)
  801336:	e8 98 fb ff ff       	call   800ed3 <sys_env_set_status>
  80133b:	85 c0                	test   %eax,%eax
  80133d:	79 20                	jns    80135f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80133f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801343:	c7 44 24 08 aa 2a 80 	movl   $0x802aaa,0x8(%esp)
  80134a:	00 
  80134b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801352:	00 
  801353:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80135a:	e8 7a ee ff ff       	call   8001d9 <_panic>
	}

	return envid;
  80135f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801362:	83 c4 2c             	add    $0x2c,%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <sfork>:

// Challenge!
int
sfork(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801370:	c7 44 24 08 c5 2a 80 	movl   $0x802ac5,0x8(%esp)
  801377:	00 
  801378:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80137f:	00 
  801380:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  801387:	e8 4d ee ff ff       	call   8001d9 <_panic>

0080138c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	83 ec 10             	sub    $0x10,%esp
  801394:	8b 75 08             	mov    0x8(%ebp),%esi
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  80139d:	85 c0                	test   %eax,%eax
  80139f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8013a4:	0f 44 c2             	cmove  %edx,%eax
  8013a7:	89 04 24             	mov    %eax,(%esp)
  8013aa:	e8 40 fc ff ff       	call   800fef <sys_ipc_recv>
	if (err_code < 0) {
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	79 16                	jns    8013c9 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8013b3:	85 f6                	test   %esi,%esi
  8013b5:	74 06                	je     8013bd <ipc_recv+0x31>
  8013b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8013bd:	85 db                	test   %ebx,%ebx
  8013bf:	74 2c                	je     8013ed <ipc_recv+0x61>
  8013c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013c7:	eb 24                	jmp    8013ed <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8013c9:	85 f6                	test   %esi,%esi
  8013cb:	74 0a                	je     8013d7 <ipc_recv+0x4b>
  8013cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d2:	8b 40 74             	mov    0x74(%eax),%eax
  8013d5:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8013d7:	85 db                	test   %ebx,%ebx
  8013d9:	74 0a                	je     8013e5 <ipc_recv+0x59>
  8013db:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e0:	8b 40 78             	mov    0x78(%eax),%eax
  8013e3:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8013e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8013ea:	8b 40 70             	mov    0x70(%eax),%eax
}
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 1c             	sub    $0x1c,%esp
  8013fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801400:	8b 75 0c             	mov    0xc(%ebp),%esi
  801403:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801406:	eb 25                	jmp    80142d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801408:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80140b:	74 20                	je     80142d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  80140d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801411:	c7 44 24 08 db 2a 80 	movl   $0x802adb,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 e7 2a 80 00 	movl   $0x802ae7,(%esp)
  801428:	e8 ac ed ff ff       	call   8001d9 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80142d:	85 db                	test   %ebx,%ebx
  80142f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801434:	0f 45 c3             	cmovne %ebx,%eax
  801437:	8b 55 14             	mov    0x14(%ebp),%edx
  80143a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80143e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801442:	89 74 24 04          	mov    %esi,0x4(%esp)
  801446:	89 3c 24             	mov    %edi,(%esp)
  801449:	e8 7e fb ff ff       	call   800fcc <sys_ipc_try_send>
  80144e:	85 c0                	test   %eax,%eax
  801450:	75 b6                	jne    801408 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801452:	83 c4 1c             	add    $0x1c,%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801460:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801465:	39 c8                	cmp    %ecx,%eax
  801467:	74 17                	je     801480 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801469:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80146e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801471:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801477:	8b 52 50             	mov    0x50(%edx),%edx
  80147a:	39 ca                	cmp    %ecx,%edx
  80147c:	75 14                	jne    801492 <ipc_find_env+0x38>
  80147e:	eb 05                	jmp    801485 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801485:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801488:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80148d:	8b 40 40             	mov    0x40(%eax),%eax
  801490:	eb 0e                	jmp    8014a0 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801492:	83 c0 01             	add    $0x1,%eax
  801495:	3d 00 04 00 00       	cmp    $0x400,%eax
  80149a:	75 d2                	jne    80146e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80149c:	66 b8 00 00          	mov    $0x0,%ax
}
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    
  8014a2:	66 90                	xchg   %ax,%ax
  8014a4:	66 90                	xchg   %ax,%ax
  8014a6:	66 90                	xchg   %ax,%ax
  8014a8:	66 90                	xchg   %ax,%ax
  8014aa:	66 90                	xchg   %ax,%ax
  8014ac:	66 90                	xchg   %ax,%ax
  8014ae:	66 90                	xchg   %ax,%ax

008014b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014da:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014df:	a8 01                	test   $0x1,%al
  8014e1:	74 34                	je     801517 <fd_alloc+0x40>
  8014e3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8014e8:	a8 01                	test   $0x1,%al
  8014ea:	74 32                	je     80151e <fd_alloc+0x47>
  8014ec:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8014f1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014f3:	89 c2                	mov    %eax,%edx
  8014f5:	c1 ea 16             	shr    $0x16,%edx
  8014f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014ff:	f6 c2 01             	test   $0x1,%dl
  801502:	74 1f                	je     801523 <fd_alloc+0x4c>
  801504:	89 c2                	mov    %eax,%edx
  801506:	c1 ea 0c             	shr    $0xc,%edx
  801509:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801510:	f6 c2 01             	test   $0x1,%dl
  801513:	75 1a                	jne    80152f <fd_alloc+0x58>
  801515:	eb 0c                	jmp    801523 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801517:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80151c:	eb 05                	jmp    801523 <fd_alloc+0x4c>
  80151e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	89 08                	mov    %ecx,(%eax)
			return 0;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
  80152d:	eb 1a                	jmp    801549 <fd_alloc+0x72>
  80152f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801534:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801539:	75 b6                	jne    8014f1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801544:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    

0080154b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801551:	83 f8 1f             	cmp    $0x1f,%eax
  801554:	77 36                	ja     80158c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801556:	c1 e0 0c             	shl    $0xc,%eax
  801559:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80155e:	89 c2                	mov    %eax,%edx
  801560:	c1 ea 16             	shr    $0x16,%edx
  801563:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80156a:	f6 c2 01             	test   $0x1,%dl
  80156d:	74 24                	je     801593 <fd_lookup+0x48>
  80156f:	89 c2                	mov    %eax,%edx
  801571:	c1 ea 0c             	shr    $0xc,%edx
  801574:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80157b:	f6 c2 01             	test   $0x1,%dl
  80157e:	74 1a                	je     80159a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801580:	8b 55 0c             	mov    0xc(%ebp),%edx
  801583:	89 02                	mov    %eax,(%edx)
	return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
  80158a:	eb 13                	jmp    80159f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80158c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801591:	eb 0c                	jmp    80159f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801593:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801598:	eb 05                	jmp    80159f <fd_lookup+0x54>
  80159a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 14             	sub    $0x14,%esp
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8015ae:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8015b4:	75 1e                	jne    8015d4 <dev_lookup+0x33>
  8015b6:	eb 0e                	jmp    8015c6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015b8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8015bd:	eb 0c                	jmp    8015cb <dev_lookup+0x2a>
  8015bf:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8015c4:	eb 05                	jmp    8015cb <dev_lookup+0x2a>
  8015c6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8015cb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	eb 38                	jmp    80160c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8015d4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8015da:	74 dc                	je     8015b8 <dev_lookup+0x17>
  8015dc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8015e2:	74 db                	je     8015bf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015e4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015ea:	8b 52 48             	mov    0x48(%edx),%edx
  8015ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015f5:	c7 04 24 f4 2a 80 00 	movl   $0x802af4,(%esp)
  8015fc:	e8 d1 ec ff ff       	call   8002d2 <cprintf>
	*dev = 0;
  801601:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801607:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80160c:	83 c4 14             	add    $0x14,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	83 ec 20             	sub    $0x20,%esp
  80161a:	8b 75 08             	mov    0x8(%ebp),%esi
  80161d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801620:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801623:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801627:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	e8 13 ff ff ff       	call   80154b <fd_lookup>
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 05                	js     801641 <fd_close+0x2f>
	    || fd != fd2)
  80163c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80163f:	74 0c                	je     80164d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801641:	84 db                	test   %bl,%bl
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	0f 44 c2             	cmove  %edx,%eax
  80164b:	eb 3f                	jmp    80168c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80164d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	8b 06                	mov    (%esi),%eax
  801656:	89 04 24             	mov    %eax,(%esp)
  801659:	e8 43 ff ff ff       	call   8015a1 <dev_lookup>
  80165e:	89 c3                	mov    %eax,%ebx
  801660:	85 c0                	test   %eax,%eax
  801662:	78 16                	js     80167a <fd_close+0x68>
		if (dev->dev_close)
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80166a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80166f:	85 c0                	test   %eax,%eax
  801671:	74 07                	je     80167a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801673:	89 34 24             	mov    %esi,(%esp)
  801676:	ff d0                	call   *%eax
  801678:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80167a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80167e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801685:	e8 f6 f7 ff ff       	call   800e80 <sys_page_unmap>
	return r;
  80168a:	89 d8                	mov    %ebx,%eax
}
  80168c:	83 c4 20             	add    $0x20,%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801699:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	89 04 24             	mov    %eax,(%esp)
  8016a6:	e8 a0 fe ff ff       	call   80154b <fd_lookup>
  8016ab:	89 c2                	mov    %eax,%edx
  8016ad:	85 d2                	test   %edx,%edx
  8016af:	78 13                	js     8016c4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016b8:	00 
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 4e ff ff ff       	call   801612 <fd_close>
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <close_all>:

void
close_all(void)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016d2:	89 1c 24             	mov    %ebx,(%esp)
  8016d5:	e8 b9 ff ff ff       	call   801693 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016da:	83 c3 01             	add    $0x1,%ebx
  8016dd:	83 fb 20             	cmp    $0x20,%ebx
  8016e0:	75 f0                	jne    8016d2 <close_all+0xc>
		close(i);
}
  8016e2:	83 c4 14             	add    $0x14,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	57                   	push   %edi
  8016ec:	56                   	push   %esi
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	89 04 24             	mov    %eax,(%esp)
  8016fe:	e8 48 fe ff ff       	call   80154b <fd_lookup>
  801703:	89 c2                	mov    %eax,%edx
  801705:	85 d2                	test   %edx,%edx
  801707:	0f 88 e1 00 00 00    	js     8017ee <dup+0x106>
		return r;
	close(newfdnum);
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	89 04 24             	mov    %eax,(%esp)
  801713:	e8 7b ff ff ff       	call   801693 <close>

	newfd = INDEX2FD(newfdnum);
  801718:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80171b:	c1 e3 0c             	shl    $0xc,%ebx
  80171e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801727:	89 04 24             	mov    %eax,(%esp)
  80172a:	e8 91 fd ff ff       	call   8014c0 <fd2data>
  80172f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801731:	89 1c 24             	mov    %ebx,(%esp)
  801734:	e8 87 fd ff ff       	call   8014c0 <fd2data>
  801739:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80173b:	89 f0                	mov    %esi,%eax
  80173d:	c1 e8 16             	shr    $0x16,%eax
  801740:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801747:	a8 01                	test   $0x1,%al
  801749:	74 43                	je     80178e <dup+0xa6>
  80174b:	89 f0                	mov    %esi,%eax
  80174d:	c1 e8 0c             	shr    $0xc,%eax
  801750:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801757:	f6 c2 01             	test   $0x1,%dl
  80175a:	74 32                	je     80178e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80175c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801763:	25 07 0e 00 00       	and    $0xe07,%eax
  801768:	89 44 24 10          	mov    %eax,0x10(%esp)
  80176c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801770:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801777:	00 
  801778:	89 74 24 04          	mov    %esi,0x4(%esp)
  80177c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801783:	e8 a5 f6 ff ff       	call   800e2d <sys_page_map>
  801788:	89 c6                	mov    %eax,%esi
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 3e                	js     8017cc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80178e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801791:	89 c2                	mov    %eax,%edx
  801793:	c1 ea 0c             	shr    $0xc,%edx
  801796:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b2:	00 
  8017b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017be:	e8 6a f6 ff ff       	call   800e2d <sys_page_map>
  8017c3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017c8:	85 f6                	test   %esi,%esi
  8017ca:	79 22                	jns    8017ee <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d7:	e8 a4 f6 ff ff       	call   800e80 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e7:	e8 94 f6 ff ff       	call   800e80 <sys_page_unmap>
	return r;
  8017ec:	89 f0                	mov    %esi,%eax
}
  8017ee:	83 c4 3c             	add    $0x3c,%esp
  8017f1:	5b                   	pop    %ebx
  8017f2:	5e                   	pop    %esi
  8017f3:	5f                   	pop    %edi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 24             	sub    $0x24,%esp
  8017fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801800:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801803:	89 44 24 04          	mov    %eax,0x4(%esp)
  801807:	89 1c 24             	mov    %ebx,(%esp)
  80180a:	e8 3c fd ff ff       	call   80154b <fd_lookup>
  80180f:	89 c2                	mov    %eax,%edx
  801811:	85 d2                	test   %edx,%edx
  801813:	78 6d                	js     801882 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801815:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	89 04 24             	mov    %eax,(%esp)
  801824:	e8 78 fd ff ff       	call   8015a1 <dev_lookup>
  801829:	85 c0                	test   %eax,%eax
  80182b:	78 55                	js     801882 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	8b 50 08             	mov    0x8(%eax),%edx
  801833:	83 e2 03             	and    $0x3,%edx
  801836:	83 fa 01             	cmp    $0x1,%edx
  801839:	75 23                	jne    80185e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80183b:	a1 04 40 80 00       	mov    0x804004,%eax
  801840:	8b 40 48             	mov    0x48(%eax),%eax
  801843:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184b:	c7 04 24 35 2b 80 00 	movl   $0x802b35,(%esp)
  801852:	e8 7b ea ff ff       	call   8002d2 <cprintf>
		return -E_INVAL;
  801857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185c:	eb 24                	jmp    801882 <read+0x8c>
	}
	if (!dev->dev_read)
  80185e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801861:	8b 52 08             	mov    0x8(%edx),%edx
  801864:	85 d2                	test   %edx,%edx
  801866:	74 15                	je     80187d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801868:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80186f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801872:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801876:	89 04 24             	mov    %eax,(%esp)
  801879:	ff d2                	call   *%edx
  80187b:	eb 05                	jmp    801882 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80187d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801882:	83 c4 24             	add    $0x24,%esp
  801885:	5b                   	pop    %ebx
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	57                   	push   %edi
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	83 ec 1c             	sub    $0x1c,%esp
  801891:	8b 7d 08             	mov    0x8(%ebp),%edi
  801894:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801897:	85 f6                	test   %esi,%esi
  801899:	74 33                	je     8018ce <readn+0x46>
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018a5:	89 f2                	mov    %esi,%edx
  8018a7:	29 c2                	sub    %eax,%edx
  8018a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018ad:	03 45 0c             	add    0xc(%ebp),%eax
  8018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b4:	89 3c 24             	mov    %edi,(%esp)
  8018b7:	e8 3a ff ff ff       	call   8017f6 <read>
		if (m < 0)
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 1b                	js     8018db <readn+0x53>
			return m;
		if (m == 0)
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	74 11                	je     8018d5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018c4:	01 c3                	add    %eax,%ebx
  8018c6:	89 d8                	mov    %ebx,%eax
  8018c8:	39 f3                	cmp    %esi,%ebx
  8018ca:	72 d9                	jb     8018a5 <readn+0x1d>
  8018cc:	eb 0b                	jmp    8018d9 <readn+0x51>
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d3:	eb 06                	jmp    8018db <readn+0x53>
  8018d5:	89 d8                	mov    %ebx,%eax
  8018d7:	eb 02                	jmp    8018db <readn+0x53>
  8018d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018db:	83 c4 1c             	add    $0x1c,%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5f                   	pop    %edi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	53                   	push   %ebx
  8018e7:	83 ec 24             	sub    $0x24,%esp
  8018ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f4:	89 1c 24             	mov    %ebx,(%esp)
  8018f7:	e8 4f fc ff ff       	call   80154b <fd_lookup>
  8018fc:	89 c2                	mov    %eax,%edx
  8018fe:	85 d2                	test   %edx,%edx
  801900:	78 68                	js     80196a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801902:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801905:	89 44 24 04          	mov    %eax,0x4(%esp)
  801909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190c:	8b 00                	mov    (%eax),%eax
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	e8 8b fc ff ff       	call   8015a1 <dev_lookup>
  801916:	85 c0                	test   %eax,%eax
  801918:	78 50                	js     80196a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801921:	75 23                	jne    801946 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801923:	a1 04 40 80 00       	mov    0x804004,%eax
  801928:	8b 40 48             	mov    0x48(%eax),%eax
  80192b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	c7 04 24 51 2b 80 00 	movl   $0x802b51,(%esp)
  80193a:	e8 93 e9 ff ff       	call   8002d2 <cprintf>
		return -E_INVAL;
  80193f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801944:	eb 24                	jmp    80196a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801949:	8b 52 0c             	mov    0xc(%edx),%edx
  80194c:	85 d2                	test   %edx,%edx
  80194e:	74 15                	je     801965 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801953:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195e:	89 04 24             	mov    %eax,(%esp)
  801961:	ff d2                	call   *%edx
  801963:	eb 05                	jmp    80196a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801965:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80196a:	83 c4 24             	add    $0x24,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <seek>:

int
seek(int fdnum, off_t offset)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801976:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801979:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	89 04 24             	mov    %eax,(%esp)
  801983:	e8 c3 fb ff ff       	call   80154b <fd_lookup>
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 0e                	js     80199a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	53                   	push   %ebx
  8019a0:	83 ec 24             	sub    $0x24,%esp
  8019a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ad:	89 1c 24             	mov    %ebx,(%esp)
  8019b0:	e8 96 fb ff ff       	call   80154b <fd_lookup>
  8019b5:	89 c2                	mov    %eax,%edx
  8019b7:	85 d2                	test   %edx,%edx
  8019b9:	78 61                	js     801a1c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c5:	8b 00                	mov    (%eax),%eax
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	e8 d2 fb ff ff       	call   8015a1 <dev_lookup>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 49                	js     801a1c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019da:	75 23                	jne    8019ff <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019dc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e1:	8b 40 48             	mov    0x48(%eax),%eax
  8019e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ec:	c7 04 24 14 2b 80 00 	movl   $0x802b14,(%esp)
  8019f3:	e8 da e8 ff ff       	call   8002d2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019fd:	eb 1d                	jmp    801a1c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a02:	8b 52 18             	mov    0x18(%edx),%edx
  801a05:	85 d2                	test   %edx,%edx
  801a07:	74 0e                	je     801a17 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a0c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a10:	89 04 24             	mov    %eax,(%esp)
  801a13:	ff d2                	call   *%edx
  801a15:	eb 05                	jmp    801a1c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a17:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a1c:	83 c4 24             	add    $0x24,%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    

00801a22 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	53                   	push   %ebx
  801a26:	83 ec 24             	sub    $0x24,%esp
  801a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	89 04 24             	mov    %eax,(%esp)
  801a39:	e8 0d fb ff ff       	call   80154b <fd_lookup>
  801a3e:	89 c2                	mov    %eax,%edx
  801a40:	85 d2                	test   %edx,%edx
  801a42:	78 52                	js     801a96 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4e:	8b 00                	mov    (%eax),%eax
  801a50:	89 04 24             	mov    %eax,(%esp)
  801a53:	e8 49 fb ff ff       	call   8015a1 <dev_lookup>
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	78 3a                	js     801a96 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a63:	74 2c                	je     801a91 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a65:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a68:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a6f:	00 00 00 
	stat->st_isdir = 0;
  801a72:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a79:	00 00 00 
	stat->st_dev = dev;
  801a7c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a89:	89 14 24             	mov    %edx,(%esp)
  801a8c:	ff 50 14             	call   *0x14(%eax)
  801a8f:	eb 05                	jmp    801a96 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a96:	83 c4 24             	add    $0x24,%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	56                   	push   %esi
  801aa0:	53                   	push   %ebx
  801aa1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aa4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aab:	00 
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 e1 01 00 00       	call   801c98 <open>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	85 db                	test   %ebx,%ebx
  801abb:	78 1b                	js     801ad8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac4:	89 1c 24             	mov    %ebx,(%esp)
  801ac7:	e8 56 ff ff ff       	call   801a22 <fstat>
  801acc:	89 c6                	mov    %eax,%esi
	close(fd);
  801ace:	89 1c 24             	mov    %ebx,(%esp)
  801ad1:	e8 bd fb ff ff       	call   801693 <close>
	return r;
  801ad6:	89 f0                	mov    %esi,%eax
}
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5d                   	pop    %ebp
  801ade:	c3                   	ret    

00801adf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 10             	sub    $0x10,%esp
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801aeb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801af2:	75 11                	jne    801b05 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801af4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801afb:	e8 5a f9 ff ff       	call   80145a <ipc_find_env>
  801b00:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801b05:	a1 04 40 80 00       	mov    0x804004,%eax
  801b0a:	8b 40 48             	mov    0x48(%eax),%eax
  801b0d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801b13:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1f:	c7 04 24 6e 2b 80 00 	movl   $0x802b6e,(%esp)
  801b26:	e8 a7 e7 ff ff       	call   8002d2 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b2b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b32:	00 
  801b33:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b3a:	00 
  801b3b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b3f:	a1 00 40 80 00       	mov    0x804000,%eax
  801b44:	89 04 24             	mov    %eax,(%esp)
  801b47:	e8 a8 f8 ff ff       	call   8013f4 <ipc_send>
	cprintf("ipc_send\n");
  801b4c:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  801b53:	e8 7a e7 ff ff       	call   8002d2 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801b58:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b5f:	00 
  801b60:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b6b:	e8 1c f8 ff ff       	call   80138c <ipc_recv>
}
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 14             	sub    $0x14,%esp
  801b7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	8b 40 0c             	mov    0xc(%eax),%eax
  801b87:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b91:	b8 05 00 00 00       	mov    $0x5,%eax
  801b96:	e8 44 ff ff ff       	call   801adf <fsipc>
  801b9b:	89 c2                	mov    %eax,%edx
  801b9d:	85 d2                	test   %edx,%edx
  801b9f:	78 2b                	js     801bcc <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ba1:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ba8:	00 
  801ba9:	89 1c 24             	mov    %ebx,(%esp)
  801bac:	e8 7a ed ff ff       	call   80092b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bb1:	a1 80 50 80 00       	mov    0x805080,%eax
  801bb6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bbc:	a1 84 50 80 00       	mov    0x805084,%eax
  801bc1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcc:	83 c4 14             	add    $0x14,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    

00801bd2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bde:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801be3:	ba 00 00 00 00       	mov    $0x0,%edx
  801be8:	b8 06 00 00 00       	mov    $0x6,%eax
  801bed:	e8 ed fe ff ff       	call   801adf <fsipc>
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 10             	sub    $0x10,%esp
  801bfc:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8b 40 0c             	mov    0xc(%eax),%eax
  801c05:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c0a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c10:	ba 00 00 00 00       	mov    $0x0,%edx
  801c15:	b8 03 00 00 00       	mov    $0x3,%eax
  801c1a:	e8 c0 fe ff ff       	call   801adf <fsipc>
  801c1f:	89 c3                	mov    %eax,%ebx
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 6a                	js     801c8f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c25:	39 c6                	cmp    %eax,%esi
  801c27:	73 24                	jae    801c4d <devfile_read+0x59>
  801c29:	c7 44 24 0c 8e 2b 80 	movl   $0x802b8e,0xc(%esp)
  801c30:	00 
  801c31:	c7 44 24 08 95 2b 80 	movl   $0x802b95,0x8(%esp)
  801c38:	00 
  801c39:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c40:	00 
  801c41:	c7 04 24 aa 2b 80 00 	movl   $0x802baa,(%esp)
  801c48:	e8 8c e5 ff ff       	call   8001d9 <_panic>
	assert(r <= PGSIZE);
  801c4d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c52:	7e 24                	jle    801c78 <devfile_read+0x84>
  801c54:	c7 44 24 0c b5 2b 80 	movl   $0x802bb5,0xc(%esp)
  801c5b:	00 
  801c5c:	c7 44 24 08 95 2b 80 	movl   $0x802b95,0x8(%esp)
  801c63:	00 
  801c64:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801c6b:	00 
  801c6c:	c7 04 24 aa 2b 80 00 	movl   $0x802baa,(%esp)
  801c73:	e8 61 e5 ff ff       	call   8001d9 <_panic>
	memmove(buf, &fsipcbuf, r);
  801c78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c83:	00 
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	e8 97 ee ff ff       	call   800b26 <memmove>
	return r;
}
  801c8f:	89 d8                	mov    %ebx,%eax
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    

00801c98 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 24             	sub    $0x24,%esp
  801c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ca2:	89 1c 24             	mov    %ebx,(%esp)
  801ca5:	e8 26 ec ff ff       	call   8008d0 <strlen>
  801caa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801caf:	7f 60                	jg     801d11 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 1b f8 ff ff       	call   8014d7 <fd_alloc>
  801cbc:	89 c2                	mov    %eax,%edx
  801cbe:	85 d2                	test   %edx,%edx
  801cc0:	78 54                	js     801d16 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc6:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801ccd:	e8 59 ec ff ff       	call   80092b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd5:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	e8 f8 fd ff ff       	call   801adf <fsipc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	79 17                	jns    801d04 <open+0x6c>
		fd_close(fd, 0);
  801ced:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cf4:	00 
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	89 04 24             	mov    %eax,(%esp)
  801cfb:	e8 12 f9 ff ff       	call   801612 <fd_close>
		return r;
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	eb 12                	jmp    801d16 <open+0x7e>
	}
	return fd2num(fd);
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 a1 f7 ff ff       	call   8014b0 <fd2num>
  801d0f:	eb 05                	jmp    801d16 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d11:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801d16:	83 c4 24             	add    $0x24,%esp
  801d19:	5b                   	pop    %ebx
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	66 90                	xchg   %ax,%ax
  801d1e:	66 90                	xchg   %ax,%ax

00801d20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	83 ec 10             	sub    $0x10,%esp
  801d28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 8a f7 ff ff       	call   8014c0 <fd2data>
  801d36:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d38:	c7 44 24 04 c1 2b 80 	movl   $0x802bc1,0x4(%esp)
  801d3f:	00 
  801d40:	89 1c 24             	mov    %ebx,(%esp)
  801d43:	e8 e3 eb ff ff       	call   80092b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d48:	8b 46 04             	mov    0x4(%esi),%eax
  801d4b:	2b 06                	sub    (%esi),%eax
  801d4d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d53:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d5a:	00 00 00 
	stat->st_dev = &devpipe;
  801d5d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d64:	30 80 00 
	return 0;
}
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	53                   	push   %ebx
  801d77:	83 ec 14             	sub    $0x14,%esp
  801d7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d88:	e8 f3 f0 ff ff       	call   800e80 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d8d:	89 1c 24             	mov    %ebx,(%esp)
  801d90:	e8 2b f7 ff ff       	call   8014c0 <fd2data>
  801d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da0:	e8 db f0 ff ff       	call   800e80 <sys_page_unmap>
}
  801da5:	83 c4 14             	add    $0x14,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    

00801dab <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	57                   	push   %edi
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
  801db1:	83 ec 2c             	sub    $0x2c,%esp
  801db4:	89 c6                	mov    %eax,%esi
  801db6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801db9:	a1 04 40 80 00       	mov    0x804004,%eax
  801dbe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc1:	89 34 24             	mov    %esi,(%esp)
  801dc4:	e8 77 05 00 00       	call   802340 <pageref>
  801dc9:	89 c7                	mov    %eax,%edi
  801dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 6a 05 00 00       	call   802340 <pageref>
  801dd6:	39 c7                	cmp    %eax,%edi
  801dd8:	0f 94 c2             	sete   %dl
  801ddb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801dde:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801de4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801de7:	39 fb                	cmp    %edi,%ebx
  801de9:	74 21                	je     801e0c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801deb:	84 d2                	test   %dl,%dl
  801ded:	74 ca                	je     801db9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801def:	8b 51 58             	mov    0x58(%ecx),%edx
  801df2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dfa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dfe:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  801e05:	e8 c8 e4 ff ff       	call   8002d2 <cprintf>
  801e0a:	eb ad                	jmp    801db9 <_pipeisclosed+0xe>
	}
}
  801e0c:	83 c4 2c             	add    $0x2c,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    

00801e14 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	57                   	push   %edi
  801e18:	56                   	push   %esi
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 1c             	sub    $0x1c,%esp
  801e1d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e20:	89 34 24             	mov    %esi,(%esp)
  801e23:	e8 98 f6 ff ff       	call   8014c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2c:	74 61                	je     801e8f <devpipe_write+0x7b>
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	bf 00 00 00 00       	mov    $0x0,%edi
  801e35:	eb 4a                	jmp    801e81 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e37:	89 da                	mov    %ebx,%edx
  801e39:	89 f0                	mov    %esi,%eax
  801e3b:	e8 6b ff ff ff       	call   801dab <_pipeisclosed>
  801e40:	85 c0                	test   %eax,%eax
  801e42:	75 54                	jne    801e98 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e44:	e8 71 ef ff ff       	call   800dba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e49:	8b 43 04             	mov    0x4(%ebx),%eax
  801e4c:	8b 0b                	mov    (%ebx),%ecx
  801e4e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e51:	39 d0                	cmp    %edx,%eax
  801e53:	73 e2                	jae    801e37 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e58:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e5c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e5f:	99                   	cltd   
  801e60:	c1 ea 1b             	shr    $0x1b,%edx
  801e63:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e66:	83 e1 1f             	and    $0x1f,%ecx
  801e69:	29 d1                	sub    %edx,%ecx
  801e6b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e6f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e73:	83 c0 01             	add    $0x1,%eax
  801e76:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e79:	83 c7 01             	add    $0x1,%edi
  801e7c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e7f:	74 13                	je     801e94 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e81:	8b 43 04             	mov    0x4(%ebx),%eax
  801e84:	8b 0b                	mov    (%ebx),%ecx
  801e86:	8d 51 20             	lea    0x20(%ecx),%edx
  801e89:	39 d0                	cmp    %edx,%eax
  801e8b:	73 aa                	jae    801e37 <devpipe_write+0x23>
  801e8d:	eb c6                	jmp    801e55 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e8f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e94:	89 f8                	mov    %edi,%eax
  801e96:	eb 05                	jmp    801e9d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e9d:	83 c4 1c             	add    $0x1c,%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    

00801ea5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	57                   	push   %edi
  801ea9:	56                   	push   %esi
  801eaa:	53                   	push   %ebx
  801eab:	83 ec 1c             	sub    $0x1c,%esp
  801eae:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801eb1:	89 3c 24             	mov    %edi,(%esp)
  801eb4:	e8 07 f6 ff ff       	call   8014c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ebd:	74 54                	je     801f13 <devpipe_read+0x6e>
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	be 00 00 00 00       	mov    $0x0,%esi
  801ec6:	eb 3e                	jmp    801f06 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ec8:	89 f0                	mov    %esi,%eax
  801eca:	eb 55                	jmp    801f21 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ecc:	89 da                	mov    %ebx,%edx
  801ece:	89 f8                	mov    %edi,%eax
  801ed0:	e8 d6 fe ff ff       	call   801dab <_pipeisclosed>
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	75 43                	jne    801f1c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ed9:	e8 dc ee ff ff       	call   800dba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ede:	8b 03                	mov    (%ebx),%eax
  801ee0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ee3:	74 e7                	je     801ecc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee5:	99                   	cltd   
  801ee6:	c1 ea 1b             	shr    $0x1b,%edx
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	83 e0 1f             	and    $0x1f,%eax
  801eee:	29 d0                	sub    %edx,%eax
  801ef0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801efb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801efe:	83 c6 01             	add    $0x1,%esi
  801f01:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f04:	74 12                	je     801f18 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801f06:	8b 03                	mov    (%ebx),%eax
  801f08:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f0b:	75 d8                	jne    801ee5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f0d:	85 f6                	test   %esi,%esi
  801f0f:	75 b7                	jne    801ec8 <devpipe_read+0x23>
  801f11:	eb b9                	jmp    801ecc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f13:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f18:	89 f0                	mov    %esi,%eax
  801f1a:	eb 05                	jmp    801f21 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f21:	83 c4 1c             	add    $0x1c,%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5f                   	pop    %edi
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	56                   	push   %esi
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f34:	89 04 24             	mov    %eax,(%esp)
  801f37:	e8 9b f5 ff ff       	call   8014d7 <fd_alloc>
  801f3c:	89 c2                	mov    %eax,%edx
  801f3e:	85 d2                	test   %edx,%edx
  801f40:	0f 88 4d 01 00 00    	js     802093 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f4d:	00 
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5c:	e8 78 ee ff ff       	call   800dd9 <sys_page_alloc>
  801f61:	89 c2                	mov    %eax,%edx
  801f63:	85 d2                	test   %edx,%edx
  801f65:	0f 88 28 01 00 00    	js     802093 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f6e:	89 04 24             	mov    %eax,(%esp)
  801f71:	e8 61 f5 ff ff       	call   8014d7 <fd_alloc>
  801f76:	89 c3                	mov    %eax,%ebx
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	0f 88 fe 00 00 00    	js     80207e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f80:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f87:	00 
  801f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f96:	e8 3e ee ff ff       	call   800dd9 <sys_page_alloc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 d9 00 00 00    	js     80207e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	89 04 24             	mov    %eax,(%esp)
  801fab:	e8 10 f5 ff ff       	call   8014c0 <fd2data>
  801fb0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb9:	00 
  801fba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc5:	e8 0f ee ff ff       	call   800dd9 <sys_page_alloc>
  801fca:	89 c3                	mov    %eax,%ebx
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	0f 88 97 00 00 00    	js     80206b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd7:	89 04 24             	mov    %eax,(%esp)
  801fda:	e8 e1 f4 ff ff       	call   8014c0 <fd2data>
  801fdf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801fe6:	00 
  801fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801feb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ff2:	00 
  801ff3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffe:	e8 2a ee ff ff       	call   800e2d <sys_page_map>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	85 c0                	test   %eax,%eax
  802007:	78 52                	js     80205b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802009:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80201e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802027:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 72 f4 ff ff       	call   8014b0 <fd2num>
  80203e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802041:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802046:	89 04 24             	mov    %eax,(%esp)
  802049:	e8 62 f4 ff ff       	call   8014b0 <fd2num>
  80204e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802051:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
  802059:	eb 38                	jmp    802093 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80205b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80205f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802066:	e8 15 ee ff ff       	call   800e80 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80206b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802072:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802079:	e8 02 ee ff ff       	call   800e80 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	89 44 24 04          	mov    %eax,0x4(%esp)
  802085:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80208c:	e8 ef ed ff ff       	call   800e80 <sys_page_unmap>
  802091:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802093:	83 c4 30             	add    $0x30,%esp
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 99 f4 ff ff       	call   80154b <fd_lookup>
  8020b2:	89 c2                	mov    %eax,%edx
  8020b4:	85 d2                	test   %edx,%edx
  8020b6:	78 15                	js     8020cd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 fd f3 ff ff       	call   8014c0 <fd2data>
	return _pipeisclosed(fd, p);
  8020c3:	89 c2                	mov    %eax,%edx
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	e8 de fc ff ff       	call   801dab <_pipeisclosed>
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    
  8020cf:	90                   	nop

008020d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020e0:	c7 44 24 04 e0 2b 80 	movl   $0x802be0,0x4(%esp)
  8020e7:	00 
  8020e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020eb:	89 04 24             	mov    %eax,(%esp)
  8020ee:	e8 38 e8 ff ff       	call   80092b <strcpy>
	return 0;
}
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	57                   	push   %edi
  8020fe:	56                   	push   %esi
  8020ff:	53                   	push   %ebx
  802100:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802106:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210a:	74 4a                	je     802156 <devcons_write+0x5c>
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802116:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80211c:	8b 75 10             	mov    0x10(%ebp),%esi
  80211f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802121:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802124:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802129:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80212c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802130:	03 45 0c             	add    0xc(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	89 3c 24             	mov    %edi,(%esp)
  80213a:	e8 e7 e9 ff ff       	call   800b26 <memmove>
		sys_cputs(buf, m);
  80213f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802143:	89 3c 24             	mov    %edi,(%esp)
  802146:	e8 c1 eb ff ff       	call   800d0c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80214b:	01 f3                	add    %esi,%ebx
  80214d:	89 d8                	mov    %ebx,%eax
  80214f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802152:	72 c8                	jb     80211c <devcons_write+0x22>
  802154:	eb 05                	jmp    80215b <devcons_write+0x61>
  802156:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80215b:	89 d8                	mov    %ebx,%eax
  80215d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802173:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802177:	75 07                	jne    802180 <devcons_read+0x18>
  802179:	eb 28                	jmp    8021a3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80217b:	e8 3a ec ff ff       	call   800dba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802180:	e8 a5 eb ff ff       	call   800d2a <sys_cgetc>
  802185:	85 c0                	test   %eax,%eax
  802187:	74 f2                	je     80217b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 16                	js     8021a3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80218d:	83 f8 04             	cmp    $0x4,%eax
  802190:	74 0c                	je     80219e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802192:	8b 55 0c             	mov    0xc(%ebp),%edx
  802195:	88 02                	mov    %al,(%edx)
	return 1;
  802197:	b8 01 00 00 00       	mov    $0x1,%eax
  80219c:	eb 05                	jmp    8021a3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021b8:	00 
  8021b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021bc:	89 04 24             	mov    %eax,(%esp)
  8021bf:	e8 48 eb ff ff       	call   800d0c <sys_cputs>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <getchar>:

int
getchar(void)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021d3:	00 
  8021d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e2:	e8 0f f6 ff ff       	call   8017f6 <read>
	if (r < 0)
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	78 0f                	js     8021fa <getchar+0x34>
		return r;
	if (r < 1)
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	7e 06                	jle    8021f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021f3:	eb 05                	jmp    8021fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802205:	89 44 24 04          	mov    %eax,0x4(%esp)
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	89 04 24             	mov    %eax,(%esp)
  80220f:	e8 37 f3 ff ff       	call   80154b <fd_lookup>
  802214:	85 c0                	test   %eax,%eax
  802216:	78 11                	js     802229 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802221:	39 10                	cmp    %edx,(%eax)
  802223:	0f 94 c0             	sete   %al
  802226:	0f b6 c0             	movzbl %al,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <opencons>:

int
opencons(void)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 9b f2 ff ff       	call   8014d7 <fd_alloc>
		return r;
  80223c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 40                	js     802282 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802242:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802249:	00 
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 7c eb ff ff       	call   800dd9 <sys_page_alloc>
		return r;
  80225d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 1f                	js     802282 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802263:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802278:	89 04 24             	mov    %eax,(%esp)
  80227b:	e8 30 f2 ff ff       	call   8014b0 <fd2num>
  802280:	89 c2                	mov    %eax,%edx
}
  802282:	89 d0                	mov    %edx,%eax
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80228c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802293:	75 50                	jne    8022e5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802295:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80229c:	00 
  80229d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8022a4:	ee 
  8022a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ac:	e8 28 eb ff ff       	call   800dd9 <sys_page_alloc>
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	79 1c                	jns    8022d1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8022b5:	c7 44 24 08 ec 2b 80 	movl   $0x802bec,0x8(%esp)
  8022bc:	00 
  8022bd:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8022c4:	00 
  8022c5:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
  8022cc:	e8 08 df ff ff       	call   8001d9 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8022d1:	c7 44 24 04 ef 22 80 	movl   $0x8022ef,0x4(%esp)
  8022d8:	00 
  8022d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e0:	e8 94 ec ff ff       	call   800f79 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022ef:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022f0:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022f5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022f7:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8022fa:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8022fc:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802301:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802304:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802309:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80230c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80230e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802311:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802313:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802315:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80231a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80231d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802322:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802325:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802327:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80232c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80232f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802334:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802337:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802339:	83 c4 08             	add    $0x8,%esp
	popal
  80233c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80233d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80233e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80233f:	c3                   	ret    

00802340 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802346:	89 d0                	mov    %edx,%eax
  802348:	c1 e8 16             	shr    $0x16,%eax
  80234b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802357:	f6 c1 01             	test   $0x1,%cl
  80235a:	74 1d                	je     802379 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80235c:	c1 ea 0c             	shr    $0xc,%edx
  80235f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802366:	f6 c2 01             	test   $0x1,%dl
  802369:	74 0e                	je     802379 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80236b:	c1 ea 0c             	shr    $0xc,%edx
  80236e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802375:	ef 
  802376:	0f b7 c0             	movzwl %ax,%eax
}
  802379:	5d                   	pop    %ebp
  80237a:	c3                   	ret    
  80237b:	66 90                	xchg   %ax,%ax
  80237d:	66 90                	xchg   %ax,%ax
  80237f:	90                   	nop

00802380 <__udivdi3>:
  802380:	55                   	push   %ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	8b 44 24 28          	mov    0x28(%esp),%eax
  80238a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80238e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802392:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802396:	85 c0                	test   %eax,%eax
  802398:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80239c:	89 ea                	mov    %ebp,%edx
  80239e:	89 0c 24             	mov    %ecx,(%esp)
  8023a1:	75 2d                	jne    8023d0 <__udivdi3+0x50>
  8023a3:	39 e9                	cmp    %ebp,%ecx
  8023a5:	77 61                	ja     802408 <__udivdi3+0x88>
  8023a7:	85 c9                	test   %ecx,%ecx
  8023a9:	89 ce                	mov    %ecx,%esi
  8023ab:	75 0b                	jne    8023b8 <__udivdi3+0x38>
  8023ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b2:	31 d2                	xor    %edx,%edx
  8023b4:	f7 f1                	div    %ecx
  8023b6:	89 c6                	mov    %eax,%esi
  8023b8:	31 d2                	xor    %edx,%edx
  8023ba:	89 e8                	mov    %ebp,%eax
  8023bc:	f7 f6                	div    %esi
  8023be:	89 c5                	mov    %eax,%ebp
  8023c0:	89 f8                	mov    %edi,%eax
  8023c2:	f7 f6                	div    %esi
  8023c4:	89 ea                	mov    %ebp,%edx
  8023c6:	83 c4 0c             	add    $0xc,%esp
  8023c9:	5e                   	pop    %esi
  8023ca:	5f                   	pop    %edi
  8023cb:	5d                   	pop    %ebp
  8023cc:	c3                   	ret    
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	39 e8                	cmp    %ebp,%eax
  8023d2:	77 24                	ja     8023f8 <__udivdi3+0x78>
  8023d4:	0f bd e8             	bsr    %eax,%ebp
  8023d7:	83 f5 1f             	xor    $0x1f,%ebp
  8023da:	75 3c                	jne    802418 <__udivdi3+0x98>
  8023dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8023e0:	39 34 24             	cmp    %esi,(%esp)
  8023e3:	0f 86 9f 00 00 00    	jbe    802488 <__udivdi3+0x108>
  8023e9:	39 d0                	cmp    %edx,%eax
  8023eb:	0f 82 97 00 00 00    	jb     802488 <__udivdi3+0x108>
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	31 d2                	xor    %edx,%edx
  8023fa:	31 c0                	xor    %eax,%eax
  8023fc:	83 c4 0c             	add    $0xc,%esp
  8023ff:	5e                   	pop    %esi
  802400:	5f                   	pop    %edi
  802401:	5d                   	pop    %ebp
  802402:	c3                   	ret    
  802403:	90                   	nop
  802404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 f8                	mov    %edi,%eax
  80240a:	f7 f1                	div    %ecx
  80240c:	31 d2                	xor    %edx,%edx
  80240e:	83 c4 0c             	add    $0xc,%esp
  802411:	5e                   	pop    %esi
  802412:	5f                   	pop    %edi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    
  802415:	8d 76 00             	lea    0x0(%esi),%esi
  802418:	89 e9                	mov    %ebp,%ecx
  80241a:	8b 3c 24             	mov    (%esp),%edi
  80241d:	d3 e0                	shl    %cl,%eax
  80241f:	89 c6                	mov    %eax,%esi
  802421:	b8 20 00 00 00       	mov    $0x20,%eax
  802426:	29 e8                	sub    %ebp,%eax
  802428:	89 c1                	mov    %eax,%ecx
  80242a:	d3 ef                	shr    %cl,%edi
  80242c:	89 e9                	mov    %ebp,%ecx
  80242e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802432:	8b 3c 24             	mov    (%esp),%edi
  802435:	09 74 24 08          	or     %esi,0x8(%esp)
  802439:	89 d6                	mov    %edx,%esi
  80243b:	d3 e7                	shl    %cl,%edi
  80243d:	89 c1                	mov    %eax,%ecx
  80243f:	89 3c 24             	mov    %edi,(%esp)
  802442:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802446:	d3 ee                	shr    %cl,%esi
  802448:	89 e9                	mov    %ebp,%ecx
  80244a:	d3 e2                	shl    %cl,%edx
  80244c:	89 c1                	mov    %eax,%ecx
  80244e:	d3 ef                	shr    %cl,%edi
  802450:	09 d7                	or     %edx,%edi
  802452:	89 f2                	mov    %esi,%edx
  802454:	89 f8                	mov    %edi,%eax
  802456:	f7 74 24 08          	divl   0x8(%esp)
  80245a:	89 d6                	mov    %edx,%esi
  80245c:	89 c7                	mov    %eax,%edi
  80245e:	f7 24 24             	mull   (%esp)
  802461:	39 d6                	cmp    %edx,%esi
  802463:	89 14 24             	mov    %edx,(%esp)
  802466:	72 30                	jb     802498 <__udivdi3+0x118>
  802468:	8b 54 24 04          	mov    0x4(%esp),%edx
  80246c:	89 e9                	mov    %ebp,%ecx
  80246e:	d3 e2                	shl    %cl,%edx
  802470:	39 c2                	cmp    %eax,%edx
  802472:	73 05                	jae    802479 <__udivdi3+0xf9>
  802474:	3b 34 24             	cmp    (%esp),%esi
  802477:	74 1f                	je     802498 <__udivdi3+0x118>
  802479:	89 f8                	mov    %edi,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	e9 7a ff ff ff       	jmp    8023fc <__udivdi3+0x7c>
  802482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	b8 01 00 00 00       	mov    $0x1,%eax
  80248f:	e9 68 ff ff ff       	jmp    8023fc <__udivdi3+0x7c>
  802494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802498:	8d 47 ff             	lea    -0x1(%edi),%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	83 c4 0c             	add    $0xc,%esp
  8024a0:	5e                   	pop    %esi
  8024a1:	5f                   	pop    %edi
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    
  8024a4:	66 90                	xchg   %ax,%ax
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	66 90                	xchg   %ax,%ax
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	83 ec 14             	sub    $0x14,%esp
  8024b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8024c2:	89 c7                	mov    %eax,%edi
  8024c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8024cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8024d0:	89 34 24             	mov    %esi,(%esp)
  8024d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	89 c2                	mov    %eax,%edx
  8024db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024df:	75 17                	jne    8024f8 <__umoddi3+0x48>
  8024e1:	39 fe                	cmp    %edi,%esi
  8024e3:	76 4b                	jbe    802530 <__umoddi3+0x80>
  8024e5:	89 c8                	mov    %ecx,%eax
  8024e7:	89 fa                	mov    %edi,%edx
  8024e9:	f7 f6                	div    %esi
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	31 d2                	xor    %edx,%edx
  8024ef:	83 c4 14             	add    $0x14,%esp
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	39 f8                	cmp    %edi,%eax
  8024fa:	77 54                	ja     802550 <__umoddi3+0xa0>
  8024fc:	0f bd e8             	bsr    %eax,%ebp
  8024ff:	83 f5 1f             	xor    $0x1f,%ebp
  802502:	75 5c                	jne    802560 <__umoddi3+0xb0>
  802504:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802508:	39 3c 24             	cmp    %edi,(%esp)
  80250b:	0f 87 e7 00 00 00    	ja     8025f8 <__umoddi3+0x148>
  802511:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802515:	29 f1                	sub    %esi,%ecx
  802517:	19 c7                	sbb    %eax,%edi
  802519:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80251d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802521:	8b 44 24 08          	mov    0x8(%esp),%eax
  802525:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802529:	83 c4 14             	add    $0x14,%esp
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	85 f6                	test   %esi,%esi
  802532:	89 f5                	mov    %esi,%ebp
  802534:	75 0b                	jne    802541 <__umoddi3+0x91>
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f6                	div    %esi
  80253f:	89 c5                	mov    %eax,%ebp
  802541:	8b 44 24 04          	mov    0x4(%esp),%eax
  802545:	31 d2                	xor    %edx,%edx
  802547:	f7 f5                	div    %ebp
  802549:	89 c8                	mov    %ecx,%eax
  80254b:	f7 f5                	div    %ebp
  80254d:	eb 9c                	jmp    8024eb <__umoddi3+0x3b>
  80254f:	90                   	nop
  802550:	89 c8                	mov    %ecx,%eax
  802552:	89 fa                	mov    %edi,%edx
  802554:	83 c4 14             	add    $0x14,%esp
  802557:	5e                   	pop    %esi
  802558:	5f                   	pop    %edi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    
  80255b:	90                   	nop
  80255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802560:	8b 04 24             	mov    (%esp),%eax
  802563:	be 20 00 00 00       	mov    $0x20,%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	29 ee                	sub    %ebp,%esi
  80256c:	d3 e2                	shl    %cl,%edx
  80256e:	89 f1                	mov    %esi,%ecx
  802570:	d3 e8                	shr    %cl,%eax
  802572:	89 e9                	mov    %ebp,%ecx
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	8b 04 24             	mov    (%esp),%eax
  80257b:	09 54 24 04          	or     %edx,0x4(%esp)
  80257f:	89 fa                	mov    %edi,%edx
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 f1                	mov    %esi,%ecx
  802585:	89 44 24 08          	mov    %eax,0x8(%esp)
  802589:	8b 44 24 10          	mov    0x10(%esp),%eax
  80258d:	d3 ea                	shr    %cl,%edx
  80258f:	89 e9                	mov    %ebp,%ecx
  802591:	d3 e7                	shl    %cl,%edi
  802593:	89 f1                	mov    %esi,%ecx
  802595:	d3 e8                	shr    %cl,%eax
  802597:	89 e9                	mov    %ebp,%ecx
  802599:	09 f8                	or     %edi,%eax
  80259b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80259f:	f7 74 24 04          	divl   0x4(%esp)
  8025a3:	d3 e7                	shl    %cl,%edi
  8025a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a9:	89 d7                	mov    %edx,%edi
  8025ab:	f7 64 24 08          	mull   0x8(%esp)
  8025af:	39 d7                	cmp    %edx,%edi
  8025b1:	89 c1                	mov    %eax,%ecx
  8025b3:	89 14 24             	mov    %edx,(%esp)
  8025b6:	72 2c                	jb     8025e4 <__umoddi3+0x134>
  8025b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8025bc:	72 22                	jb     8025e0 <__umoddi3+0x130>
  8025be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8025c2:	29 c8                	sub    %ecx,%eax
  8025c4:	19 d7                	sbb    %edx,%edi
  8025c6:	89 e9                	mov    %ebp,%ecx
  8025c8:	89 fa                	mov    %edi,%edx
  8025ca:	d3 e8                	shr    %cl,%eax
  8025cc:	89 f1                	mov    %esi,%ecx
  8025ce:	d3 e2                	shl    %cl,%edx
  8025d0:	89 e9                	mov    %ebp,%ecx
  8025d2:	d3 ef                	shr    %cl,%edi
  8025d4:	09 d0                	or     %edx,%eax
  8025d6:	89 fa                	mov    %edi,%edx
  8025d8:	83 c4 14             	add    $0x14,%esp
  8025db:	5e                   	pop    %esi
  8025dc:	5f                   	pop    %edi
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    
  8025df:	90                   	nop
  8025e0:	39 d7                	cmp    %edx,%edi
  8025e2:	75 da                	jne    8025be <__umoddi3+0x10e>
  8025e4:	8b 14 24             	mov    (%esp),%edx
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8025ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025f1:	eb cb                	jmp    8025be <__umoddi3+0x10e>
  8025f3:	90                   	nop
  8025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025fc:	0f 82 0f ff ff ff    	jb     802511 <__umoddi3+0x61>
  802602:	e9 1a ff ff ff       	jmp    802521 <__umoddi3+0x71>
