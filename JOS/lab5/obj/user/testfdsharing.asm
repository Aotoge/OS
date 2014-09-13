
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 e8 01 00 00       	call   800219 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800043:	00 
  800044:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  80004b:	e8 c6 1b 00 00       	call   801c16 <open>
  800050:	89 c3                	mov    %eax,%ebx
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("open motd: %e", fd);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 25 27 80 	movl   $0x802725,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  800071:	e8 34 02 00 00       	call   8002aa <_panic>
	seek(fd, 0);
  800076:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007d:	00 
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 9a 18 00 00       	call   801920 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 20 42 80 	movl   $0x804220,0x4(%esp)
  800095:	00 
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 9a 17 00 00       	call   801838 <readn>
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	7f 20                	jg     8000c4 <umain+0x91>
		panic("readn: %e", n);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	c7 44 24 08 48 27 80 	movl   $0x802748,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  8000bf:	e8 e6 01 00 00       	call   8002aa <_panic>

	if ((r = fork()) < 0)
  8000c4:	e8 37 11 00 00       	call   801200 <fork>
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	79 20                	jns    8000ef <umain+0xbc>
		panic("fork: %e", r);
  8000cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d3:	c7 44 24 08 52 27 80 	movl   $0x802752,0x8(%esp)
  8000da:	00 
  8000db:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e2:	00 
  8000e3:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  8000ea:	e8 bb 01 00 00       	call   8002aa <_panic>
	if (r == 0) {
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	0f 85 bd 00 00 00    	jne    8001b4 <umain+0x181>
		seek(fd, 0);
  8000f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fe:	00 
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 19 18 00 00       	call   801920 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800107:	c7 04 24 90 27 80 00 	movl   $0x802790,(%esp)
  80010e:	e8 90 02 00 00       	call   8003a3 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800113:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011a:	00 
  80011b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800122:	00 
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 0d 17 00 00       	call   801838 <readn>
  80012b:	39 f8                	cmp    %edi,%eax
  80012d:	74 24                	je     800153 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  80012f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800133:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800137:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  80013e:	00 
  80013f:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800146:	00 
  800147:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  80014e:	e8 57 01 00 00       	call   8002aa <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 20 42 80 00 	movl   $0x804220,(%esp)
  800166:	e8 14 0b 00 00       	call   800c7f <memcmp>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 1c                	je     80018b <umain+0x158>
			panic("read in parent got different bytes from read in child");
  80016f:	c7 44 24 08 00 28 80 	movl   $0x802800,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017e:	00 
  80017f:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  800186:	e8 1f 01 00 00       	call   8002aa <_panic>
		cprintf("read in child succeeded\n");
  80018b:	c7 04 24 5b 27 80 00 	movl   $0x80275b,(%esp)
  800192:	e8 0c 02 00 00       	call   8003a3 <cprintf>
		seek(fd, 0);
  800197:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019e:	00 
  80019f:	89 1c 24             	mov    %ebx,(%esp)
  8001a2:	e8 79 17 00 00       	call   801920 <seek>
		close(fd);
  8001a7:	89 1c 24             	mov    %ebx,(%esp)
  8001aa:	e8 94 14 00 00       	call   801643 <close>
		exit();
  8001af:	e8 dd 00 00 00       	call   800291 <exit>
	}
	wait(r);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 93 1e 00 00       	call   80204f <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  8001cb:	00 
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 64 16 00 00       	call   801838 <readn>
  8001d4:	39 f8                	cmp    %edi,%eax
  8001d6:	74 24                	je     8001fc <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e0:	c7 44 24 08 38 28 80 	movl   $0x802838,0x8(%esp)
  8001e7:	00 
  8001e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001ef:	00 
  8001f0:	c7 04 24 33 27 80 00 	movl   $0x802733,(%esp)
  8001f7:	e8 ae 00 00 00       	call   8002aa <_panic>
	cprintf("read in parent succeeded\n");
  8001fc:	c7 04 24 74 27 80 00 	movl   $0x802774,(%esp)
  800203:	e8 9b 01 00 00       	call   8003a3 <cprintf>
	close(fd);
  800208:	89 1c 24             	mov    %ebx,(%esp)
  80020b:	e8 33 14 00 00       	call   801643 <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800210:	cc                   	int3   

	breakpoint();
}
  800211:	83 c4 2c             	add    $0x2c,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 10             	sub    $0x10,%esp
  800221:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800227:	e8 3f 0c 00 00       	call   800e6b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80022c:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 17                	je     80024d <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800236:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80023b:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80023e:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800244:	8b 49 40             	mov    0x40(%ecx),%ecx
  800247:	39 c1                	cmp    %eax,%ecx
  800249:	75 18                	jne    800263 <libmain+0x4a>
  80024b:	eb 05                	jmp    800252 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80024d:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800252:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800255:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80025b:	89 15 20 44 80 00    	mov    %edx,0x804420
			break;
  800261:	eb 0b                	jmp    80026e <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800263:	83 c2 01             	add    $0x1,%edx
  800266:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80026c:	75 cd                	jne    80023b <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80026e:	85 db                	test   %ebx,%ebx
  800270:	7e 07                	jle    800279 <libmain+0x60>
		binaryname = argv[0];
  800272:	8b 06                	mov    (%esi),%eax
  800274:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800279:	89 74 24 04          	mov    %esi,0x4(%esp)
  80027d:	89 1c 24             	mov    %ebx,(%esp)
  800280:	e8 ae fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800285:	e8 07 00 00 00       	call   800291 <exit>
}
  80028a:	83 c4 10             	add    $0x10,%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5d                   	pop    %ebp
  800290:	c3                   	ret    

00800291 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800297:	e8 da 13 00 00       	call   801676 <close_all>
	sys_env_destroy(0);
  80029c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a3:	e8 71 0b 00 00       	call   800e19 <sys_env_destroy>
}
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002b2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002bb:	e8 ab 0b 00 00       	call   800e6b <sys_getenvid>
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ce:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	c7 04 24 68 28 80 00 	movl   $0x802868,(%esp)
  8002dd:	e8 c1 00 00 00       	call   8003a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	89 04 24             	mov    %eax,(%esp)
  8002ec:	e8 51 00 00 00       	call   800342 <vcprintf>
	cprintf("\n");
  8002f1:	c7 04 24 72 27 80 00 	movl   $0x802772,(%esp)
  8002f8:	e8 a6 00 00 00       	call   8003a3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002fd:	cc                   	int3   
  8002fe:	eb fd                	jmp    8002fd <_panic+0x53>

00800300 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	53                   	push   %ebx
  800304:	83 ec 14             	sub    $0x14,%esp
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030a:	8b 13                	mov    (%ebx),%edx
  80030c:	8d 42 01             	lea    0x1(%edx),%eax
  80030f:	89 03                	mov    %eax,(%ebx)
  800311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800314:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800318:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031d:	75 19                	jne    800338 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80031f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800326:	00 
  800327:	8d 43 08             	lea    0x8(%ebx),%eax
  80032a:	89 04 24             	mov    %eax,(%esp)
  80032d:	e8 aa 0a 00 00       	call   800ddc <sys_cputs>
		b->idx = 0;
  800332:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800338:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80033c:	83 c4 14             	add    $0x14,%esp
  80033f:	5b                   	pop    %ebx
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80034b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800352:	00 00 00 
	b.cnt = 0;
  800355:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80035c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800373:	89 44 24 04          	mov    %eax,0x4(%esp)
  800377:	c7 04 24 00 03 80 00 	movl   $0x800300,(%esp)
  80037e:	e8 b1 01 00 00       	call   800534 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800383:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800393:	89 04 24             	mov    %eax,(%esp)
  800396:	e8 41 0a 00 00       	call   800ddc <sys_cputs>

	return b.cnt;
}
  80039b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003a9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 04 24             	mov    %eax,(%esp)
  8003b6:	e8 87 ff ff ff       	call   800342 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    
  8003bd:	66 90                	xchg   %ax,%ax
  8003bf:	90                   	nop

