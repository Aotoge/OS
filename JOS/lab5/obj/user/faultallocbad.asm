
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
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
  80004a:	e8 1b 02 00 00       	call   80026a <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 0b 0d 00 00       	call   800d79 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 60 22 80 	movl   $0x802260,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 4a 22 80 00 	movl   $0x80224a,(%esp)
  800091:	e8 db 00 00 00       	call   800171 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 8c 22 80 	movl   $0x80228c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 8e 07 00 00       	call   800840 <snprintf>
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
  8000c5:	e8 17 0f 00 00       	call   800fe1 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ca:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000d9:	e8 ce 0b 00 00       	call   800cac <sys_cputs>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000ee:	e8 48 0c 00 00       	call   800d3b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000f3:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000f9:	39 c2                	cmp    %eax,%edx
  8000fb:	74 17                	je     800114 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000fd:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800102:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800105:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80010b:	8b 49 40             	mov    0x40(%ecx),%ecx
  80010e:	39 c1                	cmp    %eax,%ecx
  800110:	75 18                	jne    80012a <libmain+0x4a>
  800112:	eb 05                	jmp    800119 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800119:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80011c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800122:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800128:	eb 0b                	jmp    800135 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80012a:	83 c2 01             	add    $0x1,%edx
  80012d:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800133:	75 cd                	jne    800102 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800135:	85 db                	test   %ebx,%ebx
  800137:	7e 07                	jle    800140 <libmain+0x60>
		binaryname = argv[0];
  800139:	8b 06                	mov    (%esi),%eax
  80013b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800140:	89 74 24 04          	mov    %esi,0x4(%esp)
  800144:	89 1c 24             	mov    %ebx,(%esp)
  800147:	e8 6c ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  80014c:	e8 07 00 00 00       	call   800158 <exit>
}
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015e:	e8 53 11 00 00       	call   8012b6 <close_all>
	sys_env_destroy(0);
  800163:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016a:	e8 7a 0b 00 00       	call   800ce9 <sys_env_destroy>
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800179:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800182:	e8 b4 0b 00 00       	call   800d3b <sys_getenvid>
  800187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80018e:	8b 55 08             	mov    0x8(%ebp),%edx
  800191:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800195:	89 74 24 08          	mov    %esi,0x8(%esp)
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	c7 04 24 b8 22 80 00 	movl   $0x8022b8,(%esp)
  8001a4:	e8 c1 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b0:	89 04 24             	mov    %eax,(%esp)
  8001b3:	e8 51 00 00 00       	call   800209 <vcprintf>
	cprintf("\n");
  8001b8:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  8001bf:	e8 a6 00 00 00       	call   80026a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c4:	cc                   	int3   
  8001c5:	eb fd                	jmp    8001c4 <_panic+0x53>

008001c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 14             	sub    $0x14,%esp
  8001ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d1:	8b 13                	mov    (%ebx),%edx
  8001d3:	8d 42 01             	lea    0x1(%edx),%eax
  8001d6:	89 03                	mov    %eax,(%ebx)
  8001d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e4:	75 19                	jne    8001ff <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001e6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ed:	00 
  8001ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f1:	89 04 24             	mov    %eax,(%esp)
  8001f4:	e8 b3 0a 00 00       	call   800cac <sys_cputs>
		b->idx = 0;
  8001f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800203:	83 c4 14             	add    $0x14,%esp
  800206:	5b                   	pop    %ebx
  800207:	5d                   	pop    %ebp
  800208:	c3                   	ret    

