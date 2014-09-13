
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 3a 01 00 00       	call   80016b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003e:	eb 43                	jmp    800083 <cat+0x50>
		if ((r = write(1, buf, n)) != n)
  800040:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800044:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80004b:	00 
  80004c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800053:	e8 4b 14 00 00       	call   8014a3 <write>
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 27                	je     800083 <cat+0x50>
			panic("write error copying %s: %e", s, r);
  80005c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 40 23 80 	movl   $0x802340,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 5b 23 80 00 	movl   $0x80235b,(%esp)
  80007e:	e8 79 01 00 00       	call   8001fc <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800083:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800092:	00 
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 1b 13 00 00       	call   8013b6 <read>
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f 9f                	jg     800040 <cat+0xd>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 27                	jns    8000cc <cat+0x99>
		panic("error reading %s: %e", s, n);
  8000a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 66 23 80 	movl   $0x802366,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 5b 23 80 00 	movl   $0x80235b,(%esp)
  8000c7:	e8 30 01 00 00       	call   8001fc <_panic>
}
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 7b 	movl   $0x80237b,0x803000
  8000e6:	23 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 0d                	je     8000fc <umain+0x29>
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f8:	7f 18                	jg     800112 <umain+0x3f>
  8000fa:	eb 67                	jmp    800163 <umain+0x90>
{
	int f, i;

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
  8000fc:	c7 44 24 04 7f 23 80 	movl   $0x80237f,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010b:	e8 23 ff ff ff       	call   800033 <cat>
  800110:	eb 51                	jmp    800163 <umain+0x90>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800112:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800119:	00 
  80011a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 01 17 00 00       	call   801826 <open>
  800125:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	79 19                	jns    800144 <umain+0x71>
				printf("can't open %s: %e\n", argv[i], f);
  80012b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800132:	89 44 24 04          	mov    %eax,0x4(%esp)
  800136:	c7 04 24 87 23 80 00 	movl   $0x802387,(%esp)
  80013d:	e8 7d 18 00 00       	call   8019bf <printf>
  800142:	eb 17                	jmp    80015b <umain+0x88>
			else {
				cat(f, argv[i]);
  800144:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014b:	89 34 24             	mov    %esi,(%esp)
  80014e:	e8 e0 fe ff ff       	call   800033 <cat>
				close(f);
  800153:	89 34 24             	mov    %esi,(%esp)
  800156:	e8 f8 10 00 00       	call   801253 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80015b:	83 c3 01             	add    $0x1,%ebx
  80015e:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800161:	75 af                	jne    800112 <umain+0x3f>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800163:	83 c4 1c             	add    $0x1c,%esp
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5f                   	pop    %edi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    

0080016b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 10             	sub    $0x10,%esp
  800173:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800176:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800179:	e8 3d 0c 00 00       	call   800dbb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80017e:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800184:	39 c2                	cmp    %eax,%edx
  800186:	74 17                	je     80019f <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800188:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80018d:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800190:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800196:	8b 49 40             	mov    0x40(%ecx),%ecx
  800199:	39 c1                	cmp    %eax,%ecx
  80019b:	75 18                	jne    8001b5 <libmain+0x4a>
  80019d:	eb 05                	jmp    8001a4 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8001a4:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8001a7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8001ad:	89 15 20 60 80 00    	mov    %edx,0x806020
			break;
  8001b3:	eb 0b                	jmp    8001c0 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001b5:	83 c2 01             	add    $0x1,%edx
  8001b8:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001be:	75 cd                	jne    80018d <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c0:	85 db                	test   %ebx,%ebx
  8001c2:	7e 07                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c4:	8b 06                	mov    (%esi),%eax
  8001c6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001cf:	89 1c 24             	mov    %ebx,(%esp)
  8001d2:	e8 fc fe ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001d7:	e8 07 00 00 00       	call   8001e3 <exit>
}
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5e                   	pop    %esi
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    

008001e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001e9:	e8 98 10 00 00       	call   801286 <close_all>
	sys_env_destroy(0);
  8001ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001f5:	e8 6f 0b 00 00       	call   800d69 <sys_env_destroy>
}
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800204:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800207:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80020d:	e8 a9 0b 00 00       	call   800dbb <sys_getenvid>
  800212:	8b 55 0c             	mov    0xc(%ebp),%edx
  800215:	89 54 24 10          	mov    %edx,0x10(%esp)
  800219:	8b 55 08             	mov    0x8(%ebp),%edx
  80021c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800220:	89 74 24 08          	mov    %esi,0x8(%esp)
  800224:	89 44 24 04          	mov    %eax,0x4(%esp)
  800228:	c7 04 24 a4 23 80 00 	movl   $0x8023a4,(%esp)
  80022f:	e8 c1 00 00 00       	call   8002f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800234:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800238:	8b 45 10             	mov    0x10(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 51 00 00 00       	call   800294 <vcprintf>
	cprintf("\n");
  800243:	c7 04 24 b4 27 80 00 	movl   $0x8027b4,(%esp)
  80024a:	e8 a6 00 00 00       	call   8002f5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024f:	cc                   	int3   
  800250:	eb fd                	jmp    80024f <_panic+0x53>

00800252 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	53                   	push   %ebx
  800256:	83 ec 14             	sub    $0x14,%esp
  800259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025c:	8b 13                	mov    (%ebx),%edx
  80025e:	8d 42 01             	lea    0x1(%edx),%eax
  800261:	89 03                	mov    %eax,(%ebx)
  800263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800266:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026f:	75 19                	jne    80028a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800271:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800278:	00 
  800279:	8d 43 08             	lea    0x8(%ebx),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 a8 0a 00 00       	call   800d2c <sys_cputs>
		b->idx = 0;
  800284:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80028a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028e:	83 c4 14             	add    $0x14,%esp
  800291:	5b                   	pop    %ebx
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80029d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a4:	00 00 00 
	b.cnt = 0;
  8002a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c9:	c7 04 24 52 02 80 00 	movl   $0x800252,(%esp)
  8002d0:	e8 af 01 00 00       	call   800484 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	e8 3f 0a 00 00       	call   800d2c <sys_cputs>

	return b.cnt;
}
  8002ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800302:	8b 45 08             	mov    0x8(%ebp),%eax
  800305:	89 04 24             	mov    %eax,(%esp)
  800308:	e8 87 ff ff ff       	call   800294 <vcprintf>
	va_end(ap);

	return cnt;
}
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    
  80030f:	90                   	nop

00800310 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	57                   	push   %edi
  800314:	56                   	push   %esi
  800315:	53                   	push   %ebx
  800316:	83 ec 3c             	sub    $0x3c,%esp
  800319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031c:	89 d7                	mov    %edx,%edi
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800324:	8b 75 0c             	mov    0xc(%ebp),%esi
  800327:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80032a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800335:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800338:	39 f1                	cmp    %esi,%ecx
  80033a:	72 14                	jb     800350 <printnum+0x40>
  80033c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033f:	76 0f                	jbe    800350 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800341:	8b 45 14             	mov    0x14(%ebp),%eax
  800344:	8d 70 ff             	lea    -0x1(%eax),%esi
  800347:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80034a:	85 f6                	test   %esi,%esi
  80034c:	7f 60                	jg     8003ae <printnum+0x9e>
  80034e:	eb 72                	jmp    8003c2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800350:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800353:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800357:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80035a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80035d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800361:	89 44 24 08          	mov    %eax,0x8(%esp)
  800365:	8b 44 24 08          	mov    0x8(%esp),%eax
  800369:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80036d:	89 c3                	mov    %eax,%ebx
  80036f:	89 d6                	mov    %edx,%esi
  800371:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800377:	89 54 24 08          	mov    %edx,0x8(%esp)
  80037b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80037f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038c:	e8 1f 1d 00 00       	call   8020b0 <__udivdi3>
  800391:	89 d9                	mov    %ebx,%ecx
  800393:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800397:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a2:	89 fa                	mov    %edi,%edx
  8003a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a7:	e8 64 ff ff ff       	call   800310 <printnum>
  8003ac:	eb 14                	jmp    8003c2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ba:	83 ee 01             	sub    $0x1,%esi
  8003bd:	75 ef                	jne    8003ae <printnum+0x9e>
  8003bf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003db:	89 04 24             	mov    %eax,(%esp)
  8003de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e5:	e8 f6 1d 00 00       	call   8021e0 <__umoddi3>
  8003ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ee:	0f be 80 c7 23 80 00 	movsbl 0x8023c7(%eax),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fb:	ff d0                	call   *%eax
}
  8003fd:	83 c4 3c             	add    $0x3c,%esp
  800400:	5b                   	pop    %ebx
  800401:	5e                   	pop    %esi
  800402:	5f                   	pop    %edi
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800408:	83 fa 01             	cmp    $0x1,%edx
  80040b:	7e 0e                	jle    80041b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80040d:	8b 10                	mov    (%eax),%edx
  80040f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800412:	89 08                	mov    %ecx,(%eax)
  800414:	8b 02                	mov    (%edx),%eax
  800416:	8b 52 04             	mov    0x4(%edx),%edx
  800419:	eb 22                	jmp    80043d <getuint+0x38>
	else if (lflag)
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 10                	je     80042f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80041f:	8b 10                	mov    (%eax),%edx
  800421:	8d 4a 04             	lea    0x4(%edx),%ecx
  800424:	89 08                	mov    %ecx,(%eax)
  800426:	8b 02                	mov    (%edx),%eax
  800428:	ba 00 00 00 00       	mov    $0x0,%edx
  80042d:	eb 0e                	jmp    80043d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80042f:	8b 10                	mov    (%eax),%edx
  800431:	8d 4a 04             	lea    0x4(%edx),%ecx
  800434:	89 08                	mov    %ecx,(%eax)
  800436:	8b 02                	mov    (%edx),%eax
  800438:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    

0080043f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800445:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	3b 50 04             	cmp    0x4(%eax),%edx
  80044e:	73 0a                	jae    80045a <sprintputch+0x1b>
		*b->buf++ = ch;
  800450:	8d 4a 01             	lea    0x1(%edx),%ecx
  800453:	89 08                	mov    %ecx,(%eax)
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	88 02                	mov    %al,(%edx)
}
  80045a:	5d                   	pop    %ebp
  80045b:	c3                   	ret    

