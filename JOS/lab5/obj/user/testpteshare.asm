
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
  80002c:	e8 94 01 00 00       	call   8001c5 <libmain>
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
  800049:	e8 5d 09 00 00       	call   8009ab <strcpy>
	exit();
  80004e:	e8 ea 01 00 00       	call   80023d <exit>
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
  80007e:	e8 d6 0d 00 00       	call   800e59 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 cc 2d 80 	movl   $0x802dcc,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 df 2d 80 00 	movl   $0x802ddf,(%esp)
  8000a2:	e8 af 01 00 00       	call   800256 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 04 11 00 00       	call   8011b0 <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 f3 2d 80 	movl   $0x802df3,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 df 2d 80 00 	movl   $0x802ddf,(%esp)
  8000cd:	e8 84 01 00 00       	call   800256 <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 c0 08 00 00       	call   8009ab <strcpy>
		exit();
  8000eb:	e8 4d 01 00 00       	call   80023d <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 f7 25 00 00       	call   8026ef <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 68 09 00 00       	call   800a75 <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 c0 2d 80 00       	mov    $0x802dc0,%eax
  800114:	ba c6 2d 80 00       	mov    $0x802dc6,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800127:	e8 23 02 00 00       	call   80034f <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 17 2e 80 	movl   $0x802e17,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 1c 2e 80 	movl   $0x802e1c,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 1b 2e 80 00 	movl   $0x802e1b,(%esp)
  80014b:	e8 55 21 00 00       	call   8022a5 <spawnl>
  800150:	89 c3                	mov    %eax,%ebx
  800152:	85 c0                	test   %eax,%eax
  800154:	79 20                	jns    800176 <umain+0x121>
		panic("spawn: %e", r);
  800156:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015a:	c7 44 24 08 29 2e 80 	movl   $0x802e29,0x8(%esp)
  800161:	00 
  800162:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800169:	00 
  80016a:	c7 04 24 df 2d 80 00 	movl   $0x802ddf,(%esp)
  800171:	e8 e0 00 00 00       	call   800256 <_panic>
	cprintf("try to wait.\n");
  800176:	c7 04 24 33 2e 80 00 	movl   $0x802e33,(%esp)
  80017d:	e8 cd 01 00 00       	call   80034f <cprintf>
	wait(r);
  800182:	89 1c 24             	mov    %ebx,(%esp)
  800185:	e8 65 25 00 00       	call   8026ef <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80018a:	a1 00 40 80 00       	mov    0x804000,%eax
  80018f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800193:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80019a:	e8 d6 08 00 00       	call   800a75 <strcmp>
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	b8 c0 2d 80 00       	mov    $0x802dc0,%eax
  8001a6:	ba c6 2d 80 00       	mov    $0x802dc6,%edx
  8001ab:	0f 45 c2             	cmovne %edx,%eax
  8001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b2:	c7 04 24 41 2e 80 00 	movl   $0x802e41,(%esp)
  8001b9:	e8 91 01 00 00       	call   80034f <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001be:	cc                   	int3   

	breakpoint();
}
  8001bf:	83 c4 14             	add    $0x14,%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5d                   	pop    %ebp
  8001c4:	c3                   	ret    

008001c5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 10             	sub    $0x10,%esp
  8001cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8001d3:	e8 43 0c 00 00       	call   800e1b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8001d8:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 17                	je     8001f9 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001e2:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8001e7:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8001ea:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8001f0:	8b 49 40             	mov    0x40(%ecx),%ecx
  8001f3:	39 c1                	cmp    %eax,%ecx
  8001f5:	75 18                	jne    80020f <libmain+0x4a>
  8001f7:	eb 05                	jmp    8001fe <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8001f9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8001fe:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800201:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800207:	89 15 04 50 80 00    	mov    %edx,0x805004
			break;
  80020d:	eb 0b                	jmp    80021a <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80020f:	83 c2 01             	add    $0x1,%edx
  800212:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800218:	75 cd                	jne    8001e7 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7e 07                	jle    800225 <libmain+0x60>
		binaryname = argv[0];
  80021e:	8b 06                	mov    (%esi),%eax
  800220:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800225:	89 74 24 04          	mov    %esi,0x4(%esp)
  800229:	89 1c 24             	mov    %ebx,(%esp)
  80022c:	e8 24 fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  800231:	e8 07 00 00 00       	call   80023d <exit>
}
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	5b                   	pop    %ebx
  80023a:	5e                   	pop    %esi
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    

0080023d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800243:	e8 ee 13 00 00       	call   801636 <close_all>
	sys_env_destroy(0);
  800248:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024f:	e8 75 0b 00 00       	call   800dc9 <sys_env_destroy>
}
  800254:	c9                   	leave  
  800255:	c3                   	ret    

00800256 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	56                   	push   %esi
  80025a:	53                   	push   %ebx
  80025b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80025e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800261:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800267:	e8 af 0b 00 00       	call   800e1b <sys_getenvid>
  80026c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026f:	89 54 24 10          	mov    %edx,0x10(%esp)
  800273:	8b 55 08             	mov    0x8(%ebp),%edx
  800276:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80027a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80027e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800282:	c7 04 24 88 2e 80 00 	movl   $0x802e88,(%esp)
  800289:	e8 c1 00 00 00       	call   80034f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80028e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800292:	8b 45 10             	mov    0x10(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	e8 51 00 00 00       	call   8002ee <vcprintf>
	cprintf("\n");
  80029d:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  8002a4:	e8 a6 00 00 00       	call   80034f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a9:	cc                   	int3   
  8002aa:	eb fd                	jmp    8002a9 <_panic+0x53>

008002ac <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 14             	sub    $0x14,%esp
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b6:	8b 13                	mov    (%ebx),%edx
  8002b8:	8d 42 01             	lea    0x1(%edx),%eax
  8002bb:	89 03                	mov    %eax,(%ebx)
  8002bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c9:	75 19                	jne    8002e4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002cb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002d2:	00 
  8002d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d6:	89 04 24             	mov    %eax,(%esp)
  8002d9:	e8 ae 0a 00 00       	call   800d8c <sys_cputs>
		b->idx = 0;
  8002de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002e4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002e8:	83 c4 14             	add    $0x14,%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fe:	00 00 00 
	b.cnt = 0;
  800301:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800308:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	89 44 24 08          	mov    %eax,0x8(%esp)
  800319:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800323:	c7 04 24 ac 02 80 00 	movl   $0x8002ac,(%esp)
  80032a:	e8 b5 01 00 00       	call   8004e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80032f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800335:	89 44 24 04          	mov    %eax,0x4(%esp)
  800339:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	e8 45 0a 00 00       	call   800d8c <sys_cputs>

	return b.cnt;
}
  800347:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	89 04 24             	mov    %eax,(%esp)
  800362:	e8 87 ff ff ff       	call   8002ee <vcprintf>
	va_end(ap);

	return cnt;
}
  800367:	c9                   	leave  
  800368:	c3                   	ret    
  800369:	66 90                	xchg   %ax,%ax
  80036b:	66 90                	xchg   %ax,%ax
  80036d:	66 90                	xchg   %ax,%ax
  80036f:	90                   	nop

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
  8003ec:	e8 3f 27 00 00       	call   802b30 <__udivdi3>
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
  800445:	e8 16 28 00 00       	call   802c60 <__umoddi3>
  80044a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044e:	0f be 80 ab 2e 80 00 	movsbl 0x802eab(%eax),%eax
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
  80056c:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
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
  80061f:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  800626:	85 d2                	test   %edx,%edx
  800628:	75 20                	jne    80064a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80062a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80062e:	c7 44 24 08 c3 2e 80 	movl   $0x802ec3,0x8(%esp)
  800635:	00 
  800636:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	89 04 24             	mov    %eax,(%esp)
  800640:	e8 77 fe ff ff       	call   8004bc <printfmt>
  800645:	e9 c3 fe ff ff       	jmp    80050d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80064a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064e:	c7 44 24 08 8f 33 80 	movl   $0x80338f,0x8(%esp)
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
  80067d:	ba bc 2e 80 00       	mov    $0x802ebc,%edx
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
  800df7:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800dfe:	00 
  800dff:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e06:	00 
  800e07:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800e0e:	e8 43 f4 ff ff       	call   800256 <_panic>

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
  800e89:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800e90:	00 
  800e91:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e98:	00 
  800e99:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800ea0:	e8 b1 f3 ff ff       	call   800256 <_panic>

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
  800edc:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800ee3:	00 
  800ee4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eeb:	00 
  800eec:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800ef3:	e8 5e f3 ff ff       	call   800256 <_panic>

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
  800f2f:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800f36:	00 
  800f37:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f3e:	00 
  800f3f:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800f46:	e8 0b f3 ff ff       	call   800256 <_panic>

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
  800f82:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800f99:	e8 b8 f2 ff ff       	call   800256 <_panic>

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
  800fd5:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  800fdc:	00 
  800fdd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fe4:	00 
  800fe5:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  800fec:	e8 65 f2 ff ff       	call   800256 <_panic>

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
  801028:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  80102f:	00 
  801030:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801037:	00 
  801038:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  80103f:	e8 12 f2 ff ff       	call   800256 <_panic>

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
  80109d:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  8010a4:	00 
  8010a5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010ac:	00 
  8010ad:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  8010b4:	e8 9d f1 ff ff       	call   800256 <_panic>

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

