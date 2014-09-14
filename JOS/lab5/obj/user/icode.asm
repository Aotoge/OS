
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 27 01 00 00       	call   800158 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 80 	movl   $0x802880,0x803000
  800045:	28 80 00 

	cprintf("icode startup\n");
  800048:	c7 04 24 86 28 80 00 	movl   $0x802886,(%esp)
  80004f:	e8 8e 02 00 00       	call   8002e2 <cprintf>

	cprintf("icode: open /motd\n");
  800054:	c7 04 24 95 28 80 00 	movl   $0x802895,(%esp)
  80005b:	e8 82 02 00 00       	call   8002e2 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800060:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 a8 28 80 00 	movl   $0x8028a8,(%esp)
  80006f:	e8 d4 17 00 00       	call   801848 <open>
  800074:	89 c6                	mov    %eax,%esi
  800076:	85 c0                	test   %eax,%eax
  800078:	79 20                	jns    80009a <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007e:	c7 44 24 08 ae 28 80 	movl   $0x8028ae,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 c4 28 80 00 	movl   $0x8028c4,(%esp)
  800095:	e8 4f 01 00 00       	call   8001e9 <_panic>

	cprintf("icode: read /motd\n");
  80009a:	c7 04 24 d1 28 80 00 	movl   $0x8028d1,(%esp)
  8000a1:	e8 3c 02 00 00       	call   8002e2 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a6:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ac:	eb 0c                	jmp    8000ba <umain+0x87>
		sys_cputs(buf, n);
  8000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b2:	89 1c 24             	mov    %ebx,(%esp)
  8000b5:	e8 62 0c 00 00       	call   800d1c <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c1:	00 
  8000c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c6:	89 34 24             	mov    %esi,(%esp)
  8000c9:	e8 d8 12 00 00       	call   8013a6 <read>
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dc                	jg     8000ae <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d2:	c7 04 24 e4 28 80 00 	movl   $0x8028e4,(%esp)
  8000d9:	e8 04 02 00 00       	call   8002e2 <cprintf>
	close(fd);
  8000de:	89 34 24             	mov    %esi,(%esp)
  8000e1:	e8 5d 11 00 00       	call   801243 <close>

	cprintf("icode: spawn /init\n");
  8000e6:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  8000ed:	e8 f0 01 00 00       	call   8002e2 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 0c 0c 29 80 	movl   $0x80290c,0xc(%esp)
  800101:	00 
  800102:	c7 44 24 08 15 29 80 	movl   $0x802915,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 1f 29 80 	movl   $0x80291f,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 1e 29 80 00 	movl   $0x80291e,(%esp)
  800119:	e8 60 1d 00 00       	call   801e7e <spawnl>
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 20                	jns    800142 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	c7 44 24 08 24 29 80 	movl   $0x802924,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 c4 28 80 00 	movl   $0x8028c4,(%esp)
  80013d:	e8 a7 00 00 00       	call   8001e9 <_panic>

	cprintf("icode: exiting\n");
  800142:	c7 04 24 3b 29 80 00 	movl   $0x80293b,(%esp)
  800149:	e8 94 01 00 00       	call   8002e2 <cprintf>
}
  80014e:	81 c4 30 02 00 00    	add    $0x230,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 10             	sub    $0x10,%esp
  800160:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800163:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800166:	e8 40 0c 00 00       	call   800dab <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80016b:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 17                	je     80018c <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800175:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80017a:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80017d:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800183:	8b 49 40             	mov    0x40(%ecx),%ecx
  800186:	39 c1                	cmp    %eax,%ecx
  800188:	75 18                	jne    8001a2 <libmain+0x4a>
  80018a:	eb 05                	jmp    800191 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80018c:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800191:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800194:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80019a:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8001a0:	eb 0b                	jmp    8001ad <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001a2:	83 c2 01             	add    $0x1,%edx
  8001a5:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001ab:	75 cd                	jne    80017a <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ad:	85 db                	test   %ebx,%ebx
  8001af:	7e 07                	jle    8001b8 <libmain+0x60>
		binaryname = argv[0];
  8001b1:	8b 06                	mov    (%esi),%eax
  8001b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001bc:	89 1c 24             	mov    %ebx,(%esp)
  8001bf:	e8 6f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001c4:	e8 07 00 00 00       	call   8001d0 <exit>
}
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5d                   	pop    %ebp
  8001cf:	c3                   	ret    

008001d0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001d6:	e8 9b 10 00 00       	call   801276 <close_all>
	sys_env_destroy(0);
  8001db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e2:	e8 72 0b 00 00       	call   800d59 <sys_env_destroy>
}
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001f1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001fa:	e8 ac 0b 00 00       	call   800dab <sys_getenvid>
  8001ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800202:	89 54 24 10          	mov    %edx,0x10(%esp)
  800206:	8b 55 08             	mov    0x8(%ebp),%edx
  800209:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80020d:	89 74 24 08          	mov    %esi,0x8(%esp)
  800211:	89 44 24 04          	mov    %eax,0x4(%esp)
  800215:	c7 04 24 58 29 80 00 	movl   $0x802958,(%esp)
  80021c:	e8 c1 00 00 00       	call   8002e2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800221:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800225:	8b 45 10             	mov    0x10(%ebp),%eax
  800228:	89 04 24             	mov    %eax,(%esp)
  80022b:	e8 51 00 00 00       	call   800281 <vcprintf>
	cprintf("\n");
  800230:	c7 04 24 7e 2d 80 00 	movl   $0x802d7e,(%esp)
  800237:	e8 a6 00 00 00       	call   8002e2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80023c:	cc                   	int3   
  80023d:	eb fd                	jmp    80023c <_panic+0x53>

0080023f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	53                   	push   %ebx
  800243:	83 ec 14             	sub    $0x14,%esp
  800246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800249:	8b 13                	mov    (%ebx),%edx
  80024b:	8d 42 01             	lea    0x1(%edx),%eax
  80024e:	89 03                	mov    %eax,(%ebx)
  800250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800253:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800257:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025c:	75 19                	jne    800277 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80025e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800265:	00 
  800266:	8d 43 08             	lea    0x8(%ebx),%eax
  800269:	89 04 24             	mov    %eax,(%esp)
  80026c:	e8 ab 0a 00 00       	call   800d1c <sys_cputs>
		b->idx = 0;
  800271:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800277:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027b:	83 c4 14             	add    $0x14,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80028a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800291:	00 00 00 
	b.cnt = 0;
  800294:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b6:	c7 04 24 3f 02 80 00 	movl   $0x80023f,(%esp)
  8002bd:	e8 b2 01 00 00       	call   800474 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 42 0a 00 00       	call   800d1c <sys_cputs>

	return b.cnt;
}
  8002da:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e0:	c9                   	leave  
  8002e1:	c3                   	ret    

008002e2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 87 ff ff ff       	call   800281 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    
  8002fc:	66 90                	xchg   %ax,%ax
  8002fe:	66 90                	xchg   %ax,%ax

00800300 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 3c             	sub    $0x3c,%esp
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030c:	89 d7                	mov    %edx,%edi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800314:	8b 75 0c             	mov    0xc(%ebp),%esi
  800317:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80031a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800322:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800325:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800328:	39 f1                	cmp    %esi,%ecx
  80032a:	72 14                	jb     800340 <printnum+0x40>
  80032c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80032f:	76 0f                	jbe    800340 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8d 70 ff             	lea    -0x1(%eax),%esi
  800337:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80033a:	85 f6                	test   %esi,%esi
  80033c:	7f 60                	jg     80039e <printnum+0x9e>
  80033e:	eb 72                	jmp    8003b2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800340:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800343:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800347:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80034a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80034d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800351:	89 44 24 08          	mov    %eax,0x8(%esp)
  800355:	8b 44 24 08          	mov    0x8(%esp),%eax
  800359:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80035d:	89 c3                	mov    %eax,%ebx
  80035f:	89 d6                	mov    %edx,%esi
  800361:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800364:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800367:	89 54 24 08          	mov    %edx,0x8(%esp)
  80036b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80036f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800372:	89 04 24             	mov    %eax,(%esp)
  800375:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037c:	e8 5f 22 00 00       	call   8025e0 <__udivdi3>
  800381:	89 d9                	mov    %ebx,%ecx
  800383:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800387:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80038b:	89 04 24             	mov    %eax,(%esp)
  80038e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800392:	89 fa                	mov    %edi,%edx
  800394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800397:	e8 64 ff ff ff       	call   800300 <printnum>
  80039c:	eb 14                	jmp    8003b2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003aa:	83 ee 01             	sub    $0x1,%esi
  8003ad:	75 ef                	jne    80039e <printnum+0x9e>
  8003af:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cb:	89 04 24             	mov    %eax,(%esp)
  8003ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d5:	e8 36 23 00 00       	call   802710 <__umoddi3>
  8003da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003de:	0f be 80 7b 29 80 00 	movsbl 0x80297b(%eax),%eax
  8003e5:	89 04 24             	mov    %eax,(%esp)
  8003e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003eb:	ff d0                	call   *%eax
}
  8003ed:	83 c4 3c             	add    $0x3c,%esp
  8003f0:	5b                   	pop    %ebx
  8003f1:	5e                   	pop    %esi
  8003f2:	5f                   	pop    %edi
  8003f3:	5d                   	pop    %ebp
  8003f4:	c3                   	ret    

008003f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f8:	83 fa 01             	cmp    $0x1,%edx
  8003fb:	7e 0e                	jle    80040b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003fd:	8b 10                	mov    (%eax),%edx
  8003ff:	8d 4a 08             	lea    0x8(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 02                	mov    (%edx),%eax
  800406:	8b 52 04             	mov    0x4(%edx),%edx
  800409:	eb 22                	jmp    80042d <getuint+0x38>
	else if (lflag)
  80040b:	85 d2                	test   %edx,%edx
  80040d:	74 10                	je     80041f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80040f:	8b 10                	mov    (%eax),%edx
  800411:	8d 4a 04             	lea    0x4(%edx),%ecx
  800414:	89 08                	mov    %ecx,(%eax)
  800416:	8b 02                	mov    (%edx),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
  80041d:	eb 0e                	jmp    80042d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80041f:	8b 10                	mov    (%eax),%edx
  800421:	8d 4a 04             	lea    0x4(%edx),%ecx
  800424:	89 08                	mov    %ecx,(%eax)
  800426:	8b 02                	mov    (%edx),%eax
  800428:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800435:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	3b 50 04             	cmp    0x4(%eax),%edx
  80043e:	73 0a                	jae    80044a <sprintputch+0x1b>
		*b->buf++ = ch;
  800440:	8d 4a 01             	lea    0x1(%edx),%ecx
  800443:	89 08                	mov    %ecx,(%eax)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	88 02                	mov    %al,(%edx)
}
  80044a:	5d                   	pop    %ebp
  80044b:	c3                   	ret    