0080045c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800462:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800469:	8b 45 10             	mov    0x10(%ebp),%eax
  80046c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	89 44 24 04          	mov    %eax,0x4(%esp)
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	89 04 24             	mov    %eax,(%esp)
  80047d:	e8 02 00 00 00       	call   800484 <vprintfmt>
	va_end(ap);
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	57                   	push   %edi
  800488:	56                   	push   %esi
  800489:	53                   	push   %ebx
  80048a:	83 ec 3c             	sub    $0x3c,%esp
  80048d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800490:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800493:	eb 18                	jmp    8004ad <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800495:	85 c0                	test   %eax,%eax
  800497:	0f 84 c3 03 00 00    	je     800860 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80049d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004a1:	89 04 24             	mov    %eax,(%esp)
  8004a4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a7:	89 f3                	mov    %esi,%ebx
  8004a9:	eb 02                	jmp    8004ad <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8004ab:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ad:	8d 73 01             	lea    0x1(%ebx),%esi
  8004b0:	0f b6 03             	movzbl (%ebx),%eax
  8004b3:	83 f8 25             	cmp    $0x25,%eax
  8004b6:	75 dd                	jne    800495 <vprintfmt+0x11>
  8004b8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8004bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004c3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1d                	jmp    8004f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004da:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8004de:	eb 15                	jmp    8004f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004e2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8004e6:	eb 0d                	jmp    8004f5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ee:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004f8:	0f b6 06             	movzbl (%esi),%eax
  8004fb:	0f b6 c8             	movzbl %al,%ecx
  8004fe:	83 e8 23             	sub    $0x23,%eax
  800501:	3c 55                	cmp    $0x55,%al
  800503:	0f 87 2f 03 00 00    	ja     800838 <vprintfmt+0x3b4>
  800509:	0f b6 c0             	movzbl %al,%eax
  80050c:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800513:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800516:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800519:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80051d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800520:	83 f9 09             	cmp    $0x9,%ecx
  800523:	77 50                	ja     800575 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800525:	89 de                	mov    %ebx,%esi
  800527:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80052d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800530:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800534:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800537:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80053a:	83 fb 09             	cmp    $0x9,%ebx
  80053d:	76 eb                	jbe    80052a <vprintfmt+0xa6>
  80053f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800542:	eb 33                	jmp    800577 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 48 04             	lea    0x4(%eax),%ecx
  80054a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800554:	eb 21                	jmp    800577 <vprintfmt+0xf3>
  800556:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800559:	85 c9                	test   %ecx,%ecx
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
  800560:	0f 49 c1             	cmovns %ecx,%eax
  800563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
  800568:	eb 8b                	jmp    8004f5 <vprintfmt+0x71>
  80056a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80056c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800573:	eb 80                	jmp    8004f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800575:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057b:	0f 89 74 ff ff ff    	jns    8004f5 <vprintfmt+0x71>
  800581:	e9 62 ff ff ff       	jmp    8004e8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800586:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800589:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80058b:	e9 65 ff ff ff       	jmp    8004f5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 50 04             	lea    0x4(%eax),%edx
  800596:	89 55 14             	mov    %edx,0x14(%ebp)
  800599:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 04 24             	mov    %eax,(%esp)
  8005a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a5:	e9 03 ff ff ff       	jmp    8004ad <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 50 04             	lea    0x4(%eax),%edx
  8005b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	99                   	cltd   
  8005b6:	31 d0                	xor    %edx,%eax
  8005b8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ba:	83 f8 0f             	cmp    $0xf,%eax
  8005bd:	7f 0b                	jg     8005ca <vprintfmt+0x146>
  8005bf:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	75 20                	jne    8005ea <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8005ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ce:	c7 44 24 08 df 23 80 	movl   $0x8023df,0x8(%esp)
  8005d5:	00 
  8005d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	89 04 24             	mov    %eax,(%esp)
  8005e0:	e8 77 fe ff ff       	call   80045c <printfmt>
  8005e5:	e9 c3 fe ff ff       	jmp    8004ad <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8005ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ee:	c7 44 24 08 82 27 80 	movl   $0x802782,0x8(%esp)
  8005f5:	00 
  8005f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 04 24             	mov    %eax,(%esp)
  800600:	e8 57 fe ff ff       	call   80045c <printfmt>
  800605:	e9 a3 fe ff ff       	jmp    8004ad <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80060d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	89 55 14             	mov    %edx,0x14(%ebp)
  800619:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80061b:	85 c0                	test   %eax,%eax
  80061d:	ba d8 23 80 00       	mov    $0x8023d8,%edx
  800622:	0f 45 d0             	cmovne %eax,%edx
  800625:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800628:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80062c:	74 04                	je     800632 <vprintfmt+0x1ae>
  80062e:	85 f6                	test   %esi,%esi
  800630:	7f 19                	jg     80064b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800632:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800635:	8d 70 01             	lea    0x1(%eax),%esi
  800638:	0f b6 10             	movzbl (%eax),%edx
  80063b:	0f be c2             	movsbl %dl,%eax
  80063e:	85 c0                	test   %eax,%eax
  800640:	0f 85 95 00 00 00    	jne    8006db <vprintfmt+0x257>
  800646:	e9 85 00 00 00       	jmp    8006d0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80064f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800652:	89 04 24             	mov    %eax,(%esp)
  800655:	e8 b8 02 00 00       	call   800912 <strnlen>
  80065a:	29 c6                	sub    %eax,%esi
  80065c:	89 f0                	mov    %esi,%eax
  80065e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800661:	85 f6                	test   %esi,%esi
  800663:	7e cd                	jle    800632 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800665:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800669:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80066c:	89 c3                	mov    %eax,%ebx
  80066e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800672:	89 34 24             	mov    %esi,(%esp)
  800675:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800678:	83 eb 01             	sub    $0x1,%ebx
  80067b:	75 f1                	jne    80066e <vprintfmt+0x1ea>
  80067d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800680:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800683:	eb ad                	jmp    800632 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800685:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800689:	74 1e                	je     8006a9 <vprintfmt+0x225>
  80068b:	0f be d2             	movsbl %dl,%edx
  80068e:	83 ea 20             	sub    $0x20,%edx
  800691:	83 fa 5e             	cmp    $0x5e,%edx
  800694:	76 13                	jbe    8006a9 <vprintfmt+0x225>
					putch('?', putdat);
  800696:	8b 45 0c             	mov    0xc(%ebp),%eax
  800699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006a4:	ff 55 08             	call   *0x8(%ebp)
  8006a7:	eb 0d                	jmp    8006b6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8006a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b6:	83 ef 01             	sub    $0x1,%edi
  8006b9:	83 c6 01             	add    $0x1,%esi
  8006bc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006c0:	0f be c2             	movsbl %dl,%eax
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	75 20                	jne    8006e7 <vprintfmt+0x263>
  8006c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d4:	7f 25                	jg     8006fb <vprintfmt+0x277>
  8006d6:	e9 d2 fd ff ff       	jmp    8004ad <vprintfmt+0x29>
  8006db:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006e1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e7:	85 db                	test   %ebx,%ebx
  8006e9:	78 9a                	js     800685 <vprintfmt+0x201>
  8006eb:	83 eb 01             	sub    $0x1,%ebx
  8006ee:	79 95                	jns    800685 <vprintfmt+0x201>
  8006f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8006f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006f9:	eb d5                	jmp    8006d0 <vprintfmt+0x24c>
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800701:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800708:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80070f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800711:	83 eb 01             	sub    $0x1,%ebx
  800714:	75 ee                	jne    800704 <vprintfmt+0x280>
  800716:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800719:	e9 8f fd ff ff       	jmp    8004ad <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80071e:	83 fa 01             	cmp    $0x1,%edx
  800721:	7e 16                	jle    800739 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	89 55 14             	mov    %edx,0x14(%ebp)
  80072c:	8b 50 04             	mov    0x4(%eax),%edx
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800737:	eb 32                	jmp    80076b <vprintfmt+0x2e7>
	else if (lflag)
  800739:	85 d2                	test   %edx,%edx
  80073b:	74 18                	je     800755 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 50 04             	lea    0x4(%eax),%edx
  800743:	89 55 14             	mov    %edx,0x14(%ebp)
  800746:	8b 30                	mov    (%eax),%esi
  800748:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80074b:	89 f0                	mov    %esi,%eax
  80074d:	c1 f8 1f             	sar    $0x1f,%eax
  800750:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800753:	eb 16                	jmp    80076b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 50 04             	lea    0x4(%eax),%edx
  80075b:	89 55 14             	mov    %edx,0x14(%ebp)
  80075e:	8b 30                	mov    (%eax),%esi
  800760:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800763:	89 f0                	mov    %esi,%eax
  800765:	c1 f8 1f             	sar    $0x1f,%eax
  800768:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80076e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800771:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800776:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077a:	0f 89 80 00 00 00    	jns    800800 <vprintfmt+0x37c>
				putch('-', putdat);
  800780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800784:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80078e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800791:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800794:	f7 d8                	neg    %eax
  800796:	83 d2 00             	adc    $0x0,%edx
  800799:	f7 da                	neg    %edx
			}
			base = 10;
  80079b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007a0:	eb 5e                	jmp    800800 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a5:	e8 5b fc ff ff       	call   800405 <getuint>
			base = 10;
  8007aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007af:	eb 4f                	jmp    800800 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	e8 4c fc ff ff       	call   800405 <getuint>
			base = 8;
  8007b9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007be:	eb 40                	jmp    800800 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007cb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007d9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8d 50 04             	lea    0x4(%eax),%edx
  8007e2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ec:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007f1:	eb 0d                	jmp    800800 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f6:	e8 0a fc ff ff       	call   800405 <getuint>
			base = 16;
  8007fb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800800:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800804:	89 74 24 10          	mov    %esi,0x10(%esp)
  800808:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80080b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80080f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800813:	89 04 24             	mov    %eax,(%esp)
  800816:	89 54 24 04          	mov    %edx,0x4(%esp)
  80081a:	89 fa                	mov    %edi,%edx
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	e8 ec fa ff ff       	call   800310 <printnum>
			break;
  800824:	e9 84 fc ff ff       	jmp    8004ad <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800829:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082d:	89 0c 24             	mov    %ecx,(%esp)
  800830:	ff 55 08             	call   *0x8(%ebp)
			break;
  800833:	e9 75 fc ff ff       	jmp    8004ad <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800838:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800843:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800846:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80084a:	0f 84 5b fc ff ff    	je     8004ab <vprintfmt+0x27>
  800850:	89 f3                	mov    %esi,%ebx
  800852:	83 eb 01             	sub    $0x1,%ebx
  800855:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800859:	75 f7                	jne    800852 <vprintfmt+0x3ce>
  80085b:	e9 4d fc ff ff       	jmp    8004ad <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800860:	83 c4 3c             	add    $0x3c,%esp
  800863:	5b                   	pop    %ebx
  800864:	5e                   	pop    %esi
  800865:	5f                   	pop    %edi
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 28             	sub    $0x28,%esp
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800874:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800877:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80087e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800885:	85 c0                	test   %eax,%eax
  800887:	74 30                	je     8008b9 <vsnprintf+0x51>
  800889:	85 d2                	test   %edx,%edx
  80088b:	7e 2c                	jle    8008b9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800894:	8b 45 10             	mov    0x10(%ebp),%eax
  800897:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	c7 04 24 3f 04 80 00 	movl   $0x80043f,(%esp)
  8008a9:	e8 d6 fb ff ff       	call   800484 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b7:	eb 05                	jmp    8008be <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 04 24             	mov    %eax,(%esp)
  8008e1:	e8 82 ff ff ff       	call   800868 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    
  8008e8:	66 90                	xchg   %ax,%ax
  8008ea:	66 90                	xchg   %ax,%ax
  8008ec:	66 90                	xchg   %ax,%ax
  8008ee:	66 90                	xchg   %ax,%ax

