
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 25 05 00 00       	call   800556 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004c:	89 34 24             	mov    %esi,(%esp)
  80004f:	e8 0c 1c 00 00       	call   801c60 <seek>
	seek(kfd, off);
  800054:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800058:	89 3c 24             	mov    %edi,(%esp)
  80005b:	e8 00 1c 00 00       	call   801c60 <seek>

	cprintf("shell produced incorrect output.\n");
  800060:	c7 04 24 20 2f 80 00 	movl   $0x802f20,(%esp)
  800067:	e8 74 06 00 00       	call   8006e0 <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 8b 2f 80 00 	movl   $0x802f8b,(%esp)
  800073:	e8 68 06 00 00       	call   8006e0 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	eb 0c                	jmp    800089 <wrong+0x56>
		sys_cputs(buf, n);
  80007d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800081:	89 1c 24             	mov    %ebx,(%esp)
  800084:	e8 93 10 00 00       	call   80111c <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800089:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800090:	00 
  800091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800095:	89 3c 24             	mov    %edi,(%esp)
  800098:	e8 49 1a 00 00       	call   801ae6 <read>
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f dc                	jg     80007d <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a1:	c7 04 24 9a 2f 80 00 	movl   $0x802f9a,(%esp)
  8000a8:	e8 33 06 00 00       	call   8006e0 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0c                	jmp    8000be <wrong+0x8b>
		sys_cputs(buf, n);
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	89 1c 24             	mov    %ebx,(%esp)
  8000b9:	e8 5e 10 00 00       	call   80111c <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000be:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c5:	00 
  8000c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ca:	89 34 24             	mov    %esi,(%esp)
  8000cd:	e8 14 1a 00 00       	call   801ae6 <read>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7f dc                	jg     8000b2 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d6:	c7 04 24 95 2f 80 00 	movl   $0x802f95,(%esp)
  8000dd:	e8 fe 05 00 00       	call   8006e0 <cprintf>
	exit();
  8000e2:	e8 e7 04 00 00       	call   8005ce <exit>
}
  8000e7:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5f                   	pop    %edi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    

008000f2 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 7c 18 00 00       	call   801983 <close>
	close(1);
  800107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010e:	e8 70 18 00 00       	call   801983 <close>
	opencons();
  800113:	e8 e3 03 00 00       	call   8004fb <opencons>
	opencons();
  800118:	e8 de 03 00 00       	call   8004fb <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800124:	00 
  800125:	c7 04 24 a8 2f 80 00 	movl   $0x802fa8,(%esp)
  80012c:	e8 57 1e 00 00       	call   801f88 <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 b5 2f 80 	movl   $0x802fb5,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  800152:	e8 90 04 00 00       	call   8005e7 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 07 27 00 00       	call   802869 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 dc 2f 80 	movl   $0x802fdc,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  800181:	e8 61 04 00 00       	call   8005e7 <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800190:	e8 4b 05 00 00       	call   8006e0 <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 a6 13 00 00       	call   801540 <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 e5 2f 80 	movl   $0x802fe5,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  8001b9:	e8 29 04 00 00       	call   8005e7 <_panic>
	if (r == 0) {
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 85 9f 00 00 00    	jne    800265 <umain+0x173>
		dup(rfd, 0);
  8001c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001cd:	00 
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	e8 02 18 00 00       	call   8019d8 <dup>
		dup(wfd, 1);
  8001d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001dd:	00 
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 f2 17 00 00       	call   8019d8 <dup>
		close(rfd);
  8001e6:	89 1c 24             	mov    %ebx,(%esp)
  8001e9:	e8 95 17 00 00       	call   801983 <close>
		close(wfd);
  8001ee:	89 34 24             	mov    %esi,(%esp)
  8001f1:	e8 8d 17 00 00       	call   801983 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 ee 2f 80 	movl   $0x802fee,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 b2 2f 80 	movl   $0x802fb2,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 f1 2f 80 00 	movl   $0x802ff1,(%esp)
  800215:	e8 a4 23 00 00       	call   8025be <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 f5 2f 80 	movl   $0x802ff5,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  80023b:	e8 a7 03 00 00       	call   8005e7 <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 37 17 00 00       	call   801983 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 2b 17 00 00       	call   801983 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 af 27 00 00       	call   802a0f <wait>
		exit();
  800260:	e8 69 03 00 00       	call   8005ce <exit>
	}
	close(rfd);
  800265:	89 1c 24             	mov    %ebx,(%esp)
  800268:	e8 16 17 00 00       	call   801983 <close>
	close(wfd);
  80026d:	89 34 24             	mov    %esi,(%esp)
  800270:	e8 0e 17 00 00       	call   801983 <close>

	rfd = pfds[0];
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800282:	00 
  800283:	c7 04 24 ff 2f 80 00 	movl   $0x802fff,(%esp)
  80028a:	e8 f9 1c 00 00       	call   801f88 <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 68 2f 80 	movl   $0x802f68,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  8002b1:	e8 31 03 00 00       	call   8005e7 <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b6:	be 01 00 00 00       	mov    $0x1,%esi
  8002bb:	bf 00 00 00 00       	mov    $0x0,%edi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c7:	00 
  8002c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 0c 18 00 00       	call   801ae6 <read>
  8002da:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e3:	00 
  8002e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 f0 17 00 00       	call   801ae6 <read>
		if (n1 < 0)
  8002f6:	85 db                	test   %ebx,%ebx
  8002f8:	79 20                	jns    80031a <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fe:	c7 44 24 08 0d 30 80 	movl   $0x80300d,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  800315:	e8 cd 02 00 00       	call   8005e7 <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 cb 2f 80 00 	movl   $0x802fcb,(%esp)
  800339:	e8 a9 02 00 00       	call   8005e7 <_panic>
		if (n1 == 0 && n2 == 0)
  80033e:	89 c2                	mov    %eax,%edx
  800340:	09 da                	or     %ebx,%edx
  800342:	74 38                	je     80037c <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800344:	83 fb 01             	cmp    $0x1,%ebx
  800347:	75 0e                	jne    800357 <umain+0x265>
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	75 09                	jne    800357 <umain+0x265>
  80034e:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800352:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800355:	74 16                	je     80036d <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800357:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80035b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	e8 c6 fc ff ff       	call   800033 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036d:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800371:	0f 44 fe             	cmove  %esi,%edi
  800374:	83 c6 01             	add    $0x1,%esi
	}
  800377:	e9 44 ff ff ff       	jmp    8002c0 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037c:	c7 04 24 41 30 80 00 	movl   $0x803041,(%esp)
  800383:	e8 58 03 00 00       	call   8006e0 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800388:	cc                   	int3   

	breakpoint();
}
  800389:	83 c4 3c             	add    $0x3c,%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 56 30 80 	movl   $0x803056,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 78 09 00 00       	call   800d3b <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003da:	74 4a                	je     800426 <devcons_write+0x5c>
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003ec:	8b 75 10             	mov    0x10(%ebp),%esi
  8003ef:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8003f1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003f4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003fc:	89 74 24 08          	mov    %esi,0x8(%esp)
  800400:	03 45 0c             	add    0xc(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	89 3c 24             	mov    %edi,(%esp)
  80040a:	e8 27 0b 00 00       	call   800f36 <memmove>
		sys_cputs(buf, m);
  80040f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800413:	89 3c 24             	mov    %edi,(%esp)
  800416:	e8 01 0d 00 00       	call   80111c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80041b:	01 f3                	add    %esi,%ebx
  80041d:	89 d8                	mov    %ebx,%eax
  80041f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800422:	72 c8                	jb     8003ec <devcons_write+0x22>
  800424:	eb 05                	jmp    80042b <devcons_write+0x61>
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80042b:	89 d8                	mov    %ebx,%eax
  80042d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800433:	5b                   	pop    %ebx
  800434:	5e                   	pop    %esi
  800435:	5f                   	pop    %edi
  800436:	5d                   	pop    %ebp
  800437:	c3                   	ret    

00800438 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80043e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800447:	75 07                	jne    800450 <devcons_read+0x18>
  800449:	eb 28                	jmp    800473 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80044b:	e8 7a 0d 00 00       	call   8011ca <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800450:	e8 e5 0c 00 00       	call   80113a <sys_cgetc>
  800455:	85 c0                	test   %eax,%eax
  800457:	74 f2                	je     80044b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800459:	85 c0                	test   %eax,%eax
  80045b:	78 16                	js     800473 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80045d:	83 f8 04             	cmp    $0x4,%eax
  800460:	74 0c                	je     80046e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800462:	8b 55 0c             	mov    0xc(%ebp),%edx
  800465:	88 02                	mov    %al,(%edx)
	return 1;
  800467:	b8 01 00 00 00       	mov    $0x1,%eax
  80046c:	eb 05                	jmp    800473 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800481:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800488:	00 
  800489:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80048c:	89 04 24             	mov    %eax,(%esp)
  80048f:	e8 88 0c 00 00       	call   80111c <sys_cputs>
}
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <getchar>:

int
getchar(void)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80049c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8004a3:	00 
  8004a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8004a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004b2:	e8 2f 16 00 00       	call   801ae6 <read>
	if (r < 0)
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	78 0f                	js     8004ca <getchar+0x34>
		return r;
	if (r < 1)
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	7e 06                	jle    8004c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004c3:	eb 05                	jmp    8004ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	89 04 24             	mov    %eax,(%esp)
  8004df:	e8 57 13 00 00       	call   80183b <fd_lookup>
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	78 11                	js     8004f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004f1:	39 10                	cmp    %edx,(%eax)
  8004f3:	0f 94 c0             	sete   %al
  8004f6:	0f b6 c0             	movzbl %al,%eax
}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <opencons>:

int
opencons(void)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 bb 12 00 00       	call   8017c7 <fd_alloc>
		return r;
  80050c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80050e:	85 c0                	test   %eax,%eax
  800510:	78 40                	js     800552 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800512:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800519:	00 
  80051a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800521:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800528:	e8 bc 0c 00 00       	call   8011e9 <sys_page_alloc>
		return r;
  80052d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80052f:	85 c0                	test   %eax,%eax
  800531:	78 1f                	js     800552 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800533:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80053e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800541:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	e8 50 12 00 00       	call   8017a0 <fd2num>
  800550:	89 c2                	mov    %eax,%edx
}
  800552:	89 d0                	mov    %edx,%eax
  800554:	c9                   	leave  
  800555:	c3                   	ret    

00800556 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 10             	sub    $0x10,%esp
  80055e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800561:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800564:	e8 42 0c 00 00       	call   8011ab <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800569:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80056f:	39 c2                	cmp    %eax,%edx
  800571:	74 17                	je     80058a <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800573:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800578:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80057b:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800581:	8b 49 40             	mov    0x40(%ecx),%ecx
  800584:	39 c1                	cmp    %eax,%ecx
  800586:	75 18                	jne    8005a0 <libmain+0x4a>
  800588:	eb 05                	jmp    80058f <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80058a:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80058f:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800592:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800598:	89 15 04 50 80 00    	mov    %edx,0x805004
			break;
  80059e:	eb 0b                	jmp    8005ab <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8005a0:	83 c2 01             	add    $0x1,%edx
  8005a3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8005a9:	75 cd                	jne    800578 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ab:	85 db                	test   %ebx,%ebx
  8005ad:	7e 07                	jle    8005b6 <libmain+0x60>
		binaryname = argv[0];
  8005af:	8b 06                	mov    (%esi),%eax
  8005b1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8005b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ba:	89 1c 24             	mov    %ebx,(%esp)
  8005bd:	e8 30 fb ff ff       	call   8000f2 <umain>

	// exit gracefully
	exit();
  8005c2:	e8 07 00 00 00       	call   8005ce <exit>
}
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	5b                   	pop    %ebx
  8005cb:	5e                   	pop    %esi
  8005cc:	5d                   	pop    %ebp
  8005cd:	c3                   	ret    

008005ce <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005d4:	e8 dd 13 00 00       	call   8019b6 <close_all>
	sys_env_destroy(0);
  8005d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005e0:	e8 74 0b 00 00       	call   801159 <sys_env_destroy>
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	56                   	push   %esi
  8005eb:	53                   	push   %ebx
  8005ec:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005ef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005f2:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005f8:	e8 ae 0b 00 00       	call   8011ab <sys_getenvid>
  8005fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800600:	89 54 24 10          	mov    %edx,0x10(%esp)
  800604:	8b 55 08             	mov    0x8(%ebp),%edx
  800607:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80060b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80060f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800613:	c7 04 24 6c 30 80 00 	movl   $0x80306c,(%esp)
  80061a:	e8 c1 00 00 00       	call   8006e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80061f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800623:	8b 45 10             	mov    0x10(%ebp),%eax
  800626:	89 04 24             	mov    %eax,(%esp)
  800629:	e8 51 00 00 00       	call   80067f <vcprintf>
	cprintf("\n");
  80062e:	c7 04 24 ce 35 80 00 	movl   $0x8035ce,(%esp)
  800635:	e8 a6 00 00 00       	call   8006e0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80063a:	cc                   	int3   
  80063b:	eb fd                	jmp    80063a <_panic+0x53>

0080063d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	53                   	push   %ebx
  800641:	83 ec 14             	sub    $0x14,%esp
  800644:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800647:	8b 13                	mov    (%ebx),%edx
  800649:	8d 42 01             	lea    0x1(%edx),%eax
  80064c:	89 03                	mov    %eax,(%ebx)
  80064e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800651:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800655:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065a:	75 19                	jne    800675 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80065c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800663:	00 
  800664:	8d 43 08             	lea    0x8(%ebx),%eax
  800667:	89 04 24             	mov    %eax,(%esp)
  80066a:	e8 ad 0a 00 00       	call   80111c <sys_cputs>
		b->idx = 0;
  80066f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800675:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800679:	83 c4 14             	add    $0x14,%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5d                   	pop    %ebp
  80067e:	c3                   	ret    

0080067f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800688:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80068f:	00 00 00 
	b.cnt = 0;
  800692:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800699:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b4:	c7 04 24 3d 06 80 00 	movl   $0x80063d,(%esp)
  8006bb:	e8 b4 01 00 00       	call   800874 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006c0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ca:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006d0:	89 04 24             	mov    %eax,(%esp)
  8006d3:	e8 44 0a 00 00       	call   80111c <sys_cputs>

	return b.cnt;
}
  8006d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 04 24             	mov    %eax,(%esp)
  8006f3:	e8 87 ff ff ff       	call   80067f <vcprintf>
	va_end(ap);

	return cnt;
}
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    
  8006fa:	66 90                	xchg   %ax,%ax
  8006fc:	66 90                	xchg   %ax,%ax
  8006fe:	66 90                	xchg   %ax,%ax

