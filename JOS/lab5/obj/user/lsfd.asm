
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 01 01 00 00       	call   800132 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	c7 04 24 60 24 80 00 	movl   $0x802460,(%esp)
  800040:	e8 21 02 00 00       	call   800266 <cprintf>
	exit();
  800045:	e8 60 01 00 00       	call   8001aa <exit>
}
  80004a:	c9                   	leave  
  80004b:	c3                   	ret    

0080004c <umain>:

void
umain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800058:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800062:	8b 45 0c             	mov    0xc(%ebp),%eax
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	8d 45 08             	lea    0x8(%ebp),%eax
  80006c:	89 04 24             	mov    %eax,(%esp)
  80006f:	e8 5d 0f 00 00       	call   800fd1 <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800074:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800079:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007f:	eb 11                	jmp    800092 <umain+0x46>
		if (i == '1')
  800081:	83 f8 31             	cmp    $0x31,%eax
  800084:	75 07                	jne    80008d <umain+0x41>
			usefprint = 1;
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	eb 05                	jmp    800092 <umain+0x46>
		else
			usage();
  80008d:	e8 a1 ff ff ff       	call   800033 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800092:	89 1c 24             	mov    %ebx,(%esp)
  800095:	e8 6f 0f 00 00       	call   801009 <argnext>
  80009a:	85 c0                	test   %eax,%eax
  80009c:	79 e3                	jns    800081 <umain+0x35>
  80009e:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 ed 15 00 00       	call   8016a2 <fstat>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 66                	js     80011f <umain+0xd3>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 36                	je     8000f3 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	8b 40 04             	mov    0x4(%eax),%eax
  8000c3:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000dd:	c7 44 24 04 74 24 80 	movl   $0x802474,0x4(%esp)
  8000e4:	00 
  8000e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ec:	e8 6d 19 00 00       	call   801a5e <fprintf>
  8000f1:	eb 2c                	jmp    80011f <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	8b 40 04             	mov    0x4(%eax),%eax
  8000f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800100:	89 44 24 10          	mov    %eax,0x10(%esp)
  800104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80010b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80010f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800113:	c7 04 24 74 24 80 00 	movl   $0x802474,(%esp)
  80011a:	e8 47 01 00 00       	call   800266 <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80011f:	83 c3 01             	add    $0x1,%ebx
  800122:	83 fb 20             	cmp    $0x20,%ebx
  800125:	75 82                	jne    8000a9 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800127:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 10             	sub    $0x10,%esp
  80013a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800140:	e8 e6 0b 00 00       	call   800d2b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800145:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80014b:	39 c2                	cmp    %eax,%edx
  80014d:	74 17                	je     800166 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80014f:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800154:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800157:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80015d:	8b 49 40             	mov    0x40(%ecx),%ecx
  800160:	39 c1                	cmp    %eax,%ecx
  800162:	75 18                	jne    80017c <libmain+0x4a>
  800164:	eb 05                	jmp    80016b <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800166:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80016b:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80016e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800174:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80017a:	eb 0b                	jmp    800187 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80017c:	83 c2 01             	add    $0x1,%edx
  80017f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800185:	75 cd                	jne    800154 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	85 db                	test   %ebx,%ebx
  800189:	7e 07                	jle    800192 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 06                	mov    (%esi),%eax
  80018d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800192:	89 74 24 04          	mov    %esi,0x4(%esp)
  800196:	89 1c 24             	mov    %ebx,(%esp)
  800199:	e8 ae fe ff ff       	call   80004c <umain>

	// exit gracefully
	exit();
  80019e:	e8 07 00 00 00       	call   8001aa <exit>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	5b                   	pop    %ebx
  8001a7:	5e                   	pop    %esi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    

008001aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b0:	e8 91 11 00 00       	call   801346 <close_all>
	sys_env_destroy(0);
  8001b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001bc:	e8 18 0b 00 00       	call   800cd9 <sys_env_destroy>
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 14             	sub    $0x14,%esp
  8001ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001cd:	8b 13                	mov    (%ebx),%edx
  8001cf:	8d 42 01             	lea    0x1(%edx),%eax
  8001d2:	89 03                	mov    %eax,(%ebx)
  8001d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001db:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e0:	75 19                	jne    8001fb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001e2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001e9:	00 
  8001ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ed:	89 04 24             	mov    %eax,(%esp)
  8001f0:	e8 a7 0a 00 00       	call   800c9c <sys_cputs>
		b->idx = 0;
  8001f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001fb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ff:	83 c4 14             	add    $0x14,%esp
  800202:	5b                   	pop    %ebx
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    

00800205 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80020e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800215:	00 00 00 
	b.cnt = 0;
  800218:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80021f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800222:	8b 45 0c             	mov    0xc(%ebp),%eax
  800225:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800229:	8b 45 08             	mov    0x8(%ebp),%eax
  80022c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800230:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 c3 01 80 00 	movl   $0x8001c3,(%esp)
  800241:	e8 ae 01 00 00       	call   8003f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800246:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800256:	89 04 24             	mov    %eax,(%esp)
  800259:	e8 3e 0a 00 00       	call   800c9c <sys_cputs>

	return b.cnt;
}
  80025e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	89 04 24             	mov    %eax,(%esp)
  800279:	e8 87 ff ff ff       	call   800205 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	8b 75 0c             	mov    0xc(%ebp),%esi
  800297:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80029a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002a8:	39 f1                	cmp    %esi,%ecx
  8002aa:	72 14                	jb     8002c0 <printnum+0x40>
  8002ac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002af:	76 0f                	jbe    8002c0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8002b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002ba:	85 f6                	test   %esi,%esi
  8002bc:	7f 60                	jg     80031e <printnum+0x9e>
  8002be:	eb 72                	jmp    800332 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8002ca:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8002cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002d9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002dd:	89 c3                	mov    %eax,%ebx
  8002df:	89 d6                	mov    %edx,%esi
  8002e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fc:	e8 bf 1e 00 00       	call   8021c0 <__udivdi3>
  800301:	89 d9                	mov    %ebx,%ecx
  800303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800307:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800312:	89 fa                	mov    %edi,%edx
  800314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800317:	e8 64 ff ff ff       	call   800280 <printnum>
  80031c:	eb 14                	jmp    800332 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80031e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800322:	8b 45 18             	mov    0x18(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032a:	83 ee 01             	sub    $0x1,%esi
  80032d:	75 ef                	jne    80031e <printnum+0x9e>
  80032f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800332:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800336:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80033a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800340:	89 44 24 08          	mov    %eax,0x8(%esp)
  800344:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034b:	89 04 24             	mov    %eax,(%esp)
  80034e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800351:	89 44 24 04          	mov    %eax,0x4(%esp)
  800355:	e8 96 1f 00 00       	call   8022f0 <__umoddi3>
  80035a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80035e:	0f be 80 a6 24 80 00 	movsbl 0x8024a6(%eax),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036b:	ff d0                	call   *%eax
}
  80036d:	83 c4 3c             	add    $0x3c,%esp
  800370:	5b                   	pop    %ebx
  800371:	5e                   	pop    %esi
  800372:	5f                   	pop    %edi
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800378:	83 fa 01             	cmp    $0x1,%edx
  80037b:	7e 0e                	jle    80038b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80037d:	8b 10                	mov    (%eax),%edx
  80037f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800382:	89 08                	mov    %ecx,(%eax)
  800384:	8b 02                	mov    (%edx),%eax
  800386:	8b 52 04             	mov    0x4(%edx),%edx
  800389:	eb 22                	jmp    8003ad <getuint+0x38>
	else if (lflag)
  80038b:	85 d2                	test   %edx,%edx
  80038d:	74 10                	je     80039f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80038f:	8b 10                	mov    (%eax),%edx
  800391:	8d 4a 04             	lea    0x4(%edx),%ecx
  800394:	89 08                	mov    %ecx,(%eax)
  800396:	8b 02                	mov    (%edx),%eax
  800398:	ba 00 00 00 00       	mov    $0x0,%edx
  80039d:	eb 0e                	jmp    8003ad <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80039f:	8b 10                	mov    (%eax),%edx
  8003a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a4:	89 08                	mov    %ecx,(%eax)
  8003a6:	8b 02                	mov    (%edx),%eax
  8003a8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b9:	8b 10                	mov    (%eax),%edx
  8003bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003be:	73 0a                	jae    8003ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8003c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003c3:	89 08                	mov    %ecx,(%eax)
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	88 02                	mov    %al,(%edx)
}
  8003ca:	5d                   	pop    %ebp
  8003cb:	c3                   	ret    

