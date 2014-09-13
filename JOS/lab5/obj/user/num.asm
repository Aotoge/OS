
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 30             	sub    $0x30,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	e9 84 00 00 00       	jmp    8000ca <num+0x97>
		if (bol) {
  800046:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004d:	74 27                	je     800076 <num+0x43>
			printf("%5d ", ++line);
  80004f:	a1 00 40 80 00       	mov    0x804000,%eax
  800054:	83 c0 01             	add    $0x1,%eax
  800057:	a3 00 40 80 00       	mov    %eax,0x804000
  80005c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800060:	c7 04 24 a0 23 80 00 	movl   $0x8023a0,(%esp)
  800067:	e8 b3 19 00 00       	call   801a1f <printf>
			bol = 0;
  80006c:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800073:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800076:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007d:	00 
  80007e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800089:	e8 75 14 00 00       	call   801503 <write>
  80008e:	83 f8 01             	cmp    $0x1,%eax
  800091:	74 27                	je     8000ba <num+0x87>
			panic("write error copying %s: %e", s, r);
  800093:	89 44 24 10          	mov    %eax,0x10(%esp)
  800097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009e:	c7 44 24 08 a5 23 80 	movl   $0x8023a5,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 c0 23 80 00 	movl   $0x8023c0,(%esp)
  8000b5:	e8 a3 01 00 00       	call   80025d <_panic>
		if (c == '\n')
  8000ba:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000be:	75 0a                	jne    8000ca <num+0x97>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d1:	00 
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	89 34 24             	mov    %esi,(%esp)
  8000d9:	e8 38 13 00 00       	call   801416 <read>
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 8f 60 ff ff ff    	jg     800046 <num+0x13>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	79 27                	jns    800111 <num+0xde>
		panic("error reading %s: %e", s, n);
  8000ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f5:	c7 44 24 08 cb 23 80 	movl   $0x8023cb,0x8(%esp)
  8000fc:	00 
  8000fd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800104:	00 
  800105:	c7 04 24 c0 23 80 00 	movl   $0x8023c0,(%esp)
  80010c:	e8 4c 01 00 00       	call   80025d <_panic>
}
  800111:	83 c4 30             	add    $0x30,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 2c             	sub    $0x2c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 e0 	movl   $0x8023e0,0x803004
  800128:	23 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 13                	je     800144 <umain+0x2c>
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800140:	7f 18                	jg     80015a <umain+0x42>
  800142:	eb 7b                	jmp    8001bf <umain+0xa7>
{
	int f, i;

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
  800144:	c7 44 24 04 e4 23 80 	movl   $0x8023e4,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800153:	e8 db fe ff ff       	call   800033 <num>
  800158:	eb 65                	jmp    8001bf <umain+0xa7>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80015a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80015d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800164:	00 
  800165:	8b 03                	mov    (%ebx),%eax
  800167:	89 04 24             	mov    %eax,(%esp)
  80016a:	e8 17 17 00 00       	call   801886 <open>
  80016f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	79 29                	jns    80019e <umain+0x86>
				panic("can't open %s: %e", argv[i], f);
  800175:	89 44 24 10          	mov    %eax,0x10(%esp)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	8b 00                	mov    (%eax),%eax
  80017e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800182:	c7 44 24 08 ec 23 80 	movl   $0x8023ec,0x8(%esp)
  800189:	00 
  80018a:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800191:	00 
  800192:	c7 04 24 c0 23 80 00 	movl   $0x8023c0,(%esp)
  800199:	e8 bf 00 00 00       	call   80025d <_panic>
			else {
				num(f, argv[i]);
  80019e:	8b 03                	mov    (%ebx),%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	89 34 24             	mov    %esi,(%esp)
  8001a7:	e8 87 fe ff ff       	call   800033 <num>
				close(f);
  8001ac:	89 34 24             	mov    %esi,(%esp)
  8001af:	e8 ff 10 00 00       	call   8012b3 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001b4:	83 c7 01             	add    $0x1,%edi
  8001b7:	83 c3 04             	add    $0x4,%ebx
  8001ba:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001bd:	75 9b                	jne    80015a <umain+0x42>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001bf:	e8 80 00 00 00       	call   800244 <exit>
}
  8001c4:	83 c4 2c             	add    $0x2c,%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 10             	sub    $0x10,%esp
  8001d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8001da:	e8 3c 0c 00 00       	call   800e1b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8001df:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8001e5:	39 c2                	cmp    %eax,%edx
  8001e7:	74 17                	je     800200 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001e9:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8001ee:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8001f1:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8001f7:	8b 49 40             	mov    0x40(%ecx),%ecx
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	75 18                	jne    800216 <libmain+0x4a>
  8001fe:	eb 05                	jmp    800205 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800200:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800205:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800208:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80020e:	89 15 08 40 80 00    	mov    %edx,0x804008
			break;
  800214:	eb 0b                	jmp    800221 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800216:	83 c2 01             	add    $0x1,%edx
  800219:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80021f:	75 cd                	jne    8001ee <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800221:	85 db                	test   %ebx,%ebx
  800223:	7e 07                	jle    80022c <libmain+0x60>
		binaryname = argv[0];
  800225:	8b 06                	mov    (%esi),%eax
  800227:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80022c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800230:	89 1c 24             	mov    %ebx,(%esp)
  800233:	e8 e0 fe ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800238:	e8 07 00 00 00       	call   800244 <exit>
}
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	5b                   	pop    %ebx
  800241:	5e                   	pop    %esi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80024a:	e8 97 10 00 00       	call   8012e6 <close_all>
	sys_env_destroy(0);
  80024f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800256:	e8 6e 0b 00 00       	call   800dc9 <sys_env_destroy>
}
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	56                   	push   %esi
  800261:	53                   	push   %ebx
  800262:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800265:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800268:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80026e:	e8 a8 0b 00 00       	call   800e1b <sys_getenvid>
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	89 54 24 10          	mov    %edx,0x10(%esp)
  80027a:	8b 55 08             	mov    0x8(%ebp),%edx
  80027d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800281:	89 74 24 08          	mov    %esi,0x8(%esp)
  800285:	89 44 24 04          	mov    %eax,0x4(%esp)
  800289:	c7 04 24 08 24 80 00 	movl   $0x802408,(%esp)
  800290:	e8 c1 00 00 00       	call   800356 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800295:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800299:	8b 45 10             	mov    0x10(%ebp),%eax
  80029c:	89 04 24             	mov    %eax,(%esp)
  80029f:	e8 51 00 00 00       	call   8002f5 <vcprintf>
	cprintf("\n");
  8002a4:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8002ab:	e8 a6 00 00 00       	call   800356 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002b0:	cc                   	int3   
  8002b1:	eb fd                	jmp    8002b0 <_panic+0x53>

008002b3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 14             	sub    $0x14,%esp
  8002ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bd:	8b 13                	mov    (%ebx),%edx
  8002bf:	8d 42 01             	lea    0x1(%edx),%eax
  8002c2:	89 03                	mov    %eax,(%ebx)
  8002c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 19                	jne    8002eb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002d2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002d9:	00 
  8002da:	8d 43 08             	lea    0x8(%ebx),%eax
  8002dd:	89 04 24             	mov    %eax,(%esp)
  8002e0:	e8 a7 0a 00 00       	call   800d8c <sys_cputs>
		b->idx = 0;
  8002e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002eb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ef:	83 c4 14             	add    $0x14,%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5d                   	pop    %ebp
  8002f4:	c3                   	ret    

008002f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800305:	00 00 00 
	b.cnt = 0;
  800308:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800320:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032a:	c7 04 24 b3 02 80 00 	movl   $0x8002b3,(%esp)
  800331:	e8 ae 01 00 00       	call   8004e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800336:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80033c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800340:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800346:	89 04 24             	mov    %eax,(%esp)
  800349:	e8 3e 0a 00 00       	call   800d8c <sys_cputs>

	return b.cnt;
}
  80034e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80035c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80035f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800363:	8b 45 08             	mov    0x8(%ebp),%eax
  800366:	89 04 24             	mov    %eax,(%esp)
  800369:	e8 87 ff ff ff       	call   8002f5 <vcprintf>
	va_end(ap);

	return cnt;
}
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 3c             	sub    $0x3c,%esp
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037c:	89 d7                	mov    %edx,%edi
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800384:	8b 75 0c             	mov    0xc(%ebp),%esi
  800387:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80038a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80038d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800395:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800398:	39 f1                	cmp    %esi,%ecx
  80039a:	72 14                	jb     8003b0 <printnum+0x40>
  80039c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039f:	76 0f                	jbe    8003b0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8003a7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8003aa:	85 f6                	test   %esi,%esi
  8003ac:	7f 60                	jg     80040e <printnum+0x9e>
  8003ae:	eb 72                	jmp    800422 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8003ba:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8003bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003c9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003cd:	89 c3                	mov    %eax,%ebx
  8003cf:	89 d6                	mov    %edx,%esi
  8003d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e2:	89 04 24             	mov    %eax,(%esp)
  8003e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ec:	e8 1f 1d 00 00       	call   802110 <__udivdi3>
  8003f1:	89 d9                	mov    %ebx,%ecx
  8003f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003fb:	89 04 24             	mov    %eax,(%esp)
  8003fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800402:	89 fa                	mov    %edi,%edx
  800404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800407:	e8 64 ff ff ff       	call   800370 <printnum>
  80040c:	eb 14                	jmp    800422 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80040e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800412:	8b 45 18             	mov    0x18(%ebp),%eax
  800415:	89 04 24             	mov    %eax,(%esp)
  800418:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	83 ee 01             	sub    $0x1,%esi
  80041d:	75 ef                	jne    80040e <printnum+0x9e>
  80041f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800422:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800426:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80042a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800430:	89 44 24 08          	mov    %eax,0x8(%esp)
  800434:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043b:	89 04 24             	mov    %eax,(%esp)
  80043e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800441:	89 44 24 04          	mov    %eax,0x4(%esp)
  800445:	e8 f6 1d 00 00       	call   802240 <__umoddi3>
  80044a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044e:	0f be 80 2b 24 80 00 	movsbl 0x80242b(%eax),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045b:	ff d0                	call   *%eax
}
  80045d:	83 c4 3c             	add    $0x3c,%esp
  800460:	5b                   	pop    %ebx
  800461:	5e                   	pop    %esi
  800462:	5f                   	pop    %edi
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    

00800465 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 fa 01             	cmp    $0x1,%edx
  80046b:	7e 0e                	jle    80047b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80046d:	8b 10                	mov    (%eax),%edx
  80046f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800472:	89 08                	mov    %ecx,(%eax)
  800474:	8b 02                	mov    (%edx),%eax
  800476:	8b 52 04             	mov    0x4(%edx),%edx
  800479:	eb 22                	jmp    80049d <getuint+0x38>
	else if (lflag)
  80047b:	85 d2                	test   %edx,%edx
  80047d:	74 10                	je     80048f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80047f:	8b 10                	mov    (%eax),%edx
  800481:	8d 4a 04             	lea    0x4(%edx),%ecx
  800484:	89 08                	mov    %ecx,(%eax)
  800486:	8b 02                	mov    (%edx),%eax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
  80048d:	eb 0e                	jmp    80049d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80048f:	8b 10                	mov    (%eax),%edx
  800491:	8d 4a 04             	lea    0x4(%edx),%ecx
  800494:	89 08                	mov    %ecx,(%eax)
  800496:	8b 02                	mov    (%edx),%eax
  800498:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ae:	73 0a                	jae    8004ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8004b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004b3:	89 08                	mov    %ecx,(%eax)
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	88 02                	mov    %al,(%edx)
}
  8004ba:	5d                   	pop    %ebp
  8004bb:	c3                   	ret    

