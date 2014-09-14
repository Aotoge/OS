
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e4 02 00 00       	call   800315 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 40 	movl   $0x802840,0x803004
  800042:	28 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 69 1f 00 00       	call   801fb9 <pipe>
  800050:	89 c6                	mov    %eax,%esi
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("pipe: %e", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 4c 28 80 	movl   $0x80284c,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  800071:	e8 30 03 00 00       	call   8003a6 <_panic>

	if ((pid = fork()) < 0)
  800076:	e8 85 12 00 00       	call   801300 <fork>
  80007b:	89 c3                	mov    %eax,%ebx
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <umain+0x6e>
		panic("fork: %e", i);
  800081:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800085:	c7 44 24 08 65 28 80 	movl   $0x802865,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  80009c:	e8 05 03 00 00       	call   8003a6 <_panic>

	if (pid == 0) {
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 d5 00 00 00    	jne    80017e <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ae:	8b 40 48             	mov    0x48(%eax),%eax
  8000b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bc:	c7 04 24 6e 28 80 00 	movl   $0x80286e,(%esp)
  8000c3:	e8 d7 03 00 00       	call   80049f <cprintf>
		close(p[1]);
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 80 16 00 00       	call   801753 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d3:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d8:	8b 40 48             	mov    0x48(%eax),%eax
  8000db:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e6:	c7 04 24 8b 28 80 00 	movl   $0x80288b,(%esp)
  8000ed:	e8 ad 03 00 00       	call   80049f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f2:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000f9:	00 
  8000fa:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800104:	89 04 24             	mov    %eax,(%esp)
  800107:	e8 3c 18 00 00       	call   801948 <readn>
  80010c:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	79 20                	jns    800132 <umain+0xff>
			panic("read: %e", i);
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 a8 28 80 	movl   $0x8028a8,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  80012d:	e8 74 02 00 00       	call   8003a6 <_panic>
		buf[i] = 0;
  800132:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800137:	a1 00 30 80 00       	mov    0x803000,%eax
  80013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800140:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 7a 0a 00 00       	call   800bc5 <strcmp>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	75 0e                	jne    80015d <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  80014f:	c7 04 24 b1 28 80 00 	movl   $0x8028b1,(%esp)
  800156:	e8 44 03 00 00       	call   80049f <cprintf>
  80015b:	eb 17                	jmp    800174 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015d:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	c7 04 24 cd 28 80 00 	movl   $0x8028cd,(%esp)
  80016f:	e8 2b 03 00 00       	call   80049f <cprintf>
		exit();
  800174:	e8 14 02 00 00       	call   80038d <exit>
  800179:	e9 ac 00 00 00       	jmp    80022a <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017e:	a1 04 40 80 00       	mov    0x804004,%eax
  800183:	8b 40 48             	mov    0x48(%eax),%eax
  800186:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 6e 28 80 00 	movl   $0x80286e,(%esp)
  800198:	e8 02 03 00 00       	call   80049f <cprintf>
		close(p[0]);
  80019d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 ab 15 00 00       	call   801753 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a8:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ad:	8b 40 48             	mov    0x48(%eax),%eax
  8001b0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bb:	c7 04 24 e0 28 80 00 	movl   $0x8028e0,(%esp)
  8001c2:	e8 d8 02 00 00       	call   80049f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001cc:	89 04 24             	mov    %eax,(%esp)
  8001cf:	e8 cc 08 00 00       	call   800aa0 <strlen>
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	a1 00 30 80 00       	mov    0x803000,%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 b7 17 00 00       	call   8019a3 <write>
  8001ec:	89 c6                	mov    %eax,%esi
  8001ee:	a1 00 30 80 00       	mov    0x803000,%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 a5 08 00 00       	call   800aa0 <strlen>
  8001fb:	39 c6                	cmp    %eax,%esi
  8001fd:	74 20                	je     80021f <umain+0x1ec>
			panic("write: %e", i);
  8001ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800203:	c7 44 24 08 fd 28 80 	movl   $0x8028fd,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  80021a:	e8 87 01 00 00       	call   8003a6 <_panic>
		close(p[1]);
  80021f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 29 15 00 00       	call   801753 <close>
	}
	wait(pid);
  80022a:	89 1c 24             	mov    %ebx,(%esp)
  80022d:	e8 2d 1f 00 00       	call   80215f <wait>

	binaryname = "pipewriteeof";
  800232:	c7 05 04 30 80 00 07 	movl   $0x802907,0x803004
  800239:	29 80 00 
	if ((i = pipe(p)) < 0)
  80023c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 72 1d 00 00       	call   801fb9 <pipe>
  800247:	89 c6                	mov    %eax,%esi
  800249:	85 c0                	test   %eax,%eax
  80024b:	79 20                	jns    80026d <umain+0x23a>
		panic("pipe: %e", i);
  80024d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800251:	c7 44 24 08 4c 28 80 	movl   $0x80284c,0x8(%esp)
  800258:	00 
  800259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800260:	00 
  800261:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  800268:	e8 39 01 00 00       	call   8003a6 <_panic>

	if ((pid = fork()) < 0)
  80026d:	e8 8e 10 00 00       	call   801300 <fork>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <umain+0x265>
		panic("fork: %e", i);
  800278:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027c:	c7 44 24 08 65 28 80 	movl   $0x802865,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  800293:	e8 0e 01 00 00       	call   8003a6 <_panic>

	if (pid == 0) {
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 48                	jne    8002e4 <umain+0x2b1>
		close(p[0]);
  80029c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 ac 14 00 00       	call   801753 <close>
		while (1) {
			cprintf(".");
  8002a7:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  8002ae:	e8 ec 01 00 00       	call   80049f <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 16 29 80 	movl   $0x802916,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002c6:	89 14 24             	mov    %edx,(%esp)
  8002c9:	e8 d5 16 00 00       	call   8019a3 <write>
  8002ce:	83 f8 01             	cmp    $0x1,%eax
  8002d1:	74 d4                	je     8002a7 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d3:	c7 04 24 18 29 80 00 	movl   $0x802918,(%esp)
  8002da:	e8 c0 01 00 00       	call   80049f <cprintf>
		exit();
  8002df:	e8 a9 00 00 00       	call   80038d <exit>
	}
	close(p[0]);
  8002e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	e8 64 14 00 00       	call   801753 <close>
	close(p[1]);
  8002ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 59 14 00 00       	call   801753 <close>
	wait(pid);
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 5d 1e 00 00       	call   80215f <wait>

	cprintf("pipe tests passed\n");
  800302:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  800309:	e8 91 01 00 00       	call   80049f <cprintf>
}
  80030e:	83 ec 80             	sub    $0xffffff80,%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 10             	sub    $0x10,%esp
  80031d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800320:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800323:	e8 43 0c 00 00       	call   800f6b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800328:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80032e:	39 c2                	cmp    %eax,%edx
  800330:	74 17                	je     800349 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800332:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800337:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80033a:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800340:	8b 49 40             	mov    0x40(%ecx),%ecx
  800343:	39 c1                	cmp    %eax,%ecx
  800345:	75 18                	jne    80035f <libmain+0x4a>
  800347:	eb 05                	jmp    80034e <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80034e:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800351:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800357:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  80035d:	eb 0b                	jmp    80036a <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80035f:	83 c2 01             	add    $0x1,%edx
  800362:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800368:	75 cd                	jne    800337 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80036a:	85 db                	test   %ebx,%ebx
  80036c:	7e 07                	jle    800375 <libmain+0x60>
		binaryname = argv[0];
  80036e:	8b 06                	mov    (%esi),%eax
  800370:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800375:	89 74 24 04          	mov    %esi,0x4(%esp)
  800379:	89 1c 24             	mov    %ebx,(%esp)
  80037c:	e8 b2 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800381:	e8 07 00 00 00       	call   80038d <exit>
}
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    

0080038d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800393:	e8 ee 13 00 00       	call   801786 <close_all>
	sys_env_destroy(0);
  800398:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80039f:	e8 75 0b 00 00       	call   800f19 <sys_env_destroy>
}
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    

008003a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	56                   	push   %esi
  8003aa:	53                   	push   %ebx
  8003ab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8003b7:	e8 af 0b 00 00       	call   800f6b <sys_getenvid>
  8003bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003ca:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d2:	c7 04 24 98 29 80 00 	movl   $0x802998,(%esp)
  8003d9:	e8 c1 00 00 00       	call   80049f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e5:	89 04 24             	mov    %eax,(%esp)
  8003e8:	e8 51 00 00 00       	call   80043e <vcprintf>
	cprintf("\n");
  8003ed:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  8003f4:	e8 a6 00 00 00       	call   80049f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003f9:	cc                   	int3   
  8003fa:	eb fd                	jmp    8003f9 <_panic+0x53>

008003fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	53                   	push   %ebx
  800400:	83 ec 14             	sub    $0x14,%esp
  800403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800406:	8b 13                	mov    (%ebx),%edx
  800408:	8d 42 01             	lea    0x1(%edx),%eax
  80040b:	89 03                	mov    %eax,(%ebx)
  80040d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800410:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800414:	3d ff 00 00 00       	cmp    $0xff,%eax
  800419:	75 19                	jne    800434 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80041b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800422:	00 
  800423:	8d 43 08             	lea    0x8(%ebx),%eax
  800426:	89 04 24             	mov    %eax,(%esp)
  800429:	e8 ae 0a 00 00       	call   800edc <sys_cputs>
		b->idx = 0;
  80042e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800434:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800438:	83 c4 14             	add    $0x14,%esp
  80043b:	5b                   	pop    %ebx
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800447:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80044e:	00 00 00 
	b.cnt = 0;
  800451:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800458:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80045b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	89 44 24 08          	mov    %eax,0x8(%esp)
  800469:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80046f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800473:	c7 04 24 fc 03 80 00 	movl   $0x8003fc,(%esp)
  80047a:	e8 b5 01 00 00       	call   800634 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80047f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800485:	89 44 24 04          	mov    %eax,0x4(%esp)
  800489:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80048f:	89 04 24             	mov    %eax,(%esp)
  800492:	e8 45 0a 00 00       	call   800edc <sys_cputs>

	return b.cnt;
}
  800497:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    

0080049f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	89 04 24             	mov    %eax,(%esp)
  8004b2:	e8 87 ff ff ff       	call   80043e <vcprintf>
	va_end(ap);

	return cnt;
}
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    
  8004b9:	66 90                	xchg   %ax,%ax
  8004bb:	66 90                	xchg   %ax,%ax
  8004bd:	66 90                	xchg   %ax,%ax
  8004bf:	90                   	nop

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 3c             	sub    $0x3c,%esp
  8004c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cc:	89 d7                	mov    %edx,%edi
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8004da:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004e8:	39 f1                	cmp    %esi,%ecx
  8004ea:	72 14                	jb     800500 <printnum+0x40>
  8004ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004ef:	76 0f                	jbe    800500 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8004f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004fa:	85 f6                	test   %esi,%esi
  8004fc:	7f 60                	jg     80055e <printnum+0x9e>
  8004fe:	eb 72                	jmp    800572 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800500:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800503:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800507:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80050a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80050d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800511:	89 44 24 08          	mov    %eax,0x8(%esp)
  800515:	8b 44 24 08          	mov    0x8(%esp),%eax
  800519:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80051d:	89 c3                	mov    %eax,%ebx
  80051f:	89 d6                	mov    %edx,%esi
  800521:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800524:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800527:	89 54 24 08          	mov    %edx,0x8(%esp)
  80052b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80052f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800532:	89 04 24             	mov    %eax,(%esp)
  800535:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053c:	e8 5f 20 00 00       	call   8025a0 <__udivdi3>
  800541:	89 d9                	mov    %ebx,%ecx
  800543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800547:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80054b:	89 04 24             	mov    %eax,(%esp)
  80054e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800552:	89 fa                	mov    %edi,%edx
  800554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800557:	e8 64 ff ff ff       	call   8004c0 <printnum>
  80055c:	eb 14                	jmp    800572 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80055e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800562:	8b 45 18             	mov    0x18(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80056a:	83 ee 01             	sub    $0x1,%esi
  80056d:	75 ef                	jne    80055e <printnum+0x9e>
  80056f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800572:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800576:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80057a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800580:	89 44 24 08          	mov    %eax,0x8(%esp)
  800584:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	89 04 24             	mov    %eax,(%esp)
  80058e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800591:	89 44 24 04          	mov    %eax,0x4(%esp)
  800595:	e8 36 21 00 00       	call   8026d0 <__umoddi3>
  80059a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059e:	0f be 80 bb 29 80 00 	movsbl 0x8029bb(%eax),%eax
  8005a5:	89 04 24             	mov    %eax,(%esp)
  8005a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ab:	ff d0                	call   *%eax
}
  8005ad:	83 c4 3c             	add    $0x3c,%esp
  8005b0:	5b                   	pop    %ebx
  8005b1:	5e                   	pop    %esi
  8005b2:	5f                   	pop    %edi
  8005b3:	5d                   	pop    %ebp
  8005b4:	c3                   	ret    

008005b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005b8:	83 fa 01             	cmp    $0x1,%edx
  8005bb:	7e 0e                	jle    8005cb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005c2:	89 08                	mov    %ecx,(%eax)
  8005c4:	8b 02                	mov    (%edx),%eax
  8005c6:	8b 52 04             	mov    0x4(%edx),%edx
  8005c9:	eb 22                	jmp    8005ed <getuint+0x38>
	else if (lflag)
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 10                	je     8005df <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005cf:	8b 10                	mov    (%eax),%edx
  8005d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005d4:	89 08                	mov    %ecx,(%eax)
  8005d6:	8b 02                	mov    (%edx),%eax
  8005d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dd:	eb 0e                	jmp    8005ed <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005df:	8b 10                	mov    (%eax),%edx
  8005e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005e4:	89 08                	mov    %ecx,(%eax)
  8005e6:	8b 02                	mov    (%edx),%eax
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ed:	5d                   	pop    %ebp
  8005ee:	c3                   	ret    

