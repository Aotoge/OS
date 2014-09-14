
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 c2 00 00 00       	call   8000f3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 b9 0c 00 00       	call   800cfb <sys_getenvid>
  800042:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 c0 25 80 00 	movl   $0x8025c0,(%esp)
  800051:	e8 d1 01 00 00       	call   800227 <cprintf>

	forkchild(cur, '0');
  800056:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005d:	00 
  80005e:	89 1c 24             	mov    %ebx,(%esp)
  800061:	e8 16 00 00 00       	call   80007c <forkchild>
	forkchild(cur, '1');
  800066:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 06 00 00 00       	call   80007c <forkchild>
}
  800076:	83 c4 14             	add    $0x14,%esp
  800079:	5b                   	pop    %ebx
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 30             	sub    $0x30,%esp
  800084:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800087:	8b 75 0c             	mov    0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  80008a:	89 1c 24             	mov    %ebx,(%esp)
  80008d:	e8 9e 07 00 00       	call   800830 <strlen>
  800092:	83 f8 02             	cmp    $0x2,%eax
  800095:	7f 41                	jg     8000d8 <forkchild+0x5c>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800097:	89 f0                	mov    %esi,%eax
  800099:	0f be f0             	movsbl %al,%esi
  80009c:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a4:	c7 44 24 08 d1 25 80 	movl   $0x8025d1,0x8(%esp)
  8000ab:	00 
  8000ac:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000b3:	00 
  8000b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 41 07 00 00       	call   800800 <snprintf>
	if (fork() == 0) {
  8000bf:	e8 cc 0f 00 00       	call   801090 <fork>
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	75 10                	jne    8000d8 <forkchild+0x5c>
		forktree(nxt);
  8000c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <forktree>
		exit();
  8000d3:	e8 93 00 00 00       	call   80016b <exit>
	}
}
  8000d8:	83 c4 30             	add    $0x30,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000e5:	c7 04 24 d0 25 80 00 	movl   $0x8025d0,(%esp)
  8000ec:	e8 42 ff ff ff       	call   800033 <forktree>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 10             	sub    $0x10,%esp
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800101:	e8 f5 0b 00 00       	call   800cfb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800106:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80010c:	39 c2                	cmp    %eax,%edx
  80010e:	74 17                	je     800127 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800110:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800115:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800118:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80011e:	8b 49 40             	mov    0x40(%ecx),%ecx
  800121:	39 c1                	cmp    %eax,%ecx
  800123:	75 18                	jne    80013d <libmain+0x4a>
  800125:	eb 05                	jmp    80012c <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800127:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80012c:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80012f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800135:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80013b:	eb 0b                	jmp    800148 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80013d:	83 c2 01             	add    $0x1,%edx
  800140:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800146:	75 cd                	jne    800115 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800148:	85 db                	test   %ebx,%ebx
  80014a:	7e 07                	jle    800153 <libmain+0x60>
		binaryname = argv[0];
  80014c:	8b 06                	mov    (%esi),%eax
  80014e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800153:	89 74 24 04          	mov    %esi,0x4(%esp)
  800157:	89 1c 24             	mov    %ebx,(%esp)
  80015a:	e8 80 ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  80015f:	e8 07 00 00 00       	call   80016b <exit>
}
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    

0080016b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800171:	e8 90 13 00 00       	call   801506 <close_all>
	sys_env_destroy(0);
  800176:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017d:	e8 27 0b 00 00       	call   800ca9 <sys_env_destroy>
}
  800182:	c9                   	leave  
  800183:	c3                   	ret    

