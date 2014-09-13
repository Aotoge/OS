
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 8c 02 00 00       	call   8002bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004c:	00 
  80004d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800051:	89 1c 24             	mov    %ebx,(%esp)
  800054:	e8 8f 18 00 00       	call   8018e8 <readn>
  800059:	83 f8 04             	cmp    $0x4,%eax
  80005c:	74 2e                	je     80008c <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005e:	85 c0                	test   %eax,%eax
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	0f 4e d0             	cmovle %eax,%edx
  800068:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 60 27 80 	movl   $0x802760,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  800087:	e8 c2 02 00 00       	call   80034e <_panic>

	cprintf("%d\n", p);
  80008c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800093:	c7 04 24 a1 27 80 00 	movl   $0x8027a1,(%esp)
  80009a:	e8 a8 03 00 00       	call   800447 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  80009f:	89 3c 24             	mov    %edi,(%esp)
  8000a2:	e8 b2 1e 00 00       	call   801f59 <pipe>
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <primeproc+0x9b>
		panic("pipe: %e", i);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 a5 27 80 	movl   $0x8027a5,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  8000c9:	e8 80 02 00 00       	call   80034e <_panic>
	if ((id = fork()) < 0)
  8000ce:	e8 dd 11 00 00       	call   8012b0 <fork>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	79 20                	jns    8000f7 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000db:	c7 44 24 08 ae 27 80 	movl   $0x8027ae,0x8(%esp)
  8000e2:	00 
  8000e3:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ea:	00 
  8000eb:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  8000f2:	e8 57 02 00 00       	call   80034e <_panic>
	if (id == 0) {
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	75 1b                	jne    800116 <primeproc+0xe3>
		close(fd);
  8000fb:	89 1c 24             	mov    %ebx,(%esp)
  8000fe:	e8 f0 15 00 00       	call   8016f3 <close>
		close(pfd[1]);
  800103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800106:	89 04 24             	mov    %eax,(%esp)
  800109:	e8 e5 15 00 00       	call   8016f3 <close>
		fd = pfd[0];
  80010e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800111:	e9 2f ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  800116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800119:	89 04 24             	mov    %eax,(%esp)
  80011c:	e8 d2 15 00 00       	call   8016f3 <close>
	wfd = pfd[1];
  800121:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800124:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800127:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012e:	00 
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 ad 17 00 00       	call   8018e8 <readn>
  80013b:	83 f8 04             	cmp    $0x4,%eax
  80013e:	74 39                	je     800179 <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800140:	85 c0                	test   %eax,%eax
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	0f 4e d0             	cmovle %eax,%edx
  80014a:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800152:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	c7 44 24 08 b7 27 80 	movl   $0x8027b7,0x8(%esp)
  800164:	00 
  800165:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016c:	00 
  80016d:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  800174:	e8 d5 01 00 00       	call   80034e <_panic>
		if (i%p)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	99                   	cltd   
  80017d:	f7 7d e0             	idivl  -0x20(%ebp)
  800180:	85 d2                	test   %edx,%edx
  800182:	74 a3                	je     800127 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800184:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80018b:	00 
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 3c 24             	mov    %edi,(%esp)
  800193:	e8 ab 17 00 00       	call   801943 <write>
  800198:	83 f8 04             	cmp    $0x4,%eax
  80019b:	74 8a                	je     800127 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80019d:	85 c0                	test   %eax,%eax
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	0f 4e d0             	cmovle %eax,%edx
  8001a7:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  8001cd:	e8 7c 01 00 00       	call   80034e <_panic>

008001d2 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001d9:	c7 05 00 30 80 00 ed 	movl   $0x8027ed,0x803000
  8001e0:	27 80 00 

	if ((i=pipe(p)) < 0)
  8001e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 6b 1d 00 00       	call   801f59 <pipe>
  8001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	79 20                	jns    800215 <umain+0x43>
		panic("pipe: %e", i);
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	c7 44 24 08 a5 27 80 	movl   $0x8027a5,0x8(%esp)
  800200:	00 
  800201:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800208:	00 
  800209:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  800210:	e8 39 01 00 00       	call   80034e <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800215:	e8 96 10 00 00       	call   8012b0 <fork>
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 20                	jns    80023e <umain+0x6c>
		panic("fork: %e", id);
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	c7 44 24 08 ae 27 80 	movl   $0x8027ae,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  800239:	e8 10 01 00 00       	call   80034e <_panic>

	if (id == 0) {
  80023e:	85 c0                	test   %eax,%eax
  800240:	75 16                	jne    800258 <umain+0x86>
		close(p[1]);
  800242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 a6 14 00 00       	call   8016f3 <close>
		primeproc(p[0]);
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 db fd ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  800258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 90 14 00 00       	call   8016f3 <close>

	// feed all the integers through
	for (i=2;; i++)
  800263:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026a:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80026d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800274:	00 
  800275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 bf 16 00 00       	call   801943 <write>
  800284:	83 f8 04             	cmp    $0x4,%eax
  800287:	74 2e                	je     8002b7 <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800289:	85 c0                	test   %eax,%eax
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	0f 4e d0             	cmovle %eax,%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 f8 27 80 	movl   $0x8027f8,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  8002b2:	e8 97 00 00 00       	call   80034e <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002bb:	eb b0                	jmp    80026d <umain+0x9b>

008002bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 10             	sub    $0x10,%esp
  8002c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8002cb:	e8 4b 0c 00 00       	call   800f1b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8002d0:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8002d6:	39 c2                	cmp    %eax,%edx
  8002d8:	74 17                	je     8002f1 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8002da:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8002df:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8002e2:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8002e8:	8b 49 40             	mov    0x40(%ecx),%ecx
  8002eb:	39 c1                	cmp    %eax,%ecx
  8002ed:	75 18                	jne    800307 <libmain+0x4a>
  8002ef:	eb 05                	jmp    8002f6 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8002f1:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8002f6:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8002f9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8002ff:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800305:	eb 0b                	jmp    800312 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800307:	83 c2 01             	add    $0x1,%edx
  80030a:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800310:	75 cd                	jne    8002df <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800312:	85 db                	test   %ebx,%ebx
  800314:	7e 07                	jle    80031d <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 06                	mov    (%esi),%eax
  800318:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80031d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800321:	89 1c 24             	mov    %ebx,(%esp)
  800324:	e8 a9 fe ff ff       	call   8001d2 <umain>

	// exit gracefully
	exit();
  800329:	e8 07 00 00 00       	call   800335 <exit>
}
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	5b                   	pop    %ebx
  800332:	5e                   	pop    %esi
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    

00800335 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80033b:	e8 e6 13 00 00       	call   801726 <close_all>
	sys_env_destroy(0);
  800340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800347:	e8 7d 0b 00 00       	call   800ec9 <sys_env_destroy>
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800356:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800359:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80035f:	e8 b7 0b 00 00       	call   800f1b <sys_getenvid>
  800364:	8b 55 0c             	mov    0xc(%ebp),%edx
  800367:	89 54 24 10          	mov    %edx,0x10(%esp)
  80036b:	8b 55 08             	mov    0x8(%ebp),%edx
  80036e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800372:	89 74 24 08          	mov    %esi,0x8(%esp)
  800376:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037a:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  800381:	e8 c1 00 00 00       	call   800447 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800386:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80038a:	8b 45 10             	mov    0x10(%ebp),%eax
  80038d:	89 04 24             	mov    %eax,(%esp)
  800390:	e8 51 00 00 00       	call   8003e6 <vcprintf>
	cprintf("\n");
  800395:	c7 04 24 a3 27 80 00 	movl   $0x8027a3,(%esp)
  80039c:	e8 a6 00 00 00       	call   800447 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a1:	cc                   	int3   
  8003a2:	eb fd                	jmp    8003a1 <_panic+0x53>

008003a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	53                   	push   %ebx
  8003a8:	83 ec 14             	sub    $0x14,%esp
  8003ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ae:	8b 13                	mov    (%ebx),%edx
  8003b0:	8d 42 01             	lea    0x1(%edx),%eax
  8003b3:	89 03                	mov    %eax,(%ebx)
  8003b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c1:	75 19                	jne    8003dc <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003c3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003ca:	00 
  8003cb:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ce:	89 04 24             	mov    %eax,(%esp)
  8003d1:	e8 b6 0a 00 00       	call   800e8c <sys_cputs>
		b->idx = 0;
  8003d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003dc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003e0:	83 c4 14             	add    $0x14,%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f6:	00 00 00 
	b.cnt = 0;
  8003f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800400:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800411:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041b:	c7 04 24 a4 03 80 00 	movl   $0x8003a4,(%esp)
  800422:	e8 bd 01 00 00       	call   8005e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800427:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800437:	89 04 24             	mov    %eax,(%esp)
  80043a:	e8 4d 0a 00 00       	call   800e8c <sys_cputs>

	return b.cnt;
}
  80043f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800445:	c9                   	leave  
  800446:	c3                   	ret    

00800447 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80044d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800450:	89 44 24 04          	mov    %eax,0x4(%esp)
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	89 04 24             	mov    %eax,(%esp)
  80045a:	e8 87 ff ff ff       	call   8003e6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80045f:	c9                   	leave  
  800460:	c3                   	ret    
  800461:	66 90                	xchg   %ax,%ax
  800463:	66 90                	xchg   %ax,%ax
  800465:	66 90                	xchg   %ax,%ax
  800467:	66 90                	xchg   %ax,%ax
  800469:	66 90                	xchg   %ax,%ax
  80046b:	66 90                	xchg   %ax,%ax
  80046d:	66 90                	xchg   %ax,%ax
  80046f:	90                   	nop

