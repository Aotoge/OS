
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
  800043:	c7 04 24 60 22 80 00 	movl   $0x802260,(%esp)
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
  80007a:	c7 44 24 08 80 22 80 	movl   $0x802280,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 6a 22 80 00 	movl   $0x80226a,(%esp)
  800091:	e8 db 00 00 00       	call   800171 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 ac 22 80 	movl   $0x8022ac,0x8(%esp)
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
  80019d:	c7 04 24 d8 22 80 00 	movl   $0x8022d8,(%esp)
  8001a4:	e8 c1 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b0:	89 04 24             	mov    %eax,(%esp)
  8001b3:	e8 51 00 00 00       	call   800209 <vcprintf>
	cprintf("\n");
  8001b8:	c7 04 24 48 27 80 00 	movl   $0x802748,(%esp)
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
  80030c:	e8 bf 1c 00 00       	call   801fd0 <__udivdi3>
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
  800365:	e8 96 1d 00 00       	call   802100 <__umoddi3>
  80036a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80036e:	0f be 80 fb 22 80 00 	movsbl 0x8022fb(%eax),%eax
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
  80048c:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
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
  80053f:	8b 14 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%edx
  800546:	85 d2                	test   %edx,%edx
  800548:	75 20                	jne    80056a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80054a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054e:	c7 44 24 08 13 23 80 	movl   $0x802313,0x8(%esp)
  800555:	00 
  800556:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 77 fe ff ff       	call   8003dc <printfmt>
  800565:	e9 c3 fe ff ff       	jmp    80042d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80056a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80056e:	c7 44 24 08 16 27 80 	movl   $0x802716,0x8(%esp)
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
  80059d:	ba 0c 23 80 00       	mov    $0x80230c,%edx
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
  800d17:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800d1e:	00 
  800d1f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d26:	00 
  800d27:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800da9:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800db0:	00 
  800db1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800db8:	00 
  800db9:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800dfc:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800e03:	00 
  800e04:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e0b:	00 
  800e0c:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800e4f:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800e56:	00 
  800e57:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e5e:	00 
  800e5f:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800ea2:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800ea9:	00 
  800eaa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800eb1:	00 
  800eb2:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800ef5:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800efc:	00 
  800efd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f04:	00 
  800f05:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800f48:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800f4f:	00 
  800f50:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f57:	00 
  800f58:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  800fbd:	c7 44 24 08 ff 25 80 	movl   $0x8025ff,0x8(%esp)
  800fc4:	00 
  800fc5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fcc:	00 
  800fcd:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
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
  801010:	c7 44 24 08 2c 26 80 	movl   $0x80262c,0x8(%esp)
  801017:	00 
  801018:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80101f:	00 
  801020:	c7 04 24 50 26 80 00 	movl   $0x802650,(%esp)
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
  8011e5:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
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
  80143b:	c7 04 24 a4 26 80 00 	movl   $0x8026a4,(%esp)
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
  801523:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
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
  8015dc:	c7 04 24 80 26 80 00 	movl   $0x802680,(%esp)
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
  8016a2:	e8 e1 01 00 00       	call   801888 <open>
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
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8016db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016e2:	75 11                	jne    8016f5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016eb:	e8 54 08 00 00       	call   801f44 <ipc_find_env>
  8016f0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8016f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8016fa:	8b 40 48             	mov    0x48(%eax),%eax
  8016fd:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801703:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170f:	c7 04 24 dd 26 80 00 	movl   $0x8026dd,(%esp)
  801716:	e8 4f eb ff ff       	call   80026a <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80171b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801722:	00 
  801723:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80172a:	00 
  80172b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80172f:	a1 00 40 80 00       	mov    0x804000,%eax
  801734:	89 04 24             	mov    %eax,(%esp)
  801737:	e8 a2 07 00 00       	call   801ede <ipc_send>
	cprintf("ipc_send\n");
  80173c:	c7 04 24 f3 26 80 00 	movl   $0x8026f3,(%esp)
  801743:	e8 22 eb ff ff       	call   80026a <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801748:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80174f:	00 
  801750:	89 74 24 04          	mov    %esi,0x4(%esp)
  801754:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80175b:	e8 16 07 00 00       	call   801e76 <ipc_recv>
}
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	53                   	push   %ebx
  80176b:	83 ec 14             	sub    $0x14,%esp
  80176e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	8b 40 0c             	mov    0xc(%eax),%eax
  801777:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177c:	ba 00 00 00 00       	mov    $0x0,%edx
  801781:	b8 05 00 00 00       	mov    $0x5,%eax
  801786:	e8 44 ff ff ff       	call   8016cf <fsipc>
  80178b:	89 c2                	mov    %eax,%edx
  80178d:	85 d2                	test   %edx,%edx
  80178f:	78 2b                	js     8017bc <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801791:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801798:	00 
  801799:	89 1c 24             	mov    %ebx,(%esp)
  80179c:	e8 2a f1 ff ff       	call   8008cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017a1:	a1 80 50 80 00       	mov    0x805080,%eax
  8017a6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ac:	a1 84 50 80 00       	mov    0x805084,%eax
  8017b1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bc:	83 c4 14             	add    $0x14,%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5d                   	pop    %ebp
  8017c1:	c3                   	ret    