008008f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008f9:	74 10                	je     80090b <strlen+0x1b>
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800900:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	75 f7                	jne    800900 <strlen+0x10>
  800909:	eb 05                	jmp    800910 <strlen+0x20>
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091c:	85 c9                	test   %ecx,%ecx
  80091e:	74 1c                	je     80093c <strnlen+0x2a>
  800920:	80 3b 00             	cmpb   $0x0,(%ebx)
  800923:	74 1e                	je     800943 <strnlen+0x31>
  800925:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80092a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092c:	39 ca                	cmp    %ecx,%edx
  80092e:	74 18                	je     800948 <strnlen+0x36>
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800938:	75 f0                	jne    80092a <strnlen+0x18>
  80093a:	eb 0c                	jmp    800948 <strnlen+0x36>
  80093c:	b8 00 00 00 00       	mov    $0x0,%eax
  800941:	eb 05                	jmp    800948 <strnlen+0x36>
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800955:	89 c2                	mov    %eax,%edx
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	83 c1 01             	add    $0x1,%ecx
  80095d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800961:	88 5a ff             	mov    %bl,-0x1(%edx)
  800964:	84 db                	test   %bl,%bl
  800966:	75 ef                	jne    800957 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800975:	89 1c 24             	mov    %ebx,(%esp)
  800978:	e8 73 ff ff ff       	call   8008f0 <strlen>
	strcpy(dst + len, src);
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	89 54 24 04          	mov    %edx,0x4(%esp)
  800984:	01 d8                	add    %ebx,%eax
  800986:	89 04 24             	mov    %eax,(%esp)
  800989:	e8 bd ff ff ff       	call   80094b <strcpy>
	return dst;
}
  80098e:	89 d8                	mov    %ebx,%eax
  800990:	83 c4 08             	add    $0x8,%esp
  800993:	5b                   	pop    %ebx
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 75 08             	mov    0x8(%ebp),%esi
  80099e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a4:	85 db                	test   %ebx,%ebx
  8009a6:	74 17                	je     8009bf <strncpy+0x29>
  8009a8:	01 f3                	add    %esi,%ebx
  8009aa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8009ac:	83 c1 01             	add    $0x1,%ecx
  8009af:	0f b6 02             	movzbl (%edx),%eax
  8009b2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b5:	80 3a 01             	cmpb   $0x1,(%edx)
  8009b8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bb:	39 d9                	cmp    %ebx,%ecx
  8009bd:	75 ed                	jne    8009ac <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009bf:	89 f0                	mov    %esi,%eax
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	57                   	push   %edi
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d1:	8b 75 10             	mov    0x10(%ebp),%esi
  8009d4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d6:	85 f6                	test   %esi,%esi
  8009d8:	74 34                	je     800a0e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8009da:	83 fe 01             	cmp    $0x1,%esi
  8009dd:	74 26                	je     800a05 <strlcpy+0x40>
  8009df:	0f b6 0b             	movzbl (%ebx),%ecx
  8009e2:	84 c9                	test   %cl,%cl
  8009e4:	74 23                	je     800a09 <strlcpy+0x44>
  8009e6:	83 ee 02             	sub    $0x2,%esi
  8009e9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f4:	39 f2                	cmp    %esi,%edx
  8009f6:	74 13                	je     800a0b <strlcpy+0x46>
  8009f8:	83 c2 01             	add    $0x1,%edx
  8009fb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ff:	84 c9                	test   %cl,%cl
  800a01:	75 eb                	jne    8009ee <strlcpy+0x29>
  800a03:	eb 06                	jmp    800a0b <strlcpy+0x46>
  800a05:	89 f8                	mov    %edi,%eax
  800a07:	eb 02                	jmp    800a0b <strlcpy+0x46>
  800a09:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0e:	29 f8                	sub    %edi,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5f                   	pop    %edi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1e:	0f b6 01             	movzbl (%ecx),%eax
  800a21:	84 c0                	test   %al,%al
  800a23:	74 15                	je     800a3a <strcmp+0x25>
  800a25:	3a 02                	cmp    (%edx),%al
  800a27:	75 11                	jne    800a3a <strcmp+0x25>
		p++, q++;
  800a29:	83 c1 01             	add    $0x1,%ecx
  800a2c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a2f:	0f b6 01             	movzbl (%ecx),%eax
  800a32:	84 c0                	test   %al,%al
  800a34:	74 04                	je     800a3a <strcmp+0x25>
  800a36:	3a 02                	cmp    (%edx),%al
  800a38:	74 ef                	je     800a29 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3a:	0f b6 c0             	movzbl %al,%eax
  800a3d:	0f b6 12             	movzbl (%edx),%edx
  800a40:	29 d0                	sub    %edx,%eax
}
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800a52:	85 f6                	test   %esi,%esi
  800a54:	74 29                	je     800a7f <strncmp+0x3b>
  800a56:	0f b6 03             	movzbl (%ebx),%eax
  800a59:	84 c0                	test   %al,%al
  800a5b:	74 30                	je     800a8d <strncmp+0x49>
  800a5d:	3a 02                	cmp    (%edx),%al
  800a5f:	75 2c                	jne    800a8d <strncmp+0x49>
  800a61:	8d 43 01             	lea    0x1(%ebx),%eax
  800a64:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800a66:	89 c3                	mov    %eax,%ebx
  800a68:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a6b:	39 f0                	cmp    %esi,%eax
  800a6d:	74 17                	je     800a86 <strncmp+0x42>
  800a6f:	0f b6 08             	movzbl (%eax),%ecx
  800a72:	84 c9                	test   %cl,%cl
  800a74:	74 17                	je     800a8d <strncmp+0x49>
  800a76:	83 c0 01             	add    $0x1,%eax
  800a79:	3a 0a                	cmp    (%edx),%cl
  800a7b:	74 e9                	je     800a66 <strncmp+0x22>
  800a7d:	eb 0e                	jmp    800a8d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	eb 0f                	jmp    800a95 <strncmp+0x51>
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb 08                	jmp    800a95 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8d:	0f b6 03             	movzbl (%ebx),%eax
  800a90:	0f b6 12             	movzbl (%edx),%edx
  800a93:	29 d0                	sub    %edx,%eax
}
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800aa3:	0f b6 18             	movzbl (%eax),%ebx
  800aa6:	84 db                	test   %bl,%bl
  800aa8:	74 1d                	je     800ac7 <strchr+0x2e>
  800aaa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800aac:	38 d3                	cmp    %dl,%bl
  800aae:	75 06                	jne    800ab6 <strchr+0x1d>
  800ab0:	eb 1a                	jmp    800acc <strchr+0x33>
  800ab2:	38 ca                	cmp    %cl,%dl
  800ab4:	74 16                	je     800acc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab6:	83 c0 01             	add    $0x1,%eax
  800ab9:	0f b6 10             	movzbl (%eax),%edx
  800abc:	84 d2                	test   %dl,%dl
  800abe:	75 f2                	jne    800ab2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	eb 05                	jmp    800acc <strchr+0x33>
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ad9:	0f b6 18             	movzbl (%eax),%ebx
  800adc:	84 db                	test   %bl,%bl
  800ade:	74 16                	je     800af6 <strfind+0x27>
  800ae0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ae2:	38 d3                	cmp    %dl,%bl
  800ae4:	75 06                	jne    800aec <strfind+0x1d>
  800ae6:	eb 0e                	jmp    800af6 <strfind+0x27>
  800ae8:	38 ca                	cmp    %cl,%dl
  800aea:	74 0a                	je     800af6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aec:	83 c0 01             	add    $0x1,%eax
  800aef:	0f b6 10             	movzbl (%eax),%edx
  800af2:	84 d2                	test   %dl,%dl
  800af4:	75 f2                	jne    800ae8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800af6:	5b                   	pop    %ebx
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b05:	85 c9                	test   %ecx,%ecx
  800b07:	74 36                	je     800b3f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0f:	75 28                	jne    800b39 <memset+0x40>
  800b11:	f6 c1 03             	test   $0x3,%cl
  800b14:	75 23                	jne    800b39 <memset+0x40>
		c &= 0xFF;
  800b16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1a:	89 d3                	mov    %edx,%ebx
  800b1c:	c1 e3 08             	shl    $0x8,%ebx
  800b1f:	89 d6                	mov    %edx,%esi
  800b21:	c1 e6 18             	shl    $0x18,%esi
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	c1 e0 10             	shl    $0x10,%eax
  800b29:	09 f0                	or     %esi,%eax
  800b2b:	09 c2                	or     %eax,%edx
  800b2d:	89 d0                	mov    %edx,%eax
  800b2f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b34:	fc                   	cld    
  800b35:	f3 ab                	rep stos %eax,%es:(%edi)
  800b37:	eb 06                	jmp    800b3f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	fc                   	cld    
  800b3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3f:	89 f8                	mov    %edi,%eax
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b54:	39 c6                	cmp    %eax,%esi
  800b56:	73 35                	jae    800b8d <memmove+0x47>
  800b58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b5b:	39 d0                	cmp    %edx,%eax
  800b5d:	73 2e                	jae    800b8d <memmove+0x47>
		s += n;
		d += n;
  800b5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6c:	75 13                	jne    800b81 <memmove+0x3b>
  800b6e:	f6 c1 03             	test   $0x3,%cl
  800b71:	75 0e                	jne    800b81 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b73:	83 ef 04             	sub    $0x4,%edi
  800b76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b79:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7c:	fd                   	std    
  800b7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7f:	eb 09                	jmp    800b8a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b81:	83 ef 01             	sub    $0x1,%edi
  800b84:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b87:	fd                   	std    
  800b88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8a:	fc                   	cld    
  800b8b:	eb 1d                	jmp    800baa <memmove+0x64>
  800b8d:	89 f2                	mov    %esi,%edx
  800b8f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b91:	f6 c2 03             	test   $0x3,%dl
  800b94:	75 0f                	jne    800ba5 <memmove+0x5f>
  800b96:	f6 c1 03             	test   $0x3,%cl
  800b99:	75 0a                	jne    800ba5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	fc                   	cld    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 05                	jmp    800baa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 04 24             	mov    %eax,(%esp)
  800bc8:	e8 79 ff ff ff       	call   800b46 <memmove>
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bde:	8d 78 ff             	lea    -0x1(%eax),%edi
  800be1:	85 c0                	test   %eax,%eax
  800be3:	74 36                	je     800c1b <memcmp+0x4c>
		if (*s1 != *s2)
  800be5:	0f b6 03             	movzbl (%ebx),%eax
  800be8:	0f b6 0e             	movzbl (%esi),%ecx
  800beb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf0:	38 c8                	cmp    %cl,%al
  800bf2:	74 1c                	je     800c10 <memcmp+0x41>
  800bf4:	eb 10                	jmp    800c06 <memcmp+0x37>
  800bf6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800bfb:	83 c2 01             	add    $0x1,%edx
  800bfe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c02:	38 c8                	cmp    %cl,%al
  800c04:	74 0a                	je     800c10 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800c06:	0f b6 c0             	movzbl %al,%eax
  800c09:	0f b6 c9             	movzbl %cl,%ecx
  800c0c:	29 c8                	sub    %ecx,%eax
  800c0e:	eb 10                	jmp    800c20 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c10:	39 fa                	cmp    %edi,%edx
  800c12:	75 e2                	jne    800bf6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	eb 05                	jmp    800c20 <memcmp+0x51>
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	53                   	push   %ebx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c34:	39 d0                	cmp    %edx,%eax
  800c36:	73 13                	jae    800c4b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c38:	89 d9                	mov    %ebx,%ecx
  800c3a:	38 18                	cmp    %bl,(%eax)
  800c3c:	75 06                	jne    800c44 <memfind+0x1f>
  800c3e:	eb 0b                	jmp    800c4b <memfind+0x26>
  800c40:	38 08                	cmp    %cl,(%eax)
  800c42:	74 07                	je     800c4b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c44:	83 c0 01             	add    $0x1,%eax
  800c47:	39 d0                	cmp    %edx,%eax
  800c49:	75 f5                	jne    800c40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5a:	0f b6 0a             	movzbl (%edx),%ecx
  800c5d:	80 f9 09             	cmp    $0x9,%cl
  800c60:	74 05                	je     800c67 <strtol+0x19>
  800c62:	80 f9 20             	cmp    $0x20,%cl
  800c65:	75 10                	jne    800c77 <strtol+0x29>
		s++;
  800c67:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6a:	0f b6 0a             	movzbl (%edx),%ecx
  800c6d:	80 f9 09             	cmp    $0x9,%cl
  800c70:	74 f5                	je     800c67 <strtol+0x19>
  800c72:	80 f9 20             	cmp    $0x20,%cl
  800c75:	74 f0                	je     800c67 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c77:	80 f9 2b             	cmp    $0x2b,%cl
  800c7a:	75 0a                	jne    800c86 <strtol+0x38>
		s++;
  800c7c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c84:	eb 11                	jmp    800c97 <strtol+0x49>
  800c86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c8b:	80 f9 2d             	cmp    $0x2d,%cl
  800c8e:	75 07                	jne    800c97 <strtol+0x49>
		s++, neg = 1;
  800c90:	83 c2 01             	add    $0x1,%edx
  800c93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c9c:	75 15                	jne    800cb3 <strtol+0x65>
  800c9e:	80 3a 30             	cmpb   $0x30,(%edx)
  800ca1:	75 10                	jne    800cb3 <strtol+0x65>
  800ca3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ca7:	75 0a                	jne    800cb3 <strtol+0x65>
		s += 2, base = 16;
  800ca9:	83 c2 02             	add    $0x2,%edx
  800cac:	b8 10 00 00 00       	mov    $0x10,%eax
  800cb1:	eb 10                	jmp    800cc3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	75 0c                	jne    800cc3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cb7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb9:	80 3a 30             	cmpb   $0x30,(%edx)
  800cbc:	75 05                	jne    800cc3 <strtol+0x75>
		s++, base = 8;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800cc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ccb:	0f b6 0a             	movzbl (%edx),%ecx
  800cce:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cd1:	89 f0                	mov    %esi,%eax
  800cd3:	3c 09                	cmp    $0x9,%al
  800cd5:	77 08                	ja     800cdf <strtol+0x91>
			dig = *s - '0';
  800cd7:	0f be c9             	movsbl %cl,%ecx
  800cda:	83 e9 30             	sub    $0x30,%ecx
  800cdd:	eb 20                	jmp    800cff <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800cdf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800ce2:	89 f0                	mov    %esi,%eax
  800ce4:	3c 19                	cmp    $0x19,%al
  800ce6:	77 08                	ja     800cf0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800ce8:	0f be c9             	movsbl %cl,%ecx
  800ceb:	83 e9 57             	sub    $0x57,%ecx
  800cee:	eb 0f                	jmp    800cff <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800cf0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cf3:	89 f0                	mov    %esi,%eax
  800cf5:	3c 19                	cmp    $0x19,%al
  800cf7:	77 16                	ja     800d0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf9:	0f be c9             	movsbl %cl,%ecx
  800cfc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cff:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d02:	7d 0f                	jge    800d13 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d04:	83 c2 01             	add    $0x1,%edx
  800d07:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d0b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d0d:	eb bc                	jmp    800ccb <strtol+0x7d>
  800d0f:	89 d8                	mov    %ebx,%eax
  800d11:	eb 02                	jmp    800d15 <strtol+0xc7>
  800d13:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d19:	74 05                	je     800d20 <strtol+0xd2>
		*endptr = (char *) s;
  800d1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d1e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d20:	f7 d8                	neg    %eax
  800d22:	85 ff                	test   %edi,%edi
  800d24:	0f 44 c3             	cmove  %ebx,%eax
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	89 c3                	mov    %eax,%ebx
  800d3f:	89 c7                	mov    %eax,%edi
  800d41:	89 c6                	mov    %eax,%esi
  800d43:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 01 00 00 00       	mov    $0x1,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d77:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	89 cb                	mov    %ecx,%ebx
  800d81:	89 cf                	mov    %ecx,%edi
  800d83:	89 ce                	mov    %ecx,%esi
  800d85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7e 28                	jle    800db3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d96:	00 
  800d97:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800d9e:	00 
  800d9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800da6:	00 
  800da7:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800dae:	e8 49 f4 ff ff       	call   8001fc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800db3:	83 c4 2c             	add    $0x2c,%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dcb:	89 d1                	mov    %edx,%ecx
  800dcd:	89 d3                	mov    %edx,%ebx
  800dcf:	89 d7                	mov    %edx,%edi
  800dd1:	89 d6                	mov    %edx,%esi
  800dd3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <sys_yield>:

void
sys_yield(void)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dea:	89 d1                	mov    %edx,%ecx
  800dec:	89 d3                	mov    %edx,%ebx
  800dee:	89 d7                	mov    %edx,%edi
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e02:	be 00 00 00 00       	mov    $0x0,%esi
  800e07:	b8 04 00 00 00       	mov    $0x4,%eax
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e15:	89 f7                	mov    %esi,%edi
  800e17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7e 28                	jle    800e45 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e21:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e28:	00 
  800e29:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800e30:	00 
  800e31:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e38:	00 
  800e39:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800e40:	e8 b7 f3 ff ff       	call   8001fc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e45:	83 c4 2c             	add    $0x2c,%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e56:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e67:	8b 75 18             	mov    0x18(%ebp),%esi
  800e6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7e 28                	jle    800e98 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e74:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800e83:	00 
  800e84:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e8b:	00 
  800e8c:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800e93:	e8 64 f3 ff ff       	call   8001fc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e98:	83 c4 2c             	add    $0x2c,%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7e 28                	jle    800eeb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ece:	00 
  800ecf:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ede:	00 
  800edf:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800ee6:	e8 11 f3 ff ff       	call   8001fc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eeb:	83 c4 2c             	add    $0x2c,%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f01:	b8 08 00 00 00       	mov    $0x8,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	89 de                	mov    %ebx,%esi
  800f10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7e 28                	jle    800f3e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f21:	00 
  800f22:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800f29:	00 
  800f2a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f31:	00 
  800f32:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800f39:	e8 be f2 ff ff       	call   8001fc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f3e:	83 c4 2c             	add    $0x2c,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f54:	b8 09 00 00 00       	mov    $0x9,%eax
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	89 de                	mov    %ebx,%esi
  800f63:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	7e 28                	jle    800f91 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f74:	00 
  800f75:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800f7c:	00 
  800f7d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f84:	00 
  800f85:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800f8c:	e8 6b f2 ff ff       	call   8001fc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f91:	83 c4 2c             	add    $0x2c,%esp
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
  800f9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	89 df                	mov    %ebx,%edi
  800fb4:	89 de                	mov    %ebx,%esi
  800fb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	7e 28                	jle    800fe4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fc7:	00 
  800fc8:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  800fcf:	00 
  800fd0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fd7:	00 
  800fd8:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800fdf:	e8 18 f2 ff ff       	call   8001fc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fe4:	83 c4 2c             	add    $0x2c,%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	be 00 00 00 00       	mov    $0x0,%esi
  800ff7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801005:	8b 7d 14             	mov    0x14(%ebp),%edi
  801008:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801018:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801022:	8b 55 08             	mov    0x8(%ebp),%edx
  801025:	89 cb                	mov    %ecx,%ebx
  801027:	89 cf                	mov    %ecx,%edi
  801029:	89 ce                	mov    %ecx,%esi
  80102b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102d:	85 c0                	test   %eax,%eax
  80102f:	7e 28                	jle    801059 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	89 44 24 10          	mov    %eax,0x10(%esp)
  801035:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80103c:	00 
  80103d:	c7 44 24 08 bf 26 80 	movl   $0x8026bf,0x8(%esp)
  801044:	00 
  801045:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80104c:	00 
  80104d:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  801054:	e8 a3 f1 ff ff       	call   8001fc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801059:	83 c4 2c             	add    $0x2c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
  801061:	66 90                	xchg   %ax,%ax
  801063:	66 90                	xchg   %ax,%ax
  801065:	66 90                	xchg   %ax,%ax
  801067:	66 90                	xchg   %ax,%ax
  801069:	66 90                	xchg   %ax,%ax
  80106b:	66 90                	xchg   %ax,%ax
  80106d:	66 90                	xchg   %ax,%ax
  80106f:	90                   	nop

00801070 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
  80107b:	c1 e8 0c             	shr    $0xc,%eax
}
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80108b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801090:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80109a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80109f:	a8 01                	test   $0x1,%al
  8010a1:	74 34                	je     8010d7 <fd_alloc+0x40>
  8010a3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010a8:	a8 01                	test   $0x1,%al
  8010aa:	74 32                	je     8010de <fd_alloc+0x47>
  8010ac:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010b1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	c1 ea 16             	shr    $0x16,%edx
  8010b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	74 1f                	je     8010e3 <fd_alloc+0x4c>
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	c1 ea 0c             	shr    $0xc,%edx
  8010c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d0:	f6 c2 01             	test   $0x1,%dl
  8010d3:	75 1a                	jne    8010ef <fd_alloc+0x58>
  8010d5:	eb 0c                	jmp    8010e3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010d7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8010dc:	eb 05                	jmp    8010e3 <fd_alloc+0x4c>
  8010de:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ed:	eb 1a                	jmp    801109 <fd_alloc+0x72>
  8010ef:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010f4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010f9:	75 b6                	jne    8010b1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801104:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801111:	83 f8 1f             	cmp    $0x1f,%eax
  801114:	77 36                	ja     80114c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801116:	c1 e0 0c             	shl    $0xc,%eax
  801119:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80111e:	89 c2                	mov    %eax,%edx
  801120:	c1 ea 16             	shr    $0x16,%edx
  801123:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80112a:	f6 c2 01             	test   $0x1,%dl
  80112d:	74 24                	je     801153 <fd_lookup+0x48>
  80112f:	89 c2                	mov    %eax,%edx
  801131:	c1 ea 0c             	shr    $0xc,%edx
  801134:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80113b:	f6 c2 01             	test   $0x1,%dl
  80113e:	74 1a                	je     80115a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801140:	8b 55 0c             	mov    0xc(%ebp),%edx
  801143:	89 02                	mov    %eax,(%edx)
	return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 13                	jmp    80115f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80114c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801151:	eb 0c                	jmp    80115f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801158:	eb 05                	jmp    80115f <fd_lookup+0x54>
  80115a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	53                   	push   %ebx
  801165:	83 ec 14             	sub    $0x14,%esp
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80116e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801174:	75 1e                	jne    801194 <dev_lookup+0x33>
  801176:	eb 0e                	jmp    801186 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801178:	b8 20 30 80 00       	mov    $0x803020,%eax
  80117d:	eb 0c                	jmp    80118b <dev_lookup+0x2a>
  80117f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801184:	eb 05                	jmp    80118b <dev_lookup+0x2a>
  801186:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80118b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	eb 38                	jmp    8011cc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801194:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80119a:	74 dc                	je     801178 <dev_lookup+0x17>
  80119c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8011a2:	74 db                	je     80117f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011a4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8011aa:	8b 52 48             	mov    0x48(%edx),%edx
  8011ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011b5:	c7 04 24 ec 26 80 00 	movl   $0x8026ec,(%esp)
  8011bc:	e8 34 f1 ff ff       	call   8002f5 <cprintf>
	*dev = 0;
  8011c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011cc:	83 c4 14             	add    $0x14,%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	56                   	push   %esi
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 20             	sub    $0x20,%esp
  8011da:	8b 75 08             	mov    0x8(%ebp),%esi
  8011dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011ed:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f0:	89 04 24             	mov    %eax,(%esp)
  8011f3:	e8 13 ff ff ff       	call   80110b <fd_lookup>
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 05                	js     801201 <fd_close+0x2f>
	    || fd != fd2)
  8011fc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011ff:	74 0c                	je     80120d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801201:	84 db                	test   %bl,%bl
  801203:	ba 00 00 00 00       	mov    $0x0,%edx
  801208:	0f 44 c2             	cmove  %edx,%eax
  80120b:	eb 3f                	jmp    80124c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801210:	89 44 24 04          	mov    %eax,0x4(%esp)
  801214:	8b 06                	mov    (%esi),%eax
  801216:	89 04 24             	mov    %eax,(%esp)
  801219:	e8 43 ff ff ff       	call   801161 <dev_lookup>
  80121e:	89 c3                	mov    %eax,%ebx
  801220:	85 c0                	test   %eax,%eax
  801222:	78 16                	js     80123a <fd_close+0x68>
		if (dev->dev_close)
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801227:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80122a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80122f:	85 c0                	test   %eax,%eax
  801231:	74 07                	je     80123a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801233:	89 34 24             	mov    %esi,(%esp)
  801236:	ff d0                	call   *%eax
  801238:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80123a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80123e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801245:	e8 56 fc ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  80124a:	89 d8                	mov    %ebx,%eax
}
  80124c:	83 c4 20             	add    $0x20,%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801259:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 04 24             	mov    %eax,(%esp)
  801266:	e8 a0 fe ff ff       	call   80110b <fd_lookup>
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	85 d2                	test   %edx,%edx
  80126f:	78 13                	js     801284 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801271:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801278:	00 
  801279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127c:	89 04 24             	mov    %eax,(%esp)
  80127f:	e8 4e ff ff ff       	call   8011d2 <fd_close>
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <close_all>:

void
close_all(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	53                   	push   %ebx
  80128a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801292:	89 1c 24             	mov    %ebx,(%esp)
  801295:	e8 b9 ff ff ff       	call   801253 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80129a:	83 c3 01             	add    $0x1,%ebx
  80129d:	83 fb 20             	cmp    $0x20,%ebx
  8012a0:	75 f0                	jne    801292 <close_all+0xc>
		close(i);
}
  8012a2:	83 c4 14             	add    $0x14,%esp
  8012a5:	5b                   	pop    %ebx
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	89 04 24             	mov    %eax,(%esp)
  8012be:	e8 48 fe ff ff       	call   80110b <fd_lookup>
  8012c3:	89 c2                	mov    %eax,%edx
  8012c5:	85 d2                	test   %edx,%edx
  8012c7:	0f 88 e1 00 00 00    	js     8013ae <dup+0x106>
		return r;
	close(newfdnum);
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	89 04 24             	mov    %eax,(%esp)
  8012d3:	e8 7b ff ff ff       	call   801253 <close>

	newfd = INDEX2FD(newfdnum);
  8012d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012db:	c1 e3 0c             	shl    $0xc,%ebx
  8012de:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e7:	89 04 24             	mov    %eax,(%esp)
  8012ea:	e8 91 fd ff ff       	call   801080 <fd2data>
  8012ef:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012f1:	89 1c 24             	mov    %ebx,(%esp)
  8012f4:	e8 87 fd ff ff       	call   801080 <fd2data>
  8012f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012fb:	89 f0                	mov    %esi,%eax
  8012fd:	c1 e8 16             	shr    $0x16,%eax
  801300:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801307:	a8 01                	test   $0x1,%al
  801309:	74 43                	je     80134e <dup+0xa6>
  80130b:	89 f0                	mov    %esi,%eax
  80130d:	c1 e8 0c             	shr    $0xc,%eax
  801310:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801317:	f6 c2 01             	test   $0x1,%dl
  80131a:	74 32                	je     80134e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80131c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801323:	25 07 0e 00 00       	and    $0xe07,%eax
  801328:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801330:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801337:	00 
  801338:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801343:	e8 05 fb ff ff       	call   800e4d <sys_page_map>
  801348:	89 c6                	mov    %eax,%esi
  80134a:	85 c0                	test   %eax,%eax
  80134c:	78 3e                	js     80138c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	c1 ea 0c             	shr    $0xc,%edx
  801356:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80135d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801363:	89 54 24 10          	mov    %edx,0x10(%esp)
  801367:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80136b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801372:	00 
  801373:	89 44 24 04          	mov    %eax,0x4(%esp)
  801377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80137e:	e8 ca fa ff ff       	call   800e4d <sys_page_map>
  801383:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801388:	85 f6                	test   %esi,%esi
  80138a:	79 22                	jns    8013ae <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80138c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801397:	e8 04 fb ff ff       	call   800ea0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80139c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 f4 fa ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  8013ac:	89 f0                	mov    %esi,%eax
}
  8013ae:	83 c4 3c             	add    $0x3c,%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    

008013b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	53                   	push   %ebx
  8013ba:	83 ec 24             	sub    $0x24,%esp
  8013bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c7:	89 1c 24             	mov    %ebx,(%esp)
  8013ca:	e8 3c fd ff ff       	call   80110b <fd_lookup>
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	85 d2                	test   %edx,%edx
  8013d3:	78 6d                	js     801442 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	89 04 24             	mov    %eax,(%esp)
  8013e4:	e8 78 fd ff ff       	call   801161 <dev_lookup>
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	78 55                	js     801442 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	8b 50 08             	mov    0x8(%eax),%edx
  8013f3:	83 e2 03             	and    $0x3,%edx
  8013f6:	83 fa 01             	cmp    $0x1,%edx
  8013f9:	75 23                	jne    80141e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013fb:	a1 20 60 80 00       	mov    0x806020,%eax
  801400:	8b 40 48             	mov    0x48(%eax),%eax
  801403:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140b:	c7 04 24 30 27 80 00 	movl   $0x802730,(%esp)
  801412:	e8 de ee ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141c:	eb 24                	jmp    801442 <read+0x8c>
	}
	if (!dev->dev_read)
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 52 08             	mov    0x8(%edx),%edx
  801424:	85 d2                	test   %edx,%edx
  801426:	74 15                	je     80143d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801428:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80142f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801432:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801436:	89 04 24             	mov    %eax,(%esp)
  801439:	ff d2                	call   *%edx
  80143b:	eb 05                	jmp    801442 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80143d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801442:	83 c4 24             	add    $0x24,%esp
  801445:	5b                   	pop    %ebx
  801446:	5d                   	pop    %ebp
  801447:	c3                   	ret    

00801448 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	57                   	push   %edi
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	83 ec 1c             	sub    $0x1c,%esp
  801451:	8b 7d 08             	mov    0x8(%ebp),%edi
  801454:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801457:	85 f6                	test   %esi,%esi
  801459:	74 33                	je     80148e <readn+0x46>
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
  801460:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801465:	89 f2                	mov    %esi,%edx
  801467:	29 c2                	sub    %eax,%edx
  801469:	89 54 24 08          	mov    %edx,0x8(%esp)
  80146d:	03 45 0c             	add    0xc(%ebp),%eax
  801470:	89 44 24 04          	mov    %eax,0x4(%esp)
  801474:	89 3c 24             	mov    %edi,(%esp)
  801477:	e8 3a ff ff ff       	call   8013b6 <read>
		if (m < 0)
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 1b                	js     80149b <readn+0x53>
			return m;
		if (m == 0)
  801480:	85 c0                	test   %eax,%eax
  801482:	74 11                	je     801495 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801484:	01 c3                	add    %eax,%ebx
  801486:	89 d8                	mov    %ebx,%eax
  801488:	39 f3                	cmp    %esi,%ebx
  80148a:	72 d9                	jb     801465 <readn+0x1d>
  80148c:	eb 0b                	jmp    801499 <readn+0x51>
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	eb 06                	jmp    80149b <readn+0x53>
  801495:	89 d8                	mov    %ebx,%eax
  801497:	eb 02                	jmp    80149b <readn+0x53>
  801499:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80149b:	83 c4 1c             	add    $0x1c,%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5f                   	pop    %edi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	53                   	push   %ebx
  8014a7:	83 ec 24             	sub    $0x24,%esp
  8014aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b4:	89 1c 24             	mov    %ebx,(%esp)
  8014b7:	e8 4f fc ff ff       	call   80110b <fd_lookup>
  8014bc:	89 c2                	mov    %eax,%edx
  8014be:	85 d2                	test   %edx,%edx
  8014c0:	78 68                	js     80152a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cc:	8b 00                	mov    (%eax),%eax
  8014ce:	89 04 24             	mov    %eax,(%esp)
  8014d1:	e8 8b fc ff ff       	call   801161 <dev_lookup>
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 50                	js     80152a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e1:	75 23                	jne    801506 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014e3:	a1 20 60 80 00       	mov    0x806020,%eax
  8014e8:	8b 40 48             	mov    0x48(%eax),%eax
  8014eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f3:	c7 04 24 4c 27 80 00 	movl   $0x80274c,(%esp)
  8014fa:	e8 f6 ed ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  8014ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801504:	eb 24                	jmp    80152a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801506:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801509:	8b 52 0c             	mov    0xc(%edx),%edx
  80150c:	85 d2                	test   %edx,%edx
  80150e:	74 15                	je     801525 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801510:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801513:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80151e:	89 04 24             	mov    %eax,(%esp)
  801521:	ff d2                	call   *%edx
  801523:	eb 05                	jmp    80152a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801525:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80152a:	83 c4 24             	add    $0x24,%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <seek>:

int
seek(int fdnum, off_t offset)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801536:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 04 24             	mov    %eax,(%esp)
  801543:	e8 c3 fb ff ff       	call   80110b <fd_lookup>
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 0e                	js     80155a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	53                   	push   %ebx
  801560:	83 ec 24             	sub    $0x24,%esp
  801563:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801566:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156d:	89 1c 24             	mov    %ebx,(%esp)
  801570:	e8 96 fb ff ff       	call   80110b <fd_lookup>
  801575:	89 c2                	mov    %eax,%edx
  801577:	85 d2                	test   %edx,%edx
  801579:	78 61                	js     8015dc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 d2 fb ff ff       	call   801161 <dev_lookup>
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 49                	js     8015dc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159a:	75 23                	jne    8015bf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80159c:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a1:	8b 40 48             	mov    0x48(%eax),%eax
  8015a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ac:	c7 04 24 0c 27 80 00 	movl   $0x80270c,(%esp)
  8015b3:	e8 3d ed ff ff       	call   8002f5 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bd:	eb 1d                	jmp    8015dc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	8b 52 18             	mov    0x18(%edx),%edx
  8015c5:	85 d2                	test   %edx,%edx
  8015c7:	74 0e                	je     8015d7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015d0:	89 04 24             	mov    %eax,(%esp)
  8015d3:	ff d2                	call   *%edx
  8015d5:	eb 05                	jmp    8015dc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015dc:	83 c4 24             	add    $0x24,%esp
  8015df:	5b                   	pop    %ebx
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    

008015e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 24             	sub    $0x24,%esp
  8015e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	89 04 24             	mov    %eax,(%esp)
  8015f9:	e8 0d fb ff ff       	call   80110b <fd_lookup>
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	85 d2                	test   %edx,%edx
  801602:	78 52                	js     801656 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	89 04 24             	mov    %eax,(%esp)
  801613:	e8 49 fb ff ff       	call   801161 <dev_lookup>
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 3a                	js     801656 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801623:	74 2c                	je     801651 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801625:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801628:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162f:	00 00 00 
	stat->st_isdir = 0;
  801632:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801639:	00 00 00 
	stat->st_dev = dev;
  80163c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801642:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	89 14 24             	mov    %edx,(%esp)
  80164c:	ff 50 14             	call   *0x14(%eax)
  80164f:	eb 05                	jmp    801656 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801651:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801656:	83 c4 24             	add    $0x24,%esp
  801659:	5b                   	pop    %ebx
  80165a:	5d                   	pop    %ebp
  80165b:	c3                   	ret    