00800470 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	57                   	push   %edi
  800474:	56                   	push   %esi
  800475:	53                   	push   %ebx
  800476:	83 ec 3c             	sub    $0x3c,%esp
  800479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047c:	89 d7                	mov    %edx,%edi
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800484:	8b 75 0c             	mov    0xc(%ebp),%esi
  800487:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80048d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800498:	39 f1                	cmp    %esi,%ecx
  80049a:	72 14                	jb     8004b0 <printnum+0x40>
  80049c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049f:	76 0f                	jbe    8004b0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8004a7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004aa:	85 f6                	test   %esi,%esi
  8004ac:	7f 60                	jg     80050e <printnum+0x9e>
  8004ae:	eb 72                	jmp    800522 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004b3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8004ba:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8004bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004c5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004c9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004cd:	89 c3                	mov    %eax,%ebx
  8004cf:	89 d6                	mov    %edx,%esi
  8004d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e2:	89 04 24             	mov    %eax,(%esp)
  8004e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ec:	e8 df 1f 00 00       	call   8024d0 <__udivdi3>
  8004f1:	89 d9                	mov    %ebx,%ecx
  8004f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800502:	89 fa                	mov    %edi,%edx
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	e8 64 ff ff ff       	call   800470 <printnum>
  80050c:	eb 14                	jmp    800522 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800512:	8b 45 18             	mov    0x18(%ebp),%eax
  800515:	89 04 24             	mov    %eax,(%esp)
  800518:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051a:	83 ee 01             	sub    $0x1,%esi
  80051d:	75 ef                	jne    80050e <printnum+0x9e>
  80051f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800522:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800526:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80052a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80052d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800530:	89 44 24 08          	mov    %eax,0x8(%esp)
  800534:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	89 04 24             	mov    %eax,(%esp)
  80053e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800541:	89 44 24 04          	mov    %eax,0x4(%esp)
  800545:	e8 b6 20 00 00       	call   802600 <__umoddi3>
  80054a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054e:	0f be 80 3f 28 80 00 	movsbl 0x80283f(%eax),%eax
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80055b:	ff d0                	call   *%eax
}
  80055d:	83 c4 3c             	add    $0x3c,%esp
  800560:	5b                   	pop    %ebx
  800561:	5e                   	pop    %esi
  800562:	5f                   	pop    %edi
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800568:	83 fa 01             	cmp    $0x1,%edx
  80056b:	7e 0e                	jle    80057b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80056d:	8b 10                	mov    (%eax),%edx
  80056f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800572:	89 08                	mov    %ecx,(%eax)
  800574:	8b 02                	mov    (%edx),%eax
  800576:	8b 52 04             	mov    0x4(%edx),%edx
  800579:	eb 22                	jmp    80059d <getuint+0x38>
	else if (lflag)
  80057b:	85 d2                	test   %edx,%edx
  80057d:	74 10                	je     80058f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	8d 4a 04             	lea    0x4(%edx),%ecx
  800584:	89 08                	mov    %ecx,(%eax)
  800586:	8b 02                	mov    (%edx),%eax
  800588:	ba 00 00 00 00       	mov    $0x0,%edx
  80058d:	eb 0e                	jmp    80059d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80058f:	8b 10                	mov    (%eax),%edx
  800591:	8d 4a 04             	lea    0x4(%edx),%ecx
  800594:	89 08                	mov    %ecx,(%eax)
  800596:	8b 02                	mov    (%edx),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ae:	73 0a                	jae    8005ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8005b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b3:	89 08                	mov    %ecx,(%eax)
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	88 02                	mov    %al,(%edx)
}
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	89 04 24             	mov    %eax,(%esp)
  8005dd:	e8 02 00 00 00       	call   8005e4 <vprintfmt>
	va_end(ap);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	57                   	push   %edi
  8005e8:	56                   	push   %esi
  8005e9:	53                   	push   %ebx
  8005ea:	83 ec 3c             	sub    $0x3c,%esp
  8005ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f3:	eb 18                	jmp    80060d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 84 c3 03 00 00    	je     8009c0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8005fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800607:	89 f3                	mov    %esi,%ebx
  800609:	eb 02                	jmp    80060d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80060b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80060d:	8d 73 01             	lea    0x1(%ebx),%esi
  800610:	0f b6 03             	movzbl (%ebx),%eax
  800613:	83 f8 25             	cmp    $0x25,%eax
  800616:	75 dd                	jne    8005f5 <vprintfmt+0x11>
  800618:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80061c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800623:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80062a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800631:	ba 00 00 00 00       	mov    $0x0,%edx
  800636:	eb 1d                	jmp    800655 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800638:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80063a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80063e:	eb 15                	jmp    800655 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800640:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800642:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800646:	eb 0d                	jmp    800655 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8d 5e 01             	lea    0x1(%esi),%ebx
  800658:	0f b6 06             	movzbl (%esi),%eax
  80065b:	0f b6 c8             	movzbl %al,%ecx
  80065e:	83 e8 23             	sub    $0x23,%eax
  800661:	3c 55                	cmp    $0x55,%al
  800663:	0f 87 2f 03 00 00    	ja     800998 <vprintfmt+0x3b4>
  800669:	0f b6 c0             	movzbl %al,%eax
  80066c:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800673:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800676:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800679:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80067d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800680:	83 f9 09             	cmp    $0x9,%ecx
  800683:	77 50                	ja     8006d5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800685:	89 de                	mov    %ebx,%esi
  800687:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80068a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80068d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800690:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800694:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800697:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80069a:	83 fb 09             	cmp    $0x9,%ebx
  80069d:	76 eb                	jbe    80068a <vprintfmt+0xa6>
  80069f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a2:	eb 33                	jmp    8006d7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 48 04             	lea    0x4(%eax),%ecx
  8006aa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006b4:	eb 21                	jmp    8006d7 <vprintfmt+0xf3>
  8006b6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c0:	0f 49 c1             	cmovns %ecx,%eax
  8006c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	89 de                	mov    %ebx,%esi
  8006c8:	eb 8b                	jmp    800655 <vprintfmt+0x71>
  8006ca:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006cc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006d3:	eb 80                	jmp    800655 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006db:	0f 89 74 ff ff ff    	jns    800655 <vprintfmt+0x71>
  8006e1:	e9 62 ff ff ff       	jmp    800648 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006eb:	e9 65 ff ff ff       	jmp    800655 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 50 04             	lea    0x4(%eax),%edx
  8006f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff 55 08             	call   *0x8(%ebp)
			break;
  800705:	e9 03 ff ff ff       	jmp    80060d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	89 55 14             	mov    %edx,0x14(%ebp)
  800713:	8b 00                	mov    (%eax),%eax
  800715:	99                   	cltd   
  800716:	31 d0                	xor    %edx,%eax
  800718:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80071a:	83 f8 0f             	cmp    $0xf,%eax
  80071d:	7f 0b                	jg     80072a <vprintfmt+0x146>
  80071f:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800726:	85 d2                	test   %edx,%edx
  800728:	75 20                	jne    80074a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80072a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072e:	c7 44 24 08 57 28 80 	movl   $0x802857,0x8(%esp)
  800735:	00 
  800736:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 04 24             	mov    %eax,(%esp)
  800740:	e8 77 fe ff ff       	call   8005bc <printfmt>
  800745:	e9 c3 fe ff ff       	jmp    80060d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80074a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074e:	c7 44 24 08 2f 2d 80 	movl   $0x802d2f,0x8(%esp)
  800755:	00 
  800756:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 04 24             	mov    %eax,(%esp)
  800760:	e8 57 fe ff ff       	call   8005bc <printfmt>
  800765:	e9 a3 fe ff ff       	jmp    80060d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80076d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 50 04             	lea    0x4(%eax),%edx
  800776:	89 55 14             	mov    %edx,0x14(%ebp)
  800779:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80077b:	85 c0                	test   %eax,%eax
  80077d:	ba 50 28 80 00       	mov    $0x802850,%edx
  800782:	0f 45 d0             	cmovne %eax,%edx
  800785:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800788:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80078c:	74 04                	je     800792 <vprintfmt+0x1ae>
  80078e:	85 f6                	test   %esi,%esi
  800790:	7f 19                	jg     8007ab <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800792:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800795:	8d 70 01             	lea    0x1(%eax),%esi
  800798:	0f b6 10             	movzbl (%eax),%edx
  80079b:	0f be c2             	movsbl %dl,%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	0f 85 95 00 00 00    	jne    80083b <vprintfmt+0x257>
  8007a6:	e9 85 00 00 00       	jmp    800830 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b2:	89 04 24             	mov    %eax,(%esp)
  8007b5:	e8 b8 02 00 00       	call   800a72 <strnlen>
  8007ba:	29 c6                	sub    %eax,%esi
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007c1:	85 f6                	test   %esi,%esi
  8007c3:	7e cd                	jle    800792 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8007c5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007c9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007cc:	89 c3                	mov    %eax,%ebx
  8007ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d2:	89 34 24             	mov    %esi,(%esp)
  8007d5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	83 eb 01             	sub    $0x1,%ebx
  8007db:	75 f1                	jne    8007ce <vprintfmt+0x1ea>
  8007dd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007e3:	eb ad                	jmp    800792 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007e9:	74 1e                	je     800809 <vprintfmt+0x225>
  8007eb:	0f be d2             	movsbl %dl,%edx
  8007ee:	83 ea 20             	sub    $0x20,%edx
  8007f1:	83 fa 5e             	cmp    $0x5e,%edx
  8007f4:	76 13                	jbe    800809 <vprintfmt+0x225>
					putch('?', putdat);
  8007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800804:	ff 55 08             	call   *0x8(%ebp)
  800807:	eb 0d                	jmp    800816 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800809:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800810:	89 04 24             	mov    %eax,(%esp)
  800813:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800816:	83 ef 01             	sub    $0x1,%edi
  800819:	83 c6 01             	add    $0x1,%esi
  80081c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800820:	0f be c2             	movsbl %dl,%eax
  800823:	85 c0                	test   %eax,%eax
  800825:	75 20                	jne    800847 <vprintfmt+0x263>
  800827:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80082a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80082d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800834:	7f 25                	jg     80085b <vprintfmt+0x277>
  800836:	e9 d2 fd ff ff       	jmp    80060d <vprintfmt+0x29>
  80083b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800841:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800844:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800847:	85 db                	test   %ebx,%ebx
  800849:	78 9a                	js     8007e5 <vprintfmt+0x201>
  80084b:	83 eb 01             	sub    $0x1,%ebx
  80084e:	79 95                	jns    8007e5 <vprintfmt+0x201>
  800850:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800853:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800856:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800859:	eb d5                	jmp    800830 <vprintfmt+0x24c>
  80085b:	8b 75 08             	mov    0x8(%ebp),%esi
  80085e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800861:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800864:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800868:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80086f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800871:	83 eb 01             	sub    $0x1,%ebx
  800874:	75 ee                	jne    800864 <vprintfmt+0x280>
  800876:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800879:	e9 8f fd ff ff       	jmp    80060d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80087e:	83 fa 01             	cmp    $0x1,%edx
  800881:	7e 16                	jle    800899 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 50 08             	lea    0x8(%eax),%edx
  800889:	89 55 14             	mov    %edx,0x14(%ebp)
  80088c:	8b 50 04             	mov    0x4(%eax),%edx
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800897:	eb 32                	jmp    8008cb <vprintfmt+0x2e7>
	else if (lflag)
  800899:	85 d2                	test   %edx,%edx
  80089b:	74 18                	je     8008b5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 50 04             	lea    0x4(%eax),%edx
  8008a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a6:	8b 30                	mov    (%eax),%esi
  8008a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008ab:	89 f0                	mov    %esi,%eax
  8008ad:	c1 f8 1f             	sar    $0x1f,%eax
  8008b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b3:	eb 16                	jmp    8008cb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 04             	lea    0x4(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 30                	mov    (%eax),%esi
  8008c0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	c1 f8 1f             	sar    $0x1f,%eax
  8008c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008da:	0f 89 80 00 00 00    	jns    800960 <vprintfmt+0x37c>
				putch('-', putdat);
  8008e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008eb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008f4:	f7 d8                	neg    %eax
  8008f6:	83 d2 00             	adc    $0x0,%edx
  8008f9:	f7 da                	neg    %edx
			}
			base = 10;
  8008fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800900:	eb 5e                	jmp    800960 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800902:	8d 45 14             	lea    0x14(%ebp),%eax
  800905:	e8 5b fc ff ff       	call   800565 <getuint>
			base = 10;
  80090a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80090f:	eb 4f                	jmp    800960 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800911:	8d 45 14             	lea    0x14(%ebp),%eax
  800914:	e8 4c fc ff ff       	call   800565 <getuint>
			base = 8;
  800919:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80091e:	eb 40                	jmp    800960 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800920:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800924:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80092b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80092e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800932:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800939:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8d 50 04             	lea    0x4(%eax),%edx
  800942:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800945:	8b 00                	mov    (%eax),%eax
  800947:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80094c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800951:	eb 0d                	jmp    800960 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800953:	8d 45 14             	lea    0x14(%ebp),%eax
  800956:	e8 0a fc ff ff       	call   800565 <getuint>
			base = 16;
  80095b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800960:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800964:	89 74 24 10          	mov    %esi,0x10(%esp)
  800968:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80096b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80096f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800973:	89 04 24             	mov    %eax,(%esp)
  800976:	89 54 24 04          	mov    %edx,0x4(%esp)
  80097a:	89 fa                	mov    %edi,%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	e8 ec fa ff ff       	call   800470 <printnum>
			break;
  800984:	e9 84 fc ff ff       	jmp    80060d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800989:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098d:	89 0c 24             	mov    %ecx,(%esp)
  800990:	ff 55 08             	call   *0x8(%ebp)
			break;
  800993:	e9 75 fc ff ff       	jmp    80060d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800998:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009a3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009aa:	0f 84 5b fc ff ff    	je     80060b <vprintfmt+0x27>
  8009b0:	89 f3                	mov    %esi,%ebx
  8009b2:	83 eb 01             	sub    $0x1,%ebx
  8009b5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009b9:	75 f7                	jne    8009b2 <vprintfmt+0x3ce>
  8009bb:	e9 4d fc ff ff       	jmp    80060d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8009c0:	83 c4 3c             	add    $0x3c,%esp
  8009c3:	5b                   	pop    %ebx
  8009c4:	5e                   	pop    %esi
  8009c5:	5f                   	pop    %edi
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	83 ec 28             	sub    $0x28,%esp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009db:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	74 30                	je     800a19 <vsnprintf+0x51>
  8009e9:	85 d2                	test   %edx,%edx
  8009eb:	7e 2c                	jle    800a19 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a02:	c7 04 24 9f 05 80 00 	movl   $0x80059f,(%esp)
  800a09:	e8 d6 fb ff ff       	call   8005e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a11:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a17:	eb 05                	jmp    800a1e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a26:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a30:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 04 24             	mov    %eax,(%esp)
  800a41:	e8 82 ff ff ff       	call   8009c8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a46:	c9                   	leave  
  800a47:	c3                   	ret    
  800a48:	66 90                	xchg   %ax,%ax
  800a4a:	66 90                	xchg   %ax,%ax
  800a4c:	66 90                	xchg   %ax,%ax
  800a4e:	66 90                	xchg   %ax,%ax