008017c2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ce:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8017dd:	e8 ed fe ff ff       	call   8016cf <fsipc>
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 10             	sub    $0x10,%esp
  8017ec:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017fa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801800:	ba 00 00 00 00       	mov    $0x0,%edx
  801805:	b8 03 00 00 00       	mov    $0x3,%eax
  80180a:	e8 c0 fe ff ff       	call   8016cf <fsipc>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	85 c0                	test   %eax,%eax
  801813:	78 6a                	js     80187f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801815:	39 c6                	cmp    %eax,%esi
  801817:	73 24                	jae    80183d <devfile_read+0x59>
  801819:	c7 44 24 0c fd 26 80 	movl   $0x8026fd,0xc(%esp)
  801820:	00 
  801821:	c7 44 24 08 04 27 80 	movl   $0x802704,0x8(%esp)
  801828:	00 
  801829:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801830:	00 
  801831:	c7 04 24 19 27 80 00 	movl   $0x802719,(%esp)
  801838:	e8 34 e9 ff ff       	call   800171 <_panic>
	assert(r <= PGSIZE);
  80183d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801842:	7e 24                	jle    801868 <devfile_read+0x84>
  801844:	c7 44 24 0c 24 27 80 	movl   $0x802724,0xc(%esp)
  80184b:	00 
  80184c:	c7 44 24 08 04 27 80 	movl   $0x802704,0x8(%esp)
  801853:	00 
  801854:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80185b:	00 
  80185c:	c7 04 24 19 27 80 00 	movl   $0x802719,(%esp)
  801863:	e8 09 e9 ff ff       	call   800171 <_panic>
	memmove(buf, &fsipcbuf, r);
  801868:	89 44 24 08          	mov    %eax,0x8(%esp)
  80186c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801873:	00 
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	89 04 24             	mov    %eax,(%esp)
  80187a:	e8 47 f2 ff ff       	call   800ac6 <memmove>
	return r;
}
  80187f:	89 d8                	mov    %ebx,%eax
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	53                   	push   %ebx
  80188c:	83 ec 24             	sub    $0x24,%esp
  80188f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801892:	89 1c 24             	mov    %ebx,(%esp)
  801895:	e8 d6 ef ff ff       	call   800870 <strlen>
  80189a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80189f:	7f 60                	jg     801901 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	e8 1b f8 ff ff       	call   8010c7 <fd_alloc>
  8018ac:	89 c2                	mov    %eax,%edx
  8018ae:	85 d2                	test   %edx,%edx
  8018b0:	78 54                	js     801906 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b6:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018bd:	e8 09 f0 ff ff       	call   8008cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d2:	e8 f8 fd ff ff       	call   8016cf <fsipc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	79 17                	jns    8018f4 <open+0x6c>
		fd_close(fd, 0);
  8018dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018e4:	00 
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	89 04 24             	mov    %eax,(%esp)
  8018eb:	e8 12 f9 ff ff       	call   801202 <fd_close>
		return r;
  8018f0:	89 d8                	mov    %ebx,%eax
  8018f2:	eb 12                	jmp    801906 <open+0x7e>
	}
	return fd2num(fd);
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	89 04 24             	mov    %eax,(%esp)
  8018fa:	e8 a1 f7 ff ff       	call   8010a0 <fd2num>
  8018ff:	eb 05                	jmp    801906 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801901:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801906:	83 c4 24             	add    $0x24,%esp
  801909:	5b                   	pop    %ebx
  80190a:	5d                   	pop    %ebp
  80190b:	c3                   	ret    
  80190c:	66 90                	xchg   %ax,%ax
  80190e:	66 90                	xchg   %ax,%ax