008005ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8005fe:	73 0a                	jae    80060a <sprintputch+0x1b>
		*b->buf++ = ch;
  800600:	8d 4a 01             	lea    0x1(%edx),%ecx
  800603:	89 08                	mov    %ecx,(%eax)
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	88 02                	mov    %al,(%edx)
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800612:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800615:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800619:	8b 45 10             	mov    0x10(%ebp),%eax
  80061c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	89 44 24 04          	mov    %eax,0x4(%esp)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	89 04 24             	mov    %eax,(%esp)
  80062d:	e8 02 00 00 00       	call   800634 <vprintfmt>
	va_end(ap);
}
  800632:	c9                   	leave  
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	57                   	push   %edi
  800638:	56                   	push   %esi
  800639:	53                   	push   %ebx
  80063a:	83 ec 3c             	sub    $0x3c,%esp
  80063d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800640:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800643:	eb 18                	jmp    80065d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800645:	85 c0                	test   %eax,%eax
  800647:	0f 84 c3 03 00 00    	je     800a10 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80064d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800651:	89 04 24             	mov    %eax,(%esp)
  800654:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800657:	89 f3                	mov    %esi,%ebx
  800659:	eb 02                	jmp    80065d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80065b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065d:	8d 73 01             	lea    0x1(%ebx),%esi
  800660:	0f b6 03             	movzbl (%ebx),%eax
  800663:	83 f8 25             	cmp    $0x25,%eax
  800666:	75 dd                	jne    800645 <vprintfmt+0x11>
  800668:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80066c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800673:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80067a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1d                	jmp    8006a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80068a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80068e:	eb 15                	jmp    8006a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800690:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800692:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800696:	eb 0d                	jmp    8006a5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80069b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80069e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8006a8:	0f b6 06             	movzbl (%esi),%eax
  8006ab:	0f b6 c8             	movzbl %al,%ecx
  8006ae:	83 e8 23             	sub    $0x23,%eax
  8006b1:	3c 55                	cmp    $0x55,%al
  8006b3:	0f 87 2f 03 00 00    	ja     8009e8 <vprintfmt+0x3b4>
  8006b9:	0f b6 c0             	movzbl %al,%eax
  8006bc:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006c3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8006c9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8006cd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8006d0:	83 f9 09             	cmp    $0x9,%ecx
  8006d3:	77 50                	ja     800725 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	89 de                	mov    %ebx,%esi
  8006d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006da:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8006dd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006e0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006e4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006e7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006ea:	83 fb 09             	cmp    $0x9,%ebx
  8006ed:	76 eb                	jbe    8006da <vprintfmt+0xa6>
  8006ef:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f2:	eb 33                	jmp    800727 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 48 04             	lea    0x4(%eax),%ecx
  8006fa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800702:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800704:	eb 21                	jmp    800727 <vprintfmt+0xf3>
  800706:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800709:	85 c9                	test   %ecx,%ecx
  80070b:	b8 00 00 00 00       	mov    $0x0,%eax
  800710:	0f 49 c1             	cmovns %ecx,%eax
  800713:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800716:	89 de                	mov    %ebx,%esi
  800718:	eb 8b                	jmp    8006a5 <vprintfmt+0x71>
  80071a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80071c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800723:	eb 80                	jmp    8006a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800725:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	0f 89 74 ff ff ff    	jns    8006a5 <vprintfmt+0x71>
  800731:	e9 62 ff ff ff       	jmp    800698 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800736:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800739:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80073b:	e9 65 ff ff ff       	jmp    8006a5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 50 04             	lea    0x4(%eax),%edx
  800746:	89 55 14             	mov    %edx,0x14(%ebp)
  800749:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	89 04 24             	mov    %eax,(%esp)
  800752:	ff 55 08             	call   *0x8(%ebp)
			break;
  800755:	e9 03 ff ff ff       	jmp    80065d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	89 55 14             	mov    %edx,0x14(%ebp)
  800763:	8b 00                	mov    (%eax),%eax
  800765:	99                   	cltd   
  800766:	31 d0                	xor    %edx,%eax
  800768:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80076a:	83 f8 0f             	cmp    $0xf,%eax
  80076d:	7f 0b                	jg     80077a <vprintfmt+0x146>
  80076f:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  800776:	85 d2                	test   %edx,%edx
  800778:	75 20                	jne    80079a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80077a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80077e:	c7 44 24 08 d3 29 80 	movl   $0x8029d3,0x8(%esp)
  800785:	00 
  800786:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	89 04 24             	mov    %eax,(%esp)
  800790:	e8 77 fe ff ff       	call   80060c <printfmt>
  800795:	e9 c3 fe ff ff       	jmp    80065d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80079a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80079e:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  8007a5:	00 
  8007a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 04 24             	mov    %eax,(%esp)
  8007b0:	e8 57 fe ff ff       	call   80060c <printfmt>
  8007b5:	e9 a3 fe ff ff       	jmp    80065d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007bd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 50 04             	lea    0x4(%eax),%edx
  8007c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	ba cc 29 80 00       	mov    $0x8029cc,%edx
  8007d2:	0f 45 d0             	cmovne %eax,%edx
  8007d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8007d8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8007dc:	74 04                	je     8007e2 <vprintfmt+0x1ae>
  8007de:	85 f6                	test   %esi,%esi
  8007e0:	7f 19                	jg     8007fb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e5:	8d 70 01             	lea    0x1(%eax),%esi
  8007e8:	0f b6 10             	movzbl (%eax),%edx
  8007eb:	0f be c2             	movsbl %dl,%eax
  8007ee:	85 c0                	test   %eax,%eax
  8007f0:	0f 85 95 00 00 00    	jne    80088b <vprintfmt+0x257>
  8007f6:	e9 85 00 00 00       	jmp    800880 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 b8 02 00 00       	call   800ac2 <strnlen>
  80080a:	29 c6                	sub    %eax,%esi
  80080c:	89 f0                	mov    %esi,%eax
  80080e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800811:	85 f6                	test   %esi,%esi
  800813:	7e cd                	jle    8007e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800815:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800819:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80081c:	89 c3                	mov    %eax,%ebx
  80081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800822:	89 34 24             	mov    %esi,(%esp)
  800825:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800828:	83 eb 01             	sub    $0x1,%ebx
  80082b:	75 f1                	jne    80081e <vprintfmt+0x1ea>
  80082d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800830:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800833:	eb ad                	jmp    8007e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800835:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800839:	74 1e                	je     800859 <vprintfmt+0x225>
  80083b:	0f be d2             	movsbl %dl,%edx
  80083e:	83 ea 20             	sub    $0x20,%edx
  800841:	83 fa 5e             	cmp    $0x5e,%edx
  800844:	76 13                	jbe    800859 <vprintfmt+0x225>
					putch('?', putdat);
  800846:	8b 45 0c             	mov    0xc(%ebp),%eax
  800849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800854:	ff 55 08             	call   *0x8(%ebp)
  800857:	eb 0d                	jmp    800866 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800860:	89 04 24             	mov    %eax,(%esp)
  800863:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800866:	83 ef 01             	sub    $0x1,%edi
  800869:	83 c6 01             	add    $0x1,%esi
  80086c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800870:	0f be c2             	movsbl %dl,%eax
  800873:	85 c0                	test   %eax,%eax
  800875:	75 20                	jne    800897 <vprintfmt+0x263>
  800877:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80087a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80087d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	7f 25                	jg     8008ab <vprintfmt+0x277>
  800886:	e9 d2 fd ff ff       	jmp    80065d <vprintfmt+0x29>
  80088b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80088e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800891:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800894:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800897:	85 db                	test   %ebx,%ebx
  800899:	78 9a                	js     800835 <vprintfmt+0x201>
  80089b:	83 eb 01             	sub    $0x1,%ebx
  80089e:	79 95                	jns    800835 <vprintfmt+0x201>
  8008a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8008a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008a9:	eb d5                	jmp    800880 <vprintfmt+0x24c>
  8008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8008b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008bf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008c1:	83 eb 01             	sub    $0x1,%ebx
  8008c4:	75 ee                	jne    8008b4 <vprintfmt+0x280>
  8008c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008c9:	e9 8f fd ff ff       	jmp    80065d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008ce:	83 fa 01             	cmp    $0x1,%edx
  8008d1:	7e 16                	jle    8008e9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	89 55 14             	mov    %edx,0x14(%ebp)
  8008dc:	8b 50 04             	mov    0x4(%eax),%edx
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e7:	eb 32                	jmp    80091b <vprintfmt+0x2e7>
	else if (lflag)
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 18                	je     800905 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8d 50 04             	lea    0x4(%eax),%edx
  8008f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f6:	8b 30                	mov    (%eax),%esi
  8008f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008fb:	89 f0                	mov    %esi,%eax
  8008fd:	c1 f8 1f             	sar    $0x1f,%eax
  800900:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800903:	eb 16                	jmp    80091b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	89 55 14             	mov    %edx,0x14(%ebp)
  80090e:	8b 30                	mov    (%eax),%esi
  800910:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800913:	89 f0                	mov    %esi,%eax
  800915:	c1 f8 1f             	sar    $0x1f,%eax
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80091b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800921:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800926:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092a:	0f 89 80 00 00 00    	jns    8009b0 <vprintfmt+0x37c>
				putch('-', putdat);
  800930:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800934:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80093b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80093e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800941:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800944:	f7 d8                	neg    %eax
  800946:	83 d2 00             	adc    $0x0,%edx
  800949:	f7 da                	neg    %edx
			}
			base = 10;
  80094b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800950:	eb 5e                	jmp    8009b0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800952:	8d 45 14             	lea    0x14(%ebp),%eax
  800955:	e8 5b fc ff ff       	call   8005b5 <getuint>
			base = 10;
  80095a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80095f:	eb 4f                	jmp    8009b0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	e8 4c fc ff ff       	call   8005b5 <getuint>
			base = 8;
  800969:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80096e:	eb 40                	jmp    8009b0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800970:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800974:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80097b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80097e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800982:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800989:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 50 04             	lea    0x4(%eax),%edx
  800992:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800995:	8b 00                	mov    (%eax),%eax
  800997:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80099c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8009a1:	eb 0d                	jmp    8009b0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a6:	e8 0a fc ff ff       	call   8005b5 <getuint>
			base = 16;
  8009ab:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009b0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8009b4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8009bb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009c3:	89 04 24             	mov    %eax,(%esp)
  8009c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ca:	89 fa                	mov    %edi,%edx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	e8 ec fa ff ff       	call   8004c0 <printnum>
			break;
  8009d4:	e9 84 fc ff ff       	jmp    80065d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009dd:	89 0c 24             	mov    %ecx,(%esp)
  8009e0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009e3:	e9 75 fc ff ff       	jmp    80065d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ec:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009f3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009fa:	0f 84 5b fc ff ff    	je     80065b <vprintfmt+0x27>
  800a00:	89 f3                	mov    %esi,%ebx
  800a02:	83 eb 01             	sub    $0x1,%ebx
  800a05:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a09:	75 f7                	jne    800a02 <vprintfmt+0x3ce>
  800a0b:	e9 4d fc ff ff       	jmp    80065d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800a10:	83 c4 3c             	add    $0x3c,%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5f                   	pop    %edi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 28             	sub    $0x28,%esp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a27:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a2b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a35:	85 c0                	test   %eax,%eax
  800a37:	74 30                	je     800a69 <vsnprintf+0x51>
  800a39:	85 d2                	test   %edx,%edx
  800a3b:	7e 2c                	jle    800a69 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a44:	8b 45 10             	mov    0x10(%ebp),%eax
  800a47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a52:	c7 04 24 ef 05 80 00 	movl   $0x8005ef,(%esp)
  800a59:	e8 d6 fb ff ff       	call   800634 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a67:	eb 05                	jmp    800a6e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a76:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	89 04 24             	mov    %eax,(%esp)
  800a91:	e8 82 ff ff ff       	call   800a18 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    
  800a98:	66 90                	xchg   %ax,%ax
  800a9a:	66 90                	xchg   %ax,%ax
  800a9c:	66 90                	xchg   %ax,%ax
  800a9e:	66 90                	xchg   %ax,%ax

