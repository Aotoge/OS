
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 86 01 00 00       	call   8001b7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800049:	e8 4d 09 00 00       	call   80099b <strcpy>
	exit();
  80004e:	e8 dc 01 00 00       	call   80022f <exit>
}
  800053:	c9                   	leave  
  800054:	c3                   	ret    

00800055 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800060:	74 05                	je     800067 <umain+0x12>
		childofspawn();
  800062:	e8 cc ff ff ff       	call   800033 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800067:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800076:	a0 
  800077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007e:	e8 c6 0d 00 00       	call   800e49 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 4c 2d 80 	movl   $0x802d4c,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 5f 2d 80 00 	movl   $0x802d5f,(%esp)
  8000a2:	e8 a1 01 00 00       	call   800248 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 f4 10 00 00       	call   8011a0 <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 73 2d 80 	movl   $0x802d73,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 5f 2d 80 00 	movl   $0x802d5f,(%esp)
  8000cd:	e8 76 01 00 00       	call   800248 <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 b0 08 00 00       	call   80099b <strcpy>
		exit();
  8000eb:	e8 3f 01 00 00       	call   80022f <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 77 25 00 00       	call   80266f <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 58 09 00 00       	call   800a65 <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 40 2d 80 00       	mov    $0x802d40,%eax
  800114:	ba 46 2d 80 00       	mov    $0x802d46,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800127:	e8 15 02 00 00       	call   800341 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 97 2d 80 	movl   $0x802d97,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 9c 2d 80 	movl   $0x802d9c,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 9b 2d 80 00 	movl   $0x802d9b,(%esp)
  80014b:	e8 ce 20 00 00       	call   80221e <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11f>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 a9 2d 80 	movl   $0x802da9,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 5f 2d 80 00 	movl   $0x802d5f,(%esp)
  80016f:	e8 d4 00 00 00       	call   800248 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 f3 24 00 00       	call   80266f <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 00 40 80 00       	mov    0x804000,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 d4 08 00 00       	call   800a65 <strcmp>
  800191:	85 c0                	test   %eax,%eax
  800193:	b8 40 2d 80 00       	mov    $0x802d40,%eax
  800198:	ba 46 2d 80 00       	mov    $0x802d46,%edx
  80019d:	0f 45 c2             	cmovne %edx,%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 b3 2d 80 00 	movl   $0x802db3,(%esp)
  8001ab:	e8 91 01 00 00       	call   800341 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b0:	cc                   	int3   

	breakpoint();
}
  8001b1:	83 c4 14             	add    $0x14,%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 10             	sub    $0x10,%esp
  8001bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8001c5:	e8 41 0c 00 00       	call   800e0b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8001ca:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8001d0:	39 c2                	cmp    %eax,%edx
  8001d2:	74 17                	je     8001eb <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001d4:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8001d9:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8001dc:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8001e2:	8b 49 40             	mov    0x40(%ecx),%ecx
  8001e5:	39 c1                	cmp    %eax,%ecx
  8001e7:	75 18                	jne    800201 <libmain+0x4a>
  8001e9:	eb 05                	jmp    8001f0 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001eb:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8001f0:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8001f3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8001f9:	89 15 04 50 80 00    	mov    %edx,0x805004
			break;
  8001ff:	eb 0b                	jmp    80020c <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800201:	83 c2 01             	add    $0x1,%edx
  800204:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80020a:	75 cd                	jne    8001d9 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020c:	85 db                	test   %ebx,%ebx
  80020e:	7e 07                	jle    800217 <libmain+0x60>
		binaryname = argv[0];
  800210:	8b 06                	mov    (%esi),%eax
  800212:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800217:	89 74 24 04          	mov    %esi,0x4(%esp)
  80021b:	89 1c 24             	mov    %ebx,(%esp)
  80021e:	e8 32 fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  800223:	e8 07 00 00 00       	call   80022f <exit>
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	5b                   	pop    %ebx
  80022c:	5e                   	pop    %esi
  80022d:	5d                   	pop    %ebp
  80022e:	c3                   	ret    

0080022f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800235:	e8 dc 13 00 00       	call   801616 <close_all>
	sys_env_destroy(0);
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 73 0b 00 00       	call   800db9 <sys_env_destroy>
}
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800250:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800253:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800259:	e8 ad 0b 00 00       	call   800e0b <sys_getenvid>
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	89 54 24 10          	mov    %edx,0x10(%esp)
  800265:	8b 55 08             	mov    0x8(%ebp),%edx
  800268:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80026c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800270:	89 44 24 04          	mov    %eax,0x4(%esp)
  800274:	c7 04 24 f8 2d 80 00 	movl   $0x802df8,(%esp)
  80027b:	e8 c1 00 00 00       	call   800341 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800280:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800284:	8b 45 10             	mov    0x10(%ebp),%eax
  800287:	89 04 24             	mov    %eax,(%esp)
  80028a:	e8 51 00 00 00       	call   8002e0 <vcprintf>
	cprintf("\n");
  80028f:	c7 04 24 4e 33 80 00 	movl   $0x80334e,(%esp)
  800296:	e8 a6 00 00 00       	call   800341 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029b:	cc                   	int3   
  80029c:	eb fd                	jmp    80029b <_panic+0x53>

0080029e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 14             	sub    $0x14,%esp
  8002a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a8:	8b 13                	mov    (%ebx),%edx
  8002aa:	8d 42 01             	lea    0x1(%edx),%eax
  8002ad:	89 03                	mov    %eax,(%ebx)
  8002af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bb:	75 19                	jne    8002d6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002bd:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002c4:	00 
  8002c5:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c8:	89 04 24             	mov    %eax,(%esp)
  8002cb:	e8 ac 0a 00 00       	call   800d7c <sys_cputs>
		b->idx = 0;
  8002d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002d6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002da:	83 c4 14             	add    $0x14,%esp
  8002dd:	5b                   	pop    %ebx
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f0:	00 00 00 
	b.cnt = 0;
  8002f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800311:	89 44 24 04          	mov    %eax,0x4(%esp)
  800315:	c7 04 24 9e 02 80 00 	movl   $0x80029e,(%esp)
  80031c:	e8 b3 01 00 00       	call   8004d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800321:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800331:	89 04 24             	mov    %eax,(%esp)
  800334:	e8 43 0a 00 00       	call   800d7c <sys_cputs>

	return b.cnt;
}
  800339:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800347:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 04 24             	mov    %eax,(%esp)
  800354:	e8 87 ff ff ff       	call   8002e0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800359:	c9                   	leave  
  80035a:	c3                   	ret    
  80035b:	66 90                	xchg   %ax,%ax
  80035d:	66 90                	xchg   %ax,%ax
  80035f:	90                   	nop

00800360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 3c             	sub    $0x3c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d7                	mov    %edx,%edi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800374:	8b 75 0c             	mov    0xc(%ebp),%esi
  800377:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80037a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800382:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800385:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800388:	39 f1                	cmp    %esi,%ecx
  80038a:	72 14                	jb     8003a0 <printnum+0x40>
  80038c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80038f:	76 0f                	jbe    8003a0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8d 70 ff             	lea    -0x1(%eax),%esi
  800397:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80039a:	85 f6                	test   %esi,%esi
  80039c:	7f 60                	jg     8003fe <printnum+0x9e>
  80039e:	eb 72                	jmp    800412 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8003aa:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8003ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003b9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003bd:	89 c3                	mov    %eax,%ebx
  8003bf:	89 d6                	mov    %edx,%esi
  8003c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d2:	89 04 24             	mov    %eax,(%esp)
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003dc:	e8 cf 26 00 00       	call   802ab0 <__udivdi3>
  8003e1:	89 d9                	mov    %ebx,%ecx
  8003e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003e7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f2:	89 fa                	mov    %edi,%edx
  8003f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f7:	e8 64 ff ff ff       	call   800360 <printnum>
  8003fc:	eb 14                	jmp    800412 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800402:	8b 45 18             	mov    0x18(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040a:	83 ee 01             	sub    $0x1,%esi
  80040d:	75 ef                	jne    8003fe <printnum+0x9e>
  80040f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800412:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800416:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800420:	89 44 24 08          	mov    %eax,0x8(%esp)
  800424:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	89 04 24             	mov    %eax,(%esp)
  80042e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800431:	89 44 24 04          	mov    %eax,0x4(%esp)
  800435:	e8 a6 27 00 00       	call   802be0 <__umoddi3>
  80043a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043e:	0f be 80 1b 2e 80 00 	movsbl 0x802e1b(%eax),%eax
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	ff d0                	call   *%eax
}
  80044d:	83 c4 3c             	add    $0x3c,%esp
  800450:	5b                   	pop    %ebx
  800451:	5e                   	pop    %esi
  800452:	5f                   	pop    %edi
  800453:	5d                   	pop    %ebp
  800454:	c3                   	ret    

00800455 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800458:	83 fa 01             	cmp    $0x1,%edx
  80045b:	7e 0e                	jle    80046b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80045d:	8b 10                	mov    (%eax),%edx
  80045f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800462:	89 08                	mov    %ecx,(%eax)
  800464:	8b 02                	mov    (%edx),%eax
  800466:	8b 52 04             	mov    0x4(%edx),%edx
  800469:	eb 22                	jmp    80048d <getuint+0x38>
	else if (lflag)
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 10                	je     80047f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80046f:	8b 10                	mov    (%eax),%edx
  800471:	8d 4a 04             	lea    0x4(%edx),%ecx
  800474:	89 08                	mov    %ecx,(%eax)
  800476:	8b 02                	mov    (%edx),%eax
  800478:	ba 00 00 00 00       	mov    $0x0,%edx
  80047d:	eb 0e                	jmp    80048d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80047f:	8b 10                	mov    (%eax),%edx
  800481:	8d 4a 04             	lea    0x4(%edx),%ecx
  800484:	89 08                	mov    %ecx,(%eax)
  800486:	8b 02                	mov    (%edx),%eax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800495:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	3b 50 04             	cmp    0x4(%eax),%edx
  80049e:	73 0a                	jae    8004aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a3:	89 08                	mov    %ecx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	88 02                	mov    %al,(%edx)
}
  8004aa:	5d                   	pop    %ebp
  8004ab:	c3                   	ret    

