
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 91 00 00 00       	call   8000c2 <libmain>
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
  800038:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 7b 0c 00 00       	call   800cbb <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  800049:	00 c0 ee 
  80004c:	75 34                	jne    800082 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800060:	00 
  800061:	89 34 24             	mov    %esi,(%esp)
  800064:	e8 f8 0e 00 00       	call   800f61 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  800069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80006c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	c7 04 24 60 21 80 00 	movl   $0x802160,(%esp)
  80007b:	e8 76 01 00 00       	call   8001f6 <cprintf>
  800080:	eb cf                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800082:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800087:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008f:	c7 04 24 71 21 80 00 	movl   $0x802171,(%esp)
  800096:	e8 5b 01 00 00       	call   8001f6 <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  8000a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 04 24             	mov    %eax,(%esp)
  8000bb:	e8 0b 0f 00 00       	call   800fcb <ipc_send>
  8000c0:	eb d9                	jmp    80009b <umain+0x68>

008000c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c2:	55                   	push   %ebp
  8000c3:	89 e5                	mov    %esp,%ebp
  8000c5:	56                   	push   %esi
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 10             	sub    $0x10,%esp
  8000ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000cd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8000d0:	e8 e6 0b 00 00       	call   800cbb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8000d5:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8000db:	39 c2                	cmp    %eax,%edx
  8000dd:	74 17                	je     8000f6 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000df:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8000e4:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8000e7:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000ed:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000f0:	39 c1                	cmp    %eax,%ecx
  8000f2:	75 18                	jne    80010c <libmain+0x4a>
  8000f4:	eb 05                	jmp    8000fb <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000f6:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000fb:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000fe:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800104:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80010a:	eb 0b                	jmp    800117 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80010c:	83 c2 01             	add    $0x1,%edx
  80010f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800115:	75 cd                	jne    8000e4 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800117:	85 db                	test   %ebx,%ebx
  800119:	7e 07                	jle    800122 <libmain+0x60>
		binaryname = argv[0];
  80011b:	8b 06                	mov    (%esi),%eax
  80011d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800122:	89 74 24 04          	mov    %esi,0x4(%esp)
  800126:	89 1c 24             	mov    %ebx,(%esp)
  800129:	e8 05 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80012e:	e8 07 00 00 00       	call   80013a <exit>
}
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5d                   	pop    %ebp
  800139:	c3                   	ret    

0080013a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800140:	e8 51 11 00 00       	call   801296 <close_all>
	sys_env_destroy(0);
  800145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014c:	e8 18 0b 00 00       	call   800c69 <sys_env_destroy>
}
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	53                   	push   %ebx
  800157:	83 ec 14             	sub    $0x14,%esp
  80015a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015d:	8b 13                	mov    (%ebx),%edx
  80015f:	8d 42 01             	lea    0x1(%edx),%eax
  800162:	89 03                	mov    %eax,(%ebx)
  800164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800167:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	75 19                	jne    80018b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800172:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800179:	00 
  80017a:	8d 43 08             	lea    0x8(%ebx),%eax
  80017d:	89 04 24             	mov    %eax,(%esp)
  800180:	e8 a7 0a 00 00       	call   800c2c <sys_cputs>
		b->idx = 0;
  800185:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80018b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018f:	83 c4 14             	add    $0x14,%esp
  800192:	5b                   	pop    %ebx
  800193:	5d                   	pop    %ebp
  800194:	c3                   	ret    