00801910 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	56                   	push   %esi
  801914:	53                   	push   %ebx
  801915:	83 ec 10             	sub    $0x10,%esp
  801918:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 8a f7 ff ff       	call   8010b0 <fd2data>
  801926:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801928:	c7 44 24 04 30 27 80 	movl   $0x802730,0x4(%esp)
  80192f:	00 
  801930:	89 1c 24             	mov    %ebx,(%esp)
  801933:	e8 93 ef ff ff       	call   8008cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801938:	8b 46 04             	mov    0x4(%esi),%eax
  80193b:	2b 06                	sub    (%esi),%eax
  80193d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801943:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80194a:	00 00 00 
	stat->st_dev = &devpipe;
  80194d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801954:	30 80 00 
	return 0;
}
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	5b                   	pop    %ebx
  801960:	5e                   	pop    %esi
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	53                   	push   %ebx
  801967:	83 ec 14             	sub    $0x14,%esp
  80196a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80196d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801971:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801978:	e8 a3 f4 ff ff       	call   800e20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80197d:	89 1c 24             	mov    %ebx,(%esp)
  801980:	e8 2b f7 ff ff       	call   8010b0 <fd2data>
  801985:	89 44 24 04          	mov    %eax,0x4(%esp)
  801989:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801990:	e8 8b f4 ff ff       	call   800e20 <sys_page_unmap>
}
  801995:	83 c4 14             	add    $0x14,%esp
  801998:	5b                   	pop    %ebx
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	57                   	push   %edi
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 2c             	sub    $0x2c,%esp
  8019a4:	89 c6                	mov    %eax,%esi
  8019a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8019ae:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019b1:	89 34 24             	mov    %esi,(%esp)
  8019b4:	e8 d3 05 00 00       	call   801f8c <pageref>
  8019b9:	89 c7                	mov    %eax,%edi
  8019bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019be:	89 04 24             	mov    %eax,(%esp)
  8019c1:	e8 c6 05 00 00       	call   801f8c <pageref>
  8019c6:	39 c7                	cmp    %eax,%edi
  8019c8:	0f 94 c2             	sete   %dl
  8019cb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8019ce:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  8019d4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8019d7:	39 fb                	cmp    %edi,%ebx
  8019d9:	74 21                	je     8019fc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8019db:	84 d2                	test   %dl,%dl
  8019dd:	74 ca                	je     8019a9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019df:	8b 51 58             	mov    0x58(%ecx),%edx
  8019e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ee:	c7 04 24 37 27 80 00 	movl   $0x802737,(%esp)
  8019f5:	e8 70 e8 ff ff       	call   80026a <cprintf>
  8019fa:	eb ad                	jmp    8019a9 <_pipeisclosed+0xe>
	}
}
  8019fc:	83 c4 2c             	add    $0x2c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	57                   	push   %edi
  801a08:	56                   	push   %esi
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 1c             	sub    $0x1c,%esp
  801a0d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a10:	89 34 24             	mov    %esi,(%esp)
  801a13:	e8 98 f6 ff ff       	call   8010b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1c:	74 61                	je     801a7f <devpipe_write+0x7b>
  801a1e:	89 c3                	mov    %eax,%ebx
  801a20:	bf 00 00 00 00       	mov    $0x0,%edi
  801a25:	eb 4a                	jmp    801a71 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a27:	89 da                	mov    %ebx,%edx
  801a29:	89 f0                	mov    %esi,%eax
  801a2b:	e8 6b ff ff ff       	call   80199b <_pipeisclosed>
  801a30:	85 c0                	test   %eax,%eax
  801a32:	75 54                	jne    801a88 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a34:	e8 21 f3 ff ff       	call   800d5a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a39:	8b 43 04             	mov    0x4(%ebx),%eax
  801a3c:	8b 0b                	mov    (%ebx),%ecx
  801a3e:	8d 51 20             	lea    0x20(%ecx),%edx
  801a41:	39 d0                	cmp    %edx,%eax
  801a43:	73 e2                	jae    801a27 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a48:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a4c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a4f:	99                   	cltd   
  801a50:	c1 ea 1b             	shr    $0x1b,%edx
  801a53:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a56:	83 e1 1f             	and    $0x1f,%ecx
  801a59:	29 d1                	sub    %edx,%ecx
  801a5b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a5f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a63:	83 c0 01             	add    $0x1,%eax
  801a66:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a69:	83 c7 01             	add    $0x1,%edi
  801a6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a6f:	74 13                	je     801a84 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a71:	8b 43 04             	mov    0x4(%ebx),%eax
  801a74:	8b 0b                	mov    (%ebx),%ecx
  801a76:	8d 51 20             	lea    0x20(%ecx),%edx
  801a79:	39 d0                	cmp    %edx,%eax
  801a7b:	73 aa                	jae    801a27 <devpipe_write+0x23>
  801a7d:	eb c6                	jmp    801a45 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a7f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a84:	89 f8                	mov    %edi,%eax
  801a86:	eb 05                	jmp    801a8d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a8d:	83 c4 1c             	add    $0x1c,%esp
  801a90:	5b                   	pop    %ebx
  801a91:	5e                   	pop    %esi
  801a92:	5f                   	pop    %edi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	57                   	push   %edi
  801a99:	56                   	push   %esi
  801a9a:	53                   	push   %ebx
  801a9b:	83 ec 1c             	sub    $0x1c,%esp
  801a9e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801aa1:	89 3c 24             	mov    %edi,(%esp)
  801aa4:	e8 07 f6 ff ff       	call   8010b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801aa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aad:	74 54                	je     801b03 <devpipe_read+0x6e>
  801aaf:	89 c3                	mov    %eax,%ebx
  801ab1:	be 00 00 00 00       	mov    $0x0,%esi
  801ab6:	eb 3e                	jmp    801af6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ab8:	89 f0                	mov    %esi,%eax
  801aba:	eb 55                	jmp    801b11 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801abc:	89 da                	mov    %ebx,%edx
  801abe:	89 f8                	mov    %edi,%eax
  801ac0:	e8 d6 fe ff ff       	call   80199b <_pipeisclosed>
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 43                	jne    801b0c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ac9:	e8 8c f2 ff ff       	call   800d5a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ace:	8b 03                	mov    (%ebx),%eax
  801ad0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ad3:	74 e7                	je     801abc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ad5:	99                   	cltd   
  801ad6:	c1 ea 1b             	shr    $0x1b,%edx
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	83 e0 1f             	and    $0x1f,%eax
  801ade:	29 d0                	sub    %edx,%eax
  801ae0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801aeb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801aee:	83 c6 01             	add    $0x1,%esi
  801af1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801af4:	74 12                	je     801b08 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801af6:	8b 03                	mov    (%ebx),%eax
  801af8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801afb:	75 d8                	jne    801ad5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801afd:	85 f6                	test   %esi,%esi
  801aff:	75 b7                	jne    801ab8 <devpipe_read+0x23>
  801b01:	eb b9                	jmp    801abc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b03:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b08:	89 f0                	mov    %esi,%eax
  801b0a:	eb 05                	jmp    801b11 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b11:	83 c4 1c             	add    $0x1c,%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5f                   	pop    %edi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	56                   	push   %esi
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b24:	89 04 24             	mov    %eax,(%esp)
  801b27:	e8 9b f5 ff ff       	call   8010c7 <fd_alloc>
  801b2c:	89 c2                	mov    %eax,%edx
  801b2e:	85 d2                	test   %edx,%edx
  801b30:	0f 88 4d 01 00 00    	js     801c83 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b3d:	00 
  801b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4c:	e8 28 f2 ff ff       	call   800d79 <sys_page_alloc>
  801b51:	89 c2                	mov    %eax,%edx
  801b53:	85 d2                	test   %edx,%edx
  801b55:	0f 88 28 01 00 00    	js     801c83 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 61 f5 ff ff       	call   8010c7 <fd_alloc>
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	0f 88 fe 00 00 00    	js     801c6e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b70:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b77:	00 
  801b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b86:	e8 ee f1 ff ff       	call   800d79 <sys_page_alloc>
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	0f 88 d9 00 00 00    	js     801c6e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	89 04 24             	mov    %eax,(%esp)
  801b9b:	e8 10 f5 ff ff       	call   8010b0 <fd2data>
  801ba0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ba9:	00 
  801baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bb5:	e8 bf f1 ff ff       	call   800d79 <sys_page_alloc>
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	0f 88 97 00 00 00    	js     801c5b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc7:	89 04 24             	mov    %eax,(%esp)
  801bca:	e8 e1 f4 ff ff       	call   8010b0 <fd2data>
  801bcf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801bd6:	00 
  801bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801be2:	00 
  801be3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bee:	e8 da f1 ff ff       	call   800dcd <sys_page_map>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 52                	js     801c4b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801bf9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c0e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c17:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c26:	89 04 24             	mov    %eax,(%esp)
  801c29:	e8 72 f4 ff ff       	call   8010a0 <fd2num>
  801c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c31:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c36:	89 04 24             	mov    %eax,(%esp)
  801c39:	e8 62 f4 ff ff       	call   8010a0 <fd2num>
  801c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c41:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c44:	b8 00 00 00 00       	mov    $0x0,%eax
  801c49:	eb 38                	jmp    801c83 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801c4b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c56:	e8 c5 f1 ff ff       	call   800e20 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c69:	e8 b2 f1 ff ff       	call   800e20 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c7c:	e8 9f f1 ff ff       	call   800e20 <sys_page_unmap>
  801c81:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801c83:	83 c4 30             	add    $0x30,%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	89 04 24             	mov    %eax,(%esp)
  801c9d:	e8 99 f4 ff ff       	call   80113b <fd_lookup>
  801ca2:	89 c2                	mov    %eax,%edx
  801ca4:	85 d2                	test   %edx,%edx
  801ca6:	78 15                	js     801cbd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	89 04 24             	mov    %eax,(%esp)
  801cae:	e8 fd f3 ff ff       	call   8010b0 <fd2data>
	return _pipeisclosed(fd, p);
  801cb3:	89 c2                	mov    %eax,%edx
  801cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb8:	e8 de fc ff ff       	call   80199b <_pipeisclosed>
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    
  801cbf:	90                   	nop