008003c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	57                   	push   %edi
  8003c4:	56                   	push   %esi
  8003c5:	53                   	push   %ebx
  8003c6:	83 ec 3c             	sub    $0x3c,%esp
  8003c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cc:	89 d7                	mov    %edx,%edi
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8003da:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003e8:	39 f1                	cmp    %esi,%ecx
  8003ea:	72 14                	jb     800400 <printnum+0x40>
  8003ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003ef:	76 0f                	jbe    800400 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8003f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8003fa:	85 f6                	test   %esi,%esi
  8003fc:	7f 60                	jg     80045e <printnum+0x9e>
  8003fe:	eb 72                	jmp    800472 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800400:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800403:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800407:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80040a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80040d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800411:	89 44 24 08          	mov    %eax,0x8(%esp)
  800415:	8b 44 24 08          	mov    0x8(%esp),%eax
  800419:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80041d:	89 c3                	mov    %eax,%ebx
  80041f:	89 d6                	mov    %edx,%esi
  800421:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800424:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800427:	89 54 24 08          	mov    %edx,0x8(%esp)
  80042b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80042f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800432:	89 04 24             	mov    %eax,(%esp)
  800435:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043c:	e8 4f 20 00 00       	call   802490 <__udivdi3>
  800441:	89 d9                	mov    %ebx,%ecx
  800443:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800447:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80044b:	89 04 24             	mov    %eax,(%esp)
  80044e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800452:	89 fa                	mov    %edi,%edx
  800454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800457:	e8 64 ff ff ff       	call   8003c0 <printnum>
  80045c:	eb 14                	jmp    800472 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80045e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800462:	8b 45 18             	mov    0x18(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046a:	83 ee 01             	sub    $0x1,%esi
  80046d:	75 ef                	jne    80045e <printnum+0x9e>
  80046f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800472:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800476:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80047a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800480:	89 44 24 08          	mov    %eax,0x8(%esp)
  800484:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	89 04 24             	mov    %eax,(%esp)
  80048e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800491:	89 44 24 04          	mov    %eax,0x4(%esp)
  800495:	e8 26 21 00 00       	call   8025c0 <__umoddi3>
  80049a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049e:	0f be 80 8b 28 80 00 	movsbl 0x80288b(%eax),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ab:	ff d0                	call   *%eax
}
  8004ad:	83 c4 3c             	add    $0x3c,%esp
  8004b0:	5b                   	pop    %ebx
  8004b1:	5e                   	pop    %esi
  8004b2:	5f                   	pop    %edi
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b8:	83 fa 01             	cmp    $0x1,%edx
  8004bb:	7e 0e                	jle    8004cb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004bd:	8b 10                	mov    (%eax),%edx
  8004bf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004c2:	89 08                	mov    %ecx,(%eax)
  8004c4:	8b 02                	mov    (%edx),%eax
  8004c6:	8b 52 04             	mov    0x4(%edx),%edx
  8004c9:	eb 22                	jmp    8004ed <getuint+0x38>
	else if (lflag)
  8004cb:	85 d2                	test   %edx,%edx
  8004cd:	74 10                	je     8004df <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004cf:	8b 10                	mov    (%eax),%edx
  8004d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004d4:	89 08                	mov    %ecx,(%eax)
  8004d6:	8b 02                	mov    (%edx),%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	eb 0e                	jmp    8004ed <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004df:	8b 10                	mov    (%eax),%edx
  8004e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004e4:	89 08                	mov    %ecx,(%eax)
  8004e6:	8b 02                	mov    (%edx),%eax
  8004e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ed:	5d                   	pop    %ebp
  8004ee:	c3                   	ret    

008004ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f9:	8b 10                	mov    (%eax),%edx
  8004fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fe:	73 0a                	jae    80050a <sprintputch+0x1b>
		*b->buf++ = ch;
  800500:	8d 4a 01             	lea    0x1(%edx),%ecx
  800503:	89 08                	mov    %ecx,(%eax)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	88 02                	mov    %al,(%edx)
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800512:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800515:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800519:	8b 45 10             	mov    0x10(%ebp),%eax
  80051c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	89 44 24 04          	mov    %eax,0x4(%esp)
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	89 04 24             	mov    %eax,(%esp)
  80052d:	e8 02 00 00 00       	call   800534 <vprintfmt>
	va_end(ap);
}
  800532:	c9                   	leave  
  800533:	c3                   	ret    

00800534 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
  800537:	57                   	push   %edi
  800538:	56                   	push   %esi
  800539:	53                   	push   %ebx
  80053a:	83 ec 3c             	sub    $0x3c,%esp
  80053d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800540:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800543:	eb 18                	jmp    80055d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800545:	85 c0                	test   %eax,%eax
  800547:	0f 84 c3 03 00 00    	je     800910 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80054d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800557:	89 f3                	mov    %esi,%ebx
  800559:	eb 02                	jmp    80055d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80055b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	8d 73 01             	lea    0x1(%ebx),%esi
  800560:	0f b6 03             	movzbl (%ebx),%eax
  800563:	83 f8 25             	cmp    $0x25,%eax
  800566:	75 dd                	jne    800545 <vprintfmt+0x11>
  800568:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80056c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800573:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80057a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
  800586:	eb 1d                	jmp    8005a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800588:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80058a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80058e:	eb 15                	jmp    8005a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800590:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800592:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800596:	eb 0d                	jmp    8005a5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80059b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8005a8:	0f b6 06             	movzbl (%esi),%eax
  8005ab:	0f b6 c8             	movzbl %al,%ecx
  8005ae:	83 e8 23             	sub    $0x23,%eax
  8005b1:	3c 55                	cmp    $0x55,%al
  8005b3:	0f 87 2f 03 00 00    	ja     8008e8 <vprintfmt+0x3b4>
  8005b9:	0f b6 c0             	movzbl %al,%eax
  8005bc:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005c3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8005c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8005c9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8005cd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8005d0:	83 f9 09             	cmp    $0x9,%ecx
  8005d3:	77 50                	ja     800625 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	89 de                	mov    %ebx,%esi
  8005d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005da:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8005dd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005e0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005e4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005e7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ea:	83 fb 09             	cmp    $0x9,%ebx
  8005ed:	76 eb                	jbe    8005da <vprintfmt+0xa6>
  8005ef:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f2:	eb 33                	jmp    800627 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 48 04             	lea    0x4(%eax),%ecx
  8005fa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800602:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800604:	eb 21                	jmp    800627 <vprintfmt+0xf3>
  800606:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800609:	85 c9                	test   %ecx,%ecx
  80060b:	b8 00 00 00 00       	mov    $0x0,%eax
  800610:	0f 49 c1             	cmovns %ecx,%eax
  800613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800616:	89 de                	mov    %ebx,%esi
  800618:	eb 8b                	jmp    8005a5 <vprintfmt+0x71>
  80061a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80061c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800623:	eb 80                	jmp    8005a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800625:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062b:	0f 89 74 ff ff ff    	jns    8005a5 <vprintfmt+0x71>
  800631:	e9 62 ff ff ff       	jmp    800598 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800636:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800639:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80063b:	e9 65 ff ff ff       	jmp    8005a5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 50 04             	lea    0x4(%eax),%edx
  800646:	89 55 14             	mov    %edx,0x14(%ebp)
  800649:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	89 04 24             	mov    %eax,(%esp)
  800652:	ff 55 08             	call   *0x8(%ebp)
			break;
  800655:	e9 03 ff ff ff       	jmp    80055d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 50 04             	lea    0x4(%eax),%edx
  800660:	89 55 14             	mov    %edx,0x14(%ebp)
  800663:	8b 00                	mov    (%eax),%eax
  800665:	99                   	cltd   
  800666:	31 d0                	xor    %edx,%eax
  800668:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80066a:	83 f8 0f             	cmp    $0xf,%eax
  80066d:	7f 0b                	jg     80067a <vprintfmt+0x146>
  80066f:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  800676:	85 d2                	test   %edx,%edx
  800678:	75 20                	jne    80069a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80067a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067e:	c7 44 24 08 a3 28 80 	movl   $0x8028a3,0x8(%esp)
  800685:	00 
  800686:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 04 24             	mov    %eax,(%esp)
  800690:	e8 77 fe ff ff       	call   80050c <printfmt>
  800695:	e9 c3 fe ff ff       	jmp    80055d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80069a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80069e:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  8006a5:	00 
  8006a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 04 24             	mov    %eax,(%esp)
  8006b0:	e8 57 fe ff ff       	call   80050c <printfmt>
  8006b5:	e9 a3 fe ff ff       	jmp    80055d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006bd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 50 04             	lea    0x4(%eax),%edx
  8006c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	ba 9c 28 80 00       	mov    $0x80289c,%edx
  8006d2:	0f 45 d0             	cmovne %eax,%edx
  8006d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8006d8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8006dc:	74 04                	je     8006e2 <vprintfmt+0x1ae>
  8006de:	85 f6                	test   %esi,%esi
  8006e0:	7f 19                	jg     8006fb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006e5:	8d 70 01             	lea    0x1(%eax),%esi
  8006e8:	0f b6 10             	movzbl (%eax),%edx
  8006eb:	0f be c2             	movsbl %dl,%eax
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	0f 85 95 00 00 00    	jne    80078b <vprintfmt+0x257>
  8006f6:	e9 85 00 00 00       	jmp    800780 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800702:	89 04 24             	mov    %eax,(%esp)
  800705:	e8 b8 02 00 00       	call   8009c2 <strnlen>
  80070a:	29 c6                	sub    %eax,%esi
  80070c:	89 f0                	mov    %esi,%eax
  80070e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800711:	85 f6                	test   %esi,%esi
  800713:	7e cd                	jle    8006e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800715:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800719:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80071c:	89 c3                	mov    %eax,%ebx
  80071e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800722:	89 34 24             	mov    %esi,(%esp)
  800725:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800728:	83 eb 01             	sub    $0x1,%ebx
  80072b:	75 f1                	jne    80071e <vprintfmt+0x1ea>
  80072d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800730:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800733:	eb ad                	jmp    8006e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800735:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800739:	74 1e                	je     800759 <vprintfmt+0x225>
  80073b:	0f be d2             	movsbl %dl,%edx
  80073e:	83 ea 20             	sub    $0x20,%edx
  800741:	83 fa 5e             	cmp    $0x5e,%edx
  800744:	76 13                	jbe    800759 <vprintfmt+0x225>
					putch('?', putdat);
  800746:	8b 45 0c             	mov    0xc(%ebp),%eax
  800749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800754:	ff 55 08             	call   *0x8(%ebp)
  800757:	eb 0d                	jmp    800766 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80075c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800760:	89 04 24             	mov    %eax,(%esp)
  800763:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800766:	83 ef 01             	sub    $0x1,%edi
  800769:	83 c6 01             	add    $0x1,%esi
  80076c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800770:	0f be c2             	movsbl %dl,%eax
  800773:	85 c0                	test   %eax,%eax
  800775:	75 20                	jne    800797 <vprintfmt+0x263>
  800777:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80077a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80077d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800784:	7f 25                	jg     8007ab <vprintfmt+0x277>
  800786:	e9 d2 fd ff ff       	jmp    80055d <vprintfmt+0x29>
  80078b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80078e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800791:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800794:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800797:	85 db                	test   %ebx,%ebx
  800799:	78 9a                	js     800735 <vprintfmt+0x201>
  80079b:	83 eb 01             	sub    $0x1,%ebx
  80079e:	79 95                	jns    800735 <vprintfmt+0x201>
  8007a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8007a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007a9:	eb d5                	jmp    800780 <vprintfmt+0x24c>
  8007ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007bf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c1:	83 eb 01             	sub    $0x1,%ebx
  8007c4:	75 ee                	jne    8007b4 <vprintfmt+0x280>
  8007c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007c9:	e9 8f fd ff ff       	jmp    80055d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ce:	83 fa 01             	cmp    $0x1,%edx
  8007d1:	7e 16                	jle    8007e9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 50 08             	lea    0x8(%eax),%edx
  8007d9:	89 55 14             	mov    %edx,0x14(%ebp)
  8007dc:	8b 50 04             	mov    0x4(%eax),%edx
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	eb 32                	jmp    80081b <vprintfmt+0x2e7>
	else if (lflag)
  8007e9:	85 d2                	test   %edx,%edx
  8007eb:	74 18                	je     800805 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8d 50 04             	lea    0x4(%eax),%edx
  8007f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f6:	8b 30                	mov    (%eax),%esi
  8007f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007fb:	89 f0                	mov    %esi,%eax
  8007fd:	c1 f8 1f             	sar    $0x1f,%eax
  800800:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800803:	eb 16                	jmp    80081b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8d 50 04             	lea    0x4(%eax),%edx
  80080b:	89 55 14             	mov    %edx,0x14(%ebp)
  80080e:	8b 30                	mov    (%eax),%esi
  800810:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800813:	89 f0                	mov    %esi,%eax
  800815:	c1 f8 1f             	sar    $0x1f,%eax
  800818:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800821:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800826:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80082a:	0f 89 80 00 00 00    	jns    8008b0 <vprintfmt+0x37c>
				putch('-', putdat);
  800830:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800834:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80083b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80083e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800841:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800844:	f7 d8                	neg    %eax
  800846:	83 d2 00             	adc    $0x0,%edx
  800849:	f7 da                	neg    %edx
			}
			base = 10;
  80084b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800850:	eb 5e                	jmp    8008b0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800852:	8d 45 14             	lea    0x14(%ebp),%eax
  800855:	e8 5b fc ff ff       	call   8004b5 <getuint>
			base = 10;
  80085a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80085f:	eb 4f                	jmp    8008b0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800861:	8d 45 14             	lea    0x14(%ebp),%eax
  800864:	e8 4c fc ff ff       	call   8004b5 <getuint>
			base = 8;
  800869:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80086e:	eb 40                	jmp    8008b0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800870:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800874:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80087b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80087e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800882:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800889:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 50 04             	lea    0x4(%eax),%edx
  800892:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80089c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8008a1:	eb 0d                	jmp    8008b0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a6:	e8 0a fc ff ff       	call   8004b5 <getuint>
			base = 16;
  8008ab:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8008b4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8008bb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008c3:	89 04 24             	mov    %eax,(%esp)
  8008c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008ca:	89 fa                	mov    %edi,%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	e8 ec fa ff ff       	call   8003c0 <printnum>
			break;
  8008d4:	e9 84 fc ff ff       	jmp    80055d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008dd:	89 0c 24             	mov    %ecx,(%esp)
  8008e0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008e3:	e9 75 fc ff ff       	jmp    80055d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ec:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008f3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008fa:	0f 84 5b fc ff ff    	je     80055b <vprintfmt+0x27>
  800900:	89 f3                	mov    %esi,%ebx
  800902:	83 eb 01             	sub    $0x1,%ebx
  800905:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800909:	75 f7                	jne    800902 <vprintfmt+0x3ce>
  80090b:	e9 4d fc ff ff       	jmp    80055d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800910:	83 c4 3c             	add    $0x3c,%esp
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5f                   	pop    %edi
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 28             	sub    $0x28,%esp
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800924:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800927:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800935:	85 c0                	test   %eax,%eax
  800937:	74 30                	je     800969 <vsnprintf+0x51>
  800939:	85 d2                	test   %edx,%edx
  80093b:	7e 2c                	jle    800969 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800944:	8b 45 10             	mov    0x10(%ebp),%eax
  800947:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800952:	c7 04 24 ef 04 80 00 	movl   $0x8004ef,(%esp)
  800959:	e8 d6 fb ff ff       	call   800534 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800961:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800967:	eb 05                	jmp    80096e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800969:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800976:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800979:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80097d:	8b 45 10             	mov    0x10(%ebp),%eax
  800980:	89 44 24 08          	mov    %eax,0x8(%esp)
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 04 24             	mov    %eax,(%esp)
  800991:	e8 82 ff ff ff       	call   800918 <vsnprintf>
	va_end(ap);

	return rc;
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    
  800998:	66 90                	xchg   %ax,%ax
  80099a:	66 90                	xchg   %ax,%ax
  80099c:	66 90                	xchg   %ax,%ax
  80099e:	66 90                	xchg   %ax,%ax

