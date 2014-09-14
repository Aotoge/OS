
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx
	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 40 22 80 00 	movl   $0x802240,(%esp)
  80004a:	e8 2f 02 00 00       	call   80027e <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 1b 0d 00 00       	call   800d89 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 60 22 80 	movl   $0x802260,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 4a 22 80 00 	movl   $0x80224a,(%esp)
  800091:	e8 ef 00 00 00       	call   800185 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 8c 22 80 	movl   $0x80228c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 9e 07 00 00       	call   800850 <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 27 0f 00 00       	call   800ff1 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000ca:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d1:	de 
  8000d2:	c7 04 24 5c 22 80 00 	movl   $0x80225c,(%esp)
  8000d9:	e8 a0 01 00 00       	call   80027e <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000de:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e5:	ca 
  8000e6:	c7 04 24 5c 22 80 00 	movl   $0x80225c,(%esp)
  8000ed:	e8 8c 01 00 00       	call   80027e <cprintf>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800102:	e8 44 0c 00 00       	call   800d4b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800107:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80010d:	39 c2                	cmp    %eax,%edx
  80010f:	74 17                	je     800128 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800111:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800116:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800119:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80011f:	8b 49 40             	mov    0x40(%ecx),%ecx
  800122:	39 c1                	cmp    %eax,%ecx
  800124:	75 18                	jne    80013e <libmain+0x4a>
  800126:	eb 05                	jmp    80012d <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800128:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80012d:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800130:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800136:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80013c:	eb 0b                	jmp    800149 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80013e:	83 c2 01             	add    $0x1,%edx
  800141:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800147:	75 cd                	jne    800116 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800149:	85 db                	test   %ebx,%ebx
  80014b:	7e 07                	jle    800154 <libmain+0x60>
		binaryname = argv[0];
  80014d:	8b 06                	mov    (%esi),%eax
  80014f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800154:	89 74 24 04          	mov    %esi,0x4(%esp)
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 58 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800160:	e8 07 00 00 00       	call   80016c <exit>
}
  800165:	83 c4 10             	add    $0x10,%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800172:	e8 4f 11 00 00       	call   8012c6 <close_all>
	sys_env_destroy(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 76 0b 00 00       	call   800cf9 <sys_env_destroy>
}
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80018d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800190:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800196:	e8 b0 0b 00 00       	call   800d4b <sys_getenvid>
  80019b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019e:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001a9:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	c7 04 24 b8 22 80 00 	movl   $0x8022b8,(%esp)
  8001b8:	e8 c1 00 00 00       	call   80027e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c4:	89 04 24             	mov    %eax,(%esp)
  8001c7:	e8 51 00 00 00       	call   80021d <vcprintf>
	cprintf("\n");
  8001cc:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  8001d3:	e8 a6 00 00 00       	call   80027e <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d8:	cc                   	int3   
  8001d9:	eb fd                	jmp    8001d8 <_panic+0x53>

008001db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	53                   	push   %ebx
  8001df:	83 ec 14             	sub    $0x14,%esp
  8001e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e5:	8b 13                	mov    (%ebx),%edx
  8001e7:	8d 42 01             	lea    0x1(%edx),%eax
  8001ea:	89 03                	mov    %eax,(%ebx)
  8001ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f8:	75 19                	jne    800213 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001fa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800201:	00 
  800202:	8d 43 08             	lea    0x8(%ebx),%eax
  800205:	89 04 24             	mov    %eax,(%esp)
  800208:	e8 af 0a 00 00       	call   800cbc <sys_cputs>
		b->idx = 0;
  80020d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800213:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800217:	83 c4 14             	add    $0x14,%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    

0080021d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800226:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022d:	00 00 00 
	b.cnt = 0;
  800230:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800237:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800241:	8b 45 08             	mov    0x8(%ebp),%eax
  800244:	89 44 24 08          	mov    %eax,0x8(%esp)
  800248:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800252:	c7 04 24 db 01 80 00 	movl   $0x8001db,(%esp)
  800259:	e8 b6 01 00 00       	call   800414 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800264:	89 44 24 04          	mov    %eax,0x4(%esp)
  800268:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	e8 46 0a 00 00       	call   800cbc <sys_cputs>

	return b.cnt;
}
  800276:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800284:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	89 04 24             	mov    %eax,(%esp)
  800291:	e8 87 ff ff ff       	call   80021d <vcprintf>
	va_end(ap);

	return cnt;
}
  800296:	c9                   	leave  
  800297:	c3                   	ret    
  800298:	66 90                	xchg   %ax,%ax
  80029a:	66 90                	xchg   %ax,%ax
  80029c:	66 90                	xchg   %ax,%ax
  80029e:	66 90                	xchg   %ax,%ax

008002a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 3c             	sub    $0x3c,%esp
  8002a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ac:	89 d7                	mov    %edx,%edi
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002b7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c8:	39 f1                	cmp    %esi,%ecx
  8002ca:	72 14                	jb     8002e0 <printnum+0x40>
  8002cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002cf:	76 0f                	jbe    8002e0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	85 f6                	test   %esi,%esi
  8002dc:	7f 60                	jg     80033e <printnum+0x9e>
  8002de:	eb 72                	jmp    800352 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002e3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8002ea:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8002ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002f9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002fd:	89 c3                	mov    %eax,%ebx
  8002ff:	89 d6                	mov    %edx,%esi
  800301:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800304:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800307:	89 54 24 08          	mov    %edx,0x8(%esp)
  80030b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80030f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800312:	89 04 24             	mov    %eax,(%esp)
  800315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031c:	e8 8f 1c 00 00       	call   801fb0 <__udivdi3>
  800321:	89 d9                	mov    %ebx,%ecx
  800323:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800327:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80032b:	89 04 24             	mov    %eax,(%esp)
  80032e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800332:	89 fa                	mov    %edi,%edx
  800334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800337:	e8 64 ff ff ff       	call   8002a0 <printnum>
  80033c:	eb 14                	jmp    800352 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800342:	8b 45 18             	mov    0x18(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034a:	83 ee 01             	sub    $0x1,%esi
  80034d:	75 ef                	jne    80033e <printnum+0x9e>
  80034f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800352:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800356:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80035a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800360:	89 44 24 08          	mov    %eax,0x8(%esp)
  800364:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	89 04 24             	mov    %eax,(%esp)
  80036e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800371:	89 44 24 04          	mov    %eax,0x4(%esp)
  800375:	e8 66 1d 00 00       	call   8020e0 <__umoddi3>
  80037a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037e:	0f be 80 db 22 80 00 	movsbl 0x8022db(%eax),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038b:	ff d0                	call   *%eax
}
  80038d:	83 c4 3c             	add    $0x3c,%esp
  800390:	5b                   	pop    %ebx
  800391:	5e                   	pop    %esi
  800392:	5f                   	pop    %edi
  800393:	5d                   	pop    %ebp
  800394:	c3                   	ret    