008004ac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 04 24             	mov    %eax,(%esp)
  8004cd:	e8 02 00 00 00       	call   8004d4 <vprintfmt>
	va_end(ap);
}
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 3c             	sub    $0x3c,%esp
  8004dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004e3:	eb 18                	jmp    8004fd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	0f 84 c3 03 00 00    	je     8008b0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8004ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f1:	89 04 24             	mov    %eax,(%esp)
  8004f4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f7:	89 f3                	mov    %esi,%ebx
  8004f9:	eb 02                	jmp    8004fd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8004fb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004fd:	8d 73 01             	lea    0x1(%ebx),%esi
  800500:	0f b6 03             	movzbl (%ebx),%eax
  800503:	83 f8 25             	cmp    $0x25,%eax
  800506:	75 dd                	jne    8004e5 <vprintfmt+0x11>
  800508:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80050c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800513:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80051a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800521:	ba 00 00 00 00       	mov    $0x0,%edx
  800526:	eb 1d                	jmp    800545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800528:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80052a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80052e:	eb 15                	jmp    800545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800530:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800532:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800536:	eb 0d                	jmp    800545 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8d 5e 01             	lea    0x1(%esi),%ebx
  800548:	0f b6 06             	movzbl (%esi),%eax
  80054b:	0f b6 c8             	movzbl %al,%ecx
  80054e:	83 e8 23             	sub    $0x23,%eax
  800551:	3c 55                	cmp    $0x55,%al
  800553:	0f 87 2f 03 00 00    	ja     800888 <vprintfmt+0x3b4>
  800559:	0f b6 c0             	movzbl %al,%eax
  80055c:	ff 24 85 60 2f 80 00 	jmp    *0x802f60(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800563:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800566:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800569:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80056d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800570:	83 f9 09             	cmp    $0x9,%ecx
  800573:	77 50                	ja     8005c5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800575:	89 de                	mov    %ebx,%esi
  800577:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80057d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800580:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800584:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800587:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80058a:	83 fb 09             	cmp    $0x9,%ebx
  80058d:	76 eb                	jbe    80057a <vprintfmt+0xa6>
  80058f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800592:	eb 33                	jmp    8005c7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 48 04             	lea    0x4(%eax),%ecx
  80059a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005a4:	eb 21                	jmp    8005c7 <vprintfmt+0xf3>
  8005a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b0:	0f 49 c1             	cmovns %ecx,%eax
  8005b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	89 de                	mov    %ebx,%esi
  8005b8:	eb 8b                	jmp    800545 <vprintfmt+0x71>
  8005ba:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005bc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005c3:	eb 80                	jmp    800545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cb:	0f 89 74 ff ff ff    	jns    800545 <vprintfmt+0x71>
  8005d1:	e9 62 ff ff ff       	jmp    800538 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005db:	e9 65 ff ff ff       	jmp    800545 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8d 50 04             	lea    0x4(%eax),%edx
  8005e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005f5:	e9 03 ff ff ff       	jmp    8004fd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 50 04             	lea    0x4(%eax),%edx
  800600:	89 55 14             	mov    %edx,0x14(%ebp)
  800603:	8b 00                	mov    (%eax),%eax
  800605:	99                   	cltd   
  800606:	31 d0                	xor    %edx,%eax
  800608:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80060a:	83 f8 0f             	cmp    $0xf,%eax
  80060d:	7f 0b                	jg     80061a <vprintfmt+0x146>
  80060f:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  800616:	85 d2                	test   %edx,%edx
  800618:	75 20                	jne    80063a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80061a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80061e:	c7 44 24 08 33 2e 80 	movl   $0x802e33,0x8(%esp)
  800625:	00 
  800626:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	89 04 24             	mov    %eax,(%esp)
  800630:	e8 77 fe ff ff       	call   8004ac <printfmt>
  800635:	e9 c3 fe ff ff       	jmp    8004fd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80063a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80063e:	c7 44 24 08 2f 33 80 	movl   $0x80332f,0x8(%esp)
  800645:	00 
  800646:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 04 24             	mov    %eax,(%esp)
  800650:	e8 57 fe ff ff       	call   8004ac <printfmt>
  800655:	e9 a3 fe ff ff       	jmp    8004fd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80065d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 50 04             	lea    0x4(%eax),%edx
  800666:	89 55 14             	mov    %edx,0x14(%ebp)
  800669:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80066b:	85 c0                	test   %eax,%eax
  80066d:	ba 2c 2e 80 00       	mov    $0x802e2c,%edx
  800672:	0f 45 d0             	cmovne %eax,%edx
  800675:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800678:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80067c:	74 04                	je     800682 <vprintfmt+0x1ae>
  80067e:	85 f6                	test   %esi,%esi
  800680:	7f 19                	jg     80069b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800682:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800685:	8d 70 01             	lea    0x1(%eax),%esi
  800688:	0f b6 10             	movzbl (%eax),%edx
  80068b:	0f be c2             	movsbl %dl,%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	0f 85 95 00 00 00    	jne    80072b <vprintfmt+0x257>
  800696:	e9 85 00 00 00       	jmp    800720 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80069f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a2:	89 04 24             	mov    %eax,(%esp)
  8006a5:	e8 b8 02 00 00       	call   800962 <strnlen>
  8006aa:	29 c6                	sub    %eax,%esi
  8006ac:	89 f0                	mov    %esi,%eax
  8006ae:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006b1:	85 f6                	test   %esi,%esi
  8006b3:	7e cd                	jle    800682 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8006b5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8006b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006bc:	89 c3                	mov    %eax,%ebx
  8006be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c2:	89 34 24             	mov    %esi,(%esp)
  8006c5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c8:	83 eb 01             	sub    $0x1,%ebx
  8006cb:	75 f1                	jne    8006be <vprintfmt+0x1ea>
  8006cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8006d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006d3:	eb ad                	jmp    800682 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006d9:	74 1e                	je     8006f9 <vprintfmt+0x225>
  8006db:	0f be d2             	movsbl %dl,%edx
  8006de:	83 ea 20             	sub    $0x20,%edx
  8006e1:	83 fa 5e             	cmp    $0x5e,%edx
  8006e4:	76 13                	jbe    8006f9 <vprintfmt+0x225>
					putch('?', putdat);
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ed:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006f4:	ff 55 08             	call   *0x8(%ebp)
  8006f7:	eb 0d                	jmp    800706 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8006f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800706:	83 ef 01             	sub    $0x1,%edi
  800709:	83 c6 01             	add    $0x1,%esi
  80070c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800710:	0f be c2             	movsbl %dl,%eax
  800713:	85 c0                	test   %eax,%eax
  800715:	75 20                	jne    800737 <vprintfmt+0x263>
  800717:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80071a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80071d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800720:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800724:	7f 25                	jg     80074b <vprintfmt+0x277>
  800726:	e9 d2 fd ff ff       	jmp    8004fd <vprintfmt+0x29>
  80072b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80072e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800731:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800734:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800737:	85 db                	test   %ebx,%ebx
  800739:	78 9a                	js     8006d5 <vprintfmt+0x201>
  80073b:	83 eb 01             	sub    $0x1,%ebx
  80073e:	79 95                	jns    8006d5 <vprintfmt+0x201>
  800740:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800743:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800746:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800749:	eb d5                	jmp    800720 <vprintfmt+0x24c>
  80074b:	8b 75 08             	mov    0x8(%ebp),%esi
  80074e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800751:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800754:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800758:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80075f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800761:	83 eb 01             	sub    $0x1,%ebx
  800764:	75 ee                	jne    800754 <vprintfmt+0x280>
  800766:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800769:	e9 8f fd ff ff       	jmp    8004fd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80076e:	83 fa 01             	cmp    $0x1,%edx
  800771:	7e 16                	jle    800789 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 50 08             	lea    0x8(%eax),%edx
  800779:	89 55 14             	mov    %edx,0x14(%ebp)
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800787:	eb 32                	jmp    8007bb <vprintfmt+0x2e7>
	else if (lflag)
  800789:	85 d2                	test   %edx,%edx
  80078b:	74 18                	je     8007a5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 50 04             	lea    0x4(%eax),%edx
  800793:	89 55 14             	mov    %edx,0x14(%ebp)
  800796:	8b 30                	mov    (%eax),%esi
  800798:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80079b:	89 f0                	mov    %esi,%eax
  80079d:	c1 f8 1f             	sar    $0x1f,%eax
  8007a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007a3:	eb 16                	jmp    8007bb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 50 04             	lea    0x4(%eax),%edx
  8007ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ae:	8b 30                	mov    (%eax),%esi
  8007b0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007b3:	89 f0                	mov    %esi,%eax
  8007b5:	c1 f8 1f             	sar    $0x1f,%eax
  8007b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ca:	0f 89 80 00 00 00    	jns    800850 <vprintfmt+0x37c>
				putch('-', putdat);
  8007d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007db:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
			}
			base = 10;
  8007eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007f0:	eb 5e                	jmp    800850 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f5:	e8 5b fc ff ff       	call   800455 <getuint>
			base = 10;
  8007fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007ff:	eb 4f                	jmp    800850 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800801:	8d 45 14             	lea    0x14(%ebp),%eax
  800804:	e8 4c fc ff ff       	call   800455 <getuint>
			base = 8;
  800809:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80080e:	eb 40                	jmp    800850 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800810:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800814:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80081b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800822:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800829:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8d 50 04             	lea    0x4(%eax),%edx
  800832:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800835:	8b 00                	mov    (%eax),%eax
  800837:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80083c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800841:	eb 0d                	jmp    800850 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	e8 0a fc ff ff       	call   800455 <getuint>
			base = 16;
  80084b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800850:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800854:	89 74 24 10          	mov    %esi,0x10(%esp)
  800858:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80085b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80085f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800863:	89 04 24             	mov    %eax,(%esp)
  800866:	89 54 24 04          	mov    %edx,0x4(%esp)
  80086a:	89 fa                	mov    %edi,%edx
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	e8 ec fa ff ff       	call   800360 <printnum>
			break;
  800874:	e9 84 fc ff ff       	jmp    8004fd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800879:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087d:	89 0c 24             	mov    %ecx,(%esp)
  800880:	ff 55 08             	call   *0x8(%ebp)
			break;
  800883:	e9 75 fc ff ff       	jmp    8004fd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800888:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800893:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800896:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80089a:	0f 84 5b fc ff ff    	je     8004fb <vprintfmt+0x27>
  8008a0:	89 f3                	mov    %esi,%ebx
  8008a2:	83 eb 01             	sub    $0x1,%ebx
  8008a5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008a9:	75 f7                	jne    8008a2 <vprintfmt+0x3ce>
  8008ab:	e9 4d fc ff ff       	jmp    8004fd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8008b0:	83 c4 3c             	add    $0x3c,%esp
  8008b3:	5b                   	pop    %ebx
  8008b4:	5e                   	pop    %esi
  8008b5:	5f                   	pop    %edi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 28             	sub    $0x28,%esp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008cb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d5:	85 c0                	test   %eax,%eax
  8008d7:	74 30                	je     800909 <vsnprintf+0x51>
  8008d9:	85 d2                	test   %edx,%edx
  8008db:	7e 2c                	jle    800909 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f2:	c7 04 24 8f 04 80 00 	movl   $0x80048f,(%esp)
  8008f9:	e8 d6 fb ff ff       	call   8004d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800901:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800907:	eb 05                	jmp    80090e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800909:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800916:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800919:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	89 44 24 08          	mov    %eax,0x8(%esp)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 04 24             	mov    %eax,(%esp)
  800931:	e8 82 ff ff ff       	call   8008b8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    
  800938:	66 90                	xchg   %ax,%ax
  80093a:	66 90                	xchg   %ax,%ax
  80093c:	66 90                	xchg   %ax,%ax
  80093e:	66 90                	xchg   %ax,%ax