00800209 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800212:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800219:	00 00 00 
	b.cnt = 0;
  80021c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800223:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022d:	8b 45 08             	mov    0x8(%ebp),%eax
  800230:	89 44 24 08          	mov    %eax,0x8(%esp)
  800234:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023e:	c7 04 24 c7 01 80 00 	movl   $0x8001c7,(%esp)
  800245:	e8 ba 01 00 00       	call   800404 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800250:	89 44 24 04          	mov    %eax,0x4(%esp)
  800254:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025a:	89 04 24             	mov    %eax,(%esp)
  80025d:	e8 4a 0a 00 00       	call   800cac <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	89 44 24 04          	mov    %eax,0x4(%esp)
  800277:	8b 45 08             	mov    0x8(%ebp),%eax
  80027a:	89 04 24             	mov    %eax,(%esp)
  80027d:	e8 87 ff ff ff       	call   800209 <vcprintf>
	va_end(ap);

	return cnt;
}
  800282:	c9                   	leave  
  800283:	c3                   	ret    
  800284:	66 90                	xchg   %ax,%ax
  800286:	66 90                	xchg   %ax,%ax
  800288:	66 90                	xchg   %ax,%ax
  80028a:	66 90                	xchg   %ax,%ax
  80028c:	66 90                	xchg   %ax,%ax
  80028e:	66 90                	xchg   %ax,%ax

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002a7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8002aa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002b8:	39 f1                	cmp    %esi,%ecx
  8002ba:	72 14                	jb     8002d0 <printnum+0x40>
  8002bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002bf:	76 0f                	jbe    8002d0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8002c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002ca:	85 f6                	test   %esi,%esi
  8002cc:	7f 60                	jg     80032e <printnum+0x9e>
  8002ce:	eb 72                	jmp    800342 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002d3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8002da:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8002dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002e9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002ed:	89 c3                	mov    %eax,%ebx
  8002ef:	89 d6                	mov    %edx,%esi
  8002f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002f7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800302:	89 04 24             	mov    %eax,(%esp)
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030c:	e8 8f 1c 00 00       	call   801fa0 <__udivdi3>
  800311:	89 d9                	mov    %ebx,%ecx
  800313:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800317:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800322:	89 fa                	mov    %edi,%edx
  800324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800327:	e8 64 ff ff ff       	call   800290 <printnum>
  80032c:	eb 14                	jmp    800342 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800332:	8b 45 18             	mov    0x18(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033a:	83 ee 01             	sub    $0x1,%esi
  80033d:	75 ef                	jne    80032e <printnum+0x9e>
  80033f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800342:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800346:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80034a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80034d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800350:	89 44 24 08          	mov    %eax,0x8(%esp)
  800354:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035b:	89 04 24             	mov    %eax,(%esp)
  80035e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800361:	89 44 24 04          	mov    %eax,0x4(%esp)
  800365:	e8 66 1d 00 00       	call   8020d0 <__umoddi3>
  80036a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80036e:	0f be 80 db 22 80 00 	movsbl 0x8022db(%eax),%eax
  800375:	89 04 24             	mov    %eax,(%esp)
  800378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037b:	ff d0                	call   *%eax
}
  80037d:	83 c4 3c             	add    $0x3c,%esp
  800380:	5b                   	pop    %ebx
  800381:	5e                   	pop    %esi
  800382:	5f                   	pop    %edi
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800388:	83 fa 01             	cmp    $0x1,%edx
  80038b:	7e 0e                	jle    80039b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800392:	89 08                	mov    %ecx,(%eax)
  800394:	8b 02                	mov    (%edx),%eax
  800396:	8b 52 04             	mov    0x4(%edx),%edx
  800399:	eb 22                	jmp    8003bd <getuint+0x38>
	else if (lflag)
  80039b:	85 d2                	test   %edx,%edx
  80039d:	74 10                	je     8003af <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80039f:	8b 10                	mov    (%eax),%edx
  8003a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a4:	89 08                	mov    %ecx,(%eax)
  8003a6:	8b 02                	mov    (%edx),%eax
  8003a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ad:	eb 0e                	jmp    8003bd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003af:	8b 10                	mov    (%eax),%edx
  8003b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b4:	89 08                	mov    %ecx,(%eax)
  8003b6:	8b 02                	mov    (%edx),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c9:	8b 10                	mov    (%eax),%edx
  8003cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ce:	73 0a                	jae    8003da <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d3:	89 08                	mov    %ecx,(%eax)
  8003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d8:	88 02                	mov    %al,(%edx)
}
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	89 04 24             	mov    %eax,(%esp)
  8003fd:	e8 02 00 00 00       	call   800404 <vprintfmt>
	va_end(ap);
}
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 3c             	sub    $0x3c,%esp
  80040d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800410:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800413:	eb 18                	jmp    80042d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800415:	85 c0                	test   %eax,%eax
  800417:	0f 84 c3 03 00 00    	je     8007e0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80041d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800421:	89 04 24             	mov    %eax,(%esp)
  800424:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800427:	89 f3                	mov    %esi,%ebx
  800429:	eb 02                	jmp    80042d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80042b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042d:	8d 73 01             	lea    0x1(%ebx),%esi
  800430:	0f b6 03             	movzbl (%ebx),%eax
  800433:	83 f8 25             	cmp    $0x25,%eax
  800436:	75 dd                	jne    800415 <vprintfmt+0x11>
  800438:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80043c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800443:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80044a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800451:	ba 00 00 00 00       	mov    $0x0,%edx
  800456:	eb 1d                	jmp    800475 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800458:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80045a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80045e:	eb 15                	jmp    800475 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800460:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800462:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800466:	eb 0d                	jmp    800475 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800475:	8d 5e 01             	lea    0x1(%esi),%ebx
  800478:	0f b6 06             	movzbl (%esi),%eax
  80047b:	0f b6 c8             	movzbl %al,%ecx
  80047e:	83 e8 23             	sub    $0x23,%eax
  800481:	3c 55                	cmp    $0x55,%al
  800483:	0f 87 2f 03 00 00    	ja     8007b8 <vprintfmt+0x3b4>
  800489:	0f b6 c0             	movzbl %al,%eax
  80048c:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800493:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800496:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800499:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80049d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8004a0:	83 f9 09             	cmp    $0x9,%ecx
  8004a3:	77 50                	ja     8004f5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	89 de                	mov    %ebx,%esi
  8004a7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004aa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8004ad:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004b0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004b4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004b7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ba:	83 fb 09             	cmp    $0x9,%ebx
  8004bd:	76 eb                	jbe    8004aa <vprintfmt+0xa6>
  8004bf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004c2:	eb 33                	jmp    8004f7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ca:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004d4:	eb 21                	jmp    8004f7 <vprintfmt+0xf3>
  8004d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d9:	85 c9                	test   %ecx,%ecx
  8004db:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e0:	0f 49 c1             	cmovns %ecx,%eax
  8004e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	89 de                	mov    %ebx,%esi
  8004e8:	eb 8b                	jmp    800475 <vprintfmt+0x71>
  8004ea:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004ec:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004f3:	eb 80                	jmp    800475 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004fb:	0f 89 74 ff ff ff    	jns    800475 <vprintfmt+0x71>
  800501:	e9 62 ff ff ff       	jmp    800468 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800506:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800509:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80050b:	e9 65 ff ff ff       	jmp    800475 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 50 04             	lea    0x4(%eax),%edx
  800516:	89 55 14             	mov    %edx,0x14(%ebp)
  800519:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	ff 55 08             	call   *0x8(%ebp)
			break;
  800525:	e9 03 ff ff ff       	jmp    80042d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 50 04             	lea    0x4(%eax),%edx
  800530:	89 55 14             	mov    %edx,0x14(%ebp)
  800533:	8b 00                	mov    (%eax),%eax
  800535:	99                   	cltd   
  800536:	31 d0                	xor    %edx,%eax
  800538:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053a:	83 f8 0f             	cmp    $0xf,%eax
  80053d:	7f 0b                	jg     80054a <vprintfmt+0x146>
  80053f:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  800546:	85 d2                	test   %edx,%edx
  800548:	75 20                	jne    80056a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80054a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054e:	c7 44 24 08 f3 22 80 	movl   $0x8022f3,0x8(%esp)
  800555:	00 
  800556:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 77 fe ff ff       	call   8003dc <printfmt>
  800565:	e9 c3 fe ff ff       	jmp    80042d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80056a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80056e:	c7 44 24 08 d6 26 80 	movl   $0x8026d6,0x8(%esp)
  800575:	00 
  800576:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057a:	8b 45 08             	mov    0x8(%ebp),%eax
  80057d:	89 04 24             	mov    %eax,(%esp)
  800580:	e8 57 fe ff ff       	call   8003dc <printfmt>
  800585:	e9 a3 fe ff ff       	jmp    80042d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80058d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 50 04             	lea    0x4(%eax),%edx
  800596:	89 55 14             	mov    %edx,0x14(%ebp)
  800599:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80059b:	85 c0                	test   %eax,%eax
  80059d:	ba ec 22 80 00       	mov    $0x8022ec,%edx
  8005a2:	0f 45 d0             	cmovne %eax,%edx
  8005a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8005a8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8005ac:	74 04                	je     8005b2 <vprintfmt+0x1ae>
  8005ae:	85 f6                	test   %esi,%esi
  8005b0:	7f 19                	jg     8005cb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b5:	8d 70 01             	lea    0x1(%eax),%esi
  8005b8:	0f b6 10             	movzbl (%eax),%edx
  8005bb:	0f be c2             	movsbl %dl,%eax
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	0f 85 95 00 00 00    	jne    80065b <vprintfmt+0x257>
  8005c6:	e9 85 00 00 00       	jmp    800650 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d2:	89 04 24             	mov    %eax,(%esp)
  8005d5:	e8 b8 02 00 00       	call   800892 <strnlen>
  8005da:	29 c6                	sub    %eax,%esi
  8005dc:	89 f0                	mov    %esi,%eax
  8005de:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005e1:	85 f6                	test   %esi,%esi
  8005e3:	7e cd                	jle    8005b2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005e5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005e9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ec:	89 c3                	mov    %eax,%ebx
  8005ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f2:	89 34 24             	mov    %esi,(%esp)
  8005f5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f8:	83 eb 01             	sub    $0x1,%ebx
  8005fb:	75 f1                	jne    8005ee <vprintfmt+0x1ea>
  8005fd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800600:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800603:	eb ad                	jmp    8005b2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800605:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800609:	74 1e                	je     800629 <vprintfmt+0x225>
  80060b:	0f be d2             	movsbl %dl,%edx
  80060e:	83 ea 20             	sub    $0x20,%edx
  800611:	83 fa 5e             	cmp    $0x5e,%edx
  800614:	76 13                	jbe    800629 <vprintfmt+0x225>
					putch('?', putdat);
  800616:	8b 45 0c             	mov    0xc(%ebp),%eax
  800619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800624:	ff 55 08             	call   *0x8(%ebp)
  800627:	eb 0d                	jmp    800636 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800630:	89 04 24             	mov    %eax,(%esp)
  800633:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800636:	83 ef 01             	sub    $0x1,%edi
  800639:	83 c6 01             	add    $0x1,%esi
  80063c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800640:	0f be c2             	movsbl %dl,%eax
  800643:	85 c0                	test   %eax,%eax
  800645:	75 20                	jne    800667 <vprintfmt+0x263>
  800647:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80064a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80064d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800650:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800654:	7f 25                	jg     80067b <vprintfmt+0x277>
  800656:	e9 d2 fd ff ff       	jmp    80042d <vprintfmt+0x29>
  80065b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80065e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800661:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800664:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800667:	85 db                	test   %ebx,%ebx
  800669:	78 9a                	js     800605 <vprintfmt+0x201>
  80066b:	83 eb 01             	sub    $0x1,%ebx
  80066e:	79 95                	jns    800605 <vprintfmt+0x201>
  800670:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800673:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800676:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800679:	eb d5                	jmp    800650 <vprintfmt+0x24c>
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800681:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800684:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800688:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80068f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800691:	83 eb 01             	sub    $0x1,%ebx
  800694:	75 ee                	jne    800684 <vprintfmt+0x280>
  800696:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800699:	e9 8f fd ff ff       	jmp    80042d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80069e:	83 fa 01             	cmp    $0x1,%edx
  8006a1:	7e 16                	jle    8006b9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 50 08             	lea    0x8(%eax),%edx
  8006a9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ac:	8b 50 04             	mov    0x4(%eax),%edx
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b7:	eb 32                	jmp    8006eb <vprintfmt+0x2e7>
	else if (lflag)
  8006b9:	85 d2                	test   %edx,%edx
  8006bb:	74 18                	je     8006d5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8d 50 04             	lea    0x4(%eax),%edx
  8006c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c6:	8b 30                	mov    (%eax),%esi
  8006c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cb:	89 f0                	mov    %esi,%eax
  8006cd:	c1 f8 1f             	sar    $0x1f,%eax
  8006d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006d3:	eb 16                	jmp    8006eb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8d 50 04             	lea    0x4(%eax),%edx
  8006db:	89 55 14             	mov    %edx,0x14(%ebp)
  8006de:	8b 30                	mov    (%eax),%esi
  8006e0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006e3:	89 f0                	mov    %esi,%eax
  8006e5:	c1 f8 1f             	sar    $0x1f,%eax
  8006e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006f1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006fa:	0f 89 80 00 00 00    	jns    800780 <vprintfmt+0x37c>
				putch('-', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80070e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800711:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800714:	f7 d8                	neg    %eax
  800716:	83 d2 00             	adc    $0x0,%edx
  800719:	f7 da                	neg    %edx
			}
			base = 10;
  80071b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800720:	eb 5e                	jmp    800780 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800722:	8d 45 14             	lea    0x14(%ebp),%eax
  800725:	e8 5b fc ff ff       	call   800385 <getuint>
			base = 10;
  80072a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80072f:	eb 4f                	jmp    800780 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800731:	8d 45 14             	lea    0x14(%ebp),%eax
  800734:	e8 4c fc ff ff       	call   800385 <getuint>
			base = 8;
  800739:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80073e:	eb 40                	jmp    800780 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80074e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800752:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800759:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 50 04             	lea    0x4(%eax),%edx
  800762:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800765:	8b 00                	mov    (%eax),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80076c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800771:	eb 0d                	jmp    800780 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
  800776:	e8 0a fc ff ff       	call   800385 <getuint>
			base = 16;
  80077b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800780:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800784:	89 74 24 10          	mov    %esi,0x10(%esp)
  800788:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80078b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800793:	89 04 24             	mov    %eax,(%esp)
  800796:	89 54 24 04          	mov    %edx,0x4(%esp)
  80079a:	89 fa                	mov    %edi,%edx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	e8 ec fa ff ff       	call   800290 <printnum>
			break;
  8007a4:	e9 84 fc ff ff       	jmp    80042d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ad:	89 0c 24             	mov    %ecx,(%esp)
  8007b0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007b3:	e9 75 fc ff ff       	jmp    80042d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007c3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007ca:	0f 84 5b fc ff ff    	je     80042b <vprintfmt+0x27>
  8007d0:	89 f3                	mov    %esi,%ebx
  8007d2:	83 eb 01             	sub    $0x1,%ebx
  8007d5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007d9:	75 f7                	jne    8007d2 <vprintfmt+0x3ce>
  8007db:	e9 4d fc ff ff       	jmp    80042d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007e0:	83 c4 3c             	add    $0x3c,%esp
  8007e3:	5b                   	pop    %ebx
  8007e4:	5e                   	pop    %esi
  8007e5:	5f                   	pop    %edi
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 28             	sub    $0x28,%esp
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800805:	85 c0                	test   %eax,%eax
  800807:	74 30                	je     800839 <vsnprintf+0x51>
  800809:	85 d2                	test   %edx,%edx
  80080b:	7e 2c                	jle    800839 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80081e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800822:	c7 04 24 bf 03 80 00 	movl   $0x8003bf,(%esp)
  800829:	e8 d6 fb ff ff       	call   800404 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800831:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800837:	eb 05                	jmp    80083e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800846:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800849:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	89 44 24 08          	mov    %eax,0x8(%esp)
  800854:	8b 45 0c             	mov    0xc(%ebp),%eax
  800857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 04 24             	mov    %eax,(%esp)
  800861:	e8 82 ff ff ff       	call   8007e8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800866:	c9                   	leave  
  800867:	c3                   	ret    
  800868:	66 90                	xchg   %ax,%ax
  80086a:	66 90                	xchg   %ax,%ax
  80086c:	66 90                	xchg   %ax,%ax
  80086e:	66 90                	xchg   %ax,%ax