00800a50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a56:	80 3a 00             	cmpb   $0x0,(%edx)
  800a59:	74 10                	je     800a6b <strlen+0x1b>
  800a5b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800a60:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a67:	75 f7                	jne    800a60 <strlen+0x10>
  800a69:	eb 05                	jmp    800a70 <strlen+0x20>
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
  800a76:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a7c:	85 c9                	test   %ecx,%ecx
  800a7e:	74 1c                	je     800a9c <strnlen+0x2a>
  800a80:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a83:	74 1e                	je     800aa3 <strnlen+0x31>
  800a85:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800a8a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8c:	39 ca                	cmp    %ecx,%edx
  800a8e:	74 18                	je     800aa8 <strnlen+0x36>
  800a90:	83 c2 01             	add    $0x1,%edx
  800a93:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800a98:	75 f0                	jne    800a8a <strnlen+0x18>
  800a9a:	eb 0c                	jmp    800aa8 <strnlen+0x36>
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	eb 05                	jmp    800aa8 <strnlen+0x36>
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800aa8:	5b                   	pop    %ebx
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	83 c2 01             	add    $0x1,%edx
  800aba:	83 c1 01             	add    $0x1,%ecx
  800abd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ac1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac4:	84 db                	test   %bl,%bl
  800ac6:	75 ef                	jne    800ab7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	53                   	push   %ebx
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad5:	89 1c 24             	mov    %ebx,(%esp)
  800ad8:	e8 73 ff ff ff       	call   800a50 <strlen>
	strcpy(dst + len, src);
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ae4:	01 d8                	add    %ebx,%eax
  800ae6:	89 04 24             	mov    %eax,(%esp)
  800ae9:	e8 bd ff ff ff       	call   800aab <strcpy>
	return dst;
}
  800aee:	89 d8                	mov    %ebx,%eax
  800af0:	83 c4 08             	add    $0x8,%esp
  800af3:	5b                   	pop    %ebx
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	56                   	push   %esi
  800afa:	53                   	push   %ebx
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b04:	85 db                	test   %ebx,%ebx
  800b06:	74 17                	je     800b1f <strncpy+0x29>
  800b08:	01 f3                	add    %esi,%ebx
  800b0a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800b0c:	83 c1 01             	add    $0x1,%ecx
  800b0f:	0f b6 02             	movzbl (%edx),%eax
  800b12:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b15:	80 3a 01             	cmpb   $0x1,(%edx)
  800b18:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b1b:	39 d9                	cmp    %ebx,%ecx
  800b1d:	75 ed                	jne    800b0c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b1f:	89 f0                	mov    %esi,%eax
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	57                   	push   %edi
  800b29:	56                   	push   %esi
  800b2a:	53                   	push   %ebx
  800b2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b31:	8b 75 10             	mov    0x10(%ebp),%esi
  800b34:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b36:	85 f6                	test   %esi,%esi
  800b38:	74 34                	je     800b6e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800b3a:	83 fe 01             	cmp    $0x1,%esi
  800b3d:	74 26                	je     800b65 <strlcpy+0x40>
  800b3f:	0f b6 0b             	movzbl (%ebx),%ecx
  800b42:	84 c9                	test   %cl,%cl
  800b44:	74 23                	je     800b69 <strlcpy+0x44>
  800b46:	83 ee 02             	sub    $0x2,%esi
  800b49:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b54:	39 f2                	cmp    %esi,%edx
  800b56:	74 13                	je     800b6b <strlcpy+0x46>
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b5f:	84 c9                	test   %cl,%cl
  800b61:	75 eb                	jne    800b4e <strlcpy+0x29>
  800b63:	eb 06                	jmp    800b6b <strlcpy+0x46>
  800b65:	89 f8                	mov    %edi,%eax
  800b67:	eb 02                	jmp    800b6b <strlcpy+0x46>
  800b69:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b6e:	29 f8                	sub    %edi,%eax
}
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b7e:	0f b6 01             	movzbl (%ecx),%eax
  800b81:	84 c0                	test   %al,%al
  800b83:	74 15                	je     800b9a <strcmp+0x25>
  800b85:	3a 02                	cmp    (%edx),%al
  800b87:	75 11                	jne    800b9a <strcmp+0x25>
		p++, q++;
  800b89:	83 c1 01             	add    $0x1,%ecx
  800b8c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b8f:	0f b6 01             	movzbl (%ecx),%eax
  800b92:	84 c0                	test   %al,%al
  800b94:	74 04                	je     800b9a <strcmp+0x25>
  800b96:	3a 02                	cmp    (%edx),%al
  800b98:	74 ef                	je     800b89 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9a:	0f b6 c0             	movzbl %al,%eax
  800b9d:	0f b6 12             	movzbl (%edx),%edx
  800ba0:	29 d0                	sub    %edx,%eax
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800bb2:	85 f6                	test   %esi,%esi
  800bb4:	74 29                	je     800bdf <strncmp+0x3b>
  800bb6:	0f b6 03             	movzbl (%ebx),%eax
  800bb9:	84 c0                	test   %al,%al
  800bbb:	74 30                	je     800bed <strncmp+0x49>
  800bbd:	3a 02                	cmp    (%edx),%al
  800bbf:	75 2c                	jne    800bed <strncmp+0x49>
  800bc1:	8d 43 01             	lea    0x1(%ebx),%eax
  800bc4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800bc6:	89 c3                	mov    %eax,%ebx
  800bc8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bcb:	39 f0                	cmp    %esi,%eax
  800bcd:	74 17                	je     800be6 <strncmp+0x42>
  800bcf:	0f b6 08             	movzbl (%eax),%ecx
  800bd2:	84 c9                	test   %cl,%cl
  800bd4:	74 17                	je     800bed <strncmp+0x49>
  800bd6:	83 c0 01             	add    $0x1,%eax
  800bd9:	3a 0a                	cmp    (%edx),%cl
  800bdb:	74 e9                	je     800bc6 <strncmp+0x22>
  800bdd:	eb 0e                	jmp    800bed <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800be4:	eb 0f                	jmp    800bf5 <strncmp+0x51>
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	eb 08                	jmp    800bf5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bed:	0f b6 03             	movzbl (%ebx),%eax
  800bf0:	0f b6 12             	movzbl (%edx),%edx
  800bf3:	29 d0                	sub    %edx,%eax
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	53                   	push   %ebx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800c03:	0f b6 18             	movzbl (%eax),%ebx
  800c06:	84 db                	test   %bl,%bl
  800c08:	74 1d                	je     800c27 <strchr+0x2e>
  800c0a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800c0c:	38 d3                	cmp    %dl,%bl
  800c0e:	75 06                	jne    800c16 <strchr+0x1d>
  800c10:	eb 1a                	jmp    800c2c <strchr+0x33>
  800c12:	38 ca                	cmp    %cl,%dl
  800c14:	74 16                	je     800c2c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	0f b6 10             	movzbl (%eax),%edx
  800c1c:	84 d2                	test   %dl,%dl
  800c1e:	75 f2                	jne    800c12 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
  800c25:	eb 05                	jmp    800c2c <strchr+0x33>
  800c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	53                   	push   %ebx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800c39:	0f b6 18             	movzbl (%eax),%ebx
  800c3c:	84 db                	test   %bl,%bl
  800c3e:	74 16                	je     800c56 <strfind+0x27>
  800c40:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800c42:	38 d3                	cmp    %dl,%bl
  800c44:	75 06                	jne    800c4c <strfind+0x1d>
  800c46:	eb 0e                	jmp    800c56 <strfind+0x27>
  800c48:	38 ca                	cmp    %cl,%dl
  800c4a:	74 0a                	je     800c56 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c4c:	83 c0 01             	add    $0x1,%eax
  800c4f:	0f b6 10             	movzbl (%eax),%edx
  800c52:	84 d2                	test   %dl,%dl
  800c54:	75 f2                	jne    800c48 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800c56:	5b                   	pop    %ebx
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c65:	85 c9                	test   %ecx,%ecx
  800c67:	74 36                	je     800c9f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c6f:	75 28                	jne    800c99 <memset+0x40>
  800c71:	f6 c1 03             	test   $0x3,%cl
  800c74:	75 23                	jne    800c99 <memset+0x40>
		c &= 0xFF;
  800c76:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c7a:	89 d3                	mov    %edx,%ebx
  800c7c:	c1 e3 08             	shl    $0x8,%ebx
  800c7f:	89 d6                	mov    %edx,%esi
  800c81:	c1 e6 18             	shl    $0x18,%esi
  800c84:	89 d0                	mov    %edx,%eax
  800c86:	c1 e0 10             	shl    $0x10,%eax
  800c89:	09 f0                	or     %esi,%eax
  800c8b:	09 c2                	or     %eax,%edx
  800c8d:	89 d0                	mov    %edx,%eax
  800c8f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c91:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c94:	fc                   	cld    
  800c95:	f3 ab                	rep stos %eax,%es:(%edi)
  800c97:	eb 06                	jmp    800c9f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	fc                   	cld    
  800c9d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c9f:	89 f8                	mov    %edi,%eax
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cb4:	39 c6                	cmp    %eax,%esi
  800cb6:	73 35                	jae    800ced <memmove+0x47>
  800cb8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cbb:	39 d0                	cmp    %edx,%eax
  800cbd:	73 2e                	jae    800ced <memmove+0x47>
		s += n;
		d += n;
  800cbf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800cc2:	89 d6                	mov    %edx,%esi
  800cc4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ccc:	75 13                	jne    800ce1 <memmove+0x3b>
  800cce:	f6 c1 03             	test   $0x3,%cl
  800cd1:	75 0e                	jne    800ce1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cd3:	83 ef 04             	sub    $0x4,%edi
  800cd6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cd9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cdc:	fd                   	std    
  800cdd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdf:	eb 09                	jmp    800cea <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ce1:	83 ef 01             	sub    $0x1,%edi
  800ce4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ce7:	fd                   	std    
  800ce8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cea:	fc                   	cld    
  800ceb:	eb 1d                	jmp    800d0a <memmove+0x64>
  800ced:	89 f2                	mov    %esi,%edx
  800cef:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf1:	f6 c2 03             	test   $0x3,%dl
  800cf4:	75 0f                	jne    800d05 <memmove+0x5f>
  800cf6:	f6 c1 03             	test   $0x3,%cl
  800cf9:	75 0a                	jne    800d05 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cfb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cfe:	89 c7                	mov    %eax,%edi
  800d00:	fc                   	cld    
  800d01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d03:	eb 05                	jmp    800d0a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d05:	89 c7                	mov    %eax,%edi
  800d07:	fc                   	cld    
  800d08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 04 24             	mov    %eax,(%esp)
  800d28:	e8 79 ff ff ff       	call   800ca6 <memmove>
}
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d3e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800d41:	85 c0                	test   %eax,%eax
  800d43:	74 36                	je     800d7b <memcmp+0x4c>
		if (*s1 != *s2)
  800d45:	0f b6 03             	movzbl (%ebx),%eax
  800d48:	0f b6 0e             	movzbl (%esi),%ecx
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	38 c8                	cmp    %cl,%al
  800d52:	74 1c                	je     800d70 <memcmp+0x41>
  800d54:	eb 10                	jmp    800d66 <memcmp+0x37>
  800d56:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d5b:	83 c2 01             	add    $0x1,%edx
  800d5e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800d62:	38 c8                	cmp    %cl,%al
  800d64:	74 0a                	je     800d70 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800d66:	0f b6 c0             	movzbl %al,%eax
  800d69:	0f b6 c9             	movzbl %cl,%ecx
  800d6c:	29 c8                	sub    %ecx,%eax
  800d6e:	eb 10                	jmp    800d80 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d70:	39 fa                	cmp    %edi,%edx
  800d72:	75 e2                	jne    800d56 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d74:	b8 00 00 00 00       	mov    $0x0,%eax
  800d79:	eb 05                	jmp    800d80 <memcmp+0x51>
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	53                   	push   %ebx
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800d8f:	89 c2                	mov    %eax,%edx
  800d91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d94:	39 d0                	cmp    %edx,%eax
  800d96:	73 13                	jae    800dab <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d98:	89 d9                	mov    %ebx,%ecx
  800d9a:	38 18                	cmp    %bl,(%eax)
  800d9c:	75 06                	jne    800da4 <memfind+0x1f>
  800d9e:	eb 0b                	jmp    800dab <memfind+0x26>
  800da0:	38 08                	cmp    %cl,(%eax)
  800da2:	74 07                	je     800dab <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800da4:	83 c0 01             	add    $0x1,%eax
  800da7:	39 d0                	cmp    %edx,%eax
  800da9:	75 f5                	jne    800da0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dab:	5b                   	pop    %ebx
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dba:	0f b6 0a             	movzbl (%edx),%ecx
  800dbd:	80 f9 09             	cmp    $0x9,%cl
  800dc0:	74 05                	je     800dc7 <strtol+0x19>
  800dc2:	80 f9 20             	cmp    $0x20,%cl
  800dc5:	75 10                	jne    800dd7 <strtol+0x29>
		s++;
  800dc7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dca:	0f b6 0a             	movzbl (%edx),%ecx
  800dcd:	80 f9 09             	cmp    $0x9,%cl
  800dd0:	74 f5                	je     800dc7 <strtol+0x19>
  800dd2:	80 f9 20             	cmp    $0x20,%cl
  800dd5:	74 f0                	je     800dc7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dd7:	80 f9 2b             	cmp    $0x2b,%cl
  800dda:	75 0a                	jne    800de6 <strtol+0x38>
		s++;
  800ddc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ddf:	bf 00 00 00 00       	mov    $0x0,%edi
  800de4:	eb 11                	jmp    800df7 <strtol+0x49>
  800de6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800deb:	80 f9 2d             	cmp    $0x2d,%cl
  800dee:	75 07                	jne    800df7 <strtol+0x49>
		s++, neg = 1;
  800df0:	83 c2 01             	add    $0x1,%edx
  800df3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800df7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800dfc:	75 15                	jne    800e13 <strtol+0x65>
  800dfe:	80 3a 30             	cmpb   $0x30,(%edx)
  800e01:	75 10                	jne    800e13 <strtol+0x65>
  800e03:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e07:	75 0a                	jne    800e13 <strtol+0x65>
		s += 2, base = 16;
  800e09:	83 c2 02             	add    $0x2,%edx
  800e0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800e11:	eb 10                	jmp    800e23 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800e13:	85 c0                	test   %eax,%eax
  800e15:	75 0c                	jne    800e23 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e17:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e19:	80 3a 30             	cmpb   $0x30,(%edx)
  800e1c:	75 05                	jne    800e23 <strtol+0x75>
		s++, base = 8;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e2b:	0f b6 0a             	movzbl (%edx),%ecx
  800e2e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e31:	89 f0                	mov    %esi,%eax
  800e33:	3c 09                	cmp    $0x9,%al
  800e35:	77 08                	ja     800e3f <strtol+0x91>
			dig = *s - '0';
  800e37:	0f be c9             	movsbl %cl,%ecx
  800e3a:	83 e9 30             	sub    $0x30,%ecx
  800e3d:	eb 20                	jmp    800e5f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800e3f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	3c 19                	cmp    $0x19,%al
  800e46:	77 08                	ja     800e50 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800e48:	0f be c9             	movsbl %cl,%ecx
  800e4b:	83 e9 57             	sub    $0x57,%ecx
  800e4e:	eb 0f                	jmp    800e5f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800e50:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e53:	89 f0                	mov    %esi,%eax
  800e55:	3c 19                	cmp    $0x19,%al
  800e57:	77 16                	ja     800e6f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e59:	0f be c9             	movsbl %cl,%ecx
  800e5c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e5f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e62:	7d 0f                	jge    800e73 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e64:	83 c2 01             	add    $0x1,%edx
  800e67:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e6b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e6d:	eb bc                	jmp    800e2b <strtol+0x7d>
  800e6f:	89 d8                	mov    %ebx,%eax
  800e71:	eb 02                	jmp    800e75 <strtol+0xc7>
  800e73:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e79:	74 05                	je     800e80 <strtol+0xd2>
		*endptr = (char *) s;
  800e7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e80:	f7 d8                	neg    %eax
  800e82:	85 ff                	test   %edi,%edi
  800e84:	0f 44 c3             	cmove  %ebx,%eax
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e92:	b8 00 00 00 00       	mov    $0x0,%eax
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	89 c3                	mov    %eax,%ebx
  800e9f:	89 c7                	mov    %eax,%edi
  800ea1:	89 c6                	mov    %eax,%esi
  800ea3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    