00800940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	80 3a 00             	cmpb   $0x0,(%edx)
  800949:	74 10                	je     80095b <strlen+0x1b>
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800950:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800957:	75 f7                	jne    800950 <strlen+0x10>
  800959:	eb 05                	jmp    800960 <strlen+0x20>
  80095b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096c:	85 c9                	test   %ecx,%ecx
  80096e:	74 1c                	je     80098c <strnlen+0x2a>
  800970:	80 3b 00             	cmpb   $0x0,(%ebx)
  800973:	74 1e                	je     800993 <strnlen+0x31>
  800975:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80097a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	39 ca                	cmp    %ecx,%edx
  80097e:	74 18                	je     800998 <strnlen+0x36>
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800988:	75 f0                	jne    80097a <strnlen+0x18>
  80098a:	eb 0c                	jmp    800998 <strnlen+0x36>
  80098c:	b8 00 00 00 00       	mov    $0x0,%eax
  800991:	eb 05                	jmp    800998 <strnlen+0x36>
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800998:	5b                   	pop    %ebx
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	83 c2 01             	add    $0x1,%edx
  8009aa:	83 c1 01             	add    $0x1,%ecx
  8009ad:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009b1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b4:	84 db                	test   %bl,%bl
  8009b6:	75 ef                	jne    8009a7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	53                   	push   %ebx
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c5:	89 1c 24             	mov    %ebx,(%esp)
  8009c8:	e8 73 ff ff ff       	call   800940 <strlen>
	strcpy(dst + len, src);
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009d4:	01 d8                	add    %ebx,%eax
  8009d6:	89 04 24             	mov    %eax,(%esp)
  8009d9:	e8 bd ff ff ff       	call   80099b <strcpy>
	return dst;
}
  8009de:	89 d8                	mov    %ebx,%eax
  8009e0:	83 c4 08             	add    $0x8,%esp
  8009e3:	5b                   	pop    %ebx
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f4:	85 db                	test   %ebx,%ebx
  8009f6:	74 17                	je     800a0f <strncpy+0x29>
  8009f8:	01 f3                	add    %esi,%ebx
  8009fa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8009fc:	83 c1 01             	add    $0x1,%ecx
  8009ff:	0f b6 02             	movzbl (%edx),%eax
  800a02:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a05:	80 3a 01             	cmpb   $0x1,(%edx)
  800a08:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0b:	39 d9                	cmp    %ebx,%ecx
  800a0d:	75 ed                	jne    8009fc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a0f:	89 f0                	mov    %esi,%eax
  800a11:	5b                   	pop    %ebx
  800a12:	5e                   	pop    %esi
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	57                   	push   %edi
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a21:	8b 75 10             	mov    0x10(%ebp),%esi
  800a24:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a26:	85 f6                	test   %esi,%esi
  800a28:	74 34                	je     800a5e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800a2a:	83 fe 01             	cmp    $0x1,%esi
  800a2d:	74 26                	je     800a55 <strlcpy+0x40>
  800a2f:	0f b6 0b             	movzbl (%ebx),%ecx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	74 23                	je     800a59 <strlcpy+0x44>
  800a36:	83 ee 02             	sub    $0x2,%esi
  800a39:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800a3e:	83 c0 01             	add    $0x1,%eax
  800a41:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a44:	39 f2                	cmp    %esi,%edx
  800a46:	74 13                	je     800a5b <strlcpy+0x46>
  800a48:	83 c2 01             	add    $0x1,%edx
  800a4b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a4f:	84 c9                	test   %cl,%cl
  800a51:	75 eb                	jne    800a3e <strlcpy+0x29>
  800a53:	eb 06                	jmp    800a5b <strlcpy+0x46>
  800a55:	89 f8                	mov    %edi,%eax
  800a57:	eb 02                	jmp    800a5b <strlcpy+0x46>
  800a59:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5e:	29 f8                	sub    %edi,%eax
}
  800a60:	5b                   	pop    %ebx
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a6e:	0f b6 01             	movzbl (%ecx),%eax
  800a71:	84 c0                	test   %al,%al
  800a73:	74 15                	je     800a8a <strcmp+0x25>
  800a75:	3a 02                	cmp    (%edx),%al
  800a77:	75 11                	jne    800a8a <strcmp+0x25>
		p++, q++;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a7f:	0f b6 01             	movzbl (%ecx),%eax
  800a82:	84 c0                	test   %al,%al
  800a84:	74 04                	je     800a8a <strcmp+0x25>
  800a86:	3a 02                	cmp    (%edx),%al
  800a88:	74 ef                	je     800a79 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	0f b6 c0             	movzbl %al,%eax
  800a8d:	0f b6 12             	movzbl (%edx),%edx
  800a90:	29 d0                	sub    %edx,%eax
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800aa2:	85 f6                	test   %esi,%esi
  800aa4:	74 29                	je     800acf <strncmp+0x3b>
  800aa6:	0f b6 03             	movzbl (%ebx),%eax
  800aa9:	84 c0                	test   %al,%al
  800aab:	74 30                	je     800add <strncmp+0x49>
  800aad:	3a 02                	cmp    (%edx),%al
  800aaf:	75 2c                	jne    800add <strncmp+0x49>
  800ab1:	8d 43 01             	lea    0x1(%ebx),%eax
  800ab4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800ab6:	89 c3                	mov    %eax,%ebx
  800ab8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800abb:	39 f0                	cmp    %esi,%eax
  800abd:	74 17                	je     800ad6 <strncmp+0x42>
  800abf:	0f b6 08             	movzbl (%eax),%ecx
  800ac2:	84 c9                	test   %cl,%cl
  800ac4:	74 17                	je     800add <strncmp+0x49>
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	3a 0a                	cmp    (%edx),%cl
  800acb:	74 e9                	je     800ab6 <strncmp+0x22>
  800acd:	eb 0e                	jmp    800add <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800acf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad4:	eb 0f                	jmp    800ae5 <strncmp+0x51>
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	eb 08                	jmp    800ae5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800add:	0f b6 03             	movzbl (%ebx),%eax
  800ae0:	0f b6 12             	movzbl (%edx),%edx
  800ae3:	29 d0                	sub    %edx,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	53                   	push   %ebx
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800af3:	0f b6 18             	movzbl (%eax),%ebx
  800af6:	84 db                	test   %bl,%bl
  800af8:	74 1d                	je     800b17 <strchr+0x2e>
  800afa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800afc:	38 d3                	cmp    %dl,%bl
  800afe:	75 06                	jne    800b06 <strchr+0x1d>
  800b00:	eb 1a                	jmp    800b1c <strchr+0x33>
  800b02:	38 ca                	cmp    %cl,%dl
  800b04:	74 16                	je     800b1c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	0f b6 10             	movzbl (%eax),%edx
  800b0c:	84 d2                	test   %dl,%dl
  800b0e:	75 f2                	jne    800b02 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	eb 05                	jmp    800b1c <strchr+0x33>
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1c:	5b                   	pop    %ebx
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	53                   	push   %ebx
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800b29:	0f b6 18             	movzbl (%eax),%ebx
  800b2c:	84 db                	test   %bl,%bl
  800b2e:	74 16                	je     800b46 <strfind+0x27>
  800b30:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800b32:	38 d3                	cmp    %dl,%bl
  800b34:	75 06                	jne    800b3c <strfind+0x1d>
  800b36:	eb 0e                	jmp    800b46 <strfind+0x27>
  800b38:	38 ca                	cmp    %cl,%dl
  800b3a:	74 0a                	je     800b46 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	0f b6 10             	movzbl (%eax),%edx
  800b42:	84 d2                	test   %dl,%dl
  800b44:	75 f2                	jne    800b38 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800b46:	5b                   	pop    %ebx
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
  800b4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b55:	85 c9                	test   %ecx,%ecx
  800b57:	74 36                	je     800b8f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b59:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5f:	75 28                	jne    800b89 <memset+0x40>
  800b61:	f6 c1 03             	test   $0x3,%cl
  800b64:	75 23                	jne    800b89 <memset+0x40>
		c &= 0xFF;
  800b66:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b6a:	89 d3                	mov    %edx,%ebx
  800b6c:	c1 e3 08             	shl    $0x8,%ebx
  800b6f:	89 d6                	mov    %edx,%esi
  800b71:	c1 e6 18             	shl    $0x18,%esi
  800b74:	89 d0                	mov    %edx,%eax
  800b76:	c1 e0 10             	shl    $0x10,%eax
  800b79:	09 f0                	or     %esi,%eax
  800b7b:	09 c2                	or     %eax,%edx
  800b7d:	89 d0                	mov    %edx,%eax
  800b7f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b81:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b84:	fc                   	cld    
  800b85:	f3 ab                	rep stos %eax,%es:(%edi)
  800b87:	eb 06                	jmp    800b8f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	fc                   	cld    
  800b8d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8f:	89 f8                	mov    %edi,%eax
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5f                   	pop    %edi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba4:	39 c6                	cmp    %eax,%esi
  800ba6:	73 35                	jae    800bdd <memmove+0x47>
  800ba8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bab:	39 d0                	cmp    %edx,%eax
  800bad:	73 2e                	jae    800bdd <memmove+0x47>
		s += n;
		d += n;
  800baf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800bb2:	89 d6                	mov    %edx,%esi
  800bb4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bbc:	75 13                	jne    800bd1 <memmove+0x3b>
  800bbe:	f6 c1 03             	test   $0x3,%cl
  800bc1:	75 0e                	jne    800bd1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bc3:	83 ef 04             	sub    $0x4,%edi
  800bc6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bcc:	fd                   	std    
  800bcd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcf:	eb 09                	jmp    800bda <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bd1:	83 ef 01             	sub    $0x1,%edi
  800bd4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bd7:	fd                   	std    
  800bd8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bda:	fc                   	cld    
  800bdb:	eb 1d                	jmp    800bfa <memmove+0x64>
  800bdd:	89 f2                	mov    %esi,%edx
  800bdf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be1:	f6 c2 03             	test   $0x3,%dl
  800be4:	75 0f                	jne    800bf5 <memmove+0x5f>
  800be6:	f6 c1 03             	test   $0x3,%cl
  800be9:	75 0a                	jne    800bf5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800beb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bee:	89 c7                	mov    %eax,%edi
  800bf0:	fc                   	cld    
  800bf1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf3:	eb 05                	jmp    800bfa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bf5:	89 c7                	mov    %eax,%edi
  800bf7:	fc                   	cld    
  800bf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bfa:	5e                   	pop    %esi
  800bfb:	5f                   	pop    %edi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c04:	8b 45 10             	mov    0x10(%ebp),%eax
  800c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	89 04 24             	mov    %eax,(%esp)
  800c18:	e8 79 ff ff ff       	call   800b96 <memmove>
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c28:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800c31:	85 c0                	test   %eax,%eax
  800c33:	74 36                	je     800c6b <memcmp+0x4c>
		if (*s1 != *s2)
  800c35:	0f b6 03             	movzbl (%ebx),%eax
  800c38:	0f b6 0e             	movzbl (%esi),%ecx
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	38 c8                	cmp    %cl,%al
  800c42:	74 1c                	je     800c60 <memcmp+0x41>
  800c44:	eb 10                	jmp    800c56 <memcmp+0x37>
  800c46:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c4b:	83 c2 01             	add    $0x1,%edx
  800c4e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800c52:	38 c8                	cmp    %cl,%al
  800c54:	74 0a                	je     800c60 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800c56:	0f b6 c0             	movzbl %al,%eax
  800c59:	0f b6 c9             	movzbl %cl,%ecx
  800c5c:	29 c8                	sub    %ecx,%eax
  800c5e:	eb 10                	jmp    800c70 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c60:	39 fa                	cmp    %edi,%edx
  800c62:	75 e2                	jne    800c46 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
  800c69:	eb 05                	jmp    800c70 <memcmp+0x51>
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	53                   	push   %ebx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c84:	39 d0                	cmp    %edx,%eax
  800c86:	73 13                	jae    800c9b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c88:	89 d9                	mov    %ebx,%ecx
  800c8a:	38 18                	cmp    %bl,(%eax)
  800c8c:	75 06                	jne    800c94 <memfind+0x1f>
  800c8e:	eb 0b                	jmp    800c9b <memfind+0x26>
  800c90:	38 08                	cmp    %cl,(%eax)
  800c92:	74 07                	je     800c9b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c94:	83 c0 01             	add    $0x1,%eax
  800c97:	39 d0                	cmp    %edx,%eax
  800c99:	75 f5                	jne    800c90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c9b:	5b                   	pop    %ebx
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800caa:	0f b6 0a             	movzbl (%edx),%ecx
  800cad:	80 f9 09             	cmp    $0x9,%cl
  800cb0:	74 05                	je     800cb7 <strtol+0x19>
  800cb2:	80 f9 20             	cmp    $0x20,%cl
  800cb5:	75 10                	jne    800cc7 <strtol+0x29>
		s++;
  800cb7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	0f b6 0a             	movzbl (%edx),%ecx
  800cbd:	80 f9 09             	cmp    $0x9,%cl
  800cc0:	74 f5                	je     800cb7 <strtol+0x19>
  800cc2:	80 f9 20             	cmp    $0x20,%cl
  800cc5:	74 f0                	je     800cb7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc7:	80 f9 2b             	cmp    $0x2b,%cl
  800cca:	75 0a                	jne    800cd6 <strtol+0x38>
		s++;
  800ccc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd4:	eb 11                	jmp    800ce7 <strtol+0x49>
  800cd6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cdb:	80 f9 2d             	cmp    $0x2d,%cl
  800cde:	75 07                	jne    800ce7 <strtol+0x49>
		s++, neg = 1;
  800ce0:	83 c2 01             	add    $0x1,%edx
  800ce3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800cec:	75 15                	jne    800d03 <strtol+0x65>
  800cee:	80 3a 30             	cmpb   $0x30,(%edx)
  800cf1:	75 10                	jne    800d03 <strtol+0x65>
  800cf3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cf7:	75 0a                	jne    800d03 <strtol+0x65>
		s += 2, base = 16;
  800cf9:	83 c2 02             	add    $0x2,%edx
  800cfc:	b8 10 00 00 00       	mov    $0x10,%eax
  800d01:	eb 10                	jmp    800d13 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 0c                	jne    800d13 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d07:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d09:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0c:	75 05                	jne    800d13 <strtol+0x75>
		s++, base = 8;
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d18:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d1b:	0f b6 0a             	movzbl (%edx),%ecx
  800d1e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d21:	89 f0                	mov    %esi,%eax
  800d23:	3c 09                	cmp    $0x9,%al
  800d25:	77 08                	ja     800d2f <strtol+0x91>
			dig = *s - '0';
  800d27:	0f be c9             	movsbl %cl,%ecx
  800d2a:	83 e9 30             	sub    $0x30,%ecx
  800d2d:	eb 20                	jmp    800d4f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800d2f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d32:	89 f0                	mov    %esi,%eax
  800d34:	3c 19                	cmp    $0x19,%al
  800d36:	77 08                	ja     800d40 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800d38:	0f be c9             	movsbl %cl,%ecx
  800d3b:	83 e9 57             	sub    $0x57,%ecx
  800d3e:	eb 0f                	jmp    800d4f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800d40:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d43:	89 f0                	mov    %esi,%eax
  800d45:	3c 19                	cmp    $0x19,%al
  800d47:	77 16                	ja     800d5f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d49:	0f be c9             	movsbl %cl,%ecx
  800d4c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d4f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d52:	7d 0f                	jge    800d63 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d54:	83 c2 01             	add    $0x1,%edx
  800d57:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d5b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d5d:	eb bc                	jmp    800d1b <strtol+0x7d>
  800d5f:	89 d8                	mov    %ebx,%eax
  800d61:	eb 02                	jmp    800d65 <strtol+0xc7>
  800d63:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 05                	je     800d70 <strtol+0xd2>
		*endptr = (char *) s;
  800d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d70:	f7 d8                	neg    %eax
  800d72:	85 ff                	test   %edi,%edi
  800d74:	0f 44 c3             	cmove  %ebx,%eax
}
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d82:	b8 00 00 00 00       	mov    $0x0,%eax
  800d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8d:	89 c3                	mov    %eax,%ebx
  800d8f:	89 c7                	mov    %eax,%edi
  800d91:	89 c6                	mov    %eax,%esi
  800d93:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_cgetc>:

int
sys_cgetc(void)
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
  800da5:	b8 01 00 00 00       	mov    $0x1,%eax
  800daa:	89 d1                	mov    %edx,%ecx
  800dac:	89 d3                	mov    %edx,%ebx
  800dae:	89 d7                	mov    %edx,%edi
  800db0:	89 d6                	mov    %edx,%esi
  800db2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	89 cb                	mov    %ecx,%ebx
  800dd1:	89 cf                	mov    %ecx,%edi
  800dd3:	89 ce                	mov    %ecx,%esi
  800dd5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7e 28                	jle    800e03 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800de6:	00 
  800de7:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800dee:	00 
  800def:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800df6:	00 
  800df7:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800dfe:	e8 45 f4 ff ff       	call   800248 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e03:	83 c4 2c             	add    $0x2c,%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 02 00 00 00       	mov    $0x2,%eax
  800e1b:	89 d1                	mov    %edx,%ecx
  800e1d:	89 d3                	mov    %edx,%ebx
  800e1f:	89 d7                	mov    %edx,%edi
  800e21:	89 d6                	mov    %edx,%esi
  800e23:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_yield>:

void
sys_yield(void)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
  800e35:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e3a:	89 d1                	mov    %edx,%ecx
  800e3c:	89 d3                	mov    %edx,%ebx
  800e3e:	89 d7                	mov    %edx,%edi
  800e40:	89 d6                	mov    %edx,%esi
  800e42:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e52:	be 00 00 00 00       	mov    $0x0,%esi
  800e57:	b8 04 00 00 00       	mov    $0x4,%eax
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e65:	89 f7                	mov    %esi,%edi
  800e67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7e 28                	jle    800e95 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e71:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e78:	00 
  800e79:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800e80:	00 
  800e81:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e88:	00 
  800e89:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800e90:	e8 b3 f3 ff ff       	call   800248 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e95:	83 c4 2c             	add    $0x2c,%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea6:	b8 05 00 00 00       	mov    $0x5,%eax
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb7:	8b 75 18             	mov    0x18(%ebp),%esi
  800eba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7e 28                	jle    800ee8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ecb:	00 
  800ecc:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800edb:	00 
  800edc:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800ee3:	e8 60 f3 ff ff       	call   800248 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee8:	83 c4 2c             	add    $0x2c,%esp
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	b8 06 00 00 00       	mov    $0x6,%eax
  800f03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7e 28                	jle    800f3b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f17:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f1e:	00 
  800f1f:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800f26:	00 
  800f27:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f2e:	00 
  800f2f:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800f36:	e8 0d f3 ff ff       	call   800248 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f3b:	83 c4 2c             	add    $0x2c,%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	b8 08 00 00 00       	mov    $0x8,%eax
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7e 28                	jle    800f8e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f71:	00 
  800f72:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800f79:	00 
  800f7a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f81:	00 
  800f82:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800f89:	e8 ba f2 ff ff       	call   800248 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f8e:	83 c4 2c             	add    $0x2c,%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	89 df                	mov    %ebx,%edi
  800fb1:	89 de                	mov    %ebx,%esi
  800fb3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	7e 28                	jle    800fe1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fc4:	00 
  800fc5:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fd4:	00 
  800fd5:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  800fdc:	e8 67 f2 ff ff       	call   800248 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe1:	83 c4 2c             	add    $0x2c,%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
  800fef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	89 df                	mov    %ebx,%edi
  801004:	89 de                	mov    %ebx,%esi
  801006:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801008:	85 c0                	test   %eax,%eax
  80100a:	7e 28                	jle    801034 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801010:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801017:	00 
  801018:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  80101f:	00 
  801020:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801027:	00 
  801028:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  80102f:	e8 14 f2 ff ff       	call   800248 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801034:	83 c4 2c             	add    $0x2c,%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801042:	be 00 00 00 00       	mov    $0x0,%esi
  801047:	b8 0c 00 00 00       	mov    $0xc,%eax
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801055:	8b 7d 14             	mov    0x14(%ebp),%edi
  801058:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
  801065:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801068:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801072:	8b 55 08             	mov    0x8(%ebp),%edx
  801075:	89 cb                	mov    %ecx,%ebx
  801077:	89 cf                	mov    %ecx,%edi
  801079:	89 ce                	mov    %ecx,%esi
  80107b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107d:	85 c0                	test   %eax,%eax
  80107f:	7e 28                	jle    8010a9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801081:	89 44 24 10          	mov    %eax,0x10(%esp)
  801085:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80108c:	00 
  80108d:	c7 44 24 08 1f 31 80 	movl   $0x80311f,0x8(%esp)
  801094:	00 
  801095:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80109c:	00 
  80109d:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  8010a4:	e8 9f f1 ff ff       	call   800248 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a9:	83 c4 2c             	add    $0x2c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	53                   	push   %ebx
  8010b5:	83 ec 24             	sub    $0x24,%esp
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010bb:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  8010bd:	89 da                	mov    %ebx,%edx
  8010bf:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  8010c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  8010c9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010cd:	74 05                	je     8010d4 <pgfault+0x23>
  8010cf:	f6 c6 08             	test   $0x8,%dh
  8010d2:	75 1c                	jne    8010f0 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  8010d4:	c7 44 24 08 4c 31 80 	movl   $0x80314c,0x8(%esp)
  8010db:	00 
  8010dc:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  8010eb:	e8 58 f1 ff ff       	call   800248 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  8010f0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010f7:	00 
  8010f8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010ff:	00 
  801100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801107:	e8 3d fd ff ff       	call   800e49 <sys_page_alloc>
  80110c:	85 c0                	test   %eax,%eax
  80110e:	79 20                	jns    801130 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801110:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801114:	c7 44 24 08 b4 31 80 	movl   $0x8031b4,0x8(%esp)
  80111b:	00 
  80111c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801123:	00 
  801124:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  80112b:	e8 18 f1 ff ff       	call   800248 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801130:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801136:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80113d:	00 
  80113e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801142:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801149:	e8 48 fa ff ff       	call   800b96 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80114e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801155:	00 
  801156:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80115a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801161:	00 
  801162:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801169:	00 
  80116a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801171:	e8 27 fd ff ff       	call   800e9d <sys_page_map>
  801176:	85 c0                	test   %eax,%eax
  801178:	79 20                	jns    80119a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80117a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80117e:	c7 44 24 08 ce 31 80 	movl   $0x8031ce,0x8(%esp)
  801185:	00 
  801186:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80118d:	00 
  80118e:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  801195:	e8 ae f0 ff ff       	call   800248 <_panic>
	}
}
  80119a:	83 c4 24             	add    $0x24,%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  8011a9:	c7 04 24 b1 10 80 00 	movl   $0x8010b1,(%esp)
  8011b0:	e8 e1 16 00 00       	call   802896 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011b5:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ba:	cd 30                	int    $0x30
  8011bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	79 1c                	jns    8011df <fork+0x3f>
		panic("fork");
  8011c3:	c7 44 24 08 e7 31 80 	movl   $0x8031e7,0x8(%esp)
  8011ca:	00 
  8011cb:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  8011d2:	00 
  8011d3:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  8011da:	e8 69 f0 ff ff       	call   800248 <_panic>
  8011df:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  8011e1:	bb 00 08 00 00       	mov    $0x800,%ebx
  8011e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ea:	75 21                	jne    80120d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ec:	e8 1a fc ff ff       	call   800e0b <sys_getenvid>
  8011f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011fe:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801203:	b8 00 00 00 00       	mov    $0x0,%eax
  801208:	e9 c5 01 00 00       	jmp    8013d2 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80120d:	89 d8                	mov    %ebx,%eax
  80120f:	c1 e8 0a             	shr    $0xa,%eax
  801212:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801219:	a8 01                	test   $0x1,%al
  80121b:	0f 84 f2 00 00 00    	je     801313 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801221:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801228:	a8 05                	test   $0x5,%al
  80122a:	0f 84 e3 00 00 00    	je     801313 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801230:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801237:	89 de                	mov    %ebx,%esi
  801239:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80123c:	a9 02 08 00 00       	test   $0x802,%eax
  801241:	0f 84 88 00 00 00    	je     8012cf <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801247:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80124e:	00 
  80124f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801253:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801257:	89 74 24 04          	mov    %esi,0x4(%esp)
  80125b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801262:	e8 36 fc ff ff       	call   800e9d <sys_page_map>
  801267:	85 c0                	test   %eax,%eax
  801269:	79 20                	jns    80128b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80126b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126f:	c7 44 24 08 ec 31 80 	movl   $0x8031ec,0x8(%esp)
  801276:	00 
  801277:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80127e:	00 
  80127f:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  801286:	e8 bd ef ff ff       	call   800248 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80128b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801292:	00 
  801293:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801297:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80129e:	00 
  80129f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a3:	89 3c 24             	mov    %edi,(%esp)
  8012a6:	e8 f2 fb ff ff       	call   800e9d <sys_page_map>
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	79 64                	jns    801313 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  8012af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b3:	c7 44 24 08 06 32 80 	movl   $0x803206,0x8(%esp)
  8012ba:	00 
  8012bb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8012c2:	00 
  8012c3:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  8012ca:	e8 79 ef ff ff       	call   800248 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8012cf:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8012d6:	00 
  8012d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012db:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ea:	e8 ae fb ff ff       	call   800e9d <sys_page_map>
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	79 20                	jns    801313 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  8012f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f7:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  80130e:	e8 35 ef ff ff       	call   800248 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801313:	83 c3 01             	add    $0x1,%ebx
  801316:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80131c:	0f 85 eb fe ff ff    	jne    80120d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801322:	c7 44 24 04 ff 28 80 	movl   $0x8028ff,0x4(%esp)
  801329:	00 
  80132a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132d:	89 04 24             	mov    %eax,(%esp)
  801330:	e8 b4 fc ff ff       	call   800fe9 <sys_env_set_pgfault_upcall>
  801335:	85 c0                	test   %eax,%eax
  801337:	79 20                	jns    801359 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801339:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133d:	c7 44 24 08 84 31 80 	movl   $0x803184,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  801354:	e8 ef ee ff ff       	call   800248 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801359:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801360:	00 
  801361:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801368:	ee 
  801369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136c:	89 04 24             	mov    %eax,(%esp)
  80136f:	e8 d5 fa ff ff       	call   800e49 <sys_page_alloc>
  801374:	85 c0                	test   %eax,%eax
  801376:	79 20                	jns    801398 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801378:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137c:	c7 44 24 08 32 32 80 	movl   $0x803232,0x8(%esp)
  801383:	00 
  801384:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80138b:	00 
  80138c:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  801393:	e8 b0 ee ff ff       	call   800248 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801398:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80139f:	00 
  8013a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a3:	89 04 24             	mov    %eax,(%esp)
  8013a6:	e8 98 fb ff ff       	call   800f43 <sys_env_set_status>
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	79 20                	jns    8013cf <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  8013af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b3:	c7 44 24 08 4a 32 80 	movl   $0x80324a,0x8(%esp)
  8013ba:	00 
  8013bb:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  8013c2:	00 
  8013c3:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  8013ca:	e8 79 ee ff ff       	call   800248 <_panic>
	}

	return envid;
  8013cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8013d2:	83 c4 2c             	add    $0x2c,%esp
  8013d5:	5b                   	pop    %ebx
  8013d6:	5e                   	pop    %esi
  8013d7:	5f                   	pop    %edi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <sfork>:

// Challenge!
int
sfork(void)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013e0:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  8013e7:	00 
  8013e8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  8013ef:	00 
  8013f0:	c7 04 24 a9 31 80 00 	movl   $0x8031a9,(%esp)
  8013f7:	e8 4c ee ff ff       	call   800248 <_panic>
  8013fc:	66 90                	xchg   %ax,%ax
  8013fe:	66 90                	xchg   %ax,%ax

00801400 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	05 00 00 00 30       	add    $0x30000000,%eax
  80140b:	c1 e8 0c             	shr    $0xc,%eax
}
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80141b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801420:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80142f:	a8 01                	test   $0x1,%al
  801431:	74 34                	je     801467 <fd_alloc+0x40>
  801433:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801438:	a8 01                	test   $0x1,%al
  80143a:	74 32                	je     80146e <fd_alloc+0x47>
  80143c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801441:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 16             	shr    $0x16,%edx
  801448:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	74 1f                	je     801473 <fd_alloc+0x4c>
  801454:	89 c2                	mov    %eax,%edx
  801456:	c1 ea 0c             	shr    $0xc,%edx
  801459:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801460:	f6 c2 01             	test   $0x1,%dl
  801463:	75 1a                	jne    80147f <fd_alloc+0x58>
  801465:	eb 0c                	jmp    801473 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801467:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80146c:	eb 05                	jmp    801473 <fd_alloc+0x4c>
  80146e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 08                	mov    %ecx,(%eax)
			return 0;
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
  80147d:	eb 1a                	jmp    801499 <fd_alloc+0x72>
  80147f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801484:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801489:	75 b6                	jne    801441 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801494:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014a1:	83 f8 1f             	cmp    $0x1f,%eax
  8014a4:	77 36                	ja     8014dc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014a6:	c1 e0 0c             	shl    $0xc,%eax
  8014a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014ae:	89 c2                	mov    %eax,%edx
  8014b0:	c1 ea 16             	shr    $0x16,%edx
  8014b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014ba:	f6 c2 01             	test   $0x1,%dl
  8014bd:	74 24                	je     8014e3 <fd_lookup+0x48>
  8014bf:	89 c2                	mov    %eax,%edx
  8014c1:	c1 ea 0c             	shr    $0xc,%edx
  8014c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014cb:	f6 c2 01             	test   $0x1,%dl
  8014ce:	74 1a                	je     8014ea <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	eb 13                	jmp    8014ef <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e1:	eb 0c                	jmp    8014ef <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e8:	eb 05                	jmp    8014ef <fd_lookup+0x54>
  8014ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    

008014f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 14             	sub    $0x14,%esp
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8014fe:	39 05 0c 40 80 00    	cmp    %eax,0x80400c
  801504:	75 1e                	jne    801524 <dev_lookup+0x33>
  801506:	eb 0e                	jmp    801516 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801508:	b8 28 40 80 00       	mov    $0x804028,%eax
  80150d:	eb 0c                	jmp    80151b <dev_lookup+0x2a>
  80150f:	b8 44 40 80 00       	mov    $0x804044,%eax
  801514:	eb 05                	jmp    80151b <dev_lookup+0x2a>
  801516:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80151b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	eb 38                	jmp    80155c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801524:	39 05 28 40 80 00    	cmp    %eax,0x804028
  80152a:	74 dc                	je     801508 <dev_lookup+0x17>
  80152c:	39 05 44 40 80 00    	cmp    %eax,0x804044
  801532:	74 db                	je     80150f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801534:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80153a:	8b 52 48             	mov    0x48(%edx),%edx
  80153d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801541:	89 54 24 04          	mov    %edx,0x4(%esp)
  801545:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  80154c:	e8 f0 ed ff ff       	call   800341 <cprintf>
	*dev = 0;
  801551:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80155c:	83 c4 14             	add    $0x14,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	56                   	push   %esi
  801566:	53                   	push   %ebx
  801567:	83 ec 20             	sub    $0x20,%esp
  80156a:	8b 75 08             	mov    0x8(%ebp),%esi
  80156d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801577:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80157d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801580:	89 04 24             	mov    %eax,(%esp)
  801583:	e8 13 ff ff ff       	call   80149b <fd_lookup>
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 05                	js     801591 <fd_close+0x2f>
	    || fd != fd2)
  80158c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80158f:	74 0c                	je     80159d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801591:	84 db                	test   %bl,%bl
  801593:	ba 00 00 00 00       	mov    $0x0,%edx
  801598:	0f 44 c2             	cmove  %edx,%eax
  80159b:	eb 3f                	jmp    8015dc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80159d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a4:	8b 06                	mov    (%esi),%eax
  8015a6:	89 04 24             	mov    %eax,(%esp)
  8015a9:	e8 43 ff ff ff       	call   8014f1 <dev_lookup>
  8015ae:	89 c3                	mov    %eax,%ebx
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 16                	js     8015ca <fd_close+0x68>
		if (dev->dev_close)
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	74 07                	je     8015ca <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015c3:	89 34 24             	mov    %esi,(%esp)
  8015c6:	ff d0                	call   *%eax
  8015c8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d5:	e8 16 f9 ff ff       	call   800ef0 <sys_page_unmap>
	return r;
  8015da:	89 d8                	mov    %ebx,%eax
}
  8015dc:	83 c4 20             	add    $0x20,%esp
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 04 24             	mov    %eax,(%esp)
  8015f6:	e8 a0 fe ff ff       	call   80149b <fd_lookup>
  8015fb:	89 c2                	mov    %eax,%edx
  8015fd:	85 d2                	test   %edx,%edx
  8015ff:	78 13                	js     801614 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801601:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801608:	00 
  801609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160c:	89 04 24             	mov    %eax,(%esp)
  80160f:	e8 4e ff ff ff       	call   801562 <fd_close>
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <close_all>:

void
close_all(void)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80161d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801622:	89 1c 24             	mov    %ebx,(%esp)
  801625:	e8 b9 ff ff ff       	call   8015e3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80162a:	83 c3 01             	add    $0x1,%ebx
  80162d:	83 fb 20             	cmp    $0x20,%ebx
  801630:	75 f0                	jne    801622 <close_all+0xc>
		close(i);
}
  801632:	83 c4 14             	add    $0x14,%esp
  801635:	5b                   	pop    %ebx
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    