008010c1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 24             	sub    $0x24,%esp
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010cb:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  8010cd:	89 da                	mov    %ebx,%edx
  8010cf:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  8010d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  8010d9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010dd:	74 05                	je     8010e4 <pgfault+0x23>
  8010df:	f6 c6 08             	test   $0x8,%dh
  8010e2:	75 1c                	jne    801100 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  8010e4:	c7 44 24 08 cc 31 80 	movl   $0x8031cc,0x8(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8010f3:	00 
  8010f4:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8010fb:	e8 56 f1 ff ff       	call   800256 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801100:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801107:	00 
  801108:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80110f:	00 
  801110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801117:	e8 3d fd ff ff       	call   800e59 <sys_page_alloc>
  80111c:	85 c0                	test   %eax,%eax
  80111e:	79 20                	jns    801140 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801120:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801124:	c7 44 24 08 34 32 80 	movl   $0x803234,0x8(%esp)
  80112b:	00 
  80112c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801133:	00 
  801134:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  80113b:	e8 16 f1 ff ff       	call   800256 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801140:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801146:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80114d:	00 
  80114e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801152:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801159:	e8 48 fa ff ff       	call   800ba6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80115e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801165:	00 
  801166:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80116a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801171:	00 
  801172:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801179:	00 
  80117a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801181:	e8 27 fd ff ff       	call   800ead <sys_page_map>
  801186:	85 c0                	test   %eax,%eax
  801188:	79 20                	jns    8011aa <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80118a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80118e:	c7 44 24 08 4e 32 80 	movl   $0x80324e,0x8(%esp)
  801195:	00 
  801196:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80119d:	00 
  80119e:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8011a5:	e8 ac f0 ff ff       	call   800256 <_panic>
	}
}
  8011aa:	83 c4 24             	add    $0x24,%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  8011b9:	c7 04 24 c1 10 80 00 	movl   $0x8010c1,(%esp)
  8011c0:	e8 51 17 00 00       	call   802916 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011c5:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ca:	cd 30                	int    $0x30
  8011cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	79 1c                	jns    8011ef <fork+0x3f>
		panic("fork");
  8011d3:	c7 44 24 08 67 32 80 	movl   $0x803267,0x8(%esp)
  8011da:	00 
  8011db:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8011e2:	00 
  8011e3:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8011ea:	e8 67 f0 ff ff       	call   800256 <_panic>
  8011ef:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  8011f1:	bb 00 08 00 00       	mov    $0x800,%ebx
  8011f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011fa:	75 21                	jne    80121d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  8011fc:	e8 1a fc ff ff       	call   800e1b <sys_getenvid>
  801201:	25 ff 03 00 00       	and    $0x3ff,%eax
  801206:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801209:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80120e:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
  801218:	e9 cf 01 00 00       	jmp    8013ec <fork+0x23c>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	c1 e8 0a             	shr    $0xa,%eax
  801222:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	0f 84 fc 00 00 00    	je     80132d <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801231:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801238:	a8 05                	test   $0x5,%al
  80123a:	0f 84 ed 00 00 00    	je     80132d <fork+0x17d>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801240:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801247:	89 de                	mov    %ebx,%esi
  801249:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  80124c:	f6 c4 04             	test   $0x4,%ah
  80124f:	0f 85 93 00 00 00    	jne    8012e8 <fork+0x138>
  801255:	a9 02 08 00 00       	test   $0x802,%eax
  80125a:	0f 84 88 00 00 00    	je     8012e8 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801260:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801267:	00 
  801268:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80126c:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801270:	89 74 24 04          	mov    %esi,0x4(%esp)
  801274:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127b:	e8 2d fc ff ff       	call   800ead <sys_page_map>
  801280:	85 c0                	test   %eax,%eax
  801282:	79 20                	jns    8012a4 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  801284:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801288:	c7 44 24 08 6c 32 80 	movl   $0x80326c,0x8(%esp)
  80128f:	00 
  801290:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801297:	00 
  801298:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  80129f:	e8 b2 ef ff ff       	call   800256 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8012a4:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012ab:	00 
  8012ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b7:	00 
  8012b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012bc:	89 3c 24             	mov    %edi,(%esp)
  8012bf:	e8 e9 fb ff ff       	call   800ead <sys_page_map>
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 65                	jns    80132d <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  8012c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cc:	c7 44 24 08 86 32 80 	movl   $0x803286,0x8(%esp)
  8012d3:	00 
  8012d4:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8012db:	00 
  8012dc:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8012e3:	e8 6e ef ff ff       	call   800256 <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  8012e8:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8012ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801304:	e8 a4 fb ff ff       	call   800ead <sys_page_map>
  801309:	85 c0                	test   %eax,%eax
  80130b:	79 20                	jns    80132d <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  80130d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801311:	c7 44 24 08 a0 32 80 	movl   $0x8032a0,0x8(%esp)
  801318:	00 
  801319:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801320:	00 
  801321:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  801328:	e8 29 ef ff ff       	call   800256 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  80132d:	83 c3 01             	add    $0x1,%ebx
  801330:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801336:	0f 85 e1 fe ff ff    	jne    80121d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  80133c:	c7 44 24 04 7f 29 80 	movl   $0x80297f,0x4(%esp)
  801343:	00 
  801344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801347:	89 04 24             	mov    %eax,(%esp)
  80134a:	e8 aa fc ff ff       	call   800ff9 <sys_env_set_pgfault_upcall>
  80134f:	85 c0                	test   %eax,%eax
  801351:	79 20                	jns    801373 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801353:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801357:	c7 44 24 08 04 32 80 	movl   $0x803204,0x8(%esp)
  80135e:	00 
  80135f:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  801366:	00 
  801367:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  80136e:	e8 e3 ee ff ff       	call   800256 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801373:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80137a:	00 
  80137b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801382:	ee 
  801383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801386:	89 04 24             	mov    %eax,(%esp)
  801389:	e8 cb fa ff ff       	call   800e59 <sys_page_alloc>
  80138e:	85 c0                	test   %eax,%eax
  801390:	79 20                	jns    8013b2 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801392:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801396:	c7 44 24 08 b2 32 80 	movl   $0x8032b2,0x8(%esp)
  80139d:	00 
  80139e:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8013a5:	00 
  8013a6:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8013ad:	e8 a4 ee ff ff       	call   800256 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8013b2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013b9:	00 
  8013ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bd:	89 04 24             	mov    %eax,(%esp)
  8013c0:	e8 8e fb ff ff       	call   800f53 <sys_env_set_status>
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	79 20                	jns    8013e9 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  8013c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013cd:	c7 44 24 08 ca 32 80 	movl   $0x8032ca,0x8(%esp)
  8013d4:	00 
  8013d5:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8013dc:	00 
  8013dd:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  8013e4:	e8 6d ee ff ff       	call   800256 <_panic>
	}

	return envid;
  8013e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8013ec:	83 c4 2c             	add    $0x2c,%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5f                   	pop    %edi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <sfork>:

// Challenge!
int
sfork(void)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013fa:	c7 44 24 08 e5 32 80 	movl   $0x8032e5,0x8(%esp)
  801401:	00 
  801402:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  801409:	00 
  80140a:	c7 04 24 29 32 80 00 	movl   $0x803229,(%esp)
  801411:	e8 40 ee ff ff       	call   800256 <_panic>
  801416:	66 90                	xchg   %ax,%ax
  801418:	66 90                	xchg   %ax,%ax
  80141a:	66 90                	xchg   %ax,%ax
  80141c:	66 90                	xchg   %ax,%ax
  80141e:	66 90                	xchg   %ax,%ax

00801420 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
  80142b:	c1 e8 0c             	shr    $0xc,%eax
}
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80143b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801440:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80144a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80144f:	a8 01                	test   $0x1,%al
  801451:	74 34                	je     801487 <fd_alloc+0x40>
  801453:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801458:	a8 01                	test   $0x1,%al
  80145a:	74 32                	je     80148e <fd_alloc+0x47>
  80145c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801461:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801463:	89 c2                	mov    %eax,%edx
  801465:	c1 ea 16             	shr    $0x16,%edx
  801468:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80146f:	f6 c2 01             	test   $0x1,%dl
  801472:	74 1f                	je     801493 <fd_alloc+0x4c>
  801474:	89 c2                	mov    %eax,%edx
  801476:	c1 ea 0c             	shr    $0xc,%edx
  801479:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801480:	f6 c2 01             	test   $0x1,%dl
  801483:	75 1a                	jne    80149f <fd_alloc+0x58>
  801485:	eb 0c                	jmp    801493 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801487:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80148c:	eb 05                	jmp    801493 <fd_alloc+0x4c>
  80148e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	89 08                	mov    %ecx,(%eax)
			return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
  80149d:	eb 1a                	jmp    8014b9 <fd_alloc+0x72>
  80149f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014a9:	75 b6                	jne    801461 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014c1:	83 f8 1f             	cmp    $0x1f,%eax
  8014c4:	77 36                	ja     8014fc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014c6:	c1 e0 0c             	shl    $0xc,%eax
  8014c9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014ce:	89 c2                	mov    %eax,%edx
  8014d0:	c1 ea 16             	shr    $0x16,%edx
  8014d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014da:	f6 c2 01             	test   $0x1,%dl
  8014dd:	74 24                	je     801503 <fd_lookup+0x48>
  8014df:	89 c2                	mov    %eax,%edx
  8014e1:	c1 ea 0c             	shr    $0xc,%edx
  8014e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014eb:	f6 c2 01             	test   $0x1,%dl
  8014ee:	74 1a                	je     80150a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f3:	89 02                	mov    %eax,(%edx)
	return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fa:	eb 13                	jmp    80150f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801501:	eb 0c                	jmp    80150f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801508:	eb 05                	jmp    80150f <fd_lookup+0x54>
  80150a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    

00801511 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	53                   	push   %ebx
  801515:	83 ec 14             	sub    $0x14,%esp
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80151e:	39 05 0c 40 80 00    	cmp    %eax,0x80400c
  801524:	75 1e                	jne    801544 <dev_lookup+0x33>
  801526:	eb 0e                	jmp    801536 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801528:	b8 28 40 80 00       	mov    $0x804028,%eax
  80152d:	eb 0c                	jmp    80153b <dev_lookup+0x2a>
  80152f:	b8 44 40 80 00       	mov    $0x804044,%eax
  801534:	eb 05                	jmp    80153b <dev_lookup+0x2a>
  801536:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80153b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	eb 38                	jmp    80157c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801544:	39 05 28 40 80 00    	cmp    %eax,0x804028
  80154a:	74 dc                	je     801528 <dev_lookup+0x17>
  80154c:	39 05 44 40 80 00    	cmp    %eax,0x804044
  801552:	74 db                	je     80152f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801554:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80155a:	8b 52 48             	mov    0x48(%edx),%edx
  80155d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801561:	89 54 24 04          	mov    %edx,0x4(%esp)
  801565:	c7 04 24 fc 32 80 00 	movl   $0x8032fc,(%esp)
  80156c:	e8 de ed ff ff       	call   80034f <cprintf>
	*dev = 0;
  801571:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80157c:	83 c4 14             	add    $0x14,%esp
  80157f:	5b                   	pop    %ebx
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	83 ec 20             	sub    $0x20,%esp
  80158a:	8b 75 08             	mov    0x8(%ebp),%esi
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801590:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801593:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801597:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80159d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a0:	89 04 24             	mov    %eax,(%esp)
  8015a3:	e8 13 ff ff ff       	call   8014bb <fd_lookup>
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 05                	js     8015b1 <fd_close+0x2f>
	    || fd != fd2)
  8015ac:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015af:	74 0c                	je     8015bd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015b1:	84 db                	test   %bl,%bl
  8015b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b8:	0f 44 c2             	cmove  %edx,%eax
  8015bb:	eb 3f                	jmp    8015fc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c4:	8b 06                	mov    (%esi),%eax
  8015c6:	89 04 24             	mov    %eax,(%esp)
  8015c9:	e8 43 ff ff ff       	call   801511 <dev_lookup>
  8015ce:	89 c3                	mov    %eax,%ebx
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 16                	js     8015ea <fd_close+0x68>
		if (dev->dev_close)
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015da:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	74 07                	je     8015ea <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015e3:	89 34 24             	mov    %esi,(%esp)
  8015e6:	ff d0                	call   *%eax
  8015e8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f5:	e8 06 f9 ff ff       	call   800f00 <sys_page_unmap>
	return r;
  8015fa:	89 d8                	mov    %ebx,%eax
}
  8015fc:	83 c4 20             	add    $0x20,%esp
  8015ff:	5b                   	pop    %ebx
  801600:	5e                   	pop    %esi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 04 24             	mov    %eax,(%esp)
  801616:	e8 a0 fe ff ff       	call   8014bb <fd_lookup>
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	85 d2                	test   %edx,%edx
  80161f:	78 13                	js     801634 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801621:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801628:	00 
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	89 04 24             	mov    %eax,(%esp)
  80162f:	e8 4e ff ff ff       	call   801582 <fd_close>
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <close_all>:

void
close_all(void)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80163d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801642:	89 1c 24             	mov    %ebx,(%esp)
  801645:	e8 b9 ff ff ff       	call   801603 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80164a:	83 c3 01             	add    $0x1,%ebx
  80164d:	83 fb 20             	cmp    $0x20,%ebx
  801650:	75 f0                	jne    801642 <close_all+0xc>
		close(i);
}
  801652:	83 c4 14             	add    $0x14,%esp
  801655:	5b                   	pop    %ebx
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	57                   	push   %edi
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801661:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	89 04 24             	mov    %eax,(%esp)
  80166e:	e8 48 fe ff ff       	call   8014bb <fd_lookup>
  801673:	89 c2                	mov    %eax,%edx
  801675:	85 d2                	test   %edx,%edx
  801677:	0f 88 e1 00 00 00    	js     80175e <dup+0x106>
		return r;
	close(newfdnum);
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 04 24             	mov    %eax,(%esp)
  801683:	e8 7b ff ff ff       	call   801603 <close>

	newfd = INDEX2FD(newfdnum);
  801688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80168b:	c1 e3 0c             	shl    $0xc,%ebx
  80168e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801697:	89 04 24             	mov    %eax,(%esp)
  80169a:	e8 91 fd ff ff       	call   801430 <fd2data>
  80169f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016a1:	89 1c 24             	mov    %ebx,(%esp)
  8016a4:	e8 87 fd ff ff       	call   801430 <fd2data>
  8016a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ab:	89 f0                	mov    %esi,%eax
  8016ad:	c1 e8 16             	shr    $0x16,%eax
  8016b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b7:	a8 01                	test   $0x1,%al
  8016b9:	74 43                	je     8016fe <dup+0xa6>
  8016bb:	89 f0                	mov    %esi,%eax
  8016bd:	c1 e8 0c             	shr    $0xc,%eax
  8016c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016c7:	f6 c2 01             	test   $0x1,%dl
  8016ca:	74 32                	je     8016fe <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016e7:	00 
  8016e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f3:	e8 b5 f7 ff ff       	call   800ead <sys_page_map>
  8016f8:	89 c6                	mov    %eax,%esi
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 3e                	js     80173c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801701:	89 c2                	mov    %eax,%edx
  801703:	c1 ea 0c             	shr    $0xc,%edx
  801706:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80170d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801713:	89 54 24 10          	mov    %edx,0x10(%esp)
  801717:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80171b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801722:	00 
  801723:	89 44 24 04          	mov    %eax,0x4(%esp)
  801727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172e:	e8 7a f7 ff ff       	call   800ead <sys_page_map>
  801733:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801735:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801738:	85 f6                	test   %esi,%esi
  80173a:	79 22                	jns    80175e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80173c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801747:	e8 b4 f7 ff ff       	call   800f00 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80174c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801757:	e8 a4 f7 ff ff       	call   800f00 <sys_page_unmap>
	return r;
  80175c:	89 f0                	mov    %esi,%eax
}
  80175e:	83 c4 3c             	add    $0x3c,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5f                   	pop    %edi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	53                   	push   %ebx
  80176a:	83 ec 24             	sub    $0x24,%esp
  80176d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801770:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801773:	89 44 24 04          	mov    %eax,0x4(%esp)
  801777:	89 1c 24             	mov    %ebx,(%esp)
  80177a:	e8 3c fd ff ff       	call   8014bb <fd_lookup>
  80177f:	89 c2                	mov    %eax,%edx
  801781:	85 d2                	test   %edx,%edx
  801783:	78 6d                	js     8017f2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801785:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	8b 00                	mov    (%eax),%eax
  801791:	89 04 24             	mov    %eax,(%esp)
  801794:	e8 78 fd ff ff       	call   801511 <dev_lookup>
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 55                	js     8017f2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	8b 50 08             	mov    0x8(%eax),%edx
  8017a3:	83 e2 03             	and    $0x3,%edx
  8017a6:	83 fa 01             	cmp    $0x1,%edx
  8017a9:	75 23                	jne    8017ce <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ab:	a1 04 50 80 00       	mov    0x805004,%eax
  8017b0:	8b 40 48             	mov    0x48(%eax),%eax
  8017b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	c7 04 24 3d 33 80 00 	movl   $0x80333d,(%esp)
  8017c2:	e8 88 eb ff ff       	call   80034f <cprintf>
		return -E_INVAL;
  8017c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cc:	eb 24                	jmp    8017f2 <read+0x8c>
	}
	if (!dev->dev_read)
  8017ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d1:	8b 52 08             	mov    0x8(%edx),%edx
  8017d4:	85 d2                	test   %edx,%edx
  8017d6:	74 15                	je     8017ed <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017e6:	89 04 24             	mov    %eax,(%esp)
  8017e9:	ff d2                	call   *%edx
  8017eb:	eb 05                	jmp    8017f2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017f2:	83 c4 24             	add    $0x24,%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    

008017f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	57                   	push   %edi
  8017fc:	56                   	push   %esi
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 1c             	sub    $0x1c,%esp
  801801:	8b 7d 08             	mov    0x8(%ebp),%edi
  801804:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801807:	85 f6                	test   %esi,%esi
  801809:	74 33                	je     80183e <readn+0x46>
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801815:	89 f2                	mov    %esi,%edx
  801817:	29 c2                	sub    %eax,%edx
  801819:	89 54 24 08          	mov    %edx,0x8(%esp)
  80181d:	03 45 0c             	add    0xc(%ebp),%eax
  801820:	89 44 24 04          	mov    %eax,0x4(%esp)
  801824:	89 3c 24             	mov    %edi,(%esp)
  801827:	e8 3a ff ff ff       	call   801766 <read>
		if (m < 0)
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 1b                	js     80184b <readn+0x53>
			return m;
		if (m == 0)
  801830:	85 c0                	test   %eax,%eax
  801832:	74 11                	je     801845 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801834:	01 c3                	add    %eax,%ebx
  801836:	89 d8                	mov    %ebx,%eax
  801838:	39 f3                	cmp    %esi,%ebx
  80183a:	72 d9                	jb     801815 <readn+0x1d>
  80183c:	eb 0b                	jmp    801849 <readn+0x51>
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
  801843:	eb 06                	jmp    80184b <readn+0x53>
  801845:	89 d8                	mov    %ebx,%eax
  801847:	eb 02                	jmp    80184b <readn+0x53>
  801849:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80184b:	83 c4 1c             	add    $0x1c,%esp
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5f                   	pop    %edi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	53                   	push   %ebx
  801857:	83 ec 24             	sub    $0x24,%esp
  80185a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801860:	89 44 24 04          	mov    %eax,0x4(%esp)
  801864:	89 1c 24             	mov    %ebx,(%esp)
  801867:	e8 4f fc ff ff       	call   8014bb <fd_lookup>
  80186c:	89 c2                	mov    %eax,%edx
  80186e:	85 d2                	test   %edx,%edx
  801870:	78 68                	js     8018da <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	89 44 24 04          	mov    %eax,0x4(%esp)
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	8b 00                	mov    (%eax),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 8b fc ff ff       	call   801511 <dev_lookup>
  801886:	85 c0                	test   %eax,%eax
  801888:	78 50                	js     8018da <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801891:	75 23                	jne    8018b6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801893:	a1 04 50 80 00       	mov    0x805004,%eax
  801898:	8b 40 48             	mov    0x48(%eax),%eax
  80189b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	c7 04 24 59 33 80 00 	movl   $0x803359,(%esp)
  8018aa:	e8 a0 ea ff ff       	call   80034f <cprintf>
		return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b4:	eb 24                	jmp    8018da <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018bc:	85 d2                	test   %edx,%edx
  8018be:	74 15                	je     8018d5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	ff d2                	call   *%edx
  8018d3:	eb 05                	jmp    8018da <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018da:	83 c4 24             	add    $0x24,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	89 04 24             	mov    %eax,(%esp)
  8018f3:	e8 c3 fb ff ff       	call   8014bb <fd_lookup>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 0e                	js     80190a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	53                   	push   %ebx
  801910:	83 ec 24             	sub    $0x24,%esp
  801913:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801916:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191d:	89 1c 24             	mov    %ebx,(%esp)
  801920:	e8 96 fb ff ff       	call   8014bb <fd_lookup>
  801925:	89 c2                	mov    %eax,%edx
  801927:	85 d2                	test   %edx,%edx
  801929:	78 61                	js     80198c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	89 04 24             	mov    %eax,(%esp)
  80193a:	e8 d2 fb ff ff       	call   801511 <dev_lookup>
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 49                	js     80198c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80194a:	75 23                	jne    80196f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80194c:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801951:	8b 40 48             	mov    0x48(%eax),%eax
  801954:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801963:	e8 e7 e9 ff ff       	call   80034f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80196d:	eb 1d                	jmp    80198c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80196f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801972:	8b 52 18             	mov    0x18(%edx),%edx
  801975:	85 d2                	test   %edx,%edx
  801977:	74 0e                	je     801987 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80197c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801980:	89 04 24             	mov    %eax,(%esp)
  801983:	ff d2                	call   *%edx
  801985:	eb 05                	jmp    80198c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801987:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80198c:	83 c4 24             	add    $0x24,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5d                   	pop    %ebp
  801991:	c3                   	ret    