0080044c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800452:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800455:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800459:	8b 45 10             	mov    0x10(%ebp),%eax
  80045c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	89 44 24 04          	mov    %eax,0x4(%esp)
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	89 04 24             	mov    %eax,(%esp)
  80046d:	e8 02 00 00 00       	call   800474 <vprintfmt>
	va_end(ap);
}
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	57                   	push   %edi
  800478:	56                   	push   %esi
  800479:	53                   	push   %ebx
  80047a:	83 ec 3c             	sub    $0x3c,%esp
  80047d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800480:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800483:	eb 18                	jmp    80049d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800485:	85 c0                	test   %eax,%eax
  800487:	0f 84 c3 03 00 00    	je     800850 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80048d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800491:	89 04 24             	mov    %eax,(%esp)
  800494:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800497:	89 f3                	mov    %esi,%ebx
  800499:	eb 02                	jmp    80049d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80049b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049d:	8d 73 01             	lea    0x1(%ebx),%esi
  8004a0:	0f b6 03             	movzbl (%ebx),%eax
  8004a3:	83 f8 25             	cmp    $0x25,%eax
  8004a6:	75 dd                	jne    800485 <vprintfmt+0x11>
  8004a8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8004ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004b3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c6:	eb 1d                	jmp    8004e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ca:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8004ce:	eb 15                	jmp    8004e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8004d6:	eb 0d                	jmp    8004e5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004de:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004e8:	0f b6 06             	movzbl (%esi),%eax
  8004eb:	0f b6 c8             	movzbl %al,%ecx
  8004ee:	83 e8 23             	sub    $0x23,%eax
  8004f1:	3c 55                	cmp    $0x55,%al
  8004f3:	0f 87 2f 03 00 00    	ja     800828 <vprintfmt+0x3b4>
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	ff 24 85 c0 2a 80 00 	jmp    *0x802ac0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800503:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800506:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800509:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80050d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800510:	83 f9 09             	cmp    $0x9,%ecx
  800513:	77 50                	ja     800565 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800515:	89 de                	mov    %ebx,%esi
  800517:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80051d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800520:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800524:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800527:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80052a:	83 fb 09             	cmp    $0x9,%ebx
  80052d:	76 eb                	jbe    80051a <vprintfmt+0xa6>
  80052f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800532:	eb 33                	jmp    800567 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 48 04             	lea    0x4(%eax),%ecx
  80053a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800542:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800544:	eb 21                	jmp    800567 <vprintfmt+0xf3>
  800546:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800549:	85 c9                	test   %ecx,%ecx
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	0f 49 c1             	cmovns %ecx,%eax
  800553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	89 de                	mov    %ebx,%esi
  800558:	eb 8b                	jmp    8004e5 <vprintfmt+0x71>
  80055a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80055c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800563:	eb 80                	jmp    8004e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800565:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056b:	0f 89 74 ff ff ff    	jns    8004e5 <vprintfmt+0x71>
  800571:	e9 62 ff ff ff       	jmp    8004d8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800576:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800579:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80057b:	e9 65 ff ff ff       	jmp    8004e5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 50 04             	lea    0x4(%eax),%edx
  800586:	89 55 14             	mov    %edx,0x14(%ebp)
  800589:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	ff 55 08             	call   *0x8(%ebp)
			break;
  800595:	e9 03 ff ff ff       	jmp    80049d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 50 04             	lea    0x4(%eax),%edx
  8005a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	99                   	cltd   
  8005a6:	31 d0                	xor    %edx,%eax
  8005a8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005aa:	83 f8 0f             	cmp    $0xf,%eax
  8005ad:	7f 0b                	jg     8005ba <vprintfmt+0x146>
  8005af:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  8005b6:	85 d2                	test   %edx,%edx
  8005b8:	75 20                	jne    8005da <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8005ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005be:	c7 44 24 08 93 29 80 	movl   $0x802993,0x8(%esp)
  8005c5:	00 
  8005c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	89 04 24             	mov    %eax,(%esp)
  8005d0:	e8 77 fe ff ff       	call   80044c <printfmt>
  8005d5:	e9 c3 fe ff ff       	jmp    80049d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005de:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  8005e5:	00 
  8005e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	89 04 24             	mov    %eax,(%esp)
  8005f0:	e8 57 fe ff ff       	call   80044c <printfmt>
  8005f5:	e9 a3 fe ff ff       	jmp    80049d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005fd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 50 04             	lea    0x4(%eax),%edx
  800606:	89 55 14             	mov    %edx,0x14(%ebp)
  800609:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80060b:	85 c0                	test   %eax,%eax
  80060d:	ba 8c 29 80 00       	mov    $0x80298c,%edx
  800612:	0f 45 d0             	cmovne %eax,%edx
  800615:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800618:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80061c:	74 04                	je     800622 <vprintfmt+0x1ae>
  80061e:	85 f6                	test   %esi,%esi
  800620:	7f 19                	jg     80063b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800625:	8d 70 01             	lea    0x1(%eax),%esi
  800628:	0f b6 10             	movzbl (%eax),%edx
  80062b:	0f be c2             	movsbl %dl,%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	0f 85 95 00 00 00    	jne    8006cb <vprintfmt+0x257>
  800636:	e9 85 00 00 00       	jmp    8006c0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80063f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800642:	89 04 24             	mov    %eax,(%esp)
  800645:	e8 b8 02 00 00       	call   800902 <strnlen>
  80064a:	29 c6                	sub    %eax,%esi
  80064c:	89 f0                	mov    %esi,%eax
  80064e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800651:	85 f6                	test   %esi,%esi
  800653:	7e cd                	jle    800622 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800655:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800659:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80065c:	89 c3                	mov    %eax,%ebx
  80065e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800662:	89 34 24             	mov    %esi,(%esp)
  800665:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800668:	83 eb 01             	sub    $0x1,%ebx
  80066b:	75 f1                	jne    80065e <vprintfmt+0x1ea>
  80066d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800670:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800673:	eb ad                	jmp    800622 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800675:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800679:	74 1e                	je     800699 <vprintfmt+0x225>
  80067b:	0f be d2             	movsbl %dl,%edx
  80067e:	83 ea 20             	sub    $0x20,%edx
  800681:	83 fa 5e             	cmp    $0x5e,%edx
  800684:	76 13                	jbe    800699 <vprintfmt+0x225>
					putch('?', putdat);
  800686:	8b 45 0c             	mov    0xc(%ebp),%eax
  800689:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800694:	ff 55 08             	call   *0x8(%ebp)
  800697:	eb 0d                	jmp    8006a6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80069c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006a0:	89 04 24             	mov    %eax,(%esp)
  8006a3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a6:	83 ef 01             	sub    $0x1,%edi
  8006a9:	83 c6 01             	add    $0x1,%esi
  8006ac:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006b0:	0f be c2             	movsbl %dl,%eax
  8006b3:	85 c0                	test   %eax,%eax
  8006b5:	75 20                	jne    8006d7 <vprintfmt+0x263>
  8006b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c4:	7f 25                	jg     8006eb <vprintfmt+0x277>
  8006c6:	e9 d2 fd ff ff       	jmp    80049d <vprintfmt+0x29>
  8006cb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d7:	85 db                	test   %ebx,%ebx
  8006d9:	78 9a                	js     800675 <vprintfmt+0x201>
  8006db:	83 eb 01             	sub    $0x1,%ebx
  8006de:	79 95                	jns    800675 <vprintfmt+0x201>
  8006e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006e9:	eb d5                	jmp    8006c0 <vprintfmt+0x24c>
  8006eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ff:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800701:	83 eb 01             	sub    $0x1,%ebx
  800704:	75 ee                	jne    8006f4 <vprintfmt+0x280>
  800706:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800709:	e9 8f fd ff ff       	jmp    80049d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80070e:	83 fa 01             	cmp    $0x1,%edx
  800711:	7e 16                	jle    800729 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 50 08             	lea    0x8(%eax),%edx
  800719:	89 55 14             	mov    %edx,0x14(%ebp)
  80071c:	8b 50 04             	mov    0x4(%eax),%edx
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800727:	eb 32                	jmp    80075b <vprintfmt+0x2e7>
	else if (lflag)
  800729:	85 d2                	test   %edx,%edx
  80072b:	74 18                	je     800745 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	89 55 14             	mov    %edx,0x14(%ebp)
  800736:	8b 30                	mov    (%eax),%esi
  800738:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	c1 f8 1f             	sar    $0x1f,%eax
  800740:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800743:	eb 16                	jmp    80075b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	89 55 14             	mov    %edx,0x14(%ebp)
  80074e:	8b 30                	mov    (%eax),%esi
  800750:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800753:	89 f0                	mov    %esi,%eax
  800755:	c1 f8 1f             	sar    $0x1f,%eax
  800758:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80075b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80075e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800761:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800766:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80076a:	0f 89 80 00 00 00    	jns    8007f0 <vprintfmt+0x37c>
				putch('-', putdat);
  800770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800774:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80077b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80077e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800781:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800784:	f7 d8                	neg    %eax
  800786:	83 d2 00             	adc    $0x0,%edx
  800789:	f7 da                	neg    %edx
			}
			base = 10;
  80078b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800790:	eb 5e                	jmp    8007f0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800792:	8d 45 14             	lea    0x14(%ebp),%eax
  800795:	e8 5b fc ff ff       	call   8003f5 <getuint>
			base = 10;
  80079a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80079f:	eb 4f                	jmp    8007f0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a4:	e8 4c fc ff ff       	call   8003f5 <getuint>
			base = 8;
  8007a9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007ae:	eb 40                	jmp    8007f0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007bb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007c9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 50 04             	lea    0x4(%eax),%edx
  8007d2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007dc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007e1:	eb 0d                	jmp    8007f0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e6:	e8 0a fc ff ff       	call   8003f5 <getuint>
			base = 16;
  8007eb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007f4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007fb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800803:	89 04 24             	mov    %eax,(%esp)
  800806:	89 54 24 04          	mov    %edx,0x4(%esp)
  80080a:	89 fa                	mov    %edi,%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	e8 ec fa ff ff       	call   800300 <printnum>
			break;
  800814:	e9 84 fc ff ff       	jmp    80049d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800819:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081d:	89 0c 24             	mov    %ecx,(%esp)
  800820:	ff 55 08             	call   *0x8(%ebp)
			break;
  800823:	e9 75 fc ff ff       	jmp    80049d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800828:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800833:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800836:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80083a:	0f 84 5b fc ff ff    	je     80049b <vprintfmt+0x27>
  800840:	89 f3                	mov    %esi,%ebx
  800842:	83 eb 01             	sub    $0x1,%ebx
  800845:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800849:	75 f7                	jne    800842 <vprintfmt+0x3ce>
  80084b:	e9 4d fc ff ff       	jmp    80049d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800850:	83 c4 3c             	add    $0x3c,%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 28             	sub    $0x28,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 30                	je     8008a9 <vsnprintf+0x51>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 2c                	jle    8008a9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800884:	8b 45 10             	mov    0x10(%ebp),%eax
  800887:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800892:	c7 04 24 2f 04 80 00 	movl   $0x80042f,(%esp)
  800899:	e8 d6 fb ff ff       	call   800474 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80089e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a7:	eb 05                	jmp    8008ae <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 04 24             	mov    %eax,(%esp)
  8008d1:	e8 82 ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    
  8008d8:	66 90                	xchg   %ax,%ax
  8008da:	66 90                	xchg   %ax,%ax
  8008dc:	66 90                	xchg   %ax,%ax
  8008de:	66 90                	xchg   %ax,%ax