00800aa0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa6:	80 3a 00             	cmpb   $0x0,(%edx)
  800aa9:	74 10                	je     800abb <strlen+0x1b>
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800ab0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab7:	75 f7                	jne    800ab0 <strlen+0x10>
  800ab9:	eb 05                	jmp    800ac0 <strlen+0x20>
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	53                   	push   %ebx
  800ac6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acc:	85 c9                	test   %ecx,%ecx
  800ace:	74 1c                	je     800aec <strnlen+0x2a>
  800ad0:	80 3b 00             	cmpb   $0x0,(%ebx)
  800ad3:	74 1e                	je     800af3 <strnlen+0x31>
  800ad5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800ada:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adc:	39 ca                	cmp    %ecx,%edx
  800ade:	74 18                	je     800af8 <strnlen+0x36>
  800ae0:	83 c2 01             	add    $0x1,%edx
  800ae3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800ae8:	75 f0                	jne    800ada <strnlen+0x18>
  800aea:	eb 0c                	jmp    800af8 <strnlen+0x36>
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
  800af1:	eb 05                	jmp    800af8 <strnlen+0x36>
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800af8:	5b                   	pop    %ebx
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	83 c2 01             	add    $0x1,%edx
  800b0a:	83 c1 01             	add    $0x1,%ecx
  800b0d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b11:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b14:	84 db                	test   %bl,%bl
  800b16:	75 ef                	jne    800b07 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b18:	5b                   	pop    %ebx
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b25:	89 1c 24             	mov    %ebx,(%esp)
  800b28:	e8 73 ff ff ff       	call   800aa0 <strlen>
	strcpy(dst + len, src);
  800b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b30:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b34:	01 d8                	add    %ebx,%eax
  800b36:	89 04 24             	mov    %eax,(%esp)
  800b39:	e8 bd ff ff ff       	call   800afb <strcpy>
	return dst;
}
  800b3e:	89 d8                	mov    %ebx,%eax
  800b40:	83 c4 08             	add    $0x8,%esp
  800b43:	5b                   	pop    %ebx
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b54:	85 db                	test   %ebx,%ebx
  800b56:	74 17                	je     800b6f <strncpy+0x29>
  800b58:	01 f3                	add    %esi,%ebx
  800b5a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800b5c:	83 c1 01             	add    $0x1,%ecx
  800b5f:	0f b6 02             	movzbl (%edx),%eax
  800b62:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b65:	80 3a 01             	cmpb   $0x1,(%edx)
  800b68:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b6b:	39 d9                	cmp    %ebx,%ecx
  800b6d:	75 ed                	jne    800b5c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b6f:	89 f0                	mov    %esi,%eax
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b81:	8b 75 10             	mov    0x10(%ebp),%esi
  800b84:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b86:	85 f6                	test   %esi,%esi
  800b88:	74 34                	je     800bbe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800b8a:	83 fe 01             	cmp    $0x1,%esi
  800b8d:	74 26                	je     800bb5 <strlcpy+0x40>
  800b8f:	0f b6 0b             	movzbl (%ebx),%ecx
  800b92:	84 c9                	test   %cl,%cl
  800b94:	74 23                	je     800bb9 <strlcpy+0x44>
  800b96:	83 ee 02             	sub    $0x2,%esi
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800b9e:	83 c0 01             	add    $0x1,%eax
  800ba1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ba4:	39 f2                	cmp    %esi,%edx
  800ba6:	74 13                	je     800bbb <strlcpy+0x46>
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800baf:	84 c9                	test   %cl,%cl
  800bb1:	75 eb                	jne    800b9e <strlcpy+0x29>
  800bb3:	eb 06                	jmp    800bbb <strlcpy+0x46>
  800bb5:	89 f8                	mov    %edi,%eax
  800bb7:	eb 02                	jmp    800bbb <strlcpy+0x46>
  800bb9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800bbb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bbe:	29 f8                	sub    %edi,%eax
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bce:	0f b6 01             	movzbl (%ecx),%eax
  800bd1:	84 c0                	test   %al,%al
  800bd3:	74 15                	je     800bea <strcmp+0x25>
  800bd5:	3a 02                	cmp    (%edx),%al
  800bd7:	75 11                	jne    800bea <strcmp+0x25>
		p++, q++;
  800bd9:	83 c1 01             	add    $0x1,%ecx
  800bdc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bdf:	0f b6 01             	movzbl (%ecx),%eax
  800be2:	84 c0                	test   %al,%al
  800be4:	74 04                	je     800bea <strcmp+0x25>
  800be6:	3a 02                	cmp    (%edx),%al
  800be8:	74 ef                	je     800bd9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bea:	0f b6 c0             	movzbl %al,%eax
  800bed:	0f b6 12             	movzbl (%edx),%edx
  800bf0:	29 d0                	sub    %edx,%eax
}
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bff:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800c02:	85 f6                	test   %esi,%esi
  800c04:	74 29                	je     800c2f <strncmp+0x3b>
  800c06:	0f b6 03             	movzbl (%ebx),%eax
  800c09:	84 c0                	test   %al,%al
  800c0b:	74 30                	je     800c3d <strncmp+0x49>
  800c0d:	3a 02                	cmp    (%edx),%al
  800c0f:	75 2c                	jne    800c3d <strncmp+0x49>
  800c11:	8d 43 01             	lea    0x1(%ebx),%eax
  800c14:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800c16:	89 c3                	mov    %eax,%ebx
  800c18:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c1b:	39 f0                	cmp    %esi,%eax
  800c1d:	74 17                	je     800c36 <strncmp+0x42>
  800c1f:	0f b6 08             	movzbl (%eax),%ecx
  800c22:	84 c9                	test   %cl,%cl
  800c24:	74 17                	je     800c3d <strncmp+0x49>
  800c26:	83 c0 01             	add    $0x1,%eax
  800c29:	3a 0a                	cmp    (%edx),%cl
  800c2b:	74 e9                	je     800c16 <strncmp+0x22>
  800c2d:	eb 0e                	jmp    800c3d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	eb 0f                	jmp    800c45 <strncmp+0x51>
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	eb 08                	jmp    800c45 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3d:	0f b6 03             	movzbl (%ebx),%eax
  800c40:	0f b6 12             	movzbl (%edx),%edx
  800c43:	29 d0                	sub    %edx,%eax
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	53                   	push   %ebx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800c53:	0f b6 18             	movzbl (%eax),%ebx
  800c56:	84 db                	test   %bl,%bl
  800c58:	74 1d                	je     800c77 <strchr+0x2e>
  800c5a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800c5c:	38 d3                	cmp    %dl,%bl
  800c5e:	75 06                	jne    800c66 <strchr+0x1d>
  800c60:	eb 1a                	jmp    800c7c <strchr+0x33>
  800c62:	38 ca                	cmp    %cl,%dl
  800c64:	74 16                	je     800c7c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c66:	83 c0 01             	add    $0x1,%eax
  800c69:	0f b6 10             	movzbl (%eax),%edx
  800c6c:	84 d2                	test   %dl,%dl
  800c6e:	75 f2                	jne    800c62 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
  800c75:	eb 05                	jmp    800c7c <strchr+0x33>
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	53                   	push   %ebx
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800c89:	0f b6 18             	movzbl (%eax),%ebx
  800c8c:	84 db                	test   %bl,%bl
  800c8e:	74 16                	je     800ca6 <strfind+0x27>
  800c90:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800c92:	38 d3                	cmp    %dl,%bl
  800c94:	75 06                	jne    800c9c <strfind+0x1d>
  800c96:	eb 0e                	jmp    800ca6 <strfind+0x27>
  800c98:	38 ca                	cmp    %cl,%dl
  800c9a:	74 0a                	je     800ca6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c9c:	83 c0 01             	add    $0x1,%eax
  800c9f:	0f b6 10             	movzbl (%eax),%edx
  800ca2:	84 d2                	test   %dl,%dl
  800ca4:	75 f2                	jne    800c98 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cb5:	85 c9                	test   %ecx,%ecx
  800cb7:	74 36                	je     800cef <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cb9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cbf:	75 28                	jne    800ce9 <memset+0x40>
  800cc1:	f6 c1 03             	test   $0x3,%cl
  800cc4:	75 23                	jne    800ce9 <memset+0x40>
		c &= 0xFF;
  800cc6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cca:	89 d3                	mov    %edx,%ebx
  800ccc:	c1 e3 08             	shl    $0x8,%ebx
  800ccf:	89 d6                	mov    %edx,%esi
  800cd1:	c1 e6 18             	shl    $0x18,%esi
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	c1 e0 10             	shl    $0x10,%eax
  800cd9:	09 f0                	or     %esi,%eax
  800cdb:	09 c2                	or     %eax,%edx
  800cdd:	89 d0                	mov    %edx,%eax
  800cdf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ce1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ce4:	fc                   	cld    
  800ce5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ce7:	eb 06                	jmp    800cef <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cec:	fc                   	cld    
  800ced:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cef:	89 f8                	mov    %edi,%eax
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d04:	39 c6                	cmp    %eax,%esi
  800d06:	73 35                	jae    800d3d <memmove+0x47>
  800d08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d0b:	39 d0                	cmp    %edx,%eax
  800d0d:	73 2e                	jae    800d3d <memmove+0x47>
		s += n;
		d += n;
  800d0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d12:	89 d6                	mov    %edx,%esi
  800d14:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d1c:	75 13                	jne    800d31 <memmove+0x3b>
  800d1e:	f6 c1 03             	test   $0x3,%cl
  800d21:	75 0e                	jne    800d31 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d23:	83 ef 04             	sub    $0x4,%edi
  800d26:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d29:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d2c:	fd                   	std    
  800d2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2f:	eb 09                	jmp    800d3a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d31:	83 ef 01             	sub    $0x1,%edi
  800d34:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d37:	fd                   	std    
  800d38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d3a:	fc                   	cld    
  800d3b:	eb 1d                	jmp    800d5a <memmove+0x64>
  800d3d:	89 f2                	mov    %esi,%edx
  800d3f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d41:	f6 c2 03             	test   $0x3,%dl
  800d44:	75 0f                	jne    800d55 <memmove+0x5f>
  800d46:	f6 c1 03             	test   $0x3,%cl
  800d49:	75 0a                	jne    800d55 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d4b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d4e:	89 c7                	mov    %eax,%edi
  800d50:	fc                   	cld    
  800d51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d53:	eb 05                	jmp    800d5a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d55:	89 c7                	mov    %eax,%edi
  800d57:	fc                   	cld    
  800d58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d64:	8b 45 10             	mov    0x10(%ebp),%eax
  800d67:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	89 04 24             	mov    %eax,(%esp)
  800d78:	e8 79 ff ff ff       	call   800cf6 <memmove>
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	57                   	push   %edi
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
  800d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d8e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800d91:	85 c0                	test   %eax,%eax
  800d93:	74 36                	je     800dcb <memcmp+0x4c>
		if (*s1 != *s2)
  800d95:	0f b6 03             	movzbl (%ebx),%eax
  800d98:	0f b6 0e             	movzbl (%esi),%ecx
  800d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800da0:	38 c8                	cmp    %cl,%al
  800da2:	74 1c                	je     800dc0 <memcmp+0x41>
  800da4:	eb 10                	jmp    800db6 <memcmp+0x37>
  800da6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800db2:	38 c8                	cmp    %cl,%al
  800db4:	74 0a                	je     800dc0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800db6:	0f b6 c0             	movzbl %al,%eax
  800db9:	0f b6 c9             	movzbl %cl,%ecx
  800dbc:	29 c8                	sub    %ecx,%eax
  800dbe:	eb 10                	jmp    800dd0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dc0:	39 fa                	cmp    %edi,%edx
  800dc2:	75 e2                	jne    800da6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc9:	eb 05                	jmp    800dd0 <memcmp+0x51>
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	53                   	push   %ebx
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800ddf:	89 c2                	mov    %eax,%edx
  800de1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de4:	39 d0                	cmp    %edx,%eax
  800de6:	73 13                	jae    800dfb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de8:	89 d9                	mov    %ebx,%ecx
  800dea:	38 18                	cmp    %bl,(%eax)
  800dec:	75 06                	jne    800df4 <memfind+0x1f>
  800dee:	eb 0b                	jmp    800dfb <memfind+0x26>
  800df0:	38 08                	cmp    %cl,(%eax)
  800df2:	74 07                	je     800dfb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800df4:	83 c0 01             	add    $0x1,%eax
  800df7:	39 d0                	cmp    %edx,%eax
  800df9:	75 f5                	jne    800df0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dfb:	5b                   	pop    %ebx
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	57                   	push   %edi
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0a:	0f b6 0a             	movzbl (%edx),%ecx
  800e0d:	80 f9 09             	cmp    $0x9,%cl
  800e10:	74 05                	je     800e17 <strtol+0x19>
  800e12:	80 f9 20             	cmp    $0x20,%cl
  800e15:	75 10                	jne    800e27 <strtol+0x29>
		s++;
  800e17:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e1a:	0f b6 0a             	movzbl (%edx),%ecx
  800e1d:	80 f9 09             	cmp    $0x9,%cl
  800e20:	74 f5                	je     800e17 <strtol+0x19>
  800e22:	80 f9 20             	cmp    $0x20,%cl
  800e25:	74 f0                	je     800e17 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e27:	80 f9 2b             	cmp    $0x2b,%cl
  800e2a:	75 0a                	jne    800e36 <strtol+0x38>
		s++;
  800e2c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e34:	eb 11                	jmp    800e47 <strtol+0x49>
  800e36:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e3b:	80 f9 2d             	cmp    $0x2d,%cl
  800e3e:	75 07                	jne    800e47 <strtol+0x49>
		s++, neg = 1;
  800e40:	83 c2 01             	add    $0x1,%edx
  800e43:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e47:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e4c:	75 15                	jne    800e63 <strtol+0x65>
  800e4e:	80 3a 30             	cmpb   $0x30,(%edx)
  800e51:	75 10                	jne    800e63 <strtol+0x65>
  800e53:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e57:	75 0a                	jne    800e63 <strtol+0x65>
		s += 2, base = 16;
  800e59:	83 c2 02             	add    $0x2,%edx
  800e5c:	b8 10 00 00 00       	mov    $0x10,%eax
  800e61:	eb 10                	jmp    800e73 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800e63:	85 c0                	test   %eax,%eax
  800e65:	75 0c                	jne    800e73 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e67:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e69:	80 3a 30             	cmpb   $0x30,(%edx)
  800e6c:	75 05                	jne    800e73 <strtol+0x75>
		s++, base = 8;
  800e6e:	83 c2 01             	add    $0x1,%edx
  800e71:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e7b:	0f b6 0a             	movzbl (%edx),%ecx
  800e7e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e81:	89 f0                	mov    %esi,%eax
  800e83:	3c 09                	cmp    $0x9,%al
  800e85:	77 08                	ja     800e8f <strtol+0x91>
			dig = *s - '0';
  800e87:	0f be c9             	movsbl %cl,%ecx
  800e8a:	83 e9 30             	sub    $0x30,%ecx
  800e8d:	eb 20                	jmp    800eaf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800e8f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e92:	89 f0                	mov    %esi,%eax
  800e94:	3c 19                	cmp    $0x19,%al
  800e96:	77 08                	ja     800ea0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800e98:	0f be c9             	movsbl %cl,%ecx
  800e9b:	83 e9 57             	sub    $0x57,%ecx
  800e9e:	eb 0f                	jmp    800eaf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800ea0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ea3:	89 f0                	mov    %esi,%eax
  800ea5:	3c 19                	cmp    $0x19,%al
  800ea7:	77 16                	ja     800ebf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea9:	0f be c9             	movsbl %cl,%ecx
  800eac:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800eaf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800eb2:	7d 0f                	jge    800ec3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800eb4:	83 c2 01             	add    $0x1,%edx
  800eb7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ebb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ebd:	eb bc                	jmp    800e7b <strtol+0x7d>
  800ebf:	89 d8                	mov    %ebx,%eax
  800ec1:	eb 02                	jmp    800ec5 <strtol+0xc7>
  800ec3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ec5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec9:	74 05                	je     800ed0 <strtol+0xd2>
		*endptr = (char *) s;
  800ecb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ece:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ed0:	f7 d8                	neg    %eax
  800ed2:	85 ff                	test   %edi,%edi
  800ed4:	0f 44 c3             	cmove  %ebx,%eax
}
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	89 c3                	mov    %eax,%ebx
  800eef:	89 c7                	mov    %eax,%edi
  800ef1:	89 c6                	mov    %eax,%esi
  800ef3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <sys_cgetc>:

int
sys_cgetc(void)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f00:	ba 00 00 00 00       	mov    $0x0,%edx
  800f05:	b8 01 00 00 00       	mov    $0x1,%eax
  800f0a:	89 d1                	mov    %edx,%ecx
  800f0c:	89 d3                	mov    %edx,%ebx
  800f0e:	89 d7                	mov    %edx,%edi
  800f10:	89 d6                	mov    %edx,%esi
  800f12:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	b8 03 00 00 00       	mov    $0x3,%eax
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7e 28                	jle    800f63 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f46:	00 
  800f47:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f56:	00 
  800f57:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  800f5e:	e8 43 f4 ff ff       	call   8003a6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f63:	83 c4 2c             	add    $0x2c,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	ba 00 00 00 00       	mov    $0x0,%edx
  800f76:	b8 02 00 00 00       	mov    $0x2,%eax
  800f7b:	89 d1                	mov    %edx,%ecx
  800f7d:	89 d3                	mov    %edx,%ebx
  800f7f:	89 d7                	mov    %edx,%edi
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_yield>:

void
sys_yield(void)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f9a:	89 d1                	mov    %edx,%ecx
  800f9c:	89 d3                	mov    %edx,%ebx
  800f9e:	89 d7                	mov    %edx,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	be 00 00 00 00       	mov    $0x0,%esi
  800fb7:	b8 04 00 00 00       	mov    $0x4,%eax
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc5:	89 f7                	mov    %esi,%edi
  800fc7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	7e 28                	jle    800ff5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fd8:	00 
  800fd9:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  800fe0:	00 
  800fe1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800fe8:	00 
  800fe9:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  800ff0:	e8 b1 f3 ff ff       	call   8003a6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ff5:	83 c4 2c             	add    $0x2c,%esp
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
  801003:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801006:	b8 05 00 00 00       	mov    $0x5,%eax
  80100b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801014:	8b 7d 14             	mov    0x14(%ebp),%edi
  801017:	8b 75 18             	mov    0x18(%ebp),%esi
  80101a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	7e 28                	jle    801048 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801020:	89 44 24 10          	mov    %eax,0x10(%esp)
  801024:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80102b:	00 
  80102c:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  801033:	00 
  801034:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80103b:	00 
  80103c:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  801043:	e8 5e f3 ff ff       	call   8003a6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801048:	83 c4 2c             	add    $0x2c,%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	53                   	push   %ebx
  801056:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801059:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105e:	b8 06 00 00 00       	mov    $0x6,%eax
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 df                	mov    %ebx,%edi
  80106b:	89 de                	mov    %ebx,%esi
  80106d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80106f:	85 c0                	test   %eax,%eax
  801071:	7e 28                	jle    80109b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	89 44 24 10          	mov    %eax,0x10(%esp)
  801077:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80107e:	00 
  80107f:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  801086:	00 
  801087:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80108e:	00 
  80108f:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  801096:	e8 0b f3 ff ff       	call   8003a6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80109b:	83 c4 2c             	add    $0x2c,%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	89 df                	mov    %ebx,%edi
  8010be:	89 de                	mov    %ebx,%esi
  8010c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	7e 28                	jle    8010ee <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ca:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010d1:	00 
  8010d2:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  8010d9:	00 
  8010da:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010e1:	00 
  8010e2:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  8010e9:	e8 b8 f2 ff ff       	call   8003a6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ee:	83 c4 2c             	add    $0x2c,%esp
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801104:	b8 09 00 00 00       	mov    $0x9,%eax
  801109:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	89 df                	mov    %ebx,%edi
  801111:	89 de                	mov    %ebx,%esi
  801113:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801115:	85 c0                	test   %eax,%eax
  801117:	7e 28                	jle    801141 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801119:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801124:	00 
  801125:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  80112c:	00 
  80112d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801134:	00 
  801135:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  80113c:	e8 65 f2 ff ff       	call   8003a6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801141:	83 c4 2c             	add    $0x2c,%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801152:	bb 00 00 00 00       	mov    $0x0,%ebx
  801157:	b8 0a 00 00 00       	mov    $0xa,%eax
  80115c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	89 df                	mov    %ebx,%edi
  801164:	89 de                	mov    %ebx,%esi
  801166:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801168:	85 c0                	test   %eax,%eax
  80116a:	7e 28                	jle    801194 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801170:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801177:	00 
  801178:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  80117f:	00 
  801180:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801187:	00 
  801188:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  80118f:	e8 12 f2 ff ff       	call   8003a6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801194:	83 c4 2c             	add    $0x2c,%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a2:	be 00 00 00 00       	mov    $0x0,%esi
  8011a7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011ba:	5b                   	pop    %ebx
  8011bb:	5e                   	pop    %esi
  8011bc:	5f                   	pop    %edi
  8011bd:	5d                   	pop    %ebp
  8011be:	c3                   	ret    

008011bf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011cd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d5:	89 cb                	mov    %ecx,%ebx
  8011d7:	89 cf                	mov    %ecx,%edi
  8011d9:	89 ce                	mov    %ecx,%esi
  8011db:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	7e 28                	jle    801209 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011ec:	00 
  8011ed:	c7 44 24 08 bf 2c 80 	movl   $0x802cbf,0x8(%esp)
  8011f4:	00 
  8011f5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011fc:	00 
  8011fd:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  801204:	e8 9d f1 ff ff       	call   8003a6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801209:	83 c4 2c             	add    $0x2c,%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	53                   	push   %ebx
  801215:	83 ec 24             	sub    $0x24,%esp
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80121b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80121d:	89 da                	mov    %ebx,%edx
  80121f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801222:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801229:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80122d:	74 05                	je     801234 <pgfault+0x23>
  80122f:	f6 c6 08             	test   $0x8,%dh
  801232:	75 1c                	jne    801250 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801234:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  80124b:	e8 56 f1 ff ff       	call   8003a6 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801250:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801257:	00 
  801258:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80125f:	00 
  801260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801267:	e8 3d fd ff ff       	call   800fa9 <sys_page_alloc>
  80126c:	85 c0                	test   %eax,%eax
  80126e:	79 20                	jns    801290 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801270:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801274:	c7 44 24 08 54 2d 80 	movl   $0x802d54,0x8(%esp)
  80127b:	00 
  80127c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801283:	00 
  801284:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  80128b:	e8 16 f1 ff ff       	call   8003a6 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801290:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801296:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80129d:	00 
  80129e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012a9:	e8 48 fa ff ff       	call   800cf6 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8012ae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012b5:	00 
  8012b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c1:	00 
  8012c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012c9:	00 
  8012ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d1:	e8 27 fd ff ff       	call   800ffd <sys_page_map>
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	79 20                	jns    8012fa <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  8012da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012de:	c7 44 24 08 6e 2d 80 	movl   $0x802d6e,0x8(%esp)
  8012e5:	00 
  8012e6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8012ed:	00 
  8012ee:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  8012f5:	e8 ac f0 ff ff       	call   8003a6 <_panic>
	}
}
  8012fa:	83 c4 24             	add    $0x24,%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	57                   	push   %edi
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801309:	c7 04 24 11 12 80 00 	movl   $0x801211,(%esp)
  801310:	e8 71 10 00 00       	call   802386 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801315:	b8 07 00 00 00       	mov    $0x7,%eax
  80131a:	cd 30                	int    $0x30
  80131c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80131f:	85 c0                	test   %eax,%eax
  801321:	79 1c                	jns    80133f <fork+0x3f>
		panic("fork");
  801323:	c7 44 24 08 87 2d 80 	movl   $0x802d87,0x8(%esp)
  80132a:	00 
  80132b:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801332:	00 
  801333:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  80133a:	e8 67 f0 ff ff       	call   8003a6 <_panic>
  80133f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801341:	bb 00 08 00 00       	mov    $0x800,%ebx
  801346:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80134a:	75 21                	jne    80136d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80134c:	e8 1a fc ff ff       	call   800f6b <sys_getenvid>
  801351:	25 ff 03 00 00       	and    $0x3ff,%eax
  801356:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801359:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80135e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	e9 cf 01 00 00       	jmp    80153c <fork+0x23c>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  80136d:	89 d8                	mov    %ebx,%eax
  80136f:	c1 e8 0a             	shr    $0xa,%eax
  801372:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801379:	a8 01                	test   $0x1,%al
  80137b:	0f 84 fc 00 00 00    	je     80147d <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801381:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801388:	a8 05                	test   $0x5,%al
  80138a:	0f 84 ed 00 00 00    	je     80147d <fork+0x17d>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801390:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801397:	89 de                	mov    %ebx,%esi
  801399:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  80139c:	f6 c4 04             	test   $0x4,%ah
  80139f:	0f 85 93 00 00 00    	jne    801438 <fork+0x138>
  8013a5:	a9 02 08 00 00       	test   $0x802,%eax
  8013aa:	0f 84 88 00 00 00    	je     801438 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8013b0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013b7:	00 
  8013b8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013bc:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cb:	e8 2d fc ff ff       	call   800ffd <sys_page_map>
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	79 20                	jns    8013f4 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  8013d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013d8:	c7 44 24 08 8c 2d 80 	movl   $0x802d8c,0x8(%esp)
  8013df:	00 
  8013e0:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8013e7:	00 
  8013e8:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  8013ef:	e8 b2 ef ff ff       	call   8003a6 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  8013f4:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013fb:	00 
  8013fc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801400:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801407:	00 
  801408:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140c:	89 3c 24             	mov    %edi,(%esp)
  80140f:	e8 e9 fb ff ff       	call   800ffd <sys_page_map>
  801414:	85 c0                	test   %eax,%eax
  801416:	79 65                	jns    80147d <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  801418:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80141c:	c7 44 24 08 a6 2d 80 	movl   $0x802da6,0x8(%esp)
  801423:	00 
  801424:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80142b:	00 
  80142c:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  801433:	e8 6e ef ff ff       	call   8003a6 <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  801438:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80143d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801441:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801445:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801449:	89 74 24 04          	mov    %esi,0x4(%esp)
  80144d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801454:	e8 a4 fb ff ff       	call   800ffd <sys_page_map>
  801459:	85 c0                	test   %eax,%eax
  80145b:	79 20                	jns    80147d <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  80145d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801461:	c7 44 24 08 c0 2d 80 	movl   $0x802dc0,0x8(%esp)
  801468:	00 
  801469:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801470:	00 
  801471:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  801478:	e8 29 ef ff ff       	call   8003a6 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  80147d:	83 c3 01             	add    $0x1,%ebx
  801480:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801486:	0f 85 e1 fe ff ff    	jne    80136d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  80148c:	c7 44 24 04 ef 23 80 	movl   $0x8023ef,0x4(%esp)
  801493:	00 
  801494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801497:	89 04 24             	mov    %eax,(%esp)
  80149a:	e8 aa fc ff ff       	call   801149 <sys_env_set_pgfault_upcall>
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	79 20                	jns    8014c3 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8014a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a7:	c7 44 24 08 24 2d 80 	movl   $0x802d24,0x8(%esp)
  8014ae:	00 
  8014af:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  8014b6:	00 
  8014b7:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  8014be:	e8 e3 ee ff ff       	call   8003a6 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8014c3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014ca:	00 
  8014cb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014d2:	ee 
  8014d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d6:	89 04 24             	mov    %eax,(%esp)
  8014d9:	e8 cb fa ff ff       	call   800fa9 <sys_page_alloc>
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	79 20                	jns    801502 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  8014e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e6:	c7 44 24 08 d2 2d 80 	movl   $0x802dd2,0x8(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8014f5:	00 
  8014f6:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  8014fd:	e8 a4 ee ff ff       	call   8003a6 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801502:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801509:	00 
  80150a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150d:	89 04 24             	mov    %eax,(%esp)
  801510:	e8 8e fb ff ff       	call   8010a3 <sys_env_set_status>
  801515:	85 c0                	test   %eax,%eax
  801517:	79 20                	jns    801539 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  801519:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80151d:	c7 44 24 08 ea 2d 80 	movl   $0x802dea,0x8(%esp)
  801524:	00 
  801525:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  80152c:	00 
  80152d:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  801534:	e8 6d ee ff ff       	call   8003a6 <_panic>
	}

	return envid;
  801539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80153c:	83 c4 2c             	add    $0x2c,%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5f                   	pop    %edi
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    