00801cc0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801cd0:	c7 44 24 04 4f 27 80 	movl   $0x80274f,0x4(%esp)
  801cd7:	00 
  801cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdb:	89 04 24             	mov    %eax,(%esp)
  801cde:	e8 e8 eb ff ff       	call   8008cb <strcpy>
	return 0;
}
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	57                   	push   %edi
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cfa:	74 4a                	je     801d46 <devcons_write+0x5c>
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d06:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d0c:	8b 75 10             	mov    0x10(%ebp),%esi
  801d0f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801d11:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d14:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d19:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d1c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d20:	03 45 0c             	add    0xc(%ebp),%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	89 3c 24             	mov    %edi,(%esp)
  801d2a:	e8 97 ed ff ff       	call   800ac6 <memmove>
		sys_cputs(buf, m);
  801d2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d33:	89 3c 24             	mov    %edi,(%esp)
  801d36:	e8 71 ef ff ff       	call   800cac <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d3b:	01 f3                	add    %esi,%ebx
  801d3d:	89 d8                	mov    %ebx,%eax
  801d3f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d42:	72 c8                	jb     801d0c <devcons_write+0x22>
  801d44:	eb 05                	jmp    801d4b <devcons_write+0x61>
  801d46:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d4b:	89 d8                	mov    %ebx,%eax
  801d4d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    