00800eaa <sys_cgetc>:

int
sys_cgetc(void)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  800eba:	89 d1                	mov    %edx,%ecx
  800ebc:	89 d3                	mov    %edx,%ebx
  800ebe:	89 d7                	mov    %edx,%edi
  800ec0:	89 d6                	mov    %edx,%esi
  800ec2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 03 00 00 00       	mov    $0x3,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7e 28                	jle    800f13 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eef:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800f0e:	e8 3b f4 ff ff       	call   80034e <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f13:	83 c4 2c             	add    $0x2c,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 02 00 00 00       	mov    $0x2,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_yield>:

void
sys_yield(void)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f40:	ba 00 00 00 00       	mov    $0x0,%edx
  800f45:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f4a:	89 d1                	mov    %edx,%ecx
  800f4c:	89 d3                	mov    %edx,%ebx
  800f4e:	89 d7                	mov    %edx,%edi
  800f50:	89 d6                	mov    %edx,%esi
  800f52:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
  800f5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	be 00 00 00 00       	mov    $0x0,%esi
  800f67:	b8 04 00 00 00       	mov    $0x4,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f75:	89 f7                	mov    %esi,%edi
  800f77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7e 28                	jle    800fa5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f81:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f88:	00 
  800f89:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800fa0:	e8 a9 f3 ff ff       	call   80034e <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa5:	83 c4 2c             	add    $0x2c,%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb6:	b8 05 00 00 00       	mov    $0x5,%eax
  800fbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc7:	8b 75 18             	mov    0x18(%ebp),%esi
  800fca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7e 28                	jle    800ff8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fdb:	00 
  800fdc:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800feb:	00 
  800fec:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800ff3:	e8 56 f3 ff ff       	call   80034e <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff8:	83 c4 2c             	add    $0x2c,%esp
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
  801006:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801009:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100e:	b8 06 00 00 00       	mov    $0x6,%eax
  801013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 de                	mov    %ebx,%esi
  80101d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  801046:	e8 03 f3 ff ff       	call   80034e <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80104b:	83 c4 2c             	add    $0x2c,%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
  801059:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801061:	b8 08 00 00 00       	mov    $0x8,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	89 df                	mov    %ebx,%edi
  80106e:	89 de                	mov    %ebx,%esi
  801070:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 28                	jle    80109e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801076:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801081:	00 
  801082:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  801089:	00 
  80108a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801091:	00 
  801092:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  801099:	e8 b0 f2 ff ff       	call   80034e <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80109e:	83 c4 2c             	add    $0x2c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	89 df                	mov    %ebx,%edi
  8010c1:	89 de                	mov    %ebx,%esi
  8010c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	7e 28                	jle    8010f1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010cd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010d4:	00 
  8010d5:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  8010dc:	00 
  8010dd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010e4:	00 
  8010e5:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  8010ec:	e8 5d f2 ff ff       	call   80034e <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010f1:	83 c4 2c             	add    $0x2c,%esp
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801102:	bb 00 00 00 00       	mov    $0x0,%ebx
  801107:	b8 0a 00 00 00       	mov    $0xa,%eax
  80110c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
  801112:	89 df                	mov    %ebx,%edi
  801114:	89 de                	mov    %ebx,%esi
  801116:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801118:	85 c0                	test   %eax,%eax
  80111a:	7e 28                	jle    801144 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80111c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801120:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801127:	00 
  801128:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  80112f:	00 
  801130:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801137:	00 
  801138:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  80113f:	e8 0a f2 ff ff       	call   80034e <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801144:	83 c4 2c             	add    $0x2c,%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801152:	be 00 00 00 00       	mov    $0x0,%esi
  801157:	b8 0c 00 00 00       	mov    $0xc,%eax
  80115c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801165:	8b 7d 14             	mov    0x14(%ebp),%edi
  801168:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801178:	b9 00 00 00 00       	mov    $0x0,%ecx
  80117d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	89 cb                	mov    %ecx,%ebx
  801187:	89 cf                	mov    %ecx,%edi
  801189:	89 ce                	mov    %ecx,%esi
  80118b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	7e 28                	jle    8011b9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	89 44 24 10          	mov    %eax,0x10(%esp)
  801195:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80119c:	00 
  80119d:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  8011a4:	00 
  8011a5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011ac:	00 
  8011ad:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  8011b4:	e8 95 f1 ff ff       	call   80034e <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011b9:	83 c4 2c             	add    $0x2c,%esp
  8011bc:	5b                   	pop    %ebx
  8011bd:	5e                   	pop    %esi
  8011be:	5f                   	pop    %edi
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 24             	sub    $0x24,%esp
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011cb:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  8011cd:	89 da                	mov    %ebx,%edx
  8011cf:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  8011d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  8011d9:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011dd:	74 05                	je     8011e4 <pgfault+0x23>
  8011df:	f6 c6 08             	test   $0x8,%dh
  8011e2:	75 1c                	jne    801200 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  8011e4:	c7 44 24 08 6c 2b 80 	movl   $0x802b6c,0x8(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8011f3:	00 
  8011f4:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8011fb:	e8 4e f1 ff ff       	call   80034e <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801200:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801207:	00 
  801208:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80120f:	00 
  801210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801217:	e8 3d fd ff ff       	call   800f59 <sys_page_alloc>
  80121c:	85 c0                	test   %eax,%eax
  80121e:	79 20                	jns    801240 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801224:	c7 44 24 08 d4 2b 80 	movl   $0x802bd4,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  80123b:	e8 0e f1 ff ff       	call   80034e <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801240:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801246:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80124d:	00 
  80124e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801252:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801259:	e8 48 fa ff ff       	call   800ca6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  80125e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801265:	00 
  801266:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80126a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801271:	00 
  801272:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801279:	00 
  80127a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801281:	e8 27 fd ff ff       	call   800fad <sys_page_map>
  801286:	85 c0                	test   %eax,%eax
  801288:	79 20                	jns    8012aa <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80128a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80128e:	c7 44 24 08 ee 2b 80 	movl   $0x802bee,0x8(%esp)
  801295:	00 
  801296:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80129d:	00 
  80129e:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8012a5:	e8 a4 f0 ff ff       	call   80034e <_panic>
	}
}
  8012aa:	83 c4 24             	add    $0x24,%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  8012b9:	c7 04 24 c1 11 80 00 	movl   $0x8011c1,(%esp)
  8012c0:	e8 f1 0f 00 00       	call   8022b6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012c5:	b8 07 00 00 00       	mov    $0x7,%eax
  8012ca:	cd 30                	int    $0x30
  8012cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	79 1c                	jns    8012ef <fork+0x3f>
		panic("fork");
  8012d3:	c7 44 24 08 07 2c 80 	movl   $0x802c07,0x8(%esp)
  8012da:	00 
  8012db:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  8012e2:	00 
  8012e3:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8012ea:	e8 5f f0 ff ff       	call   80034e <_panic>
  8012ef:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  8012f1:	bb 00 08 00 00       	mov    $0x800,%ebx
  8012f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012fa:	75 21                	jne    80131d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  8012fc:	e8 1a fc ff ff       	call   800f1b <sys_getenvid>
  801301:	25 ff 03 00 00       	and    $0x3ff,%eax
  801306:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801309:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
  801318:	e9 c5 01 00 00       	jmp    8014e2 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80131d:	89 d8                	mov    %ebx,%eax
  80131f:	c1 e8 0a             	shr    $0xa,%eax
  801322:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801329:	a8 01                	test   $0x1,%al
  80132b:	0f 84 f2 00 00 00    	je     801423 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801331:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801338:	a8 05                	test   $0x5,%al
  80133a:	0f 84 e3 00 00 00    	je     801423 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801340:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801347:	89 de                	mov    %ebx,%esi
  801349:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  80134c:	a9 02 08 00 00       	test   $0x802,%eax
  801351:	0f 84 88 00 00 00    	je     8013df <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801357:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80135e:	00 
  80135f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801363:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801367:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801372:	e8 36 fc ff ff       	call   800fad <sys_page_map>
  801377:	85 c0                	test   %eax,%eax
  801379:	79 20                	jns    80139b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80137b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137f:	c7 44 24 08 0c 2c 80 	movl   $0x802c0c,0x8(%esp)
  801386:	00 
  801387:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80138e:	00 
  80138f:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  801396:	e8 b3 ef ff ff       	call   80034e <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80139b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013a2:	00 
  8013a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013ae:	00 
  8013af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b3:	89 3c 24             	mov    %edi,(%esp)
  8013b6:	e8 f2 fb ff ff       	call   800fad <sys_page_map>
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	79 64                	jns    801423 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  8013bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c3:	c7 44 24 08 26 2c 80 	movl   $0x802c26,0x8(%esp)
  8013ca:	00 
  8013cb:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8013d2:	00 
  8013d3:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8013da:	e8 6f ef ff ff       	call   80034e <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8013df:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8013e6:	00 
  8013e7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fa:	e8 ae fb ff ff       	call   800fad <sys_page_map>
  8013ff:	85 c0                	test   %eax,%eax
  801401:	79 20                	jns    801423 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801407:	c7 44 24 08 40 2c 80 	movl   $0x802c40,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  80141e:	e8 2b ef ff ff       	call   80034e <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801423:	83 c3 01             	add    $0x1,%ebx
  801426:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80142c:	0f 85 eb fe ff ff    	jne    80131d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801432:	c7 44 24 04 1f 23 80 	movl   $0x80231f,0x4(%esp)
  801439:	00 
  80143a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143d:	89 04 24             	mov    %eax,(%esp)
  801440:	e8 b4 fc ff ff       	call   8010f9 <sys_env_set_pgfault_upcall>
  801445:	85 c0                	test   %eax,%eax
  801447:	79 20                	jns    801469 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801449:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144d:	c7 44 24 08 a4 2b 80 	movl   $0x802ba4,0x8(%esp)
  801454:	00 
  801455:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80145c:	00 
  80145d:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  801464:	e8 e5 ee ff ff       	call   80034e <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801469:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801470:	00 
  801471:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801478:	ee 
  801479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147c:	89 04 24             	mov    %eax,(%esp)
  80147f:	e8 d5 fa ff ff       	call   800f59 <sys_page_alloc>
  801484:	85 c0                	test   %eax,%eax
  801486:	79 20                	jns    8014a8 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801488:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80148c:	c7 44 24 08 52 2c 80 	movl   $0x802c52,0x8(%esp)
  801493:	00 
  801494:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80149b:	00 
  80149c:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8014a3:	e8 a6 ee ff ff       	call   80034e <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  8014a8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014af:	00 
  8014b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b3:	89 04 24             	mov    %eax,(%esp)
  8014b6:	e8 98 fb ff ff       	call   801053 <sys_env_set_status>
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	79 20                	jns    8014df <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  8014bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c3:	c7 44 24 08 6a 2c 80 	movl   $0x802c6a,0x8(%esp)
  8014ca:	00 
  8014cb:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  8014d2:	00 
  8014d3:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8014da:	e8 6f ee ff ff       	call   80034e <_panic>
	}

	return envid;
  8014df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8014e2:	83 c4 2c             	add    $0x2c,%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <sfork>:

// Challenge!
int
sfork(void)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014f0:	c7 44 24 08 85 2c 80 	movl   $0x802c85,0x8(%esp)
  8014f7:	00 
  8014f8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  8014ff:	00 
  801500:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  801507:	e8 42 ee ff ff       	call   80034e <_panic>
  80150c:	66 90                	xchg   %ax,%ax
  80150e:	66 90                	xchg   %ax,%ax

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80152b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801530:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80153a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80153f:	a8 01                	test   $0x1,%al
  801541:	74 34                	je     801577 <fd_alloc+0x40>
  801543:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801548:	a8 01                	test   $0x1,%al
  80154a:	74 32                	je     80157e <fd_alloc+0x47>
  80154c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801551:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 16             	shr    $0x16,%edx
  801558:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 1f                	je     801583 <fd_alloc+0x4c>
  801564:	89 c2                	mov    %eax,%edx
  801566:	c1 ea 0c             	shr    $0xc,%edx
  801569:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801570:	f6 c2 01             	test   $0x1,%dl
  801573:	75 1a                	jne    80158f <fd_alloc+0x58>
  801575:	eb 0c                	jmp    801583 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801577:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80157c:	eb 05                	jmp    801583 <fd_alloc+0x4c>
  80157e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 08                	mov    %ecx,(%eax)
			return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 1a                	jmp    8015a9 <fd_alloc+0x72>
  80158f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801594:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801599:	75 b6                	jne    801551 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015a4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    

008015ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015b1:	83 f8 1f             	cmp    $0x1f,%eax
  8015b4:	77 36                	ja     8015ec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015b6:	c1 e0 0c             	shl    $0xc,%eax
  8015b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015be:	89 c2                	mov    %eax,%edx
  8015c0:	c1 ea 16             	shr    $0x16,%edx
  8015c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015ca:	f6 c2 01             	test   $0x1,%dl
  8015cd:	74 24                	je     8015f3 <fd_lookup+0x48>
  8015cf:	89 c2                	mov    %eax,%edx
  8015d1:	c1 ea 0c             	shr    $0xc,%edx
  8015d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015db:	f6 c2 01             	test   $0x1,%dl
  8015de:	74 1a                	je     8015fa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb 13                	jmp    8015ff <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f1:	eb 0c                	jmp    8015ff <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f8:	eb 05                	jmp    8015ff <fd_lookup+0x54>
  8015fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    

00801601 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	53                   	push   %ebx
  801605:	83 ec 14             	sub    $0x14,%esp
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80160e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801614:	75 1e                	jne    801634 <dev_lookup+0x33>
  801616:	eb 0e                	jmp    801626 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801618:	b8 20 30 80 00       	mov    $0x803020,%eax
  80161d:	eb 0c                	jmp    80162b <dev_lookup+0x2a>
  80161f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801624:	eb 05                	jmp    80162b <dev_lookup+0x2a>
  801626:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80162b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80162d:	b8 00 00 00 00       	mov    $0x0,%eax
  801632:	eb 38                	jmp    80166c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801634:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80163a:	74 dc                	je     801618 <dev_lookup+0x17>
  80163c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801642:	74 db                	je     80161f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801644:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80164a:	8b 52 48             	mov    0x48(%edx),%edx
  80164d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801651:	89 54 24 04          	mov    %edx,0x4(%esp)
  801655:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  80165c:	e8 e6 ed ff ff       	call   800447 <cprintf>
	*dev = 0;
  801661:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80166c:	83 c4 14             	add    $0x14,%esp
  80166f:	5b                   	pop    %ebx
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
  801677:	83 ec 20             	sub    $0x20,%esp
  80167a:	8b 75 08             	mov    0x8(%ebp),%esi
  80167d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801680:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801683:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801687:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80168d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 13 ff ff ff       	call   8015ab <fd_lookup>
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 05                	js     8016a1 <fd_close+0x2f>
	    || fd != fd2)
  80169c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80169f:	74 0c                	je     8016ad <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016a1:	84 db                	test   %bl,%bl
  8016a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a8:	0f 44 c2             	cmove  %edx,%eax
  8016ab:	eb 3f                	jmp    8016ec <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	8b 06                	mov    (%esi),%eax
  8016b6:	89 04 24             	mov    %eax,(%esp)
  8016b9:	e8 43 ff ff ff       	call   801601 <dev_lookup>
  8016be:	89 c3                	mov    %eax,%ebx
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 16                	js     8016da <fd_close+0x68>
		if (dev->dev_close)
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	74 07                	je     8016da <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016d3:	89 34 24             	mov    %esi,(%esp)
  8016d6:	ff d0                	call   *%eax
  8016d8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e5:	e8 16 f9 ff ff       	call   801000 <sys_page_unmap>
	return r;
  8016ea:	89 d8                	mov    %ebx,%eax
}
  8016ec:	83 c4 20             	add    $0x20,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	89 04 24             	mov    %eax,(%esp)
  801706:	e8 a0 fe ff ff       	call   8015ab <fd_lookup>
  80170b:	89 c2                	mov    %eax,%edx
  80170d:	85 d2                	test   %edx,%edx
  80170f:	78 13                	js     801724 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801711:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801718:	00 
  801719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171c:	89 04 24             	mov    %eax,(%esp)
  80171f:	e8 4e ff ff ff       	call   801672 <fd_close>
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <close_all>:

void
close_all(void)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	53                   	push   %ebx
  80172a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80172d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801732:	89 1c 24             	mov    %ebx,(%esp)
  801735:	e8 b9 ff ff ff       	call   8016f3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80173a:	83 c3 01             	add    $0x1,%ebx
  80173d:	83 fb 20             	cmp    $0x20,%ebx
  801740:	75 f0                	jne    801732 <close_all+0xc>
		close(i);
}
  801742:	83 c4 14             	add    $0x14,%esp
  801745:	5b                   	pop    %ebx
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	57                   	push   %edi
  80174c:	56                   	push   %esi
  80174d:	53                   	push   %ebx
  80174e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801751:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801754:	89 44 24 04          	mov    %eax,0x4(%esp)
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	89 04 24             	mov    %eax,(%esp)
  80175e:	e8 48 fe ff ff       	call   8015ab <fd_lookup>
  801763:	89 c2                	mov    %eax,%edx
  801765:	85 d2                	test   %edx,%edx
  801767:	0f 88 e1 00 00 00    	js     80184e <dup+0x106>
		return r;
	close(newfdnum);
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 04 24             	mov    %eax,(%esp)
  801773:	e8 7b ff ff ff       	call   8016f3 <close>

	newfd = INDEX2FD(newfdnum);
  801778:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80177b:	c1 e3 0c             	shl    $0xc,%ebx
  80177e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801787:	89 04 24             	mov    %eax,(%esp)
  80178a:	e8 91 fd ff ff       	call   801520 <fd2data>
  80178f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801791:	89 1c 24             	mov    %ebx,(%esp)
  801794:	e8 87 fd ff ff       	call   801520 <fd2data>
  801799:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80179b:	89 f0                	mov    %esi,%eax
  80179d:	c1 e8 16             	shr    $0x16,%eax
  8017a0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017a7:	a8 01                	test   $0x1,%al
  8017a9:	74 43                	je     8017ee <dup+0xa6>
  8017ab:	89 f0                	mov    %esi,%eax
  8017ad:	c1 e8 0c             	shr    $0xc,%eax
  8017b0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017b7:	f6 c2 01             	test   $0x1,%dl
  8017ba:	74 32                	je     8017ee <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8017c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017d7:	00 
  8017d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e3:	e8 c5 f7 ff ff       	call   800fad <sys_page_map>
  8017e8:	89 c6                	mov    %eax,%esi
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 3e                	js     80182c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f1:	89 c2                	mov    %eax,%edx
  8017f3:	c1 ea 0c             	shr    $0xc,%edx
  8017f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017fd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801803:	89 54 24 10          	mov    %edx,0x10(%esp)
  801807:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80180b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801812:	00 
  801813:	89 44 24 04          	mov    %eax,0x4(%esp)
  801817:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181e:	e8 8a f7 ff ff       	call   800fad <sys_page_map>
  801823:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801825:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801828:	85 f6                	test   %esi,%esi
  80182a:	79 22                	jns    80184e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80182c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801837:	e8 c4 f7 ff ff       	call   801000 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80183c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801847:	e8 b4 f7 ff ff       	call   801000 <sys_page_unmap>
	return r;
  80184c:	89 f0                	mov    %esi,%eax
}
  80184e:	83 c4 3c             	add    $0x3c,%esp
  801851:	5b                   	pop    %ebx
  801852:	5e                   	pop    %esi
  801853:	5f                   	pop    %edi
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 24             	sub    $0x24,%esp
  80185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801860:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801863:	89 44 24 04          	mov    %eax,0x4(%esp)
  801867:	89 1c 24             	mov    %ebx,(%esp)
  80186a:	e8 3c fd ff ff       	call   8015ab <fd_lookup>
  80186f:	89 c2                	mov    %eax,%edx
  801871:	85 d2                	test   %edx,%edx
  801873:	78 6d                	js     8018e2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187f:	8b 00                	mov    (%eax),%eax
  801881:	89 04 24             	mov    %eax,(%esp)
  801884:	e8 78 fd ff ff       	call   801601 <dev_lookup>
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 55                	js     8018e2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	8b 50 08             	mov    0x8(%eax),%edx
  801893:	83 e2 03             	and    $0x3,%edx
  801896:	83 fa 01             	cmp    $0x1,%edx
  801899:	75 23                	jne    8018be <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80189b:	a1 04 40 80 00       	mov    0x804004,%eax
  8018a0:	8b 40 48             	mov    0x48(%eax),%eax
  8018a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ab:	c7 04 24 dd 2c 80 00 	movl   $0x802cdd,(%esp)
  8018b2:	e8 90 eb ff ff       	call   800447 <cprintf>
		return -E_INVAL;
  8018b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bc:	eb 24                	jmp    8018e2 <read+0x8c>
	}
	if (!dev->dev_read)
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 52 08             	mov    0x8(%edx),%edx
  8018c4:	85 d2                	test   %edx,%edx
  8018c6:	74 15                	je     8018dd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	ff d2                	call   *%edx
  8018db:	eb 05                	jmp    8018e2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018e2:	83 c4 24             	add    $0x24,%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	57                   	push   %edi
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	83 ec 1c             	sub    $0x1c,%esp
  8018f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018f7:	85 f6                	test   %esi,%esi
  8018f9:	74 33                	je     80192e <readn+0x46>
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801905:	89 f2                	mov    %esi,%edx
  801907:	29 c2                	sub    %eax,%edx
  801909:	89 54 24 08          	mov    %edx,0x8(%esp)
  80190d:	03 45 0c             	add    0xc(%ebp),%eax
  801910:	89 44 24 04          	mov    %eax,0x4(%esp)
  801914:	89 3c 24             	mov    %edi,(%esp)
  801917:	e8 3a ff ff ff       	call   801856 <read>
		if (m < 0)
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 1b                	js     80193b <readn+0x53>
			return m;
		if (m == 0)
  801920:	85 c0                	test   %eax,%eax
  801922:	74 11                	je     801935 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801924:	01 c3                	add    %eax,%ebx
  801926:	89 d8                	mov    %ebx,%eax
  801928:	39 f3                	cmp    %esi,%ebx
  80192a:	72 d9                	jb     801905 <readn+0x1d>
  80192c:	eb 0b                	jmp    801939 <readn+0x51>
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	eb 06                	jmp    80193b <readn+0x53>
  801935:	89 d8                	mov    %ebx,%eax
  801937:	eb 02                	jmp    80193b <readn+0x53>
  801939:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80193b:	83 c4 1c             	add    $0x1c,%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	53                   	push   %ebx
  801947:	83 ec 24             	sub    $0x24,%esp
  80194a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801950:	89 44 24 04          	mov    %eax,0x4(%esp)
  801954:	89 1c 24             	mov    %ebx,(%esp)
  801957:	e8 4f fc ff ff       	call   8015ab <fd_lookup>
  80195c:	89 c2                	mov    %eax,%edx
  80195e:	85 d2                	test   %edx,%edx
  801960:	78 68                	js     8019ca <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801962:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801965:	89 44 24 04          	mov    %eax,0x4(%esp)
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	e8 8b fc ff ff       	call   801601 <dev_lookup>
  801976:	85 c0                	test   %eax,%eax
  801978:	78 50                	js     8019ca <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801981:	75 23                	jne    8019a6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801983:	a1 04 40 80 00       	mov    0x804004,%eax
  801988:	8b 40 48             	mov    0x48(%eax),%eax
  80198b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801993:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  80199a:	e8 a8 ea ff ff       	call   800447 <cprintf>
		return -E_INVAL;
  80199f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a4:	eb 24                	jmp    8019ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	74 15                	je     8019c5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019be:	89 04 24             	mov    %eax,(%esp)
  8019c1:	ff d2                	call   *%edx
  8019c3:	eb 05                	jmp    8019ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019ca:	83 c4 24             	add    $0x24,%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	89 04 24             	mov    %eax,(%esp)
  8019e3:	e8 c3 fb ff ff       	call   8015ab <fd_lookup>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 0e                	js     8019fa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 24             	sub    $0x24,%esp
  801a03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0d:	89 1c 24             	mov    %ebx,(%esp)
  801a10:	e8 96 fb ff ff       	call   8015ab <fd_lookup>
  801a15:	89 c2                	mov    %eax,%edx
  801a17:	85 d2                	test   %edx,%edx
  801a19:	78 61                	js     801a7c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	89 04 24             	mov    %eax,(%esp)
  801a2a:	e8 d2 fb ff ff       	call   801601 <dev_lookup>
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 49                	js     801a7c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a36:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3a:	75 23                	jne    801a5f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a3c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a41:	8b 40 48             	mov    0x48(%eax),%eax
  801a44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4c:	c7 04 24 bc 2c 80 00 	movl   $0x802cbc,(%esp)
  801a53:	e8 ef e9 ff ff       	call   800447 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5d:	eb 1d                	jmp    801a7c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a62:	8b 52 18             	mov    0x18(%edx),%edx
  801a65:	85 d2                	test   %edx,%edx
  801a67:	74 0e                	je     801a77 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a70:	89 04 24             	mov    %eax,(%esp)
  801a73:	ff d2                	call   *%edx
  801a75:	eb 05                	jmp    801a7c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a7c:	83 c4 24             	add    $0x24,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    