00801638 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	57                   	push   %edi
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
  80163e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801641:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801644:	89 44 24 04          	mov    %eax,0x4(%esp)
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	89 04 24             	mov    %eax,(%esp)
  80164e:	e8 48 fe ff ff       	call   80149b <fd_lookup>
  801653:	89 c2                	mov    %eax,%edx
  801655:	85 d2                	test   %edx,%edx
  801657:	0f 88 e1 00 00 00    	js     80173e <dup+0x106>
		return r;
	close(newfdnum);
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	89 04 24             	mov    %eax,(%esp)
  801663:	e8 7b ff ff ff       	call   8015e3 <close>

	newfd = INDEX2FD(newfdnum);
  801668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80166b:	c1 e3 0c             	shl    $0xc,%ebx
  80166e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801677:	89 04 24             	mov    %eax,(%esp)
  80167a:	e8 91 fd ff ff       	call   801410 <fd2data>
  80167f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801681:	89 1c 24             	mov    %ebx,(%esp)
  801684:	e8 87 fd ff ff       	call   801410 <fd2data>
  801689:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80168b:	89 f0                	mov    %esi,%eax
  80168d:	c1 e8 16             	shr    $0x16,%eax
  801690:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801697:	a8 01                	test   $0x1,%al
  801699:	74 43                	je     8016de <dup+0xa6>
  80169b:	89 f0                	mov    %esi,%eax
  80169d:	c1 e8 0c             	shr    $0xc,%eax
  8016a0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016a7:	f6 c2 01             	test   $0x1,%dl
  8016aa:	74 32                	je     8016de <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016c7:	00 
  8016c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d3:	e8 c5 f7 ff ff       	call   800e9d <sys_page_map>
  8016d8:	89 c6                	mov    %eax,%esi
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 3e                	js     80171c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e1:	89 c2                	mov    %eax,%edx
  8016e3:	c1 ea 0c             	shr    $0xc,%edx
  8016e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ed:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801702:	00 
  801703:	89 44 24 04          	mov    %eax,0x4(%esp)
  801707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170e:	e8 8a f7 ff ff       	call   800e9d <sys_page_map>
  801713:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801718:	85 f6                	test   %esi,%esi
  80171a:	79 22                	jns    80173e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80171c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801727:	e8 c4 f7 ff ff       	call   800ef0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80172c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801737:	e8 b4 f7 ff ff       	call   800ef0 <sys_page_unmap>
	return r;
  80173c:	89 f0                	mov    %esi,%eax
}
  80173e:	83 c4 3c             	add    $0x3c,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	53                   	push   %ebx
  80174a:	83 ec 24             	sub    $0x24,%esp
  80174d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801753:	89 44 24 04          	mov    %eax,0x4(%esp)
  801757:	89 1c 24             	mov    %ebx,(%esp)
  80175a:	e8 3c fd ff ff       	call   80149b <fd_lookup>
  80175f:	89 c2                	mov    %eax,%edx
  801761:	85 d2                	test   %edx,%edx
  801763:	78 6d                	js     8017d2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176f:	8b 00                	mov    (%eax),%eax
  801771:	89 04 24             	mov    %eax,(%esp)
  801774:	e8 78 fd ff ff       	call   8014f1 <dev_lookup>
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 55                	js     8017d2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	8b 50 08             	mov    0x8(%eax),%edx
  801783:	83 e2 03             	and    $0x3,%edx
  801786:	83 fa 01             	cmp    $0x1,%edx
  801789:	75 23                	jne    8017ae <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80178b:	a1 04 50 80 00       	mov    0x805004,%eax
  801790:	8b 40 48             	mov    0x48(%eax),%eax
  801793:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	c7 04 24 bd 32 80 00 	movl   $0x8032bd,(%esp)
  8017a2:	e8 9a eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  8017a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ac:	eb 24                	jmp    8017d2 <read+0x8c>
	}
	if (!dev->dev_read)
  8017ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b1:	8b 52 08             	mov    0x8(%edx),%edx
  8017b4:	85 d2                	test   %edx,%edx
  8017b6:	74 15                	je     8017cd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017c6:	89 04 24             	mov    %eax,(%esp)
  8017c9:	ff d2                	call   *%edx
  8017cb:	eb 05                	jmp    8017d2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017d2:	83 c4 24             	add    $0x24,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	57                   	push   %edi
  8017dc:	56                   	push   %esi
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 1c             	sub    $0x1c,%esp
  8017e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017e7:	85 f6                	test   %esi,%esi
  8017e9:	74 33                	je     80181e <readn+0x46>
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017f5:	89 f2                	mov    %esi,%edx
  8017f7:	29 c2                	sub    %eax,%edx
  8017f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017fd:	03 45 0c             	add    0xc(%ebp),%eax
  801800:	89 44 24 04          	mov    %eax,0x4(%esp)
  801804:	89 3c 24             	mov    %edi,(%esp)
  801807:	e8 3a ff ff ff       	call   801746 <read>
		if (m < 0)
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 1b                	js     80182b <readn+0x53>
			return m;
		if (m == 0)
  801810:	85 c0                	test   %eax,%eax
  801812:	74 11                	je     801825 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801814:	01 c3                	add    %eax,%ebx
  801816:	89 d8                	mov    %ebx,%eax
  801818:	39 f3                	cmp    %esi,%ebx
  80181a:	72 d9                	jb     8017f5 <readn+0x1d>
  80181c:	eb 0b                	jmp    801829 <readn+0x51>
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
  801823:	eb 06                	jmp    80182b <readn+0x53>
  801825:	89 d8                	mov    %ebx,%eax
  801827:	eb 02                	jmp    80182b <readn+0x53>
  801829:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80182b:	83 c4 1c             	add    $0x1c,%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 24             	sub    $0x24,%esp
  80183a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801840:	89 44 24 04          	mov    %eax,0x4(%esp)
  801844:	89 1c 24             	mov    %ebx,(%esp)
  801847:	e8 4f fc ff ff       	call   80149b <fd_lookup>
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	85 d2                	test   %edx,%edx
  801850:	78 68                	js     8018ba <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801852:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801855:	89 44 24 04          	mov    %eax,0x4(%esp)
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185c:	8b 00                	mov    (%eax),%eax
  80185e:	89 04 24             	mov    %eax,(%esp)
  801861:	e8 8b fc ff ff       	call   8014f1 <dev_lookup>
  801866:	85 c0                	test   %eax,%eax
  801868:	78 50                	js     8018ba <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801871:	75 23                	jne    801896 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801873:	a1 04 50 80 00       	mov    0x805004,%eax
  801878:	8b 40 48             	mov    0x48(%eax),%eax
  80187b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801883:	c7 04 24 d9 32 80 00 	movl   $0x8032d9,(%esp)
  80188a:	e8 b2 ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  80188f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801894:	eb 24                	jmp    8018ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801899:	8b 52 0c             	mov    0xc(%edx),%edx
  80189c:	85 d2                	test   %edx,%edx
  80189e:	74 15                	je     8018b5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	ff d2                	call   *%edx
  8018b3:	eb 05                	jmp    8018ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ba:	83 c4 24             	add    $0x24,%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	89 04 24             	mov    %eax,(%esp)
  8018d3:	e8 c3 fb ff ff       	call   80149b <fd_lookup>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 0e                	js     8018ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 24             	sub    $0x24,%esp
  8018f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fd:	89 1c 24             	mov    %ebx,(%esp)
  801900:	e8 96 fb ff ff       	call   80149b <fd_lookup>
  801905:	89 c2                	mov    %eax,%edx
  801907:	85 d2                	test   %edx,%edx
  801909:	78 61                	js     80196c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	e8 d2 fb ff ff       	call   8014f1 <dev_lookup>
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 49                	js     80196c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801926:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80192a:	75 23                	jne    80194f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80192c:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801931:	8b 40 48             	mov    0x48(%eax),%eax
  801934:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193c:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  801943:	e8 f9 e9 ff ff       	call   800341 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194d:	eb 1d                	jmp    80196c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	8b 52 18             	mov    0x18(%edx),%edx
  801955:	85 d2                	test   %edx,%edx
  801957:	74 0e                	je     801967 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	ff d2                	call   *%edx
  801965:	eb 05                	jmp    80196c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801967:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80196c:	83 c4 24             	add    $0x24,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	53                   	push   %ebx
  801976:	83 ec 24             	sub    $0x24,%esp
  801979:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 0d fb ff ff       	call   80149b <fd_lookup>
  80198e:	89 c2                	mov    %eax,%edx
  801990:	85 d2                	test   %edx,%edx
  801992:	78 52                	js     8019e6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199e:	8b 00                	mov    (%eax),%eax
  8019a0:	89 04 24             	mov    %eax,(%esp)
  8019a3:	e8 49 fb ff ff       	call   8014f1 <dev_lookup>
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 3a                	js     8019e6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019af:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019b3:	74 2c                	je     8019e1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019b5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019b8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019bf:	00 00 00 
	stat->st_isdir = 0;
  8019c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019c9:	00 00 00 
	stat->st_dev = dev;
  8019cc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d9:	89 14 24             	mov    %edx,(%esp)
  8019dc:	ff 50 14             	call   *0x14(%eax)
  8019df:	eb 05                	jmp    8019e6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019e6:	83 c4 24             	add    $0x24,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    

008019ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019fb:	00 
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 e1 01 00 00       	call   801be8 <open>
  801a07:	89 c3                	mov    %eax,%ebx
  801a09:	85 db                	test   %ebx,%ebx
  801a0b:	78 1b                	js     801a28 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a14:	89 1c 24             	mov    %ebx,(%esp)
  801a17:	e8 56 ff ff ff       	call   801972 <fstat>
  801a1c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1e:	89 1c 24             	mov    %ebx,(%esp)
  801a21:	e8 bd fb ff ff       	call   8015e3 <close>
	return r;
  801a26:	89 f0                	mov    %esi,%eax
}
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 10             	sub    $0x10,%esp
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801a3b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a42:	75 11                	jne    801a55 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a4b:	e8 ce 0f 00 00       	call   802a1e <ipc_find_env>
  801a50:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801a55:	a1 04 50 80 00       	mov    0x805004,%eax
  801a5a:	8b 40 48             	mov    0x48(%eax),%eax
  801a5d:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801a63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	c7 04 24 f6 32 80 00 	movl   $0x8032f6,(%esp)
  801a76:	e8 c6 e8 ff ff       	call   800341 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a7b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a82:	00 
  801a83:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a8a:	00 
  801a8b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a8f:	a1 00 50 80 00       	mov    0x805000,%eax
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	e8 1c 0f 00 00       	call   8029b8 <ipc_send>
	cprintf("ipc_send\n");
  801a9c:	c7 04 24 0c 33 80 00 	movl   $0x80330c,(%esp)
  801aa3:	e8 99 e8 ff ff       	call   800341 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801aa8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aaf:	00 
  801ab0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abb:	e8 90 0e 00 00       	call   802950 <ipc_recv>
}
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 14             	sub    $0x14,%esp
  801ace:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801adc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae1:	b8 05 00 00 00       	mov    $0x5,%eax
  801ae6:	e8 44 ff ff ff       	call   801a2f <fsipc>
  801aeb:	89 c2                	mov    %eax,%edx
  801aed:	85 d2                	test   %edx,%edx
  801aef:	78 2b                	js     801b1c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801af1:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801af8:	00 
  801af9:	89 1c 24             	mov    %ebx,(%esp)
  801afc:	e8 9a ee ff ff       	call   80099b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b01:	a1 80 60 80 00       	mov    0x806080,%eax
  801b06:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b0c:	a1 84 60 80 00       	mov    0x806084,%eax
  801b11:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1c:	83 c4 14             	add    $0x14,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b33:	ba 00 00 00 00       	mov    $0x0,%edx
  801b38:	b8 06 00 00 00       	mov    $0x6,%eax
  801b3d:	e8 ed fe ff ff       	call   801a2f <fsipc>
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	83 ec 10             	sub    $0x10,%esp
  801b4c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	8b 40 0c             	mov    0xc(%eax),%eax
  801b55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b5a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	b8 03 00 00 00       	mov    $0x3,%eax
  801b6a:	e8 c0 fe ff ff       	call   801a2f <fsipc>
  801b6f:	89 c3                	mov    %eax,%ebx
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 6a                	js     801bdf <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b75:	39 c6                	cmp    %eax,%esi
  801b77:	73 24                	jae    801b9d <devfile_read+0x59>
  801b79:	c7 44 24 0c 16 33 80 	movl   $0x803316,0xc(%esp)
  801b80:	00 
  801b81:	c7 44 24 08 1d 33 80 	movl   $0x80331d,0x8(%esp)
  801b88:	00 
  801b89:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b90:	00 
  801b91:	c7 04 24 32 33 80 00 	movl   $0x803332,(%esp)
  801b98:	e8 ab e6 ff ff       	call   800248 <_panic>
	assert(r <= PGSIZE);
  801b9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ba2:	7e 24                	jle    801bc8 <devfile_read+0x84>
  801ba4:	c7 44 24 0c 3d 33 80 	movl   $0x80333d,0xc(%esp)
  801bab:	00 
  801bac:	c7 44 24 08 1d 33 80 	movl   $0x80331d,0x8(%esp)
  801bb3:	00 
  801bb4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801bbb:	00 
  801bbc:	c7 04 24 32 33 80 00 	movl   $0x803332,(%esp)
  801bc3:	e8 80 e6 ff ff       	call   800248 <_panic>
	memmove(buf, &fsipcbuf, r);
  801bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bcc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bd3:	00 
  801bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd7:	89 04 24             	mov    %eax,(%esp)
  801bda:	e8 b7 ef ff ff       	call   800b96 <memmove>
	return r;
}
  801bdf:	89 d8                	mov    %ebx,%eax
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    