008008e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008e9:	74 10                	je     8008fb <strlen+0x1b>
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f7:	75 f7                	jne    8008f0 <strlen+0x10>
  8008f9:	eb 05                	jmp    800900 <strlen+0x20>
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800909:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090c:	85 c9                	test   %ecx,%ecx
  80090e:	74 1c                	je     80092c <strnlen+0x2a>
  800910:	80 3b 00             	cmpb   $0x0,(%ebx)
  800913:	74 1e                	je     800933 <strnlen+0x31>
  800915:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80091a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091c:	39 ca                	cmp    %ecx,%edx
  80091e:	74 18                	je     800938 <strnlen+0x36>
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800928:	75 f0                	jne    80091a <strnlen+0x18>
  80092a:	eb 0c                	jmp    800938 <strnlen+0x36>
  80092c:	b8 00 00 00 00       	mov    $0x0,%eax
  800931:	eb 05                	jmp    800938 <strnlen+0x36>
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800938:	5b                   	pop    %ebx
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800945:	89 c2                	mov    %eax,%edx
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	83 c1 01             	add    $0x1,%ecx
  80094d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800951:	88 5a ff             	mov    %bl,-0x1(%edx)
  800954:	84 db                	test   %bl,%bl
  800956:	75 ef                	jne    800947 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800958:	5b                   	pop    %ebx
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800965:	89 1c 24             	mov    %ebx,(%esp)
  800968:	e8 73 ff ff ff       	call   8008e0 <strlen>
	strcpy(dst + len, src);
  80096d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800970:	89 54 24 04          	mov    %edx,0x4(%esp)
  800974:	01 d8                	add    %ebx,%eax
  800976:	89 04 24             	mov    %eax,(%esp)
  800979:	e8 bd ff ff ff       	call   80093b <strcpy>
	return dst;
}
  80097e:	89 d8                	mov    %ebx,%eax
  800980:	83 c4 08             	add    $0x8,%esp
  800983:	5b                   	pop    %ebx
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	8b 75 08             	mov    0x8(%ebp),%esi
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800994:	85 db                	test   %ebx,%ebx
  800996:	74 17                	je     8009af <strncpy+0x29>
  800998:	01 f3                	add    %esi,%ebx
  80099a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80099c:	83 c1 01             	add    $0x1,%ecx
  80099f:	0f b6 02             	movzbl (%edx),%eax
  8009a2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a5:	80 3a 01             	cmpb   $0x1,(%edx)
  8009a8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ab:	39 d9                	cmp    %ebx,%ecx
  8009ad:	75 ed                	jne    80099c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009af:	89 f0                	mov    %esi,%eax
  8009b1:	5b                   	pop    %ebx
  8009b2:	5e                   	pop    %esi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	57                   	push   %edi
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
  8009bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009c1:	8b 75 10             	mov    0x10(%ebp),%esi
  8009c4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c6:	85 f6                	test   %esi,%esi
  8009c8:	74 34                	je     8009fe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8009ca:	83 fe 01             	cmp    $0x1,%esi
  8009cd:	74 26                	je     8009f5 <strlcpy+0x40>
  8009cf:	0f b6 0b             	movzbl (%ebx),%ecx
  8009d2:	84 c9                	test   %cl,%cl
  8009d4:	74 23                	je     8009f9 <strlcpy+0x44>
  8009d6:	83 ee 02             	sub    $0x2,%esi
  8009d9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e4:	39 f2                	cmp    %esi,%edx
  8009e6:	74 13                	je     8009fb <strlcpy+0x46>
  8009e8:	83 c2 01             	add    $0x1,%edx
  8009eb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ef:	84 c9                	test   %cl,%cl
  8009f1:	75 eb                	jne    8009de <strlcpy+0x29>
  8009f3:	eb 06                	jmp    8009fb <strlcpy+0x46>
  8009f5:	89 f8                	mov    %edi,%eax
  8009f7:	eb 02                	jmp    8009fb <strlcpy+0x46>
  8009f9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009fb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fe:	29 f8                	sub    %edi,%eax
}
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0e:	0f b6 01             	movzbl (%ecx),%eax
  800a11:	84 c0                	test   %al,%al
  800a13:	74 15                	je     800a2a <strcmp+0x25>
  800a15:	3a 02                	cmp    (%edx),%al
  800a17:	75 11                	jne    800a2a <strcmp+0x25>
		p++, q++;
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a1f:	0f b6 01             	movzbl (%ecx),%eax
  800a22:	84 c0                	test   %al,%al
  800a24:	74 04                	je     800a2a <strcmp+0x25>
  800a26:	3a 02                	cmp    (%edx),%al
  800a28:	74 ef                	je     800a19 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	56                   	push   %esi
  800a38:	53                   	push   %ebx
  800a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800a42:	85 f6                	test   %esi,%esi
  800a44:	74 29                	je     800a6f <strncmp+0x3b>
  800a46:	0f b6 03             	movzbl (%ebx),%eax
  800a49:	84 c0                	test   %al,%al
  800a4b:	74 30                	je     800a7d <strncmp+0x49>
  800a4d:	3a 02                	cmp    (%edx),%al
  800a4f:	75 2c                	jne    800a7d <strncmp+0x49>
  800a51:	8d 43 01             	lea    0x1(%ebx),%eax
  800a54:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800a56:	89 c3                	mov    %eax,%ebx
  800a58:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a5b:	39 f0                	cmp    %esi,%eax
  800a5d:	74 17                	je     800a76 <strncmp+0x42>
  800a5f:	0f b6 08             	movzbl (%eax),%ecx
  800a62:	84 c9                	test   %cl,%cl
  800a64:	74 17                	je     800a7d <strncmp+0x49>
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	3a 0a                	cmp    (%edx),%cl
  800a6b:	74 e9                	je     800a56 <strncmp+0x22>
  800a6d:	eb 0e                	jmp    800a7d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	eb 0f                	jmp    800a85 <strncmp+0x51>
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	eb 08                	jmp    800a85 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7d:	0f b6 03             	movzbl (%ebx),%eax
  800a80:	0f b6 12             	movzbl (%edx),%edx
  800a83:	29 d0                	sub    %edx,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a93:	0f b6 18             	movzbl (%eax),%ebx
  800a96:	84 db                	test   %bl,%bl
  800a98:	74 1d                	je     800ab7 <strchr+0x2e>
  800a9a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a9c:	38 d3                	cmp    %dl,%bl
  800a9e:	75 06                	jne    800aa6 <strchr+0x1d>
  800aa0:	eb 1a                	jmp    800abc <strchr+0x33>
  800aa2:	38 ca                	cmp    %cl,%dl
  800aa4:	74 16                	je     800abc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa6:	83 c0 01             	add    $0x1,%eax
  800aa9:	0f b6 10             	movzbl (%eax),%edx
  800aac:	84 d2                	test   %dl,%dl
  800aae:	75 f2                	jne    800aa2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb 05                	jmp    800abc <strchr+0x33>
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	53                   	push   %ebx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ac9:	0f b6 18             	movzbl (%eax),%ebx
  800acc:	84 db                	test   %bl,%bl
  800ace:	74 16                	je     800ae6 <strfind+0x27>
  800ad0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ad2:	38 d3                	cmp    %dl,%bl
  800ad4:	75 06                	jne    800adc <strfind+0x1d>
  800ad6:	eb 0e                	jmp    800ae6 <strfind+0x27>
  800ad8:	38 ca                	cmp    %cl,%dl
  800ada:	74 0a                	je     800ae6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800adc:	83 c0 01             	add    $0x1,%eax
  800adf:	0f b6 10             	movzbl (%eax),%edx
  800ae2:	84 d2                	test   %dl,%dl
  800ae4:	75 f2                	jne    800ad8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
  800aef:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af5:	85 c9                	test   %ecx,%ecx
  800af7:	74 36                	je     800b2f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aff:	75 28                	jne    800b29 <memset+0x40>
  800b01:	f6 c1 03             	test   $0x3,%cl
  800b04:	75 23                	jne    800b29 <memset+0x40>
		c &= 0xFF;
  800b06:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b0a:	89 d3                	mov    %edx,%ebx
  800b0c:	c1 e3 08             	shl    $0x8,%ebx
  800b0f:	89 d6                	mov    %edx,%esi
  800b11:	c1 e6 18             	shl    $0x18,%esi
  800b14:	89 d0                	mov    %edx,%eax
  800b16:	c1 e0 10             	shl    $0x10,%eax
  800b19:	09 f0                	or     %esi,%eax
  800b1b:	09 c2                	or     %eax,%edx
  800b1d:	89 d0                	mov    %edx,%eax
  800b1f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b21:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b24:	fc                   	cld    
  800b25:	f3 ab                	rep stos %eax,%es:(%edi)
  800b27:	eb 06                	jmp    800b2f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	fc                   	cld    
  800b2d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2f:	89 f8                	mov    %edi,%eax
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b44:	39 c6                	cmp    %eax,%esi
  800b46:	73 35                	jae    800b7d <memmove+0x47>
  800b48:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b4b:	39 d0                	cmp    %edx,%eax
  800b4d:	73 2e                	jae    800b7d <memmove+0x47>
		s += n;
		d += n;
  800b4f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b52:	89 d6                	mov    %edx,%esi
  800b54:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5c:	75 13                	jne    800b71 <memmove+0x3b>
  800b5e:	f6 c1 03             	test   $0x3,%cl
  800b61:	75 0e                	jne    800b71 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b63:	83 ef 04             	sub    $0x4,%edi
  800b66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b69:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b6c:	fd                   	std    
  800b6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6f:	eb 09                	jmp    800b7a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b71:	83 ef 01             	sub    $0x1,%edi
  800b74:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b77:	fd                   	std    
  800b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b7a:	fc                   	cld    
  800b7b:	eb 1d                	jmp    800b9a <memmove+0x64>
  800b7d:	89 f2                	mov    %esi,%edx
  800b7f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b81:	f6 c2 03             	test   $0x3,%dl
  800b84:	75 0f                	jne    800b95 <memmove+0x5f>
  800b86:	f6 c1 03             	test   $0x3,%cl
  800b89:	75 0a                	jne    800b95 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b8e:	89 c7                	mov    %eax,%edi
  800b90:	fc                   	cld    
  800b91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b93:	eb 05                	jmp    800b9a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b95:	89 c7                	mov    %eax,%edi
  800b97:	fc                   	cld    
  800b98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 04 24             	mov    %eax,(%esp)
  800bb8:	e8 79 ff ff ff       	call   800b36 <memmove>
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bce:	8d 78 ff             	lea    -0x1(%eax),%edi
  800bd1:	85 c0                	test   %eax,%eax
  800bd3:	74 36                	je     800c0b <memcmp+0x4c>
		if (*s1 != *s2)
  800bd5:	0f b6 03             	movzbl (%ebx),%eax
  800bd8:	0f b6 0e             	movzbl (%esi),%ecx
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	38 c8                	cmp    %cl,%al
  800be2:	74 1c                	je     800c00 <memcmp+0x41>
  800be4:	eb 10                	jmp    800bf6 <memcmp+0x37>
  800be6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800beb:	83 c2 01             	add    $0x1,%edx
  800bee:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800bf2:	38 c8                	cmp    %cl,%al
  800bf4:	74 0a                	je     800c00 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800bf6:	0f b6 c0             	movzbl %al,%eax
  800bf9:	0f b6 c9             	movzbl %cl,%ecx
  800bfc:	29 c8                	sub    %ecx,%eax
  800bfe:	eb 10                	jmp    800c10 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c00:	39 fa                	cmp    %edi,%edx
  800c02:	75 e2                	jne    800be6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
  800c09:	eb 05                	jmp    800c10 <memcmp+0x51>
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800c1f:	89 c2                	mov    %eax,%edx
  800c21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c24:	39 d0                	cmp    %edx,%eax
  800c26:	73 13                	jae    800c3b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c28:	89 d9                	mov    %ebx,%ecx
  800c2a:	38 18                	cmp    %bl,(%eax)
  800c2c:	75 06                	jne    800c34 <memfind+0x1f>
  800c2e:	eb 0b                	jmp    800c3b <memfind+0x26>
  800c30:	38 08                	cmp    %cl,(%eax)
  800c32:	74 07                	je     800c3b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c34:	83 c0 01             	add    $0x1,%eax
  800c37:	39 d0                	cmp    %edx,%eax
  800c39:	75 f5                	jne    800c30 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 0a             	movzbl (%edx),%ecx
  800c4d:	80 f9 09             	cmp    $0x9,%cl
  800c50:	74 05                	je     800c57 <strtol+0x19>
  800c52:	80 f9 20             	cmp    $0x20,%cl
  800c55:	75 10                	jne    800c67 <strtol+0x29>
		s++;
  800c57:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5a:	0f b6 0a             	movzbl (%edx),%ecx
  800c5d:	80 f9 09             	cmp    $0x9,%cl
  800c60:	74 f5                	je     800c57 <strtol+0x19>
  800c62:	80 f9 20             	cmp    $0x20,%cl
  800c65:	74 f0                	je     800c57 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c67:	80 f9 2b             	cmp    $0x2b,%cl
  800c6a:	75 0a                	jne    800c76 <strtol+0x38>
		s++;
  800c6c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c74:	eb 11                	jmp    800c87 <strtol+0x49>
  800c76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c7b:	80 f9 2d             	cmp    $0x2d,%cl
  800c7e:	75 07                	jne    800c87 <strtol+0x49>
		s++, neg = 1;
  800c80:	83 c2 01             	add    $0x1,%edx
  800c83:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c87:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c8c:	75 15                	jne    800ca3 <strtol+0x65>
  800c8e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c91:	75 10                	jne    800ca3 <strtol+0x65>
  800c93:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c97:	75 0a                	jne    800ca3 <strtol+0x65>
		s += 2, base = 16;
  800c99:	83 c2 02             	add    $0x2,%edx
  800c9c:	b8 10 00 00 00       	mov    $0x10,%eax
  800ca1:	eb 10                	jmp    800cb3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	75 0c                	jne    800cb3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ca9:	80 3a 30             	cmpb   $0x30,(%edx)
  800cac:	75 05                	jne    800cb3 <strtol+0x75>
		s++, base = 8;
  800cae:	83 c2 01             	add    $0x1,%edx
  800cb1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cbb:	0f b6 0a             	movzbl (%edx),%ecx
  800cbe:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cc1:	89 f0                	mov    %esi,%eax
  800cc3:	3c 09                	cmp    $0x9,%al
  800cc5:	77 08                	ja     800ccf <strtol+0x91>
			dig = *s - '0';
  800cc7:	0f be c9             	movsbl %cl,%ecx
  800cca:	83 e9 30             	sub    $0x30,%ecx
  800ccd:	eb 20                	jmp    800cef <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800ccf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cd2:	89 f0                	mov    %esi,%eax
  800cd4:	3c 19                	cmp    $0x19,%al
  800cd6:	77 08                	ja     800ce0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800cd8:	0f be c9             	movsbl %cl,%ecx
  800cdb:	83 e9 57             	sub    $0x57,%ecx
  800cde:	eb 0f                	jmp    800cef <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800ce0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ce3:	89 f0                	mov    %esi,%eax
  800ce5:	3c 19                	cmp    $0x19,%al
  800ce7:	77 16                	ja     800cff <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ce9:	0f be c9             	movsbl %cl,%ecx
  800cec:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cef:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cf2:	7d 0f                	jge    800d03 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cf4:	83 c2 01             	add    $0x1,%edx
  800cf7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cfb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cfd:	eb bc                	jmp    800cbb <strtol+0x7d>
  800cff:	89 d8                	mov    %ebx,%eax
  800d01:	eb 02                	jmp    800d05 <strtol+0xc7>
  800d03:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d09:	74 05                	je     800d10 <strtol+0xd2>
		*endptr = (char *) s;
  800d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d10:	f7 d8                	neg    %eax
  800d12:	85 ff                	test   %edi,%edi
  800d14:	0f 44 c3             	cmove  %ebx,%eax
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2d:	89 c3                	mov    %eax,%ebx
  800d2f:	89 c7                	mov    %eax,%edi
  800d31:	89 c6                	mov    %eax,%esi
  800d33:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
  800d45:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4a:	89 d1                	mov    %edx,%ecx
  800d4c:	89 d3                	mov    %edx,%ebx
  800d4e:	89 d7                	mov    %edx,%edi
  800d50:	89 d6                	mov    %edx,%esi
  800d52:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d67:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	89 cb                	mov    %ecx,%ebx
  800d71:	89 cf                	mov    %ecx,%edi
  800d73:	89 ce                	mov    %ecx,%esi
  800d75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	7e 28                	jle    800da3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d86:	00 
  800d87:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d96:	00 
  800d97:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800d9e:	e8 46 f4 ff ff       	call   8001e9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da3:	83 c4 2c             	add    $0x2c,%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
  800db6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dbb:	89 d1                	mov    %edx,%ecx
  800dbd:	89 d3                	mov    %edx,%ebx
  800dbf:	89 d7                	mov    %edx,%edi
  800dc1:	89 d6                	mov    %edx,%esi
  800dc3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <sys_yield>:

void
sys_yield(void)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	be 00 00 00 00       	mov    $0x0,%esi
  800df7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e05:	89 f7                	mov    %esi,%edi
  800e07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7e 28                	jle    800e35 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e11:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e18:	00 
  800e19:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800e20:	00 
  800e21:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e28:	00 
  800e29:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800e30:	e8 b4 f3 ff ff       	call   8001e9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e35:	83 c4 2c             	add    $0x2c,%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e46:	b8 05 00 00 00       	mov    $0x5,%eax
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e54:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e57:	8b 75 18             	mov    0x18(%ebp),%esi
  800e5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7e 28                	jle    800e88 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e64:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e6b:	00 
  800e6c:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800e73:	00 
  800e74:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e7b:	00 
  800e7c:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800e83:	e8 61 f3 ff ff       	call   8001e9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e88:	83 c4 2c             	add    $0x2c,%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7e 28                	jle    800edb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ebe:	00 
  800ebf:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800ec6:	00 
  800ec7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ece:	00 
  800ecf:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800ed6:	e8 0e f3 ff ff       	call   8001e9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800edb:	83 c4 2c             	add    $0x2c,%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	89 de                	mov    %ebx,%esi
  800f00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7e 28                	jle    800f2e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f11:	00 
  800f12:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f19:	00 
  800f1a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f21:	00 
  800f22:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800f29:	e8 bb f2 ff ff       	call   8001e9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2e:	83 c4 2c             	add    $0x2c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
  800f3c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f44:	b8 09 00 00 00       	mov    $0x9,%eax
  800f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	89 df                	mov    %ebx,%edi
  800f51:	89 de                	mov    %ebx,%esi
  800f53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7e 28                	jle    800f81 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f64:	00 
  800f65:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f74:	00 
  800f75:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800f7c:	e8 68 f2 ff ff       	call   8001e9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f81:	83 c4 2c             	add    $0x2c,%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	89 df                	mov    %ebx,%edi
  800fa4:	89 de                	mov    %ebx,%esi
  800fa6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	7e 28                	jle    800fd4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fac:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fb7:	00 
  800fb8:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800fbf:	00 
  800fc0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fc7:	00 
  800fc8:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800fcf:	e8 15 f2 ff ff       	call   8001e9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd4:	83 c4 2c             	add    $0x2c,%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	be 00 00 00 00       	mov    $0x0,%esi
  800fe7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
  801005:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801008:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	89 cb                	mov    %ecx,%ebx
  801017:	89 cf                	mov    %ecx,%edi
  801019:	89 ce                	mov    %ecx,%esi
  80101b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	7e 28                	jle    801049 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801021:	89 44 24 10          	mov    %eax,0x10(%esp)
  801025:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80102c:	00 
  80102d:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  801034:	00 
  801035:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80103c:	00 
  80103d:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  801044:	e8 a0 f1 ff ff       	call   8001e9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801049:	83 c4 2c             	add    $0x2c,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    
  801051:	66 90                	xchg   %ax,%ax
  801053:	66 90                	xchg   %ax,%ax
  801055:	66 90                	xchg   %ax,%ax
  801057:	66 90                	xchg   %ax,%ax
  801059:	66 90                	xchg   %ax,%ax
  80105b:	66 90                	xchg   %ax,%ax
  80105d:	66 90                	xchg   %ax,%ax
  80105f:	90                   	nop

00801060 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
  80106b:	c1 e8 0c             	shr    $0xc,%eax
}
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80107b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801080:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80108a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80108f:	a8 01                	test   $0x1,%al
  801091:	74 34                	je     8010c7 <fd_alloc+0x40>
  801093:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801098:	a8 01                	test   $0x1,%al
  80109a:	74 32                	je     8010ce <fd_alloc+0x47>
  80109c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010a1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010a3:	89 c2                	mov    %eax,%edx
  8010a5:	c1 ea 16             	shr    $0x16,%edx
  8010a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	74 1f                	je     8010d3 <fd_alloc+0x4c>
  8010b4:	89 c2                	mov    %eax,%edx
  8010b6:	c1 ea 0c             	shr    $0xc,%edx
  8010b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c0:	f6 c2 01             	test   $0x1,%dl
  8010c3:	75 1a                	jne    8010df <fd_alloc+0x58>
  8010c5:	eb 0c                	jmp    8010d3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010c7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8010cc:	eb 05                	jmp    8010d3 <fd_alloc+0x4c>
  8010ce:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dd:	eb 1a                	jmp    8010f9 <fd_alloc+0x72>
  8010df:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010e4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010e9:	75 b6                	jne    8010a1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010f4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801101:	83 f8 1f             	cmp    $0x1f,%eax
  801104:	77 36                	ja     80113c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801106:	c1 e0 0c             	shl    $0xc,%eax
  801109:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80110e:	89 c2                	mov    %eax,%edx
  801110:	c1 ea 16             	shr    $0x16,%edx
  801113:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80111a:	f6 c2 01             	test   $0x1,%dl
  80111d:	74 24                	je     801143 <fd_lookup+0x48>
  80111f:	89 c2                	mov    %eax,%edx
  801121:	c1 ea 0c             	shr    $0xc,%edx
  801124:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80112b:	f6 c2 01             	test   $0x1,%dl
  80112e:	74 1a                	je     80114a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801130:	8b 55 0c             	mov    0xc(%ebp),%edx
  801133:	89 02                	mov    %eax,(%edx)
	return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	eb 13                	jmp    80114f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80113c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801141:	eb 0c                	jmp    80114f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801143:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801148:	eb 05                	jmp    80114f <fd_lookup+0x54>
  80114a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	53                   	push   %ebx
  801155:	83 ec 14             	sub    $0x14,%esp
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80115e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801164:	75 1e                	jne    801184 <dev_lookup+0x33>
  801166:	eb 0e                	jmp    801176 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801168:	b8 20 30 80 00       	mov    $0x803020,%eax
  80116d:	eb 0c                	jmp    80117b <dev_lookup+0x2a>
  80116f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801174:	eb 05                	jmp    80117b <dev_lookup+0x2a>
  801176:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80117b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	eb 38                	jmp    8011bc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801184:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80118a:	74 dc                	je     801168 <dev_lookup+0x17>
  80118c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801192:	74 db                	je     80116f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801194:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80119a:	8b 52 48             	mov    0x48(%edx),%edx
  80119d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011a5:	c7 04 24 ac 2c 80 00 	movl   $0x802cac,(%esp)
  8011ac:	e8 31 f1 ff ff       	call   8002e2 <cprintf>
	*dev = 0;
  8011b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8011b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011bc:	83 c4 14             	add    $0x14,%esp
  8011bf:	5b                   	pop    %ebx
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	56                   	push   %esi
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 20             	sub    $0x20,%esp
  8011ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8011cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011dd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e0:	89 04 24             	mov    %eax,(%esp)
  8011e3:	e8 13 ff ff ff       	call   8010fb <fd_lookup>
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	78 05                	js     8011f1 <fd_close+0x2f>
	    || fd != fd2)
  8011ec:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011ef:	74 0c                	je     8011fd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011f1:	84 db                	test   %bl,%bl
  8011f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f8:	0f 44 c2             	cmove  %edx,%eax
  8011fb:	eb 3f                	jmp    80123c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801200:	89 44 24 04          	mov    %eax,0x4(%esp)
  801204:	8b 06                	mov    (%esi),%eax
  801206:	89 04 24             	mov    %eax,(%esp)
  801209:	e8 43 ff ff ff       	call   801151 <dev_lookup>
  80120e:	89 c3                	mov    %eax,%ebx
  801210:	85 c0                	test   %eax,%eax
  801212:	78 16                	js     80122a <fd_close+0x68>
		if (dev->dev_close)
  801214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801217:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80121a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80121f:	85 c0                	test   %eax,%eax
  801221:	74 07                	je     80122a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801223:	89 34 24             	mov    %esi,(%esp)
  801226:	ff d0                	call   *%eax
  801228:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80122a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801235:	e8 56 fc ff ff       	call   800e90 <sys_page_unmap>
	return r;
  80123a:	89 d8                	mov    %ebx,%eax
}
  80123c:	83 c4 20             	add    $0x20,%esp
  80123f:	5b                   	pop    %ebx
  801240:	5e                   	pop    %esi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801249:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	89 04 24             	mov    %eax,(%esp)
  801256:	e8 a0 fe ff ff       	call   8010fb <fd_lookup>
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	78 13                	js     801274 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801261:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801268:	00 
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	89 04 24             	mov    %eax,(%esp)
  80126f:	e8 4e ff ff ff       	call   8011c2 <fd_close>
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <close_all>:

void
close_all(void)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	53                   	push   %ebx
  80127a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80127d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801282:	89 1c 24             	mov    %ebx,(%esp)
  801285:	e8 b9 ff ff ff       	call   801243 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80128a:	83 c3 01             	add    $0x1,%ebx
  80128d:	83 fb 20             	cmp    $0x20,%ebx
  801290:	75 f0                	jne    801282 <close_all+0xc>
		close(i);
}
  801292:	83 c4 14             	add    $0x14,%esp
  801295:	5b                   	pop    %ebx
  801296:	5d                   	pop    %ebp
  801297:	c3                   	ret    

00801298 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	57                   	push   %edi
  80129c:	56                   	push   %esi
  80129d:	53                   	push   %ebx
  80129e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	89 04 24             	mov    %eax,(%esp)
  8012ae:	e8 48 fe ff ff       	call   8010fb <fd_lookup>
  8012b3:	89 c2                	mov    %eax,%edx
  8012b5:	85 d2                	test   %edx,%edx
  8012b7:	0f 88 e1 00 00 00    	js     80139e <dup+0x106>
		return r;
	close(newfdnum);
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	89 04 24             	mov    %eax,(%esp)
  8012c3:	e8 7b ff ff ff       	call   801243 <close>

	newfd = INDEX2FD(newfdnum);
  8012c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012cb:	c1 e3 0c             	shl    $0xc,%ebx
  8012ce:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d7:	89 04 24             	mov    %eax,(%esp)
  8012da:	e8 91 fd ff ff       	call   801070 <fd2data>
  8012df:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012e1:	89 1c 24             	mov    %ebx,(%esp)
  8012e4:	e8 87 fd ff ff       	call   801070 <fd2data>
  8012e9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	c1 e8 16             	shr    $0x16,%eax
  8012f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f7:	a8 01                	test   $0x1,%al
  8012f9:	74 43                	je     80133e <dup+0xa6>
  8012fb:	89 f0                	mov    %esi,%eax
  8012fd:	c1 e8 0c             	shr    $0xc,%eax
  801300:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801307:	f6 c2 01             	test   $0x1,%dl
  80130a:	74 32                	je     80133e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801313:	25 07 0e 00 00       	and    $0xe07,%eax
  801318:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801320:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801327:	00 
  801328:	89 74 24 04          	mov    %esi,0x4(%esp)
  80132c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801333:	e8 05 fb ff ff       	call   800e3d <sys_page_map>
  801338:	89 c6                	mov    %eax,%esi
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 3e                	js     80137c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801341:	89 c2                	mov    %eax,%edx
  801343:	c1 ea 0c             	shr    $0xc,%edx
  801346:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801353:	89 54 24 10          	mov    %edx,0x10(%esp)
  801357:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80135b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801362:	00 
  801363:	89 44 24 04          	mov    %eax,0x4(%esp)
  801367:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136e:	e8 ca fa ff ff       	call   800e3d <sys_page_map>
  801373:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801378:	85 f6                	test   %esi,%esi
  80137a:	79 22                	jns    80139e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80137c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801387:	e8 04 fb ff ff       	call   800e90 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80138c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801397:	e8 f4 fa ff ff       	call   800e90 <sys_page_unmap>
	return r;
  80139c:	89 f0                	mov    %esi,%eax
}
  80139e:	83 c4 3c             	add    $0x3c,%esp
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5f                   	pop    %edi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 24             	sub    $0x24,%esp
  8013ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b7:	89 1c 24             	mov    %ebx,(%esp)
  8013ba:	e8 3c fd ff ff       	call   8010fb <fd_lookup>
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	85 d2                	test   %edx,%edx
  8013c3:	78 6d                	js     801432 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cf:	8b 00                	mov    (%eax),%eax
  8013d1:	89 04 24             	mov    %eax,(%esp)
  8013d4:	e8 78 fd ff ff       	call   801151 <dev_lookup>
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 55                	js     801432 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e0:	8b 50 08             	mov    0x8(%eax),%edx
  8013e3:	83 e2 03             	and    $0x3,%edx
  8013e6:	83 fa 01             	cmp    $0x1,%edx
  8013e9:	75 23                	jne    80140e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8013f0:	8b 40 48             	mov    0x48(%eax),%eax
  8013f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fb:	c7 04 24 ed 2c 80 00 	movl   $0x802ced,(%esp)
  801402:	e8 db ee ff ff       	call   8002e2 <cprintf>
		return -E_INVAL;
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb 24                	jmp    801432 <read+0x8c>
	}
	if (!dev->dev_read)
  80140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801411:	8b 52 08             	mov    0x8(%edx),%edx
  801414:	85 d2                	test   %edx,%edx
  801416:	74 15                	je     80142d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801418:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80141f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801422:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801426:	89 04 24             	mov    %eax,(%esp)
  801429:	ff d2                	call   *%edx
  80142b:	eb 05                	jmp    801432 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80142d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801432:	83 c4 24             	add    $0x24,%esp
  801435:	5b                   	pop    %ebx
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	57                   	push   %edi
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	83 ec 1c             	sub    $0x1c,%esp
  801441:	8b 7d 08             	mov    0x8(%ebp),%edi
  801444:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801447:	85 f6                	test   %esi,%esi
  801449:	74 33                	je     80147e <readn+0x46>
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801455:	89 f2                	mov    %esi,%edx
  801457:	29 c2                	sub    %eax,%edx
  801459:	89 54 24 08          	mov    %edx,0x8(%esp)
  80145d:	03 45 0c             	add    0xc(%ebp),%eax
  801460:	89 44 24 04          	mov    %eax,0x4(%esp)
  801464:	89 3c 24             	mov    %edi,(%esp)
  801467:	e8 3a ff ff ff       	call   8013a6 <read>
		if (m < 0)
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 1b                	js     80148b <readn+0x53>
			return m;
		if (m == 0)
  801470:	85 c0                	test   %eax,%eax
  801472:	74 11                	je     801485 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801474:	01 c3                	add    %eax,%ebx
  801476:	89 d8                	mov    %ebx,%eax
  801478:	39 f3                	cmp    %esi,%ebx
  80147a:	72 d9                	jb     801455 <readn+0x1d>
  80147c:	eb 0b                	jmp    801489 <readn+0x51>
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
  801483:	eb 06                	jmp    80148b <readn+0x53>
  801485:	89 d8                	mov    %ebx,%eax
  801487:	eb 02                	jmp    80148b <readn+0x53>
  801489:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80148b:	83 c4 1c             	add    $0x1c,%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5f                   	pop    %edi
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 24             	sub    $0x24,%esp
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a4:	89 1c 24             	mov    %ebx,(%esp)
  8014a7:	e8 4f fc ff ff       	call   8010fb <fd_lookup>
  8014ac:	89 c2                	mov    %eax,%edx
  8014ae:	85 d2                	test   %edx,%edx
  8014b0:	78 68                	js     80151a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	89 04 24             	mov    %eax,(%esp)
  8014c1:	e8 8b fc ff ff       	call   801151 <dev_lookup>
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 50                	js     80151a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d1:	75 23                	jne    8014f6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d8:	8b 40 48             	mov    0x48(%eax),%eax
  8014db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e3:	c7 04 24 09 2d 80 00 	movl   $0x802d09,(%esp)
  8014ea:	e8 f3 ed ff ff       	call   8002e2 <cprintf>
		return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb 24                	jmp    80151a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8014fc:	85 d2                	test   %edx,%edx
  8014fe:	74 15                	je     801515 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801500:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80150e:	89 04 24             	mov    %eax,(%esp)
  801511:	ff d2                	call   *%edx
  801513:	eb 05                	jmp    80151a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801515:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80151a:	83 c4 24             	add    $0x24,%esp
  80151d:	5b                   	pop    %ebx
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <seek>:

int
seek(int fdnum, off_t offset)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801526:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	89 04 24             	mov    %eax,(%esp)
  801533:	e8 c3 fb ff ff       	call   8010fb <fd_lookup>
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 0e                	js     80154a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80153c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801542:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	53                   	push   %ebx
  801550:	83 ec 24             	sub    $0x24,%esp
  801553:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155d:	89 1c 24             	mov    %ebx,(%esp)
  801560:	e8 96 fb ff ff       	call   8010fb <fd_lookup>
  801565:	89 c2                	mov    %eax,%edx
  801567:	85 d2                	test   %edx,%edx
  801569:	78 61                	js     8015cc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 00                	mov    (%eax),%eax
  801577:	89 04 24             	mov    %eax,(%esp)
  80157a:	e8 d2 fb ff ff       	call   801151 <dev_lookup>
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 49                	js     8015cc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801586:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158a:	75 23                	jne    8015af <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80158c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801591:	8b 40 48             	mov    0x48(%eax),%eax
  801594:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  8015a3:	e8 3a ed ff ff       	call   8002e2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ad:	eb 1d                	jmp    8015cc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b2:	8b 52 18             	mov    0x18(%edx),%edx
  8015b5:	85 d2                	test   %edx,%edx
  8015b7:	74 0e                	je     8015c7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015bc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015c0:	89 04 24             	mov    %eax,(%esp)
  8015c3:	ff d2                	call   *%edx
  8015c5:	eb 05                	jmp    8015cc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015cc:	83 c4 24             	add    $0x24,%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    

008015d2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	53                   	push   %ebx
  8015d6:	83 ec 24             	sub    $0x24,%esp
  8015d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	89 04 24             	mov    %eax,(%esp)
  8015e9:	e8 0d fb ff ff       	call   8010fb <fd_lookup>
  8015ee:	89 c2                	mov    %eax,%edx
  8015f0:	85 d2                	test   %edx,%edx
  8015f2:	78 52                	js     801646 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	8b 00                	mov    (%eax),%eax
  801600:	89 04 24             	mov    %eax,(%esp)
  801603:	e8 49 fb ff ff       	call   801151 <dev_lookup>
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 3a                	js     801646 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801613:	74 2c                	je     801641 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801615:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801618:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80161f:	00 00 00 
	stat->st_isdir = 0;
  801622:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801629:	00 00 00 
	stat->st_dev = dev;
  80162c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801632:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801636:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801639:	89 14 24             	mov    %edx,(%esp)
  80163c:	ff 50 14             	call   *0x14(%eax)
  80163f:	eb 05                	jmp    801646 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801641:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801646:	83 c4 24             	add    $0x24,%esp
  801649:	5b                   	pop    %ebx
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
  801651:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801654:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80165b:	00 
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 04 24             	mov    %eax,(%esp)
  801662:	e8 e1 01 00 00       	call   801848 <open>
  801667:	89 c3                	mov    %eax,%ebx
  801669:	85 db                	test   %ebx,%ebx
  80166b:	78 1b                	js     801688 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	89 44 24 04          	mov    %eax,0x4(%esp)
  801674:	89 1c 24             	mov    %ebx,(%esp)
  801677:	e8 56 ff ff ff       	call   8015d2 <fstat>
  80167c:	89 c6                	mov    %eax,%esi
	close(fd);
  80167e:	89 1c 24             	mov    %ebx,(%esp)
  801681:	e8 bd fb ff ff       	call   801243 <close>
	return r;
  801686:	89 f0                	mov    %esi,%eax
}
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    

0080168f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 10             	sub    $0x10,%esp
  801697:	89 c3                	mov    %eax,%ebx
  801699:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80169b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016a2:	75 11                	jne    8016b5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016ab:	e8 a4 0e 00 00       	call   802554 <ipc_find_env>
  8016b0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8016b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8016ba:	8b 40 48             	mov    0x48(%eax),%eax
  8016bd:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8016c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	c7 04 24 26 2d 80 00 	movl   $0x802d26,(%esp)
  8016d6:	e8 07 ec ff ff       	call   8002e2 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016db:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016e2:	00 
  8016e3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016ea:	00 
  8016eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ef:	a1 00 40 80 00       	mov    0x804000,%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 f2 0d 00 00       	call   8024ee <ipc_send>
	cprintf("ipc_send\n");
  8016fc:	c7 04 24 3c 2d 80 00 	movl   $0x802d3c,(%esp)
  801703:	e8 da eb ff ff       	call   8002e2 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801708:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80170f:	00 
  801710:	89 74 24 04          	mov    %esi,0x4(%esp)
  801714:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171b:	e8 66 0d 00 00       	call   802486 <ipc_recv>
}
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    

00801727 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
  80172b:	83 ec 14             	sub    $0x14,%esp
  80172e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 40 0c             	mov    0xc(%eax),%eax
  801737:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80173c:	ba 00 00 00 00       	mov    $0x0,%edx
  801741:	b8 05 00 00 00       	mov    $0x5,%eax
  801746:	e8 44 ff ff ff       	call   80168f <fsipc>
  80174b:	89 c2                	mov    %eax,%edx
  80174d:	85 d2                	test   %edx,%edx
  80174f:	78 2b                	js     80177c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801751:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801758:	00 
  801759:	89 1c 24             	mov    %ebx,(%esp)
  80175c:	e8 da f1 ff ff       	call   80093b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801761:	a1 80 50 80 00       	mov    0x805080,%eax
  801766:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80176c:	a1 84 50 80 00       	mov    0x805084,%eax
  801771:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177c:	83 c4 14             	add    $0x14,%esp
  80177f:	5b                   	pop    %ebx
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8b 40 0c             	mov    0xc(%eax),%eax
  80178e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801793:	ba 00 00 00 00       	mov    $0x0,%edx
  801798:	b8 06 00 00 00       	mov    $0x6,%eax
  80179d:	e8 ed fe ff ff       	call   80168f <fsipc>
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 10             	sub    $0x10,%esp
  8017ac:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017ba:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ca:	e8 c0 fe ff ff       	call   80168f <fsipc>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 6a                	js     80183f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017d5:	39 c6                	cmp    %eax,%esi
  8017d7:	73 24                	jae    8017fd <devfile_read+0x59>
  8017d9:	c7 44 24 0c 46 2d 80 	movl   $0x802d46,0xc(%esp)
  8017e0:	00 
  8017e1:	c7 44 24 08 4d 2d 80 	movl   $0x802d4d,0x8(%esp)
  8017e8:	00 
  8017e9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8017f0:	00 
  8017f1:	c7 04 24 62 2d 80 00 	movl   $0x802d62,(%esp)
  8017f8:	e8 ec e9 ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  8017fd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801802:	7e 24                	jle    801828 <devfile_read+0x84>
  801804:	c7 44 24 0c 6d 2d 80 	movl   $0x802d6d,0xc(%esp)
  80180b:	00 
  80180c:	c7 44 24 08 4d 2d 80 	movl   $0x802d4d,0x8(%esp)
  801813:	00 
  801814:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80181b:	00 
  80181c:	c7 04 24 62 2d 80 00 	movl   $0x802d62,(%esp)
  801823:	e8 c1 e9 ff ff       	call   8001e9 <_panic>
	memmove(buf, &fsipcbuf, r);
  801828:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801833:	00 
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	89 04 24             	mov    %eax,(%esp)
  80183a:	e8 f7 f2 ff ff       	call   800b36 <memmove>
	return r;
}
  80183f:	89 d8                	mov    %ebx,%eax
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 24             	sub    $0x24,%esp
  80184f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801852:	89 1c 24             	mov    %ebx,(%esp)
  801855:	e8 86 f0 ff ff       	call   8008e0 <strlen>
  80185a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80185f:	7f 60                	jg     8018c1 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801864:	89 04 24             	mov    %eax,(%esp)
  801867:	e8 1b f8 ff ff       	call   801087 <fd_alloc>
  80186c:	89 c2                	mov    %eax,%edx
  80186e:	85 d2                	test   %edx,%edx
  801870:	78 54                	js     8018c6 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801872:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801876:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80187d:	e8 b9 f0 ff ff       	call   80093b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80188a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188d:	b8 01 00 00 00       	mov    $0x1,%eax
  801892:	e8 f8 fd ff ff       	call   80168f <fsipc>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	85 c0                	test   %eax,%eax
  80189b:	79 17                	jns    8018b4 <open+0x6c>
		fd_close(fd, 0);
  80189d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018a4:	00 
  8018a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a8:	89 04 24             	mov    %eax,(%esp)
  8018ab:	e8 12 f9 ff ff       	call   8011c2 <fd_close>
		return r;
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	eb 12                	jmp    8018c6 <open+0x7e>
	}
	return fd2num(fd);
  8018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b7:	89 04 24             	mov    %eax,(%esp)
  8018ba:	e8 a1 f7 ff ff       	call   801060 <fd2num>
  8018bf:	eb 05                	jmp    8018c6 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018c1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8018c6:	83 c4 24             	add    $0x24,%esp
  8018c9:	5b                   	pop    %ebx
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
  8018cc:	66 90                	xchg   %ax,%ax
  8018ce:	66 90                	xchg   %ax,%ax

