
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 02 01 00 00       	call   800133 <libmain>
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

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800046:	c7 04 24 e0 21 80 00 	movl   $0x8021e0,(%esp)
  80004d:	e8 6b 02 00 00       	call   8002bd <cprintf>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
  800052:	83 3d 20 40 80 00 00 	cmpl   $0x0,0x804020
  800059:	75 11                	jne    80006c <umain+0x2c>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  80005b:	b8 01 00 00 00       	mov    $0x1,%eax
		if (bigarray[i] != 0)
  800060:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800067:	00 
  800068:	74 27                	je     800091 <umain+0x51>
  80006a:	eb 05                	jmp    800071 <umain+0x31>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 5b 22 80 	movl   $0x80225b,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 78 22 80 00 	movl   $0x802278,(%esp)
  80008c:	e8 33 01 00 00       	call   8001c4 <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800091:	83 c0 01             	add    $0x1,%eax
  800094:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800099:	75 c5                	jne    800060 <umain+0x20>
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  8000a0:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000a7:	83 c0 01             	add    $0x1,%eax
  8000aa:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000af:	75 ef                	jne    8000a0 <umain+0x60>
  8000b1:	eb 70                	jmp    800123 <umain+0xe3>
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  8000b3:	3b 04 85 20 40 80 00 	cmp    0x804020(,%eax,4),%eax
  8000ba:	74 2b                	je     8000e7 <umain+0xa7>
  8000bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8000c0:	eb 05                	jmp    8000c7 <umain+0x87>
  8000c2:	b8 00 00 00 00       	mov    $0x0,%eax
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000cb:	c7 44 24 08 00 22 80 	movl   $0x802200,0x8(%esp)
  8000d2:	00 
  8000d3:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  8000da:	00 
  8000db:	c7 04 24 78 22 80 00 	movl   $0x802278,(%esp)
  8000e2:	e8 dd 00 00 00       	call   8001c4 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000e7:	83 c0 01             	add    $0x1,%eax
  8000ea:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000ef:	75 c2                	jne    8000b3 <umain+0x73>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000f1:	c7 04 24 28 22 80 00 	movl   $0x802228,(%esp)
  8000f8:	e8 c0 01 00 00       	call   8002bd <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000fd:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  800104:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800107:	c7 44 24 08 87 22 80 	movl   $0x802287,0x8(%esp)
  80010e:	00 
  80010f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800116:	00 
  800117:	c7 04 24 78 22 80 00 	movl   $0x802278,(%esp)
  80011e:	e8 a1 00 00 00       	call   8001c4 <_panic>
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  800123:	83 3d 20 40 80 00 00 	cmpl   $0x0,0x804020
  80012a:	75 96                	jne    8000c2 <umain+0x82>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  80012c:	b8 01 00 00 00       	mov    $0x1,%eax
  800131:	eb 80                	jmp    8000b3 <umain+0x73>

00800133 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	83 ec 10             	sub    $0x10,%esp
  80013b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800141:	e8 45 0c 00 00       	call   800d8b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800146:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80014c:	39 c2                	cmp    %eax,%edx
  80014e:	74 17                	je     800167 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800150:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800155:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800158:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80015e:	8b 49 40             	mov    0x40(%ecx),%ecx
  800161:	39 c1                	cmp    %eax,%ecx
  800163:	75 18                	jne    80017d <libmain+0x4a>
  800165:	eb 05                	jmp    80016c <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800167:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80016c:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80016f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800175:	89 15 20 40 c0 00    	mov    %edx,0xc04020
			break;
  80017b:	eb 0b                	jmp    800188 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80017d:	83 c2 01             	add    $0x1,%edx
  800180:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800186:	75 cd                	jne    800155 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	85 db                	test   %ebx,%ebx
  80018a:	7e 07                	jle    800193 <libmain+0x60>
		binaryname = argv[0];
  80018c:	8b 06                	mov    (%esi),%eax
  80018e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800193:	89 74 24 04          	mov    %esi,0x4(%esp)
  800197:	89 1c 24             	mov    %ebx,(%esp)
  80019a:	e8 a1 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80019f:	e8 07 00 00 00       	call   8001ab <exit>
}
  8001a4:	83 c4 10             	add    $0x10,%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    

008001ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b1:	e8 a0 10 00 00       	call   801256 <close_all>
	sys_env_destroy(0);
  8001b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001bd:	e8 77 0b 00 00       	call   800d39 <sys_env_destroy>
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001cc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001cf:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001d5:	e8 b1 0b 00 00       	call   800d8b <sys_getenvid>
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001e8:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f0:	c7 04 24 a8 22 80 00 	movl   $0x8022a8,(%esp)
  8001f7:	e8 c1 00 00 00       	call   8002bd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800200:	8b 45 10             	mov    0x10(%ebp),%eax
  800203:	89 04 24             	mov    %eax,(%esp)
  800206:	e8 51 00 00 00       	call   80025c <vcprintf>
	cprintf("\n");
  80020b:	c7 04 24 76 22 80 00 	movl   $0x802276,(%esp)
  800212:	e8 a6 00 00 00       	call   8002bd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800217:	cc                   	int3   
  800218:	eb fd                	jmp    800217 <_panic+0x53>

0080021a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	53                   	push   %ebx
  80021e:	83 ec 14             	sub    $0x14,%esp
  800221:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800224:	8b 13                	mov    (%ebx),%edx
  800226:	8d 42 01             	lea    0x1(%edx),%eax
  800229:	89 03                	mov    %eax,(%ebx)
  80022b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800232:	3d ff 00 00 00       	cmp    $0xff,%eax
  800237:	75 19                	jne    800252 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800239:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800240:	00 
  800241:	8d 43 08             	lea    0x8(%ebx),%eax
  800244:	89 04 24             	mov    %eax,(%esp)
  800247:	e8 b0 0a 00 00       	call   800cfc <sys_cputs>
		b->idx = 0;
  80024c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800252:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800256:	83 c4 14             	add    $0x14,%esp
  800259:	5b                   	pop    %ebx
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    

0080025c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800265:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026c:	00 00 00 
	b.cnt = 0;
  80026f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800276:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	89 44 24 08          	mov    %eax,0x8(%esp)
  800287:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800291:	c7 04 24 1a 02 80 00 	movl   $0x80021a,(%esp)
  800298:	e8 b7 01 00 00       	call   800454 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ad:	89 04 24             	mov    %eax,(%esp)
  8002b0:	e8 47 0a 00 00       	call   800cfc <sys_cputs>

	return b.cnt;
}
  8002b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cd:	89 04 24             	mov    %eax,(%esp)
  8002d0:	e8 87 ff ff ff       	call   80025c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    
  8002d7:	66 90                	xchg   %ax,%ax
  8002d9:	66 90                	xchg   %ax,%ax
  8002db:	66 90                	xchg   %ax,%ax
  8002dd:	66 90                	xchg   %ax,%ax
  8002df:	90                   	nop

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002f7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800302:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800305:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800308:	39 f1                	cmp    %esi,%ecx
  80030a:	72 14                	jb     800320 <printnum+0x40>
  80030c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80030f:	76 0f                	jbe    800320 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800311:	8b 45 14             	mov    0x14(%ebp),%eax
  800314:	8d 70 ff             	lea    -0x1(%eax),%esi
  800317:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80031a:	85 f6                	test   %esi,%esi
  80031c:	7f 60                	jg     80037e <printnum+0x9e>
  80031e:	eb 72                	jmp    800392 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800320:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800323:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800327:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80032a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80032d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800331:	89 44 24 08          	mov    %eax,0x8(%esp)
  800335:	8b 44 24 08          	mov    0x8(%esp),%eax
  800339:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80033d:	89 c3                	mov    %eax,%ebx
  80033f:	89 d6                	mov    %edx,%esi
  800341:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800344:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800347:	89 54 24 08          	mov    %edx,0x8(%esp)
  80034b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80034f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800352:	89 04 24             	mov    %eax,(%esp)
  800355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035c:	e8 df 1b 00 00       	call   801f40 <__udivdi3>
  800361:	89 d9                	mov    %ebx,%ecx
  800363:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800367:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80036b:	89 04 24             	mov    %eax,(%esp)
  80036e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800372:	89 fa                	mov    %edi,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	e8 64 ff ff ff       	call   8002e0 <printnum>
  80037c:	eb 14                	jmp    800392 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800382:	8b 45 18             	mov    0x18(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038a:	83 ee 01             	sub    $0x1,%esi
  80038d:	75 ef                	jne    80037e <printnum+0x9e>
  80038f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800392:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800396:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80039a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ab:	89 04 24             	mov    %eax,(%esp)
  8003ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b5:	e8 b6 1c 00 00       	call   802070 <__umoddi3>
  8003ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003be:	0f be 80 cb 22 80 00 	movsbl 0x8022cb(%eax),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003cb:	ff d0                	call   *%eax
}
  8003cd:	83 c4 3c             	add    $0x3c,%esp
  8003d0:	5b                   	pop    %ebx
  8003d1:	5e                   	pop    %esi
  8003d2:	5f                   	pop    %edi
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    