00801be8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	53                   	push   %ebx
  801bec:	83 ec 24             	sub    $0x24,%esp
  801bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bf2:	89 1c 24             	mov    %ebx,(%esp)
  801bf5:	e8 46 ed ff ff       	call   800940 <strlen>
  801bfa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bff:	7f 60                	jg     801c61 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 1b f8 ff ff       	call   801427 <fd_alloc>
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	85 d2                	test   %edx,%edx
  801c10:	78 54                	js     801c66 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c16:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c1d:	e8 79 ed ff ff       	call   80099b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	e8 f8 fd ff ff       	call   801a2f <fsipc>
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	79 17                	jns    801c54 <open+0x6c>
		fd_close(fd, 0);
  801c3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c44:	00 
  801c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c48:	89 04 24             	mov    %eax,(%esp)
  801c4b:	e8 12 f9 ff ff       	call   801562 <fd_close>
		return r;
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	eb 12                	jmp    801c66 <open+0x7e>
	}
	return fd2num(fd);
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 a1 f7 ff ff       	call   801400 <fd2num>
  801c5f:	eb 05                	jmp    801c66 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c61:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801c66:	83 c4 24             	add    $0x24,%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	57                   	push   %edi
  801c74:	56                   	push   %esi
  801c75:	53                   	push   %ebx
  801c76:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  801c7c:	c7 04 24 49 33 80 00 	movl   $0x803349,(%esp)
  801c83:	e8 b9 e6 ff ff       	call   800341 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  801c88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c8f:	00 
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 4d ff ff ff       	call   801be8 <open>
  801c9b:	89 c7                	mov    %eax,%edi
  801c9d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	0f 88 09 05 00 00    	js     8021b4 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  801cab:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  801cb2:	e8 8a e6 ff ff       	call   800341 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801cb7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801cbe:	00 
  801cbf:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc9:	89 3c 24             	mov    %edi,(%esp)
  801ccc:	e8 07 fb ff ff       	call   8017d8 <readn>
  801cd1:	3d 00 02 00 00       	cmp    $0x200,%eax
  801cd6:	75 0c                	jne    801ce4 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  801cd8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801cdf:	45 4c 46 
  801ce2:	74 36                	je     801d1a <spawn+0xaa>
		close(fd);
  801ce4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cea:	89 04 24             	mov    %eax,(%esp)
  801ced:	e8 f1 f8 ff ff       	call   8015e3 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cf2:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801cf9:	46 
  801cfa:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d04:	c7 04 24 62 33 80 00 	movl   $0x803362,(%esp)
  801d0b:	e8 31 e6 ff ff       	call   800341 <cprintf>
		return -E_NOT_EXEC;
  801d10:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801d15:	e9 f9 04 00 00       	jmp    802213 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  801d1a:	c7 04 24 7c 33 80 00 	movl   $0x80337c,(%esp)
  801d21:	e8 1b e6 ff ff       	call   800341 <cprintf>
  801d26:	b8 07 00 00 00       	mov    $0x7,%eax
  801d2b:	cd 30                	int    $0x30
  801d2d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801d33:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	0f 88 7b 04 00 00    	js     8021bc <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d41:	89 c6                	mov    %eax,%esi
  801d43:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801d49:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801d4c:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801d52:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d58:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d5f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d65:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  801d6b:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801d72:	e8 ca e5 ff ff       	call   800341 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	74 38                	je     801db8 <spawn+0x148>
  801d80:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d85:	be 00 00 00 00       	mov    $0x0,%esi
  801d8a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801d8d:	89 04 24             	mov    %eax,(%esp)
  801d90:	e8 ab eb ff ff       	call   800940 <strlen>
  801d95:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d99:	83 c3 01             	add    $0x1,%ebx
  801d9c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801da3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801da6:	85 c0                	test   %eax,%eax
  801da8:	75 e3                	jne    801d8d <spawn+0x11d>
  801daa:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801db0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801db6:	eb 1e                	jmp    801dd6 <spawn+0x166>
  801db8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801dbf:	00 00 00 
  801dc2:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801dc9:	00 00 00 
  801dcc:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801dd1:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801dd6:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ddb:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ddd:	89 fa                	mov    %edi,%edx
  801ddf:	83 e2 fc             	and    $0xfffffffc,%edx
  801de2:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801de9:	29 c2                	sub    %eax,%edx
  801deb:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801df1:	8d 42 f8             	lea    -0x8(%edx),%eax
  801df4:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801df9:	0f 86 cd 03 00 00    	jbe    8021cc <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801dff:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e06:	00 
  801e07:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e0e:	00 
  801e0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e16:	e8 2e f0 ff ff       	call   800e49 <sys_page_alloc>
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	0f 88 f0 03 00 00    	js     802213 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e23:	85 db                	test   %ebx,%ebx
  801e25:	7e 46                	jle    801e6d <spawn+0x1fd>
  801e27:	be 00 00 00 00       	mov    $0x0,%esi
  801e2c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801e32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  801e35:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e3b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e41:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801e44:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4b:	89 3c 24             	mov    %edi,(%esp)
  801e4e:	e8 48 eb ff ff       	call   80099b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801e53:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801e56:	89 04 24             	mov    %eax,(%esp)
  801e59:	e8 e2 ea ff ff       	call   800940 <strlen>
  801e5e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e62:	83 c6 01             	add    $0x1,%esi
  801e65:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801e6b:	75 c8                	jne    801e35 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801e6d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e73:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801e79:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e80:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e86:	74 24                	je     801eac <spawn+0x23c>
  801e88:	c7 44 24 0c fc 33 80 	movl   $0x8033fc,0xc(%esp)
  801e8f:	00 
  801e90:	c7 44 24 08 1d 33 80 	movl   $0x80331d,0x8(%esp)
  801e97:	00 
  801e98:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  801e9f:	00 
  801ea0:	c7 04 24 95 33 80 00 	movl   $0x803395,(%esp)
  801ea7:	e8 9c e3 ff ff       	call   800248 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801eac:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801eb2:	89 c8                	mov    %ecx,%eax
  801eb4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801eb9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ebc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ec2:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ec5:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ecb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ed1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801ed8:	00 
  801ed9:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801ee0:	ee 
  801ee1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ee7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eeb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ef2:	00 
  801ef3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801efa:	e8 9e ef ff ff       	call   800e9d <sys_page_map>
  801eff:	89 c3                	mov    %eax,%ebx
  801f01:	85 c0                	test   %eax,%eax
  801f03:	0f 88 f4 02 00 00    	js     8021fd <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f09:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f10:	00 
  801f11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f18:	e8 d3 ef ff ff       	call   800ef0 <sys_page_unmap>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	0f 88 d6 02 00 00    	js     8021fd <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801f27:	c7 04 24 a1 33 80 00 	movl   $0x8033a1,(%esp)
  801f2e:	e8 0e e4 ff ff       	call   800341 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f33:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f39:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801f40:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f46:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801f4d:	00 
  801f4e:	0f 84 dc 01 00 00    	je     802130 <spawn+0x4c0>
  801f54:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801f5b:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801f5e:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f64:	83 38 01             	cmpl   $0x1,(%eax)
  801f67:	0f 85 a2 01 00 00    	jne    80210f <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f6d:	89 c1                	mov    %eax,%ecx
  801f6f:	8b 40 18             	mov    0x18(%eax),%eax
  801f72:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f75:	83 f8 01             	cmp    $0x1,%eax
  801f78:	19 c0                	sbb    %eax,%eax
  801f7a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f80:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801f87:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f8e:	89 c8                	mov    %ecx,%eax
  801f90:	8b 51 04             	mov    0x4(%ecx),%edx
  801f93:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801f99:	8b 79 10             	mov    0x10(%ecx),%edi
  801f9c:	8b 49 14             	mov    0x14(%ecx),%ecx
  801f9f:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801fa5:	8b 40 08             	mov    0x8(%eax),%eax
  801fa8:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801fae:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fb3:	74 14                	je     801fc9 <spawn+0x359>
		va -= i;
  801fb5:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801fbb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801fc1:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801fc3:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801fc9:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801fd0:	0f 84 39 01 00 00    	je     80210f <spawn+0x49f>
  801fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fdb:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801fe0:	39 f7                	cmp    %esi,%edi
  801fe2:	77 31                	ja     802015 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801fe4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fea:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fee:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801ff4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ff8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 43 ee ff ff       	call   800e49 <sys_page_alloc>
  802006:	85 c0                	test   %eax,%eax
  802008:	0f 89 ed 00 00 00    	jns    8020fb <spawn+0x48b>
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	e9 c8 01 00 00       	jmp    8021dd <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802015:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80201c:	00 
  80201d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802024:	00 
  802025:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202c:	e8 18 ee ff ff       	call   800e49 <sys_page_alloc>
  802031:	85 c0                	test   %eax,%eax
  802033:	0f 88 9a 01 00 00    	js     8021d3 <spawn+0x563>
  802039:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80203f:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802041:	89 44 24 04          	mov    %eax,0x4(%esp)
  802045:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80204b:	89 04 24             	mov    %eax,(%esp)
  80204e:	e8 6d f8 ff ff       	call   8018c0 <seek>
  802053:	85 c0                	test   %eax,%eax
  802055:	0f 88 7c 01 00 00    	js     8021d7 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80205b:	89 fa                	mov    %edi,%edx
  80205d:	29 f2                	sub    %esi,%edx
  80205f:	89 d0                	mov    %edx,%eax
  802061:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  802067:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80206c:	0f 47 c1             	cmova  %ecx,%eax
  80206f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802073:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80207a:	00 
  80207b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 4f f7 ff ff       	call   8017d8 <readn>
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 88 4a 01 00 00    	js     8021db <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802091:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802097:	89 44 24 10          	mov    %eax,0x10(%esp)
  80209b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8020a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8020a5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020af:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020b6:	00 
  8020b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020be:	e8 da ed ff ff       	call   800e9d <sys_page_map>
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	79 20                	jns    8020e7 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  8020c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020cb:	c7 44 24 08 ae 33 80 	movl   $0x8033ae,0x8(%esp)
  8020d2:	00 
  8020d3:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  8020da:	00 
  8020db:	c7 04 24 95 33 80 00 	movl   $0x803395,(%esp)
  8020e2:	e8 61 e1 ff ff       	call   800248 <_panic>
			sys_page_unmap(0, UTEMP);
  8020e7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020ee:	00 
  8020ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f6:	e8 f5 ed ff ff       	call   800ef0 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8020fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802101:	89 de                	mov    %ebx,%esi
  802103:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802109:	0f 82 d1 fe ff ff    	jb     801fe0 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80210f:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802116:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  80211d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802124:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  80212a:	0f 8f 2e fe ff ff    	jg     801f5e <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802130:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 a5 f4 ff ff       	call   8015e3 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80213e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802144:	89 44 24 04          	mov    %eax,0x4(%esp)
  802148:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80214e:	89 04 24             	mov    %eax,(%esp)
  802151:	e8 40 ee ff ff       	call   800f96 <sys_env_set_trapframe>
  802156:	85 c0                	test   %eax,%eax
  802158:	79 20                	jns    80217a <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  80215a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215e:	c7 44 24 08 cb 33 80 	movl   $0x8033cb,0x8(%esp)
  802165:	00 
  802166:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80216d:	00 
  80216e:	c7 04 24 95 33 80 00 	movl   $0x803395,(%esp)
  802175:	e8 ce e0 ff ff       	call   800248 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80217a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802181:	00 
  802182:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802188:	89 04 24             	mov    %eax,(%esp)
  80218b:	e8 b3 ed ff ff       	call   800f43 <sys_env_set_status>
  802190:	85 c0                	test   %eax,%eax
  802192:	79 30                	jns    8021c4 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  802194:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802198:	c7 44 24 08 e5 33 80 	movl   $0x8033e5,0x8(%esp)
  80219f:	00 
  8021a0:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  8021a7:	00 
  8021a8:	c7 04 24 95 33 80 00 	movl   $0x803395,(%esp)
  8021af:	e8 94 e0 ff ff       	call   800248 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8021b4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021ba:	eb 57                	jmp    802213 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8021bc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021c2:	eb 4f                	jmp    802213 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  8021c4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021ca:	eb 47                	jmp    802213 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8021cc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8021d1:	eb 40                	jmp    802213 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	eb 06                	jmp    8021dd <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8021d7:	89 c3                	mov    %eax,%ebx
  8021d9:	eb 02                	jmp    8021dd <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021db:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  8021dd:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021e3:	89 04 24             	mov    %eax,(%esp)
  8021e6:	e8 ce eb ff ff       	call   800db9 <sys_env_destroy>
	close(fd);
  8021eb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 ea f3 ff ff       	call   8015e3 <close>
	return r;
  8021f9:	89 d8                	mov    %ebx,%eax
  8021fb:	eb 16                	jmp    802213 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8021fd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802204:	00 
  802205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220c:	e8 df ec ff ff       	call   800ef0 <sys_page_unmap>
  802211:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802213:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802219:	5b                   	pop    %ebx
  80221a:	5e                   	pop    %esi
  80221b:	5f                   	pop    %edi
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802227:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80222b:	74 61                	je     80228e <spawnl+0x70>
  80222d:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802230:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802235:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802238:	83 c0 04             	add    $0x4,%eax
  80223b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80223f:	74 04                	je     802245 <spawnl+0x27>
		argc++;
  802241:	89 ca                	mov    %ecx,%edx
  802243:	eb f0                	jmp    802235 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802245:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  80224c:	83 e0 f0             	and    $0xfffffff0,%eax
  80224f:	29 c4                	sub    %eax,%esp
  802251:	8d 74 24 0b          	lea    0xb(%esp),%esi
  802255:	c1 ee 02             	shr    $0x2,%esi
  802258:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  80225f:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802261:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802264:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  80226b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  802272:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802273:	89 ce                	mov    %ecx,%esi
  802275:	85 c9                	test   %ecx,%ecx
  802277:	74 25                	je     80229e <spawnl+0x80>
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  80227e:	83 c0 01             	add    $0x1,%eax
  802281:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  802285:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802288:	39 f0                	cmp    %esi,%eax
  80228a:	75 f2                	jne    80227e <spawnl+0x60>
  80228c:	eb 10                	jmp    80229e <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  80228e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802291:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  802294:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80229b:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80229e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	89 04 24             	mov    %eax,(%esp)
  8022a8:	e8 c3 f9 ff ff       	call   801c70 <spawn>
}
  8022ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	66 90                	xchg   %ax,%ax
  8022b7:	66 90                	xchg   %ax,%ax
  8022b9:	66 90                	xchg   %ax,%ax
  8022bb:	66 90                	xchg   %ax,%ax
  8022bd:	66 90                	xchg   %ax,%ax
  8022bf:	90                   	nop

008022c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 10             	sub    $0x10,%esp
  8022c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	89 04 24             	mov    %eax,(%esp)
  8022d1:	e8 3a f1 ff ff       	call   801410 <fd2data>
  8022d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022d8:	c7 44 24 04 22 34 80 	movl   $0x803422,0x4(%esp)
  8022df:	00 
  8022e0:	89 1c 24             	mov    %ebx,(%esp)
  8022e3:	e8 b3 e6 ff ff       	call   80099b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022e8:	8b 46 04             	mov    0x4(%esi),%eax
  8022eb:	2b 06                	sub    (%esi),%eax
  8022ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022fa:	00 00 00 
	stat->st_dev = &devpipe;
  8022fd:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  802304:	40 80 00 
	return 0;
}
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	53                   	push   %ebx
  802317:	83 ec 14             	sub    $0x14,%esp
  80231a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80231d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802321:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802328:	e8 c3 eb ff ff       	call   800ef0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80232d:	89 1c 24             	mov    %ebx,(%esp)
  802330:	e8 db f0 ff ff       	call   801410 <fd2data>
  802335:	89 44 24 04          	mov    %eax,0x4(%esp)
  802339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802340:	e8 ab eb ff ff       	call   800ef0 <sys_page_unmap>
}
  802345:	83 c4 14             	add    $0x14,%esp
  802348:	5b                   	pop    %ebx
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	57                   	push   %edi
  80234f:	56                   	push   %esi
  802350:	53                   	push   %ebx
  802351:	83 ec 2c             	sub    $0x2c,%esp
  802354:	89 c6                	mov    %eax,%esi
  802356:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802359:	a1 04 50 80 00       	mov    0x805004,%eax
  80235e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802361:	89 34 24             	mov    %esi,(%esp)
  802364:	e8 fd 06 00 00       	call   802a66 <pageref>
  802369:	89 c7                	mov    %eax,%edi
  80236b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236e:	89 04 24             	mov    %eax,(%esp)
  802371:	e8 f0 06 00 00       	call   802a66 <pageref>
  802376:	39 c7                	cmp    %eax,%edi
  802378:	0f 94 c2             	sete   %dl
  80237b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80237e:	8b 0d 04 50 80 00    	mov    0x805004,%ecx
  802384:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802387:	39 fb                	cmp    %edi,%ebx
  802389:	74 21                	je     8023ac <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80238b:	84 d2                	test   %dl,%dl
  80238d:	74 ca                	je     802359 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80238f:	8b 51 58             	mov    0x58(%ecx),%edx
  802392:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802396:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80239e:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  8023a5:	e8 97 df ff ff       	call   800341 <cprintf>
  8023aa:	eb ad                	jmp    802359 <_pipeisclosed+0xe>
	}
}
  8023ac:	83 c4 2c             	add    $0x2c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	57                   	push   %edi
  8023b8:	56                   	push   %esi
  8023b9:	53                   	push   %ebx
  8023ba:	83 ec 1c             	sub    $0x1c,%esp
  8023bd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023c0:	89 34 24             	mov    %esi,(%esp)
  8023c3:	e8 48 f0 ff ff       	call   801410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023cc:	74 61                	je     80242f <devpipe_write+0x7b>
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d5:	eb 4a                	jmp    802421 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023d7:	89 da                	mov    %ebx,%edx
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	e8 6b ff ff ff       	call   80234b <_pipeisclosed>
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 54                	jne    802438 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8023e4:	e8 41 ea ff ff       	call   800e2a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023e9:	8b 43 04             	mov    0x4(%ebx),%eax
  8023ec:	8b 0b                	mov    (%ebx),%ecx
  8023ee:	8d 51 20             	lea    0x20(%ecx),%edx
  8023f1:	39 d0                	cmp    %edx,%eax
  8023f3:	73 e2                	jae    8023d7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023f8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023fc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023ff:	99                   	cltd   
  802400:	c1 ea 1b             	shr    $0x1b,%edx
  802403:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802406:	83 e1 1f             	and    $0x1f,%ecx
  802409:	29 d1                	sub    %edx,%ecx
  80240b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80240f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802413:	83 c0 01             	add    $0x1,%eax
  802416:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802419:	83 c7 01             	add    $0x1,%edi
  80241c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80241f:	74 13                	je     802434 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802421:	8b 43 04             	mov    0x4(%ebx),%eax
  802424:	8b 0b                	mov    (%ebx),%ecx
  802426:	8d 51 20             	lea    0x20(%ecx),%edx
  802429:	39 d0                	cmp    %edx,%eax
  80242b:	73 aa                	jae    8023d7 <devpipe_write+0x23>
  80242d:	eb c6                	jmp    8023f5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80242f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802434:	89 f8                	mov    %edi,%eax
  802436:	eb 05                	jmp    80243d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    