00800395 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800398:	83 fa 01             	cmp    $0x1,%edx
  80039b:	7e 0e                	jle    8003ab <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80039d:	8b 10                	mov    (%eax),%edx
  80039f:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003a2:	89 08                	mov    %ecx,(%eax)
  8003a4:	8b 02                	mov    (%edx),%eax
  8003a6:	8b 52 04             	mov    0x4(%edx),%edx
  8003a9:	eb 22                	jmp    8003cd <getuint+0x38>
	else if (lflag)
  8003ab:	85 d2                	test   %edx,%edx
  8003ad:	74 10                	je     8003bf <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003af:	8b 10                	mov    (%eax),%edx
  8003b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b4:	89 08                	mov    %ecx,(%eax)
  8003b6:	8b 02                	mov    (%edx),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	eb 0e                	jmp    8003cd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003bf:	8b 10                	mov    (%eax),%edx
  8003c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 02                	mov    (%edx),%eax
  8003c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	3b 50 04             	cmp    0x4(%eax),%edx
  8003de:	73 0a                	jae    8003ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 02                	mov    %al,(%edx)
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	89 04 24             	mov    %eax,(%esp)
  80040d:	e8 02 00 00 00       	call   800414 <vprintfmt>
	va_end(ap);
}
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	57                   	push   %edi
  800418:	56                   	push   %esi
  800419:	53                   	push   %ebx
  80041a:	83 ec 3c             	sub    $0x3c,%esp
  80041d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800420:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800423:	eb 18                	jmp    80043d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800425:	85 c0                	test   %eax,%eax
  800427:	0f 84 c3 03 00 00    	je     8007f0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80042d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800431:	89 04 24             	mov    %eax,(%esp)
  800434:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800437:	89 f3                	mov    %esi,%ebx
  800439:	eb 02                	jmp    80043d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80043b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80043d:	8d 73 01             	lea    0x1(%ebx),%esi
  800440:	0f b6 03             	movzbl (%ebx),%eax
  800443:	83 f8 25             	cmp    $0x25,%eax
  800446:	75 dd                	jne    800425 <vprintfmt+0x11>
  800448:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80044c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800453:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80045a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800461:	ba 00 00 00 00       	mov    $0x0,%edx
  800466:	eb 1d                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800468:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80046a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80046e:	eb 15                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800470:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800472:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800476:	eb 0d                	jmp    800485 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80047b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8d 5e 01             	lea    0x1(%esi),%ebx
  800488:	0f b6 06             	movzbl (%esi),%eax
  80048b:	0f b6 c8             	movzbl %al,%ecx
  80048e:	83 e8 23             	sub    $0x23,%eax
  800491:	3c 55                	cmp    $0x55,%al
  800493:	0f 87 2f 03 00 00    	ja     8007c8 <vprintfmt+0x3b4>
  800499:	0f b6 c0             	movzbl %al,%eax
  80049c:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8004a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8004a9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8004ad:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8004b0:	83 f9 09             	cmp    $0x9,%ecx
  8004b3:	77 50                	ja     800505 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	89 de                	mov    %ebx,%esi
  8004b7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ba:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004bd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004c0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004c4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004c7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ca:	83 fb 09             	cmp    $0x9,%ebx
  8004cd:	76 eb                	jbe    8004ba <vprintfmt+0xa6>
  8004cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004d2:	eb 33                	jmp    800507 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 48 04             	lea    0x4(%eax),%ecx
  8004da:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e4:	eb 21                	jmp    800507 <vprintfmt+0xf3>
  8004e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e9:	85 c9                	test   %ecx,%ecx
  8004eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f0:	0f 49 c1             	cmovns %ecx,%eax
  8004f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
  8004f8:	eb 8b                	jmp    800485 <vprintfmt+0x71>
  8004fa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004fc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800503:	eb 80                	jmp    800485 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800505:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80050b:	0f 89 74 ff ff ff    	jns    800485 <vprintfmt+0x71>
  800511:	e9 62 ff ff ff       	jmp    800478 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800516:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800519:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80051b:	e9 65 ff ff ff       	jmp    800485 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 50 04             	lea    0x4(%eax),%edx
  800526:	89 55 14             	mov    %edx,0x14(%ebp)
  800529:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 04 24             	mov    %eax,(%esp)
  800532:	ff 55 08             	call   *0x8(%ebp)
			break;
  800535:	e9 03 ff ff ff       	jmp    80043d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8d 50 04             	lea    0x4(%eax),%edx
  800540:	89 55 14             	mov    %edx,0x14(%ebp)
  800543:	8b 00                	mov    (%eax),%eax
  800545:	99                   	cltd   
  800546:	31 d0                	xor    %edx,%eax
  800548:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054a:	83 f8 0f             	cmp    $0xf,%eax
  80054d:	7f 0b                	jg     80055a <vprintfmt+0x146>
  80054f:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  800556:	85 d2                	test   %edx,%edx
  800558:	75 20                	jne    80057a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80055a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80055e:	c7 44 24 08 f3 22 80 	movl   $0x8022f3,0x8(%esp)
  800565:	00 
  800566:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	e8 77 fe ff ff       	call   8003ec <printfmt>
  800575:	e9 c3 fe ff ff       	jmp    80043d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80057a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80057e:	c7 44 24 08 d6 26 80 	movl   $0x8026d6,0x8(%esp)
  800585:	00 
  800586:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 04 24             	mov    %eax,(%esp)
  800590:	e8 57 fe ff ff       	call   8003ec <printfmt>
  800595:	e9 a3 fe ff ff       	jmp    80043d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80059d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 50 04             	lea    0x4(%eax),%edx
  8005a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8005ab:	85 c0                	test   %eax,%eax
  8005ad:	ba ec 22 80 00       	mov    $0x8022ec,%edx
  8005b2:	0f 45 d0             	cmovne %eax,%edx
  8005b5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8005b8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8005bc:	74 04                	je     8005c2 <vprintfmt+0x1ae>
  8005be:	85 f6                	test   %esi,%esi
  8005c0:	7f 19                	jg     8005db <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c5:	8d 70 01             	lea    0x1(%eax),%esi
  8005c8:	0f b6 10             	movzbl (%eax),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	0f 85 95 00 00 00    	jne    80066b <vprintfmt+0x257>
  8005d6:	e9 85 00 00 00       	jmp    800660 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e2:	89 04 24             	mov    %eax,(%esp)
  8005e5:	e8 b8 02 00 00       	call   8008a2 <strnlen>
  8005ea:	29 c6                	sub    %eax,%esi
  8005ec:	89 f0                	mov    %esi,%eax
  8005ee:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005f1:	85 f6                	test   %esi,%esi
  8005f3:	7e cd                	jle    8005c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005f5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005fc:	89 c3                	mov    %eax,%ebx
  8005fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800602:	89 34 24             	mov    %esi,(%esp)
  800605:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800608:	83 eb 01             	sub    $0x1,%ebx
  80060b:	75 f1                	jne    8005fe <vprintfmt+0x1ea>
  80060d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800610:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800613:	eb ad                	jmp    8005c2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800615:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800619:	74 1e                	je     800639 <vprintfmt+0x225>
  80061b:	0f be d2             	movsbl %dl,%edx
  80061e:	83 ea 20             	sub    $0x20,%edx
  800621:	83 fa 5e             	cmp    $0x5e,%edx
  800624:	76 13                	jbe    800639 <vprintfmt+0x225>
					putch('?', putdat);
  800626:	8b 45 0c             	mov    0xc(%ebp),%eax
  800629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800634:	ff 55 08             	call   *0x8(%ebp)
  800637:	eb 0d                	jmp    800646 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800639:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800640:	89 04 24             	mov    %eax,(%esp)
  800643:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800646:	83 ef 01             	sub    $0x1,%edi
  800649:	83 c6 01             	add    $0x1,%esi
  80064c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800650:	0f be c2             	movsbl %dl,%eax
  800653:	85 c0                	test   %eax,%eax
  800655:	75 20                	jne    800677 <vprintfmt+0x263>
  800657:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80065a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80065d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800664:	7f 25                	jg     80068b <vprintfmt+0x277>
  800666:	e9 d2 fd ff ff       	jmp    80043d <vprintfmt+0x29>
  80066b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800671:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800674:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800677:	85 db                	test   %ebx,%ebx
  800679:	78 9a                	js     800615 <vprintfmt+0x201>
  80067b:	83 eb 01             	sub    $0x1,%ebx
  80067e:	79 95                	jns    800615 <vprintfmt+0x201>
  800680:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800683:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800686:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800689:	eb d5                	jmp    800660 <vprintfmt+0x24c>
  80068b:	8b 75 08             	mov    0x8(%ebp),%esi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800694:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800698:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80069f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a1:	83 eb 01             	sub    $0x1,%ebx
  8006a4:	75 ee                	jne    800694 <vprintfmt+0x280>
  8006a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006a9:	e9 8f fd ff ff       	jmp    80043d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ae:	83 fa 01             	cmp    $0x1,%edx
  8006b1:	7e 16                	jle    8006c9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 50 08             	lea    0x8(%eax),%edx
  8006b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	eb 32                	jmp    8006fb <vprintfmt+0x2e7>
	else if (lflag)
  8006c9:	85 d2                	test   %edx,%edx
  8006cb:	74 18                	je     8006e5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d6:	8b 30                	mov    (%eax),%esi
  8006d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006db:	89 f0                	mov    %esi,%eax
  8006dd:	c1 f8 1f             	sar    $0x1f,%eax
  8006e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006e3:	eb 16                	jmp    8006fb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 04             	lea    0x4(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 30                	mov    (%eax),%esi
  8006f0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	c1 f8 1f             	sar    $0x1f,%eax
  8006f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800701:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800706:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070a:	0f 89 80 00 00 00    	jns    800790 <vprintfmt+0x37c>
				putch('-', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80071e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800721:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800724:	f7 d8                	neg    %eax
  800726:	83 d2 00             	adc    $0x0,%edx
  800729:	f7 da                	neg    %edx
			}
			base = 10;
  80072b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800730:	eb 5e                	jmp    800790 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800732:	8d 45 14             	lea    0x14(%ebp),%eax
  800735:	e8 5b fc ff ff       	call   800395 <getuint>
			base = 10;
  80073a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80073f:	eb 4f                	jmp    800790 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800741:	8d 45 14             	lea    0x14(%ebp),%eax
  800744:	e8 4c fc ff ff       	call   800395 <getuint>
			base = 8;
  800749:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80074e:	eb 40                	jmp    800790 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800754:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80075e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800762:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800769:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 50 04             	lea    0x4(%eax),%edx
  800772:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80077c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800781:	eb 0d                	jmp    800790 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	e8 0a fc ff ff       	call   800395 <getuint>
			base = 16;
  80078b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800790:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800794:	89 74 24 10          	mov    %esi,0x10(%esp)
  800798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80079b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80079f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007a3:	89 04 24             	mov    %eax,(%esp)
  8007a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007aa:	89 fa                	mov    %edi,%edx
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	e8 ec fa ff ff       	call   8002a0 <printnum>
			break;
  8007b4:	e9 84 fc ff ff       	jmp    80043d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bd:	89 0c 24             	mov    %ecx,(%esp)
  8007c0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007c3:	e9 75 fc ff ff       	jmp    80043d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007d3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007da:	0f 84 5b fc ff ff    	je     80043b <vprintfmt+0x27>
  8007e0:	89 f3                	mov    %esi,%ebx
  8007e2:	83 eb 01             	sub    $0x1,%ebx
  8007e5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007e9:	75 f7                	jne    8007e2 <vprintfmt+0x3ce>
  8007eb:	e9 4d fc ff ff       	jmp    80043d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007f0:	83 c4 3c             	add    $0x3c,%esp
  8007f3:	5b                   	pop    %ebx
  8007f4:	5e                   	pop    %esi
  8007f5:	5f                   	pop    %edi
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 28             	sub    $0x28,%esp
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800807:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80080b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80080e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800815:	85 c0                	test   %eax,%eax
  800817:	74 30                	je     800849 <vsnprintf+0x51>
  800819:	85 d2                	test   %edx,%edx
  80081b:	7e 2c                	jle    800849 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80082e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800832:	c7 04 24 cf 03 80 00 	movl   $0x8003cf,(%esp)
  800839:	e8 d6 fb ff ff       	call   800414 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80083e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800841:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	eb 05                	jmp    80084e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800849:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800859:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085d:	8b 45 10             	mov    0x10(%ebp),%eax
  800860:	89 44 24 08          	mov    %eax,0x8(%esp)
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 04 24             	mov    %eax,(%esp)
  800871:	e8 82 ff ff ff       	call   8007f8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    
  800878:	66 90                	xchg   %ax,%ax
  80087a:	66 90                	xchg   %ax,%ax
  80087c:	66 90                	xchg   %ax,%ax
  80087e:	66 90                	xchg   %ax,%ax

00800880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800886:	80 3a 00             	cmpb   $0x0,(%edx)
  800889:	74 10                	je     80089b <strlen+0x1b>
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800890:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800893:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800897:	75 f7                	jne    800890 <strlen+0x10>
  800899:	eb 05                	jmp    8008a0 <strlen+0x20>
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	74 1c                	je     8008cc <strnlen+0x2a>
  8008b0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008b3:	74 1e                	je     8008d3 <strnlen+0x31>
  8008b5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008ba:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bc:	39 ca                	cmp    %ecx,%edx
  8008be:	74 18                	je     8008d8 <strnlen+0x36>
  8008c0:	83 c2 01             	add    $0x1,%edx
  8008c3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008c8:	75 f0                	jne    8008ba <strnlen+0x18>
  8008ca:	eb 0c                	jmp    8008d8 <strnlen+0x36>
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d1:	eb 05                	jmp    8008d8 <strnlen+0x36>
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	83 c2 01             	add    $0x1,%edx
  8008ea:	83 c1 01             	add    $0x1,%ecx
  8008ed:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008f1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f4:	84 db                	test   %bl,%bl
  8008f6:	75 ef                	jne    8008e7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f8:	5b                   	pop    %ebx
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	53                   	push   %ebx
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800905:	89 1c 24             	mov    %ebx,(%esp)
  800908:	e8 73 ff ff ff       	call   800880 <strlen>
	strcpy(dst + len, src);
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	89 54 24 04          	mov    %edx,0x4(%esp)
  800914:	01 d8                	add    %ebx,%eax
  800916:	89 04 24             	mov    %eax,(%esp)
  800919:	e8 bd ff ff ff       	call   8008db <strcpy>
	return dst;
}
  80091e:	89 d8                	mov    %ebx,%eax
  800920:	83 c4 08             	add    $0x8,%esp
  800923:	5b                   	pop    %ebx
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	56                   	push   %esi
  80092a:	53                   	push   %ebx
  80092b:	8b 75 08             	mov    0x8(%ebp),%esi
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800931:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800934:	85 db                	test   %ebx,%ebx
  800936:	74 17                	je     80094f <strncpy+0x29>
  800938:	01 f3                	add    %esi,%ebx
  80093a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80093c:	83 c1 01             	add    $0x1,%ecx
  80093f:	0f b6 02             	movzbl (%edx),%eax
  800942:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800945:	80 3a 01             	cmpb   $0x1,(%edx)
  800948:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094b:	39 d9                	cmp    %ebx,%ecx
  80094d:	75 ed                	jne    80093c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80094f:	89 f0                	mov    %esi,%eax
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	57                   	push   %edi
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800961:	8b 75 10             	mov    0x10(%ebp),%esi
  800964:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800966:	85 f6                	test   %esi,%esi
  800968:	74 34                	je     80099e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80096a:	83 fe 01             	cmp    $0x1,%esi
  80096d:	74 26                	je     800995 <strlcpy+0x40>
  80096f:	0f b6 0b             	movzbl (%ebx),%ecx
  800972:	84 c9                	test   %cl,%cl
  800974:	74 23                	je     800999 <strlcpy+0x44>
  800976:	83 ee 02             	sub    $0x2,%esi
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800984:	39 f2                	cmp    %esi,%edx
  800986:	74 13                	je     80099b <strlcpy+0x46>
  800988:	83 c2 01             	add    $0x1,%edx
  80098b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098f:	84 c9                	test   %cl,%cl
  800991:	75 eb                	jne    80097e <strlcpy+0x29>
  800993:	eb 06                	jmp    80099b <strlcpy+0x46>
  800995:	89 f8                	mov    %edi,%eax
  800997:	eb 02                	jmp    80099b <strlcpy+0x46>
  800999:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80099b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099e:	29 f8                	sub    %edi,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5f                   	pop    %edi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 15                	je     8009ca <strcmp+0x25>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	75 11                	jne    8009ca <strcmp+0x25>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009bf:	0f b6 01             	movzbl (%ecx),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 04                	je     8009ca <strcmp+0x25>
  8009c6:	3a 02                	cmp    (%edx),%al
  8009c8:	74 ef                	je     8009b9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 c0             	movzbl %al,%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8009e2:	85 f6                	test   %esi,%esi
  8009e4:	74 29                	je     800a0f <strncmp+0x3b>
  8009e6:	0f b6 03             	movzbl (%ebx),%eax
  8009e9:	84 c0                	test   %al,%al
  8009eb:	74 30                	je     800a1d <strncmp+0x49>
  8009ed:	3a 02                	cmp    (%edx),%al
  8009ef:	75 2c                	jne    800a1d <strncmp+0x49>
  8009f1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009f4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009f6:	89 c3                	mov    %eax,%ebx
  8009f8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009fb:	39 f0                	cmp    %esi,%eax
  8009fd:	74 17                	je     800a16 <strncmp+0x42>
  8009ff:	0f b6 08             	movzbl (%eax),%ecx
  800a02:	84 c9                	test   %cl,%cl
  800a04:	74 17                	je     800a1d <strncmp+0x49>
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	3a 0a                	cmp    (%edx),%cl
  800a0b:	74 e9                	je     8009f6 <strncmp+0x22>
  800a0d:	eb 0e                	jmp    800a1d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	eb 0f                	jmp    800a25 <strncmp+0x51>
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	eb 08                	jmp    800a25 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 03             	movzbl (%ebx),%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5e                   	pop    %esi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a33:	0f b6 18             	movzbl (%eax),%ebx
  800a36:	84 db                	test   %bl,%bl
  800a38:	74 1d                	je     800a57 <strchr+0x2e>
  800a3a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a3c:	38 d3                	cmp    %dl,%bl
  800a3e:	75 06                	jne    800a46 <strchr+0x1d>
  800a40:	eb 1a                	jmp    800a5c <strchr+0x33>
  800a42:	38 ca                	cmp    %cl,%dl
  800a44:	74 16                	je     800a5c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a46:	83 c0 01             	add    $0x1,%eax
  800a49:	0f b6 10             	movzbl (%eax),%edx
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	75 f2                	jne    800a42 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	eb 05                	jmp    800a5c <strchr+0x33>
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5c:	5b                   	pop    %ebx
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	53                   	push   %ebx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a69:	0f b6 18             	movzbl (%eax),%ebx
  800a6c:	84 db                	test   %bl,%bl
  800a6e:	74 16                	je     800a86 <strfind+0x27>
  800a70:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a72:	38 d3                	cmp    %dl,%bl
  800a74:	75 06                	jne    800a7c <strfind+0x1d>
  800a76:	eb 0e                	jmp    800a86 <strfind+0x27>
  800a78:	38 ca                	cmp    %cl,%dl
  800a7a:	74 0a                	je     800a86 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a7c:	83 c0 01             	add    $0x1,%eax
  800a7f:	0f b6 10             	movzbl (%eax),%edx
  800a82:	84 d2                	test   %dl,%dl
  800a84:	75 f2                	jne    800a78 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a86:	5b                   	pop    %ebx
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a95:	85 c9                	test   %ecx,%ecx
  800a97:	74 36                	je     800acf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a99:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9f:	75 28                	jne    800ac9 <memset+0x40>
  800aa1:	f6 c1 03             	test   $0x3,%cl
  800aa4:	75 23                	jne    800ac9 <memset+0x40>
		c &= 0xFF;
  800aa6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	c1 e3 08             	shl    $0x8,%ebx
  800aaf:	89 d6                	mov    %edx,%esi
  800ab1:	c1 e6 18             	shl    $0x18,%esi
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 10             	shl    $0x10,%eax
  800ab9:	09 f0                	or     %esi,%eax
  800abb:	09 c2                	or     %eax,%edx
  800abd:	89 d0                	mov    %edx,%eax
  800abf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac4:	fc                   	cld    
  800ac5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac7:	eb 06                	jmp    800acf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	fc                   	cld    
  800acd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acf:	89 f8                	mov    %edi,%eax
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae4:	39 c6                	cmp    %eax,%esi
  800ae6:	73 35                	jae    800b1d <memmove+0x47>
  800ae8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aeb:	39 d0                	cmp    %edx,%eax
  800aed:	73 2e                	jae    800b1d <memmove+0x47>
		s += n;
		d += n;
  800aef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800af2:	89 d6                	mov    %edx,%esi
  800af4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afc:	75 13                	jne    800b11 <memmove+0x3b>
  800afe:	f6 c1 03             	test   $0x3,%cl
  800b01:	75 0e                	jne    800b11 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b03:	83 ef 04             	sub    $0x4,%edi
  800b06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b09:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0f:	eb 09                	jmp    800b1a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 1d                	jmp    800b3a <memmove+0x64>
  800b1d:	89 f2                	mov    %esi,%edx
  800b1f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	f6 c2 03             	test   $0x3,%dl
  800b24:	75 0f                	jne    800b35 <memmove+0x5f>
  800b26:	f6 c1 03             	test   $0x3,%cl
  800b29:	75 0a                	jne    800b35 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2e:	89 c7                	mov    %eax,%edi
  800b30:	fc                   	cld    
  800b31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b33:	eb 05                	jmp    800b3a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b35:	89 c7                	mov    %eax,%edi
  800b37:	fc                   	cld    
  800b38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 04 24             	mov    %eax,(%esp)
  800b58:	e8 79 ff ff ff       	call   800ad6 <memmove>
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	57                   	push   %edi
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b71:	85 c0                	test   %eax,%eax
  800b73:	74 36                	je     800bab <memcmp+0x4c>
		if (*s1 != *s2)
  800b75:	0f b6 03             	movzbl (%ebx),%eax
  800b78:	0f b6 0e             	movzbl (%esi),%ecx
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	38 c8                	cmp    %cl,%al
  800b82:	74 1c                	je     800ba0 <memcmp+0x41>
  800b84:	eb 10                	jmp    800b96 <memcmp+0x37>
  800b86:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b8b:	83 c2 01             	add    $0x1,%edx
  800b8e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b92:	38 c8                	cmp    %cl,%al
  800b94:	74 0a                	je     800ba0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b96:	0f b6 c0             	movzbl %al,%eax
  800b99:	0f b6 c9             	movzbl %cl,%ecx
  800b9c:	29 c8                	sub    %ecx,%eax
  800b9e:	eb 10                	jmp    800bb0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba0:	39 fa                	cmp    %edi,%edx
  800ba2:	75 e2                	jne    800b86 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	eb 05                	jmp    800bb0 <memcmp+0x51>
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	53                   	push   %ebx
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	39 d0                	cmp    %edx,%eax
  800bc6:	73 13                	jae    800bdb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc8:	89 d9                	mov    %ebx,%ecx
  800bca:	38 18                	cmp    %bl,(%eax)
  800bcc:	75 06                	jne    800bd4 <memfind+0x1f>
  800bce:	eb 0b                	jmp    800bdb <memfind+0x26>
  800bd0:	38 08                	cmp    %cl,(%eax)
  800bd2:	74 07                	je     800bdb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	39 d0                	cmp    %edx,%eax
  800bd9:	75 f5                	jne    800bd0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bea:	0f b6 0a             	movzbl (%edx),%ecx
  800bed:	80 f9 09             	cmp    $0x9,%cl
  800bf0:	74 05                	je     800bf7 <strtol+0x19>
  800bf2:	80 f9 20             	cmp    $0x20,%cl
  800bf5:	75 10                	jne    800c07 <strtol+0x29>
		s++;
  800bf7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfa:	0f b6 0a             	movzbl (%edx),%ecx
  800bfd:	80 f9 09             	cmp    $0x9,%cl
  800c00:	74 f5                	je     800bf7 <strtol+0x19>
  800c02:	80 f9 20             	cmp    $0x20,%cl
  800c05:	74 f0                	je     800bf7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c07:	80 f9 2b             	cmp    $0x2b,%cl
  800c0a:	75 0a                	jne    800c16 <strtol+0x38>
		s++;
  800c0c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c14:	eb 11                	jmp    800c27 <strtol+0x49>
  800c16:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c1b:	80 f9 2d             	cmp    $0x2d,%cl
  800c1e:	75 07                	jne    800c27 <strtol+0x49>
		s++, neg = 1;
  800c20:	83 c2 01             	add    $0x1,%edx
  800c23:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c27:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c2c:	75 15                	jne    800c43 <strtol+0x65>
  800c2e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c31:	75 10                	jne    800c43 <strtol+0x65>
  800c33:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c37:	75 0a                	jne    800c43 <strtol+0x65>
		s += 2, base = 16;
  800c39:	83 c2 02             	add    $0x2,%edx
  800c3c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c41:	eb 10                	jmp    800c53 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c43:	85 c0                	test   %eax,%eax
  800c45:	75 0c                	jne    800c53 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c47:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c49:	80 3a 30             	cmpb   $0x30,(%edx)
  800c4c:	75 05                	jne    800c53 <strtol+0x75>
		s++, base = 8;
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c5b:	0f b6 0a             	movzbl (%edx),%ecx
  800c5e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c61:	89 f0                	mov    %esi,%eax
  800c63:	3c 09                	cmp    $0x9,%al
  800c65:	77 08                	ja     800c6f <strtol+0x91>
			dig = *s - '0';
  800c67:	0f be c9             	movsbl %cl,%ecx
  800c6a:	83 e9 30             	sub    $0x30,%ecx
  800c6d:	eb 20                	jmp    800c8f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c6f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c72:	89 f0                	mov    %esi,%eax
  800c74:	3c 19                	cmp    $0x19,%al
  800c76:	77 08                	ja     800c80 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c78:	0f be c9             	movsbl %cl,%ecx
  800c7b:	83 e9 57             	sub    $0x57,%ecx
  800c7e:	eb 0f                	jmp    800c8f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c80:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c83:	89 f0                	mov    %esi,%eax
  800c85:	3c 19                	cmp    $0x19,%al
  800c87:	77 16                	ja     800c9f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c89:	0f be c9             	movsbl %cl,%ecx
  800c8c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c8f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c92:	7d 0f                	jge    800ca3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c94:	83 c2 01             	add    $0x1,%edx
  800c97:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c9b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c9d:	eb bc                	jmp    800c5b <strtol+0x7d>
  800c9f:	89 d8                	mov    %ebx,%eax
  800ca1:	eb 02                	jmp    800ca5 <strtol+0xc7>
  800ca3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ca5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca9:	74 05                	je     800cb0 <strtol+0xd2>
		*endptr = (char *) s;
  800cab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cae:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cb0:	f7 d8                	neg    %eax
  800cb2:	85 ff                	test   %edi,%edi
  800cb4:	0f 44 c3             	cmove  %ebx,%eax
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	89 c3                	mov    %eax,%ebx
  800ccf:	89 c7                	mov    %eax,%edi
  800cd1:	89 c6                	mov    %eax,%esi
  800cd3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_cgetc>:

int
sys_cgetc(void)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d07:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	89 cb                	mov    %ecx,%ebx
  800d11:	89 cf                	mov    %ecx,%edi
  800d13:	89 ce                	mov    %ecx,%esi
  800d15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d17:	85 c0                	test   %eax,%eax
  800d19:	7e 28                	jle    800d43 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d26:	00 
  800d27:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d36:	00 
  800d37:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800d3e:	e8 42 f4 ff ff       	call   800185 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d43:	83 c4 2c             	add    $0x2c,%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_yield>:

void
sys_yield(void)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7a:	89 d1                	mov    %edx,%ecx
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	89 d7                	mov    %edx,%edi
  800d80:	89 d6                	mov    %edx,%esi
  800d82:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	be 00 00 00 00       	mov    $0x0,%esi
  800d97:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da5:	89 f7                	mov    %esi,%edi
  800da7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7e 28                	jle    800dd5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800db8:	00 
  800db9:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800dc0:	00 
  800dc1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dc8:	00 
  800dc9:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800dd0:	e8 b0 f3 ff ff       	call   800185 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd5:	83 c4 2c             	add    $0x2c,%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de6:	b8 05 00 00 00       	mov    $0x5,%eax
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 28                	jle    800e28 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e04:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800e13:	00 
  800e14:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e1b:	00 
  800e1c:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800e23:	e8 5d f3 ff ff       	call   800185 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e28:	83 c4 2c             	add    $0x2c,%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7e 28                	jle    800e7b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800e66:	00 
  800e67:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e6e:	00 
  800e6f:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800e76:	e8 0a f3 ff ff       	call   800185 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7b:	83 c4 2c             	add    $0x2c,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	b8 08 00 00 00       	mov    $0x8,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	89 df                	mov    %ebx,%edi
  800e9e:	89 de                	mov    %ebx,%esi
  800ea0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7e 28                	jle    800ece <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaa:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800eb9:	00 
  800eba:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ec1:	00 
  800ec2:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800ec9:	e8 b7 f2 ff ff       	call   800185 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	83 c4 2c             	add    $0x2c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
  800edc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	89 de                	mov    %ebx,%esi
  800ef3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7e 28                	jle    800f21 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f04:	00 
  800f05:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800f0c:	00 
  800f0d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f14:	00 
  800f15:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800f1c:	e8 64 f2 ff ff       	call   800185 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f21:	83 c4 2c             	add    $0x2c,%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f37:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	89 df                	mov    %ebx,%edi
  800f44:	89 de                	mov    %ebx,%esi
  800f46:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7e 28                	jle    800f74 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f50:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f57:	00 
  800f58:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800f5f:	00 
  800f60:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f67:	00 
  800f68:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800f6f:	e8 11 f2 ff ff       	call   800185 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f74:	83 c4 2c             	add    $0x2c,%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	be 00 00 00 00       	mov    $0x0,%esi
  800f87:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f98:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fad:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	89 cb                	mov    %ecx,%ebx
  800fb7:	89 cf                	mov    %ecx,%edi
  800fb9:	89 ce                	mov    %ecx,%esi
  800fbb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7e 28                	jle    800fe9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800fd4:	00 
  800fd5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fdc:	00 
  800fdd:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800fe4:	e8 9c f1 ff ff       	call   800185 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe9:	83 c4 2c             	add    $0x2c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  800ff7:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800ffe:	75 50                	jne    801050 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801000:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801007:	00 
  801008:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80100f:	ee 
  801010:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801017:	e8 6d fd ff ff       	call   800d89 <sys_page_alloc>
  80101c:	85 c0                	test   %eax,%eax
  80101e:	79 1c                	jns    80103c <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801020:	c7 44 24 08 0c 26 80 	movl   $0x80260c,0x8(%esp)
  801027:	00 
  801028:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80102f:	00 
  801030:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  801037:	e8 49 f1 ff ff       	call   800185 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80103c:	c7 44 24 04 5a 10 80 	movl   $0x80105a,0x4(%esp)
  801043:	00 
  801044:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80104b:	e8 d9 fe ff ff       	call   800f29 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	a3 08 40 80 00       	mov    %eax,0x804008
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80105a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80105b:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  801060:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801062:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801065:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801067:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  80106c:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80106f:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801074:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801077:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801079:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  80107c:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  80107e:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801080:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801085:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801088:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  80108d:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801090:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801092:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801097:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80109a:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80109f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8010a2:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8010a4:	83 c4 08             	add    $0x8,%esp
	popal
  8010a7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8010a8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010a9:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8010aa:	c3                   	ret    
  8010ab:	66 90                	xchg   %ax,%ax
  8010ad:	66 90                	xchg   %ax,%ax
  8010af:	90                   	nop