00801992 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	53                   	push   %ebx
  801996:	83 ec 24             	sub    $0x24,%esp
  801999:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	89 04 24             	mov    %eax,(%esp)
  8019a9:	e8 0d fb ff ff       	call   8014bb <fd_lookup>
  8019ae:	89 c2                	mov    %eax,%edx
  8019b0:	85 d2                	test   %edx,%edx
  8019b2:	78 52                	js     801a06 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019be:	8b 00                	mov    (%eax),%eax
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	e8 49 fb ff ff       	call   801511 <dev_lookup>
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 3a                	js     801a06 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d3:	74 2c                	je     801a01 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019d8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019df:	00 00 00 
	stat->st_isdir = 0;
  8019e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e9:	00 00 00 
	stat->st_dev = dev;
  8019ec:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f9:	89 14 24             	mov    %edx,(%esp)
  8019fc:	ff 50 14             	call   *0x14(%eax)
  8019ff:	eb 05                	jmp    801a06 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a01:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a06:	83 c4 24             	add    $0x24,%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	56                   	push   %esi
  801a10:	53                   	push   %ebx
  801a11:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a1b:	00 
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 af 01 00 00       	call   801bd6 <open>
  801a27:	89 c3                	mov    %eax,%ebx
  801a29:	85 db                	test   %ebx,%ebx
  801a2b:	78 1b                	js     801a48 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a34:	89 1c 24             	mov    %ebx,(%esp)
  801a37:	e8 56 ff ff ff       	call   801992 <fstat>
  801a3c:	89 c6                	mov    %eax,%esi
	close(fd);
  801a3e:	89 1c 24             	mov    %ebx,(%esp)
  801a41:	e8 bd fb ff ff       	call   801603 <close>
	return r;
  801a46:	89 f0                	mov    %esi,%eax
}
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 10             	sub    $0x10,%esp
  801a57:	89 c6                	mov    %eax,%esi
  801a59:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a5b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a62:	75 11                	jne    801a75 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a6b:	e8 2e 10 00 00       	call   802a9e <ipc_find_env>
  801a70:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a75:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a7c:	00 
  801a7d:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a84:	00 
  801a85:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a89:	a1 00 50 80 00       	mov    0x805000,%eax
  801a8e:	89 04 24             	mov    %eax,(%esp)
  801a91:	e8 a2 0f 00 00       	call   802a38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a9d:	00 
  801a9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa9:	e8 22 0f 00 00       	call   8029d0 <ipc_recv>
}
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 14             	sub    $0x14,%esp
  801abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aca:	ba 00 00 00 00       	mov    $0x0,%edx
  801acf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ad4:	e8 76 ff ff ff       	call   801a4f <fsipc>
  801ad9:	89 c2                	mov    %eax,%edx
  801adb:	85 d2                	test   %edx,%edx
  801add:	78 2b                	js     801b0a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801adf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ae6:	00 
  801ae7:	89 1c 24             	mov    %ebx,(%esp)
  801aea:	e8 bc ee ff ff       	call   8009ab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aef:	a1 80 60 80 00       	mov    0x806080,%eax
  801af4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801afa:	a1 84 60 80 00       	mov    0x806084,%eax
  801aff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	83 c4 14             	add    $0x14,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b21:	ba 00 00 00 00       	mov    $0x0,%edx
  801b26:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2b:	e8 1f ff ff ff       	call   801a4f <fsipc>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	56                   	push   %esi
  801b36:	53                   	push   %ebx
  801b37:	83 ec 10             	sub    $0x10,%esp
  801b3a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	8b 40 0c             	mov    0xc(%eax),%eax
  801b43:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b48:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 03 00 00 00       	mov    $0x3,%eax
  801b58:	e8 f2 fe ff ff       	call   801a4f <fsipc>
  801b5d:	89 c3                	mov    %eax,%ebx
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 6a                	js     801bcd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b63:	39 c6                	cmp    %eax,%esi
  801b65:	73 24                	jae    801b8b <devfile_read+0x59>
  801b67:	c7 44 24 0c 76 33 80 	movl   $0x803376,0xc(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 08 7d 33 80 	movl   $0x80337d,0x8(%esp)
  801b76:	00 
  801b77:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801b7e:	00 
  801b7f:	c7 04 24 92 33 80 00 	movl   $0x803392,(%esp)
  801b86:	e8 cb e6 ff ff       	call   800256 <_panic>
	assert(r <= PGSIZE);
  801b8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b90:	7e 24                	jle    801bb6 <devfile_read+0x84>
  801b92:	c7 44 24 0c 9d 33 80 	movl   $0x80339d,0xc(%esp)
  801b99:	00 
  801b9a:	c7 44 24 08 7d 33 80 	movl   $0x80337d,0x8(%esp)
  801ba1:	00 
  801ba2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ba9:	00 
  801baa:	c7 04 24 92 33 80 00 	movl   $0x803392,(%esp)
  801bb1:	e8 a0 e6 ff ff       	call   800256 <_panic>
	memmove(buf, &fsipcbuf, r);
  801bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bba:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bc1:	00 
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 d9 ef ff ff       	call   800ba6 <memmove>
	return r;
}
  801bcd:	89 d8                	mov    %ebx,%eax
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 24             	sub    $0x24,%esp
  801bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801be0:	89 1c 24             	mov    %ebx,(%esp)
  801be3:	e8 68 ed ff ff       	call   800950 <strlen>
  801be8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bed:	7f 60                	jg     801c4f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	e8 4d f8 ff ff       	call   801447 <fd_alloc>
  801bfa:	89 c2                	mov    %eax,%edx
  801bfc:	85 d2                	test   %edx,%edx
  801bfe:	78 54                	js     801c54 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c04:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c0b:	e8 9b ed ff ff       	call   8009ab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c20:	e8 2a fe ff ff       	call   801a4f <fsipc>
  801c25:	89 c3                	mov    %eax,%ebx
  801c27:	85 c0                	test   %eax,%eax
  801c29:	79 17                	jns    801c42 <open+0x6c>
		fd_close(fd, 0);
  801c2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c32:	00 
  801c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c36:	89 04 24             	mov    %eax,(%esp)
  801c39:	e8 44 f9 ff ff       	call   801582 <fd_close>
		return r;
  801c3e:	89 d8                	mov    %ebx,%eax
  801c40:	eb 12                	jmp    801c54 <open+0x7e>
	}
	return fd2num(fd);
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	89 04 24             	mov    %eax,(%esp)
  801c48:	e8 d3 f7 ff ff       	call   801420 <fd2num>
  801c4d:	eb 05                	jmp    801c54 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c4f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801c54:	83 c4 24             	add    $0x24,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	66 90                	xchg   %ax,%ax
  801c5e:	66 90                	xchg   %ax,%ax