008018d0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	57                   	push   %edi
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  8018dc:	c7 04 24 79 2d 80 00 	movl   $0x802d79,(%esp)
  8018e3:	e8 fa e9 ff ff       	call   8002e2 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  8018e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ef:	00 
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	89 04 24             	mov    %eax,(%esp)
  8018f6:	e8 4d ff ff ff       	call   801848 <open>
  8018fb:	89 c7                	mov    %eax,%edi
  8018fd:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801903:	85 c0                	test   %eax,%eax
  801905:	0f 88 09 05 00 00    	js     801e14 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  80190b:	c7 04 24 80 2d 80 00 	movl   $0x802d80,(%esp)
  801912:	e8 cb e9 ff ff       	call   8002e2 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801917:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80191e:	00 
  80191f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801925:	89 44 24 04          	mov    %eax,0x4(%esp)
  801929:	89 3c 24             	mov    %edi,(%esp)
  80192c:	e8 07 fb ff ff       	call   801438 <readn>
  801931:	3d 00 02 00 00       	cmp    $0x200,%eax
  801936:	75 0c                	jne    801944 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  801938:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80193f:	45 4c 46 
  801942:	74 36                	je     80197a <spawn+0xaa>
		close(fd);
  801944:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80194a:	89 04 24             	mov    %eax,(%esp)
  80194d:	e8 f1 f8 ff ff       	call   801243 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801952:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801959:	46 
  80195a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801960:	89 44 24 04          	mov    %eax,0x4(%esp)
  801964:	c7 04 24 92 2d 80 00 	movl   $0x802d92,(%esp)
  80196b:	e8 72 e9 ff ff       	call   8002e2 <cprintf>
		return -E_NOT_EXEC;
  801970:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801975:	e9 f9 04 00 00       	jmp    801e73 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  80197a:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
  801981:	e8 5c e9 ff ff       	call   8002e2 <cprintf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801986:	b8 07 00 00 00       	mov    $0x7,%eax
  80198b:	cd 30                	int    $0x30
  80198d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801993:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801999:	85 c0                	test   %eax,%eax
  80199b:	0f 88 7b 04 00 00    	js     801e1c <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019a1:	89 c6                	mov    %eax,%esi
  8019a3:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8019a9:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8019ac:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8019b2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019b8:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019bf:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019c5:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  8019cb:	c7 04 24 b9 2d 80 00 	movl   $0x802db9,(%esp)
  8019d2:	e8 0b e9 ff ff       	call   8002e2 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019da:	8b 00                	mov    (%eax),%eax
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	74 38                	je     801a18 <spawn+0x148>
  8019e0:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8019e5:	be 00 00 00 00       	mov    $0x0,%esi
  8019ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8019ed:	89 04 24             	mov    %eax,(%esp)
  8019f0:	e8 eb ee ff ff       	call   8008e0 <strlen>
  8019f5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019f9:	83 c3 01             	add    $0x1,%ebx
  8019fc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a03:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a06:	85 c0                	test   %eax,%eax
  801a08:	75 e3                	jne    8019ed <spawn+0x11d>
  801a0a:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801a10:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a16:	eb 1e                	jmp    801a36 <spawn+0x166>
  801a18:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801a1f:	00 00 00 
  801a22:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801a29:	00 00 00 
  801a2c:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801a31:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a36:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a3b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a3d:	89 fa                	mov    %edi,%edx
  801a3f:	83 e2 fc             	and    $0xfffffffc,%edx
  801a42:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a49:	29 c2                	sub    %eax,%edx
  801a4b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a51:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a54:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a59:	0f 86 cd 03 00 00    	jbe    801e2c <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a5f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a66:	00 
  801a67:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a6e:	00 
  801a6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a76:	e8 6e f3 ff ff       	call   800de9 <sys_page_alloc>
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	0f 88 f0 03 00 00    	js     801e73 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a83:	85 db                	test   %ebx,%ebx
  801a85:	7e 46                	jle    801acd <spawn+0x1fd>
  801a87:	be 00 00 00 00       	mov    $0x0,%esi
  801a8c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  801a95:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a9b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801aa1:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801aa4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	89 3c 24             	mov    %edi,(%esp)
  801aae:	e8 88 ee ff ff       	call   80093b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ab3:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801ab6:	89 04 24             	mov    %eax,(%esp)
  801ab9:	e8 22 ee ff ff       	call   8008e0 <strlen>
  801abe:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ac2:	83 c6 01             	add    $0x1,%esi
  801ac5:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801acb:	75 c8                	jne    801a95 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801acd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ad3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ad9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ae0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ae6:	74 24                	je     801b0c <spawn+0x23c>
  801ae8:	c7 44 24 0c 2c 2e 80 	movl   $0x802e2c,0xc(%esp)
  801aef:	00 
  801af0:	c7 44 24 08 4d 2d 80 	movl   $0x802d4d,0x8(%esp)
  801af7:	00 
  801af8:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  801aff:	00 
  801b00:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  801b07:	e8 dd e6 ff ff       	call   8001e9 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b0c:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b12:	89 c8                	mov    %ecx,%eax
  801b14:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801b19:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b1c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801b22:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b25:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801b2b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b31:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801b38:	00 
  801b39:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801b40:	ee 
  801b41:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b47:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b52:	00 
  801b53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5a:	e8 de f2 ff ff       	call   800e3d <sys_page_map>
  801b5f:	89 c3                	mov    %eax,%ebx
  801b61:	85 c0                	test   %eax,%eax
  801b63:	0f 88 f4 02 00 00    	js     801e5d <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b69:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b70:	00 
  801b71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b78:	e8 13 f3 ff ff       	call   800e90 <sys_page_unmap>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	0f 88 d6 02 00 00    	js     801e5d <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801b87:	c7 04 24 d1 2d 80 00 	movl   $0x802dd1,(%esp)
  801b8e:	e8 4f e7 ff ff       	call   8002e2 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b93:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b99:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801ba0:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ba6:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801bad:	00 
  801bae:	0f 84 dc 01 00 00    	je     801d90 <spawn+0x4c0>
  801bb4:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801bbb:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801bbe:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801bc4:	83 38 01             	cmpl   $0x1,(%eax)
  801bc7:	0f 85 a2 01 00 00    	jne    801d6f <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801bcd:	89 c1                	mov    %eax,%ecx
  801bcf:	8b 40 18             	mov    0x18(%eax),%eax
  801bd2:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801bd5:	83 f8 01             	cmp    $0x1,%eax
  801bd8:	19 c0                	sbb    %eax,%eax
  801bda:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801be0:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801be7:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801bee:	89 c8                	mov    %ecx,%eax
  801bf0:	8b 51 04             	mov    0x4(%ecx),%edx
  801bf3:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801bf9:	8b 79 10             	mov    0x10(%ecx),%edi
  801bfc:	8b 49 14             	mov    0x14(%ecx),%ecx
  801bff:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801c05:	8b 40 08             	mov    0x8(%eax),%eax
  801c08:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801c0e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c13:	74 14                	je     801c29 <spawn+0x359>
		va -= i;
  801c15:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801c1b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801c21:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801c23:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801c29:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801c30:	0f 84 39 01 00 00    	je     801d6f <spawn+0x49f>
  801c36:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c3b:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801c40:	39 f7                	cmp    %esi,%edi
  801c42:	77 31                	ja     801c75 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c44:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4e:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c54:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c58:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 83 f1 ff ff       	call   800de9 <sys_page_alloc>
  801c66:	85 c0                	test   %eax,%eax
  801c68:	0f 89 ed 00 00 00    	jns    801d5b <spawn+0x48b>
  801c6e:	89 c3                	mov    %eax,%ebx
  801c70:	e9 c8 01 00 00       	jmp    801e3d <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c75:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c7c:	00 
  801c7d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c84:	00 
  801c85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8c:	e8 58 f1 ff ff       	call   800de9 <sys_page_alloc>
  801c91:	85 c0                	test   %eax,%eax
  801c93:	0f 88 9a 01 00 00    	js     801e33 <spawn+0x563>
  801c99:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c9f:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cab:	89 04 24             	mov    %eax,(%esp)
  801cae:	e8 6d f8 ff ff       	call   801520 <seek>
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	0f 88 7c 01 00 00    	js     801e37 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801cbb:	89 fa                	mov    %edi,%edx
  801cbd:	29 f2                	sub    %esi,%edx
  801cbf:	89 d0                	mov    %edx,%eax
  801cc1:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  801cc7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ccc:	0f 47 c1             	cmova  %ecx,%eax
  801ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cda:	00 
  801cdb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ce1:	89 04 24             	mov    %eax,(%esp)
  801ce4:	e8 4f f7 ff ff       	call   801438 <readn>
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	0f 88 4a 01 00 00    	js     801e3b <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801cf1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801cf7:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cfb:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801d01:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d05:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d0f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d16:	00 
  801d17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1e:	e8 1a f1 ff ff       	call   800e3d <sys_page_map>
  801d23:	85 c0                	test   %eax,%eax
  801d25:	79 20                	jns    801d47 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  801d27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2b:	c7 44 24 08 de 2d 80 	movl   $0x802dde,0x8(%esp)
  801d32:	00 
  801d33:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  801d3a:	00 
  801d3b:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  801d42:	e8 a2 e4 ff ff       	call   8001e9 <_panic>
			sys_page_unmap(0, UTEMP);
  801d47:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d4e:	00 
  801d4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d56:	e8 35 f1 ff ff       	call   800e90 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801d5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d61:	89 de                	mov    %ebx,%esi
  801d63:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801d69:	0f 82 d1 fe ff ff    	jb     801c40 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d6f:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801d76:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801d7d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d84:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  801d8a:	0f 8f 2e fe ff ff    	jg     801bbe <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801d90:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 a5 f4 ff ff       	call   801243 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d9e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 80 f1 ff ff       	call   800f36 <sys_env_set_trapframe>
  801db6:	85 c0                	test   %eax,%eax
  801db8:	79 20                	jns    801dda <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  801dba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dbe:	c7 44 24 08 fb 2d 80 	movl   $0x802dfb,0x8(%esp)
  801dc5:	00 
  801dc6:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  801dcd:	00 
  801dce:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  801dd5:	e8 0f e4 ff ff       	call   8001e9 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dda:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801de1:	00 
  801de2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801de8:	89 04 24             	mov    %eax,(%esp)
  801deb:	e8 f3 f0 ff ff       	call   800ee3 <sys_env_set_status>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	79 30                	jns    801e24 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  801df4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df8:	c7 44 24 08 15 2e 80 	movl   $0x802e15,0x8(%esp)
  801dff:	00 
  801e00:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801e07:	00 
  801e08:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  801e0f:	e8 d5 e3 ff ff       	call   8001e9 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801e14:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e1a:	eb 57                	jmp    801e73 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801e1c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e22:	eb 4f                	jmp    801e73 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  801e24:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e2a:	eb 47                	jmp    801e73 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e2c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801e31:	eb 40                	jmp    801e73 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e33:	89 c3                	mov    %eax,%ebx
  801e35:	eb 06                	jmp    801e3d <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	eb 02                	jmp    801e3d <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e3b:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  801e3d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e43:	89 04 24             	mov    %eax,(%esp)
  801e46:	e8 0e ef ff ff       	call   800d59 <sys_env_destroy>
	close(fd);
  801e4b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e51:	89 04 24             	mov    %eax,(%esp)
  801e54:	e8 ea f3 ff ff       	call   801243 <close>
	return r;
  801e59:	89 d8                	mov    %ebx,%eax
  801e5b:	eb 16                	jmp    801e73 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801e5d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e64:	00 
  801e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6c:	e8 1f f0 ff ff       	call   800e90 <sys_page_unmap>
  801e71:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801e73:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5f                   	pop    %edi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8b:	74 61                	je     801eee <spawnl+0x70>
  801e8d:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801e90:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  801e95:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e98:	83 c0 04             	add    $0x4,%eax
  801e9b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801e9f:	74 04                	je     801ea5 <spawnl+0x27>
		argc++;
  801ea1:	89 ca                	mov    %ecx,%edx
  801ea3:	eb f0                	jmp    801e95 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801ea5:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  801eac:	83 e0 f0             	and    $0xfffffff0,%eax
  801eaf:	29 c4                	sub    %eax,%esp
  801eb1:	8d 74 24 0b          	lea    0xb(%esp),%esi
  801eb5:	c1 ee 02             	shr    $0x2,%esi
  801eb8:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  801ebf:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  801ec1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ec4:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  801ecb:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  801ed2:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801ed3:	89 ce                	mov    %ecx,%esi
  801ed5:	85 c9                	test   %ecx,%ecx
  801ed7:	74 25                	je     801efe <spawnl+0x80>
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  801ede:	83 c0 01             	add    $0x1,%eax
  801ee1:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  801ee5:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801ee8:	39 f0                	cmp    %esi,%eax
  801eea:	75 f2                	jne    801ede <spawnl+0x60>
  801eec:	eb 10                	jmp    801efe <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  801ef4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801efb:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801efe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	89 04 24             	mov    %eax,(%esp)
  801f08:	e8 c3 f9 ff ff       	call   8018d0 <spawn>
}
  801f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
  801f15:	66 90                	xchg   %ax,%ax
  801f17:	66 90                	xchg   %ax,%ax
  801f19:	66 90                	xchg   %ax,%ax
  801f1b:	66 90                	xchg   %ax,%ax
  801f1d:	66 90                	xchg   %ax,%ax
  801f1f:	90                   	nop

00801f20 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	56                   	push   %esi
  801f24:	53                   	push   %ebx
  801f25:	83 ec 10             	sub    $0x10,%esp
  801f28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	89 04 24             	mov    %eax,(%esp)
  801f31:	e8 3a f1 ff ff       	call   801070 <fd2data>
  801f36:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f38:	c7 44 24 04 54 2e 80 	movl   $0x802e54,0x4(%esp)
  801f3f:	00 
  801f40:	89 1c 24             	mov    %ebx,(%esp)
  801f43:	e8 f3 e9 ff ff       	call   80093b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f48:	8b 46 04             	mov    0x4(%esi),%eax
  801f4b:	2b 06                	sub    (%esi),%eax
  801f4d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f53:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f5a:	00 00 00 
	stat->st_dev = &devpipe;
  801f5d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801f64:	30 80 00 
	return 0;
}
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	53                   	push   %ebx
  801f77:	83 ec 14             	sub    $0x14,%esp
  801f7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f88:	e8 03 ef ff ff       	call   800e90 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f8d:	89 1c 24             	mov    %ebx,(%esp)
  801f90:	e8 db f0 ff ff       	call   801070 <fd2data>
  801f95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa0:	e8 eb ee ff ff       	call   800e90 <sys_page_unmap>
}
  801fa5:	83 c4 14             	add    $0x14,%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	57                   	push   %edi
  801faf:	56                   	push   %esi
  801fb0:	53                   	push   %ebx
  801fb1:	83 ec 2c             	sub    $0x2c,%esp
  801fb4:	89 c6                	mov    %eax,%esi
  801fb6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801fb9:	a1 04 40 80 00       	mov    0x804004,%eax
  801fbe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fc1:	89 34 24             	mov    %esi,(%esp)
  801fc4:	e8 d3 05 00 00       	call   80259c <pageref>
  801fc9:	89 c7                	mov    %eax,%edi
  801fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 c6 05 00 00       	call   80259c <pageref>
  801fd6:	39 c7                	cmp    %eax,%edi
  801fd8:	0f 94 c2             	sete   %dl
  801fdb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fde:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801fe4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fe7:	39 fb                	cmp    %edi,%ebx
  801fe9:	74 21                	je     80200c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801feb:	84 d2                	test   %dl,%dl
  801fed:	74 ca                	je     801fb9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fef:	8b 51 58             	mov    0x58(%ecx),%edx
  801ff2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ff6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ffa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ffe:	c7 04 24 5b 2e 80 00 	movl   $0x802e5b,(%esp)
  802005:	e8 d8 e2 ff ff       	call   8002e2 <cprintf>
  80200a:	eb ad                	jmp    801fb9 <_pipeisclosed+0xe>
	}
}
  80200c:	83 c4 2c             	add    $0x2c,%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5f                   	pop    %edi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    