008010b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010da:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010df:	a8 01                	test   $0x1,%al
  8010e1:	74 34                	je     801117 <fd_alloc+0x40>
  8010e3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010e8:	a8 01                	test   $0x1,%al
  8010ea:	74 32                	je     80111e <fd_alloc+0x47>
  8010ec:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010f1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	c1 ea 16             	shr    $0x16,%edx
  8010f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	74 1f                	je     801123 <fd_alloc+0x4c>
  801104:	89 c2                	mov    %eax,%edx
  801106:	c1 ea 0c             	shr    $0xc,%edx
  801109:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801110:	f6 c2 01             	test   $0x1,%dl
  801113:	75 1a                	jne    80112f <fd_alloc+0x58>
  801115:	eb 0c                	jmp    801123 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801117:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80111c:	eb 05                	jmp    801123 <fd_alloc+0x4c>
  80111e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 08                	mov    %ecx,(%eax)
			return 0;
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	eb 1a                	jmp    801149 <fd_alloc+0x72>
  80112f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801134:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801139:	75 b6                	jne    8010f1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801144:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801151:	83 f8 1f             	cmp    $0x1f,%eax
  801154:	77 36                	ja     80118c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801156:	c1 e0 0c             	shl    $0xc,%eax
  801159:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115e:	89 c2                	mov    %eax,%edx
  801160:	c1 ea 16             	shr    $0x16,%edx
  801163:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116a:	f6 c2 01             	test   $0x1,%dl
  80116d:	74 24                	je     801193 <fd_lookup+0x48>
  80116f:	89 c2                	mov    %eax,%edx
  801171:	c1 ea 0c             	shr    $0xc,%edx
  801174:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117b:	f6 c2 01             	test   $0x1,%dl
  80117e:	74 1a                	je     80119a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801180:	8b 55 0c             	mov    0xc(%ebp),%edx
  801183:	89 02                	mov    %eax,(%edx)
	return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	eb 13                	jmp    80119f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb 0c                	jmp    80119f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801193:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801198:	eb 05                	jmp    80119f <fd_lookup+0x54>
  80119a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 14             	sub    $0x14,%esp
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011ae:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8011b4:	75 1e                	jne    8011d4 <dev_lookup+0x33>
  8011b6:	eb 0e                	jmp    8011c6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011b8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8011bd:	eb 0c                	jmp    8011cb <dev_lookup+0x2a>
  8011bf:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8011c4:	eb 05                	jmp    8011cb <dev_lookup+0x2a>
  8011c6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011cb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8011cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d2:	eb 38                	jmp    80120c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011d4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8011da:	74 dc                	je     8011b8 <dev_lookup+0x17>
  8011dc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8011e2:	74 db                	je     8011bf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011e4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011ea:	8b 52 48             	mov    0x48(%edx),%edx
  8011ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011f5:	c7 04 24 40 26 80 00 	movl   $0x802640,(%esp)
  8011fc:	e8 7d f0 ff ff       	call   80027e <cprintf>
	*dev = 0;
  801201:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801207:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80120c:	83 c4 14             	add    $0x14,%esp
  80120f:	5b                   	pop    %ebx
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    

00801212 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 20             	sub    $0x20,%esp
  80121a:	8b 75 08             	mov    0x8(%ebp),%esi
  80121d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801223:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801227:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80122d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801230:	89 04 24             	mov    %eax,(%esp)
  801233:	e8 13 ff ff ff       	call   80114b <fd_lookup>
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 05                	js     801241 <fd_close+0x2f>
	    || fd != fd2)
  80123c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80123f:	74 0c                	je     80124d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801241:	84 db                	test   %bl,%bl
  801243:	ba 00 00 00 00       	mov    $0x0,%edx
  801248:	0f 44 c2             	cmove  %edx,%eax
  80124b:	eb 3f                	jmp    80128c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80124d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801250:	89 44 24 04          	mov    %eax,0x4(%esp)
  801254:	8b 06                	mov    (%esi),%eax
  801256:	89 04 24             	mov    %eax,(%esp)
  801259:	e8 43 ff ff ff       	call   8011a1 <dev_lookup>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	85 c0                	test   %eax,%eax
  801262:	78 16                	js     80127a <fd_close+0x68>
		if (dev->dev_close)
  801264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801267:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80126a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80126f:	85 c0                	test   %eax,%eax
  801271:	74 07                	je     80127a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801273:	89 34 24             	mov    %esi,(%esp)
  801276:	ff d0                	call   *%eax
  801278:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80127a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801285:	e8 a6 fb ff ff       	call   800e30 <sys_page_unmap>
	return r;
  80128a:	89 d8                	mov    %ebx,%eax
}
  80128c:	83 c4 20             	add    $0x20,%esp
  80128f:	5b                   	pop    %ebx
  801290:	5e                   	pop    %esi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	89 04 24             	mov    %eax,(%esp)
  8012a6:	e8 a0 fe ff ff       	call   80114b <fd_lookup>
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	85 d2                	test   %edx,%edx
  8012af:	78 13                	js     8012c4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012b8:	00 
  8012b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bc:	89 04 24             	mov    %eax,(%esp)
  8012bf:	e8 4e ff ff ff       	call   801212 <fd_close>
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <close_all>:

void
close_all(void)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	53                   	push   %ebx
  8012ca:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012d2:	89 1c 24             	mov    %ebx,(%esp)
  8012d5:	e8 b9 ff ff ff       	call   801293 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012da:	83 c3 01             	add    $0x1,%ebx
  8012dd:	83 fb 20             	cmp    $0x20,%ebx
  8012e0:	75 f0                	jne    8012d2 <close_all+0xc>
		close(i);
}
  8012e2:	83 c4 14             	add    $0x14,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	89 04 24             	mov    %eax,(%esp)
  8012fe:	e8 48 fe ff ff       	call   80114b <fd_lookup>
  801303:	89 c2                	mov    %eax,%edx
  801305:	85 d2                	test   %edx,%edx
  801307:	0f 88 e1 00 00 00    	js     8013ee <dup+0x106>
		return r;
	close(newfdnum);
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	89 04 24             	mov    %eax,(%esp)
  801313:	e8 7b ff ff ff       	call   801293 <close>

	newfd = INDEX2FD(newfdnum);
  801318:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80131b:	c1 e3 0c             	shl    $0xc,%ebx
  80131e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801327:	89 04 24             	mov    %eax,(%esp)
  80132a:	e8 91 fd ff ff       	call   8010c0 <fd2data>
  80132f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801331:	89 1c 24             	mov    %ebx,(%esp)
  801334:	e8 87 fd ff ff       	call   8010c0 <fd2data>
  801339:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80133b:	89 f0                	mov    %esi,%eax
  80133d:	c1 e8 16             	shr    $0x16,%eax
  801340:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801347:	a8 01                	test   $0x1,%al
  801349:	74 43                	je     80138e <dup+0xa6>
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	c1 e8 0c             	shr    $0xc,%eax
  801350:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801357:	f6 c2 01             	test   $0x1,%dl
  80135a:	74 32                	je     80138e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80135c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801363:	25 07 0e 00 00       	and    $0xe07,%eax
  801368:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801370:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801377:	00 
  801378:	89 74 24 04          	mov    %esi,0x4(%esp)
  80137c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801383:	e8 55 fa ff ff       	call   800ddd <sys_page_map>
  801388:	89 c6                	mov    %eax,%esi
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 3e                	js     8013cc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80138e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801391:	89 c2                	mov    %eax,%edx
  801393:	c1 ea 0c             	shr    $0xc,%edx
  801396:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b2:	00 
  8013b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013be:	e8 1a fa ff ff       	call   800ddd <sys_page_map>
  8013c3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c8:	85 f6                	test   %esi,%esi
  8013ca:	79 22                	jns    8013ee <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d7:	e8 54 fa ff ff       	call   800e30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e7:	e8 44 fa ff ff       	call   800e30 <sys_page_unmap>
	return r;
  8013ec:	89 f0                	mov    %esi,%eax
}
  8013ee:	83 c4 3c             	add    $0x3c,%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 24             	sub    $0x24,%esp
  8013fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801400:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801403:	89 44 24 04          	mov    %eax,0x4(%esp)
  801407:	89 1c 24             	mov    %ebx,(%esp)
  80140a:	e8 3c fd ff ff       	call   80114b <fd_lookup>
  80140f:	89 c2                	mov    %eax,%edx
  801411:	85 d2                	test   %edx,%edx
  801413:	78 6d                	js     801482 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	89 04 24             	mov    %eax,(%esp)
  801424:	e8 78 fd ff ff       	call   8011a1 <dev_lookup>
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 55                	js     801482 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	8b 50 08             	mov    0x8(%eax),%edx
  801433:	83 e2 03             	and    $0x3,%edx
  801436:	83 fa 01             	cmp    $0x1,%edx
  801439:	75 23                	jne    80145e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80143b:	a1 04 40 80 00       	mov    0x804004,%eax
  801440:	8b 40 48             	mov    0x48(%eax),%eax
  801443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144b:	c7 04 24 84 26 80 00 	movl   $0x802684,(%esp)
  801452:	e8 27 ee ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  801457:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145c:	eb 24                	jmp    801482 <read+0x8c>
	}
	if (!dev->dev_read)
  80145e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801461:	8b 52 08             	mov    0x8(%edx),%edx
  801464:	85 d2                	test   %edx,%edx
  801466:	74 15                	je     80147d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801468:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80146f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801472:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801476:	89 04 24             	mov    %eax,(%esp)
  801479:	ff d2                	call   *%edx
  80147b:	eb 05                	jmp    801482 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80147d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801482:	83 c4 24             	add    $0x24,%esp
  801485:	5b                   	pop    %ebx
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    

00801488 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	57                   	push   %edi
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	83 ec 1c             	sub    $0x1c,%esp
  801491:	8b 7d 08             	mov    0x8(%ebp),%edi
  801494:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801497:	85 f6                	test   %esi,%esi
  801499:	74 33                	je     8014ce <readn+0x46>
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a5:	89 f2                	mov    %esi,%edx
  8014a7:	29 c2                	sub    %eax,%edx
  8014a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014ad:	03 45 0c             	add    0xc(%ebp),%eax
  8014b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b4:	89 3c 24             	mov    %edi,(%esp)
  8014b7:	e8 3a ff ff ff       	call   8013f6 <read>
		if (m < 0)
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 1b                	js     8014db <readn+0x53>
			return m;
		if (m == 0)
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 11                	je     8014d5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014c4:	01 c3                	add    %eax,%ebx
  8014c6:	89 d8                	mov    %ebx,%eax
  8014c8:	39 f3                	cmp    %esi,%ebx
  8014ca:	72 d9                	jb     8014a5 <readn+0x1d>
  8014cc:	eb 0b                	jmp    8014d9 <readn+0x51>
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb 06                	jmp    8014db <readn+0x53>
  8014d5:	89 d8                	mov    %ebx,%eax
  8014d7:	eb 02                	jmp    8014db <readn+0x53>
  8014d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014db:	83 c4 1c             	add    $0x1c,%esp
  8014de:	5b                   	pop    %ebx
  8014df:	5e                   	pop    %esi
  8014e0:	5f                   	pop    %edi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 24             	sub    $0x24,%esp
  8014ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f4:	89 1c 24             	mov    %ebx,(%esp)
  8014f7:	e8 4f fc ff ff       	call   80114b <fd_lookup>
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	85 d2                	test   %edx,%edx
  801500:	78 68                	js     80156a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	89 04 24             	mov    %eax,(%esp)
  801511:	e8 8b fc ff ff       	call   8011a1 <dev_lookup>
  801516:	85 c0                	test   %eax,%eax
  801518:	78 50                	js     80156a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801521:	75 23                	jne    801546 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801523:	a1 04 40 80 00       	mov    0x804004,%eax
  801528:	8b 40 48             	mov    0x48(%eax),%eax
  80152b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801533:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  80153a:	e8 3f ed ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801544:	eb 24                	jmp    80156a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	8b 52 0c             	mov    0xc(%edx),%edx
  80154c:	85 d2                	test   %edx,%edx
  80154e:	74 15                	je     801565 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801550:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801553:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80155a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80155e:	89 04 24             	mov    %eax,(%esp)
  801561:	ff d2                	call   *%edx
  801563:	eb 05                	jmp    80156a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801565:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80156a:	83 c4 24             	add    $0x24,%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <seek>:

int
seek(int fdnum, off_t offset)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801576:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 04 24             	mov    %eax,(%esp)
  801583:	e8 c3 fb ff ff       	call   80114b <fd_lookup>
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 0e                	js     80159a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80158c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	53                   	push   %ebx
  8015a0:	83 ec 24             	sub    $0x24,%esp
  8015a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ad:	89 1c 24             	mov    %ebx,(%esp)
  8015b0:	e8 96 fb ff ff       	call   80114b <fd_lookup>
  8015b5:	89 c2                	mov    %eax,%edx
  8015b7:	85 d2                	test   %edx,%edx
  8015b9:	78 61                	js     80161c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c5:	8b 00                	mov    (%eax),%eax
  8015c7:	89 04 24             	mov    %eax,(%esp)
  8015ca:	e8 d2 fb ff ff       	call   8011a1 <dev_lookup>
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 49                	js     80161c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015da:	75 23                	jne    8015ff <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015dc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e1:	8b 40 48             	mov    0x48(%eax),%eax
  8015e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ec:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  8015f3:	e8 86 ec ff ff       	call   80027e <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fd:	eb 1d                	jmp    80161c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801602:	8b 52 18             	mov    0x18(%edx),%edx
  801605:	85 d2                	test   %edx,%edx
  801607:	74 0e                	je     801617 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801610:	89 04 24             	mov    %eax,(%esp)
  801613:	ff d2                	call   *%edx
  801615:	eb 05                	jmp    80161c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801617:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80161c:	83 c4 24             	add    $0x24,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 24             	sub    $0x24,%esp
  801629:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	89 04 24             	mov    %eax,(%esp)
  801639:	e8 0d fb ff ff       	call   80114b <fd_lookup>
  80163e:	89 c2                	mov    %eax,%edx
  801640:	85 d2                	test   %edx,%edx
  801642:	78 52                	js     801696 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801644:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	8b 00                	mov    (%eax),%eax
  801650:	89 04 24             	mov    %eax,(%esp)
  801653:	e8 49 fb ff ff       	call   8011a1 <dev_lookup>
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 3a                	js     801696 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801663:	74 2c                	je     801691 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801665:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801668:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80166f:	00 00 00 
	stat->st_isdir = 0;
  801672:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801679:	00 00 00 
	stat->st_dev = dev;
  80167c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801682:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801689:	89 14 24             	mov    %edx,(%esp)
  80168c:	ff 50 14             	call   *0x14(%eax)
  80168f:	eb 05                	jmp    801696 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801691:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801696:	83 c4 24             	add    $0x24,%esp
  801699:	5b                   	pop    %ebx
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016ab:	00 
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 04 24             	mov    %eax,(%esp)
  8016b2:	e8 af 01 00 00       	call   801866 <open>
  8016b7:	89 c3                	mov    %eax,%ebx
  8016b9:	85 db                	test   %ebx,%ebx
  8016bb:	78 1b                	js     8016d8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	89 1c 24             	mov    %ebx,(%esp)
  8016c7:	e8 56 ff ff ff       	call   801622 <fstat>
  8016cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ce:	89 1c 24             	mov    %ebx,(%esp)
  8016d1:	e8 bd fb ff ff       	call   801293 <close>
	return r;
  8016d6:	89 f0                	mov    %esi,%eax
}
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 10             	sub    $0x10,%esp
  8016e7:	89 c6                	mov    %eax,%esi
  8016e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016eb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f2:	75 11                	jne    801705 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016fb:	e8 24 08 00 00       	call   801f24 <ipc_find_env>
  801700:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801705:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80170c:	00 
  80170d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801714:	00 
  801715:	89 74 24 04          	mov    %esi,0x4(%esp)
  801719:	a1 00 40 80 00       	mov    0x804000,%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 98 07 00 00       	call   801ebe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801726:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172d:	00 
  80172e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801739:	e8 18 07 00 00       	call   801e56 <ipc_recv>
}
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 14             	sub    $0x14,%esp
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 05 00 00 00       	mov    $0x5,%eax
  801764:	e8 76 ff ff ff       	call   8016df <fsipc>
  801769:	89 c2                	mov    %eax,%edx
  80176b:	85 d2                	test   %edx,%edx
  80176d:	78 2b                	js     80179a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801776:	00 
  801777:	89 1c 24             	mov    %ebx,(%esp)
  80177a:	e8 5c f1 ff ff       	call   8008db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80177f:	a1 80 50 80 00       	mov    0x805080,%eax
  801784:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80178a:	a1 84 50 80 00       	mov    0x805084,%eax
  80178f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	83 c4 14             	add    $0x14,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8017bb:	e8 1f ff ff ff       	call   8016df <fsipc>
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 10             	sub    $0x10,%esp
  8017ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017d8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017e8:	e8 f2 fe ff ff       	call   8016df <fsipc>
  8017ed:	89 c3                	mov    %eax,%ebx
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 6a                	js     80185d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017f3:	39 c6                	cmp    %eax,%esi
  8017f5:	73 24                	jae    80181b <devfile_read+0x59>
  8017f7:	c7 44 24 0c bd 26 80 	movl   $0x8026bd,0xc(%esp)
  8017fe:	00 
  8017ff:	c7 44 24 08 c4 26 80 	movl   $0x8026c4,0x8(%esp)
  801806:	00 
  801807:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80180e:	00 
  80180f:	c7 04 24 d9 26 80 00 	movl   $0x8026d9,(%esp)
  801816:	e8 6a e9 ff ff       	call   800185 <_panic>
	assert(r <= PGSIZE);
  80181b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801820:	7e 24                	jle    801846 <devfile_read+0x84>
  801822:	c7 44 24 0c e4 26 80 	movl   $0x8026e4,0xc(%esp)
  801829:	00 
  80182a:	c7 44 24 08 c4 26 80 	movl   $0x8026c4,0x8(%esp)
  801831:	00 
  801832:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801839:	00 
  80183a:	c7 04 24 d9 26 80 00 	movl   $0x8026d9,(%esp)
  801841:	e8 3f e9 ff ff       	call   800185 <_panic>
	memmove(buf, &fsipcbuf, r);
  801846:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801851:	00 
  801852:	8b 45 0c             	mov    0xc(%ebp),%eax
  801855:	89 04 24             	mov    %eax,(%esp)
  801858:	e8 79 f2 ff ff       	call   800ad6 <memmove>
	return r;
}
  80185d:	89 d8                	mov    %ebx,%eax
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	5b                   	pop    %ebx
  801863:	5e                   	pop    %esi
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 24             	sub    $0x24,%esp
  80186d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801870:	89 1c 24             	mov    %ebx,(%esp)
  801873:	e8 08 f0 ff ff       	call   800880 <strlen>
  801878:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80187d:	7f 60                	jg     8018df <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80187f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801882:	89 04 24             	mov    %eax,(%esp)
  801885:	e8 4d f8 ff ff       	call   8010d7 <fd_alloc>
  80188a:	89 c2                	mov    %eax,%edx
  80188c:	85 d2                	test   %edx,%edx
  80188e:	78 54                	js     8018e4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801890:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801894:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80189b:	e8 3b f0 ff ff       	call   8008db <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b0:	e8 2a fe ff ff       	call   8016df <fsipc>
  8018b5:	89 c3                	mov    %eax,%ebx
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	79 17                	jns    8018d2 <open+0x6c>
		fd_close(fd, 0);
  8018bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018c2:	00 
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	89 04 24             	mov    %eax,(%esp)
  8018c9:	e8 44 f9 ff ff       	call   801212 <fd_close>
		return r;
  8018ce:	89 d8                	mov    %ebx,%eax
  8018d0:	eb 12                	jmp    8018e4 <open+0x7e>
	}
	return fd2num(fd);
  8018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 d3 f7 ff ff       	call   8010b0 <fd2num>
  8018dd:	eb 05                	jmp    8018e4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018df:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8018e4:	83 c4 24             	add    $0x24,%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    
  8018ea:	66 90                	xchg   %ax,%ax
  8018ec:	66 90                	xchg   %ax,%ax
  8018ee:	66 90                	xchg   %ax,%ax

008018f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 10             	sub    $0x10,%esp
  8018f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 04 24             	mov    %eax,(%esp)
  801901:	e8 ba f7 ff ff       	call   8010c0 <fd2data>
  801906:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801908:	c7 44 24 04 f0 26 80 	movl   $0x8026f0,0x4(%esp)
  80190f:	00 
  801910:	89 1c 24             	mov    %ebx,(%esp)
  801913:	e8 c3 ef ff ff       	call   8008db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801918:	8b 46 04             	mov    0x4(%esi),%eax
  80191b:	2b 06                	sub    (%esi),%eax
  80191d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801923:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192a:	00 00 00 
	stat->st_dev = &devpipe;
  80192d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801934:	30 80 00 
	return 0;
}
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	53                   	push   %ebx
  801947:	83 ec 14             	sub    $0x14,%esp
  80194a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80194d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801951:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801958:	e8 d3 f4 ff ff       	call   800e30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80195d:	89 1c 24             	mov    %ebx,(%esp)
  801960:	e8 5b f7 ff ff       	call   8010c0 <fd2data>
  801965:	89 44 24 04          	mov    %eax,0x4(%esp)
  801969:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801970:	e8 bb f4 ff ff       	call   800e30 <sys_page_unmap>
}
  801975:	83 c4 14             	add    $0x14,%esp
  801978:	5b                   	pop    %ebx
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    

0080197b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	57                   	push   %edi
  80197f:	56                   	push   %esi
  801980:	53                   	push   %ebx
  801981:	83 ec 2c             	sub    $0x2c,%esp
  801984:	89 c6                	mov    %eax,%esi
  801986:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801989:	a1 04 40 80 00       	mov    0x804004,%eax
  80198e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801991:	89 34 24             	mov    %esi,(%esp)
  801994:	e8 d3 05 00 00       	call   801f6c <pageref>
  801999:	89 c7                	mov    %eax,%edi
  80199b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80199e:	89 04 24             	mov    %eax,(%esp)
  8019a1:	e8 c6 05 00 00       	call   801f6c <pageref>
  8019a6:	39 c7                	cmp    %eax,%edi
  8019a8:	0f 94 c2             	sete   %dl
  8019ab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8019ae:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  8019b4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8019b7:	39 fb                	cmp    %edi,%ebx
  8019b9:	74 21                	je     8019dc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8019bb:	84 d2                	test   %dl,%dl
  8019bd:	74 ca                	je     801989 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019bf:	8b 51 58             	mov    0x58(%ecx),%edx
  8019c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ce:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
  8019d5:	e8 a4 e8 ff ff       	call   80027e <cprintf>
  8019da:	eb ad                	jmp    801989 <_pipeisclosed+0xe>
	}
}
  8019dc:	83 c4 2c             	add    $0x2c,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	57                   	push   %edi
  8019e8:	56                   	push   %esi
  8019e9:	53                   	push   %ebx
  8019ea:	83 ec 1c             	sub    $0x1c,%esp
  8019ed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019f0:	89 34 24             	mov    %esi,(%esp)
  8019f3:	e8 c8 f6 ff ff       	call   8010c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019fc:	74 61                	je     801a5f <devpipe_write+0x7b>
  8019fe:	89 c3                	mov    %eax,%ebx
  801a00:	bf 00 00 00 00       	mov    $0x0,%edi
  801a05:	eb 4a                	jmp    801a51 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a07:	89 da                	mov    %ebx,%edx
  801a09:	89 f0                	mov    %esi,%eax
  801a0b:	e8 6b ff ff ff       	call   80197b <_pipeisclosed>
  801a10:	85 c0                	test   %eax,%eax
  801a12:	75 54                	jne    801a68 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a14:	e8 51 f3 ff ff       	call   800d6a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a19:	8b 43 04             	mov    0x4(%ebx),%eax
  801a1c:	8b 0b                	mov    (%ebx),%ecx
  801a1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801a21:	39 d0                	cmp    %edx,%eax
  801a23:	73 e2                	jae    801a07 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a28:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a2c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a2f:	99                   	cltd   
  801a30:	c1 ea 1b             	shr    $0x1b,%edx
  801a33:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a36:	83 e1 1f             	and    $0x1f,%ecx
  801a39:	29 d1                	sub    %edx,%ecx
  801a3b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a3f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a43:	83 c0 01             	add    $0x1,%eax
  801a46:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a49:	83 c7 01             	add    $0x1,%edi
  801a4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a4f:	74 13                	je     801a64 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a51:	8b 43 04             	mov    0x4(%ebx),%eax
  801a54:	8b 0b                	mov    (%ebx),%ecx
  801a56:	8d 51 20             	lea    0x20(%ecx),%edx
  801a59:	39 d0                	cmp    %edx,%eax
  801a5b:	73 aa                	jae    801a07 <devpipe_write+0x23>
  801a5d:	eb c6                	jmp    801a25 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a5f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a64:	89 f8                	mov    %edi,%eax
  801a66:	eb 05                	jmp    801a6d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a68:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a6d:	83 c4 1c             	add    $0x1c,%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    

00801a75 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	57                   	push   %edi
  801a79:	56                   	push   %esi
  801a7a:	53                   	push   %ebx
  801a7b:	83 ec 1c             	sub    $0x1c,%esp
  801a7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a81:	89 3c 24             	mov    %edi,(%esp)
  801a84:	e8 37 f6 ff ff       	call   8010c0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a8d:	74 54                	je     801ae3 <devpipe_read+0x6e>
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	be 00 00 00 00       	mov    $0x0,%esi
  801a96:	eb 3e                	jmp    801ad6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a98:	89 f0                	mov    %esi,%eax
  801a9a:	eb 55                	jmp    801af1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a9c:	89 da                	mov    %ebx,%edx
  801a9e:	89 f8                	mov    %edi,%eax
  801aa0:	e8 d6 fe ff ff       	call   80197b <_pipeisclosed>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	75 43                	jne    801aec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801aa9:	e8 bc f2 ff ff       	call   800d6a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801aae:	8b 03                	mov    (%ebx),%eax
  801ab0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ab3:	74 e7                	je     801a9c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ab5:	99                   	cltd   
  801ab6:	c1 ea 1b             	shr    $0x1b,%edx
  801ab9:	01 d0                	add    %edx,%eax
  801abb:	83 e0 1f             	and    $0x1f,%eax
  801abe:	29 d0                	sub    %edx,%eax
  801ac0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801acb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ace:	83 c6 01             	add    $0x1,%esi
  801ad1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ad4:	74 12                	je     801ae8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ad6:	8b 03                	mov    (%ebx),%eax
  801ad8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801adb:	75 d8                	jne    801ab5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801add:	85 f6                	test   %esi,%esi
  801adf:	75 b7                	jne    801a98 <devpipe_read+0x23>
  801ae1:	eb b9                	jmp    801a9c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ae3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ae8:	89 f0                	mov    %esi,%eax
  801aea:	eb 05                	jmp    801af1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801af1:	83 c4 1c             	add    $0x1c,%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5f                   	pop    %edi
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    