008004bc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 04 24             	mov    %eax,(%esp)
  8004dd:	e8 02 00 00 00       	call   8004e4 <vprintfmt>
	va_end(ap);
}
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	57                   	push   %edi
  8004e8:	56                   	push   %esi
  8004e9:	53                   	push   %ebx
  8004ea:	83 ec 3c             	sub    $0x3c,%esp
  8004ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004f3:	eb 18                	jmp    80050d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	0f 84 c3 03 00 00    	je     8008c0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8004fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800501:	89 04 24             	mov    %eax,(%esp)
  800504:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800507:	89 f3                	mov    %esi,%ebx
  800509:	eb 02                	jmp    80050d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80050b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80050d:	8d 73 01             	lea    0x1(%ebx),%esi
  800510:	0f b6 03             	movzbl (%ebx),%eax
  800513:	83 f8 25             	cmp    $0x25,%eax
  800516:	75 dd                	jne    8004f5 <vprintfmt+0x11>
  800518:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80051c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800523:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80052a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800531:	ba 00 00 00 00       	mov    $0x0,%edx
  800536:	eb 1d                	jmp    800555 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800538:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80053a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80053e:	eb 15                	jmp    800555 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800540:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800542:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800546:	eb 0d                	jmp    800555 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80054b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800555:	8d 5e 01             	lea    0x1(%esi),%ebx
  800558:	0f b6 06             	movzbl (%esi),%eax
  80055b:	0f b6 c8             	movzbl %al,%ecx
  80055e:	83 e8 23             	sub    $0x23,%eax
  800561:	3c 55                	cmp    $0x55,%al
  800563:	0f 87 2f 03 00 00    	ja     800898 <vprintfmt+0x3b4>
  800569:	0f b6 c0             	movzbl %al,%eax
  80056c:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800573:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800576:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800579:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80057d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800580:	83 f9 09             	cmp    $0x9,%ecx
  800583:	77 50                	ja     8005d5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800585:	89 de                	mov    %ebx,%esi
  800587:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80058d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800590:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800594:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800597:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80059a:	83 fb 09             	cmp    $0x9,%ebx
  80059d:	76 eb                	jbe    80058a <vprintfmt+0xa6>
  80059f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a2:	eb 33                	jmp    8005d7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 48 04             	lea    0x4(%eax),%ecx
  8005aa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005b4:	eb 21                	jmp    8005d7 <vprintfmt+0xf3>
  8005b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005b9:	85 c9                	test   %ecx,%ecx
  8005bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c0:	0f 49 c1             	cmovns %ecx,%eax
  8005c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 de                	mov    %ebx,%esi
  8005c8:	eb 8b                	jmp    800555 <vprintfmt+0x71>
  8005ca:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005cc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005d3:	eb 80                	jmp    800555 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005db:	0f 89 74 ff ff ff    	jns    800555 <vprintfmt+0x71>
  8005e1:	e9 62 ff ff ff       	jmp    800548 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005eb:	e9 65 ff ff ff       	jmp    800555 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 50 04             	lea    0x4(%eax),%edx
  8005f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 04 24             	mov    %eax,(%esp)
  800602:	ff 55 08             	call   *0x8(%ebp)
			break;
  800605:	e9 03 ff ff ff       	jmp    80050d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 50 04             	lea    0x4(%eax),%edx
  800610:	89 55 14             	mov    %edx,0x14(%ebp)
  800613:	8b 00                	mov    (%eax),%eax
  800615:	99                   	cltd   
  800616:	31 d0                	xor    %edx,%eax
  800618:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061a:	83 f8 0f             	cmp    $0xf,%eax
  80061d:	7f 0b                	jg     80062a <vprintfmt+0x146>
  80061f:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	75 20                	jne    80064a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80062a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80062e:	c7 44 24 08 43 24 80 	movl   $0x802443,0x8(%esp)
  800635:	00 
  800636:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	89 04 24             	mov    %eax,(%esp)
  800640:	e8 77 fe ff ff       	call   8004bc <printfmt>
  800645:	e9 c3 fe ff ff       	jmp    80050d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80064a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064e:	c7 44 24 08 e2 27 80 	movl   $0x8027e2,0x8(%esp)
  800655:	00 
  800656:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	89 04 24             	mov    %eax,(%esp)
  800660:	e8 57 fe ff ff       	call   8004bc <printfmt>
  800665:	e9 a3 fe ff ff       	jmp    80050d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80066d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	89 55 14             	mov    %edx,0x14(%ebp)
  800679:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80067b:	85 c0                	test   %eax,%eax
  80067d:	ba 3c 24 80 00       	mov    $0x80243c,%edx
  800682:	0f 45 d0             	cmovne %eax,%edx
  800685:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800688:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80068c:	74 04                	je     800692 <vprintfmt+0x1ae>
  80068e:	85 f6                	test   %esi,%esi
  800690:	7f 19                	jg     8006ab <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	8d 70 01             	lea    0x1(%eax),%esi
  800698:	0f b6 10             	movzbl (%eax),%edx
  80069b:	0f be c2             	movsbl %dl,%eax
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	0f 85 95 00 00 00    	jne    80073b <vprintfmt+0x257>
  8006a6:	e9 85 00 00 00       	jmp    800730 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b2:	89 04 24             	mov    %eax,(%esp)
  8006b5:	e8 b8 02 00 00       	call   800972 <strnlen>
  8006ba:	29 c6                	sub    %eax,%esi
  8006bc:	89 f0                	mov    %esi,%eax
  8006be:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	7e cd                	jle    800692 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8006c5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8006c9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006cc:	89 c3                	mov    %eax,%ebx
  8006ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d2:	89 34 24             	mov    %esi,(%esp)
  8006d5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d8:	83 eb 01             	sub    $0x1,%ebx
  8006db:	75 f1                	jne    8006ce <vprintfmt+0x1ea>
  8006dd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8006e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006e3:	eb ad                	jmp    800692 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e9:	74 1e                	je     800709 <vprintfmt+0x225>
  8006eb:	0f be d2             	movsbl %dl,%edx
  8006ee:	83 ea 20             	sub    $0x20,%edx
  8006f1:	83 fa 5e             	cmp    $0x5e,%edx
  8006f4:	76 13                	jbe    800709 <vprintfmt+0x225>
					putch('?', putdat);
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800704:	ff 55 08             	call   *0x8(%ebp)
  800707:	eb 0d                	jmp    800716 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800710:	89 04 24             	mov    %eax,(%esp)
  800713:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800716:	83 ef 01             	sub    $0x1,%edi
  800719:	83 c6 01             	add    $0x1,%esi
  80071c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800720:	0f be c2             	movsbl %dl,%eax
  800723:	85 c0                	test   %eax,%eax
  800725:	75 20                	jne    800747 <vprintfmt+0x263>
  800727:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80072a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80072d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800734:	7f 25                	jg     80075b <vprintfmt+0x277>
  800736:	e9 d2 fd ff ff       	jmp    80050d <vprintfmt+0x29>
  80073b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800741:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800744:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800747:	85 db                	test   %ebx,%ebx
  800749:	78 9a                	js     8006e5 <vprintfmt+0x201>
  80074b:	83 eb 01             	sub    $0x1,%ebx
  80074e:	79 95                	jns    8006e5 <vprintfmt+0x201>
  800750:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800753:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800756:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800759:	eb d5                	jmp    800730 <vprintfmt+0x24c>
  80075b:	8b 75 08             	mov    0x8(%ebp),%esi
  80075e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800761:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800764:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800768:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80076f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800771:	83 eb 01             	sub    $0x1,%ebx
  800774:	75 ee                	jne    800764 <vprintfmt+0x280>
  800776:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800779:	e9 8f fd ff ff       	jmp    80050d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80077e:	83 fa 01             	cmp    $0x1,%edx
  800781:	7e 16                	jle    800799 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 50 08             	lea    0x8(%eax),%edx
  800789:	89 55 14             	mov    %edx,0x14(%ebp)
  80078c:	8b 50 04             	mov    0x4(%eax),%edx
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800797:	eb 32                	jmp    8007cb <vprintfmt+0x2e7>
	else if (lflag)
  800799:	85 d2                	test   %edx,%edx
  80079b:	74 18                	je     8007b5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 50 04             	lea    0x4(%eax),%edx
  8007a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a6:	8b 30                	mov    (%eax),%esi
  8007a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007ab:	89 f0                	mov    %esi,%eax
  8007ad:	c1 f8 1f             	sar    $0x1f,%eax
  8007b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007b3:	eb 16                	jmp    8007cb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 50 04             	lea    0x4(%eax),%edx
  8007bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007be:	8b 30                	mov    (%eax),%esi
  8007c0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007c3:	89 f0                	mov    %esi,%eax
  8007c5:	c1 f8 1f             	sar    $0x1f,%eax
  8007c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007da:	0f 89 80 00 00 00    	jns    800860 <vprintfmt+0x37c>
				putch('-', putdat);
  8007e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007eb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007f4:	f7 d8                	neg    %eax
  8007f6:	83 d2 00             	adc    $0x0,%edx
  8007f9:	f7 da                	neg    %edx
			}
			base = 10;
  8007fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800800:	eb 5e                	jmp    800860 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	e8 5b fc ff ff       	call   800465 <getuint>
			base = 10;
  80080a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80080f:	eb 4f                	jmp    800860 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800811:	8d 45 14             	lea    0x14(%ebp),%eax
  800814:	e8 4c fc ff ff       	call   800465 <getuint>
			base = 8;
  800819:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80081e:	eb 40                	jmp    800860 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800820:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800824:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80082b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80082e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800832:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800839:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 50 04             	lea    0x4(%eax),%edx
  800842:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800845:	8b 00                	mov    (%eax),%eax
  800847:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80084c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800851:	eb 0d                	jmp    800860 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800853:	8d 45 14             	lea    0x14(%ebp),%eax
  800856:	e8 0a fc ff ff       	call   800465 <getuint>
			base = 16;
  80085b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800860:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800864:	89 74 24 10          	mov    %esi,0x10(%esp)
  800868:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80086b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80086f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800873:	89 04 24             	mov    %eax,(%esp)
  800876:	89 54 24 04          	mov    %edx,0x4(%esp)
  80087a:	89 fa                	mov    %edi,%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	e8 ec fa ff ff       	call   800370 <printnum>
			break;
  800884:	e9 84 fc ff ff       	jmp    80050d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800889:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088d:	89 0c 24             	mov    %ecx,(%esp)
  800890:	ff 55 08             	call   *0x8(%ebp)
			break;
  800893:	e9 75 fc ff ff       	jmp    80050d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800898:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008a3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8008aa:	0f 84 5b fc ff ff    	je     80050b <vprintfmt+0x27>
  8008b0:	89 f3                	mov    %esi,%ebx
  8008b2:	83 eb 01             	sub    $0x1,%ebx
  8008b5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008b9:	75 f7                	jne    8008b2 <vprintfmt+0x3ce>
  8008bb:	e9 4d fc ff ff       	jmp    80050d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8008c0:	83 c4 3c             	add    $0x3c,%esp
  8008c3:	5b                   	pop    %ebx
  8008c4:	5e                   	pop    %esi
  8008c5:	5f                   	pop    %edi
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 28             	sub    $0x28,%esp
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008db:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	74 30                	je     800919 <vsnprintf+0x51>
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	7e 2c                	jle    800919 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800902:	c7 04 24 9f 04 80 00 	movl   $0x80049f,(%esp)
  800909:	e8 d6 fb ff ff       	call   8004e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80090e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800911:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800917:	eb 05                	jmp    80091e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800926:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800929:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	89 44 24 08          	mov    %eax,0x8(%esp)
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
  800937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 04 24             	mov    %eax,(%esp)
  800941:	e8 82 ff ff ff       	call   8008c8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    
  800948:	66 90                	xchg   %ax,%ax
  80094a:	66 90                	xchg   %ax,%ax
  80094c:	66 90                	xchg   %ax,%ax
  80094e:	66 90                	xchg   %ax,%ax

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	80 3a 00             	cmpb   $0x0,(%edx)
  800959:	74 10                	je     80096b <strlen+0x1b>
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800960:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800967:	75 f7                	jne    800960 <strlen+0x10>
  800969:	eb 05                	jmp    800970 <strlen+0x20>
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	85 c9                	test   %ecx,%ecx
  80097e:	74 1c                	je     80099c <strnlen+0x2a>
  800980:	80 3b 00             	cmpb   $0x0,(%ebx)
  800983:	74 1e                	je     8009a3 <strnlen+0x31>
  800985:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80098a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098c:	39 ca                	cmp    %ecx,%edx
  80098e:	74 18                	je     8009a8 <strnlen+0x36>
  800990:	83 c2 01             	add    $0x1,%edx
  800993:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800998:	75 f0                	jne    80098a <strnlen+0x18>
  80099a:	eb 0c                	jmp    8009a8 <strnlen+0x36>
  80099c:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a1:	eb 05                	jmp    8009a8 <strnlen+0x36>
  8009a3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b5:	89 c2                	mov    %eax,%edx
  8009b7:	83 c2 01             	add    $0x1,%edx
  8009ba:	83 c1 01             	add    $0x1,%ecx
  8009bd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009c1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c4:	84 db                	test   %bl,%bl
  8009c6:	75 ef                	jne    8009b7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d5:	89 1c 24             	mov    %ebx,(%esp)
  8009d8:	e8 73 ff ff ff       	call   800950 <strlen>
	strcpy(dst + len, src);
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	89 04 24             	mov    %eax,(%esp)
  8009e9:	e8 bd ff ff ff       	call   8009ab <strcpy>
	return dst;
}
  8009ee:	89 d8                	mov    %ebx,%eax
  8009f0:	83 c4 08             	add    $0x8,%esp
  8009f3:	5b                   	pop    %ebx
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	74 17                	je     800a1f <strncpy+0x29>
  800a08:	01 f3                	add    %esi,%ebx
  800a0a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	0f b6 02             	movzbl (%edx),%eax
  800a12:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a15:	80 3a 01             	cmpb   $0x1,(%edx)
  800a18:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1b:	39 d9                	cmp    %ebx,%ecx
  800a1d:	75 ed                	jne    800a0c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a1f:	89 f0                	mov    %esi,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	57                   	push   %edi
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a31:	8b 75 10             	mov    0x10(%ebp),%esi
  800a34:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a36:	85 f6                	test   %esi,%esi
  800a38:	74 34                	je     800a6e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800a3a:	83 fe 01             	cmp    $0x1,%esi
  800a3d:	74 26                	je     800a65 <strlcpy+0x40>
  800a3f:	0f b6 0b             	movzbl (%ebx),%ecx
  800a42:	84 c9                	test   %cl,%cl
  800a44:	74 23                	je     800a69 <strlcpy+0x44>
  800a46:	83 ee 02             	sub    $0x2,%esi
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800a4e:	83 c0 01             	add    $0x1,%eax
  800a51:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a54:	39 f2                	cmp    %esi,%edx
  800a56:	74 13                	je     800a6b <strlcpy+0x46>
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5f:	84 c9                	test   %cl,%cl
  800a61:	75 eb                	jne    800a4e <strlcpy+0x29>
  800a63:	eb 06                	jmp    800a6b <strlcpy+0x46>
  800a65:	89 f8                	mov    %edi,%eax
  800a67:	eb 02                	jmp    800a6b <strlcpy+0x46>
  800a69:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6e:	29 f8                	sub    %edi,%eax
}
  800a70:	5b                   	pop    %ebx
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7e:	0f b6 01             	movzbl (%ecx),%eax
  800a81:	84 c0                	test   %al,%al
  800a83:	74 15                	je     800a9a <strcmp+0x25>
  800a85:	3a 02                	cmp    (%edx),%al
  800a87:	75 11                	jne    800a9a <strcmp+0x25>
		p++, q++;
  800a89:	83 c1 01             	add    $0x1,%ecx
  800a8c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a8f:	0f b6 01             	movzbl (%ecx),%eax
  800a92:	84 c0                	test   %al,%al
  800a94:	74 04                	je     800a9a <strcmp+0x25>
  800a96:	3a 02                	cmp    (%edx),%al
  800a98:	74 ef                	je     800a89 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9a:	0f b6 c0             	movzbl %al,%eax
  800a9d:	0f b6 12             	movzbl (%edx),%edx
  800aa0:	29 d0                	sub    %edx,%eax
}
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	56                   	push   %esi
  800aa8:	53                   	push   %ebx
  800aa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800ab2:	85 f6                	test   %esi,%esi
  800ab4:	74 29                	je     800adf <strncmp+0x3b>
  800ab6:	0f b6 03             	movzbl (%ebx),%eax
  800ab9:	84 c0                	test   %al,%al
  800abb:	74 30                	je     800aed <strncmp+0x49>
  800abd:	3a 02                	cmp    (%edx),%al
  800abf:	75 2c                	jne    800aed <strncmp+0x49>
  800ac1:	8d 43 01             	lea    0x1(%ebx),%eax
  800ac4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800ac6:	89 c3                	mov    %eax,%ebx
  800ac8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800acb:	39 f0                	cmp    %esi,%eax
  800acd:	74 17                	je     800ae6 <strncmp+0x42>
  800acf:	0f b6 08             	movzbl (%eax),%ecx
  800ad2:	84 c9                	test   %cl,%cl
  800ad4:	74 17                	je     800aed <strncmp+0x49>
  800ad6:	83 c0 01             	add    $0x1,%eax
  800ad9:	3a 0a                	cmp    (%edx),%cl
  800adb:	74 e9                	je     800ac6 <strncmp+0x22>
  800add:	eb 0e                	jmp    800aed <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb 0f                	jmp    800af5 <strncmp+0x51>
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aeb:	eb 08                	jmp    800af5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aed:	0f b6 03             	movzbl (%ebx),%eax
  800af0:	0f b6 12             	movzbl (%edx),%edx
  800af3:	29 d0                	sub    %edx,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	53                   	push   %ebx
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b03:	0f b6 18             	movzbl (%eax),%ebx
  800b06:	84 db                	test   %bl,%bl
  800b08:	74 1d                	je     800b27 <strchr+0x2e>
  800b0a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b0c:	38 d3                	cmp    %dl,%bl
  800b0e:	75 06                	jne    800b16 <strchr+0x1d>
  800b10:	eb 1a                	jmp    800b2c <strchr+0x33>
  800b12:	38 ca                	cmp    %cl,%dl
  800b14:	74 16                	je     800b2c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b16:	83 c0 01             	add    $0x1,%eax
  800b19:	0f b6 10             	movzbl (%eax),%edx
  800b1c:	84 d2                	test   %dl,%dl
  800b1e:	75 f2                	jne    800b12 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
  800b25:	eb 05                	jmp    800b2c <strchr+0x33>
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2c:	5b                   	pop    %ebx
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	53                   	push   %ebx
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b39:	0f b6 18             	movzbl (%eax),%ebx
  800b3c:	84 db                	test   %bl,%bl
  800b3e:	74 16                	je     800b56 <strfind+0x27>
  800b40:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b42:	38 d3                	cmp    %dl,%bl
  800b44:	75 06                	jne    800b4c <strfind+0x1d>
  800b46:	eb 0e                	jmp    800b56 <strfind+0x27>
  800b48:	38 ca                	cmp    %cl,%dl
  800b4a:	74 0a                	je     800b56 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	0f b6 10             	movzbl (%eax),%edx
  800b52:	84 d2                	test   %dl,%dl
  800b54:	75 f2                	jne    800b48 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800b56:	5b                   	pop    %ebx
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	57                   	push   %edi
  800b5d:	56                   	push   %esi
  800b5e:	53                   	push   %ebx
  800b5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b65:	85 c9                	test   %ecx,%ecx
  800b67:	74 36                	je     800b9f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b6f:	75 28                	jne    800b99 <memset+0x40>
  800b71:	f6 c1 03             	test   $0x3,%cl
  800b74:	75 23                	jne    800b99 <memset+0x40>
		c &= 0xFF;
  800b76:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b7a:	89 d3                	mov    %edx,%ebx
  800b7c:	c1 e3 08             	shl    $0x8,%ebx
  800b7f:	89 d6                	mov    %edx,%esi
  800b81:	c1 e6 18             	shl    $0x18,%esi
  800b84:	89 d0                	mov    %edx,%eax
  800b86:	c1 e0 10             	shl    $0x10,%eax
  800b89:	09 f0                	or     %esi,%eax
  800b8b:	09 c2                	or     %eax,%edx
  800b8d:	89 d0                	mov    %edx,%eax
  800b8f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b91:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b94:	fc                   	cld    
  800b95:	f3 ab                	rep stos %eax,%es:(%edi)
  800b97:	eb 06                	jmp    800b9f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	fc                   	cld    
  800b9d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9f:	89 f8                	mov    %edi,%eax
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb4:	39 c6                	cmp    %eax,%esi
  800bb6:	73 35                	jae    800bed <memmove+0x47>
  800bb8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bbb:	39 d0                	cmp    %edx,%eax
  800bbd:	73 2e                	jae    800bed <memmove+0x47>
		s += n;
		d += n;
  800bbf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800bc2:	89 d6                	mov    %edx,%esi
  800bc4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bcc:	75 13                	jne    800be1 <memmove+0x3b>
  800bce:	f6 c1 03             	test   $0x3,%cl
  800bd1:	75 0e                	jne    800be1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bd3:	83 ef 04             	sub    $0x4,%edi
  800bd6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bdc:	fd                   	std    
  800bdd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bdf:	eb 09                	jmp    800bea <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be1:	83 ef 01             	sub    $0x1,%edi
  800be4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800be7:	fd                   	std    
  800be8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bea:	fc                   	cld    
  800beb:	eb 1d                	jmp    800c0a <memmove+0x64>
  800bed:	89 f2                	mov    %esi,%edx
  800bef:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf1:	f6 c2 03             	test   $0x3,%dl
  800bf4:	75 0f                	jne    800c05 <memmove+0x5f>
  800bf6:	f6 c1 03             	test   $0x3,%cl
  800bf9:	75 0a                	jne    800c05 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bfb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bfe:	89 c7                	mov    %eax,%edi
  800c00:	fc                   	cld    
  800c01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c03:	eb 05                	jmp    800c0a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c05:	89 c7                	mov    %eax,%edi
  800c07:	fc                   	cld    
  800c08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	89 04 24             	mov    %eax,(%esp)
  800c28:	e8 79 ff ff ff       	call   800ba6 <memmove>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800c41:	85 c0                	test   %eax,%eax
  800c43:	74 36                	je     800c7b <memcmp+0x4c>
		if (*s1 != *s2)
  800c45:	0f b6 03             	movzbl (%ebx),%eax
  800c48:	0f b6 0e             	movzbl (%esi),%ecx
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	38 c8                	cmp    %cl,%al
  800c52:	74 1c                	je     800c70 <memcmp+0x41>
  800c54:	eb 10                	jmp    800c66 <memcmp+0x37>
  800c56:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c5b:	83 c2 01             	add    $0x1,%edx
  800c5e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c62:	38 c8                	cmp    %cl,%al
  800c64:	74 0a                	je     800c70 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800c66:	0f b6 c0             	movzbl %al,%eax
  800c69:	0f b6 c9             	movzbl %cl,%ecx
  800c6c:	29 c8                	sub    %ecx,%eax
  800c6e:	eb 10                	jmp    800c80 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c70:	39 fa                	cmp    %edi,%edx
  800c72:	75 e2                	jne    800c56 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	eb 05                	jmp    800c80 <memcmp+0x51>
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	53                   	push   %ebx
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800c8f:	89 c2                	mov    %eax,%edx
  800c91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c94:	39 d0                	cmp    %edx,%eax
  800c96:	73 13                	jae    800cab <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c98:	89 d9                	mov    %ebx,%ecx
  800c9a:	38 18                	cmp    %bl,(%eax)
  800c9c:	75 06                	jne    800ca4 <memfind+0x1f>
  800c9e:	eb 0b                	jmp    800cab <memfind+0x26>
  800ca0:	38 08                	cmp    %cl,(%eax)
  800ca2:	74 07                	je     800cab <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca4:	83 c0 01             	add    $0x1,%eax
  800ca7:	39 d0                	cmp    %edx,%eax
  800ca9:	75 f5                	jne    800ca0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cab:	5b                   	pop    %ebx
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	57                   	push   %edi
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	0f b6 0a             	movzbl (%edx),%ecx
  800cbd:	80 f9 09             	cmp    $0x9,%cl
  800cc0:	74 05                	je     800cc7 <strtol+0x19>
  800cc2:	80 f9 20             	cmp    $0x20,%cl
  800cc5:	75 10                	jne    800cd7 <strtol+0x29>
		s++;
  800cc7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cca:	0f b6 0a             	movzbl (%edx),%ecx
  800ccd:	80 f9 09             	cmp    $0x9,%cl
  800cd0:	74 f5                	je     800cc7 <strtol+0x19>
  800cd2:	80 f9 20             	cmp    $0x20,%cl
  800cd5:	74 f0                	je     800cc7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd7:	80 f9 2b             	cmp    $0x2b,%cl
  800cda:	75 0a                	jne    800ce6 <strtol+0x38>
		s++;
  800cdc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800cdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce4:	eb 11                	jmp    800cf7 <strtol+0x49>
  800ce6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ceb:	80 f9 2d             	cmp    $0x2d,%cl
  800cee:	75 07                	jne    800cf7 <strtol+0x49>
		s++, neg = 1;
  800cf0:	83 c2 01             	add    $0x1,%edx
  800cf3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800cfc:	75 15                	jne    800d13 <strtol+0x65>
  800cfe:	80 3a 30             	cmpb   $0x30,(%edx)
  800d01:	75 10                	jne    800d13 <strtol+0x65>
  800d03:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d07:	75 0a                	jne    800d13 <strtol+0x65>
		s += 2, base = 16;
  800d09:	83 c2 02             	add    $0x2,%edx
  800d0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800d11:	eb 10                	jmp    800d23 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800d13:	85 c0                	test   %eax,%eax
  800d15:	75 0c                	jne    800d23 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d17:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d19:	80 3a 30             	cmpb   $0x30,(%edx)
  800d1c:	75 05                	jne    800d23 <strtol+0x75>
		s++, base = 8;
  800d1e:	83 c2 01             	add    $0x1,%edx
  800d21:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d28:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d2b:	0f b6 0a             	movzbl (%edx),%ecx
  800d2e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d31:	89 f0                	mov    %esi,%eax
  800d33:	3c 09                	cmp    $0x9,%al
  800d35:	77 08                	ja     800d3f <strtol+0x91>
			dig = *s - '0';
  800d37:	0f be c9             	movsbl %cl,%ecx
  800d3a:	83 e9 30             	sub    $0x30,%ecx
  800d3d:	eb 20                	jmp    800d5f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800d3f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d42:	89 f0                	mov    %esi,%eax
  800d44:	3c 19                	cmp    $0x19,%al
  800d46:	77 08                	ja     800d50 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800d48:	0f be c9             	movsbl %cl,%ecx
  800d4b:	83 e9 57             	sub    $0x57,%ecx
  800d4e:	eb 0f                	jmp    800d5f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800d50:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d53:	89 f0                	mov    %esi,%eax
  800d55:	3c 19                	cmp    $0x19,%al
  800d57:	77 16                	ja     800d6f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d59:	0f be c9             	movsbl %cl,%ecx
  800d5c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d5f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d62:	7d 0f                	jge    800d73 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d64:	83 c2 01             	add    $0x1,%edx
  800d67:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d6b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d6d:	eb bc                	jmp    800d2b <strtol+0x7d>
  800d6f:	89 d8                	mov    %ebx,%eax
  800d71:	eb 02                	jmp    800d75 <strtol+0xc7>
  800d73:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 05                	je     800d80 <strtol+0xd2>
		*endptr = (char *) s;
  800d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d80:	f7 d8                	neg    %eax
  800d82:	85 ff                	test   %edi,%edi
  800d84:	0f 44 c3             	cmove  %ebx,%eax
}
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	89 c3                	mov    %eax,%ebx
  800d9f:	89 c7                	mov    %eax,%edi
  800da1:	89 c6                	mov    %eax,%esi
  800da3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_cgetc>:

int
sys_cgetc(void)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db0:	ba 00 00 00 00       	mov    $0x0,%edx
  800db5:	b8 01 00 00 00       	mov    $0x1,%eax
  800dba:	89 d1                	mov    %edx,%ecx
  800dbc:	89 d3                	mov    %edx,%ebx
  800dbe:	89 d7                	mov    %edx,%edi
  800dc0:	89 d6                	mov    %edx,%esi
  800dc2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd7:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 cb                	mov    %ecx,%ebx
  800de1:	89 cf                	mov    %ecx,%edi
  800de3:	89 ce                	mov    %ecx,%esi
  800de5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7e 28                	jle    800e13 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800def:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800df6:	00 
  800df7:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800dfe:	00 
  800dff:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e06:	00 
  800e07:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800e0e:	e8 4a f4 ff ff       	call   80025d <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e13:	83 c4 2c             	add    $0x2c,%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2b:	89 d1                	mov    %edx,%ecx
  800e2d:	89 d3                	mov    %edx,%ebx
  800e2f:	89 d7                	mov    %edx,%edi
  800e31:	89 d6                	mov    %edx,%esi
  800e33:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_yield>:

void
sys_yield(void)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
  800e45:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e4a:	89 d1                	mov    %edx,%ecx
  800e4c:	89 d3                	mov    %edx,%ebx
  800e4e:	89 d7                	mov    %edx,%edi
  800e50:	89 d6                	mov    %edx,%esi
  800e52:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	be 00 00 00 00       	mov    $0x0,%esi
  800e67:	b8 04 00 00 00       	mov    $0x4,%eax
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e75:	89 f7                	mov    %esi,%edi
  800e77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7e 28                	jle    800ea5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e81:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e88:	00 
  800e89:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800e90:	00 
  800e91:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e98:	00 
  800e99:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800ea0:	e8 b8 f3 ff ff       	call   80025d <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea5:	83 c4 2c             	add    $0x2c,%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb6:	b8 05 00 00 00       	mov    $0x5,%eax
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec7:	8b 75 18             	mov    0x18(%ebp),%esi
  800eca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7e 28                	jle    800ef8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800edb:	00 
  800edc:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800ee3:	00 
  800ee4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eeb:	00 
  800eec:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800ef3:	e8 65 f3 ff ff       	call   80025d <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef8:	83 c4 2c             	add    $0x2c,%esp
  800efb:	5b                   	pop    %ebx
  800efc:	5e                   	pop    %esi
  800efd:	5f                   	pop    %edi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7e 28                	jle    800f4b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f27:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800f36:	00 
  800f37:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f3e:	00 
  800f3f:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800f46:	e8 12 f3 ff ff       	call   80025d <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f4b:	83 c4 2c             	add    $0x2c,%esp
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f61:	b8 08 00 00 00       	mov    $0x8,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	89 df                	mov    %ebx,%edi
  800f6e:	89 de                	mov    %ebx,%esi
  800f70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7e 28                	jle    800f9e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f81:	00 
  800f82:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800f99:	e8 bf f2 ff ff       	call   80025d <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f9e:	83 c4 2c             	add    $0x2c,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	89 df                	mov    %ebx,%edi
  800fc1:	89 de                	mov    %ebx,%esi
  800fc3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7e 28                	jle    800ff1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fcd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fd4:	00 
  800fd5:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  800fdc:	00 
  800fdd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fe4:	00 
  800fe5:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800fec:	e8 6c f2 ff ff       	call   80025d <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ff1:	83 c4 2c             	add    $0x2c,%esp
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
  800fff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
  801007:	b8 0a 00 00 00       	mov    $0xa,%eax
  80100c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	89 df                	mov    %ebx,%edi
  801014:	89 de                	mov    %ebx,%esi
  801016:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801018:	85 c0                	test   %eax,%eax
  80101a:	7e 28                	jle    801044 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801020:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801027:	00 
  801028:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  80102f:	00 
  801030:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801037:	00 
  801038:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  80103f:	e8 19 f2 ff ff       	call   80025d <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801044:	83 c4 2c             	add    $0x2c,%esp
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	be 00 00 00 00       	mov    $0x0,%esi
  801057:	b8 0c 00 00 00       	mov    $0xc,%eax
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801065:	8b 7d 14             	mov    0x14(%ebp),%edi
  801068:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
  801075:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801078:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 cb                	mov    %ecx,%ebx
  801087:	89 cf                	mov    %ecx,%edi
  801089:	89 ce                	mov    %ecx,%esi
  80108b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	7e 28                	jle    8010b9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801091:	89 44 24 10          	mov    %eax,0x10(%esp)
  801095:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80109c:	00 
  80109d:	c7 44 24 08 1f 27 80 	movl   $0x80271f,0x8(%esp)
  8010a4:	00 
  8010a5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010ac:	00 
  8010ad:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  8010b4:	e8 a4 f1 ff ff       	call   80025d <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010b9:	83 c4 2c             	add    $0x2c,%esp
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    
  8010c1:	66 90                	xchg   %ax,%ax
  8010c3:	66 90                	xchg   %ax,%ax
  8010c5:	66 90                	xchg   %ax,%ax
  8010c7:	66 90                	xchg   %ax,%ax
  8010c9:	66 90                	xchg   %ax,%ax
  8010cb:	66 90                	xchg   %ax,%ax
  8010cd:	66 90                	xchg   %ax,%ax
  8010cf:	90                   	nop