008003d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d8:	83 fa 01             	cmp    $0x1,%edx
  8003db:	7e 0e                	jle    8003eb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003dd:	8b 10                	mov    (%eax),%edx
  8003df:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003e2:	89 08                	mov    %ecx,(%eax)
  8003e4:	8b 02                	mov    (%edx),%eax
  8003e6:	8b 52 04             	mov    0x4(%edx),%edx
  8003e9:	eb 22                	jmp    80040d <getuint+0x38>
	else if (lflag)
  8003eb:	85 d2                	test   %edx,%edx
  8003ed:	74 10                	je     8003ff <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003ef:	8b 10                	mov    (%eax),%edx
  8003f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f4:	89 08                	mov    %ecx,(%eax)
  8003f6:	8b 02                	mov    (%edx),%eax
  8003f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fd:	eb 0e                	jmp    80040d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8d 4a 04             	lea    0x4(%edx),%ecx
  800404:	89 08                	mov    %ecx,(%eax)
  800406:	8b 02                	mov    (%edx),%eax
  800408:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800415:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	3b 50 04             	cmp    0x4(%eax),%edx
  80041e:	73 0a                	jae    80042a <sprintputch+0x1b>
		*b->buf++ = ch;
  800420:	8d 4a 01             	lea    0x1(%edx),%ecx
  800423:	89 08                	mov    %ecx,(%eax)
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	88 02                	mov    %al,(%edx)
}
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800432:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800435:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800439:	8b 45 10             	mov    0x10(%ebp),%eax
  80043c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800440:	8b 45 0c             	mov    0xc(%ebp),%eax
  800443:	89 44 24 04          	mov    %eax,0x4(%esp)
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	89 04 24             	mov    %eax,(%esp)
  80044d:	e8 02 00 00 00       	call   800454 <vprintfmt>
	va_end(ap);
}
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	57                   	push   %edi
  800458:	56                   	push   %esi
  800459:	53                   	push   %ebx
  80045a:	83 ec 3c             	sub    $0x3c,%esp
  80045d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800460:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800463:	eb 18                	jmp    80047d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800465:	85 c0                	test   %eax,%eax
  800467:	0f 84 c3 03 00 00    	je     800830 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80046d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800471:	89 04 24             	mov    %eax,(%esp)
  800474:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800477:	89 f3                	mov    %esi,%ebx
  800479:	eb 02                	jmp    80047d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80047b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047d:	8d 73 01             	lea    0x1(%ebx),%esi
  800480:	0f b6 03             	movzbl (%ebx),%eax
  800483:	83 f8 25             	cmp    $0x25,%eax
  800486:	75 dd                	jne    800465 <vprintfmt+0x11>
  800488:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80048c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800493:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80049a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a6:	eb 1d                	jmp    8004c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004aa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8004ae:	eb 15                	jmp    8004c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8004b6:	eb 0d                	jmp    8004c5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004be:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004c8:	0f b6 06             	movzbl (%esi),%eax
  8004cb:	0f b6 c8             	movzbl %al,%ecx
  8004ce:	83 e8 23             	sub    $0x23,%eax
  8004d1:	3c 55                	cmp    $0x55,%al
  8004d3:	0f 87 2f 03 00 00    	ja     800808 <vprintfmt+0x3b4>
  8004d9:	0f b6 c0             	movzbl %al,%eax
  8004dc:	ff 24 85 00 24 80 00 	jmp    *0x802400(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8004e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8004e9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004ed:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8004f0:	83 f9 09             	cmp    $0x9,%ecx
  8004f3:	77 50                	ja     800545 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	89 de                	mov    %ebx,%esi
  8004f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004fd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800500:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800504:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800507:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80050a:	83 fb 09             	cmp    $0x9,%ebx
  80050d:	76 eb                	jbe    8004fa <vprintfmt+0xa6>
  80050f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800512:	eb 33                	jmp    800547 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 48 04             	lea    0x4(%eax),%ecx
  80051a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800524:	eb 21                	jmp    800547 <vprintfmt+0xf3>
  800526:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800529:	85 c9                	test   %ecx,%ecx
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	0f 49 c1             	cmovns %ecx,%eax
  800533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	89 de                	mov    %ebx,%esi
  800538:	eb 8b                	jmp    8004c5 <vprintfmt+0x71>
  80053a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80053c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800543:	eb 80                	jmp    8004c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800545:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800547:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054b:	0f 89 74 ff ff ff    	jns    8004c5 <vprintfmt+0x71>
  800551:	e9 62 ff ff ff       	jmp    8004b8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800556:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800559:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80055b:	e9 65 ff ff ff       	jmp    8004c5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 50 04             	lea    0x4(%eax),%edx
  800566:	89 55 14             	mov    %edx,0x14(%ebp)
  800569:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	ff 55 08             	call   *0x8(%ebp)
			break;
  800575:	e9 03 ff ff ff       	jmp    80047d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8d 50 04             	lea    0x4(%eax),%edx
  800580:	89 55 14             	mov    %edx,0x14(%ebp)
  800583:	8b 00                	mov    (%eax),%eax
  800585:	99                   	cltd   
  800586:	31 d0                	xor    %edx,%eax
  800588:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80058a:	83 f8 0f             	cmp    $0xf,%eax
  80058d:	7f 0b                	jg     80059a <vprintfmt+0x146>
  80058f:	8b 14 85 60 25 80 00 	mov    0x802560(,%eax,4),%edx
  800596:	85 d2                	test   %edx,%edx
  800598:	75 20                	jne    8005ba <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80059a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80059e:	c7 44 24 08 e3 22 80 	movl   $0x8022e3,0x8(%esp)
  8005a5:	00 
  8005a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	89 04 24             	mov    %eax,(%esp)
  8005b0:	e8 77 fe ff ff       	call   80042c <printfmt>
  8005b5:	e9 c3 fe ff ff       	jmp    80047d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005be:	c7 44 24 08 82 26 80 	movl   $0x802682,0x8(%esp)
  8005c5:	00 
  8005c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	89 04 24             	mov    %eax,(%esp)
  8005d0:	e8 57 fe ff ff       	call   80042c <printfmt>
  8005d5:	e9 a3 fe ff ff       	jmp    80047d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005dd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8d 50 04             	lea    0x4(%eax),%edx
  8005e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	ba dc 22 80 00       	mov    $0x8022dc,%edx
  8005f2:	0f 45 d0             	cmovne %eax,%edx
  8005f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8005f8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8005fc:	74 04                	je     800602 <vprintfmt+0x1ae>
  8005fe:	85 f6                	test   %esi,%esi
  800600:	7f 19                	jg     80061b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8d 70 01             	lea    0x1(%eax),%esi
  800608:	0f b6 10             	movzbl (%eax),%edx
  80060b:	0f be c2             	movsbl %dl,%eax
  80060e:	85 c0                	test   %eax,%eax
  800610:	0f 85 95 00 00 00    	jne    8006ab <vprintfmt+0x257>
  800616:	e9 85 00 00 00       	jmp    8006a0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80061f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800622:	89 04 24             	mov    %eax,(%esp)
  800625:	e8 b8 02 00 00       	call   8008e2 <strnlen>
  80062a:	29 c6                	sub    %eax,%esi
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800631:	85 f6                	test   %esi,%esi
  800633:	7e cd                	jle    800602 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800635:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800639:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80063c:	89 c3                	mov    %eax,%ebx
  80063e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800642:	89 34 24             	mov    %esi,(%esp)
  800645:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	83 eb 01             	sub    $0x1,%ebx
  80064b:	75 f1                	jne    80063e <vprintfmt+0x1ea>
  80064d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800653:	eb ad                	jmp    800602 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800655:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800659:	74 1e                	je     800679 <vprintfmt+0x225>
  80065b:	0f be d2             	movsbl %dl,%edx
  80065e:	83 ea 20             	sub    $0x20,%edx
  800661:	83 fa 5e             	cmp    $0x5e,%edx
  800664:	76 13                	jbe    800679 <vprintfmt+0x225>
					putch('?', putdat);
  800666:	8b 45 0c             	mov    0xc(%ebp),%eax
  800669:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800674:	ff 55 08             	call   *0x8(%ebp)
  800677:	eb 0d                	jmp    800686 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800680:	89 04 24             	mov    %eax,(%esp)
  800683:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800686:	83 ef 01             	sub    $0x1,%edi
  800689:	83 c6 01             	add    $0x1,%esi
  80068c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800690:	0f be c2             	movsbl %dl,%eax
  800693:	85 c0                	test   %eax,%eax
  800695:	75 20                	jne    8006b7 <vprintfmt+0x263>
  800697:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80069a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80069d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a4:	7f 25                	jg     8006cb <vprintfmt+0x277>
  8006a6:	e9 d2 fd ff ff       	jmp    80047d <vprintfmt+0x29>
  8006ab:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b7:	85 db                	test   %ebx,%ebx
  8006b9:	78 9a                	js     800655 <vprintfmt+0x201>
  8006bb:	83 eb 01             	sub    $0x1,%ebx
  8006be:	79 95                	jns    800655 <vprintfmt+0x201>
  8006c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006c9:	eb d5                	jmp    8006a0 <vprintfmt+0x24c>
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006df:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e1:	83 eb 01             	sub    $0x1,%ebx
  8006e4:	75 ee                	jne    8006d4 <vprintfmt+0x280>
  8006e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006e9:	e9 8f fd ff ff       	jmp    80047d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ee:	83 fa 01             	cmp    $0x1,%edx
  8006f1:	7e 16                	jle    800709 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8d 50 08             	lea    0x8(%eax),%edx
  8006f9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fc:	8b 50 04             	mov    0x4(%eax),%edx
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800704:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800707:	eb 32                	jmp    80073b <vprintfmt+0x2e7>
	else if (lflag)
  800709:	85 d2                	test   %edx,%edx
  80070b:	74 18                	je     800725 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 50 04             	lea    0x4(%eax),%edx
  800713:	89 55 14             	mov    %edx,0x14(%ebp)
  800716:	8b 30                	mov    (%eax),%esi
  800718:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80071b:	89 f0                	mov    %esi,%eax
  80071d:	c1 f8 1f             	sar    $0x1f,%eax
  800720:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800723:	eb 16                	jmp    80073b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 50 04             	lea    0x4(%eax),%edx
  80072b:	89 55 14             	mov    %edx,0x14(%ebp)
  80072e:	8b 30                	mov    (%eax),%esi
  800730:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800733:	89 f0                	mov    %esi,%eax
  800735:	c1 f8 1f             	sar    $0x1f,%eax
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80073e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800741:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800746:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074a:	0f 89 80 00 00 00    	jns    8007d0 <vprintfmt+0x37c>
				putch('-', putdat);
  800750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800754:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80075e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800761:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800764:	f7 d8                	neg    %eax
  800766:	83 d2 00             	adc    $0x0,%edx
  800769:	f7 da                	neg    %edx
			}
			base = 10;
  80076b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800770:	eb 5e                	jmp    8007d0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
  800775:	e8 5b fc ff ff       	call   8003d5 <getuint>
			base = 10;
  80077a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80077f:	eb 4f                	jmp    8007d0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
  800784:	e8 4c fc ff ff       	call   8003d5 <getuint>
			base = 8;
  800789:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80078e:	eb 40                	jmp    8007d0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800794:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80079b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80079e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007a9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8d 50 04             	lea    0x4(%eax),%edx
  8007b2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007bc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007c1:	eb 0d                	jmp    8007d0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	e8 0a fc ff ff       	call   8003d5 <getuint>
			base = 16;
  8007cb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007d4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007db:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007e3:	89 04 24             	mov    %eax,(%esp)
  8007e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007ea:	89 fa                	mov    %edi,%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	e8 ec fa ff ff       	call   8002e0 <printnum>
			break;
  8007f4:	e9 84 fc ff ff       	jmp    80047d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fd:	89 0c 24             	mov    %ecx,(%esp)
  800800:	ff 55 08             	call   *0x8(%ebp)
			break;
  800803:	e9 75 fc ff ff       	jmp    80047d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800808:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800813:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800816:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80081a:	0f 84 5b fc ff ff    	je     80047b <vprintfmt+0x27>
  800820:	89 f3                	mov    %esi,%ebx
  800822:	83 eb 01             	sub    $0x1,%ebx
  800825:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800829:	75 f7                	jne    800822 <vprintfmt+0x3ce>
  80082b:	e9 4d fc ff ff       	jmp    80047d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800830:	83 c4 3c             	add    $0x3c,%esp
  800833:	5b                   	pop    %ebx
  800834:	5e                   	pop    %esi
  800835:	5f                   	pop    %edi
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 28             	sub    $0x28,%esp
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800847:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80084b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800855:	85 c0                	test   %eax,%eax
  800857:	74 30                	je     800889 <vsnprintf+0x51>
  800859:	85 d2                	test   %edx,%edx
  80085b:	7e 2c                	jle    800889 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800864:	8b 45 10             	mov    0x10(%ebp),%eax
  800867:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800872:	c7 04 24 0f 04 80 00 	movl   $0x80040f,(%esp)
  800879:	e8 d6 fb ff ff       	call   800454 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800881:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800887:	eb 05                	jmp    80088e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800896:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800899:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	89 04 24             	mov    %eax,(%esp)
  8008b1:	e8 82 ff ff ff       	call   800838 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    
  8008b8:	66 90                	xchg   %ax,%ax
  8008ba:	66 90                	xchg   %ax,%ax
  8008bc:	66 90                	xchg   %ax,%ax
  8008be:	66 90                	xchg   %ax,%ax

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008c9:	74 10                	je     8008db <strlen+0x1b>
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008d0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d7:	75 f7                	jne    8008d0 <strlen+0x10>
  8008d9:	eb 05                	jmp    8008e0 <strlen+0x20>
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	53                   	push   %ebx
  8008e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ec:	85 c9                	test   %ecx,%ecx
  8008ee:	74 1c                	je     80090c <strnlen+0x2a>
  8008f0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008f3:	74 1e                	je     800913 <strnlen+0x31>
  8008f5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008fa:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fc:	39 ca                	cmp    %ecx,%edx
  8008fe:	74 18                	je     800918 <strnlen+0x36>
  800900:	83 c2 01             	add    $0x1,%edx
  800903:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800908:	75 f0                	jne    8008fa <strnlen+0x18>
  80090a:	eb 0c                	jmp    800918 <strnlen+0x36>
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	eb 05                	jmp    800918 <strnlen+0x36>
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	53                   	push   %ebx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800925:	89 c2                	mov    %eax,%edx
  800927:	83 c2 01             	add    $0x1,%edx
  80092a:	83 c1 01             	add    $0x1,%ecx
  80092d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800931:	88 5a ff             	mov    %bl,-0x1(%edx)
  800934:	84 db                	test   %bl,%bl
  800936:	75 ef                	jne    800927 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800938:	5b                   	pop    %ebx
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800945:	89 1c 24             	mov    %ebx,(%esp)
  800948:	e8 73 ff ff ff       	call   8008c0 <strlen>
	strcpy(dst + len, src);
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800950:	89 54 24 04          	mov    %edx,0x4(%esp)
  800954:	01 d8                	add    %ebx,%eax
  800956:	89 04 24             	mov    %eax,(%esp)
  800959:	e8 bd ff ff ff       	call   80091b <strcpy>
	return dst;
}
  80095e:	89 d8                	mov    %ebx,%eax
  800960:	83 c4 08             	add    $0x8,%esp
  800963:	5b                   	pop    %ebx
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800974:	85 db                	test   %ebx,%ebx
  800976:	74 17                	je     80098f <strncpy+0x29>
  800978:	01 f3                	add    %esi,%ebx
  80097a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80097c:	83 c1 01             	add    $0x1,%ecx
  80097f:	0f b6 02             	movzbl (%edx),%eax
  800982:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800985:	80 3a 01             	cmpb   $0x1,(%edx)
  800988:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098b:	39 d9                	cmp    %ebx,%ecx
  80098d:	75 ed                	jne    80097c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80098f:	89 f0                	mov    %esi,%eax
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	57                   	push   %edi
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009a1:	8b 75 10             	mov    0x10(%ebp),%esi
  8009a4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a6:	85 f6                	test   %esi,%esi
  8009a8:	74 34                	je     8009de <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8009aa:	83 fe 01             	cmp    $0x1,%esi
  8009ad:	74 26                	je     8009d5 <strlcpy+0x40>
  8009af:	0f b6 0b             	movzbl (%ebx),%ecx
  8009b2:	84 c9                	test   %cl,%cl
  8009b4:	74 23                	je     8009d9 <strlcpy+0x44>
  8009b6:	83 ee 02             	sub    $0x2,%esi
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8009be:	83 c0 01             	add    $0x1,%eax
  8009c1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c4:	39 f2                	cmp    %esi,%edx
  8009c6:	74 13                	je     8009db <strlcpy+0x46>
  8009c8:	83 c2 01             	add    $0x1,%edx
  8009cb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009cf:	84 c9                	test   %cl,%cl
  8009d1:	75 eb                	jne    8009be <strlcpy+0x29>
  8009d3:	eb 06                	jmp    8009db <strlcpy+0x46>
  8009d5:	89 f8                	mov    %edi,%eax
  8009d7:	eb 02                	jmp    8009db <strlcpy+0x46>
  8009d9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009de:	29 f8                	sub    %edi,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5f                   	pop    %edi
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ee:	0f b6 01             	movzbl (%ecx),%eax
  8009f1:	84 c0                	test   %al,%al
  8009f3:	74 15                	je     800a0a <strcmp+0x25>
  8009f5:	3a 02                	cmp    (%edx),%al
  8009f7:	75 11                	jne    800a0a <strcmp+0x25>
		p++, q++;
  8009f9:	83 c1 01             	add    $0x1,%ecx
  8009fc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ff:	0f b6 01             	movzbl (%ecx),%eax
  800a02:	84 c0                	test   %al,%al
  800a04:	74 04                	je     800a0a <strcmp+0x25>
  800a06:	3a 02                	cmp    (%edx),%al
  800a08:	74 ef                	je     8009f9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0a:	0f b6 c0             	movzbl %al,%eax
  800a0d:	0f b6 12             	movzbl (%edx),%edx
  800a10:	29 d0                	sub    %edx,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800a22:	85 f6                	test   %esi,%esi
  800a24:	74 29                	je     800a4f <strncmp+0x3b>
  800a26:	0f b6 03             	movzbl (%ebx),%eax
  800a29:	84 c0                	test   %al,%al
  800a2b:	74 30                	je     800a5d <strncmp+0x49>
  800a2d:	3a 02                	cmp    (%edx),%al
  800a2f:	75 2c                	jne    800a5d <strncmp+0x49>
  800a31:	8d 43 01             	lea    0x1(%ebx),%eax
  800a34:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800a36:	89 c3                	mov    %eax,%ebx
  800a38:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a3b:	39 f0                	cmp    %esi,%eax
  800a3d:	74 17                	je     800a56 <strncmp+0x42>
  800a3f:	0f b6 08             	movzbl (%eax),%ecx
  800a42:	84 c9                	test   %cl,%cl
  800a44:	74 17                	je     800a5d <strncmp+0x49>
  800a46:	83 c0 01             	add    $0x1,%eax
  800a49:	3a 0a                	cmp    (%edx),%cl
  800a4b:	74 e9                	je     800a36 <strncmp+0x22>
  800a4d:	eb 0e                	jmp    800a5d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	eb 0f                	jmp    800a65 <strncmp+0x51>
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	eb 08                	jmp    800a65 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5d:	0f b6 03             	movzbl (%ebx),%eax
  800a60:	0f b6 12             	movzbl (%edx),%edx
  800a63:	29 d0                	sub    %edx,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	53                   	push   %ebx
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a73:	0f b6 18             	movzbl (%eax),%ebx
  800a76:	84 db                	test   %bl,%bl
  800a78:	74 1d                	je     800a97 <strchr+0x2e>
  800a7a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a7c:	38 d3                	cmp    %dl,%bl
  800a7e:	75 06                	jne    800a86 <strchr+0x1d>
  800a80:	eb 1a                	jmp    800a9c <strchr+0x33>
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 16                	je     800a9c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a86:	83 c0 01             	add    $0x1,%eax
  800a89:	0f b6 10             	movzbl (%eax),%edx
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	75 f2                	jne    800a82 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	eb 05                	jmp    800a9c <strchr+0x33>
  800a97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9c:	5b                   	pop    %ebx
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800aa9:	0f b6 18             	movzbl (%eax),%ebx
  800aac:	84 db                	test   %bl,%bl
  800aae:	74 16                	je     800ac6 <strfind+0x27>
  800ab0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ab2:	38 d3                	cmp    %dl,%bl
  800ab4:	75 06                	jne    800abc <strfind+0x1d>
  800ab6:	eb 0e                	jmp    800ac6 <strfind+0x27>
  800ab8:	38 ca                	cmp    %cl,%dl
  800aba:	74 0a                	je     800ac6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	0f b6 10             	movzbl (%eax),%edx
  800ac2:	84 d2                	test   %dl,%dl
  800ac4:	75 f2                	jne    800ab8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad5:	85 c9                	test   %ecx,%ecx
  800ad7:	74 36                	je     800b0f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800adf:	75 28                	jne    800b09 <memset+0x40>
  800ae1:	f6 c1 03             	test   $0x3,%cl
  800ae4:	75 23                	jne    800b09 <memset+0x40>
		c &= 0xFF;
  800ae6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aea:	89 d3                	mov    %edx,%ebx
  800aec:	c1 e3 08             	shl    $0x8,%ebx
  800aef:	89 d6                	mov    %edx,%esi
  800af1:	c1 e6 18             	shl    $0x18,%esi
  800af4:	89 d0                	mov    %edx,%eax
  800af6:	c1 e0 10             	shl    $0x10,%eax
  800af9:	09 f0                	or     %esi,%eax
  800afb:	09 c2                	or     %eax,%edx
  800afd:	89 d0                	mov    %edx,%eax
  800aff:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b01:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b04:	fc                   	cld    
  800b05:	f3 ab                	rep stos %eax,%es:(%edi)
  800b07:	eb 06                	jmp    800b0f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	fc                   	cld    
  800b0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0f:	89 f8                	mov    %edi,%eax
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b24:	39 c6                	cmp    %eax,%esi
  800b26:	73 35                	jae    800b5d <memmove+0x47>
  800b28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2b:	39 d0                	cmp    %edx,%eax
  800b2d:	73 2e                	jae    800b5d <memmove+0x47>
		s += n;
		d += n;
  800b2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3c:	75 13                	jne    800b51 <memmove+0x3b>
  800b3e:	f6 c1 03             	test   $0x3,%cl
  800b41:	75 0e                	jne    800b51 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b43:	83 ef 04             	sub    $0x4,%edi
  800b46:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b49:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b4c:	fd                   	std    
  800b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4f:	eb 09                	jmp    800b5a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b51:	83 ef 01             	sub    $0x1,%edi
  800b54:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b57:	fd                   	std    
  800b58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5a:	fc                   	cld    
  800b5b:	eb 1d                	jmp    800b7a <memmove+0x64>
  800b5d:	89 f2                	mov    %esi,%edx
  800b5f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b61:	f6 c2 03             	test   $0x3,%dl
  800b64:	75 0f                	jne    800b75 <memmove+0x5f>
  800b66:	f6 c1 03             	test   $0x3,%cl
  800b69:	75 0a                	jne    800b75 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b6b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b6e:	89 c7                	mov    %eax,%edi
  800b70:	fc                   	cld    
  800b71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b73:	eb 05                	jmp    800b7a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b75:	89 c7                	mov    %eax,%edi
  800b77:	fc                   	cld    
  800b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	89 04 24             	mov    %eax,(%esp)
  800b98:	e8 79 ff ff ff       	call   800b16 <memmove>
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bae:	8d 78 ff             	lea    -0x1(%eax),%edi
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	74 36                	je     800beb <memcmp+0x4c>
		if (*s1 != *s2)
  800bb5:	0f b6 03             	movzbl (%ebx),%eax
  800bb8:	0f b6 0e             	movzbl (%esi),%ecx
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	38 c8                	cmp    %cl,%al
  800bc2:	74 1c                	je     800be0 <memcmp+0x41>
  800bc4:	eb 10                	jmp    800bd6 <memcmp+0x37>
  800bc6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bcb:	83 c2 01             	add    $0x1,%edx
  800bce:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800bd2:	38 c8                	cmp    %cl,%al
  800bd4:	74 0a                	je     800be0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800bd6:	0f b6 c0             	movzbl %al,%eax
  800bd9:	0f b6 c9             	movzbl %cl,%ecx
  800bdc:	29 c8                	sub    %ecx,%eax
  800bde:	eb 10                	jmp    800bf0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be0:	39 fa                	cmp    %edi,%edx
  800be2:	75 e2                	jne    800bc6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	eb 05                	jmp    800bf0 <memcmp+0x51>
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	53                   	push   %ebx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c04:	39 d0                	cmp    %edx,%eax
  800c06:	73 13                	jae    800c1b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c08:	89 d9                	mov    %ebx,%ecx
  800c0a:	38 18                	cmp    %bl,(%eax)
  800c0c:	75 06                	jne    800c14 <memfind+0x1f>
  800c0e:	eb 0b                	jmp    800c1b <memfind+0x26>
  800c10:	38 08                	cmp    %cl,(%eax)
  800c12:	74 07                	je     800c1b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c14:	83 c0 01             	add    $0x1,%eax
  800c17:	39 d0                	cmp    %edx,%eax
  800c19:	75 f5                	jne    800c10 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c1b:	5b                   	pop    %ebx
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2a:	0f b6 0a             	movzbl (%edx),%ecx
  800c2d:	80 f9 09             	cmp    $0x9,%cl
  800c30:	74 05                	je     800c37 <strtol+0x19>
  800c32:	80 f9 20             	cmp    $0x20,%cl
  800c35:	75 10                	jne    800c47 <strtol+0x29>
		s++;
  800c37:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3a:	0f b6 0a             	movzbl (%edx),%ecx
  800c3d:	80 f9 09             	cmp    $0x9,%cl
  800c40:	74 f5                	je     800c37 <strtol+0x19>
  800c42:	80 f9 20             	cmp    $0x20,%cl
  800c45:	74 f0                	je     800c37 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c47:	80 f9 2b             	cmp    $0x2b,%cl
  800c4a:	75 0a                	jne    800c56 <strtol+0x38>
		s++;
  800c4c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c54:	eb 11                	jmp    800c67 <strtol+0x49>
  800c56:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c5b:	80 f9 2d             	cmp    $0x2d,%cl
  800c5e:	75 07                	jne    800c67 <strtol+0x49>
		s++, neg = 1;
  800c60:	83 c2 01             	add    $0x1,%edx
  800c63:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c67:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c6c:	75 15                	jne    800c83 <strtol+0x65>
  800c6e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c71:	75 10                	jne    800c83 <strtol+0x65>
  800c73:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c77:	75 0a                	jne    800c83 <strtol+0x65>
		s += 2, base = 16;
  800c79:	83 c2 02             	add    $0x2,%edx
  800c7c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c81:	eb 10                	jmp    800c93 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c83:	85 c0                	test   %eax,%eax
  800c85:	75 0c                	jne    800c93 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c87:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c89:	80 3a 30             	cmpb   $0x30,(%edx)
  800c8c:	75 05                	jne    800c93 <strtol+0x75>
		s++, base = 8;
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c9b:	0f b6 0a             	movzbl (%edx),%ecx
  800c9e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ca1:	89 f0                	mov    %esi,%eax
  800ca3:	3c 09                	cmp    $0x9,%al
  800ca5:	77 08                	ja     800caf <strtol+0x91>
			dig = *s - '0';
  800ca7:	0f be c9             	movsbl %cl,%ecx
  800caa:	83 e9 30             	sub    $0x30,%ecx
  800cad:	eb 20                	jmp    800ccf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800caf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cb2:	89 f0                	mov    %esi,%eax
  800cb4:	3c 19                	cmp    $0x19,%al
  800cb6:	77 08                	ja     800cc0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800cb8:	0f be c9             	movsbl %cl,%ecx
  800cbb:	83 e9 57             	sub    $0x57,%ecx
  800cbe:	eb 0f                	jmp    800ccf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800cc0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cc3:	89 f0                	mov    %esi,%eax
  800cc5:	3c 19                	cmp    $0x19,%al
  800cc7:	77 16                	ja     800cdf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cc9:	0f be c9             	movsbl %cl,%ecx
  800ccc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ccf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cd2:	7d 0f                	jge    800ce3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cd4:	83 c2 01             	add    $0x1,%edx
  800cd7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cdb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cdd:	eb bc                	jmp    800c9b <strtol+0x7d>
  800cdf:	89 d8                	mov    %ebx,%eax
  800ce1:	eb 02                	jmp    800ce5 <strtol+0xc7>
  800ce3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	74 05                	je     800cf0 <strtol+0xd2>
		*endptr = (char *) s;
  800ceb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cee:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cf0:	f7 d8                	neg    %eax
  800cf2:	85 ff                	test   %edi,%edi
  800cf4:	0f 44 c3             	cmove  %ebx,%eax
}
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	89 c3                	mov    %eax,%ebx
  800d0f:	89 c7                	mov    %eax,%edi
  800d11:	89 c6                	mov    %eax,%esi
  800d13:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_cgetc>:

int
sys_cgetc(void)
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
  800d25:	b8 01 00 00 00       	mov    $0x1,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800d42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d47:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	89 cb                	mov    %ecx,%ebx
  800d51:	89 cf                	mov    %ecx,%edi
  800d53:	89 ce                	mov    %ecx,%esi
  800d55:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d57:	85 c0                	test   %eax,%eax
  800d59:	7e 28                	jle    800d83 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d66:	00 
  800d67:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800d6e:	00 
  800d6f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d76:	00 
  800d77:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800d7e:	e8 41 f4 ff ff       	call   8001c4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d83:	83 c4 2c             	add    $0x2c,%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	b8 02 00 00 00       	mov    $0x2,%eax
  800d9b:	89 d1                	mov    %edx,%ecx
  800d9d:	89 d3                	mov    %edx,%ebx
  800d9f:	89 d7                	mov    %edx,%edi
  800da1:	89 d6                	mov    %edx,%esi
  800da3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_yield>:

void
sys_yield(void)
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
  800db5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dba:	89 d1                	mov    %edx,%ecx
  800dbc:	89 d3                	mov    %edx,%ebx
  800dbe:	89 d7                	mov    %edx,%edi
  800dc0:	89 d6                	mov    %edx,%esi
  800dc2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800dd2:	be 00 00 00 00       	mov    $0x0,%esi
  800dd7:	b8 04 00 00 00       	mov    $0x4,%eax
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de5:	89 f7                	mov    %esi,%edi
  800de7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7e 28                	jle    800e15 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df8:	00 
  800df9:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800e00:	00 
  800e01:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e08:	00 
  800e09:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800e10:	e8 af f3 ff ff       	call   8001c4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e15:	83 c4 2c             	add    $0x2c,%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
  800e23:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e26:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e34:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e37:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7e 28                	jle    800e68 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e44:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e4b:	00 
  800e4c:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800e53:	00 
  800e54:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e5b:	00 
  800e5c:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800e63:	e8 5c f3 ff ff       	call   8001c4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e68:	83 c4 2c             	add    $0x2c,%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	89 df                	mov    %ebx,%edi
  800e8b:	89 de                	mov    %ebx,%esi
  800e8d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7e 28                	jle    800ebb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e97:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e9e:	00 
  800e9f:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800ea6:	00 
  800ea7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eae:	00 
  800eaf:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800eb6:	e8 09 f3 ff ff       	call   8001c4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ebb:	83 c4 2c             	add    $0x2c,%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	89 df                	mov    %ebx,%edi
  800ede:	89 de                	mov    %ebx,%esi
  800ee0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7e 28                	jle    800f0e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eea:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ef1:	00 
  800ef2:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800ef9:	00 
  800efa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f01:	00 
  800f02:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800f09:	e8 b6 f2 ff ff       	call   8001c4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0e:	83 c4 2c             	add    $0x2c,%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
  800f1c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	b8 09 00 00 00       	mov    $0x9,%eax
  800f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 df                	mov    %ebx,%edi
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7e 28                	jle    800f61 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f39:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f44:	00 
  800f45:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800f4c:	00 
  800f4d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f54:	00 
  800f55:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800f5c:	e8 63 f2 ff ff       	call   8001c4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f61:	83 c4 2c             	add    $0x2c,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	89 de                	mov    %ebx,%esi
  800f86:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	7e 28                	jle    800fb4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f90:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f97:	00 
  800f98:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  800f9f:	00 
  800fa0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fa7:	00 
  800fa8:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  800faf:	e8 10 f2 ff ff       	call   8001c4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb4:	83 c4 2c             	add    $0x2c,%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	be 00 00 00 00       	mov    $0x0,%esi
  800fc7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fed:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	89 cb                	mov    %ecx,%ebx
  800ff7:	89 cf                	mov    %ecx,%edi
  800ff9:	89 ce                	mov    %ecx,%esi
  800ffb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	7e 28                	jle    801029 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	89 44 24 10          	mov    %eax,0x10(%esp)
  801005:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80100c:	00 
  80100d:	c7 44 24 08 bf 25 80 	movl   $0x8025bf,0x8(%esp)
  801014:	00 
  801015:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80101c:	00 
  80101d:	c7 04 24 dc 25 80 00 	movl   $0x8025dc,(%esp)
  801024:	e8 9b f1 ff ff       	call   8001c4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801029:	83 c4 2c             	add    $0x2c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	66 90                	xchg   %ax,%ax
  801033:	66 90                	xchg   %ax,%ax
  801035:	66 90                	xchg   %ax,%ax
  801037:	66 90                	xchg   %ax,%ax
  801039:	66 90                	xchg   %ax,%ax
  80103b:	66 90                	xchg   %ax,%ax
  80103d:	66 90                	xchg   %ax,%ax
  80103f:	90                   	nop