00801af9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
  801afe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b04:	89 04 24             	mov    %eax,(%esp)
  801b07:	e8 cb f5 ff ff       	call   8010d7 <fd_alloc>
  801b0c:	89 c2                	mov    %eax,%edx
  801b0e:	85 d2                	test   %edx,%edx
  801b10:	0f 88 4d 01 00 00    	js     801c63 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b1d:	00 
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2c:	e8 58 f2 ff ff       	call   800d89 <sys_page_alloc>
  801b31:	89 c2                	mov    %eax,%edx
  801b33:	85 d2                	test   %edx,%edx
  801b35:	0f 88 28 01 00 00    	js     801c63 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3e:	89 04 24             	mov    %eax,(%esp)
  801b41:	e8 91 f5 ff ff       	call   8010d7 <fd_alloc>
  801b46:	89 c3                	mov    %eax,%ebx
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	0f 88 fe 00 00 00    	js     801c4e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b50:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b57:	00 
  801b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b66:	e8 1e f2 ff ff       	call   800d89 <sys_page_alloc>
  801b6b:	89 c3                	mov    %eax,%ebx
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	0f 88 d9 00 00 00    	js     801c4e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	89 04 24             	mov    %eax,(%esp)
  801b7b:	e8 40 f5 ff ff       	call   8010c0 <fd2data>
  801b80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b89:	00 
  801b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b95:	e8 ef f1 ff ff       	call   800d89 <sys_page_alloc>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	0f 88 97 00 00 00    	js     801c3b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba7:	89 04 24             	mov    %eax,(%esp)
  801baa:	e8 11 f5 ff ff       	call   8010c0 <fd2data>
  801baf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801bb6:	00 
  801bb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bc2:	00 
  801bc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bce:	e8 0a f2 ff ff       	call   800ddd <sys_page_map>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 52                	js     801c2b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801bd9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801bee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 a2 f4 ff ff       	call   8010b0 <fd2num>
  801c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c11:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	89 04 24             	mov    %eax,(%esp)
  801c19:	e8 92 f4 ff ff       	call   8010b0 <fd2num>
  801c1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c21:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	eb 38                	jmp    801c63 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801c2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c36:	e8 f5 f1 ff ff       	call   800e30 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c49:	e8 e2 f1 ff ff       	call   800e30 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5c:	e8 cf f1 ff ff       	call   800e30 <sys_page_unmap>
  801c61:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801c63:	83 c4 30             	add    $0x30,%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	89 04 24             	mov    %eax,(%esp)
  801c7d:	e8 c9 f4 ff ff       	call   80114b <fd_lookup>
  801c82:	89 c2                	mov    %eax,%edx
  801c84:	85 d2                	test   %edx,%edx
  801c86:	78 15                	js     801c9d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	89 04 24             	mov    %eax,(%esp)
  801c8e:	e8 2d f4 ff ff       	call   8010c0 <fd2data>
	return _pipeisclosed(fd, p);
  801c93:	89 c2                	mov    %eax,%edx
  801c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c98:	e8 de fc ff ff       	call   80197b <_pipeisclosed>
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    
  801c9f:	90                   	nop

00801ca0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801cb0:	c7 44 24 04 0f 27 80 	movl   $0x80270f,0x4(%esp)
  801cb7:	00 
  801cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbb:	89 04 24             	mov    %eax,(%esp)
  801cbe:	e8 18 ec ff ff       	call   8008db <strcpy>
	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cda:	74 4a                	je     801d26 <devcons_write+0x5c>
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ce6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cec:	8b 75 10             	mov    0x10(%ebp),%esi
  801cef:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801cf1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cf4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801cf9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cfc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d00:	03 45 0c             	add    0xc(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	89 3c 24             	mov    %edi,(%esp)
  801d0a:	e8 c7 ed ff ff       	call   800ad6 <memmove>
		sys_cputs(buf, m);
  801d0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d13:	89 3c 24             	mov    %edi,(%esp)
  801d16:	e8 a1 ef ff ff       	call   800cbc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d1b:	01 f3                	add    %esi,%ebx
  801d1d:	89 d8                	mov    %ebx,%eax
  801d1f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d22:	72 c8                	jb     801cec <devcons_write+0x22>
  801d24:	eb 05                	jmp    801d2b <devcons_write+0x61>
  801d26:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d2b:	89 d8                	mov    %ebx,%eax
  801d2d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    

00801d38 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d47:	75 07                	jne    801d50 <devcons_read+0x18>
  801d49:	eb 28                	jmp    801d73 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d4b:	e8 1a f0 ff ff       	call   800d6a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d50:	e8 85 ef ff ff       	call   800cda <sys_cgetc>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	74 f2                	je     801d4b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 16                	js     801d73 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d5d:	83 f8 04             	cmp    $0x4,%eax
  801d60:	74 0c                	je     801d6e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d65:	88 02                	mov    %al,(%edx)
	return 1;
  801d67:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6c:	eb 05                	jmp    801d73 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d88:	00 
  801d89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 28 ef ff ff       	call   800cbc <sys_cputs>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <getchar>:

int
getchar(void)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801da3:	00 
  801da4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db2:	e8 3f f6 ff ff       	call   8013f6 <read>
	if (r < 0)
  801db7:	85 c0                	test   %eax,%eax
  801db9:	78 0f                	js     801dca <getchar+0x34>
		return r;
	if (r < 1)
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	7e 06                	jle    801dc5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801dbf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801dc3:	eb 05                	jmp    801dca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801dc5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	89 04 24             	mov    %eax,(%esp)
  801ddf:	e8 67 f3 ff ff       	call   80114b <fd_lookup>
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 11                	js     801df9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801df1:	39 10                	cmp    %edx,(%eax)
  801df3:	0f 94 c0             	sete   %al
  801df6:	0f b6 c0             	movzbl %al,%eax
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <opencons>:

int
opencons(void)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e04:	89 04 24             	mov    %eax,(%esp)
  801e07:	e8 cb f2 ff ff       	call   8010d7 <fd_alloc>
		return r;
  801e0c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 40                	js     801e52 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e19:	00 
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e28:	e8 5c ef ff ff       	call   800d89 <sys_page_alloc>
		return r;
  801e2d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 1f                	js     801e52 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e33:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e48:	89 04 24             	mov    %eax,(%esp)
  801e4b:	e8 60 f2 ff ff       	call   8010b0 <fd2num>
  801e50:	89 c2                	mov    %eax,%edx
}
  801e52:	89 d0                	mov    %edx,%eax
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	83 ec 10             	sub    $0x10,%esp
  801e5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801e67:	85 c0                	test   %eax,%eax
  801e69:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e6e:	0f 44 c2             	cmove  %edx,%eax
  801e71:	89 04 24             	mov    %eax,(%esp)
  801e74:	e8 26 f1 ff ff       	call   800f9f <sys_ipc_recv>
	if (err_code < 0) {
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	79 16                	jns    801e93 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801e7d:	85 f6                	test   %esi,%esi
  801e7f:	74 06                	je     801e87 <ipc_recv+0x31>
  801e81:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e87:	85 db                	test   %ebx,%ebx
  801e89:	74 2c                	je     801eb7 <ipc_recv+0x61>
  801e8b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e91:	eb 24                	jmp    801eb7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e93:	85 f6                	test   %esi,%esi
  801e95:	74 0a                	je     801ea1 <ipc_recv+0x4b>
  801e97:	a1 04 40 80 00       	mov    0x804004,%eax
  801e9c:	8b 40 74             	mov    0x74(%eax),%eax
  801e9f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801ea1:	85 db                	test   %ebx,%ebx
  801ea3:	74 0a                	je     801eaf <ipc_recv+0x59>
  801ea5:	a1 04 40 80 00       	mov    0x804004,%eax
  801eaa:	8b 40 78             	mov    0x78(%eax),%eax
  801ead:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801eaf:	a1 04 40 80 00       	mov    0x804004,%eax
  801eb4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5e                   	pop    %esi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 1c             	sub    $0x1c,%esp
  801ec7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801eca:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ed0:	eb 25                	jmp    801ef7 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801ed2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ed5:	74 20                	je     801ef7 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801ed7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801edb:	c7 44 24 08 1b 27 80 	movl   $0x80271b,0x8(%esp)
  801ee2:	00 
  801ee3:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801eea:	00 
  801eeb:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  801ef2:	e8 8e e2 ff ff       	call   800185 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ef7:	85 db                	test   %ebx,%ebx
  801ef9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801efe:	0f 45 c3             	cmovne %ebx,%eax
  801f01:	8b 55 14             	mov    0x14(%ebp),%edx
  801f04:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f10:	89 3c 24             	mov    %edi,(%esp)
  801f13:	e8 64 f0 ff ff       	call   800f7c <sys_ipc_try_send>
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 b6                	jne    801ed2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f2a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f2f:	39 c8                	cmp    %ecx,%eax
  801f31:	74 17                	je     801f4a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f33:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f38:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f3b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f41:	8b 52 50             	mov    0x50(%edx),%edx
  801f44:	39 ca                	cmp    %ecx,%edx
  801f46:	75 14                	jne    801f5c <ipc_find_env+0x38>
  801f48:	eb 05                	jmp    801f4f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f4f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f52:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f57:	8b 40 40             	mov    0x40(%eax),%eax
  801f5a:	eb 0e                	jmp    801f6a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f5c:	83 c0 01             	add    $0x1,%eax
  801f5f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f64:	75 d2                	jne    801f38 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f66:	66 b8 00 00          	mov    $0x0,%ax
}
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    

00801f6c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f72:	89 d0                	mov    %edx,%eax
  801f74:	c1 e8 16             	shr    $0x16,%eax
  801f77:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f83:	f6 c1 01             	test   $0x1,%cl
  801f86:	74 1d                	je     801fa5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f88:	c1 ea 0c             	shr    $0xc,%edx
  801f8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f92:	f6 c2 01             	test   $0x1,%dl
  801f95:	74 0e                	je     801fa5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f97:	c1 ea 0c             	shr    $0xc,%edx
  801f9a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fa1:	ef 
  801fa2:	0f b7 c0             	movzwl %ax,%eax
}
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    
  801fa7:	66 90                	xchg   %ax,%ax
  801fa9:	66 90                	xchg   %ax,%ax
  801fab:	66 90                	xchg   %ax,%ax
  801fad:	66 90                	xchg   %ax,%ax
  801faf:	90                   	nop