00801544 <sfork>:

// Challenge!
int
sfork(void)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80154a:	c7 44 24 08 05 2e 80 	movl   $0x802e05,0x8(%esp)
  801551:	00 
  801552:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  801559:	00 
  80155a:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  801561:	e8 40 ee ff ff       	call   8003a6 <_panic>
  801566:	66 90                	xchg   %ax,%ax
  801568:	66 90                	xchg   %ax,%ax
  80156a:	66 90                	xchg   %ax,%ax
  80156c:	66 90                	xchg   %ax,%ax
  80156e:	66 90                	xchg   %ax,%ax

00801570 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	05 00 00 00 30       	add    $0x30000000,%eax
  80157b:	c1 e8 0c             	shr    $0xc,%eax
}
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80158b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801590:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801595:	5d                   	pop    %ebp
  801596:	c3                   	ret    

00801597 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80159a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80159f:	a8 01                	test   $0x1,%al
  8015a1:	74 34                	je     8015d7 <fd_alloc+0x40>
  8015a3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8015a8:	a8 01                	test   $0x1,%al
  8015aa:	74 32                	je     8015de <fd_alloc+0x47>
  8015ac:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015b1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	c1 ea 16             	shr    $0x16,%edx
  8015b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015bf:	f6 c2 01             	test   $0x1,%dl
  8015c2:	74 1f                	je     8015e3 <fd_alloc+0x4c>
  8015c4:	89 c2                	mov    %eax,%edx
  8015c6:	c1 ea 0c             	shr    $0xc,%edx
  8015c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015d0:	f6 c2 01             	test   $0x1,%dl
  8015d3:	75 1a                	jne    8015ef <fd_alloc+0x58>
  8015d5:	eb 0c                	jmp    8015e3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015d7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8015dc:	eb 05                	jmp    8015e3 <fd_alloc+0x4c>
  8015de:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	eb 1a                	jmp    801609 <fd_alloc+0x72>
  8015ef:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015f4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015f9:	75 b6                	jne    8015b1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801604:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801611:	83 f8 1f             	cmp    $0x1f,%eax
  801614:	77 36                	ja     80164c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801616:	c1 e0 0c             	shl    $0xc,%eax
  801619:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80161e:	89 c2                	mov    %eax,%edx
  801620:	c1 ea 16             	shr    $0x16,%edx
  801623:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80162a:	f6 c2 01             	test   $0x1,%dl
  80162d:	74 24                	je     801653 <fd_lookup+0x48>
  80162f:	89 c2                	mov    %eax,%edx
  801631:	c1 ea 0c             	shr    $0xc,%edx
  801634:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80163b:	f6 c2 01             	test   $0x1,%dl
  80163e:	74 1a                	je     80165a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801640:	8b 55 0c             	mov    0xc(%ebp),%edx
  801643:	89 02                	mov    %eax,(%edx)
	return 0;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb 13                	jmp    80165f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80164c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801651:	eb 0c                	jmp    80165f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801658:	eb 05                	jmp    80165f <fd_lookup+0x54>
  80165a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    

00801661 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	53                   	push   %ebx
  801665:	83 ec 14             	sub    $0x14,%esp
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80166e:	39 05 08 30 80 00    	cmp    %eax,0x803008
  801674:	75 1e                	jne    801694 <dev_lookup+0x33>
  801676:	eb 0e                	jmp    801686 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801678:	b8 24 30 80 00       	mov    $0x803024,%eax
  80167d:	eb 0c                	jmp    80168b <dev_lookup+0x2a>
  80167f:	b8 40 30 80 00       	mov    $0x803040,%eax
  801684:	eb 05                	jmp    80168b <dev_lookup+0x2a>
  801686:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80168b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 38                	jmp    8016cc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801694:	39 05 24 30 80 00    	cmp    %eax,0x803024
  80169a:	74 dc                	je     801678 <dev_lookup+0x17>
  80169c:	39 05 40 30 80 00    	cmp    %eax,0x803040
  8016a2:	74 db                	je     80167f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016a4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016aa:	8b 52 48             	mov    0x48(%edx),%edx
  8016ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016b5:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8016bc:	e8 de ed ff ff       	call   80049f <cprintf>
	*dev = 0;
  8016c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8016c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016cc:	83 c4 14             	add    $0x14,%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    

008016d2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 20             	sub    $0x20,%esp
  8016da:	8b 75 08             	mov    0x8(%ebp),%esi
  8016dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016e7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016ed:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f0:	89 04 24             	mov    %eax,(%esp)
  8016f3:	e8 13 ff ff ff       	call   80160b <fd_lookup>
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 05                	js     801701 <fd_close+0x2f>
	    || fd != fd2)
  8016fc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016ff:	74 0c                	je     80170d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801701:	84 db                	test   %bl,%bl
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	0f 44 c2             	cmove  %edx,%eax
  80170b:	eb 3f                	jmp    80174c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80170d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801710:	89 44 24 04          	mov    %eax,0x4(%esp)
  801714:	8b 06                	mov    (%esi),%eax
  801716:	89 04 24             	mov    %eax,(%esp)
  801719:	e8 43 ff ff ff       	call   801661 <dev_lookup>
  80171e:	89 c3                	mov    %eax,%ebx
  801720:	85 c0                	test   %eax,%eax
  801722:	78 16                	js     80173a <fd_close+0x68>
		if (dev->dev_close)
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80172a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 07                	je     80173a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801733:	89 34 24             	mov    %esi,(%esp)
  801736:	ff d0                	call   *%eax
  801738:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80173a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80173e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801745:	e8 06 f9 ff ff       	call   801050 <sys_page_unmap>
	return r;
  80174a:	89 d8                	mov    %ebx,%eax
}
  80174c:	83 c4 20             	add    $0x20,%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801759:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	89 04 24             	mov    %eax,(%esp)
  801766:	e8 a0 fe ff ff       	call   80160b <fd_lookup>
  80176b:	89 c2                	mov    %eax,%edx
  80176d:	85 d2                	test   %edx,%edx
  80176f:	78 13                	js     801784 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801771:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801778:	00 
  801779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177c:	89 04 24             	mov    %eax,(%esp)
  80177f:	e8 4e ff ff ff       	call   8016d2 <fd_close>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <close_all>:

void
close_all(void)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	53                   	push   %ebx
  80178a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80178d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801792:	89 1c 24             	mov    %ebx,(%esp)
  801795:	e8 b9 ff ff ff       	call   801753 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80179a:	83 c3 01             	add    $0x1,%ebx
  80179d:	83 fb 20             	cmp    $0x20,%ebx
  8017a0:	75 f0                	jne    801792 <close_all+0xc>
		close(i);
}
  8017a2:	83 c4 14             	add    $0x14,%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    

008017a8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	57                   	push   %edi
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	89 04 24             	mov    %eax,(%esp)
  8017be:	e8 48 fe ff ff       	call   80160b <fd_lookup>
  8017c3:	89 c2                	mov    %eax,%edx
  8017c5:	85 d2                	test   %edx,%edx
  8017c7:	0f 88 e1 00 00 00    	js     8018ae <dup+0x106>
		return r;
	close(newfdnum);
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	89 04 24             	mov    %eax,(%esp)
  8017d3:	e8 7b ff ff ff       	call   801753 <close>

	newfd = INDEX2FD(newfdnum);
  8017d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017db:	c1 e3 0c             	shl    $0xc,%ebx
  8017de:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e7:	89 04 24             	mov    %eax,(%esp)
  8017ea:	e8 91 fd ff ff       	call   801580 <fd2data>
  8017ef:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017f1:	89 1c 24             	mov    %ebx,(%esp)
  8017f4:	e8 87 fd ff ff       	call   801580 <fd2data>
  8017f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017fb:	89 f0                	mov    %esi,%eax
  8017fd:	c1 e8 16             	shr    $0x16,%eax
  801800:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801807:	a8 01                	test   $0x1,%al
  801809:	74 43                	je     80184e <dup+0xa6>
  80180b:	89 f0                	mov    %esi,%eax
  80180d:	c1 e8 0c             	shr    $0xc,%eax
  801810:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801817:	f6 c2 01             	test   $0x1,%dl
  80181a:	74 32                	je     80184e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80181c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801823:	25 07 0e 00 00       	and    $0xe07,%eax
  801828:	89 44 24 10          	mov    %eax,0x10(%esp)
  80182c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801830:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801837:	00 
  801838:	89 74 24 04          	mov    %esi,0x4(%esp)
  80183c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801843:	e8 b5 f7 ff ff       	call   800ffd <sys_page_map>
  801848:	89 c6                	mov    %eax,%esi
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 3e                	js     80188c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80184e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801851:	89 c2                	mov    %eax,%edx
  801853:	c1 ea 0c             	shr    $0xc,%edx
  801856:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80185d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801863:	89 54 24 10          	mov    %edx,0x10(%esp)
  801867:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80186b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801872:	00 
  801873:	89 44 24 04          	mov    %eax,0x4(%esp)
  801877:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80187e:	e8 7a f7 ff ff       	call   800ffd <sys_page_map>
  801883:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801888:	85 f6                	test   %esi,%esi
  80188a:	79 22                	jns    8018ae <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80188c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801897:	e8 b4 f7 ff ff       	call   801050 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80189c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a7:	e8 a4 f7 ff ff       	call   801050 <sys_page_unmap>
	return r;
  8018ac:	89 f0                	mov    %esi,%eax
}
  8018ae:	83 c4 3c             	add    $0x3c,%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5f                   	pop    %edi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 24             	sub    $0x24,%esp
  8018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	89 1c 24             	mov    %ebx,(%esp)
  8018ca:	e8 3c fd ff ff       	call   80160b <fd_lookup>
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	85 d2                	test   %edx,%edx
  8018d3:	78 6d                	js     801942 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	89 04 24             	mov    %eax,(%esp)
  8018e4:	e8 78 fd ff ff       	call   801661 <dev_lookup>
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 55                	js     801942 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f0:	8b 50 08             	mov    0x8(%eax),%edx
  8018f3:	83 e2 03             	and    $0x3,%edx
  8018f6:	83 fa 01             	cmp    $0x1,%edx
  8018f9:	75 23                	jne    80191e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018fb:	a1 04 40 80 00       	mov    0x804004,%eax
  801900:	8b 40 48             	mov    0x48(%eax),%eax
  801903:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	c7 04 24 5d 2e 80 00 	movl   $0x802e5d,(%esp)
  801912:	e8 88 eb ff ff       	call   80049f <cprintf>
		return -E_INVAL;
  801917:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80191c:	eb 24                	jmp    801942 <read+0x8c>
	}
	if (!dev->dev_read)
  80191e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801921:	8b 52 08             	mov    0x8(%edx),%edx
  801924:	85 d2                	test   %edx,%edx
  801926:	74 15                	je     80193d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801936:	89 04 24             	mov    %eax,(%esp)
  801939:	ff d2                	call   *%edx
  80193b:	eb 05                	jmp    801942 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80193d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801942:	83 c4 24             	add    $0x24,%esp
  801945:	5b                   	pop    %ebx
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    