00801a82 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	53                   	push   %ebx
  801a86:	83 ec 24             	sub    $0x24,%esp
  801a89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 0d fb ff ff       	call   8015ab <fd_lookup>
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	85 d2                	test   %edx,%edx
  801aa2:	78 52                	js     801af6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aae:	8b 00                	mov    (%eax),%eax
  801ab0:	89 04 24             	mov    %eax,(%esp)
  801ab3:	e8 49 fb ff ff       	call   801601 <dev_lookup>
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	78 3a                	js     801af6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ac3:	74 2c                	je     801af1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ac5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ac8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801acf:	00 00 00 
	stat->st_isdir = 0;
  801ad2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad9:	00 00 00 
	stat->st_dev = dev;
  801adc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ae2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae9:	89 14 24             	mov    %edx,(%esp)
  801aec:	ff 50 14             	call   *0x14(%eax)
  801aef:	eb 05                	jmp    801af6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801af1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801af6:	83 c4 24             	add    $0x24,%esp
  801af9:	5b                   	pop    %ebx
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    

00801afc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	56                   	push   %esi
  801b00:	53                   	push   %ebx
  801b01:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b0b:	00 
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	89 04 24             	mov    %eax,(%esp)
  801b12:	e8 af 01 00 00       	call   801cc6 <open>
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	85 db                	test   %ebx,%ebx
  801b1b:	78 1b                	js     801b38 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b24:	89 1c 24             	mov    %ebx,(%esp)
  801b27:	e8 56 ff ff ff       	call   801a82 <fstat>
  801b2c:	89 c6                	mov    %eax,%esi
	close(fd);
  801b2e:	89 1c 24             	mov    %ebx,(%esp)
  801b31:	e8 bd fb ff ff       	call   8016f3 <close>
	return r;
  801b36:	89 f0                	mov    %esi,%eax
}
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 10             	sub    $0x10,%esp
  801b47:	89 c6                	mov    %eax,%esi
  801b49:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b4b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b52:	75 11                	jne    801b65 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b5b:	e8 e0 08 00 00       	call   802440 <ipc_find_env>
  801b60:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b65:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b6c:	00 
  801b6d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801b74:	00 
  801b75:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b79:	a1 00 40 80 00       	mov    0x804000,%eax
  801b7e:	89 04 24             	mov    %eax,(%esp)
  801b81:	e8 54 08 00 00       	call   8023da <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b8d:	00 
  801b8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b99:	e8 d2 07 00 00       	call   802370 <ipc_recv>
}
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    

00801ba5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 14             	sub    $0x14,%esp
  801bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc4:	e8 76 ff ff ff       	call   801b3f <fsipc>
  801bc9:	89 c2                	mov    %eax,%edx
  801bcb:	85 d2                	test   %edx,%edx
  801bcd:	78 2b                	js     801bfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bcf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801bd6:	00 
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 cc ee ff ff       	call   800aab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bdf:	a1 80 50 80 00       	mov    0x805080,%eax
  801be4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bea:	a1 84 50 80 00       	mov    0x805084,%eax
  801bef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	83 c4 14             	add    $0x14,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c11:	ba 00 00 00 00       	mov    $0x0,%edx
  801c16:	b8 06 00 00 00       	mov    $0x6,%eax
  801c1b:	e8 1f ff ff ff       	call   801b3f <fsipc>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	56                   	push   %esi
  801c26:	53                   	push   %ebx
  801c27:	83 ec 10             	sub    $0x10,%esp
  801c2a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c38:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	b8 03 00 00 00       	mov    $0x3,%eax
  801c48:	e8 f2 fe ff ff       	call   801b3f <fsipc>
  801c4d:	89 c3                	mov    %eax,%ebx
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	78 6a                	js     801cbd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c53:	39 c6                	cmp    %eax,%esi
  801c55:	73 24                	jae    801c7b <devfile_read+0x59>
  801c57:	c7 44 24 0c 16 2d 80 	movl   $0x802d16,0xc(%esp)
  801c5e:	00 
  801c5f:	c7 44 24 08 1d 2d 80 	movl   $0x802d1d,0x8(%esp)
  801c66:	00 
  801c67:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801c6e:	00 
  801c6f:	c7 04 24 32 2d 80 00 	movl   $0x802d32,(%esp)
  801c76:	e8 d3 e6 ff ff       	call   80034e <_panic>
	assert(r <= PGSIZE);
  801c7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c80:	7e 24                	jle    801ca6 <devfile_read+0x84>
  801c82:	c7 44 24 0c 3d 2d 80 	movl   $0x802d3d,0xc(%esp)
  801c89:	00 
  801c8a:	c7 44 24 08 1d 2d 80 	movl   $0x802d1d,0x8(%esp)
  801c91:	00 
  801c92:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801c99:	00 
  801c9a:	c7 04 24 32 2d 80 00 	movl   $0x802d32,(%esp)
  801ca1:	e8 a8 e6 ff ff       	call   80034e <_panic>
	memmove(buf, &fsipcbuf, r);
  801ca6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801caa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801cb1:	00 
  801cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb5:	89 04 24             	mov    %eax,(%esp)
  801cb8:	e8 e9 ef ff ff       	call   800ca6 <memmove>
	return r;
}
  801cbd:	89 d8                	mov    %ebx,%eax
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5d                   	pop    %ebp
  801cc5:	c3                   	ret    

00801cc6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	53                   	push   %ebx
  801cca:	83 ec 24             	sub    $0x24,%esp
  801ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cd0:	89 1c 24             	mov    %ebx,(%esp)
  801cd3:	e8 78 ed ff ff       	call   800a50 <strlen>
  801cd8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cdd:	7f 60                	jg     801d3f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cdf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce2:	89 04 24             	mov    %eax,(%esp)
  801ce5:	e8 4d f8 ff ff       	call   801537 <fd_alloc>
  801cea:	89 c2                	mov    %eax,%edx
  801cec:	85 d2                	test   %edx,%edx
  801cee:	78 54                	js     801d44 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cf0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cf4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801cfb:	e8 ab ed ff ff       	call   800aab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d10:	e8 2a fe ff ff       	call   801b3f <fsipc>
  801d15:	89 c3                	mov    %eax,%ebx
  801d17:	85 c0                	test   %eax,%eax
  801d19:	79 17                	jns    801d32 <open+0x6c>
		fd_close(fd, 0);
  801d1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d22:	00 
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	89 04 24             	mov    %eax,(%esp)
  801d29:	e8 44 f9 ff ff       	call   801672 <fd_close>
		return r;
  801d2e:	89 d8                	mov    %ebx,%eax
  801d30:	eb 12                	jmp    801d44 <open+0x7e>
	}

	return fd2num(fd);
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	89 04 24             	mov    %eax,(%esp)
  801d38:	e8 d3 f7 ff ff       	call   801510 <fd2num>
  801d3d:	eb 05                	jmp    801d44 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d3f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d44:	83 c4 24             	add    $0x24,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	66 90                	xchg   %ax,%ax
  801d4e:	66 90                	xchg   %ax,%ax

00801d50 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	83 ec 10             	sub    $0x10,%esp
  801d58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	89 04 24             	mov    %eax,(%esp)
  801d61:	e8 ba f7 ff ff       	call   801520 <fd2data>
  801d66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d68:	c7 44 24 04 49 2d 80 	movl   $0x802d49,0x4(%esp)
  801d6f:	00 
  801d70:	89 1c 24             	mov    %ebx,(%esp)
  801d73:	e8 33 ed ff ff       	call   800aab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d78:	8b 46 04             	mov    0x4(%esi),%eax
  801d7b:	2b 06                	sub    (%esi),%eax
  801d7d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d8a:	00 00 00 
	stat->st_dev = &devpipe;
  801d8d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d94:	30 80 00 
	return 0;
}
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	53                   	push   %ebx
  801da7:	83 ec 14             	sub    $0x14,%esp
  801daa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db8:	e8 43 f2 ff ff       	call   801000 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dbd:	89 1c 24             	mov    %ebx,(%esp)
  801dc0:	e8 5b f7 ff ff       	call   801520 <fd2data>
  801dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd0:	e8 2b f2 ff ff       	call   801000 <sys_page_unmap>
}
  801dd5:	83 c4 14             	add    $0x14,%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	57                   	push   %edi
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	83 ec 2c             	sub    $0x2c,%esp
  801de4:	89 c6                	mov    %eax,%esi
  801de6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801de9:	a1 04 40 80 00       	mov    0x804004,%eax
  801dee:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801df1:	89 34 24             	mov    %esi,(%esp)
  801df4:	e8 8f 06 00 00       	call   802488 <pageref>
  801df9:	89 c7                	mov    %eax,%edi
  801dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 82 06 00 00       	call   802488 <pageref>
  801e06:	39 c7                	cmp    %eax,%edi
  801e08:	0f 94 c2             	sete   %dl
  801e0b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e0e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801e14:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e17:	39 fb                	cmp    %edi,%ebx
  801e19:	74 21                	je     801e3c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e1b:	84 d2                	test   %dl,%dl
  801e1d:	74 ca                	je     801de9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e1f:	8b 51 58             	mov    0x58(%ecx),%edx
  801e22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e2e:	c7 04 24 50 2d 80 00 	movl   $0x802d50,(%esp)
  801e35:	e8 0d e6 ff ff       	call   800447 <cprintf>
  801e3a:	eb ad                	jmp    801de9 <_pipeisclosed+0xe>
	}
}
  801e3c:	83 c4 2c             	add    $0x2c,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5f                   	pop    %edi
  801e42:	5d                   	pop    %ebp
  801e43:	c3                   	ret    