008003cc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	89 04 24             	mov    %eax,(%esp)
  8003ed:	e8 02 00 00 00       	call   8003f4 <vprintfmt>
	va_end(ap);
}
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 3c             	sub    $0x3c,%esp
  8003fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800400:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800403:	eb 18                	jmp    80041d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800405:	85 c0                	test   %eax,%eax
  800407:	0f 84 c3 03 00 00    	je     8007d0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80040d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800417:	89 f3                	mov    %esi,%ebx
  800419:	eb 02                	jmp    80041d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80041b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80041d:	8d 73 01             	lea    0x1(%ebx),%esi
  800420:	0f b6 03             	movzbl (%ebx),%eax
  800423:	83 f8 25             	cmp    $0x25,%eax
  800426:	75 dd                	jne    800405 <vprintfmt+0x11>
  800428:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80042c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800433:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80043a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	eb 1d                	jmp    800465 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800448:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80044a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80044e:	eb 15                	jmp    800465 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800450:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800452:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800456:	eb 0d                	jmp    800465 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800465:	8d 5e 01             	lea    0x1(%esi),%ebx
  800468:	0f b6 06             	movzbl (%esi),%eax
  80046b:	0f b6 c8             	movzbl %al,%ecx
  80046e:	83 e8 23             	sub    $0x23,%eax
  800471:	3c 55                	cmp    $0x55,%al
  800473:	0f 87 2f 03 00 00    	ja     8007a8 <vprintfmt+0x3b4>
  800479:	0f b6 c0             	movzbl %al,%eax
  80047c:	ff 24 85 e0 25 80 00 	jmp    *0x8025e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800483:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800486:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800489:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80048d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800490:	83 f9 09             	cmp    $0x9,%ecx
  800493:	77 50                	ja     8004e5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800495:	89 de                	mov    %ebx,%esi
  800497:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80049a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80049d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004a0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004a4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004a7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004aa:	83 fb 09             	cmp    $0x9,%ebx
  8004ad:	76 eb                	jbe    80049a <vprintfmt+0xa6>
  8004af:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004b2:	eb 33                	jmp    8004e7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ba:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004c4:	eb 21                	jmp    8004e7 <vprintfmt+0xf3>
  8004c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004c9:	85 c9                	test   %ecx,%ecx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c1             	cmovns %ecx,%eax
  8004d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	89 de                	mov    %ebx,%esi
  8004d8:	eb 8b                	jmp    800465 <vprintfmt+0x71>
  8004da:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004dc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e3:	eb 80                	jmp    800465 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004eb:	0f 89 74 ff ff ff    	jns    800465 <vprintfmt+0x71>
  8004f1:	e9 62 ff ff ff       	jmp    800458 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004f6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004fb:	e9 65 ff ff ff       	jmp    800465 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	8d 50 04             	lea    0x4(%eax),%edx
  800506:	89 55 14             	mov    %edx,0x14(%ebp)
  800509:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	ff 55 08             	call   *0x8(%ebp)
			break;
  800515:	e9 03 ff ff ff       	jmp    80041d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 50 04             	lea    0x4(%eax),%edx
  800520:	89 55 14             	mov    %edx,0x14(%ebp)
  800523:	8b 00                	mov    (%eax),%eax
  800525:	99                   	cltd   
  800526:	31 d0                	xor    %edx,%eax
  800528:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052a:	83 f8 0f             	cmp    $0xf,%eax
  80052d:	7f 0b                	jg     80053a <vprintfmt+0x146>
  80052f:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  800536:	85 d2                	test   %edx,%edx
  800538:	75 20                	jne    80055a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80053a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80053e:	c7 44 24 08 be 24 80 	movl   $0x8024be,0x8(%esp)
  800545:	00 
  800546:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	89 04 24             	mov    %eax,(%esp)
  800550:	e8 77 fe ff ff       	call   8003cc <printfmt>
  800555:	e9 c3 fe ff ff       	jmp    80041d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80055a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80055e:	c7 44 24 08 5f 28 80 	movl   $0x80285f,0x8(%esp)
  800565:	00 
  800566:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	e8 57 fe ff ff       	call   8003cc <printfmt>
  800575:	e9 a3 fe ff ff       	jmp    80041d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80057d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 50 04             	lea    0x4(%eax),%edx
  800586:	89 55 14             	mov    %edx,0x14(%ebp)
  800589:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80058b:	85 c0                	test   %eax,%eax
  80058d:	ba b7 24 80 00       	mov    $0x8024b7,%edx
  800592:	0f 45 d0             	cmovne %eax,%edx
  800595:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800598:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80059c:	74 04                	je     8005a2 <vprintfmt+0x1ae>
  80059e:	85 f6                	test   %esi,%esi
  8005a0:	7f 19                	jg     8005bb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a5:	8d 70 01             	lea    0x1(%eax),%esi
  8005a8:	0f b6 10             	movzbl (%eax),%edx
  8005ab:	0f be c2             	movsbl %dl,%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	0f 85 95 00 00 00    	jne    80064b <vprintfmt+0x257>
  8005b6:	e9 85 00 00 00       	jmp    800640 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c2:	89 04 24             	mov    %eax,(%esp)
  8005c5:	e8 b8 02 00 00       	call   800882 <strnlen>
  8005ca:	29 c6                	sub    %eax,%esi
  8005cc:	89 f0                	mov    %esi,%eax
  8005ce:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005d1:	85 f6                	test   %esi,%esi
  8005d3:	7e cd                	jle    8005a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8005d5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8005d9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005dc:	89 c3                	mov    %eax,%ebx
  8005de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e2:	89 34 24             	mov    %esi,(%esp)
  8005e5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e8:	83 eb 01             	sub    $0x1,%ebx
  8005eb:	75 f1                	jne    8005de <vprintfmt+0x1ea>
  8005ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f3:	eb ad                	jmp    8005a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f9:	74 1e                	je     800619 <vprintfmt+0x225>
  8005fb:	0f be d2             	movsbl %dl,%edx
  8005fe:	83 ea 20             	sub    $0x20,%edx
  800601:	83 fa 5e             	cmp    $0x5e,%edx
  800604:	76 13                	jbe    800619 <vprintfmt+0x225>
					putch('?', putdat);
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800614:	ff 55 08             	call   *0x8(%ebp)
  800617:	eb 0d                	jmp    800626 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80061c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800620:	89 04 24             	mov    %eax,(%esp)
  800623:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800626:	83 ef 01             	sub    $0x1,%edi
  800629:	83 c6 01             	add    $0x1,%esi
  80062c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800630:	0f be c2             	movsbl %dl,%eax
  800633:	85 c0                	test   %eax,%eax
  800635:	75 20                	jne    800657 <vprintfmt+0x263>
  800637:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80063a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80063d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	7f 25                	jg     80066b <vprintfmt+0x277>
  800646:	e9 d2 fd ff ff       	jmp    80041d <vprintfmt+0x29>
  80064b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800651:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800654:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800657:	85 db                	test   %ebx,%ebx
  800659:	78 9a                	js     8005f5 <vprintfmt+0x201>
  80065b:	83 eb 01             	sub    $0x1,%ebx
  80065e:	79 95                	jns    8005f5 <vprintfmt+0x201>
  800660:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800663:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800666:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800669:	eb d5                	jmp    800640 <vprintfmt+0x24c>
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800674:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800678:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80067f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800681:	83 eb 01             	sub    $0x1,%ebx
  800684:	75 ee                	jne    800674 <vprintfmt+0x280>
  800686:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800689:	e9 8f fd ff ff       	jmp    80041d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80068e:	83 fa 01             	cmp    $0x1,%edx
  800691:	7e 16                	jle    8006a9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 50 08             	lea    0x8(%eax),%edx
  800699:	89 55 14             	mov    %edx,0x14(%ebp)
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a7:	eb 32                	jmp    8006db <vprintfmt+0x2e7>
	else if (lflag)
  8006a9:	85 d2                	test   %edx,%edx
  8006ab:	74 18                	je     8006c5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 50 04             	lea    0x4(%eax),%edx
  8006b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b6:	8b 30                	mov    (%eax),%esi
  8006b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006bb:	89 f0                	mov    %esi,%eax
  8006bd:	c1 f8 1f             	sar    $0x1f,%eax
  8006c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c3:	eb 16                	jmp    8006db <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ce:	8b 30                	mov    (%eax),%esi
  8006d0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006d3:	89 f0                	mov    %esi,%eax
  8006d5:	c1 f8 1f             	sar    $0x1f,%eax
  8006d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006de:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ea:	0f 89 80 00 00 00    	jns    800770 <vprintfmt+0x37c>
				putch('-', putdat);
  8006f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800701:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800704:	f7 d8                	neg    %eax
  800706:	83 d2 00             	adc    $0x0,%edx
  800709:	f7 da                	neg    %edx
			}
			base = 10;
  80070b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800710:	eb 5e                	jmp    800770 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800712:	8d 45 14             	lea    0x14(%ebp),%eax
  800715:	e8 5b fc ff ff       	call   800375 <getuint>
			base = 10;
  80071a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80071f:	eb 4f                	jmp    800770 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800721:	8d 45 14             	lea    0x14(%ebp),%eax
  800724:	e8 4c fc ff ff       	call   800375 <getuint>
			base = 8;
  800729:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80072e:	eb 40                	jmp    800770 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800730:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800734:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80073b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80073e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800742:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800749:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 50 04             	lea    0x4(%eax),%edx
  800752:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800755:	8b 00                	mov    (%eax),%eax
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80075c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800761:	eb 0d                	jmp    800770 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	e8 0a fc ff ff       	call   800375 <getuint>
			base = 16;
  80076b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800770:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800774:	89 74 24 10          	mov    %esi,0x10(%esp)
  800778:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80077b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80077f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800783:	89 04 24             	mov    %eax,(%esp)
  800786:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078a:	89 fa                	mov    %edi,%edx
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	e8 ec fa ff ff       	call   800280 <printnum>
			break;
  800794:	e9 84 fc ff ff       	jmp    80041d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800799:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079d:	89 0c 24             	mov    %ecx,(%esp)
  8007a0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007a3:	e9 75 fc ff ff       	jmp    80041d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8007ba:	0f 84 5b fc ff ff    	je     80041b <vprintfmt+0x27>
  8007c0:	89 f3                	mov    %esi,%ebx
  8007c2:	83 eb 01             	sub    $0x1,%ebx
  8007c5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007c9:	75 f7                	jne    8007c2 <vprintfmt+0x3ce>
  8007cb:	e9 4d fc ff ff       	jmp    80041d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8007d0:	83 c4 3c             	add    $0x3c,%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5e                   	pop    %esi
  8007d5:	5f                   	pop    %edi
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 28             	sub    $0x28,%esp
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007eb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	74 30                	je     800829 <vsnprintf+0x51>
  8007f9:	85 d2                	test   %edx,%edx
  8007fb:	7e 2c                	jle    800829 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800804:	8b 45 10             	mov    0x10(%ebp),%eax
  800807:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800812:	c7 04 24 af 03 80 00 	movl   $0x8003af,(%esp)
  800819:	e8 d6 fb ff ff       	call   8003f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800821:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800827:	eb 05                	jmp    80082e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800836:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800839:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083d:	8b 45 10             	mov    0x10(%ebp),%eax
  800840:	89 44 24 08          	mov    %eax,0x8(%esp)
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 04 24             	mov    %eax,(%esp)
  800851:	e8 82 ff ff ff       	call   8007d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800856:	c9                   	leave  
  800857:	c3                   	ret    
  800858:	66 90                	xchg   %ax,%ax
  80085a:	66 90                	xchg   %ax,%ax
  80085c:	66 90                	xchg   %ax,%ax
  80085e:	66 90                	xchg   %ax,%ax

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	80 3a 00             	cmpb   $0x0,(%edx)
  800869:	74 10                	je     80087b <strlen+0x1b>
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800873:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800877:	75 f7                	jne    800870 <strlen+0x10>
  800879:	eb 05                	jmp    800880 <strlen+0x20>
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	53                   	push   %ebx
  800886:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088c:	85 c9                	test   %ecx,%ecx
  80088e:	74 1c                	je     8008ac <strnlen+0x2a>
  800890:	80 3b 00             	cmpb   $0x0,(%ebx)
  800893:	74 1e                	je     8008b3 <strnlen+0x31>
  800895:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80089a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089c:	39 ca                	cmp    %ecx,%edx
  80089e:	74 18                	je     8008b8 <strnlen+0x36>
  8008a0:	83 c2 01             	add    $0x1,%edx
  8008a3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8008a8:	75 f0                	jne    80089a <strnlen+0x18>
  8008aa:	eb 0c                	jmp    8008b8 <strnlen+0x36>
  8008ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b1:	eb 05                	jmp    8008b8 <strnlen+0x36>
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008b8:	5b                   	pop    %ebx
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	83 c2 01             	add    $0x1,%edx
  8008ca:	83 c1 01             	add    $0x1,%ecx
  8008cd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d4:	84 db                	test   %bl,%bl
  8008d6:	75 ef                	jne    8008c7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e5:	89 1c 24             	mov    %ebx,(%esp)
  8008e8:	e8 73 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008f4:	01 d8                	add    %ebx,%eax
  8008f6:	89 04 24             	mov    %eax,(%esp)
  8008f9:	e8 bd ff ff ff       	call   8008bb <strcpy>
	return dst;
}
  8008fe:	89 d8                	mov    %ebx,%eax
  800900:	83 c4 08             	add    $0x8,%esp
  800903:	5b                   	pop    %ebx
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 75 08             	mov    0x8(%ebp),%esi
  80090e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800911:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800914:	85 db                	test   %ebx,%ebx
  800916:	74 17                	je     80092f <strncpy+0x29>
  800918:	01 f3                	add    %esi,%ebx
  80091a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80091c:	83 c1 01             	add    $0x1,%ecx
  80091f:	0f b6 02             	movzbl (%edx),%eax
  800922:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800925:	80 3a 01             	cmpb   $0x1,(%edx)
  800928:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092b:	39 d9                	cmp    %ebx,%ecx
  80092d:	75 ed                	jne    80091c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80092f:	89 f0                	mov    %esi,%eax
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	57                   	push   %edi
  800939:	56                   	push   %esi
  80093a:	53                   	push   %ebx
  80093b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800941:	8b 75 10             	mov    0x10(%ebp),%esi
  800944:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800946:	85 f6                	test   %esi,%esi
  800948:	74 34                	je     80097e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80094a:	83 fe 01             	cmp    $0x1,%esi
  80094d:	74 26                	je     800975 <strlcpy+0x40>
  80094f:	0f b6 0b             	movzbl (%ebx),%ecx
  800952:	84 c9                	test   %cl,%cl
  800954:	74 23                	je     800979 <strlcpy+0x44>
  800956:	83 ee 02             	sub    $0x2,%esi
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800964:	39 f2                	cmp    %esi,%edx
  800966:	74 13                	je     80097b <strlcpy+0x46>
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80096f:	84 c9                	test   %cl,%cl
  800971:	75 eb                	jne    80095e <strlcpy+0x29>
  800973:	eb 06                	jmp    80097b <strlcpy+0x46>
  800975:	89 f8                	mov    %edi,%eax
  800977:	eb 02                	jmp    80097b <strlcpy+0x46>
  800979:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80097b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097e:	29 f8                	sub    %edi,%eax
}
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5f                   	pop    %edi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098e:	0f b6 01             	movzbl (%ecx),%eax
  800991:	84 c0                	test   %al,%al
  800993:	74 15                	je     8009aa <strcmp+0x25>
  800995:	3a 02                	cmp    (%edx),%al
  800997:	75 11                	jne    8009aa <strcmp+0x25>
		p++, q++;
  800999:	83 c1 01             	add    $0x1,%ecx
  80099c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80099f:	0f b6 01             	movzbl (%ecx),%eax
  8009a2:	84 c0                	test   %al,%al
  8009a4:	74 04                	je     8009aa <strcmp+0x25>
  8009a6:	3a 02                	cmp    (%edx),%al
  8009a8:	74 ef                	je     800999 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009aa:	0f b6 c0             	movzbl %al,%eax
  8009ad:	0f b6 12             	movzbl (%edx),%edx
  8009b0:	29 d0                	sub    %edx,%eax
}
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	56                   	push   %esi
  8009b8:	53                   	push   %ebx
  8009b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8009c2:	85 f6                	test   %esi,%esi
  8009c4:	74 29                	je     8009ef <strncmp+0x3b>
  8009c6:	0f b6 03             	movzbl (%ebx),%eax
  8009c9:	84 c0                	test   %al,%al
  8009cb:	74 30                	je     8009fd <strncmp+0x49>
  8009cd:	3a 02                	cmp    (%edx),%al
  8009cf:	75 2c                	jne    8009fd <strncmp+0x49>
  8009d1:	8d 43 01             	lea    0x1(%ebx),%eax
  8009d4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8009d6:	89 c3                	mov    %eax,%ebx
  8009d8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009db:	39 f0                	cmp    %esi,%eax
  8009dd:	74 17                	je     8009f6 <strncmp+0x42>
  8009df:	0f b6 08             	movzbl (%eax),%ecx
  8009e2:	84 c9                	test   %cl,%cl
  8009e4:	74 17                	je     8009fd <strncmp+0x49>
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	3a 0a                	cmp    (%edx),%cl
  8009eb:	74 e9                	je     8009d6 <strncmp+0x22>
  8009ed:	eb 0e                	jmp    8009fd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f4:	eb 0f                	jmp    800a05 <strncmp+0x51>
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb 08                	jmp    800a05 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fd:	0f b6 03             	movzbl (%ebx),%eax
  800a00:	0f b6 12             	movzbl (%edx),%edx
  800a03:	29 d0                	sub    %edx,%eax
}
  800a05:	5b                   	pop    %ebx
  800a06:	5e                   	pop    %esi
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a13:	0f b6 18             	movzbl (%eax),%ebx
  800a16:	84 db                	test   %bl,%bl
  800a18:	74 1d                	je     800a37 <strchr+0x2e>
  800a1a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a1c:	38 d3                	cmp    %dl,%bl
  800a1e:	75 06                	jne    800a26 <strchr+0x1d>
  800a20:	eb 1a                	jmp    800a3c <strchr+0x33>
  800a22:	38 ca                	cmp    %cl,%dl
  800a24:	74 16                	je     800a3c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a26:	83 c0 01             	add    $0x1,%eax
  800a29:	0f b6 10             	movzbl (%eax),%edx
  800a2c:	84 d2                	test   %dl,%dl
  800a2e:	75 f2                	jne    800a22 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	eb 05                	jmp    800a3c <strchr+0x33>
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3c:	5b                   	pop    %ebx
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	53                   	push   %ebx
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800a49:	0f b6 18             	movzbl (%eax),%ebx
  800a4c:	84 db                	test   %bl,%bl
  800a4e:	74 16                	je     800a66 <strfind+0x27>
  800a50:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800a52:	38 d3                	cmp    %dl,%bl
  800a54:	75 06                	jne    800a5c <strfind+0x1d>
  800a56:	eb 0e                	jmp    800a66 <strfind+0x27>
  800a58:	38 ca                	cmp    %cl,%dl
  800a5a:	74 0a                	je     800a66 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a5c:	83 c0 01             	add    $0x1,%eax
  800a5f:	0f b6 10             	movzbl (%eax),%edx
  800a62:	84 d2                	test   %dl,%dl
  800a64:	75 f2                	jne    800a58 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	57                   	push   %edi
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a72:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a75:	85 c9                	test   %ecx,%ecx
  800a77:	74 36                	je     800aaf <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a79:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7f:	75 28                	jne    800aa9 <memset+0x40>
  800a81:	f6 c1 03             	test   $0x3,%cl
  800a84:	75 23                	jne    800aa9 <memset+0x40>
		c &= 0xFF;
  800a86:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8a:	89 d3                	mov    %edx,%ebx
  800a8c:	c1 e3 08             	shl    $0x8,%ebx
  800a8f:	89 d6                	mov    %edx,%esi
  800a91:	c1 e6 18             	shl    $0x18,%esi
  800a94:	89 d0                	mov    %edx,%eax
  800a96:	c1 e0 10             	shl    $0x10,%eax
  800a99:	09 f0                	or     %esi,%eax
  800a9b:	09 c2                	or     %eax,%edx
  800a9d:	89 d0                	mov    %edx,%eax
  800a9f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aa1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800aa4:	fc                   	cld    
  800aa5:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa7:	eb 06                	jmp    800aaf <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	fc                   	cld    
  800aad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aaf:	89 f8                	mov    %edi,%eax
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5f                   	pop    %edi
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac4:	39 c6                	cmp    %eax,%esi
  800ac6:	73 35                	jae    800afd <memmove+0x47>
  800ac8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800acb:	39 d0                	cmp    %edx,%eax
  800acd:	73 2e                	jae    800afd <memmove+0x47>
		s += n;
		d += n;
  800acf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ad2:	89 d6                	mov    %edx,%esi
  800ad4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800adc:	75 13                	jne    800af1 <memmove+0x3b>
  800ade:	f6 c1 03             	test   $0x3,%cl
  800ae1:	75 0e                	jne    800af1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae3:	83 ef 04             	sub    $0x4,%edi
  800ae6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aec:	fd                   	std    
  800aed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aef:	eb 09                	jmp    800afa <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af1:	83 ef 01             	sub    $0x1,%edi
  800af4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800af7:	fd                   	std    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afa:	fc                   	cld    
  800afb:	eb 1d                	jmp    800b1a <memmove+0x64>
  800afd:	89 f2                	mov    %esi,%edx
  800aff:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b01:	f6 c2 03             	test   $0x3,%dl
  800b04:	75 0f                	jne    800b15 <memmove+0x5f>
  800b06:	f6 c1 03             	test   $0x3,%cl
  800b09:	75 0a                	jne    800b15 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b0e:	89 c7                	mov    %eax,%edi
  800b10:	fc                   	cld    
  800b11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b13:	eb 05                	jmp    800b1a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b15:	89 c7                	mov    %eax,%edi
  800b17:	fc                   	cld    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b1a:	5e                   	pop    %esi
  800b1b:	5f                   	pop    %edi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b24:	8b 45 10             	mov    0x10(%ebp),%eax
  800b27:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 04 24             	mov    %eax,(%esp)
  800b38:	e8 79 ff ff ff       	call   800ab6 <memmove>
}
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	57                   	push   %edi
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b48:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800b51:	85 c0                	test   %eax,%eax
  800b53:	74 36                	je     800b8b <memcmp+0x4c>
		if (*s1 != *s2)
  800b55:	0f b6 03             	movzbl (%ebx),%eax
  800b58:	0f b6 0e             	movzbl (%esi),%ecx
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b60:	38 c8                	cmp    %cl,%al
  800b62:	74 1c                	je     800b80 <memcmp+0x41>
  800b64:	eb 10                	jmp    800b76 <memcmp+0x37>
  800b66:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b6b:	83 c2 01             	add    $0x1,%edx
  800b6e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800b72:	38 c8                	cmp    %cl,%al
  800b74:	74 0a                	je     800b80 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800b76:	0f b6 c0             	movzbl %al,%eax
  800b79:	0f b6 c9             	movzbl %cl,%ecx
  800b7c:	29 c8                	sub    %ecx,%eax
  800b7e:	eb 10                	jmp    800b90 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b80:	39 fa                	cmp    %edi,%edx
  800b82:	75 e2                	jne    800b66 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
  800b89:	eb 05                	jmp    800b90 <memcmp+0x51>
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba4:	39 d0                	cmp    %edx,%eax
  800ba6:	73 13                	jae    800bbb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba8:	89 d9                	mov    %ebx,%ecx
  800baa:	38 18                	cmp    %bl,(%eax)
  800bac:	75 06                	jne    800bb4 <memfind+0x1f>
  800bae:	eb 0b                	jmp    800bbb <memfind+0x26>
  800bb0:	38 08                	cmp    %cl,(%eax)
  800bb2:	74 07                	je     800bbb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	39 d0                	cmp    %edx,%eax
  800bb9:	75 f5                	jne    800bb0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bbb:	5b                   	pop    %ebx
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bca:	0f b6 0a             	movzbl (%edx),%ecx
  800bcd:	80 f9 09             	cmp    $0x9,%cl
  800bd0:	74 05                	je     800bd7 <strtol+0x19>
  800bd2:	80 f9 20             	cmp    $0x20,%cl
  800bd5:	75 10                	jne    800be7 <strtol+0x29>
		s++;
  800bd7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bda:	0f b6 0a             	movzbl (%edx),%ecx
  800bdd:	80 f9 09             	cmp    $0x9,%cl
  800be0:	74 f5                	je     800bd7 <strtol+0x19>
  800be2:	80 f9 20             	cmp    $0x20,%cl
  800be5:	74 f0                	je     800bd7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be7:	80 f9 2b             	cmp    $0x2b,%cl
  800bea:	75 0a                	jne    800bf6 <strtol+0x38>
		s++;
  800bec:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bef:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf4:	eb 11                	jmp    800c07 <strtol+0x49>
  800bf6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bfb:	80 f9 2d             	cmp    $0x2d,%cl
  800bfe:	75 07                	jne    800c07 <strtol+0x49>
		s++, neg = 1;
  800c00:	83 c2 01             	add    $0x1,%edx
  800c03:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c07:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c0c:	75 15                	jne    800c23 <strtol+0x65>
  800c0e:	80 3a 30             	cmpb   $0x30,(%edx)
  800c11:	75 10                	jne    800c23 <strtol+0x65>
  800c13:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c17:	75 0a                	jne    800c23 <strtol+0x65>
		s += 2, base = 16;
  800c19:	83 c2 02             	add    $0x2,%edx
  800c1c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c21:	eb 10                	jmp    800c33 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800c23:	85 c0                	test   %eax,%eax
  800c25:	75 0c                	jne    800c33 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c27:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c29:	80 3a 30             	cmpb   $0x30,(%edx)
  800c2c:	75 05                	jne    800c33 <strtol+0x75>
		s++, base = 8;
  800c2e:	83 c2 01             	add    $0x1,%edx
  800c31:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c38:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c3b:	0f b6 0a             	movzbl (%edx),%ecx
  800c3e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c41:	89 f0                	mov    %esi,%eax
  800c43:	3c 09                	cmp    $0x9,%al
  800c45:	77 08                	ja     800c4f <strtol+0x91>
			dig = *s - '0';
  800c47:	0f be c9             	movsbl %cl,%ecx
  800c4a:	83 e9 30             	sub    $0x30,%ecx
  800c4d:	eb 20                	jmp    800c6f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800c4f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c52:	89 f0                	mov    %esi,%eax
  800c54:	3c 19                	cmp    $0x19,%al
  800c56:	77 08                	ja     800c60 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800c58:	0f be c9             	movsbl %cl,%ecx
  800c5b:	83 e9 57             	sub    $0x57,%ecx
  800c5e:	eb 0f                	jmp    800c6f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800c60:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c63:	89 f0                	mov    %esi,%eax
  800c65:	3c 19                	cmp    $0x19,%al
  800c67:	77 16                	ja     800c7f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c69:	0f be c9             	movsbl %cl,%ecx
  800c6c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c6f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c72:	7d 0f                	jge    800c83 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c74:	83 c2 01             	add    $0x1,%edx
  800c77:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c7b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c7d:	eb bc                	jmp    800c3b <strtol+0x7d>
  800c7f:	89 d8                	mov    %ebx,%eax
  800c81:	eb 02                	jmp    800c85 <strtol+0xc7>
  800c83:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c89:	74 05                	je     800c90 <strtol+0xd2>
		*endptr = (char *) s;
  800c8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c90:	f7 d8                	neg    %eax
  800c92:	85 ff                	test   %edi,%edi
  800c94:	0f 44 c3             	cmove  %ebx,%eax
}
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	89 c3                	mov    %eax,%ebx
  800caf:	89 c7                	mov    %eax,%edi
  800cb1:	89 c6                	mov    %eax,%esi
  800cb3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_cgetc>:

int
sys_cgetc(void)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cca:	89 d1                	mov    %edx,%ecx
  800ccc:	89 d3                	mov    %edx,%ebx
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	89 d6                	mov    %edx,%esi
  800cd2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	89 cb                	mov    %ecx,%ebx
  800cf1:	89 cf                	mov    %ecx,%edi
  800cf3:	89 ce                	mov    %ecx,%esi
  800cf5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7e 28                	jle    800d23 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cff:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d06:	00 
  800d07:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800d0e:	00 
  800d0f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800d16:	00 
  800d17:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800d1e:	e8 f3 12 00 00       	call   802016 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d23:	83 c4 2c             	add    $0x2c,%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d31:	ba 00 00 00 00       	mov    $0x0,%edx
  800d36:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3b:	89 d1                	mov    %edx,%ecx
  800d3d:	89 d3                	mov    %edx,%ebx
  800d3f:	89 d7                	mov    %edx,%edi
  800d41:	89 d6                	mov    %edx,%esi
  800d43:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_yield>:

void
sys_yield(void)
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
  800d55:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d72:	be 00 00 00 00       	mov    $0x0,%esi
  800d77:	b8 04 00 00 00       	mov    $0x4,%eax
  800d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d85:	89 f7                	mov    %esi,%edi
  800d87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7e 28                	jle    800db5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d91:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d98:	00 
  800d99:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800da0:	00 
  800da1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800da8:	00 
  800da9:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800db0:	e8 61 12 00 00       	call   802016 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db5:	83 c4 2c             	add    $0x2c,%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc6:	b8 05 00 00 00       	mov    $0x5,%eax
  800dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7e 28                	jle    800e08 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800deb:	00 
  800dec:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800df3:	00 
  800df4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800dfb:	00 
  800dfc:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800e03:	e8 0e 12 00 00       	call   802016 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e08:	83 c4 2c             	add    $0x2c,%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 de                	mov    %ebx,%esi
  800e2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7e 28                	jle    800e5b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e37:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e3e:	00 
  800e3f:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800e46:	00 
  800e47:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800e4e:	00 
  800e4f:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800e56:	e8 bb 11 00 00       	call   802016 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e5b:	83 c4 2c             	add    $0x2c,%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e71:	b8 08 00 00 00       	mov    $0x8,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	89 df                	mov    %ebx,%edi
  800e7e:	89 de                	mov    %ebx,%esi
  800e80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7e 28                	jle    800eae <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e91:	00 
  800e92:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800e99:	00 
  800e9a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ea1:	00 
  800ea2:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800ea9:	e8 68 11 00 00       	call   802016 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eae:	83 c4 2c             	add    $0x2c,%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	89 df                	mov    %ebx,%edi
  800ed1:	89 de                	mov    %ebx,%esi
  800ed3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	7e 28                	jle    800f01 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ee4:	00 
  800ee5:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800eec:	00 
  800eed:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800ef4:	00 
  800ef5:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800efc:	e8 15 11 00 00       	call   802016 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f01:	83 c4 2c             	add    $0x2c,%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7e 28                	jle    800f54 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f30:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f37:	00 
  800f38:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800f3f:	00 
  800f40:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f47:	00 
  800f48:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800f4f:	e8 c2 10 00 00       	call   802016 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f54:	83 c4 2c             	add    $0x2c,%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	be 00 00 00 00       	mov    $0x0,%esi
  800f67:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f78:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7e 28                	jle    800fc9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fac:	00 
  800fad:	c7 44 24 08 9f 27 80 	movl   $0x80279f,0x8(%esp)
  800fb4:	00 
  800fb5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fbc:	00 
  800fbd:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800fc4:	e8 4d 10 00 00       	call   802016 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc9:	83 c4 2c             	add    $0x2c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	53                   	push   %ebx
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdb:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800fde:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  800fe0:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	83 39 01             	cmpl   $0x1,(%ecx)
  800feb:	7e 0f                	jle    800ffc <argstart+0x2b>
  800fed:	85 d2                	test   %edx,%edx
  800fef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff4:	bb 71 24 80 00       	mov    $0x802471,%ebx
  800ff9:	0f 44 da             	cmove  %edx,%ebx
  800ffc:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  800fff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801006:	5b                   	pop    %ebx
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <argnext>:

int
argnext(struct Argstate *args)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	53                   	push   %ebx
  80100d:	83 ec 14             	sub    $0x14,%esp
  801010:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801013:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80101a:	8b 43 08             	mov    0x8(%ebx),%eax
  80101d:	85 c0                	test   %eax,%eax
  80101f:	74 71                	je     801092 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801021:	80 38 00             	cmpb   $0x0,(%eax)
  801024:	75 50                	jne    801076 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801026:	8b 0b                	mov    (%ebx),%ecx
  801028:	83 39 01             	cmpl   $0x1,(%ecx)
  80102b:	74 57                	je     801084 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80102d:	8b 53 04             	mov    0x4(%ebx),%edx
  801030:	8b 42 04             	mov    0x4(%edx),%eax
  801033:	80 38 2d             	cmpb   $0x2d,(%eax)
  801036:	75 4c                	jne    801084 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801038:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80103c:	74 46                	je     801084 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80103e:	83 c0 01             	add    $0x1,%eax
  801041:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801044:	8b 01                	mov    (%ecx),%eax
  801046:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80104d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801051:	8d 42 08             	lea    0x8(%edx),%eax
  801054:	89 44 24 04          	mov    %eax,0x4(%esp)
  801058:	83 c2 04             	add    $0x4,%edx
  80105b:	89 14 24             	mov    %edx,(%esp)
  80105e:	e8 53 fa ff ff       	call   800ab6 <memmove>
		(*args->argc)--;
  801063:	8b 03                	mov    (%ebx),%eax
  801065:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801068:	8b 43 08             	mov    0x8(%ebx),%eax
  80106b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80106e:	75 06                	jne    801076 <argnext+0x6d>
  801070:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801074:	74 0e                	je     801084 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801076:	8b 53 08             	mov    0x8(%ebx),%edx
  801079:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80107c:	83 c2 01             	add    $0x1,%edx
  80107f:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801082:	eb 13                	jmp    801097 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801084:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80108b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801090:	eb 05                	jmp    801097 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801097:	83 c4 14             	add    $0x14,%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 14             	sub    $0x14,%esp
  8010a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010a7:	8b 43 08             	mov    0x8(%ebx),%eax
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 5a                	je     801108 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8010ae:	80 38 00             	cmpb   $0x0,(%eax)
  8010b1:	74 0c                	je     8010bf <argnextvalue+0x22>
		args->argvalue = args->curarg;
  8010b3:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8010b6:	c7 43 08 71 24 80 00 	movl   $0x802471,0x8(%ebx)
  8010bd:	eb 44                	jmp    801103 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  8010bf:	8b 03                	mov    (%ebx),%eax
  8010c1:	83 38 01             	cmpl   $0x1,(%eax)
  8010c4:	7e 2f                	jle    8010f5 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8010c6:	8b 53 04             	mov    0x4(%ebx),%edx
  8010c9:	8b 4a 04             	mov    0x4(%edx),%ecx
  8010cc:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010dc:	8d 42 08             	lea    0x8(%edx),%eax
  8010df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e3:	83 c2 04             	add    $0x4,%edx
  8010e6:	89 14 24             	mov    %edx,(%esp)
  8010e9:	e8 c8 f9 ff ff       	call   800ab6 <memmove>
		(*args->argc)--;
  8010ee:	8b 03                	mov    (%ebx),%eax
  8010f0:	83 28 01             	subl   $0x1,(%eax)
  8010f3:	eb 0e                	jmp    801103 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  8010f5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010fc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801103:	8b 43 0c             	mov    0xc(%ebx),%eax
  801106:	eb 05                	jmp    80110d <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801108:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80110d:	83 c4 14             	add    $0x14,%esp
  801110:	5b                   	pop    %ebx
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 18             	sub    $0x18,%esp
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80111c:	8b 51 0c             	mov    0xc(%ecx),%edx
  80111f:	89 d0                	mov    %edx,%eax
  801121:	85 d2                	test   %edx,%edx
  801123:	75 08                	jne    80112d <argvalue+0x1a>
  801125:	89 0c 24             	mov    %ecx,(%esp)
  801128:	e8 70 ff ff ff       	call   80109d <argnextvalue>
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    
  80112f:	90                   	nop

00801130 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	05 00 00 00 30       	add    $0x30000000,%eax
  80113b:	c1 e8 0c             	shr    $0xc,%eax
}
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80114b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801150:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80115a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80115f:	a8 01                	test   $0x1,%al
  801161:	74 34                	je     801197 <fd_alloc+0x40>
  801163:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801168:	a8 01                	test   $0x1,%al
  80116a:	74 32                	je     80119e <fd_alloc+0x47>
  80116c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801171:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801173:	89 c2                	mov    %eax,%edx
  801175:	c1 ea 16             	shr    $0x16,%edx
  801178:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	74 1f                	je     8011a3 <fd_alloc+0x4c>
  801184:	89 c2                	mov    %eax,%edx
  801186:	c1 ea 0c             	shr    $0xc,%edx
  801189:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801190:	f6 c2 01             	test   $0x1,%dl
  801193:	75 1a                	jne    8011af <fd_alloc+0x58>
  801195:	eb 0c                	jmp    8011a3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801197:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80119c:	eb 05                	jmp    8011a3 <fd_alloc+0x4c>
  80119e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8011a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ad:	eb 1a                	jmp    8011c9 <fd_alloc+0x72>
  8011af:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011b4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b9:	75 b6                	jne    801171 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011c4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    

008011cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d1:	83 f8 1f             	cmp    $0x1f,%eax
  8011d4:	77 36                	ja     80120c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d6:	c1 e0 0c             	shl    $0xc,%eax
  8011d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011de:	89 c2                	mov    %eax,%edx
  8011e0:	c1 ea 16             	shr    $0x16,%edx
  8011e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ea:	f6 c2 01             	test   $0x1,%dl
  8011ed:	74 24                	je     801213 <fd_lookup+0x48>
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	c1 ea 0c             	shr    $0xc,%edx
  8011f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fb:	f6 c2 01             	test   $0x1,%dl
  8011fe:	74 1a                	je     80121a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801200:	8b 55 0c             	mov    0xc(%ebp),%edx
  801203:	89 02                	mov    %eax,(%edx)
	return 0;
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	eb 13                	jmp    80121f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80120c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801211:	eb 0c                	jmp    80121f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801218:	eb 05                	jmp    80121f <fd_lookup+0x54>
  80121a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	53                   	push   %ebx
  801225:	83 ec 14             	sub    $0x14,%esp
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80122e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801234:	75 1e                	jne    801254 <dev_lookup+0x33>
  801236:	eb 0e                	jmp    801246 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801238:	b8 20 30 80 00       	mov    $0x803020,%eax
  80123d:	eb 0c                	jmp    80124b <dev_lookup+0x2a>
  80123f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801244:	eb 05                	jmp    80124b <dev_lookup+0x2a>
  801246:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80124b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	eb 38                	jmp    80128c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801254:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80125a:	74 dc                	je     801238 <dev_lookup+0x17>
  80125c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801262:	74 db                	je     80123f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801264:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80126a:	8b 52 48             	mov    0x48(%edx),%edx
  80126d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801271:	89 54 24 04          	mov    %edx,0x4(%esp)
  801275:	c7 04 24 cc 27 80 00 	movl   $0x8027cc,(%esp)
  80127c:	e8 e5 ef ff ff       	call   800266 <cprintf>
	*dev = 0;
  801281:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80128c:	83 c4 14             	add    $0x14,%esp
  80128f:	5b                   	pop    %ebx
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 20             	sub    $0x20,%esp
  80129a:	8b 75 08             	mov    0x8(%ebp),%esi
  80129d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ad:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b0:	89 04 24             	mov    %eax,(%esp)
  8012b3:	e8 13 ff ff ff       	call   8011cb <fd_lookup>
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 05                	js     8012c1 <fd_close+0x2f>
	    || fd != fd2)
  8012bc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012bf:	74 0c                	je     8012cd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012c1:	84 db                	test   %bl,%bl
  8012c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c8:	0f 44 c2             	cmove  %edx,%eax
  8012cb:	eb 3f                	jmp    80130c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d4:	8b 06                	mov    (%esi),%eax
  8012d6:	89 04 24             	mov    %eax,(%esp)
  8012d9:	e8 43 ff ff ff       	call   801221 <dev_lookup>
  8012de:	89 c3                	mov    %eax,%ebx
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	78 16                	js     8012fa <fd_close+0x68>
		if (dev->dev_close)
  8012e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012ea:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	74 07                	je     8012fa <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012f3:	89 34 24             	mov    %esi,(%esp)
  8012f6:	ff d0                	call   *%eax
  8012f8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801305:	e8 06 fb ff ff       	call   800e10 <sys_page_unmap>
	return r;
  80130a:	89 d8                	mov    %ebx,%eax
}
  80130c:	83 c4 20             	add    $0x20,%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801319:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	89 04 24             	mov    %eax,(%esp)
  801326:	e8 a0 fe ff ff       	call   8011cb <fd_lookup>
  80132b:	89 c2                	mov    %eax,%edx
  80132d:	85 d2                	test   %edx,%edx
  80132f:	78 13                	js     801344 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801338:	00 
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	89 04 24             	mov    %eax,(%esp)
  80133f:	e8 4e ff ff ff       	call   801292 <fd_close>
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <close_all>:

void
close_all(void)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	53                   	push   %ebx
  80134a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80134d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801352:	89 1c 24             	mov    %ebx,(%esp)
  801355:	e8 b9 ff ff ff       	call   801313 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80135a:	83 c3 01             	add    $0x1,%ebx
  80135d:	83 fb 20             	cmp    $0x20,%ebx
  801360:	75 f0                	jne    801352 <close_all+0xc>
		close(i);
}
  801362:	83 c4 14             	add    $0x14,%esp
  801365:	5b                   	pop    %ebx
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	57                   	push   %edi
  80136c:	56                   	push   %esi
  80136d:	53                   	push   %ebx
  80136e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801371:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801374:	89 44 24 04          	mov    %eax,0x4(%esp)
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	e8 48 fe ff ff       	call   8011cb <fd_lookup>
  801383:	89 c2                	mov    %eax,%edx
  801385:	85 d2                	test   %edx,%edx
  801387:	0f 88 e1 00 00 00    	js     80146e <dup+0x106>
		return r;
	close(newfdnum);
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	89 04 24             	mov    %eax,(%esp)
  801393:	e8 7b ff ff ff       	call   801313 <close>

	newfd = INDEX2FD(newfdnum);
  801398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80139b:	c1 e3 0c             	shl    $0xc,%ebx
  80139e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a7:	89 04 24             	mov    %eax,(%esp)
  8013aa:	e8 91 fd ff ff       	call   801140 <fd2data>
  8013af:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013b1:	89 1c 24             	mov    %ebx,(%esp)
  8013b4:	e8 87 fd ff ff       	call   801140 <fd2data>
  8013b9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013bb:	89 f0                	mov    %esi,%eax
  8013bd:	c1 e8 16             	shr    $0x16,%eax
  8013c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c7:	a8 01                	test   $0x1,%al
  8013c9:	74 43                	je     80140e <dup+0xa6>
  8013cb:	89 f0                	mov    %esi,%eax
  8013cd:	c1 e8 0c             	shr    $0xc,%eax
  8013d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d7:	f6 c2 01             	test   $0x1,%dl
  8013da:	74 32                	je     80140e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f7:	00 
  8013f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801403:	e8 b5 f9 ff ff       	call   800dbd <sys_page_map>
  801408:	89 c6                	mov    %eax,%esi
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 3e                	js     80144c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80140e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801411:	89 c2                	mov    %eax,%edx
  801413:	c1 ea 0c             	shr    $0xc,%edx
  801416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801423:	89 54 24 10          	mov    %edx,0x10(%esp)
  801427:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80142b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801432:	00 
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
  801437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143e:	e8 7a f9 ff ff       	call   800dbd <sys_page_map>
  801443:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801448:	85 f6                	test   %esi,%esi
  80144a:	79 22                	jns    80146e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80144c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801457:	e8 b4 f9 ff ff       	call   800e10 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80145c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801460:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801467:	e8 a4 f9 ff ff       	call   800e10 <sys_page_unmap>
	return r;
  80146c:	89 f0                	mov    %esi,%eax
}
  80146e:	83 c4 3c             	add    $0x3c,%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	53                   	push   %ebx
  80147a:	83 ec 24             	sub    $0x24,%esp
  80147d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801480:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	89 1c 24             	mov    %ebx,(%esp)
  80148a:	e8 3c fd ff ff       	call   8011cb <fd_lookup>
  80148f:	89 c2                	mov    %eax,%edx
  801491:	85 d2                	test   %edx,%edx
  801493:	78 6d                	js     801502 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801495:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801498:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149f:	8b 00                	mov    (%eax),%eax
  8014a1:	89 04 24             	mov    %eax,(%esp)
  8014a4:	e8 78 fd ff ff       	call   801221 <dev_lookup>
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 55                	js     801502 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b0:	8b 50 08             	mov    0x8(%eax),%edx
  8014b3:	83 e2 03             	and    $0x3,%edx
  8014b6:	83 fa 01             	cmp    $0x1,%edx
  8014b9:	75 23                	jne    8014de <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c0:	8b 40 48             	mov    0x48(%eax),%eax
  8014c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cb:	c7 04 24 0d 28 80 00 	movl   $0x80280d,(%esp)
  8014d2:	e8 8f ed ff ff       	call   800266 <cprintf>
		return -E_INVAL;
  8014d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dc:	eb 24                	jmp    801502 <read+0x8c>
	}
	if (!dev->dev_read)
  8014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e1:	8b 52 08             	mov    0x8(%edx),%edx
  8014e4:	85 d2                	test   %edx,%edx
  8014e6:	74 15                	je     8014fd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014f6:	89 04 24             	mov    %eax,(%esp)
  8014f9:	ff d2                	call   *%edx
  8014fb:	eb 05                	jmp    801502 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801502:	83 c4 24             	add    $0x24,%esp
  801505:	5b                   	pop    %ebx
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    

00801508 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	57                   	push   %edi
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	83 ec 1c             	sub    $0x1c,%esp
  801511:	8b 7d 08             	mov    0x8(%ebp),%edi
  801514:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801517:	85 f6                	test   %esi,%esi
  801519:	74 33                	je     80154e <readn+0x46>
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801525:	89 f2                	mov    %esi,%edx
  801527:	29 c2                	sub    %eax,%edx
  801529:	89 54 24 08          	mov    %edx,0x8(%esp)
  80152d:	03 45 0c             	add    0xc(%ebp),%eax
  801530:	89 44 24 04          	mov    %eax,0x4(%esp)
  801534:	89 3c 24             	mov    %edi,(%esp)
  801537:	e8 3a ff ff ff       	call   801476 <read>
		if (m < 0)
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 1b                	js     80155b <readn+0x53>
			return m;
		if (m == 0)
  801540:	85 c0                	test   %eax,%eax
  801542:	74 11                	je     801555 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801544:	01 c3                	add    %eax,%ebx
  801546:	89 d8                	mov    %ebx,%eax
  801548:	39 f3                	cmp    %esi,%ebx
  80154a:	72 d9                	jb     801525 <readn+0x1d>
  80154c:	eb 0b                	jmp    801559 <readn+0x51>
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 06                	jmp    80155b <readn+0x53>
  801555:	89 d8                	mov    %ebx,%eax
  801557:	eb 02                	jmp    80155b <readn+0x53>
  801559:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80155b:	83 c4 1c             	add    $0x1c,%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	53                   	push   %ebx
  801567:	83 ec 24             	sub    $0x24,%esp
  80156a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801570:	89 44 24 04          	mov    %eax,0x4(%esp)
  801574:	89 1c 24             	mov    %ebx,(%esp)
  801577:	e8 4f fc ff ff       	call   8011cb <fd_lookup>
  80157c:	89 c2                	mov    %eax,%edx
  80157e:	85 d2                	test   %edx,%edx
  801580:	78 68                	js     8015ea <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801582:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801585:	89 44 24 04          	mov    %eax,0x4(%esp)
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	8b 00                	mov    (%eax),%eax
  80158e:	89 04 24             	mov    %eax,(%esp)
  801591:	e8 8b fc ff ff       	call   801221 <dev_lookup>
  801596:	85 c0                	test   %eax,%eax
  801598:	78 50                	js     8015ea <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a1:	75 23                	jne    8015c6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8015a8:	8b 40 48             	mov    0x48(%eax),%eax
  8015ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b3:	c7 04 24 29 28 80 00 	movl   $0x802829,(%esp)
  8015ba:	e8 a7 ec ff ff       	call   800266 <cprintf>
		return -E_INVAL;
  8015bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c4:	eb 24                	jmp    8015ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015cc:	85 d2                	test   %edx,%edx
  8015ce:	74 15                	je     8015e5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	ff d2                	call   *%edx
  8015e3:	eb 05                	jmp    8015ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015ea:	83 c4 24             	add    $0x24,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 04 24             	mov    %eax,(%esp)
  801603:	e8 c3 fb ff ff       	call   8011cb <fd_lookup>
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 0e                	js     80161a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801612:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	53                   	push   %ebx
  801620:	83 ec 24             	sub    $0x24,%esp
  801623:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801626:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162d:	89 1c 24             	mov    %ebx,(%esp)
  801630:	e8 96 fb ff ff       	call   8011cb <fd_lookup>
  801635:	89 c2                	mov    %eax,%edx
  801637:	85 d2                	test   %edx,%edx
  801639:	78 61                	js     80169c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	89 04 24             	mov    %eax,(%esp)
  80164a:	e8 d2 fb ff ff       	call   801221 <dev_lookup>
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 49                	js     80169c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801656:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165a:	75 23                	jne    80167f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80165c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801661:	8b 40 48             	mov    0x48(%eax),%eax
  801664:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166c:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  801673:	e8 ee eb ff ff       	call   800266 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801678:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167d:	eb 1d                	jmp    80169c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80167f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801682:	8b 52 18             	mov    0x18(%edx),%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	74 0e                	je     801697 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	ff d2                	call   *%edx
  801695:	eb 05                	jmp    80169c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801697:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80169c:	83 c4 24             	add    $0x24,%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    

008016a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 24             	sub    $0x24,%esp
  8016a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 04 24             	mov    %eax,(%esp)
  8016b9:	e8 0d fb ff ff       	call   8011cb <fd_lookup>
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	85 d2                	test   %edx,%edx
  8016c2:	78 52                	js     801716 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ce:	8b 00                	mov    (%eax),%eax
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 49 fb ff ff       	call   801221 <dev_lookup>
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 3a                	js     801716 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e3:	74 2c                	je     801711 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016ef:	00 00 00 
	stat->st_isdir = 0;
  8016f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016f9:	00 00 00 
	stat->st_dev = dev;
  8016fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801702:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801709:	89 14 24             	mov    %edx,(%esp)
  80170c:	ff 50 14             	call   *0x14(%eax)
  80170f:	eb 05                	jmp    801716 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801711:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801716:	83 c4 24             	add    $0x24,%esp
  801719:	5b                   	pop    %ebx
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801724:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80172b:	00 
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	89 04 24             	mov    %eax,(%esp)
  801732:	e8 af 01 00 00       	call   8018e6 <open>
  801737:	89 c3                	mov    %eax,%ebx
  801739:	85 db                	test   %ebx,%ebx
  80173b:	78 1b                	js     801758 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	89 44 24 04          	mov    %eax,0x4(%esp)
  801744:	89 1c 24             	mov    %ebx,(%esp)
  801747:	e8 56 ff ff ff       	call   8016a2 <fstat>
  80174c:	89 c6                	mov    %eax,%esi
	close(fd);
  80174e:	89 1c 24             	mov    %ebx,(%esp)
  801751:	e8 bd fb ff ff       	call   801313 <close>
	return r;
  801756:	89 f0                	mov    %esi,%eax
}
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    