00801040 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80105b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801060:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80106a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80106f:	a8 01                	test   $0x1,%al
  801071:	74 34                	je     8010a7 <fd_alloc+0x40>
  801073:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801078:	a8 01                	test   $0x1,%al
  80107a:	74 32                	je     8010ae <fd_alloc+0x47>
  80107c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801081:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 16             	shr    $0x16,%edx
  801088:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	74 1f                	je     8010b3 <fd_alloc+0x4c>
  801094:	89 c2                	mov    %eax,%edx
  801096:	c1 ea 0c             	shr    $0xc,%edx
  801099:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a0:	f6 c2 01             	test   $0x1,%dl
  8010a3:	75 1a                	jne    8010bf <fd_alloc+0x58>
  8010a5:	eb 0c                	jmp    8010b3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010a7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8010ac:	eb 05                	jmp    8010b3 <fd_alloc+0x4c>
  8010ae:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8010b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bd:	eb 1a                	jmp    8010d9 <fd_alloc+0x72>
  8010bf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010c4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c9:	75 b6                	jne    801081 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e1:	83 f8 1f             	cmp    $0x1f,%eax
  8010e4:	77 36                	ja     80111c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e6:	c1 e0 0c             	shl    $0xc,%eax
  8010e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	c1 ea 16             	shr    $0x16,%edx
  8010f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010fa:	f6 c2 01             	test   $0x1,%dl
  8010fd:	74 24                	je     801123 <fd_lookup+0x48>
  8010ff:	89 c2                	mov    %eax,%edx
  801101:	c1 ea 0c             	shr    $0xc,%edx
  801104:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110b:	f6 c2 01             	test   $0x1,%dl
  80110e:	74 1a                	je     80112a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801110:	8b 55 0c             	mov    0xc(%ebp),%edx
  801113:	89 02                	mov    %eax,(%edx)
	return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	eb 13                	jmp    80112f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80111c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801121:	eb 0c                	jmp    80112f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801128:	eb 05                	jmp    80112f <fd_lookup+0x54>
  80112a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	53                   	push   %ebx
  801135:	83 ec 14             	sub    $0x14,%esp
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80113e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801144:	75 1e                	jne    801164 <dev_lookup+0x33>
  801146:	eb 0e                	jmp    801156 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801148:	b8 20 30 80 00       	mov    $0x803020,%eax
  80114d:	eb 0c                	jmp    80115b <dev_lookup+0x2a>
  80114f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801154:	eb 05                	jmp    80115b <dev_lookup+0x2a>
  801156:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80115b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
  801162:	eb 38                	jmp    80119c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801164:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80116a:	74 dc                	je     801148 <dev_lookup+0x17>
  80116c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801172:	74 db                	je     80114f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801174:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  80117a:	8b 52 48             	mov    0x48(%edx),%edx
  80117d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801181:	89 54 24 04          	mov    %edx,0x4(%esp)
  801185:	c7 04 24 ec 25 80 00 	movl   $0x8025ec,(%esp)
  80118c:	e8 2c f1 ff ff       	call   8002bd <cprintf>
	*dev = 0;
  801191:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801197:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80119c:	83 c4 14             	add    $0x14,%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	56                   	push   %esi
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 20             	sub    $0x20,%esp
  8011aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011bd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c0:	89 04 24             	mov    %eax,(%esp)
  8011c3:	e8 13 ff ff ff       	call   8010db <fd_lookup>
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 05                	js     8011d1 <fd_close+0x2f>
	    || fd != fd2)
  8011cc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011cf:	74 0c                	je     8011dd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011d1:	84 db                	test   %bl,%bl
  8011d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d8:	0f 44 c2             	cmove  %edx,%eax
  8011db:	eb 3f                	jmp    80121c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e4:	8b 06                	mov    (%esi),%eax
  8011e6:	89 04 24             	mov    %eax,(%esp)
  8011e9:	e8 43 ff ff ff       	call   801131 <dev_lookup>
  8011ee:	89 c3                	mov    %eax,%ebx
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 16                	js     80120a <fd_close+0x68>
		if (dev->dev_close)
  8011f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011fa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011ff:	85 c0                	test   %eax,%eax
  801201:	74 07                	je     80120a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801203:	89 34 24             	mov    %esi,(%esp)
  801206:	ff d0                	call   *%eax
  801208:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80120a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80120e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801215:	e8 56 fc ff ff       	call   800e70 <sys_page_unmap>
	return r;
  80121a:	89 d8                	mov    %ebx,%eax
}
  80121c:	83 c4 20             	add    $0x20,%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801229:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	89 04 24             	mov    %eax,(%esp)
  801236:	e8 a0 fe ff ff       	call   8010db <fd_lookup>
  80123b:	89 c2                	mov    %eax,%edx
  80123d:	85 d2                	test   %edx,%edx
  80123f:	78 13                	js     801254 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801241:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801248:	00 
  801249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124c:	89 04 24             	mov    %eax,(%esp)
  80124f:	e8 4e ff ff ff       	call   8011a2 <fd_close>
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <close_all>:

void
close_all(void)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	53                   	push   %ebx
  80125a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80125d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801262:	89 1c 24             	mov    %ebx,(%esp)
  801265:	e8 b9 ff ff ff       	call   801223 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80126a:	83 c3 01             	add    $0x1,%ebx
  80126d:	83 fb 20             	cmp    $0x20,%ebx
  801270:	75 f0                	jne    801262 <close_all+0xc>
		close(i);
}
  801272:	83 c4 14             	add    $0x14,%esp
  801275:	5b                   	pop    %ebx
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    

00801278 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	57                   	push   %edi
  80127c:	56                   	push   %esi
  80127d:	53                   	push   %ebx
  80127e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801281:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	89 04 24             	mov    %eax,(%esp)
  80128e:	e8 48 fe ff ff       	call   8010db <fd_lookup>
  801293:	89 c2                	mov    %eax,%edx
  801295:	85 d2                	test   %edx,%edx
  801297:	0f 88 e1 00 00 00    	js     80137e <dup+0x106>
		return r;
	close(newfdnum);
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	89 04 24             	mov    %eax,(%esp)
  8012a3:	e8 7b ff ff ff       	call   801223 <close>

	newfd = INDEX2FD(newfdnum);
  8012a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012ab:	c1 e3 0c             	shl    $0xc,%ebx
  8012ae:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b7:	89 04 24             	mov    %eax,(%esp)
  8012ba:	e8 91 fd ff ff       	call   801050 <fd2data>
  8012bf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012c1:	89 1c 24             	mov    %ebx,(%esp)
  8012c4:	e8 87 fd ff ff       	call   801050 <fd2data>
  8012c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012cb:	89 f0                	mov    %esi,%eax
  8012cd:	c1 e8 16             	shr    $0x16,%eax
  8012d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012d7:	a8 01                	test   $0x1,%al
  8012d9:	74 43                	je     80131e <dup+0xa6>
  8012db:	89 f0                	mov    %esi,%eax
  8012dd:	c1 e8 0c             	shr    $0xc,%eax
  8012e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012e7:	f6 c2 01             	test   $0x1,%dl
  8012ea:	74 32                	je     80131e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012fc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801300:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801307:	00 
  801308:	89 74 24 04          	mov    %esi,0x4(%esp)
  80130c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801313:	e8 05 fb ff ff       	call   800e1d <sys_page_map>
  801318:	89 c6                	mov    %eax,%esi
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 3e                	js     80135c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801321:	89 c2                	mov    %eax,%edx
  801323:	c1 ea 0c             	shr    $0xc,%edx
  801326:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801333:	89 54 24 10          	mov    %edx,0x10(%esp)
  801337:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80133b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801342:	00 
  801343:	89 44 24 04          	mov    %eax,0x4(%esp)
  801347:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134e:	e8 ca fa ff ff       	call   800e1d <sys_page_map>
  801353:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801358:	85 f6                	test   %esi,%esi
  80135a:	79 22                	jns    80137e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80135c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801367:	e8 04 fb ff ff       	call   800e70 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80136c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801370:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801377:	e8 f4 fa ff ff       	call   800e70 <sys_page_unmap>
	return r;
  80137c:	89 f0                	mov    %esi,%eax
}
  80137e:	83 c4 3c             	add    $0x3c,%esp
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	53                   	push   %ebx
  80138a:	83 ec 24             	sub    $0x24,%esp
  80138d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801390:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801393:	89 44 24 04          	mov    %eax,0x4(%esp)
  801397:	89 1c 24             	mov    %ebx,(%esp)
  80139a:	e8 3c fd ff ff       	call   8010db <fd_lookup>
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	85 d2                	test   %edx,%edx
  8013a3:	78 6d                	js     801412 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	8b 00                	mov    (%eax),%eax
  8013b1:	89 04 24             	mov    %eax,(%esp)
  8013b4:	e8 78 fd ff ff       	call   801131 <dev_lookup>
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 55                	js     801412 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	8b 50 08             	mov    0x8(%eax),%edx
  8013c3:	83 e2 03             	and    $0x3,%edx
  8013c6:	83 fa 01             	cmp    $0x1,%edx
  8013c9:	75 23                	jne    8013ee <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cb:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8013d0:	8b 40 48             	mov    0x48(%eax),%eax
  8013d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  8013e2:	e8 d6 ee ff ff       	call   8002bd <cprintf>
		return -E_INVAL;
  8013e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ec:	eb 24                	jmp    801412 <read+0x8c>
	}
	if (!dev->dev_read)
  8013ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f1:	8b 52 08             	mov    0x8(%edx),%edx
  8013f4:	85 d2                	test   %edx,%edx
  8013f6:	74 15                	je     80140d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801402:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801406:	89 04 24             	mov    %eax,(%esp)
  801409:	ff d2                	call   *%edx
  80140b:	eb 05                	jmp    801412 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80140d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801412:	83 c4 24             	add    $0x24,%esp
  801415:	5b                   	pop    %ebx
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    

00801418 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	57                   	push   %edi
  80141c:	56                   	push   %esi
  80141d:	53                   	push   %ebx
  80141e:	83 ec 1c             	sub    $0x1c,%esp
  801421:	8b 7d 08             	mov    0x8(%ebp),%edi
  801424:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801427:	85 f6                	test   %esi,%esi
  801429:	74 33                	je     80145e <readn+0x46>
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
  801430:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801435:	89 f2                	mov    %esi,%edx
  801437:	29 c2                	sub    %eax,%edx
  801439:	89 54 24 08          	mov    %edx,0x8(%esp)
  80143d:	03 45 0c             	add    0xc(%ebp),%eax
  801440:	89 44 24 04          	mov    %eax,0x4(%esp)
  801444:	89 3c 24             	mov    %edi,(%esp)
  801447:	e8 3a ff ff ff       	call   801386 <read>
		if (m < 0)
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 1b                	js     80146b <readn+0x53>
			return m;
		if (m == 0)
  801450:	85 c0                	test   %eax,%eax
  801452:	74 11                	je     801465 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801454:	01 c3                	add    %eax,%ebx
  801456:	89 d8                	mov    %ebx,%eax
  801458:	39 f3                	cmp    %esi,%ebx
  80145a:	72 d9                	jb     801435 <readn+0x1d>
  80145c:	eb 0b                	jmp    801469 <readn+0x51>
  80145e:	b8 00 00 00 00       	mov    $0x0,%eax
  801463:	eb 06                	jmp    80146b <readn+0x53>
  801465:	89 d8                	mov    %ebx,%eax
  801467:	eb 02                	jmp    80146b <readn+0x53>
  801469:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80146b:	83 c4 1c             	add    $0x1c,%esp
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5f                   	pop    %edi
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	53                   	push   %ebx
  801477:	83 ec 24             	sub    $0x24,%esp
  80147a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	89 1c 24             	mov    %ebx,(%esp)
  801487:	e8 4f fc ff ff       	call   8010db <fd_lookup>
  80148c:	89 c2                	mov    %eax,%edx
  80148e:	85 d2                	test   %edx,%edx
  801490:	78 68                	js     8014fa <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801492:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801495:	89 44 24 04          	mov    %eax,0x4(%esp)
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	8b 00                	mov    (%eax),%eax
  80149e:	89 04 24             	mov    %eax,(%esp)
  8014a1:	e8 8b fc ff ff       	call   801131 <dev_lookup>
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 50                	js     8014fa <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b1:	75 23                	jne    8014d6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8014b8:	8b 40 48             	mov    0x48(%eax),%eax
  8014bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c3:	c7 04 24 4c 26 80 00 	movl   $0x80264c,(%esp)
  8014ca:	e8 ee ed ff ff       	call   8002bd <cprintf>
		return -E_INVAL;
  8014cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d4:	eb 24                	jmp    8014fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8014dc:	85 d2                	test   %edx,%edx
  8014de:	74 15                	je     8014f5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ee:	89 04 24             	mov    %eax,(%esp)
  8014f1:	ff d2                	call   *%edx
  8014f3:	eb 05                	jmp    8014fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014fa:	83 c4 24             	add    $0x24,%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    

00801500 <seek>:

int
seek(int fdnum, off_t offset)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801506:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801509:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 c3 fb ff ff       	call   8010db <fd_lookup>
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 0e                	js     80152a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80151c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801522:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	53                   	push   %ebx
  801530:	83 ec 24             	sub    $0x24,%esp
  801533:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153d:	89 1c 24             	mov    %ebx,(%esp)
  801540:	e8 96 fb ff ff       	call   8010db <fd_lookup>
  801545:	89 c2                	mov    %eax,%edx
  801547:	85 d2                	test   %edx,%edx
  801549:	78 61                	js     8015ac <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	8b 00                	mov    (%eax),%eax
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	e8 d2 fb ff ff       	call   801131 <dev_lookup>
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 49                	js     8015ac <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156a:	75 23                	jne    80158f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80156c:	a1 20 40 c0 00       	mov    0xc04020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801571:	8b 40 48             	mov    0x48(%eax),%eax
  801574:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801578:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157c:	c7 04 24 0c 26 80 00 	movl   $0x80260c,(%esp)
  801583:	e8 35 ed ff ff       	call   8002bd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801588:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158d:	eb 1d                	jmp    8015ac <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80158f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801592:	8b 52 18             	mov    0x18(%edx),%edx
  801595:	85 d2                	test   %edx,%edx
  801597:	74 0e                	je     8015a7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801599:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	ff d2                	call   *%edx
  8015a5:	eb 05                	jmp    8015ac <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015ac:	83 c4 24             	add    $0x24,%esp
  8015af:	5b                   	pop    %ebx
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    