00800195 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80019e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a5:	00 00 00 
	b.cnt = 0;
  8001a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001af:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ca:	c7 04 24 53 01 80 00 	movl   $0x800153,(%esp)
  8001d1:	e8 ae 01 00 00       	call   800384 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 3e 0a 00 00       	call   800c2c <sys_cputs>

	return b.cnt;
}
  8001ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800203:	8b 45 08             	mov    0x8(%ebp),%eax
  800206:	89 04 24             	mov    %eax,(%esp)
  800209:	e8 87 ff ff ff       	call   800195 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 3c             	sub    $0x3c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
  800227:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800232:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800235:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800238:	39 f1                	cmp    %esi,%ecx
  80023a:	72 14                	jb     800250 <printnum+0x40>
  80023c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80023f:	76 0f                	jbe    800250 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800241:	8b 45 14             	mov    0x14(%ebp),%eax
  800244:	8d 70 ff             	lea    -0x1(%eax),%esi
  800247:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80024a:	85 f6                	test   %esi,%esi
  80024c:	7f 60                	jg     8002ae <printnum+0x9e>
  80024e:	eb 72                	jmp    8002c2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800250:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800253:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800257:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80025a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80025d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800261:	89 44 24 08          	mov    %eax,0x8(%esp)
  800265:	8b 44 24 08          	mov    0x8(%esp),%eax
  800269:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80026d:	89 c3                	mov    %eax,%ebx
  80026f:	89 d6                	mov    %edx,%esi
  800271:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800274:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800277:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	89 04 24             	mov    %eax,(%esp)
  800285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028c:	e8 2f 1c 00 00       	call   801ec0 <__udivdi3>
  800291:	89 d9                	mov    %ebx,%ecx
  800293:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800297:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029b:	89 04 24             	mov    %eax,(%esp)
  80029e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a7:	e8 64 ff ff ff       	call   800210 <printnum>
  8002ac:	eb 14                	jmp    8002c2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ba:	83 ee 01             	sub    $0x1,%esi
  8002bd:	75 ef                	jne    8002ae <printnum+0x9e>
  8002bf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002db:	89 04 24             	mov    %eax,(%esp)
  8002de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e5:	e8 06 1d 00 00       	call   801ff0 <__umoddi3>
  8002ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ee:	0f be 80 92 21 80 00 	movsbl 0x802192(%eax),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fb:	ff d0                	call   *%eax
}
  8002fd:	83 c4 3c             	add    $0x3c,%esp
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800308:	83 fa 01             	cmp    $0x1,%edx
  80030b:	7e 0e                	jle    80031b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800312:	89 08                	mov    %ecx,(%eax)
  800314:	8b 02                	mov    (%edx),%eax
  800316:	8b 52 04             	mov    0x4(%edx),%edx
  800319:	eb 22                	jmp    80033d <getuint+0x38>
	else if (lflag)
  80031b:	85 d2                	test   %edx,%edx
  80031d:	74 10                	je     80032f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80031f:	8b 10                	mov    (%eax),%edx
  800321:	8d 4a 04             	lea    0x4(%edx),%ecx
  800324:	89 08                	mov    %ecx,(%eax)
  800326:	8b 02                	mov    (%edx),%eax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	eb 0e                	jmp    80033d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80032f:	8b 10                	mov    (%eax),%edx
  800331:	8d 4a 04             	lea    0x4(%edx),%ecx
  800334:	89 08                	mov    %ecx,(%eax)
  800336:	8b 02                	mov    (%edx),%eax
  800338:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800345:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	3b 50 04             	cmp    0x4(%eax),%edx
  80034e:	73 0a                	jae    80035a <sprintputch+0x1b>
		*b->buf++ = ch;
  800350:	8d 4a 01             	lea    0x1(%edx),%ecx
  800353:	89 08                	mov    %ecx,(%eax)
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	88 02                	mov    %al,(%edx)
}
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800362:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800365:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800369:	8b 45 10             	mov    0x10(%ebp),%eax
  80036c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	89 44 24 04          	mov    %eax,0x4(%esp)
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	89 04 24             	mov    %eax,(%esp)
  80037d:	e8 02 00 00 00       	call   800384 <vprintfmt>
	va_end(ap);
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 3c             	sub    $0x3c,%esp
  80038d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800390:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800393:	eb 18                	jmp    8003ad <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800395:	85 c0                	test   %eax,%eax
  800397:	0f 84 c3 03 00 00    	je     800760 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80039d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a1:	89 04 24             	mov    %eax,(%esp)
  8003a4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a7:	89 f3                	mov    %esi,%ebx
  8003a9:	eb 02                	jmp    8003ad <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003ab:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ad:	8d 73 01             	lea    0x1(%ebx),%esi
  8003b0:	0f b6 03             	movzbl (%ebx),%eax
  8003b3:	83 f8 25             	cmp    $0x25,%eax
  8003b6:	75 dd                	jne    800395 <vprintfmt+0x11>
  8003b8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003c3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d6:	eb 1d                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003da:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8003de:	eb 15                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8003e6:	eb 0d                	jmp    8003f5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ee:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003f8:	0f b6 06             	movzbl (%esi),%eax
  8003fb:	0f b6 c8             	movzbl %al,%ecx
  8003fe:	83 e8 23             	sub    $0x23,%eax
  800401:	3c 55                	cmp    $0x55,%al
  800403:	0f 87 2f 03 00 00    	ja     800738 <vprintfmt+0x3b4>
  800409:	0f b6 c0             	movzbl %al,%eax
  80040c:	ff 24 85 e0 22 80 00 	jmp    *0x8022e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800413:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800419:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80041d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800420:	83 f9 09             	cmp    $0x9,%ecx
  800423:	77 50                	ja     800475 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800425:	89 de                	mov    %ebx,%esi
  800427:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80042a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80042d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800430:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800434:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800437:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80043a:	83 fb 09             	cmp    $0x9,%ebx
  80043d:	76 eb                	jbe    80042a <vprintfmt+0xa6>
  80043f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800442:	eb 33                	jmp    800477 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 48 04             	lea    0x4(%eax),%ecx
  80044a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800454:	eb 21                	jmp    800477 <vprintfmt+0xf3>
  800456:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800459:	85 c9                	test   %ecx,%ecx
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c1             	cmovns %ecx,%eax
  800463:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	89 de                	mov    %ebx,%esi
  800468:	eb 8b                	jmp    8003f5 <vprintfmt+0x71>
  80046a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800473:	eb 80                	jmp    8003f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800475:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800477:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80047b:	0f 89 74 ff ff ff    	jns    8003f5 <vprintfmt+0x71>
  800481:	e9 62 ff ff ff       	jmp    8003e8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800486:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800489:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80048b:	e9 65 ff ff ff       	jmp    8003f5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	89 55 14             	mov    %edx,0x14(%ebp)
  800499:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 04 24             	mov    %eax,(%esp)
  8004a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004a5:	e9 03 ff ff ff       	jmp    8003ad <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8d 50 04             	lea    0x4(%eax),%edx
  8004b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	99                   	cltd   
  8004b6:	31 d0                	xor    %edx,%eax
  8004b8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ba:	83 f8 0f             	cmp    $0xf,%eax
  8004bd:	7f 0b                	jg     8004ca <vprintfmt+0x146>
  8004bf:	8b 14 85 40 24 80 00 	mov    0x802440(,%eax,4),%edx
  8004c6:	85 d2                	test   %edx,%edx
  8004c8:	75 20                	jne    8004ea <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ce:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  8004d5:	00 
  8004d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 77 fe ff ff       	call   80035c <printfmt>
  8004e5:	e9 c3 fe ff ff       	jmp    8003ad <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8004ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ee:	c7 44 24 08 73 25 80 	movl   $0x802573,0x8(%esp)
  8004f5:	00 
  8004f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 57 fe ff ff       	call   80035c <printfmt>
  800505:	e9 a3 fe ff ff       	jmp    8003ad <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80050d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 50 04             	lea    0x4(%eax),%edx
  800516:	89 55 14             	mov    %edx,0x14(%ebp)
  800519:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80051b:	85 c0                	test   %eax,%eax
  80051d:	ba a3 21 80 00       	mov    $0x8021a3,%edx
  800522:	0f 45 d0             	cmovne %eax,%edx
  800525:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800528:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80052c:	74 04                	je     800532 <vprintfmt+0x1ae>
  80052e:	85 f6                	test   %esi,%esi
  800530:	7f 19                	jg     80054b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800532:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800535:	8d 70 01             	lea    0x1(%eax),%esi
  800538:	0f b6 10             	movzbl (%eax),%edx
  80053b:	0f be c2             	movsbl %dl,%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	0f 85 95 00 00 00    	jne    8005db <vprintfmt+0x257>
  800546:	e9 85 00 00 00       	jmp    8005d0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80054f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800552:	89 04 24             	mov    %eax,(%esp)
  800555:	e8 b8 02 00 00       	call   800812 <strnlen>
  80055a:	29 c6                	sub    %eax,%esi
  80055c:	89 f0                	mov    %esi,%eax
  80055e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800561:	85 f6                	test   %esi,%esi
  800563:	7e cd                	jle    800532 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800565:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800569:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80056c:	89 c3                	mov    %eax,%ebx
  80056e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800572:	89 34 24             	mov    %esi,(%esp)
  800575:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	75 f1                	jne    80056e <vprintfmt+0x1ea>
  80057d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800580:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800583:	eb ad                	jmp    800532 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800589:	74 1e                	je     8005a9 <vprintfmt+0x225>
  80058b:	0f be d2             	movsbl %dl,%edx
  80058e:	83 ea 20             	sub    $0x20,%edx
  800591:	83 fa 5e             	cmp    $0x5e,%edx
  800594:	76 13                	jbe    8005a9 <vprintfmt+0x225>
					putch('?', putdat);
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a4:	ff 55 08             	call   *0x8(%ebp)
  8005a7:	eb 0d                	jmp    8005b6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c6 01             	add    $0x1,%esi
  8005bc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005c0:	0f be c2             	movsbl %dl,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	75 20                	jne    8005e7 <vprintfmt+0x263>
  8005c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d4:	7f 25                	jg     8005fb <vprintfmt+0x277>
  8005d6:	e9 d2 fd ff ff       	jmp    8003ad <vprintfmt+0x29>
  8005db:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e7:	85 db                	test   %ebx,%ebx
  8005e9:	78 9a                	js     800585 <vprintfmt+0x201>
  8005eb:	83 eb 01             	sub    $0x1,%ebx
  8005ee:	79 95                	jns    800585 <vprintfmt+0x201>
  8005f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f9:	eb d5                	jmp    8005d0 <vprintfmt+0x24c>
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800604:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800608:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80060f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800611:	83 eb 01             	sub    $0x1,%ebx
  800614:	75 ee                	jne    800604 <vprintfmt+0x280>
  800616:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800619:	e9 8f fd ff ff       	jmp    8003ad <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061e:	83 fa 01             	cmp    $0x1,%edx
  800621:	7e 16                	jle    800639 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 50 08             	lea    0x8(%eax),%edx
  800629:	89 55 14             	mov    %edx,0x14(%ebp)
  80062c:	8b 50 04             	mov    0x4(%eax),%edx
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800634:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800637:	eb 32                	jmp    80066b <vprintfmt+0x2e7>
	else if (lflag)
  800639:	85 d2                	test   %edx,%edx
  80063b:	74 18                	je     800655 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 50 04             	lea    0x4(%eax),%edx
  800643:	89 55 14             	mov    %edx,0x14(%ebp)
  800646:	8b 30                	mov    (%eax),%esi
  800648:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80064b:	89 f0                	mov    %esi,%eax
  80064d:	c1 f8 1f             	sar    $0x1f,%eax
  800650:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800653:	eb 16                	jmp    80066b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 50 04             	lea    0x4(%eax),%edx
  80065b:	89 55 14             	mov    %edx,0x14(%ebp)
  80065e:	8b 30                	mov    (%eax),%esi
  800660:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800663:	89 f0                	mov    %esi,%eax
  800665:	c1 f8 1f             	sar    $0x1f,%eax
  800668:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80066e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800671:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800676:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067a:	0f 89 80 00 00 00    	jns    800700 <vprintfmt+0x37c>
				putch('-', putdat);
  800680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800684:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80068b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80068e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800691:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800694:	f7 d8                	neg    %eax
  800696:	83 d2 00             	adc    $0x0,%edx
  800699:	f7 da                	neg    %edx
			}
			base = 10;
  80069b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006a0:	eb 5e                	jmp    800700 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a5:	e8 5b fc ff ff       	call   800305 <getuint>
			base = 10;
  8006aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006af:	eb 4f                	jmp    800700 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b4:	e8 4c fc ff ff       	call   800305 <getuint>
			base = 8;
  8006b9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006be:	eb 40                	jmp    800700 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006d9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ec:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006f1:	eb 0d                	jmp    800700 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 0a fc ff ff       	call   800305 <getuint>
			base = 16;
  8006fb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800700:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800704:	89 74 24 10          	mov    %esi,0x10(%esp)
  800708:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80070b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80070f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800713:	89 04 24             	mov    %eax,(%esp)
  800716:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071a:	89 fa                	mov    %edi,%edx
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	e8 ec fa ff ff       	call   800210 <printnum>
			break;
  800724:	e9 84 fc ff ff       	jmp    8003ad <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800729:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072d:	89 0c 24             	mov    %ecx,(%esp)
  800730:	ff 55 08             	call   *0x8(%ebp)
			break;
  800733:	e9 75 fc ff ff       	jmp    8003ad <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800738:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800743:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800746:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80074a:	0f 84 5b fc ff ff    	je     8003ab <vprintfmt+0x27>
  800750:	89 f3                	mov    %esi,%ebx
  800752:	83 eb 01             	sub    $0x1,%ebx
  800755:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800759:	75 f7                	jne    800752 <vprintfmt+0x3ce>
  80075b:	e9 4d fc ff ff       	jmp    8003ad <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800760:	83 c4 3c             	add    $0x3c,%esp
  800763:	5b                   	pop    %ebx
  800764:	5e                   	pop    %esi
  800765:	5f                   	pop    %edi
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	83 ec 28             	sub    $0x28,%esp
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800774:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800777:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800785:	85 c0                	test   %eax,%eax
  800787:	74 30                	je     8007b9 <vsnprintf+0x51>
  800789:	85 d2                	test   %edx,%edx
  80078b:	7e 2c                	jle    8007b9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a2:	c7 04 24 3f 03 80 00 	movl   $0x80033f,(%esp)
  8007a9:	e8 d6 fb ff ff       	call   800384 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b7:	eb 05                	jmp    8007be <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	89 04 24             	mov    %eax,(%esp)
  8007e1:	e8 82 ff ff ff       	call   800768 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    
  8007e8:	66 90                	xchg   %ax,%ax
  8007ea:	66 90                	xchg   %ax,%ax
  8007ec:	66 90                	xchg   %ax,%ax
  8007ee:	66 90                	xchg   %ax,%ax

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	80 3a 00             	cmpb   $0x0,(%edx)
  8007f9:	74 10                	je     80080b <strlen+0x1b>
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800807:	75 f7                	jne    800800 <strlen+0x10>
  800809:	eb 05                	jmp    800810 <strlen+0x20>
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081c:	85 c9                	test   %ecx,%ecx
  80081e:	74 1c                	je     80083c <strnlen+0x2a>
  800820:	80 3b 00             	cmpb   $0x0,(%ebx)
  800823:	74 1e                	je     800843 <strnlen+0x31>
  800825:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80082a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082c:	39 ca                	cmp    %ecx,%edx
  80082e:	74 18                	je     800848 <strnlen+0x36>
  800830:	83 c2 01             	add    $0x1,%edx
  800833:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800838:	75 f0                	jne    80082a <strnlen+0x18>
  80083a:	eb 0c                	jmp    800848 <strnlen+0x36>
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb 05                	jmp    800848 <strnlen+0x36>
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800848:	5b                   	pop    %ebx
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800855:	89 c2                	mov    %eax,%edx
  800857:	83 c2 01             	add    $0x1,%edx
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800861:	88 5a ff             	mov    %bl,-0x1(%edx)
  800864:	84 db                	test   %bl,%bl
  800866:	75 ef                	jne    800857 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800868:	5b                   	pop    %ebx
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800875:	89 1c 24             	mov    %ebx,(%esp)
  800878:	e8 73 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800880:	89 54 24 04          	mov    %edx,0x4(%esp)
  800884:	01 d8                	add    %ebx,%eax
  800886:	89 04 24             	mov    %eax,(%esp)
  800889:	e8 bd ff ff ff       	call   80084b <strcpy>
	return dst;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	83 c4 08             	add    $0x8,%esp
  800893:	5b                   	pop    %ebx
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a4:	85 db                	test   %ebx,%ebx
  8008a6:	74 17                	je     8008bf <strncpy+0x29>
  8008a8:	01 f3                	add    %esi,%ebx
  8008aa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008ac:	83 c1 01             	add    $0x1,%ecx
  8008af:	0f b6 02             	movzbl (%edx),%eax
  8008b2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008b8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008bb:	39 d9                	cmp    %ebx,%ecx
  8008bd:	75 ed                	jne    8008ac <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008bf:	89 f0                	mov    %esi,%eax
  8008c1:	5b                   	pop    %ebx
  8008c2:	5e                   	pop    %esi
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	57                   	push   %edi
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
  8008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d1:	8b 75 10             	mov    0x10(%ebp),%esi
  8008d4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	74 34                	je     80090e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8008da:	83 fe 01             	cmp    $0x1,%esi
  8008dd:	74 26                	je     800905 <strlcpy+0x40>
  8008df:	0f b6 0b             	movzbl (%ebx),%ecx
  8008e2:	84 c9                	test   %cl,%cl
  8008e4:	74 23                	je     800909 <strlcpy+0x44>
  8008e6:	83 ee 02             	sub    $0x2,%esi
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8008ee:	83 c0 01             	add    $0x1,%eax
  8008f1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008f4:	39 f2                	cmp    %esi,%edx
  8008f6:	74 13                	je     80090b <strlcpy+0x46>
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ff:	84 c9                	test   %cl,%cl
  800901:	75 eb                	jne    8008ee <strlcpy+0x29>
  800903:	eb 06                	jmp    80090b <strlcpy+0x46>
  800905:	89 f8                	mov    %edi,%eax
  800907:	eb 02                	jmp    80090b <strlcpy+0x46>
  800909:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090e:	29 f8                	sub    %edi,%eax
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5f                   	pop    %edi
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091e:	0f b6 01             	movzbl (%ecx),%eax
  800921:	84 c0                	test   %al,%al
  800923:	74 15                	je     80093a <strcmp+0x25>
  800925:	3a 02                	cmp    (%edx),%al
  800927:	75 11                	jne    80093a <strcmp+0x25>
		p++, q++;
  800929:	83 c1 01             	add    $0x1,%ecx
  80092c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092f:	0f b6 01             	movzbl (%ecx),%eax
  800932:	84 c0                	test   %al,%al
  800934:	74 04                	je     80093a <strcmp+0x25>
  800936:	3a 02                	cmp    (%edx),%al
  800938:	74 ef                	je     800929 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093a:	0f b6 c0             	movzbl %al,%eax
  80093d:	0f b6 12             	movzbl (%edx),%edx
  800940:	29 d0                	sub    %edx,%eax
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	56                   	push   %esi
  800948:	53                   	push   %ebx
  800949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800952:	85 f6                	test   %esi,%esi
  800954:	74 29                	je     80097f <strncmp+0x3b>
  800956:	0f b6 03             	movzbl (%ebx),%eax
  800959:	84 c0                	test   %al,%al
  80095b:	74 30                	je     80098d <strncmp+0x49>
  80095d:	3a 02                	cmp    (%edx),%al
  80095f:	75 2c                	jne    80098d <strncmp+0x49>
  800961:	8d 43 01             	lea    0x1(%ebx),%eax
  800964:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800966:	89 c3                	mov    %eax,%ebx
  800968:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096b:	39 f0                	cmp    %esi,%eax
  80096d:	74 17                	je     800986 <strncmp+0x42>
  80096f:	0f b6 08             	movzbl (%eax),%ecx
  800972:	84 c9                	test   %cl,%cl
  800974:	74 17                	je     80098d <strncmp+0x49>
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	3a 0a                	cmp    (%edx),%cl
  80097b:	74 e9                	je     800966 <strncmp+0x22>
  80097d:	eb 0e                	jmp    80098d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80097f:	b8 00 00 00 00       	mov    $0x0,%eax
  800984:	eb 0f                	jmp    800995 <strncmp+0x51>
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb 08                	jmp    800995 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80098d:	0f b6 03             	movzbl (%ebx),%eax
  800990:	0f b6 12             	movzbl (%edx),%edx
  800993:	29 d0                	sub    %edx,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009a3:	0f b6 18             	movzbl (%eax),%ebx
  8009a6:	84 db                	test   %bl,%bl
  8009a8:	74 1d                	je     8009c7 <strchr+0x2e>
  8009aa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009ac:	38 d3                	cmp    %dl,%bl
  8009ae:	75 06                	jne    8009b6 <strchr+0x1d>
  8009b0:	eb 1a                	jmp    8009cc <strchr+0x33>
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 16                	je     8009cc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	0f b6 10             	movzbl (%eax),%edx
  8009bc:	84 d2                	test   %dl,%dl
  8009be:	75 f2                	jne    8009b2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	eb 05                	jmp    8009cc <strchr+0x33>
  8009c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cc:	5b                   	pop    %ebx
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009d9:	0f b6 18             	movzbl (%eax),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 16                	je     8009f6 <strfind+0x27>
  8009e0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009e2:	38 d3                	cmp    %dl,%bl
  8009e4:	75 06                	jne    8009ec <strfind+0x1d>
  8009e6:	eb 0e                	jmp    8009f6 <strfind+0x27>
  8009e8:	38 ca                	cmp    %cl,%dl
  8009ea:	74 0a                	je     8009f6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	0f b6 10             	movzbl (%eax),%edx
  8009f2:	84 d2                	test   %dl,%dl
  8009f4:	75 f2                	jne    8009e8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	57                   	push   %edi
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a05:	85 c9                	test   %ecx,%ecx
  800a07:	74 36                	je     800a3f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0f:	75 28                	jne    800a39 <memset+0x40>
  800a11:	f6 c1 03             	test   $0x3,%cl
  800a14:	75 23                	jne    800a39 <memset+0x40>
		c &= 0xFF;
  800a16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1a:	89 d3                	mov    %edx,%ebx
  800a1c:	c1 e3 08             	shl    $0x8,%ebx
  800a1f:	89 d6                	mov    %edx,%esi
  800a21:	c1 e6 18             	shl    $0x18,%esi
  800a24:	89 d0                	mov    %edx,%eax
  800a26:	c1 e0 10             	shl    $0x10,%eax
  800a29:	09 f0                	or     %esi,%eax
  800a2b:	09 c2                	or     %eax,%edx
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a31:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a34:	fc                   	cld    
  800a35:	f3 ab                	rep stos %eax,%es:(%edi)
  800a37:	eb 06                	jmp    800a3f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	fc                   	cld    
  800a3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3f:	89 f8                	mov    %edi,%eax
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5f                   	pop    %edi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	57                   	push   %edi
  800a4a:	56                   	push   %esi
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a54:	39 c6                	cmp    %eax,%esi
  800a56:	73 35                	jae    800a8d <memmove+0x47>
  800a58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5b:	39 d0                	cmp    %edx,%eax
  800a5d:	73 2e                	jae    800a8d <memmove+0x47>
		s += n;
		d += n;
  800a5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a62:	89 d6                	mov    %edx,%esi
  800a64:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6c:	75 13                	jne    800a81 <memmove+0x3b>
  800a6e:	f6 c1 03             	test   $0x3,%cl
  800a71:	75 0e                	jne    800a81 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a73:	83 ef 04             	sub    $0x4,%edi
  800a76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a79:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a7c:	fd                   	std    
  800a7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7f:	eb 09                	jmp    800a8a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a81:	83 ef 01             	sub    $0x1,%edi
  800a84:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a87:	fd                   	std    
  800a88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8a:	fc                   	cld    
  800a8b:	eb 1d                	jmp    800aaa <memmove+0x64>
  800a8d:	89 f2                	mov    %esi,%edx
  800a8f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	f6 c2 03             	test   $0x3,%dl
  800a94:	75 0f                	jne    800aa5 <memmove+0x5f>
  800a96:	f6 c1 03             	test   $0x3,%cl
  800a99:	75 0a                	jne    800aa5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	fc                   	cld    
  800aa1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa3:	eb 05                	jmp    800aaa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	fc                   	cld    
  800aa8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 04 24             	mov    %eax,(%esp)
  800ac8:	e8 79 ff ff ff       	call   800a46 <memmove>
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
  800ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ade:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 36                	je     800b1b <memcmp+0x4c>
		if (*s1 != *s2)
  800ae5:	0f b6 03             	movzbl (%ebx),%eax
  800ae8:	0f b6 0e             	movzbl (%esi),%ecx
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	38 c8                	cmp    %cl,%al
  800af2:	74 1c                	je     800b10 <memcmp+0x41>
  800af4:	eb 10                	jmp    800b06 <memcmp+0x37>
  800af6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800afb:	83 c2 01             	add    $0x1,%edx
  800afe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b02:	38 c8                	cmp    %cl,%al
  800b04:	74 0a                	je     800b10 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b06:	0f b6 c0             	movzbl %al,%eax
  800b09:	0f b6 c9             	movzbl %cl,%ecx
  800b0c:	29 c8                	sub    %ecx,%eax
  800b0e:	eb 10                	jmp    800b20 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b10:	39 fa                	cmp    %edi,%edx
  800b12:	75 e2                	jne    800af6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	eb 05                	jmp    800b20 <memcmp+0x51>
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5f                   	pop    %edi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	53                   	push   %ebx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	39 d0                	cmp    %edx,%eax
  800b36:	73 13                	jae    800b4b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b38:	89 d9                	mov    %ebx,%ecx
  800b3a:	38 18                	cmp    %bl,(%eax)
  800b3c:	75 06                	jne    800b44 <memfind+0x1f>
  800b3e:	eb 0b                	jmp    800b4b <memfind+0x26>
  800b40:	38 08                	cmp    %cl,(%eax)
  800b42:	74 07                	je     800b4b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	39 d0                	cmp    %edx,%eax
  800b49:	75 f5                	jne    800b40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5a:	0f b6 0a             	movzbl (%edx),%ecx
  800b5d:	80 f9 09             	cmp    $0x9,%cl
  800b60:	74 05                	je     800b67 <strtol+0x19>
  800b62:	80 f9 20             	cmp    $0x20,%cl
  800b65:	75 10                	jne    800b77 <strtol+0x29>
		s++;
  800b67:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6a:	0f b6 0a             	movzbl (%edx),%ecx
  800b6d:	80 f9 09             	cmp    $0x9,%cl
  800b70:	74 f5                	je     800b67 <strtol+0x19>
  800b72:	80 f9 20             	cmp    $0x20,%cl
  800b75:	74 f0                	je     800b67 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b77:	80 f9 2b             	cmp    $0x2b,%cl
  800b7a:	75 0a                	jne    800b86 <strtol+0x38>
		s++;
  800b7c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b84:	eb 11                	jmp    800b97 <strtol+0x49>
  800b86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b8b:	80 f9 2d             	cmp    $0x2d,%cl
  800b8e:	75 07                	jne    800b97 <strtol+0x49>
		s++, neg = 1;
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b97:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b9c:	75 15                	jne    800bb3 <strtol+0x65>
  800b9e:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba1:	75 10                	jne    800bb3 <strtol+0x65>
  800ba3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba7:	75 0a                	jne    800bb3 <strtol+0x65>
		s += 2, base = 16;
  800ba9:	83 c2 02             	add    $0x2,%edx
  800bac:	b8 10 00 00 00       	mov    $0x10,%eax
  800bb1:	eb 10                	jmp    800bc3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	75 0c                	jne    800bc3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bbc:	75 05                	jne    800bc3 <strtol+0x75>
		s++, base = 8;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bcb:	0f b6 0a             	movzbl (%edx),%ecx
  800bce:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bd1:	89 f0                	mov    %esi,%eax
  800bd3:	3c 09                	cmp    $0x9,%al
  800bd5:	77 08                	ja     800bdf <strtol+0x91>
			dig = *s - '0';
  800bd7:	0f be c9             	movsbl %cl,%ecx
  800bda:	83 e9 30             	sub    $0x30,%ecx
  800bdd:	eb 20                	jmp    800bff <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800bdf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800be2:	89 f0                	mov    %esi,%eax
  800be4:	3c 19                	cmp    $0x19,%al
  800be6:	77 08                	ja     800bf0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800be8:	0f be c9             	movsbl %cl,%ecx
  800beb:	83 e9 57             	sub    $0x57,%ecx
  800bee:	eb 0f                	jmp    800bff <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800bf0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bf3:	89 f0                	mov    %esi,%eax
  800bf5:	3c 19                	cmp    $0x19,%al
  800bf7:	77 16                	ja     800c0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bf9:	0f be c9             	movsbl %cl,%ecx
  800bfc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bff:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c02:	7d 0f                	jge    800c13 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c0b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c0d:	eb bc                	jmp    800bcb <strtol+0x7d>
  800c0f:	89 d8                	mov    %ebx,%eax
  800c11:	eb 02                	jmp    800c15 <strtol+0xc7>
  800c13:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c19:	74 05                	je     800c20 <strtol+0xd2>
		*endptr = (char *) s;
  800c1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c20:	f7 d8                	neg    %eax
  800c22:	85 ff                	test   %edi,%edi
  800c24:	0f 44 c3             	cmove  %ebx,%eax
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c32:	b8 00 00 00 00       	mov    $0x0,%eax
  800c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	89 c3                	mov    %eax,%ebx
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	89 c6                	mov    %eax,%esi
  800c43:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5a:	89 d1                	mov    %edx,%ecx
  800c5c:	89 d3                	mov    %edx,%ebx
  800c5e:	89 d7                	mov    %edx,%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c77:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	89 cb                	mov    %ecx,%ebx
  800c81:	89 cf                	mov    %ecx,%edi
  800c83:	89 ce                	mov    %ecx,%esi
  800c85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7e 28                	jle    800cb3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c96:	00 
  800c97:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800c9e:	00 
  800c9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ca6:	00 
  800ca7:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800cae:	e8 73 11 00 00       	call   801e26 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cb3:	83 c4 2c             	add    $0x2c,%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc6:	b8 02 00 00 00       	mov    $0x2,%eax
  800ccb:	89 d1                	mov    %edx,%ecx
  800ccd:	89 d3                	mov    %edx,%ebx
  800ccf:	89 d7                	mov    %edx,%edi
  800cd1:	89 d6                	mov    %edx,%esi
  800cd3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_yield>:

void
sys_yield(void)
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
  800ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d02:	be 00 00 00 00       	mov    $0x0,%esi
  800d07:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d15:	89 f7                	mov    %esi,%edi
  800d17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7e 28                	jle    800d45 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d21:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d28:	00 
  800d29:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800d30:	00 
  800d31:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d38:	00 
  800d39:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800d40:	e8 e1 10 00 00       	call   801e26 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d45:	83 c4 2c             	add    $0x2c,%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d56:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d67:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7e 28                	jle    800d98 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d74:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d7b:	00 
  800d7c:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800d83:	00 
  800d84:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d8b:	00 
  800d8c:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800d93:	e8 8e 10 00 00       	call   801e26 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d98:	83 c4 2c             	add    $0x2c,%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dae:	b8 06 00 00 00       	mov    $0x6,%eax
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	89 de                	mov    %ebx,%esi
  800dbd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7e 28                	jle    800deb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dce:	00 
  800dcf:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dde:	00 
  800ddf:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800de6:	e8 3b 10 00 00       	call   801e26 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	83 c4 2c             	add    $0x2c,%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	b8 08 00 00 00       	mov    $0x8,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7e 28                	jle    800e3e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e21:	00 
  800e22:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800e29:	00 
  800e2a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e31:	00 
  800e32:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800e39:	e8 e8 0f 00 00       	call   801e26 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3e:	83 c4 2c             	add    $0x2c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	b8 09 00 00 00       	mov    $0x9,%eax
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7e 28                	jle    800e91 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e69:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e74:	00 
  800e75:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800e7c:	00 
  800e7d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e84:	00 
  800e85:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800e8c:	e8 95 0f 00 00       	call   801e26 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e91:	83 c4 2c             	add    $0x2c,%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	89 df                	mov    %ebx,%edi
  800eb4:	89 de                	mov    %ebx,%esi
  800eb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7e 28                	jle    800ee4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ed7:	00 
  800ed8:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800edf:	e8 42 0f 00 00       	call   801e26 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee4:	83 c4 2c             	add    $0x2c,%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef2:	be 00 00 00 00       	mov    $0x0,%esi
  800ef7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f05:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f08:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	89 cb                	mov    %ecx,%ebx
  800f27:	89 cf                	mov    %ecx,%edi
  800f29:	89 ce                	mov    %ecx,%esi
  800f2b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	7e 28                	jle    800f59 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f35:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 08 9f 24 80 	movl   $0x80249f,0x8(%esp)
  800f44:	00 
  800f45:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f4c:	00 
  800f4d:	c7 04 24 bc 24 80 00 	movl   $0x8024bc,(%esp)
  800f54:	e8 cd 0e 00 00       	call   801e26 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f59:	83 c4 2c             	add    $0x2c,%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 10             	sub    $0x10,%esp
  800f69:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  800f72:	83 f8 01             	cmp    $0x1,%eax
  800f75:	19 c0                	sbb    %eax,%eax
  800f77:	f7 d0                	not    %eax
  800f79:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  800f7e:	89 04 24             	mov    %eax,(%esp)
  800f81:	e8 89 ff ff ff       	call   800f0f <sys_ipc_recv>
	if (err_code < 0) {
  800f86:	85 c0                	test   %eax,%eax
  800f88:	79 16                	jns    800fa0 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  800f8a:	85 f6                	test   %esi,%esi
  800f8c:	74 06                	je     800f94 <ipc_recv+0x33>
  800f8e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  800f94:	85 db                	test   %ebx,%ebx
  800f96:	74 2c                	je     800fc4 <ipc_recv+0x63>
  800f98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800f9e:	eb 24                	jmp    800fc4 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  800fa0:	85 f6                	test   %esi,%esi
  800fa2:	74 0a                	je     800fae <ipc_recv+0x4d>
  800fa4:	a1 04 40 80 00       	mov    0x804004,%eax
  800fa9:	8b 40 74             	mov    0x74(%eax),%eax
  800fac:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  800fae:	85 db                	test   %ebx,%ebx
  800fb0:	74 0a                	je     800fbc <ipc_recv+0x5b>
  800fb2:	a1 04 40 80 00       	mov    0x804004,%eax
  800fb7:	8b 40 78             	mov    0x78(%eax),%eax
  800fba:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  800fbc:	a1 04 40 80 00       	mov    0x804004,%eax
  800fc1:	8b 40 70             	mov    0x70(%eax),%eax
}
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 1c             	sub    $0x1c,%esp
  800fd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fd7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  800fdd:	eb 25                	jmp    801004 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  800fdf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800fe2:	74 20                	je     801004 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  800fe4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fe8:	c7 44 24 08 ca 24 80 	movl   $0x8024ca,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 d6 24 80 00 	movl   $0x8024d6,(%esp)
  800fff:	e8 22 0e 00 00       	call   801e26 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801004:	85 db                	test   %ebx,%ebx
  801006:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80100b:	0f 45 c3             	cmovne %ebx,%eax
  80100e:	8b 55 14             	mov    0x14(%ebp),%edx
  801011:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801015:	89 44 24 08          	mov    %eax,0x8(%esp)
  801019:	89 74 24 04          	mov    %esi,0x4(%esp)
  80101d:	89 3c 24             	mov    %edi,(%esp)
  801020:	e8 c7 fe ff ff       	call   800eec <sys_ipc_try_send>
  801025:	85 c0                	test   %eax,%eax
  801027:	75 b6                	jne    800fdf <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801037:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80103c:	39 c8                	cmp    %ecx,%eax
  80103e:	74 17                	je     801057 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801040:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801045:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801048:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80104e:	8b 52 50             	mov    0x50(%edx),%edx
  801051:	39 ca                	cmp    %ecx,%edx
  801053:	75 14                	jne    801069 <ipc_find_env+0x38>
  801055:	eb 05                	jmp    80105c <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801057:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80105c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80105f:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801064:	8b 40 40             	mov    0x40(%eax),%eax
  801067:	eb 0e                	jmp    801077 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801069:	83 c0 01             	add    $0x1,%eax
  80106c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801071:	75 d2                	jne    801045 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801073:	66 b8 00 00          	mov    $0x0,%ax
}
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
  801079:	66 90                	xchg   %ax,%ax
  80107b:	66 90                	xchg   %ax,%ax
  80107d:	66 90                	xchg   %ax,%ax
  80107f:	90                   	nop