00801e44 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	57                   	push   %edi
  801e48:	56                   	push   %esi
  801e49:	53                   	push   %ebx
  801e4a:	83 ec 1c             	sub    $0x1c,%esp
  801e4d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e50:	89 34 24             	mov    %esi,(%esp)
  801e53:	e8 c8 f6 ff ff       	call   801520 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e5c:	74 61                	je     801ebf <devpipe_write+0x7b>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	bf 00 00 00 00       	mov    $0x0,%edi
  801e65:	eb 4a                	jmp    801eb1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e67:	89 da                	mov    %ebx,%edx
  801e69:	89 f0                	mov    %esi,%eax
  801e6b:	e8 6b ff ff ff       	call   801ddb <_pipeisclosed>
  801e70:	85 c0                	test   %eax,%eax
  801e72:	75 54                	jne    801ec8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e74:	e8 c1 f0 ff ff       	call   800f3a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e79:	8b 43 04             	mov    0x4(%ebx),%eax
  801e7c:	8b 0b                	mov    (%ebx),%ecx
  801e7e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e81:	39 d0                	cmp    %edx,%eax
  801e83:	73 e2                	jae    801e67 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e88:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e8c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e8f:	99                   	cltd   
  801e90:	c1 ea 1b             	shr    $0x1b,%edx
  801e93:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e96:	83 e1 1f             	and    $0x1f,%ecx
  801e99:	29 d1                	sub    %edx,%ecx
  801e9b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e9f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ea3:	83 c0 01             	add    $0x1,%eax
  801ea6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea9:	83 c7 01             	add    $0x1,%edi
  801eac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eaf:	74 13                	je     801ec4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb1:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb4:	8b 0b                	mov    (%ebx),%ecx
  801eb6:	8d 51 20             	lea    0x20(%ecx),%edx
  801eb9:	39 d0                	cmp    %edx,%eax
  801ebb:	73 aa                	jae    801e67 <devpipe_write+0x23>
  801ebd:	eb c6                	jmp    801e85 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ebf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ec4:	89 f8                	mov    %edi,%eax
  801ec6:	eb 05                	jmp    801ecd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ecd:	83 c4 1c             	add    $0x1c,%esp
  801ed0:	5b                   	pop    %ebx
  801ed1:	5e                   	pop    %esi
  801ed2:	5f                   	pop    %edi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    

00801ed5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	57                   	push   %edi
  801ed9:	56                   	push   %esi
  801eda:	53                   	push   %ebx
  801edb:	83 ec 1c             	sub    $0x1c,%esp
  801ede:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ee1:	89 3c 24             	mov    %edi,(%esp)
  801ee4:	e8 37 f6 ff ff       	call   801520 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ee9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eed:	74 54                	je     801f43 <devpipe_read+0x6e>
  801eef:	89 c3                	mov    %eax,%ebx
  801ef1:	be 00 00 00 00       	mov    $0x0,%esi
  801ef6:	eb 3e                	jmp    801f36 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ef8:	89 f0                	mov    %esi,%eax
  801efa:	eb 55                	jmp    801f51 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801efc:	89 da                	mov    %ebx,%edx
  801efe:	89 f8                	mov    %edi,%eax
  801f00:	e8 d6 fe ff ff       	call   801ddb <_pipeisclosed>
  801f05:	85 c0                	test   %eax,%eax
  801f07:	75 43                	jne    801f4c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f09:	e8 2c f0 ff ff       	call   800f3a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f0e:	8b 03                	mov    (%ebx),%eax
  801f10:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f13:	74 e7                	je     801efc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f15:	99                   	cltd   
  801f16:	c1 ea 1b             	shr    $0x1b,%edx
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	83 e0 1f             	and    $0x1f,%eax
  801f1e:	29 d0                	sub    %edx,%eax
  801f20:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f28:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f2b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f2e:	83 c6 01             	add    $0x1,%esi
  801f31:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f34:	74 12                	je     801f48 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801f36:	8b 03                	mov    (%ebx),%eax
  801f38:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f3b:	75 d8                	jne    801f15 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f3d:	85 f6                	test   %esi,%esi
  801f3f:	75 b7                	jne    801ef8 <devpipe_read+0x23>
  801f41:	eb b9                	jmp    801efc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f43:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f48:	89 f0                	mov    %esi,%eax
  801f4a:	eb 05                	jmp    801f51 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f51:	83 c4 1c             	add    $0x1c,%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f64:	89 04 24             	mov    %eax,(%esp)
  801f67:	e8 cb f5 ff ff       	call   801537 <fd_alloc>
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	85 d2                	test   %edx,%edx
  801f70:	0f 88 4d 01 00 00    	js     8020c3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f7d:	00 
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8c:	e8 c8 ef ff ff       	call   800f59 <sys_page_alloc>
  801f91:	89 c2                	mov    %eax,%edx
  801f93:	85 d2                	test   %edx,%edx
  801f95:	0f 88 28 01 00 00    	js     8020c3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f9e:	89 04 24             	mov    %eax,(%esp)
  801fa1:	e8 91 f5 ff ff       	call   801537 <fd_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	0f 88 fe 00 00 00    	js     8020ae <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb7:	00 
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 8e ef ff ff       	call   800f59 <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	0f 88 d9 00 00 00    	js     8020ae <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	89 04 24             	mov    %eax,(%esp)
  801fdb:	e8 40 f5 ff ff       	call   801520 <fd2data>
  801fe0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fe9:	00 
  801fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff5:	e8 5f ef ff ff       	call   800f59 <sys_page_alloc>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	0f 88 97 00 00 00    	js     80209b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802007:	89 04 24             	mov    %eax,(%esp)
  80200a:	e8 11 f5 ff ff       	call   801520 <fd2data>
  80200f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802016:	00 
  802017:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80201b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802022:	00 
  802023:	89 74 24 04          	mov    %esi,0x4(%esp)
  802027:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202e:	e8 7a ef ff ff       	call   800fad <sys_page_map>
  802033:	89 c3                	mov    %eax,%ebx
  802035:	85 c0                	test   %eax,%eax
  802037:	78 52                	js     80208b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802039:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80204e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	89 04 24             	mov    %eax,(%esp)
  802069:	e8 a2 f4 ff ff       	call   801510 <fd2num>
  80206e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802071:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 92 f4 ff ff       	call   801510 <fd2num>
  80207e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802081:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	eb 38                	jmp    8020c3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80208b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80208f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802096:	e8 65 ef ff ff       	call   801000 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a9:	e8 52 ef ff ff       	call   801000 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020bc:	e8 3f ef ff ff       	call   801000 <sys_page_unmap>
  8020c1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020c3:	83 c4 30             	add    $0x30,%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5e                   	pop    %esi
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	89 04 24             	mov    %eax,(%esp)
  8020dd:	e8 c9 f4 ff ff       	call   8015ab <fd_lookup>
  8020e2:	89 c2                	mov    %eax,%edx
  8020e4:	85 d2                	test   %edx,%edx
  8020e6:	78 15                	js     8020fd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	89 04 24             	mov    %eax,(%esp)
  8020ee:	e8 2d f4 ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  8020f3:	89 c2                	mov    %eax,%edx
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	e8 de fc ff ff       	call   801ddb <_pipeisclosed>
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    
  8020ff:	90                   	nop

00802100 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    

0080210a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802110:	c7 44 24 04 63 2d 80 	movl   $0x802d63,0x4(%esp)
  802117:	00 
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 88 e9 ff ff       	call   800aab <strcpy>
	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213a:	74 4a                	je     802186 <devcons_write+0x5c>
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
  802141:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802146:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80214c:	8b 75 10             	mov    0x10(%ebp),%esi
  80214f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802151:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802154:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802159:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80215c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802160:	03 45 0c             	add    0xc(%ebp),%eax
  802163:	89 44 24 04          	mov    %eax,0x4(%esp)
  802167:	89 3c 24             	mov    %edi,(%esp)
  80216a:	e8 37 eb ff ff       	call   800ca6 <memmove>
		sys_cputs(buf, m);
  80216f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802173:	89 3c 24             	mov    %edi,(%esp)
  802176:	e8 11 ed ff ff       	call   800e8c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80217b:	01 f3                	add    %esi,%ebx
  80217d:	89 d8                	mov    %ebx,%eax
  80217f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802182:	72 c8                	jb     80214c <devcons_write+0x22>
  802184:	eb 05                	jmp    80218b <devcons_write+0x61>
  802186:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80218b:	89 d8                	mov    %ebx,%eax
  80218d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    

00802198 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a7:	75 07                	jne    8021b0 <devcons_read+0x18>
  8021a9:	eb 28                	jmp    8021d3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021ab:	e8 8a ed ff ff       	call   800f3a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021b0:	e8 f5 ec ff ff       	call   800eaa <sys_cgetc>
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 f2                	je     8021ab <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	78 16                	js     8021d3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021bd:	83 f8 04             	cmp    $0x4,%eax
  8021c0:	74 0c                	je     8021ce <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	88 02                	mov    %al,(%edx)
	return 1;
  8021c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cc:	eb 05                	jmp    8021d3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021e8:	00 
  8021e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 98 ec ff ff       	call   800e8c <sys_cputs>
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <getchar>:

int
getchar(void)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802203:	00 
  802204:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802212:	e8 3f f6 ff ff       	call   801856 <read>
	if (r < 0)
  802217:	85 c0                	test   %eax,%eax
  802219:	78 0f                	js     80222a <getchar+0x34>
		return r;
	if (r < 1)
  80221b:	85 c0                	test   %eax,%eax
  80221d:	7e 06                	jle    802225 <getchar+0x2f>
		return -E_EOF;
	return c;
  80221f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802223:	eb 05                	jmp    80222a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802225:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802235:	89 44 24 04          	mov    %eax,0x4(%esp)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 04 24             	mov    %eax,(%esp)
  80223f:	e8 67 f3 ff ff       	call   8015ab <fd_lookup>
  802244:	85 c0                	test   %eax,%eax
  802246:	78 11                	js     802259 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802251:	39 10                	cmp    %edx,(%eax)
  802253:	0f 94 c0             	sete   %al
  802256:	0f b6 c0             	movzbl %al,%eax
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <opencons>:

int
opencons(void)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802261:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802264:	89 04 24             	mov    %eax,(%esp)
  802267:	e8 cb f2 ff ff       	call   801537 <fd_alloc>
		return r;
  80226c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 40                	js     8022b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802272:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802279:	00 
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802281:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802288:	e8 cc ec ff ff       	call   800f59 <sys_page_alloc>
		return r;
  80228d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80228f:	85 c0                	test   %eax,%eax
  802291:	78 1f                	js     8022b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802293:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022a8:	89 04 24             	mov    %eax,(%esp)
  8022ab:	e8 60 f2 ff ff       	call   801510 <fd2num>
  8022b0:	89 c2                	mov    %eax,%edx
}
  8022b2:	89 d0                	mov    %edx,%eax
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  8022bc:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8022c3:	75 50                	jne    802315 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8022c5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8022cc:	00 
  8022cd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8022d4:	ee 
  8022d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022dc:	e8 78 ec ff ff       	call   800f59 <sys_page_alloc>
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	79 1c                	jns    802301 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8022e5:	c7 44 24 08 70 2d 80 	movl   $0x802d70,0x8(%esp)
  8022ec:	00 
  8022ed:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8022f4:	00 
  8022f5:	c7 04 24 94 2d 80 00 	movl   $0x802d94,(%esp)
  8022fc:	e8 4d e0 ff ff       	call   80034e <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802301:	c7 44 24 04 1f 23 80 	movl   $0x80231f,0x4(%esp)
  802308:	00 
  802309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802310:	e8 e4 ed ff ff       	call   8010f9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80231f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802320:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802325:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802327:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80232a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80232c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802331:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802334:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802339:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80233c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80233e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802341:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802343:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802345:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80234a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80234d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802352:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802355:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802357:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80235c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80235f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802364:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802367:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802369:	83 c4 08             	add    $0x8,%esp
	popal
  80236c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80236d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80236e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80236f:	c3                   	ret    

00802370 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	56                   	push   %esi
  802374:	53                   	push   %ebx
  802375:	83 ec 10             	sub    $0x10,%esp
  802378:	8b 75 08             	mov    0x8(%ebp),%esi
  80237b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  802381:	83 f8 01             	cmp    $0x1,%eax
  802384:	19 c0                	sbb    %eax,%eax
  802386:	f7 d0                	not    %eax
  802388:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  80238d:	89 04 24             	mov    %eax,(%esp)
  802390:	e8 da ed ff ff       	call   80116f <sys_ipc_recv>
	if (err_code < 0) {
  802395:	85 c0                	test   %eax,%eax
  802397:	79 16                	jns    8023af <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  802399:	85 f6                	test   %esi,%esi
  80239b:	74 06                	je     8023a3 <ipc_recv+0x33>
  80239d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8023a3:	85 db                	test   %ebx,%ebx
  8023a5:	74 2c                	je     8023d3 <ipc_recv+0x63>
  8023a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023ad:	eb 24                	jmp    8023d3 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8023af:	85 f6                	test   %esi,%esi
  8023b1:	74 0a                	je     8023bd <ipc_recv+0x4d>
  8023b3:	a1 04 40 80 00       	mov    0x804004,%eax
  8023b8:	8b 40 74             	mov    0x74(%eax),%eax
  8023bb:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8023bd:	85 db                	test   %ebx,%ebx
  8023bf:	74 0a                	je     8023cb <ipc_recv+0x5b>
  8023c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8023c6:	8b 40 78             	mov    0x78(%eax),%eax
  8023c9:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8023cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8023d0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023d3:	83 c4 10             	add    $0x10,%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5e                   	pop    %esi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	57                   	push   %edi
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 1c             	sub    $0x1c,%esp
  8023e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023e6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8023ec:	eb 25                	jmp    802413 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8023ee:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023f1:	74 20                	je     802413 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8023f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f7:	c7 44 24 08 a2 2d 80 	movl   $0x802da2,0x8(%esp)
  8023fe:	00 
  8023ff:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802406:	00 
  802407:	c7 04 24 ae 2d 80 00 	movl   $0x802dae,(%esp)
  80240e:	e8 3b df ff ff       	call   80034e <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802413:	85 db                	test   %ebx,%ebx
  802415:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80241a:	0f 45 c3             	cmovne %ebx,%eax
  80241d:	8b 55 14             	mov    0x14(%ebp),%edx
  802420:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802424:	89 44 24 08          	mov    %eax,0x8(%esp)
  802428:	89 74 24 04          	mov    %esi,0x4(%esp)
  80242c:	89 3c 24             	mov    %edi,(%esp)
  80242f:	e8 18 ed ff ff       	call   80114c <sys_ipc_try_send>
  802434:	85 c0                	test   %eax,%eax
  802436:	75 b6                	jne    8023ee <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    

00802440 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802446:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80244b:	39 c8                	cmp    %ecx,%eax
  80244d:	74 17                	je     802466 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80244f:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802454:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802457:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80245d:	8b 52 50             	mov    0x50(%edx),%edx
  802460:	39 ca                	cmp    %ecx,%edx
  802462:	75 14                	jne    802478 <ipc_find_env+0x38>
  802464:	eb 05                	jmp    80246b <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80246b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80246e:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802473:	8b 40 40             	mov    0x40(%eax),%eax
  802476:	eb 0e                	jmp    802486 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802478:	83 c0 01             	add    $0x1,%eax
  80247b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802480:	75 d2                	jne    802454 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802482:	66 b8 00 00          	mov    $0x0,%ax
}
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    