008015b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	53                   	push   %ebx
  8015b6:	83 ec 24             	sub    $0x24,%esp
  8015b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 04 24             	mov    %eax,(%esp)
  8015c9:	e8 0d fb ff ff       	call   8010db <fd_lookup>
  8015ce:	89 c2                	mov    %eax,%edx
  8015d0:	85 d2                	test   %edx,%edx
  8015d2:	78 52                	js     801626 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	8b 00                	mov    (%eax),%eax
  8015e0:	89 04 24             	mov    %eax,(%esp)
  8015e3:	e8 49 fb ff ff       	call   801131 <dev_lookup>
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 3a                	js     801626 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015f3:	74 2c                	je     801621 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015f5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ff:	00 00 00 
	stat->st_isdir = 0;
  801602:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801609:	00 00 00 
	stat->st_dev = dev;
  80160c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801612:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801616:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801619:	89 14 24             	mov    %edx,(%esp)
  80161c:	ff 50 14             	call   *0x14(%eax)
  80161f:	eb 05                	jmp    801626 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801621:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801626:	83 c4 24             	add    $0x24,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801634:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80163b:	00 
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	89 04 24             	mov    %eax,(%esp)
  801642:	e8 af 01 00 00       	call   8017f6 <open>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	85 db                	test   %ebx,%ebx
  80164b:	78 1b                	js     801668 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	89 1c 24             	mov    %ebx,(%esp)
  801657:	e8 56 ff ff ff       	call   8015b2 <fstat>
  80165c:	89 c6                	mov    %eax,%esi
	close(fd);
  80165e:	89 1c 24             	mov    %ebx,(%esp)
  801661:	e8 bd fb ff ff       	call   801223 <close>
	return r;
  801666:	89 f0                	mov    %esi,%eax
}
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 10             	sub    $0x10,%esp
  801677:	89 c6                	mov    %eax,%esi
  801679:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80167b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801682:	75 11                	jne    801695 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80168b:	e8 26 08 00 00       	call   801eb6 <ipc_find_env>
  801690:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801695:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80169c:	00 
  80169d:	c7 44 24 08 00 50 c0 	movl   $0xc05000,0x8(%esp)
  8016a4:	00 
  8016a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a9:	a1 00 40 80 00       	mov    0x804000,%eax
  8016ae:	89 04 24             	mov    %eax,(%esp)
  8016b1:	e8 9a 07 00 00       	call   801e50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016bd:	00 
  8016be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c9:	e8 18 07 00 00       	call   801de6 <ipc_recv>
}
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 14             	sub    $0x14,%esp
  8016dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f4:	e8 76 ff ff ff       	call   80166f <fsipc>
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	85 d2                	test   %edx,%edx
  8016fd:	78 2b                	js     80172a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ff:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  801706:	00 
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 0c f2 ff ff       	call   80091b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80170f:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801714:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171a:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80171f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	83 c4 14             	add    $0x14,%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8b 40 0c             	mov    0xc(%eax),%eax
  80173c:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	b8 06 00 00 00       	mov    $0x6,%eax
  80174b:	e8 1f ff ff ff       	call   80166f <fsipc>
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	83 ec 10             	sub    $0x10,%esp
  80175a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8b 40 0c             	mov    0xc(%eax),%eax
  801763:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  801768:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	b8 03 00 00 00       	mov    $0x3,%eax
  801778:	e8 f2 fe ff ff       	call   80166f <fsipc>
  80177d:	89 c3                	mov    %eax,%ebx
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 6a                	js     8017ed <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801783:	39 c6                	cmp    %eax,%esi
  801785:	73 24                	jae    8017ab <devfile_read+0x59>
  801787:	c7 44 24 0c 69 26 80 	movl   $0x802669,0xc(%esp)
  80178e:	00 
  80178f:	c7 44 24 08 70 26 80 	movl   $0x802670,0x8(%esp)
  801796:	00 
  801797:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  80179e:	00 
  80179f:	c7 04 24 85 26 80 00 	movl   $0x802685,(%esp)
  8017a6:	e8 19 ea ff ff       	call   8001c4 <_panic>
	assert(r <= PGSIZE);
  8017ab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b0:	7e 24                	jle    8017d6 <devfile_read+0x84>
  8017b2:	c7 44 24 0c 90 26 80 	movl   $0x802690,0xc(%esp)
  8017b9:	00 
  8017ba:	c7 44 24 08 70 26 80 	movl   $0x802670,0x8(%esp)
  8017c1:	00 
  8017c2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8017c9:	00 
  8017ca:	c7 04 24 85 26 80 00 	movl   $0x802685,(%esp)
  8017d1:	e8 ee e9 ff ff       	call   8001c4 <_panic>
	memmove(buf, &fsipcbuf, r);
  8017d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017da:	c7 44 24 04 00 50 c0 	movl   $0xc05000,0x4(%esp)
  8017e1:	00 
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	89 04 24             	mov    %eax,(%esp)
  8017e8:	e8 29 f3 ff ff       	call   800b16 <memmove>
	return r;
}
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 24             	sub    $0x24,%esp
  8017fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801800:	89 1c 24             	mov    %ebx,(%esp)
  801803:	e8 b8 f0 ff ff       	call   8008c0 <strlen>
  801808:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80180d:	7f 60                	jg     80186f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80180f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 4d f8 ff ff       	call   801067 <fd_alloc>
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	85 d2                	test   %edx,%edx
  80181e:	78 54                	js     801874 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801824:	c7 04 24 00 50 c0 00 	movl   $0xc05000,(%esp)
  80182b:	e8 eb f0 ff ff       	call   80091b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	a3 00 54 c0 00       	mov    %eax,0xc05400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183b:	b8 01 00 00 00       	mov    $0x1,%eax
  801840:	e8 2a fe ff ff       	call   80166f <fsipc>
  801845:	89 c3                	mov    %eax,%ebx
  801847:	85 c0                	test   %eax,%eax
  801849:	79 17                	jns    801862 <open+0x6c>
		fd_close(fd, 0);
  80184b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801852:	00 
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 44 f9 ff ff       	call   8011a2 <fd_close>
		return r;
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	eb 12                	jmp    801874 <open+0x7e>
	}

	return fd2num(fd);
  801862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801865:	89 04 24             	mov    %eax,(%esp)
  801868:	e8 d3 f7 ff ff       	call   801040 <fd2num>
  80186d:	eb 05                	jmp    801874 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80186f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801874:	83 c4 24             	add    $0x24,%esp
  801877:	5b                   	pop    %ebx
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
  80187a:	66 90                	xchg   %ax,%ax
  80187c:	66 90                	xchg   %ax,%ax
  80187e:	66 90                	xchg   %ax,%ax

00801880 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	83 ec 10             	sub    $0x10,%esp
  801888:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 04 24             	mov    %eax,(%esp)
  801891:	e8 ba f7 ff ff       	call   801050 <fd2data>
  801896:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801898:	c7 44 24 04 9c 26 80 	movl   $0x80269c,0x4(%esp)
  80189f:	00 
  8018a0:	89 1c 24             	mov    %ebx,(%esp)
  8018a3:	e8 73 f0 ff ff       	call   80091b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018a8:	8b 46 04             	mov    0x4(%esi),%eax
  8018ab:	2b 06                	sub    (%esi),%eax
  8018ad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018ba:	00 00 00 
	stat->st_dev = &devpipe;
  8018bd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018c4:	30 80 00 
	return 0;
}
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	53                   	push   %ebx
  8018d7:	83 ec 14             	sub    $0x14,%esp
  8018da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e8:	e8 83 f5 ff ff       	call   800e70 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018ed:	89 1c 24             	mov    %ebx,(%esp)
  8018f0:	e8 5b f7 ff ff       	call   801050 <fd2data>
  8018f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801900:	e8 6b f5 ff ff       	call   800e70 <sys_page_unmap>
}
  801905:	83 c4 14             	add    $0x14,%esp
  801908:	5b                   	pop    %ebx
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	57                   	push   %edi
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	83 ec 2c             	sub    $0x2c,%esp
  801914:	89 c6                	mov    %eax,%esi
  801916:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801919:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80191e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801921:	89 34 24             	mov    %esi,(%esp)
  801924:	e8 d5 05 00 00       	call   801efe <pageref>
  801929:	89 c7                	mov    %eax,%edi
  80192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 c8 05 00 00       	call   801efe <pageref>
  801936:	39 c7                	cmp    %eax,%edi
  801938:	0f 94 c2             	sete   %dl
  80193b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80193e:	8b 0d 20 40 c0 00    	mov    0xc04020,%ecx
  801944:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801947:	39 fb                	cmp    %edi,%ebx
  801949:	74 21                	je     80196c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80194b:	84 d2                	test   %dl,%dl
  80194d:	74 ca                	je     801919 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80194f:	8b 51 58             	mov    0x58(%ecx),%edx
  801952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801956:	89 54 24 08          	mov    %edx,0x8(%esp)
  80195a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80195e:	c7 04 24 a3 26 80 00 	movl   $0x8026a3,(%esp)
  801965:	e8 53 e9 ff ff       	call   8002bd <cprintf>
  80196a:	eb ad                	jmp    801919 <_pipeisclosed+0xe>
	}
}
  80196c:	83 c4 2c             	add    $0x2c,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5f                   	pop    %edi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	57                   	push   %edi
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	83 ec 1c             	sub    $0x1c,%esp
  80197d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801980:	89 34 24             	mov    %esi,(%esp)
  801983:	e8 c8 f6 ff ff       	call   801050 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801988:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198c:	74 61                	je     8019ef <devpipe_write+0x7b>
  80198e:	89 c3                	mov    %eax,%ebx
  801990:	bf 00 00 00 00       	mov    $0x0,%edi
  801995:	eb 4a                	jmp    8019e1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801997:	89 da                	mov    %ebx,%edx
  801999:	89 f0                	mov    %esi,%eax
  80199b:	e8 6b ff ff ff       	call   80190b <_pipeisclosed>
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	75 54                	jne    8019f8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8019a4:	e8 01 f4 ff ff       	call   800daa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8019ac:	8b 0b                	mov    (%ebx),%ecx
  8019ae:	8d 51 20             	lea    0x20(%ecx),%edx
  8019b1:	39 d0                	cmp    %edx,%eax
  8019b3:	73 e2                	jae    801997 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019bc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019bf:	99                   	cltd   
  8019c0:	c1 ea 1b             	shr    $0x1b,%edx
  8019c3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8019c6:	83 e1 1f             	and    $0x1f,%ecx
  8019c9:	29 d1                	sub    %edx,%ecx
  8019cb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8019cf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8019d3:	83 c0 01             	add    $0x1,%eax
  8019d6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019d9:	83 c7 01             	add    $0x1,%edi
  8019dc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019df:	74 13                	je     8019f4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019e4:	8b 0b                	mov    (%ebx),%ecx
  8019e6:	8d 51 20             	lea    0x20(%ecx),%edx
  8019e9:	39 d0                	cmp    %edx,%eax
  8019eb:	73 aa                	jae    801997 <devpipe_write+0x23>
  8019ed:	eb c6                	jmp    8019b5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019f4:	89 f8                	mov    %edi,%eax
  8019f6:	eb 05                	jmp    8019fd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8019f8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8019fd:	83 c4 1c             	add    $0x1c,%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5f                   	pop    %edi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	57                   	push   %edi
  801a09:	56                   	push   %esi
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 1c             	sub    $0x1c,%esp
  801a0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a11:	89 3c 24             	mov    %edi,(%esp)
  801a14:	e8 37 f6 ff ff       	call   801050 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1d:	74 54                	je     801a73 <devpipe_read+0x6e>
  801a1f:	89 c3                	mov    %eax,%ebx
  801a21:	be 00 00 00 00       	mov    $0x0,%esi
  801a26:	eb 3e                	jmp    801a66 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a28:	89 f0                	mov    %esi,%eax
  801a2a:	eb 55                	jmp    801a81 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a2c:	89 da                	mov    %ebx,%edx
  801a2e:	89 f8                	mov    %edi,%eax
  801a30:	e8 d6 fe ff ff       	call   80190b <_pipeisclosed>
  801a35:	85 c0                	test   %eax,%eax
  801a37:	75 43                	jne    801a7c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a39:	e8 6c f3 ff ff       	call   800daa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a3e:	8b 03                	mov    (%ebx),%eax
  801a40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a43:	74 e7                	je     801a2c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a45:	99                   	cltd   
  801a46:	c1 ea 1b             	shr    $0x1b,%edx
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	83 e0 1f             	and    $0x1f,%eax
  801a4e:	29 d0                	sub    %edx,%eax
  801a50:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a58:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a5b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a5e:	83 c6 01             	add    $0x1,%esi
  801a61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a64:	74 12                	je     801a78 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801a66:	8b 03                	mov    (%ebx),%eax
  801a68:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a6b:	75 d8                	jne    801a45 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a6d:	85 f6                	test   %esi,%esi
  801a6f:	75 b7                	jne    801a28 <devpipe_read+0x23>
  801a71:	eb b9                	jmp    801a2c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a73:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a78:	89 f0                	mov    %esi,%eax
  801a7a:	eb 05                	jmp    801a81 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801a81:	83 c4 1c             	add    $0x1c,%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5f                   	pop    %edi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
  801a8e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	e8 cb f5 ff ff       	call   801067 <fd_alloc>
  801a9c:	89 c2                	mov    %eax,%edx
  801a9e:	85 d2                	test   %edx,%edx
  801aa0:	0f 88 4d 01 00 00    	js     801bf3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801aad:	00 
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abc:	e8 08 f3 ff ff       	call   800dc9 <sys_page_alloc>
  801ac1:	89 c2                	mov    %eax,%edx
  801ac3:	85 d2                	test   %edx,%edx
  801ac5:	0f 88 28 01 00 00    	js     801bf3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801acb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 91 f5 ff ff       	call   801067 <fd_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	0f 88 fe 00 00 00    	js     801bde <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ae7:	00 
  801ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801af6:	e8 ce f2 ff ff       	call   800dc9 <sys_page_alloc>
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	85 c0                	test   %eax,%eax
  801aff:	0f 88 d9 00 00 00    	js     801bde <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	e8 40 f5 ff ff       	call   801050 <fd2data>
  801b10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b19:	00 
  801b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b25:	e8 9f f2 ff ff       	call   800dc9 <sys_page_alloc>
  801b2a:	89 c3                	mov    %eax,%ebx
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	0f 88 97 00 00 00    	js     801bcb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b37:	89 04 24             	mov    %eax,(%esp)
  801b3a:	e8 11 f5 ff ff       	call   801050 <fd2data>
  801b3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b46:	00 
  801b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b52:	00 
  801b53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5e:	e8 ba f2 ff ff       	call   800e1d <sys_page_map>
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 52                	js     801bbb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	e8 a2 f4 ff ff       	call   801040 <fd2num>
  801b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	e8 92 f4 ff ff       	call   801040 <fd2num>
  801bae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	eb 38                	jmp    801bf3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801bbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc6:	e8 a5 f2 ff ff       	call   800e70 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd9:	e8 92 f2 ff ff       	call   800e70 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bec:	e8 7f f2 ff ff       	call   800e70 <sys_page_unmap>
  801bf1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801bf3:	83 c4 30             	add    $0x30,%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5e                   	pop    %esi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    