008010d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010db:	c1 e8 0c             	shr    $0xc,%eax
}
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010ff:	a8 01                	test   $0x1,%al
  801101:	74 34                	je     801137 <fd_alloc+0x40>
  801103:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801108:	a8 01                	test   $0x1,%al
  80110a:	74 32                	je     80113e <fd_alloc+0x47>
  80110c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801111:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801113:	89 c2                	mov    %eax,%edx
  801115:	c1 ea 16             	shr    $0x16,%edx
  801118:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80111f:	f6 c2 01             	test   $0x1,%dl
  801122:	74 1f                	je     801143 <fd_alloc+0x4c>
  801124:	89 c2                	mov    %eax,%edx
  801126:	c1 ea 0c             	shr    $0xc,%edx
  801129:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801130:	f6 c2 01             	test   $0x1,%dl
  801133:	75 1a                	jne    80114f <fd_alloc+0x58>
  801135:	eb 0c                	jmp    801143 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801137:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80113c:	eb 05                	jmp    801143 <fd_alloc+0x4c>
  80113e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	89 08                	mov    %ecx,(%eax)
			return 0;
  801148:	b8 00 00 00 00       	mov    $0x0,%eax
  80114d:	eb 1a                	jmp    801169 <fd_alloc+0x72>
  80114f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801154:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801159:	75 b6                	jne    801111 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801164:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801171:	83 f8 1f             	cmp    $0x1f,%eax
  801174:	77 36                	ja     8011ac <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801176:	c1 e0 0c             	shl    $0xc,%eax
  801179:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80117e:	89 c2                	mov    %eax,%edx
  801180:	c1 ea 16             	shr    $0x16,%edx
  801183:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80118a:	f6 c2 01             	test   $0x1,%dl
  80118d:	74 24                	je     8011b3 <fd_lookup+0x48>
  80118f:	89 c2                	mov    %eax,%edx
  801191:	c1 ea 0c             	shr    $0xc,%edx
  801194:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80119b:	f6 c2 01             	test   $0x1,%dl
  80119e:	74 1a                	je     8011ba <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	eb 13                	jmp    8011bf <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b1:	eb 0c                	jmp    8011bf <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b8:	eb 05                	jmp    8011bf <fd_lookup+0x54>
  8011ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 14             	sub    $0x14,%esp
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011ce:	39 05 08 30 80 00    	cmp    %eax,0x803008
  8011d4:	75 1e                	jne    8011f4 <dev_lookup+0x33>
  8011d6:	eb 0e                	jmp    8011e6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011d8:	b8 24 30 80 00       	mov    $0x803024,%eax
  8011dd:	eb 0c                	jmp    8011eb <dev_lookup+0x2a>
  8011df:	b8 40 30 80 00       	mov    $0x803040,%eax
  8011e4:	eb 05                	jmp    8011eb <dev_lookup+0x2a>
  8011e6:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011eb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8011ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f2:	eb 38                	jmp    80122c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011f4:	39 05 24 30 80 00    	cmp    %eax,0x803024
  8011fa:	74 dc                	je     8011d8 <dev_lookup+0x17>
  8011fc:	39 05 40 30 80 00    	cmp    %eax,0x803040
  801202:	74 db                	je     8011df <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801204:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80120a:	8b 52 48             	mov    0x48(%edx),%edx
  80120d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801211:	89 54 24 04          	mov    %edx,0x4(%esp)
  801215:	c7 04 24 4c 27 80 00 	movl   $0x80274c,(%esp)
  80121c:	e8 35 f1 ff ff       	call   800356 <cprintf>
	*dev = 0;
  801221:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801227:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122c:	83 c4 14             	add    $0x14,%esp
  80122f:	5b                   	pop    %ebx
  801230:	5d                   	pop    %ebp
  801231:	c3                   	ret    