00802014 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	57                   	push   %edi
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
  80201a:	83 ec 1c             	sub    $0x1c,%esp
  80201d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802020:	89 34 24             	mov    %esi,(%esp)
  802023:	e8 48 f0 ff ff       	call   801070 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80202c:	74 61                	je     80208f <devpipe_write+0x7b>
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	bf 00 00 00 00       	mov    $0x0,%edi
  802035:	eb 4a                	jmp    802081 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802037:	89 da                	mov    %ebx,%edx
  802039:	89 f0                	mov    %esi,%eax
  80203b:	e8 6b ff ff ff       	call   801fab <_pipeisclosed>
  802040:	85 c0                	test   %eax,%eax
  802042:	75 54                	jne    802098 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802044:	e8 81 ed ff ff       	call   800dca <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802049:	8b 43 04             	mov    0x4(%ebx),%eax
  80204c:	8b 0b                	mov    (%ebx),%ecx
  80204e:	8d 51 20             	lea    0x20(%ecx),%edx
  802051:	39 d0                	cmp    %edx,%eax
  802053:	73 e2                	jae    802037 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802055:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802058:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80205c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80205f:	99                   	cltd   
  802060:	c1 ea 1b             	shr    $0x1b,%edx
  802063:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802066:	83 e1 1f             	and    $0x1f,%ecx
  802069:	29 d1                	sub    %edx,%ecx
  80206b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80206f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802073:	83 c0 01             	add    $0x1,%eax
  802076:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802079:	83 c7 01             	add    $0x1,%edi
  80207c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80207f:	74 13                	je     802094 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802081:	8b 43 04             	mov    0x4(%ebx),%eax
  802084:	8b 0b                	mov    (%ebx),%ecx
  802086:	8d 51 20             	lea    0x20(%ecx),%edx
  802089:	39 d0                	cmp    %edx,%eax
  80208b:	73 aa                	jae    802037 <devpipe_write+0x23>
  80208d:	eb c6                	jmp    802055 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80208f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802094:	89 f8                	mov    %edi,%eax
  802096:	eb 05                	jmp    80209d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80209d:	83 c4 1c             	add    $0x1c,%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5f                   	pop    %edi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    

008020a5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	57                   	push   %edi
  8020a9:	56                   	push   %esi
  8020aa:	53                   	push   %ebx
  8020ab:	83 ec 1c             	sub    $0x1c,%esp
  8020ae:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8020b1:	89 3c 24             	mov    %edi,(%esp)
  8020b4:	e8 b7 ef ff ff       	call   801070 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bd:	74 54                	je     802113 <devpipe_read+0x6e>
  8020bf:	89 c3                	mov    %eax,%ebx
  8020c1:	be 00 00 00 00       	mov    $0x0,%esi
  8020c6:	eb 3e                	jmp    802106 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8020c8:	89 f0                	mov    %esi,%eax
  8020ca:	eb 55                	jmp    802121 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020cc:	89 da                	mov    %ebx,%edx
  8020ce:	89 f8                	mov    %edi,%eax
  8020d0:	e8 d6 fe ff ff       	call   801fab <_pipeisclosed>
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	75 43                	jne    80211c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020d9:	e8 ec ec ff ff       	call   800dca <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020de:	8b 03                	mov    (%ebx),%eax
  8020e0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020e3:	74 e7                	je     8020cc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020e5:	99                   	cltd   
  8020e6:	c1 ea 1b             	shr    $0x1b,%edx
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	83 e0 1f             	and    $0x1f,%eax
  8020ee:	29 d0                	sub    %edx,%eax
  8020f0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020f8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020fb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020fe:	83 c6 01             	add    $0x1,%esi
  802101:	3b 75 10             	cmp    0x10(%ebp),%esi
  802104:	74 12                	je     802118 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802106:	8b 03                	mov    (%ebx),%eax
  802108:	3b 43 04             	cmp    0x4(%ebx),%eax
  80210b:	75 d8                	jne    8020e5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80210d:	85 f6                	test   %esi,%esi
  80210f:	75 b7                	jne    8020c8 <devpipe_read+0x23>
  802111:	eb b9                	jmp    8020cc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802113:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802118:	89 f0                	mov    %esi,%eax
  80211a:	eb 05                	jmp    802121 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802121:	83 c4 1c             	add    $0x1c,%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5f                   	pop    %edi
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    

00802129 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802131:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802134:	89 04 24             	mov    %eax,(%esp)
  802137:	e8 4b ef ff ff       	call   801087 <fd_alloc>
  80213c:	89 c2                	mov    %eax,%edx
  80213e:	85 d2                	test   %edx,%edx
  802140:	0f 88 4d 01 00 00    	js     802293 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802146:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80214d:	00 
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 44 24 04          	mov    %eax,0x4(%esp)
  802155:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215c:	e8 88 ec ff ff       	call   800de9 <sys_page_alloc>
  802161:	89 c2                	mov    %eax,%edx
  802163:	85 d2                	test   %edx,%edx
  802165:	0f 88 28 01 00 00    	js     802293 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80216b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80216e:	89 04 24             	mov    %eax,(%esp)
  802171:	e8 11 ef ff ff       	call   801087 <fd_alloc>
  802176:	89 c3                	mov    %eax,%ebx
  802178:	85 c0                	test   %eax,%eax
  80217a:	0f 88 fe 00 00 00    	js     80227e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802180:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802187:	00 
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802196:	e8 4e ec ff ff       	call   800de9 <sys_page_alloc>
  80219b:	89 c3                	mov    %eax,%ebx
  80219d:	85 c0                	test   %eax,%eax
  80219f:	0f 88 d9 00 00 00    	js     80227e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	89 04 24             	mov    %eax,(%esp)
  8021ab:	e8 c0 ee ff ff       	call   801070 <fd2data>
  8021b0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021b9:	00 
  8021ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c5:	e8 1f ec ff ff       	call   800de9 <sys_page_alloc>
  8021ca:	89 c3                	mov    %eax,%ebx
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 88 97 00 00 00    	js     80226b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	89 04 24             	mov    %eax,(%esp)
  8021da:	e8 91 ee ff ff       	call   801070 <fd2data>
  8021df:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021e6:	00 
  8021e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021f2:	00 
  8021f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021fe:	e8 3a ec ff ff       	call   800e3d <sys_page_map>
  802203:	89 c3                	mov    %eax,%ebx
  802205:	85 c0                	test   %eax,%eax
  802207:	78 52                	js     80225b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802209:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80221e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 22 ee ff ff       	call   801060 <fd2num>
  80223e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802241:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	89 04 24             	mov    %eax,(%esp)
  802249:	e8 12 ee ff ff       	call   801060 <fd2num>
  80224e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802251:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	eb 38                	jmp    802293 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80225b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802266:	e8 25 ec ff ff       	call   800e90 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80226b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802272:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802279:	e8 12 ec ff ff       	call   800e90 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	89 44 24 04          	mov    %eax,0x4(%esp)
  802285:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80228c:	e8 ff eb ff ff       	call   800e90 <sys_page_unmap>
  802291:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802293:	83 c4 30             	add    $0x30,%esp
  802296:	5b                   	pop    %ebx
  802297:	5e                   	pop    %esi
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	89 04 24             	mov    %eax,(%esp)
  8022ad:	e8 49 ee ff ff       	call   8010fb <fd_lookup>
  8022b2:	89 c2                	mov    %eax,%edx
  8022b4:	85 d2                	test   %edx,%edx
  8022b6:	78 15                	js     8022cd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	89 04 24             	mov    %eax,(%esp)
  8022be:	e8 ad ed ff ff       	call   801070 <fd2data>
	return _pipeisclosed(fd, p);
  8022c3:	89 c2                	mov    %eax,%edx
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	e8 de fc ff ff       	call   801fab <_pipeisclosed>
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    
  8022cf:	90                   	nop

008022d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    

008022da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022e0:	c7 44 24 04 73 2e 80 	movl   $0x802e73,0x4(%esp)
  8022e7:	00 
  8022e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022eb:	89 04 24             	mov    %eax,(%esp)
  8022ee:	e8 48 e6 ff ff       	call   80093b <strcpy>
	return 0;
}
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	57                   	push   %edi
  8022fe:	56                   	push   %esi
  8022ff:	53                   	push   %ebx
  802300:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802306:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80230a:	74 4a                	je     802356 <devcons_write+0x5c>
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
  802311:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802316:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80231c:	8b 75 10             	mov    0x10(%ebp),%esi
  80231f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802321:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802324:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802329:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80232c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802330:	03 45 0c             	add    0xc(%ebp),%eax
  802333:	89 44 24 04          	mov    %eax,0x4(%esp)
  802337:	89 3c 24             	mov    %edi,(%esp)
  80233a:	e8 f7 e7 ff ff       	call   800b36 <memmove>
		sys_cputs(buf, m);
  80233f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802343:	89 3c 24             	mov    %edi,(%esp)
  802346:	e8 d1 e9 ff ff       	call   800d1c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80234b:	01 f3                	add    %esi,%ebx
  80234d:	89 d8                	mov    %ebx,%eax
  80234f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802352:	72 c8                	jb     80231c <devcons_write+0x22>
  802354:	eb 05                	jmp    80235b <devcons_write+0x61>
  802356:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802363:	5b                   	pop    %ebx
  802364:	5e                   	pop    %esi
  802365:	5f                   	pop    %edi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802373:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802377:	75 07                	jne    802380 <devcons_read+0x18>
  802379:	eb 28                	jmp    8023a3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80237b:	e8 4a ea ff ff       	call   800dca <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802380:	e8 b5 e9 ff ff       	call   800d3a <sys_cgetc>
  802385:	85 c0                	test   %eax,%eax
  802387:	74 f2                	je     80237b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802389:	85 c0                	test   %eax,%eax
  80238b:	78 16                	js     8023a3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80238d:	83 f8 04             	cmp    $0x4,%eax
  802390:	74 0c                	je     80239e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802392:	8b 55 0c             	mov    0xc(%ebp),%edx
  802395:	88 02                	mov    %al,(%edx)
	return 1;
  802397:	b8 01 00 00 00       	mov    $0x1,%eax
  80239c:	eb 05                	jmp    8023a3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8023b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023b8:	00 
  8023b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023bc:	89 04 24             	mov    %eax,(%esp)
  8023bf:	e8 58 e9 ff ff       	call   800d1c <sys_cputs>
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <getchar>:

int
getchar(void)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023d3:	00 
  8023d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e2:	e8 bf ef ff ff       	call   8013a6 <read>
	if (r < 0)
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	78 0f                	js     8023fa <getchar+0x34>
		return r;
	if (r < 1)
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	7e 06                	jle    8023f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023f3:	eb 05                	jmp    8023fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802405:	89 44 24 04          	mov    %eax,0x4(%esp)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	89 04 24             	mov    %eax,(%esp)
  80240f:	e8 e7 ec ff ff       	call   8010fb <fd_lookup>
  802414:	85 c0                	test   %eax,%eax
  802416:	78 11                	js     802429 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802421:	39 10                	cmp    %edx,(%eax)
  802423:	0f 94 c0             	sete   %al
  802426:	0f b6 c0             	movzbl %al,%eax
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <opencons>:

int
opencons(void)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802431:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802434:	89 04 24             	mov    %eax,(%esp)
  802437:	e8 4b ec ff ff       	call   801087 <fd_alloc>
		return r;
  80243c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80243e:	85 c0                	test   %eax,%eax
  802440:	78 40                	js     802482 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802442:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802449:	00 
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802451:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802458:	e8 8c e9 ff ff       	call   800de9 <sys_page_alloc>
		return r;
  80245d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80245f:	85 c0                	test   %eax,%eax
  802461:	78 1f                	js     802482 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802463:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802478:	89 04 24             	mov    %eax,(%esp)
  80247b:	e8 e0 eb ff ff       	call   801060 <fd2num>
  802480:	89 c2                	mov    %eax,%edx
}
  802482:	89 d0                	mov    %edx,%eax
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	56                   	push   %esi
  80248a:	53                   	push   %ebx
  80248b:	83 ec 10             	sub    $0x10,%esp
  80248e:	8b 75 08             	mov    0x8(%ebp),%esi
  802491:	8b 45 0c             	mov    0xc(%ebp),%eax
  802494:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  802497:	85 c0                	test   %eax,%eax
  802499:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80249e:	0f 44 c2             	cmove  %edx,%eax
  8024a1:	89 04 24             	mov    %eax,(%esp)
  8024a4:	e8 56 eb ff ff       	call   800fff <sys_ipc_recv>
	if (err_code < 0) {
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	79 16                	jns    8024c3 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8024ad:	85 f6                	test   %esi,%esi
  8024af:	74 06                	je     8024b7 <ipc_recv+0x31>
  8024b1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8024b7:	85 db                	test   %ebx,%ebx
  8024b9:	74 2c                	je     8024e7 <ipc_recv+0x61>
  8024bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024c1:	eb 24                	jmp    8024e7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8024c3:	85 f6                	test   %esi,%esi
  8024c5:	74 0a                	je     8024d1 <ipc_recv+0x4b>
  8024c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8024cc:	8b 40 74             	mov    0x74(%eax),%eax
  8024cf:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8024d1:	85 db                	test   %ebx,%ebx
  8024d3:	74 0a                	je     8024df <ipc_recv+0x59>
  8024d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8024da:	8b 40 78             	mov    0x78(%eax),%eax
  8024dd:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8024df:	a1 04 40 80 00       	mov    0x804004,%eax
  8024e4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	5b                   	pop    %ebx
  8024eb:	5e                   	pop    %esi
  8024ec:	5d                   	pop    %ebp
  8024ed:	c3                   	ret    

008024ee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802500:	eb 25                	jmp    802527 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802502:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802505:	74 20                	je     802527 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802507:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80250b:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  802512:	00 
  802513:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80251a:	00 
  80251b:	c7 04 24 8b 2e 80 00 	movl   $0x802e8b,(%esp)
  802522:	e8 c2 dc ff ff       	call   8001e9 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802527:	85 db                	test   %ebx,%ebx
  802529:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80252e:	0f 45 c3             	cmovne %ebx,%eax
  802531:	8b 55 14             	mov    0x14(%ebp),%edx
  802534:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802538:	89 44 24 08          	mov    %eax,0x8(%esp)
  80253c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802540:	89 3c 24             	mov    %edi,(%esp)
  802543:	e8 94 ea ff ff       	call   800fdc <sys_ipc_try_send>
  802548:	85 c0                	test   %eax,%eax
  80254a:	75 b6                	jne    802502 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80255a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80255f:	39 c8                	cmp    %ecx,%eax
  802561:	74 17                	je     80257a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802563:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802568:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80256b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802571:	8b 52 50             	mov    0x50(%edx),%edx
  802574:	39 ca                	cmp    %ecx,%edx
  802576:	75 14                	jne    80258c <ipc_find_env+0x38>
  802578:	eb 05                	jmp    80257f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80257f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802582:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802587:	8b 40 40             	mov    0x40(%eax),%eax
  80258a:	eb 0e                	jmp    80259a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80258c:	83 c0 01             	add    $0x1,%eax
  80258f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802594:	75 d2                	jne    802568 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802596:	66 b8 00 00          	mov    $0x0,%ax
}
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    