00801bfa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	89 04 24             	mov    %eax,(%esp)
  801c0d:	e8 c9 f4 ff ff       	call   8010db <fd_lookup>
  801c12:	89 c2                	mov    %eax,%edx
  801c14:	85 d2                	test   %edx,%edx
  801c16:	78 15                	js     801c2d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 2d f4 ff ff       	call   801050 <fd2data>
	return _pipeisclosed(fd, p);
  801c23:	89 c2                	mov    %eax,%edx
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	e8 de fc ff ff       	call   80190b <_pipeisclosed>
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    
  801c2f:	90                   	nop

00801c30 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c40:	c7 44 24 04 bb 26 80 	movl   $0x8026bb,0x4(%esp)
  801c47:	00 
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	89 04 24             	mov    %eax,(%esp)
  801c4e:	e8 c8 ec ff ff       	call   80091b <strcpy>
	return 0;
}
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c6a:	74 4a                	je     801cb6 <devcons_write+0x5c>
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c71:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c76:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c7c:	8b 75 10             	mov    0x10(%ebp),%esi
  801c7f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801c81:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c84:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801c89:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c8c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c90:	03 45 0c             	add    0xc(%ebp),%eax
  801c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c97:	89 3c 24             	mov    %edi,(%esp)
  801c9a:	e8 77 ee ff ff       	call   800b16 <memmove>
		sys_cputs(buf, m);
  801c9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ca3:	89 3c 24             	mov    %edi,(%esp)
  801ca6:	e8 51 f0 ff ff       	call   800cfc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cab:	01 f3                	add    %esi,%ebx
  801cad:	89 d8                	mov    %ebx,%eax
  801caf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801cb2:	72 c8                	jb     801c7c <devcons_write+0x22>
  801cb4:	eb 05                	jmp    801cbb <devcons_write+0x61>
  801cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801cbb:	89 d8                	mov    %ebx,%eax
  801cbd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    

00801cc8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cd7:	75 07                	jne    801ce0 <devcons_read+0x18>
  801cd9:	eb 28                	jmp    801d03 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801cdb:	e8 ca f0 ff ff       	call   800daa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ce0:	e8 35 f0 ff ff       	call   800d1a <sys_cgetc>
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	74 f2                	je     801cdb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	78 16                	js     801d03 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ced:	83 f8 04             	cmp    $0x4,%eax
  801cf0:	74 0c                	je     801cfe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	88 02                	mov    %al,(%edx)
	return 1;
  801cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfc:	eb 05                	jmp    801d03 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d18:	00 
  801d19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d1c:	89 04 24             	mov    %eax,(%esp)
  801d1f:	e8 d8 ef ff ff       	call   800cfc <sys_cputs>
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <getchar>:

int
getchar(void)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d2c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d33:	00 
  801d34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d42:	e8 3f f6 ff ff       	call   801386 <read>
	if (r < 0)
  801d47:	85 c0                	test   %eax,%eax
  801d49:	78 0f                	js     801d5a <getchar+0x34>
		return r;
	if (r < 1)
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	7e 06                	jle    801d55 <getchar+0x2f>
		return -E_EOF;
	return c;
  801d4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801d53:	eb 05                	jmp    801d5a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801d55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	89 04 24             	mov    %eax,(%esp)
  801d6f:	e8 67 f3 ff ff       	call   8010db <fd_lookup>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 11                	js     801d89 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d81:	39 10                	cmp    %edx,(%eax)
  801d83:	0f 94 c0             	sete   %al
  801d86:	0f b6 c0             	movzbl %al,%eax
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <opencons>:

int
opencons(void)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d94:	89 04 24             	mov    %eax,(%esp)
  801d97:	e8 cb f2 ff ff       	call   801067 <fd_alloc>
		return r;
  801d9c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 40                	js     801de2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801da2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801da9:	00 
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db8:	e8 0c f0 ff ff       	call   800dc9 <sys_page_alloc>
		return r;
  801dbd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 1f                	js     801de2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801dc3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801dd8:	89 04 24             	mov    %eax,(%esp)
  801ddb:	e8 60 f2 ff ff       	call   801040 <fd2num>
  801de0:	89 c2                	mov    %eax,%edx
}
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
  801deb:	83 ec 10             	sub    $0x10,%esp
  801dee:	8b 75 08             	mov    0x8(%ebp),%esi
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801df7:	83 f8 01             	cmp    $0x1,%eax
  801dfa:	19 c0                	sbb    %eax,%eax
  801dfc:	f7 d0                	not    %eax
  801dfe:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801e03:	89 04 24             	mov    %eax,(%esp)
  801e06:	e8 d4 f1 ff ff       	call   800fdf <sys_ipc_recv>
	if (err_code < 0) {
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	79 16                	jns    801e25 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801e0f:	85 f6                	test   %esi,%esi
  801e11:	74 06                	je     801e19 <ipc_recv+0x33>
  801e13:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e19:	85 db                	test   %ebx,%ebx
  801e1b:	74 2c                	je     801e49 <ipc_recv+0x63>
  801e1d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e23:	eb 24                	jmp    801e49 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e25:	85 f6                	test   %esi,%esi
  801e27:	74 0a                	je     801e33 <ipc_recv+0x4d>
  801e29:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e2e:	8b 40 74             	mov    0x74(%eax),%eax
  801e31:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e33:	85 db                	test   %ebx,%ebx
  801e35:	74 0a                	je     801e41 <ipc_recv+0x5b>
  801e37:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e3c:	8b 40 78             	mov    0x78(%eax),%eax
  801e3f:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801e41:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e46:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	57                   	push   %edi
  801e54:	56                   	push   %esi
  801e55:	53                   	push   %ebx
  801e56:	83 ec 1c             	sub    $0x1c,%esp
  801e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e62:	eb 25                	jmp    801e89 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801e64:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e67:	74 20                	je     801e89 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801e69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6d:	c7 44 24 08 c7 26 80 	movl   $0x8026c7,0x8(%esp)
  801e74:	00 
  801e75:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e7c:	00 
  801e7d:	c7 04 24 d3 26 80 00 	movl   $0x8026d3,(%esp)
  801e84:	e8 3b e3 ff ff       	call   8001c4 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e89:	85 db                	test   %ebx,%ebx
  801e8b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e90:	0f 45 c3             	cmovne %ebx,%eax
  801e93:	8b 55 14             	mov    0x14(%ebp),%edx
  801e96:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ea2:	89 3c 24             	mov    %edi,(%esp)
  801ea5:	e8 12 f1 ff ff       	call   800fbc <sys_ipc_try_send>
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	75 b6                	jne    801e64 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801eae:	83 c4 1c             	add    $0x1c,%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801ebc:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801ec1:	39 c8                	cmp    %ecx,%eax
  801ec3:	74 17                	je     801edc <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ec5:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801eca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ecd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ed3:	8b 52 50             	mov    0x50(%edx),%edx
  801ed6:	39 ca                	cmp    %ecx,%edx
  801ed8:	75 14                	jne    801eee <ipc_find_env+0x38>
  801eda:	eb 05                	jmp    801ee1 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ee1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ee4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ee9:	8b 40 40             	mov    0x40(%eax),%eax
  801eec:	eb 0e                	jmp    801efc <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eee:	83 c0 01             	add    $0x1,%eax
  801ef1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ef6:	75 d2                	jne    801eca <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ef8:	66 b8 00 00          	mov    $0x0,%ax
}
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    

00801efe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	c1 e8 16             	shr    $0x16,%eax
  801f09:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f15:	f6 c1 01             	test   $0x1,%cl
  801f18:	74 1d                	je     801f37 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f1a:	c1 ea 0c             	shr    $0xc,%edx
  801f1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f24:	f6 c2 01             	test   $0x1,%dl
  801f27:	74 0e                	je     801f37 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f29:	c1 ea 0c             	shr    $0xc,%edx
  801f2c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f33:	ef 
  801f34:	0f b7 c0             	movzwl %ax,%eax
}
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    
  801f39:	66 90                	xchg   %ax,%ax
  801f3b:	66 90                	xchg   %ax,%ax
  801f3d:	66 90                	xchg   %ax,%ax
  801f3f:	90                   	nop