00801080 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
  80108b:	c1 e8 0c             	shr    $0xc,%eax
}
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80109b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010aa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010af:	a8 01                	test   $0x1,%al
  8010b1:	74 34                	je     8010e7 <fd_alloc+0x40>
  8010b3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8010b8:	a8 01                	test   $0x1,%al
  8010ba:	74 32                	je     8010ee <fd_alloc+0x47>
  8010bc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010c1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	c1 ea 16             	shr    $0x16,%edx
  8010c8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010cf:	f6 c2 01             	test   $0x1,%dl
  8010d2:	74 1f                	je     8010f3 <fd_alloc+0x4c>
  8010d4:	89 c2                	mov    %eax,%edx
  8010d6:	c1 ea 0c             	shr    $0xc,%edx
  8010d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e0:	f6 c2 01             	test   $0x1,%dl
  8010e3:	75 1a                	jne    8010ff <fd_alloc+0x58>
  8010e5:	eb 0c                	jmp    8010f3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8010e7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8010ec:	eb 05                	jmp    8010f3 <fd_alloc+0x4c>
  8010ee:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	eb 1a                	jmp    801119 <fd_alloc+0x72>
  8010ff:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801104:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801109:	75 b6                	jne    8010c1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801114:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801121:	83 f8 1f             	cmp    $0x1f,%eax
  801124:	77 36                	ja     80115c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801126:	c1 e0 0c             	shl    $0xc,%eax
  801129:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80112e:	89 c2                	mov    %eax,%edx
  801130:	c1 ea 16             	shr    $0x16,%edx
  801133:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80113a:	f6 c2 01             	test   $0x1,%dl
  80113d:	74 24                	je     801163 <fd_lookup+0x48>
  80113f:	89 c2                	mov    %eax,%edx
  801141:	c1 ea 0c             	shr    $0xc,%edx
  801144:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80114b:	f6 c2 01             	test   $0x1,%dl
  80114e:	74 1a                	je     80116a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801150:	8b 55 0c             	mov    0xc(%ebp),%edx
  801153:	89 02                	mov    %eax,(%edx)
	return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
  80115a:	eb 13                	jmp    80116f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801161:	eb 0c                	jmp    80116f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb 05                	jmp    80116f <fd_lookup+0x54>
  80116a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	53                   	push   %ebx
  801175:	83 ec 14             	sub    $0x14,%esp
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80117e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801184:	75 1e                	jne    8011a4 <dev_lookup+0x33>
  801186:	eb 0e                	jmp    801196 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801188:	b8 20 30 80 00       	mov    $0x803020,%eax
  80118d:	eb 0c                	jmp    80119b <dev_lookup+0x2a>
  80118f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801194:	eb 05                	jmp    80119b <dev_lookup+0x2a>
  801196:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80119b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	eb 38                	jmp    8011dc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8011a4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8011aa:	74 dc                	je     801188 <dev_lookup+0x17>
  8011ac:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8011b2:	74 db                	je     80118f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011b4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011ba:	8b 52 48             	mov    0x48(%edx),%edx
  8011bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011c5:	c7 04 24 e0 24 80 00 	movl   $0x8024e0,(%esp)
  8011cc:	e8 25 f0 ff ff       	call   8001f6 <cprintf>
	*dev = 0;
  8011d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8011d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011dc:	83 c4 14             	add    $0x14,%esp
  8011df:	5b                   	pop    %ebx
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    