0080165c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
  801661:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801664:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80166b:	00 
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	89 04 24             	mov    %eax,(%esp)
  801672:	e8 af 01 00 00       	call   801826 <open>
  801677:	89 c3                	mov    %eax,%ebx
  801679:	85 db                	test   %ebx,%ebx
  80167b:	78 1b                	js     801698 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 44 24 04          	mov    %eax,0x4(%esp)
  801684:	89 1c 24             	mov    %ebx,(%esp)
  801687:	e8 56 ff ff ff       	call   8015e2 <fstat>
  80168c:	89 c6                	mov    %eax,%esi
	close(fd);
  80168e:	89 1c 24             	mov    %ebx,(%esp)
  801691:	e8 bd fb ff ff       	call   801253 <close>
	return r;
  801696:	89 f0                	mov    %esi,%eax
}
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 10             	sub    $0x10,%esp
  8016a7:	89 c6                	mov    %eax,%esi
  8016a9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b2:	75 11                	jne    8016c5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016bb:	e8 66 09 00 00       	call   802026 <ipc_find_env>
  8016c0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016cc:	00 
  8016cd:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8016d4:	00 
  8016d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016d9:	a1 00 40 80 00       	mov    0x804000,%eax
  8016de:	89 04 24             	mov    %eax,(%esp)
  8016e1:	e8 da 08 00 00       	call   801fc0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ed:	00 
  8016ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f9:	e8 58 08 00 00       	call   801f56 <ipc_recv>
}
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	53                   	push   %ebx
  801709:	83 ec 14             	sub    $0x14,%esp
  80170c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 05 00 00 00       	mov    $0x5,%eax
  801724:	e8 76 ff ff ff       	call   80169f <fsipc>
  801729:	89 c2                	mov    %eax,%edx
  80172b:	85 d2                	test   %edx,%edx
  80172d:	78 2b                	js     80175a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80172f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801736:	00 
  801737:	89 1c 24             	mov    %ebx,(%esp)
  80173a:	e8 0c f2 ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80173f:	a1 80 70 80 00       	mov    0x807080,%eax
  801744:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80174a:	a1 84 70 80 00       	mov    0x807084,%eax
  80174f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	83 c4 14             	add    $0x14,%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8b 40 0c             	mov    0xc(%eax),%eax
  80176c:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 06 00 00 00       	mov    $0x6,%eax
  80177b:	e8 1f ff ff ff       	call   80169f <fsipc>
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 10             	sub    $0x10,%esp
  80178a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8b 40 0c             	mov    0xc(%eax),%eax
  801793:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801798:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	e8 f2 fe ff ff       	call   80169f <fsipc>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 6a                	js     80181d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017b3:	39 c6                	cmp    %eax,%esi
  8017b5:	73 24                	jae    8017db <devfile_read+0x59>
  8017b7:	c7 44 24 0c 69 27 80 	movl   $0x802769,0xc(%esp)
  8017be:	00 
  8017bf:	c7 44 24 08 70 27 80 	movl   $0x802770,0x8(%esp)
  8017c6:	00 
  8017c7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8017ce:	00 
  8017cf:	c7 04 24 85 27 80 00 	movl   $0x802785,(%esp)
  8017d6:	e8 21 ea ff ff       	call   8001fc <_panic>
	assert(r <= PGSIZE);
  8017db:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e0:	7e 24                	jle    801806 <devfile_read+0x84>
  8017e2:	c7 44 24 0c 90 27 80 	movl   $0x802790,0xc(%esp)
  8017e9:	00 
  8017ea:	c7 44 24 08 70 27 80 	movl   $0x802770,0x8(%esp)
  8017f1:	00 
  8017f2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8017f9:	00 
  8017fa:	c7 04 24 85 27 80 00 	movl   $0x802785,(%esp)
  801801:	e8 f6 e9 ff ff       	call   8001fc <_panic>
	memmove(buf, &fsipcbuf, r);
  801806:	89 44 24 08          	mov    %eax,0x8(%esp)
  80180a:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801811:	00 
  801812:	8b 45 0c             	mov    0xc(%ebp),%eax
  801815:	89 04 24             	mov    %eax,(%esp)
  801818:	e8 29 f3 ff ff       	call   800b46 <memmove>
	return r;
}
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 24             	sub    $0x24,%esp
  80182d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801830:	89 1c 24             	mov    %ebx,(%esp)
  801833:	e8 b8 f0 ff ff       	call   8008f0 <strlen>
  801838:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80183d:	7f 60                	jg     80189f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80183f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 4d f8 ff ff       	call   801097 <fd_alloc>
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	85 d2                	test   %edx,%edx
  80184e:	78 54                	js     8018a4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801850:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801854:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  80185b:	e8 eb f0 ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186b:	b8 01 00 00 00       	mov    $0x1,%eax
  801870:	e8 2a fe ff ff       	call   80169f <fsipc>
  801875:	89 c3                	mov    %eax,%ebx
  801877:	85 c0                	test   %eax,%eax
  801879:	79 17                	jns    801892 <open+0x6c>
		fd_close(fd, 0);
  80187b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801882:	00 
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	89 04 24             	mov    %eax,(%esp)
  801889:	e8 44 f9 ff ff       	call   8011d2 <fd_close>
		return r;
  80188e:	89 d8                	mov    %ebx,%eax
  801890:	eb 12                	jmp    8018a4 <open+0x7e>
	}

	return fd2num(fd);
  801892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 d3 f7 ff ff       	call   801070 <fd2num>
  80189d:	eb 05                	jmp    8018a4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80189f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018a4:	83 c4 24             	add    $0x24,%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 14             	sub    $0x14,%esp
  8018b1:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8018b3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018b7:	7e 31                	jle    8018ea <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018b9:	8b 40 04             	mov    0x4(%eax),%eax
  8018bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c0:	8d 43 10             	lea    0x10(%ebx),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	8b 03                	mov    (%ebx),%eax
  8018c9:	89 04 24             	mov    %eax,(%esp)
  8018cc:	e8 d2 fb ff ff       	call   8014a3 <write>
		if (result > 0)
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	7e 03                	jle    8018d8 <writebuf+0x2e>
			b->result += result;
  8018d5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8018d8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018db:	74 0d                	je     8018ea <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	0f 4f c2             	cmovg  %edx,%eax
  8018e7:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8018ea:	83 c4 14             	add    $0x14,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <putch>:

static void
putch(int ch, void *thunk)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018fa:	8b 53 04             	mov    0x4(%ebx),%edx
  8018fd:	8d 42 01             	lea    0x1(%edx),%eax
  801900:	89 43 04             	mov    %eax,0x4(%ebx)
  801903:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801906:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80190a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80190f:	75 0e                	jne    80191f <putch+0x2f>
		writebuf(b);
  801911:	89 d8                	mov    %ebx,%eax
  801913:	e8 92 ff ff ff       	call   8018aa <writebuf>
		b->idx = 0;
  801918:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  80191f:	83 c4 04             	add    $0x4,%esp
  801922:	5b                   	pop    %ebx
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801937:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80193e:	00 00 00 
	b.result = 0;
  801941:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801948:	00 00 00 
	b.error = 1;
  80194b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801952:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80195c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801963:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196d:	c7 04 24 f0 18 80 00 	movl   $0x8018f0,(%esp)
  801974:	e8 0b eb ff ff       	call   800484 <vprintfmt>
	if (b.idx > 0)
  801979:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801980:	7e 0b                	jle    80198d <vfprintf+0x68>
		writebuf(&b);
  801982:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801988:	e8 1d ff ff ff       	call   8018aa <writebuf>

	return (b.result ? b.result : b.error);
  80198d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801993:	85 c0                	test   %eax,%eax
  801995:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019a4:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	e8 68 ff ff ff       	call   801925 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <printf>:

int
printf(const char *fmt, ...)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019da:	e8 46 ff ff ff       	call   801925 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    
  8019e1:	66 90                	xchg   %ax,%ax
  8019e3:	66 90                	xchg   %ax,%ax
  8019e5:	66 90                	xchg   %ax,%ax
  8019e7:	66 90                	xchg   %ax,%ax
  8019e9:	66 90                	xchg   %ax,%ax
  8019eb:	66 90                	xchg   %ax,%ax
  8019ed:	66 90                	xchg   %ax,%ax
  8019ef:	90                   	nop

008019f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	56                   	push   %esi
  8019f4:	53                   	push   %ebx
  8019f5:	83 ec 10             	sub    $0x10,%esp
  8019f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 7a f6 ff ff       	call   801080 <fd2data>
  801a06:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a08:	c7 44 24 04 9c 27 80 	movl   $0x80279c,0x4(%esp)
  801a0f:	00 
  801a10:	89 1c 24             	mov    %ebx,(%esp)
  801a13:	e8 33 ef ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a18:	8b 46 04             	mov    0x4(%esi),%eax
  801a1b:	2b 06                	sub    (%esi),%eax
  801a1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a2a:	00 00 00 
	stat->st_dev = &devpipe;
  801a2d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a34:	30 80 00 
	return 0;
}
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	53                   	push   %ebx
  801a47:	83 ec 14             	sub    $0x14,%esp
  801a4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a58:	e8 43 f4 ff ff       	call   800ea0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a5d:	89 1c 24             	mov    %ebx,(%esp)
  801a60:	e8 1b f6 ff ff       	call   801080 <fd2data>
  801a65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a70:	e8 2b f4 ff ff       	call   800ea0 <sys_page_unmap>
}
  801a75:	83 c4 14             	add    $0x14,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    

00801a7b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	57                   	push   %edi
  801a7f:	56                   	push   %esi
  801a80:	53                   	push   %ebx
  801a81:	83 ec 2c             	sub    $0x2c,%esp
  801a84:	89 c6                	mov    %eax,%esi
  801a86:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801a89:	a1 20 60 80 00       	mov    0x806020,%eax
  801a8e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a91:	89 34 24             	mov    %esi,(%esp)
  801a94:	e8 d5 05 00 00       	call   80206e <pageref>
  801a99:	89 c7                	mov    %eax,%edi
  801a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a9e:	89 04 24             	mov    %eax,(%esp)
  801aa1:	e8 c8 05 00 00       	call   80206e <pageref>
  801aa6:	39 c7                	cmp    %eax,%edi
  801aa8:	0f 94 c2             	sete   %dl
  801aab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801aae:	8b 0d 20 60 80 00    	mov    0x806020,%ecx
  801ab4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801ab7:	39 fb                	cmp    %edi,%ebx
  801ab9:	74 21                	je     801adc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801abb:	84 d2                	test   %dl,%dl
  801abd:	74 ca                	je     801a89 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801abf:	8b 51 58             	mov    0x58(%ecx),%edx
  801ac2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801aca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ace:	c7 04 24 a3 27 80 00 	movl   $0x8027a3,(%esp)
  801ad5:	e8 1b e8 ff ff       	call   8002f5 <cprintf>
  801ada:	eb ad                	jmp    801a89 <_pipeisclosed+0xe>
	}
}
  801adc:	83 c4 2c             	add    $0x2c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	57                   	push   %edi
  801ae8:	56                   	push   %esi
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 1c             	sub    $0x1c,%esp
  801aed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801af0:	89 34 24             	mov    %esi,(%esp)
  801af3:	e8 88 f5 ff ff       	call   801080 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801af8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801afc:	74 61                	je     801b5f <devpipe_write+0x7b>
  801afe:	89 c3                	mov    %eax,%ebx
  801b00:	bf 00 00 00 00       	mov    $0x0,%edi
  801b05:	eb 4a                	jmp    801b51 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b07:	89 da                	mov    %ebx,%edx
  801b09:	89 f0                	mov    %esi,%eax
  801b0b:	e8 6b ff ff ff       	call   801a7b <_pipeisclosed>
  801b10:	85 c0                	test   %eax,%eax
  801b12:	75 54                	jne    801b68 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b14:	e8 c1 f2 ff ff       	call   800dda <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b19:	8b 43 04             	mov    0x4(%ebx),%eax
  801b1c:	8b 0b                	mov    (%ebx),%ecx
  801b1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801b21:	39 d0                	cmp    %edx,%eax
  801b23:	73 e2                	jae    801b07 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b28:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b2c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b2f:	99                   	cltd   
  801b30:	c1 ea 1b             	shr    $0x1b,%edx
  801b33:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801b36:	83 e1 1f             	and    $0x1f,%ecx
  801b39:	29 d1                	sub    %edx,%ecx
  801b3b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801b3f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801b43:	83 c0 01             	add    $0x1,%eax
  801b46:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b49:	83 c7 01             	add    $0x1,%edi
  801b4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b4f:	74 13                	je     801b64 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b51:	8b 43 04             	mov    0x4(%ebx),%eax
  801b54:	8b 0b                	mov    (%ebx),%ecx
  801b56:	8d 51 20             	lea    0x20(%ecx),%edx
  801b59:	39 d0                	cmp    %edx,%eax
  801b5b:	73 aa                	jae    801b07 <devpipe_write+0x23>
  801b5d:	eb c6                	jmp    801b25 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b5f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b64:	89 f8                	mov    %edi,%eax
  801b66:	eb 05                	jmp    801b6d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b68:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801b6d:	83 c4 1c             	add    $0x1c,%esp
  801b70:	5b                   	pop    %ebx
  801b71:	5e                   	pop    %esi
  801b72:	5f                   	pop    %edi
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	57                   	push   %edi
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 1c             	sub    $0x1c,%esp
  801b7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801b81:	89 3c 24             	mov    %edi,(%esp)
  801b84:	e8 f7 f4 ff ff       	call   801080 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b8d:	74 54                	je     801be3 <devpipe_read+0x6e>
  801b8f:	89 c3                	mov    %eax,%ebx
  801b91:	be 00 00 00 00       	mov    $0x0,%esi
  801b96:	eb 3e                	jmp    801bd6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801b98:	89 f0                	mov    %esi,%eax
  801b9a:	eb 55                	jmp    801bf1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801b9c:	89 da                	mov    %ebx,%edx
  801b9e:	89 f8                	mov    %edi,%eax
  801ba0:	e8 d6 fe ff ff       	call   801a7b <_pipeisclosed>
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	75 43                	jne    801bec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ba9:	e8 2c f2 ff ff       	call   800dda <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801bae:	8b 03                	mov    (%ebx),%eax
  801bb0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bb3:	74 e7                	je     801b9c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bb5:	99                   	cltd   
  801bb6:	c1 ea 1b             	shr    $0x1b,%edx
  801bb9:	01 d0                	add    %edx,%eax
  801bbb:	83 e0 1f             	and    $0x1f,%eax
  801bbe:	29 d0                	sub    %edx,%eax
  801bc0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bcb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bce:	83 c6 01             	add    $0x1,%esi
  801bd1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bd4:	74 12                	je     801be8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801bd6:	8b 03                	mov    (%ebx),%eax
  801bd8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bdb:	75 d8                	jne    801bb5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801bdd:	85 f6                	test   %esi,%esi
  801bdf:	75 b7                	jne    801b98 <devpipe_read+0x23>
  801be1:	eb b9                	jmp    801b9c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801be3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801be8:	89 f0                	mov    %esi,%eax
  801bea:	eb 05                	jmp    801bf1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801bf1:	83 c4 1c             	add    $0x1c,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5f                   	pop    %edi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 8b f4 ff ff       	call   801097 <fd_alloc>
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	85 d2                	test   %edx,%edx
  801c10:	0f 88 4d 01 00 00    	js     801d63 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c1d:	00 
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2c:	e8 c8 f1 ff ff       	call   800df9 <sys_page_alloc>
  801c31:	89 c2                	mov    %eax,%edx
  801c33:	85 d2                	test   %edx,%edx
  801c35:	0f 88 28 01 00 00    	js     801d63 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3e:	89 04 24             	mov    %eax,(%esp)
  801c41:	e8 51 f4 ff ff       	call   801097 <fd_alloc>
  801c46:	89 c3                	mov    %eax,%ebx
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	0f 88 fe 00 00 00    	js     801d4e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c50:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c57:	00 
  801c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c66:	e8 8e f1 ff ff       	call   800df9 <sys_page_alloc>
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	0f 88 d9 00 00 00    	js     801d4e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	89 04 24             	mov    %eax,(%esp)
  801c7b:	e8 00 f4 ff ff       	call   801080 <fd2data>
  801c80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c89:	00 
  801c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c95:	e8 5f f1 ff ff       	call   800df9 <sys_page_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	0f 88 97 00 00 00    	js     801d3b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca7:	89 04 24             	mov    %eax,(%esp)
  801caa:	e8 d1 f3 ff ff       	call   801080 <fd2data>
  801caf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801cb6:	00 
  801cb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cc2:	00 
  801cc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cce:	e8 7a f1 ff ff       	call   800e4d <sys_page_map>
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	78 52                	js     801d2b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801cd9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	89 04 24             	mov    %eax,(%esp)
  801d09:	e8 62 f3 ff ff       	call   801070 <fd2num>
  801d0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d11:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	89 04 24             	mov    %eax,(%esp)
  801d19:	e8 52 f3 ff ff       	call   801070 <fd2num>
  801d1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d21:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	eb 38                	jmp    801d63 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801d2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d36:	e8 65 f1 ff ff       	call   800ea0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d49:	e8 52 f1 ff ff       	call   800ea0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d5c:	e8 3f f1 ff ff       	call   800ea0 <sys_page_unmap>
  801d61:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801d63:	83 c4 30             	add    $0x30,%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	89 04 24             	mov    %eax,(%esp)
  801d7d:	e8 89 f3 ff ff       	call   80110b <fd_lookup>
  801d82:	89 c2                	mov    %eax,%edx
  801d84:	85 d2                	test   %edx,%edx
  801d86:	78 15                	js     801d9d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	89 04 24             	mov    %eax,(%esp)
  801d8e:	e8 ed f2 ff ff       	call   801080 <fd2data>
	return _pipeisclosed(fd, p);
  801d93:	89 c2                	mov    %eax,%edx
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	e8 de fc ff ff       	call   801a7b <_pipeisclosed>
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    
  801d9f:	90                   	nop