00801f40 <__udivdi3>:
  801f40:	55                   	push   %ebp
  801f41:	57                   	push   %edi
  801f42:	56                   	push   %esi
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801f4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801f52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f56:	85 c0                	test   %eax,%eax
  801f58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f5c:	89 ea                	mov    %ebp,%edx
  801f5e:	89 0c 24             	mov    %ecx,(%esp)
  801f61:	75 2d                	jne    801f90 <__udivdi3+0x50>
  801f63:	39 e9                	cmp    %ebp,%ecx
  801f65:	77 61                	ja     801fc8 <__udivdi3+0x88>
  801f67:	85 c9                	test   %ecx,%ecx
  801f69:	89 ce                	mov    %ecx,%esi
  801f6b:	75 0b                	jne    801f78 <__udivdi3+0x38>
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f72:	31 d2                	xor    %edx,%edx
  801f74:	f7 f1                	div    %ecx
  801f76:	89 c6                	mov    %eax,%esi
  801f78:	31 d2                	xor    %edx,%edx
  801f7a:	89 e8                	mov    %ebp,%eax
  801f7c:	f7 f6                	div    %esi
  801f7e:	89 c5                	mov    %eax,%ebp
  801f80:	89 f8                	mov    %edi,%eax
  801f82:	f7 f6                	div    %esi
  801f84:	89 ea                	mov    %ebp,%edx
  801f86:	83 c4 0c             	add    $0xc,%esp
  801f89:	5e                   	pop    %esi
  801f8a:	5f                   	pop    %edi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	39 e8                	cmp    %ebp,%eax
  801f92:	77 24                	ja     801fb8 <__udivdi3+0x78>
  801f94:	0f bd e8             	bsr    %eax,%ebp
  801f97:	83 f5 1f             	xor    $0x1f,%ebp
  801f9a:	75 3c                	jne    801fd8 <__udivdi3+0x98>
  801f9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801fa0:	39 34 24             	cmp    %esi,(%esp)
  801fa3:	0f 86 9f 00 00 00    	jbe    802048 <__udivdi3+0x108>
  801fa9:	39 d0                	cmp    %edx,%eax
  801fab:	0f 82 97 00 00 00    	jb     802048 <__udivdi3+0x108>
  801fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fb8:	31 d2                	xor    %edx,%edx
  801fba:	31 c0                	xor    %eax,%eax
  801fbc:	83 c4 0c             	add    $0xc,%esp
  801fbf:	5e                   	pop    %esi
  801fc0:	5f                   	pop    %edi
  801fc1:	5d                   	pop    %ebp
  801fc2:	c3                   	ret    
  801fc3:	90                   	nop
  801fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fc8:	89 f8                	mov    %edi,%eax
  801fca:	f7 f1                	div    %ecx
  801fcc:	31 d2                	xor    %edx,%edx
  801fce:	83 c4 0c             	add    $0xc,%esp
  801fd1:	5e                   	pop    %esi
  801fd2:	5f                   	pop    %edi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
  801fd5:	8d 76 00             	lea    0x0(%esi),%esi
  801fd8:	89 e9                	mov    %ebp,%ecx
  801fda:	8b 3c 24             	mov    (%esp),%edi
  801fdd:	d3 e0                	shl    %cl,%eax
  801fdf:	89 c6                	mov    %eax,%esi
  801fe1:	b8 20 00 00 00       	mov    $0x20,%eax
  801fe6:	29 e8                	sub    %ebp,%eax
  801fe8:	89 c1                	mov    %eax,%ecx
  801fea:	d3 ef                	shr    %cl,%edi
  801fec:	89 e9                	mov    %ebp,%ecx
  801fee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ff2:	8b 3c 24             	mov    (%esp),%edi
  801ff5:	09 74 24 08          	or     %esi,0x8(%esp)
  801ff9:	89 d6                	mov    %edx,%esi
  801ffb:	d3 e7                	shl    %cl,%edi
  801ffd:	89 c1                	mov    %eax,%ecx
  801fff:	89 3c 24             	mov    %edi,(%esp)
  802002:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802006:	d3 ee                	shr    %cl,%esi
  802008:	89 e9                	mov    %ebp,%ecx
  80200a:	d3 e2                	shl    %cl,%edx
  80200c:	89 c1                	mov    %eax,%ecx
  80200e:	d3 ef                	shr    %cl,%edi
  802010:	09 d7                	or     %edx,%edi
  802012:	89 f2                	mov    %esi,%edx
  802014:	89 f8                	mov    %edi,%eax
  802016:	f7 74 24 08          	divl   0x8(%esp)
  80201a:	89 d6                	mov    %edx,%esi
  80201c:	89 c7                	mov    %eax,%edi
  80201e:	f7 24 24             	mull   (%esp)
  802021:	39 d6                	cmp    %edx,%esi
  802023:	89 14 24             	mov    %edx,(%esp)
  802026:	72 30                	jb     802058 <__udivdi3+0x118>
  802028:	8b 54 24 04          	mov    0x4(%esp),%edx
  80202c:	89 e9                	mov    %ebp,%ecx
  80202e:	d3 e2                	shl    %cl,%edx
  802030:	39 c2                	cmp    %eax,%edx
  802032:	73 05                	jae    802039 <__udivdi3+0xf9>
  802034:	3b 34 24             	cmp    (%esp),%esi
  802037:	74 1f                	je     802058 <__udivdi3+0x118>
  802039:	89 f8                	mov    %edi,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	e9 7a ff ff ff       	jmp    801fbc <__udivdi3+0x7c>
  802042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802048:	31 d2                	xor    %edx,%edx
  80204a:	b8 01 00 00 00       	mov    $0x1,%eax
  80204f:	e9 68 ff ff ff       	jmp    801fbc <__udivdi3+0x7c>
  802054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802058:	8d 47 ff             	lea    -0x1(%edi),%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	83 c4 0c             	add    $0xc,%esp
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    
  802064:	66 90                	xchg   %ax,%ax
  802066:	66 90                	xchg   %ax,%ax
  802068:	66 90                	xchg   %ax,%ax
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <__umoddi3>:
  802070:	55                   	push   %ebp
  802071:	57                   	push   %edi
  802072:	56                   	push   %esi
  802073:	83 ec 14             	sub    $0x14,%esp
  802076:	8b 44 24 28          	mov    0x28(%esp),%eax
  80207a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80207e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802082:	89 c7                	mov    %eax,%edi
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	8b 44 24 30          	mov    0x30(%esp),%eax
  80208c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802090:	89 34 24             	mov    %esi,(%esp)
  802093:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802097:	85 c0                	test   %eax,%eax
  802099:	89 c2                	mov    %eax,%edx
  80209b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80209f:	75 17                	jne    8020b8 <__umoddi3+0x48>
  8020a1:	39 fe                	cmp    %edi,%esi
  8020a3:	76 4b                	jbe    8020f0 <__umoddi3+0x80>
  8020a5:	89 c8                	mov    %ecx,%eax
  8020a7:	89 fa                	mov    %edi,%edx
  8020a9:	f7 f6                	div    %esi
  8020ab:	89 d0                	mov    %edx,%eax
  8020ad:	31 d2                	xor    %edx,%edx
  8020af:	83 c4 14             	add    $0x14,%esp
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	39 f8                	cmp    %edi,%eax
  8020ba:	77 54                	ja     802110 <__umoddi3+0xa0>
  8020bc:	0f bd e8             	bsr    %eax,%ebp
  8020bf:	83 f5 1f             	xor    $0x1f,%ebp
  8020c2:	75 5c                	jne    802120 <__umoddi3+0xb0>
  8020c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8020c8:	39 3c 24             	cmp    %edi,(%esp)
  8020cb:	0f 87 e7 00 00 00    	ja     8021b8 <__umoddi3+0x148>
  8020d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8020d5:	29 f1                	sub    %esi,%ecx
  8020d7:	19 c7                	sbb    %eax,%edi
  8020d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8020e9:	83 c4 14             	add    $0x14,%esp
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	85 f6                	test   %esi,%esi
  8020f2:	89 f5                	mov    %esi,%ebp
  8020f4:	75 0b                	jne    802101 <__umoddi3+0x91>
  8020f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fb:	31 d2                	xor    %edx,%edx
  8020fd:	f7 f6                	div    %esi
  8020ff:	89 c5                	mov    %eax,%ebp
  802101:	8b 44 24 04          	mov    0x4(%esp),%eax
  802105:	31 d2                	xor    %edx,%edx
  802107:	f7 f5                	div    %ebp
  802109:	89 c8                	mov    %ecx,%eax
  80210b:	f7 f5                	div    %ebp
  80210d:	eb 9c                	jmp    8020ab <__umoddi3+0x3b>
  80210f:	90                   	nop
  802110:	89 c8                	mov    %ecx,%eax
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 14             	add    $0x14,%esp
  802117:	5e                   	pop    %esi
  802118:	5f                   	pop    %edi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    
  80211b:	90                   	nop
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	8b 04 24             	mov    (%esp),%eax
  802123:	be 20 00 00 00       	mov    $0x20,%esi
  802128:	89 e9                	mov    %ebp,%ecx
  80212a:	29 ee                	sub    %ebp,%esi
  80212c:	d3 e2                	shl    %cl,%edx
  80212e:	89 f1                	mov    %esi,%ecx
  802130:	d3 e8                	shr    %cl,%eax
  802132:	89 e9                	mov    %ebp,%ecx
  802134:	89 44 24 04          	mov    %eax,0x4(%esp)
  802138:	8b 04 24             	mov    (%esp),%eax
  80213b:	09 54 24 04          	or     %edx,0x4(%esp)
  80213f:	89 fa                	mov    %edi,%edx
  802141:	d3 e0                	shl    %cl,%eax
  802143:	89 f1                	mov    %esi,%ecx
  802145:	89 44 24 08          	mov    %eax,0x8(%esp)
  802149:	8b 44 24 10          	mov    0x10(%esp),%eax
  80214d:	d3 ea                	shr    %cl,%edx
  80214f:	89 e9                	mov    %ebp,%ecx
  802151:	d3 e7                	shl    %cl,%edi
  802153:	89 f1                	mov    %esi,%ecx
  802155:	d3 e8                	shr    %cl,%eax
  802157:	89 e9                	mov    %ebp,%ecx
  802159:	09 f8                	or     %edi,%eax
  80215b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80215f:	f7 74 24 04          	divl   0x4(%esp)
  802163:	d3 e7                	shl    %cl,%edi
  802165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802169:	89 d7                	mov    %edx,%edi
  80216b:	f7 64 24 08          	mull   0x8(%esp)
  80216f:	39 d7                	cmp    %edx,%edi
  802171:	89 c1                	mov    %eax,%ecx
  802173:	89 14 24             	mov    %edx,(%esp)
  802176:	72 2c                	jb     8021a4 <__umoddi3+0x134>
  802178:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80217c:	72 22                	jb     8021a0 <__umoddi3+0x130>
  80217e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802182:	29 c8                	sub    %ecx,%eax
  802184:	19 d7                	sbb    %edx,%edi
  802186:	89 e9                	mov    %ebp,%ecx
  802188:	89 fa                	mov    %edi,%edx
  80218a:	d3 e8                	shr    %cl,%eax
  80218c:	89 f1                	mov    %esi,%ecx
  80218e:	d3 e2                	shl    %cl,%edx
  802190:	89 e9                	mov    %ebp,%ecx
  802192:	d3 ef                	shr    %cl,%edi
  802194:	09 d0                	or     %edx,%eax
  802196:	89 fa                	mov    %edi,%edx
  802198:	83 c4 14             	add    $0x14,%esp
  80219b:	5e                   	pop    %esi
  80219c:	5f                   	pop    %edi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    
  80219f:	90                   	nop
  8021a0:	39 d7                	cmp    %edx,%edi
  8021a2:	75 da                	jne    80217e <__umoddi3+0x10e>
  8021a4:	8b 14 24             	mov    (%esp),%edx
  8021a7:	89 c1                	mov    %eax,%ecx
  8021a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8021ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8021b1:	eb cb                	jmp    80217e <__umoddi3+0x10e>
  8021b3:	90                   	nop
  8021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8021bc:	0f 82 0f ff ff ff    	jb     8020d1 <__umoddi3+0x61>
  8021c2:	e9 1a ff ff ff       	jmp    8020e1 <__umoddi3+0x71>