00801d58 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d67:	75 07                	jne    801d70 <devcons_read+0x18>
  801d69:	eb 28                	jmp    801d93 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d6b:	e8 ea ef ff ff       	call   800d5a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d70:	e8 55 ef ff ff       	call   800cca <sys_cgetc>
  801d75:	85 c0                	test   %eax,%eax
  801d77:	74 f2                	je     801d6b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 16                	js     801d93 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d7d:	83 f8 04             	cmp    $0x4,%eax
  801d80:	74 0c                	je     801d8e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d85:	88 02                	mov    %al,(%edx)
	return 1;
  801d87:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8c:	eb 05                	jmp    801d93 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801da1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801da8:	00 
  801da9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dac:	89 04 24             	mov    %eax,(%esp)
  801daf:	e8 f8 ee ff ff       	call   800cac <sys_cputs>
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <getchar>:

int
getchar(void)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801dbc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801dc3:	00 
  801dc4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd2:	e8 0f f6 ff ff       	call   8013e6 <read>
	if (r < 0)
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 0f                	js     801dea <getchar+0x34>
		return r;
	if (r < 1)
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	7e 06                	jle    801de5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801ddf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801de3:	eb 05                	jmp    801dea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801de5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	89 04 24             	mov    %eax,(%esp)
  801dff:	e8 37 f3 ff ff       	call   80113b <fd_lookup>
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 11                	js     801e19 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e11:	39 10                	cmp    %edx,(%eax)
  801e13:	0f 94 c0             	sete   %al
  801e16:	0f b6 c0             	movzbl %al,%eax
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <opencons>:

int
opencons(void)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e24:	89 04 24             	mov    %eax,(%esp)
  801e27:	e8 9b f2 ff ff       	call   8010c7 <fd_alloc>
		return r;
  801e2c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 40                	js     801e72 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e32:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e39:	00 
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e48:	e8 2c ef ff ff       	call   800d79 <sys_page_alloc>
		return r;
  801e4d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 1f                	js     801e72 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e53:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e68:	89 04 24             	mov    %eax,(%esp)
  801e6b:	e8 30 f2 ff ff       	call   8010a0 <fd2num>
  801e70:	89 c2                	mov    %eax,%edx
}
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	56                   	push   %esi
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 10             	sub    $0x10,%esp
  801e7e:	8b 75 08             	mov    0x8(%ebp),%esi
  801e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801e87:	85 c0                	test   %eax,%eax
  801e89:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e8e:	0f 44 c2             	cmove  %edx,%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 f6 f0 ff ff       	call   800f8f <sys_ipc_recv>
	if (err_code < 0) {
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	79 16                	jns    801eb3 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801e9d:	85 f6                	test   %esi,%esi
  801e9f:	74 06                	je     801ea7 <ipc_recv+0x31>
  801ea1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801ea7:	85 db                	test   %ebx,%ebx
  801ea9:	74 2c                	je     801ed7 <ipc_recv+0x61>
  801eab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801eb1:	eb 24                	jmp    801ed7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801eb3:	85 f6                	test   %esi,%esi
  801eb5:	74 0a                	je     801ec1 <ipc_recv+0x4b>
  801eb7:	a1 04 40 80 00       	mov    0x804004,%eax
  801ebc:	8b 40 74             	mov    0x74(%eax),%eax
  801ebf:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801ec1:	85 db                	test   %ebx,%ebx
  801ec3:	74 0a                	je     801ecf <ipc_recv+0x59>
  801ec5:	a1 04 40 80 00       	mov    0x804004,%eax
  801eca:	8b 40 78             	mov    0x78(%eax),%eax
  801ecd:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801ecf:	a1 04 40 80 00       	mov    0x804004,%eax
  801ed4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    

00801ede <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 1c             	sub    $0x1c,%esp
  801ee7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801eea:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ef0:	eb 25                	jmp    801f17 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801ef2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ef5:	74 20                	je     801f17 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801ef7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801efb:	c7 44 24 08 5b 27 80 	movl   $0x80275b,0x8(%esp)
  801f02:	00 
  801f03:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801f0a:	00 
  801f0b:	c7 04 24 67 27 80 00 	movl   $0x802767,(%esp)
  801f12:	e8 5a e2 ff ff       	call   800171 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801f17:	85 db                	test   %ebx,%ebx
  801f19:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f1e:	0f 45 c3             	cmovne %ebx,%eax
  801f21:	8b 55 14             	mov    0x14(%ebp),%edx
  801f24:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f30:	89 3c 24             	mov    %edi,(%esp)
  801f33:	e8 34 f0 ff ff       	call   800f6c <sys_ipc_try_send>
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	75 b6                	jne    801ef2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801f4a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801f4f:	39 c8                	cmp    %ecx,%eax
  801f51:	74 17                	je     801f6a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f53:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801f58:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f5b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f61:	8b 52 50             	mov    0x50(%edx),%edx
  801f64:	39 ca                	cmp    %ecx,%edx
  801f66:	75 14                	jne    801f7c <ipc_find_env+0x38>
  801f68:	eb 05                	jmp    801f6f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801f6f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f72:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801f77:	8b 40 40             	mov    0x40(%eax),%eax
  801f7a:	eb 0e                	jmp    801f8a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f7c:	83 c0 01             	add    $0x1,%eax
  801f7f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f84:	75 d2                	jne    801f58 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f86:	66 b8 00 00          	mov    $0x0,%ax
}
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    