00801232 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
  801237:	83 ec 20             	sub    $0x20,%esp
  80123a:	8b 75 08             	mov    0x8(%ebp),%esi
  80123d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801243:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801247:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80124d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801250:	89 04 24             	mov    %eax,(%esp)
  801253:	e8 13 ff ff ff       	call   80116b <fd_lookup>
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 05                	js     801261 <fd_close+0x2f>
	    || fd != fd2)
  80125c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80125f:	74 0c                	je     80126d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801261:	84 db                	test   %bl,%bl
  801263:	ba 00 00 00 00       	mov    $0x0,%edx
  801268:	0f 44 c2             	cmove  %edx,%eax
  80126b:	eb 3f                	jmp    8012ac <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80126d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801270:	89 44 24 04          	mov    %eax,0x4(%esp)
  801274:	8b 06                	mov    (%esi),%eax
  801276:	89 04 24             	mov    %eax,(%esp)
  801279:	e8 43 ff ff ff       	call   8011c1 <dev_lookup>
  80127e:	89 c3                	mov    %eax,%ebx
  801280:	85 c0                	test   %eax,%eax
  801282:	78 16                	js     80129a <fd_close+0x68>
		if (dev->dev_close)
  801284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801287:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80128a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80128f:	85 c0                	test   %eax,%eax
  801291:	74 07                	je     80129a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801293:	89 34 24             	mov    %esi,(%esp)
  801296:	ff d0                	call   *%eax
  801298:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80129a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a5:	e8 56 fc ff ff       	call   800f00 <sys_page_unmap>
	return r;
  8012aa:	89 d8                	mov    %ebx,%eax
}
  8012ac:	83 c4 20             	add    $0x20,%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 04 24             	mov    %eax,(%esp)
  8012c6:	e8 a0 fe ff ff       	call   80116b <fd_lookup>
  8012cb:	89 c2                	mov    %eax,%edx
  8012cd:	85 d2                	test   %edx,%edx
  8012cf:	78 13                	js     8012e4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012d8:	00 
  8012d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012dc:	89 04 24             	mov    %eax,(%esp)
  8012df:	e8 4e ff ff ff       	call   801232 <fd_close>
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <close_all>:

void
close_all(void)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f2:	89 1c 24             	mov    %ebx,(%esp)
  8012f5:	e8 b9 ff ff ff       	call   8012b3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012fa:	83 c3 01             	add    $0x1,%ebx
  8012fd:	83 fb 20             	cmp    $0x20,%ebx
  801300:	75 f0                	jne    8012f2 <close_all+0xc>
		close(i);
}
  801302:	83 c4 14             	add    $0x14,%esp
  801305:	5b                   	pop    %ebx
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	57                   	push   %edi
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
  80130e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801311:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801314:	89 44 24 04          	mov    %eax,0x4(%esp)
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	89 04 24             	mov    %eax,(%esp)
  80131e:	e8 48 fe ff ff       	call   80116b <fd_lookup>
  801323:	89 c2                	mov    %eax,%edx
  801325:	85 d2                	test   %edx,%edx
  801327:	0f 88 e1 00 00 00    	js     80140e <dup+0x106>
		return r;
	close(newfdnum);
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	89 04 24             	mov    %eax,(%esp)
  801333:	e8 7b ff ff ff       	call   8012b3 <close>

	newfd = INDEX2FD(newfdnum);
  801338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80133b:	c1 e3 0c             	shl    $0xc,%ebx
  80133e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801347:	89 04 24             	mov    %eax,(%esp)
  80134a:	e8 91 fd ff ff       	call   8010e0 <fd2data>
  80134f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801351:	89 1c 24             	mov    %ebx,(%esp)
  801354:	e8 87 fd ff ff       	call   8010e0 <fd2data>
  801359:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135b:	89 f0                	mov    %esi,%eax
  80135d:	c1 e8 16             	shr    $0x16,%eax
  801360:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801367:	a8 01                	test   $0x1,%al
  801369:	74 43                	je     8013ae <dup+0xa6>
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	c1 e8 0c             	shr    $0xc,%eax
  801370:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801377:	f6 c2 01             	test   $0x1,%dl
  80137a:	74 32                	je     8013ae <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80137c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801383:	25 07 0e 00 00       	and    $0xe07,%eax
  801388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801390:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801397:	00 
  801398:	89 74 24 04          	mov    %esi,0x4(%esp)
  80139c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a3:	e8 05 fb ff ff       	call   800ead <sys_page_map>
  8013a8:	89 c6                	mov    %eax,%esi
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 3e                	js     8013ec <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	c1 ea 0c             	shr    $0xc,%edx
  8013b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013bd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d2:	00 
  8013d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013de:	e8 ca fa ff ff       	call   800ead <sys_page_map>
  8013e3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e8:	85 f6                	test   %esi,%esi
  8013ea:	79 22                	jns    80140e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f7:	e8 04 fb ff ff       	call   800f00 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801407:	e8 f4 fa ff ff       	call   800f00 <sys_page_unmap>
	return r;
  80140c:	89 f0                	mov    %esi,%eax
}
  80140e:	83 c4 3c             	add    $0x3c,%esp
  801411:	5b                   	pop    %ebx
  801412:	5e                   	pop    %esi
  801413:	5f                   	pop    %edi
  801414:	5d                   	pop    %ebp
  801415:	c3                   	ret    

00801416 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 24             	sub    $0x24,%esp
  80141d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
  801427:	89 1c 24             	mov    %ebx,(%esp)
  80142a:	e8 3c fd ff ff       	call   80116b <fd_lookup>
  80142f:	89 c2                	mov    %eax,%edx
  801431:	85 d2                	test   %edx,%edx
  801433:	78 6d                	js     8014a2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	89 04 24             	mov    %eax,(%esp)
  801444:	e8 78 fd ff ff       	call   8011c1 <dev_lookup>
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 55                	js     8014a2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801450:	8b 50 08             	mov    0x8(%eax),%edx
  801453:	83 e2 03             	and    $0x3,%edx
  801456:	83 fa 01             	cmp    $0x1,%edx
  801459:	75 23                	jne    80147e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145b:	a1 08 40 80 00       	mov    0x804008,%eax
  801460:	8b 40 48             	mov    0x48(%eax),%eax
  801463:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146b:	c7 04 24 90 27 80 00 	movl   $0x802790,(%esp)
  801472:	e8 df ee ff ff       	call   800356 <cprintf>
		return -E_INVAL;
  801477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147c:	eb 24                	jmp    8014a2 <read+0x8c>
	}
	if (!dev->dev_read)
  80147e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801481:	8b 52 08             	mov    0x8(%edx),%edx
  801484:	85 d2                	test   %edx,%edx
  801486:	74 15                	je     80149d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80148f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801492:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801496:	89 04 24             	mov    %eax,(%esp)
  801499:	ff d2                	call   *%edx
  80149b:	eb 05                	jmp    8014a2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80149d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014a2:	83 c4 24             	add    $0x24,%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5d                   	pop    %ebp
  8014a7:	c3                   	ret    

008014a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 1c             	sub    $0x1c,%esp
  8014b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b7:	85 f6                	test   %esi,%esi
  8014b9:	74 33                	je     8014ee <readn+0x46>
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c5:	89 f2                	mov    %esi,%edx
  8014c7:	29 c2                	sub    %eax,%edx
  8014c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014cd:	03 45 0c             	add    0xc(%ebp),%eax
  8014d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d4:	89 3c 24             	mov    %edi,(%esp)
  8014d7:	e8 3a ff ff ff       	call   801416 <read>
		if (m < 0)
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 1b                	js     8014fb <readn+0x53>
			return m;
		if (m == 0)
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	74 11                	je     8014f5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e4:	01 c3                	add    %eax,%ebx
  8014e6:	89 d8                	mov    %ebx,%eax
  8014e8:	39 f3                	cmp    %esi,%ebx
  8014ea:	72 d9                	jb     8014c5 <readn+0x1d>
  8014ec:	eb 0b                	jmp    8014f9 <readn+0x51>
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f3:	eb 06                	jmp    8014fb <readn+0x53>
  8014f5:	89 d8                	mov    %ebx,%eax
  8014f7:	eb 02                	jmp    8014fb <readn+0x53>
  8014f9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014fb:	83 c4 1c             	add    $0x1c,%esp
  8014fe:	5b                   	pop    %ebx
  8014ff:	5e                   	pop    %esi
  801500:	5f                   	pop    %edi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    

00801503 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	53                   	push   %ebx
  801507:	83 ec 24             	sub    $0x24,%esp
  80150a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801510:	89 44 24 04          	mov    %eax,0x4(%esp)
  801514:	89 1c 24             	mov    %ebx,(%esp)
  801517:	e8 4f fc ff ff       	call   80116b <fd_lookup>
  80151c:	89 c2                	mov    %eax,%edx
  80151e:	85 d2                	test   %edx,%edx
  801520:	78 68                	js     80158a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801522:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801525:	89 44 24 04          	mov    %eax,0x4(%esp)
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	8b 00                	mov    (%eax),%eax
  80152e:	89 04 24             	mov    %eax,(%esp)
  801531:	e8 8b fc ff ff       	call   8011c1 <dev_lookup>
  801536:	85 c0                	test   %eax,%eax
  801538:	78 50                	js     80158a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801541:	75 23                	jne    801566 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801543:	a1 08 40 80 00       	mov    0x804008,%eax
  801548:	8b 40 48             	mov    0x48(%eax),%eax
  80154b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80154f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801553:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  80155a:	e8 f7 ed ff ff       	call   800356 <cprintf>
		return -E_INVAL;
  80155f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801564:	eb 24                	jmp    80158a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 52 0c             	mov    0xc(%edx),%edx
  80156c:	85 d2                	test   %edx,%edx
  80156e:	74 15                	je     801585 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801570:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801577:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80157e:	89 04 24             	mov    %eax,(%esp)
  801581:	ff d2                	call   *%edx
  801583:	eb 05                	jmp    80158a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801585:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80158a:	83 c4 24             	add    $0x24,%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <seek>:

int
seek(int fdnum, off_t offset)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801596:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 c3 fb ff ff       	call   80116b <fd_lookup>
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 0e                	js     8015ba <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	53                   	push   %ebx
  8015c0:	83 ec 24             	sub    $0x24,%esp
  8015c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cd:	89 1c 24             	mov    %ebx,(%esp)
  8015d0:	e8 96 fb ff ff       	call   80116b <fd_lookup>
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	85 d2                	test   %edx,%edx
  8015d9:	78 61                	js     80163c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	e8 d2 fb ff ff       	call   8011c1 <dev_lookup>
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 49                	js     80163c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015fa:	75 23                	jne    80161f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015fc:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801601:	8b 40 48             	mov    0x48(%eax),%eax
  801604:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160c:	c7 04 24 6c 27 80 00 	movl   $0x80276c,(%esp)
  801613:	e8 3e ed ff ff       	call   800356 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801618:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161d:	eb 1d                	jmp    80163c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80161f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801622:	8b 52 18             	mov    0x18(%edx),%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	74 0e                	je     801637 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	ff d2                	call   *%edx
  801635:	eb 05                	jmp    80163c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801637:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80163c:	83 c4 24             	add    $0x24,%esp
  80163f:	5b                   	pop    %ebx
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    

00801642 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	53                   	push   %ebx
  801646:	83 ec 24             	sub    $0x24,%esp
  801649:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	89 04 24             	mov    %eax,(%esp)
  801659:	e8 0d fb ff ff       	call   80116b <fd_lookup>
  80165e:	89 c2                	mov    %eax,%edx
  801660:	85 d2                	test   %edx,%edx
  801662:	78 52                	js     8016b6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801664:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166e:	8b 00                	mov    (%eax),%eax
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	e8 49 fb ff ff       	call   8011c1 <dev_lookup>
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 3a                	js     8016b6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80167c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801683:	74 2c                	je     8016b1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801685:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801688:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80168f:	00 00 00 
	stat->st_isdir = 0;
  801692:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801699:	00 00 00 
	stat->st_dev = dev;
  80169c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a9:	89 14 24             	mov    %edx,(%esp)
  8016ac:	ff 50 14             	call   *0x14(%eax)
  8016af:	eb 05                	jmp    8016b6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016b6:	83 c4 24             	add    $0x24,%esp
  8016b9:	5b                   	pop    %ebx
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    