00800184 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	53                   	push   %ebx
  800188:	83 ec 14             	sub    $0x14,%esp
  80018b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018e:	8b 13                	mov    (%ebx),%edx
  800190:	8d 42 01             	lea    0x1(%edx),%eax
  800193:	89 03                	mov    %eax,(%ebx)
  800195:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800198:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a1:	75 19                	jne    8001bc <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001a3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001aa:	00 
  8001ab:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ae:	89 04 24             	mov    %eax,(%esp)
  8001b1:	e8 b6 0a 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  8001b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001bc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c0:	83 c4 14             	add    $0x14,%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d6:	00 00 00 
	b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fb:	c7 04 24 84 01 80 00 	movl   $0x800184,(%esp)
  800202:	e8 bd 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800207:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80020d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800211:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800217:	89 04 24             	mov    %eax,(%esp)
  80021a:	e8 4d 0a 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  80021f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800230:	89 44 24 04          	mov    %eax,0x4(%esp)
  800234:	8b 45 08             	mov    0x8(%ebp),%eax
  800237:	89 04 24             	mov    %eax,(%esp)
  80023a:	e8 87 ff ff ff       	call   8001c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80023f:	c9                   	leave  
  800240:	c3                   	ret    
  800241:	66 90                	xchg   %ax,%ax
  800243:	66 90                	xchg   %ax,%ax
  800245:	66 90                	xchg   %ax,%ax
  800247:	66 90                	xchg   %ax,%ax
  800249:	66 90                	xchg   %ax,%ax
  80024b:	66 90                	xchg   %ax,%ax
  80024d:	66 90                	xchg   %ax,%ax
  80024f:	90                   	nop

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 3c             	sub    $0x3c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800264:	8b 75 0c             	mov    0xc(%ebp),%esi
  800267:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800275:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800278:	39 f1                	cmp    %esi,%ecx
  80027a:	72 14                	jb     800290 <printnum+0x40>
  80027c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80027f:	76 0f                	jbe    800290 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800281:	8b 45 14             	mov    0x14(%ebp),%eax
  800284:	8d 70 ff             	lea    -0x1(%eax),%esi
  800287:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028a:	85 f6                	test   %esi,%esi
  80028c:	7f 60                	jg     8002ee <printnum+0x9e>
  80028e:	eb 72                	jmp    800302 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800290:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800293:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800297:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80029a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80029d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002a9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002ad:	89 c3                	mov    %eax,%ebx
  8002af:	89 d6                	mov    %edx,%esi
  8002b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	e8 5f 20 00 00       	call   802330 <__udivdi3>
  8002d1:	89 d9                	mov    %ebx,%ecx
  8002d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002db:	89 04 24             	mov    %eax,(%esp)
  8002de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e2:	89 fa                	mov    %edi,%edx
  8002e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e7:	e8 64 ff ff ff       	call   800250 <printnum>
  8002ec:	eb 14                	jmp    800302 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002fa:	83 ee 01             	sub    $0x1,%esi
  8002fd:	75 ef                	jne    8002ee <printnum+0x9e>
  8002ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800302:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800306:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80030a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80030d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800310:	89 44 24 08          	mov    %eax,0x8(%esp)
  800314:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	e8 36 21 00 00       	call   802460 <__umoddi3>
  80032a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80032e:	0f be 80 e0 25 80 00 	movsbl 0x8025e0(%eax),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033b:	ff d0                	call   *%eax
}
  80033d:	83 c4 3c             	add    $0x3c,%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800348:	83 fa 01             	cmp    $0x1,%edx
  80034b:	7e 0e                	jle    80035b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80034d:	8b 10                	mov    (%eax),%edx
  80034f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800352:	89 08                	mov    %ecx,(%eax)
  800354:	8b 02                	mov    (%edx),%eax
  800356:	8b 52 04             	mov    0x4(%edx),%edx
  800359:	eb 22                	jmp    80037d <getuint+0x38>
	else if (lflag)
  80035b:	85 d2                	test   %edx,%edx
  80035d:	74 10                	je     80036f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8d 4a 04             	lea    0x4(%edx),%ecx
  800364:	89 08                	mov    %ecx,(%eax)
  800366:	8b 02                	mov    (%edx),%eax
  800368:	ba 00 00 00 00       	mov    $0x0,%edx
  80036d:	eb 0e                	jmp    80037d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80036f:	8b 10                	mov    (%eax),%edx
  800371:	8d 4a 04             	lea    0x4(%edx),%ecx
  800374:	89 08                	mov    %ecx,(%eax)
  800376:	8b 02                	mov    (%edx),%eax
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800385:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	3b 50 04             	cmp    0x4(%eax),%edx
  80038e:	73 0a                	jae    80039a <sprintputch+0x1b>
		*b->buf++ = ch;
  800390:	8d 4a 01             	lea    0x1(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	88 02                	mov    %al,(%edx)
}
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 02 00 00 00       	call   8003c4 <vprintfmt>
	va_end(ap);
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d3:	eb 18                	jmp    8003ed <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	0f 84 c3 03 00 00    	je     8007a0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8003dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e7:	89 f3                	mov    %esi,%ebx
  8003e9:	eb 02                	jmp    8003ed <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8003eb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f0:	0f b6 03             	movzbl (%ebx),%eax
  8003f3:	83 f8 25             	cmp    $0x25,%eax
  8003f6:	75 dd                	jne    8003d5 <vprintfmt+0x11>
  8003f8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8003fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800403:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80040a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	eb 1d                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80041a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80041e:	eb 15                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800420:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800422:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800426:	eb 0d                	jmp    800435 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8d 5e 01             	lea    0x1(%esi),%ebx
  800438:	0f b6 06             	movzbl (%esi),%eax
  80043b:	0f b6 c8             	movzbl %al,%ecx
  80043e:	83 e8 23             	sub    $0x23,%eax
  800441:	3c 55                	cmp    $0x55,%al
  800443:	0f 87 2f 03 00 00    	ja     800778 <vprintfmt+0x3b4>
  800449:	0f b6 c0             	movzbl %al,%eax
  80044c:	ff 24 85 20 27 80 00 	jmp    *0x802720(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800453:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800456:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800459:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80045d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800460:	83 f9 09             	cmp    $0x9,%ecx
  800463:	77 50                	ja     8004b5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	89 de                	mov    %ebx,%esi
  800467:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80046a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80046d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800470:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800474:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800477:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047a:	83 fb 09             	cmp    $0x9,%ebx
  80047d:	76 eb                	jbe    80046a <vprintfmt+0xa6>
  80047f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800482:	eb 33                	jmp    8004b7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 48 04             	lea    0x4(%eax),%ecx
  80048a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800494:	eb 21                	jmp    8004b7 <vprintfmt+0xf3>
  800496:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800499:	85 c9                	test   %ecx,%ecx
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	0f 49 c1             	cmovns %ecx,%eax
  8004a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
  8004a8:	eb 8b                	jmp    800435 <vprintfmt+0x71>
  8004aa:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004ac:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b3:	eb 80                	jmp    800435 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004bb:	0f 89 74 ff ff ff    	jns    800435 <vprintfmt+0x71>
  8004c1:	e9 62 ff ff ff       	jmp    800428 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cb:	e9 65 ff ff ff       	jmp    800435 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 04 24             	mov    %eax,(%esp)
  8004e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e5:	e9 03 ff ff ff       	jmp    8003ed <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 50 04             	lea    0x4(%eax),%edx
  8004f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	99                   	cltd   
  8004f6:	31 d0                	xor    %edx,%eax
  8004f8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fa:	83 f8 0f             	cmp    $0xf,%eax
  8004fd:	7f 0b                	jg     80050a <vprintfmt+0x146>
  8004ff:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  800506:	85 d2                	test   %edx,%edx
  800508:	75 20                	jne    80052a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80050a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050e:	c7 44 24 08 f8 25 80 	movl   $0x8025f8,0x8(%esp)
  800515:	00 
  800516:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 77 fe ff ff       	call   80039c <printfmt>
  800525:	e9 c3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80052a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052e:	c7 44 24 08 ef 2a 80 	movl   $0x802aef,0x8(%esp)
  800535:	00 
  800536:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 57 fe ff ff       	call   80039c <printfmt>
  800545:	e9 a3 fe ff ff       	jmp    8003ed <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 50 04             	lea    0x4(%eax),%edx
  800556:	89 55 14             	mov    %edx,0x14(%ebp)
  800559:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80055b:	85 c0                	test   %eax,%eax
  80055d:	ba f1 25 80 00       	mov    $0x8025f1,%edx
  800562:	0f 45 d0             	cmovne %eax,%edx
  800565:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800568:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80056c:	74 04                	je     800572 <vprintfmt+0x1ae>
  80056e:	85 f6                	test   %esi,%esi
  800570:	7f 19                	jg     80058b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800572:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800575:	8d 70 01             	lea    0x1(%eax),%esi
  800578:	0f b6 10             	movzbl (%eax),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	0f 85 95 00 00 00    	jne    80061b <vprintfmt+0x257>
  800586:	e9 85 00 00 00       	jmp    800610 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80058f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800592:	89 04 24             	mov    %eax,(%esp)
  800595:	e8 b8 02 00 00       	call   800852 <strnlen>
  80059a:	29 c6                	sub    %eax,%esi
  80059c:	89 f0                	mov    %esi,%eax
  80059e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005a1:	85 f6                	test   %esi,%esi
  8005a3:	7e cd                	jle    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005a5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ac:	89 c3                	mov    %eax,%ebx
  8005ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b2:	89 34 24             	mov    %esi,(%esp)
  8005b5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	83 eb 01             	sub    $0x1,%ebx
  8005bb:	75 f1                	jne    8005ae <vprintfmt+0x1ea>
  8005bd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c3:	eb ad                	jmp    800572 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c9:	74 1e                	je     8005e9 <vprintfmt+0x225>
  8005cb:	0f be d2             	movsbl %dl,%edx
  8005ce:	83 ea 20             	sub    $0x20,%edx
  8005d1:	83 fa 5e             	cmp    $0x5e,%edx
  8005d4:	76 13                	jbe    8005e9 <vprintfmt+0x225>
					putch('?', putdat);
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e4:	ff 55 08             	call   *0x8(%ebp)
  8005e7:	eb 0d                	jmp    8005f6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8005e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f6:	83 ef 01             	sub    $0x1,%edi
  8005f9:	83 c6 01             	add    $0x1,%esi
  8005fc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800600:	0f be c2             	movsbl %dl,%eax
  800603:	85 c0                	test   %eax,%eax
  800605:	75 20                	jne    800627 <vprintfmt+0x263>
  800607:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80060a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800614:	7f 25                	jg     80063b <vprintfmt+0x277>
  800616:	e9 d2 fd ff ff       	jmp    8003ed <vprintfmt+0x29>
  80061b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800621:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800624:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800627:	85 db                	test   %ebx,%ebx
  800629:	78 9a                	js     8005c5 <vprintfmt+0x201>
  80062b:	83 eb 01             	sub    $0x1,%ebx
  80062e:	79 95                	jns    8005c5 <vprintfmt+0x201>
  800630:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800633:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800636:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800639:	eb d5                	jmp    800610 <vprintfmt+0x24c>
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800644:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800648:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80064f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800651:	83 eb 01             	sub    $0x1,%ebx
  800654:	75 ee                	jne    800644 <vprintfmt+0x280>
  800656:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800659:	e9 8f fd ff ff       	jmp    8003ed <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80065e:	83 fa 01             	cmp    $0x1,%edx
  800661:	7e 16                	jle    800679 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	89 55 14             	mov    %edx,0x14(%ebp)
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	eb 32                	jmp    8006ab <vprintfmt+0x2e7>
	else if (lflag)
  800679:	85 d2                	test   %edx,%edx
  80067b:	74 18                	je     800695 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)
  800686:	8b 30                	mov    (%eax),%esi
  800688:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	c1 f8 1f             	sar    $0x1f,%eax
  800690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800693:	eb 16                	jmp    8006ab <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 30                	mov    (%eax),%esi
  8006a0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	c1 f8 1f             	sar    $0x1f,%eax
  8006a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ba:	0f 89 80 00 00 00    	jns    800740 <vprintfmt+0x37c>
				putch('-', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d4:	f7 d8                	neg    %eax
  8006d6:	83 d2 00             	adc    $0x0,%edx
  8006d9:	f7 da                	neg    %edx
			}
			base = 10;
  8006db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e0:	eb 5e                	jmp    800740 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e5:	e8 5b fc ff ff       	call   800345 <getuint>
			base = 10;
  8006ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ef:	eb 4f                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8006f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f4:	e8 4c fc ff ff       	call   800345 <getuint>
			base = 8;
  8006f9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006fe:	eb 40                	jmp    800740 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80070e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800712:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800719:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800731:	eb 0d                	jmp    800740 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800733:	8d 45 14             	lea    0x14(%ebp),%eax
  800736:	e8 0a fc ff ff       	call   800345 <getuint>
			base = 16;
  80073b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800740:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800744:	89 74 24 10          	mov    %esi,0x10(%esp)
  800748:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80074b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80074f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800753:	89 04 24             	mov    %eax,(%esp)
  800756:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075a:	89 fa                	mov    %edi,%edx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	e8 ec fa ff ff       	call   800250 <printnum>
			break;
  800764:	e9 84 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800769:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076d:	89 0c 24             	mov    %ecx,(%esp)
  800770:	ff 55 08             	call   *0x8(%ebp)
			break;
  800773:	e9 75 fc ff ff       	jmp    8003ed <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800778:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800783:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800786:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80078a:	0f 84 5b fc ff ff    	je     8003eb <vprintfmt+0x27>
  800790:	89 f3                	mov    %esi,%ebx
  800792:	83 eb 01             	sub    $0x1,%ebx
  800795:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800799:	75 f7                	jne    800792 <vprintfmt+0x3ce>
  80079b:	e9 4d fc ff ff       	jmp    8003ed <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007a0:	83 c4 3c             	add    $0x3c,%esp
  8007a3:	5b                   	pop    %ebx
  8007a4:	5e                   	pop    %esi
  8007a5:	5f                   	pop    %edi
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 28             	sub    $0x28,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 30                	je     8007f9 <vsnprintf+0x51>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 2c                	jle    8007f9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e2:	c7 04 24 7f 03 80 00 	movl   $0x80037f,(%esp)
  8007e9:	e8 d6 fb ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	eb 05                	jmp    8007fe <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800806:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800809:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	89 44 24 08          	mov    %eax,0x8(%esp)
  800814:	8b 45 0c             	mov    0xc(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	e8 82 ff ff ff       	call   8007a8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	80 3a 00             	cmpb   $0x0,(%edx)
  800839:	74 10                	je     80084b <strlen+0x1b>
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <strlen+0x10>
  800849:	eb 05                	jmp    800850 <strlen+0x20>
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085c:	85 c9                	test   %ecx,%ecx
  80085e:	74 1c                	je     80087c <strnlen+0x2a>
  800860:	80 3b 00             	cmpb   $0x0,(%ebx)
  800863:	74 1e                	je     800883 <strnlen+0x31>
  800865:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80086a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086c:	39 ca                	cmp    %ecx,%edx
  80086e:	74 18                	je     800888 <strnlen+0x36>
  800870:	83 c2 01             	add    $0x1,%edx
  800873:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800878:	75 f0                	jne    80086a <strnlen+0x18>
  80087a:	eb 0c                	jmp    800888 <strnlen+0x36>
  80087c:	b8 00 00 00 00       	mov    $0x0,%eax
  800881:	eb 05                	jmp    800888 <strnlen+0x36>
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	53                   	push   %ebx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800895:	89 c2                	mov    %eax,%edx
  800897:	83 c2 01             	add    $0x1,%edx
  80089a:	83 c1 01             	add    $0x1,%ecx
  80089d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a4:	84 db                	test   %bl,%bl
  8008a6:	75 ef                	jne    800897 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b5:	89 1c 24             	mov    %ebx,(%esp)
  8008b8:	e8 73 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c4:	01 d8                	add    %ebx,%eax
  8008c6:	89 04 24             	mov    %eax,(%esp)
  8008c9:	e8 bd ff ff ff       	call   80088b <strcpy>
	return dst;
}
  8008ce:	89 d8                	mov    %ebx,%eax
  8008d0:	83 c4 08             	add    $0x8,%esp
  8008d3:	5b                   	pop    %ebx
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	8b 75 08             	mov    0x8(%ebp),%esi
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e4:	85 db                	test   %ebx,%ebx
  8008e6:	74 17                	je     8008ff <strncpy+0x29>
  8008e8:	01 f3                	add    %esi,%ebx
  8008ea:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8008ec:	83 c1 01             	add    $0x1,%ecx
  8008ef:	0f b6 02             	movzbl (%edx),%eax
  8008f2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f5:	80 3a 01             	cmpb   $0x1,(%edx)
  8008f8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fb:	39 d9                	cmp    %ebx,%ecx
  8008fd:	75 ed                	jne    8008ec <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ff:	89 f0                	mov    %esi,%eax
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800911:	8b 75 10             	mov    0x10(%ebp),%esi
  800914:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800916:	85 f6                	test   %esi,%esi
  800918:	74 34                	je     80094e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80091a:	83 fe 01             	cmp    $0x1,%esi
  80091d:	74 26                	je     800945 <strlcpy+0x40>
  80091f:	0f b6 0b             	movzbl (%ebx),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	74 23                	je     800949 <strlcpy+0x44>
  800926:	83 ee 02             	sub    $0x2,%esi
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80092e:	83 c0 01             	add    $0x1,%eax
  800931:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800934:	39 f2                	cmp    %esi,%edx
  800936:	74 13                	je     80094b <strlcpy+0x46>
  800938:	83 c2 01             	add    $0x1,%edx
  80093b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 eb                	jne    80092e <strlcpy+0x29>
  800943:	eb 06                	jmp    80094b <strlcpy+0x46>
  800945:	89 f8                	mov    %edi,%eax
  800947:	eb 02                	jmp    80094b <strlcpy+0x46>
  800949:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80094b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094e:	29 f8                	sub    %edi,%eax
}
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095e:	0f b6 01             	movzbl (%ecx),%eax
  800961:	84 c0                	test   %al,%al
  800963:	74 15                	je     80097a <strcmp+0x25>
  800965:	3a 02                	cmp    (%edx),%al
  800967:	75 11                	jne    80097a <strcmp+0x25>
		p++, q++;
  800969:	83 c1 01             	add    $0x1,%ecx
  80096c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80096f:	0f b6 01             	movzbl (%ecx),%eax
  800972:	84 c0                	test   %al,%al
  800974:	74 04                	je     80097a <strcmp+0x25>
  800976:	3a 02                	cmp    (%edx),%al
  800978:	74 ef                	je     800969 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097a:	0f b6 c0             	movzbl %al,%eax
  80097d:	0f b6 12             	movzbl (%edx),%edx
  800980:	29 d0                	sub    %edx,%eax
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800992:	85 f6                	test   %esi,%esi
  800994:	74 29                	je     8009bf <strncmp+0x3b>
  800996:	0f b6 03             	movzbl (%ebx),%eax
  800999:	84 c0                	test   %al,%al
  80099b:	74 30                	je     8009cd <strncmp+0x49>
  80099d:	3a 02                	cmp    (%edx),%al
  80099f:	75 2c                	jne    8009cd <strncmp+0x49>
  8009a1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009a4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ab:	39 f0                	cmp    %esi,%eax
  8009ad:	74 17                	je     8009c6 <strncmp+0x42>
  8009af:	0f b6 08             	movzbl (%eax),%ecx
  8009b2:	84 c9                	test   %cl,%cl
  8009b4:	74 17                	je     8009cd <strncmp+0x49>
  8009b6:	83 c0 01             	add    $0x1,%eax
  8009b9:	3a 0a                	cmp    (%edx),%cl
  8009bb:	74 e9                	je     8009a6 <strncmp+0x22>
  8009bd:	eb 0e                	jmp    8009cd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	eb 0f                	jmp    8009d5 <strncmp+0x51>
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	eb 08                	jmp    8009d5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 03             	movzbl (%ebx),%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8009e3:	0f b6 18             	movzbl (%eax),%ebx
  8009e6:	84 db                	test   %bl,%bl
  8009e8:	74 1d                	je     800a07 <strchr+0x2e>
  8009ea:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8009ec:	38 d3                	cmp    %dl,%bl
  8009ee:	75 06                	jne    8009f6 <strchr+0x1d>
  8009f0:	eb 1a                	jmp    800a0c <strchr+0x33>
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 16                	je     800a0c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	0f b6 10             	movzbl (%eax),%edx
  8009fc:	84 d2                	test   %dl,%dl
  8009fe:	75 f2                	jne    8009f2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb 05                	jmp    800a0c <strchr+0x33>
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0c:	5b                   	pop    %ebx
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a19:	0f b6 18             	movzbl (%eax),%ebx
  800a1c:	84 db                	test   %bl,%bl
  800a1e:	74 16                	je     800a36 <strfind+0x27>
  800a20:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a22:	38 d3                	cmp    %dl,%bl
  800a24:	75 06                	jne    800a2c <strfind+0x1d>
  800a26:	eb 0e                	jmp    800a36 <strfind+0x27>
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 0a                	je     800a36 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	0f b6 10             	movzbl (%eax),%edx
  800a32:	84 d2                	test   %dl,%dl
  800a34:	75 f2                	jne    800a28 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a45:	85 c9                	test   %ecx,%ecx
  800a47:	74 36                	je     800a7f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a49:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4f:	75 28                	jne    800a79 <memset+0x40>
  800a51:	f6 c1 03             	test   $0x3,%cl
  800a54:	75 23                	jne    800a79 <memset+0x40>
		c &= 0xFF;
  800a56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5a:	89 d3                	mov    %edx,%ebx
  800a5c:	c1 e3 08             	shl    $0x8,%ebx
  800a5f:	89 d6                	mov    %edx,%esi
  800a61:	c1 e6 18             	shl    $0x18,%esi
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	c1 e0 10             	shl    $0x10,%eax
  800a69:	09 f0                	or     %esi,%eax
  800a6b:	09 c2                	or     %eax,%edx
  800a6d:	89 d0                	mov    %edx,%eax
  800a6f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a71:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a74:	fc                   	cld    
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
  800a77:	eb 06                	jmp    800a7f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	fc                   	cld    
  800a7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7f:	89 f8                	mov    %edi,%eax
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5f                   	pop    %edi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	57                   	push   %edi
  800a8a:	56                   	push   %esi
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a94:	39 c6                	cmp    %eax,%esi
  800a96:	73 35                	jae    800acd <memmove+0x47>
  800a98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 2e                	jae    800acd <memmove+0x47>
		s += n;
		d += n;
  800a9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aac:	75 13                	jne    800ac1 <memmove+0x3b>
  800aae:	f6 c1 03             	test   $0x3,%cl
  800ab1:	75 0e                	jne    800ac1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab3:	83 ef 04             	sub    $0x4,%edi
  800ab6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800abc:	fd                   	std    
  800abd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abf:	eb 09                	jmp    800aca <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac1:	83 ef 01             	sub    $0x1,%edi
  800ac4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac7:	fd                   	std    
  800ac8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aca:	fc                   	cld    
  800acb:	eb 1d                	jmp    800aea <memmove+0x64>
  800acd:	89 f2                	mov    %esi,%edx
  800acf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	f6 c2 03             	test   $0x3,%dl
  800ad4:	75 0f                	jne    800ae5 <memmove+0x5f>
  800ad6:	f6 c1 03             	test   $0x3,%cl
  800ad9:	75 0a                	jne    800ae5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800adb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae3:	eb 05                	jmp    800aea <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae5:	89 c7                	mov    %eax,%edi
  800ae7:	fc                   	cld    
  800ae8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af4:	8b 45 10             	mov    0x10(%ebp),%eax
  800af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	89 04 24             	mov    %eax,(%esp)
  800b08:	e8 79 ff ff ff       	call   800a86 <memmove>
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	57                   	push   %edi
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b21:	85 c0                	test   %eax,%eax
  800b23:	74 36                	je     800b5b <memcmp+0x4c>
		if (*s1 != *s2)
  800b25:	0f b6 03             	movzbl (%ebx),%eax
  800b28:	0f b6 0e             	movzbl (%esi),%ecx
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	38 c8                	cmp    %cl,%al
  800b32:	74 1c                	je     800b50 <memcmp+0x41>
  800b34:	eb 10                	jmp    800b46 <memcmp+0x37>
  800b36:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b3b:	83 c2 01             	add    $0x1,%edx
  800b3e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b42:	38 c8                	cmp    %cl,%al
  800b44:	74 0a                	je     800b50 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b46:	0f b6 c0             	movzbl %al,%eax
  800b49:	0f b6 c9             	movzbl %cl,%ecx
  800b4c:	29 c8                	sub    %ecx,%eax
  800b4e:	eb 10                	jmp    800b60 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b50:	39 fa                	cmp    %edi,%edx
  800b52:	75 e2                	jne    800b36 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	eb 05                	jmp    800b60 <memcmp+0x51>
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	39 d0                	cmp    %edx,%eax
  800b76:	73 13                	jae    800b8b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b78:	89 d9                	mov    %ebx,%ecx
  800b7a:	38 18                	cmp    %bl,(%eax)
  800b7c:	75 06                	jne    800b84 <memfind+0x1f>
  800b7e:	eb 0b                	jmp    800b8b <memfind+0x26>
  800b80:	38 08                	cmp    %cl,(%eax)
  800b82:	74 07                	je     800b8b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	39 d0                	cmp    %edx,%eax
  800b89:	75 f5                	jne    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9a:	0f b6 0a             	movzbl (%edx),%ecx
  800b9d:	80 f9 09             	cmp    $0x9,%cl
  800ba0:	74 05                	je     800ba7 <strtol+0x19>
  800ba2:	80 f9 20             	cmp    $0x20,%cl
  800ba5:	75 10                	jne    800bb7 <strtol+0x29>
		s++;
  800ba7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baa:	0f b6 0a             	movzbl (%edx),%ecx
  800bad:	80 f9 09             	cmp    $0x9,%cl
  800bb0:	74 f5                	je     800ba7 <strtol+0x19>
  800bb2:	80 f9 20             	cmp    $0x20,%cl
  800bb5:	74 f0                	je     800ba7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bb7:	80 f9 2b             	cmp    $0x2b,%cl
  800bba:	75 0a                	jne    800bc6 <strtol+0x38>
		s++;
  800bbc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc4:	eb 11                	jmp    800bd7 <strtol+0x49>
  800bc6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bcb:	80 f9 2d             	cmp    $0x2d,%cl
  800bce:	75 07                	jne    800bd7 <strtol+0x49>
		s++, neg = 1;
  800bd0:	83 c2 01             	add    $0x1,%edx
  800bd3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bdc:	75 15                	jne    800bf3 <strtol+0x65>
  800bde:	80 3a 30             	cmpb   $0x30,(%edx)
  800be1:	75 10                	jne    800bf3 <strtol+0x65>
  800be3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be7:	75 0a                	jne    800bf3 <strtol+0x65>
		s += 2, base = 16;
  800be9:	83 c2 02             	add    $0x2,%edx
  800bec:	b8 10 00 00 00       	mov    $0x10,%eax
  800bf1:	eb 10                	jmp    800c03 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	75 0c                	jne    800c03 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf9:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfc:	75 05                	jne    800c03 <strtol+0x75>
		s++, base = 8;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c08:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c0b:	0f b6 0a             	movzbl (%edx),%ecx
  800c0e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c11:	89 f0                	mov    %esi,%eax
  800c13:	3c 09                	cmp    $0x9,%al
  800c15:	77 08                	ja     800c1f <strtol+0x91>
			dig = *s - '0';
  800c17:	0f be c9             	movsbl %cl,%ecx
  800c1a:	83 e9 30             	sub    $0x30,%ecx
  800c1d:	eb 20                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c1f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c22:	89 f0                	mov    %esi,%eax
  800c24:	3c 19                	cmp    $0x19,%al
  800c26:	77 08                	ja     800c30 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c28:	0f be c9             	movsbl %cl,%ecx
  800c2b:	83 e9 57             	sub    $0x57,%ecx
  800c2e:	eb 0f                	jmp    800c3f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c30:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c33:	89 f0                	mov    %esi,%eax
  800c35:	3c 19                	cmp    $0x19,%al
  800c37:	77 16                	ja     800c4f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c39:	0f be c9             	movsbl %cl,%ecx
  800c3c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c3f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c42:	7d 0f                	jge    800c53 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c44:	83 c2 01             	add    $0x1,%edx
  800c47:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c4b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c4d:	eb bc                	jmp    800c0b <strtol+0x7d>
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	eb 02                	jmp    800c55 <strtol+0xc7>
  800c53:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xd2>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c60:	f7 d8                	neg    %eax
  800c62:	85 ff                	test   %edi,%edi
  800c64:	0f 44 c3             	cmove  %ebx,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7e 28                	jle    800cf3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cd6:	00 
  800cd7:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800cde:	00 
  800cdf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ce6:	00 
  800ce7:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800cee:	e8 d3 13 00 00       	call   8020c6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf3:	83 c4 2c             	add    $0x2c,%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
  800d06:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0b:	89 d1                	mov    %edx,%ecx
  800d0d:	89 d3                	mov    %edx,%ebx
  800d0f:	89 d7                	mov    %edx,%edi
  800d11:	89 d6                	mov    %edx,%esi
  800d13:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_yield>:

void
sys_yield(void)
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
  800d25:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d42:	be 00 00 00 00       	mov    $0x0,%esi
  800d47:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d55:	89 f7                	mov    %esi,%edi
  800d57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800d80:	e8 41 13 00 00       	call   8020c6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da7:	8b 75 18             	mov    0x18(%ebp),%esi
  800daa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800dd3:	e8 ee 12 00 00       	call   8020c6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 06 00 00 00       	mov    $0x6,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800e26:	e8 9b 12 00 00       	call   8020c6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 08 00 00 00       	mov    $0x8,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800e79:	e8 48 12 00 00       	call   8020c6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	b8 09 00 00 00       	mov    $0x9,%eax
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7e 28                	jle    800ed1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ead:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800ebc:	00 
  800ebd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ec4:	00 
  800ec5:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800ecc:	e8 f5 11 00 00       	call   8020c6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed1:	83 c4 2c             	add    $0x2c,%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7e 28                	jle    800f24 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f00:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f07:	00 
  800f08:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800f0f:	00 
  800f10:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f17:	00 
  800f18:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800f1f:	e8 a2 11 00 00       	call   8020c6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f24:	83 c4 2c             	add    $0x2c,%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	be 00 00 00 00       	mov    $0x0,%esi
  800f37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f48:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	89 cb                	mov    %ecx,%ebx
  800f67:	89 cf                	mov    %ecx,%edi
  800f69:	89 ce                	mov    %ecx,%esi
  800f6b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	7e 28                	jle    800f99 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f71:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f75:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f7c:	00 
  800f7d:	c7 44 24 08 df 28 80 	movl   $0x8028df,0x8(%esp)
  800f84:	00 
  800f85:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f8c:	00 
  800f8d:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800f94:	e8 2d 11 00 00       	call   8020c6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f99:	83 c4 2c             	add    $0x2c,%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 24             	sub    $0x24,%esp
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fab:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  800fad:	89 da                	mov    %ebx,%edx
  800faf:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  800fb2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  800fb9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fbd:	74 05                	je     800fc4 <pgfault+0x23>
  800fbf:	f6 c6 08             	test   $0x8,%dh
  800fc2:	75 1c                	jne    800fe0 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  800fc4:	c7 44 24 08 0c 29 80 	movl   $0x80290c,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  800fdb:	e8 e6 10 00 00       	call   8020c6 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  800fe0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fef:	00 
  800ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ff7:	e8 3d fd ff ff       	call   800d39 <sys_page_alloc>
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	79 20                	jns    801020 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801000:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801004:	c7 44 24 08 74 29 80 	movl   $0x802974,0x8(%esp)
  80100b:	00 
  80100c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801013:	00 
  801014:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  80101b:	e8 a6 10 00 00       	call   8020c6 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801020:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801026:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80102d:	00 
  80102e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801032:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801039:	e8 48 fa ff ff       	call   800a86 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80103e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801045:	00 
  801046:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80104a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801061:	e8 27 fd ff ff       	call   800d8d <sys_page_map>
  801066:	85 c0                	test   %eax,%eax
  801068:	79 20                	jns    80108a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80106a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80106e:	c7 44 24 08 8e 29 80 	movl   $0x80298e,0x8(%esp)
  801075:	00 
  801076:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80107d:	00 
  80107e:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  801085:	e8 3c 10 00 00       	call   8020c6 <_panic>
	}
}
  80108a:	83 c4 24             	add    $0x24,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801099:	c7 04 24 a1 0f 80 00 	movl   $0x800fa1,(%esp)
  8010a0:	e8 77 10 00 00       	call   80211c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010a5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010aa:	cd 30                	int    $0x30
  8010ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	79 1c                	jns    8010cf <fork+0x3f>
		panic("fork");
  8010b3:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  8010c2:	00 
  8010c3:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  8010ca:	e8 f7 0f 00 00       	call   8020c6 <_panic>
  8010cf:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  8010d1:	bb 00 08 00 00       	mov    $0x800,%ebx
  8010d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010da:	75 21                	jne    8010fd <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  8010dc:	e8 1a fc ff ff       	call   800cfb <sys_getenvid>
  8010e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ee:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	e9 c5 01 00 00       	jmp    8012c2 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	c1 e8 0a             	shr    $0xa,%eax
  801102:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801109:	a8 01                	test   $0x1,%al
  80110b:	0f 84 f2 00 00 00    	je     801203 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801111:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801118:	a8 05                	test   $0x5,%al
  80111a:	0f 84 e3 00 00 00    	je     801203 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801120:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801127:	89 de                	mov    %ebx,%esi
  801129:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80112c:	a9 02 08 00 00       	test   $0x802,%eax
  801131:	0f 84 88 00 00 00    	je     8011bf <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801137:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80113e:	00 
  80113f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801143:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801147:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801152:	e8 36 fc ff ff       	call   800d8d <sys_page_map>
  801157:	85 c0                	test   %eax,%eax
  801159:	79 20                	jns    80117b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80115b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115f:	c7 44 24 08 ac 29 80 	movl   $0x8029ac,0x8(%esp)
  801166:	00 
  801167:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80116e:	00 
  80116f:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  801176:	e8 4b 0f 00 00       	call   8020c6 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80117b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801182:	00 
  801183:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801187:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80118e:	00 
  80118f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801193:	89 3c 24             	mov    %edi,(%esp)
  801196:	e8 f2 fb ff ff       	call   800d8d <sys_page_map>
  80119b:	85 c0                	test   %eax,%eax
  80119d:	79 64                	jns    801203 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80119f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011a3:	c7 44 24 08 c6 29 80 	movl   $0x8029c6,0x8(%esp)
  8011aa:	00 
  8011ab:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8011b2:	00 
  8011b3:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  8011ba:	e8 07 0f 00 00       	call   8020c6 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8011bf:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8011c6:	00 
  8011c7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011da:	e8 ae fb ff ff       	call   800d8d <sys_page_map>
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	79 20                	jns    801203 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  8011e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e7:	c7 44 24 08 e0 29 80 	movl   $0x8029e0,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  8011fe:	e8 c3 0e 00 00       	call   8020c6 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801203:	83 c3 01             	add    $0x1,%ebx
  801206:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80120c:	0f 85 eb fe ff ff    	jne    8010fd <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801212:	c7 44 24 04 85 21 80 	movl   $0x802185,0x4(%esp)
  801219:	00 
  80121a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121d:	89 04 24             	mov    %eax,(%esp)
  801220:	e8 b4 fc ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
  801225:	85 c0                	test   %eax,%eax
  801227:	79 20                	jns    801249 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801229:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122d:	c7 44 24 08 44 29 80 	movl   $0x802944,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  801244:	e8 7d 0e 00 00       	call   8020c6 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801249:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801250:	00 
  801251:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801258:	ee 
  801259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125c:	89 04 24             	mov    %eax,(%esp)
  80125f:	e8 d5 fa ff ff       	call   800d39 <sys_page_alloc>
  801264:	85 c0                	test   %eax,%eax
  801266:	79 20                	jns    801288 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126c:	c7 44 24 08 f2 29 80 	movl   $0x8029f2,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  801283:	e8 3e 0e 00 00       	call   8020c6 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801288:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80128f:	00 
  801290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801293:	89 04 24             	mov    %eax,(%esp)
  801296:	e8 98 fb ff ff       	call   800e33 <sys_env_set_status>
  80129b:	85 c0                	test   %eax,%eax
  80129d:	79 20                	jns    8012bf <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80129f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a3:	c7 44 24 08 0a 2a 80 	movl   $0x802a0a,0x8(%esp)
  8012aa:	00 
  8012ab:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  8012b2:	00 
  8012b3:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  8012ba:	e8 07 0e 00 00       	call   8020c6 <_panic>
	}

	return envid;
  8012bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8012c2:	83 c4 2c             	add    $0x2c,%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <sfork>:

// Challenge!
int
sfork(void)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012d0:	c7 44 24 08 25 2a 80 	movl   $0x802a25,0x8(%esp)
  8012d7:	00 
  8012d8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  8012df:	00 
  8012e0:	c7 04 24 69 29 80 00 	movl   $0x802969,(%esp)
  8012e7:	e8 da 0d 00 00       	call   8020c6 <_panic>
  8012ec:	66 90                	xchg   %ax,%ax
  8012ee:	66 90                	xchg   %ax,%ax

008012f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80130b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801310:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80131a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80131f:	a8 01                	test   $0x1,%al
  801321:	74 34                	je     801357 <fd_alloc+0x40>
  801323:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801328:	a8 01                	test   $0x1,%al
  80132a:	74 32                	je     80135e <fd_alloc+0x47>
  80132c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801331:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801333:	89 c2                	mov    %eax,%edx
  801335:	c1 ea 16             	shr    $0x16,%edx
  801338:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133f:	f6 c2 01             	test   $0x1,%dl
  801342:	74 1f                	je     801363 <fd_alloc+0x4c>
  801344:	89 c2                	mov    %eax,%edx
  801346:	c1 ea 0c             	shr    $0xc,%edx
  801349:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801350:	f6 c2 01             	test   $0x1,%dl
  801353:	75 1a                	jne    80136f <fd_alloc+0x58>
  801355:	eb 0c                	jmp    801363 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801357:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80135c:	eb 05                	jmp    801363 <fd_alloc+0x4c>
  80135e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 08                	mov    %ecx,(%eax)
			return 0;
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	eb 1a                	jmp    801389 <fd_alloc+0x72>
  80136f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801374:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801379:	75 b6                	jne    801331 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801384:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801391:	83 f8 1f             	cmp    $0x1f,%eax
  801394:	77 36                	ja     8013cc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801396:	c1 e0 0c             	shl    $0xc,%eax
  801399:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	c1 ea 16             	shr    $0x16,%edx
  8013a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013aa:	f6 c2 01             	test   $0x1,%dl
  8013ad:	74 24                	je     8013d3 <fd_lookup+0x48>
  8013af:	89 c2                	mov    %eax,%edx
  8013b1:	c1 ea 0c             	shr    $0xc,%edx
  8013b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013bb:	f6 c2 01             	test   $0x1,%dl
  8013be:	74 1a                	je     8013da <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ca:	eb 13                	jmp    8013df <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d1:	eb 0c                	jmp    8013df <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d8:	eb 05                	jmp    8013df <fd_lookup+0x54>
  8013da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    

008013e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 14             	sub    $0x14,%esp
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013ee:	39 05 04 30 80 00    	cmp    %eax,0x803004
  8013f4:	75 1e                	jne    801414 <dev_lookup+0x33>
  8013f6:	eb 0e                	jmp    801406 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013f8:	b8 20 30 80 00       	mov    $0x803020,%eax
  8013fd:	eb 0c                	jmp    80140b <dev_lookup+0x2a>
  8013ff:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801404:	eb 05                	jmp    80140b <dev_lookup+0x2a>
  801406:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80140b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	eb 38                	jmp    80144c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801414:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80141a:	74 dc                	je     8013f8 <dev_lookup+0x17>
  80141c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801422:	74 db                	je     8013ff <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801424:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80142a:	8b 52 48             	mov    0x48(%edx),%edx
  80142d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801431:	89 54 24 04          	mov    %edx,0x4(%esp)
  801435:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  80143c:	e8 e6 ed ff ff       	call   800227 <cprintf>
	*dev = 0;
  801441:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80144c:	83 c4 14             	add    $0x14,%esp
  80144f:	5b                   	pop    %ebx
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    

00801452 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	56                   	push   %esi
  801456:	53                   	push   %ebx
  801457:	83 ec 20             	sub    $0x20,%esp
  80145a:	8b 75 08             	mov    0x8(%ebp),%esi
  80145d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801460:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801463:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801467:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80146d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801470:	89 04 24             	mov    %eax,(%esp)
  801473:	e8 13 ff ff ff       	call   80138b <fd_lookup>
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 05                	js     801481 <fd_close+0x2f>
	    || fd != fd2)
  80147c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80147f:	74 0c                	je     80148d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801481:	84 db                	test   %bl,%bl
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
  801488:	0f 44 c2             	cmove  %edx,%eax
  80148b:	eb 3f                	jmp    8014cc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80148d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801490:	89 44 24 04          	mov    %eax,0x4(%esp)
  801494:	8b 06                	mov    (%esi),%eax
  801496:	89 04 24             	mov    %eax,(%esp)
  801499:	e8 43 ff ff ff       	call   8013e1 <dev_lookup>
  80149e:	89 c3                	mov    %eax,%ebx
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 16                	js     8014ba <fd_close+0x68>
		if (dev->dev_close)
  8014a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014aa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 07                	je     8014ba <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014b3:	89 34 24             	mov    %esi,(%esp)
  8014b6:	ff d0                	call   *%eax
  8014b8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c5:	e8 16 f9 ff ff       	call   800de0 <sys_page_unmap>
	return r;
  8014ca:	89 d8                	mov    %ebx,%eax
}
  8014cc:	83 c4 20             	add    $0x20,%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	89 04 24             	mov    %eax,(%esp)
  8014e6:	e8 a0 fe ff ff       	call   80138b <fd_lookup>
  8014eb:	89 c2                	mov    %eax,%edx
  8014ed:	85 d2                	test   %edx,%edx
  8014ef:	78 13                	js     801504 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014f8:	00 
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	89 04 24             	mov    %eax,(%esp)
  8014ff:	e8 4e ff ff ff       	call   801452 <fd_close>
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <close_all>:

void
close_all(void)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80150d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801512:	89 1c 24             	mov    %ebx,(%esp)
  801515:	e8 b9 ff ff ff       	call   8014d3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80151a:	83 c3 01             	add    $0x1,%ebx
  80151d:	83 fb 20             	cmp    $0x20,%ebx
  801520:	75 f0                	jne    801512 <close_all+0xc>
		close(i);
}
  801522:	83 c4 14             	add    $0x14,%esp
  801525:	5b                   	pop    %ebx
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	57                   	push   %edi
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801531:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 48 fe ff ff       	call   80138b <fd_lookup>
  801543:	89 c2                	mov    %eax,%edx
  801545:	85 d2                	test   %edx,%edx
  801547:	0f 88 e1 00 00 00    	js     80162e <dup+0x106>
		return r;
	close(newfdnum);
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	89 04 24             	mov    %eax,(%esp)
  801553:	e8 7b ff ff ff       	call   8014d3 <close>

	newfd = INDEX2FD(newfdnum);
  801558:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80155b:	c1 e3 0c             	shl    $0xc,%ebx
  80155e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801567:	89 04 24             	mov    %eax,(%esp)
  80156a:	e8 91 fd ff ff       	call   801300 <fd2data>
  80156f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801571:	89 1c 24             	mov    %ebx,(%esp)
  801574:	e8 87 fd ff ff       	call   801300 <fd2data>
  801579:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80157b:	89 f0                	mov    %esi,%eax
  80157d:	c1 e8 16             	shr    $0x16,%eax
  801580:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801587:	a8 01                	test   $0x1,%al
  801589:	74 43                	je     8015ce <dup+0xa6>
  80158b:	89 f0                	mov    %esi,%eax
  80158d:	c1 e8 0c             	shr    $0xc,%eax
  801590:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801597:	f6 c2 01             	test   $0x1,%dl
  80159a:	74 32                	je     8015ce <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80159c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ac:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015b7:	00 
  8015b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c3:	e8 c5 f7 ff ff       	call   800d8d <sys_page_map>
  8015c8:	89 c6                	mov    %eax,%esi
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 3e                	js     80160c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	c1 ea 0c             	shr    $0xc,%edx
  8015d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015dd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015e3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f2:	00 
  8015f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fe:	e8 8a f7 ff ff       	call   800d8d <sys_page_map>
  801603:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801608:	85 f6                	test   %esi,%esi
  80160a:	79 22                	jns    80162e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80160c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801617:	e8 c4 f7 ff ff       	call   800de0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80161c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801620:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801627:	e8 b4 f7 ff ff       	call   800de0 <sys_page_unmap>
	return r;
  80162c:	89 f0                	mov    %esi,%eax
}
  80162e:	83 c4 3c             	add    $0x3c,%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5f                   	pop    %edi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 24             	sub    $0x24,%esp
  80163d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	89 1c 24             	mov    %ebx,(%esp)
  80164a:	e8 3c fd ff ff       	call   80138b <fd_lookup>
  80164f:	89 c2                	mov    %eax,%edx
  801651:	85 d2                	test   %edx,%edx
  801653:	78 6d                	js     8016c2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801655:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	89 04 24             	mov    %eax,(%esp)
  801664:	e8 78 fd ff ff       	call   8013e1 <dev_lookup>
  801669:	85 c0                	test   %eax,%eax
  80166b:	78 55                	js     8016c2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	8b 50 08             	mov    0x8(%eax),%edx
  801673:	83 e2 03             	and    $0x3,%edx
  801676:	83 fa 01             	cmp    $0x1,%edx
  801679:	75 23                	jne    80169e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80167b:	a1 04 40 80 00       	mov    0x804004,%eax
  801680:	8b 40 48             	mov    0x48(%eax),%eax
  801683:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168b:	c7 04 24 7d 2a 80 00 	movl   $0x802a7d,(%esp)
  801692:	e8 90 eb ff ff       	call   800227 <cprintf>
		return -E_INVAL;
  801697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169c:	eb 24                	jmp    8016c2 <read+0x8c>
	}
	if (!dev->dev_read)
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	8b 52 08             	mov    0x8(%edx),%edx
  8016a4:	85 d2                	test   %edx,%edx
  8016a6:	74 15                	je     8016bd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016b6:	89 04 24             	mov    %eax,(%esp)
  8016b9:	ff d2                	call   *%edx
  8016bb:	eb 05                	jmp    8016c2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016c2:	83 c4 24             	add    $0x24,%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    

008016c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d7:	85 f6                	test   %esi,%esi
  8016d9:	74 33                	je     80170e <readn+0x46>
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e5:	89 f2                	mov    %esi,%edx
  8016e7:	29 c2                	sub    %eax,%edx
  8016e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016ed:	03 45 0c             	add    0xc(%ebp),%eax
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	89 3c 24             	mov    %edi,(%esp)
  8016f7:	e8 3a ff ff ff       	call   801636 <read>
		if (m < 0)
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 1b                	js     80171b <readn+0x53>
			return m;
		if (m == 0)
  801700:	85 c0                	test   %eax,%eax
  801702:	74 11                	je     801715 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801704:	01 c3                	add    %eax,%ebx
  801706:	89 d8                	mov    %ebx,%eax
  801708:	39 f3                	cmp    %esi,%ebx
  80170a:	72 d9                	jb     8016e5 <readn+0x1d>
  80170c:	eb 0b                	jmp    801719 <readn+0x51>
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 06                	jmp    80171b <readn+0x53>
  801715:	89 d8                	mov    %ebx,%eax
  801717:	eb 02                	jmp    80171b <readn+0x53>
  801719:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80171b:	83 c4 1c             	add    $0x1c,%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5f                   	pop    %edi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	53                   	push   %ebx
  801727:	83 ec 24             	sub    $0x24,%esp
  80172a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801730:	89 44 24 04          	mov    %eax,0x4(%esp)
  801734:	89 1c 24             	mov    %ebx,(%esp)
  801737:	e8 4f fc ff ff       	call   80138b <fd_lookup>
  80173c:	89 c2                	mov    %eax,%edx
  80173e:	85 d2                	test   %edx,%edx
  801740:	78 68                	js     8017aa <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801745:	89 44 24 04          	mov    %eax,0x4(%esp)
  801749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174c:	8b 00                	mov    (%eax),%eax
  80174e:	89 04 24             	mov    %eax,(%esp)
  801751:	e8 8b fc ff ff       	call   8013e1 <dev_lookup>
  801756:	85 c0                	test   %eax,%eax
  801758:	78 50                	js     8017aa <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801761:	75 23                	jne    801786 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801763:	a1 04 40 80 00       	mov    0x804004,%eax
  801768:	8b 40 48             	mov    0x48(%eax),%eax
  80176b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80176f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801773:	c7 04 24 99 2a 80 00 	movl   $0x802a99,(%esp)
  80177a:	e8 a8 ea ff ff       	call   800227 <cprintf>
		return -E_INVAL;
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801784:	eb 24                	jmp    8017aa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801789:	8b 52 0c             	mov    0xc(%edx),%edx
  80178c:	85 d2                	test   %edx,%edx
  80178e:	74 15                	je     8017a5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801790:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801793:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80179e:	89 04 24             	mov    %eax,(%esp)
  8017a1:	ff d2                	call   *%edx
  8017a3:	eb 05                	jmp    8017aa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017aa:	83 c4 24             	add    $0x24,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	89 04 24             	mov    %eax,(%esp)
  8017c3:	e8 c3 fb ff ff       	call   80138b <fd_lookup>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	78 0e                	js     8017da <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 24             	sub    $0x24,%esp
  8017e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ed:	89 1c 24             	mov    %ebx,(%esp)
  8017f0:	e8 96 fb ff ff       	call   80138b <fd_lookup>
  8017f5:	89 c2                	mov    %eax,%edx
  8017f7:	85 d2                	test   %edx,%edx
  8017f9:	78 61                	js     80185c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 d2 fb ff ff       	call   8013e1 <dev_lookup>
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 49                	js     80185c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181a:	75 23                	jne    80183f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80181c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801821:	8b 40 48             	mov    0x48(%eax),%eax
  801824:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182c:	c7 04 24 5c 2a 80 00 	movl   $0x802a5c,(%esp)
  801833:	e8 ef e9 ff ff       	call   800227 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183d:	eb 1d                	jmp    80185c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80183f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801842:	8b 52 18             	mov    0x18(%edx),%edx
  801845:	85 d2                	test   %edx,%edx
  801847:	74 0e                	je     801857 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801850:	89 04 24             	mov    %eax,(%esp)
  801853:	ff d2                	call   *%edx
  801855:	eb 05                	jmp    80185c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801857:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80185c:	83 c4 24             	add    $0x24,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    

00801862 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	53                   	push   %ebx
  801866:	83 ec 24             	sub    $0x24,%esp
  801869:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	89 04 24             	mov    %eax,(%esp)
  801879:	e8 0d fb ff ff       	call   80138b <fd_lookup>
  80187e:	89 c2                	mov    %eax,%edx
  801880:	85 d2                	test   %edx,%edx
  801882:	78 52                	js     8018d6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	8b 00                	mov    (%eax),%eax
  801890:	89 04 24             	mov    %eax,(%esp)
  801893:	e8 49 fb ff ff       	call   8013e1 <dev_lookup>
  801898:	85 c0                	test   %eax,%eax
  80189a:	78 3a                	js     8018d6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018a3:	74 2c                	je     8018d1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018af:	00 00 00 
	stat->st_isdir = 0;
  8018b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018b9:	00 00 00 
	stat->st_dev = dev;
  8018bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c9:	89 14 24             	mov    %edx,(%esp)
  8018cc:	ff 50 14             	call   *0x14(%eax)
  8018cf:	eb 05                	jmp    8018d6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018d6:	83 c4 24             	add    $0x24,%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018eb:	00 
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 e1 01 00 00       	call   801ad8 <open>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	85 db                	test   %ebx,%ebx
  8018fb:	78 1b                	js     801918 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801900:	89 44 24 04          	mov    %eax,0x4(%esp)
  801904:	89 1c 24             	mov    %ebx,(%esp)
  801907:	e8 56 ff ff ff       	call   801862 <fstat>
  80190c:	89 c6                	mov    %eax,%esi
	close(fd);
  80190e:	89 1c 24             	mov    %ebx,(%esp)
  801911:	e8 bd fb ff ff       	call   8014d3 <close>
	return r;
  801916:	89 f0                	mov    %esi,%eax
}
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5d                   	pop    %ebp
  80191e:	c3                   	ret    