0080259c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025a2:	89 d0                	mov    %edx,%eax
  8025a4:	c1 e8 16             	shr    $0x16,%eax
  8025a7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025b3:	f6 c1 01             	test   $0x1,%cl
  8025b6:	74 1d                	je     8025d5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025b8:	c1 ea 0c             	shr    $0xc,%edx
  8025bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025c2:	f6 c2 01             	test   $0x1,%dl
  8025c5:	74 0e                	je     8025d5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025c7:	c1 ea 0c             	shr    $0xc,%edx
  8025ca:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025d1:	ef 
  8025d2:	0f b7 c0             	movzwl %ax,%eax
}
  8025d5:	5d                   	pop    %ebp
  8025d6:	c3                   	ret    
  8025d7:	66 90                	xchg   %ax,%ax
  8025d9:	66 90                	xchg   %ax,%ax
  8025db:	66 90                	xchg   %ax,%ax
  8025dd:	66 90                	xchg   %ax,%ax
  8025df:	90                   	nop

008025e0 <__udivdi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025fc:	89 ea                	mov    %ebp,%edx
  8025fe:	89 0c 24             	mov    %ecx,(%esp)
  802601:	75 2d                	jne    802630 <__udivdi3+0x50>
  802603:	39 e9                	cmp    %ebp,%ecx
  802605:	77 61                	ja     802668 <__udivdi3+0x88>
  802607:	85 c9                	test   %ecx,%ecx
  802609:	89 ce                	mov    %ecx,%esi
  80260b:	75 0b                	jne    802618 <__udivdi3+0x38>
  80260d:	b8 01 00 00 00       	mov    $0x1,%eax
  802612:	31 d2                	xor    %edx,%edx
  802614:	f7 f1                	div    %ecx
  802616:	89 c6                	mov    %eax,%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	89 e8                	mov    %ebp,%eax
  80261c:	f7 f6                	div    %esi
  80261e:	89 c5                	mov    %eax,%ebp
  802620:	89 f8                	mov    %edi,%eax
  802622:	f7 f6                	div    %esi
  802624:	89 ea                	mov    %ebp,%edx
  802626:	83 c4 0c             	add    $0xc,%esp
  802629:	5e                   	pop    %esi
  80262a:	5f                   	pop    %edi
  80262b:	5d                   	pop    %ebp
  80262c:	c3                   	ret    
  80262d:	8d 76 00             	lea    0x0(%esi),%esi
  802630:	39 e8                	cmp    %ebp,%eax
  802632:	77 24                	ja     802658 <__udivdi3+0x78>
  802634:	0f bd e8             	bsr    %eax,%ebp
  802637:	83 f5 1f             	xor    $0x1f,%ebp
  80263a:	75 3c                	jne    802678 <__udivdi3+0x98>
  80263c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802640:	39 34 24             	cmp    %esi,(%esp)
  802643:	0f 86 9f 00 00 00    	jbe    8026e8 <__udivdi3+0x108>
  802649:	39 d0                	cmp    %edx,%eax
  80264b:	0f 82 97 00 00 00    	jb     8026e8 <__udivdi3+0x108>
  802651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802658:	31 d2                	xor    %edx,%edx
  80265a:	31 c0                	xor    %eax,%eax
  80265c:	83 c4 0c             	add    $0xc,%esp
  80265f:	5e                   	pop    %esi
  802660:	5f                   	pop    %edi
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	89 f8                	mov    %edi,%eax
  80266a:	f7 f1                	div    %ecx
  80266c:	31 d2                	xor    %edx,%edx
  80266e:	83 c4 0c             	add    $0xc,%esp
  802671:	5e                   	pop    %esi
  802672:	5f                   	pop    %edi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    
  802675:	8d 76 00             	lea    0x0(%esi),%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	8b 3c 24             	mov    (%esp),%edi
  80267d:	d3 e0                	shl    %cl,%eax
  80267f:	89 c6                	mov    %eax,%esi
  802681:	b8 20 00 00 00       	mov    $0x20,%eax
  802686:	29 e8                	sub    %ebp,%eax
  802688:	89 c1                	mov    %eax,%ecx
  80268a:	d3 ef                	shr    %cl,%edi
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802692:	8b 3c 24             	mov    (%esp),%edi
  802695:	09 74 24 08          	or     %esi,0x8(%esp)
  802699:	89 d6                	mov    %edx,%esi
  80269b:	d3 e7                	shl    %cl,%edi
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	89 3c 24             	mov    %edi,(%esp)
  8026a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a6:	d3 ee                	shr    %cl,%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	d3 e2                	shl    %cl,%edx
  8026ac:	89 c1                	mov    %eax,%ecx
  8026ae:	d3 ef                	shr    %cl,%edi
  8026b0:	09 d7                	or     %edx,%edi
  8026b2:	89 f2                	mov    %esi,%edx
  8026b4:	89 f8                	mov    %edi,%eax
  8026b6:	f7 74 24 08          	divl   0x8(%esp)
  8026ba:	89 d6                	mov    %edx,%esi
  8026bc:	89 c7                	mov    %eax,%edi
  8026be:	f7 24 24             	mull   (%esp)
  8026c1:	39 d6                	cmp    %edx,%esi
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 30                	jb     8026f8 <__udivdi3+0x118>
  8026c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	d3 e2                	shl    %cl,%edx
  8026d0:	39 c2                	cmp    %eax,%edx
  8026d2:	73 05                	jae    8026d9 <__udivdi3+0xf9>
  8026d4:	3b 34 24             	cmp    (%esp),%esi
  8026d7:	74 1f                	je     8026f8 <__udivdi3+0x118>
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	31 d2                	xor    %edx,%edx
  8026dd:	e9 7a ff ff ff       	jmp    80265c <__udivdi3+0x7c>
  8026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026e8:	31 d2                	xor    %edx,%edx
  8026ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ef:	e9 68 ff ff ff       	jmp    80265c <__udivdi3+0x7c>
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	83 c4 0c             	add    $0xc,%esp
  802700:	5e                   	pop    %esi
  802701:	5f                   	pop    %edi
  802702:	5d                   	pop    %ebp
  802703:	c3                   	ret    
  802704:	66 90                	xchg   %ax,%ax
  802706:	66 90                	xchg   %ax,%ax
  802708:	66 90                	xchg   %ax,%ax
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__umoddi3>:
  802710:	55                   	push   %ebp
  802711:	57                   	push   %edi
  802712:	56                   	push   %esi
  802713:	83 ec 14             	sub    $0x14,%esp
  802716:	8b 44 24 28          	mov    0x28(%esp),%eax
  80271a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80271e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802722:	89 c7                	mov    %eax,%edi
  802724:	89 44 24 04          	mov    %eax,0x4(%esp)
  802728:	8b 44 24 30          	mov    0x30(%esp),%eax
  80272c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802730:	89 34 24             	mov    %esi,(%esp)
  802733:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802737:	85 c0                	test   %eax,%eax
  802739:	89 c2                	mov    %eax,%edx
  80273b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80273f:	75 17                	jne    802758 <__umoddi3+0x48>
  802741:	39 fe                	cmp    %edi,%esi
  802743:	76 4b                	jbe    802790 <__umoddi3+0x80>
  802745:	89 c8                	mov    %ecx,%eax
  802747:	89 fa                	mov    %edi,%edx
  802749:	f7 f6                	div    %esi
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	31 d2                	xor    %edx,%edx
  80274f:	83 c4 14             	add    $0x14,%esp
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	66 90                	xchg   %ax,%ax
  802758:	39 f8                	cmp    %edi,%eax
  80275a:	77 54                	ja     8027b0 <__umoddi3+0xa0>
  80275c:	0f bd e8             	bsr    %eax,%ebp
  80275f:	83 f5 1f             	xor    $0x1f,%ebp
  802762:	75 5c                	jne    8027c0 <__umoddi3+0xb0>
  802764:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802768:	39 3c 24             	cmp    %edi,(%esp)
  80276b:	0f 87 e7 00 00 00    	ja     802858 <__umoddi3+0x148>
  802771:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802775:	29 f1                	sub    %esi,%ecx
  802777:	19 c7                	sbb    %eax,%edi
  802779:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80277d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802781:	8b 44 24 08          	mov    0x8(%esp),%eax
  802785:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802789:	83 c4 14             	add    $0x14,%esp
  80278c:	5e                   	pop    %esi
  80278d:	5f                   	pop    %edi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    
  802790:	85 f6                	test   %esi,%esi
  802792:	89 f5                	mov    %esi,%ebp
  802794:	75 0b                	jne    8027a1 <__umoddi3+0x91>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f6                	div    %esi
  80279f:	89 c5                	mov    %eax,%ebp
  8027a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027a5:	31 d2                	xor    %edx,%edx
  8027a7:	f7 f5                	div    %ebp
  8027a9:	89 c8                	mov    %ecx,%eax
  8027ab:	f7 f5                	div    %ebp
  8027ad:	eb 9c                	jmp    80274b <__umoddi3+0x3b>
  8027af:	90                   	nop
  8027b0:	89 c8                	mov    %ecx,%eax
  8027b2:	89 fa                	mov    %edi,%edx
  8027b4:	83 c4 14             	add    $0x14,%esp
  8027b7:	5e                   	pop    %esi
  8027b8:	5f                   	pop    %edi
  8027b9:	5d                   	pop    %ebp
  8027ba:	c3                   	ret    
  8027bb:	90                   	nop
  8027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	8b 04 24             	mov    (%esp),%eax
  8027c3:	be 20 00 00 00       	mov    $0x20,%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	29 ee                	sub    %ebp,%esi
  8027cc:	d3 e2                	shl    %cl,%edx
  8027ce:	89 f1                	mov    %esi,%ecx
  8027d0:	d3 e8                	shr    %cl,%eax
  8027d2:	89 e9                	mov    %ebp,%ecx
  8027d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d8:	8b 04 24             	mov    (%esp),%eax
  8027db:	09 54 24 04          	or     %edx,0x4(%esp)
  8027df:	89 fa                	mov    %edi,%edx
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 f1                	mov    %esi,%ecx
  8027e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027ed:	d3 ea                	shr    %cl,%edx
  8027ef:	89 e9                	mov    %ebp,%ecx
  8027f1:	d3 e7                	shl    %cl,%edi
  8027f3:	89 f1                	mov    %esi,%ecx
  8027f5:	d3 e8                	shr    %cl,%eax
  8027f7:	89 e9                	mov    %ebp,%ecx
  8027f9:	09 f8                	or     %edi,%eax
  8027fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027ff:	f7 74 24 04          	divl   0x4(%esp)
  802803:	d3 e7                	shl    %cl,%edi
  802805:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802809:	89 d7                	mov    %edx,%edi
  80280b:	f7 64 24 08          	mull   0x8(%esp)
  80280f:	39 d7                	cmp    %edx,%edi
  802811:	89 c1                	mov    %eax,%ecx
  802813:	89 14 24             	mov    %edx,(%esp)
  802816:	72 2c                	jb     802844 <__umoddi3+0x134>
  802818:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80281c:	72 22                	jb     802840 <__umoddi3+0x130>
  80281e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802822:	29 c8                	sub    %ecx,%eax
  802824:	19 d7                	sbb    %edx,%edi
  802826:	89 e9                	mov    %ebp,%ecx
  802828:	89 fa                	mov    %edi,%edx
  80282a:	d3 e8                	shr    %cl,%eax
  80282c:	89 f1                	mov    %esi,%ecx
  80282e:	d3 e2                	shl    %cl,%edx
  802830:	89 e9                	mov    %ebp,%ecx
  802832:	d3 ef                	shr    %cl,%edi
  802834:	09 d0                	or     %edx,%eax
  802836:	89 fa                	mov    %edi,%edx
  802838:	83 c4 14             	add    $0x14,%esp
  80283b:	5e                   	pop    %esi
  80283c:	5f                   	pop    %edi
  80283d:	5d                   	pop    %ebp
  80283e:	c3                   	ret    
  80283f:	90                   	nop
  802840:	39 d7                	cmp    %edx,%edi
  802842:	75 da                	jne    80281e <__umoddi3+0x10e>
  802844:	8b 14 24             	mov    (%esp),%edx
  802847:	89 c1                	mov    %eax,%ecx
  802849:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80284d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802851:	eb cb                	jmp    80281e <__umoddi3+0x10e>
  802853:	90                   	nop
  802854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802858:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80285c:	0f 82 0f ff ff ff    	jb     802771 <__umoddi3+0x61>
  802862:	e9 1a ff ff ff       	jmp    802781 <__umoddi3+0x71>