008016bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016cb:	00 
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	89 04 24             	mov    %eax,(%esp)
  8016d2:	e8 af 01 00 00       	call   801886 <open>
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	85 db                	test   %ebx,%ebx
  8016db:	78 1b                	js     8016f8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e4:	89 1c 24             	mov    %ebx,(%esp)
  8016e7:	e8 56 ff ff ff       	call   801642 <fstat>
  8016ec:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ee:	89 1c 24             	mov    %ebx,(%esp)
  8016f1:	e8 bd fb ff ff       	call   8012b3 <close>
	return r;
  8016f6:	89 f0                	mov    %esi,%eax
}
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	5b                   	pop    %ebx
  8016fc:	5e                   	pop    %esi
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 10             	sub    $0x10,%esp
  801707:	89 c6                	mov    %eax,%esi
  801709:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80170b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801712:	75 11                	jne    801725 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801714:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80171b:	e8 66 09 00 00       	call   802086 <ipc_find_env>
  801720:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801725:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80172c:	00 
  80172d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801734:	00 
  801735:	89 74 24 04          	mov    %esi,0x4(%esp)
  801739:	a1 04 40 80 00       	mov    0x804004,%eax
  80173e:	89 04 24             	mov    %eax,(%esp)
  801741:	e8 da 08 00 00       	call   802020 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801746:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80174d:	00 
  80174e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801759:	e8 58 08 00 00       	call   801fb6 <ipc_recv>
}
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	53                   	push   %ebx
  801769:	83 ec 14             	sub    $0x14,%esp
  80176c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	b8 05 00 00 00       	mov    $0x5,%eax
  801784:	e8 76 ff ff ff       	call   8016ff <fsipc>
  801789:	89 c2                	mov    %eax,%edx
  80178b:	85 d2                	test   %edx,%edx
  80178d:	78 2b                	js     8017ba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801796:	00 
  801797:	89 1c 24             	mov    %ebx,(%esp)
  80179a:	e8 0c f2 ff ff       	call   8009ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80179f:	a1 80 50 80 00       	mov    0x805080,%eax
  8017a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017aa:	a1 84 50 80 00       	mov    0x805084,%eax
  8017af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	83 c4 14             	add    $0x14,%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8017db:	e8 1f ff ff ff       	call   8016ff <fsipc>
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 10             	sub    $0x10,%esp
  8017ea:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017f8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801803:	b8 03 00 00 00       	mov    $0x3,%eax
  801808:	e8 f2 fe ff ff       	call   8016ff <fsipc>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 6a                	js     80187d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801813:	39 c6                	cmp    %eax,%esi
  801815:	73 24                	jae    80183b <devfile_read+0x59>
  801817:	c7 44 24 0c c9 27 80 	movl   $0x8027c9,0xc(%esp)
  80181e:	00 
  80181f:	c7 44 24 08 d0 27 80 	movl   $0x8027d0,0x8(%esp)
  801826:	00 
  801827:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  80182e:	00 
  80182f:	c7 04 24 e5 27 80 00 	movl   $0x8027e5,(%esp)
  801836:	e8 22 ea ff ff       	call   80025d <_panic>
	assert(r <= PGSIZE);
  80183b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801840:	7e 24                	jle    801866 <devfile_read+0x84>
  801842:	c7 44 24 0c f0 27 80 	movl   $0x8027f0,0xc(%esp)
  801849:	00 
  80184a:	c7 44 24 08 d0 27 80 	movl   $0x8027d0,0x8(%esp)
  801851:	00 
  801852:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801859:	00 
  80185a:	c7 04 24 e5 27 80 00 	movl   $0x8027e5,(%esp)
  801861:	e8 f7 e9 ff ff       	call   80025d <_panic>
	memmove(buf, &fsipcbuf, r);
  801866:	89 44 24 08          	mov    %eax,0x8(%esp)
  80186a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801871:	00 
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	89 04 24             	mov    %eax,(%esp)
  801878:	e8 29 f3 ff ff       	call   800ba6 <memmove>
	return r;
}
  80187d:	89 d8                	mov    %ebx,%eax
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 24             	sub    $0x24,%esp
  80188d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801890:	89 1c 24             	mov    %ebx,(%esp)
  801893:	e8 b8 f0 ff ff       	call   800950 <strlen>
  801898:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80189d:	7f 60                	jg     8018ff <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80189f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a2:	89 04 24             	mov    %eax,(%esp)
  8018a5:	e8 4d f8 ff ff       	call   8010f7 <fd_alloc>
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	85 d2                	test   %edx,%edx
  8018ae:	78 54                	js     801904 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018bb:	e8 eb f0 ff ff       	call   8009ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d0:	e8 2a fe ff ff       	call   8016ff <fsipc>
  8018d5:	89 c3                	mov    %eax,%ebx
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	79 17                	jns    8018f2 <open+0x6c>
		fd_close(fd, 0);
  8018db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018e2:	00 
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	89 04 24             	mov    %eax,(%esp)
  8018e9:	e8 44 f9 ff ff       	call   801232 <fd_close>
		return r;
  8018ee:	89 d8                	mov    %ebx,%eax
  8018f0:	eb 12                	jmp    801904 <open+0x7e>
	}

	return fd2num(fd);
  8018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f5:	89 04 24             	mov    %eax,(%esp)
  8018f8:	e8 d3 f7 ff ff       	call   8010d0 <fd2num>
  8018fd:	eb 05                	jmp    801904 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018ff:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801904:	83 c4 24             	add    $0x24,%esp
  801907:	5b                   	pop    %ebx
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 14             	sub    $0x14,%esp
  801911:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801913:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801917:	7e 31                	jle    80194a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801919:	8b 40 04             	mov    0x4(%eax),%eax
  80191c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801920:	8d 43 10             	lea    0x10(%ebx),%eax
  801923:	89 44 24 04          	mov    %eax,0x4(%esp)
  801927:	8b 03                	mov    (%ebx),%eax
  801929:	89 04 24             	mov    %eax,(%esp)
  80192c:	e8 d2 fb ff ff       	call   801503 <write>
		if (result > 0)
  801931:	85 c0                	test   %eax,%eax
  801933:	7e 03                	jle    801938 <writebuf+0x2e>
			b->result += result;
  801935:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801938:	39 43 04             	cmp    %eax,0x4(%ebx)
  80193b:	74 0d                	je     80194a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80193d:	85 c0                	test   %eax,%eax
  80193f:	ba 00 00 00 00       	mov    $0x0,%edx
  801944:	0f 4f c2             	cmovg  %edx,%eax
  801947:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80194a:	83 c4 14             	add    $0x14,%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <putch>:

static void
putch(int ch, void *thunk)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80195a:	8b 53 04             	mov    0x4(%ebx),%edx
  80195d:	8d 42 01             	lea    0x1(%edx),%eax
  801960:	89 43 04             	mov    %eax,0x4(%ebx)
  801963:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801966:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80196a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80196f:	75 0e                	jne    80197f <putch+0x2f>
		writebuf(b);
  801971:	89 d8                	mov    %ebx,%eax
  801973:	e8 92 ff ff ff       	call   80190a <writebuf>
		b->idx = 0;
  801978:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  80197f:	83 c4 04             	add    $0x4,%esp
  801982:	5b                   	pop    %ebx
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801997:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80199e:	00 00 00 
	b.result = 0;
  8019a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019a8:	00 00 00 
	b.error = 1;
  8019ab:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019b2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cd:	c7 04 24 50 19 80 00 	movl   $0x801950,(%esp)
  8019d4:	e8 0b eb ff ff       	call   8004e4 <vprintfmt>
	if (b.idx > 0)
  8019d9:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019e0:	7e 0b                	jle    8019ed <vfprintf+0x68>
		writebuf(&b);
  8019e2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019e8:	e8 1d ff ff ff       	call   80190a <writebuf>

	return (b.result ? b.result : b.error);
  8019ed:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a04:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 68 ff ff ff       	call   801985 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <printf>:

int
printf(const char *fmt, ...)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a25:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a3a:	e8 46 ff ff ff       	call   801985 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    
  801a41:	66 90                	xchg   %ax,%ax
  801a43:	66 90                	xchg   %ax,%ax
  801a45:	66 90                	xchg   %ax,%ax
  801a47:	66 90                	xchg   %ax,%ax
  801a49:	66 90                	xchg   %ax,%ax
  801a4b:	66 90                	xchg   %ax,%ax
  801a4d:	66 90                	xchg   %ax,%ax
  801a4f:	90                   	nop

00801a50 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	56                   	push   %esi
  801a54:	53                   	push   %ebx
  801a55:	83 ec 10             	sub    $0x10,%esp
  801a58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	89 04 24             	mov    %eax,(%esp)
  801a61:	e8 7a f6 ff ff       	call   8010e0 <fd2data>
  801a66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a68:	c7 44 24 04 fc 27 80 	movl   $0x8027fc,0x4(%esp)
  801a6f:	00 
  801a70:	89 1c 24             	mov    %ebx,(%esp)
  801a73:	e8 33 ef ff ff       	call   8009ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a78:	8b 46 04             	mov    0x4(%esi),%eax
  801a7b:	2b 06                	sub    (%esi),%eax
  801a7d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a8a:	00 00 00 
	stat->st_dev = &devpipe;
  801a8d:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801a94:	30 80 00 
	return 0;
}
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    

00801aa3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 14             	sub    $0x14,%esp
  801aaa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab8:	e8 43 f4 ff ff       	call   800f00 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801abd:	89 1c 24             	mov    %ebx,(%esp)
  801ac0:	e8 1b f6 ff ff       	call   8010e0 <fd2data>
  801ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad0:	e8 2b f4 ff ff       	call   800f00 <sys_page_unmap>
}
  801ad5:	83 c4 14             	add    $0x14,%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	57                   	push   %edi
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 2c             	sub    $0x2c,%esp
  801ae4:	89 c6                	mov    %eax,%esi
  801ae6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ae9:	a1 08 40 80 00       	mov    0x804008,%eax
  801aee:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801af1:	89 34 24             	mov    %esi,(%esp)
  801af4:	e8 d5 05 00 00       	call   8020ce <pageref>
  801af9:	89 c7                	mov    %eax,%edi
  801afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801afe:	89 04 24             	mov    %eax,(%esp)
  801b01:	e8 c8 05 00 00       	call   8020ce <pageref>
  801b06:	39 c7                	cmp    %eax,%edi
  801b08:	0f 94 c2             	sete   %dl
  801b0b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801b0e:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801b14:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801b17:	39 fb                	cmp    %edi,%ebx
  801b19:	74 21                	je     801b3c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b1b:	84 d2                	test   %dl,%dl
  801b1d:	74 ca                	je     801ae9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b1f:	8b 51 58             	mov    0x58(%ecx),%edx
  801b22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2e:	c7 04 24 03 28 80 00 	movl   $0x802803,(%esp)
  801b35:	e8 1c e8 ff ff       	call   800356 <cprintf>
  801b3a:	eb ad                	jmp    801ae9 <_pipeisclosed+0xe>
	}
}
  801b3c:	83 c4 2c             	add    $0x2c,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 1c             	sub    $0x1c,%esp
  801b4d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b50:	89 34 24             	mov    %esi,(%esp)
  801b53:	e8 88 f5 ff ff       	call   8010e0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b5c:	74 61                	je     801bbf <devpipe_write+0x7b>
  801b5e:	89 c3                	mov    %eax,%ebx
  801b60:	bf 00 00 00 00       	mov    $0x0,%edi
  801b65:	eb 4a                	jmp    801bb1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b67:	89 da                	mov    %ebx,%edx
  801b69:	89 f0                	mov    %esi,%eax
  801b6b:	e8 6b ff ff ff       	call   801adb <_pipeisclosed>
  801b70:	85 c0                	test   %eax,%eax
  801b72:	75 54                	jne    801bc8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b74:	e8 c1 f2 ff ff       	call   800e3a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b79:	8b 43 04             	mov    0x4(%ebx),%eax
  801b7c:	8b 0b                	mov    (%ebx),%ecx
  801b7e:	8d 51 20             	lea    0x20(%ecx),%edx
  801b81:	39 d0                	cmp    %edx,%eax
  801b83:	73 e2                	jae    801b67 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b88:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b8c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b8f:	99                   	cltd   
  801b90:	c1 ea 1b             	shr    $0x1b,%edx
  801b93:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801b96:	83 e1 1f             	and    $0x1f,%ecx
  801b99:	29 d1                	sub    %edx,%ecx
  801b9b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801b9f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ba3:	83 c0 01             	add    $0x1,%eax
  801ba6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ba9:	83 c7 01             	add    $0x1,%edi
  801bac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801baf:	74 13                	je     801bc4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bb1:	8b 43 04             	mov    0x4(%ebx),%eax
  801bb4:	8b 0b                	mov    (%ebx),%ecx
  801bb6:	8d 51 20             	lea    0x20(%ecx),%edx
  801bb9:	39 d0                	cmp    %edx,%eax
  801bbb:	73 aa                	jae    801b67 <devpipe_write+0x23>
  801bbd:	eb c6                	jmp    801b85 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bbf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bc4:	89 f8                	mov    %edi,%eax
  801bc6:	eb 05                	jmp    801bcd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801bcd:	83 c4 1c             	add    $0x1c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    