00800700 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	57                   	push   %edi
  800704:	56                   	push   %esi
  800705:	53                   	push   %ebx
  800706:	83 ec 3c             	sub    $0x3c,%esp
  800709:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80070c:	89 d7                	mov    %edx,%edi
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800714:	8b 75 0c             	mov    0xc(%ebp),%esi
  800717:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80071a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800728:	39 f1                	cmp    %esi,%ecx
  80072a:	72 14                	jb     800740 <printnum+0x40>
  80072c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80072f:	76 0f                	jbe    800740 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 70 ff             	lea    -0x1(%eax),%esi
  800737:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80073a:	85 f6                	test   %esi,%esi
  80073c:	7f 60                	jg     80079e <printnum+0x9e>
  80073e:	eb 72                	jmp    8007b2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800740:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800743:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800747:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80074a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80074d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800751:	89 44 24 08          	mov    %eax,0x8(%esp)
  800755:	8b 44 24 08          	mov    0x8(%esp),%eax
  800759:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80075d:	89 c3                	mov    %eax,%ebx
  80075f:	89 d6                	mov    %edx,%esi
  800761:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800764:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800767:	89 54 24 08          	mov    %edx,0x8(%esp)
  80076b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80076f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800772:	89 04 24             	mov    %eax,(%esp)
  800775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077c:	e8 0f 25 00 00       	call   802c90 <__udivdi3>
  800781:	89 d9                	mov    %ebx,%ecx
  800783:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800787:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078b:	89 04 24             	mov    %eax,(%esp)
  80078e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800792:	89 fa                	mov    %edi,%edx
  800794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800797:	e8 64 ff ff ff       	call   800700 <printnum>
  80079c:	eb 14                	jmp    8007b2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80079e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a5:	89 04 24             	mov    %eax,(%esp)
  8007a8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007aa:	83 ee 01             	sub    $0x1,%esi
  8007ad:	75 ef                	jne    80079e <printnum+0x9e>
  8007af:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007cb:	89 04 24             	mov    %eax,(%esp)
  8007ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	e8 e6 25 00 00       	call   802dc0 <__umoddi3>
  8007da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007de:	0f be 80 8f 30 80 00 	movsbl 0x80308f(%eax),%eax
  8007e5:	89 04 24             	mov    %eax,(%esp)
  8007e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
}
  8007ed:	83 c4 3c             	add    $0x3c,%esp
  8007f0:	5b                   	pop    %ebx
  8007f1:	5e                   	pop    %esi
  8007f2:	5f                   	pop    %edi
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007f8:	83 fa 01             	cmp    $0x1,%edx
  8007fb:	7e 0e                	jle    80080b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007fd:	8b 10                	mov    (%eax),%edx
  8007ff:	8d 4a 08             	lea    0x8(%edx),%ecx
  800802:	89 08                	mov    %ecx,(%eax)
  800804:	8b 02                	mov    (%edx),%eax
  800806:	8b 52 04             	mov    0x4(%edx),%edx
  800809:	eb 22                	jmp    80082d <getuint+0x38>
	else if (lflag)
  80080b:	85 d2                	test   %edx,%edx
  80080d:	74 10                	je     80081f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80080f:	8b 10                	mov    (%eax),%edx
  800811:	8d 4a 04             	lea    0x4(%edx),%ecx
  800814:	89 08                	mov    %ecx,(%eax)
  800816:	8b 02                	mov    (%edx),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	eb 0e                	jmp    80082d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	8d 4a 04             	lea    0x4(%edx),%ecx
  800824:	89 08                	mov    %ecx,(%eax)
  800826:	8b 02                	mov    (%edx),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800835:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800839:	8b 10                	mov    (%eax),%edx
  80083b:	3b 50 04             	cmp    0x4(%eax),%edx
  80083e:	73 0a                	jae    80084a <sprintputch+0x1b>
		*b->buf++ = ch;
  800840:	8d 4a 01             	lea    0x1(%edx),%ecx
  800843:	89 08                	mov    %ecx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	88 02                	mov    %al,(%edx)
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800852:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800855:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	89 44 24 04          	mov    %eax,0x4(%esp)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	89 04 24             	mov    %eax,(%esp)
  80086d:	e8 02 00 00 00       	call   800874 <vprintfmt>
	va_end(ap);
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	57                   	push   %edi
  800878:	56                   	push   %esi
  800879:	53                   	push   %ebx
  80087a:	83 ec 3c             	sub    $0x3c,%esp
  80087d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800880:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800883:	eb 18                	jmp    80089d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800885:	85 c0                	test   %eax,%eax
  800887:	0f 84 c3 03 00 00    	je     800c50 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80088d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800891:	89 04 24             	mov    %eax,(%esp)
  800894:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800897:	89 f3                	mov    %esi,%ebx
  800899:	eb 02                	jmp    80089d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089d:	8d 73 01             	lea    0x1(%ebx),%esi
  8008a0:	0f b6 03             	movzbl (%ebx),%eax
  8008a3:	83 f8 25             	cmp    $0x25,%eax
  8008a6:	75 dd                	jne    800885 <vprintfmt+0x11>
  8008a8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8008ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8008b3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c6:	eb 1d                	jmp    8008e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ca:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8008ce:	eb 15                	jmp    8008e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8008d6:	eb 0d                	jmp    8008e5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008de:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008e8:	0f b6 06             	movzbl (%esi),%eax
  8008eb:	0f b6 c8             	movzbl %al,%ecx
  8008ee:	83 e8 23             	sub    $0x23,%eax
  8008f1:	3c 55                	cmp    $0x55,%al
  8008f3:	0f 87 2f 03 00 00    	ja     800c28 <vprintfmt+0x3b4>
  8008f9:	0f b6 c0             	movzbl %al,%eax
  8008fc:	ff 24 85 e0 31 80 00 	jmp    *0x8031e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800903:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800909:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80090d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800910:	83 f9 09             	cmp    $0x9,%ecx
  800913:	77 50                	ja     800965 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800915:	89 de                	mov    %ebx,%esi
  800917:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80091d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800920:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800924:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800927:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80092a:	83 fb 09             	cmp    $0x9,%ebx
  80092d:	76 eb                	jbe    80091a <vprintfmt+0xa6>
  80092f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800932:	eb 33                	jmp    800967 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 48 04             	lea    0x4(%eax),%ecx
  80093a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800942:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800944:	eb 21                	jmp    800967 <vprintfmt+0xf3>
  800946:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800949:	85 c9                	test   %ecx,%ecx
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	0f 49 c1             	cmovns %ecx,%eax
  800953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800956:	89 de                	mov    %ebx,%esi
  800958:	eb 8b                	jmp    8008e5 <vprintfmt+0x71>
  80095a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80095c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800963:	eb 80                	jmp    8008e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800965:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	0f 89 74 ff ff ff    	jns    8008e5 <vprintfmt+0x71>
  800971:	e9 62 ff ff ff       	jmp    8008d8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800976:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800979:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80097b:	e9 65 ff ff ff       	jmp    8008e5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 50 04             	lea    0x4(%eax),%edx
  800986:	89 55 14             	mov    %edx,0x14(%ebp)
  800989:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	89 04 24             	mov    %eax,(%esp)
  800992:	ff 55 08             	call   *0x8(%ebp)
			break;
  800995:	e9 03 ff ff ff       	jmp    80089d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8d 50 04             	lea    0x4(%eax),%edx
  8009a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	99                   	cltd   
  8009a6:	31 d0                	xor    %edx,%eax
  8009a8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009aa:	83 f8 0f             	cmp    $0xf,%eax
  8009ad:	7f 0b                	jg     8009ba <vprintfmt+0x146>
  8009af:	8b 14 85 40 33 80 00 	mov    0x803340(,%eax,4),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	75 20                	jne    8009da <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009be:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  8009c5:	00 
  8009c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	89 04 24             	mov    %eax,(%esp)
  8009d0:	e8 77 fe ff ff       	call   80084c <printfmt>
  8009d5:	e9 c3 fe ff ff       	jmp    80089d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8009da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009de:	c7 44 24 08 af 35 80 	movl   $0x8035af,0x8(%esp)
  8009e5:	00 
  8009e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	89 04 24             	mov    %eax,(%esp)
  8009f0:	e8 57 fe ff ff       	call   80084c <printfmt>
  8009f5:	e9 a3 fe ff ff       	jmp    80089d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009fd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8d 50 04             	lea    0x4(%eax),%edx
  800a06:	89 55 14             	mov    %edx,0x14(%ebp)
  800a09:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  800a0b:	85 c0                	test   %eax,%eax
  800a0d:	ba a0 30 80 00       	mov    $0x8030a0,%edx
  800a12:	0f 45 d0             	cmovne %eax,%edx
  800a15:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800a18:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  800a1c:	74 04                	je     800a22 <vprintfmt+0x1ae>
  800a1e:	85 f6                	test   %esi,%esi
  800a20:	7f 19                	jg     800a3b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a25:	8d 70 01             	lea    0x1(%eax),%esi
  800a28:	0f b6 10             	movzbl (%eax),%edx
  800a2b:	0f be c2             	movsbl %dl,%eax
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	0f 85 95 00 00 00    	jne    800acb <vprintfmt+0x257>
  800a36:	e9 85 00 00 00       	jmp    800ac0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a42:	89 04 24             	mov    %eax,(%esp)
  800a45:	e8 b8 02 00 00       	call   800d02 <strnlen>
  800a4a:	29 c6                	sub    %eax,%esi
  800a4c:	89 f0                	mov    %esi,%eax
  800a4e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a51:	85 f6                	test   %esi,%esi
  800a53:	7e cd                	jle    800a22 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800a55:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800a59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a5c:	89 c3                	mov    %eax,%ebx
  800a5e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a62:	89 34 24             	mov    %esi,(%esp)
  800a65:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a68:	83 eb 01             	sub    $0x1,%ebx
  800a6b:	75 f1                	jne    800a5e <vprintfmt+0x1ea>
  800a6d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800a70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a73:	eb ad                	jmp    800a22 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a75:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a79:	74 1e                	je     800a99 <vprintfmt+0x225>
  800a7b:	0f be d2             	movsbl %dl,%edx
  800a7e:	83 ea 20             	sub    $0x20,%edx
  800a81:	83 fa 5e             	cmp    $0x5e,%edx
  800a84:	76 13                	jbe    800a99 <vprintfmt+0x225>
					putch('?', putdat);
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a94:	ff 55 08             	call   *0x8(%ebp)
  800a97:	eb 0d                	jmp    800aa6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800aa0:	89 04 24             	mov    %eax,(%esp)
  800aa3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa6:	83 ef 01             	sub    $0x1,%edi
  800aa9:	83 c6 01             	add    $0x1,%esi
  800aac:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800ab0:	0f be c2             	movsbl %dl,%eax
  800ab3:	85 c0                	test   %eax,%eax
  800ab5:	75 20                	jne    800ad7 <vprintfmt+0x263>
  800ab7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800aba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800abd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac4:	7f 25                	jg     800aeb <vprintfmt+0x277>
  800ac6:	e9 d2 fd ff ff       	jmp    80089d <vprintfmt+0x29>
  800acb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ace:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ad1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	78 9a                	js     800a75 <vprintfmt+0x201>
  800adb:	83 eb 01             	sub    $0x1,%ebx
  800ade:	79 95                	jns    800a75 <vprintfmt+0x201>
  800ae0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800ae3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ae9:	eb d5                	jmp    800ac0 <vprintfmt+0x24c>
  800aeb:	8b 75 08             	mov    0x8(%ebp),%esi
  800aee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800af4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800aff:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b01:	83 eb 01             	sub    $0x1,%ebx
  800b04:	75 ee                	jne    800af4 <vprintfmt+0x280>
  800b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b09:	e9 8f fd ff ff       	jmp    80089d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b0e:	83 fa 01             	cmp    $0x1,%edx
  800b11:	7e 16                	jle    800b29 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	8d 50 08             	lea    0x8(%eax),%edx
  800b19:	89 55 14             	mov    %edx,0x14(%ebp)
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b27:	eb 32                	jmp    800b5b <vprintfmt+0x2e7>
	else if (lflag)
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	74 18                	je     800b45 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	8d 50 04             	lea    0x4(%eax),%edx
  800b33:	89 55 14             	mov    %edx,0x14(%ebp)
  800b36:	8b 30                	mov    (%eax),%esi
  800b38:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b3b:	89 f0                	mov    %esi,%eax
  800b3d:	c1 f8 1f             	sar    $0x1f,%eax
  800b40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b43:	eb 16                	jmp    800b5b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800b45:	8b 45 14             	mov    0x14(%ebp),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b4e:	8b 30                	mov    (%eax),%esi
  800b50:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b53:	89 f0                	mov    %esi,%eax
  800b55:	c1 f8 1f             	sar    $0x1f,%eax
  800b58:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b61:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b6a:	0f 89 80 00 00 00    	jns    800bf0 <vprintfmt+0x37c>
				putch('-', putdat);
  800b70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b74:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b7b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b81:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b84:	f7 d8                	neg    %eax
  800b86:	83 d2 00             	adc    $0x0,%edx
  800b89:	f7 da                	neg    %edx
			}
			base = 10;
  800b8b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b90:	eb 5e                	jmp    800bf0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b92:	8d 45 14             	lea    0x14(%ebp),%eax
  800b95:	e8 5b fc ff ff       	call   8007f5 <getuint>
			base = 10;
  800b9a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b9f:	eb 4f                	jmp    800bf0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800ba1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba4:	e8 4c fc ff ff       	call   8007f5 <getuint>
			base = 8;
  800ba9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bae:	eb 40                	jmp    800bf0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800bb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bbb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bbe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bc9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcf:	8d 50 04             	lea    0x4(%eax),%edx
  800bd2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bdc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800be1:	eb 0d                	jmp    800bf0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800be3:	8d 45 14             	lea    0x14(%ebp),%eax
  800be6:	e8 0a fc ff ff       	call   8007f5 <getuint>
			base = 16;
  800beb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800bf4:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bf8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800bfb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c03:	89 04 24             	mov    %eax,(%esp)
  800c06:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0a:	89 fa                	mov    %edi,%edx
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	e8 ec fa ff ff       	call   800700 <printnum>
			break;
  800c14:	e9 84 fc ff ff       	jmp    80089d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c19:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c1d:	89 0c 24             	mov    %ecx,(%esp)
  800c20:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c23:	e9 75 fc ff ff       	jmp    80089d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c33:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c36:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800c3a:	0f 84 5b fc ff ff    	je     80089b <vprintfmt+0x27>
  800c40:	89 f3                	mov    %esi,%ebx
  800c42:	83 eb 01             	sub    $0x1,%ebx
  800c45:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c49:	75 f7                	jne    800c42 <vprintfmt+0x3ce>
  800c4b:	e9 4d fc ff ff       	jmp    80089d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800c50:	83 c4 3c             	add    $0x3c,%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 28             	sub    $0x28,%esp
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c67:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c6b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c75:	85 c0                	test   %eax,%eax
  800c77:	74 30                	je     800ca9 <vsnprintf+0x51>
  800c79:	85 d2                	test   %edx,%edx
  800c7b:	7e 2c                	jle    800ca9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c92:	c7 04 24 2f 08 80 00 	movl   $0x80082f,(%esp)
  800c99:	e8 d6 fb ff ff       	call   800874 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca7:	eb 05                	jmp    800cae <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ca9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cb9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 04 24             	mov    %eax,(%esp)
  800cd1:	e8 82 ff ff ff       	call   800c58 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    
  800cd8:	66 90                	xchg   %ax,%ax
  800cda:	66 90                	xchg   %ax,%ax
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce6:	80 3a 00             	cmpb   $0x0,(%edx)
  800ce9:	74 10                	je     800cfb <strlen+0x1b>
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800cf0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf7:	75 f7                	jne    800cf0 <strlen+0x10>
  800cf9:	eb 05                	jmp    800d00 <strlen+0x20>
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	53                   	push   %ebx
  800d06:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0c:	85 c9                	test   %ecx,%ecx
  800d0e:	74 1c                	je     800d2c <strnlen+0x2a>
  800d10:	80 3b 00             	cmpb   $0x0,(%ebx)
  800d13:	74 1e                	je     800d33 <strnlen+0x31>
  800d15:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800d1a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1c:	39 ca                	cmp    %ecx,%edx
  800d1e:	74 18                	je     800d38 <strnlen+0x36>
  800d20:	83 c2 01             	add    $0x1,%edx
  800d23:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800d28:	75 f0                	jne    800d1a <strnlen+0x18>
  800d2a:	eb 0c                	jmp    800d38 <strnlen+0x36>
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	eb 05                	jmp    800d38 <strnlen+0x36>
  800d33:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800d38:	5b                   	pop    %ebx
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	53                   	push   %ebx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	83 c2 01             	add    $0x1,%edx
  800d4a:	83 c1 01             	add    $0x1,%ecx
  800d4d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d51:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d54:	84 db                	test   %bl,%bl
  800d56:	75 ef                	jne    800d47 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d58:	5b                   	pop    %ebx
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 08             	sub    $0x8,%esp
  800d62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d65:	89 1c 24             	mov    %ebx,(%esp)
  800d68:	e8 73 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d70:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d74:	01 d8                	add    %ebx,%eax
  800d76:	89 04 24             	mov    %eax,(%esp)
  800d79:	e8 bd ff ff ff       	call   800d3b <strcpy>
	return dst;
}
  800d7e:	89 d8                	mov    %ebx,%eax
  800d80:	83 c4 08             	add    $0x8,%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d94:	85 db                	test   %ebx,%ebx
  800d96:	74 17                	je     800daf <strncpy+0x29>
  800d98:	01 f3                	add    %esi,%ebx
  800d9a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800d9c:	83 c1 01             	add    $0x1,%ecx
  800d9f:	0f b6 02             	movzbl (%edx),%eax
  800da2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800da5:	80 3a 01             	cmpb   $0x1,(%edx)
  800da8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dab:	39 d9                	cmp    %ebx,%ecx
  800dad:	75 ed                	jne    800d9c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800daf:	89 f0                	mov    %esi,%eax
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800dc1:	8b 75 10             	mov    0x10(%ebp),%esi
  800dc4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	74 34                	je     800dfe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800dca:	83 fe 01             	cmp    $0x1,%esi
  800dcd:	74 26                	je     800df5 <strlcpy+0x40>
  800dcf:	0f b6 0b             	movzbl (%ebx),%ecx
  800dd2:	84 c9                	test   %cl,%cl
  800dd4:	74 23                	je     800df9 <strlcpy+0x44>
  800dd6:	83 ee 02             	sub    $0x2,%esi
  800dd9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800dde:	83 c0 01             	add    $0x1,%eax
  800de1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800de4:	39 f2                	cmp    %esi,%edx
  800de6:	74 13                	je     800dfb <strlcpy+0x46>
  800de8:	83 c2 01             	add    $0x1,%edx
  800deb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800def:	84 c9                	test   %cl,%cl
  800df1:	75 eb                	jne    800dde <strlcpy+0x29>
  800df3:	eb 06                	jmp    800dfb <strlcpy+0x46>
  800df5:	89 f8                	mov    %edi,%eax
  800df7:	eb 02                	jmp    800dfb <strlcpy+0x46>
  800df9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800dfb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dfe:	29 f8                	sub    %edi,%eax
}
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e0e:	0f b6 01             	movzbl (%ecx),%eax
  800e11:	84 c0                	test   %al,%al
  800e13:	74 15                	je     800e2a <strcmp+0x25>
  800e15:	3a 02                	cmp    (%edx),%al
  800e17:	75 11                	jne    800e2a <strcmp+0x25>
		p++, q++;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1f:	0f b6 01             	movzbl (%ecx),%eax
  800e22:	84 c0                	test   %al,%al
  800e24:	74 04                	je     800e2a <strcmp+0x25>
  800e26:	3a 02                	cmp    (%edx),%al
  800e28:	74 ef                	je     800e19 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2a:	0f b6 c0             	movzbl %al,%eax
  800e2d:	0f b6 12             	movzbl (%edx),%edx
  800e30:	29 d0                	sub    %edx,%eax
}
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800e42:	85 f6                	test   %esi,%esi
  800e44:	74 29                	je     800e6f <strncmp+0x3b>
  800e46:	0f b6 03             	movzbl (%ebx),%eax
  800e49:	84 c0                	test   %al,%al
  800e4b:	74 30                	je     800e7d <strncmp+0x49>
  800e4d:	3a 02                	cmp    (%edx),%al
  800e4f:	75 2c                	jne    800e7d <strncmp+0x49>
  800e51:	8d 43 01             	lea    0x1(%ebx),%eax
  800e54:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800e56:	89 c3                	mov    %eax,%ebx
  800e58:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e5b:	39 f0                	cmp    %esi,%eax
  800e5d:	74 17                	je     800e76 <strncmp+0x42>
  800e5f:	0f b6 08             	movzbl (%eax),%ecx
  800e62:	84 c9                	test   %cl,%cl
  800e64:	74 17                	je     800e7d <strncmp+0x49>
  800e66:	83 c0 01             	add    $0x1,%eax
  800e69:	3a 0a                	cmp    (%edx),%cl
  800e6b:	74 e9                	je     800e56 <strncmp+0x22>
  800e6d:	eb 0e                	jmp    800e7d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e74:	eb 0f                	jmp    800e85 <strncmp+0x51>
  800e76:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7b:	eb 08                	jmp    800e85 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7d:	0f b6 03             	movzbl (%ebx),%eax
  800e80:	0f b6 12             	movzbl (%edx),%edx
  800e83:	29 d0                	sub    %edx,%eax
}
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	53                   	push   %ebx
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800e93:	0f b6 18             	movzbl (%eax),%ebx
  800e96:	84 db                	test   %bl,%bl
  800e98:	74 1d                	je     800eb7 <strchr+0x2e>
  800e9a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800e9c:	38 d3                	cmp    %dl,%bl
  800e9e:	75 06                	jne    800ea6 <strchr+0x1d>
  800ea0:	eb 1a                	jmp    800ebc <strchr+0x33>
  800ea2:	38 ca                	cmp    %cl,%dl
  800ea4:	74 16                	je     800ebc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ea6:	83 c0 01             	add    $0x1,%eax
  800ea9:	0f b6 10             	movzbl (%eax),%edx
  800eac:	84 d2                	test   %dl,%dl
  800eae:	75 f2                	jne    800ea2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb5:	eb 05                	jmp    800ebc <strchr+0x33>
  800eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebc:	5b                   	pop    %ebx
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	53                   	push   %ebx
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ec9:	0f b6 18             	movzbl (%eax),%ebx
  800ecc:	84 db                	test   %bl,%bl
  800ece:	74 16                	je     800ee6 <strfind+0x27>
  800ed0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800ed2:	38 d3                	cmp    %dl,%bl
  800ed4:	75 06                	jne    800edc <strfind+0x1d>
  800ed6:	eb 0e                	jmp    800ee6 <strfind+0x27>
  800ed8:	38 ca                	cmp    %cl,%dl
  800eda:	74 0a                	je     800ee6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edc:	83 c0 01             	add    $0x1,%eax
  800edf:	0f b6 10             	movzbl (%eax),%edx
  800ee2:	84 d2                	test   %dl,%dl
  800ee4:	75 f2                	jne    800ed8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ef2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ef5:	85 c9                	test   %ecx,%ecx
  800ef7:	74 36                	je     800f2f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ef9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eff:	75 28                	jne    800f29 <memset+0x40>
  800f01:	f6 c1 03             	test   $0x3,%cl
  800f04:	75 23                	jne    800f29 <memset+0x40>
		c &= 0xFF;
  800f06:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f0a:	89 d3                	mov    %edx,%ebx
  800f0c:	c1 e3 08             	shl    $0x8,%ebx
  800f0f:	89 d6                	mov    %edx,%esi
  800f11:	c1 e6 18             	shl    $0x18,%esi
  800f14:	89 d0                	mov    %edx,%eax
  800f16:	c1 e0 10             	shl    $0x10,%eax
  800f19:	09 f0                	or     %esi,%eax
  800f1b:	09 c2                	or     %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
  800f1f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f21:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800f24:	fc                   	cld    
  800f25:	f3 ab                	rep stos %eax,%es:(%edi)
  800f27:	eb 06                	jmp    800f2f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	fc                   	cld    
  800f2d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f2f:	89 f8                	mov    %edi,%eax
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f44:	39 c6                	cmp    %eax,%esi
  800f46:	73 35                	jae    800f7d <memmove+0x47>
  800f48:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f4b:	39 d0                	cmp    %edx,%eax
  800f4d:	73 2e                	jae    800f7d <memmove+0x47>
		s += n;
		d += n;
  800f4f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800f52:	89 d6                	mov    %edx,%esi
  800f54:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f5c:	75 13                	jne    800f71 <memmove+0x3b>
  800f5e:	f6 c1 03             	test   $0x3,%cl
  800f61:	75 0e                	jne    800f71 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f63:	83 ef 04             	sub    $0x4,%edi
  800f66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f69:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800f6c:	fd                   	std    
  800f6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f6f:	eb 09                	jmp    800f7a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f71:	83 ef 01             	sub    $0x1,%edi
  800f74:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f77:	fd                   	std    
  800f78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f7a:	fc                   	cld    
  800f7b:	eb 1d                	jmp    800f9a <memmove+0x64>
  800f7d:	89 f2                	mov    %esi,%edx
  800f7f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f81:	f6 c2 03             	test   $0x3,%dl
  800f84:	75 0f                	jne    800f95 <memmove+0x5f>
  800f86:	f6 c1 03             	test   $0x3,%cl
  800f89:	75 0a                	jne    800f95 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f8b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f8e:	89 c7                	mov    %eax,%edi
  800f90:	fc                   	cld    
  800f91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f93:	eb 05                	jmp    800f9a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f95:	89 c7                	mov    %eax,%edi
  800f97:	fc                   	cld    
  800f98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f9a:	5e                   	pop    %esi
  800f9b:	5f                   	pop    %edi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	89 04 24             	mov    %eax,(%esp)
  800fb8:	e8 79 ff ff ff       	call   800f36 <memmove>
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800fc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fce:	8d 78 ff             	lea    -0x1(%eax),%edi
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	74 36                	je     80100b <memcmp+0x4c>
		if (*s1 != *s2)
  800fd5:	0f b6 03             	movzbl (%ebx),%eax
  800fd8:	0f b6 0e             	movzbl (%esi),%ecx
  800fdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe0:	38 c8                	cmp    %cl,%al
  800fe2:	74 1c                	je     801000 <memcmp+0x41>
  800fe4:	eb 10                	jmp    800ff6 <memcmp+0x37>
  800fe6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800feb:	83 c2 01             	add    $0x1,%edx
  800fee:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800ff2:	38 c8                	cmp    %cl,%al
  800ff4:	74 0a                	je     801000 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800ff6:	0f b6 c0             	movzbl %al,%eax
  800ff9:	0f b6 c9             	movzbl %cl,%ecx
  800ffc:	29 c8                	sub    %ecx,%eax
  800ffe:	eb 10                	jmp    801010 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801000:	39 fa                	cmp    %edi,%edx
  801002:	75 e2                	jne    800fe6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
  801009:	eb 05                	jmp    801010 <memcmp+0x51>
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	53                   	push   %ebx
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80101f:	89 c2                	mov    %eax,%edx
  801021:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801024:	39 d0                	cmp    %edx,%eax
  801026:	73 13                	jae    80103b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801028:	89 d9                	mov    %ebx,%ecx
  80102a:	38 18                	cmp    %bl,(%eax)
  80102c:	75 06                	jne    801034 <memfind+0x1f>
  80102e:	eb 0b                	jmp    80103b <memfind+0x26>
  801030:	38 08                	cmp    %cl,(%eax)
  801032:	74 07                	je     80103b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801034:	83 c0 01             	add    $0x1,%eax
  801037:	39 d0                	cmp    %edx,%eax
  801039:	75 f5                	jne    801030 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80103b:	5b                   	pop    %ebx
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104a:	0f b6 0a             	movzbl (%edx),%ecx
  80104d:	80 f9 09             	cmp    $0x9,%cl
  801050:	74 05                	je     801057 <strtol+0x19>
  801052:	80 f9 20             	cmp    $0x20,%cl
  801055:	75 10                	jne    801067 <strtol+0x29>
		s++;
  801057:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105a:	0f b6 0a             	movzbl (%edx),%ecx
  80105d:	80 f9 09             	cmp    $0x9,%cl
  801060:	74 f5                	je     801057 <strtol+0x19>
  801062:	80 f9 20             	cmp    $0x20,%cl
  801065:	74 f0                	je     801057 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801067:	80 f9 2b             	cmp    $0x2b,%cl
  80106a:	75 0a                	jne    801076 <strtol+0x38>
		s++;
  80106c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80106f:	bf 00 00 00 00       	mov    $0x0,%edi
  801074:	eb 11                	jmp    801087 <strtol+0x49>
  801076:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80107b:	80 f9 2d             	cmp    $0x2d,%cl
  80107e:	75 07                	jne    801087 <strtol+0x49>
		s++, neg = 1;
  801080:	83 c2 01             	add    $0x1,%edx
  801083:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801087:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80108c:	75 15                	jne    8010a3 <strtol+0x65>
  80108e:	80 3a 30             	cmpb   $0x30,(%edx)
  801091:	75 10                	jne    8010a3 <strtol+0x65>
  801093:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801097:	75 0a                	jne    8010a3 <strtol+0x65>
		s += 2, base = 16;
  801099:	83 c2 02             	add    $0x2,%edx
  80109c:	b8 10 00 00 00       	mov    $0x10,%eax
  8010a1:	eb 10                	jmp    8010b3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	75 0c                	jne    8010b3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010a7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010a9:	80 3a 30             	cmpb   $0x30,(%edx)
  8010ac:	75 05                	jne    8010b3 <strtol+0x75>
		s++, base = 8;
  8010ae:	83 c2 01             	add    $0x1,%edx
  8010b1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8010b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010bb:	0f b6 0a             	movzbl (%edx),%ecx
  8010be:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	3c 09                	cmp    $0x9,%al
  8010c5:	77 08                	ja     8010cf <strtol+0x91>
			dig = *s - '0';
  8010c7:	0f be c9             	movsbl %cl,%ecx
  8010ca:	83 e9 30             	sub    $0x30,%ecx
  8010cd:	eb 20                	jmp    8010ef <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  8010cf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8010d2:	89 f0                	mov    %esi,%eax
  8010d4:	3c 19                	cmp    $0x19,%al
  8010d6:	77 08                	ja     8010e0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  8010d8:	0f be c9             	movsbl %cl,%ecx
  8010db:	83 e9 57             	sub    $0x57,%ecx
  8010de:	eb 0f                	jmp    8010ef <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  8010e0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8010e3:	89 f0                	mov    %esi,%eax
  8010e5:	3c 19                	cmp    $0x19,%al
  8010e7:	77 16                	ja     8010ff <strtol+0xc1>
			dig = *s - 'A' + 10;
  8010e9:	0f be c9             	movsbl %cl,%ecx
  8010ec:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8010ef:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8010f2:	7d 0f                	jge    801103 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8010f4:	83 c2 01             	add    $0x1,%edx
  8010f7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8010fb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8010fd:	eb bc                	jmp    8010bb <strtol+0x7d>
  8010ff:	89 d8                	mov    %ebx,%eax
  801101:	eb 02                	jmp    801105 <strtol+0xc7>
  801103:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801105:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801109:	74 05                	je     801110 <strtol+0xd2>
		*endptr = (char *) s;
  80110b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80110e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801110:	f7 d8                	neg    %eax
  801112:	85 ff                	test   %edi,%edi
  801114:	0f 44 c3             	cmove  %ebx,%eax
}
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801122:	b8 00 00 00 00       	mov    $0x0,%eax
  801127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	89 c7                	mov    %eax,%edi
  801131:	89 c6                	mov    %eax,%esi
  801133:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_cgetc>:

int
sys_cgetc(void)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801140:	ba 00 00 00 00       	mov    $0x0,%edx
  801145:	b8 01 00 00 00       	mov    $0x1,%eax
  80114a:	89 d1                	mov    %edx,%ecx
  80114c:	89 d3                	mov    %edx,%ebx
  80114e:	89 d7                	mov    %edx,%edi
  801150:	89 d6                	mov    %edx,%esi
  801152:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5f                   	pop    %edi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801162:	b9 00 00 00 00       	mov    $0x0,%ecx
  801167:	b8 03 00 00 00       	mov    $0x3,%eax
  80116c:	8b 55 08             	mov    0x8(%ebp),%edx
  80116f:	89 cb                	mov    %ecx,%ebx
  801171:	89 cf                	mov    %ecx,%edi
  801173:	89 ce                	mov    %ecx,%esi
  801175:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801177:	85 c0                	test   %eax,%eax
  801179:	7e 28                	jle    8011a3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801186:	00 
  801187:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  80118e:	00 
  80118f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801196:	00 
  801197:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  80119e:	e8 44 f4 ff ff       	call   8005e7 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011a3:	83 c4 2c             	add    $0x2c,%esp
  8011a6:	5b                   	pop    %ebx
  8011a7:	5e                   	pop    %esi
  8011a8:	5f                   	pop    %edi
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	57                   	push   %edi
  8011af:	56                   	push   %esi
  8011b0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b6:	b8 02 00 00 00       	mov    $0x2,%eax
  8011bb:	89 d1                	mov    %edx,%ecx
  8011bd:	89 d3                	mov    %edx,%ebx
  8011bf:	89 d7                	mov    %edx,%edi
  8011c1:	89 d6                	mov    %edx,%esi
  8011c3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <sys_yield>:

void
sys_yield(void)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011da:	89 d1                	mov    %edx,%ecx
  8011dc:	89 d3                	mov    %edx,%ebx
  8011de:	89 d7                	mov    %edx,%edi
  8011e0:	89 d6                	mov    %edx,%esi
  8011e2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	57                   	push   %edi
  8011ed:	56                   	push   %esi
  8011ee:	53                   	push   %ebx
  8011ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f2:	be 00 00 00 00       	mov    $0x0,%esi
  8011f7:	b8 04 00 00 00       	mov    $0x4,%eax
  8011fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801202:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801205:	89 f7                	mov    %esi,%edi
  801207:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	7e 28                	jle    801235 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801211:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801218:	00 
  801219:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  801220:	00 
  801221:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801228:	00 
  801229:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  801230:	e8 b2 f3 ff ff       	call   8005e7 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801235:	83 c4 2c             	add    $0x2c,%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5f                   	pop    %edi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	57                   	push   %edi
  801241:	56                   	push   %esi
  801242:	53                   	push   %ebx
  801243:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801246:	b8 05 00 00 00       	mov    $0x5,%eax
  80124b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801254:	8b 7d 14             	mov    0x14(%ebp),%edi
  801257:	8b 75 18             	mov    0x18(%ebp),%esi
  80125a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80125c:	85 c0                	test   %eax,%eax
  80125e:	7e 28                	jle    801288 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	89 44 24 10          	mov    %eax,0x10(%esp)
  801264:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  801283:	e8 5f f3 ff ff       	call   8005e7 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801288:	83 c4 2c             	add    $0x2c,%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801299:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129e:	b8 06 00 00 00       	mov    $0x6,%eax
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 df                	mov    %ebx,%edi
  8012ab:	89 de                	mov    %ebx,%esi
  8012ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7e 28                	jle    8012db <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012be:	00 
  8012bf:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  8012d6:	e8 0c f3 ff ff       	call   8005e7 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012db:	83 c4 2c             	add    $0x2c,%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5f                   	pop    %edi
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8012f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	89 df                	mov    %ebx,%edi
  8012fe:	89 de                	mov    %ebx,%esi
  801300:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801302:	85 c0                	test   %eax,%eax
  801304:	7e 28                	jle    80132e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801306:	89 44 24 10          	mov    %eax,0x10(%esp)
  80130a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801311:	00 
  801312:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  801319:	00 
  80131a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801321:	00 
  801322:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  801329:	e8 b9 f2 ff ff       	call   8005e7 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80132e:	83 c4 2c             	add    $0x2c,%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    

00801336 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	57                   	push   %edi
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
  80133c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801344:	b8 09 00 00 00       	mov    $0x9,%eax
  801349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	89 df                	mov    %ebx,%edi
  801351:	89 de                	mov    %ebx,%esi
  801353:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801355:	85 c0                	test   %eax,%eax
  801357:	7e 28                	jle    801381 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801359:	89 44 24 10          	mov    %eax,0x10(%esp)
  80135d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801364:	00 
  801365:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  80136c:	00 
  80136d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801374:	00 
  801375:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  80137c:	e8 66 f2 ff ff       	call   8005e7 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801381:	83 c4 2c             	add    $0x2c,%esp
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	57                   	push   %edi
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801392:	bb 00 00 00 00       	mov    $0x0,%ebx
  801397:	b8 0a 00 00 00       	mov    $0xa,%eax
  80139c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139f:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a2:	89 df                	mov    %ebx,%edi
  8013a4:	89 de                	mov    %ebx,%esi
  8013a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	7e 28                	jle    8013d4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8013b7:	00 
  8013b8:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  8013bf:	00 
  8013c0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013c7:	00 
  8013c8:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  8013cf:	e8 13 f2 ff ff       	call   8005e7 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013d4:	83 c4 2c             	add    $0x2c,%esp
  8013d7:	5b                   	pop    %ebx
  8013d8:	5e                   	pop    %esi
  8013d9:	5f                   	pop    %edi
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e2:	be 00 00 00 00       	mov    $0x0,%esi
  8013e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013f5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013f8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	57                   	push   %edi
  801403:	56                   	push   %esi
  801404:	53                   	push   %ebx
  801405:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801408:	b9 00 00 00 00       	mov    $0x0,%ecx
  80140d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801412:	8b 55 08             	mov    0x8(%ebp),%edx
  801415:	89 cb                	mov    %ecx,%ebx
  801417:	89 cf                	mov    %ecx,%edi
  801419:	89 ce                	mov    %ecx,%esi
  80141b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80141d:	85 c0                	test   %eax,%eax
  80141f:	7e 28                	jle    801449 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801421:	89 44 24 10          	mov    %eax,0x10(%esp)
  801425:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80142c:	00 
  80142d:	c7 44 24 08 9f 33 80 	movl   $0x80339f,0x8(%esp)
  801434:	00 
  801435:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80143c:	00 
  80143d:	c7 04 24 bc 33 80 00 	movl   $0x8033bc,(%esp)
  801444:	e8 9e f1 ff ff       	call   8005e7 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801449:	83 c4 2c             	add    $0x2c,%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5f                   	pop    %edi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	53                   	push   %ebx
  801455:	83 ec 24             	sub    $0x24,%esp
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80145b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  80145d:	89 da                	mov    %ebx,%edx
  80145f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801462:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801469:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80146d:	74 05                	je     801474 <pgfault+0x23>
  80146f:	f6 c6 08             	test   $0x8,%dh
  801472:	75 1c                	jne    801490 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801474:	c7 44 24 08 cc 33 80 	movl   $0x8033cc,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  80148b:	e8 57 f1 ff ff       	call   8005e7 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801490:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801497:	00 
  801498:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80149f:	00 
  8014a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a7:	e8 3d fd ff ff       	call   8011e9 <sys_page_alloc>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	79 20                	jns    8014d0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  8014b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b4:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8014c3:	00 
  8014c4:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  8014cb:	e8 17 f1 ff ff       	call   8005e7 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  8014d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  8014d6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014dd:	00 
  8014de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014e2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014e9:	e8 48 fa ff ff       	call   800f36 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  8014ee:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014f5:	00 
  8014f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801501:	00 
  801502:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801509:	00 
  80150a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801511:	e8 27 fd ff ff       	call   80123d <sys_page_map>
  801516:	85 c0                	test   %eax,%eax
  801518:	79 20                	jns    80153a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  80151a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80151e:	c7 44 24 08 4e 34 80 	movl   $0x80344e,0x8(%esp)
  801525:	00 
  801526:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80152d:	00 
  80152e:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  801535:	e8 ad f0 ff ff       	call   8005e7 <_panic>
	}
}
  80153a:	83 c4 24             	add    $0x24,%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	57                   	push   %edi
  801544:	56                   	push   %esi
  801545:	53                   	push   %ebx
  801546:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801549:	c7 04 24 51 14 80 00 	movl   $0x801451,(%esp)
  801550:	e8 26 15 00 00       	call   802a7b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801555:	b8 07 00 00 00       	mov    $0x7,%eax
  80155a:	cd 30                	int    $0x30
  80155c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 1c                	jns    80157f <fork+0x3f>
		panic("fork");
  801563:	c7 44 24 08 67 34 80 	movl   $0x803467,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801572:	00 
  801573:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  80157a:	e8 68 f0 ff ff       	call   8005e7 <_panic>
  80157f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801581:	bb 00 08 00 00       	mov    $0x800,%ebx
  801586:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80158a:	75 21                	jne    8015ad <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  80158c:	e8 1a fc ff ff       	call   8011ab <sys_getenvid>
  801591:	25 ff 03 00 00       	and    $0x3ff,%eax
  801596:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801599:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80159e:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	e9 c5 01 00 00       	jmp    801772 <fork+0x232>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  8015ad:	89 d8                	mov    %ebx,%eax
  8015af:	c1 e8 0a             	shr    $0xa,%eax
  8015b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015b9:	a8 01                	test   $0x1,%al
  8015bb:	0f 84 f2 00 00 00    	je     8016b3 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  8015c1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015c8:	a8 05                	test   $0x5,%al
  8015ca:	0f 84 e3 00 00 00    	je     8016b3 <fork+0x173>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  8015d0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015d7:	89 de                	mov    %ebx,%esi
  8015d9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  8015dc:	a9 02 08 00 00       	test   $0x802,%eax
  8015e1:	0f 84 88 00 00 00    	je     80166f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  8015e7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8015ee:	00 
  8015ef:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801602:	e8 36 fc ff ff       	call   80123d <sys_page_map>
  801607:	85 c0                	test   %eax,%eax
  801609:	79 20                	jns    80162b <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  80160b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160f:	c7 44 24 08 6c 34 80 	movl   $0x80346c,0x8(%esp)
  801616:	00 
  801617:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80161e:	00 
  80161f:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  801626:	e8 bc ef ff ff       	call   8005e7 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  80162b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801632:	00 
  801633:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801637:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80163e:	00 
  80163f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801643:	89 3c 24             	mov    %edi,(%esp)
  801646:	e8 f2 fb ff ff       	call   80123d <sys_page_map>
  80164b:	85 c0                	test   %eax,%eax
  80164d:	79 64                	jns    8016b3 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  80164f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801653:	c7 44 24 08 86 34 80 	movl   $0x803486,0x8(%esp)
  80165a:	00 
  80165b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801662:	00 
  801663:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  80166a:	e8 78 ef ff ff       	call   8005e7 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  80166f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801676:	00 
  801677:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80167b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80167f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801683:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168a:	e8 ae fb ff ff       	call   80123d <sys_page_map>
  80168f:	85 c0                	test   %eax,%eax
  801691:	79 20                	jns    8016b3 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801693:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801697:	c7 44 24 08 a0 34 80 	movl   $0x8034a0,0x8(%esp)
  80169e:	00 
  80169f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  8016a6:	00 
  8016a7:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  8016ae:	e8 34 ef ff ff       	call   8005e7 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  8016b3:	83 c3 01             	add    $0x1,%ebx
  8016b6:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8016bc:	0f 85 eb fe ff ff    	jne    8015ad <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  8016c2:	c7 44 24 04 e4 2a 80 	movl   $0x802ae4,0x4(%esp)
  8016c9:	00 
  8016ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016cd:	89 04 24             	mov    %eax,(%esp)
  8016d0:	e8 b4 fc ff ff       	call   801389 <sys_env_set_pgfault_upcall>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	79 20                	jns    8016f9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8016d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016dd:	c7 44 24 08 04 34 80 	movl   $0x803404,0x8(%esp)
  8016e4:	00 
  8016e5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8016ec:	00 
  8016ed:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  8016f4:	e8 ee ee ff ff       	call   8005e7 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8016f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801700:	00 
  801701:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801708:	ee 
  801709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170c:	89 04 24             	mov    %eax,(%esp)
  80170f:	e8 d5 fa ff ff       	call   8011e9 <sys_page_alloc>
  801714:	85 c0                	test   %eax,%eax
  801716:	79 20                	jns    801738 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801718:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80171c:	c7 44 24 08 b2 34 80 	movl   $0x8034b2,0x8(%esp)
  801723:	00 
  801724:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80172b:	00 
  80172c:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  801733:	e8 af ee ff ff       	call   8005e7 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801738:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80173f:	00 
  801740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801743:	89 04 24             	mov    %eax,(%esp)
  801746:	e8 98 fb ff ff       	call   8012e3 <sys_env_set_status>
  80174b:	85 c0                	test   %eax,%eax
  80174d:	79 20                	jns    80176f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  80174f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801753:	c7 44 24 08 ca 34 80 	movl   $0x8034ca,0x8(%esp)
  80175a:	00 
  80175b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801762:	00 
  801763:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  80176a:	e8 78 ee ff ff       	call   8005e7 <_panic>
	}

	return envid;
  80176f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801772:	83 c4 2c             	add    $0x2c,%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    

0080177a <sfork>:

// Challenge!
int
sfork(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801780:	c7 44 24 08 e5 34 80 	movl   $0x8034e5,0x8(%esp)
  801787:	00 
  801788:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80178f:	00 
  801790:	c7 04 24 29 34 80 00 	movl   $0x803429,(%esp)
  801797:	e8 4b ee ff ff       	call   8005e7 <_panic>
  80179c:	66 90                	xchg   %ax,%ax
  80179e:	66 90                	xchg   %ax,%ax

008017a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017ca:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8017cf:	a8 01                	test   $0x1,%al
  8017d1:	74 34                	je     801807 <fd_alloc+0x40>
  8017d3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8017d8:	a8 01                	test   $0x1,%al
  8017da:	74 32                	je     80180e <fd_alloc+0x47>
  8017dc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8017e1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017e3:	89 c2                	mov    %eax,%edx
  8017e5:	c1 ea 16             	shr    $0x16,%edx
  8017e8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ef:	f6 c2 01             	test   $0x1,%dl
  8017f2:	74 1f                	je     801813 <fd_alloc+0x4c>
  8017f4:	89 c2                	mov    %eax,%edx
  8017f6:	c1 ea 0c             	shr    $0xc,%edx
  8017f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801800:	f6 c2 01             	test   $0x1,%dl
  801803:	75 1a                	jne    80181f <fd_alloc+0x58>
  801805:	eb 0c                	jmp    801813 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801807:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80180c:	eb 05                	jmp    801813 <fd_alloc+0x4c>
  80180e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	89 08                	mov    %ecx,(%eax)
			return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	eb 1a                	jmp    801839 <fd_alloc+0x72>
  80181f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801824:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801829:	75 b6                	jne    8017e1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801834:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801841:	83 f8 1f             	cmp    $0x1f,%eax
  801844:	77 36                	ja     80187c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801846:	c1 e0 0c             	shl    $0xc,%eax
  801849:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80184e:	89 c2                	mov    %eax,%edx
  801850:	c1 ea 16             	shr    $0x16,%edx
  801853:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80185a:	f6 c2 01             	test   $0x1,%dl
  80185d:	74 24                	je     801883 <fd_lookup+0x48>
  80185f:	89 c2                	mov    %eax,%edx
  801861:	c1 ea 0c             	shr    $0xc,%edx
  801864:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80186b:	f6 c2 01             	test   $0x1,%dl
  80186e:	74 1a                	je     80188a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	89 02                	mov    %eax,(%edx)
	return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 13                	jmp    80188f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80187c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801881:	eb 0c                	jmp    80188f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801883:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801888:	eb 05                	jmp    80188f <fd_lookup+0x54>
  80188a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    

00801891 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	53                   	push   %ebx
  801895:	83 ec 14             	sub    $0x14,%esp
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80189e:	39 05 20 40 80 00    	cmp    %eax,0x804020
  8018a4:	75 1e                	jne    8018c4 <dev_lookup+0x33>
  8018a6:	eb 0e                	jmp    8018b6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018a8:	b8 3c 40 80 00       	mov    $0x80403c,%eax
  8018ad:	eb 0c                	jmp    8018bb <dev_lookup+0x2a>
  8018af:	b8 00 40 80 00       	mov    $0x804000,%eax
  8018b4:	eb 05                	jmp    8018bb <dev_lookup+0x2a>
  8018b6:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8018bb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c2:	eb 38                	jmp    8018fc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8018c4:	39 05 3c 40 80 00    	cmp    %eax,0x80403c
  8018ca:	74 dc                	je     8018a8 <dev_lookup+0x17>
  8018cc:	39 05 00 40 80 00    	cmp    %eax,0x804000
  8018d2:	74 db                	je     8018af <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018d4:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8018da:	8b 52 48             	mov    0x48(%edx),%edx
  8018dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018e5:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8018ec:	e8 ef ed ff ff       	call   8006e0 <cprintf>
	*dev = 0;
  8018f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8018f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018fc:	83 c4 14             	add    $0x14,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	56                   	push   %esi
  801906:	53                   	push   %ebx
  801907:	83 ec 20             	sub    $0x20,%esp
  80190a:	8b 75 08             	mov    0x8(%ebp),%esi
  80190d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801910:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801913:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801917:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80191d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801920:	89 04 24             	mov    %eax,(%esp)
  801923:	e8 13 ff ff ff       	call   80183b <fd_lookup>
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 05                	js     801931 <fd_close+0x2f>
	    || fd != fd2)
  80192c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80192f:	74 0c                	je     80193d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801931:	84 db                	test   %bl,%bl
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	0f 44 c2             	cmove  %edx,%eax
  80193b:	eb 3f                	jmp    80197c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80193d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	8b 06                	mov    (%esi),%eax
  801946:	89 04 24             	mov    %eax,(%esp)
  801949:	e8 43 ff ff ff       	call   801891 <dev_lookup>
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	85 c0                	test   %eax,%eax
  801952:	78 16                	js     80196a <fd_close+0x68>
		if (dev->dev_close)
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801957:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80195a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80195f:	85 c0                	test   %eax,%eax
  801961:	74 07                	je     80196a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801963:	89 34 24             	mov    %esi,(%esp)
  801966:	ff d0                	call   *%eax
  801968:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80196a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80196e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801975:	e8 16 f9 ff ff       	call   801290 <sys_page_unmap>
	return r;
  80197a:	89 d8                	mov    %ebx,%eax
}
  80197c:	83 c4 20             	add    $0x20,%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801989:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	89 04 24             	mov    %eax,(%esp)
  801996:	e8 a0 fe ff ff       	call   80183b <fd_lookup>
  80199b:	89 c2                	mov    %eax,%edx
  80199d:	85 d2                	test   %edx,%edx
  80199f:	78 13                	js     8019b4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019a8:	00 
  8019a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ac:	89 04 24             	mov    %eax,(%esp)
  8019af:	e8 4e ff ff ff       	call   801902 <fd_close>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <close_all>:

void
close_all(void)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	53                   	push   %ebx
  8019ba:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019c2:	89 1c 24             	mov    %ebx,(%esp)
  8019c5:	e8 b9 ff ff ff       	call   801983 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ca:	83 c3 01             	add    $0x1,%ebx
  8019cd:	83 fb 20             	cmp    $0x20,%ebx
  8019d0:	75 f0                	jne    8019c2 <close_all+0xc>
		close(i);
}
  8019d2:	83 c4 14             	add    $0x14,%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    

008019d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	57                   	push   %edi
  8019dc:	56                   	push   %esi
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	89 04 24             	mov    %eax,(%esp)
  8019ee:	e8 48 fe ff ff       	call   80183b <fd_lookup>
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	85 d2                	test   %edx,%edx
  8019f7:	0f 88 e1 00 00 00    	js     801ade <dup+0x106>
		return r;
	close(newfdnum);
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 7b ff ff ff       	call   801983 <close>

	newfd = INDEX2FD(newfdnum);
  801a08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a0b:	c1 e3 0c             	shl    $0xc,%ebx
  801a0e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a17:	89 04 24             	mov    %eax,(%esp)
  801a1a:	e8 91 fd ff ff       	call   8017b0 <fd2data>
  801a1f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a21:	89 1c 24             	mov    %ebx,(%esp)
  801a24:	e8 87 fd ff ff       	call   8017b0 <fd2data>
  801a29:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a2b:	89 f0                	mov    %esi,%eax
  801a2d:	c1 e8 16             	shr    $0x16,%eax
  801a30:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a37:	a8 01                	test   $0x1,%al
  801a39:	74 43                	je     801a7e <dup+0xa6>
  801a3b:	89 f0                	mov    %esi,%eax
  801a3d:	c1 e8 0c             	shr    $0xc,%eax
  801a40:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a47:	f6 c2 01             	test   $0x1,%dl
  801a4a:	74 32                	je     801a7e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a4c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a53:	25 07 0e 00 00       	and    $0xe07,%eax
  801a58:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a5c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a67:	00 
  801a68:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a73:	e8 c5 f7 ff ff       	call   80123d <sys_page_map>
  801a78:	89 c6                	mov    %eax,%esi
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 3e                	js     801abc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a81:	89 c2                	mov    %eax,%edx
  801a83:	c1 ea 0c             	shr    $0xc,%edx
  801a86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a8d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a93:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a97:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aa2:	00 
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aae:	e8 8a f7 ff ff       	call   80123d <sys_page_map>
  801ab3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ab8:	85 f6                	test   %esi,%esi
  801aba:	79 22                	jns    801ade <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801abc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac7:	e8 c4 f7 ff ff       	call   801290 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801acc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad7:	e8 b4 f7 ff ff       	call   801290 <sys_page_unmap>
	return r;
  801adc:	89 f0                	mov    %esi,%eax
}
  801ade:	83 c4 3c             	add    $0x3c,%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5f                   	pop    %edi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 24             	sub    $0x24,%esp
  801aed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af7:	89 1c 24             	mov    %ebx,(%esp)
  801afa:	e8 3c fd ff ff       	call   80183b <fd_lookup>
  801aff:	89 c2                	mov    %eax,%edx
  801b01:	85 d2                	test   %edx,%edx
  801b03:	78 6d                	js     801b72 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	8b 00                	mov    (%eax),%eax
  801b11:	89 04 24             	mov    %eax,(%esp)
  801b14:	e8 78 fd ff ff       	call   801891 <dev_lookup>
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	78 55                	js     801b72 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b20:	8b 50 08             	mov    0x8(%eax),%edx
  801b23:	83 e2 03             	and    $0x3,%edx
  801b26:	83 fa 01             	cmp    $0x1,%edx
  801b29:	75 23                	jne    801b4e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b2b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b30:	8b 40 48             	mov    0x48(%eax),%eax
  801b33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3b:	c7 04 24 3d 35 80 00 	movl   $0x80353d,(%esp)
  801b42:	e8 99 eb ff ff       	call   8006e0 <cprintf>
		return -E_INVAL;
  801b47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4c:	eb 24                	jmp    801b72 <read+0x8c>
	}
	if (!dev->dev_read)
  801b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b51:	8b 52 08             	mov    0x8(%edx),%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	74 15                	je     801b6d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b66:	89 04 24             	mov    %eax,(%esp)
  801b69:	ff d2                	call   *%edx
  801b6b:	eb 05                	jmp    801b72 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b72:	83 c4 24             	add    $0x24,%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    

00801b78 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	57                   	push   %edi
  801b7c:	56                   	push   %esi
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 1c             	sub    $0x1c,%esp
  801b81:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b84:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b87:	85 f6                	test   %esi,%esi
  801b89:	74 33                	je     801bbe <readn+0x46>
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b95:	89 f2                	mov    %esi,%edx
  801b97:	29 c2                	sub    %eax,%edx
  801b99:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b9d:	03 45 0c             	add    0xc(%ebp),%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	89 3c 24             	mov    %edi,(%esp)
  801ba7:	e8 3a ff ff ff       	call   801ae6 <read>
		if (m < 0)
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 1b                	js     801bcb <readn+0x53>
			return m;
		if (m == 0)
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	74 11                	je     801bc5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb4:	01 c3                	add    %eax,%ebx
  801bb6:	89 d8                	mov    %ebx,%eax
  801bb8:	39 f3                	cmp    %esi,%ebx
  801bba:	72 d9                	jb     801b95 <readn+0x1d>
  801bbc:	eb 0b                	jmp    801bc9 <readn+0x51>
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc3:	eb 06                	jmp    801bcb <readn+0x53>
  801bc5:	89 d8                	mov    %ebx,%eax
  801bc7:	eb 02                	jmp    801bcb <readn+0x53>
  801bc9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bcb:	83 c4 1c             	add    $0x1c,%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5f                   	pop    %edi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    

00801bd3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 24             	sub    $0x24,%esp
  801bda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be4:	89 1c 24             	mov    %ebx,(%esp)
  801be7:	e8 4f fc ff ff       	call   80183b <fd_lookup>
  801bec:	89 c2                	mov    %eax,%edx
  801bee:	85 d2                	test   %edx,%edx
  801bf0:	78 68                	js     801c5a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfc:	8b 00                	mov    (%eax),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 8b fc ff ff       	call   801891 <dev_lookup>
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 50                	js     801c5a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c11:	75 23                	jne    801c36 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c13:	a1 04 50 80 00       	mov    0x805004,%eax
  801c18:	8b 40 48             	mov    0x48(%eax),%eax
  801c1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c23:	c7 04 24 59 35 80 00 	movl   $0x803559,(%esp)
  801c2a:	e8 b1 ea ff ff       	call   8006e0 <cprintf>
		return -E_INVAL;
  801c2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c34:	eb 24                	jmp    801c5a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c39:	8b 52 0c             	mov    0xc(%edx),%edx
  801c3c:	85 d2                	test   %edx,%edx
  801c3e:	74 15                	je     801c55 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	ff d2                	call   *%edx
  801c53:	eb 05                	jmp    801c5a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c5a:	83 c4 24             	add    $0x24,%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c66:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	89 04 24             	mov    %eax,(%esp)
  801c73:	e8 c3 fb ff ff       	call   80183b <fd_lookup>
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 0e                	js     801c8a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 24             	sub    $0x24,%esp
  801c93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9d:	89 1c 24             	mov    %ebx,(%esp)
  801ca0:	e8 96 fb ff ff       	call   80183b <fd_lookup>
  801ca5:	89 c2                	mov    %eax,%edx
  801ca7:	85 d2                	test   %edx,%edx
  801ca9:	78 61                	js     801d0c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb5:	8b 00                	mov    (%eax),%eax
  801cb7:	89 04 24             	mov    %eax,(%esp)
  801cba:	e8 d2 fb ff ff       	call   801891 <dev_lookup>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 49                	js     801d0c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cca:	75 23                	jne    801cef <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ccc:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cd1:	8b 40 48             	mov    0x48(%eax),%eax
  801cd4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	c7 04 24 1c 35 80 00 	movl   $0x80351c,(%esp)
  801ce3:	e8 f8 e9 ff ff       	call   8006e0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801ce8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ced:	eb 1d                	jmp    801d0c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	8b 52 18             	mov    0x18(%edx),%edx
  801cf5:	85 d2                	test   %edx,%edx
  801cf7:	74 0e                	je     801d07 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d00:	89 04 24             	mov    %eax,(%esp)
  801d03:	ff d2                	call   *%edx
  801d05:	eb 05                	jmp    801d0c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d0c:	83 c4 24             	add    $0x24,%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	53                   	push   %ebx
  801d16:	83 ec 24             	sub    $0x24,%esp
  801d19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 04 24             	mov    %eax,(%esp)
  801d29:	e8 0d fb ff ff       	call   80183b <fd_lookup>
  801d2e:	89 c2                	mov    %eax,%edx
  801d30:	85 d2                	test   %edx,%edx
  801d32:	78 52                	js     801d86 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	89 04 24             	mov    %eax,(%esp)
  801d43:	e8 49 fb ff ff       	call   801891 <dev_lookup>
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 3a                	js     801d86 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d53:	74 2c                	je     801d81 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d55:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d58:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d5f:	00 00 00 
	stat->st_isdir = 0;
  801d62:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d69:	00 00 00 
	stat->st_dev = dev;
  801d6c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d79:	89 14 24             	mov    %edx,(%esp)
  801d7c:	ff 50 14             	call   *0x14(%eax)
  801d7f:	eb 05                	jmp    801d86 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d81:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d86:	83 c4 24             	add    $0x24,%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    

00801d8c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d9b:	00 
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 e1 01 00 00       	call   801f88 <open>
  801da7:	89 c3                	mov    %eax,%ebx
  801da9:	85 db                	test   %ebx,%ebx
  801dab:	78 1b                	js     801dc8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db4:	89 1c 24             	mov    %ebx,(%esp)
  801db7:	e8 56 ff ff ff       	call   801d12 <fstat>
  801dbc:	89 c6                	mov    %eax,%esi
	close(fd);
  801dbe:	89 1c 24             	mov    %ebx,(%esp)
  801dc1:	e8 bd fb ff ff       	call   801983 <close>
	return r;
  801dc6:	89 f0                	mov    %esi,%eax
}
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 10             	sub    $0x10,%esp
  801dd7:	89 c3                	mov    %eax,%ebx
  801dd9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  801ddb:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801de2:	75 11                	jne    801df5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801deb:	e8 13 0e 00 00       	call   802c03 <ipc_find_env>
  801df0:	a3 00 50 80 00       	mov    %eax,0x805000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801df5:	a1 04 50 80 00       	mov    0x805004,%eax
  801dfa:	8b 40 48             	mov    0x48(%eax),%eax
  801dfd:	8b 15 00 60 80 00    	mov    0x806000,%edx
  801e03:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0f:	c7 04 24 76 35 80 00 	movl   $0x803576,(%esp)
  801e16:	e8 c5 e8 ff ff       	call   8006e0 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e1b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e22:	00 
  801e23:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e2a:	00 
  801e2b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e2f:	a1 00 50 80 00       	mov    0x805000,%eax
  801e34:	89 04 24             	mov    %eax,(%esp)
  801e37:	e8 61 0d 00 00       	call   802b9d <ipc_send>
	cprintf("ipc_send\n");
  801e3c:	c7 04 24 8c 35 80 00 	movl   $0x80358c,(%esp)
  801e43:	e8 98 e8 ff ff       	call   8006e0 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801e48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e4f:	00 
  801e50:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5b:	e8 d5 0c 00 00       	call   802b35 <ipc_recv>
}
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	53                   	push   %ebx
  801e6b:	83 ec 14             	sub    $0x14,%esp
  801e6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	8b 40 0c             	mov    0xc(%eax),%eax
  801e77:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e81:	b8 05 00 00 00       	mov    $0x5,%eax
  801e86:	e8 44 ff ff ff       	call   801dcf <fsipc>
  801e8b:	89 c2                	mov    %eax,%edx
  801e8d:	85 d2                	test   %edx,%edx
  801e8f:	78 2b                	js     801ebc <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e91:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e98:	00 
  801e99:	89 1c 24             	mov    %ebx,(%esp)
  801e9c:	e8 9a ee ff ff       	call   800d3b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ea1:	a1 80 60 80 00       	mov    0x806080,%eax
  801ea6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eac:	a1 84 60 80 00       	mov    0x806084,%eax
  801eb1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	83 c4 14             	add    $0x14,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    

00801ec2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ece:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed8:	b8 06 00 00 00       	mov    $0x6,%eax
  801edd:	e8 ed fe ff ff       	call   801dcf <fsipc>
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	56                   	push   %esi
  801ee8:	53                   	push   %ebx
  801ee9:	83 ec 10             	sub    $0x10,%esp
  801eec:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801efa:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f00:	ba 00 00 00 00       	mov    $0x0,%edx
  801f05:	b8 03 00 00 00       	mov    $0x3,%eax
  801f0a:	e8 c0 fe ff ff       	call   801dcf <fsipc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	85 c0                	test   %eax,%eax
  801f13:	78 6a                	js     801f7f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f15:	39 c6                	cmp    %eax,%esi
  801f17:	73 24                	jae    801f3d <devfile_read+0x59>
  801f19:	c7 44 24 0c 96 35 80 	movl   $0x803596,0xc(%esp)
  801f20:	00 
  801f21:	c7 44 24 08 9d 35 80 	movl   $0x80359d,0x8(%esp)
  801f28:	00 
  801f29:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801f30:	00 
  801f31:	c7 04 24 b2 35 80 00 	movl   $0x8035b2,(%esp)
  801f38:	e8 aa e6 ff ff       	call   8005e7 <_panic>
	assert(r <= PGSIZE);
  801f3d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f42:	7e 24                	jle    801f68 <devfile_read+0x84>
  801f44:	c7 44 24 0c bd 35 80 	movl   $0x8035bd,0xc(%esp)
  801f4b:	00 
  801f4c:	c7 44 24 08 9d 35 80 	movl   $0x80359d,0x8(%esp)
  801f53:	00 
  801f54:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801f5b:	00 
  801f5c:	c7 04 24 b2 35 80 00 	movl   $0x8035b2,(%esp)
  801f63:	e8 7f e6 ff ff       	call   8005e7 <_panic>
	memmove(buf, &fsipcbuf, r);
  801f68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f6c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f73:	00 
  801f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f77:	89 04 24             	mov    %eax,(%esp)
  801f7a:	e8 b7 ef ff ff       	call   800f36 <memmove>
	return r;
}
  801f7f:	89 d8                	mov    %ebx,%eax
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 24             	sub    $0x24,%esp
  801f8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f92:	89 1c 24             	mov    %ebx,(%esp)
  801f95:	e8 46 ed ff ff       	call   800ce0 <strlen>
  801f9a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f9f:	7f 60                	jg     802001 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa4:	89 04 24             	mov    %eax,(%esp)
  801fa7:	e8 1b f8 ff ff       	call   8017c7 <fd_alloc>
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	85 d2                	test   %edx,%edx
  801fb0:	78 54                	js     802006 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801fb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fb6:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801fbd:	e8 79 ed ff ff       	call   800d3b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc5:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd2:	e8 f8 fd ff ff       	call   801dcf <fsipc>
  801fd7:	89 c3                	mov    %eax,%ebx
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	79 17                	jns    801ff4 <open+0x6c>
		fd_close(fd, 0);
  801fdd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fe4:	00 
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	89 04 24             	mov    %eax,(%esp)
  801feb:	e8 12 f9 ff ff       	call   801902 <fd_close>
		return r;
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	eb 12                	jmp    802006 <open+0x7e>
	}
	return fd2num(fd);
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	89 04 24             	mov    %eax,(%esp)
  801ffa:	e8 a1 f7 ff ff       	call   8017a0 <fd2num>
  801fff:	eb 05                	jmp    802006 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802001:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  802006:	83 c4 24             	add    $0x24,%esp
  802009:	5b                   	pop    %ebx
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    
  80200c:	66 90                	xchg   %ax,%ax
  80200e:	66 90                	xchg   %ax,%ax