0080191f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 10             	sub    $0x10,%esp
  801927:	89 c3                	mov    %eax,%ebx
  801929:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80192b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801932:	75 11                	jne    801945 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80193b:	e8 64 09 00 00       	call   8022a4 <ipc_find_env>
  801940:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801945:	a1 04 40 80 00       	mov    0x804004,%eax
  80194a:	8b 40 48             	mov    0x48(%eax),%eax
  80194d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801953:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801957:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	c7 04 24 b6 2a 80 00 	movl   $0x802ab6,(%esp)
  801966:	e8 bc e8 ff ff       	call   800227 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80196b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801972:	00 
  801973:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80197a:	00 
  80197b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80197f:	a1 00 40 80 00       	mov    0x804000,%eax
  801984:	89 04 24             	mov    %eax,(%esp)
  801987:	e8 b2 08 00 00       	call   80223e <ipc_send>
	cprintf("ipc_send\n");
  80198c:	c7 04 24 cc 2a 80 00 	movl   $0x802acc,(%esp)
  801993:	e8 8f e8 ff ff       	call   800227 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801998:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80199f:	00 
  8019a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ab:	e8 26 08 00 00       	call   8021d6 <ipc_recv>
}
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 14             	sub    $0x14,%esp
  8019be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d1:	b8 05 00 00 00       	mov    $0x5,%eax
  8019d6:	e8 44 ff ff ff       	call   80191f <fsipc>
  8019db:	89 c2                	mov    %eax,%edx
  8019dd:	85 d2                	test   %edx,%edx
  8019df:	78 2b                	js     801a0c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019e1:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019e8:	00 
  8019e9:	89 1c 24             	mov    %ebx,(%esp)
  8019ec:	e8 9a ee ff ff       	call   80088b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f1:	a1 80 50 80 00       	mov    0x805080,%eax
  8019f6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019fc:	a1 84 50 80 00       	mov    0x805084,%eax
  801a01:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0c:	83 c4 14             	add    $0x14,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    

00801a12 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	b8 06 00 00 00       	mov    $0x6,%eax
  801a2d:	e8 ed fe ff ff       	call   80191f <fsipc>
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	83 ec 10             	sub    $0x10,%esp
  801a3c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8b 40 0c             	mov    0xc(%eax),%eax
  801a45:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a4a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a50:	ba 00 00 00 00       	mov    $0x0,%edx
  801a55:	b8 03 00 00 00       	mov    $0x3,%eax
  801a5a:	e8 c0 fe ff ff       	call   80191f <fsipc>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 6a                	js     801acf <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a65:	39 c6                	cmp    %eax,%esi
  801a67:	73 24                	jae    801a8d <devfile_read+0x59>
  801a69:	c7 44 24 0c d6 2a 80 	movl   $0x802ad6,0xc(%esp)
  801a70:	00 
  801a71:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801a78:	00 
  801a79:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801a80:	00 
  801a81:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801a88:	e8 39 06 00 00       	call   8020c6 <_panic>
	assert(r <= PGSIZE);
  801a8d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a92:	7e 24                	jle    801ab8 <devfile_read+0x84>
  801a94:	c7 44 24 0c fd 2a 80 	movl   $0x802afd,0xc(%esp)
  801a9b:	00 
  801a9c:	c7 44 24 08 dd 2a 80 	movl   $0x802add,0x8(%esp)
  801aa3:	00 
  801aa4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801aab:	00 
  801aac:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  801ab3:	e8 0e 06 00 00       	call   8020c6 <_panic>
	memmove(buf, &fsipcbuf, r);
  801ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801abc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ac3:	00 
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	89 04 24             	mov    %eax,(%esp)
  801aca:	e8 b7 ef ff ff       	call   800a86 <memmove>
	return r;
}
  801acf:	89 d8                	mov    %ebx,%eax
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	5b                   	pop    %ebx
  801ad5:	5e                   	pop    %esi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    

00801ad8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	53                   	push   %ebx
  801adc:	83 ec 24             	sub    $0x24,%esp
  801adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ae2:	89 1c 24             	mov    %ebx,(%esp)
  801ae5:	e8 46 ed ff ff       	call   800830 <strlen>
  801aea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aef:	7f 60                	jg     801b51 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801af1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 1b f8 ff ff       	call   801317 <fd_alloc>
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	85 d2                	test   %edx,%edx
  801b00:	78 54                	js     801b56 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b06:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b0d:	e8 79 ed ff ff       	call   80088b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b22:	e8 f8 fd ff ff       	call   80191f <fsipc>
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	79 17                	jns    801b44 <open+0x6c>
		fd_close(fd, 0);
  801b2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b34:	00 
  801b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b38:	89 04 24             	mov    %eax,(%esp)
  801b3b:	e8 12 f9 ff ff       	call   801452 <fd_close>
		return r;
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	eb 12                	jmp    801b56 <open+0x7e>
	}
	return fd2num(fd);
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	89 04 24             	mov    %eax,(%esp)
  801b4a:	e8 a1 f7 ff ff       	call   8012f0 <fd2num>
  801b4f:	eb 05                	jmp    801b56 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b51:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801b56:	83 c4 24             	add    $0x24,%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	66 90                	xchg   %ax,%ax
  801b5e:	66 90                	xchg   %ax,%ax

00801b60 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	83 ec 10             	sub    $0x10,%esp
  801b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	89 04 24             	mov    %eax,(%esp)
  801b71:	e8 8a f7 ff ff       	call   801300 <fd2data>
  801b76:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b78:	c7 44 24 04 09 2b 80 	movl   $0x802b09,0x4(%esp)
  801b7f:	00 
  801b80:	89 1c 24             	mov    %ebx,(%esp)
  801b83:	e8 03 ed ff ff       	call   80088b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b88:	8b 46 04             	mov    0x4(%esi),%eax
  801b8b:	2b 06                	sub    (%esi),%eax
  801b8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b9a:	00 00 00 
	stat->st_dev = &devpipe;
  801b9d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ba4:	30 80 00 
	return 0;
}
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 14             	sub    $0x14,%esp
  801bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc8:	e8 13 f2 ff ff       	call   800de0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bcd:	89 1c 24             	mov    %ebx,(%esp)
  801bd0:	e8 2b f7 ff ff       	call   801300 <fd2data>
  801bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be0:	e8 fb f1 ff ff       	call   800de0 <sys_page_unmap>
}
  801be5:	83 c4 14             	add    $0x14,%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    

00801beb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	57                   	push   %edi
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 2c             	sub    $0x2c,%esp
  801bf4:	89 c6                	mov    %eax,%esi
  801bf6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801bf9:	a1 04 40 80 00       	mov    0x804004,%eax
  801bfe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c01:	89 34 24             	mov    %esi,(%esp)
  801c04:	e8 e3 06 00 00       	call   8022ec <pageref>
  801c09:	89 c7                	mov    %eax,%edi
  801c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 d6 06 00 00       	call   8022ec <pageref>
  801c16:	39 c7                	cmp    %eax,%edi
  801c18:	0f 94 c2             	sete   %dl
  801c1b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801c1e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801c24:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801c27:	39 fb                	cmp    %edi,%ebx
  801c29:	74 21                	je     801c4c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c2b:	84 d2                	test   %dl,%dl
  801c2d:	74 ca                	je     801bf9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c2f:	8b 51 58             	mov    0x58(%ecx),%edx
  801c32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c3e:	c7 04 24 10 2b 80 00 	movl   $0x802b10,(%esp)
  801c45:	e8 dd e5 ff ff       	call   800227 <cprintf>
  801c4a:	eb ad                	jmp    801bf9 <_pipeisclosed+0xe>
	}
}
  801c4c:	83 c4 2c             	add    $0x2c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	57                   	push   %edi
  801c58:	56                   	push   %esi
  801c59:	53                   	push   %ebx
  801c5a:	83 ec 1c             	sub    $0x1c,%esp
  801c5d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c60:	89 34 24             	mov    %esi,(%esp)
  801c63:	e8 98 f6 ff ff       	call   801300 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c6c:	74 61                	je     801ccf <devpipe_write+0x7b>
  801c6e:	89 c3                	mov    %eax,%ebx
  801c70:	bf 00 00 00 00       	mov    $0x0,%edi
  801c75:	eb 4a                	jmp    801cc1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c77:	89 da                	mov    %ebx,%edx
  801c79:	89 f0                	mov    %esi,%eax
  801c7b:	e8 6b ff ff ff       	call   801beb <_pipeisclosed>
  801c80:	85 c0                	test   %eax,%eax
  801c82:	75 54                	jne    801cd8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c84:	e8 91 f0 ff ff       	call   800d1a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c89:	8b 43 04             	mov    0x4(%ebx),%eax
  801c8c:	8b 0b                	mov    (%ebx),%ecx
  801c8e:	8d 51 20             	lea    0x20(%ecx),%edx
  801c91:	39 d0                	cmp    %edx,%eax
  801c93:	73 e2                	jae    801c77 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c98:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c9c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c9f:	99                   	cltd   
  801ca0:	c1 ea 1b             	shr    $0x1b,%edx
  801ca3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ca6:	83 e1 1f             	and    $0x1f,%ecx
  801ca9:	29 d1                	sub    %edx,%ecx
  801cab:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801caf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801cb3:	83 c0 01             	add    $0x1,%eax
  801cb6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cb9:	83 c7 01             	add    $0x1,%edi
  801cbc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cbf:	74 13                	je     801cd4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc1:	8b 43 04             	mov    0x4(%ebx),%eax
  801cc4:	8b 0b                	mov    (%ebx),%ecx
  801cc6:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc9:	39 d0                	cmp    %edx,%eax
  801ccb:	73 aa                	jae    801c77 <devpipe_write+0x23>
  801ccd:	eb c6                	jmp    801c95 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ccf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801cd4:	89 f8                	mov    %edi,%eax
  801cd6:	eb 05                	jmp    801cdd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	57                   	push   %edi
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 1c             	sub    $0x1c,%esp
  801cee:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801cf1:	89 3c 24             	mov    %edi,(%esp)
  801cf4:	e8 07 f6 ff ff       	call   801300 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cfd:	74 54                	je     801d53 <devpipe_read+0x6e>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	be 00 00 00 00       	mov    $0x0,%esi
  801d06:	eb 3e                	jmp    801d46 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801d08:	89 f0                	mov    %esi,%eax
  801d0a:	eb 55                	jmp    801d61 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d0c:	89 da                	mov    %ebx,%edx
  801d0e:	89 f8                	mov    %edi,%eax
  801d10:	e8 d6 fe ff ff       	call   801beb <_pipeisclosed>
  801d15:	85 c0                	test   %eax,%eax
  801d17:	75 43                	jne    801d5c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801d19:	e8 fc ef ff ff       	call   800d1a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801d1e:	8b 03                	mov    (%ebx),%eax
  801d20:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d23:	74 e7                	je     801d0c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d25:	99                   	cltd   
  801d26:	c1 ea 1b             	shr    $0x1b,%edx
  801d29:	01 d0                	add    %edx,%eax
  801d2b:	83 e0 1f             	and    $0x1f,%eax
  801d2e:	29 d0                	sub    %edx,%eax
  801d30:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d38:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d3b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d3e:	83 c6 01             	add    $0x1,%esi
  801d41:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d44:	74 12                	je     801d58 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801d46:	8b 03                	mov    (%ebx),%eax
  801d48:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d4b:	75 d8                	jne    801d25 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801d4d:	85 f6                	test   %esi,%esi
  801d4f:	75 b7                	jne    801d08 <devpipe_read+0x23>
  801d51:	eb b9                	jmp    801d0c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d58:	89 f0                	mov    %esi,%eax
  801d5a:	eb 05                	jmp    801d61 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d61:	83 c4 1c             	add    $0x1c,%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5f                   	pop    %edi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d74:	89 04 24             	mov    %eax,(%esp)
  801d77:	e8 9b f5 ff ff       	call   801317 <fd_alloc>
  801d7c:	89 c2                	mov    %eax,%edx
  801d7e:	85 d2                	test   %edx,%edx
  801d80:	0f 88 4d 01 00 00    	js     801ed3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d8d:	00 
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9c:	e8 98 ef ff ff       	call   800d39 <sys_page_alloc>
  801da1:	89 c2                	mov    %eax,%edx
  801da3:	85 d2                	test   %edx,%edx
  801da5:	0f 88 28 01 00 00    	js     801ed3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801dab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 61 f5 ff ff       	call   801317 <fd_alloc>
  801db6:	89 c3                	mov    %eax,%ebx
  801db8:	85 c0                	test   %eax,%eax
  801dba:	0f 88 fe 00 00 00    	js     801ebe <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dc7:	00 
  801dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd6:	e8 5e ef ff ff       	call   800d39 <sys_page_alloc>
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	0f 88 d9 00 00 00    	js     801ebe <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	89 04 24             	mov    %eax,(%esp)
  801deb:	e8 10 f5 ff ff       	call   801300 <fd2data>
  801df0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801df9:	00 
  801dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e05:	e8 2f ef ff ff       	call   800d39 <sys_page_alloc>
  801e0a:	89 c3                	mov    %eax,%ebx
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	0f 88 97 00 00 00    	js     801eab <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 e1 f4 ff ff       	call   801300 <fd2data>
  801e1f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801e26:	00 
  801e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e32:	00 
  801e33:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3e:	e8 4a ef ff ff       	call   800d8d <sys_page_map>
  801e43:	89 c3                	mov    %eax,%ebx
  801e45:	85 c0                	test   %eax,%eax
  801e47:	78 52                	js     801e9b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801e49:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e5e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e67:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	89 04 24             	mov    %eax,(%esp)
  801e79:	e8 72 f4 ff ff       	call   8012f0 <fd2num>
  801e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e81:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 62 f4 ff ff       	call   8012f0 <fd2num>
  801e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e91:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	eb 38                	jmp    801ed3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801e9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea6:	e8 35 ef ff ff       	call   800de0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb9:	e8 22 ef ff ff       	call   800de0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ecc:	e8 0f ef ff ff       	call   800de0 <sys_page_unmap>
  801ed1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801ed3:	83 c4 30             	add    $0x30,%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	89 04 24             	mov    %eax,(%esp)
  801eed:	e8 99 f4 ff ff       	call   80138b <fd_lookup>
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	85 d2                	test   %edx,%edx
  801ef6:	78 15                	js     801f0d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	89 04 24             	mov    %eax,(%esp)
  801efe:	e8 fd f3 ff ff       	call   801300 <fd2data>
	return _pipeisclosed(fd, p);
  801f03:	89 c2                	mov    %eax,%edx
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	e8 de fc ff ff       	call   801beb <_pipeisclosed>
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    
  801f0f:	90                   	nop