00801bd5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 1c             	sub    $0x1c,%esp
  801bde:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801be1:	89 3c 24             	mov    %edi,(%esp)
  801be4:	e8 f7 f4 ff ff       	call   8010e0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801be9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bed:	74 54                	je     801c43 <devpipe_read+0x6e>
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	be 00 00 00 00       	mov    $0x0,%esi
  801bf6:	eb 3e                	jmp    801c36 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801bf8:	89 f0                	mov    %esi,%eax
  801bfa:	eb 55                	jmp    801c51 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801bfc:	89 da                	mov    %ebx,%edx
  801bfe:	89 f8                	mov    %edi,%eax
  801c00:	e8 d6 fe ff ff       	call   801adb <_pipeisclosed>
  801c05:	85 c0                	test   %eax,%eax
  801c07:	75 43                	jne    801c4c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c09:	e8 2c f2 ff ff       	call   800e3a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c0e:	8b 03                	mov    (%ebx),%eax
  801c10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c13:	74 e7                	je     801bfc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c15:	99                   	cltd   
  801c16:	c1 ea 1b             	shr    $0x1b,%edx
  801c19:	01 d0                	add    %edx,%eax
  801c1b:	83 e0 1f             	and    $0x1f,%eax
  801c1e:	29 d0                	sub    %edx,%eax
  801c20:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c28:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c2b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c2e:	83 c6 01             	add    $0x1,%esi
  801c31:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c34:	74 12                	je     801c48 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801c36:	8b 03                	mov    (%ebx),%eax
  801c38:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c3b:	75 d8                	jne    801c15 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c3d:	85 f6                	test   %esi,%esi
  801c3f:	75 b7                	jne    801bf8 <devpipe_read+0x23>
  801c41:	eb b9                	jmp    801bfc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c43:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c48:	89 f0                	mov    %esi,%eax
  801c4a:	eb 05                	jmp    801c51 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	56                   	push   %esi
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 8b f4 ff ff       	call   8010f7 <fd_alloc>
  801c6c:	89 c2                	mov    %eax,%edx
  801c6e:	85 d2                	test   %edx,%edx
  801c70:	0f 88 4d 01 00 00    	js     801dc3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c7d:	00 
  801c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8c:	e8 c8 f1 ff ff       	call   800e59 <sys_page_alloc>
  801c91:	89 c2                	mov    %eax,%edx
  801c93:	85 d2                	test   %edx,%edx
  801c95:	0f 88 28 01 00 00    	js     801dc3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 51 f4 ff ff       	call   8010f7 <fd_alloc>
  801ca6:	89 c3                	mov    %eax,%ebx
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 88 fe 00 00 00    	js     801dae <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cb7:	00 
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cc6:	e8 8e f1 ff ff       	call   800e59 <sys_page_alloc>
  801ccb:	89 c3                	mov    %eax,%ebx
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	0f 88 d9 00 00 00    	js     801dae <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	89 04 24             	mov    %eax,(%esp)
  801cdb:	e8 00 f4 ff ff       	call   8010e0 <fd2data>
  801ce0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ce9:	00 
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf5:	e8 5f f1 ff ff       	call   800e59 <sys_page_alloc>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	0f 88 97 00 00 00    	js     801d9b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 d1 f3 ff ff       	call   8010e0 <fd2data>
  801d0f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801d16:	00 
  801d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d22:	00 
  801d23:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2e:	e8 7a f1 ff ff       	call   800ead <sys_page_map>
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	85 c0                	test   %eax,%eax
  801d37:	78 52                	js     801d8b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d39:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d4e:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	89 04 24             	mov    %eax,(%esp)
  801d69:	e8 62 f3 ff ff       	call   8010d0 <fd2num>
  801d6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d71:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 52 f3 ff ff       	call   8010d0 <fd2num>
  801d7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d81:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
  801d89:	eb 38                	jmp    801dc3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801d8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d96:	e8 65 f1 ff ff       	call   800f00 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da9:	e8 52 f1 ff ff       	call   800f00 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbc:	e8 3f f1 ff ff       	call   800f00 <sys_page_unmap>
  801dc1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801dc3:	83 c4 30             	add    $0x30,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	89 04 24             	mov    %eax,(%esp)
  801ddd:	e8 89 f3 ff ff       	call   80116b <fd_lookup>
  801de2:	89 c2                	mov    %eax,%edx
  801de4:	85 d2                	test   %edx,%edx
  801de6:	78 15                	js     801dfd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	89 04 24             	mov    %eax,(%esp)
  801dee:	e8 ed f2 ff ff       	call   8010e0 <fd2data>
	return _pipeisclosed(fd, p);
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	e8 de fc ff ff       	call   801adb <_pipeisclosed>
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    
  801dff:	90                   	nop

00801e00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801e10:	c7 44 24 04 1b 28 80 	movl   $0x80281b,0x4(%esp)
  801e17:	00 
  801e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1b:	89 04 24             	mov    %eax,(%esp)
  801e1e:	e8 88 eb ff ff       	call   8009ab <strcpy>
	return 0;
}
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	57                   	push   %edi
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3a:	74 4a                	je     801e86 <devcons_write+0x5c>
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e41:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e46:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e4c:	8b 75 10             	mov    0x10(%ebp),%esi
  801e4f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801e51:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e54:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e59:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e5c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801e60:	03 45 0c             	add    0xc(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	89 3c 24             	mov    %edi,(%esp)
  801e6a:	e8 37 ed ff ff       	call   800ba6 <memmove>
		sys_cputs(buf, m);
  801e6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e73:	89 3c 24             	mov    %edi,(%esp)
  801e76:	e8 11 ef ff ff       	call   800d8c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e7b:	01 f3                	add    %esi,%ebx
  801e7d:	89 d8                	mov    %ebx,%eax
  801e7f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801e82:	72 c8                	jb     801e4c <devcons_write+0x22>
  801e84:	eb 05                	jmp    801e8b <devcons_write+0x61>
  801e86:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e8b:	89 d8                	mov    %ebx,%eax
  801e8d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5f                   	pop    %edi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    

00801e98 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801ea3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea7:	75 07                	jne    801eb0 <devcons_read+0x18>
  801ea9:	eb 28                	jmp    801ed3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801eab:	e8 8a ef ff ff       	call   800e3a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801eb0:	e8 f5 ee ff ff       	call   800daa <sys_cgetc>
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	74 f2                	je     801eab <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	78 16                	js     801ed3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ebd:	83 f8 04             	cmp    $0x4,%eax
  801ec0:	74 0c                	je     801ece <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	88 02                	mov    %al,(%edx)
	return 1;
  801ec7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecc:	eb 05                	jmp    801ed3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ee1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ee8:	00 
  801ee9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eec:	89 04 24             	mov    %eax,(%esp)
  801eef:	e8 98 ee ff ff       	call   800d8c <sys_cputs>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <getchar>:

int
getchar(void)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801efc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f03:	00 
  801f04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f12:	e8 ff f4 ff ff       	call   801416 <read>
	if (r < 0)
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 0f                	js     801f2a <getchar+0x34>
		return r;
	if (r < 1)
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	7e 06                	jle    801f25 <getchar+0x2f>
		return -E_EOF;
	return c;
  801f1f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f23:	eb 05                	jmp    801f2a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	89 04 24             	mov    %eax,(%esp)
  801f3f:	e8 27 f2 ff ff       	call   80116b <fd_lookup>
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 11                	js     801f59 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801f51:	39 10                	cmp    %edx,(%eax)
  801f53:	0f 94 c0             	sete   %al
  801f56:	0f b6 c0             	movzbl %al,%eax
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <opencons>:

int
opencons(void)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f64:	89 04 24             	mov    %eax,(%esp)
  801f67:	e8 8b f1 ff ff       	call   8010f7 <fd_alloc>
		return r;
  801f6c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 40                	js     801fb2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f79:	00 
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f88:	e8 cc ee ff ff       	call   800e59 <sys_page_alloc>
		return r;
  801f8d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 1f                	js     801fb2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f93:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fa8:	89 04 24             	mov    %eax,(%esp)
  801fab:	e8 20 f1 ff ff       	call   8010d0 <fd2num>
  801fb0:	89 c2                	mov    %eax,%edx
}
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
  801fbb:	83 ec 10             	sub    $0x10,%esp
  801fbe:	8b 75 08             	mov    0x8(%ebp),%esi
  801fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801fc7:	83 f8 01             	cmp    $0x1,%eax
  801fca:	19 c0                	sbb    %eax,%eax
  801fcc:	f7 d0                	not    %eax
  801fce:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 94 f0 ff ff       	call   80106f <sys_ipc_recv>
	if (err_code < 0) {
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	79 16                	jns    801ff5 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801fdf:	85 f6                	test   %esi,%esi
  801fe1:	74 06                	je     801fe9 <ipc_recv+0x33>
  801fe3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801fe9:	85 db                	test   %ebx,%ebx
  801feb:	74 2c                	je     802019 <ipc_recv+0x63>
  801fed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ff3:	eb 24                	jmp    802019 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801ff5:	85 f6                	test   %esi,%esi
  801ff7:	74 0a                	je     802003 <ipc_recv+0x4d>
  801ff9:	a1 08 40 80 00       	mov    0x804008,%eax
  801ffe:	8b 40 74             	mov    0x74(%eax),%eax
  802001:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802003:	85 db                	test   %ebx,%ebx
  802005:	74 0a                	je     802011 <ipc_recv+0x5b>
  802007:	a1 08 40 80 00       	mov    0x804008,%eax
  80200c:	8b 40 78             	mov    0x78(%eax),%eax
  80200f:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802011:	a1 08 40 80 00       	mov    0x804008,%eax
  802016:	8b 40 70             	mov    0x70(%eax),%eax
}
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	57                   	push   %edi
  802024:	56                   	push   %esi
  802025:	53                   	push   %ebx
  802026:	83 ec 1c             	sub    $0x1c,%esp
  802029:	8b 7d 08             	mov    0x8(%ebp),%edi
  80202c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80202f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802032:	eb 25                	jmp    802059 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802034:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802037:	74 20                	je     802059 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802039:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80203d:	c7 44 24 08 27 28 80 	movl   $0x802827,0x8(%esp)
  802044:	00 
  802045:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80204c:	00 
  80204d:	c7 04 24 33 28 80 00 	movl   $0x802833,(%esp)
  802054:	e8 04 e2 ff ff       	call   80025d <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802059:	85 db                	test   %ebx,%ebx
  80205b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802060:	0f 45 c3             	cmovne %ebx,%eax
  802063:	8b 55 14             	mov    0x14(%ebp),%edx
  802066:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80206a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802072:	89 3c 24             	mov    %edi,(%esp)
  802075:	e8 d2 ef ff ff       	call   80104c <sys_ipc_try_send>
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 b6                	jne    802034 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80207e:	83 c4 1c             	add    $0x1c,%esp
  802081:	5b                   	pop    %ebx
  802082:	5e                   	pop    %esi
  802083:	5f                   	pop    %edi
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    

00802086 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80208c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802091:	39 c8                	cmp    %ecx,%eax
  802093:	74 17                	je     8020ac <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802095:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80209a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80209d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020a3:	8b 52 50             	mov    0x50(%edx),%edx
  8020a6:	39 ca                	cmp    %ecx,%edx
  8020a8:	75 14                	jne    8020be <ipc_find_env+0x38>
  8020aa:	eb 05                	jmp    8020b1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8020b1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020b4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8020b9:	8b 40 40             	mov    0x40(%eax),%eax
  8020bc:	eb 0e                	jmp    8020cc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8020be:	83 c0 01             	add    $0x1,%eax
  8020c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020c6:	75 d2                	jne    80209a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8020c8:	66 b8 00 00          	mov    $0x0,%ax
}
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020d4:	89 d0                	mov    %edx,%eax
  8020d6:	c1 e8 16             	shr    $0x16,%eax
  8020d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020e5:	f6 c1 01             	test   $0x1,%cl
  8020e8:	74 1d                	je     802107 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8020ea:	c1 ea 0c             	shr    $0xc,%edx
  8020ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020f4:	f6 c2 01             	test   $0x1,%dl
  8020f7:	74 0e                	je     802107 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020f9:	c1 ea 0c             	shr    $0xc,%edx
  8020fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802103:	ef 
  802104:	0f b7 c0             	movzwl %ax,%eax
}
  802107:	5d                   	pop    %ebp
  802108:	c3                   	ret    
  802109:	66 90                	xchg   %ax,%ax
  80210b:	66 90                	xchg   %ax,%ax
  80210d:	66 90                	xchg   %ax,%ax
  80210f:	90                   	nop