008011e2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	56                   	push   %esi
  8011e6:	53                   	push   %ebx
  8011e7:	83 ec 20             	sub    $0x20,%esp
  8011ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011fd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801200:	89 04 24             	mov    %eax,(%esp)
  801203:	e8 13 ff ff ff       	call   80111b <fd_lookup>
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 05                	js     801211 <fd_close+0x2f>
	    || fd != fd2)
  80120c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80120f:	74 0c                	je     80121d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801211:	84 db                	test   %bl,%bl
  801213:	ba 00 00 00 00       	mov    $0x0,%edx
  801218:	0f 44 c2             	cmove  %edx,%eax
  80121b:	eb 3f                	jmp    80125c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80121d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801220:	89 44 24 04          	mov    %eax,0x4(%esp)
  801224:	8b 06                	mov    (%esi),%eax
  801226:	89 04 24             	mov    %eax,(%esp)
  801229:	e8 43 ff ff ff       	call   801171 <dev_lookup>
  80122e:	89 c3                	mov    %eax,%ebx
  801230:	85 c0                	test   %eax,%eax
  801232:	78 16                	js     80124a <fd_close+0x68>
		if (dev->dev_close)
  801234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801237:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80123f:	85 c0                	test   %eax,%eax
  801241:	74 07                	je     80124a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801243:	89 34 24             	mov    %esi,(%esp)
  801246:	ff d0                	call   *%eax
  801248:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80124a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80124e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801255:	e8 46 fb ff ff       	call   800da0 <sys_page_unmap>
	return r;
  80125a:	89 d8                	mov    %ebx,%eax
}
  80125c:	83 c4 20             	add    $0x20,%esp
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	89 04 24             	mov    %eax,(%esp)
  801276:	e8 a0 fe ff ff       	call   80111b <fd_lookup>
  80127b:	89 c2                	mov    %eax,%edx
  80127d:	85 d2                	test   %edx,%edx
  80127f:	78 13                	js     801294 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801288:	00 
  801289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128c:	89 04 24             	mov    %eax,(%esp)
  80128f:	e8 4e ff ff ff       	call   8011e2 <fd_close>
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <close_all>:

void
close_all(void)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80129d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a2:	89 1c 24             	mov    %ebx,(%esp)
  8012a5:	e8 b9 ff ff ff       	call   801263 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012aa:	83 c3 01             	add    $0x1,%ebx
  8012ad:	83 fb 20             	cmp    $0x20,%ebx
  8012b0:	75 f0                	jne    8012a2 <close_all+0xc>
		close(i);
}
  8012b2:	83 c4 14             	add    $0x14,%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	89 04 24             	mov    %eax,(%esp)
  8012ce:	e8 48 fe ff ff       	call   80111b <fd_lookup>
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	85 d2                	test   %edx,%edx
  8012d7:	0f 88 e1 00 00 00    	js     8013be <dup+0x106>
		return r;
	close(newfdnum);
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	89 04 24             	mov    %eax,(%esp)
  8012e3:	e8 7b ff ff ff       	call   801263 <close>

	newfd = INDEX2FD(newfdnum);
  8012e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012eb:	c1 e3 0c             	shl    $0xc,%ebx
  8012ee:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f7:	89 04 24             	mov    %eax,(%esp)
  8012fa:	e8 91 fd ff ff       	call   801090 <fd2data>
  8012ff:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801301:	89 1c 24             	mov    %ebx,(%esp)
  801304:	e8 87 fd ff ff       	call   801090 <fd2data>
  801309:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80130b:	89 f0                	mov    %esi,%eax
  80130d:	c1 e8 16             	shr    $0x16,%eax
  801310:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801317:	a8 01                	test   $0x1,%al
  801319:	74 43                	je     80135e <dup+0xa6>
  80131b:	89 f0                	mov    %esi,%eax
  80131d:	c1 e8 0c             	shr    $0xc,%eax
  801320:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801327:	f6 c2 01             	test   $0x1,%dl
  80132a:	74 32                	je     80135e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80132c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801333:	25 07 0e 00 00       	and    $0xe07,%eax
  801338:	89 44 24 10          	mov    %eax,0x10(%esp)
  80133c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801340:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801347:	00 
  801348:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801353:	e8 f5 f9 ff ff       	call   800d4d <sys_page_map>
  801358:	89 c6                	mov    %eax,%esi
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 3e                	js     80139c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80135e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801361:	89 c2                	mov    %eax,%edx
  801363:	c1 ea 0c             	shr    $0xc,%edx
  801366:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801373:	89 54 24 10          	mov    %edx,0x10(%esp)
  801377:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80137b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801382:	00 
  801383:	89 44 24 04          	mov    %eax,0x4(%esp)
  801387:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138e:	e8 ba f9 ff ff       	call   800d4d <sys_page_map>
  801393:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801398:	85 f6                	test   %esi,%esi
  80139a:	79 22                	jns    8013be <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80139c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 f4 f9 ff ff       	call   800da0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b7:	e8 e4 f9 ff ff       	call   800da0 <sys_page_unmap>
	return r;
  8013bc:	89 f0                	mov    %esi,%eax
}
  8013be:	83 c4 3c             	add    $0x3c,%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 24             	sub    $0x24,%esp
  8013cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d7:	89 1c 24             	mov    %ebx,(%esp)
  8013da:	e8 3c fd ff ff       	call   80111b <fd_lookup>
  8013df:	89 c2                	mov    %eax,%edx
  8013e1:	85 d2                	test   %edx,%edx
  8013e3:	78 6d                	js     801452 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ef:	8b 00                	mov    (%eax),%eax
  8013f1:	89 04 24             	mov    %eax,(%esp)
  8013f4:	e8 78 fd ff ff       	call   801171 <dev_lookup>
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 55                	js     801452 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	8b 50 08             	mov    0x8(%eax),%edx
  801403:	83 e2 03             	and    $0x3,%edx
  801406:	83 fa 01             	cmp    $0x1,%edx
  801409:	75 23                	jne    80142e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140b:	a1 04 40 80 00       	mov    0x804004,%eax
  801410:	8b 40 48             	mov    0x48(%eax),%eax
  801413:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141b:	c7 04 24 21 25 80 00 	movl   $0x802521,(%esp)
  801422:	e8 cf ed ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142c:	eb 24                	jmp    801452 <read+0x8c>
	}
	if (!dev->dev_read)
  80142e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801431:	8b 52 08             	mov    0x8(%edx),%edx
  801434:	85 d2                	test   %edx,%edx
  801436:	74 15                	je     80144d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801438:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80143f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801442:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801446:	89 04 24             	mov    %eax,(%esp)
  801449:	ff d2                	call   *%edx
  80144b:	eb 05                	jmp    801452 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80144d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801452:	83 c4 24             	add    $0x24,%esp
  801455:	5b                   	pop    %ebx
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 1c             	sub    $0x1c,%esp
  801461:	8b 7d 08             	mov    0x8(%ebp),%edi
  801464:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801467:	85 f6                	test   %esi,%esi
  801469:	74 33                	je     80149e <readn+0x46>
  80146b:	b8 00 00 00 00       	mov    $0x0,%eax
  801470:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801475:	89 f2                	mov    %esi,%edx
  801477:	29 c2                	sub    %eax,%edx
  801479:	89 54 24 08          	mov    %edx,0x8(%esp)
  80147d:	03 45 0c             	add    0xc(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	89 3c 24             	mov    %edi,(%esp)
  801487:	e8 3a ff ff ff       	call   8013c6 <read>
		if (m < 0)
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 1b                	js     8014ab <readn+0x53>
			return m;
		if (m == 0)
  801490:	85 c0                	test   %eax,%eax
  801492:	74 11                	je     8014a5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801494:	01 c3                	add    %eax,%ebx
  801496:	89 d8                	mov    %ebx,%eax
  801498:	39 f3                	cmp    %esi,%ebx
  80149a:	72 d9                	jb     801475 <readn+0x1d>
  80149c:	eb 0b                	jmp    8014a9 <readn+0x51>
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a3:	eb 06                	jmp    8014ab <readn+0x53>
  8014a5:	89 d8                	mov    %ebx,%eax
  8014a7:	eb 02                	jmp    8014ab <readn+0x53>
  8014a9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ab:	83 c4 1c             	add    $0x1c,%esp
  8014ae:	5b                   	pop    %ebx
  8014af:	5e                   	pop    %esi
  8014b0:	5f                   	pop    %edi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 24             	sub    $0x24,%esp
  8014ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c4:	89 1c 24             	mov    %ebx,(%esp)
  8014c7:	e8 4f fc ff ff       	call   80111b <fd_lookup>
  8014cc:	89 c2                	mov    %eax,%edx
  8014ce:	85 d2                	test   %edx,%edx
  8014d0:	78 68                	js     80153a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	89 04 24             	mov    %eax,(%esp)
  8014e1:	e8 8b fc ff ff       	call   801171 <dev_lookup>
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 50                	js     80153a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f1:	75 23                	jne    801516 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f8:	8b 40 48             	mov    0x48(%eax),%eax
  8014fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801503:	c7 04 24 3d 25 80 00 	movl   $0x80253d,(%esp)
  80150a:	e8 e7 ec ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  80150f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801514:	eb 24                	jmp    80153a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801519:	8b 52 0c             	mov    0xc(%edx),%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	74 15                	je     801535 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801520:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80152a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80152e:	89 04 24             	mov    %eax,(%esp)
  801531:	ff d2                	call   *%edx
  801533:	eb 05                	jmp    80153a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801535:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80153a:	83 c4 24             	add    $0x24,%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <seek>:

int
seek(int fdnum, off_t offset)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801546:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	89 04 24             	mov    %eax,(%esp)
  801553:	e8 c3 fb ff ff       	call   80111b <fd_lookup>
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 0e                	js     80156a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80155c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	53                   	push   %ebx
  801570:	83 ec 24             	sub    $0x24,%esp
  801573:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801576:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157d:	89 1c 24             	mov    %ebx,(%esp)
  801580:	e8 96 fb ff ff       	call   80111b <fd_lookup>
  801585:	89 c2                	mov    %eax,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	78 61                	js     8015ec <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	89 04 24             	mov    %eax,(%esp)
  80159a:	e8 d2 fb ff ff       	call   801171 <dev_lookup>
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 49                	js     8015ec <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015aa:	75 23                	jne    8015cf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015ac:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b1:	8b 40 48             	mov    0x48(%eax),%eax
  8015b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bc:	c7 04 24 00 25 80 00 	movl   $0x802500,(%esp)
  8015c3:	e8 2e ec ff ff       	call   8001f6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cd:	eb 1d                	jmp    8015ec <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d2:	8b 52 18             	mov    0x18(%edx),%edx
  8015d5:	85 d2                	test   %edx,%edx
  8015d7:	74 0e                	je     8015e7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015e0:	89 04 24             	mov    %eax,(%esp)
  8015e3:	ff d2                	call   *%edx
  8015e5:	eb 05                	jmp    8015ec <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015ec:	83 c4 24             	add    $0x24,%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 24             	sub    $0x24,%esp
  8015f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 04 24             	mov    %eax,(%esp)
  801609:	e8 0d fb ff ff       	call   80111b <fd_lookup>
  80160e:	89 c2                	mov    %eax,%edx
  801610:	85 d2                	test   %edx,%edx
  801612:	78 52                	js     801666 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801614:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	89 04 24             	mov    %eax,(%esp)
  801623:	e8 49 fb ff ff       	call   801171 <dev_lookup>
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 3a                	js     801666 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801633:	74 2c                	je     801661 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801635:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801638:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163f:	00 00 00 
	stat->st_isdir = 0;
  801642:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801649:	00 00 00 
	stat->st_dev = dev;
  80164c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801652:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801656:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801659:	89 14 24             	mov    %edx,(%esp)
  80165c:	ff 50 14             	call   *0x14(%eax)
  80165f:	eb 05                	jmp    801666 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801661:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801666:	83 c4 24             	add    $0x24,%esp
  801669:	5b                   	pop    %ebx
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	56                   	push   %esi
  801670:	53                   	push   %ebx
  801671:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801674:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80167b:	00 
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	89 04 24             	mov    %eax,(%esp)
  801682:	e8 af 01 00 00       	call   801836 <open>
  801687:	89 c3                	mov    %eax,%ebx
  801689:	85 db                	test   %ebx,%ebx
  80168b:	78 1b                	js     8016a8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	89 44 24 04          	mov    %eax,0x4(%esp)
  801694:	89 1c 24             	mov    %ebx,(%esp)
  801697:	e8 56 ff ff ff       	call   8015f2 <fstat>
  80169c:	89 c6                	mov    %eax,%esi
	close(fd);
  80169e:	89 1c 24             	mov    %ebx,(%esp)
  8016a1:	e8 bd fb ff ff       	call   801263 <close>
	return r;
  8016a6:	89 f0                	mov    %esi,%eax
}
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 10             	sub    $0x10,%esp
  8016b7:	89 c6                	mov    %eax,%esi
  8016b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016c2:	75 11                	jne    8016d5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016cb:	e8 61 f9 ff ff       	call   801031 <ipc_find_env>
  8016d0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016dc:	00 
  8016dd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016e4:	00 
  8016e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8016ee:	89 04 24             	mov    %eax,(%esp)
  8016f1:	e8 d5 f8 ff ff       	call   800fcb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016fd:	00 
  8016fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801702:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801709:	e8 53 f8 ff ff       	call   800f61 <ipc_recv>
}
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	53                   	push   %ebx
  801719:	83 ec 14             	sub    $0x14,%esp
  80171c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80172a:	ba 00 00 00 00       	mov    $0x0,%edx
  80172f:	b8 05 00 00 00       	mov    $0x5,%eax
  801734:	e8 76 ff ff ff       	call   8016af <fsipc>
  801739:	89 c2                	mov    %eax,%edx
  80173b:	85 d2                	test   %edx,%edx
  80173d:	78 2b                	js     80176a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80173f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801746:	00 
  801747:	89 1c 24             	mov    %ebx,(%esp)
  80174a:	e8 fc f0 ff ff       	call   80084b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80174f:	a1 80 50 80 00       	mov    0x805080,%eax
  801754:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80175a:	a1 84 50 80 00       	mov    0x805084,%eax
  80175f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176a:	83 c4 14             	add    $0x14,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8b 40 0c             	mov    0xc(%eax),%eax
  80177c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801781:	ba 00 00 00 00       	mov    $0x0,%edx
  801786:	b8 06 00 00 00       	mov    $0x6,%eax
  80178b:	e8 1f ff ff ff       	call   8016af <fsipc>
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
  801797:	83 ec 10             	sub    $0x10,%esp
  80179a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017a8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017b8:	e8 f2 fe ff ff       	call   8016af <fsipc>
  8017bd:	89 c3                	mov    %eax,%ebx
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 6a                	js     80182d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017c3:	39 c6                	cmp    %eax,%esi
  8017c5:	73 24                	jae    8017eb <devfile_read+0x59>
  8017c7:	c7 44 24 0c 5a 25 80 	movl   $0x80255a,0xc(%esp)
  8017ce:	00 
  8017cf:	c7 44 24 08 61 25 80 	movl   $0x802561,0x8(%esp)
  8017d6:	00 
  8017d7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8017de:	00 
  8017df:	c7 04 24 76 25 80 00 	movl   $0x802576,(%esp)
  8017e6:	e8 3b 06 00 00       	call   801e26 <_panic>
	assert(r <= PGSIZE);
  8017eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f0:	7e 24                	jle    801816 <devfile_read+0x84>
  8017f2:	c7 44 24 0c 81 25 80 	movl   $0x802581,0xc(%esp)
  8017f9:	00 
  8017fa:	c7 44 24 08 61 25 80 	movl   $0x802561,0x8(%esp)
  801801:	00 
  801802:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801809:	00 
  80180a:	c7 04 24 76 25 80 00 	movl   $0x802576,(%esp)
  801811:	e8 10 06 00 00       	call   801e26 <_panic>
	memmove(buf, &fsipcbuf, r);
  801816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801821:	00 
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	89 04 24             	mov    %eax,(%esp)
  801828:	e8 19 f2 ff ff       	call   800a46 <memmove>
	return r;
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
  80183a:	83 ec 24             	sub    $0x24,%esp
  80183d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801840:	89 1c 24             	mov    %ebx,(%esp)
  801843:	e8 a8 ef ff ff       	call   8007f0 <strlen>
  801848:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184d:	7f 60                	jg     8018af <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	e8 4d f8 ff ff       	call   8010a7 <fd_alloc>
  80185a:	89 c2                	mov    %eax,%edx
  80185c:	85 d2                	test   %edx,%edx
  80185e:	78 54                	js     8018b4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801864:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80186b:	e8 db ef ff ff       	call   80084b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
  801880:	e8 2a fe ff ff       	call   8016af <fsipc>
  801885:	89 c3                	mov    %eax,%ebx
  801887:	85 c0                	test   %eax,%eax
  801889:	79 17                	jns    8018a2 <open+0x6c>
		fd_close(fd, 0);
  80188b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801892:	00 
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	89 04 24             	mov    %eax,(%esp)
  801899:	e8 44 f9 ff ff       	call   8011e2 <fd_close>
		return r;
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	eb 12                	jmp    8018b4 <open+0x7e>
	}

	return fd2num(fd);
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 d3 f7 ff ff       	call   801080 <fd2num>
  8018ad:	eb 05                	jmp    8018b4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018af:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018b4:	83 c4 24             	add    $0x24,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    
  8018ba:	66 90                	xchg   %ax,%ax
  8018bc:	66 90                	xchg   %ax,%ax
  8018be:	66 90                	xchg   %ax,%ax