00802010 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	57                   	push   %edi
  802014:	56                   	push   %esi
  802015:	53                   	push   %ebx
  802016:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  80201c:	c7 04 24 c9 35 80 00 	movl   $0x8035c9,(%esp)
  802023:	e8 b8 e6 ff ff       	call   8006e0 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  802028:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80202f:	00 
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	89 04 24             	mov    %eax,(%esp)
  802036:	e8 4d ff ff ff       	call   801f88 <open>
  80203b:	89 c7                	mov    %eax,%edi
  80203d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802043:	85 c0                	test   %eax,%eax
  802045:	0f 88 09 05 00 00    	js     802554 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  80204b:	c7 04 24 d0 35 80 00 	movl   $0x8035d0,(%esp)
  802052:	e8 89 e6 ff ff       	call   8006e0 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802057:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80205e:	00 
  80205f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802065:	89 44 24 04          	mov    %eax,0x4(%esp)
  802069:	89 3c 24             	mov    %edi,(%esp)
  80206c:	e8 07 fb ff ff       	call   801b78 <readn>
  802071:	3d 00 02 00 00       	cmp    $0x200,%eax
  802076:	75 0c                	jne    802084 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  802078:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80207f:	45 4c 46 
  802082:	74 36                	je     8020ba <spawn+0xaa>
		close(fd);
  802084:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80208a:	89 04 24             	mov    %eax,(%esp)
  80208d:	e8 f1 f8 ff ff       	call   801983 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802092:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802099:	46 
  80209a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8020a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a4:	c7 04 24 e2 35 80 00 	movl   $0x8035e2,(%esp)
  8020ab:	e8 30 e6 ff ff       	call   8006e0 <cprintf>
		return -E_NOT_EXEC;
  8020b0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8020b5:	e9 f9 04 00 00       	jmp    8025b3 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  8020ba:	c7 04 24 fc 35 80 00 	movl   $0x8035fc,(%esp)
  8020c1:	e8 1a e6 ff ff       	call   8006e0 <cprintf>
  8020c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8020cb:	cd 30                	int    $0x30
  8020cd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8020d3:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	0f 88 7b 04 00 00    	js     80255c <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8020e1:	89 c6                	mov    %eax,%esi
  8020e3:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8020e9:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8020ec:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8020f2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8020f8:	b9 11 00 00 00       	mov    $0x11,%ecx
  8020fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8020ff:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802105:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  80210b:	c7 04 24 09 36 80 00 	movl   $0x803609,(%esp)
  802112:	e8 c9 e5 ff ff       	call   8006e0 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	74 38                	je     802158 <spawn+0x148>
  802120:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802125:	be 00 00 00 00       	mov    $0x0,%esi
  80212a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80212d:	89 04 24             	mov    %eax,(%esp)
  802130:	e8 ab eb ff ff       	call   800ce0 <strlen>
  802135:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802139:	83 c3 01             	add    $0x1,%ebx
  80213c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802143:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	75 e3                	jne    80212d <spawn+0x11d>
  80214a:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  802150:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802156:	eb 1e                	jmp    802176 <spawn+0x166>
  802158:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  80215f:	00 00 00 
  802162:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  802169:	00 00 00 
  80216c:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802171:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802176:	bf 00 10 40 00       	mov    $0x401000,%edi
  80217b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80217d:	89 fa                	mov    %edi,%edx
  80217f:	83 e2 fc             	and    $0xfffffffc,%edx
  802182:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802189:	29 c2                	sub    %eax,%edx
  80218b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802191:	8d 42 f8             	lea    -0x8(%edx),%eax
  802194:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802199:	0f 86 cd 03 00 00    	jbe    80256c <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80219f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021a6:	00 
  8021a7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021ae:	00 
  8021af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b6:	e8 2e f0 ff ff       	call   8011e9 <sys_page_alloc>
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	0f 88 f0 03 00 00    	js     8025b3 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8021c3:	85 db                	test   %ebx,%ebx
  8021c5:	7e 46                	jle    80220d <spawn+0x1fd>
  8021c7:	be 00 00 00 00       	mov    $0x0,%esi
  8021cc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8021d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  8021d5:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8021db:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8021e1:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8021e4:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8021e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021eb:	89 3c 24             	mov    %edi,(%esp)
  8021ee:	e8 48 eb ff ff       	call   800d3b <strcpy>
		string_store += strlen(argv[i]) + 1;
  8021f3:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8021f6:	89 04 24             	mov    %eax,(%esp)
  8021f9:	e8 e2 ea ff ff       	call   800ce0 <strlen>
  8021fe:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802202:	83 c6 01             	add    $0x1,%esi
  802205:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  80220b:	75 c8                	jne    8021d5 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80220d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802213:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802219:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802220:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802226:	74 24                	je     80224c <spawn+0x23c>
  802228:	c7 44 24 0c 7c 36 80 	movl   $0x80367c,0xc(%esp)
  80222f:	00 
  802230:	c7 44 24 08 9d 35 80 	movl   $0x80359d,0x8(%esp)
  802237:	00 
  802238:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  80223f:	00 
  802240:	c7 04 24 15 36 80 00 	movl   $0x803615,(%esp)
  802247:	e8 9b e3 ff ff       	call   8005e7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80224c:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802252:	89 c8                	mov    %ecx,%eax
  802254:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802259:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80225c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802262:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802265:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  80226b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802271:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802278:	00 
  802279:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802280:	ee 
  802281:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802287:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802292:	00 
  802293:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229a:	e8 9e ef ff ff       	call   80123d <sys_page_map>
  80229f:	89 c3                	mov    %eax,%ebx
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	0f 88 f4 02 00 00    	js     80259d <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8022a9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022b0:	00 
  8022b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b8:	e8 d3 ef ff ff       	call   801290 <sys_page_unmap>
  8022bd:	89 c3                	mov    %eax,%ebx
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	0f 88 d6 02 00 00    	js     80259d <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  8022c7:	c7 04 24 21 36 80 00 	movl   $0x803621,(%esp)
  8022ce:	e8 0d e4 ff ff       	call   8006e0 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8022d3:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8022d9:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8022e0:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8022e6:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  8022ed:	00 
  8022ee:	0f 84 dc 01 00 00    	je     8024d0 <spawn+0x4c0>
  8022f4:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8022fb:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  8022fe:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802304:	83 38 01             	cmpl   $0x1,(%eax)
  802307:	0f 85 a2 01 00 00    	jne    8024af <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80230d:	89 c1                	mov    %eax,%ecx
  80230f:	8b 40 18             	mov    0x18(%eax),%eax
  802312:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802315:	83 f8 01             	cmp    $0x1,%eax
  802318:	19 c0                	sbb    %eax,%eax
  80231a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802320:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  802327:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	8b 51 04             	mov    0x4(%ecx),%edx
  802333:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  802339:	8b 79 10             	mov    0x10(%ecx),%edi
  80233c:	8b 49 14             	mov    0x14(%ecx),%ecx
  80233f:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  802345:	8b 40 08             	mov    0x8(%eax),%eax
  802348:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80234e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802353:	74 14                	je     802369 <spawn+0x359>
		va -= i;
  802355:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  80235b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802361:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  802363:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802369:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802370:	0f 84 39 01 00 00    	je     8024af <spawn+0x49f>
  802376:	bb 00 00 00 00       	mov    $0x0,%ebx
  80237b:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802380:	39 f7                	cmp    %esi,%edi
  802382:	77 31                	ja     8023b5 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802384:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80238a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238e:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802394:	89 74 24 04          	mov    %esi,0x4(%esp)
  802398:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80239e:	89 04 24             	mov    %eax,(%esp)
  8023a1:	e8 43 ee ff ff       	call   8011e9 <sys_page_alloc>
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	0f 89 ed 00 00 00    	jns    80249b <spawn+0x48b>
  8023ae:	89 c3                	mov    %eax,%ebx
  8023b0:	e9 c8 01 00 00       	jmp    80257d <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8023b5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8023bc:	00 
  8023bd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023c4:	00 
  8023c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023cc:	e8 18 ee ff ff       	call   8011e9 <sys_page_alloc>
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	0f 88 9a 01 00 00    	js     802573 <spawn+0x563>
  8023d9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8023df:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8023e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8023eb:	89 04 24             	mov    %eax,(%esp)
  8023ee:	e8 6d f8 ff ff       	call   801c60 <seek>
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 88 7c 01 00 00    	js     802577 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	29 f2                	sub    %esi,%edx
  8023ff:	89 d0                	mov    %edx,%eax
  802401:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  802407:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80240c:	0f 47 c1             	cmova  %ecx,%eax
  80240f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802413:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80241a:	00 
  80241b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802421:	89 04 24             	mov    %eax,(%esp)
  802424:	e8 4f f7 ff ff       	call   801b78 <readn>
  802429:	85 c0                	test   %eax,%eax
  80242b:	0f 88 4a 01 00 00    	js     80257b <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802431:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802437:	89 44 24 10          	mov    %eax,0x10(%esp)
  80243b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802441:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802445:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80244b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80244f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802456:	00 
  802457:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80245e:	e8 da ed ff ff       	call   80123d <sys_page_map>
  802463:	85 c0                	test   %eax,%eax
  802465:	79 20                	jns    802487 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  802467:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80246b:	c7 44 24 08 2e 36 80 	movl   $0x80362e,0x8(%esp)
  802472:	00 
  802473:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  80247a:	00 
  80247b:	c7 04 24 15 36 80 00 	movl   $0x803615,(%esp)
  802482:	e8 60 e1 ff ff       	call   8005e7 <_panic>
			sys_page_unmap(0, UTEMP);
  802487:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80248e:	00 
  80248f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802496:	e8 f5 ed ff ff       	call   801290 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80249b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024a1:	89 de                	mov    %ebx,%esi
  8024a3:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  8024a9:	0f 82 d1 fe ff ff    	jb     802380 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8024af:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  8024b6:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8024bd:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8024c4:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  8024ca:	0f 8f 2e fe ff ff    	jg     8022fe <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8024d0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8024d6:	89 04 24             	mov    %eax,(%esp)
  8024d9:	e8 a5 f4 ff ff       	call   801983 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8024de:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8024e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024ee:	89 04 24             	mov    %eax,(%esp)
  8024f1:	e8 40 ee ff ff       	call   801336 <sys_env_set_trapframe>
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	79 20                	jns    80251a <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  8024fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024fe:	c7 44 24 08 4b 36 80 	movl   $0x80364b,0x8(%esp)
  802505:	00 
  802506:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80250d:	00 
  80250e:	c7 04 24 15 36 80 00 	movl   $0x803615,(%esp)
  802515:	e8 cd e0 ff ff       	call   8005e7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80251a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802521:	00 
  802522:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802528:	89 04 24             	mov    %eax,(%esp)
  80252b:	e8 b3 ed ff ff       	call   8012e3 <sys_env_set_status>
  802530:	85 c0                	test   %eax,%eax
  802532:	79 30                	jns    802564 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  802534:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802538:	c7 44 24 08 65 36 80 	movl   $0x803665,0x8(%esp)
  80253f:	00 
  802540:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  802547:	00 
  802548:	c7 04 24 15 36 80 00 	movl   $0x803615,(%esp)
  80254f:	e8 93 e0 ff ff       	call   8005e7 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802554:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80255a:	eb 57                	jmp    8025b3 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  80255c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802562:	eb 4f                	jmp    8025b3 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  802564:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80256a:	eb 47                	jmp    8025b3 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  80256c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802571:	eb 40                	jmp    8025b3 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802573:	89 c3                	mov    %eax,%ebx
  802575:	eb 06                	jmp    80257d <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802577:	89 c3                	mov    %eax,%ebx
  802579:	eb 02                	jmp    80257d <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80257b:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  80257d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802583:	89 04 24             	mov    %eax,(%esp)
  802586:	e8 ce eb ff ff       	call   801159 <sys_env_destroy>
	close(fd);
  80258b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802591:	89 04 24             	mov    %eax,(%esp)
  802594:	e8 ea f3 ff ff       	call   801983 <close>
	return r;
  802599:	89 d8                	mov    %ebx,%eax
  80259b:	eb 16                	jmp    8025b3 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80259d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8025a4:	00 
  8025a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ac:	e8 df ec ff ff       	call   801290 <sys_page_unmap>
  8025b1:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8025b3:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8025b9:	5b                   	pop    %ebx
  8025ba:	5e                   	pop    %esi
  8025bb:	5f                   	pop    %edi
  8025bc:	5d                   	pop    %ebp
  8025bd:	c3                   	ret    

008025be <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025cb:	74 61                	je     80262e <spawnl+0x70>
  8025cd:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8025d0:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  8025d5:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025d8:	83 c0 04             	add    $0x4,%eax
  8025db:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8025df:	74 04                	je     8025e5 <spawnl+0x27>
		argc++;
  8025e1:	89 ca                	mov    %ecx,%edx
  8025e3:	eb f0                	jmp    8025d5 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8025e5:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  8025ec:	83 e0 f0             	and    $0xfffffff0,%eax
  8025ef:	29 c4                	sub    %eax,%esp
  8025f1:	8d 74 24 0b          	lea    0xb(%esp),%esi
  8025f5:	c1 ee 02             	shr    $0x2,%esi
  8025f8:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  8025ff:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802601:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802604:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  80260b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  802612:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802613:	89 ce                	mov    %ecx,%esi
  802615:	85 c9                	test   %ecx,%ecx
  802617:	74 25                	je     80263e <spawnl+0x80>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  80261e:	83 c0 01             	add    $0x1,%eax
  802621:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  802625:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802628:	39 f0                	cmp    %esi,%eax
  80262a:	75 f2                	jne    80261e <spawnl+0x60>
  80262c:	eb 10                	jmp    80263e <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  80262e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802631:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  802634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80263b:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80263e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	89 04 24             	mov    %eax,(%esp)
  802648:	e8 c3 f9 ff ff       	call   802010 <spawn>
}
  80264d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	66 90                	xchg   %ax,%ax
  802657:	66 90                	xchg   %ax,%ax
  802659:	66 90                	xchg   %ax,%ax
  80265b:	66 90                	xchg   %ax,%ax
  80265d:	66 90                	xchg   %ax,%ax
  80265f:	90                   	nop

00802660 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	56                   	push   %esi
  802664:	53                   	push   %ebx
  802665:	83 ec 10             	sub    $0x10,%esp
  802668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	89 04 24             	mov    %eax,(%esp)
  802671:	e8 3a f1 ff ff       	call   8017b0 <fd2data>
  802676:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802678:	c7 44 24 04 a2 36 80 	movl   $0x8036a2,0x4(%esp)
  80267f:	00 
  802680:	89 1c 24             	mov    %ebx,(%esp)
  802683:	e8 b3 e6 ff ff       	call   800d3b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802688:	8b 46 04             	mov    0x4(%esi),%eax
  80268b:	2b 06                	sub    (%esi),%eax
  80268d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802693:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80269a:	00 00 00 
	stat->st_dev = &devpipe;
  80269d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8026a4:	40 80 00 
	return 0;
}
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	83 c4 10             	add    $0x10,%esp
  8026af:	5b                   	pop    %ebx
  8026b0:	5e                   	pop    %esi
  8026b1:	5d                   	pop    %ebp
  8026b2:	c3                   	ret    