008009a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a6:	80 3a 00             	cmpb   $0x0,(%edx)
  8009a9:	74 10                	je     8009bb <strlen+0x1b>
  8009ab:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b7:	75 f7                	jne    8009b0 <strlen+0x10>
  8009b9:	eb 05                	jmp    8009c0 <strlen+0x20>
  8009bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cc:	85 c9                	test   %ecx,%ecx
  8009ce:	74 1c                	je     8009ec <strnlen+0x2a>
  8009d0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009d3:	74 1e                	je     8009f3 <strnlen+0x31>
  8009d5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8009da:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009dc:	39 ca                	cmp    %ecx,%edx
  8009de:	74 18                	je     8009f8 <strnlen+0x36>
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8009e8:	75 f0                	jne    8009da <strnlen+0x18>
  8009ea:	eb 0c                	jmp    8009f8 <strnlen+0x36>
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	eb 05                	jmp    8009f8 <strnlen+0x36>
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a11:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a14:	84 db                	test   %bl,%bl
  800a16:	75 ef                	jne    800a07 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a18:	5b                   	pop    %ebx
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	53                   	push   %ebx
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a25:	89 1c 24             	mov    %ebx,(%esp)
  800a28:	e8 73 ff ff ff       	call   8009a0 <strlen>
	strcpy(dst + len, src);
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a30:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a34:	01 d8                	add    %ebx,%eax
  800a36:	89 04 24             	mov    %eax,(%esp)
  800a39:	e8 bd ff ff ff       	call   8009fb <strcpy>
	return dst;
}
  800a3e:	89 d8                	mov    %ebx,%eax
  800a40:	83 c4 08             	add    $0x8,%esp
  800a43:	5b                   	pop    %ebx
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	74 17                	je     800a6f <strncpy+0x29>
  800a58:	01 f3                	add    %esi,%ebx
  800a5a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800a5c:	83 c1 01             	add    $0x1,%ecx
  800a5f:	0f b6 02             	movzbl (%edx),%eax
  800a62:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a65:	80 3a 01             	cmpb   $0x1,(%edx)
  800a68:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6b:	39 d9                	cmp    %ebx,%ecx
  800a6d:	75 ed                	jne    800a5c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a6f:	89 f0                	mov    %esi,%eax
  800a71:	5b                   	pop    %ebx
  800a72:	5e                   	pop    %esi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	57                   	push   %edi
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a81:	8b 75 10             	mov    0x10(%ebp),%esi
  800a84:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a86:	85 f6                	test   %esi,%esi
  800a88:	74 34                	je     800abe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800a8a:	83 fe 01             	cmp    $0x1,%esi
  800a8d:	74 26                	je     800ab5 <strlcpy+0x40>
  800a8f:	0f b6 0b             	movzbl (%ebx),%ecx
  800a92:	84 c9                	test   %cl,%cl
  800a94:	74 23                	je     800ab9 <strlcpy+0x44>
  800a96:	83 ee 02             	sub    $0x2,%esi
  800a99:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800a9e:	83 c0 01             	add    $0x1,%eax
  800aa1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa4:	39 f2                	cmp    %esi,%edx
  800aa6:	74 13                	je     800abb <strlcpy+0x46>
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aaf:	84 c9                	test   %cl,%cl
  800ab1:	75 eb                	jne    800a9e <strlcpy+0x29>
  800ab3:	eb 06                	jmp    800abb <strlcpy+0x46>
  800ab5:	89 f8                	mov    %edi,%eax
  800ab7:	eb 02                	jmp    800abb <strlcpy+0x46>
  800ab9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800abb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abe:	29 f8                	sub    %edi,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ace:	0f b6 01             	movzbl (%ecx),%eax
  800ad1:	84 c0                	test   %al,%al
  800ad3:	74 15                	je     800aea <strcmp+0x25>
  800ad5:	3a 02                	cmp    (%edx),%al
  800ad7:	75 11                	jne    800aea <strcmp+0x25>
		p++, q++;
  800ad9:	83 c1 01             	add    $0x1,%ecx
  800adc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800adf:	0f b6 01             	movzbl (%ecx),%eax
  800ae2:	84 c0                	test   %al,%al
  800ae4:	74 04                	je     800aea <strcmp+0x25>
  800ae6:	3a 02                	cmp    (%edx),%al
  800ae8:	74 ef                	je     800ad9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aea:	0f b6 c0             	movzbl %al,%eax
  800aed:	0f b6 12             	movzbl (%edx),%edx
  800af0:	29 d0                	sub    %edx,%eax
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aff:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800b02:	85 f6                	test   %esi,%esi
  800b04:	74 29                	je     800b2f <strncmp+0x3b>
  800b06:	0f b6 03             	movzbl (%ebx),%eax
  800b09:	84 c0                	test   %al,%al
  800b0b:	74 30                	je     800b3d <strncmp+0x49>
  800b0d:	3a 02                	cmp    (%edx),%al
  800b0f:	75 2c                	jne    800b3d <strncmp+0x49>
  800b11:	8d 43 01             	lea    0x1(%ebx),%eax
  800b14:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800b16:	89 c3                	mov    %eax,%ebx
  800b18:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b1b:	39 f0                	cmp    %esi,%eax
  800b1d:	74 17                	je     800b36 <strncmp+0x42>
  800b1f:	0f b6 08             	movzbl (%eax),%ecx
  800b22:	84 c9                	test   %cl,%cl
  800b24:	74 17                	je     800b3d <strncmp+0x49>
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	3a 0a                	cmp    (%edx),%cl
  800b2b:	74 e9                	je     800b16 <strncmp+0x22>
  800b2d:	eb 0e                	jmp    800b3d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	eb 0f                	jmp    800b45 <strncmp+0x51>
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	eb 08                	jmp    800b45 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3d:	0f b6 03             	movzbl (%ebx),%eax
  800b40:	0f b6 12             	movzbl (%edx),%edx
  800b43:	29 d0                	sub    %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b53:	0f b6 18             	movzbl (%eax),%ebx
  800b56:	84 db                	test   %bl,%bl
  800b58:	74 1d                	je     800b77 <strchr+0x2e>
  800b5a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b5c:	38 d3                	cmp    %dl,%bl
  800b5e:	75 06                	jne    800b66 <strchr+0x1d>
  800b60:	eb 1a                	jmp    800b7c <strchr+0x33>
  800b62:	38 ca                	cmp    %cl,%dl
  800b64:	74 16                	je     800b7c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	0f b6 10             	movzbl (%eax),%edx
  800b6c:	84 d2                	test   %dl,%dl
  800b6e:	75 f2                	jne    800b62 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
  800b75:	eb 05                	jmp    800b7c <strchr+0x33>
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7c:	5b                   	pop    %ebx
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b89:	0f b6 18             	movzbl (%eax),%ebx
  800b8c:	84 db                	test   %bl,%bl
  800b8e:	74 16                	je     800ba6 <strfind+0x27>
  800b90:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b92:	38 d3                	cmp    %dl,%bl
  800b94:	75 06                	jne    800b9c <strfind+0x1d>
  800b96:	eb 0e                	jmp    800ba6 <strfind+0x27>
  800b98:	38 ca                	cmp    %cl,%dl
  800b9a:	74 0a                	je     800ba6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b9c:	83 c0 01             	add    $0x1,%eax
  800b9f:	0f b6 10             	movzbl (%eax),%edx
  800ba2:	84 d2                	test   %dl,%dl
  800ba4:	75 f2                	jne    800b98 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb5:	85 c9                	test   %ecx,%ecx
  800bb7:	74 36                	je     800bef <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bbf:	75 28                	jne    800be9 <memset+0x40>
  800bc1:	f6 c1 03             	test   $0x3,%cl
  800bc4:	75 23                	jne    800be9 <memset+0x40>
		c &= 0xFF;
  800bc6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bca:	89 d3                	mov    %edx,%ebx
  800bcc:	c1 e3 08             	shl    $0x8,%ebx
  800bcf:	89 d6                	mov    %edx,%esi
  800bd1:	c1 e6 18             	shl    $0x18,%esi
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	c1 e0 10             	shl    $0x10,%eax
  800bd9:	09 f0                	or     %esi,%eax
  800bdb:	09 c2                	or     %eax,%edx
  800bdd:	89 d0                	mov    %edx,%eax
  800bdf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800be1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800be4:	fc                   	cld    
  800be5:	f3 ab                	rep stos %eax,%es:(%edi)
  800be7:	eb 06                	jmp    800bef <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	fc                   	cld    
  800bed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bef:	89 f8                	mov    %edi,%eax
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c04:	39 c6                	cmp    %eax,%esi
  800c06:	73 35                	jae    800c3d <memmove+0x47>
  800c08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c0b:	39 d0                	cmp    %edx,%eax
  800c0d:	73 2e                	jae    800c3d <memmove+0x47>
		s += n;
		d += n;
  800c0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c12:	89 d6                	mov    %edx,%esi
  800c14:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1c:	75 13                	jne    800c31 <memmove+0x3b>
  800c1e:	f6 c1 03             	test   $0x3,%cl
  800c21:	75 0e                	jne    800c31 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c23:	83 ef 04             	sub    $0x4,%edi
  800c26:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c29:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c2c:	fd                   	std    
  800c2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2f:	eb 09                	jmp    800c3a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c31:	83 ef 01             	sub    $0x1,%edi
  800c34:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c37:	fd                   	std    
  800c38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c3a:	fc                   	cld    
  800c3b:	eb 1d                	jmp    800c5a <memmove+0x64>
  800c3d:	89 f2                	mov    %esi,%edx
  800c3f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c41:	f6 c2 03             	test   $0x3,%dl
  800c44:	75 0f                	jne    800c55 <memmove+0x5f>
  800c46:	f6 c1 03             	test   $0x3,%cl
  800c49:	75 0a                	jne    800c55 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c4b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c4e:	89 c7                	mov    %eax,%edi
  800c50:	fc                   	cld    
  800c51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c53:	eb 05                	jmp    800c5a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c55:	89 c7                	mov    %eax,%edi
  800c57:	fc                   	cld    
  800c58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 04 24             	mov    %eax,(%esp)
  800c78:	e8 79 ff ff ff       	call   800bf6 <memmove>
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c8e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800c91:	85 c0                	test   %eax,%eax
  800c93:	74 36                	je     800ccb <memcmp+0x4c>
		if (*s1 != *s2)
  800c95:	0f b6 03             	movzbl (%ebx),%eax
  800c98:	0f b6 0e             	movzbl (%esi),%ecx
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	38 c8                	cmp    %cl,%al
  800ca2:	74 1c                	je     800cc0 <memcmp+0x41>
  800ca4:	eb 10                	jmp    800cb6 <memcmp+0x37>
  800ca6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800cab:	83 c2 01             	add    $0x1,%edx
  800cae:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800cb2:	38 c8                	cmp    %cl,%al
  800cb4:	74 0a                	je     800cc0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800cb6:	0f b6 c0             	movzbl %al,%eax
  800cb9:	0f b6 c9             	movzbl %cl,%ecx
  800cbc:	29 c8                	sub    %ecx,%eax
  800cbe:	eb 10                	jmp    800cd0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cc0:	39 fa                	cmp    %edi,%edx
  800cc2:	75 e2                	jne    800ca6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc9:	eb 05                	jmp    800cd0 <memcmp+0x51>
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	53                   	push   %ebx
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800cdf:	89 c2                	mov    %eax,%edx
  800ce1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ce4:	39 d0                	cmp    %edx,%eax
  800ce6:	73 13                	jae    800cfb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce8:	89 d9                	mov    %ebx,%ecx
  800cea:	38 18                	cmp    %bl,(%eax)
  800cec:	75 06                	jne    800cf4 <memfind+0x1f>
  800cee:	eb 0b                	jmp    800cfb <memfind+0x26>
  800cf0:	38 08                	cmp    %cl,(%eax)
  800cf2:	74 07                	je     800cfb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cf4:	83 c0 01             	add    $0x1,%eax
  800cf7:	39 d0                	cmp    %edx,%eax
  800cf9:	75 f5                	jne    800cf0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0a:	0f b6 0a             	movzbl (%edx),%ecx
  800d0d:	80 f9 09             	cmp    $0x9,%cl
  800d10:	74 05                	je     800d17 <strtol+0x19>
  800d12:	80 f9 20             	cmp    $0x20,%cl
  800d15:	75 10                	jne    800d27 <strtol+0x29>
		s++;
  800d17:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1a:	0f b6 0a             	movzbl (%edx),%ecx
  800d1d:	80 f9 09             	cmp    $0x9,%cl
  800d20:	74 f5                	je     800d17 <strtol+0x19>
  800d22:	80 f9 20             	cmp    $0x20,%cl
  800d25:	74 f0                	je     800d17 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d27:	80 f9 2b             	cmp    $0x2b,%cl
  800d2a:	75 0a                	jne    800d36 <strtol+0x38>
		s++;
  800d2c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d34:	eb 11                	jmp    800d47 <strtol+0x49>
  800d36:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d3b:	80 f9 2d             	cmp    $0x2d,%cl
  800d3e:	75 07                	jne    800d47 <strtol+0x49>
		s++, neg = 1;
  800d40:	83 c2 01             	add    $0x1,%edx
  800d43:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d47:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d4c:	75 15                	jne    800d63 <strtol+0x65>
  800d4e:	80 3a 30             	cmpb   $0x30,(%edx)
  800d51:	75 10                	jne    800d63 <strtol+0x65>
  800d53:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d57:	75 0a                	jne    800d63 <strtol+0x65>
		s += 2, base = 16;
  800d59:	83 c2 02             	add    $0x2,%edx
  800d5c:	b8 10 00 00 00       	mov    $0x10,%eax
  800d61:	eb 10                	jmp    800d73 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 0c                	jne    800d73 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d67:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d69:	80 3a 30             	cmpb   $0x30,(%edx)
  800d6c:	75 05                	jne    800d73 <strtol+0x75>
		s++, base = 8;
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d78:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d7b:	0f b6 0a             	movzbl (%edx),%ecx
  800d7e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d81:	89 f0                	mov    %esi,%eax
  800d83:	3c 09                	cmp    $0x9,%al
  800d85:	77 08                	ja     800d8f <strtol+0x91>
			dig = *s - '0';
  800d87:	0f be c9             	movsbl %cl,%ecx
  800d8a:	83 e9 30             	sub    $0x30,%ecx
  800d8d:	eb 20                	jmp    800daf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800d8f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d92:	89 f0                	mov    %esi,%eax
  800d94:	3c 19                	cmp    $0x19,%al
  800d96:	77 08                	ja     800da0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800d98:	0f be c9             	movsbl %cl,%ecx
  800d9b:	83 e9 57             	sub    $0x57,%ecx
  800d9e:	eb 0f                	jmp    800daf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800da0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800da3:	89 f0                	mov    %esi,%eax
  800da5:	3c 19                	cmp    $0x19,%al
  800da7:	77 16                	ja     800dbf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da9:	0f be c9             	movsbl %cl,%ecx
  800dac:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800daf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800db2:	7d 0f                	jge    800dc3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800db4:	83 c2 01             	add    $0x1,%edx
  800db7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dbb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dbd:	eb bc                	jmp    800d7b <strtol+0x7d>
  800dbf:	89 d8                	mov    %ebx,%eax
  800dc1:	eb 02                	jmp    800dc5 <strtol+0xc7>
  800dc3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc9:	74 05                	je     800dd0 <strtol+0xd2>
		*endptr = (char *) s;
  800dcb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dce:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dd0:	f7 d8                	neg    %eax
  800dd2:	85 ff                	test   %edi,%edi
  800dd4:	0f 44 c3             	cmove  %ebx,%eax
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de2:	b8 00 00 00 00       	mov    $0x0,%eax
  800de7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	89 c3                	mov    %eax,%ebx
  800def:	89 c7                	mov    %eax,%edi
  800df1:	89 c6                	mov    %eax,%esi
  800df3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <sys_cgetc>:

int
sys_cgetc(void)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e00:	ba 00 00 00 00       	mov    $0x0,%edx
  800e05:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0a:	89 d1                	mov    %edx,%ecx
  800e0c:	89 d3                	mov    %edx,%ebx
  800e0e:	89 d7                	mov    %edx,%edi
  800e10:	89 d6                	mov    %edx,%esi
  800e12:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e27:	b8 03 00 00 00       	mov    $0x3,%eax
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	89 cb                	mov    %ecx,%ebx
  800e31:	89 cf                	mov    %ecx,%edi
  800e33:	89 ce                	mov    %ecx,%esi
  800e35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	7e 28                	jle    800e63 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e46:	00 
  800e47:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e56:	00 
  800e57:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800e5e:	e8 47 f4 ff ff       	call   8002aa <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e63:	83 c4 2c             	add    $0x2c,%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e71:	ba 00 00 00 00       	mov    $0x0,%edx
  800e76:	b8 02 00 00 00       	mov    $0x2,%eax
  800e7b:	89 d1                	mov    %edx,%ecx
  800e7d:	89 d3                	mov    %edx,%ebx
  800e7f:	89 d7                	mov    %edx,%edi
  800e81:	89 d6                	mov    %edx,%esi
  800e83:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <sys_yield>:

void
sys_yield(void)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e90:	ba 00 00 00 00       	mov    $0x0,%edx
  800e95:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e9a:	89 d1                	mov    %edx,%ecx
  800e9c:	89 d3                	mov    %edx,%ebx
  800e9e:	89 d7                	mov    %edx,%edi
  800ea0:	89 d6                	mov    %edx,%esi
  800ea2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	be 00 00 00 00       	mov    $0x0,%esi
  800eb7:	b8 04 00 00 00       	mov    $0x4,%eax
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec5:	89 f7                	mov    %esi,%edi
  800ec7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7e 28                	jle    800ef5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800ef0:	e8 b5 f3 ff ff       	call   8002aa <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ef5:	83 c4 2c             	add    $0x2c,%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f06:	b8 05 00 00 00       	mov    $0x5,%eax
  800f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f17:	8b 75 18             	mov    0x18(%ebp),%esi
  800f1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7e 28                	jle    800f48 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f24:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f33:	00 
  800f34:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f3b:	00 
  800f3c:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f43:	e8 62 f3 ff ff       	call   8002aa <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f48:	83 c4 2c             	add    $0x2c,%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	89 df                	mov    %ebx,%edi
  800f6b:	89 de                	mov    %ebx,%esi
  800f6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	7e 28                	jle    800f9b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f77:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f7e:	00 
  800f7f:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f86:	00 
  800f87:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f8e:	00 
  800f8f:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f96:	e8 0f f3 ff ff       	call   8002aa <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9b:	83 c4 2c             	add    $0x2c,%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7e 28                	jle    800fee <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fca:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800fd9:	00 
  800fda:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fe1:	00 
  800fe2:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800fe9:	e8 bc f2 ff ff       	call   8002aa <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fee:	83 c4 2c             	add    $0x2c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801004:	b8 09 00 00 00       	mov    $0x9,%eax
  801009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	89 df                	mov    %ebx,%edi
  801011:	89 de                	mov    %ebx,%esi
  801013:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801015:	85 c0                	test   %eax,%eax
  801017:	7e 28                	jle    801041 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801019:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801024:	00 
  801025:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  80102c:	00 
  80102d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801034:	00 
  801035:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80103c:	e8 69 f2 ff ff       	call   8002aa <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801041:	83 c4 2c             	add    $0x2c,%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
  801057:	b8 0a 00 00 00       	mov    $0xa,%eax
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	89 df                	mov    %ebx,%edi
  801064:	89 de                	mov    %ebx,%esi
  801066:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801068:	85 c0                	test   %eax,%eax
  80106a:	7e 28                	jle    801094 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801070:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801077:	00 
  801078:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  80107f:	00 
  801080:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801087:	00 
  801088:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80108f:	e8 16 f2 ff ff       	call   8002aa <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801094:	83 c4 2c             	add    $0x2c,%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a2:	be 00 00 00 00       	mov    $0x0,%esi
  8010a7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	57                   	push   %edi
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010cd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	89 cb                	mov    %ecx,%ebx
  8010d7:	89 cf                	mov    %ecx,%edi
  8010d9:	89 ce                	mov    %ecx,%esi
  8010db:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	7e 28                	jle    801109 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010ec:	00 
  8010ed:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  8010f4:	00 
  8010f5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010fc:	00 
  8010fd:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  801104:	e8 a1 f1 ff ff       	call   8002aa <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801109:	83 c4 2c             	add    $0x2c,%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    