008018c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 10             	sub    $0x10,%esp
  8018c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 ba f7 ff ff       	call   801090 <fd2data>
  8018d6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018d8:	c7 44 24 04 8d 25 80 	movl   $0x80258d,0x4(%esp)
  8018df:	00 
  8018e0:	89 1c 24             	mov    %ebx,(%esp)
  8018e3:	e8 63 ef ff ff       	call   80084b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018e8:	8b 46 04             	mov    0x4(%esi),%eax
  8018eb:	2b 06                	sub    (%esi),%eax
  8018ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fa:	00 00 00 
	stat->st_dev = &devpipe;
  8018fd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801904:	30 80 00 
	return 0;
}
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	53                   	push   %ebx
  801917:	83 ec 14             	sub    $0x14,%esp
  80191a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80191d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801921:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801928:	e8 73 f4 ff ff       	call   800da0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80192d:	89 1c 24             	mov    %ebx,(%esp)
  801930:	e8 5b f7 ff ff       	call   801090 <fd2data>
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801940:	e8 5b f4 ff ff       	call   800da0 <sys_page_unmap>
}
  801945:	83 c4 14             	add    $0x14,%esp
  801948:	5b                   	pop    %ebx
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 2c             	sub    $0x2c,%esp
  801954:	89 c6                	mov    %eax,%esi
  801956:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801959:	a1 04 40 80 00       	mov    0x804004,%eax
  80195e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801961:	89 34 24             	mov    %esi,(%esp)
  801964:	e8 13 05 00 00       	call   801e7c <pageref>
  801969:	89 c7                	mov    %eax,%edi
  80196b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	e8 06 05 00 00       	call   801e7c <pageref>
  801976:	39 c7                	cmp    %eax,%edi
  801978:	0f 94 c2             	sete   %dl
  80197b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80197e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801984:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801987:	39 fb                	cmp    %edi,%ebx
  801989:	74 21                	je     8019ac <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80198b:	84 d2                	test   %dl,%dl
  80198d:	74 ca                	je     801959 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80198f:	8b 51 58             	mov    0x58(%ecx),%edx
  801992:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801996:	89 54 24 08          	mov    %edx,0x8(%esp)
  80199a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80199e:	c7 04 24 94 25 80 00 	movl   $0x802594,(%esp)
  8019a5:	e8 4c e8 ff ff       	call   8001f6 <cprintf>
  8019aa:	eb ad                	jmp    801959 <_pipeisclosed+0xe>
	}
}
  8019ac:	83 c4 2c             	add    $0x2c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    

008019b4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	57                   	push   %edi
  8019b8:	56                   	push   %esi
  8019b9:	53                   	push   %ebx
  8019ba:	83 ec 1c             	sub    $0x1c,%esp
  8019bd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019c0:	89 34 24             	mov    %esi,(%esp)
  8019c3:	e8 c8 f6 ff ff       	call   801090 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019cc:	74 61                	je     801a2f <devpipe_write+0x7b>
  8019ce:	89 c3                	mov    %eax,%ebx
  8019d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d5:	eb 4a                	jmp    801a21 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019d7:	89 da                	mov    %ebx,%edx
  8019d9:	89 f0                	mov    %esi,%eax
  8019db:	e8 6b ff ff ff       	call   80194b <_pipeisclosed>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	75 54                	jne    801a38 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8019e4:	e8 f1 f2 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019e9:	8b 43 04             	mov    0x4(%ebx),%eax
  8019ec:	8b 0b                	mov    (%ebx),%ecx
  8019ee:	8d 51 20             	lea    0x20(%ecx),%edx
  8019f1:	39 d0                	cmp    %edx,%eax
  8019f3:	73 e2                	jae    8019d7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019fc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019ff:	99                   	cltd   
  801a00:	c1 ea 1b             	shr    $0x1b,%edx
  801a03:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801a06:	83 e1 1f             	and    $0x1f,%ecx
  801a09:	29 d1                	sub    %edx,%ecx
  801a0b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801a0f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801a13:	83 c0 01             	add    $0x1,%eax
  801a16:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a19:	83 c7 01             	add    $0x1,%edi
  801a1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a1f:	74 13                	je     801a34 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a21:	8b 43 04             	mov    0x4(%ebx),%eax
  801a24:	8b 0b                	mov    (%ebx),%ecx
  801a26:	8d 51 20             	lea    0x20(%ecx),%edx
  801a29:	39 d0                	cmp    %edx,%eax
  801a2b:	73 aa                	jae    8019d7 <devpipe_write+0x23>
  801a2d:	eb c6                	jmp    8019f5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a2f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a34:	89 f8                	mov    %edi,%eax
  801a36:	eb 05                	jmp    801a3d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a3d:	83 c4 1c             	add    $0x1c,%esp
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5f                   	pop    %edi
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    