00801fb0 <__udivdi3>:
  801fb0:	55                   	push   %ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801fba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801fbe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801fc2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fcc:	89 ea                	mov    %ebp,%edx
  801fce:	89 0c 24             	mov    %ecx,(%esp)
  801fd1:	75 2d                	jne    802000 <__udivdi3+0x50>
  801fd3:	39 e9                	cmp    %ebp,%ecx
  801fd5:	77 61                	ja     802038 <__udivdi3+0x88>
  801fd7:	85 c9                	test   %ecx,%ecx
  801fd9:	89 ce                	mov    %ecx,%esi
  801fdb:	75 0b                	jne    801fe8 <__udivdi3+0x38>
  801fdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe2:	31 d2                	xor    %edx,%edx
  801fe4:	f7 f1                	div    %ecx
  801fe6:	89 c6                	mov    %eax,%esi
  801fe8:	31 d2                	xor    %edx,%edx
  801fea:	89 e8                	mov    %ebp,%eax
  801fec:	f7 f6                	div    %esi
  801fee:	89 c5                	mov    %eax,%ebp
  801ff0:	89 f8                	mov    %edi,%eax
  801ff2:	f7 f6                	div    %esi
  801ff4:	89 ea                	mov    %ebp,%edx
  801ff6:	83 c4 0c             	add    $0xc,%esp
  801ff9:	5e                   	pop    %esi
  801ffa:	5f                   	pop    %edi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    
  801ffd:	8d 76 00             	lea    0x0(%esi),%esi
  802000:	39 e8                	cmp    %ebp,%eax
  802002:	77 24                	ja     802028 <__udivdi3+0x78>
  802004:	0f bd e8             	bsr    %eax,%ebp
  802007:	83 f5 1f             	xor    $0x1f,%ebp
  80200a:	75 3c                	jne    802048 <__udivdi3+0x98>
  80200c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802010:	39 34 24             	cmp    %esi,(%esp)
  802013:	0f 86 9f 00 00 00    	jbe    8020b8 <__udivdi3+0x108>
  802019:	39 d0                	cmp    %edx,%eax
  80201b:	0f 82 97 00 00 00    	jb     8020b8 <__udivdi3+0x108>
  802021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802028:	31 d2                	xor    %edx,%edx
  80202a:	31 c0                	xor    %eax,%eax
  80202c:	83 c4 0c             	add    $0xc,%esp
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    
  802033:	90                   	nop
  802034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802038:	89 f8                	mov    %edi,%eax
  80203a:	f7 f1                	div    %ecx
  80203c:	31 d2                	xor    %edx,%edx
  80203e:	83 c4 0c             	add    $0xc,%esp
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    
  802045:	8d 76 00             	lea    0x0(%esi),%esi
  802048:	89 e9                	mov    %ebp,%ecx
  80204a:	8b 3c 24             	mov    (%esp),%edi
  80204d:	d3 e0                	shl    %cl,%eax
  80204f:	89 c6                	mov    %eax,%esi
  802051:	b8 20 00 00 00       	mov    $0x20,%eax
  802056:	29 e8                	sub    %ebp,%eax
  802058:	89 c1                	mov    %eax,%ecx
  80205a:	d3 ef                	shr    %cl,%edi
  80205c:	89 e9                	mov    %ebp,%ecx
  80205e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802062:	8b 3c 24             	mov    (%esp),%edi
  802065:	09 74 24 08          	or     %esi,0x8(%esp)
  802069:	89 d6                	mov    %edx,%esi
  80206b:	d3 e7                	shl    %cl,%edi
  80206d:	89 c1                	mov    %eax,%ecx
  80206f:	89 3c 24             	mov    %edi,(%esp)
  802072:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802076:	d3 ee                	shr    %cl,%esi
  802078:	89 e9                	mov    %ebp,%ecx
  80207a:	d3 e2                	shl    %cl,%edx
  80207c:	89 c1                	mov    %eax,%ecx
  80207e:	d3 ef                	shr    %cl,%edi
  802080:	09 d7                	or     %edx,%edi
  802082:	89 f2                	mov    %esi,%edx
  802084:	89 f8                	mov    %edi,%eax
  802086:	f7 74 24 08          	divl   0x8(%esp)
  80208a:	89 d6                	mov    %edx,%esi
  80208c:	89 c7                	mov    %eax,%edi
  80208e:	f7 24 24             	mull   (%esp)
  802091:	39 d6                	cmp    %edx,%esi
  802093:	89 14 24             	mov    %edx,(%esp)
  802096:	72 30                	jb     8020c8 <__udivdi3+0x118>
  802098:	8b 54 24 04          	mov    0x4(%esp),%edx
  80209c:	89 e9                	mov    %ebp,%ecx
  80209e:	d3 e2                	shl    %cl,%edx
  8020a0:	39 c2                	cmp    %eax,%edx
  8020a2:	73 05                	jae    8020a9 <__udivdi3+0xf9>
  8020a4:	3b 34 24             	cmp    (%esp),%esi
  8020a7:	74 1f                	je     8020c8 <__udivdi3+0x118>
  8020a9:	89 f8                	mov    %edi,%eax
  8020ab:	31 d2                	xor    %edx,%edx
  8020ad:	e9 7a ff ff ff       	jmp    80202c <__udivdi3+0x7c>
  8020b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020b8:	31 d2                	xor    %edx,%edx
  8020ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bf:	e9 68 ff ff ff       	jmp    80202c <__udivdi3+0x7c>
  8020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	83 c4 0c             	add    $0xc,%esp
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	66 90                	xchg   %ax,%ax
  8020d6:	66 90                	xchg   %ax,%ax
  8020d8:	66 90                	xchg   %ax,%ax
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <__umoddi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	83 ec 14             	sub    $0x14,%esp
  8020e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8020ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8020ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8020f2:	89 c7                	mov    %eax,%edi
  8020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8020fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802100:	89 34 24             	mov    %esi,(%esp)
  802103:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802107:	85 c0                	test   %eax,%eax
  802109:	89 c2                	mov    %eax,%edx
  80210b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80210f:	75 17                	jne    802128 <__umoddi3+0x48>
  802111:	39 fe                	cmp    %edi,%esi
  802113:	76 4b                	jbe    802160 <__umoddi3+0x80>
  802115:	89 c8                	mov    %ecx,%eax
  802117:	89 fa                	mov    %edi,%edx
  802119:	f7 f6                	div    %esi
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	31 d2                	xor    %edx,%edx
  80211f:	83 c4 14             	add    $0x14,%esp
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    
  802126:	66 90                	xchg   %ax,%ax
  802128:	39 f8                	cmp    %edi,%eax
  80212a:	77 54                	ja     802180 <__umoddi3+0xa0>
  80212c:	0f bd e8             	bsr    %eax,%ebp
  80212f:	83 f5 1f             	xor    $0x1f,%ebp
  802132:	75 5c                	jne    802190 <__umoddi3+0xb0>
  802134:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802138:	39 3c 24             	cmp    %edi,(%esp)
  80213b:	0f 87 e7 00 00 00    	ja     802228 <__umoddi3+0x148>
  802141:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802145:	29 f1                	sub    %esi,%ecx
  802147:	19 c7                	sbb    %eax,%edi
  802149:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80214d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802151:	8b 44 24 08          	mov    0x8(%esp),%eax
  802155:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802159:	83 c4 14             	add    $0x14,%esp
  80215c:	5e                   	pop    %esi
  80215d:	5f                   	pop    %edi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    
  802160:	85 f6                	test   %esi,%esi
  802162:	89 f5                	mov    %esi,%ebp
  802164:	75 0b                	jne    802171 <__umoddi3+0x91>
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f6                	div    %esi
  80216f:	89 c5                	mov    %eax,%ebp
  802171:	8b 44 24 04          	mov    0x4(%esp),%eax
  802175:	31 d2                	xor    %edx,%edx
  802177:	f7 f5                	div    %ebp
  802179:	89 c8                	mov    %ecx,%eax
  80217b:	f7 f5                	div    %ebp
  80217d:	eb 9c                	jmp    80211b <__umoddi3+0x3b>
  80217f:	90                   	nop
  802180:	89 c8                	mov    %ecx,%eax
  802182:	89 fa                	mov    %edi,%edx
  802184:	83 c4 14             	add    $0x14,%esp
  802187:	5e                   	pop    %esi
  802188:	5f                   	pop    %edi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    
  80218b:	90                   	nop
  80218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802190:	8b 04 24             	mov    (%esp),%eax
  802193:	be 20 00 00 00       	mov    $0x20,%esi
  802198:	89 e9                	mov    %ebp,%ecx
  80219a:	29 ee                	sub    %ebp,%esi
  80219c:	d3 e2                	shl    %cl,%edx
  80219e:	89 f1                	mov    %esi,%ecx
  8021a0:	d3 e8                	shr    %cl,%eax
  8021a2:	89 e9                	mov    %ebp,%ecx
  8021a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a8:	8b 04 24             	mov    (%esp),%eax
  8021ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8021af:	89 fa                	mov    %edi,%edx
  8021b1:	d3 e0                	shl    %cl,%eax
  8021b3:	89 f1                	mov    %esi,%ecx
  8021b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8021bd:	d3 ea                	shr    %cl,%edx
  8021bf:	89 e9                	mov    %ebp,%ecx
  8021c1:	d3 e7                	shl    %cl,%edi
  8021c3:	89 f1                	mov    %esi,%ecx
  8021c5:	d3 e8                	shr    %cl,%eax
  8021c7:	89 e9                	mov    %ebp,%ecx
  8021c9:	09 f8                	or     %edi,%eax
  8021cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8021cf:	f7 74 24 04          	divl   0x4(%esp)
  8021d3:	d3 e7                	shl    %cl,%edi
  8021d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021d9:	89 d7                	mov    %edx,%edi
  8021db:	f7 64 24 08          	mull   0x8(%esp)
  8021df:	39 d7                	cmp    %edx,%edi
  8021e1:	89 c1                	mov    %eax,%ecx
  8021e3:	89 14 24             	mov    %edx,(%esp)
  8021e6:	72 2c                	jb     802214 <__umoddi3+0x134>
  8021e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8021ec:	72 22                	jb     802210 <__umoddi3+0x130>
  8021ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8021f2:	29 c8                	sub    %ecx,%eax
  8021f4:	19 d7                	sbb    %edx,%edi
  8021f6:	89 e9                	mov    %ebp,%ecx
  8021f8:	89 fa                	mov    %edi,%edx
  8021fa:	d3 e8                	shr    %cl,%eax
  8021fc:	89 f1                	mov    %esi,%ecx
  8021fe:	d3 e2                	shl    %cl,%edx
  802200:	89 e9                	mov    %ebp,%ecx
  802202:	d3 ef                	shr    %cl,%edi
  802204:	09 d0                	or     %edx,%eax
  802206:	89 fa                	mov    %edi,%edx
  802208:	83 c4 14             	add    $0x14,%esp
  80220b:	5e                   	pop    %esi
  80220c:	5f                   	pop    %edi
  80220d:	5d                   	pop    %ebp
  80220e:	c3                   	ret    
  80220f:	90                   	nop
  802210:	39 d7                	cmp    %edx,%edi
  802212:	75 da                	jne    8021ee <__umoddi3+0x10e>
  802214:	8b 14 24             	mov    (%esp),%edx
  802217:	89 c1                	mov    %eax,%ecx
  802219:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80221d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802221:	eb cb                	jmp    8021ee <__umoddi3+0x10e>
  802223:	90                   	nop
  802224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802228:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80222c:	0f 82 0f ff ff ff    	jb     802141 <__umoddi3+0x61>
  802232:	e9 1a ff ff ff       	jmp    802151 <__umoddi3+0x71>