00801f8c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f92:	89 d0                	mov    %edx,%eax
  801f94:	c1 e8 16             	shr    $0x16,%eax
  801f97:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fa3:	f6 c1 01             	test   $0x1,%cl
  801fa6:	74 1d                	je     801fc5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801fa8:	c1 ea 0c             	shr    $0xc,%edx
  801fab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801fb2:	f6 c2 01             	test   $0x1,%dl
  801fb5:	74 0e                	je     801fc5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fb7:	c1 ea 0c             	shr    $0xc,%edx
  801fba:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fc1:	ef 
  801fc2:	0f b7 c0             	movzwl %ax,%eax
}
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    
  801fc7:	66 90                	xchg   %ax,%ax
  801fc9:	66 90                	xchg   %ax,%ax
  801fcb:	66 90                	xchg   %ax,%ax
  801fcd:	66 90                	xchg   %ax,%ax
  801fcf:	90                   	nop

00801fd0 <__udivdi3>:
  801fd0:	55                   	push   %ebp
  801fd1:	57                   	push   %edi
  801fd2:	56                   	push   %esi
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801fda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801fde:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801fe2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fec:	89 ea                	mov    %ebp,%edx
  801fee:	89 0c 24             	mov    %ecx,(%esp)
  801ff1:	75 2d                	jne    802020 <__udivdi3+0x50>
  801ff3:	39 e9                	cmp    %ebp,%ecx
  801ff5:	77 61                	ja     802058 <__udivdi3+0x88>
  801ff7:	85 c9                	test   %ecx,%ecx
  801ff9:	89 ce                	mov    %ecx,%esi
  801ffb:	75 0b                	jne    802008 <__udivdi3+0x38>
  801ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  802002:	31 d2                	xor    %edx,%edx
  802004:	f7 f1                	div    %ecx
  802006:	89 c6                	mov    %eax,%esi
  802008:	31 d2                	xor    %edx,%edx
  80200a:	89 e8                	mov    %ebp,%eax
  80200c:	f7 f6                	div    %esi
  80200e:	89 c5                	mov    %eax,%ebp
  802010:	89 f8                	mov    %edi,%eax
  802012:	f7 f6                	div    %esi
  802014:	89 ea                	mov    %ebp,%edx
  802016:	83 c4 0c             	add    $0xc,%esp
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
  80201d:	8d 76 00             	lea    0x0(%esi),%esi
  802020:	39 e8                	cmp    %ebp,%eax
  802022:	77 24                	ja     802048 <__udivdi3+0x78>
  802024:	0f bd e8             	bsr    %eax,%ebp
  802027:	83 f5 1f             	xor    $0x1f,%ebp
  80202a:	75 3c                	jne    802068 <__udivdi3+0x98>
  80202c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802030:	39 34 24             	cmp    %esi,(%esp)
  802033:	0f 86 9f 00 00 00    	jbe    8020d8 <__udivdi3+0x108>
  802039:	39 d0                	cmp    %edx,%eax
  80203b:	0f 82 97 00 00 00    	jb     8020d8 <__udivdi3+0x108>
  802041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802048:	31 d2                	xor    %edx,%edx
  80204a:	31 c0                	xor    %eax,%eax
  80204c:	83 c4 0c             	add    $0xc,%esp
  80204f:	5e                   	pop    %esi
  802050:	5f                   	pop    %edi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    
  802053:	90                   	nop
  802054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802058:	89 f8                	mov    %edi,%eax
  80205a:	f7 f1                	div    %ecx
  80205c:	31 d2                	xor    %edx,%edx
  80205e:	83 c4 0c             	add    $0xc,%esp
  802061:	5e                   	pop    %esi
  802062:	5f                   	pop    %edi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    
  802065:	8d 76 00             	lea    0x0(%esi),%esi
  802068:	89 e9                	mov    %ebp,%ecx
  80206a:	8b 3c 24             	mov    (%esp),%edi
  80206d:	d3 e0                	shl    %cl,%eax
  80206f:	89 c6                	mov    %eax,%esi
  802071:	b8 20 00 00 00       	mov    $0x20,%eax
  802076:	29 e8                	sub    %ebp,%eax
  802078:	89 c1                	mov    %eax,%ecx
  80207a:	d3 ef                	shr    %cl,%edi
  80207c:	89 e9                	mov    %ebp,%ecx
  80207e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802082:	8b 3c 24             	mov    (%esp),%edi
  802085:	09 74 24 08          	or     %esi,0x8(%esp)
  802089:	89 d6                	mov    %edx,%esi
  80208b:	d3 e7                	shl    %cl,%edi
  80208d:	89 c1                	mov    %eax,%ecx
  80208f:	89 3c 24             	mov    %edi,(%esp)
  802092:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802096:	d3 ee                	shr    %cl,%esi
  802098:	89 e9                	mov    %ebp,%ecx
  80209a:	d3 e2                	shl    %cl,%edx
  80209c:	89 c1                	mov    %eax,%ecx
  80209e:	d3 ef                	shr    %cl,%edi
  8020a0:	09 d7                	or     %edx,%edi
  8020a2:	89 f2                	mov    %esi,%edx
  8020a4:	89 f8                	mov    %edi,%eax
  8020a6:	f7 74 24 08          	divl   0x8(%esp)
  8020aa:	89 d6                	mov    %edx,%esi
  8020ac:	89 c7                	mov    %eax,%edi
  8020ae:	f7 24 24             	mull   (%esp)
  8020b1:	39 d6                	cmp    %edx,%esi
  8020b3:	89 14 24             	mov    %edx,(%esp)
  8020b6:	72 30                	jb     8020e8 <__udivdi3+0x118>
  8020b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020bc:	89 e9                	mov    %ebp,%ecx
  8020be:	d3 e2                	shl    %cl,%edx
  8020c0:	39 c2                	cmp    %eax,%edx
  8020c2:	73 05                	jae    8020c9 <__udivdi3+0xf9>
  8020c4:	3b 34 24             	cmp    (%esp),%esi
  8020c7:	74 1f                	je     8020e8 <__udivdi3+0x118>
  8020c9:	89 f8                	mov    %edi,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	e9 7a ff ff ff       	jmp    80204c <__udivdi3+0x7c>
  8020d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020d8:	31 d2                	xor    %edx,%edx
  8020da:	b8 01 00 00 00       	mov    $0x1,%eax
  8020df:	e9 68 ff ff ff       	jmp    80204c <__udivdi3+0x7c>
  8020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	83 c4 0c             	add    $0xc,%esp
  8020f0:	5e                   	pop    %esi
  8020f1:	5f                   	pop    %edi
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    
  8020f4:	66 90                	xchg   %ax,%ax
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	66 90                	xchg   %ax,%ax
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <__umoddi3>:
  802100:	55                   	push   %ebp
  802101:	57                   	push   %edi
  802102:	56                   	push   %esi
  802103:	83 ec 14             	sub    $0x14,%esp
  802106:	8b 44 24 28          	mov    0x28(%esp),%eax
  80210a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80210e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802112:	89 c7                	mov    %eax,%edi
  802114:	89 44 24 04          	mov    %eax,0x4(%esp)
  802118:	8b 44 24 30          	mov    0x30(%esp),%eax
  80211c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802120:	89 34 24             	mov    %esi,(%esp)
  802123:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802127:	85 c0                	test   %eax,%eax
  802129:	89 c2                	mov    %eax,%edx
  80212b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80212f:	75 17                	jne    802148 <__umoddi3+0x48>
  802131:	39 fe                	cmp    %edi,%esi
  802133:	76 4b                	jbe    802180 <__umoddi3+0x80>
  802135:	89 c8                	mov    %ecx,%eax
  802137:	89 fa                	mov    %edi,%edx
  802139:	f7 f6                	div    %esi
  80213b:	89 d0                	mov    %edx,%eax
  80213d:	31 d2                	xor    %edx,%edx
  80213f:	83 c4 14             	add    $0x14,%esp
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    
  802146:	66 90                	xchg   %ax,%ax
  802148:	39 f8                	cmp    %edi,%eax
  80214a:	77 54                	ja     8021a0 <__umoddi3+0xa0>
  80214c:	0f bd e8             	bsr    %eax,%ebp
  80214f:	83 f5 1f             	xor    $0x1f,%ebp
  802152:	75 5c                	jne    8021b0 <__umoddi3+0xb0>
  802154:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802158:	39 3c 24             	cmp    %edi,(%esp)
  80215b:	0f 87 e7 00 00 00    	ja     802248 <__umoddi3+0x148>
  802161:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802165:	29 f1                	sub    %esi,%ecx
  802167:	19 c7                	sbb    %eax,%edi
  802169:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80216d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802171:	8b 44 24 08          	mov    0x8(%esp),%eax
  802175:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802179:	83 c4 14             	add    $0x14,%esp
  80217c:	5e                   	pop    %esi
  80217d:	5f                   	pop    %edi
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    
  802180:	85 f6                	test   %esi,%esi
  802182:	89 f5                	mov    %esi,%ebp
  802184:	75 0b                	jne    802191 <__umoddi3+0x91>
  802186:	b8 01 00 00 00       	mov    $0x1,%eax
  80218b:	31 d2                	xor    %edx,%edx
  80218d:	f7 f6                	div    %esi
  80218f:	89 c5                	mov    %eax,%ebp
  802191:	8b 44 24 04          	mov    0x4(%esp),%eax
  802195:	31 d2                	xor    %edx,%edx
  802197:	f7 f5                	div    %ebp
  802199:	89 c8                	mov    %ecx,%eax
  80219b:	f7 f5                	div    %ebp
  80219d:	eb 9c                	jmp    80213b <__umoddi3+0x3b>
  80219f:	90                   	nop
  8021a0:	89 c8                	mov    %ecx,%eax
  8021a2:	89 fa                	mov    %edi,%edx
  8021a4:	83 c4 14             	add    $0x14,%esp
  8021a7:	5e                   	pop    %esi
  8021a8:	5f                   	pop    %edi
  8021a9:	5d                   	pop    %ebp
  8021aa:	c3                   	ret    
  8021ab:	90                   	nop
  8021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	8b 04 24             	mov    (%esp),%eax
  8021b3:	be 20 00 00 00       	mov    $0x20,%esi
  8021b8:	89 e9                	mov    %ebp,%ecx
  8021ba:	29 ee                	sub    %ebp,%esi
  8021bc:	d3 e2                	shl    %cl,%edx
  8021be:	89 f1                	mov    %esi,%ecx
  8021c0:	d3 e8                	shr    %cl,%eax
  8021c2:	89 e9                	mov    %ebp,%ecx
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	8b 04 24             	mov    (%esp),%eax
  8021cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8021cf:	89 fa                	mov    %edi,%edx
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 f1                	mov    %esi,%ecx
  8021d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8021dd:	d3 ea                	shr    %cl,%edx
  8021df:	89 e9                	mov    %ebp,%ecx
  8021e1:	d3 e7                	shl    %cl,%edi
  8021e3:	89 f1                	mov    %esi,%ecx
  8021e5:	d3 e8                	shr    %cl,%eax
  8021e7:	89 e9                	mov    %ebp,%ecx
  8021e9:	09 f8                	or     %edi,%eax
  8021eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8021ef:	f7 74 24 04          	divl   0x4(%esp)
  8021f3:	d3 e7                	shl    %cl,%edi
  8021f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021f9:	89 d7                	mov    %edx,%edi
  8021fb:	f7 64 24 08          	mull   0x8(%esp)
  8021ff:	39 d7                	cmp    %edx,%edi
  802201:	89 c1                	mov    %eax,%ecx
  802203:	89 14 24             	mov    %edx,(%esp)
  802206:	72 2c                	jb     802234 <__umoddi3+0x134>
  802208:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80220c:	72 22                	jb     802230 <__umoddi3+0x130>
  80220e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802212:	29 c8                	sub    %ecx,%eax
  802214:	19 d7                	sbb    %edx,%edi
  802216:	89 e9                	mov    %ebp,%ecx
  802218:	89 fa                	mov    %edi,%edx
  80221a:	d3 e8                	shr    %cl,%eax
  80221c:	89 f1                	mov    %esi,%ecx
  80221e:	d3 e2                	shl    %cl,%edx
  802220:	89 e9                	mov    %ebp,%ecx
  802222:	d3 ef                	shr    %cl,%edi
  802224:	09 d0                	or     %edx,%eax
  802226:	89 fa                	mov    %edi,%edx
  802228:	83 c4 14             	add    $0x14,%esp
  80222b:	5e                   	pop    %esi
  80222c:	5f                   	pop    %edi
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    
  80222f:	90                   	nop
  802230:	39 d7                	cmp    %edx,%edi
  802232:	75 da                	jne    80220e <__umoddi3+0x10e>
  802234:	8b 14 24             	mov    (%esp),%edx
  802237:	89 c1                	mov    %eax,%ecx
  802239:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80223d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802241:	eb cb                	jmp    80220e <__umoddi3+0x10e>
  802243:	90                   	nop
  802244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802248:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80224c:	0f 82 0f ff ff ff    	jb     802161 <__umoddi3+0x61>
  802252:	e9 1a ff ff ff       	jmp    802171 <__umoddi3+0x71>