0080175f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 10             	sub    $0x10,%esp
  801767:	89 c6                	mov    %eax,%esi
  801769:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801772:	75 11                	jne    801785 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801774:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80177b:	e8 bc 09 00 00       	call   80213c <ipc_find_env>
  801780:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801785:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80178c:	00 
  80178d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801794:	00 
  801795:	89 74 24 04          	mov    %esi,0x4(%esp)
  801799:	a1 00 40 80 00       	mov    0x804000,%eax
  80179e:	89 04 24             	mov    %eax,(%esp)
  8017a1:	e8 30 09 00 00       	call   8020d6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017ad:	00 
  8017ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b9:	e8 ae 08 00 00       	call   80206c <ipc_recv>
}
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 14             	sub    $0x14,%esp
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e4:	e8 76 ff ff ff       	call   80175f <fsipc>
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	85 d2                	test   %edx,%edx
  8017ed:	78 2b                	js     80181a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ef:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017f6:	00 
  8017f7:	89 1c 24             	mov    %ebx,(%esp)
  8017fa:	e8 bc f0 ff ff       	call   8008bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ff:	a1 80 50 80 00       	mov    0x805080,%eax
  801804:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180a:	a1 84 50 80 00       	mov    0x805084,%eax
  80180f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181a:	83 c4 14             	add    $0x14,%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8b 40 0c             	mov    0xc(%eax),%eax
  80182c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801831:	ba 00 00 00 00       	mov    $0x0,%edx
  801836:	b8 06 00 00 00       	mov    $0x6,%eax
  80183b:	e8 1f ff ff ff       	call   80175f <fsipc>
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	83 ec 10             	sub    $0x10,%esp
  80184a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801858:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 03 00 00 00       	mov    $0x3,%eax
  801868:	e8 f2 fe ff ff       	call   80175f <fsipc>
  80186d:	89 c3                	mov    %eax,%ebx
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 6a                	js     8018dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801873:	39 c6                	cmp    %eax,%esi
  801875:	73 24                	jae    80189b <devfile_read+0x59>
  801877:	c7 44 24 0c 46 28 80 	movl   $0x802846,0xc(%esp)
  80187e:	00 
  80187f:	c7 44 24 08 4d 28 80 	movl   $0x80284d,0x8(%esp)
  801886:	00 
  801887:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  80188e:	00 
  80188f:	c7 04 24 62 28 80 00 	movl   $0x802862,(%esp)
  801896:	e8 7b 07 00 00       	call   802016 <_panic>
	assert(r <= PGSIZE);
  80189b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a0:	7e 24                	jle    8018c6 <devfile_read+0x84>
  8018a2:	c7 44 24 0c 6d 28 80 	movl   $0x80286d,0xc(%esp)
  8018a9:	00 
  8018aa:	c7 44 24 08 4d 28 80 	movl   $0x80284d,0x8(%esp)
  8018b1:	00 
  8018b2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8018b9:	00 
  8018ba:	c7 04 24 62 28 80 00 	movl   $0x802862,(%esp)
  8018c1:	e8 50 07 00 00       	call   802016 <_panic>
	memmove(buf, &fsipcbuf, r);
  8018c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ca:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018d1:	00 
  8018d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 d9 f1 ff ff       	call   800ab6 <memmove>
	return r;
}
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 24             	sub    $0x24,%esp
  8018ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018f0:	89 1c 24             	mov    %ebx,(%esp)
  8018f3:	e8 68 ef ff ff       	call   800860 <strlen>
  8018f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018fd:	7f 60                	jg     80195f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 4d f8 ff ff       	call   801157 <fd_alloc>
  80190a:	89 c2                	mov    %eax,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	78 54                	js     801964 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801910:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801914:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  80191b:	e8 9b ef ff ff       	call   8008bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192b:	b8 01 00 00 00       	mov    $0x1,%eax
  801930:	e8 2a fe ff ff       	call   80175f <fsipc>
  801935:	89 c3                	mov    %eax,%ebx
  801937:	85 c0                	test   %eax,%eax
  801939:	79 17                	jns    801952 <open+0x6c>
		fd_close(fd, 0);
  80193b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801942:	00 
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	89 04 24             	mov    %eax,(%esp)
  801949:	e8 44 f9 ff ff       	call   801292 <fd_close>
		return r;
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	eb 12                	jmp    801964 <open+0x7e>
	}

	return fd2num(fd);
  801952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801955:	89 04 24             	mov    %eax,(%esp)
  801958:	e8 d3 f7 ff ff       	call   801130 <fd2num>
  80195d:	eb 05                	jmp    801964 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80195f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801964:	83 c4 24             	add    $0x24,%esp
  801967:	5b                   	pop    %ebx
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    

0080196a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 14             	sub    $0x14,%esp
  801971:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801973:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801977:	7e 31                	jle    8019aa <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801979:	8b 40 04             	mov    0x4(%eax),%eax
  80197c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801980:	8d 43 10             	lea    0x10(%ebx),%eax
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	8b 03                	mov    (%ebx),%eax
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 d2 fb ff ff       	call   801563 <write>
		if (result > 0)
  801991:	85 c0                	test   %eax,%eax
  801993:	7e 03                	jle    801998 <writebuf+0x2e>
			b->result += result;
  801995:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801998:	39 43 04             	cmp    %eax,0x4(%ebx)
  80199b:	74 0d                	je     8019aa <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80199d:	85 c0                	test   %eax,%eax
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	0f 4f c2             	cmovg  %edx,%eax
  8019a7:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019aa:	83 c4 14             	add    $0x14,%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    

008019b0 <putch>:

static void
putch(int ch, void *thunk)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019ba:	8b 53 04             	mov    0x4(%ebx),%edx
  8019bd:	8d 42 01             	lea    0x1(%edx),%eax
  8019c0:	89 43 04             	mov    %eax,0x4(%ebx)
  8019c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ca:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019cf:	75 0e                	jne    8019df <putch+0x2f>
		writebuf(b);
  8019d1:	89 d8                	mov    %ebx,%eax
  8019d3:	e8 92 ff ff ff       	call   80196a <writebuf>
		b->idx = 0;
  8019d8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8019df:	83 c4 04             	add    $0x4,%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019f7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019fe:	00 00 00 
	b.result = 0;
  801a01:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a08:	00 00 00 
	b.error = 1;
  801a0b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a12:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a15:	8b 45 10             	mov    0x10(%ebp),%eax
  801a18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a23:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2d:	c7 04 24 b0 19 80 00 	movl   $0x8019b0,(%esp)
  801a34:	e8 bb e9 ff ff       	call   8003f4 <vprintfmt>
	if (b.idx > 0)
  801a39:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a40:	7e 0b                	jle    801a4d <vfprintf+0x68>
		writebuf(&b);
  801a42:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a48:	e8 1d ff ff ff       	call   80196a <writebuf>

	return (b.result ? b.result : b.error);
  801a4d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a53:	85 c0                	test   %eax,%eax
  801a55:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a64:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	89 04 24             	mov    %eax,(%esp)
  801a78:	e8 68 ff ff ff       	call   8019e5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <printf>:

int
printf(const char *fmt, ...)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a85:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a9a:	e8 46 ff ff ff       	call   8019e5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    
  801aa1:	66 90                	xchg   %ax,%ax
  801aa3:	66 90                	xchg   %ax,%ax
  801aa5:	66 90                	xchg   %ax,%ax
  801aa7:	66 90                	xchg   %ax,%ax
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	66 90                	xchg   %ax,%ax
  801aad:	66 90                	xchg   %ax,%ax
  801aaf:	90                   	nop

00801ab0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	56                   	push   %esi
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 10             	sub    $0x10,%esp
  801ab8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 7a f6 ff ff       	call   801140 <fd2data>
  801ac6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ac8:	c7 44 24 04 79 28 80 	movl   $0x802879,0x4(%esp)
  801acf:	00 
  801ad0:	89 1c 24             	mov    %ebx,(%esp)
  801ad3:	e8 e3 ed ff ff       	call   8008bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ad8:	8b 46 04             	mov    0x4(%esi),%eax
  801adb:	2b 06                	sub    (%esi),%eax
  801add:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ae3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aea:	00 00 00 
	stat->st_dev = &devpipe;
  801aed:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801af4:	30 80 00 
	return 0;
}
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	53                   	push   %ebx
  801b07:	83 ec 14             	sub    $0x14,%esp
  801b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b0d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b18:	e8 f3 f2 ff ff       	call   800e10 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b1d:	89 1c 24             	mov    %ebx,(%esp)
  801b20:	e8 1b f6 ff ff       	call   801140 <fd2data>
  801b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b30:	e8 db f2 ff ff       	call   800e10 <sys_page_unmap>
}
  801b35:	83 c4 14             	add    $0x14,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    

00801b3b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	57                   	push   %edi
  801b3f:	56                   	push   %esi
  801b40:	53                   	push   %ebx
  801b41:	83 ec 2c             	sub    $0x2c,%esp
  801b44:	89 c6                	mov    %eax,%esi
  801b46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b49:	a1 04 40 80 00       	mov    0x804004,%eax
  801b4e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b51:	89 34 24             	mov    %esi,(%esp)
  801b54:	e8 2b 06 00 00       	call   802184 <pageref>
  801b59:	89 c7                	mov    %eax,%edi
  801b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 1e 06 00 00       	call   802184 <pageref>
  801b66:	39 c7                	cmp    %eax,%edi
  801b68:	0f 94 c2             	sete   %dl
  801b6b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801b6e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801b74:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801b77:	39 fb                	cmp    %edi,%ebx
  801b79:	74 21                	je     801b9c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b7b:	84 d2                	test   %dl,%dl
  801b7d:	74 ca                	je     801b49 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b7f:	8b 51 58             	mov    0x58(%ecx),%edx
  801b82:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b86:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b8e:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  801b95:	e8 cc e6 ff ff       	call   800266 <cprintf>
  801b9a:	eb ad                	jmp    801b49 <_pipeisclosed+0xe>
	}
}
  801b9c:	83 c4 2c             	add    $0x2c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	57                   	push   %edi
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 1c             	sub    $0x1c,%esp
  801bad:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bb0:	89 34 24             	mov    %esi,(%esp)
  801bb3:	e8 88 f5 ff ff       	call   801140 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bbc:	74 61                	je     801c1f <devpipe_write+0x7b>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc5:	eb 4a                	jmp    801c11 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bc7:	89 da                	mov    %ebx,%edx
  801bc9:	89 f0                	mov    %esi,%eax
  801bcb:	e8 6b ff ff ff       	call   801b3b <_pipeisclosed>
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	75 54                	jne    801c28 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bd4:	e8 71 f1 ff ff       	call   800d4a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bd9:	8b 43 04             	mov    0x4(%ebx),%eax
  801bdc:	8b 0b                	mov    (%ebx),%ecx
  801bde:	8d 51 20             	lea    0x20(%ecx),%edx
  801be1:	39 d0                	cmp    %edx,%eax
  801be3:	73 e2                	jae    801bc7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bef:	99                   	cltd   
  801bf0:	c1 ea 1b             	shr    $0x1b,%edx
  801bf3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801bf6:	83 e1 1f             	and    $0x1f,%ecx
  801bf9:	29 d1                	sub    %edx,%ecx
  801bfb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801bff:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801c03:	83 c0 01             	add    $0x1,%eax
  801c06:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c09:	83 c7 01             	add    $0x1,%edi
  801c0c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c0f:	74 13                	je     801c24 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c11:	8b 43 04             	mov    0x4(%ebx),%eax
  801c14:	8b 0b                	mov    (%ebx),%ecx
  801c16:	8d 51 20             	lea    0x20(%ecx),%edx
  801c19:	39 d0                	cmp    %edx,%eax
  801c1b:	73 aa                	jae    801bc7 <devpipe_write+0x23>
  801c1d:	eb c6                	jmp    801be5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c1f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c24:	89 f8                	mov    %edi,%eax
  801c26:	eb 05                	jmp    801c2d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    