00800870 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800876:	80 3a 00             	cmpb   $0x0,(%edx)
  800879:	74 10                	je     80088b <strlen+0x1b>
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800880:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800887:	75 f7                	jne    800880 <strlen+0x10>
  800889:	eb 05                	jmp    800890 <strlen+0x20>
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089c:	85 c9                	test   %ecx,%ecx
  80089e:	74 1c                	je     8008bc <strnlen+0x2a>
  8008a0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008a3:	74 1e                	je     8008c3 <strnlen+0x31>
  8008a5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8008aa:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ac:	39 ca                	cmp    %ecx,%edx
  8008ae:	74 18                	je     8008c8 <strnlen+0x36>
  8008b0:	83 c2 01             	add    $0x1,%edx
  8008b3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008b8:	75 f0                	jne    8008aa <strnlen+0x18>
  8008ba:	eb 0c                	jmp    8008c8 <strnlen+0x36>
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	eb 05                	jmp    8008c8 <strnlen+0x36>
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d5:	89 c2                	mov    %eax,%edx
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	83 c1 01             	add    $0x1,%ecx
  8008dd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008e1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e4:	84 db                	test   %bl,%bl
  8008e6:	75 ef                	jne    8008d7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f5:	89 1c 24             	mov    %ebx,(%esp)
  8008f8:	e8 73 ff ff ff       	call   800870 <strlen>
	strcpy(dst + len, src);
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	89 54 24 04          	mov    %edx,0x4(%esp)
  800904:	01 d8                	add    %ebx,%eax
  800906:	89 04 24             	mov    %eax,(%esp)
  800909:	e8 bd ff ff ff       	call   8008cb <strcpy>
	return dst;
}
  80090e:	89 d8                	mov    %ebx,%eax
  800910:	83 c4 08             	add    $0x8,%esp
  800913:	5b                   	pop    %ebx
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 75 08             	mov    0x8(%ebp),%esi
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800924:	85 db                	test   %ebx,%ebx
  800926:	74 17                	je     80093f <strncpy+0x29>
  800928:	01 f3                	add    %esi,%ebx
  80092a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80092c:	83 c1 01             	add    $0x1,%ecx
  80092f:	0f b6 02             	movzbl (%edx),%eax
  800932:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800935:	80 3a 01             	cmpb   $0x1,(%edx)
  800938:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093b:	39 d9                	cmp    %ebx,%ecx
  80093d:	75 ed                	jne    80092c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80093f:	89 f0                	mov    %esi,%eax
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	57                   	push   %edi
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800951:	8b 75 10             	mov    0x10(%ebp),%esi
  800954:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800956:	85 f6                	test   %esi,%esi
  800958:	74 34                	je     80098e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80095a:	83 fe 01             	cmp    $0x1,%esi
  80095d:	74 26                	je     800985 <strlcpy+0x40>
  80095f:	0f b6 0b             	movzbl (%ebx),%ecx
  800962:	84 c9                	test   %cl,%cl
  800964:	74 23                	je     800989 <strlcpy+0x44>
  800966:	83 ee 02             	sub    $0x2,%esi
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80096e:	83 c0 01             	add    $0x1,%eax
  800971:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800974:	39 f2                	cmp    %esi,%edx
  800976:	74 13                	je     80098b <strlcpy+0x46>
  800978:	83 c2 01             	add    $0x1,%edx
  80097b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097f:	84 c9                	test   %cl,%cl
  800981:	75 eb                	jne    80096e <strlcpy+0x29>
  800983:	eb 06                	jmp    80098b <strlcpy+0x46>
  800985:	89 f8                	mov    %edi,%eax
  800987:	eb 02                	jmp    80098b <strlcpy+0x46>
  800989:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80098b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098e:	29 f8                	sub    %edi,%eax
}
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5f                   	pop    %edi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099e:	0f b6 01             	movzbl (%ecx),%eax
  8009a1:	84 c0                	test   %al,%al
  8009a3:	74 15                	je     8009ba <strcmp+0x25>
  8009a5:	3a 02                	cmp    (%edx),%al
  8009a7:	75 11                	jne    8009ba <strcmp+0x25>
		p++, q++;
  8009a9:	83 c1 01             	add    $0x1,%ecx
  8009ac:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009af:	0f b6 01             	movzbl (%ecx),%eax
  8009b2:	84 c0                	test   %al,%al
  8009b4:	74 04                	je     8009ba <strcmp+0x25>
  8009b6:	3a 02                	cmp    (%edx),%al
  8009b8:	74 ef                	je     8009a9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ba:	0f b6 c0             	movzbl %al,%eax
  8009bd:	0f b6 12             	movzbl (%edx),%edx
  8009c0:	29 d0                	sub    %edx,%eax
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8009d2:	85 f6                	test   %esi,%esi
  8009d4:	74 29                	je     8009ff <strncmp+0x3b>
  8009d6:	0f b6 03             	movzbl (%ebx),%eax
  8009d9:	84 c0                	test   %al,%al
  8009db:	74 30                	je     800a0d <strncmp+0x49>
  8009dd:	3a 02                	cmp    (%edx),%al
  8009df:	75 2c                	jne    800a0d <strncmp+0x49>
  8009e1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009e4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009e6:	89 c3                	mov    %eax,%ebx
  8009e8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009eb:	39 f0                	cmp    %esi,%eax
  8009ed:	74 17                	je     800a06 <strncmp+0x42>
  8009ef:	0f b6 08             	movzbl (%eax),%ecx
  8009f2:	84 c9                	test   %cl,%cl
  8009f4:	74 17                	je     800a0d <strncmp+0x49>
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	3a 0a                	cmp    (%edx),%cl
  8009fb:	74 e9                	je     8009e6 <strncmp+0x22>
  8009fd:	eb 0e                	jmp    800a0d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800a04:	eb 0f                	jmp    800a15 <strncmp+0x51>
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0b:	eb 08                	jmp    800a15 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0d:	0f b6 03             	movzbl (%ebx),%eax
  800a10:	0f b6 12             	movzbl (%edx),%edx
  800a13:	29 d0                	sub    %edx,%eax
}
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a23:	0f b6 18             	movzbl (%eax),%ebx
  800a26:	84 db                	test   %bl,%bl
  800a28:	74 1d                	je     800a47 <strchr+0x2e>
  800a2a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a2c:	38 d3                	cmp    %dl,%bl
  800a2e:	75 06                	jne    800a36 <strchr+0x1d>
  800a30:	eb 1a                	jmp    800a4c <strchr+0x33>
  800a32:	38 ca                	cmp    %cl,%dl
  800a34:	74 16                	je     800a4c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	0f b6 10             	movzbl (%eax),%edx
  800a3c:	84 d2                	test   %dl,%dl
  800a3e:	75 f2                	jne    800a32 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a40:	b8 00 00 00 00       	mov    $0x0,%eax
  800a45:	eb 05                	jmp    800a4c <strchr+0x33>
  800a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4c:	5b                   	pop    %ebx
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	53                   	push   %ebx
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a59:	0f b6 18             	movzbl (%eax),%ebx
  800a5c:	84 db                	test   %bl,%bl
  800a5e:	74 16                	je     800a76 <strfind+0x27>
  800a60:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a62:	38 d3                	cmp    %dl,%bl
  800a64:	75 06                	jne    800a6c <strfind+0x1d>
  800a66:	eb 0e                	jmp    800a76 <strfind+0x27>
  800a68:	38 ca                	cmp    %cl,%dl
  800a6a:	74 0a                	je     800a76 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a6c:	83 c0 01             	add    $0x1,%eax
  800a6f:	0f b6 10             	movzbl (%eax),%edx
  800a72:	84 d2                	test   %dl,%dl
  800a74:	75 f2                	jne    800a68 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a76:	5b                   	pop    %ebx
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	57                   	push   %edi
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a85:	85 c9                	test   %ecx,%ecx
  800a87:	74 36                	je     800abf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a89:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8f:	75 28                	jne    800ab9 <memset+0x40>
  800a91:	f6 c1 03             	test   $0x3,%cl
  800a94:	75 23                	jne    800ab9 <memset+0x40>
		c &= 0xFF;
  800a96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9a:	89 d3                	mov    %edx,%ebx
  800a9c:	c1 e3 08             	shl    $0x8,%ebx
  800a9f:	89 d6                	mov    %edx,%esi
  800aa1:	c1 e6 18             	shl    $0x18,%esi
  800aa4:	89 d0                	mov    %edx,%eax
  800aa6:	c1 e0 10             	shl    $0x10,%eax
  800aa9:	09 f0                	or     %esi,%eax
  800aab:	09 c2                	or     %eax,%edx
  800aad:	89 d0                	mov    %edx,%eax
  800aaf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ab4:	fc                   	cld    
  800ab5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab7:	eb 06                	jmp    800abf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	fc                   	cld    
  800abd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abf:	89 f8                	mov    %edi,%eax
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad4:	39 c6                	cmp    %eax,%esi
  800ad6:	73 35                	jae    800b0d <memmove+0x47>
  800ad8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800adb:	39 d0                	cmp    %edx,%eax
  800add:	73 2e                	jae    800b0d <memmove+0x47>
		s += n;
		d += n;
  800adf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ae2:	89 d6                	mov    %edx,%esi
  800ae4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aec:	75 13                	jne    800b01 <memmove+0x3b>
  800aee:	f6 c1 03             	test   $0x3,%cl
  800af1:	75 0e                	jne    800b01 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af3:	83 ef 04             	sub    $0x4,%edi
  800af6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800afc:	fd                   	std    
  800afd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aff:	eb 09                	jmp    800b0a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b01:	83 ef 01             	sub    $0x1,%edi
  800b04:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b07:	fd                   	std    
  800b08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0a:	fc                   	cld    
  800b0b:	eb 1d                	jmp    800b2a <memmove+0x64>
  800b0d:	89 f2                	mov    %esi,%edx
  800b0f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b11:	f6 c2 03             	test   $0x3,%dl
  800b14:	75 0f                	jne    800b25 <memmove+0x5f>
  800b16:	f6 c1 03             	test   $0x3,%cl
  800b19:	75 0a                	jne    800b25 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b1e:	89 c7                	mov    %eax,%edi
  800b20:	fc                   	cld    
  800b21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b23:	eb 05                	jmp    800b2a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b25:	89 c7                	mov    %eax,%edi
  800b27:	fc                   	cld    
  800b28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b2a:	5e                   	pop    %esi
  800b2b:	5f                   	pop    %edi
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	e8 79 ff ff ff       	call   800ac6 <memmove>
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b61:	85 c0                	test   %eax,%eax
  800b63:	74 36                	je     800b9b <memcmp+0x4c>
		if (*s1 != *s2)
  800b65:	0f b6 03             	movzbl (%ebx),%eax
  800b68:	0f b6 0e             	movzbl (%esi),%ecx
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	38 c8                	cmp    %cl,%al
  800b72:	74 1c                	je     800b90 <memcmp+0x41>
  800b74:	eb 10                	jmp    800b86 <memcmp+0x37>
  800b76:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b82:	38 c8                	cmp    %cl,%al
  800b84:	74 0a                	je     800b90 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	0f b6 c9             	movzbl %cl,%ecx
  800b8c:	29 c8                	sub    %ecx,%eax
  800b8e:	eb 10                	jmp    800ba0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b90:	39 fa                	cmp    %edi,%edx
  800b92:	75 e2                	jne    800b76 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
  800b99:	eb 05                	jmp    800ba0 <memcmp+0x51>
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb4:	39 d0                	cmp    %edx,%eax
  800bb6:	73 13                	jae    800bcb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb8:	89 d9                	mov    %ebx,%ecx
  800bba:	38 18                	cmp    %bl,(%eax)
  800bbc:	75 06                	jne    800bc4 <memfind+0x1f>
  800bbe:	eb 0b                	jmp    800bcb <memfind+0x26>
  800bc0:	38 08                	cmp    %cl,(%eax)
  800bc2:	74 07                	je     800bcb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bc4:	83 c0 01             	add    $0x1,%eax
  800bc7:	39 d0                	cmp    %edx,%eax
  800bc9:	75 f5                	jne    800bc0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bda:	0f b6 0a             	movzbl (%edx),%ecx
  800bdd:	80 f9 09             	cmp    $0x9,%cl
  800be0:	74 05                	je     800be7 <strtol+0x19>
  800be2:	80 f9 20             	cmp    $0x20,%cl
  800be5:	75 10                	jne    800bf7 <strtol+0x29>
		s++;
  800be7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bea:	0f b6 0a             	movzbl (%edx),%ecx
  800bed:	80 f9 09             	cmp    $0x9,%cl
  800bf0:	74 f5                	je     800be7 <strtol+0x19>
  800bf2:	80 f9 20             	cmp    $0x20,%cl
  800bf5:	74 f0                	je     800be7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bf7:	80 f9 2b             	cmp    $0x2b,%cl
  800bfa:	75 0a                	jne    800c06 <strtol+0x38>
		s++;
  800bfc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bff:	bf 00 00 00 00       	mov    $0x0,%edi
  800c04:	eb 11                	jmp    800c17 <strtol+0x49>
  800c06:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c0b:	80 f9 2d             	cmp    $0x2d,%cl
  800c0e:	75 07                	jne    800c17 <strtol+0x49>
		s++, neg = 1;
  800c10:	83 c2 01             	add    $0x1,%edx
  800c13:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c17:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c1c:	75 15                	jne    800c33 <strtol+0x65>
  800c1e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c21:	75 10                	jne    800c33 <strtol+0x65>
  800c23:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c27:	75 0a                	jne    800c33 <strtol+0x65>
		s += 2, base = 16;
  800c29:	83 c2 02             	add    $0x2,%edx
  800c2c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c31:	eb 10                	jmp    800c43 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c33:	85 c0                	test   %eax,%eax
  800c35:	75 0c                	jne    800c43 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c37:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c39:	80 3a 30             	cmpb   $0x30,(%edx)
  800c3c:	75 05                	jne    800c43 <strtol+0x75>
		s++, base = 8;
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c48:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c4b:	0f b6 0a             	movzbl (%edx),%ecx
  800c4e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c51:	89 f0                	mov    %esi,%eax
  800c53:	3c 09                	cmp    $0x9,%al
  800c55:	77 08                	ja     800c5f <strtol+0x91>
			dig = *s - '0';
  800c57:	0f be c9             	movsbl %cl,%ecx
  800c5a:	83 e9 30             	sub    $0x30,%ecx
  800c5d:	eb 20                	jmp    800c7f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c5f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c62:	89 f0                	mov    %esi,%eax
  800c64:	3c 19                	cmp    $0x19,%al
  800c66:	77 08                	ja     800c70 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c68:	0f be c9             	movsbl %cl,%ecx
  800c6b:	83 e9 57             	sub    $0x57,%ecx
  800c6e:	eb 0f                	jmp    800c7f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c70:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c73:	89 f0                	mov    %esi,%eax
  800c75:	3c 19                	cmp    $0x19,%al
  800c77:	77 16                	ja     800c8f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c79:	0f be c9             	movsbl %cl,%ecx
  800c7c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c7f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c82:	7d 0f                	jge    800c93 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c84:	83 c2 01             	add    $0x1,%edx
  800c87:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c8b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c8d:	eb bc                	jmp    800c4b <strtol+0x7d>
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	eb 02                	jmp    800c95 <strtol+0xc7>
  800c93:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c99:	74 05                	je     800ca0 <strtol+0xd2>
		*endptr = (char *) s;
  800c9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ca0:	f7 d8                	neg    %eax
  800ca2:	85 ff                	test   %edi,%edi
  800ca4:	0f 44 c3             	cmove  %ebx,%eax
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	89 c3                	mov    %eax,%ebx
  800cbf:	89 c7                	mov    %eax,%edi
  800cc1:	89 c6                	mov    %eax,%esi
  800cc3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <sys_cgetc>:

int
sys_cgetc(void)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cda:	89 d1                	mov    %edx,%ecx
  800cdc:	89 d3                	mov    %edx,%ebx
  800cde:	89 d7                	mov    %edx,%edi
  800ce0:	89 d6                	mov    %edx,%esi
  800ce2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	89 cb                	mov    %ecx,%ebx
  800d01:	89 cf                	mov    %ecx,%edi
  800d03:	89 ce                	mov    %ecx,%esi
  800d05:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d07:	85 c0                	test   %eax,%eax
  800d09:	7e 28                	jle    800d33 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d16:	00 
  800d17:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800d1e:	00 
  800d1f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d26:	00 
  800d27:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800d2e:	e8 3e f4 ff ff       	call   800171 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d33:	83 c4 2c             	add    $0x2c,%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d41:	ba 00 00 00 00       	mov    $0x0,%edx
  800d46:	b8 02 00 00 00       	mov    $0x2,%eax
  800d4b:	89 d1                	mov    %edx,%ecx
  800d4d:	89 d3                	mov    %edx,%ebx
  800d4f:	89 d7                	mov    %edx,%edi
  800d51:	89 d6                	mov    %edx,%esi
  800d53:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_yield>:

void
sys_yield(void)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6a:	89 d1                	mov    %edx,%ecx
  800d6c:	89 d3                	mov    %edx,%ebx
  800d6e:	89 d7                	mov    %edx,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d82:	be 00 00 00 00       	mov    $0x0,%esi
  800d87:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d95:	89 f7                	mov    %esi,%edi
  800d97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	7e 28                	jle    800dc5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800da8:	00 
  800da9:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800db0:	00 
  800db1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800db8:	00 
  800db9:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800dc0:	e8 ac f3 ff ff       	call   800171 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc5:	83 c4 2c             	add    $0x2c,%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd6:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7e 28                	jle    800e18 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dfb:	00 
  800dfc:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800e03:	00 
  800e04:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e0b:	00 
  800e0c:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800e13:	e8 59 f3 ff ff       	call   800171 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e18:	83 c4 2c             	add    $0x2c,%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	89 df                	mov    %ebx,%edi
  800e3b:	89 de                	mov    %ebx,%esi
  800e3d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	7e 28                	jle    800e6b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e47:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800e56:	00 
  800e57:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e5e:	00 
  800e5f:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800e66:	e8 06 f3 ff ff       	call   800171 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e6b:	83 c4 2c             	add    $0x2c,%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	b8 08 00 00 00       	mov    $0x8,%eax
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	89 df                	mov    %ebx,%edi
  800e8e:	89 de                	mov    %ebx,%esi
  800e90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7e 28                	jle    800ebe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ea1:	00 
  800ea2:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800ea9:	00 
  800eaa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb1:	00 
  800eb2:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800eb9:	e8 b3 f2 ff ff       	call   800171 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ebe:	83 c4 2c             	add    $0x2c,%esp
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 df                	mov    %ebx,%edi
  800ee1:	89 de                	mov    %ebx,%esi
  800ee3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7e 28                	jle    800f11 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eed:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ef4:	00 
  800ef5:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800efc:	00 
  800efd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f04:	00 
  800f05:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800f0c:	e8 60 f2 ff ff       	call   800171 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f11:	83 c4 2c             	add    $0x2c,%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	89 df                	mov    %ebx,%edi
  800f34:	89 de                	mov    %ebx,%esi
  800f36:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	7e 28                	jle    800f64 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f40:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f47:	00 
  800f48:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800f4f:	00 
  800f50:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f57:	00 
  800f58:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800f5f:	e8 0d f2 ff ff       	call   800171 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f64:	83 c4 2c             	add    $0x2c,%esp
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	be 00 00 00 00       	mov    $0x0,%esi
  800f77:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f85:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f88:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
  800f95:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	89 cb                	mov    %ecx,%ebx
  800fa7:	89 cf                	mov    %ecx,%edi
  800fa9:	89 ce                	mov    %ecx,%esi
  800fab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7e 28                	jle    800fd9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fbc:	00 
  800fbd:	c7 44 24 08 df 25 80 	movl   $0x8025df,0x8(%esp)
  800fc4:	00 
  800fc5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fcc:	00 
  800fcd:	c7 04 24 fc 25 80 00 	movl   $0x8025fc,(%esp)
  800fd4:	e8 98 f1 ff ff       	call   800171 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd9:	83 c4 2c             	add    $0x2c,%esp
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  800fe7:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800fee:	75 50                	jne    801040 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  800ff0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800fff:	ee 
  801000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801007:	e8 6d fd ff ff       	call   800d79 <sys_page_alloc>
  80100c:	85 c0                	test   %eax,%eax
  80100e:	79 1c                	jns    80102c <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801010:	c7 44 24 08 0c 26 80 	movl   $0x80260c,0x8(%esp)
  801017:	00 
  801018:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80101f:	00 
  801020:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  801027:	e8 45 f1 ff ff       	call   800171 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80102c:	c7 44 24 04 4a 10 80 	movl   $0x80104a,0x4(%esp)
  801033:	00 
  801034:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80103b:	e8 d9 fe ff ff       	call   800f19 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	a3 08 40 80 00       	mov    %eax,0x804008
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80104a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80104b:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  801050:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801052:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801055:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801057:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  80105c:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80105f:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801064:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801067:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801069:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  80106c:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  80106e:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801070:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801075:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801078:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  80107d:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801080:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801082:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801087:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80108a:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80108f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  801092:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  801094:	83 c4 08             	add    $0x8,%esp
	popal
  801097:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801098:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801099:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80109a:	c3                   	ret    
  80109b:	66 90                	xchg   %ax,%ax
  80109d:	66 90                	xchg   %ax,%ax
  80109f:	90                   	nop

008010a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010ca:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010cf:	a8 01                	test   $0x1,%al
  8010d1:	74 34                	je     801107 <fd_alloc+0x40>
  8010d3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010d8:	a8 01                	test   $0x1,%al
  8010da:	74 32                	je     80110e <fd_alloc+0x47>
  8010dc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010e1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 16             	shr    $0x16,%edx
  8010e8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ef:	f6 c2 01             	test   $0x1,%dl
  8010f2:	74 1f                	je     801113 <fd_alloc+0x4c>
  8010f4:	89 c2                	mov    %eax,%edx
  8010f6:	c1 ea 0c             	shr    $0xc,%edx
  8010f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801100:	f6 c2 01             	test   $0x1,%dl
  801103:	75 1a                	jne    80111f <fd_alloc+0x58>
  801105:	eb 0c                	jmp    801113 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801107:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80110c:	eb 05                	jmp    801113 <fd_alloc+0x4c>
  80110e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	89 08                	mov    %ecx,(%eax)
			return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
  80111d:	eb 1a                	jmp    801139 <fd_alloc+0x72>
  80111f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801124:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801129:	75 b6                	jne    8010e1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801134:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801141:	83 f8 1f             	cmp    $0x1f,%eax
  801144:	77 36                	ja     80117c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801146:	c1 e0 0c             	shl    $0xc,%eax
  801149:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80114e:	89 c2                	mov    %eax,%edx
  801150:	c1 ea 16             	shr    $0x16,%edx
  801153:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80115a:	f6 c2 01             	test   $0x1,%dl
  80115d:	74 24                	je     801183 <fd_lookup+0x48>
  80115f:	89 c2                	mov    %eax,%edx
  801161:	c1 ea 0c             	shr    $0xc,%edx
  801164:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80116b:	f6 c2 01             	test   $0x1,%dl
  80116e:	74 1a                	je     80118a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801170:	8b 55 0c             	mov    0xc(%ebp),%edx
  801173:	89 02                	mov    %eax,(%edx)
	return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 13                	jmp    80118f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80117c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801181:	eb 0c                	jmp    80118f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801183:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801188:	eb 05                	jmp    80118f <fd_lookup+0x54>
  80118a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	53                   	push   %ebx
  801195:	83 ec 14             	sub    $0x14,%esp
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80119e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8011a4:	75 1e                	jne    8011c4 <dev_lookup+0x33>
  8011a6:	eb 0e                	jmp    8011b6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011a8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8011ad:	eb 0c                	jmp    8011bb <dev_lookup+0x2a>
  8011af:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8011b4:	eb 05                	jmp    8011bb <dev_lookup+0x2a>
  8011b6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8011bb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8011bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c2:	eb 38                	jmp    8011fc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011c4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8011ca:	74 dc                	je     8011a8 <dev_lookup+0x17>
  8011cc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8011d2:	74 db                	je     8011af <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011d4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011da:	8b 52 48             	mov    0x48(%edx),%edx
  8011dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011e5:	c7 04 24 40 26 80 00 	movl   $0x802640,(%esp)
  8011ec:	e8 79 f0 ff ff       	call   80026a <cprintf>
	*dev = 0;
  8011f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011fc:	83 c4 14             	add    $0x14,%esp
  8011ff:	5b                   	pop    %ebx
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	56                   	push   %esi
  801206:	53                   	push   %ebx
  801207:	83 ec 20             	sub    $0x20,%esp
  80120a:	8b 75 08             	mov    0x8(%ebp),%esi
  80120d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801210:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801213:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801217:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80121d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801220:	89 04 24             	mov    %eax,(%esp)
  801223:	e8 13 ff ff ff       	call   80113b <fd_lookup>
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 05                	js     801231 <fd_close+0x2f>
	    || fd != fd2)
  80122c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80122f:	74 0c                	je     80123d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801231:	84 db                	test   %bl,%bl
  801233:	ba 00 00 00 00       	mov    $0x0,%edx
  801238:	0f 44 c2             	cmove  %edx,%eax
  80123b:	eb 3f                	jmp    80127c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80123d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801240:	89 44 24 04          	mov    %eax,0x4(%esp)
  801244:	8b 06                	mov    (%esi),%eax
  801246:	89 04 24             	mov    %eax,(%esp)
  801249:	e8 43 ff ff ff       	call   801191 <dev_lookup>
  80124e:	89 c3                	mov    %eax,%ebx
  801250:	85 c0                	test   %eax,%eax
  801252:	78 16                	js     80126a <fd_close+0x68>
		if (dev->dev_close)
  801254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801257:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80125a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80125f:	85 c0                	test   %eax,%eax
  801261:	74 07                	je     80126a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801263:	89 34 24             	mov    %esi,(%esp)
  801266:	ff d0                	call   *%eax
  801268:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80126a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801275:	e8 a6 fb ff ff       	call   800e20 <sys_page_unmap>
	return r;
  80127a:	89 d8                	mov    %ebx,%eax
}
  80127c:	83 c4 20             	add    $0x20,%esp
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801289:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 04 24             	mov    %eax,(%esp)
  801296:	e8 a0 fe ff ff       	call   80113b <fd_lookup>
  80129b:	89 c2                	mov    %eax,%edx
  80129d:	85 d2                	test   %edx,%edx
  80129f:	78 13                	js     8012b4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012a8:	00 
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	89 04 24             	mov    %eax,(%esp)
  8012af:	e8 4e ff ff ff       	call   801202 <fd_close>
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <close_all>:

void
close_all(void)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	53                   	push   %ebx
  8012ba:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012c2:	89 1c 24             	mov    %ebx,(%esp)
  8012c5:	e8 b9 ff ff ff       	call   801283 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ca:	83 c3 01             	add    $0x1,%ebx
  8012cd:	83 fb 20             	cmp    $0x20,%ebx
  8012d0:	75 f0                	jne    8012c2 <close_all+0xc>
		close(i);
}
  8012d2:	83 c4 14             	add    $0x14,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	57                   	push   %edi
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 48 fe ff ff       	call   80113b <fd_lookup>
  8012f3:	89 c2                	mov    %eax,%edx
  8012f5:	85 d2                	test   %edx,%edx
  8012f7:	0f 88 e1 00 00 00    	js     8013de <dup+0x106>
		return r;
	close(newfdnum);
  8012fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801300:	89 04 24             	mov    %eax,(%esp)
  801303:	e8 7b ff ff ff       	call   801283 <close>

	newfd = INDEX2FD(newfdnum);
  801308:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80130b:	c1 e3 0c             	shl    $0xc,%ebx
  80130e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801317:	89 04 24             	mov    %eax,(%esp)
  80131a:	e8 91 fd ff ff       	call   8010b0 <fd2data>
  80131f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801321:	89 1c 24             	mov    %ebx,(%esp)
  801324:	e8 87 fd ff ff       	call   8010b0 <fd2data>
  801329:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80132b:	89 f0                	mov    %esi,%eax
  80132d:	c1 e8 16             	shr    $0x16,%eax
  801330:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801337:	a8 01                	test   $0x1,%al
  801339:	74 43                	je     80137e <dup+0xa6>
  80133b:	89 f0                	mov    %esi,%eax
  80133d:	c1 e8 0c             	shr    $0xc,%eax
  801340:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801347:	f6 c2 01             	test   $0x1,%dl
  80134a:	74 32                	je     80137e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801353:	25 07 0e 00 00       	and    $0xe07,%eax
  801358:	89 44 24 10          	mov    %eax,0x10(%esp)
  80135c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801360:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801367:	00 
  801368:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801373:	e8 55 fa ff ff       	call   800dcd <sys_page_map>
  801378:	89 c6                	mov    %eax,%esi
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 3e                	js     8013bc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80137e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801381:	89 c2                	mov    %eax,%edx
  801383:	c1 ea 0c             	shr    $0xc,%edx
  801386:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801393:	89 54 24 10          	mov    %edx,0x10(%esp)
  801397:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80139b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013a2:	00 
  8013a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ae:	e8 1a fa ff ff       	call   800dcd <sys_page_map>
  8013b3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b8:	85 f6                	test   %esi,%esi
  8013ba:	79 22                	jns    8013de <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c7:	e8 54 fa ff ff       	call   800e20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d7:	e8 44 fa ff ff       	call   800e20 <sys_page_unmap>
	return r;
  8013dc:	89 f0                	mov    %esi,%eax
}
  8013de:	83 c4 3c             	add    $0x3c,%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5e                   	pop    %esi
  8013e3:	5f                   	pop    %edi
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    

008013e6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	53                   	push   %ebx
  8013ea:	83 ec 24             	sub    $0x24,%esp
  8013ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f7:	89 1c 24             	mov    %ebx,(%esp)
  8013fa:	e8 3c fd ff ff       	call   80113b <fd_lookup>
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	85 d2                	test   %edx,%edx
  801403:	78 6d                	js     801472 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801405:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801408:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	89 04 24             	mov    %eax,(%esp)
  801414:	e8 78 fd ff ff       	call   801191 <dev_lookup>
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 55                	js     801472 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	8b 50 08             	mov    0x8(%eax),%edx
  801423:	83 e2 03             	and    $0x3,%edx
  801426:	83 fa 01             	cmp    $0x1,%edx
  801429:	75 23                	jne    80144e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80142b:	a1 04 40 80 00       	mov    0x804004,%eax
  801430:	8b 40 48             	mov    0x48(%eax),%eax
  801433:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143b:	c7 04 24 84 26 80 00 	movl   $0x802684,(%esp)
  801442:	e8 23 ee ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb 24                	jmp    801472 <read+0x8c>
	}
	if (!dev->dev_read)
  80144e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801451:	8b 52 08             	mov    0x8(%edx),%edx
  801454:	85 d2                	test   %edx,%edx
  801456:	74 15                	je     80146d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801458:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80145f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801462:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801466:	89 04 24             	mov    %eax,(%esp)
  801469:	ff d2                	call   *%edx
  80146b:	eb 05                	jmp    801472 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80146d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801472:	83 c4 24             	add    $0x24,%esp
  801475:	5b                   	pop    %ebx
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    

00801478 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	57                   	push   %edi
  80147c:	56                   	push   %esi
  80147d:	53                   	push   %ebx
  80147e:	83 ec 1c             	sub    $0x1c,%esp
  801481:	8b 7d 08             	mov    0x8(%ebp),%edi
  801484:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801487:	85 f6                	test   %esi,%esi
  801489:	74 33                	je     8014be <readn+0x46>
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
  801490:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801495:	89 f2                	mov    %esi,%edx
  801497:	29 c2                	sub    %eax,%edx
  801499:	89 54 24 08          	mov    %edx,0x8(%esp)
  80149d:	03 45 0c             	add    0xc(%ebp),%eax
  8014a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a4:	89 3c 24             	mov    %edi,(%esp)
  8014a7:	e8 3a ff ff ff       	call   8013e6 <read>
		if (m < 0)
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 1b                	js     8014cb <readn+0x53>
			return m;
		if (m == 0)
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 11                	je     8014c5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b4:	01 c3                	add    %eax,%ebx
  8014b6:	89 d8                	mov    %ebx,%eax
  8014b8:	39 f3                	cmp    %esi,%ebx
  8014ba:	72 d9                	jb     801495 <readn+0x1d>
  8014bc:	eb 0b                	jmp    8014c9 <readn+0x51>
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb 06                	jmp    8014cb <readn+0x53>
  8014c5:	89 d8                	mov    %ebx,%eax
  8014c7:	eb 02                	jmp    8014cb <readn+0x53>
  8014c9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014cb:	83 c4 1c             	add    $0x1c,%esp
  8014ce:	5b                   	pop    %ebx
  8014cf:	5e                   	pop    %esi
  8014d0:	5f                   	pop    %edi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 24             	sub    $0x24,%esp
  8014da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e4:	89 1c 24             	mov    %ebx,(%esp)
  8014e7:	e8 4f fc ff ff       	call   80113b <fd_lookup>
  8014ec:	89 c2                	mov    %eax,%edx
  8014ee:	85 d2                	test   %edx,%edx
  8014f0:	78 68                	js     80155a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	89 04 24             	mov    %eax,(%esp)
  801501:	e8 8b fc ff ff       	call   801191 <dev_lookup>
  801506:	85 c0                	test   %eax,%eax
  801508:	78 50                	js     80155a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801511:	75 23                	jne    801536 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801513:	a1 04 40 80 00       	mov    0x804004,%eax
  801518:	8b 40 48             	mov    0x48(%eax),%eax
  80151b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  80152a:	e8 3b ed ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80152f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801534:	eb 24                	jmp    80155a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801536:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801539:	8b 52 0c             	mov    0xc(%edx),%edx
  80153c:	85 d2                	test   %edx,%edx
  80153e:	74 15                	je     801555 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801540:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80154e:	89 04 24             	mov    %eax,(%esp)
  801551:	ff d2                	call   *%edx
  801553:	eb 05                	jmp    80155a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801555:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80155a:	83 c4 24             	add    $0x24,%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <seek>:

int
seek(int fdnum, off_t offset)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801566:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	89 04 24             	mov    %eax,(%esp)
  801573:	e8 c3 fb ff ff       	call   80113b <fd_lookup>
  801578:	85 c0                	test   %eax,%eax
  80157a:	78 0e                	js     80158a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80157c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	53                   	push   %ebx
  801590:	83 ec 24             	sub    $0x24,%esp
  801593:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801596:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159d:	89 1c 24             	mov    %ebx,(%esp)
  8015a0:	e8 96 fb ff ff       	call   80113b <fd_lookup>
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	85 d2                	test   %edx,%edx
  8015a9:	78 61                	js     80160c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	89 04 24             	mov    %eax,(%esp)
  8015ba:	e8 d2 fb ff ff       	call   801191 <dev_lookup>
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 49                	js     80160c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ca:	75 23                	jne    8015ef <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015cc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d1:	8b 40 48             	mov    0x48(%eax),%eax
  8015d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015dc:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  8015e3:	e8 82 ec ff ff       	call   80026a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ed:	eb 1d                	jmp    80160c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f2:	8b 52 18             	mov    0x18(%edx),%edx
  8015f5:	85 d2                	test   %edx,%edx
  8015f7:	74 0e                	je     801607 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801600:	89 04 24             	mov    %eax,(%esp)
  801603:	ff d2                	call   *%edx
  801605:	eb 05                	jmp    80160c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801607:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80160c:	83 c4 24             	add    $0x24,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 24             	sub    $0x24,%esp
  801619:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	89 04 24             	mov    %eax,(%esp)
  801629:	e8 0d fb ff ff       	call   80113b <fd_lookup>
  80162e:	89 c2                	mov    %eax,%edx
  801630:	85 d2                	test   %edx,%edx
  801632:	78 52                	js     801686 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	89 04 24             	mov    %eax,(%esp)
  801643:	e8 49 fb ff ff       	call   801191 <dev_lookup>
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 3a                	js     801686 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801653:	74 2c                	je     801681 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801655:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801658:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165f:	00 00 00 
	stat->st_isdir = 0;
  801662:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801669:	00 00 00 
	stat->st_dev = dev;
  80166c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801672:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801676:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801679:	89 14 24             	mov    %edx,(%esp)
  80167c:	ff 50 14             	call   *0x14(%eax)
  80167f:	eb 05                	jmp    801686 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801681:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801686:	83 c4 24             	add    $0x24,%esp
  801689:	5b                   	pop    %ebx
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
  801691:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801694:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80169b:	00 
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	89 04 24             	mov    %eax,(%esp)
  8016a2:	e8 af 01 00 00       	call   801856 <open>
  8016a7:	89 c3                	mov    %eax,%ebx
  8016a9:	85 db                	test   %ebx,%ebx
  8016ab:	78 1b                	js     8016c8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	89 1c 24             	mov    %ebx,(%esp)
  8016b7:	e8 56 ff ff ff       	call   801612 <fstat>
  8016bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8016be:	89 1c 24             	mov    %ebx,(%esp)
  8016c1:	e8 bd fb ff ff       	call   801283 <close>
	return r;
  8016c6:	89 f0                	mov    %esi,%eax
}
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 10             	sub    $0x10,%esp
  8016d7:	89 c6                	mov    %eax,%esi
  8016d9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016e2:	75 11                	jne    8016f5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016eb:	e8 26 08 00 00       	call   801f16 <ipc_find_env>
  8016f0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016f5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016fc:	00 
  8016fd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801704:	00 
  801705:	89 74 24 04          	mov    %esi,0x4(%esp)
  801709:	a1 00 40 80 00       	mov    0x804000,%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 9a 07 00 00       	call   801eb0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801716:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80171d:	00 
  80171e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801722:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801729:	e8 18 07 00 00       	call   801e46 <ipc_recv>
}
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 14             	sub    $0x14,%esp
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 05 00 00 00       	mov    $0x5,%eax
  801754:	e8 76 ff ff ff       	call   8016cf <fsipc>
  801759:	89 c2                	mov    %eax,%edx
  80175b:	85 d2                	test   %edx,%edx
  80175d:	78 2b                	js     80178a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801766:	00 
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 5c f1 ff ff       	call   8008cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80176f:	a1 80 50 80 00       	mov    0x805080,%eax
  801774:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80177a:	a1 84 50 80 00       	mov    0x805084,%eax
  80177f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178a:	83 c4 14             	add    $0x14,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8b 40 0c             	mov    0xc(%eax),%eax
  80179c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ab:	e8 1f ff ff ff       	call   8016cf <fsipc>
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	56                   	push   %esi
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 10             	sub    $0x10,%esp
  8017ba:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d8:	e8 f2 fe ff ff       	call   8016cf <fsipc>
  8017dd:	89 c3                	mov    %eax,%ebx
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 6a                	js     80184d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017e3:	39 c6                	cmp    %eax,%esi
  8017e5:	73 24                	jae    80180b <devfile_read+0x59>
  8017e7:	c7 44 24 0c bd 26 80 	movl   $0x8026bd,0xc(%esp)
  8017ee:	00 
  8017ef:	c7 44 24 08 c4 26 80 	movl   $0x8026c4,0x8(%esp)
  8017f6:	00 
  8017f7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8017fe:	00 
  8017ff:	c7 04 24 d9 26 80 00 	movl   $0x8026d9,(%esp)
  801806:	e8 66 e9 ff ff       	call   800171 <_panic>
	assert(r <= PGSIZE);
  80180b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801810:	7e 24                	jle    801836 <devfile_read+0x84>
  801812:	c7 44 24 0c e4 26 80 	movl   $0x8026e4,0xc(%esp)
  801819:	00 
  80181a:	c7 44 24 08 c4 26 80 	movl   $0x8026c4,0x8(%esp)
  801821:	00 
  801822:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801829:	00 
  80182a:	c7 04 24 d9 26 80 00 	movl   $0x8026d9,(%esp)
  801831:	e8 3b e9 ff ff       	call   800171 <_panic>
	memmove(buf, &fsipcbuf, r);
  801836:	89 44 24 08          	mov    %eax,0x8(%esp)
  80183a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801841:	00 
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	89 04 24             	mov    %eax,(%esp)
  801848:	e8 79 f2 ff ff       	call   800ac6 <memmove>
	return r;
}
  80184d:	89 d8                	mov    %ebx,%eax
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	5b                   	pop    %ebx
  801853:	5e                   	pop    %esi
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 24             	sub    $0x24,%esp
  80185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801860:	89 1c 24             	mov    %ebx,(%esp)
  801863:	e8 08 f0 ff ff       	call   800870 <strlen>
  801868:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186d:	7f 60                	jg     8018cf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80186f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801872:	89 04 24             	mov    %eax,(%esp)
  801875:	e8 4d f8 ff ff       	call   8010c7 <fd_alloc>
  80187a:	89 c2                	mov    %eax,%edx
  80187c:	85 d2                	test   %edx,%edx
  80187e:	78 54                	js     8018d4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801884:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80188b:	e8 3b f0 ff ff       	call   8008cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801890:	8b 45 0c             	mov    0xc(%ebp),%eax
  801893:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189b:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a0:	e8 2a fe ff ff       	call   8016cf <fsipc>
  8018a5:	89 c3                	mov    %eax,%ebx
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	79 17                	jns    8018c2 <open+0x6c>
		fd_close(fd, 0);
  8018ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018b2:	00 
  8018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b6:	89 04 24             	mov    %eax,(%esp)
  8018b9:	e8 44 f9 ff ff       	call   801202 <fd_close>
		return r;
  8018be:	89 d8                	mov    %ebx,%eax
  8018c0:	eb 12                	jmp    8018d4 <open+0x7e>
	}

	return fd2num(fd);
  8018c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c5:	89 04 24             	mov    %eax,(%esp)
  8018c8:	e8 d3 f7 ff ff       	call   8010a0 <fd2num>
  8018cd:	eb 05                	jmp    8018d4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018cf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018d4:	83 c4 24             	add    $0x24,%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    
  8018da:	66 90                	xchg   %ax,%ax
  8018dc:	66 90                	xchg   %ax,%ax
  8018de:	66 90                	xchg   %ax,%ax

008018e0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
  8018e5:	83 ec 10             	sub    $0x10,%esp
  8018e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	89 04 24             	mov    %eax,(%esp)
  8018f1:	e8 ba f7 ff ff       	call   8010b0 <fd2data>
  8018f6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018f8:	c7 44 24 04 f0 26 80 	movl   $0x8026f0,0x4(%esp)
  8018ff:	00 
  801900:	89 1c 24             	mov    %ebx,(%esp)
  801903:	e8 c3 ef ff ff       	call   8008cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801908:	8b 46 04             	mov    0x4(%esi),%eax
  80190b:	2b 06                	sub    (%esi),%eax
  80190d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801913:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80191a:	00 00 00 
	stat->st_dev = &devpipe;
  80191d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801924:	30 80 00 
	return 0;
}
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	53                   	push   %ebx
  801937:	83 ec 14             	sub    $0x14,%esp
  80193a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80193d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801941:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801948:	e8 d3 f4 ff ff       	call   800e20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80194d:	89 1c 24             	mov    %ebx,(%esp)
  801950:	e8 5b f7 ff ff       	call   8010b0 <fd2data>
  801955:	89 44 24 04          	mov    %eax,0x4(%esp)
  801959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801960:	e8 bb f4 ff ff       	call   800e20 <sys_page_unmap>
}
  801965:	83 c4 14             	add    $0x14,%esp
  801968:	5b                   	pop    %ebx
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	57                   	push   %edi
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	83 ec 2c             	sub    $0x2c,%esp
  801974:	89 c6                	mov    %eax,%esi
  801976:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801979:	a1 04 40 80 00       	mov    0x804004,%eax
  80197e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801981:	89 34 24             	mov    %esi,(%esp)
  801984:	e8 d5 05 00 00       	call   801f5e <pageref>
  801989:	89 c7                	mov    %eax,%edi
  80198b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198e:	89 04 24             	mov    %eax,(%esp)
  801991:	e8 c8 05 00 00       	call   801f5e <pageref>
  801996:	39 c7                	cmp    %eax,%edi
  801998:	0f 94 c2             	sete   %dl
  80199b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80199e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  8019a4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8019a7:	39 fb                	cmp    %edi,%ebx
  8019a9:	74 21                	je     8019cc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8019ab:	84 d2                	test   %dl,%dl
  8019ad:	74 ca                	je     801979 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019af:	8b 51 58             	mov    0x58(%ecx),%edx
  8019b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019be:	c7 04 24 f7 26 80 00 	movl   $0x8026f7,(%esp)
  8019c5:	e8 a0 e8 ff ff       	call   80026a <cprintf>
  8019ca:	eb ad                	jmp    801979 <_pipeisclosed+0xe>
	}
}
  8019cc:	83 c4 2c             	add    $0x2c,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	57                   	push   %edi
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 1c             	sub    $0x1c,%esp
  8019dd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019e0:	89 34 24             	mov    %esi,(%esp)
  8019e3:	e8 c8 f6 ff ff       	call   8010b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ec:	74 61                	je     801a4f <devpipe_write+0x7b>
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f5:	eb 4a                	jmp    801a41 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019f7:	89 da                	mov    %ebx,%edx
  8019f9:	89 f0                	mov    %esi,%eax
  8019fb:	e8 6b ff ff ff       	call   80196b <_pipeisclosed>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	75 54                	jne    801a58 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a04:	e8 51 f3 ff ff       	call   800d5a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a09:	8b 43 04             	mov    0x4(%ebx),%eax
  801a0c:	8b 0b                	mov    (%ebx),%ecx
  801a0e:	8d 51 20             	lea    0x20(%ecx),%edx
  801a11:	39 d0                	cmp    %edx,%eax
  801a13:	73 e2                	jae    8019f7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a18:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a1c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a1f:	99                   	cltd   
  801a20:	c1 ea 1b             	shr    $0x1b,%edx
  801a23:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a26:	83 e1 1f             	and    $0x1f,%ecx
  801a29:	29 d1                	sub    %edx,%ecx
  801a2b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a2f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a33:	83 c0 01             	add    $0x1,%eax
  801a36:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a39:	83 c7 01             	add    $0x1,%edi
  801a3c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a3f:	74 13                	je     801a54 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a41:	8b 43 04             	mov    0x4(%ebx),%eax
  801a44:	8b 0b                	mov    (%ebx),%ecx
  801a46:	8d 51 20             	lea    0x20(%ecx),%edx
  801a49:	39 d0                	cmp    %edx,%eax
  801a4b:	73 aa                	jae    8019f7 <devpipe_write+0x23>
  801a4d:	eb c6                	jmp    801a15 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a4f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a54:	89 f8                	mov    %edi,%eax
  801a56:	eb 05                	jmp    801a5d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a5d:	83 c4 1c             	add    $0x1c,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	57                   	push   %edi
  801a69:	56                   	push   %esi
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 1c             	sub    $0x1c,%esp
  801a6e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a71:	89 3c 24             	mov    %edi,(%esp)
  801a74:	e8 37 f6 ff ff       	call   8010b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a7d:	74 54                	je     801ad3 <devpipe_read+0x6e>
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	be 00 00 00 00       	mov    $0x0,%esi
  801a86:	eb 3e                	jmp    801ac6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a88:	89 f0                	mov    %esi,%eax
  801a8a:	eb 55                	jmp    801ae1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a8c:	89 da                	mov    %ebx,%edx
  801a8e:	89 f8                	mov    %edi,%eax
  801a90:	e8 d6 fe ff ff       	call   80196b <_pipeisclosed>
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 43                	jne    801adc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a99:	e8 bc f2 ff ff       	call   800d5a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a9e:	8b 03                	mov    (%ebx),%eax
  801aa0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801aa3:	74 e7                	je     801a8c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801aa5:	99                   	cltd   
  801aa6:	c1 ea 1b             	shr    $0x1b,%edx
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	83 e0 1f             	and    $0x1f,%eax
  801aae:	29 d0                	sub    %edx,%eax
  801ab0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801abb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801abe:	83 c6 01             	add    $0x1,%esi
  801ac1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ac4:	74 12                	je     801ad8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ac6:	8b 03                	mov    (%ebx),%eax
  801ac8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801acb:	75 d8                	jne    801aa5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801acd:	85 f6                	test   %esi,%esi
  801acf:	75 b7                	jne    801a88 <devpipe_read+0x23>
  801ad1:	eb b9                	jmp    801a8c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ad3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ad8:	89 f0                	mov    %esi,%eax
  801ada:	eb 05                	jmp    801ae1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ae1:	83 c4 1c             	add    $0x1c,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
  801aee:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801af1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 cb f5 ff ff       	call   8010c7 <fd_alloc>
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	85 d2                	test   %edx,%edx
  801b00:	0f 88 4d 01 00 00    	js     801c53 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b0d:	00 
  801b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1c:	e8 58 f2 ff ff       	call   800d79 <sys_page_alloc>
  801b21:	89 c2                	mov    %eax,%edx
  801b23:	85 d2                	test   %edx,%edx
  801b25:	0f 88 28 01 00 00    	js     801c53 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2e:	89 04 24             	mov    %eax,(%esp)
  801b31:	e8 91 f5 ff ff       	call   8010c7 <fd_alloc>
  801b36:	89 c3                	mov    %eax,%ebx
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	0f 88 fe 00 00 00    	js     801c3e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b40:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b47:	00 
  801b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b56:	e8 1e f2 ff ff       	call   800d79 <sys_page_alloc>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	0f 88 d9 00 00 00    	js     801c3e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	89 04 24             	mov    %eax,(%esp)
  801b6b:	e8 40 f5 ff ff       	call   8010b0 <fd2data>
  801b70:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b79:	00 
  801b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b85:	e8 ef f1 ff ff       	call   800d79 <sys_page_alloc>
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	0f 88 97 00 00 00    	js     801c2b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	89 04 24             	mov    %eax,(%esp)
  801b9a:	e8 11 f5 ff ff       	call   8010b0 <fd2data>
  801b9f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801ba6:	00 
  801ba7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bb2:	00 
  801bb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bbe:	e8 0a f2 ff ff       	call   800dcd <sys_page_map>
  801bc3:	89 c3                	mov    %eax,%ebx
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 52                	js     801c1b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801bc9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801bde:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf6:	89 04 24             	mov    %eax,(%esp)
  801bf9:	e8 a2 f4 ff ff       	call   8010a0 <fd2num>
  801bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c01:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 92 f4 ff ff       	call   8010a0 <fd2num>
  801c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c11:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 38                	jmp    801c53 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801c1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c26:	e8 f5 f1 ff ff       	call   800e20 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c39:	e8 e2 f1 ff ff       	call   800e20 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4c:	e8 cf f1 ff ff       	call   800e20 <sys_page_unmap>
  801c51:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801c53:	83 c4 30             	add    $0x30,%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	89 04 24             	mov    %eax,(%esp)
  801c6d:	e8 c9 f4 ff ff       	call   80113b <fd_lookup>
  801c72:	89 c2                	mov    %eax,%edx
  801c74:	85 d2                	test   %edx,%edx
  801c76:	78 15                	js     801c8d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 2d f4 ff ff       	call   8010b0 <fd2data>
	return _pipeisclosed(fd, p);
  801c83:	89 c2                	mov    %eax,%edx
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c88:	e8 de fc ff ff       	call   80196b <_pipeisclosed>
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    
  801c8f:	90                   	nop