00801111 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	53                   	push   %ebx
  801115:	83 ec 24             	sub    $0x24,%esp
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80111b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80111d:	89 da                	mov    %ebx,%edx
  80111f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801122:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801129:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80112d:	74 05                	je     801134 <pgfault+0x23>
  80112f:	f6 c6 08             	test   $0x8,%dh
  801132:	75 1c                	jne    801150 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801134:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  80113b:	00 
  80113c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801143:	00 
  801144:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80114b:	e8 5a f1 ff ff       	call   8002aa <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801150:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801157:	00 
  801158:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80115f:	00 
  801160:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801167:	e8 3d fd ff ff       	call   800ea9 <sys_page_alloc>
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 20                	jns    801190 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801170:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801174:	c7 44 24 08 14 2c 80 	movl   $0x802c14,0x8(%esp)
  80117b:	00 
  80117c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801183:	00 
  801184:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80118b:	e8 1a f1 ff ff       	call   8002aa <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801190:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801196:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80119d:	00 
  80119e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011a9:	e8 48 fa ff ff       	call   800bf6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8011ae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011b5:	00 
  8011b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c1:	00 
  8011c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011c9:	00 
  8011ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d1:	e8 27 fd ff ff       	call   800efd <sys_page_map>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	79 20                	jns    8011fa <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8011da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011de:	c7 44 24 08 2e 2c 80 	movl   $0x802c2e,0x8(%esp)
  8011e5:	00 
  8011e6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011ed:	00 
  8011ee:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  8011f5:	e8 b0 f0 ff ff       	call   8002aa <_panic>
	}
}
  8011fa:	83 c4 24             	add    $0x24,%esp
  8011fd:	5b                   	pop    %ebx
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801209:	c7 04 24 11 11 80 00 	movl   $0x801111,(%esp)
  801210:	e8 61 10 00 00       	call   802276 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801215:	b8 07 00 00 00       	mov    $0x7,%eax
  80121a:	cd 30                	int    $0x30
  80121c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80121f:	85 c0                	test   %eax,%eax
  801221:	79 1c                	jns    80123f <fork+0x3f>
		panic("fork");
  801223:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  80122a:	00 
  80122b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801232:	00 
  801233:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80123a:	e8 6b f0 ff ff       	call   8002aa <_panic>
  80123f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801241:	bb 00 08 00 00       	mov    $0x800,%ebx
  801246:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80124a:	75 21                	jne    80126d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80124c:	e8 1a fc ff ff       	call   800e6b <sys_getenvid>
  801251:	25 ff 03 00 00       	and    $0x3ff,%eax
  801256:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801259:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125e:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
  801268:	e9 c5 01 00 00       	jmp    801432 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80126d:	89 d8                	mov    %ebx,%eax
  80126f:	c1 e8 0a             	shr    $0xa,%eax
  801272:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801279:	a8 01                	test   $0x1,%al
  80127b:	0f 84 f2 00 00 00    	je     801373 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801281:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801288:	a8 05                	test   $0x5,%al
  80128a:	0f 84 e3 00 00 00    	je     801373 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801290:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801297:	89 de                	mov    %ebx,%esi
  801299:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80129c:	a9 02 08 00 00       	test   $0x802,%eax
  8012a1:	0f 84 88 00 00 00    	je     80132f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8012a7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012ae:	00 
  8012af:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c2:	e8 36 fc ff ff       	call   800efd <sys_page_map>
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	79 20                	jns    8012eb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  8012cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cf:	c7 44 24 08 4c 2c 80 	movl   $0x802c4c,0x8(%esp)
  8012d6:	00 
  8012d7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8012de:	00 
  8012df:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  8012e6:	e8 bf ef ff ff       	call   8002aa <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8012eb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012f2:	00 
  8012f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012fe:	00 
  8012ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  801303:	89 3c 24             	mov    %edi,(%esp)
  801306:	e8 f2 fb ff ff       	call   800efd <sys_page_map>
  80130b:	85 c0                	test   %eax,%eax
  80130d:	79 64                	jns    801373 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80130f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801313:	c7 44 24 08 66 2c 80 	movl   $0x802c66,0x8(%esp)
  80131a:	00 
  80131b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801322:	00 
  801323:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80132a:	e8 7b ef ff ff       	call   8002aa <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80132f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801336:	00 
  801337:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80133b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80133f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801343:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134a:	e8 ae fb ff ff       	call   800efd <sys_page_map>
  80134f:	85 c0                	test   %eax,%eax
  801351:	79 20                	jns    801373 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801353:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801357:	c7 44 24 08 80 2c 80 	movl   $0x802c80,0x8(%esp)
  80135e:	00 
  80135f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801366:	00 
  801367:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80136e:	e8 37 ef ff ff       	call   8002aa <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801373:	83 c3 01             	add    $0x1,%ebx
  801376:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80137c:	0f 85 eb fe ff ff    	jne    80126d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801382:	c7 44 24 04 df 22 80 	movl   $0x8022df,0x4(%esp)
  801389:	00 
  80138a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138d:	89 04 24             	mov    %eax,(%esp)
  801390:	e8 b4 fc ff ff       	call   801049 <sys_env_set_pgfault_upcall>
  801395:	85 c0                	test   %eax,%eax
  801397:	79 20                	jns    8013b9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801399:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80139d:	c7 44 24 08 e4 2b 80 	movl   $0x802be4,0x8(%esp)
  8013a4:	00 
  8013a5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013ac:	00 
  8013ad:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  8013b4:	e8 f1 ee ff ff       	call   8002aa <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8013b9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013c0:	00 
  8013c1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013c8:	ee 
  8013c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cc:	89 04 24             	mov    %eax,(%esp)
  8013cf:	e8 d5 fa ff ff       	call   800ea9 <sys_page_alloc>
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	79 20                	jns    8013f8 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8013d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013dc:	c7 44 24 08 92 2c 80 	movl   $0x802c92,0x8(%esp)
  8013e3:	00 
  8013e4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  8013eb:	00 
  8013ec:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  8013f3:	e8 b2 ee ff ff       	call   8002aa <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8013f8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013ff:	00 
  801400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801403:	89 04 24             	mov    %eax,(%esp)
  801406:	e8 98 fb ff ff       	call   800fa3 <sys_env_set_status>
  80140b:	85 c0                	test   %eax,%eax
  80140d:	79 20                	jns    80142f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80140f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801413:	c7 44 24 08 aa 2c 80 	movl   $0x802caa,0x8(%esp)
  80141a:	00 
  80141b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801422:	00 
  801423:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  80142a:	e8 7b ee ff ff       	call   8002aa <_panic>
	}

	return envid;
  80142f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801432:	83 c4 2c             	add    $0x2c,%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <sfork>:

// Challenge!
int
sfork(void)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801440:	c7 44 24 08 c5 2c 80 	movl   $0x802cc5,0x8(%esp)
  801447:	00 
  801448:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80144f:	00 
  801450:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  801457:	e8 4e ee ff ff       	call   8002aa <_panic>
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
  801594:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80159a:	8b 52 48             	mov    0x48(%edx),%edx
  80159d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015a5:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  8015ac:	e8 f2 ed ff ff       	call   8003a3 <cprintf>
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
  801635:	e8 16 f9 ff ff       	call   800f50 <sys_page_unmap>
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
  801733:	e8 c5 f7 ff ff       	call   800efd <sys_page_map>
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
  80176e:	e8 8a f7 ff ff       	call   800efd <sys_page_map>
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
  801787:	e8 c4 f7 ff ff       	call   800f50 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80178c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801797:	e8 b4 f7 ff ff       	call   800f50 <sys_page_unmap>
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
  8017eb:	a1 20 44 80 00       	mov    0x804420,%eax
  8017f0:	8b 40 48             	mov    0x48(%eax),%eax
  8017f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fb:	c7 04 24 1d 2d 80 00 	movl   $0x802d1d,(%esp)
  801802:	e8 9c eb ff ff       	call   8003a3 <cprintf>
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
  8018d3:	a1 20 44 80 00       	mov    0x804420,%eax
  8018d8:	8b 40 48             	mov    0x48(%eax),%eax
  8018db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  8018ea:	e8 b4 ea ff ff       	call   8003a3 <cprintf>
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
  80198c:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801991:	8b 40 48             	mov    0x48(%eax),%eax
  801994:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  8019a3:	e8 fb e9 ff ff       	call   8003a3 <cprintf>
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
  801aab:	e8 50 09 00 00       	call   802400 <ipc_find_env>
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
  801ad1:	e8 c4 08 00 00       	call   80239a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ad6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801add:	00 
  801ade:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae9:	e8 42 08 00 00       	call   802330 <ipc_recv>
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
  801b2a:	e8 cc ee ff ff       	call   8009fb <strcpy>
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
  801ba7:	c7 44 24 0c 56 2d 80 	movl   $0x802d56,0xc(%esp)
  801bae:	00 
  801baf:	c7 44 24 08 5d 2d 80 	movl   $0x802d5d,0x8(%esp)
  801bb6:	00 
  801bb7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801bbe:	00 
  801bbf:	c7 04 24 72 2d 80 00 	movl   $0x802d72,(%esp)
  801bc6:	e8 df e6 ff ff       	call   8002aa <_panic>
	assert(r <= PGSIZE);
  801bcb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd0:	7e 24                	jle    801bf6 <devfile_read+0x84>
  801bd2:	c7 44 24 0c 7d 2d 80 	movl   $0x802d7d,0xc(%esp)
  801bd9:	00 
  801bda:	c7 44 24 08 5d 2d 80 	movl   $0x802d5d,0x8(%esp)
  801be1:	00 
  801be2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801be9:	00 
  801bea:	c7 04 24 72 2d 80 00 	movl   $0x802d72,(%esp)
  801bf1:	e8 b4 e6 ff ff       	call   8002aa <_panic>
	memmove(buf, &fsipcbuf, r);
  801bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bfa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c01:	00 
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	89 04 24             	mov    %eax,(%esp)
  801c08:	e8 e9 ef ff ff       	call   800bf6 <memmove>
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
  801c23:	e8 78 ed ff ff       	call   8009a0 <strlen>
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
  801c4b:	e8 ab ed ff ff       	call   8009fb <strcpy>
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
  801cb8:	c7 44 24 04 89 2d 80 	movl   $0x802d89,0x4(%esp)
  801cbf:	00 
  801cc0:	89 1c 24             	mov    %ebx,(%esp)
  801cc3:	e8 33 ed ff ff       	call   8009fb <strcpy>
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
  801d08:	e8 43 f2 ff ff       	call   800f50 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d0d:	89 1c 24             	mov    %ebx,(%esp)
  801d10:	e8 5b f7 ff ff       	call   801470 <fd2data>
  801d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d20:	e8 2b f2 ff ff       	call   800f50 <sys_page_unmap>
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
  801d39:	a1 20 44 80 00       	mov    0x804420,%eax
  801d3e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d41:	89 34 24             	mov    %esi,(%esp)
  801d44:	e8 ff 06 00 00       	call   802448 <pageref>
  801d49:	89 c7                	mov    %eax,%edi
  801d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 f2 06 00 00       	call   802448 <pageref>
  801d56:	39 c7                	cmp    %eax,%edi
  801d58:	0f 94 c2             	sete   %dl
  801d5b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d5e:	8b 0d 20 44 80 00    	mov    0x804420,%ecx
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
  801d7e:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  801d85:	e8 19 e6 ff ff       	call   8003a3 <cprintf>
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
  801dc4:	e8 c1 f0 ff ff       	call   800e8a <sys_yield>
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
  801e59:	e8 2c f0 ff ff       	call   800e8a <sys_yield>
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
  801edc:	e8 c8 ef ff ff       	call   800ea9 <sys_page_alloc>
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
  801f16:	e8 8e ef ff ff       	call   800ea9 <sys_page_alloc>
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
  801f45:	e8 5f ef ff ff       	call   800ea9 <sys_page_alloc>
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
  801f7e:	e8 7a ef ff ff       	call   800efd <sys_page_map>
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
  801fe6:	e8 65 ef ff ff       	call   800f50 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff9:	e8 52 ef ff ff       	call   800f50 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	89 44 24 04          	mov    %eax,0x4(%esp)
  802005:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200c:	e8 3f ef ff ff       	call   800f50 <sys_page_unmap>
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