00801c60 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	57                   	push   %edi
  801c64:	56                   	push   %esi
  801c65:	53                   	push   %ebx
  801c66:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
  801c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open. %s\n", prog);
  801c6f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c73:	c7 04 24 a9 33 80 00 	movl   $0x8033a9,(%esp)
  801c7a:	e8 d0 e6 ff ff       	call   80034f <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0) {
  801c7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c86:	00 
  801c87:	89 1c 24             	mov    %ebx,(%esp)
  801c8a:	e8 47 ff ff ff       	call   801bd6 <open>
  801c8f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c95:	85 c0                	test   %eax,%eax
  801c97:	79 17                	jns    801cb0 <spawn+0x50>
		cprintf("cannot\n");
  801c99:	c7 04 24 b3 33 80 00 	movl   $0x8033b3,(%esp)
  801ca0:	e8 aa e6 ff ff       	call   80034f <cprintf>
		return r;
  801ca5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cab:	e9 ea 05 00 00       	jmp    80229a <spawn+0x63a>
	}
	fd = r;

	cprintf("read elf header.\n");
  801cb0:	c7 04 24 bb 33 80 00 	movl   $0x8033bb,(%esp)
  801cb7:	e8 93 e6 ff ff       	call   80034f <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801cbc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801cc3:	00 
  801cc4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cce:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 1c fb ff ff       	call   8017f8 <readn>
  801cdc:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ce1:	75 0c                	jne    801cef <spawn+0x8f>
	    || elf->e_magic != ELF_MAGIC) {
  801ce3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801cea:	45 4c 46 
  801ced:	74 36                	je     801d25 <spawn+0xc5>
		close(fd);
  801cef:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cf5:	89 04 24             	mov    %eax,(%esp)
  801cf8:	e8 06 f9 ff ff       	call   801603 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cfd:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801d04:	46 
  801d05:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0f:	c7 04 24 cd 33 80 00 	movl   $0x8033cd,(%esp)
  801d16:	e8 34 e6 ff ff       	call   80034f <cprintf>
		return -E_NOT_EXEC;
  801d1b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801d20:	e9 75 05 00 00       	jmp    80229a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
  801d25:	c7 04 24 e7 33 80 00 	movl   $0x8033e7,(%esp)
  801d2c:	e8 1e e6 ff ff       	call   80034f <cprintf>
  801d31:	b8 07 00 00 00       	mov    $0x7,%eax
  801d36:	cd 30                	int    $0x30
  801d38:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801d3e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d44:	85 c0                	test   %eax,%eax
  801d46:	0f 88 ff 04 00 00    	js     80224b <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d4c:	89 c6                	mov    %eax,%esi
  801d4e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801d54:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801d57:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801d5d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d63:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d6a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d70:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  801d76:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  801d7d:	e8 cd e5 ff ff       	call   80034f <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	8b 00                	mov    (%eax),%eax
  801d87:	85 c0                	test   %eax,%eax
  801d89:	74 38                	je     801dc3 <spawn+0x163>
  801d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d90:	be 00 00 00 00       	mov    $0x0,%esi
  801d95:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801d98:	89 04 24             	mov    %eax,(%esp)
  801d9b:	e8 b0 eb ff ff       	call   800950 <strlen>
  801da0:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801da4:	83 c3 01             	add    $0x1,%ebx
  801da7:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801dae:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	75 e3                	jne    801d98 <spawn+0x138>
  801db5:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801dbb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801dc1:	eb 1e                	jmp    801de1 <spawn+0x181>
  801dc3:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801dca:	00 00 00 
  801dcd:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801dd4:	00 00 00 
  801dd7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801ddc:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801de1:	bf 00 10 40 00       	mov    $0x401000,%edi
  801de6:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801de8:	89 fa                	mov    %edi,%edx
  801dea:	83 e2 fc             	and    $0xfffffffc,%edx
  801ded:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801df4:	29 c2                	sub    %eax,%edx
  801df6:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801dfc:	8d 42 f8             	lea    -0x8(%edx),%eax
  801dff:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e04:	0f 86 49 04 00 00    	jbe    802253 <spawn+0x5f3>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e0a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e11:	00 
  801e12:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e19:	00 
  801e1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e21:	e8 33 f0 ff ff       	call   800e59 <sys_page_alloc>
  801e26:	85 c0                	test   %eax,%eax
  801e28:	0f 88 6c 04 00 00    	js     80229a <spawn+0x63a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e2e:	85 db                	test   %ebx,%ebx
  801e30:	7e 46                	jle    801e78 <spawn+0x218>
  801e32:	be 00 00 00 00       	mov    $0x0,%esi
  801e37:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801e3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  801e40:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e46:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e4c:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801e4f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e56:	89 3c 24             	mov    %edi,(%esp)
  801e59:	e8 4d eb ff ff       	call   8009ab <strcpy>
		string_store += strlen(argv[i]) + 1;
  801e5e:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801e61:	89 04 24             	mov    %eax,(%esp)
  801e64:	e8 e7 ea ff ff       	call   800950 <strlen>
  801e69:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e6d:	83 c6 01             	add    $0x1,%esi
  801e70:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801e76:	75 c8                	jne    801e40 <spawn+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801e78:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e7e:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801e84:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e8b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e91:	74 24                	je     801eb7 <spawn+0x257>
  801e93:	c7 44 24 0c 78 34 80 	movl   $0x803478,0xc(%esp)
  801e9a:	00 
  801e9b:	c7 44 24 08 7d 33 80 	movl   $0x80337d,0x8(%esp)
  801ea2:	00 
  801ea3:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  801eaa:	00 
  801eab:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  801eb2:	e8 9f e3 ff ff       	call   800256 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801eb7:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ebd:	89 c8                	mov    %ecx,%eax
  801ebf:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801ec4:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ec7:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ecd:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ed0:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ed6:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801edc:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801ee3:	00 
  801ee4:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801eeb:	ee 
  801eec:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801efd:	00 
  801efe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f05:	e8 a3 ef ff ff       	call   800ead <sys_page_map>
  801f0a:	89 c3                	mov    %eax,%ebx
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	0f 88 70 03 00 00    	js     802284 <spawn+0x624>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f14:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f1b:	00 
  801f1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f23:	e8 d8 ef ff ff       	call   800f00 <sys_page_unmap>
  801f28:	89 c3                	mov    %eax,%ebx
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	0f 88 52 03 00 00    	js     802284 <spawn+0x624>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801f32:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  801f39:	e8 11 e4 ff ff       	call   80034f <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f3e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f44:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801f4b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f51:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801f58:	00 
  801f59:	0f 84 dc 01 00 00    	je     80213b <spawn+0x4db>
  801f5f:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801f66:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801f69:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f6f:	83 38 01             	cmpl   $0x1,(%eax)
  801f72:	0f 85 a2 01 00 00    	jne    80211a <spawn+0x4ba>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f78:	89 c1                	mov    %eax,%ecx
  801f7a:	8b 40 18             	mov    0x18(%eax),%eax
  801f7d:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f80:	83 f8 01             	cmp    $0x1,%eax
  801f83:	19 c0                	sbb    %eax,%eax
  801f85:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f8b:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801f92:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f99:	89 c8                	mov    %ecx,%eax
  801f9b:	8b 51 04             	mov    0x4(%ecx),%edx
  801f9e:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801fa4:	8b 79 10             	mov    0x10(%ecx),%edi
  801fa7:	8b 49 14             	mov    0x14(%ecx),%ecx
  801faa:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801fb0:	8b 40 08             	mov    0x8(%eax),%eax
  801fb3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801fb9:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fbe:	74 14                	je     801fd4 <spawn+0x374>
		va -= i;
  801fc0:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801fc6:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801fcc:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801fce:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801fd4:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801fdb:	0f 84 39 01 00 00    	je     80211a <spawn+0x4ba>
  801fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe6:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801feb:	39 f7                	cmp    %esi,%edi
  801fed:	77 31                	ja     802020 <spawn+0x3c0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801fef:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ff5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff9:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801fff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802003:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 48 ee ff ff       	call   800e59 <sys_page_alloc>
  802011:	85 c0                	test   %eax,%eax
  802013:	0f 89 ed 00 00 00    	jns    802106 <spawn+0x4a6>
  802019:	89 c3                	mov    %eax,%ebx
  80201b:	e9 44 02 00 00       	jmp    802264 <spawn+0x604>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802020:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802027:	00 
  802028:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80202f:	00 
  802030:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802037:	e8 1d ee ff ff       	call   800e59 <sys_page_alloc>
  80203c:	85 c0                	test   %eax,%eax
  80203e:	0f 88 16 02 00 00    	js     80225a <spawn+0x5fa>
  802044:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80204a:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80204c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802050:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802056:	89 04 24             	mov    %eax,(%esp)
  802059:	e8 82 f8 ff ff       	call   8018e0 <seek>
  80205e:	85 c0                	test   %eax,%eax
  802060:	0f 88 f8 01 00 00    	js     80225e <spawn+0x5fe>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802066:	89 f9                	mov    %edi,%ecx
  802068:	29 f1                	sub    %esi,%ecx
  80206a:	89 c8                	mov    %ecx,%eax
  80206c:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802072:	ba 00 10 00 00       	mov    $0x1000,%edx
  802077:	0f 47 c2             	cmova  %edx,%eax
  80207a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80207e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802085:	00 
  802086:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80208c:	89 04 24             	mov    %eax,(%esp)
  80208f:	e8 64 f7 ff ff       	call   8017f8 <readn>
  802094:	85 c0                	test   %eax,%eax
  802096:	0f 88 c6 01 00 00    	js     802262 <spawn+0x602>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80209c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8020a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8020a6:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8020ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8020b0:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ba:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020c1:	00 
  8020c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c9:	e8 df ed ff ff       	call   800ead <sys_page_map>
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	79 20                	jns    8020f2 <spawn+0x492>
				panic("spawn: sys_page_map data: %e", r);
  8020d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020d6:	c7 44 24 08 19 34 80 	movl   $0x803419,0x8(%esp)
  8020dd:	00 
  8020de:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  8020e5:	00 
  8020e6:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  8020ed:	e8 64 e1 ff ff       	call   800256 <_panic>
			sys_page_unmap(0, UTEMP);
  8020f2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020f9:	00 
  8020fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802101:	e8 fa ed ff ff       	call   800f00 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802106:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80210c:	89 de                	mov    %ebx,%esi
  80210e:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802114:	0f 82 d1 fe ff ff    	jb     801feb <spawn+0x38b>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80211a:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802121:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802128:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80212f:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  802135:	0f 8f 2e fe ff ff    	jg     801f69 <spawn+0x309>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80213b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 ba f4 ff ff       	call   801603 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
  802149:	bb 00 08 00 00       	mov    $0x800,%ebx
  80214e:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {

		if (!(uvpd[pn_beg >> 10] & (PTE_P | PTE_U))) {
  802154:	89 d8                	mov    %ebx,%eax
  802156:	c1 e8 0a             	shr    $0xa,%eax
  802159:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802160:	a8 05                	test   $0x5,%al
  802162:	74 52                	je     8021b6 <spawn+0x556>
			continue;
		}

		const pte_t pte = uvpt[pn_beg];
  802164:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax

		if (pte & PTE_SHARE) {
  80216b:	f6 c4 04             	test   $0x4,%ah
  80216e:	74 46                	je     8021b6 <spawn+0x556>
  802170:	89 da                	mov    %ebx,%edx
  802172:	c1 e2 0c             	shl    $0xc,%edx
			void* va = (void*) (pn_beg * PGSIZE);
			int perm = pte & PTE_SYSCALL;
  802175:	25 07 0e 00 00       	and    $0xe07,%eax
			int err_code;
			if ((err_code = sys_page_map(0, va, child, va, perm)) < 0) {
  80217a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80217e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802182:	89 74 24 08          	mov    %esi,0x8(%esp)
  802186:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802191:	e8 17 ed ff ff       	call   800ead <sys_page_map>
  802196:	85 c0                	test   %eax,%eax
  802198:	79 1c                	jns    8021b6 <spawn+0x556>
				panic("copy_shared_pages:sys_page_map");
  80219a:	c7 44 24 08 a0 34 80 	movl   $0x8034a0,0x8(%esp)
  8021a1:	00 
  8021a2:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  8021a9:	00 
  8021aa:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  8021b1:	e8 a0 e0 ff ff       	call   800256 <_panic>
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  8021b6:	83 c3 01             	add    $0x1,%ebx
  8021b9:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8021bf:	75 93                	jne    802154 <spawn+0x4f4>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8021c1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021d1:	89 04 24             	mov    %eax,(%esp)
  8021d4:	e8 cd ed ff ff       	call   800fa6 <sys_env_set_trapframe>
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	79 20                	jns    8021fd <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);
  8021dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021e1:	c7 44 24 08 36 34 80 	movl   $0x803436,0x8(%esp)
  8021e8:	00 
  8021e9:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  8021f0:	00 
  8021f1:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  8021f8:	e8 59 e0 ff ff       	call   800256 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8021fd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802204:	00 
  802205:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 40 ed ff ff       	call   800f53 <sys_env_set_status>
  802213:	85 c0                	test   %eax,%eax
  802215:	79 20                	jns    802237 <spawn+0x5d7>
		panic("sys_env_set_status: %e", r);
  802217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221b:	c7 44 24 08 50 34 80 	movl   $0x803450,0x8(%esp)
  802222:	00 
  802223:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  80222a:	00 
  80222b:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  802232:	e8 1f e0 ff ff       	call   800256 <_panic>

	cprintf("spawn return.\n");
  802237:	c7 04 24 67 34 80 00 	movl   $0x803467,(%esp)
  80223e:	e8 0c e1 ff ff       	call   80034f <cprintf>
	return child;
  802243:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802249:	eb 4f                	jmp    80229a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  80224b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802251:	eb 47                	jmp    80229a <spawn+0x63a>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802253:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802258:	eb 40                	jmp    80229a <spawn+0x63a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80225a:	89 c3                	mov    %eax,%ebx
  80225c:	eb 06                	jmp    802264 <spawn+0x604>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80225e:	89 c3                	mov    %eax,%ebx
  802260:	eb 02                	jmp    802264 <spawn+0x604>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802262:	89 c3                	mov    %eax,%ebx

	cprintf("spawn return.\n");
	return child;

error:
	sys_env_destroy(child);
  802264:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80226a:	89 04 24             	mov    %eax,(%esp)
  80226d:	e8 57 eb ff ff       	call   800dc9 <sys_env_destroy>
	close(fd);
  802272:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802278:	89 04 24             	mov    %eax,(%esp)
  80227b:	e8 83 f3 ff ff       	call   801603 <close>
	return r;
  802280:	89 d8                	mov    %ebx,%eax
  802282:	eb 16                	jmp    80229a <spawn+0x63a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802284:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80228b:	00 
  80228c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802293:	e8 68 ec ff ff       	call   800f00 <sys_page_unmap>
  802298:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80229a:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5f                   	pop    %edi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    

008022a5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	57                   	push   %edi
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8022ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b2:	74 61                	je     802315 <spawnl+0x70>
  8022b4:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8022b7:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  8022bc:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8022bf:	83 c0 04             	add    $0x4,%eax
  8022c2:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8022c6:	74 04                	je     8022cc <spawnl+0x27>
		argc++;
  8022c8:	89 ca                	mov    %ecx,%edx
  8022ca:	eb f0                	jmp    8022bc <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8022cc:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  8022d3:	83 e0 f0             	and    $0xfffffff0,%eax
  8022d6:	29 c4                	sub    %eax,%esp
  8022d8:	8d 74 24 0b          	lea    0xb(%esp),%esi
  8022dc:	c1 ee 02             	shr    $0x2,%esi
  8022df:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  8022e6:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  8022e8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022eb:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  8022f2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  8022f9:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8022fa:	89 ce                	mov    %ecx,%esi
  8022fc:	85 c9                	test   %ecx,%ecx
  8022fe:	74 25                	je     802325 <spawnl+0x80>
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802305:	83 c0 01             	add    $0x1,%eax
  802308:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  80230c:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80230f:	39 f0                	cmp    %esi,%eax
  802311:	75 f2                	jne    802305 <spawnl+0x60>
  802313:	eb 10                	jmp    802325 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  802315:	8b 45 0c             	mov    0xc(%ebp),%eax
  802318:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  80231b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802322:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802325:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	89 04 24             	mov    %eax,(%esp)
  80232f:	e8 2c f9 ff ff       	call   801c60 <spawn>
}
  802334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	83 ec 10             	sub    $0x10,%esp
  802348:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	89 04 24             	mov    %eax,(%esp)
  802351:	e8 da f0 ff ff       	call   801430 <fd2data>
  802356:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802358:	c7 44 24 04 bf 34 80 	movl   $0x8034bf,0x4(%esp)
  80235f:	00 
  802360:	89 1c 24             	mov    %ebx,(%esp)
  802363:	e8 43 e6 ff ff       	call   8009ab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802368:	8b 46 04             	mov    0x4(%esi),%eax
  80236b:	2b 06                	sub    (%esi),%eax
  80236d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802373:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80237a:	00 00 00 
	stat->st_dev = &devpipe;
  80237d:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  802384:	40 80 00 
	return 0;
}
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	83 c4 10             	add    $0x10,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    

00802393 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	53                   	push   %ebx
  802397:	83 ec 14             	sub    $0x14,%esp
  80239a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80239d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a8:	e8 53 eb ff ff       	call   800f00 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023ad:	89 1c 24             	mov    %ebx,(%esp)
  8023b0:	e8 7b f0 ff ff       	call   801430 <fd2data>
  8023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c0:	e8 3b eb ff ff       	call   800f00 <sys_page_unmap>
}
  8023c5:	83 c4 14             	add    $0x14,%esp
  8023c8:	5b                   	pop    %ebx
  8023c9:	5d                   	pop    %ebp
  8023ca:	c3                   	ret    