00802445 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	57                   	push   %edi
  802449:	56                   	push   %esi
  80244a:	53                   	push   %ebx
  80244b:	83 ec 1c             	sub    $0x1c,%esp
  80244e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802451:	89 3c 24             	mov    %edi,(%esp)
  802454:	e8 b7 ef ff ff       	call   801410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802459:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80245d:	74 54                	je     8024b3 <devpipe_read+0x6e>
  80245f:	89 c3                	mov    %eax,%ebx
  802461:	be 00 00 00 00       	mov    $0x0,%esi
  802466:	eb 3e                	jmp    8024a6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802468:	89 f0                	mov    %esi,%eax
  80246a:	eb 55                	jmp    8024c1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80246c:	89 da                	mov    %ebx,%edx
  80246e:	89 f8                	mov    %edi,%eax
  802470:	e8 d6 fe ff ff       	call   80234b <_pipeisclosed>
  802475:	85 c0                	test   %eax,%eax
  802477:	75 43                	jne    8024bc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802479:	e8 ac e9 ff ff       	call   800e2a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80247e:	8b 03                	mov    (%ebx),%eax
  802480:	3b 43 04             	cmp    0x4(%ebx),%eax
  802483:	74 e7                	je     80246c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802485:	99                   	cltd   
  802486:	c1 ea 1b             	shr    $0x1b,%edx
  802489:	01 d0                	add    %edx,%eax
  80248b:	83 e0 1f             	and    $0x1f,%eax
  80248e:	29 d0                	sub    %edx,%eax
  802490:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802495:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802498:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80249b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249e:	83 c6 01             	add    $0x1,%esi
  8024a1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a4:	74 12                	je     8024b8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8024a6:	8b 03                	mov    (%ebx),%eax
  8024a8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024ab:	75 d8                	jne    802485 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024ad:	85 f6                	test   %esi,%esi
  8024af:	75 b7                	jne    802468 <devpipe_read+0x23>
  8024b1:	eb b9                	jmp    80246c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024b8:	89 f0                	mov    %esi,%eax
  8024ba:	eb 05                	jmp    8024c1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024c1:	83 c4 1c             	add    $0x1c,%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5f                   	pop    %edi
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    

008024c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	56                   	push   %esi
  8024cd:	53                   	push   %ebx
  8024ce:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024d4:	89 04 24             	mov    %eax,(%esp)
  8024d7:	e8 4b ef ff ff       	call   801427 <fd_alloc>
  8024dc:	89 c2                	mov    %eax,%edx
  8024de:	85 d2                	test   %edx,%edx
  8024e0:	0f 88 4d 01 00 00    	js     802633 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024ed:	00 
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fc:	e8 48 e9 ff ff       	call   800e49 <sys_page_alloc>
  802501:	89 c2                	mov    %eax,%edx
  802503:	85 d2                	test   %edx,%edx
  802505:	0f 88 28 01 00 00    	js     802633 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80250b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80250e:	89 04 24             	mov    %eax,(%esp)
  802511:	e8 11 ef ff ff       	call   801427 <fd_alloc>
  802516:	89 c3                	mov    %eax,%ebx
  802518:	85 c0                	test   %eax,%eax
  80251a:	0f 88 fe 00 00 00    	js     80261e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802520:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802527:	00 
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802536:	e8 0e e9 ff ff       	call   800e49 <sys_page_alloc>
  80253b:	89 c3                	mov    %eax,%ebx
  80253d:	85 c0                	test   %eax,%eax
  80253f:	0f 88 d9 00 00 00    	js     80261e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	89 04 24             	mov    %eax,(%esp)
  80254b:	e8 c0 ee ff ff       	call   801410 <fd2data>
  802550:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802552:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802559:	00 
  80255a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802565:	e8 df e8 ff ff       	call   800e49 <sys_page_alloc>
  80256a:	89 c3                	mov    %eax,%ebx
  80256c:	85 c0                	test   %eax,%eax
  80256e:	0f 88 97 00 00 00    	js     80260b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	89 04 24             	mov    %eax,(%esp)
  80257a:	e8 91 ee ff ff       	call   801410 <fd2data>
  80257f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802586:	00 
  802587:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80258b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802592:	00 
  802593:	89 74 24 04          	mov    %esi,0x4(%esp)
  802597:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80259e:	e8 fa e8 ff ff       	call   800e9d <sys_page_map>
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 52                	js     8025fb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025a9:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025be:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 22 ee ff ff       	call   801400 <fd2num>
  8025de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e6:	89 04 24             	mov    %eax,(%esp)
  8025e9:	e8 12 ee ff ff       	call   801400 <fd2num>
  8025ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	eb 38                	jmp    802633 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8025fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802606:	e8 e5 e8 ff ff       	call   800ef0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802612:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802619:	e8 d2 e8 ff ff       	call   800ef0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	89 44 24 04          	mov    %eax,0x4(%esp)
  802625:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80262c:	e8 bf e8 ff ff       	call   800ef0 <sys_page_unmap>
  802631:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802633:	83 c4 30             	add    $0x30,%esp
  802636:	5b                   	pop    %ebx
  802637:	5e                   	pop    %esi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    

0080263a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802640:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802643:	89 44 24 04          	mov    %eax,0x4(%esp)
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	89 04 24             	mov    %eax,(%esp)
  80264d:	e8 49 ee ff ff       	call   80149b <fd_lookup>
  802652:	89 c2                	mov    %eax,%edx
  802654:	85 d2                	test   %edx,%edx
  802656:	78 15                	js     80266d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	89 04 24             	mov    %eax,(%esp)
  80265e:	e8 ad ed ff ff       	call   801410 <fd2data>
	return _pipeisclosed(fd, p);
  802663:	89 c2                	mov    %eax,%edx
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	e8 de fc ff ff       	call   80234b <_pipeisclosed>
}
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	56                   	push   %esi
  802673:	53                   	push   %ebx
  802674:	83 ec 10             	sub    $0x10,%esp
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80267a:	85 c0                	test   %eax,%eax
  80267c:	75 24                	jne    8026a2 <wait+0x33>
  80267e:	c7 44 24 0c 41 34 80 	movl   $0x803441,0xc(%esp)
  802685:	00 
  802686:	c7 44 24 08 1d 33 80 	movl   $0x80331d,0x8(%esp)
  80268d:	00 
  80268e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802695:	00 
  802696:	c7 04 24 4c 34 80 00 	movl   $0x80344c,(%esp)
  80269d:	e8 a6 db ff ff       	call   800248 <_panic>
	e = &envs[ENVX(envid)];
  8026a2:	89 c3                	mov    %eax,%ebx
  8026a4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8026aa:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8026ad:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026b3:	8b 73 48             	mov    0x48(%ebx),%esi
  8026b6:	39 c6                	cmp    %eax,%esi
  8026b8:	75 1a                	jne    8026d4 <wait+0x65>
  8026ba:	8b 43 54             	mov    0x54(%ebx),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 13                	je     8026d4 <wait+0x65>
		sys_yield();
  8026c1:	e8 64 e7 ff ff       	call   800e2a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026c6:	8b 43 48             	mov    0x48(%ebx),%eax
  8026c9:	39 f0                	cmp    %esi,%eax
  8026cb:	75 07                	jne    8026d4 <wait+0x65>
  8026cd:	8b 43 54             	mov    0x54(%ebx),%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	75 ed                	jne    8026c1 <wait+0x52>
		sys_yield();
}
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    
  8026db:	66 90                	xchg   %ax,%ax
  8026dd:	66 90                	xchg   %ax,%ax
  8026df:	90                   	nop

008026e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	5d                   	pop    %ebp
  8026e9:	c3                   	ret    

008026ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026f0:	c7 44 24 04 57 34 80 	movl   $0x803457,0x4(%esp)
  8026f7:	00 
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	89 04 24             	mov    %eax,(%esp)
  8026fe:	e8 98 e2 ff ff       	call   80099b <strcpy>
	return 0;
}
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	57                   	push   %edi
  80270e:	56                   	push   %esi
  80270f:	53                   	push   %ebx
  802710:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802716:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80271a:	74 4a                	je     802766 <devcons_write+0x5c>
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802726:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80272c:	8b 75 10             	mov    0x10(%ebp),%esi
  80272f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802731:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802734:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802739:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80273c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802740:	03 45 0c             	add    0xc(%ebp),%eax
  802743:	89 44 24 04          	mov    %eax,0x4(%esp)
  802747:	89 3c 24             	mov    %edi,(%esp)
  80274a:	e8 47 e4 ff ff       	call   800b96 <memmove>
		sys_cputs(buf, m);
  80274f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802753:	89 3c 24             	mov    %edi,(%esp)
  802756:	e8 21 e6 ff ff       	call   800d7c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80275b:	01 f3                	add    %esi,%ebx
  80275d:	89 d8                	mov    %ebx,%eax
  80275f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802762:	72 c8                	jb     80272c <devcons_write+0x22>
  802764:	eb 05                	jmp    80276b <devcons_write+0x61>
  802766:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80276b:	89 d8                	mov    %ebx,%eax
  80276d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802773:	5b                   	pop    %ebx
  802774:	5e                   	pop    %esi
  802775:	5f                   	pop    %edi
  802776:	5d                   	pop    %ebp
  802777:	c3                   	ret    

00802778 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802783:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802787:	75 07                	jne    802790 <devcons_read+0x18>
  802789:	eb 28                	jmp    8027b3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80278b:	e8 9a e6 ff ff       	call   800e2a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802790:	e8 05 e6 ff ff       	call   800d9a <sys_cgetc>
  802795:	85 c0                	test   %eax,%eax
  802797:	74 f2                	je     80278b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802799:	85 c0                	test   %eax,%eax
  80279b:	78 16                	js     8027b3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80279d:	83 f8 04             	cmp    $0x4,%eax
  8027a0:	74 0c                	je     8027ae <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8027a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a5:	88 02                	mov    %al,(%edx)
	return 1;
  8027a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ac:	eb 05                	jmp    8027b3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027c8:	00 
  8027c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027cc:	89 04 24             	mov    %eax,(%esp)
  8027cf:	e8 a8 e5 ff ff       	call   800d7c <sys_cputs>
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <getchar>:

int
getchar(void)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027e3:	00 
  8027e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f2:	e8 4f ef ff ff       	call   801746 <read>
	if (r < 0)
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	78 0f                	js     80280a <getchar+0x34>
		return r;
	if (r < 1)
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	7e 06                	jle    802805 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802803:	eb 05                	jmp    80280a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802805:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802812:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802815:	89 44 24 04          	mov    %eax,0x4(%esp)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	89 04 24             	mov    %eax,(%esp)
  80281f:	e8 77 ec ff ff       	call   80149b <fd_lookup>
  802824:	85 c0                	test   %eax,%eax
  802826:	78 11                	js     802839 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802831:	39 10                	cmp    %edx,(%eax)
  802833:	0f 94 c0             	sete   %al
  802836:	0f b6 c0             	movzbl %al,%eax
}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <opencons>:

int
opencons(void)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802844:	89 04 24             	mov    %eax,(%esp)
  802847:	e8 db eb ff ff       	call   801427 <fd_alloc>
		return r;
  80284c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80284e:	85 c0                	test   %eax,%eax
  802850:	78 40                	js     802892 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802852:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802859:	00 
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802868:	e8 dc e5 ff ff       	call   800e49 <sys_page_alloc>
		return r;
  80286d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80286f:	85 c0                	test   %eax,%eax
  802871:	78 1f                	js     802892 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802873:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802888:	89 04 24             	mov    %eax,(%esp)
  80288b:	e8 70 eb ff ff       	call   801400 <fd2num>
  802890:	89 c2                	mov    %eax,%edx
}
  802892:	89 d0                	mov    %edx,%eax
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80289c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8028a3:	75 50                	jne    8028f5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8028a5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8028ac:	00 
  8028ad:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8028b4:	ee 
  8028b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028bc:	e8 88 e5 ff ff       	call   800e49 <sys_page_alloc>
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	79 1c                	jns    8028e1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8028c5:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  8028cc:	00 
  8028cd:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8028d4:	00 
  8028d5:	c7 04 24 88 34 80 00 	movl   $0x803488,(%esp)
  8028dc:	e8 67 d9 ff ff       	call   800248 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8028e1:	c7 44 24 04 ff 28 80 	movl   $0x8028ff,0x4(%esp)
  8028e8:	00 
  8028e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f0:	e8 f4 e6 ff ff       	call   800fe9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028ff:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802900:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802905:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802907:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80290a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80290c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802911:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802914:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802919:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80291c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80291e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802921:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802923:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802925:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80292a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80292d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802932:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802935:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802937:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80293c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80293f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802944:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802947:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802949:	83 c4 08             	add    $0x8,%esp
	popal
  80294c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80294d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80294e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80294f:	c3                   	ret    

00802950 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	56                   	push   %esi
  802954:	53                   	push   %ebx
  802955:	83 ec 10             	sub    $0x10,%esp
  802958:	8b 75 08             	mov    0x8(%ebp),%esi
  80295b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  802961:	85 c0                	test   %eax,%eax
  802963:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802968:	0f 44 c2             	cmove  %edx,%eax
  80296b:	89 04 24             	mov    %eax,(%esp)
  80296e:	e8 ec e6 ff ff       	call   80105f <sys_ipc_recv>
	if (err_code < 0) {
  802973:	85 c0                	test   %eax,%eax
  802975:	79 16                	jns    80298d <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802977:	85 f6                	test   %esi,%esi
  802979:	74 06                	je     802981 <ipc_recv+0x31>
  80297b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802981:	85 db                	test   %ebx,%ebx
  802983:	74 2c                	je     8029b1 <ipc_recv+0x61>
  802985:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80298b:	eb 24                	jmp    8029b1 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80298d:	85 f6                	test   %esi,%esi
  80298f:	74 0a                	je     80299b <ipc_recv+0x4b>
  802991:	a1 04 50 80 00       	mov    0x805004,%eax
  802996:	8b 40 74             	mov    0x74(%eax),%eax
  802999:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80299b:	85 db                	test   %ebx,%ebx
  80299d:	74 0a                	je     8029a9 <ipc_recv+0x59>
  80299f:	a1 04 50 80 00       	mov    0x805004,%eax
  8029a4:	8b 40 78             	mov    0x78(%eax),%eax
  8029a7:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8029a9:	a1 04 50 80 00       	mov    0x805004,%eax
  8029ae:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	5b                   	pop    %ebx
  8029b5:	5e                   	pop    %esi
  8029b6:	5d                   	pop    %ebp
  8029b7:	c3                   	ret    

008029b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
  8029bb:	57                   	push   %edi
  8029bc:	56                   	push   %esi
  8029bd:	53                   	push   %ebx
  8029be:	83 ec 1c             	sub    $0x1c,%esp
  8029c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8029ca:	eb 25                	jmp    8029f1 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8029cc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029cf:	74 20                	je     8029f1 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8029d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029d5:	c7 44 24 08 96 34 80 	movl   $0x803496,0x8(%esp)
  8029dc:	00 
  8029dd:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8029e4:	00 
  8029e5:	c7 04 24 a2 34 80 00 	movl   $0x8034a2,(%esp)
  8029ec:	e8 57 d8 ff ff       	call   800248 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8029f1:	85 db                	test   %ebx,%ebx
  8029f3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029f8:	0f 45 c3             	cmovne %ebx,%eax
  8029fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8029fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a06:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a0a:	89 3c 24             	mov    %edi,(%esp)
  802a0d:	e8 2a e6 ff ff       	call   80103c <sys_ipc_try_send>
  802a12:	85 c0                	test   %eax,%eax
  802a14:	75 b6                	jne    8029cc <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802a16:	83 c4 1c             	add    $0x1c,%esp
  802a19:	5b                   	pop    %ebx
  802a1a:	5e                   	pop    %esi
  802a1b:	5f                   	pop    %edi
  802a1c:	5d                   	pop    %ebp
  802a1d:	c3                   	ret    

00802a1e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802a24:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802a29:	39 c8                	cmp    %ecx,%eax
  802a2b:	74 17                	je     802a44 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a2d:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802a32:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802a35:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a3b:	8b 52 50             	mov    0x50(%edx),%edx
  802a3e:	39 ca                	cmp    %ecx,%edx
  802a40:	75 14                	jne    802a56 <ipc_find_env+0x38>
  802a42:	eb 05                	jmp    802a49 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802a49:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a4c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802a51:	8b 40 40             	mov    0x40(%eax),%eax
  802a54:	eb 0e                	jmp    802a64 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a56:	83 c0 01             	add    $0x1,%eax
  802a59:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a5e:	75 d2                	jne    802a32 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a60:	66 b8 00 00          	mov    $0x0,%ax
}
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    