0080204f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 10             	sub    $0x10,%esp
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80205a:	85 c0                	test   %eax,%eax
  80205c:	75 24                	jne    802082 <wait+0x33>
  80205e:	c7 44 24 0c a8 2d 80 	movl   $0x802da8,0xc(%esp)
  802065:	00 
  802066:	c7 44 24 08 5d 2d 80 	movl   $0x802d5d,0x8(%esp)
  80206d:	00 
  80206e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802075:	00 
  802076:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  80207d:	e8 28 e2 ff ff       	call   8002aa <_panic>
	e = &envs[ENVX(envid)];
  802082:	89 c3                	mov    %eax,%ebx
  802084:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80208a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80208d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802093:	8b 73 48             	mov    0x48(%ebx),%esi
  802096:	39 c6                	cmp    %eax,%esi
  802098:	75 1a                	jne    8020b4 <wait+0x65>
  80209a:	8b 43 54             	mov    0x54(%ebx),%eax
  80209d:	85 c0                	test   %eax,%eax
  80209f:	74 13                	je     8020b4 <wait+0x65>
		sys_yield();
  8020a1:	e8 e4 ed ff ff       	call   800e8a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8020a6:	8b 43 48             	mov    0x48(%ebx),%eax
  8020a9:	39 f0                	cmp    %esi,%eax
  8020ab:	75 07                	jne    8020b4 <wait+0x65>
  8020ad:	8b 43 54             	mov    0x54(%ebx),%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	75 ed                	jne    8020a1 <wait+0x52>
		sys_yield();
}
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5d                   	pop    %ebp
  8020ba:	c3                   	ret    
  8020bb:	66 90                	xchg   %ax,%ax
  8020bd:	66 90                	xchg   %ax,%ax
  8020bf:	90                   	nop

008020c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020d0:	c7 44 24 04 be 2d 80 	movl   $0x802dbe,0x4(%esp)
  8020d7:	00 
  8020d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 18 e9 ff ff       	call   8009fb <strcpy>
	return 0;
}
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	57                   	push   %edi
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fa:	74 4a                	je     802146 <devcons_write+0x5c>
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802106:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80210c:	8b 75 10             	mov    0x10(%ebp),%esi
  80210f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802111:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802114:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802119:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80211c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802120:	03 45 0c             	add    0xc(%ebp),%eax
  802123:	89 44 24 04          	mov    %eax,0x4(%esp)
  802127:	89 3c 24             	mov    %edi,(%esp)
  80212a:	e8 c7 ea ff ff       	call   800bf6 <memmove>
		sys_cputs(buf, m);
  80212f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802133:	89 3c 24             	mov    %edi,(%esp)
  802136:	e8 a1 ec ff ff       	call   800ddc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80213b:	01 f3                	add    %esi,%ebx
  80213d:	89 d8                	mov    %ebx,%eax
  80213f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802142:	72 c8                	jb     80210c <devcons_write+0x22>
  802144:	eb 05                	jmp    80214b <devcons_write+0x61>
  802146:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80214b:	89 d8                	mov    %ebx,%eax
  80214d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802167:	75 07                	jne    802170 <devcons_read+0x18>
  802169:	eb 28                	jmp    802193 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80216b:	e8 1a ed ff ff       	call   800e8a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802170:	e8 85 ec ff ff       	call   800dfa <sys_cgetc>
  802175:	85 c0                	test   %eax,%eax
  802177:	74 f2                	je     80216b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 16                	js     802193 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80217d:	83 f8 04             	cmp    $0x4,%eax
  802180:	74 0c                	je     80218e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	88 02                	mov    %al,(%edx)
	return 1;
  802187:	b8 01 00 00 00       	mov    $0x1,%eax
  80218c:	eb 05                	jmp    802193 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021a8:	00 
  8021a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 28 ec ff ff       	call   800ddc <sys_cputs>
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <getchar>:

int
getchar(void)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021c3:	00 
  8021c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d2:	e8 cf f5 ff ff       	call   8017a6 <read>
	if (r < 0)
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 0f                	js     8021ea <getchar+0x34>
		return r;
	if (r < 1)
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	7e 06                	jle    8021e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021e3:	eb 05                	jmp    8021ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 f7 f2 ff ff       	call   8014fb <fd_lookup>
  802204:	85 c0                	test   %eax,%eax
  802206:	78 11                	js     802219 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802211:	39 10                	cmp    %edx,(%eax)
  802213:	0f 94 c0             	sete   %al
  802216:	0f b6 c0             	movzbl %al,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <opencons>:

int
opencons(void)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802221:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802224:	89 04 24             	mov    %eax,(%esp)
  802227:	e8 5b f2 ff ff       	call   801487 <fd_alloc>
		return r;
  80222c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 40                	js     802272 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802232:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802239:	00 
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802248:	e8 5c ec ff ff       	call   800ea9 <sys_page_alloc>
		return r;
  80224d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 1f                	js     802272 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802253:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802268:	89 04 24             	mov    %eax,(%esp)
  80226b:	e8 f0 f1 ff ff       	call   801460 <fd2num>
  802270:	89 c2                	mov    %eax,%edx
}
  802272:	89 d0                	mov    %edx,%eax
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80227c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802283:	75 50                	jne    8022d5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802285:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80228c:	00 
  80228d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802294:	ee 
  802295:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229c:	e8 08 ec ff ff       	call   800ea9 <sys_page_alloc>
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	79 1c                	jns    8022c1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8022a5:	c7 44 24 08 cc 2d 80 	movl   $0x802dcc,0x8(%esp)
  8022ac:	00 
  8022ad:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8022b4:	00 
  8022b5:	c7 04 24 f0 2d 80 00 	movl   $0x802df0,(%esp)
  8022bc:	e8 e9 df ff ff       	call   8002aa <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8022c1:	c7 44 24 04 df 22 80 	movl   $0x8022df,0x4(%esp)
  8022c8:	00 
  8022c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d0:	e8 74 ed ff ff       	call   801049 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022df:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022e0:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022e5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022e7:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8022ea:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8022ec:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8022f1:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8022f4:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8022f9:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8022fc:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8022fe:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802301:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802303:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802305:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80230a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80230d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802312:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802315:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802317:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80231c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80231f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802324:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802327:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802329:	83 c4 08             	add    $0x8,%esp
	popal
  80232c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80232d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80232e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80232f:	c3                   	ret    

00802330 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	56                   	push   %esi
  802334:	53                   	push   %ebx
  802335:	83 ec 10             	sub    $0x10,%esp
  802338:	8b 75 08             	mov    0x8(%ebp),%esi
  80233b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  802341:	83 f8 01             	cmp    $0x1,%eax
  802344:	19 c0                	sbb    %eax,%eax
  802346:	f7 d0                	not    %eax
  802348:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  80234d:	89 04 24             	mov    %eax,(%esp)
  802350:	e8 6a ed ff ff       	call   8010bf <sys_ipc_recv>
	if (err_code < 0) {
  802355:	85 c0                	test   %eax,%eax
  802357:	79 16                	jns    80236f <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  802359:	85 f6                	test   %esi,%esi
  80235b:	74 06                	je     802363 <ipc_recv+0x33>
  80235d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802363:	85 db                	test   %ebx,%ebx
  802365:	74 2c                	je     802393 <ipc_recv+0x63>
  802367:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80236d:	eb 24                	jmp    802393 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80236f:	85 f6                	test   %esi,%esi
  802371:	74 0a                	je     80237d <ipc_recv+0x4d>
  802373:	a1 20 44 80 00       	mov    0x804420,%eax
  802378:	8b 40 74             	mov    0x74(%eax),%eax
  80237b:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80237d:	85 db                	test   %ebx,%ebx
  80237f:	74 0a                	je     80238b <ipc_recv+0x5b>
  802381:	a1 20 44 80 00       	mov    0x804420,%eax
  802386:	8b 40 78             	mov    0x78(%eax),%eax
  802389:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80238b:	a1 20 44 80 00       	mov    0x804420,%eax
  802390:	8b 40 70             	mov    0x70(%eax),%eax
}
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	5b                   	pop    %ebx
  802397:	5e                   	pop    %esi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	57                   	push   %edi
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
  8023a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8023ac:	eb 25                	jmp    8023d3 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8023ae:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023b1:	74 20                	je     8023d3 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8023b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023b7:	c7 44 24 08 fe 2d 80 	movl   $0x802dfe,0x8(%esp)
  8023be:	00 
  8023bf:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8023c6:	00 
  8023c7:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  8023ce:	e8 d7 de ff ff       	call   8002aa <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8023d3:	85 db                	test   %ebx,%ebx
  8023d5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023da:	0f 45 c3             	cmovne %ebx,%eax
  8023dd:	8b 55 14             	mov    0x14(%ebp),%edx
  8023e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ec:	89 3c 24             	mov    %edi,(%esp)
  8023ef:	e8 a8 ec ff ff       	call   80109c <sys_ipc_try_send>
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	75 b6                	jne    8023ae <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    

00802400 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802406:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80240b:	39 c8                	cmp    %ecx,%eax
  80240d:	74 17                	je     802426 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80240f:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802414:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802417:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80241d:	8b 52 50             	mov    0x50(%edx),%edx
  802420:	39 ca                	cmp    %ecx,%edx
  802422:	75 14                	jne    802438 <ipc_find_env+0x38>
  802424:	eb 05                	jmp    80242b <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80242b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80242e:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802433:	8b 40 40             	mov    0x40(%eax),%eax
  802436:	eb 0e                	jmp    802446 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802438:	83 c0 01             	add    $0x1,%eax
  80243b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802440:	75 d2                	jne    802414 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802442:	66 b8 00 00          	mov    $0x0,%ax
}
  802446:	5d                   	pop    %ebp
  802447:	c3                   	ret    