008023cb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	57                   	push   %edi
  8023cf:	56                   	push   %esi
  8023d0:	53                   	push   %ebx
  8023d1:	83 ec 2c             	sub    $0x2c,%esp
  8023d4:	89 c6                	mov    %eax,%esi
  8023d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023d9:	a1 04 50 80 00       	mov    0x805004,%eax
  8023de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e1:	89 34 24             	mov    %esi,(%esp)
  8023e4:	e8 fd 06 00 00       	call   802ae6 <pageref>
  8023e9:	89 c7                	mov    %eax,%edi
  8023eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 f0 06 00 00       	call   802ae6 <pageref>
  8023f6:	39 c7                	cmp    %eax,%edi
  8023f8:	0f 94 c2             	sete   %dl
  8023fb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023fe:	8b 0d 04 50 80 00    	mov    0x805004,%ecx
  802404:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802407:	39 fb                	cmp    %edi,%ebx
  802409:	74 21                	je     80242c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80240b:	84 d2                	test   %dl,%dl
  80240d:	74 ca                	je     8023d9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80240f:	8b 51 58             	mov    0x58(%ecx),%edx
  802412:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802416:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80241e:	c7 04 24 c6 34 80 00 	movl   $0x8034c6,(%esp)
  802425:	e8 25 df ff ff       	call   80034f <cprintf>
  80242a:	eb ad                	jmp    8023d9 <_pipeisclosed+0xe>
	}
}
  80242c:	83 c4 2c             	add    $0x2c,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5e                   	pop    %esi
  802431:	5f                   	pop    %edi
  802432:	5d                   	pop    %ebp
  802433:	c3                   	ret    

00802434 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	57                   	push   %edi
  802438:	56                   	push   %esi
  802439:	53                   	push   %ebx
  80243a:	83 ec 1c             	sub    $0x1c,%esp
  80243d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802440:	89 34 24             	mov    %esi,(%esp)
  802443:	e8 e8 ef ff ff       	call   801430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80244c:	74 61                	je     8024af <devpipe_write+0x7b>
  80244e:	89 c3                	mov    %eax,%ebx
  802450:	bf 00 00 00 00       	mov    $0x0,%edi
  802455:	eb 4a                	jmp    8024a1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802457:	89 da                	mov    %ebx,%edx
  802459:	89 f0                	mov    %esi,%eax
  80245b:	e8 6b ff ff ff       	call   8023cb <_pipeisclosed>
  802460:	85 c0                	test   %eax,%eax
  802462:	75 54                	jne    8024b8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802464:	e8 d1 e9 ff ff       	call   800e3a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802469:	8b 43 04             	mov    0x4(%ebx),%eax
  80246c:	8b 0b                	mov    (%ebx),%ecx
  80246e:	8d 51 20             	lea    0x20(%ecx),%edx
  802471:	39 d0                	cmp    %edx,%eax
  802473:	73 e2                	jae    802457 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802475:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802478:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80247c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80247f:	99                   	cltd   
  802480:	c1 ea 1b             	shr    $0x1b,%edx
  802483:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802486:	83 e1 1f             	and    $0x1f,%ecx
  802489:	29 d1                	sub    %edx,%ecx
  80248b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80248f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802493:	83 c0 01             	add    $0x1,%eax
  802496:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802499:	83 c7 01             	add    $0x1,%edi
  80249c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80249f:	74 13                	je     8024b4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024a4:	8b 0b                	mov    (%ebx),%ecx
  8024a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8024a9:	39 d0                	cmp    %edx,%eax
  8024ab:	73 aa                	jae    802457 <devpipe_write+0x23>
  8024ad:	eb c6                	jmp    802475 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024b4:	89 f8                	mov    %edi,%eax
  8024b6:	eb 05                	jmp    8024bd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024bd:	83 c4 1c             	add    $0x1c,%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    

008024c5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	57                   	push   %edi
  8024c9:	56                   	push   %esi
  8024ca:	53                   	push   %ebx
  8024cb:	83 ec 1c             	sub    $0x1c,%esp
  8024ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024d1:	89 3c 24             	mov    %edi,(%esp)
  8024d4:	e8 57 ef ff ff       	call   801430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024dd:	74 54                	je     802533 <devpipe_read+0x6e>
  8024df:	89 c3                	mov    %eax,%ebx
  8024e1:	be 00 00 00 00       	mov    $0x0,%esi
  8024e6:	eb 3e                	jmp    802526 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8024e8:	89 f0                	mov    %esi,%eax
  8024ea:	eb 55                	jmp    802541 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024ec:	89 da                	mov    %ebx,%edx
  8024ee:	89 f8                	mov    %edi,%eax
  8024f0:	e8 d6 fe ff ff       	call   8023cb <_pipeisclosed>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	75 43                	jne    80253c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024f9:	e8 3c e9 ff ff       	call   800e3a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024fe:	8b 03                	mov    (%ebx),%eax
  802500:	3b 43 04             	cmp    0x4(%ebx),%eax
  802503:	74 e7                	je     8024ec <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802505:	99                   	cltd   
  802506:	c1 ea 1b             	shr    $0x1b,%edx
  802509:	01 d0                	add    %edx,%eax
  80250b:	83 e0 1f             	and    $0x1f,%eax
  80250e:	29 d0                	sub    %edx,%eax
  802510:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802515:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802518:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80251b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251e:	83 c6 01             	add    $0x1,%esi
  802521:	3b 75 10             	cmp    0x10(%ebp),%esi
  802524:	74 12                	je     802538 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802526:	8b 03                	mov    (%ebx),%eax
  802528:	3b 43 04             	cmp    0x4(%ebx),%eax
  80252b:	75 d8                	jne    802505 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80252d:	85 f6                	test   %esi,%esi
  80252f:	75 b7                	jne    8024e8 <devpipe_read+0x23>
  802531:	eb b9                	jmp    8024ec <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802533:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802538:	89 f0                	mov    %esi,%eax
  80253a:	eb 05                	jmp    802541 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802541:	83 c4 1c             	add    $0x1c,%esp
  802544:	5b                   	pop    %ebx
  802545:	5e                   	pop    %esi
  802546:	5f                   	pop    %edi
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	56                   	push   %esi
  80254d:	53                   	push   %ebx
  80254e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802551:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802554:	89 04 24             	mov    %eax,(%esp)
  802557:	e8 eb ee ff ff       	call   801447 <fd_alloc>
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	85 d2                	test   %edx,%edx
  802560:	0f 88 4d 01 00 00    	js     8026b3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802566:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80256d:	00 
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	89 44 24 04          	mov    %eax,0x4(%esp)
  802575:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80257c:	e8 d8 e8 ff ff       	call   800e59 <sys_page_alloc>
  802581:	89 c2                	mov    %eax,%edx
  802583:	85 d2                	test   %edx,%edx
  802585:	0f 88 28 01 00 00    	js     8026b3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80258b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80258e:	89 04 24             	mov    %eax,(%esp)
  802591:	e8 b1 ee ff ff       	call   801447 <fd_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 fe 00 00 00    	js     80269e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025a7:	00 
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b6:	e8 9e e8 ff ff       	call   800e59 <sys_page_alloc>
  8025bb:	89 c3                	mov    %eax,%ebx
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	0f 88 d9 00 00 00    	js     80269e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	89 04 24             	mov    %eax,(%esp)
  8025cb:	e8 60 ee ff ff       	call   801430 <fd2data>
  8025d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d9:	00 
  8025da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e5:	e8 6f e8 ff ff       	call   800e59 <sys_page_alloc>
  8025ea:	89 c3                	mov    %eax,%ebx
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	0f 88 97 00 00 00    	js     80268b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	89 04 24             	mov    %eax,(%esp)
  8025fa:	e8 31 ee ff ff       	call   801430 <fd2data>
  8025ff:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802606:	00 
  802607:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80260b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802612:	00 
  802613:	89 74 24 04          	mov    %esi,0x4(%esp)
  802617:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80261e:	e8 8a e8 ff ff       	call   800ead <sys_page_map>
  802623:	89 c3                	mov    %eax,%ebx
  802625:	85 c0                	test   %eax,%eax
  802627:	78 52                	js     80267b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802629:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80263e:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	89 04 24             	mov    %eax,(%esp)
  802659:	e8 c2 ed ff ff       	call   801420 <fd2num>
  80265e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802661:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	89 04 24             	mov    %eax,(%esp)
  802669:	e8 b2 ed ff ff       	call   801420 <fd2num>
  80266e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802671:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802674:	b8 00 00 00 00       	mov    $0x0,%eax
  802679:	eb 38                	jmp    8026b3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80267b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80267f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802686:	e8 75 e8 ff ff       	call   800f00 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802699:	e8 62 e8 ff ff       	call   800f00 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026ac:	e8 4f e8 ff ff       	call   800f00 <sys_page_unmap>
  8026b1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026b3:	83 c4 30             	add    $0x30,%esp
  8026b6:	5b                   	pop    %ebx
  8026b7:	5e                   	pop    %esi
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    

008026ba <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	89 04 24             	mov    %eax,(%esp)
  8026cd:	e8 e9 ed ff ff       	call   8014bb <fd_lookup>
  8026d2:	89 c2                	mov    %eax,%edx
  8026d4:	85 d2                	test   %edx,%edx
  8026d6:	78 15                	js     8026ed <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	89 04 24             	mov    %eax,(%esp)
  8026de:	e8 4d ed ff ff       	call   801430 <fd2data>
	return _pipeisclosed(fd, p);
  8026e3:	89 c2                	mov    %eax,%edx
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	e8 de fc ff ff       	call   8023cb <_pipeisclosed>
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	56                   	push   %esi
  8026f3:	53                   	push   %ebx
  8026f4:	83 ec 10             	sub    $0x10,%esp
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	75 24                	jne    802722 <wait+0x33>
  8026fe:	c7 44 24 0c de 34 80 	movl   $0x8034de,0xc(%esp)
  802705:	00 
  802706:	c7 44 24 08 7d 33 80 	movl   $0x80337d,0x8(%esp)
  80270d:	00 
  80270e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802715:	00 
  802716:	c7 04 24 e9 34 80 00 	movl   $0x8034e9,(%esp)
  80271d:	e8 34 db ff ff       	call   800256 <_panic>
	e = &envs[ENVX(envid)];
  802722:	89 c3                	mov    %eax,%ebx
  802724:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80272a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80272d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802733:	8b 73 48             	mov    0x48(%ebx),%esi
  802736:	39 c6                	cmp    %eax,%esi
  802738:	75 1a                	jne    802754 <wait+0x65>
  80273a:	8b 43 54             	mov    0x54(%ebx),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	74 13                	je     802754 <wait+0x65>
		sys_yield();
  802741:	e8 f4 e6 ff ff       	call   800e3a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802746:	8b 43 48             	mov    0x48(%ebx),%eax
  802749:	39 f0                	cmp    %esi,%eax
  80274b:	75 07                	jne    802754 <wait+0x65>
  80274d:	8b 43 54             	mov    0x54(%ebx),%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	75 ed                	jne    802741 <wait+0x52>
		sys_yield();
}
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	5b                   	pop    %ebx
  802758:	5e                   	pop    %esi
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    
  80275b:	66 90                	xchg   %ax,%ax
  80275d:	66 90                	xchg   %ax,%ax
  80275f:	90                   	nop

00802760 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802770:	c7 44 24 04 f4 34 80 	movl   $0x8034f4,0x4(%esp)
  802777:	00 
  802778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277b:	89 04 24             	mov    %eax,(%esp)
  80277e:	e8 28 e2 ff ff       	call   8009ab <strcpy>
	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	57                   	push   %edi
  80278e:	56                   	push   %esi
  80278f:	53                   	push   %ebx
  802790:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802796:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80279a:	74 4a                	je     8027e6 <devcons_write+0x5c>
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027ac:	8b 75 10             	mov    0x10(%ebp),%esi
  8027af:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8027b1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027b9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027bc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027c0:	03 45 0c             	add    0xc(%ebp),%eax
  8027c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c7:	89 3c 24             	mov    %edi,(%esp)
  8027ca:	e8 d7 e3 ff ff       	call   800ba6 <memmove>
		sys_cputs(buf, m);
  8027cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027d3:	89 3c 24             	mov    %edi,(%esp)
  8027d6:	e8 b1 e5 ff ff       	call   800d8c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027db:	01 f3                	add    %esi,%ebx
  8027dd:	89 d8                	mov    %ebx,%eax
  8027df:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027e2:	72 c8                	jb     8027ac <devcons_write+0x22>
  8027e4:	eb 05                	jmp    8027eb <devcons_write+0x61>
  8027e6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027eb:	89 d8                	mov    %ebx,%eax
  8027ed:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027f3:	5b                   	pop    %ebx
  8027f4:	5e                   	pop    %esi
  8027f5:	5f                   	pop    %edi
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    