00801da0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801db0:	c7 44 24 04 bb 27 80 	movl   $0x8027bb,0x4(%esp)
  801db7:	00 
  801db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 88 eb ff ff       	call   80094b <strcpy>
	return 0;
}
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	57                   	push   %edi
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dda:	74 4a                	je     801e26 <devcons_write+0x5c>
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  801de1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801de6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801dec:	8b 75 10             	mov    0x10(%ebp),%esi
  801def:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801df1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801df4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801df9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801dfc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801e00:	03 45 0c             	add    0xc(%ebp),%eax
  801e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e07:	89 3c 24             	mov    %edi,(%esp)
  801e0a:	e8 37 ed ff ff       	call   800b46 <memmove>
		sys_cputs(buf, m);
  801e0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e13:	89 3c 24             	mov    %edi,(%esp)
  801e16:	e8 11 ef ff ff       	call   800d2c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e1b:	01 f3                	add    %esi,%ebx
  801e1d:	89 d8                	mov    %ebx,%eax
  801e1f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801e22:	72 c8                	jb     801dec <devcons_write+0x22>
  801e24:	eb 05                	jmp    801e2b <devcons_write+0x61>
  801e26:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e2b:	89 d8                	mov    %ebx,%eax
  801e2d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    

00801e38 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e47:	75 07                	jne    801e50 <devcons_read+0x18>
  801e49:	eb 28                	jmp    801e73 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e4b:	e8 8a ef ff ff       	call   800dda <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e50:	e8 f5 ee ff ff       	call   800d4a <sys_cgetc>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	74 f2                	je     801e4b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 16                	js     801e73 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e5d:	83 f8 04             	cmp    $0x4,%eax
  801e60:	74 0c                	je     801e6e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	88 02                	mov    %al,(%edx)
	return 1;
  801e67:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6c:	eb 05                	jmp    801e73 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e88:	00 
  801e89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8c:	89 04 24             	mov    %eax,(%esp)
  801e8f:	e8 98 ee ff ff       	call   800d2c <sys_cputs>
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <getchar>:

int
getchar(void)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ea3:	00 
  801ea4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb2:	e8 ff f4 ff ff       	call   8013b6 <read>
	if (r < 0)
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 0f                	js     801eca <getchar+0x34>
		return r;
	if (r < 1)
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	7e 06                	jle    801ec5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801ebf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801ec3:	eb 05                	jmp    801eca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801ec5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	89 04 24             	mov    %eax,(%esp)
  801edf:	e8 27 f2 ff ff       	call   80110b <fd_lookup>
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 11                	js     801ef9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ef1:	39 10                	cmp    %edx,(%eax)
  801ef3:	0f 94 c0             	sete   %al
  801ef6:	0f b6 c0             	movzbl %al,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <opencons>:

int
opencons(void)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f04:	89 04 24             	mov    %eax,(%esp)
  801f07:	e8 8b f1 ff ff       	call   801097 <fd_alloc>
		return r;
  801f0c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 40                	js     801f52 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f19:	00 
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f28:	e8 cc ee ff ff       	call   800df9 <sys_page_alloc>
		return r;
  801f2d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 1f                	js     801f52 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f33:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f48:	89 04 24             	mov    %eax,(%esp)
  801f4b:	e8 20 f1 ff ff       	call   801070 <fd2num>
  801f50:	89 c2                	mov    %eax,%edx
}
  801f52:	89 d0                	mov    %edx,%eax
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	56                   	push   %esi
  801f5a:	53                   	push   %ebx
  801f5b:	83 ec 10             	sub    $0x10,%esp
  801f5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801f67:	83 f8 01             	cmp    $0x1,%eax
  801f6a:	19 c0                	sbb    %eax,%eax
  801f6c:	f7 d0                	not    %eax
  801f6e:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801f73:	89 04 24             	mov    %eax,(%esp)
  801f76:	e8 94 f0 ff ff       	call   80100f <sys_ipc_recv>
	if (err_code < 0) {
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	79 16                	jns    801f95 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801f7f:	85 f6                	test   %esi,%esi
  801f81:	74 06                	je     801f89 <ipc_recv+0x33>
  801f83:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801f89:	85 db                	test   %ebx,%ebx
  801f8b:	74 2c                	je     801fb9 <ipc_recv+0x63>
  801f8d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801f93:	eb 24                	jmp    801fb9 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801f95:	85 f6                	test   %esi,%esi
  801f97:	74 0a                	je     801fa3 <ipc_recv+0x4d>
  801f99:	a1 20 60 80 00       	mov    0x806020,%eax
  801f9e:	8b 40 74             	mov    0x74(%eax),%eax
  801fa1:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801fa3:	85 db                	test   %ebx,%ebx
  801fa5:	74 0a                	je     801fb1 <ipc_recv+0x5b>
  801fa7:	a1 20 60 80 00       	mov    0x806020,%eax
  801fac:	8b 40 78             	mov    0x78(%eax),%eax
  801faf:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801fb1:	a1 20 60 80 00       	mov    0x806020,%eax
  801fb6:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	5b                   	pop    %ebx
  801fbd:	5e                   	pop    %esi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    

00801fc0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	57                   	push   %edi
  801fc4:	56                   	push   %esi
  801fc5:	53                   	push   %ebx
  801fc6:	83 ec 1c             	sub    $0x1c,%esp
  801fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801fd2:	eb 25                	jmp    801ff9 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801fd4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fd7:	74 20                	je     801ff9 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801fd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fdd:	c7 44 24 08 c7 27 80 	movl   $0x8027c7,0x8(%esp)
  801fe4:	00 
  801fe5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801fec:	00 
  801fed:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  801ff4:	e8 03 e2 ff ff       	call   8001fc <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ff9:	85 db                	test   %ebx,%ebx
  801ffb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802000:	0f 45 c3             	cmovne %ebx,%eax
  802003:	8b 55 14             	mov    0x14(%ebp),%edx
  802006:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80200a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802012:	89 3c 24             	mov    %edi,(%esp)
  802015:	e8 d2 ef ff ff       	call   800fec <sys_ipc_try_send>
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 b6                	jne    801fd4 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80201e:	83 c4 1c             	add    $0x1c,%esp
  802021:	5b                   	pop    %ebx
  802022:	5e                   	pop    %esi
  802023:	5f                   	pop    %edi
  802024:	5d                   	pop    %ebp
  802025:	c3                   	ret    

00802026 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80202c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802031:	39 c8                	cmp    %ecx,%eax
  802033:	74 17                	je     80204c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802035:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  80203a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80203d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802043:	8b 52 50             	mov    0x50(%edx),%edx
  802046:	39 ca                	cmp    %ecx,%edx
  802048:	75 14                	jne    80205e <ipc_find_env+0x38>
  80204a:	eb 05                	jmp    802051 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802051:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802054:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802059:	8b 40 40             	mov    0x40(%eax),%eax
  80205c:	eb 0e                	jmp    80206c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80205e:	83 c0 01             	add    $0x1,%eax
  802061:	3d 00 04 00 00       	cmp    $0x400,%eax
  802066:	75 d2                	jne    80203a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802068:	66 b8 00 00          	mov    $0x0,%ax
}
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802074:	89 d0                	mov    %edx,%eax
  802076:	c1 e8 16             	shr    $0x16,%eax
  802079:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802085:	f6 c1 01             	test   $0x1,%cl
  802088:	74 1d                	je     8020a7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80208a:	c1 ea 0c             	shr    $0xc,%edx
  80208d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802094:	f6 c2 01             	test   $0x1,%dl
  802097:	74 0e                	je     8020a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802099:	c1 ea 0c             	shr    $0xc,%edx
  80209c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020a3:	ef 
  8020a4:	0f b7 c0             	movzwl %ax,%eax
}
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
  8020a9:	66 90                	xchg   %ax,%ax
  8020ab:	66 90                	xchg   %ax,%ax
  8020ad:	66 90                	xchg   %ax,%ax
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8020ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8020be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8020c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020cc:	89 ea                	mov    %ebp,%edx
  8020ce:	89 0c 24             	mov    %ecx,(%esp)
  8020d1:	75 2d                	jne    802100 <__udivdi3+0x50>
  8020d3:	39 e9                	cmp    %ebp,%ecx
  8020d5:	77 61                	ja     802138 <__udivdi3+0x88>
  8020d7:	85 c9                	test   %ecx,%ecx
  8020d9:	89 ce                	mov    %ecx,%esi
  8020db:	75 0b                	jne    8020e8 <__udivdi3+0x38>
  8020dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e2:	31 d2                	xor    %edx,%edx
  8020e4:	f7 f1                	div    %ecx
  8020e6:	89 c6                	mov    %eax,%esi
  8020e8:	31 d2                	xor    %edx,%edx
  8020ea:	89 e8                	mov    %ebp,%eax
  8020ec:	f7 f6                	div    %esi
  8020ee:	89 c5                	mov    %eax,%ebp
  8020f0:	89 f8                	mov    %edi,%eax
  8020f2:	f7 f6                	div    %esi
  8020f4:	89 ea                	mov    %ebp,%edx
  8020f6:	83 c4 0c             	add    $0xc,%esp
  8020f9:	5e                   	pop    %esi
  8020fa:	5f                   	pop    %edi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    
  8020fd:	8d 76 00             	lea    0x0(%esi),%esi
  802100:	39 e8                	cmp    %ebp,%eax
  802102:	77 24                	ja     802128 <__udivdi3+0x78>
  802104:	0f bd e8             	bsr    %eax,%ebp
  802107:	83 f5 1f             	xor    $0x1f,%ebp
  80210a:	75 3c                	jne    802148 <__udivdi3+0x98>
  80210c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802110:	39 34 24             	cmp    %esi,(%esp)
  802113:	0f 86 9f 00 00 00    	jbe    8021b8 <__udivdi3+0x108>
  802119:	39 d0                	cmp    %edx,%eax
  80211b:	0f 82 97 00 00 00    	jb     8021b8 <__udivdi3+0x108>
  802121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802128:	31 d2                	xor    %edx,%edx
  80212a:	31 c0                	xor    %eax,%eax
  80212c:	83 c4 0c             	add    $0xc,%esp
  80212f:	5e                   	pop    %esi
  802130:	5f                   	pop    %edi
  802131:	5d                   	pop    %ebp
  802132:	c3                   	ret    
  802133:	90                   	nop
  802134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802138:	89 f8                	mov    %edi,%eax
  80213a:	f7 f1                	div    %ecx
  80213c:	31 d2                	xor    %edx,%edx
  80213e:	83 c4 0c             	add    $0xc,%esp
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	89 e9                	mov    %ebp,%ecx
  80214a:	8b 3c 24             	mov    (%esp),%edi
  80214d:	d3 e0                	shl    %cl,%eax
  80214f:	89 c6                	mov    %eax,%esi
  802151:	b8 20 00 00 00       	mov    $0x20,%eax
  802156:	29 e8                	sub    %ebp,%eax
  802158:	89 c1                	mov    %eax,%ecx
  80215a:	d3 ef                	shr    %cl,%edi
  80215c:	89 e9                	mov    %ebp,%ecx
  80215e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802162:	8b 3c 24             	mov    (%esp),%edi
  802165:	09 74 24 08          	or     %esi,0x8(%esp)
  802169:	89 d6                	mov    %edx,%esi
  80216b:	d3 e7                	shl    %cl,%edi
  80216d:	89 c1                	mov    %eax,%ecx
  80216f:	89 3c 24             	mov    %edi,(%esp)
  802172:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802176:	d3 ee                	shr    %cl,%esi
  802178:	89 e9                	mov    %ebp,%ecx
  80217a:	d3 e2                	shl    %cl,%edx
  80217c:	89 c1                	mov    %eax,%ecx
  80217e:	d3 ef                	shr    %cl,%edi
  802180:	09 d7                	or     %edx,%edi
  802182:	89 f2                	mov    %esi,%edx
  802184:	89 f8                	mov    %edi,%eax
  802186:	f7 74 24 08          	divl   0x8(%esp)
  80218a:	89 d6                	mov    %edx,%esi
  80218c:	89 c7                	mov    %eax,%edi
  80218e:	f7 24 24             	mull   (%esp)
  802191:	39 d6                	cmp    %edx,%esi
  802193:	89 14 24             	mov    %edx,(%esp)
  802196:	72 30                	jb     8021c8 <__udivdi3+0x118>
  802198:	8b 54 24 04          	mov    0x4(%esp),%edx
  80219c:	89 e9                	mov    %ebp,%ecx
  80219e:	d3 e2                	shl    %cl,%edx
  8021a0:	39 c2                	cmp    %eax,%edx
  8021a2:	73 05                	jae    8021a9 <__udivdi3+0xf9>
  8021a4:	3b 34 24             	cmp    (%esp),%esi
  8021a7:	74 1f                	je     8021c8 <__udivdi3+0x118>
  8021a9:	89 f8                	mov    %edi,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	e9 7a ff ff ff       	jmp    80212c <__udivdi3+0x7c>
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	31 d2                	xor    %edx,%edx
  8021ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bf:	e9 68 ff ff ff       	jmp    80212c <__udivdi3+0x7c>
  8021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8021cb:	31 d2                	xor    %edx,%edx
  8021cd:	83 c4 0c             	add    $0xc,%esp
  8021d0:	5e                   	pop    %esi
  8021d1:	5f                   	pop    %edi
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    
  8021d4:	66 90                	xchg   %ax,%ax
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	66 90                	xchg   %ax,%ax
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__umoddi3>:
  8021e0:	55                   	push   %ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	83 ec 14             	sub    $0x14,%esp
  8021e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8021ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8021ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8021f2:	89 c7                	mov    %eax,%edi
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8021fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802200:	89 34 24             	mov    %esi,(%esp)
  802203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802207:	85 c0                	test   %eax,%eax
  802209:	89 c2                	mov    %eax,%edx
  80220b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80220f:	75 17                	jne    802228 <__umoddi3+0x48>
  802211:	39 fe                	cmp    %edi,%esi
  802213:	76 4b                	jbe    802260 <__umoddi3+0x80>
  802215:	89 c8                	mov    %ecx,%eax
  802217:	89 fa                	mov    %edi,%edx
  802219:	f7 f6                	div    %esi
  80221b:	89 d0                	mov    %edx,%eax
  80221d:	31 d2                	xor    %edx,%edx
  80221f:	83 c4 14             	add    $0x14,%esp
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
  802226:	66 90                	xchg   %ax,%ax
  802228:	39 f8                	cmp    %edi,%eax
  80222a:	77 54                	ja     802280 <__umoddi3+0xa0>
  80222c:	0f bd e8             	bsr    %eax,%ebp
  80222f:	83 f5 1f             	xor    $0x1f,%ebp
  802232:	75 5c                	jne    802290 <__umoddi3+0xb0>
  802234:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802238:	39 3c 24             	cmp    %edi,(%esp)
  80223b:	0f 87 e7 00 00 00    	ja     802328 <__umoddi3+0x148>
  802241:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802245:	29 f1                	sub    %esi,%ecx
  802247:	19 c7                	sbb    %eax,%edi
  802249:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80224d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802251:	8b 44 24 08          	mov    0x8(%esp),%eax
  802255:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802259:	83 c4 14             	add    $0x14,%esp
  80225c:	5e                   	pop    %esi
  80225d:	5f                   	pop    %edi
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    
  802260:	85 f6                	test   %esi,%esi
  802262:	89 f5                	mov    %esi,%ebp
  802264:	75 0b                	jne    802271 <__umoddi3+0x91>
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f6                	div    %esi
  80226f:	89 c5                	mov    %eax,%ebp
  802271:	8b 44 24 04          	mov    0x4(%esp),%eax
  802275:	31 d2                	xor    %edx,%edx
  802277:	f7 f5                	div    %ebp
  802279:	89 c8                	mov    %ecx,%eax
  80227b:	f7 f5                	div    %ebp
  80227d:	eb 9c                	jmp    80221b <__umoddi3+0x3b>
  80227f:	90                   	nop
  802280:	89 c8                	mov    %ecx,%eax
  802282:	89 fa                	mov    %edi,%edx
  802284:	83 c4 14             	add    $0x14,%esp
  802287:	5e                   	pop    %esi
  802288:	5f                   	pop    %edi
  802289:	5d                   	pop    %ebp
  80228a:	c3                   	ret    
  80228b:	90                   	nop
  80228c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802290:	8b 04 24             	mov    (%esp),%eax
  802293:	be 20 00 00 00       	mov    $0x20,%esi
  802298:	89 e9                	mov    %ebp,%ecx
  80229a:	29 ee                	sub    %ebp,%esi
  80229c:	d3 e2                	shl    %cl,%edx
  80229e:	89 f1                	mov    %esi,%ecx
  8022a0:	d3 e8                	shr    %cl,%eax
  8022a2:	89 e9                	mov    %ebp,%ecx
  8022a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a8:	8b 04 24             	mov    (%esp),%eax
  8022ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 f1                	mov    %esi,%ecx
  8022b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8022bd:	d3 ea                	shr    %cl,%edx
  8022bf:	89 e9                	mov    %ebp,%ecx
  8022c1:	d3 e7                	shl    %cl,%edi
  8022c3:	89 f1                	mov    %esi,%ecx
  8022c5:	d3 e8                	shr    %cl,%eax
  8022c7:	89 e9                	mov    %ebp,%ecx
  8022c9:	09 f8                	or     %edi,%eax
  8022cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8022cf:	f7 74 24 04          	divl   0x4(%esp)
  8022d3:	d3 e7                	shl    %cl,%edi
  8022d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022d9:	89 d7                	mov    %edx,%edi
  8022db:	f7 64 24 08          	mull   0x8(%esp)
  8022df:	39 d7                	cmp    %edx,%edi
  8022e1:	89 c1                	mov    %eax,%ecx
  8022e3:	89 14 24             	mov    %edx,(%esp)
  8022e6:	72 2c                	jb     802314 <__umoddi3+0x134>
  8022e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8022ec:	72 22                	jb     802310 <__umoddi3+0x130>
  8022ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8022f2:	29 c8                	sub    %ecx,%eax
  8022f4:	19 d7                	sbb    %edx,%edi
  8022f6:	89 e9                	mov    %ebp,%ecx
  8022f8:	89 fa                	mov    %edi,%edx
  8022fa:	d3 e8                	shr    %cl,%eax
  8022fc:	89 f1                	mov    %esi,%ecx
  8022fe:	d3 e2                	shl    %cl,%edx
  802300:	89 e9                	mov    %ebp,%ecx
  802302:	d3 ef                	shr    %cl,%edi
  802304:	09 d0                	or     %edx,%eax
  802306:	89 fa                	mov    %edi,%edx
  802308:	83 c4 14             	add    $0x14,%esp
  80230b:	5e                   	pop    %esi
  80230c:	5f                   	pop    %edi
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    
  80230f:	90                   	nop
  802310:	39 d7                	cmp    %edx,%edi
  802312:	75 da                	jne    8022ee <__umoddi3+0x10e>
  802314:	8b 14 24             	mov    (%esp),%edx
  802317:	89 c1                	mov    %eax,%ecx
  802319:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80231d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802321:	eb cb                	jmp    8022ee <__umoddi3+0x10e>
  802323:	90                   	nop
  802324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802328:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80232c:	0f 82 0f ff ff ff    	jb     802241 <__umoddi3+0x61>
  802332:	e9 1a ff ff ff       	jmp    802251 <__umoddi3+0x71>