00802488 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
  80248b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80248e:	89 d0                	mov    %edx,%eax
  802490:	c1 e8 16             	shr    $0x16,%eax
  802493:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80249f:	f6 c1 01             	test   $0x1,%cl
  8024a2:	74 1d                	je     8024c1 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024a4:	c1 ea 0c             	shr    $0xc,%edx
  8024a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ae:	f6 c2 01             	test   $0x1,%dl
  8024b1:	74 0e                	je     8024c1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024b3:	c1 ea 0c             	shr    $0xc,%edx
  8024b6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024bd:	ef 
  8024be:	0f b7 c0             	movzwl %ax,%eax
}
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    
  8024c3:	66 90                	xchg   %ax,%ax
  8024c5:	66 90                	xchg   %ax,%ax
  8024c7:	66 90                	xchg   %ax,%ax
  8024c9:	66 90                	xchg   %ax,%ax
  8024cb:	66 90                	xchg   %ax,%ax
  8024cd:	66 90                	xchg   %ax,%ax
  8024cf:	90                   	nop

008024d0 <__udivdi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ec:	89 ea                	mov    %ebp,%edx
  8024ee:	89 0c 24             	mov    %ecx,(%esp)
  8024f1:	75 2d                	jne    802520 <__udivdi3+0x50>
  8024f3:	39 e9                	cmp    %ebp,%ecx
  8024f5:	77 61                	ja     802558 <__udivdi3+0x88>
  8024f7:	85 c9                	test   %ecx,%ecx
  8024f9:	89 ce                	mov    %ecx,%esi
  8024fb:	75 0b                	jne    802508 <__udivdi3+0x38>
  8024fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802502:	31 d2                	xor    %edx,%edx
  802504:	f7 f1                	div    %ecx
  802506:	89 c6                	mov    %eax,%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	89 e8                	mov    %ebp,%eax
  80250c:	f7 f6                	div    %esi
  80250e:	89 c5                	mov    %eax,%ebp
  802510:	89 f8                	mov    %edi,%eax
  802512:	f7 f6                	div    %esi
  802514:	89 ea                	mov    %ebp,%edx
  802516:	83 c4 0c             	add    $0xc,%esp
  802519:	5e                   	pop    %esi
  80251a:	5f                   	pop    %edi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	39 e8                	cmp    %ebp,%eax
  802522:	77 24                	ja     802548 <__udivdi3+0x78>
  802524:	0f bd e8             	bsr    %eax,%ebp
  802527:	83 f5 1f             	xor    $0x1f,%ebp
  80252a:	75 3c                	jne    802568 <__udivdi3+0x98>
  80252c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802530:	39 34 24             	cmp    %esi,(%esp)
  802533:	0f 86 9f 00 00 00    	jbe    8025d8 <__udivdi3+0x108>
  802539:	39 d0                	cmp    %edx,%eax
  80253b:	0f 82 97 00 00 00    	jb     8025d8 <__udivdi3+0x108>
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	31 c0                	xor    %eax,%eax
  80254c:	83 c4 0c             	add    $0xc,%esp
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 f8                	mov    %edi,%eax
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	83 c4 0c             	add    $0xc,%esp
  802561:	5e                   	pop    %esi
  802562:	5f                   	pop    %edi
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	8b 3c 24             	mov    (%esp),%edi
  80256d:	d3 e0                	shl    %cl,%eax
  80256f:	89 c6                	mov    %eax,%esi
  802571:	b8 20 00 00 00       	mov    $0x20,%eax
  802576:	29 e8                	sub    %ebp,%eax
  802578:	89 c1                	mov    %eax,%ecx
  80257a:	d3 ef                	shr    %cl,%edi
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802582:	8b 3c 24             	mov    (%esp),%edi
  802585:	09 74 24 08          	or     %esi,0x8(%esp)
  802589:	89 d6                	mov    %edx,%esi
  80258b:	d3 e7                	shl    %cl,%edi
  80258d:	89 c1                	mov    %eax,%ecx
  80258f:	89 3c 24             	mov    %edi,(%esp)
  802592:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802596:	d3 ee                	shr    %cl,%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	d3 e2                	shl    %cl,%edx
  80259c:	89 c1                	mov    %eax,%ecx
  80259e:	d3 ef                	shr    %cl,%edi
  8025a0:	09 d7                	or     %edx,%edi
  8025a2:	89 f2                	mov    %esi,%edx
  8025a4:	89 f8                	mov    %edi,%eax
  8025a6:	f7 74 24 08          	divl   0x8(%esp)
  8025aa:	89 d6                	mov    %edx,%esi
  8025ac:	89 c7                	mov    %eax,%edi
  8025ae:	f7 24 24             	mull   (%esp)
  8025b1:	39 d6                	cmp    %edx,%esi
  8025b3:	89 14 24             	mov    %edx,(%esp)
  8025b6:	72 30                	jb     8025e8 <__udivdi3+0x118>
  8025b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	d3 e2                	shl    %cl,%edx
  8025c0:	39 c2                	cmp    %eax,%edx
  8025c2:	73 05                	jae    8025c9 <__udivdi3+0xf9>
  8025c4:	3b 34 24             	cmp    (%esp),%esi
  8025c7:	74 1f                	je     8025e8 <__udivdi3+0x118>
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	e9 7a ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	b8 01 00 00 00       	mov    $0x1,%eax
  8025df:	e9 68 ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	83 c4 0c             	add    $0xc,%esp
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    
  8025f4:	66 90                	xchg   %ax,%ax
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	66 90                	xchg   %ax,%ax
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	66 90                	xchg   %ax,%ax
  8025fe:	66 90                	xchg   %ax,%ax

00802600 <__umoddi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	83 ec 14             	sub    $0x14,%esp
  802606:	8b 44 24 28          	mov    0x28(%esp),%eax
  80260a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80260e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802612:	89 c7                	mov    %eax,%edi
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 44 24 30          	mov    0x30(%esp),%eax
  80261c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802620:	89 34 24             	mov    %esi,(%esp)
  802623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802627:	85 c0                	test   %eax,%eax
  802629:	89 c2                	mov    %eax,%edx
  80262b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80262f:	75 17                	jne    802648 <__umoddi3+0x48>
  802631:	39 fe                	cmp    %edi,%esi
  802633:	76 4b                	jbe    802680 <__umoddi3+0x80>
  802635:	89 c8                	mov    %ecx,%eax
  802637:	89 fa                	mov    %edi,%edx
  802639:	f7 f6                	div    %esi
  80263b:	89 d0                	mov    %edx,%eax
  80263d:	31 d2                	xor    %edx,%edx
  80263f:	83 c4 14             	add    $0x14,%esp
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	66 90                	xchg   %ax,%ax
  802648:	39 f8                	cmp    %edi,%eax
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd e8             	bsr    %eax,%ebp
  80264f:	83 f5 1f             	xor    $0x1f,%ebp
  802652:	75 5c                	jne    8026b0 <__umoddi3+0xb0>
  802654:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802658:	39 3c 24             	cmp    %edi,(%esp)
  80265b:	0f 87 e7 00 00 00    	ja     802748 <__umoddi3+0x148>
  802661:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802665:	29 f1                	sub    %esi,%ecx
  802667:	19 c7                	sbb    %eax,%edi
  802669:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80266d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802671:	8b 44 24 08          	mov    0x8(%esp),%eax
  802675:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802679:	83 c4 14             	add    $0x14,%esp
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	85 f6                	test   %esi,%esi
  802682:	89 f5                	mov    %esi,%ebp
  802684:	75 0b                	jne    802691 <__umoddi3+0x91>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f6                	div    %esi
  80268f:	89 c5                	mov    %eax,%ebp
  802691:	8b 44 24 04          	mov    0x4(%esp),%eax
  802695:	31 d2                	xor    %edx,%edx
  802697:	f7 f5                	div    %ebp
  802699:	89 c8                	mov    %ecx,%eax
  80269b:	f7 f5                	div    %ebp
  80269d:	eb 9c                	jmp    80263b <__umoddi3+0x3b>
  80269f:	90                   	nop
  8026a0:	89 c8                	mov    %ecx,%eax
  8026a2:	89 fa                	mov    %edi,%edx
  8026a4:	83 c4 14             	add    $0x14,%esp
  8026a7:	5e                   	pop    %esi
  8026a8:	5f                   	pop    %edi
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    
  8026ab:	90                   	nop
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	8b 04 24             	mov    (%esp),%eax
  8026b3:	be 20 00 00 00       	mov    $0x20,%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	29 ee                	sub    %ebp,%esi
  8026bc:	d3 e2                	shl    %cl,%edx
  8026be:	89 f1                	mov    %esi,%ecx
  8026c0:	d3 e8                	shr    %cl,%eax
  8026c2:	89 e9                	mov    %ebp,%ecx
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	8b 04 24             	mov    (%esp),%eax
  8026cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026cf:	89 fa                	mov    %edi,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 f1                	mov    %esi,%ecx
  8026d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026dd:	d3 ea                	shr    %cl,%edx
  8026df:	89 e9                	mov    %ebp,%ecx
  8026e1:	d3 e7                	shl    %cl,%edi
  8026e3:	89 f1                	mov    %esi,%ecx
  8026e5:	d3 e8                	shr    %cl,%eax
  8026e7:	89 e9                	mov    %ebp,%ecx
  8026e9:	09 f8                	or     %edi,%eax
  8026eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026ef:	f7 74 24 04          	divl   0x4(%esp)
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026f9:	89 d7                	mov    %edx,%edi
  8026fb:	f7 64 24 08          	mull   0x8(%esp)
  8026ff:	39 d7                	cmp    %edx,%edi
  802701:	89 c1                	mov    %eax,%ecx
  802703:	89 14 24             	mov    %edx,(%esp)
  802706:	72 2c                	jb     802734 <__umoddi3+0x134>
  802708:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80270c:	72 22                	jb     802730 <__umoddi3+0x130>
  80270e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802712:	29 c8                	sub    %ecx,%eax
  802714:	19 d7                	sbb    %edx,%edi
  802716:	89 e9                	mov    %ebp,%ecx
  802718:	89 fa                	mov    %edi,%edx
  80271a:	d3 e8                	shr    %cl,%eax
  80271c:	89 f1                	mov    %esi,%ecx
  80271e:	d3 e2                	shl    %cl,%edx
  802720:	89 e9                	mov    %ebp,%ecx
  802722:	d3 ef                	shr    %cl,%edi
  802724:	09 d0                	or     %edx,%eax
  802726:	89 fa                	mov    %edi,%edx
  802728:	83 c4 14             	add    $0x14,%esp
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	5d                   	pop    %ebp
  80272e:	c3                   	ret    
  80272f:	90                   	nop
  802730:	39 d7                	cmp    %edx,%edi
  802732:	75 da                	jne    80270e <__umoddi3+0x10e>
  802734:	8b 14 24             	mov    (%esp),%edx
  802737:	89 c1                	mov    %eax,%ecx
  802739:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80273d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802741:	eb cb                	jmp    80270e <__umoddi3+0x10e>
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80274c:	0f 82 0f ff ff ff    	jb     802661 <__umoddi3+0x61>
  802752:	e9 1a ff ff ff       	jmp    802671 <__umoddi3+0x71>