008027f8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802803:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802807:	75 07                	jne    802810 <devcons_read+0x18>
  802809:	eb 28                	jmp    802833 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80280b:	e8 2a e6 ff ff       	call   800e3a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802810:	e8 95 e5 ff ff       	call   800daa <sys_cgetc>
  802815:	85 c0                	test   %eax,%eax
  802817:	74 f2                	je     80280b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 16                	js     802833 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80281d:	83 f8 04             	cmp    $0x4,%eax
  802820:	74 0c                	je     80282e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802822:	8b 55 0c             	mov    0xc(%ebp),%edx
  802825:	88 02                	mov    %al,(%edx)
	return 1;
  802827:	b8 01 00 00 00       	mov    $0x1,%eax
  80282c:	eb 05                	jmp    802833 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802841:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802848:	00 
  802849:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80284c:	89 04 24             	mov    %eax,(%esp)
  80284f:	e8 38 e5 ff ff       	call   800d8c <sys_cputs>
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <getchar>:

int
getchar(void)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80285c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802863:	00 
  802864:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802872:	e8 ef ee ff ff       	call   801766 <read>
	if (r < 0)
  802877:	85 c0                	test   %eax,%eax
  802879:	78 0f                	js     80288a <getchar+0x34>
		return r;
	if (r < 1)
  80287b:	85 c0                	test   %eax,%eax
  80287d:	7e 06                	jle    802885 <getchar+0x2f>
		return -E_EOF;
	return c;
  80287f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802883:	eb 05                	jmp    80288a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802885:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802895:	89 44 24 04          	mov    %eax,0x4(%esp)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	89 04 24             	mov    %eax,(%esp)
  80289f:	e8 17 ec ff ff       	call   8014bb <fd_lookup>
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	78 11                	js     8028b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8028b1:	39 10                	cmp    %edx,(%eax)
  8028b3:	0f 94 c0             	sete   %al
  8028b6:	0f b6 c0             	movzbl %al,%eax
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <opencons>:

int
opencons(void)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
  8028be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c4:	89 04 24             	mov    %eax,(%esp)
  8028c7:	e8 7b eb ff ff       	call   801447 <fd_alloc>
		return r;
  8028cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	78 40                	js     802912 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028d9:	00 
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e8:	e8 6c e5 ff ff       	call   800e59 <sys_page_alloc>
		return r;
  8028ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 1f                	js     802912 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028f3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802908:	89 04 24             	mov    %eax,(%esp)
  80290b:	e8 10 eb ff ff       	call   801420 <fd2num>
  802910:	89 c2                	mov    %eax,%edx
}
  802912:	89 d0                	mov    %edx,%eax
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80291c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802923:	75 50                	jne    802975 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802925:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80292c:	00 
  80292d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802934:	ee 
  802935:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80293c:	e8 18 e5 ff ff       	call   800e59 <sys_page_alloc>
  802941:	85 c0                	test   %eax,%eax
  802943:	79 1c                	jns    802961 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802945:	c7 44 24 08 00 35 80 	movl   $0x803500,0x8(%esp)
  80294c:	00 
  80294d:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802954:	00 
  802955:	c7 04 24 24 35 80 00 	movl   $0x803524,(%esp)
  80295c:	e8 f5 d8 ff ff       	call   800256 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802961:	c7 44 24 04 7f 29 80 	movl   $0x80297f,0x4(%esp)
  802968:	00 
  802969:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802970:	e8 84 e6 ff ff       	call   800ff9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80297f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802980:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802985:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802987:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80298a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80298c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802991:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802994:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802999:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80299c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80299e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8029a1:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8029a3:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8029a5:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8029aa:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8029ad:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8029b2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8029b5:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8029b7:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8029bc:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8029bf:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8029c4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8029c7:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8029c9:	83 c4 08             	add    $0x8,%esp
	popal
  8029cc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8029cd:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029ce:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029cf:	c3                   	ret    

008029d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	56                   	push   %esi
  8029d4:	53                   	push   %ebx
  8029d5:	83 ec 10             	sub    $0x10,%esp
  8029d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8029db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029e8:	0f 44 c2             	cmove  %edx,%eax
  8029eb:	89 04 24             	mov    %eax,(%esp)
  8029ee:	e8 7c e6 ff ff       	call   80106f <sys_ipc_recv>
	if (err_code < 0) {
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	79 16                	jns    802a0d <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8029f7:	85 f6                	test   %esi,%esi
  8029f9:	74 06                	je     802a01 <ipc_recv+0x31>
  8029fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802a01:	85 db                	test   %ebx,%ebx
  802a03:	74 2c                	je     802a31 <ipc_recv+0x61>
  802a05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a0b:	eb 24                	jmp    802a31 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802a0d:	85 f6                	test   %esi,%esi
  802a0f:	74 0a                	je     802a1b <ipc_recv+0x4b>
  802a11:	a1 04 50 80 00       	mov    0x805004,%eax
  802a16:	8b 40 74             	mov    0x74(%eax),%eax
  802a19:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802a1b:	85 db                	test   %ebx,%ebx
  802a1d:	74 0a                	je     802a29 <ipc_recv+0x59>
  802a1f:	a1 04 50 80 00       	mov    0x805004,%eax
  802a24:	8b 40 78             	mov    0x78(%eax),%eax
  802a27:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802a29:	a1 04 50 80 00       	mov    0x805004,%eax
  802a2e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a31:	83 c4 10             	add    $0x10,%esp
  802a34:	5b                   	pop    %ebx
  802a35:	5e                   	pop    %esi
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    

00802a38 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	57                   	push   %edi
  802a3c:	56                   	push   %esi
  802a3d:	53                   	push   %ebx
  802a3e:	83 ec 1c             	sub    $0x1c,%esp
  802a41:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a44:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802a4a:	eb 25                	jmp    802a71 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802a4c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a4f:	74 20                	je     802a71 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802a51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a55:	c7 44 24 08 32 35 80 	movl   $0x803532,0x8(%esp)
  802a5c:	00 
  802a5d:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802a64:	00 
  802a65:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  802a6c:	e8 e5 d7 ff ff       	call   800256 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802a71:	85 db                	test   %ebx,%ebx
  802a73:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a78:	0f 45 c3             	cmovne %ebx,%eax
  802a7b:	8b 55 14             	mov    0x14(%ebp),%edx
  802a7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a82:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a86:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a8a:	89 3c 24             	mov    %edi,(%esp)
  802a8d:	e8 ba e5 ff ff       	call   80104c <sys_ipc_try_send>
  802a92:	85 c0                	test   %eax,%eax
  802a94:	75 b6                	jne    802a4c <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802a96:	83 c4 1c             	add    $0x1c,%esp
  802a99:	5b                   	pop    %ebx
  802a9a:	5e                   	pop    %esi
  802a9b:	5f                   	pop    %edi
  802a9c:	5d                   	pop    %ebp
  802a9d:	c3                   	ret    

00802a9e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802aa4:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802aa9:	39 c8                	cmp    %ecx,%eax
  802aab:	74 17                	je     802ac4 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802aad:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802ab2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ab5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802abb:	8b 52 50             	mov    0x50(%edx),%edx
  802abe:	39 ca                	cmp    %ecx,%edx
  802ac0:	75 14                	jne    802ad6 <ipc_find_env+0x38>
  802ac2:	eb 05                	jmp    802ac9 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ac4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802ac9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802acc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802ad1:	8b 40 40             	mov    0x40(%eax),%eax
  802ad4:	eb 0e                	jmp    802ae4 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ad6:	83 c0 01             	add    $0x1,%eax
  802ad9:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ade:	75 d2                	jne    802ab2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ae0:	66 b8 00 00          	mov    $0x0,%ax
}
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    

00802ae6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ae6:	55                   	push   %ebp
  802ae7:	89 e5                	mov    %esp,%ebp
  802ae9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aec:	89 d0                	mov    %edx,%eax
  802aee:	c1 e8 16             	shr    $0x16,%eax
  802af1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802afd:	f6 c1 01             	test   $0x1,%cl
  802b00:	74 1d                	je     802b1f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b02:	c1 ea 0c             	shr    $0xc,%edx
  802b05:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b0c:	f6 c2 01             	test   $0x1,%dl
  802b0f:	74 0e                	je     802b1f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b11:	c1 ea 0c             	shr    $0xc,%edx
  802b14:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b1b:	ef 
  802b1c:	0f b7 c0             	movzwl %ax,%eax
}
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	66 90                	xchg   %ax,%ax
  802b23:	66 90                	xchg   %ax,%ax
  802b25:	66 90                	xchg   %ax,%ax
  802b27:	66 90                	xchg   %ax,%ax
  802b29:	66 90                	xchg   %ax,%ax
  802b2b:	66 90                	xchg   %ax,%ax
  802b2d:	66 90                	xchg   %ax,%ax
  802b2f:	90                   	nop