00801948 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	57                   	push   %edi
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
  80194e:	83 ec 1c             	sub    $0x1c,%esp
  801951:	8b 7d 08             	mov    0x8(%ebp),%edi
  801954:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801957:	85 f6                	test   %esi,%esi
  801959:	74 33                	je     80198e <readn+0x46>
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
  801960:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801965:	89 f2                	mov    %esi,%edx
  801967:	29 c2                	sub    %eax,%edx
  801969:	89 54 24 08          	mov    %edx,0x8(%esp)
  80196d:	03 45 0c             	add    0xc(%ebp),%eax
  801970:	89 44 24 04          	mov    %eax,0x4(%esp)
  801974:	89 3c 24             	mov    %edi,(%esp)
  801977:	e8 3a ff ff ff       	call   8018b6 <read>
		if (m < 0)
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 1b                	js     80199b <readn+0x53>
			return m;
		if (m == 0)
  801980:	85 c0                	test   %eax,%eax
  801982:	74 11                	je     801995 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801984:	01 c3                	add    %eax,%ebx
  801986:	89 d8                	mov    %ebx,%eax
  801988:	39 f3                	cmp    %esi,%ebx
  80198a:	72 d9                	jb     801965 <readn+0x1d>
  80198c:	eb 0b                	jmp    801999 <readn+0x51>
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
  801993:	eb 06                	jmp    80199b <readn+0x53>
  801995:	89 d8                	mov    %ebx,%eax
  801997:	eb 02                	jmp    80199b <readn+0x53>
  801999:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80199b:	83 c4 1c             	add    $0x1c,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	53                   	push   %ebx
  8019a7:	83 ec 24             	sub    $0x24,%esp
  8019aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b4:	89 1c 24             	mov    %ebx,(%esp)
  8019b7:	e8 4f fc ff ff       	call   80160b <fd_lookup>
  8019bc:	89 c2                	mov    %eax,%edx
  8019be:	85 d2                	test   %edx,%edx
  8019c0:	78 68                	js     801a2a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	89 04 24             	mov    %eax,(%esp)
  8019d1:	e8 8b fc ff ff       	call   801661 <dev_lookup>
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 50                	js     801a2a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e1:	75 23                	jne    801a06 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e8:	8b 40 48             	mov    0x48(%eax),%eax
  8019eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f3:	c7 04 24 79 2e 80 00 	movl   $0x802e79,(%esp)
  8019fa:	e8 a0 ea ff ff       	call   80049f <cprintf>
		return -E_INVAL;
  8019ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a04:	eb 24                	jmp    801a2a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a09:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0c:	85 d2                	test   %edx,%edx
  801a0e:	74 15                	je     801a25 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a1e:	89 04 24             	mov    %eax,(%esp)
  801a21:	ff d2                	call   *%edx
  801a23:	eb 05                	jmp    801a2a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a2a:	83 c4 24             	add    $0x24,%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a36:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	89 04 24             	mov    %eax,(%esp)
  801a43:	e8 c3 fb ff ff       	call   80160b <fd_lookup>
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 0e                	js     801a5a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a52:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 24             	sub    $0x24,%esp
  801a63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a66:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6d:	89 1c 24             	mov    %ebx,(%esp)
  801a70:	e8 96 fb ff ff       	call   80160b <fd_lookup>
  801a75:	89 c2                	mov    %eax,%edx
  801a77:	85 d2                	test   %edx,%edx
  801a79:	78 61                	js     801adc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	89 04 24             	mov    %eax,(%esp)
  801a8a:	e8 d2 fb ff ff       	call   801661 <dev_lookup>
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 49                	js     801adc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a96:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a9a:	75 23                	jne    801abf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a9c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aa1:	8b 40 48             	mov    0x48(%eax),%eax
  801aa4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aac:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  801ab3:	e8 e7 e9 ff ff       	call   80049f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801abd:	eb 1d                	jmp    801adc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac2:	8b 52 18             	mov    0x18(%edx),%edx
  801ac5:	85 d2                	test   %edx,%edx
  801ac7:	74 0e                	je     801ad7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801acc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad0:	89 04 24             	mov    %eax,(%esp)
  801ad3:	ff d2                	call   *%edx
  801ad5:	eb 05                	jmp    801adc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801ad7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801adc:	83 c4 24             	add    $0x24,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 24             	sub    $0x24,%esp
  801ae9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	89 04 24             	mov    %eax,(%esp)
  801af9:	e8 0d fb ff ff       	call   80160b <fd_lookup>
  801afe:	89 c2                	mov    %eax,%edx
  801b00:	85 d2                	test   %edx,%edx
  801b02:	78 52                	js     801b56 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	89 04 24             	mov    %eax,(%esp)
  801b13:	e8 49 fb ff ff       	call   801661 <dev_lookup>
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 3a                	js     801b56 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b23:	74 2c                	je     801b51 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b25:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b28:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b2f:	00 00 00 
	stat->st_isdir = 0;
  801b32:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b39:	00 00 00 
	stat->st_dev = dev;
  801b3c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b49:	89 14 24             	mov    %edx,(%esp)
  801b4c:	ff 50 14             	call   *0x14(%eax)
  801b4f:	eb 05                	jmp    801b56 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b56:	83 c4 24             	add    $0x24,%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b6b:	00 
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 af 01 00 00       	call   801d26 <open>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	85 db                	test   %ebx,%ebx
  801b7b:	78 1b                	js     801b98 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b84:	89 1c 24             	mov    %ebx,(%esp)
  801b87:	e8 56 ff ff ff       	call   801ae2 <fstat>
  801b8c:	89 c6                	mov    %eax,%esi
	close(fd);
  801b8e:	89 1c 24             	mov    %ebx,(%esp)
  801b91:	e8 bd fb ff ff       	call   801753 <close>
	return r;
  801b96:	89 f0                	mov    %esi,%eax
}
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 10             	sub    $0x10,%esp
  801ba7:	89 c6                	mov    %eax,%esi
  801ba9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801bb2:	75 11                	jne    801bc5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bbb:	e8 4e 09 00 00       	call   80250e <ipc_find_env>
  801bc0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bc5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bcc:	00 
  801bcd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801bd4:	00 
  801bd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bd9:	a1 00 40 80 00       	mov    0x804000,%eax
  801bde:	89 04 24             	mov    %eax,(%esp)
  801be1:	e8 c2 08 00 00       	call   8024a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801be6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bed:	00 
  801bee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bf2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf9:	e8 42 08 00 00       	call   802440 <ipc_recv>
}
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5e                   	pop    %esi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	83 ec 14             	sub    $0x14,%esp
  801c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 40 0c             	mov    0xc(%eax),%eax
  801c15:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c24:	e8 76 ff ff ff       	call   801b9f <fsipc>
  801c29:	89 c2                	mov    %eax,%edx
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	78 2b                	js     801c5a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c2f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c36:	00 
  801c37:	89 1c 24             	mov    %ebx,(%esp)
  801c3a:	e8 bc ee ff ff       	call   800afb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c3f:	a1 80 50 80 00       	mov    0x805080,%eax
  801c44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c4a:	a1 84 50 80 00       	mov    0x805084,%eax
  801c4f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5a:	83 c4 14             	add    $0x14,%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c71:	ba 00 00 00 00       	mov    $0x0,%edx
  801c76:	b8 06 00 00 00       	mov    $0x6,%eax
  801c7b:	e8 1f ff ff ff       	call   801b9f <fsipc>
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	56                   	push   %esi
  801c86:	53                   	push   %ebx
  801c87:	83 ec 10             	sub    $0x10,%esp
  801c8a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	8b 40 0c             	mov    0xc(%eax),%eax
  801c93:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c98:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ca8:	e8 f2 fe ff ff       	call   801b9f <fsipc>
  801cad:	89 c3                	mov    %eax,%ebx
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 6a                	js     801d1d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cb3:	39 c6                	cmp    %eax,%esi
  801cb5:	73 24                	jae    801cdb <devfile_read+0x59>
  801cb7:	c7 44 24 0c 96 2e 80 	movl   $0x802e96,0xc(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 08 9d 2e 80 	movl   $0x802e9d,0x8(%esp)
  801cc6:	00 
  801cc7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801cce:	00 
  801ccf:	c7 04 24 b2 2e 80 00 	movl   $0x802eb2,(%esp)
  801cd6:	e8 cb e6 ff ff       	call   8003a6 <_panic>
	assert(r <= PGSIZE);
  801cdb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce0:	7e 24                	jle    801d06 <devfile_read+0x84>
  801ce2:	c7 44 24 0c bd 2e 80 	movl   $0x802ebd,0xc(%esp)
  801ce9:	00 
  801cea:	c7 44 24 08 9d 2e 80 	movl   $0x802e9d,0x8(%esp)
  801cf1:	00 
  801cf2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801cf9:	00 
  801cfa:	c7 04 24 b2 2e 80 00 	movl   $0x802eb2,(%esp)
  801d01:	e8 a0 e6 ff ff       	call   8003a6 <_panic>
	memmove(buf, &fsipcbuf, r);
  801d06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d0a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d11:	00 
  801d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d15:	89 04 24             	mov    %eax,(%esp)
  801d18:	e8 d9 ef ff ff       	call   800cf6 <memmove>
	return r;
}
  801d1d:	89 d8                	mov    %ebx,%eax
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    

00801d26 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	53                   	push   %ebx
  801d2a:	83 ec 24             	sub    $0x24,%esp
  801d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d30:	89 1c 24             	mov    %ebx,(%esp)
  801d33:	e8 68 ed ff ff       	call   800aa0 <strlen>
  801d38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d3d:	7f 60                	jg     801d9f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 4d f8 ff ff       	call   801597 <fd_alloc>
  801d4a:	89 c2                	mov    %eax,%edx
  801d4c:	85 d2                	test   %edx,%edx
  801d4e:	78 54                	js     801da4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d54:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d5b:	e8 9b ed ff ff       	call   800afb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d63:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d70:	e8 2a fe ff ff       	call   801b9f <fsipc>
  801d75:	89 c3                	mov    %eax,%ebx
  801d77:	85 c0                	test   %eax,%eax
  801d79:	79 17                	jns    801d92 <open+0x6c>
		fd_close(fd, 0);
  801d7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d82:	00 
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 44 f9 ff ff       	call   8016d2 <fd_close>
		return r;
  801d8e:	89 d8                	mov    %ebx,%eax
  801d90:	eb 12                	jmp    801da4 <open+0x7e>
	}
	return fd2num(fd);
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	89 04 24             	mov    %eax,(%esp)
  801d98:	e8 d3 f7 ff ff       	call   801570 <fd2num>
  801d9d:	eb 05                	jmp    801da4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d9f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801da4:	83 c4 24             	add    $0x24,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	66 90                	xchg   %ax,%ax
  801dae:	66 90                	xchg   %ax,%ax

00801db0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 10             	sub    $0x10,%esp
  801db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	89 04 24             	mov    %eax,(%esp)
  801dc1:	e8 ba f7 ff ff       	call   801580 <fd2data>
  801dc6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc8:	c7 44 24 04 c9 2e 80 	movl   $0x802ec9,0x4(%esp)
  801dcf:	00 
  801dd0:	89 1c 24             	mov    %ebx,(%esp)
  801dd3:	e8 23 ed ff ff       	call   800afb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd8:	8b 46 04             	mov    0x4(%esi),%eax
  801ddb:	2b 06                	sub    (%esi),%eax
  801ddd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dea:	00 00 00 
	stat->st_dev = &devpipe;
  801ded:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801df4:	30 80 00 
	return 0;
}
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	53                   	push   %ebx
  801e07:	83 ec 14             	sub    $0x14,%esp
  801e0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e0d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e18:	e8 33 f2 ff ff       	call   801050 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e1d:	89 1c 24             	mov    %ebx,(%esp)
  801e20:	e8 5b f7 ff ff       	call   801580 <fd2data>
  801e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e30:	e8 1b f2 ff ff       	call   801050 <sys_page_unmap>
}
  801e35:	83 c4 14             	add    $0x14,%esp
  801e38:	5b                   	pop    %ebx
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    

00801e3b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	53                   	push   %ebx
  801e41:	83 ec 2c             	sub    $0x2c,%esp
  801e44:	89 c6                	mov    %eax,%esi
  801e46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e49:	a1 04 40 80 00       	mov    0x804004,%eax
  801e4e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e51:	89 34 24             	mov    %esi,(%esp)
  801e54:	e8 fd 06 00 00       	call   802556 <pageref>
  801e59:	89 c7                	mov    %eax,%edi
  801e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	e8 f0 06 00 00       	call   802556 <pageref>
  801e66:	39 c7                	cmp    %eax,%edi
  801e68:	0f 94 c2             	sete   %dl
  801e6b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e6e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801e74:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e77:	39 fb                	cmp    %edi,%ebx
  801e79:	74 21                	je     801e9c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e7b:	84 d2                	test   %dl,%dl
  801e7d:	74 ca                	je     801e49 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e7f:	8b 51 58             	mov    0x58(%ecx),%edx
  801e82:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e86:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e8e:	c7 04 24 d0 2e 80 00 	movl   $0x802ed0,(%esp)
  801e95:	e8 05 e6 ff ff       	call   80049f <cprintf>
  801e9a:	eb ad                	jmp    801e49 <_pipeisclosed+0xe>
	}
}
  801e9c:	83 c4 2c             	add    $0x2c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	83 ec 1c             	sub    $0x1c,%esp
  801ead:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801eb0:	89 34 24             	mov    %esi,(%esp)
  801eb3:	e8 c8 f6 ff ff       	call   801580 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ebc:	74 61                	je     801f1f <devpipe_write+0x7b>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec5:	eb 4a                	jmp    801f11 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ec7:	89 da                	mov    %ebx,%edx
  801ec9:	89 f0                	mov    %esi,%eax
  801ecb:	e8 6b ff ff ff       	call   801e3b <_pipeisclosed>
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	75 54                	jne    801f28 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ed4:	e8 b1 f0 ff ff       	call   800f8a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ed9:	8b 43 04             	mov    0x4(%ebx),%eax
  801edc:	8b 0b                	mov    (%ebx),%ecx
  801ede:	8d 51 20             	lea    0x20(%ecx),%edx
  801ee1:	39 d0                	cmp    %edx,%eax
  801ee3:	73 e2                	jae    801ec7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eef:	99                   	cltd   
  801ef0:	c1 ea 1b             	shr    $0x1b,%edx
  801ef3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ef6:	83 e1 1f             	and    $0x1f,%ecx
  801ef9:	29 d1                	sub    %edx,%ecx
  801efb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801eff:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f03:	83 c0 01             	add    $0x1,%eax
  801f06:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f09:	83 c7 01             	add    $0x1,%edi
  801f0c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f0f:	74 13                	je     801f24 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f11:	8b 43 04             	mov    0x4(%ebx),%eax
  801f14:	8b 0b                	mov    (%ebx),%ecx
  801f16:	8d 51 20             	lea    0x20(%ecx),%edx
  801f19:	39 d0                	cmp    %edx,%eax
  801f1b:	73 aa                	jae    801ec7 <devpipe_write+0x23>
  801f1d:	eb c6                	jmp    801ee5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f1f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f24:	89 f8                	mov    %edi,%eax
  801f26:	eb 05                	jmp    801f2d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    