00801c35 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 1c             	sub    $0x1c,%esp
  801c3e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c41:	89 3c 24             	mov    %edi,(%esp)
  801c44:	e8 f7 f4 ff ff       	call   801140 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4d:	74 54                	je     801ca3 <devpipe_read+0x6e>
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	be 00 00 00 00       	mov    $0x0,%esi
  801c56:	eb 3e                	jmp    801c96 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801c58:	89 f0                	mov    %esi,%eax
  801c5a:	eb 55                	jmp    801cb1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c5c:	89 da                	mov    %ebx,%edx
  801c5e:	89 f8                	mov    %edi,%eax
  801c60:	e8 d6 fe ff ff       	call   801b3b <_pipeisclosed>
  801c65:	85 c0                	test   %eax,%eax
  801c67:	75 43                	jne    801cac <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c69:	e8 dc f0 ff ff       	call   800d4a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c6e:	8b 03                	mov    (%ebx),%eax
  801c70:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c73:	74 e7                	je     801c5c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c75:	99                   	cltd   
  801c76:	c1 ea 1b             	shr    $0x1b,%edx
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	83 e0 1f             	and    $0x1f,%eax
  801c7e:	29 d0                	sub    %edx,%eax
  801c80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c8b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c8e:	83 c6 01             	add    $0x1,%esi
  801c91:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c94:	74 12                	je     801ca8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801c96:	8b 03                	mov    (%ebx),%eax
  801c98:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c9b:	75 d8                	jne    801c75 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c9d:	85 f6                	test   %esi,%esi
  801c9f:	75 b7                	jne    801c58 <devpipe_read+0x23>
  801ca1:	eb b9                	jmp    801c5c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ca3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ca8:	89 f0                	mov    %esi,%eax
  801caa:	eb 05                	jmp    801cb1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801cb1:	83 c4 1c             	add    $0x1c,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5f                   	pop    %edi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801cc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc4:	89 04 24             	mov    %eax,(%esp)
  801cc7:	e8 8b f4 ff ff       	call   801157 <fd_alloc>
  801ccc:	89 c2                	mov    %eax,%edx
  801cce:	85 d2                	test   %edx,%edx
  801cd0:	0f 88 4d 01 00 00    	js     801e23 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cdd:	00 
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cec:	e8 78 f0 ff ff       	call   800d69 <sys_page_alloc>
  801cf1:	89 c2                	mov    %eax,%edx
  801cf3:	85 d2                	test   %edx,%edx
  801cf5:	0f 88 28 01 00 00    	js     801e23 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 51 f4 ff ff       	call   801157 <fd_alloc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	0f 88 fe 00 00 00    	js     801e0e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d10:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d17:	00 
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d26:	e8 3e f0 ff ff       	call   800d69 <sys_page_alloc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	0f 88 d9 00 00 00    	js     801e0e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	89 04 24             	mov    %eax,(%esp)
  801d3b:	e8 00 f4 ff ff       	call   801140 <fd2data>
  801d40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d42:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d49:	00 
  801d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d55:	e8 0f f0 ff ff       	call   800d69 <sys_page_alloc>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	0f 88 97 00 00 00    	js     801dfb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	89 04 24             	mov    %eax,(%esp)
  801d6a:	e8 d1 f3 ff ff       	call   801140 <fd2data>
  801d6f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801d76:	00 
  801d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d82:	00 
  801d83:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8e:	e8 2a f0 ff ff       	call   800dbd <sys_page_map>
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 52                	js     801deb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d99:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801dae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 62 f3 ff ff       	call   801130 <fd2num>
  801dce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd6:	89 04 24             	mov    %eax,(%esp)
  801dd9:	e8 52 f3 ff ff       	call   801130 <fd2num>
  801dde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	eb 38                	jmp    801e23 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801deb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df6:	e8 15 f0 ff ff       	call   800e10 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e09:	e8 02 f0 ff ff       	call   800e10 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1c:	e8 ef ef ff ff       	call   800e10 <sys_page_unmap>
  801e21:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801e23:	83 c4 30             	add    $0x30,%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5e                   	pop    %esi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	89 04 24             	mov    %eax,(%esp)
  801e3d:	e8 89 f3 ff ff       	call   8011cb <fd_lookup>
  801e42:	89 c2                	mov    %eax,%edx
  801e44:	85 d2                	test   %edx,%edx
  801e46:	78 15                	js     801e5d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	89 04 24             	mov    %eax,(%esp)
  801e4e:	e8 ed f2 ff ff       	call   801140 <fd2data>
	return _pipeisclosed(fd, p);
  801e53:	89 c2                	mov    %eax,%edx
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	e8 de fc ff ff       	call   801b3b <_pipeisclosed>
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    
  801e5f:	90                   	nop

00801e60 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801e70:	c7 44 24 04 98 28 80 	movl   $0x802898,0x4(%esp)
  801e77:	00 
  801e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7b:	89 04 24             	mov    %eax,(%esp)
  801e7e:	e8 38 ea ff ff       	call   8008bb <strcpy>
	return 0;
}
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	57                   	push   %edi
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e9a:	74 4a                	je     801ee6 <devcons_write+0x5c>
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ea6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801eac:	8b 75 10             	mov    0x10(%ebp),%esi
  801eaf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801eb1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801eb4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801eb9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ebc:	89 74 24 08          	mov    %esi,0x8(%esp)
  801ec0:	03 45 0c             	add    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 3c 24             	mov    %edi,(%esp)
  801eca:	e8 e7 eb ff ff       	call   800ab6 <memmove>
		sys_cputs(buf, m);
  801ecf:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ed3:	89 3c 24             	mov    %edi,(%esp)
  801ed6:	e8 c1 ed ff ff       	call   800c9c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801edb:	01 f3                	add    %esi,%ebx
  801edd:	89 d8                	mov    %ebx,%eax
  801edf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ee2:	72 c8                	jb     801eac <devcons_write+0x22>
  801ee4:	eb 05                	jmp    801eeb <devcons_write+0x61>
  801ee6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801eeb:	89 d8                	mov    %ebx,%eax
  801eed:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    

00801ef8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801f03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f07:	75 07                	jne    801f10 <devcons_read+0x18>
  801f09:	eb 28                	jmp    801f33 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f0b:	e8 3a ee ff ff       	call   800d4a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f10:	e8 a5 ed ff ff       	call   800cba <sys_cgetc>
  801f15:	85 c0                	test   %eax,%eax
  801f17:	74 f2                	je     801f0b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	78 16                	js     801f33 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f1d:	83 f8 04             	cmp    $0x4,%eax
  801f20:	74 0c                	je     801f2e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f25:	88 02                	mov    %al,(%edx)
	return 1;
  801f27:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2c:	eb 05                	jmp    801f33 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f48:	00 
  801f49:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f4c:	89 04 24             	mov    %eax,(%esp)
  801f4f:	e8 48 ed ff ff       	call   800c9c <sys_cputs>
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <getchar>:

int
getchar(void)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f5c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f63:	00 
  801f64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f72:	e8 ff f4 ff ff       	call   801476 <read>
	if (r < 0)
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 0f                	js     801f8a <getchar+0x34>
		return r;
	if (r < 1)
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	7e 06                	jle    801f85 <getchar+0x2f>
		return -E_EOF;
	return c;
  801f7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f83:	eb 05                	jmp    801f8a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f85:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	89 04 24             	mov    %eax,(%esp)
  801f9f:	e8 27 f2 ff ff       	call   8011cb <fd_lookup>
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 11                	js     801fb9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fb1:	39 10                	cmp    %edx,(%eax)
  801fb3:	0f 94 c0             	sete   %al
  801fb6:	0f b6 c0             	movzbl %al,%eax
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <opencons>:

int
opencons(void)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc4:	89 04 24             	mov    %eax,(%esp)
  801fc7:	e8 8b f1 ff ff       	call   801157 <fd_alloc>
		return r;
  801fcc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	78 40                	js     802012 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fd2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fd9:	00 
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe8:	e8 7c ed ff ff       	call   800d69 <sys_page_alloc>
		return r;
  801fed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 1f                	js     802012 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801ff3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802008:	89 04 24             	mov    %eax,(%esp)
  80200b:	e8 20 f1 ff ff       	call   801130 <fd2num>
  802010:	89 c2                	mov    %eax,%edx
}
  802012:	89 d0                	mov    %edx,%eax
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	56                   	push   %esi
  80201a:	53                   	push   %ebx
  80201b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80201e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802021:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802027:	e8 ff ec ff ff       	call   800d2b <sys_getenvid>
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80203a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80203e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802042:	c7 04 24 a4 28 80 00 	movl   $0x8028a4,(%esp)
  802049:	e8 18 e2 ff ff       	call   800266 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80204e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802052:	8b 45 10             	mov    0x10(%ebp),%eax
  802055:	89 04 24             	mov    %eax,(%esp)
  802058:	e8 a8 e1 ff ff       	call   800205 <vcprintf>
	cprintf("\n");
  80205d:	c7 04 24 70 24 80 00 	movl   $0x802470,(%esp)
  802064:	e8 fd e1 ff ff       	call   800266 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802069:	cc                   	int3   
  80206a:	eb fd                	jmp    802069 <_panic+0x53>

0080206c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	83 ec 10             	sub    $0x10,%esp
  802074:	8b 75 08             	mov    0x8(%ebp),%esi
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  80207d:	83 f8 01             	cmp    $0x1,%eax
  802080:	19 c0                	sbb    %eax,%eax
  802082:	f7 d0                	not    %eax
  802084:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  802089:	89 04 24             	mov    %eax,(%esp)
  80208c:	e8 ee ee ff ff       	call   800f7f <sys_ipc_recv>
	if (err_code < 0) {
  802091:	85 c0                	test   %eax,%eax
  802093:	79 16                	jns    8020ab <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  802095:	85 f6                	test   %esi,%esi
  802097:	74 06                	je     80209f <ipc_recv+0x33>
  802099:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80209f:	85 db                	test   %ebx,%ebx
  8020a1:	74 2c                	je     8020cf <ipc_recv+0x63>
  8020a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020a9:	eb 24                	jmp    8020cf <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8020ab:	85 f6                	test   %esi,%esi
  8020ad:	74 0a                	je     8020b9 <ipc_recv+0x4d>
  8020af:	a1 04 40 80 00       	mov    0x804004,%eax
  8020b4:	8b 40 74             	mov    0x74(%eax),%eax
  8020b7:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8020b9:	85 db                	test   %ebx,%ebx
  8020bb:	74 0a                	je     8020c7 <ipc_recv+0x5b>
  8020bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8020c2:	8b 40 78             	mov    0x78(%eax),%eax
  8020c5:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8020c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8020cc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8020e8:	eb 25                	jmp    80210f <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8020ea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ed:	74 20                	je     80210f <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8020ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f3:	c7 44 24 08 c8 28 80 	movl   $0x8028c8,0x8(%esp)
  8020fa:	00 
  8020fb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802102:	00 
  802103:	c7 04 24 d4 28 80 00 	movl   $0x8028d4,(%esp)
  80210a:	e8 07 ff ff ff       	call   802016 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80210f:	85 db                	test   %ebx,%ebx
  802111:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802116:	0f 45 c3             	cmovne %ebx,%eax
  802119:	8b 55 14             	mov    0x14(%ebp),%edx
  80211c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802120:	89 44 24 08          	mov    %eax,0x8(%esp)
  802124:	89 74 24 04          	mov    %esi,0x4(%esp)
  802128:	89 3c 24             	mov    %edi,(%esp)
  80212b:	e8 2c ee ff ff       	call   800f5c <sys_ipc_try_send>
  802130:	85 c0                	test   %eax,%eax
  802132:	75 b6                	jne    8020ea <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802134:	83 c4 1c             	add    $0x1c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802142:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802147:	39 c8                	cmp    %ecx,%eax
  802149:	74 17                	je     802162 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80214b:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802150:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802153:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802159:	8b 52 50             	mov    0x50(%edx),%edx
  80215c:	39 ca                	cmp    %ecx,%edx
  80215e:	75 14                	jne    802174 <ipc_find_env+0x38>
  802160:	eb 05                	jmp    802167 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802167:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80216a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80216f:	8b 40 40             	mov    0x40(%eax),%eax
  802172:	eb 0e                	jmp    802182 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802174:	83 c0 01             	add    $0x1,%eax
  802177:	3d 00 04 00 00       	cmp    $0x400,%eax
  80217c:	75 d2                	jne    802150 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80217e:	66 b8 00 00          	mov    $0x0,%ax
}
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80218a:	89 d0                	mov    %edx,%eax
  80218c:	c1 e8 16             	shr    $0x16,%eax
  80218f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80219b:	f6 c1 01             	test   $0x1,%cl
  80219e:	74 1d                	je     8021bd <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8021a0:	c1 ea 0c             	shr    $0xc,%edx
  8021a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021aa:	f6 c2 01             	test   $0x1,%dl
  8021ad:	74 0e                	je     8021bd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021af:	c1 ea 0c             	shr    $0xc,%edx
  8021b2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021b9:	ef 
  8021ba:	0f b7 c0             	movzwl %ax,%eax
}
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    
  8021bf:	90                   	nop