00802b30 <__udivdi3>:
  802b30:	55                   	push   %ebp
  802b31:	57                   	push   %edi
  802b32:	56                   	push   %esi
  802b33:	83 ec 0c             	sub    $0xc,%esp
  802b36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b46:	85 c0                	test   %eax,%eax
  802b48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b4c:	89 ea                	mov    %ebp,%edx
  802b4e:	89 0c 24             	mov    %ecx,(%esp)
  802b51:	75 2d                	jne    802b80 <__udivdi3+0x50>
  802b53:	39 e9                	cmp    %ebp,%ecx
  802b55:	77 61                	ja     802bb8 <__udivdi3+0x88>
  802b57:	85 c9                	test   %ecx,%ecx
  802b59:	89 ce                	mov    %ecx,%esi
  802b5b:	75 0b                	jne    802b68 <__udivdi3+0x38>
  802b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b62:	31 d2                	xor    %edx,%edx
  802b64:	f7 f1                	div    %ecx
  802b66:	89 c6                	mov    %eax,%esi
  802b68:	31 d2                	xor    %edx,%edx
  802b6a:	89 e8                	mov    %ebp,%eax
  802b6c:	f7 f6                	div    %esi
  802b6e:	89 c5                	mov    %eax,%ebp
  802b70:	89 f8                	mov    %edi,%eax
  802b72:	f7 f6                	div    %esi
  802b74:	89 ea                	mov    %ebp,%edx
  802b76:	83 c4 0c             	add    $0xc,%esp
  802b79:	5e                   	pop    %esi
  802b7a:	5f                   	pop    %edi
  802b7b:	5d                   	pop    %ebp
  802b7c:	c3                   	ret    
  802b7d:	8d 76 00             	lea    0x0(%esi),%esi
  802b80:	39 e8                	cmp    %ebp,%eax
  802b82:	77 24                	ja     802ba8 <__udivdi3+0x78>
  802b84:	0f bd e8             	bsr    %eax,%ebp
  802b87:	83 f5 1f             	xor    $0x1f,%ebp
  802b8a:	75 3c                	jne    802bc8 <__udivdi3+0x98>
  802b8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b90:	39 34 24             	cmp    %esi,(%esp)
  802b93:	0f 86 9f 00 00 00    	jbe    802c38 <__udivdi3+0x108>
  802b99:	39 d0                	cmp    %edx,%eax
  802b9b:	0f 82 97 00 00 00    	jb     802c38 <__udivdi3+0x108>
  802ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	31 d2                	xor    %edx,%edx
  802baa:	31 c0                	xor    %eax,%eax
  802bac:	83 c4 0c             	add    $0xc,%esp
  802baf:	5e                   	pop    %esi
  802bb0:	5f                   	pop    %edi
  802bb1:	5d                   	pop    %ebp
  802bb2:	c3                   	ret    
  802bb3:	90                   	nop
  802bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	89 f8                	mov    %edi,%eax
  802bba:	f7 f1                	div    %ecx
  802bbc:	31 d2                	xor    %edx,%edx
  802bbe:	83 c4 0c             	add    $0xc,%esp
  802bc1:	5e                   	pop    %esi
  802bc2:	5f                   	pop    %edi
  802bc3:	5d                   	pop    %ebp
  802bc4:	c3                   	ret    
  802bc5:	8d 76 00             	lea    0x0(%esi),%esi
  802bc8:	89 e9                	mov    %ebp,%ecx
  802bca:	8b 3c 24             	mov    (%esp),%edi
  802bcd:	d3 e0                	shl    %cl,%eax
  802bcf:	89 c6                	mov    %eax,%esi
  802bd1:	b8 20 00 00 00       	mov    $0x20,%eax
  802bd6:	29 e8                	sub    %ebp,%eax
  802bd8:	89 c1                	mov    %eax,%ecx
  802bda:	d3 ef                	shr    %cl,%edi
  802bdc:	89 e9                	mov    %ebp,%ecx
  802bde:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802be2:	8b 3c 24             	mov    (%esp),%edi
  802be5:	09 74 24 08          	or     %esi,0x8(%esp)
  802be9:	89 d6                	mov    %edx,%esi
  802beb:	d3 e7                	shl    %cl,%edi
  802bed:	89 c1                	mov    %eax,%ecx
  802bef:	89 3c 24             	mov    %edi,(%esp)
  802bf2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bf6:	d3 ee                	shr    %cl,%esi
  802bf8:	89 e9                	mov    %ebp,%ecx
  802bfa:	d3 e2                	shl    %cl,%edx
  802bfc:	89 c1                	mov    %eax,%ecx
  802bfe:	d3 ef                	shr    %cl,%edi
  802c00:	09 d7                	or     %edx,%edi
  802c02:	89 f2                	mov    %esi,%edx
  802c04:	89 f8                	mov    %edi,%eax
  802c06:	f7 74 24 08          	divl   0x8(%esp)
  802c0a:	89 d6                	mov    %edx,%esi
  802c0c:	89 c7                	mov    %eax,%edi
  802c0e:	f7 24 24             	mull   (%esp)
  802c11:	39 d6                	cmp    %edx,%esi
  802c13:	89 14 24             	mov    %edx,(%esp)
  802c16:	72 30                	jb     802c48 <__udivdi3+0x118>
  802c18:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c1c:	89 e9                	mov    %ebp,%ecx
  802c1e:	d3 e2                	shl    %cl,%edx
  802c20:	39 c2                	cmp    %eax,%edx
  802c22:	73 05                	jae    802c29 <__udivdi3+0xf9>
  802c24:	3b 34 24             	cmp    (%esp),%esi
  802c27:	74 1f                	je     802c48 <__udivdi3+0x118>
  802c29:	89 f8                	mov    %edi,%eax
  802c2b:	31 d2                	xor    %edx,%edx
  802c2d:	e9 7a ff ff ff       	jmp    802bac <__udivdi3+0x7c>
  802c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c38:	31 d2                	xor    %edx,%edx
  802c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3f:	e9 68 ff ff ff       	jmp    802bac <__udivdi3+0x7c>
  802c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c48:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	83 c4 0c             	add    $0xc,%esp
  802c50:	5e                   	pop    %esi
  802c51:	5f                   	pop    %edi
  802c52:	5d                   	pop    %ebp
  802c53:	c3                   	ret    
  802c54:	66 90                	xchg   %ax,%ax
  802c56:	66 90                	xchg   %ax,%ax
  802c58:	66 90                	xchg   %ax,%ax
  802c5a:	66 90                	xchg   %ax,%ax
  802c5c:	66 90                	xchg   %ax,%ax
  802c5e:	66 90                	xchg   %ax,%ax

00802c60 <__umoddi3>:
  802c60:	55                   	push   %ebp
  802c61:	57                   	push   %edi
  802c62:	56                   	push   %esi
  802c63:	83 ec 14             	sub    $0x14,%esp
  802c66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c72:	89 c7                	mov    %eax,%edi
  802c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c78:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c80:	89 34 24             	mov    %esi,(%esp)
  802c83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c87:	85 c0                	test   %eax,%eax
  802c89:	89 c2                	mov    %eax,%edx
  802c8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c8f:	75 17                	jne    802ca8 <__umoddi3+0x48>
  802c91:	39 fe                	cmp    %edi,%esi
  802c93:	76 4b                	jbe    802ce0 <__umoddi3+0x80>
  802c95:	89 c8                	mov    %ecx,%eax
  802c97:	89 fa                	mov    %edi,%edx
  802c99:	f7 f6                	div    %esi
  802c9b:	89 d0                	mov    %edx,%eax
  802c9d:	31 d2                	xor    %edx,%edx
  802c9f:	83 c4 14             	add    $0x14,%esp
  802ca2:	5e                   	pop    %esi
  802ca3:	5f                   	pop    %edi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    
  802ca6:	66 90                	xchg   %ax,%ax
  802ca8:	39 f8                	cmp    %edi,%eax
  802caa:	77 54                	ja     802d00 <__umoddi3+0xa0>
  802cac:	0f bd e8             	bsr    %eax,%ebp
  802caf:	83 f5 1f             	xor    $0x1f,%ebp
  802cb2:	75 5c                	jne    802d10 <__umoddi3+0xb0>
  802cb4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cb8:	39 3c 24             	cmp    %edi,(%esp)
  802cbb:	0f 87 e7 00 00 00    	ja     802da8 <__umoddi3+0x148>
  802cc1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cc5:	29 f1                	sub    %esi,%ecx
  802cc7:	19 c7                	sbb    %eax,%edi
  802cc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ccd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cd1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cd5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802cd9:	83 c4 14             	add    $0x14,%esp
  802cdc:	5e                   	pop    %esi
  802cdd:	5f                   	pop    %edi
  802cde:	5d                   	pop    %ebp
  802cdf:	c3                   	ret    
  802ce0:	85 f6                	test   %esi,%esi
  802ce2:	89 f5                	mov    %esi,%ebp
  802ce4:	75 0b                	jne    802cf1 <__umoddi3+0x91>
  802ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ceb:	31 d2                	xor    %edx,%edx
  802ced:	f7 f6                	div    %esi
  802cef:	89 c5                	mov    %eax,%ebp
  802cf1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cf5:	31 d2                	xor    %edx,%edx
  802cf7:	f7 f5                	div    %ebp
  802cf9:	89 c8                	mov    %ecx,%eax
  802cfb:	f7 f5                	div    %ebp
  802cfd:	eb 9c                	jmp    802c9b <__umoddi3+0x3b>
  802cff:	90                   	nop
  802d00:	89 c8                	mov    %ecx,%eax
  802d02:	89 fa                	mov    %edi,%edx
  802d04:	83 c4 14             	add    $0x14,%esp
  802d07:	5e                   	pop    %esi
  802d08:	5f                   	pop    %edi
  802d09:	5d                   	pop    %ebp
  802d0a:	c3                   	ret    
  802d0b:	90                   	nop
  802d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d10:	8b 04 24             	mov    (%esp),%eax
  802d13:	be 20 00 00 00       	mov    $0x20,%esi
  802d18:	89 e9                	mov    %ebp,%ecx
  802d1a:	29 ee                	sub    %ebp,%esi
  802d1c:	d3 e2                	shl    %cl,%edx
  802d1e:	89 f1                	mov    %esi,%ecx
  802d20:	d3 e8                	shr    %cl,%eax
  802d22:	89 e9                	mov    %ebp,%ecx
  802d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d28:	8b 04 24             	mov    (%esp),%eax
  802d2b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d2f:	89 fa                	mov    %edi,%edx
  802d31:	d3 e0                	shl    %cl,%eax
  802d33:	89 f1                	mov    %esi,%ecx
  802d35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d39:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d3d:	d3 ea                	shr    %cl,%edx
  802d3f:	89 e9                	mov    %ebp,%ecx
  802d41:	d3 e7                	shl    %cl,%edi
  802d43:	89 f1                	mov    %esi,%ecx
  802d45:	d3 e8                	shr    %cl,%eax
  802d47:	89 e9                	mov    %ebp,%ecx
  802d49:	09 f8                	or     %edi,%eax
  802d4b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d4f:	f7 74 24 04          	divl   0x4(%esp)
  802d53:	d3 e7                	shl    %cl,%edi
  802d55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d59:	89 d7                	mov    %edx,%edi
  802d5b:	f7 64 24 08          	mull   0x8(%esp)
  802d5f:	39 d7                	cmp    %edx,%edi
  802d61:	89 c1                	mov    %eax,%ecx
  802d63:	89 14 24             	mov    %edx,(%esp)
  802d66:	72 2c                	jb     802d94 <__umoddi3+0x134>
  802d68:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d6c:	72 22                	jb     802d90 <__umoddi3+0x130>
  802d6e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d72:	29 c8                	sub    %ecx,%eax
  802d74:	19 d7                	sbb    %edx,%edi
  802d76:	89 e9                	mov    %ebp,%ecx
  802d78:	89 fa                	mov    %edi,%edx
  802d7a:	d3 e8                	shr    %cl,%eax
  802d7c:	89 f1                	mov    %esi,%ecx
  802d7e:	d3 e2                	shl    %cl,%edx
  802d80:	89 e9                	mov    %ebp,%ecx
  802d82:	d3 ef                	shr    %cl,%edi
  802d84:	09 d0                	or     %edx,%eax
  802d86:	89 fa                	mov    %edi,%edx
  802d88:	83 c4 14             	add    $0x14,%esp
  802d8b:	5e                   	pop    %esi
  802d8c:	5f                   	pop    %edi
  802d8d:	5d                   	pop    %ebp
  802d8e:	c3                   	ret    
  802d8f:	90                   	nop
  802d90:	39 d7                	cmp    %edx,%edi
  802d92:	75 da                	jne    802d6e <__umoddi3+0x10e>
  802d94:	8b 14 24             	mov    (%esp),%edx
  802d97:	89 c1                	mov    %eax,%ecx
  802d99:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d9d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802da1:	eb cb                	jmp    802d6e <__umoddi3+0x10e>
  802da3:	90                   	nop
  802da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802da8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dac:	0f 82 0f ff ff ff    	jb     802cc1 <__umoddi3+0x61>
  802db2:	e9 1a ff ff ff       	jmp    802cd1 <__umoddi3+0x71>