00801f35 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	57                   	push   %edi
  801f39:	56                   	push   %esi
  801f3a:	53                   	push   %ebx
  801f3b:	83 ec 1c             	sub    $0x1c,%esp
  801f3e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f41:	89 3c 24             	mov    %edi,(%esp)
  801f44:	e8 37 f6 ff ff       	call   801580 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f4d:	74 54                	je     801fa3 <devpipe_read+0x6e>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	be 00 00 00 00       	mov    $0x0,%esi
  801f56:	eb 3e                	jmp    801f96 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f58:	89 f0                	mov    %esi,%eax
  801f5a:	eb 55                	jmp    801fb1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f5c:	89 da                	mov    %ebx,%edx
  801f5e:	89 f8                	mov    %edi,%eax
  801f60:	e8 d6 fe ff ff       	call   801e3b <_pipeisclosed>
  801f65:	85 c0                	test   %eax,%eax
  801f67:	75 43                	jne    801fac <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f69:	e8 1c f0 ff ff       	call   800f8a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f6e:	8b 03                	mov    (%ebx),%eax
  801f70:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f73:	74 e7                	je     801f5c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f75:	99                   	cltd   
  801f76:	c1 ea 1b             	shr    $0x1b,%edx
  801f79:	01 d0                	add    %edx,%eax
  801f7b:	83 e0 1f             	and    $0x1f,%eax
  801f7e:	29 d0                	sub    %edx,%eax
  801f80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f8b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f8e:	83 c6 01             	add    $0x1,%esi
  801f91:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f94:	74 12                	je     801fa8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801f96:	8b 03                	mov    (%ebx),%eax
  801f98:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f9b:	75 d8                	jne    801f75 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f9d:	85 f6                	test   %esi,%esi
  801f9f:	75 b7                	jne    801f58 <devpipe_read+0x23>
  801fa1:	eb b9                	jmp    801f5c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fa3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fa8:	89 f0                	mov    %esi,%eax
  801faa:	eb 05                	jmp    801fb1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801fb1:	83 c4 1c             	add    $0x1c,%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	5f                   	pop    %edi
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	56                   	push   %esi
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc4:	89 04 24             	mov    %eax,(%esp)
  801fc7:	e8 cb f5 ff ff       	call   801597 <fd_alloc>
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	85 d2                	test   %edx,%edx
  801fd0:	0f 88 4d 01 00 00    	js     802123 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fdd:	00 
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 b8 ef ff ff       	call   800fa9 <sys_page_alloc>
  801ff1:	89 c2                	mov    %eax,%edx
  801ff3:	85 d2                	test   %edx,%edx
  801ff5:	0f 88 28 01 00 00    	js     802123 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ffb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 91 f5 ff ff       	call   801597 <fd_alloc>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	85 c0                	test   %eax,%eax
  80200a:	0f 88 fe 00 00 00    	js     80210e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802010:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802017:	00 
  802018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802026:	e8 7e ef ff ff       	call   800fa9 <sys_page_alloc>
  80202b:	89 c3                	mov    %eax,%ebx
  80202d:	85 c0                	test   %eax,%eax
  80202f:	0f 88 d9 00 00 00    	js     80210e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	89 04 24             	mov    %eax,(%esp)
  80203b:	e8 40 f5 ff ff       	call   801580 <fd2data>
  802040:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802042:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802049:	00 
  80204a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802055:	e8 4f ef ff ff       	call   800fa9 <sys_page_alloc>
  80205a:	89 c3                	mov    %eax,%ebx
  80205c:	85 c0                	test   %eax,%eax
  80205e:	0f 88 97 00 00 00    	js     8020fb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	89 04 24             	mov    %eax,(%esp)
  80206a:	e8 11 f5 ff ff       	call   801580 <fd2data>
  80206f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802076:	00 
  802077:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802082:	00 
  802083:	89 74 24 04          	mov    %esi,0x4(%esp)
  802087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80208e:	e8 6a ef ff ff       	call   800ffd <sys_page_map>
  802093:	89 c3                	mov    %eax,%ebx
  802095:	85 c0                	test   %eax,%eax
  802097:	78 52                	js     8020eb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802099:	8b 15 24 30 80 00    	mov    0x803024,%edx
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020ae:	8b 15 24 30 80 00    	mov    0x803024,%edx
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	89 04 24             	mov    %eax,(%esp)
  8020c9:	e8 a2 f4 ff ff       	call   801570 <fd2num>
  8020ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 92 f4 ff ff       	call   801570 <fd2num>
  8020de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e9:	eb 38                	jmp    802123 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f6:	e8 55 ef ff ff       	call   801050 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802109:	e8 42 ef ff ff       	call   801050 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	89 44 24 04          	mov    %eax,0x4(%esp)
  802115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80211c:	e8 2f ef ff ff       	call   801050 <sys_page_unmap>
  802121:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802123:	83 c4 30             	add    $0x30,%esp
  802126:	5b                   	pop    %ebx
  802127:	5e                   	pop    %esi
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    

0080212a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802130:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	89 04 24             	mov    %eax,(%esp)
  80213d:	e8 c9 f4 ff ff       	call   80160b <fd_lookup>
  802142:	89 c2                	mov    %eax,%edx
  802144:	85 d2                	test   %edx,%edx
  802146:	78 15                	js     80215d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	89 04 24             	mov    %eax,(%esp)
  80214e:	e8 2d f4 ff ff       	call   801580 <fd2data>
	return _pipeisclosed(fd, p);
  802153:	89 c2                	mov    %eax,%edx
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	e8 de fc ff ff       	call   801e3b <_pipeisclosed>
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 10             	sub    $0x10,%esp
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 24                	jne    802192 <wait+0x33>
  80216e:	c7 44 24 0c e8 2e 80 	movl   $0x802ee8,0xc(%esp)
  802175:	00 
  802176:	c7 44 24 08 9d 2e 80 	movl   $0x802e9d,0x8(%esp)
  80217d:	00 
  80217e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802185:	00 
  802186:	c7 04 24 f3 2e 80 00 	movl   $0x802ef3,(%esp)
  80218d:	e8 14 e2 ff ff       	call   8003a6 <_panic>
	e = &envs[ENVX(envid)];
  802192:	89 c3                	mov    %eax,%ebx
  802194:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80219a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80219d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021a3:	8b 73 48             	mov    0x48(%ebx),%esi
  8021a6:	39 c6                	cmp    %eax,%esi
  8021a8:	75 1a                	jne    8021c4 <wait+0x65>
  8021aa:	8b 43 54             	mov    0x54(%ebx),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 13                	je     8021c4 <wait+0x65>
		sys_yield();
  8021b1:	e8 d4 ed ff ff       	call   800f8a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021b6:	8b 43 48             	mov    0x48(%ebx),%eax
  8021b9:	39 f0                	cmp    %esi,%eax
  8021bb:	75 07                	jne    8021c4 <wait+0x65>
  8021bd:	8b 43 54             	mov    0x54(%ebx),%eax
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	75 ed                	jne    8021b1 <wait+0x52>
		sys_yield();
}
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5d                   	pop    %ebp
  8021ca:	c3                   	ret    
  8021cb:	66 90                	xchg   %ax,%ax
  8021cd:	66 90                	xchg   %ax,%ax
  8021cf:	90                   	nop

008021d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    

008021da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021e0:	c7 44 24 04 fe 2e 80 	movl   $0x802efe,0x4(%esp)
  8021e7:	00 
  8021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021eb:	89 04 24             	mov    %eax,(%esp)
  8021ee:	e8 08 e9 ff ff       	call   800afb <strcpy>
	return 0;
}
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	57                   	push   %edi
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802206:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220a:	74 4a                	je     802256 <devcons_write+0x5c>
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
  802211:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802216:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80221c:	8b 75 10             	mov    0x10(%ebp),%esi
  80221f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802221:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802224:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802229:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80222c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802230:	03 45 0c             	add    0xc(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	89 3c 24             	mov    %edi,(%esp)
  80223a:	e8 b7 ea ff ff       	call   800cf6 <memmove>
		sys_cputs(buf, m);
  80223f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802243:	89 3c 24             	mov    %edi,(%esp)
  802246:	e8 91 ec ff ff       	call   800edc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80224b:	01 f3                	add    %esi,%ebx
  80224d:	89 d8                	mov    %ebx,%eax
  80224f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802252:	72 c8                	jb     80221c <devcons_write+0x22>
  802254:	eb 05                	jmp    80225b <devcons_write+0x61>
  802256:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80225b:	89 d8                	mov    %ebx,%eax
  80225d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    

00802268 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802277:	75 07                	jne    802280 <devcons_read+0x18>
  802279:	eb 28                	jmp    8022a3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80227b:	e8 0a ed ff ff       	call   800f8a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802280:	e8 75 ec ff ff       	call   800efa <sys_cgetc>
  802285:	85 c0                	test   %eax,%eax
  802287:	74 f2                	je     80227b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 16                	js     8022a3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80228d:	83 f8 04             	cmp    $0x4,%eax
  802290:	74 0c                	je     80229e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	88 02                	mov    %al,(%edx)
	return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022b8:	00 
  8022b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022bc:	89 04 24             	mov    %eax,(%esp)
  8022bf:	e8 18 ec ff ff       	call   800edc <sys_cputs>
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <getchar>:

int
getchar(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022d3:	00 
  8022d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e2:	e8 cf f5 ff ff       	call   8018b6 <read>
	if (r < 0)
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 0f                	js     8022fa <getchar+0x34>
		return r;
	if (r < 1)
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	7e 06                	jle    8022f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022f3:	eb 05                	jmp    8022fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802305:	89 44 24 04          	mov    %eax,0x4(%esp)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	89 04 24             	mov    %eax,(%esp)
  80230f:	e8 f7 f2 ff ff       	call   80160b <fd_lookup>
  802314:	85 c0                	test   %eax,%eax
  802316:	78 11                	js     802329 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802321:	39 10                	cmp    %edx,(%eax)
  802323:	0f 94 c0             	sete   %al
  802326:	0f b6 c0             	movzbl %al,%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <opencons>:

int
opencons(void)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802334:	89 04 24             	mov    %eax,(%esp)
  802337:	e8 5b f2 ff ff       	call   801597 <fd_alloc>
		return r;
  80233c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80233e:	85 c0                	test   %eax,%eax
  802340:	78 40                	js     802382 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802342:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802349:	00 
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802358:	e8 4c ec ff ff       	call   800fa9 <sys_page_alloc>
		return r;
  80235d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 1f                	js     802382 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802363:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 f0 f1 ff ff       	call   801570 <fd2num>
  802380:	89 c2                	mov    %eax,%edx
}
  802382:	89 d0                	mov    %edx,%eax
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  80238c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802393:	75 50                	jne    8023e5 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802395:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80239c:	00 
  80239d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8023a4:	ee 
  8023a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ac:	e8 f8 eb ff ff       	call   800fa9 <sys_page_alloc>
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	79 1c                	jns    8023d1 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8023b5:	c7 44 24 08 0c 2f 80 	movl   $0x802f0c,0x8(%esp)
  8023bc:	00 
  8023bd:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8023c4:	00 
  8023c5:	c7 04 24 30 2f 80 00 	movl   $0x802f30,(%esp)
  8023cc:	e8 d5 df ff ff       	call   8003a6 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8023d1:	c7 44 24 04 ef 23 80 	movl   $0x8023ef,0x4(%esp)
  8023d8:	00 
  8023d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e0:	e8 64 ed ff ff       	call   801149 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023ef:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023f0:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023f5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023f7:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8023fa:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8023fc:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802401:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802404:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802409:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80240c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80240e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802411:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802413:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802415:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80241a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80241d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802422:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802425:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802427:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80242c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80242f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802434:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802437:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802439:	83 c4 08             	add    $0x8,%esp
	popal
  80243c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80243d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80243e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80243f:	c3                   	ret    

00802440 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	56                   	push   %esi
  802444:	53                   	push   %ebx
  802445:	83 ec 10             	sub    $0x10,%esp
  802448:	8b 75 08             	mov    0x8(%ebp),%esi
  80244b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802451:	85 c0                	test   %eax,%eax
  802453:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802458:	0f 44 c2             	cmove  %edx,%eax
  80245b:	89 04 24             	mov    %eax,(%esp)
  80245e:	e8 5c ed ff ff       	call   8011bf <sys_ipc_recv>
	if (err_code < 0) {
  802463:	85 c0                	test   %eax,%eax
  802465:	79 16                	jns    80247d <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802467:	85 f6                	test   %esi,%esi
  802469:	74 06                	je     802471 <ipc_recv+0x31>
  80246b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802471:	85 db                	test   %ebx,%ebx
  802473:	74 2c                	je     8024a1 <ipc_recv+0x61>
  802475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80247b:	eb 24                	jmp    8024a1 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80247d:	85 f6                	test   %esi,%esi
  80247f:	74 0a                	je     80248b <ipc_recv+0x4b>
  802481:	a1 04 40 80 00       	mov    0x804004,%eax
  802486:	8b 40 74             	mov    0x74(%eax),%eax
  802489:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80248b:	85 db                	test   %ebx,%ebx
  80248d:	74 0a                	je     802499 <ipc_recv+0x59>
  80248f:	a1 04 40 80 00       	mov    0x804004,%eax
  802494:	8b 40 78             	mov    0x78(%eax),%eax
  802497:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802499:	a1 04 40 80 00       	mov    0x804004,%eax
  80249e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024a1:	83 c4 10             	add    $0x10,%esp
  8024a4:	5b                   	pop    %ebx
  8024a5:	5e                   	pop    %esi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    

008024a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	57                   	push   %edi
  8024ac:	56                   	push   %esi
  8024ad:	53                   	push   %ebx
  8024ae:	83 ec 1c             	sub    $0x1c,%esp
  8024b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8024ba:	eb 25                	jmp    8024e1 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8024bc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024bf:	74 20                	je     8024e1 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8024c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c5:	c7 44 24 08 3e 2f 80 	movl   $0x802f3e,0x8(%esp)
  8024cc:	00 
  8024cd:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8024d4:	00 
  8024d5:	c7 04 24 4a 2f 80 00 	movl   $0x802f4a,(%esp)
  8024dc:	e8 c5 de ff ff       	call   8003a6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8024e1:	85 db                	test   %ebx,%ebx
  8024e3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024e8:	0f 45 c3             	cmovne %ebx,%eax
  8024eb:	8b 55 14             	mov    0x14(%ebp),%edx
  8024ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024fa:	89 3c 24             	mov    %edi,(%esp)
  8024fd:	e8 9a ec ff ff       	call   80119c <sys_ipc_try_send>
  802502:	85 c0                	test   %eax,%eax
  802504:	75 b6                	jne    8024bc <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802506:	83 c4 1c             	add    $0x1c,%esp
  802509:	5b                   	pop    %ebx
  80250a:	5e                   	pop    %esi
  80250b:	5f                   	pop    %edi
  80250c:	5d                   	pop    %ebp
  80250d:	c3                   	ret    

0080250e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802514:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802519:	39 c8                	cmp    %ecx,%eax
  80251b:	74 17                	je     802534 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80251d:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802522:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802525:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80252b:	8b 52 50             	mov    0x50(%edx),%edx
  80252e:	39 ca                	cmp    %ecx,%edx
  802530:	75 14                	jne    802546 <ipc_find_env+0x38>
  802532:	eb 05                	jmp    802539 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802539:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80253c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802541:	8b 40 40             	mov    0x40(%eax),%eax
  802544:	eb 0e                	jmp    802554 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802546:	83 c0 01             	add    $0x1,%eax
  802549:	3d 00 04 00 00       	cmp    $0x400,%eax
  80254e:	75 d2                	jne    802522 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802550:	66 b8 00 00          	mov    $0x0,%ax
}
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    

00802556 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80255c:	89 d0                	mov    %edx,%eax
  80255e:	c1 e8 16             	shr    $0x16,%eax
  802561:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80256d:	f6 c1 01             	test   $0x1,%cl
  802570:	74 1d                	je     80258f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802572:	c1 ea 0c             	shr    $0xc,%edx
  802575:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80257c:	f6 c2 01             	test   $0x1,%dl
  80257f:	74 0e                	je     80258f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802581:	c1 ea 0c             	shr    $0xc,%edx
  802584:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80258b:	ef 
  80258c:	0f b7 c0             	movzwl %ax,%eax
}
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    
  802591:	66 90                	xchg   %ax,%ax
  802593:	66 90                	xchg   %ax,%ax
  802595:	66 90                	xchg   %ax,%ax
  802597:	66 90                	xchg   %ax,%ax
  802599:	66 90                	xchg   %ax,%ax
  80259b:	66 90                	xchg   %ax,%ax
  80259d:	66 90                	xchg   %ax,%ax
  80259f:	90                   	nop