00802448 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80244e:	89 d0                	mov    %edx,%eax
  802450:	c1 e8 16             	shr    $0x16,%eax
  802453:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80245f:	f6 c1 01             	test   $0x1,%cl
  802462:	74 1d                	je     802481 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802464:	c1 ea 0c             	shr    $0xc,%edx
  802467:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80246e:	f6 c2 01             	test   $0x1,%dl
  802471:	74 0e                	je     802481 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802473:	c1 ea 0c             	shr    $0xc,%edx
  802476:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80247d:	ef 
  80247e:	0f b7 c0             	movzwl %ax,%eax
}
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    
  802483:	66 90                	xchg   %ax,%ax
  802485:	66 90                	xchg   %ax,%ax
  802487:	66 90                	xchg   %ax,%ax
  802489:	66 90                	xchg   %ax,%ax
  80248b:	66 90                	xchg   %ax,%ax
  80248d:	66 90                	xchg   %ax,%ax
  80248f:	90                   	nop

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	8b 44 24 28          	mov    0x28(%esp),%eax
  80249a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80249e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ac:	89 ea                	mov    %ebp,%edx
  8024ae:	89 0c 24             	mov    %ecx,(%esp)
  8024b1:	75 2d                	jne    8024e0 <__udivdi3+0x50>
  8024b3:	39 e9                	cmp    %ebp,%ecx
  8024b5:	77 61                	ja     802518 <__udivdi3+0x88>
  8024b7:	85 c9                	test   %ecx,%ecx
  8024b9:	89 ce                	mov    %ecx,%esi
  8024bb:	75 0b                	jne    8024c8 <__udivdi3+0x38>
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	f7 f1                	div    %ecx
  8024c6:	89 c6                	mov    %eax,%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	89 e8                	mov    %ebp,%eax
  8024cc:	f7 f6                	div    %esi
  8024ce:	89 c5                	mov    %eax,%ebp
  8024d0:	89 f8                	mov    %edi,%eax
  8024d2:	f7 f6                	div    %esi
  8024d4:	89 ea                	mov    %ebp,%edx
  8024d6:	83 c4 0c             	add    $0xc,%esp
  8024d9:	5e                   	pop    %esi
  8024da:	5f                   	pop    %edi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	39 e8                	cmp    %ebp,%eax
  8024e2:	77 24                	ja     802508 <__udivdi3+0x78>
  8024e4:	0f bd e8             	bsr    %eax,%ebp
  8024e7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ea:	75 3c                	jne    802528 <__udivdi3+0x98>
  8024ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024f0:	39 34 24             	cmp    %esi,(%esp)
  8024f3:	0f 86 9f 00 00 00    	jbe    802598 <__udivdi3+0x108>
  8024f9:	39 d0                	cmp    %edx,%eax
  8024fb:	0f 82 97 00 00 00    	jb     802598 <__udivdi3+0x108>
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	31 c0                	xor    %eax,%eax
  80250c:	83 c4 0c             	add    $0xc,%esp
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
  802513:	90                   	nop
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 f8                	mov    %edi,%eax
  80251a:	f7 f1                	div    %ecx
  80251c:	31 d2                	xor    %edx,%edx
  80251e:	83 c4 0c             	add    $0xc,%esp
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	8d 76 00             	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	8b 3c 24             	mov    (%esp),%edi
  80252d:	d3 e0                	shl    %cl,%eax
  80252f:	89 c6                	mov    %eax,%esi
  802531:	b8 20 00 00 00       	mov    $0x20,%eax
  802536:	29 e8                	sub    %ebp,%eax
  802538:	89 c1                	mov    %eax,%ecx
  80253a:	d3 ef                	shr    %cl,%edi
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802542:	8b 3c 24             	mov    (%esp),%edi
  802545:	09 74 24 08          	or     %esi,0x8(%esp)
  802549:	89 d6                	mov    %edx,%esi
  80254b:	d3 e7                	shl    %cl,%edi
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	89 3c 24             	mov    %edi,(%esp)
  802552:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802556:	d3 ee                	shr    %cl,%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	d3 e2                	shl    %cl,%edx
  80255c:	89 c1                	mov    %eax,%ecx
  80255e:	d3 ef                	shr    %cl,%edi
  802560:	09 d7                	or     %edx,%edi
  802562:	89 f2                	mov    %esi,%edx
  802564:	89 f8                	mov    %edi,%eax
  802566:	f7 74 24 08          	divl   0x8(%esp)
  80256a:	89 d6                	mov    %edx,%esi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	f7 24 24             	mull   (%esp)
  802571:	39 d6                	cmp    %edx,%esi
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 30                	jb     8025a8 <__udivdi3+0x118>
  802578:	8b 54 24 04          	mov    0x4(%esp),%edx
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	39 c2                	cmp    %eax,%edx
  802582:	73 05                	jae    802589 <__udivdi3+0xf9>
  802584:	3b 34 24             	cmp    (%esp),%esi
  802587:	74 1f                	je     8025a8 <__udivdi3+0x118>
  802589:	89 f8                	mov    %edi,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	e9 7a ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  802592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	e9 68 ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	83 c4 0c             	add    $0xc,%esp
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    
  8025b4:	66 90                	xchg   %ax,%ax
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	66 90                	xchg   %ax,%ax
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	83 ec 14             	sub    $0x14,%esp
  8025c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025e0:	89 34 24             	mov    %esi,(%esp)
  8025e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	75 17                	jne    802608 <__umoddi3+0x48>
  8025f1:	39 fe                	cmp    %edi,%esi
  8025f3:	76 4b                	jbe    802640 <__umoddi3+0x80>
  8025f5:	89 c8                	mov    %ecx,%eax
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	f7 f6                	div    %esi
  8025fb:	89 d0                	mov    %edx,%eax
  8025fd:	31 d2                	xor    %edx,%edx
  8025ff:	83 c4 14             	add    $0x14,%esp
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	66 90                	xchg   %ax,%ax
  802608:	39 f8                	cmp    %edi,%eax
  80260a:	77 54                	ja     802660 <__umoddi3+0xa0>
  80260c:	0f bd e8             	bsr    %eax,%ebp
  80260f:	83 f5 1f             	xor    $0x1f,%ebp
  802612:	75 5c                	jne    802670 <__umoddi3+0xb0>
  802614:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802618:	39 3c 24             	cmp    %edi,(%esp)
  80261b:	0f 87 e7 00 00 00    	ja     802708 <__umoddi3+0x148>
  802621:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802625:	29 f1                	sub    %esi,%ecx
  802627:	19 c7                	sbb    %eax,%edi
  802629:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80262d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802631:	8b 44 24 08          	mov    0x8(%esp),%eax
  802635:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802639:	83 c4 14             	add    $0x14,%esp
  80263c:	5e                   	pop    %esi
  80263d:	5f                   	pop    %edi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
  802640:	85 f6                	test   %esi,%esi
  802642:	89 f5                	mov    %esi,%ebp
  802644:	75 0b                	jne    802651 <__umoddi3+0x91>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f6                	div    %esi
  80264f:	89 c5                	mov    %eax,%ebp
  802651:	8b 44 24 04          	mov    0x4(%esp),%eax
  802655:	31 d2                	xor    %edx,%edx
  802657:	f7 f5                	div    %ebp
  802659:	89 c8                	mov    %ecx,%eax
  80265b:	f7 f5                	div    %ebp
  80265d:	eb 9c                	jmp    8025fb <__umoddi3+0x3b>
  80265f:	90                   	nop
  802660:	89 c8                	mov    %ecx,%eax
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 14             	add    $0x14,%esp
  802667:	5e                   	pop    %esi
  802668:	5f                   	pop    %edi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    
  80266b:	90                   	nop
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	8b 04 24             	mov    (%esp),%eax
  802673:	be 20 00 00 00       	mov    $0x20,%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	29 ee                	sub    %ebp,%esi
  80267c:	d3 e2                	shl    %cl,%edx
  80267e:	89 f1                	mov    %esi,%ecx
  802680:	d3 e8                	shr    %cl,%eax
  802682:	89 e9                	mov    %ebp,%ecx
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	8b 04 24             	mov    (%esp),%eax
  80268b:	09 54 24 04          	or     %edx,0x4(%esp)
  80268f:	89 fa                	mov    %edi,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 f1                	mov    %esi,%ecx
  802695:	89 44 24 08          	mov    %eax,0x8(%esp)
  802699:	8b 44 24 10          	mov    0x10(%esp),%eax
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	89 e9                	mov    %ebp,%ecx
  8026a1:	d3 e7                	shl    %cl,%edi
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	89 e9                	mov    %ebp,%ecx
  8026a9:	09 f8                	or     %edi,%eax
  8026ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026af:	f7 74 24 04          	divl   0x4(%esp)
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b9:	89 d7                	mov    %edx,%edi
  8026bb:	f7 64 24 08          	mull   0x8(%esp)
  8026bf:	39 d7                	cmp    %edx,%edi
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 2c                	jb     8026f4 <__umoddi3+0x134>
  8026c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026cc:	72 22                	jb     8026f0 <__umoddi3+0x130>
  8026ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026d2:	29 c8                	sub    %ecx,%eax
  8026d4:	19 d7                	sbb    %edx,%edi
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	89 fa                	mov    %edi,%edx
  8026da:	d3 e8                	shr    %cl,%eax
  8026dc:	89 f1                	mov    %esi,%ecx
  8026de:	d3 e2                	shl    %cl,%edx
  8026e0:	89 e9                	mov    %ebp,%ecx
  8026e2:	d3 ef                	shr    %cl,%edi
  8026e4:	09 d0                	or     %edx,%eax
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 14             	add    $0x14,%esp
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
  8026ef:	90                   	nop
  8026f0:	39 d7                	cmp    %edx,%edi
  8026f2:	75 da                	jne    8026ce <__umoddi3+0x10e>
  8026f4:	8b 14 24             	mov    (%esp),%edx
  8026f7:	89 c1                	mov    %eax,%ecx
  8026f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802701:	eb cb                	jmp    8026ce <__umoddi3+0x10e>
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80270c:	0f 82 0f ff ff ff    	jb     802621 <__umoddi3+0x61>
  802712:	e9 1a ff ff ff       	jmp    802631 <__umoddi3+0x71>