00801a45 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	57                   	push   %edi
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 1c             	sub    $0x1c,%esp
  801a4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a51:	89 3c 24             	mov    %edi,(%esp)
  801a54:	e8 37 f6 ff ff       	call   801090 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5d:	74 54                	je     801ab3 <devpipe_read+0x6e>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	be 00 00 00 00       	mov    $0x0,%esi
  801a66:	eb 3e                	jmp    801aa6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a68:	89 f0                	mov    %esi,%eax
  801a6a:	eb 55                	jmp    801ac1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a6c:	89 da                	mov    %ebx,%edx
  801a6e:	89 f8                	mov    %edi,%eax
  801a70:	e8 d6 fe ff ff       	call   80194b <_pipeisclosed>
  801a75:	85 c0                	test   %eax,%eax
  801a77:	75 43                	jne    801abc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a79:	e8 5c f2 ff ff       	call   800cda <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a7e:	8b 03                	mov    (%ebx),%eax
  801a80:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a83:	74 e7                	je     801a6c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a85:	99                   	cltd   
  801a86:	c1 ea 1b             	shr    $0x1b,%edx
  801a89:	01 d0                	add    %edx,%eax
  801a8b:	83 e0 1f             	and    $0x1f,%eax
  801a8e:	29 d0                	sub    %edx,%eax
  801a90:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a98:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a9b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a9e:	83 c6 01             	add    $0x1,%esi
  801aa1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aa4:	74 12                	je     801ab8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801aa6:	8b 03                	mov    (%ebx),%eax
  801aa8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801aab:	75 d8                	jne    801a85 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801aad:	85 f6                	test   %esi,%esi
  801aaf:	75 b7                	jne    801a68 <devpipe_read+0x23>
  801ab1:	eb b9                	jmp    801a6c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ab3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ab8:	89 f0                	mov    %esi,%eax
  801aba:	eb 05                	jmp    801ac1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ac1:	83 c4 1c             	add    $0x1c,%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5f                   	pop    %edi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
  801ace:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ad1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad4:	89 04 24             	mov    %eax,(%esp)
  801ad7:	e8 cb f5 ff ff       	call   8010a7 <fd_alloc>
  801adc:	89 c2                	mov    %eax,%edx
  801ade:	85 d2                	test   %edx,%edx
  801ae0:	0f 88 4d 01 00 00    	js     801c33 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801aed:	00 
  801aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afc:	e8 f8 f1 ff ff       	call   800cf9 <sys_page_alloc>
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	85 d2                	test   %edx,%edx
  801b05:	0f 88 28 01 00 00    	js     801c33 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 91 f5 ff ff       	call   8010a7 <fd_alloc>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	0f 88 fe 00 00 00    	js     801c1e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b20:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b27:	00 
  801b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b36:	e8 be f1 ff ff       	call   800cf9 <sys_page_alloc>
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	0f 88 d9 00 00 00    	js     801c1e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	89 04 24             	mov    %eax,(%esp)
  801b4b:	e8 40 f5 ff ff       	call   801090 <fd2data>
  801b50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b59:	00 
  801b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b65:	e8 8f f1 ff ff       	call   800cf9 <sys_page_alloc>
  801b6a:	89 c3                	mov    %eax,%ebx
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	0f 88 97 00 00 00    	js     801c0b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	89 04 24             	mov    %eax,(%esp)
  801b7a:	e8 11 f5 ff ff       	call   801090 <fd2data>
  801b7f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b86:	00 
  801b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b92:	00 
  801b93:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9e:	e8 aa f1 ff ff       	call   800d4d <sys_page_map>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 52                	js     801bfb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ba9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801bbe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	89 04 24             	mov    %eax,(%esp)
  801bd9:	e8 a2 f4 ff ff       	call   801080 <fd2num>
  801bde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 92 f4 ff ff       	call   801080 <fd2num>
  801bee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	eb 38                	jmp    801c33 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801bfb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c06:	e8 95 f1 ff ff       	call   800da0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c19:	e8 82 f1 ff ff       	call   800da0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2c:	e8 6f f1 ff ff       	call   800da0 <sys_page_unmap>
  801c31:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801c33:	83 c4 30             	add    $0x30,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	89 04 24             	mov    %eax,(%esp)
  801c4d:	e8 c9 f4 ff ff       	call   80111b <fd_lookup>
  801c52:	89 c2                	mov    %eax,%edx
  801c54:	85 d2                	test   %edx,%edx
  801c56:	78 15                	js     801c6d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 2d f4 ff ff       	call   801090 <fd2data>
	return _pipeisclosed(fd, p);
  801c63:	89 c2                	mov    %eax,%edx
  801c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c68:	e8 de fc ff ff       	call   80194b <_pipeisclosed>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    
  801c6f:	90                   	nop

00801c70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c80:	c7 44 24 04 ac 25 80 	movl   $0x8025ac,0x4(%esp)
  801c87:	00 
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	89 04 24             	mov    %eax,(%esp)
  801c8e:	e8 b8 eb ff ff       	call   80084b <strcpy>
	return 0;
}
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ca6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801caa:	74 4a                	je     801cf6 <devcons_write+0x5c>
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cbc:	8b 75 10             	mov    0x10(%ebp),%esi
  801cbf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801cc1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801cc4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801cc9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ccc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cd0:	03 45 0c             	add    0xc(%ebp),%eax
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	89 3c 24             	mov    %edi,(%esp)
  801cda:	e8 67 ed ff ff       	call   800a46 <memmove>
		sys_cputs(buf, m);
  801cdf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ce3:	89 3c 24             	mov    %edi,(%esp)
  801ce6:	e8 41 ef ff ff       	call   800c2c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ceb:	01 f3                	add    %esi,%ebx
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801cf2:	72 c8                	jb     801cbc <devcons_write+0x22>
  801cf4:	eb 05                	jmp    801cfb <devcons_write+0x61>
  801cf6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801cfb:	89 d8                	mov    %ebx,%eax
  801cfd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d17:	75 07                	jne    801d20 <devcons_read+0x18>
  801d19:	eb 28                	jmp    801d43 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d1b:	e8 ba ef ff ff       	call   800cda <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d20:	e8 25 ef ff ff       	call   800c4a <sys_cgetc>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	74 f2                	je     801d1b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 16                	js     801d43 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d2d:	83 f8 04             	cmp    $0x4,%eax
  801d30:	74 0c                	je     801d3e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	88 02                	mov    %al,(%edx)
	return 1;
  801d37:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3c:	eb 05                	jmp    801d43 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d58:	00 
  801d59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d5c:	89 04 24             	mov    %eax,(%esp)
  801d5f:	e8 c8 ee ff ff       	call   800c2c <sys_cputs>
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <getchar>:

int
getchar(void)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d73:	00 
  801d74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d82:	e8 3f f6 ff ff       	call   8013c6 <read>
	if (r < 0)
  801d87:	85 c0                	test   %eax,%eax
  801d89:	78 0f                	js     801d9a <getchar+0x34>
		return r;
	if (r < 1)
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	7e 06                	jle    801d95 <getchar+0x2f>
		return -E_EOF;
	return c;
  801d8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801d93:	eb 05                	jmp    801d9a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801d95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801da2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	89 04 24             	mov    %eax,(%esp)
  801daf:	e8 67 f3 ff ff       	call   80111b <fd_lookup>
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 11                	js     801dc9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc1:	39 10                	cmp    %edx,(%eax)
  801dc3:	0f 94 c0             	sete   %al
  801dc6:	0f b6 c0             	movzbl %al,%eax
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <opencons>:

int
opencons(void)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801dd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd4:	89 04 24             	mov    %eax,(%esp)
  801dd7:	e8 cb f2 ff ff       	call   8010a7 <fd_alloc>
		return r;
  801ddc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 40                	js     801e22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801de2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801de9:	00 
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df8:	e8 fc ee ff ff       	call   800cf9 <sys_page_alloc>
		return r;
  801dfd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 1f                	js     801e22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e03:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e18:	89 04 24             	mov    %eax,(%esp)
  801e1b:	e8 60 f2 ff ff       	call   801080 <fd2num>
  801e20:	89 c2                	mov    %eax,%edx
}
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801e2e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e31:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e37:	e8 7f ee ff ff       	call   800cbb <sys_getenvid>
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e43:	8b 55 08             	mov    0x8(%ebp),%edx
  801e46:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e4a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e52:	c7 04 24 b8 25 80 00 	movl   $0x8025b8,(%esp)
  801e59:	e8 98 e3 ff ff       	call   8001f6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e62:	8b 45 10             	mov    0x10(%ebp),%eax
  801e65:	89 04 24             	mov    %eax,(%esp)
  801e68:	e8 28 e3 ff ff       	call   800195 <vcprintf>
	cprintf("\n");
  801e6d:	c7 04 24 a5 25 80 00 	movl   $0x8025a5,(%esp)
  801e74:	e8 7d e3 ff ff       	call   8001f6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e79:	cc                   	int3   
  801e7a:	eb fd                	jmp    801e79 <_panic+0x53>

00801e7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e82:	89 d0                	mov    %edx,%eax
  801e84:	c1 e8 16             	shr    $0x16,%eax
  801e87:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e93:	f6 c1 01             	test   $0x1,%cl
  801e96:	74 1d                	je     801eb5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e98:	c1 ea 0c             	shr    $0xc,%edx
  801e9b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ea2:	f6 c2 01             	test   $0x1,%dl
  801ea5:	74 0e                	je     801eb5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ea7:	c1 ea 0c             	shr    $0xc,%edx
  801eaa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801eb1:	ef 
  801eb2:	0f b7 c0             	movzwl %ax,%eax
}
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    
  801eb7:	66 90                	xchg   %ax,%ax
  801eb9:	66 90                	xchg   %ax,%ax
  801ebb:	66 90                	xchg   %ax,%ax
  801ebd:	66 90                	xchg   %ax,%ax
  801ebf:	90                   	nop