008025a0 <__udivdi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025bc:	89 ea                	mov    %ebp,%edx
  8025be:	89 0c 24             	mov    %ecx,(%esp)
  8025c1:	75 2d                	jne    8025f0 <__udivdi3+0x50>
  8025c3:	39 e9                	cmp    %ebp,%ecx
  8025c5:	77 61                	ja     802628 <__udivdi3+0x88>
  8025c7:	85 c9                	test   %ecx,%ecx
  8025c9:	89 ce                	mov    %ecx,%esi
  8025cb:	75 0b                	jne    8025d8 <__udivdi3+0x38>
  8025cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d2:	31 d2                	xor    %edx,%edx
  8025d4:	f7 f1                	div    %ecx
  8025d6:	89 c6                	mov    %eax,%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	89 e8                	mov    %ebp,%eax
  8025dc:	f7 f6                	div    %esi
  8025de:	89 c5                	mov    %eax,%ebp
  8025e0:	89 f8                	mov    %edi,%eax
  8025e2:	f7 f6                	div    %esi
  8025e4:	89 ea                	mov    %ebp,%edx
  8025e6:	83 c4 0c             	add    $0xc,%esp
  8025e9:	5e                   	pop    %esi
  8025ea:	5f                   	pop    %edi
  8025eb:	5d                   	pop    %ebp
  8025ec:	c3                   	ret    
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	39 e8                	cmp    %ebp,%eax
  8025f2:	77 24                	ja     802618 <__udivdi3+0x78>
  8025f4:	0f bd e8             	bsr    %eax,%ebp
  8025f7:	83 f5 1f             	xor    $0x1f,%ebp
  8025fa:	75 3c                	jne    802638 <__udivdi3+0x98>
  8025fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802600:	39 34 24             	cmp    %esi,(%esp)
  802603:	0f 86 9f 00 00 00    	jbe    8026a8 <__udivdi3+0x108>
  802609:	39 d0                	cmp    %edx,%eax
  80260b:	0f 82 97 00 00 00    	jb     8026a8 <__udivdi3+0x108>
  802611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	31 c0                	xor    %eax,%eax
  80261c:	83 c4 0c             	add    $0xc,%esp
  80261f:	5e                   	pop    %esi
  802620:	5f                   	pop    %edi
  802621:	5d                   	pop    %ebp
  802622:	c3                   	ret    
  802623:	90                   	nop
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	89 f8                	mov    %edi,%eax
  80262a:	f7 f1                	div    %ecx
  80262c:	31 d2                	xor    %edx,%edx
  80262e:	83 c4 0c             	add    $0xc,%esp
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
  802635:	8d 76 00             	lea    0x0(%esi),%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	8b 3c 24             	mov    (%esp),%edi
  80263d:	d3 e0                	shl    %cl,%eax
  80263f:	89 c6                	mov    %eax,%esi
  802641:	b8 20 00 00 00       	mov    $0x20,%eax
  802646:	29 e8                	sub    %ebp,%eax
  802648:	89 c1                	mov    %eax,%ecx
  80264a:	d3 ef                	shr    %cl,%edi
  80264c:	89 e9                	mov    %ebp,%ecx
  80264e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802652:	8b 3c 24             	mov    (%esp),%edi
  802655:	09 74 24 08          	or     %esi,0x8(%esp)
  802659:	89 d6                	mov    %edx,%esi
  80265b:	d3 e7                	shl    %cl,%edi
  80265d:	89 c1                	mov    %eax,%ecx
  80265f:	89 3c 24             	mov    %edi,(%esp)
  802662:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802666:	d3 ee                	shr    %cl,%esi
  802668:	89 e9                	mov    %ebp,%ecx
  80266a:	d3 e2                	shl    %cl,%edx
  80266c:	89 c1                	mov    %eax,%ecx
  80266e:	d3 ef                	shr    %cl,%edi
  802670:	09 d7                	or     %edx,%edi
  802672:	89 f2                	mov    %esi,%edx
  802674:	89 f8                	mov    %edi,%eax
  802676:	f7 74 24 08          	divl   0x8(%esp)
  80267a:	89 d6                	mov    %edx,%esi
  80267c:	89 c7                	mov    %eax,%edi
  80267e:	f7 24 24             	mull   (%esp)
  802681:	39 d6                	cmp    %edx,%esi
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 30                	jb     8026b8 <__udivdi3+0x118>
  802688:	8b 54 24 04          	mov    0x4(%esp),%edx
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	39 c2                	cmp    %eax,%edx
  802692:	73 05                	jae    802699 <__udivdi3+0xf9>
  802694:	3b 34 24             	cmp    (%esp),%esi
  802697:	74 1f                	je     8026b8 <__udivdi3+0x118>
  802699:	89 f8                	mov    %edi,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	e9 7a ff ff ff       	jmp    80261c <__udivdi3+0x7c>
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	31 d2                	xor    %edx,%edx
  8026aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8026af:	e9 68 ff ff ff       	jmp    80261c <__udivdi3+0x7c>
  8026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	83 c4 0c             	add    $0xc,%esp
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
  8026c4:	66 90                	xchg   %ax,%ax
  8026c6:	66 90                	xchg   %ax,%ax
  8026c8:	66 90                	xchg   %ax,%ax
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	83 ec 14             	sub    $0x14,%esp
  8026d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026e2:	89 c7                	mov    %eax,%edi
  8026e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026f0:	89 34 24             	mov    %esi,(%esp)
  8026f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	89 c2                	mov    %eax,%edx
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	75 17                	jne    802718 <__umoddi3+0x48>
  802701:	39 fe                	cmp    %edi,%esi
  802703:	76 4b                	jbe    802750 <__umoddi3+0x80>
  802705:	89 c8                	mov    %ecx,%eax
  802707:	89 fa                	mov    %edi,%edx
  802709:	f7 f6                	div    %esi
  80270b:	89 d0                	mov    %edx,%eax
  80270d:	31 d2                	xor    %edx,%edx
  80270f:	83 c4 14             	add    $0x14,%esp
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
  802716:	66 90                	xchg   %ax,%ax
  802718:	39 f8                	cmp    %edi,%eax
  80271a:	77 54                	ja     802770 <__umoddi3+0xa0>
  80271c:	0f bd e8             	bsr    %eax,%ebp
  80271f:	83 f5 1f             	xor    $0x1f,%ebp
  802722:	75 5c                	jne    802780 <__umoddi3+0xb0>
  802724:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802728:	39 3c 24             	cmp    %edi,(%esp)
  80272b:	0f 87 e7 00 00 00    	ja     802818 <__umoddi3+0x148>
  802731:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802735:	29 f1                	sub    %esi,%ecx
  802737:	19 c7                	sbb    %eax,%edi
  802739:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80273d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802741:	8b 44 24 08          	mov    0x8(%esp),%eax
  802745:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802749:	83 c4 14             	add    $0x14,%esp
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
  802750:	85 f6                	test   %esi,%esi
  802752:	89 f5                	mov    %esi,%ebp
  802754:	75 0b                	jne    802761 <__umoddi3+0x91>
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f6                	div    %esi
  80275f:	89 c5                	mov    %eax,%ebp
  802761:	8b 44 24 04          	mov    0x4(%esp),%eax
  802765:	31 d2                	xor    %edx,%edx
  802767:	f7 f5                	div    %ebp
  802769:	89 c8                	mov    %ecx,%eax
  80276b:	f7 f5                	div    %ebp
  80276d:	eb 9c                	jmp    80270b <__umoddi3+0x3b>
  80276f:	90                   	nop
  802770:	89 c8                	mov    %ecx,%eax
  802772:	89 fa                	mov    %edi,%edx
  802774:	83 c4 14             	add    $0x14,%esp
  802777:	5e                   	pop    %esi
  802778:	5f                   	pop    %edi
  802779:	5d                   	pop    %ebp
  80277a:	c3                   	ret    
  80277b:	90                   	nop
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	8b 04 24             	mov    (%esp),%eax
  802783:	be 20 00 00 00       	mov    $0x20,%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	29 ee                	sub    %ebp,%esi
  80278c:	d3 e2                	shl    %cl,%edx
  80278e:	89 f1                	mov    %esi,%ecx
  802790:	d3 e8                	shr    %cl,%eax
  802792:	89 e9                	mov    %ebp,%ecx
  802794:	89 44 24 04          	mov    %eax,0x4(%esp)
  802798:	8b 04 24             	mov    (%esp),%eax
  80279b:	09 54 24 04          	or     %edx,0x4(%esp)
  80279f:	89 fa                	mov    %edi,%edx
  8027a1:	d3 e0                	shl    %cl,%eax
  8027a3:	89 f1                	mov    %esi,%ecx
  8027a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027ad:	d3 ea                	shr    %cl,%edx
  8027af:	89 e9                	mov    %ebp,%ecx
  8027b1:	d3 e7                	shl    %cl,%edi
  8027b3:	89 f1                	mov    %esi,%ecx
  8027b5:	d3 e8                	shr    %cl,%eax
  8027b7:	89 e9                	mov    %ebp,%ecx
  8027b9:	09 f8                	or     %edi,%eax
  8027bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027bf:	f7 74 24 04          	divl   0x4(%esp)
  8027c3:	d3 e7                	shl    %cl,%edi
  8027c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027c9:	89 d7                	mov    %edx,%edi
  8027cb:	f7 64 24 08          	mull   0x8(%esp)
  8027cf:	39 d7                	cmp    %edx,%edi
  8027d1:	89 c1                	mov    %eax,%ecx
  8027d3:	89 14 24             	mov    %edx,(%esp)
  8027d6:	72 2c                	jb     802804 <__umoddi3+0x134>
  8027d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027dc:	72 22                	jb     802800 <__umoddi3+0x130>
  8027de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027e2:	29 c8                	sub    %ecx,%eax
  8027e4:	19 d7                	sbb    %edx,%edi
  8027e6:	89 e9                	mov    %ebp,%ecx
  8027e8:	89 fa                	mov    %edi,%edx
  8027ea:	d3 e8                	shr    %cl,%eax
  8027ec:	89 f1                	mov    %esi,%ecx
  8027ee:	d3 e2                	shl    %cl,%edx
  8027f0:	89 e9                	mov    %ebp,%ecx
  8027f2:	d3 ef                	shr    %cl,%edi
  8027f4:	09 d0                	or     %edx,%eax
  8027f6:	89 fa                	mov    %edi,%edx
  8027f8:	83 c4 14             	add    $0x14,%esp
  8027fb:	5e                   	pop    %esi
  8027fc:	5f                   	pop    %edi
  8027fd:	5d                   	pop    %ebp
  8027fe:	c3                   	ret    
  8027ff:	90                   	nop
  802800:	39 d7                	cmp    %edx,%edi
  802802:	75 da                	jne    8027de <__umoddi3+0x10e>
  802804:	8b 14 24             	mov    (%esp),%edx
  802807:	89 c1                	mov    %eax,%ecx
  802809:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80280d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802811:	eb cb                	jmp    8027de <__umoddi3+0x10e>
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80281c:	0f 82 0f ff ff ff    	jb     802731 <__umoddi3+0x61>
  802822:	e9 1a ff ff ff       	jmp    802741 <__umoddi3+0x71>