008026b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	53                   	push   %ebx
  8026b7:	83 ec 14             	sub    $0x14,%esp
  8026ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c8:	e8 c3 eb ff ff       	call   801290 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026cd:	89 1c 24             	mov    %ebx,(%esp)
  8026d0:	e8 db f0 ff ff       	call   8017b0 <fd2data>
  8026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e0:	e8 ab eb ff ff       	call   801290 <sys_page_unmap>
}
  8026e5:	83 c4 14             	add    $0x14,%esp
  8026e8:	5b                   	pop    %ebx
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    

008026eb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	57                   	push   %edi
  8026ef:	56                   	push   %esi
  8026f0:	53                   	push   %ebx
  8026f1:	83 ec 2c             	sub    $0x2c,%esp
  8026f4:	89 c6                	mov    %eax,%esi
  8026f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8026f9:	a1 04 50 80 00       	mov    0x805004,%eax
  8026fe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802701:	89 34 24             	mov    %esi,(%esp)
  802704:	e8 42 05 00 00       	call   802c4b <pageref>
  802709:	89 c7                	mov    %eax,%edi
  80270b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270e:	89 04 24             	mov    %eax,(%esp)
  802711:	e8 35 05 00 00       	call   802c4b <pageref>
  802716:	39 c7                	cmp    %eax,%edi
  802718:	0f 94 c2             	sete   %dl
  80271b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80271e:	8b 0d 04 50 80 00    	mov    0x805004,%ecx
  802724:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802727:	39 fb                	cmp    %edi,%ebx
  802729:	74 21                	je     80274c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80272b:	84 d2                	test   %dl,%dl
  80272d:	74 ca                	je     8026f9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80272f:	8b 51 58             	mov    0x58(%ecx),%edx
  802732:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802736:	89 54 24 08          	mov    %edx,0x8(%esp)
  80273a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80273e:	c7 04 24 a9 36 80 00 	movl   $0x8036a9,(%esp)
  802745:	e8 96 df ff ff       	call   8006e0 <cprintf>
  80274a:	eb ad                	jmp    8026f9 <_pipeisclosed+0xe>
	}
}
  80274c:	83 c4 2c             	add    $0x2c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	57                   	push   %edi
  802758:	56                   	push   %esi
  802759:	53                   	push   %ebx
  80275a:	83 ec 1c             	sub    $0x1c,%esp
  80275d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802760:	89 34 24             	mov    %esi,(%esp)
  802763:	e8 48 f0 ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802768:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80276c:	74 61                	je     8027cf <devpipe_write+0x7b>
  80276e:	89 c3                	mov    %eax,%ebx
  802770:	bf 00 00 00 00       	mov    $0x0,%edi
  802775:	eb 4a                	jmp    8027c1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802777:	89 da                	mov    %ebx,%edx
  802779:	89 f0                	mov    %esi,%eax
  80277b:	e8 6b ff ff ff       	call   8026eb <_pipeisclosed>
  802780:	85 c0                	test   %eax,%eax
  802782:	75 54                	jne    8027d8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802784:	e8 41 ea ff ff       	call   8011ca <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802789:	8b 43 04             	mov    0x4(%ebx),%eax
  80278c:	8b 0b                	mov    (%ebx),%ecx
  80278e:	8d 51 20             	lea    0x20(%ecx),%edx
  802791:	39 d0                	cmp    %edx,%eax
  802793:	73 e2                	jae    802777 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802795:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802798:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80279c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80279f:	99                   	cltd   
  8027a0:	c1 ea 1b             	shr    $0x1b,%edx
  8027a3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8027a6:	83 e1 1f             	and    $0x1f,%ecx
  8027a9:	29 d1                	sub    %edx,%ecx
  8027ab:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8027af:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8027b3:	83 c0 01             	add    $0x1,%eax
  8027b6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027b9:	83 c7 01             	add    $0x1,%edi
  8027bc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027bf:	74 13                	je     8027d4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8027c4:	8b 0b                	mov    (%ebx),%ecx
  8027c6:	8d 51 20             	lea    0x20(%ecx),%edx
  8027c9:	39 d0                	cmp    %edx,%eax
  8027cb:	73 aa                	jae    802777 <devpipe_write+0x23>
  8027cd:	eb c6                	jmp    802795 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8027d4:	89 f8                	mov    %edi,%eax
  8027d6:	eb 05                	jmp    8027dd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8027dd:	83 c4 1c             	add    $0x1c,%esp
  8027e0:	5b                   	pop    %ebx
  8027e1:	5e                   	pop    %esi
  8027e2:	5f                   	pop    %edi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    

008027e5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	57                   	push   %edi
  8027e9:	56                   	push   %esi
  8027ea:	53                   	push   %ebx
  8027eb:	83 ec 1c             	sub    $0x1c,%esp
  8027ee:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027f1:	89 3c 24             	mov    %edi,(%esp)
  8027f4:	e8 b7 ef ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027fd:	74 54                	je     802853 <devpipe_read+0x6e>
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	be 00 00 00 00       	mov    $0x0,%esi
  802806:	eb 3e                	jmp    802846 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802808:	89 f0                	mov    %esi,%eax
  80280a:	eb 55                	jmp    802861 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80280c:	89 da                	mov    %ebx,%edx
  80280e:	89 f8                	mov    %edi,%eax
  802810:	e8 d6 fe ff ff       	call   8026eb <_pipeisclosed>
  802815:	85 c0                	test   %eax,%eax
  802817:	75 43                	jne    80285c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802819:	e8 ac e9 ff ff       	call   8011ca <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80281e:	8b 03                	mov    (%ebx),%eax
  802820:	3b 43 04             	cmp    0x4(%ebx),%eax
  802823:	74 e7                	je     80280c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802825:	99                   	cltd   
  802826:	c1 ea 1b             	shr    $0x1b,%edx
  802829:	01 d0                	add    %edx,%eax
  80282b:	83 e0 1f             	and    $0x1f,%eax
  80282e:	29 d0                	sub    %edx,%eax
  802830:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802835:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802838:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80283b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80283e:	83 c6 01             	add    $0x1,%esi
  802841:	3b 75 10             	cmp    0x10(%ebp),%esi
  802844:	74 12                	je     802858 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802846:	8b 03                	mov    (%ebx),%eax
  802848:	3b 43 04             	cmp    0x4(%ebx),%eax
  80284b:	75 d8                	jne    802825 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80284d:	85 f6                	test   %esi,%esi
  80284f:	75 b7                	jne    802808 <devpipe_read+0x23>
  802851:	eb b9                	jmp    80280c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802853:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802858:	89 f0                	mov    %esi,%eax
  80285a:	eb 05                	jmp    802861 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802861:	83 c4 1c             	add    $0x1c,%esp
  802864:	5b                   	pop    %ebx
  802865:	5e                   	pop    %esi
  802866:	5f                   	pop    %edi
  802867:	5d                   	pop    %ebp
  802868:	c3                   	ret    

00802869 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	56                   	push   %esi
  80286d:	53                   	push   %ebx
  80286e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802874:	89 04 24             	mov    %eax,(%esp)
  802877:	e8 4b ef ff ff       	call   8017c7 <fd_alloc>
  80287c:	89 c2                	mov    %eax,%edx
  80287e:	85 d2                	test   %edx,%edx
  802880:	0f 88 4d 01 00 00    	js     8029d3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802886:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80288d:	00 
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 44 24 04          	mov    %eax,0x4(%esp)
  802895:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289c:	e8 48 e9 ff ff       	call   8011e9 <sys_page_alloc>
  8028a1:	89 c2                	mov    %eax,%edx
  8028a3:	85 d2                	test   %edx,%edx
  8028a5:	0f 88 28 01 00 00    	js     8029d3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028ae:	89 04 24             	mov    %eax,(%esp)
  8028b1:	e8 11 ef ff ff       	call   8017c7 <fd_alloc>
  8028b6:	89 c3                	mov    %eax,%ebx
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	0f 88 fe 00 00 00    	js     8029be <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028c0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c7:	00 
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d6:	e8 0e e9 ff ff       	call   8011e9 <sys_page_alloc>
  8028db:	89 c3                	mov    %eax,%ebx
  8028dd:	85 c0                	test   %eax,%eax
  8028df:	0f 88 d9 00 00 00    	js     8029be <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 04 24             	mov    %eax,(%esp)
  8028eb:	e8 c0 ee ff ff       	call   8017b0 <fd2data>
  8028f0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f9:	00 
  8028fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802905:	e8 df e8 ff ff       	call   8011e9 <sys_page_alloc>
  80290a:	89 c3                	mov    %eax,%ebx
  80290c:	85 c0                	test   %eax,%eax
  80290e:	0f 88 97 00 00 00    	js     8029ab <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	89 04 24             	mov    %eax,(%esp)
  80291a:	e8 91 ee ff ff       	call   8017b0 <fd2data>
  80291f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802926:	00 
  802927:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80292b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802932:	00 
  802933:	89 74 24 04          	mov    %esi,0x4(%esp)
  802937:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80293e:	e8 fa e8 ff ff       	call   80123d <sys_page_map>
  802943:	89 c3                	mov    %eax,%ebx
  802945:	85 c0                	test   %eax,%eax
  802947:	78 52                	js     80299b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802949:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80295e:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	89 04 24             	mov    %eax,(%esp)
  802979:	e8 22 ee ff ff       	call   8017a0 <fd2num>
  80297e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802981:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	89 04 24             	mov    %eax,(%esp)
  802989:	e8 12 ee ff ff       	call   8017a0 <fd2num>
  80298e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802991:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802994:	b8 00 00 00 00       	mov    $0x0,%eax
  802999:	eb 38                	jmp    8029d3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80299b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80299f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a6:	e8 e5 e8 ff ff       	call   801290 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b9:	e8 d2 e8 ff ff       	call   801290 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029cc:	e8 bf e8 ff ff       	call   801290 <sys_page_unmap>
  8029d1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8029d3:	83 c4 30             	add    $0x30,%esp
  8029d6:	5b                   	pop    %ebx
  8029d7:	5e                   	pop    %esi
  8029d8:	5d                   	pop    %ebp
  8029d9:	c3                   	ret    

008029da <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
  8029dd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	89 04 24             	mov    %eax,(%esp)
  8029ed:	e8 49 ee ff ff       	call   80183b <fd_lookup>
  8029f2:	89 c2                	mov    %eax,%edx
  8029f4:	85 d2                	test   %edx,%edx
  8029f6:	78 15                	js     802a0d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	89 04 24             	mov    %eax,(%esp)
  8029fe:	e8 ad ed ff ff       	call   8017b0 <fd2data>
	return _pipeisclosed(fd, p);
  802a03:	89 c2                	mov    %eax,%edx
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	e8 de fc ff ff       	call   8026eb <_pipeisclosed>
}
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    

00802a0f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802a0f:	55                   	push   %ebp
  802a10:	89 e5                	mov    %esp,%ebp
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 10             	sub    $0x10,%esp
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	75 24                	jne    802a42 <wait+0x33>
  802a1e:	c7 44 24 0c c1 36 80 	movl   $0x8036c1,0xc(%esp)
  802a25:	00 
  802a26:	c7 44 24 08 9d 35 80 	movl   $0x80359d,0x8(%esp)
  802a2d:	00 
  802a2e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802a35:	00 
  802a36:	c7 04 24 cc 36 80 00 	movl   $0x8036cc,(%esp)
  802a3d:	e8 a5 db ff ff       	call   8005e7 <_panic>
	e = &envs[ENVX(envid)];
  802a42:	89 c3                	mov    %eax,%ebx
  802a44:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802a4a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802a4d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a53:	8b 73 48             	mov    0x48(%ebx),%esi
  802a56:	39 c6                	cmp    %eax,%esi
  802a58:	75 1a                	jne    802a74 <wait+0x65>
  802a5a:	8b 43 54             	mov    0x54(%ebx),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 13                	je     802a74 <wait+0x65>
		sys_yield();
  802a61:	e8 64 e7 ff ff       	call   8011ca <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a66:	8b 43 48             	mov    0x48(%ebx),%eax
  802a69:	39 f0                	cmp    %esi,%eax
  802a6b:	75 07                	jne    802a74 <wait+0x65>
  802a6d:	8b 43 54             	mov    0x54(%ebx),%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	75 ed                	jne    802a61 <wait+0x52>
		sys_yield();
}
  802a74:	83 c4 10             	add    $0x10,%esp
  802a77:	5b                   	pop    %ebx
  802a78:	5e                   	pop    %esi
  802a79:	5d                   	pop    %ebp
  802a7a:	c3                   	ret    

00802a7b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  802a81:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802a88:	75 50                	jne    802ada <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802a8a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a91:	00 
  802a92:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a99:	ee 
  802a9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aa1:	e8 43 e7 ff ff       	call   8011e9 <sys_page_alloc>
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	79 1c                	jns    802ac6 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802aaa:	c7 44 24 08 d8 36 80 	movl   $0x8036d8,0x8(%esp)
  802ab1:	00 
  802ab2:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802ab9:	00 
  802aba:	c7 04 24 fc 36 80 00 	movl   $0x8036fc,(%esp)
  802ac1:	e8 21 db ff ff       	call   8005e7 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802ac6:	c7 44 24 04 e4 2a 80 	movl   $0x802ae4,0x4(%esp)
  802acd:	00 
  802ace:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad5:	e8 af e8 ff ff       	call   801389 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

00802ae4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ae4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ae5:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802aea:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802aec:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  802aef:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  802af1:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802af6:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802af9:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802afe:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  802b01:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  802b03:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802b06:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802b08:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802b0a:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  802b0f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  802b12:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802b17:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802b1a:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802b1c:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  802b21:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  802b24:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802b29:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802b2c:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802b2e:	83 c4 08             	add    $0x8,%esp
	popal
  802b31:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802b32:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b33:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802b34:	c3                   	ret    

00802b35 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
  802b38:	56                   	push   %esi
  802b39:	53                   	push   %ebx
  802b3a:	83 ec 10             	sub    $0x10,%esp
  802b3d:	8b 75 08             	mov    0x8(%ebp),%esi
  802b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  802b46:	85 c0                	test   %eax,%eax
  802b48:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802b4d:	0f 44 c2             	cmove  %edx,%eax
  802b50:	89 04 24             	mov    %eax,(%esp)
  802b53:	e8 a7 e8 ff ff       	call   8013ff <sys_ipc_recv>
	if (err_code < 0) {
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	79 16                	jns    802b72 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802b5c:	85 f6                	test   %esi,%esi
  802b5e:	74 06                	je     802b66 <ipc_recv+0x31>
  802b60:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802b66:	85 db                	test   %ebx,%ebx
  802b68:	74 2c                	je     802b96 <ipc_recv+0x61>
  802b6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802b70:	eb 24                	jmp    802b96 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802b72:	85 f6                	test   %esi,%esi
  802b74:	74 0a                	je     802b80 <ipc_recv+0x4b>
  802b76:	a1 04 50 80 00       	mov    0x805004,%eax
  802b7b:	8b 40 74             	mov    0x74(%eax),%eax
  802b7e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802b80:	85 db                	test   %ebx,%ebx
  802b82:	74 0a                	je     802b8e <ipc_recv+0x59>
  802b84:	a1 04 50 80 00       	mov    0x805004,%eax
  802b89:	8b 40 78             	mov    0x78(%eax),%eax
  802b8c:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802b8e:	a1 04 50 80 00       	mov    0x805004,%eax
  802b93:	8b 40 70             	mov    0x70(%eax),%eax
}
  802b96:	83 c4 10             	add    $0x10,%esp
  802b99:	5b                   	pop    %ebx
  802b9a:	5e                   	pop    %esi
  802b9b:	5d                   	pop    %ebp
  802b9c:	c3                   	ret    