00801c90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ca0:	c7 44 24 04 0f 27 80 	movl   $0x80270f,0x4(%esp)
  801ca7:	00 
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	89 04 24             	mov    %eax,(%esp)
  801cae:	e8 18 ec ff ff       	call   8008cb <strcpy>
	return 0;
}
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	57                   	push   %edi
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cca:	74 4a                	je     801d16 <devcons_write+0x5c>
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cd6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cdc:	8b 75 10             	mov    0x10(%ebp),%esi
  801cdf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801ce1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ce4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ce9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cec:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cf0:	03 45 0c             	add    0xc(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	89 3c 24             	mov    %edi,(%esp)
  801cfa:	e8 c7 ed ff ff       	call   800ac6 <memmove>
		sys_cputs(buf, m);
  801cff:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d03:	89 3c 24             	mov    %edi,(%esp)
  801d06:	e8 a1 ef ff ff       	call   800cac <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d0b:	01 f3                	add    %esi,%ebx
  801d0d:	89 d8                	mov    %ebx,%eax
  801d0f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d12:	72 c8                	jb     801cdc <devcons_write+0x22>
  801d14:	eb 05                	jmp    801d1b <devcons_write+0x61>
  801d16:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d37:	75 07                	jne    801d40 <devcons_read+0x18>
  801d39:	eb 28                	jmp    801d63 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d3b:	e8 1a f0 ff ff       	call   800d5a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d40:	e8 85 ef ff ff       	call   800cca <sys_cgetc>
  801d45:	85 c0                	test   %eax,%eax
  801d47:	74 f2                	je     801d3b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 16                	js     801d63 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d4d:	83 f8 04             	cmp    $0x4,%eax
  801d50:	74 0c                	je     801d5e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	88 02                	mov    %al,(%edx)
	return 1;
  801d57:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5c:	eb 05                	jmp    801d63 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d78:	00 
  801d79:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d7c:	89 04 24             	mov    %eax,(%esp)
  801d7f:	e8 28 ef ff ff       	call   800cac <sys_cputs>
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <getchar>:

int
getchar(void)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d8c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d93:	00 
  801d94:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da2:	e8 3f f6 ff ff       	call   8013e6 <read>
	if (r < 0)
  801da7:	85 c0                	test   %eax,%eax
  801da9:	78 0f                	js     801dba <getchar+0x34>
		return r;
	if (r < 1)
  801dab:	85 c0                	test   %eax,%eax
  801dad:	7e 06                	jle    801db5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801daf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801db3:	eb 05                	jmp    801dba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801db5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	89 04 24             	mov    %eax,(%esp)
  801dcf:	e8 67 f3 ff ff       	call   80113b <fd_lookup>
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 11                	js     801de9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801de1:	39 10                	cmp    %edx,(%eax)
  801de3:	0f 94 c0             	sete   %al
  801de6:	0f b6 c0             	movzbl %al,%eax
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <opencons>:

int
opencons(void)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801df1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df4:	89 04 24             	mov    %eax,(%esp)
  801df7:	e8 cb f2 ff ff       	call   8010c7 <fd_alloc>
		return r;
  801dfc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 40                	js     801e42 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e09:	00 
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e18:	e8 5c ef ff ff       	call   800d79 <sys_page_alloc>
		return r;
  801e1d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 1f                	js     801e42 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e23:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 60 f2 ff ff       	call   8010a0 <fd2num>
  801e40:	89 c2                	mov    %eax,%edx
}
  801e42:	89 d0                	mov    %edx,%eax
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	83 ec 10             	sub    $0x10,%esp
  801e4e:	8b 75 08             	mov    0x8(%ebp),%esi
  801e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801e57:	83 f8 01             	cmp    $0x1,%eax
  801e5a:	19 c0                	sbb    %eax,%eax
  801e5c:	f7 d0                	not    %eax
  801e5e:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 24 f1 ff ff       	call   800f8f <sys_ipc_recv>
	if (err_code < 0) {
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	79 16                	jns    801e85 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801e6f:	85 f6                	test   %esi,%esi
  801e71:	74 06                	je     801e79 <ipc_recv+0x33>
  801e73:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e79:	85 db                	test   %ebx,%ebx
  801e7b:	74 2c                	je     801ea9 <ipc_recv+0x63>
  801e7d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e83:	eb 24                	jmp    801ea9 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e85:	85 f6                	test   %esi,%esi
  801e87:	74 0a                	je     801e93 <ipc_recv+0x4d>
  801e89:	a1 04 40 80 00       	mov    0x804004,%eax
  801e8e:	8b 40 74             	mov    0x74(%eax),%eax
  801e91:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e93:	85 db                	test   %ebx,%ebx
  801e95:	74 0a                	je     801ea1 <ipc_recv+0x5b>
  801e97:	a1 04 40 80 00       	mov    0x804004,%eax
  801e9c:	8b 40 78             	mov    0x78(%eax),%eax
  801e9f:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801ea1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ea6:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	57                   	push   %edi
  801eb4:	56                   	push   %esi
  801eb5:	53                   	push   %ebx
  801eb6:	83 ec 1c             	sub    $0x1c,%esp
  801eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ebf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ec2:	eb 25                	jmp    801ee9 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801ec4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ec7:	74 20                	je     801ee9 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801ec9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ecd:	c7 44 24 08 1b 27 80 	movl   $0x80271b,0x8(%esp)
  801ed4:	00 
  801ed5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801edc:	00 
  801edd:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  801ee4:	e8 88 e2 ff ff       	call   800171 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ee9:	85 db                	test   %ebx,%ebx
  801eeb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ef0:	0f 45 c3             	cmovne %ebx,%eax
  801ef3:	8b 55 14             	mov    0x14(%ebp),%edx
  801ef6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801efa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f02:	89 3c 24             	mov    %edi,(%esp)
  801f05:	e8 62 f0 ff ff       	call   800f6c <sys_ipc_try_send>
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	75 b6                	jne    801ec4 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801f0e:	83 c4 1c             	add    $0x1c,%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5f                   	pop    %edi
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    

00801f16 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f1c:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f21:	39 c8                	cmp    %ecx,%eax
  801f23:	74 17                	je     801f3c <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f2a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f2d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f33:	8b 52 50             	mov    0x50(%edx),%edx
  801f36:	39 ca                	cmp    %ecx,%edx
  801f38:	75 14                	jne    801f4e <ipc_find_env+0x38>
  801f3a:	eb 05                	jmp    801f41 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f41:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f44:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f49:	8b 40 40             	mov    0x40(%eax),%eax
  801f4c:	eb 0e                	jmp    801f5c <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f4e:	83 c0 01             	add    $0x1,%eax
  801f51:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f56:	75 d2                	jne    801f2a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f58:	66 b8 00 00          	mov    $0x0,%ax
}
  801f5c:	5d                   	pop    %ebp
  801f5d:	c3                   	ret    

00801f5e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	c1 e8 16             	shr    $0x16,%eax
  801f69:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f75:	f6 c1 01             	test   $0x1,%cl
  801f78:	74 1d                	je     801f97 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f7a:	c1 ea 0c             	shr    $0xc,%edx
  801f7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f84:	f6 c2 01             	test   $0x1,%dl
  801f87:	74 0e                	je     801f97 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f89:	c1 ea 0c             	shr    $0xc,%edx
  801f8c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f93:	ef 
  801f94:	0f b7 c0             	movzwl %ax,%eax
}
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    
  801f99:	66 90                	xchg   %ax,%ax
  801f9b:	66 90                	xchg   %ax,%ax
  801f9d:	66 90                	xchg   %ax,%ax
  801f9f:	90                   	nop