00802110 <__udivdi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	8b 44 24 28          	mov    0x28(%esp),%eax
  80211a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80211e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802122:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802126:	85 c0                	test   %eax,%eax
  802128:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80212c:	89 ea                	mov    %ebp,%edx
  80212e:	89 0c 24             	mov    %ecx,(%esp)
  802131:	75 2d                	jne    802160 <__udivdi3+0x50>
  802133:	39 e9                	cmp    %ebp,%ecx
  802135:	77 61                	ja     802198 <__udivdi3+0x88>
  802137:	85 c9                	test   %ecx,%ecx
  802139:	89 ce                	mov    %ecx,%esi
  80213b:	75 0b                	jne    802148 <__udivdi3+0x38>
  80213d:	b8 01 00 00 00       	mov    $0x1,%eax
  802142:	31 d2                	xor    %edx,%edx
  802144:	f7 f1                	div    %ecx
  802146:	89 c6                	mov    %eax,%esi
  802148:	31 d2                	xor    %edx,%edx
  80214a:	89 e8                	mov    %ebp,%eax
  80214c:	f7 f6                	div    %esi
  80214e:	89 c5                	mov    %eax,%ebp
  802150:	89 f8                	mov    %edi,%eax
  802152:	f7 f6                	div    %esi
  802154:	89 ea                	mov    %ebp,%edx
  802156:	83 c4 0c             	add    $0xc,%esp
  802159:	5e                   	pop    %esi
  80215a:	5f                   	pop    %edi
  80215b:	5d                   	pop    %ebp
  80215c:	c3                   	ret    
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	39 e8                	cmp    %ebp,%eax
  802162:	77 24                	ja     802188 <__udivdi3+0x78>
  802164:	0f bd e8             	bsr    %eax,%ebp
  802167:	83 f5 1f             	xor    $0x1f,%ebp
  80216a:	75 3c                	jne    8021a8 <__udivdi3+0x98>
  80216c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802170:	39 34 24             	cmp    %esi,(%esp)
  802173:	0f 86 9f 00 00 00    	jbe    802218 <__udivdi3+0x108>
  802179:	39 d0                	cmp    %edx,%eax
  80217b:	0f 82 97 00 00 00    	jb     802218 <__udivdi3+0x108>
  802181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802188:	31 d2                	xor    %edx,%edx
  80218a:	31 c0                	xor    %eax,%eax
  80218c:	83 c4 0c             	add    $0xc,%esp
  80218f:	5e                   	pop    %esi
  802190:	5f                   	pop    %edi
  802191:	5d                   	pop    %ebp
  802192:	c3                   	ret    
  802193:	90                   	nop
  802194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802198:	89 f8                	mov    %edi,%eax
  80219a:	f7 f1                	div    %ecx
  80219c:	31 d2                	xor    %edx,%edx
  80219e:	83 c4 0c             	add    $0xc,%esp
  8021a1:	5e                   	pop    %esi
  8021a2:	5f                   	pop    %edi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
  8021a5:	8d 76 00             	lea    0x0(%esi),%esi
  8021a8:	89 e9                	mov    %ebp,%ecx
  8021aa:	8b 3c 24             	mov    (%esp),%edi
  8021ad:	d3 e0                	shl    %cl,%eax
  8021af:	89 c6                	mov    %eax,%esi
  8021b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8021b6:	29 e8                	sub    %ebp,%eax
  8021b8:	89 c1                	mov    %eax,%ecx
  8021ba:	d3 ef                	shr    %cl,%edi
  8021bc:	89 e9                	mov    %ebp,%ecx
  8021be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021c2:	8b 3c 24             	mov    (%esp),%edi
  8021c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8021c9:	89 d6                	mov    %edx,%esi
  8021cb:	d3 e7                	shl    %cl,%edi
  8021cd:	89 c1                	mov    %eax,%ecx
  8021cf:	89 3c 24             	mov    %edi,(%esp)
  8021d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8021d6:	d3 ee                	shr    %cl,%esi
  8021d8:	89 e9                	mov    %ebp,%ecx
  8021da:	d3 e2                	shl    %cl,%edx
  8021dc:	89 c1                	mov    %eax,%ecx
  8021de:	d3 ef                	shr    %cl,%edi
  8021e0:	09 d7                	or     %edx,%edi
  8021e2:	89 f2                	mov    %esi,%edx
  8021e4:	89 f8                	mov    %edi,%eax
  8021e6:	f7 74 24 08          	divl   0x8(%esp)
  8021ea:	89 d6                	mov    %edx,%esi
  8021ec:	89 c7                	mov    %eax,%edi
  8021ee:	f7 24 24             	mull   (%esp)
  8021f1:	39 d6                	cmp    %edx,%esi
  8021f3:	89 14 24             	mov    %edx,(%esp)
  8021f6:	72 30                	jb     802228 <__udivdi3+0x118>
  8021f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021fc:	89 e9                	mov    %ebp,%ecx
  8021fe:	d3 e2                	shl    %cl,%edx
  802200:	39 c2                	cmp    %eax,%edx
  802202:	73 05                	jae    802209 <__udivdi3+0xf9>
  802204:	3b 34 24             	cmp    (%esp),%esi
  802207:	74 1f                	je     802228 <__udivdi3+0x118>
  802209:	89 f8                	mov    %edi,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	e9 7a ff ff ff       	jmp    80218c <__udivdi3+0x7c>
  802212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802218:	31 d2                	xor    %edx,%edx
  80221a:	b8 01 00 00 00       	mov    $0x1,%eax
  80221f:	e9 68 ff ff ff       	jmp    80218c <__udivdi3+0x7c>
  802224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802228:	8d 47 ff             	lea    -0x1(%edi),%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 0c             	add    $0xc,%esp
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	66 90                	xchg   %ax,%ax
  802236:	66 90                	xchg   %ax,%ax
  802238:	66 90                	xchg   %ax,%ax
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <__umoddi3>:
  802240:	55                   	push   %ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	83 ec 14             	sub    $0x14,%esp
  802246:	8b 44 24 28          	mov    0x28(%esp),%eax
  80224a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80224e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802252:	89 c7                	mov    %eax,%edi
  802254:	89 44 24 04          	mov    %eax,0x4(%esp)
  802258:	8b 44 24 30          	mov    0x30(%esp),%eax
  80225c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802260:	89 34 24             	mov    %esi,(%esp)
  802263:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802267:	85 c0                	test   %eax,%eax
  802269:	89 c2                	mov    %eax,%edx
  80226b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80226f:	75 17                	jne    802288 <__umoddi3+0x48>
  802271:	39 fe                	cmp    %edi,%esi
  802273:	76 4b                	jbe    8022c0 <__umoddi3+0x80>
  802275:	89 c8                	mov    %ecx,%eax
  802277:	89 fa                	mov    %edi,%edx
  802279:	f7 f6                	div    %esi
  80227b:	89 d0                	mov    %edx,%eax
  80227d:	31 d2                	xor    %edx,%edx
  80227f:	83 c4 14             	add    $0x14,%esp
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
  802286:	66 90                	xchg   %ax,%ax
  802288:	39 f8                	cmp    %edi,%eax
  80228a:	77 54                	ja     8022e0 <__umoddi3+0xa0>
  80228c:	0f bd e8             	bsr    %eax,%ebp
  80228f:	83 f5 1f             	xor    $0x1f,%ebp
  802292:	75 5c                	jne    8022f0 <__umoddi3+0xb0>
  802294:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802298:	39 3c 24             	cmp    %edi,(%esp)
  80229b:	0f 87 e7 00 00 00    	ja     802388 <__umoddi3+0x148>
  8022a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8022a5:	29 f1                	sub    %esi,%ecx
  8022a7:	19 c7                	sbb    %eax,%edi
  8022a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8022b9:	83 c4 14             	add    $0x14,%esp
  8022bc:	5e                   	pop    %esi
  8022bd:	5f                   	pop    %edi
  8022be:	5d                   	pop    %ebp
  8022bf:	c3                   	ret    
  8022c0:	85 f6                	test   %esi,%esi
  8022c2:	89 f5                	mov    %esi,%ebp
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0x91>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f6                	div    %esi
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022d5:	31 d2                	xor    %edx,%edx
  8022d7:	f7 f5                	div    %ebp
  8022d9:	89 c8                	mov    %ecx,%eax
  8022db:	f7 f5                	div    %ebp
  8022dd:	eb 9c                	jmp    80227b <__umoddi3+0x3b>
  8022df:	90                   	nop
  8022e0:	89 c8                	mov    %ecx,%eax
  8022e2:	89 fa                	mov    %edi,%edx
  8022e4:	83 c4 14             	add    $0x14,%esp
  8022e7:	5e                   	pop    %esi
  8022e8:	5f                   	pop    %edi
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    
  8022eb:	90                   	nop
  8022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	8b 04 24             	mov    (%esp),%eax
  8022f3:	be 20 00 00 00       	mov    $0x20,%esi
  8022f8:	89 e9                	mov    %ebp,%ecx
  8022fa:	29 ee                	sub    %ebp,%esi
  8022fc:	d3 e2                	shl    %cl,%edx
  8022fe:	89 f1                	mov    %esi,%ecx
  802300:	d3 e8                	shr    %cl,%eax
  802302:	89 e9                	mov    %ebp,%ecx
  802304:	89 44 24 04          	mov    %eax,0x4(%esp)
  802308:	8b 04 24             	mov    (%esp),%eax
  80230b:	09 54 24 04          	or     %edx,0x4(%esp)
  80230f:	89 fa                	mov    %edi,%edx
  802311:	d3 e0                	shl    %cl,%eax
  802313:	89 f1                	mov    %esi,%ecx
  802315:	89 44 24 08          	mov    %eax,0x8(%esp)
  802319:	8b 44 24 10          	mov    0x10(%esp),%eax
  80231d:	d3 ea                	shr    %cl,%edx
  80231f:	89 e9                	mov    %ebp,%ecx
  802321:	d3 e7                	shl    %cl,%edi
  802323:	89 f1                	mov    %esi,%ecx
  802325:	d3 e8                	shr    %cl,%eax
  802327:	89 e9                	mov    %ebp,%ecx
  802329:	09 f8                	or     %edi,%eax
  80232b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80232f:	f7 74 24 04          	divl   0x4(%esp)
  802333:	d3 e7                	shl    %cl,%edi
  802335:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802339:	89 d7                	mov    %edx,%edi
  80233b:	f7 64 24 08          	mull   0x8(%esp)
  80233f:	39 d7                	cmp    %edx,%edi
  802341:	89 c1                	mov    %eax,%ecx
  802343:	89 14 24             	mov    %edx,(%esp)
  802346:	72 2c                	jb     802374 <__umoddi3+0x134>
  802348:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80234c:	72 22                	jb     802370 <__umoddi3+0x130>
  80234e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802352:	29 c8                	sub    %ecx,%eax
  802354:	19 d7                	sbb    %edx,%edi
  802356:	89 e9                	mov    %ebp,%ecx
  802358:	89 fa                	mov    %edi,%edx
  80235a:	d3 e8                	shr    %cl,%eax
  80235c:	89 f1                	mov    %esi,%ecx
  80235e:	d3 e2                	shl    %cl,%edx
  802360:	89 e9                	mov    %ebp,%ecx
  802362:	d3 ef                	shr    %cl,%edi
  802364:	09 d0                	or     %edx,%eax
  802366:	89 fa                	mov    %edi,%edx
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5e                   	pop    %esi
  80236c:	5f                   	pop    %edi
  80236d:	5d                   	pop    %ebp
  80236e:	c3                   	ret    
  80236f:	90                   	nop
  802370:	39 d7                	cmp    %edx,%edi
  802372:	75 da                	jne    80234e <__umoddi3+0x10e>
  802374:	8b 14 24             	mov    (%esp),%edx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80237d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802381:	eb cb                	jmp    80234e <__umoddi3+0x10e>
  802383:	90                   	nop
  802384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802388:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80238c:	0f 82 0f ff ff ff    	jb     8022a1 <__umoddi3+0x61>
  802392:	e9 1a ff ff ff       	jmp    8022b1 <__umoddi3+0x71>