00802b9d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
  802ba0:	57                   	push   %edi
  802ba1:	56                   	push   %esi
  802ba2:	53                   	push   %ebx
  802ba3:	83 ec 1c             	sub    $0x1c,%esp
  802ba6:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ba9:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802baf:	eb 25                	jmp    802bd6 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802bb1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802bb4:	74 20                	je     802bd6 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802bb6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bba:	c7 44 24 08 0a 37 80 	movl   $0x80370a,0x8(%esp)
  802bc1:	00 
  802bc2:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802bc9:	00 
  802bca:	c7 04 24 16 37 80 00 	movl   $0x803716,(%esp)
  802bd1:	e8 11 da ff ff       	call   8005e7 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802bd6:	85 db                	test   %ebx,%ebx
  802bd8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802bdd:	0f 45 c3             	cmovne %ebx,%eax
  802be0:	8b 55 14             	mov    0x14(%ebp),%edx
  802be3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802be7:	89 44 24 08          	mov    %eax,0x8(%esp)
  802beb:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bef:	89 3c 24             	mov    %edi,(%esp)
  802bf2:	e8 e5 e7 ff ff       	call   8013dc <sys_ipc_try_send>
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	75 b6                	jne    802bb1 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802bfb:	83 c4 1c             	add    $0x1c,%esp
  802bfe:	5b                   	pop    %ebx
  802bff:	5e                   	pop    %esi
  802c00:	5f                   	pop    %edi
  802c01:	5d                   	pop    %ebp
  802c02:	c3                   	ret    

00802c03 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c03:	55                   	push   %ebp
  802c04:	89 e5                	mov    %esp,%ebp
  802c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802c09:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802c0e:	39 c8                	cmp    %ecx,%eax
  802c10:	74 17                	je     802c29 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c12:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802c17:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802c1a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802c20:	8b 52 50             	mov    0x50(%edx),%edx
  802c23:	39 ca                	cmp    %ecx,%edx
  802c25:	75 14                	jne    802c3b <ipc_find_env+0x38>
  802c27:	eb 05                	jmp    802c2e <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c29:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802c2e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c31:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802c36:	8b 40 40             	mov    0x40(%eax),%eax
  802c39:	eb 0e                	jmp    802c49 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c3b:	83 c0 01             	add    $0x1,%eax
  802c3e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802c43:	75 d2                	jne    802c17 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802c45:	66 b8 00 00          	mov    $0x0,%ax
}
  802c49:	5d                   	pop    %ebp
  802c4a:	c3                   	ret    

00802c4b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c51:	89 d0                	mov    %edx,%eax
  802c53:	c1 e8 16             	shr    $0x16,%eax
  802c56:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c62:	f6 c1 01             	test   $0x1,%cl
  802c65:	74 1d                	je     802c84 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c67:	c1 ea 0c             	shr    $0xc,%edx
  802c6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c71:	f6 c2 01             	test   $0x1,%dl
  802c74:	74 0e                	je     802c84 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c76:	c1 ea 0c             	shr    $0xc,%edx
  802c79:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c80:	ef 
  802c81:	0f b7 c0             	movzwl %ax,%eax
}
  802c84:	5d                   	pop    %ebp
  802c85:	c3                   	ret    
  802c86:	66 90                	xchg   %ax,%ax
  802c88:	66 90                	xchg   %ax,%ax
  802c8a:	66 90                	xchg   %ax,%ax
  802c8c:	66 90                	xchg   %ax,%ax
  802c8e:	66 90                	xchg   %ax,%ax

00802c90 <__udivdi3>:
  802c90:	55                   	push   %ebp
  802c91:	57                   	push   %edi
  802c92:	56                   	push   %esi
  802c93:	83 ec 0c             	sub    $0xc,%esp
  802c96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802c9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ca2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802cac:	89 ea                	mov    %ebp,%edx
  802cae:	89 0c 24             	mov    %ecx,(%esp)
  802cb1:	75 2d                	jne    802ce0 <__udivdi3+0x50>
  802cb3:	39 e9                	cmp    %ebp,%ecx
  802cb5:	77 61                	ja     802d18 <__udivdi3+0x88>
  802cb7:	85 c9                	test   %ecx,%ecx
  802cb9:	89 ce                	mov    %ecx,%esi
  802cbb:	75 0b                	jne    802cc8 <__udivdi3+0x38>
  802cbd:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc2:	31 d2                	xor    %edx,%edx
  802cc4:	f7 f1                	div    %ecx
  802cc6:	89 c6                	mov    %eax,%esi
  802cc8:	31 d2                	xor    %edx,%edx
  802cca:	89 e8                	mov    %ebp,%eax
  802ccc:	f7 f6                	div    %esi
  802cce:	89 c5                	mov    %eax,%ebp
  802cd0:	89 f8                	mov    %edi,%eax
  802cd2:	f7 f6                	div    %esi
  802cd4:	89 ea                	mov    %ebp,%edx
  802cd6:	83 c4 0c             	add    $0xc,%esp
  802cd9:	5e                   	pop    %esi
  802cda:	5f                   	pop    %edi
  802cdb:	5d                   	pop    %ebp
  802cdc:	c3                   	ret    
  802cdd:	8d 76 00             	lea    0x0(%esi),%esi
  802ce0:	39 e8                	cmp    %ebp,%eax
  802ce2:	77 24                	ja     802d08 <__udivdi3+0x78>
  802ce4:	0f bd e8             	bsr    %eax,%ebp
  802ce7:	83 f5 1f             	xor    $0x1f,%ebp
  802cea:	75 3c                	jne    802d28 <__udivdi3+0x98>
  802cec:	8b 74 24 04          	mov    0x4(%esp),%esi
  802cf0:	39 34 24             	cmp    %esi,(%esp)
  802cf3:	0f 86 9f 00 00 00    	jbe    802d98 <__udivdi3+0x108>
  802cf9:	39 d0                	cmp    %edx,%eax
  802cfb:	0f 82 97 00 00 00    	jb     802d98 <__udivdi3+0x108>
  802d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d08:	31 d2                	xor    %edx,%edx
  802d0a:	31 c0                	xor    %eax,%eax
  802d0c:	83 c4 0c             	add    $0xc,%esp
  802d0f:	5e                   	pop    %esi
  802d10:	5f                   	pop    %edi
  802d11:	5d                   	pop    %ebp
  802d12:	c3                   	ret    
  802d13:	90                   	nop
  802d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d18:	89 f8                	mov    %edi,%eax
  802d1a:	f7 f1                	div    %ecx
  802d1c:	31 d2                	xor    %edx,%edx
  802d1e:	83 c4 0c             	add    $0xc,%esp
  802d21:	5e                   	pop    %esi
  802d22:	5f                   	pop    %edi
  802d23:	5d                   	pop    %ebp
  802d24:	c3                   	ret    
  802d25:	8d 76 00             	lea    0x0(%esi),%esi
  802d28:	89 e9                	mov    %ebp,%ecx
  802d2a:	8b 3c 24             	mov    (%esp),%edi
  802d2d:	d3 e0                	shl    %cl,%eax
  802d2f:	89 c6                	mov    %eax,%esi
  802d31:	b8 20 00 00 00       	mov    $0x20,%eax
  802d36:	29 e8                	sub    %ebp,%eax
  802d38:	89 c1                	mov    %eax,%ecx
  802d3a:	d3 ef                	shr    %cl,%edi
  802d3c:	89 e9                	mov    %ebp,%ecx
  802d3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d42:	8b 3c 24             	mov    (%esp),%edi
  802d45:	09 74 24 08          	or     %esi,0x8(%esp)
  802d49:	89 d6                	mov    %edx,%esi
  802d4b:	d3 e7                	shl    %cl,%edi
  802d4d:	89 c1                	mov    %eax,%ecx
  802d4f:	89 3c 24             	mov    %edi,(%esp)
  802d52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d56:	d3 ee                	shr    %cl,%esi
  802d58:	89 e9                	mov    %ebp,%ecx
  802d5a:	d3 e2                	shl    %cl,%edx
  802d5c:	89 c1                	mov    %eax,%ecx
  802d5e:	d3 ef                	shr    %cl,%edi
  802d60:	09 d7                	or     %edx,%edi
  802d62:	89 f2                	mov    %esi,%edx
  802d64:	89 f8                	mov    %edi,%eax
  802d66:	f7 74 24 08          	divl   0x8(%esp)
  802d6a:	89 d6                	mov    %edx,%esi
  802d6c:	89 c7                	mov    %eax,%edi
  802d6e:	f7 24 24             	mull   (%esp)
  802d71:	39 d6                	cmp    %edx,%esi
  802d73:	89 14 24             	mov    %edx,(%esp)
  802d76:	72 30                	jb     802da8 <__udivdi3+0x118>
  802d78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d7c:	89 e9                	mov    %ebp,%ecx
  802d7e:	d3 e2                	shl    %cl,%edx
  802d80:	39 c2                	cmp    %eax,%edx
  802d82:	73 05                	jae    802d89 <__udivdi3+0xf9>
  802d84:	3b 34 24             	cmp    (%esp),%esi
  802d87:	74 1f                	je     802da8 <__udivdi3+0x118>
  802d89:	89 f8                	mov    %edi,%eax
  802d8b:	31 d2                	xor    %edx,%edx
  802d8d:	e9 7a ff ff ff       	jmp    802d0c <__udivdi3+0x7c>
  802d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d98:	31 d2                	xor    %edx,%edx
  802d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d9f:	e9 68 ff ff ff       	jmp    802d0c <__udivdi3+0x7c>
  802da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802da8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802dab:	31 d2                	xor    %edx,%edx
  802dad:	83 c4 0c             	add    $0xc,%esp
  802db0:	5e                   	pop    %esi
  802db1:	5f                   	pop    %edi
  802db2:	5d                   	pop    %ebp
  802db3:	c3                   	ret    
  802db4:	66 90                	xchg   %ax,%ax
  802db6:	66 90                	xchg   %ax,%ax
  802db8:	66 90                	xchg   %ax,%ax
  802dba:	66 90                	xchg   %ax,%ax
  802dbc:	66 90                	xchg   %ax,%ax
  802dbe:	66 90                	xchg   %ax,%ax

00802dc0 <__umoddi3>:
  802dc0:	55                   	push   %ebp
  802dc1:	57                   	push   %edi
  802dc2:	56                   	push   %esi
  802dc3:	83 ec 14             	sub    $0x14,%esp
  802dc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802dca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802dce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802dd2:	89 c7                	mov    %eax,%edi
  802dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802ddc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802de0:	89 34 24             	mov    %esi,(%esp)
  802de3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802de7:	85 c0                	test   %eax,%eax
  802de9:	89 c2                	mov    %eax,%edx
  802deb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802def:	75 17                	jne    802e08 <__umoddi3+0x48>
  802df1:	39 fe                	cmp    %edi,%esi
  802df3:	76 4b                	jbe    802e40 <__umoddi3+0x80>
  802df5:	89 c8                	mov    %ecx,%eax
  802df7:	89 fa                	mov    %edi,%edx
  802df9:	f7 f6                	div    %esi
  802dfb:	89 d0                	mov    %edx,%eax
  802dfd:	31 d2                	xor    %edx,%edx
  802dff:	83 c4 14             	add    $0x14,%esp
  802e02:	5e                   	pop    %esi
  802e03:	5f                   	pop    %edi
  802e04:	5d                   	pop    %ebp
  802e05:	c3                   	ret    
  802e06:	66 90                	xchg   %ax,%ax
  802e08:	39 f8                	cmp    %edi,%eax
  802e0a:	77 54                	ja     802e60 <__umoddi3+0xa0>
  802e0c:	0f bd e8             	bsr    %eax,%ebp
  802e0f:	83 f5 1f             	xor    $0x1f,%ebp
  802e12:	75 5c                	jne    802e70 <__umoddi3+0xb0>
  802e14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802e18:	39 3c 24             	cmp    %edi,(%esp)
  802e1b:	0f 87 e7 00 00 00    	ja     802f08 <__umoddi3+0x148>
  802e21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e25:	29 f1                	sub    %esi,%ecx
  802e27:	19 c7                	sbb    %eax,%edi
  802e29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802e39:	83 c4 14             	add    $0x14,%esp
  802e3c:	5e                   	pop    %esi
  802e3d:	5f                   	pop    %edi
  802e3e:	5d                   	pop    %ebp
  802e3f:	c3                   	ret    
  802e40:	85 f6                	test   %esi,%esi
  802e42:	89 f5                	mov    %esi,%ebp
  802e44:	75 0b                	jne    802e51 <__umoddi3+0x91>
  802e46:	b8 01 00 00 00       	mov    $0x1,%eax
  802e4b:	31 d2                	xor    %edx,%edx
  802e4d:	f7 f6                	div    %esi
  802e4f:	89 c5                	mov    %eax,%ebp
  802e51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e55:	31 d2                	xor    %edx,%edx
  802e57:	f7 f5                	div    %ebp
  802e59:	89 c8                	mov    %ecx,%eax
  802e5b:	f7 f5                	div    %ebp
  802e5d:	eb 9c                	jmp    802dfb <__umoddi3+0x3b>
  802e5f:	90                   	nop
  802e60:	89 c8                	mov    %ecx,%eax
  802e62:	89 fa                	mov    %edi,%edx
  802e64:	83 c4 14             	add    $0x14,%esp
  802e67:	5e                   	pop    %esi
  802e68:	5f                   	pop    %edi
  802e69:	5d                   	pop    %ebp
  802e6a:	c3                   	ret    
  802e6b:	90                   	nop
  802e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e70:	8b 04 24             	mov    (%esp),%eax
  802e73:	be 20 00 00 00       	mov    $0x20,%esi
  802e78:	89 e9                	mov    %ebp,%ecx
  802e7a:	29 ee                	sub    %ebp,%esi
  802e7c:	d3 e2                	shl    %cl,%edx
  802e7e:	89 f1                	mov    %esi,%ecx
  802e80:	d3 e8                	shr    %cl,%eax
  802e82:	89 e9                	mov    %ebp,%ecx
  802e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e88:	8b 04 24             	mov    (%esp),%eax
  802e8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802e8f:	89 fa                	mov    %edi,%edx
  802e91:	d3 e0                	shl    %cl,%eax
  802e93:	89 f1                	mov    %esi,%ecx
  802e95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802e9d:	d3 ea                	shr    %cl,%edx
  802e9f:	89 e9                	mov    %ebp,%ecx
  802ea1:	d3 e7                	shl    %cl,%edi
  802ea3:	89 f1                	mov    %esi,%ecx
  802ea5:	d3 e8                	shr    %cl,%eax
  802ea7:	89 e9                	mov    %ebp,%ecx
  802ea9:	09 f8                	or     %edi,%eax
  802eab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802eaf:	f7 74 24 04          	divl   0x4(%esp)
  802eb3:	d3 e7                	shl    %cl,%edi
  802eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eb9:	89 d7                	mov    %edx,%edi
  802ebb:	f7 64 24 08          	mull   0x8(%esp)
  802ebf:	39 d7                	cmp    %edx,%edi
  802ec1:	89 c1                	mov    %eax,%ecx
  802ec3:	89 14 24             	mov    %edx,(%esp)
  802ec6:	72 2c                	jb     802ef4 <__umoddi3+0x134>
  802ec8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ecc:	72 22                	jb     802ef0 <__umoddi3+0x130>
  802ece:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ed2:	29 c8                	sub    %ecx,%eax
  802ed4:	19 d7                	sbb    %edx,%edi
  802ed6:	89 e9                	mov    %ebp,%ecx
  802ed8:	89 fa                	mov    %edi,%edx
  802eda:	d3 e8                	shr    %cl,%eax
  802edc:	89 f1                	mov    %esi,%ecx
  802ede:	d3 e2                	shl    %cl,%edx
  802ee0:	89 e9                	mov    %ebp,%ecx
  802ee2:	d3 ef                	shr    %cl,%edi
  802ee4:	09 d0                	or     %edx,%eax
  802ee6:	89 fa                	mov    %edi,%edx
  802ee8:	83 c4 14             	add    $0x14,%esp
  802eeb:	5e                   	pop    %esi
  802eec:	5f                   	pop    %edi
  802eed:	5d                   	pop    %ebp
  802eee:	c3                   	ret    
  802eef:	90                   	nop
  802ef0:	39 d7                	cmp    %edx,%edi
  802ef2:	75 da                	jne    802ece <__umoddi3+0x10e>
  802ef4:	8b 14 24             	mov    (%esp),%edx
  802ef7:	89 c1                	mov    %eax,%ecx
  802ef9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802efd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802f01:	eb cb                	jmp    802ece <__umoddi3+0x10e>
  802f03:	90                   	nop
  802f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802f0c:	0f 82 0f ff ff ff    	jb     802e21 <__umoddi3+0x61>
  802f12:	e9 1a ff ff ff       	jmp    802e31 <__umoddi3+0x71>