008021c0 <__udivdi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8021ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8021ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8021d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021dc:	89 ea                	mov    %ebp,%edx
  8021de:	89 0c 24             	mov    %ecx,(%esp)
  8021e1:	75 2d                	jne    802210 <__udivdi3+0x50>
  8021e3:	39 e9                	cmp    %ebp,%ecx
  8021e5:	77 61                	ja     802248 <__udivdi3+0x88>
  8021e7:	85 c9                	test   %ecx,%ecx
  8021e9:	89 ce                	mov    %ecx,%esi
  8021eb:	75 0b                	jne    8021f8 <__udivdi3+0x38>
  8021ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f2:	31 d2                	xor    %edx,%edx
  8021f4:	f7 f1                	div    %ecx
  8021f6:	89 c6                	mov    %eax,%esi
  8021f8:	31 d2                	xor    %edx,%edx
  8021fa:	89 e8                	mov    %ebp,%eax
  8021fc:	f7 f6                	div    %esi
  8021fe:	89 c5                	mov    %eax,%ebp
  802200:	89 f8                	mov    %edi,%eax
  802202:	f7 f6                	div    %esi
  802204:	89 ea                	mov    %ebp,%edx
  802206:	83 c4 0c             	add    $0xc,%esp
  802209:	5e                   	pop    %esi
  80220a:	5f                   	pop    %edi
  80220b:	5d                   	pop    %ebp
  80220c:	c3                   	ret    
  80220d:	8d 76 00             	lea    0x0(%esi),%esi
  802210:	39 e8                	cmp    %ebp,%eax
  802212:	77 24                	ja     802238 <__udivdi3+0x78>
  802214:	0f bd e8             	bsr    %eax,%ebp
  802217:	83 f5 1f             	xor    $0x1f,%ebp
  80221a:	75 3c                	jne    802258 <__udivdi3+0x98>
  80221c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802220:	39 34 24             	cmp    %esi,(%esp)
  802223:	0f 86 9f 00 00 00    	jbe    8022c8 <__udivdi3+0x108>
  802229:	39 d0                	cmp    %edx,%eax
  80222b:	0f 82 97 00 00 00    	jb     8022c8 <__udivdi3+0x108>
  802231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802238:	31 d2                	xor    %edx,%edx
  80223a:	31 c0                	xor    %eax,%eax
  80223c:	83 c4 0c             	add    $0xc,%esp
  80223f:	5e                   	pop    %esi
  802240:	5f                   	pop    %edi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    
  802243:	90                   	nop
  802244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802248:	89 f8                	mov    %edi,%eax
  80224a:	f7 f1                	div    %ecx
  80224c:	31 d2                	xor    %edx,%edx
  80224e:	83 c4 0c             	add    $0xc,%esp
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	89 e9                	mov    %ebp,%ecx
  80225a:	8b 3c 24             	mov    (%esp),%edi
  80225d:	d3 e0                	shl    %cl,%eax
  80225f:	89 c6                	mov    %eax,%esi
  802261:	b8 20 00 00 00       	mov    $0x20,%eax
  802266:	29 e8                	sub    %ebp,%eax
  802268:	89 c1                	mov    %eax,%ecx
  80226a:	d3 ef                	shr    %cl,%edi
  80226c:	89 e9                	mov    %ebp,%ecx
  80226e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802272:	8b 3c 24             	mov    (%esp),%edi
  802275:	09 74 24 08          	or     %esi,0x8(%esp)
  802279:	89 d6                	mov    %edx,%esi
  80227b:	d3 e7                	shl    %cl,%edi
  80227d:	89 c1                	mov    %eax,%ecx
  80227f:	89 3c 24             	mov    %edi,(%esp)
  802282:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802286:	d3 ee                	shr    %cl,%esi
  802288:	89 e9                	mov    %ebp,%ecx
  80228a:	d3 e2                	shl    %cl,%edx
  80228c:	89 c1                	mov    %eax,%ecx
  80228e:	d3 ef                	shr    %cl,%edi
  802290:	09 d7                	or     %edx,%edi
  802292:	89 f2                	mov    %esi,%edx
  802294:	89 f8                	mov    %edi,%eax
  802296:	f7 74 24 08          	divl   0x8(%esp)
  80229a:	89 d6                	mov    %edx,%esi
  80229c:	89 c7                	mov    %eax,%edi
  80229e:	f7 24 24             	mull   (%esp)
  8022a1:	39 d6                	cmp    %edx,%esi
  8022a3:	89 14 24             	mov    %edx,(%esp)
  8022a6:	72 30                	jb     8022d8 <__udivdi3+0x118>
  8022a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022ac:	89 e9                	mov    %ebp,%ecx
  8022ae:	d3 e2                	shl    %cl,%edx
  8022b0:	39 c2                	cmp    %eax,%edx
  8022b2:	73 05                	jae    8022b9 <__udivdi3+0xf9>
  8022b4:	3b 34 24             	cmp    (%esp),%esi
  8022b7:	74 1f                	je     8022d8 <__udivdi3+0x118>
  8022b9:	89 f8                	mov    %edi,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	e9 7a ff ff ff       	jmp    80223c <__udivdi3+0x7c>
  8022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c8:	31 d2                	xor    %edx,%edx
  8022ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cf:	e9 68 ff ff ff       	jmp    80223c <__udivdi3+0x7c>
  8022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	83 c4 0c             	add    $0xc,%esp
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
  8022e4:	66 90                	xchg   %ax,%ax
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__umoddi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	83 ec 14             	sub    $0x14,%esp
  8022f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8022fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8022fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802302:	89 c7                	mov    %eax,%edi
  802304:	89 44 24 04          	mov    %eax,0x4(%esp)
  802308:	8b 44 24 30          	mov    0x30(%esp),%eax
  80230c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802310:	89 34 24             	mov    %esi,(%esp)
  802313:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802317:	85 c0                	test   %eax,%eax
  802319:	89 c2                	mov    %eax,%edx
  80231b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80231f:	75 17                	jne    802338 <__umoddi3+0x48>
  802321:	39 fe                	cmp    %edi,%esi
  802323:	76 4b                	jbe    802370 <__umoddi3+0x80>
  802325:	89 c8                	mov    %ecx,%eax
  802327:	89 fa                	mov    %edi,%edx
  802329:	f7 f6                	div    %esi
  80232b:	89 d0                	mov    %edx,%eax
  80232d:	31 d2                	xor    %edx,%edx
  80232f:	83 c4 14             	add    $0x14,%esp
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	66 90                	xchg   %ax,%ax
  802338:	39 f8                	cmp    %edi,%eax
  80233a:	77 54                	ja     802390 <__umoddi3+0xa0>
  80233c:	0f bd e8             	bsr    %eax,%ebp
  80233f:	83 f5 1f             	xor    $0x1f,%ebp
  802342:	75 5c                	jne    8023a0 <__umoddi3+0xb0>
  802344:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802348:	39 3c 24             	cmp    %edi,(%esp)
  80234b:	0f 87 e7 00 00 00    	ja     802438 <__umoddi3+0x148>
  802351:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802355:	29 f1                	sub    %esi,%ecx
  802357:	19 c7                	sbb    %eax,%edi
  802359:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80235d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802361:	8b 44 24 08          	mov    0x8(%esp),%eax
  802365:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802369:	83 c4 14             	add    $0x14,%esp
  80236c:	5e                   	pop    %esi
  80236d:	5f                   	pop    %edi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    
  802370:	85 f6                	test   %esi,%esi
  802372:	89 f5                	mov    %esi,%ebp
  802374:	75 0b                	jne    802381 <__umoddi3+0x91>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f6                	div    %esi
  80237f:	89 c5                	mov    %eax,%ebp
  802381:	8b 44 24 04          	mov    0x4(%esp),%eax
  802385:	31 d2                	xor    %edx,%edx
  802387:	f7 f5                	div    %ebp
  802389:	89 c8                	mov    %ecx,%eax
  80238b:	f7 f5                	div    %ebp
  80238d:	eb 9c                	jmp    80232b <__umoddi3+0x3b>
  80238f:	90                   	nop
  802390:	89 c8                	mov    %ecx,%eax
  802392:	89 fa                	mov    %edi,%edx
  802394:	83 c4 14             	add    $0x14,%esp
  802397:	5e                   	pop    %esi
  802398:	5f                   	pop    %edi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    
  80239b:	90                   	nop
  80239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023a0:	8b 04 24             	mov    (%esp),%eax
  8023a3:	be 20 00 00 00       	mov    $0x20,%esi
  8023a8:	89 e9                	mov    %ebp,%ecx
  8023aa:	29 ee                	sub    %ebp,%esi
  8023ac:	d3 e2                	shl    %cl,%edx
  8023ae:	89 f1                	mov    %esi,%ecx
  8023b0:	d3 e8                	shr    %cl,%eax
  8023b2:	89 e9                	mov    %ebp,%ecx
  8023b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b8:	8b 04 24             	mov    (%esp),%eax
  8023bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8023bf:	89 fa                	mov    %edi,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 f1                	mov    %esi,%ecx
  8023c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8023cd:	d3 ea                	shr    %cl,%edx
  8023cf:	89 e9                	mov    %ebp,%ecx
  8023d1:	d3 e7                	shl    %cl,%edi
  8023d3:	89 f1                	mov    %esi,%ecx
  8023d5:	d3 e8                	shr    %cl,%eax
  8023d7:	89 e9                	mov    %ebp,%ecx
  8023d9:	09 f8                	or     %edi,%eax
  8023db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8023df:	f7 74 24 04          	divl   0x4(%esp)
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023e9:	89 d7                	mov    %edx,%edi
  8023eb:	f7 64 24 08          	mull   0x8(%esp)
  8023ef:	39 d7                	cmp    %edx,%edi
  8023f1:	89 c1                	mov    %eax,%ecx
  8023f3:	89 14 24             	mov    %edx,(%esp)
  8023f6:	72 2c                	jb     802424 <__umoddi3+0x134>
  8023f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8023fc:	72 22                	jb     802420 <__umoddi3+0x130>
  8023fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802402:	29 c8                	sub    %ecx,%eax
  802404:	19 d7                	sbb    %edx,%edi
  802406:	89 e9                	mov    %ebp,%ecx
  802408:	89 fa                	mov    %edi,%edx
  80240a:	d3 e8                	shr    %cl,%eax
  80240c:	89 f1                	mov    %esi,%ecx
  80240e:	d3 e2                	shl    %cl,%edx
  802410:	89 e9                	mov    %ebp,%ecx
  802412:	d3 ef                	shr    %cl,%edi
  802414:	09 d0                	or     %edx,%eax
  802416:	89 fa                	mov    %edi,%edx
  802418:	83 c4 14             	add    $0x14,%esp
  80241b:	5e                   	pop    %esi
  80241c:	5f                   	pop    %edi
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    
  80241f:	90                   	nop
  802420:	39 d7                	cmp    %edx,%edi
  802422:	75 da                	jne    8023fe <__umoddi3+0x10e>
  802424:	8b 14 24             	mov    (%esp),%edx
  802427:	89 c1                	mov    %eax,%ecx
  802429:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80242d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802431:	eb cb                	jmp    8023fe <__umoddi3+0x10e>
  802433:	90                   	nop
  802434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802438:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80243c:	0f 82 0f ff ff ff    	jb     802351 <__umoddi3+0x61>
  802442:	e9 1a ff ff ff       	jmp    802361 <__umoddi3+0x71>