00801ec0 <__udivdi3>:
  801ec0:	55                   	push   %ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801eca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801ece:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801ed2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801edc:	89 ea                	mov    %ebp,%edx
  801ede:	89 0c 24             	mov    %ecx,(%esp)
  801ee1:	75 2d                	jne    801f10 <__udivdi3+0x50>
  801ee3:	39 e9                	cmp    %ebp,%ecx
  801ee5:	77 61                	ja     801f48 <__udivdi3+0x88>
  801ee7:	85 c9                	test   %ecx,%ecx
  801ee9:	89 ce                	mov    %ecx,%esi
  801eeb:	75 0b                	jne    801ef8 <__udivdi3+0x38>
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	31 d2                	xor    %edx,%edx
  801ef4:	f7 f1                	div    %ecx
  801ef6:	89 c6                	mov    %eax,%esi
  801ef8:	31 d2                	xor    %edx,%edx
  801efa:	89 e8                	mov    %ebp,%eax
  801efc:	f7 f6                	div    %esi
  801efe:	89 c5                	mov    %eax,%ebp
  801f00:	89 f8                	mov    %edi,%eax
  801f02:	f7 f6                	div    %esi
  801f04:	89 ea                	mov    %ebp,%edx
  801f06:	83 c4 0c             	add    $0xc,%esp
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    
  801f0d:	8d 76 00             	lea    0x0(%esi),%esi
  801f10:	39 e8                	cmp    %ebp,%eax
  801f12:	77 24                	ja     801f38 <__udivdi3+0x78>
  801f14:	0f bd e8             	bsr    %eax,%ebp
  801f17:	83 f5 1f             	xor    $0x1f,%ebp
  801f1a:	75 3c                	jne    801f58 <__udivdi3+0x98>
  801f1c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f20:	39 34 24             	cmp    %esi,(%esp)
  801f23:	0f 86 9f 00 00 00    	jbe    801fc8 <__udivdi3+0x108>
  801f29:	39 d0                	cmp    %edx,%eax
  801f2b:	0f 82 97 00 00 00    	jb     801fc8 <__udivdi3+0x108>
  801f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f38:	31 d2                	xor    %edx,%edx
  801f3a:	31 c0                	xor    %eax,%eax
  801f3c:	83 c4 0c             	add    $0xc,%esp
  801f3f:	5e                   	pop    %esi
  801f40:	5f                   	pop    %edi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    
  801f43:	90                   	nop
  801f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f48:	89 f8                	mov    %edi,%eax
  801f4a:	f7 f1                	div    %ecx
  801f4c:	31 d2                	xor    %edx,%edx
  801f4e:	83 c4 0c             	add    $0xc,%esp
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	89 e9                	mov    %ebp,%ecx
  801f5a:	8b 3c 24             	mov    (%esp),%edi
  801f5d:	d3 e0                	shl    %cl,%eax
  801f5f:	89 c6                	mov    %eax,%esi
  801f61:	b8 20 00 00 00       	mov    $0x20,%eax
  801f66:	29 e8                	sub    %ebp,%eax
  801f68:	89 c1                	mov    %eax,%ecx
  801f6a:	d3 ef                	shr    %cl,%edi
  801f6c:	89 e9                	mov    %ebp,%ecx
  801f6e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f72:	8b 3c 24             	mov    (%esp),%edi
  801f75:	09 74 24 08          	or     %esi,0x8(%esp)
  801f79:	89 d6                	mov    %edx,%esi
  801f7b:	d3 e7                	shl    %cl,%edi
  801f7d:	89 c1                	mov    %eax,%ecx
  801f7f:	89 3c 24             	mov    %edi,(%esp)
  801f82:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f86:	d3 ee                	shr    %cl,%esi
  801f88:	89 e9                	mov    %ebp,%ecx
  801f8a:	d3 e2                	shl    %cl,%edx
  801f8c:	89 c1                	mov    %eax,%ecx
  801f8e:	d3 ef                	shr    %cl,%edi
  801f90:	09 d7                	or     %edx,%edi
  801f92:	89 f2                	mov    %esi,%edx
  801f94:	89 f8                	mov    %edi,%eax
  801f96:	f7 74 24 08          	divl   0x8(%esp)
  801f9a:	89 d6                	mov    %edx,%esi
  801f9c:	89 c7                	mov    %eax,%edi
  801f9e:	f7 24 24             	mull   (%esp)
  801fa1:	39 d6                	cmp    %edx,%esi
  801fa3:	89 14 24             	mov    %edx,(%esp)
  801fa6:	72 30                	jb     801fd8 <__udivdi3+0x118>
  801fa8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fac:	89 e9                	mov    %ebp,%ecx
  801fae:	d3 e2                	shl    %cl,%edx
  801fb0:	39 c2                	cmp    %eax,%edx
  801fb2:	73 05                	jae    801fb9 <__udivdi3+0xf9>
  801fb4:	3b 34 24             	cmp    (%esp),%esi
  801fb7:	74 1f                	je     801fd8 <__udivdi3+0x118>
  801fb9:	89 f8                	mov    %edi,%eax
  801fbb:	31 d2                	xor    %edx,%edx
  801fbd:	e9 7a ff ff ff       	jmp    801f3c <__udivdi3+0x7c>
  801fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fc8:	31 d2                	xor    %edx,%edx
  801fca:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcf:	e9 68 ff ff ff       	jmp    801f3c <__udivdi3+0x7c>
  801fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fd8:	8d 47 ff             	lea    -0x1(%edi),%eax
  801fdb:	31 d2                	xor    %edx,%edx
  801fdd:	83 c4 0c             	add    $0xc,%esp
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	66 90                	xchg   %ax,%ax
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	66 90                	xchg   %ax,%ax
  801fea:	66 90                	xchg   %ax,%ax
  801fec:	66 90                	xchg   %ax,%ax
  801fee:	66 90                	xchg   %ax,%ax

00801ff0 <__umoddi3>:
  801ff0:	55                   	push   %ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	83 ec 14             	sub    $0x14,%esp
  801ff6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801ffa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801ffe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802002:	89 c7                	mov    %eax,%edi
  802004:	89 44 24 04          	mov    %eax,0x4(%esp)
  802008:	8b 44 24 30          	mov    0x30(%esp),%eax
  80200c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802010:	89 34 24             	mov    %esi,(%esp)
  802013:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802017:	85 c0                	test   %eax,%eax
  802019:	89 c2                	mov    %eax,%edx
  80201b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80201f:	75 17                	jne    802038 <__umoddi3+0x48>
  802021:	39 fe                	cmp    %edi,%esi
  802023:	76 4b                	jbe    802070 <__umoddi3+0x80>
  802025:	89 c8                	mov    %ecx,%eax
  802027:	89 fa                	mov    %edi,%edx
  802029:	f7 f6                	div    %esi
  80202b:	89 d0                	mov    %edx,%eax
  80202d:	31 d2                	xor    %edx,%edx
  80202f:	83 c4 14             	add    $0x14,%esp
  802032:	5e                   	pop    %esi
  802033:	5f                   	pop    %edi
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    
  802036:	66 90                	xchg   %ax,%ax
  802038:	39 f8                	cmp    %edi,%eax
  80203a:	77 54                	ja     802090 <__umoddi3+0xa0>
  80203c:	0f bd e8             	bsr    %eax,%ebp
  80203f:	83 f5 1f             	xor    $0x1f,%ebp
  802042:	75 5c                	jne    8020a0 <__umoddi3+0xb0>
  802044:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802048:	39 3c 24             	cmp    %edi,(%esp)
  80204b:	0f 87 e7 00 00 00    	ja     802138 <__umoddi3+0x148>
  802051:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802055:	29 f1                	sub    %esi,%ecx
  802057:	19 c7                	sbb    %eax,%edi
  802059:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80205d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802061:	8b 44 24 08          	mov    0x8(%esp),%eax
  802065:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802069:	83 c4 14             	add    $0x14,%esp
  80206c:	5e                   	pop    %esi
  80206d:	5f                   	pop    %edi
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    
  802070:	85 f6                	test   %esi,%esi
  802072:	89 f5                	mov    %esi,%ebp
  802074:	75 0b                	jne    802081 <__umoddi3+0x91>
  802076:	b8 01 00 00 00       	mov    $0x1,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f6                	div    %esi
  80207f:	89 c5                	mov    %eax,%ebp
  802081:	8b 44 24 04          	mov    0x4(%esp),%eax
  802085:	31 d2                	xor    %edx,%edx
  802087:	f7 f5                	div    %ebp
  802089:	89 c8                	mov    %ecx,%eax
  80208b:	f7 f5                	div    %ebp
  80208d:	eb 9c                	jmp    80202b <__umoddi3+0x3b>
  80208f:	90                   	nop
  802090:	89 c8                	mov    %ecx,%eax
  802092:	89 fa                	mov    %edi,%edx
  802094:	83 c4 14             	add    $0x14,%esp
  802097:	5e                   	pop    %esi
  802098:	5f                   	pop    %edi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    
  80209b:	90                   	nop
  80209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020a0:	8b 04 24             	mov    (%esp),%eax
  8020a3:	be 20 00 00 00       	mov    $0x20,%esi
  8020a8:	89 e9                	mov    %ebp,%ecx
  8020aa:	29 ee                	sub    %ebp,%esi
  8020ac:	d3 e2                	shl    %cl,%edx
  8020ae:	89 f1                	mov    %esi,%ecx
  8020b0:	d3 e8                	shr    %cl,%eax
  8020b2:	89 e9                	mov    %ebp,%ecx
  8020b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b8:	8b 04 24             	mov    (%esp),%eax
  8020bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8020bf:	89 fa                	mov    %edi,%edx
  8020c1:	d3 e0                	shl    %cl,%eax
  8020c3:	89 f1                	mov    %esi,%ecx
  8020c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8020cd:	d3 ea                	shr    %cl,%edx
  8020cf:	89 e9                	mov    %ebp,%ecx
  8020d1:	d3 e7                	shl    %cl,%edi
  8020d3:	89 f1                	mov    %esi,%ecx
  8020d5:	d3 e8                	shr    %cl,%eax
  8020d7:	89 e9                	mov    %ebp,%ecx
  8020d9:	09 f8                	or     %edi,%eax
  8020db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8020df:	f7 74 24 04          	divl   0x4(%esp)
  8020e3:	d3 e7                	shl    %cl,%edi
  8020e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020e9:	89 d7                	mov    %edx,%edi
  8020eb:	f7 64 24 08          	mull   0x8(%esp)
  8020ef:	39 d7                	cmp    %edx,%edi
  8020f1:	89 c1                	mov    %eax,%ecx
  8020f3:	89 14 24             	mov    %edx,(%esp)
  8020f6:	72 2c                	jb     802124 <__umoddi3+0x134>
  8020f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8020fc:	72 22                	jb     802120 <__umoddi3+0x130>
  8020fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802102:	29 c8                	sub    %ecx,%eax
  802104:	19 d7                	sbb    %edx,%edi
  802106:	89 e9                	mov    %ebp,%ecx
  802108:	89 fa                	mov    %edi,%edx
  80210a:	d3 e8                	shr    %cl,%eax
  80210c:	89 f1                	mov    %esi,%ecx
  80210e:	d3 e2                	shl    %cl,%edx
  802110:	89 e9                	mov    %ebp,%ecx
  802112:	d3 ef                	shr    %cl,%edi
  802114:	09 d0                	or     %edx,%eax
  802116:	89 fa                	mov    %edi,%edx
  802118:	83 c4 14             	add    $0x14,%esp
  80211b:	5e                   	pop    %esi
  80211c:	5f                   	pop    %edi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    
  80211f:	90                   	nop
  802120:	39 d7                	cmp    %edx,%edi
  802122:	75 da                	jne    8020fe <__umoddi3+0x10e>
  802124:	8b 14 24             	mov    (%esp),%edx
  802127:	89 c1                	mov    %eax,%ecx
  802129:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80212d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802131:	eb cb                	jmp    8020fe <__umoddi3+0x10e>
  802133:	90                   	nop
  802134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802138:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80213c:	0f 82 0f ff ff ff    	jb     802051 <__umoddi3+0x61>
  802142:	e9 1a ff ff ff       	jmp    802061 <__umoddi3+0x71>