00801f10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801f20:	c7 44 24 04 28 2b 80 	movl   $0x802b28,0x4(%esp)
  801f27:	00 
  801f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2b:	89 04 24             	mov    %eax,(%esp)
  801f2e:	e8 58 e9 ff ff       	call   80088b <strcpy>
	return 0;
}
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	57                   	push   %edi
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f4a:	74 4a                	je     801f96 <devcons_write+0x5c>
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f51:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f56:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f5c:	8b 75 10             	mov    0x10(%ebp),%esi
  801f5f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801f61:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f64:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801f69:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f6c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f70:	03 45 0c             	add    0xc(%ebp),%eax
  801f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f77:	89 3c 24             	mov    %edi,(%esp)
  801f7a:	e8 07 eb ff ff       	call   800a86 <memmove>
		sys_cputs(buf, m);
  801f7f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f83:	89 3c 24             	mov    %edi,(%esp)
  801f86:	e8 e1 ec ff ff       	call   800c6c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f8b:	01 f3                	add    %esi,%ebx
  801f8d:	89 d8                	mov    %ebx,%eax
  801f8f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801f92:	72 c8                	jb     801f5c <devcons_write+0x22>
  801f94:	eb 05                	jmp    801f9b <devcons_write+0x61>
  801f96:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb7:	75 07                	jne    801fc0 <devcons_read+0x18>
  801fb9:	eb 28                	jmp    801fe3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801fbb:	e8 5a ed ff ff       	call   800d1a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801fc0:	e8 c5 ec ff ff       	call   800c8a <sys_cgetc>
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	74 f2                	je     801fbb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	78 16                	js     801fe3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801fcd:	83 f8 04             	cmp    $0x4,%eax
  801fd0:	74 0c                	je     801fde <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	88 02                	mov    %al,(%edx)
	return 1;
  801fd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdc:	eb 05                	jmp    801fe3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ff8:	00 
  801ff9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ffc:	89 04 24             	mov    %eax,(%esp)
  801fff:	e8 68 ec ff ff       	call   800c6c <sys_cputs>
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <getchar>:

int
getchar(void)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80200c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802013:	00 
  802014:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802022:	e8 0f f6 ff ff       	call   801636 <read>
	if (r < 0)
  802027:	85 c0                	test   %eax,%eax
  802029:	78 0f                	js     80203a <getchar+0x34>
		return r;
	if (r < 1)
  80202b:	85 c0                	test   %eax,%eax
  80202d:	7e 06                	jle    802035 <getchar+0x2f>
		return -E_EOF;
	return c;
  80202f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802033:	eb 05                	jmp    80203a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802035:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802045:	89 44 24 04          	mov    %eax,0x4(%esp)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 37 f3 ff ff       	call   80138b <fd_lookup>
  802054:	85 c0                	test   %eax,%eax
  802056:	78 11                	js     802069 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802061:	39 10                	cmp    %edx,(%eax)
  802063:	0f 94 c0             	sete   %al
  802066:	0f b6 c0             	movzbl %al,%eax
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <opencons>:

int
opencons(void)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802074:	89 04 24             	mov    %eax,(%esp)
  802077:	e8 9b f2 ff ff       	call   801317 <fd_alloc>
		return r;
  80207c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 40                	js     8020c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802082:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802089:	00 
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802098:	e8 9c ec ff ff       	call   800d39 <sys_page_alloc>
		return r;
  80209d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 1f                	js     8020c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8020a3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 30 f2 ff ff       	call   8012f0 <fd2num>
  8020c0:	89 c2                	mov    %eax,%edx
}
  8020c2:	89 d0                	mov    %edx,%eax
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	56                   	push   %esi
  8020ca:	53                   	push   %ebx
  8020cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8020ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8020d7:	e8 1f ec ff ff       	call   800cfb <sys_getenvid>
  8020dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8020e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f2:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  8020f9:	e8 29 e1 ff ff       	call   800227 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802102:	8b 45 10             	mov    0x10(%ebp),%eax
  802105:	89 04 24             	mov    %eax,(%esp)
  802108:	e8 b9 e0 ff ff       	call   8001c6 <vcprintf>
	cprintf("\n");
  80210d:	c7 04 24 cf 25 80 00 	movl   $0x8025cf,(%esp)
  802114:	e8 0e e1 ff ff       	call   800227 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802119:	cc                   	int3   
  80211a:	eb fd                	jmp    802119 <_panic+0x53>

0080211c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  802122:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802129:	75 50                	jne    80217b <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80212b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802132:	00 
  802133:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80213a:	ee 
  80213b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802142:	e8 f2 eb ff ff       	call   800d39 <sys_page_alloc>
  802147:	85 c0                	test   %eax,%eax
  802149:	79 1c                	jns    802167 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  80214b:	c7 44 24 08 58 2b 80 	movl   $0x802b58,0x8(%esp)
  802152:	00 
  802153:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80215a:	00 
  80215b:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  802162:	e8 5f ff ff ff       	call   8020c6 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802167:	c7 44 24 04 85 21 80 	movl   $0x802185,0x4(%esp)
  80216e:	00 
  80216f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802176:	e8 5e ed ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802185:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802186:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80218b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80218d:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  802190:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  802192:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802197:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80219a:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  80219f:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8021a2:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8021a4:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8021a7:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8021a9:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8021ab:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8021b0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8021b3:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8021b8:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8021bb:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8021bd:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  8021c2:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  8021c5:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  8021ca:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  8021cd:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  8021cf:	83 c4 08             	add    $0x8,%esp
	popal
  8021d2:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8021d3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021d4:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8021d5:	c3                   	ret    

008021d6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	56                   	push   %esi
  8021da:	53                   	push   %ebx
  8021db:	83 ec 10             	sub    $0x10,%esp
  8021de:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ee:	0f 44 c2             	cmove  %edx,%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 56 ed ff ff       	call   800f4f <sys_ipc_recv>
	if (err_code < 0) {
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	79 16                	jns    802213 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8021fd:	85 f6                	test   %esi,%esi
  8021ff:	74 06                	je     802207 <ipc_recv+0x31>
  802201:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802207:	85 db                	test   %ebx,%ebx
  802209:	74 2c                	je     802237 <ipc_recv+0x61>
  80220b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802211:	eb 24                	jmp    802237 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802213:	85 f6                	test   %esi,%esi
  802215:	74 0a                	je     802221 <ipc_recv+0x4b>
  802217:	a1 04 40 80 00       	mov    0x804004,%eax
  80221c:	8b 40 74             	mov    0x74(%eax),%eax
  80221f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802221:	85 db                	test   %ebx,%ebx
  802223:	74 0a                	je     80222f <ipc_recv+0x59>
  802225:	a1 04 40 80 00       	mov    0x804004,%eax
  80222a:	8b 40 78             	mov    0x78(%eax),%eax
  80222d:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80222f:	a1 04 40 80 00       	mov    0x804004,%eax
  802234:	8b 40 70             	mov    0x70(%eax),%eax
}
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	5b                   	pop    %ebx
  80223b:	5e                   	pop    %esi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    

0080223e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 1c             	sub    $0x1c,%esp
  802247:	8b 7d 08             	mov    0x8(%ebp),%edi
  80224a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802250:	eb 25                	jmp    802277 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802252:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802255:	74 20                	je     802277 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802257:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80225b:	c7 44 24 08 8a 2b 80 	movl   $0x802b8a,0x8(%esp)
  802262:	00 
  802263:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80226a:	00 
  80226b:	c7 04 24 96 2b 80 00 	movl   $0x802b96,(%esp)
  802272:	e8 4f fe ff ff       	call   8020c6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802277:	85 db                	test   %ebx,%ebx
  802279:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80227e:	0f 45 c3             	cmovne %ebx,%eax
  802281:	8b 55 14             	mov    0x14(%ebp),%edx
  802284:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802288:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802290:	89 3c 24             	mov    %edi,(%esp)
  802293:	e8 94 ec ff ff       	call   800f2c <sys_ipc_try_send>
  802298:	85 c0                	test   %eax,%eax
  80229a:	75 b6                	jne    802252 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80229c:	83 c4 1c             	add    $0x1c,%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8022aa:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8022af:	39 c8                	cmp    %ecx,%eax
  8022b1:	74 17                	je     8022ca <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022b3:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8022b8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c1:	8b 52 50             	mov    0x50(%edx),%edx
  8022c4:	39 ca                	cmp    %ecx,%edx
  8022c6:	75 14                	jne    8022dc <ipc_find_env+0x38>
  8022c8:	eb 05                	jmp    8022cf <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8022cf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022d2:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8022d7:	8b 40 40             	mov    0x40(%eax),%eax
  8022da:	eb 0e                	jmp    8022ea <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022dc:	83 c0 01             	add    $0x1,%eax
  8022df:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022e4:	75 d2                	jne    8022b8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8022e6:	66 b8 00 00          	mov    $0x0,%ax
}
  8022ea:	5d                   	pop    %ebp
  8022eb:	c3                   	ret    