00802a66 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a66:	55                   	push   %ebp
  802a67:	89 e5                	mov    %esp,%ebp
  802a69:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a6c:	89 d0                	mov    %edx,%eax
  802a6e:	c1 e8 16             	shr    $0x16,%eax
  802a71:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a7d:	f6 c1 01             	test   $0x1,%cl
  802a80:	74 1d                	je     802a9f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a82:	c1 ea 0c             	shr    $0xc,%edx
  802a85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a8c:	f6 c2 01             	test   $0x1,%dl
  802a8f:	74 0e                	je     802a9f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a91:	c1 ea 0c             	shr    $0xc,%edx
  802a94:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a9b:	ef 
  802a9c:	0f b7 c0             	movzwl %ax,%eax
}
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    
  802aa1:	66 90                	xchg   %ax,%ax
  802aa3:	66 90                	xchg   %ax,%ax
  802aa5:	66 90                	xchg   %ax,%ax
  802aa7:	66 90                	xchg   %ax,%ax
  802aa9:	66 90                	xchg   %ax,%ax
  802aab:	66 90                	xchg   %ax,%ax
  802aad:	66 90                	xchg   %ax,%ax
  802aaf:	90                   	nop

00802ab0 <__udivdi3>:
  802ab0:	55                   	push   %ebp
  802ab1:	57                   	push   %edi
  802ab2:	56                   	push   %esi
  802ab3:	83 ec 0c             	sub    $0xc,%esp
  802ab6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802abe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ac2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802acc:	89 ea                	mov    %ebp,%edx
  802ace:	89 0c 24             	mov    %ecx,(%esp)
  802ad1:	75 2d                	jne    802b00 <__udivdi3+0x50>
  802ad3:	39 e9                	cmp    %ebp,%ecx
  802ad5:	77 61                	ja     802b38 <__udivdi3+0x88>
  802ad7:	85 c9                	test   %ecx,%ecx
  802ad9:	89 ce                	mov    %ecx,%esi
  802adb:	75 0b                	jne    802ae8 <__udivdi3+0x38>
  802add:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae2:	31 d2                	xor    %edx,%edx
  802ae4:	f7 f1                	div    %ecx
  802ae6:	89 c6                	mov    %eax,%esi
  802ae8:	31 d2                	xor    %edx,%edx
  802aea:	89 e8                	mov    %ebp,%eax
  802aec:	f7 f6                	div    %esi
  802aee:	89 c5                	mov    %eax,%ebp
  802af0:	89 f8                	mov    %edi,%eax
  802af2:	f7 f6                	div    %esi
  802af4:	89 ea                	mov    %ebp,%edx
  802af6:	83 c4 0c             	add    $0xc,%esp
  802af9:	5e                   	pop    %esi
  802afa:	5f                   	pop    %edi
  802afb:	5d                   	pop    %ebp
  802afc:	c3                   	ret    
  802afd:	8d 76 00             	lea    0x0(%esi),%esi
  802b00:	39 e8                	cmp    %ebp,%eax
  802b02:	77 24                	ja     802b28 <__udivdi3+0x78>
  802b04:	0f bd e8             	bsr    %eax,%ebp
  802b07:	83 f5 1f             	xor    $0x1f,%ebp
  802b0a:	75 3c                	jne    802b48 <__udivdi3+0x98>
  802b0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b10:	39 34 24             	cmp    %esi,(%esp)
  802b13:	0f 86 9f 00 00 00    	jbe    802bb8 <__udivdi3+0x108>
  802b19:	39 d0                	cmp    %edx,%eax
  802b1b:	0f 82 97 00 00 00    	jb     802bb8 <__udivdi3+0x108>
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	31 d2                	xor    %edx,%edx
  802b2a:	31 c0                	xor    %eax,%eax
  802b2c:	83 c4 0c             	add    $0xc,%esp
  802b2f:	5e                   	pop    %esi
  802b30:	5f                   	pop    %edi
  802b31:	5d                   	pop    %ebp
  802b32:	c3                   	ret    
  802b33:	90                   	nop
  802b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 f8                	mov    %edi,%eax
  802b3a:	f7 f1                	div    %ecx
  802b3c:	31 d2                	xor    %edx,%edx
  802b3e:	83 c4 0c             	add    $0xc,%esp
  802b41:	5e                   	pop    %esi
  802b42:	5f                   	pop    %edi
  802b43:	5d                   	pop    %ebp
  802b44:	c3                   	ret    
  802b45:	8d 76 00             	lea    0x0(%esi),%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	8b 3c 24             	mov    (%esp),%edi
  802b4d:	d3 e0                	shl    %cl,%eax
  802b4f:	89 c6                	mov    %eax,%esi
  802b51:	b8 20 00 00 00       	mov    $0x20,%eax
  802b56:	29 e8                	sub    %ebp,%eax
  802b58:	89 c1                	mov    %eax,%ecx
  802b5a:	d3 ef                	shr    %cl,%edi
  802b5c:	89 e9                	mov    %ebp,%ecx
  802b5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b62:	8b 3c 24             	mov    (%esp),%edi
  802b65:	09 74 24 08          	or     %esi,0x8(%esp)
  802b69:	89 d6                	mov    %edx,%esi
  802b6b:	d3 e7                	shl    %cl,%edi
  802b6d:	89 c1                	mov    %eax,%ecx
  802b6f:	89 3c 24             	mov    %edi,(%esp)
  802b72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b76:	d3 ee                	shr    %cl,%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	d3 e2                	shl    %cl,%edx
  802b7c:	89 c1                	mov    %eax,%ecx
  802b7e:	d3 ef                	shr    %cl,%edi
  802b80:	09 d7                	or     %edx,%edi
  802b82:	89 f2                	mov    %esi,%edx
  802b84:	89 f8                	mov    %edi,%eax
  802b86:	f7 74 24 08          	divl   0x8(%esp)
  802b8a:	89 d6                	mov    %edx,%esi
  802b8c:	89 c7                	mov    %eax,%edi
  802b8e:	f7 24 24             	mull   (%esp)
  802b91:	39 d6                	cmp    %edx,%esi
  802b93:	89 14 24             	mov    %edx,(%esp)
  802b96:	72 30                	jb     802bc8 <__udivdi3+0x118>
  802b98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b9c:	89 e9                	mov    %ebp,%ecx
  802b9e:	d3 e2                	shl    %cl,%edx
  802ba0:	39 c2                	cmp    %eax,%edx
  802ba2:	73 05                	jae    802ba9 <__udivdi3+0xf9>
  802ba4:	3b 34 24             	cmp    (%esp),%esi
  802ba7:	74 1f                	je     802bc8 <__udivdi3+0x118>
  802ba9:	89 f8                	mov    %edi,%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	e9 7a ff ff ff       	jmp    802b2c <__udivdi3+0x7c>
  802bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbf:	e9 68 ff ff ff       	jmp    802b2c <__udivdi3+0x7c>
  802bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bcb:	31 d2                	xor    %edx,%edx
  802bcd:	83 c4 0c             	add    $0xc,%esp
  802bd0:	5e                   	pop    %esi
  802bd1:	5f                   	pop    %edi
  802bd2:	5d                   	pop    %ebp
  802bd3:	c3                   	ret    
  802bd4:	66 90                	xchg   %ax,%ax
  802bd6:	66 90                	xchg   %ax,%ax
  802bd8:	66 90                	xchg   %ax,%ax
  802bda:	66 90                	xchg   %ax,%ax
  802bdc:	66 90                	xchg   %ax,%ax
  802bde:	66 90                	xchg   %ax,%ax

00802be0 <__umoddi3>:
  802be0:	55                   	push   %ebp
  802be1:	57                   	push   %edi
  802be2:	56                   	push   %esi
  802be3:	83 ec 14             	sub    $0x14,%esp
  802be6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802bf2:	89 c7                	mov    %eax,%edi
  802bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bfc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c00:	89 34 24             	mov    %esi,(%esp)
  802c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c07:	85 c0                	test   %eax,%eax
  802c09:	89 c2                	mov    %eax,%edx
  802c0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c0f:	75 17                	jne    802c28 <__umoddi3+0x48>
  802c11:	39 fe                	cmp    %edi,%esi
  802c13:	76 4b                	jbe    802c60 <__umoddi3+0x80>
  802c15:	89 c8                	mov    %ecx,%eax
  802c17:	89 fa                	mov    %edi,%edx
  802c19:	f7 f6                	div    %esi
  802c1b:	89 d0                	mov    %edx,%eax
  802c1d:	31 d2                	xor    %edx,%edx
  802c1f:	83 c4 14             	add    $0x14,%esp
  802c22:	5e                   	pop    %esi
  802c23:	5f                   	pop    %edi
  802c24:	5d                   	pop    %ebp
  802c25:	c3                   	ret    
  802c26:	66 90                	xchg   %ax,%ax
  802c28:	39 f8                	cmp    %edi,%eax
  802c2a:	77 54                	ja     802c80 <__umoddi3+0xa0>
  802c2c:	0f bd e8             	bsr    %eax,%ebp
  802c2f:	83 f5 1f             	xor    $0x1f,%ebp
  802c32:	75 5c                	jne    802c90 <__umoddi3+0xb0>
  802c34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c38:	39 3c 24             	cmp    %edi,(%esp)
  802c3b:	0f 87 e7 00 00 00    	ja     802d28 <__umoddi3+0x148>
  802c41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c45:	29 f1                	sub    %esi,%ecx
  802c47:	19 c7                	sbb    %eax,%edi
  802c49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c59:	83 c4 14             	add    $0x14,%esp
  802c5c:	5e                   	pop    %esi
  802c5d:	5f                   	pop    %edi
  802c5e:	5d                   	pop    %ebp
  802c5f:	c3                   	ret    
  802c60:	85 f6                	test   %esi,%esi
  802c62:	89 f5                	mov    %esi,%ebp
  802c64:	75 0b                	jne    802c71 <__umoddi3+0x91>
  802c66:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6b:	31 d2                	xor    %edx,%edx
  802c6d:	f7 f6                	div    %esi
  802c6f:	89 c5                	mov    %eax,%ebp
  802c71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c75:	31 d2                	xor    %edx,%edx
  802c77:	f7 f5                	div    %ebp
  802c79:	89 c8                	mov    %ecx,%eax
  802c7b:	f7 f5                	div    %ebp
  802c7d:	eb 9c                	jmp    802c1b <__umoddi3+0x3b>
  802c7f:	90                   	nop
  802c80:	89 c8                	mov    %ecx,%eax
  802c82:	89 fa                	mov    %edi,%edx
  802c84:	83 c4 14             	add    $0x14,%esp
  802c87:	5e                   	pop    %esi
  802c88:	5f                   	pop    %edi
  802c89:	5d                   	pop    %ebp
  802c8a:	c3                   	ret    
  802c8b:	90                   	nop
  802c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c90:	8b 04 24             	mov    (%esp),%eax
  802c93:	be 20 00 00 00       	mov    $0x20,%esi
  802c98:	89 e9                	mov    %ebp,%ecx
  802c9a:	29 ee                	sub    %ebp,%esi
  802c9c:	d3 e2                	shl    %cl,%edx
  802c9e:	89 f1                	mov    %esi,%ecx
  802ca0:	d3 e8                	shr    %cl,%eax
  802ca2:	89 e9                	mov    %ebp,%ecx
  802ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca8:	8b 04 24             	mov    (%esp),%eax
  802cab:	09 54 24 04          	or     %edx,0x4(%esp)
  802caf:	89 fa                	mov    %edi,%edx
  802cb1:	d3 e0                	shl    %cl,%eax
  802cb3:	89 f1                	mov    %esi,%ecx
  802cb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cb9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802cbd:	d3 ea                	shr    %cl,%edx
  802cbf:	89 e9                	mov    %ebp,%ecx
  802cc1:	d3 e7                	shl    %cl,%edi
  802cc3:	89 f1                	mov    %esi,%ecx
  802cc5:	d3 e8                	shr    %cl,%eax
  802cc7:	89 e9                	mov    %ebp,%ecx
  802cc9:	09 f8                	or     %edi,%eax
  802ccb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802ccf:	f7 74 24 04          	divl   0x4(%esp)
  802cd3:	d3 e7                	shl    %cl,%edi
  802cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cd9:	89 d7                	mov    %edx,%edi
  802cdb:	f7 64 24 08          	mull   0x8(%esp)
  802cdf:	39 d7                	cmp    %edx,%edi
  802ce1:	89 c1                	mov    %eax,%ecx
  802ce3:	89 14 24             	mov    %edx,(%esp)
  802ce6:	72 2c                	jb     802d14 <__umoddi3+0x134>
  802ce8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802cec:	72 22                	jb     802d10 <__umoddi3+0x130>
  802cee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802cf2:	29 c8                	sub    %ecx,%eax
  802cf4:	19 d7                	sbb    %edx,%edi
  802cf6:	89 e9                	mov    %ebp,%ecx
  802cf8:	89 fa                	mov    %edi,%edx
  802cfa:	d3 e8                	shr    %cl,%eax
  802cfc:	89 f1                	mov    %esi,%ecx
  802cfe:	d3 e2                	shl    %cl,%edx
  802d00:	89 e9                	mov    %ebp,%ecx
  802d02:	d3 ef                	shr    %cl,%edi
  802d04:	09 d0                	or     %edx,%eax
  802d06:	89 fa                	mov    %edi,%edx
  802d08:	83 c4 14             	add    $0x14,%esp
  802d0b:	5e                   	pop    %esi
  802d0c:	5f                   	pop    %edi
  802d0d:	5d                   	pop    %ebp
  802d0e:	c3                   	ret    
  802d0f:	90                   	nop
  802d10:	39 d7                	cmp    %edx,%edi
  802d12:	75 da                	jne    802cee <__umoddi3+0x10e>
  802d14:	8b 14 24             	mov    (%esp),%edx
  802d17:	89 c1                	mov    %eax,%ecx
  802d19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d21:	eb cb                	jmp    802cee <__umoddi3+0x10e>
  802d23:	90                   	nop
  802d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d2c:	0f 82 0f ff ff ff    	jb     802c41 <__umoddi3+0x61>
  802d32:	e9 1a ff ff ff       	jmp    802c51 <__umoddi3+0x71>