00801fa0 <__udivdi3>:
  801fa0:	55                   	push   %ebp
  801fa1:	57                   	push   %edi
  801fa2:	56                   	push   %esi
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801faa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801fae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801fb2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fbc:	89 ea                	mov    %ebp,%edx
  801fbe:	89 0c 24             	mov    %ecx,(%esp)
  801fc1:	75 2d                	jne    801ff0 <__udivdi3+0x50>
  801fc3:	39 e9                	cmp    %ebp,%ecx
  801fc5:	77 61                	ja     802028 <__udivdi3+0x88>
  801fc7:	85 c9                	test   %ecx,%ecx
  801fc9:	89 ce                	mov    %ecx,%esi
  801fcb:	75 0b                	jne    801fd8 <__udivdi3+0x38>
  801fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd2:	31 d2                	xor    %edx,%edx
  801fd4:	f7 f1                	div    %ecx
  801fd6:	89 c6                	mov    %eax,%esi
  801fd8:	31 d2                	xor    %edx,%edx
  801fda:	89 e8                	mov    %ebp,%eax
  801fdc:	f7 f6                	div    %esi
  801fde:	89 c5                	mov    %eax,%ebp
  801fe0:	89 f8                	mov    %edi,%eax
  801fe2:	f7 f6                	div    %esi
  801fe4:	89 ea                	mov    %ebp,%edx
  801fe6:	83 c4 0c             	add    $0xc,%esp
  801fe9:	5e                   	pop    %esi
  801fea:	5f                   	pop    %edi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    
  801fed:	8d 76 00             	lea    0x0(%esi),%esi
  801ff0:	39 e8                	cmp    %ebp,%eax
  801ff2:	77 24                	ja     802018 <__udivdi3+0x78>
  801ff4:	0f bd e8             	bsr    %eax,%ebp
  801ff7:	83 f5 1f             	xor    $0x1f,%ebp
  801ffa:	75 3c                	jne    802038 <__udivdi3+0x98>
  801ffc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802000:	39 34 24             	cmp    %esi,(%esp)
  802003:	0f 86 9f 00 00 00    	jbe    8020a8 <__udivdi3+0x108>
  802009:	39 d0                	cmp    %edx,%eax
  80200b:	0f 82 97 00 00 00    	jb     8020a8 <__udivdi3+0x108>
  802011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802018:	31 d2                	xor    %edx,%edx
  80201a:	31 c0                	xor    %eax,%eax
  80201c:	83 c4 0c             	add    $0xc,%esp
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    
  802023:	90                   	nop
  802024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802028:	89 f8                	mov    %edi,%eax
  80202a:	f7 f1                	div    %ecx
  80202c:	31 d2                	xor    %edx,%edx
  80202e:	83 c4 0c             	add    $0xc,%esp
  802031:	5e                   	pop    %esi
  802032:	5f                   	pop    %edi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
  802035:	8d 76 00             	lea    0x0(%esi),%esi
  802038:	89 e9                	mov    %ebp,%ecx
  80203a:	8b 3c 24             	mov    (%esp),%edi
  80203d:	d3 e0                	shl    %cl,%eax
  80203f:	89 c6                	mov    %eax,%esi
  802041:	b8 20 00 00 00       	mov    $0x20,%eax
  802046:	29 e8                	sub    %ebp,%eax
  802048:	89 c1                	mov    %eax,%ecx
  80204a:	d3 ef                	shr    %cl,%edi
  80204c:	89 e9                	mov    %ebp,%ecx
  80204e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802052:	8b 3c 24             	mov    (%esp),%edi
  802055:	09 74 24 08          	or     %esi,0x8(%esp)
  802059:	89 d6                	mov    %edx,%esi
  80205b:	d3 e7                	shl    %cl,%edi
  80205d:	89 c1                	mov    %eax,%ecx
  80205f:	89 3c 24             	mov    %edi,(%esp)
  802062:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802066:	d3 ee                	shr    %cl,%esi
  802068:	89 e9                	mov    %ebp,%ecx
  80206a:	d3 e2                	shl    %cl,%edx
  80206c:	89 c1                	mov    %eax,%ecx
  80206e:	d3 ef                	shr    %cl,%edi
  802070:	09 d7                	or     %edx,%edi
  802072:	89 f2                	mov    %esi,%edx
  802074:	89 f8                	mov    %edi,%eax
  802076:	f7 74 24 08          	divl   0x8(%esp)
  80207a:	89 d6                	mov    %edx,%esi
  80207c:	89 c7                	mov    %eax,%edi
  80207e:	f7 24 24             	mull   (%esp)
  802081:	39 d6                	cmp    %edx,%esi
  802083:	89 14 24             	mov    %edx,(%esp)
  802086:	72 30                	jb     8020b8 <__udivdi3+0x118>
  802088:	8b 54 24 04          	mov    0x4(%esp),%edx
  80208c:	89 e9                	mov    %ebp,%ecx
  80208e:	d3 e2                	shl    %cl,%edx
  802090:	39 c2                	cmp    %eax,%edx
  802092:	73 05                	jae    802099 <__udivdi3+0xf9>
  802094:	3b 34 24             	cmp    (%esp),%esi
  802097:	74 1f                	je     8020b8 <__udivdi3+0x118>
  802099:	89 f8                	mov    %edi,%eax
  80209b:	31 d2                	xor    %edx,%edx
  80209d:	e9 7a ff ff ff       	jmp    80201c <__udivdi3+0x7c>
  8020a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020a8:	31 d2                	xor    %edx,%edx
  8020aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8020af:	e9 68 ff ff ff       	jmp    80201c <__udivdi3+0x7c>
  8020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8020bb:	31 d2                	xor    %edx,%edx
  8020bd:	83 c4 0c             	add    $0xc,%esp
  8020c0:	5e                   	pop    %esi
  8020c1:	5f                   	pop    %edi
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    
  8020c4:	66 90                	xchg   %ax,%ax
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	66 90                	xchg   %ax,%ax
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	66 90                	xchg   %ax,%ax
  8020ce:	66 90                	xchg   %ax,%ax

008020d0 <__umoddi3>:
  8020d0:	55                   	push   %ebp
  8020d1:	57                   	push   %edi
  8020d2:	56                   	push   %esi
  8020d3:	83 ec 14             	sub    $0x14,%esp
  8020d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8020da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8020de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8020e2:	89 c7                	mov    %eax,%edi
  8020e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8020ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8020f0:	89 34 24             	mov    %esi,(%esp)
  8020f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	89 c2                	mov    %eax,%edx
  8020fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ff:	75 17                	jne    802118 <__umoddi3+0x48>
  802101:	39 fe                	cmp    %edi,%esi
  802103:	76 4b                	jbe    802150 <__umoddi3+0x80>
  802105:	89 c8                	mov    %ecx,%eax
  802107:	89 fa                	mov    %edi,%edx
  802109:	f7 f6                	div    %esi
  80210b:	89 d0                	mov    %edx,%eax
  80210d:	31 d2                	xor    %edx,%edx
  80210f:	83 c4 14             	add    $0x14,%esp
  802112:	5e                   	pop    %esi
  802113:	5f                   	pop    %edi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    
  802116:	66 90                	xchg   %ax,%ax
  802118:	39 f8                	cmp    %edi,%eax
  80211a:	77 54                	ja     802170 <__umoddi3+0xa0>
  80211c:	0f bd e8             	bsr    %eax,%ebp
  80211f:	83 f5 1f             	xor    $0x1f,%ebp
  802122:	75 5c                	jne    802180 <__umoddi3+0xb0>
  802124:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802128:	39 3c 24             	cmp    %edi,(%esp)
  80212b:	0f 87 e7 00 00 00    	ja     802218 <__umoddi3+0x148>
  802131:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802135:	29 f1                	sub    %esi,%ecx
  802137:	19 c7                	sbb    %eax,%edi
  802139:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80213d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802141:	8b 44 24 08          	mov    0x8(%esp),%eax
  802145:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802149:	83 c4 14             	add    $0x14,%esp
  80214c:	5e                   	pop    %esi
  80214d:	5f                   	pop    %edi
  80214e:	5d                   	pop    %ebp
  80214f:	c3                   	ret    
  802150:	85 f6                	test   %esi,%esi
  802152:	89 f5                	mov    %esi,%ebp
  802154:	75 0b                	jne    802161 <__umoddi3+0x91>
  802156:	b8 01 00 00 00       	mov    $0x1,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	f7 f6                	div    %esi
  80215f:	89 c5                	mov    %eax,%ebp
  802161:	8b 44 24 04          	mov    0x4(%esp),%eax
  802165:	31 d2                	xor    %edx,%edx
  802167:	f7 f5                	div    %ebp
  802169:	89 c8                	mov    %ecx,%eax
  80216b:	f7 f5                	div    %ebp
  80216d:	eb 9c                	jmp    80210b <__umoddi3+0x3b>
  80216f:	90                   	nop
  802170:	89 c8                	mov    %ecx,%eax
  802172:	89 fa                	mov    %edi,%edx
  802174:	83 c4 14             	add    $0x14,%esp
  802177:	5e                   	pop    %esi
  802178:	5f                   	pop    %edi
  802179:	5d                   	pop    %ebp
  80217a:	c3                   	ret    
  80217b:	90                   	nop
  80217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802180:	8b 04 24             	mov    (%esp),%eax
  802183:	be 20 00 00 00       	mov    $0x20,%esi
  802188:	89 e9                	mov    %ebp,%ecx
  80218a:	29 ee                	sub    %ebp,%esi
  80218c:	d3 e2                	shl    %cl,%edx
  80218e:	89 f1                	mov    %esi,%ecx
  802190:	d3 e8                	shr    %cl,%eax
  802192:	89 e9                	mov    %ebp,%ecx
  802194:	89 44 24 04          	mov    %eax,0x4(%esp)
  802198:	8b 04 24             	mov    (%esp),%eax
  80219b:	09 54 24 04          	or     %edx,0x4(%esp)
  80219f:	89 fa                	mov    %edi,%edx
  8021a1:	d3 e0                	shl    %cl,%eax
  8021a3:	89 f1                	mov    %esi,%ecx
  8021a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8021ad:	d3 ea                	shr    %cl,%edx
  8021af:	89 e9                	mov    %ebp,%ecx
  8021b1:	d3 e7                	shl    %cl,%edi
  8021b3:	89 f1                	mov    %esi,%ecx
  8021b5:	d3 e8                	shr    %cl,%eax
  8021b7:	89 e9                	mov    %ebp,%ecx
  8021b9:	09 f8                	or     %edi,%eax
  8021bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8021bf:	f7 74 24 04          	divl   0x4(%esp)
  8021c3:	d3 e7                	shl    %cl,%edi
  8021c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021c9:	89 d7                	mov    %edx,%edi
  8021cb:	f7 64 24 08          	mull   0x8(%esp)
  8021cf:	39 d7                	cmp    %edx,%edi
  8021d1:	89 c1                	mov    %eax,%ecx
  8021d3:	89 14 24             	mov    %edx,(%esp)
  8021d6:	72 2c                	jb     802204 <__umoddi3+0x134>
  8021d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8021dc:	72 22                	jb     802200 <__umoddi3+0x130>
  8021de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8021e2:	29 c8                	sub    %ecx,%eax
  8021e4:	19 d7                	sbb    %edx,%edi
  8021e6:	89 e9                	mov    %ebp,%ecx
  8021e8:	89 fa                	mov    %edi,%edx
  8021ea:	d3 e8                	shr    %cl,%eax
  8021ec:	89 f1                	mov    %esi,%ecx
  8021ee:	d3 e2                	shl    %cl,%edx
  8021f0:	89 e9                	mov    %ebp,%ecx
  8021f2:	d3 ef                	shr    %cl,%edi
  8021f4:	09 d0                	or     %edx,%eax
  8021f6:	89 fa                	mov    %edi,%edx
  8021f8:	83 c4 14             	add    $0x14,%esp
  8021fb:	5e                   	pop    %esi
  8021fc:	5f                   	pop    %edi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    
  8021ff:	90                   	nop
  802200:	39 d7                	cmp    %edx,%edi
  802202:	75 da                	jne    8021de <__umoddi3+0x10e>
  802204:	8b 14 24             	mov    (%esp),%edx
  802207:	89 c1                	mov    %eax,%ecx
  802209:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80220d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802211:	eb cb                	jmp    8021de <__umoddi3+0x10e>
  802213:	90                   	nop
  802214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802218:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80221c:	0f 82 0f ff ff ff    	jb     802131 <__umoddi3+0x61>
  802222:	e9 1a ff ff ff       	jmp    802141 <__umoddi3+0x71>