008022ec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f2:	89 d0                	mov    %edx,%eax
  8022f4:	c1 e8 16             	shr    $0x16,%eax
  8022f7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802303:	f6 c1 01             	test   $0x1,%cl
  802306:	74 1d                	je     802325 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802308:	c1 ea 0c             	shr    $0xc,%edx
  80230b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802312:	f6 c2 01             	test   $0x1,%dl
  802315:	74 0e                	je     802325 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802317:	c1 ea 0c             	shr    $0xc,%edx
  80231a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802321:	ef 
  802322:	0f b7 c0             	movzwl %ax,%eax
}
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    
  802327:	66 90                	xchg   %ax,%ax
  802329:	66 90                	xchg   %ax,%ax
  80232b:	66 90                	xchg   %ax,%ax
  80232d:	66 90                	xchg   %ax,%ax
  80232f:	90                   	nop

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	8b 44 24 28          	mov    0x28(%esp),%eax
  80233a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80233e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802342:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802346:	85 c0                	test   %eax,%eax
  802348:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80234c:	89 ea                	mov    %ebp,%edx
  80234e:	89 0c 24             	mov    %ecx,(%esp)
  802351:	75 2d                	jne    802380 <__udivdi3+0x50>
  802353:	39 e9                	cmp    %ebp,%ecx
  802355:	77 61                	ja     8023b8 <__udivdi3+0x88>
  802357:	85 c9                	test   %ecx,%ecx
  802359:	89 ce                	mov    %ecx,%esi
  80235b:	75 0b                	jne    802368 <__udivdi3+0x38>
  80235d:	b8 01 00 00 00       	mov    $0x1,%eax
  802362:	31 d2                	xor    %edx,%edx
  802364:	f7 f1                	div    %ecx
  802366:	89 c6                	mov    %eax,%esi
  802368:	31 d2                	xor    %edx,%edx
  80236a:	89 e8                	mov    %ebp,%eax
  80236c:	f7 f6                	div    %esi
  80236e:	89 c5                	mov    %eax,%ebp
  802370:	89 f8                	mov    %edi,%eax
  802372:	f7 f6                	div    %esi
  802374:	89 ea                	mov    %ebp,%edx
  802376:	83 c4 0c             	add    $0xc,%esp
  802379:	5e                   	pop    %esi
  80237a:	5f                   	pop    %edi
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	39 e8                	cmp    %ebp,%eax
  802382:	77 24                	ja     8023a8 <__udivdi3+0x78>
  802384:	0f bd e8             	bsr    %eax,%ebp
  802387:	83 f5 1f             	xor    $0x1f,%ebp
  80238a:	75 3c                	jne    8023c8 <__udivdi3+0x98>
  80238c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802390:	39 34 24             	cmp    %esi,(%esp)
  802393:	0f 86 9f 00 00 00    	jbe    802438 <__udivdi3+0x108>
  802399:	39 d0                	cmp    %edx,%eax
  80239b:	0f 82 97 00 00 00    	jb     802438 <__udivdi3+0x108>
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	31 d2                	xor    %edx,%edx
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	83 c4 0c             	add    $0xc,%esp
  8023af:	5e                   	pop    %esi
  8023b0:	5f                   	pop    %edi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    
  8023b3:	90                   	nop
  8023b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 f8                	mov    %edi,%eax
  8023ba:	f7 f1                	div    %ecx
  8023bc:	31 d2                	xor    %edx,%edx
  8023be:	83 c4 0c             	add    $0xc,%esp
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	8b 3c 24             	mov    (%esp),%edi
  8023cd:	d3 e0                	shl    %cl,%eax
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d6:	29 e8                	sub    %ebp,%eax
  8023d8:	89 c1                	mov    %eax,%ecx
  8023da:	d3 ef                	shr    %cl,%edi
  8023dc:	89 e9                	mov    %ebp,%ecx
  8023de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023e2:	8b 3c 24             	mov    (%esp),%edi
  8023e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8023e9:	89 d6                	mov    %edx,%esi
  8023eb:	d3 e7                	shl    %cl,%edi
  8023ed:	89 c1                	mov    %eax,%ecx
  8023ef:	89 3c 24             	mov    %edi,(%esp)
  8023f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8023f6:	d3 ee                	shr    %cl,%esi
  8023f8:	89 e9                	mov    %ebp,%ecx
  8023fa:	d3 e2                	shl    %cl,%edx
  8023fc:	89 c1                	mov    %eax,%ecx
  8023fe:	d3 ef                	shr    %cl,%edi
  802400:	09 d7                	or     %edx,%edi
  802402:	89 f2                	mov    %esi,%edx
  802404:	89 f8                	mov    %edi,%eax
  802406:	f7 74 24 08          	divl   0x8(%esp)
  80240a:	89 d6                	mov    %edx,%esi
  80240c:	89 c7                	mov    %eax,%edi
  80240e:	f7 24 24             	mull   (%esp)
  802411:	39 d6                	cmp    %edx,%esi
  802413:	89 14 24             	mov    %edx,(%esp)
  802416:	72 30                	jb     802448 <__udivdi3+0x118>
  802418:	8b 54 24 04          	mov    0x4(%esp),%edx
  80241c:	89 e9                	mov    %ebp,%ecx
  80241e:	d3 e2                	shl    %cl,%edx
  802420:	39 c2                	cmp    %eax,%edx
  802422:	73 05                	jae    802429 <__udivdi3+0xf9>
  802424:	3b 34 24             	cmp    (%esp),%esi
  802427:	74 1f                	je     802448 <__udivdi3+0x118>
  802429:	89 f8                	mov    %edi,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	e9 7a ff ff ff       	jmp    8023ac <__udivdi3+0x7c>
  802432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	b8 01 00 00 00       	mov    $0x1,%eax
  80243f:	e9 68 ff ff ff       	jmp    8023ac <__udivdi3+0x7c>
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	8d 47 ff             	lea    -0x1(%edi),%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	83 c4 0c             	add    $0xc,%esp
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    
  802454:	66 90                	xchg   %ax,%ax
  802456:	66 90                	xchg   %ax,%ax
  802458:	66 90                	xchg   %ax,%ax
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	83 ec 14             	sub    $0x14,%esp
  802466:	8b 44 24 28          	mov    0x28(%esp),%eax
  80246a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80246e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802472:	89 c7                	mov    %eax,%edi
  802474:	89 44 24 04          	mov    %eax,0x4(%esp)
  802478:	8b 44 24 30          	mov    0x30(%esp),%eax
  80247c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802480:	89 34 24             	mov    %esi,(%esp)
  802483:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802487:	85 c0                	test   %eax,%eax
  802489:	89 c2                	mov    %eax,%edx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	75 17                	jne    8024a8 <__umoddi3+0x48>
  802491:	39 fe                	cmp    %edi,%esi
  802493:	76 4b                	jbe    8024e0 <__umoddi3+0x80>
  802495:	89 c8                	mov    %ecx,%eax
  802497:	89 fa                	mov    %edi,%edx
  802499:	f7 f6                	div    %esi
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	31 d2                	xor    %edx,%edx
  80249f:	83 c4 14             	add    $0x14,%esp
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	39 f8                	cmp    %edi,%eax
  8024aa:	77 54                	ja     802500 <__umoddi3+0xa0>
  8024ac:	0f bd e8             	bsr    %eax,%ebp
  8024af:	83 f5 1f             	xor    $0x1f,%ebp
  8024b2:	75 5c                	jne    802510 <__umoddi3+0xb0>
  8024b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024b8:	39 3c 24             	cmp    %edi,(%esp)
  8024bb:	0f 87 e7 00 00 00    	ja     8025a8 <__umoddi3+0x148>
  8024c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024c5:	29 f1                	sub    %esi,%ecx
  8024c7:	19 c7                	sbb    %eax,%edi
  8024c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024d9:	83 c4 14             	add    $0x14,%esp
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    
  8024e0:	85 f6                	test   %esi,%esi
  8024e2:	89 f5                	mov    %esi,%ebp
  8024e4:	75 0b                	jne    8024f1 <__umoddi3+0x91>
  8024e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	f7 f6                	div    %esi
  8024ef:	89 c5                	mov    %eax,%ebp
  8024f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024f5:	31 d2                	xor    %edx,%edx
  8024f7:	f7 f5                	div    %ebp
  8024f9:	89 c8                	mov    %ecx,%eax
  8024fb:	f7 f5                	div    %ebp
  8024fd:	eb 9c                	jmp    80249b <__umoddi3+0x3b>
  8024ff:	90                   	nop
  802500:	89 c8                	mov    %ecx,%eax
  802502:	89 fa                	mov    %edi,%edx
  802504:	83 c4 14             	add    $0x14,%esp
  802507:	5e                   	pop    %esi
  802508:	5f                   	pop    %edi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    
  80250b:	90                   	nop
  80250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802510:	8b 04 24             	mov    (%esp),%eax
  802513:	be 20 00 00 00       	mov    $0x20,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	29 ee                	sub    %ebp,%esi
  80251c:	d3 e2                	shl    %cl,%edx
  80251e:	89 f1                	mov    %esi,%ecx
  802520:	d3 e8                	shr    %cl,%eax
  802522:	89 e9                	mov    %ebp,%ecx
  802524:	89 44 24 04          	mov    %eax,0x4(%esp)
  802528:	8b 04 24             	mov    (%esp),%eax
  80252b:	09 54 24 04          	or     %edx,0x4(%esp)
  80252f:	89 fa                	mov    %edi,%edx
  802531:	d3 e0                	shl    %cl,%eax
  802533:	89 f1                	mov    %esi,%ecx
  802535:	89 44 24 08          	mov    %eax,0x8(%esp)
  802539:	8b 44 24 10          	mov    0x10(%esp),%eax
  80253d:	d3 ea                	shr    %cl,%edx
  80253f:	89 e9                	mov    %ebp,%ecx
  802541:	d3 e7                	shl    %cl,%edi
  802543:	89 f1                	mov    %esi,%ecx
  802545:	d3 e8                	shr    %cl,%eax
  802547:	89 e9                	mov    %ebp,%ecx
  802549:	09 f8                	or     %edi,%eax
  80254b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80254f:	f7 74 24 04          	divl   0x4(%esp)
  802553:	d3 e7                	shl    %cl,%edi
  802555:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802559:	89 d7                	mov    %edx,%edi
  80255b:	f7 64 24 08          	mull   0x8(%esp)
  80255f:	39 d7                	cmp    %edx,%edi
  802561:	89 c1                	mov    %eax,%ecx
  802563:	89 14 24             	mov    %edx,(%esp)
  802566:	72 2c                	jb     802594 <__umoddi3+0x134>
  802568:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80256c:	72 22                	jb     802590 <__umoddi3+0x130>
  80256e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802572:	29 c8                	sub    %ecx,%eax
  802574:	19 d7                	sbb    %edx,%edi
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	89 fa                	mov    %edi,%edx
  80257a:	d3 e8                	shr    %cl,%eax
  80257c:	89 f1                	mov    %esi,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	89 e9                	mov    %ebp,%ecx
  802582:	d3 ef                	shr    %cl,%edi
  802584:	09 d0                	or     %edx,%eax
  802586:	89 fa                	mov    %edi,%edx
  802588:	83 c4 14             	add    $0x14,%esp
  80258b:	5e                   	pop    %esi
  80258c:	5f                   	pop    %edi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    
  80258f:	90                   	nop
  802590:	39 d7                	cmp    %edx,%edi
  802592:	75 da                	jne    80256e <__umoddi3+0x10e>
  802594:	8b 14 24             	mov    (%esp),%edx
  802597:	89 c1                	mov    %eax,%ecx
  802599:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80259d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025a1:	eb cb                	jmp    80256e <__umoddi3+0x10e>
  8025a3:	90                   	nop
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025ac:	0f 82 0f ff ff ff    	jb     8024c1 <__umoddi3+0x61>
  8025b2:	e9 1a ff ff ff       	jmp    8024d1 <__umoddi3+0x71>
