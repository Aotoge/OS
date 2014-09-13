
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
  800060:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  800067:	e8 74 06 00 00       	call   8006e0 <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 2b 2f 80 00 	movl   $0x802f2b,(%esp)
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
  8000a1:	c7 04 24 3a 2f 80 00 	movl   $0x802f3a,(%esp)
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
  8000d6:	c7 04 24 35 2f 80 00 	movl   $0x802f35,(%esp)
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
  800125:	c7 04 24 48 2f 80 00 	movl   $0x802f48,(%esp)
  80012c:	e8 25 1e 00 00       	call   801f56 <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 55 2f 80 	movl   $0x802f55,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
  800152:	e8 90 04 00 00       	call   8005e7 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 97 26 00 00       	call   8027f9 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 7c 2f 80 	movl   $0x802f7c,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
  800181:	e8 61 04 00 00       	call   8005e7 <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 e4 2e 80 00 	movl   $0x802ee4,(%esp)
  800190:	e8 4b 05 00 00       	call   8006e0 <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 a6 13 00 00       	call   801540 <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 85 2f 80 	movl   $0x802f85,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
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
  8001fe:	c7 44 24 08 8e 2f 80 	movl   $0x802f8e,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 52 2f 80 	movl   $0x802f52,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 91 2f 80 00 	movl   $0x802f91,(%esp)
  800215:	e8 38 23 00 00       	call   802552 <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 95 2f 80 	movl   $0x802f95,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
  80023b:	e8 a7 03 00 00       	call   8005e7 <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 37 17 00 00       	call   801983 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 2b 17 00 00       	call   801983 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 3f 27 00 00       	call   80299f <wait>
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
  800283:	c7 04 24 9f 2f 80 00 	movl   $0x802f9f,(%esp)
  80028a:	e8 c7 1c 00 00       	call   801f56 <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 08 2f 80 	movl   $0x802f08,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
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
  8002fe:	c7 44 24 08 ad 2f 80 	movl   $0x802fad,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
  800315:	e8 cd 02 00 00       	call   8005e7 <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
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
  80037c:	c7 04 24 e1 2f 80 00 	movl   $0x802fe1,(%esp)
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
  8003b0:	c7 44 24 04 f6 2f 80 	movl   $0x802ff6,0x4(%esp)
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
  800613:	c7 04 24 0c 30 80 00 	movl   $0x80300c,(%esp)
  80061a:	e8 c1 00 00 00       	call   8006e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80061f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800623:	8b 45 10             	mov    0x10(%ebp),%eax
  800626:	89 04 24             	mov    %eax,(%esp)
  800629:	e8 51 00 00 00       	call   80067f <vcprintf>
	cprintf("\n");
  80062e:	c7 04 24 38 2f 80 00 	movl   $0x802f38,(%esp)
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
  80077c:	e8 9f 24 00 00       	call   802c20 <__udivdi3>
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
  8007d5:	e8 76 25 00 00       	call   802d50 <__umoddi3>
  8007da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007de:	0f be 80 2f 30 80 00 	movsbl 0x80302f(%eax),%eax
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
  8008fc:	ff 24 85 80 31 80 00 	jmp    *0x803180(,%eax,4)
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
  8009af:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	75 20                	jne    8009da <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009be:	c7 44 24 08 47 30 80 	movl   $0x803047,0x8(%esp)
  8009c5:	00 
  8009c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	89 04 24             	mov    %eax,(%esp)
  8009d0:	e8 77 fe ff ff       	call   80084c <printfmt>
  8009d5:	e9 c3 fe ff ff       	jmp    80089d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8009da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009de:	c7 44 24 08 2f 35 80 	movl   $0x80352f,0x8(%esp)
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
  800a0d:	ba 40 30 80 00       	mov    $0x803040,%edx
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
  801187:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  80118e:	00 
  80118f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801196:	00 
  801197:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  801219:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801220:	00 
  801221:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801228:	00 
  801229:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  80126c:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  8012bf:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  801312:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801319:	00 
  80131a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801321:	00 
  801322:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  801365:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  80136c:	00 
  80136d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801374:	00 
  801375:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  8013b8:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  8013bf:	00 
  8013c0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013c7:	00 
  8013c8:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  80142d:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801434:	00 
  801435:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80143c:	00 
  80143d:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
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
  801474:	c7 44 24 08 6c 33 80 	movl   $0x80336c,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  8014b4:	c7 44 24 08 d4 33 80 	movl   $0x8033d4,0x8(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8014c3:	00 
  8014c4:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  80151e:	c7 44 24 08 ee 33 80 	movl   $0x8033ee,0x8(%esp)
  801525:	00 
  801526:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80152d:	00 
  80152e:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  801550:	e8 b6 14 00 00       	call   802a0b <set_pgfault_handler>
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
  801563:	c7 44 24 08 07 34 80 	movl   $0x803407,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801572:	00 
  801573:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  80160f:	c7 44 24 08 0c 34 80 	movl   $0x80340c,0x8(%esp)
  801616:	00 
  801617:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80161e:	00 
  80161f:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  801653:	c7 44 24 08 26 34 80 	movl   $0x803426,0x8(%esp)
  80165a:	00 
  80165b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801662:	00 
  801663:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  801697:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  80169e:	00 
  80169f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  8016a6:	00 
  8016a7:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  8016c2:	c7 44 24 04 74 2a 80 	movl   $0x802a74,0x4(%esp)
  8016c9:	00 
  8016ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016cd:	89 04 24             	mov    %eax,(%esp)
  8016d0:	e8 b4 fc ff ff       	call   801389 <sys_env_set_pgfault_upcall>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	79 20                	jns    8016f9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  8016d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016dd:	c7 44 24 08 a4 33 80 	movl   $0x8033a4,0x8(%esp)
  8016e4:	00 
  8016e5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8016ec:	00 
  8016ed:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  80171c:	c7 44 24 08 52 34 80 	movl   $0x803452,0x8(%esp)
  801723:	00 
  801724:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  80172b:	00 
  80172c:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  801753:	c7 44 24 08 6a 34 80 	movl   $0x80346a,0x8(%esp)
  80175a:	00 
  80175b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801762:	00 
  801763:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  801780:	c7 44 24 08 85 34 80 	movl   $0x803485,0x8(%esp)
  801787:	00 
  801788:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  80178f:	00 
  801790:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
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
  8018e5:	c7 04 24 9c 34 80 00 	movl   $0x80349c,(%esp)
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
  801b3b:	c7 04 24 dd 34 80 00 	movl   $0x8034dd,(%esp)
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
  801c23:	c7 04 24 f9 34 80 00 	movl   $0x8034f9,(%esp)
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
  801cdc:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
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
  801da2:	e8 af 01 00 00       	call   801f56 <open>
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
  801dd7:	89 c6                	mov    %eax,%esi
  801dd9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ddb:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801de2:	75 11                	jne    801df5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801deb:	e8 a5 0d 00 00       	call   802b95 <ipc_find_env>
  801df0:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801df5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dfc:	00 
  801dfd:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e04:	00 
  801e05:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e09:	a1 00 50 80 00       	mov    0x805000,%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 19 0d 00 00       	call   802b2f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e1d:	00 
  801e1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e29:	e8 97 0c 00 00       	call   802ac5 <ipc_recv>
}
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    

00801e35 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	53                   	push   %ebx
  801e39:	83 ec 14             	sub    $0x14,%esp
  801e3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	8b 40 0c             	mov    0xc(%eax),%eax
  801e45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e54:	e8 76 ff ff ff       	call   801dcf <fsipc>
  801e59:	89 c2                	mov    %eax,%edx
  801e5b:	85 d2                	test   %edx,%edx
  801e5d:	78 2b                	js     801e8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e66:	00 
  801e67:	89 1c 24             	mov    %ebx,(%esp)
  801e6a:	e8 cc ee ff ff       	call   800d3b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	83 c4 14             	add    $0x14,%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    

00801e90 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea6:	b8 06 00 00 00       	mov    $0x6,%eax
  801eab:	e8 1f ff ff ff       	call   801dcf <fsipc>
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 10             	sub    $0x10,%esp
  801eba:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ec8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ed8:	e8 f2 fe ff ff       	call   801dcf <fsipc>
  801edd:	89 c3                	mov    %eax,%ebx
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 6a                	js     801f4d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ee3:	39 c6                	cmp    %eax,%esi
  801ee5:	73 24                	jae    801f0b <devfile_read+0x59>
  801ee7:	c7 44 24 0c 16 35 80 	movl   $0x803516,0xc(%esp)
  801eee:	00 
  801eef:	c7 44 24 08 1d 35 80 	movl   $0x80351d,0x8(%esp)
  801ef6:	00 
  801ef7:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801efe:	00 
  801eff:	c7 04 24 32 35 80 00 	movl   $0x803532,(%esp)
  801f06:	e8 dc e6 ff ff       	call   8005e7 <_panic>
	assert(r <= PGSIZE);
  801f0b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f10:	7e 24                	jle    801f36 <devfile_read+0x84>
  801f12:	c7 44 24 0c 3d 35 80 	movl   $0x80353d,0xc(%esp)
  801f19:	00 
  801f1a:	c7 44 24 08 1d 35 80 	movl   $0x80351d,0x8(%esp)
  801f21:	00 
  801f22:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801f29:	00 
  801f2a:	c7 04 24 32 35 80 00 	movl   $0x803532,(%esp)
  801f31:	e8 b1 e6 ff ff       	call   8005e7 <_panic>
	memmove(buf, &fsipcbuf, r);
  801f36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f3a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f41:	00 
  801f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f45:	89 04 24             	mov    %eax,(%esp)
  801f48:	e8 e9 ef ff ff       	call   800f36 <memmove>
	return r;
}
  801f4d:	89 d8                	mov    %ebx,%eax
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5e                   	pop    %esi
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 24             	sub    $0x24,%esp
  801f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f60:	89 1c 24             	mov    %ebx,(%esp)
  801f63:	e8 78 ed ff ff       	call   800ce0 <strlen>
  801f68:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f6d:	7f 60                	jg     801fcf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f72:	89 04 24             	mov    %eax,(%esp)
  801f75:	e8 4d f8 ff ff       	call   8017c7 <fd_alloc>
  801f7a:	89 c2                	mov    %eax,%edx
  801f7c:	85 d2                	test   %edx,%edx
  801f7e:	78 54                	js     801fd4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f84:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f8b:	e8 ab ed ff ff       	call   800d3b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa0:	e8 2a fe ff ff       	call   801dcf <fsipc>
  801fa5:	89 c3                	mov    %eax,%ebx
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	79 17                	jns    801fc2 <open+0x6c>
		fd_close(fd, 0);
  801fab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fb2:	00 
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	89 04 24             	mov    %eax,(%esp)
  801fb9:	e8 44 f9 ff ff       	call   801902 <fd_close>
		return r;
  801fbe:	89 d8                	mov    %ebx,%eax
  801fc0:	eb 12                	jmp    801fd4 <open+0x7e>
	}

	return fd2num(fd);
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	89 04 24             	mov    %eax,(%esp)
  801fc8:	e8 d3 f7 ff ff       	call   8017a0 <fd2num>
  801fcd:	eb 05                	jmp    801fd4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fcf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fd4:	83 c4 24             	add    $0x24,%esp
  801fd7:	5b                   	pop    %ebx
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    
  801fda:	66 90                	xchg   %ax,%ax
  801fdc:	66 90                	xchg   %ax,%ax
  801fde:	66 90                	xchg   %ax,%ax

00801fe0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	57                   	push   %edi
  801fe4:	56                   	push   %esi
  801fe5:	53                   	push   %ebx
  801fe6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801fec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ff3:	00 
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	89 04 24             	mov    %eax,(%esp)
  801ffa:	e8 57 ff ff ff       	call   801f56 <open>
  801fff:	89 c1                	mov    %eax,%ecx
  802001:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	0f 88 d9 04 00 00    	js     8024e8 <spawn+0x508>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80200f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802016:	00 
  802017:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80201d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802021:	89 0c 24             	mov    %ecx,(%esp)
  802024:	e8 4f fb ff ff       	call   801b78 <readn>
  802029:	3d 00 02 00 00       	cmp    $0x200,%eax
  80202e:	75 0c                	jne    80203c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802030:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802037:	45 4c 46 
  80203a:	74 36                	je     802072 <spawn+0x92>
		close(fd);
  80203c:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802042:	89 04 24             	mov    %eax,(%esp)
  802045:	e8 39 f9 ff ff       	call   801983 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80204a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802051:	46 
  802052:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	c7 04 24 49 35 80 00 	movl   $0x803549,(%esp)
  802063:	e8 78 e6 ff ff       	call   8006e0 <cprintf>
		return -E_NOT_EXEC;
  802068:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80206d:	e9 d5 04 00 00       	jmp    802547 <spawn+0x567>
  802072:	b8 07 00 00 00       	mov    $0x7,%eax
  802077:	cd 30                	int    $0x30
  802079:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80207f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802085:	85 c0                	test   %eax,%eax
  802087:	0f 88 63 04 00 00    	js     8024f0 <spawn+0x510>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80208d:	89 c6                	mov    %eax,%esi
  80208f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802095:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802098:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80209e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8020a4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8020a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8020ab:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8020b1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	74 38                	je     8020f8 <spawn+0x118>
  8020c0:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8020c5:	be 00 00 00 00       	mov    $0x0,%esi
  8020ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8020cd:	89 04 24             	mov    %eax,(%esp)
  8020d0:	e8 0b ec ff ff       	call   800ce0 <strlen>
  8020d5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020d9:	83 c3 01             	add    $0x1,%ebx
  8020dc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8020e3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	75 e3                	jne    8020cd <spawn+0xed>
  8020ea:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8020f0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8020f6:	eb 1e                	jmp    802116 <spawn+0x136>
  8020f8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  8020ff:	00 00 00 
  802102:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  802109:	00 00 00 
  80210c:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802111:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802116:	bf 00 10 40 00       	mov    $0x401000,%edi
  80211b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80211d:	89 fa                	mov    %edi,%edx
  80211f:	83 e2 fc             	and    $0xfffffffc,%edx
  802122:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802129:	29 c2                	sub    %eax,%edx
  80212b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802131:	8d 42 f8             	lea    -0x8(%edx),%eax
  802134:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802139:	0f 86 c1 03 00 00    	jbe    802500 <spawn+0x520>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80213f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802146:	00 
  802147:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80214e:	00 
  80214f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802156:	e8 8e f0 ff ff       	call   8011e9 <sys_page_alloc>
  80215b:	85 c0                	test   %eax,%eax
  80215d:	0f 88 e4 03 00 00    	js     802547 <spawn+0x567>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802163:	85 db                	test   %ebx,%ebx
  802165:	7e 46                	jle    8021ad <spawn+0x1cd>
  802167:	be 00 00 00 00       	mov    $0x0,%esi
  80216c:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802172:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  802175:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80217b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802181:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802184:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218b:	89 3c 24             	mov    %edi,(%esp)
  80218e:	e8 a8 eb ff ff       	call   800d3b <strcpy>
		string_store += strlen(argv[i]) + 1;
  802193:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802196:	89 04 24             	mov    %eax,(%esp)
  802199:	e8 42 eb ff ff       	call   800ce0 <strlen>
  80219e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8021a2:	83 c6 01             	add    $0x1,%esi
  8021a5:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  8021ab:	75 c8                	jne    802175 <spawn+0x195>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8021ad:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8021b3:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8021b9:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8021c0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8021c6:	74 24                	je     8021ec <spawn+0x20c>
  8021c8:	c7 44 24 0c c0 35 80 	movl   $0x8035c0,0xc(%esp)
  8021cf:	00 
  8021d0:	c7 44 24 08 1d 35 80 	movl   $0x80351d,0x8(%esp)
  8021d7:	00 
  8021d8:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  8021df:	00 
  8021e0:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  8021e7:	e8 fb e3 ff ff       	call   8005e7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8021ec:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8021f2:	89 c8                	mov    %ecx,%eax
  8021f4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8021f9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8021fc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802202:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802205:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  80220b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802211:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802218:	00 
  802219:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802220:	ee 
  802221:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802227:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802232:	00 
  802233:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223a:	e8 fe ef ff ff       	call   80123d <sys_page_map>
  80223f:	89 c3                	mov    %eax,%ebx
  802241:	85 c0                	test   %eax,%eax
  802243:	0f 88 e8 02 00 00    	js     802531 <spawn+0x551>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802249:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802250:	00 
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 33 f0 ff ff       	call   801290 <sys_page_unmap>
  80225d:	89 c3                	mov    %eax,%ebx
  80225f:	85 c0                	test   %eax,%eax
  802261:	0f 88 ca 02 00 00    	js     802531 <spawn+0x551>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802267:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80226d:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802274:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80227a:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802281:	00 
  802282:	0f 84 dc 01 00 00    	je     802464 <spawn+0x484>
  802288:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  80228f:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  802292:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802298:	83 38 01             	cmpl   $0x1,(%eax)
  80229b:	0f 85 a2 01 00 00    	jne    802443 <spawn+0x463>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8022a1:	89 c1                	mov    %eax,%ecx
  8022a3:	8b 40 18             	mov    0x18(%eax),%eax
  8022a6:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  8022a9:	83 f8 01             	cmp    $0x1,%eax
  8022ac:	19 c0                	sbb    %eax,%eax
  8022ae:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8022b4:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  8022bb:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8022c2:	89 c8                	mov    %ecx,%eax
  8022c4:	8b 51 04             	mov    0x4(%ecx),%edx
  8022c7:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  8022cd:	8b 79 10             	mov    0x10(%ecx),%edi
  8022d0:	8b 49 14             	mov    0x14(%ecx),%ecx
  8022d3:	89 8d 90 fd ff ff    	mov    %ecx,-0x270(%ebp)
  8022d9:	8b 40 08             	mov    0x8(%eax),%eax
  8022dc:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8022e2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022e7:	74 14                	je     8022fd <spawn+0x31d>
		va -= i;
  8022e9:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  8022ef:	01 85 90 fd ff ff    	add    %eax,-0x270(%ebp)
		filesz += i;
  8022f5:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  8022f7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8022fd:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  802304:	0f 84 39 01 00 00    	je     802443 <spawn+0x463>
  80230a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80230f:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802314:	39 f7                	cmp    %esi,%edi
  802316:	77 31                	ja     802349 <spawn+0x369>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802318:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80231e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802322:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802328:	89 74 24 04          	mov    %esi,0x4(%esp)
  80232c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802332:	89 04 24             	mov    %eax,(%esp)
  802335:	e8 af ee ff ff       	call   8011e9 <sys_page_alloc>
  80233a:	85 c0                	test   %eax,%eax
  80233c:	0f 89 ed 00 00 00    	jns    80242f <spawn+0x44f>
  802342:	89 c3                	mov    %eax,%ebx
  802344:	e9 c8 01 00 00       	jmp    802511 <spawn+0x531>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802349:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802350:	00 
  802351:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802358:	00 
  802359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802360:	e8 84 ee ff ff       	call   8011e9 <sys_page_alloc>
  802365:	85 c0                	test   %eax,%eax
  802367:	0f 88 9a 01 00 00    	js     802507 <spawn+0x527>
  80236d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802373:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802375:	89 44 24 04          	mov    %eax,0x4(%esp)
  802379:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80237f:	89 04 24             	mov    %eax,(%esp)
  802382:	e8 d9 f8 ff ff       	call   801c60 <seek>
  802387:	85 c0                	test   %eax,%eax
  802389:	0f 88 7c 01 00 00    	js     80250b <spawn+0x52b>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80238f:	89 fa                	mov    %edi,%edx
  802391:	29 f2                	sub    %esi,%edx
  802393:	89 d0                	mov    %edx,%eax
  802395:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  80239b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023a0:	0f 47 c1             	cmova  %ecx,%eax
  8023a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023a7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023ae:	00 
  8023af:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8023b5:	89 04 24             	mov    %eax,(%esp)
  8023b8:	e8 bb f7 ff ff       	call   801b78 <readn>
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	0f 88 4a 01 00 00    	js     80250f <spawn+0x52f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8023c5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8023cf:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8023d5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8023d9:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8023df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023ea:	00 
  8023eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f2:	e8 46 ee ff ff       	call   80123d <sys_page_map>
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	79 20                	jns    80241b <spawn+0x43b>
				panic("spawn: sys_page_map data: %e", r);
  8023fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ff:	c7 44 24 08 6f 35 80 	movl   $0x80356f,0x8(%esp)
  802406:	00 
  802407:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  80240e:	00 
  80240f:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  802416:	e8 cc e1 ff ff       	call   8005e7 <_panic>
			sys_page_unmap(0, UTEMP);
  80241b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802422:	00 
  802423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242a:	e8 61 ee ff ff       	call   801290 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80242f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802435:	89 de                	mov    %ebx,%esi
  802437:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  80243d:	0f 82 d1 fe ff ff    	jb     802314 <spawn+0x334>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802443:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80244a:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802451:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802458:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  80245e:	0f 8f 2e fe ff ff    	jg     802292 <spawn+0x2b2>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802464:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80246a:	89 04 24             	mov    %eax,(%esp)
  80246d:	e8 11 f5 ff ff       	call   801983 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802472:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802482:	89 04 24             	mov    %eax,(%esp)
  802485:	e8 ac ee ff ff       	call   801336 <sys_env_set_trapframe>
  80248a:	85 c0                	test   %eax,%eax
  80248c:	79 20                	jns    8024ae <spawn+0x4ce>
		panic("sys_env_set_trapframe: %e", r);
  80248e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802492:	c7 44 24 08 8c 35 80 	movl   $0x80358c,0x8(%esp)
  802499:	00 
  80249a:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8024a1:	00 
  8024a2:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  8024a9:	e8 39 e1 ff ff       	call   8005e7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8024ae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8024b5:	00 
  8024b6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024bc:	89 04 24             	mov    %eax,(%esp)
  8024bf:	e8 1f ee ff ff       	call   8012e3 <sys_env_set_status>
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	79 30                	jns    8024f8 <spawn+0x518>
		panic("sys_env_set_status: %e", r);
  8024c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024cc:	c7 44 24 08 a6 35 80 	movl   $0x8035a6,0x8(%esp)
  8024d3:	00 
  8024d4:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8024db:	00 
  8024dc:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  8024e3:	e8 ff e0 ff ff       	call   8005e7 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8024e8:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8024ee:	eb 57                	jmp    802547 <spawn+0x567>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8024f0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024f6:	eb 4f                	jmp    802547 <spawn+0x567>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8024f8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024fe:	eb 47                	jmp    802547 <spawn+0x567>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802500:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802505:	eb 40                	jmp    802547 <spawn+0x567>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802507:	89 c3                	mov    %eax,%ebx
  802509:	eb 06                	jmp    802511 <spawn+0x531>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80250b:	89 c3                	mov    %eax,%ebx
  80250d:	eb 02                	jmp    802511 <spawn+0x531>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80250f:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802511:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802517:	89 04 24             	mov    %eax,(%esp)
  80251a:	e8 3a ec ff ff       	call   801159 <sys_env_destroy>
	close(fd);
  80251f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802525:	89 04 24             	mov    %eax,(%esp)
  802528:	e8 56 f4 ff ff       	call   801983 <close>
	return r;
  80252d:	89 d8                	mov    %ebx,%eax
  80252f:	eb 16                	jmp    802547 <spawn+0x567>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802531:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802538:	00 
  802539:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802540:	e8 4b ed ff ff       	call   801290 <sys_page_unmap>
  802545:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802547:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	57                   	push   %edi
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80255b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80255f:	74 61                	je     8025c2 <spawnl+0x70>
  802561:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802564:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802569:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80256c:	83 c0 04             	add    $0x4,%eax
  80256f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802573:	74 04                	je     802579 <spawnl+0x27>
		argc++;
  802575:	89 ca                	mov    %ecx,%edx
  802577:	eb f0                	jmp    802569 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802579:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  802580:	83 e0 f0             	and    $0xfffffff0,%eax
  802583:	29 c4                	sub    %eax,%esp
  802585:	8d 74 24 0b          	lea    0xb(%esp),%esi
  802589:	c1 ee 02             	shr    $0x2,%esi
  80258c:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  802593:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802595:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802598:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  80259f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  8025a6:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025a7:	89 ce                	mov    %ecx,%esi
  8025a9:	85 c9                	test   %ecx,%ecx
  8025ab:	74 25                	je     8025d2 <spawnl+0x80>
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  8025b2:	83 c0 01             	add    $0x1,%eax
  8025b5:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  8025b9:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025bc:	39 f0                	cmp    %esi,%eax
  8025be:	75 f2                	jne    8025b2 <spawnl+0x60>
  8025c0:	eb 10                	jmp    8025d2 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  8025c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  8025c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8025cf:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8025d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 ff f9 ff ff       	call   801fe0 <spawn>
}
  8025e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025e4:	5b                   	pop    %ebx
  8025e5:	5e                   	pop    %esi
  8025e6:	5f                   	pop    %edi
  8025e7:	5d                   	pop    %ebp
  8025e8:	c3                   	ret    
  8025e9:	66 90                	xchg   %ax,%ax
  8025eb:	66 90                	xchg   %ax,%ax
  8025ed:	66 90                	xchg   %ax,%ax
  8025ef:	90                   	nop

008025f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	56                   	push   %esi
  8025f4:	53                   	push   %ebx
  8025f5:	83 ec 10             	sub    $0x10,%esp
  8025f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	89 04 24             	mov    %eax,(%esp)
  802601:	e8 aa f1 ff ff       	call   8017b0 <fd2data>
  802606:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802608:	c7 44 24 04 e6 35 80 	movl   $0x8035e6,0x4(%esp)
  80260f:	00 
  802610:	89 1c 24             	mov    %ebx,(%esp)
  802613:	e8 23 e7 ff ff       	call   800d3b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802618:	8b 46 04             	mov    0x4(%esi),%eax
  80261b:	2b 06                	sub    (%esi),%eax
  80261d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802623:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80262a:	00 00 00 
	stat->st_dev = &devpipe;
  80262d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802634:	40 80 00 
	return 0;
}
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	5b                   	pop    %ebx
  802640:	5e                   	pop    %esi
  802641:	5d                   	pop    %ebp
  802642:	c3                   	ret    

00802643 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	53                   	push   %ebx
  802647:	83 ec 14             	sub    $0x14,%esp
  80264a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80264d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802651:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802658:	e8 33 ec ff ff       	call   801290 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80265d:	89 1c 24             	mov    %ebx,(%esp)
  802660:	e8 4b f1 ff ff       	call   8017b0 <fd2data>
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802670:	e8 1b ec ff ff       	call   801290 <sys_page_unmap>
}
  802675:	83 c4 14             	add    $0x14,%esp
  802678:	5b                   	pop    %ebx
  802679:	5d                   	pop    %ebp
  80267a:	c3                   	ret    

0080267b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	57                   	push   %edi
  80267f:	56                   	push   %esi
  802680:	53                   	push   %ebx
  802681:	83 ec 2c             	sub    $0x2c,%esp
  802684:	89 c6                	mov    %eax,%esi
  802686:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802689:	a1 04 50 80 00       	mov    0x805004,%eax
  80268e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802691:	89 34 24             	mov    %esi,(%esp)
  802694:	e8 44 05 00 00       	call   802bdd <pageref>
  802699:	89 c7                	mov    %eax,%edi
  80269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269e:	89 04 24             	mov    %eax,(%esp)
  8026a1:	e8 37 05 00 00       	call   802bdd <pageref>
  8026a6:	39 c7                	cmp    %eax,%edi
  8026a8:	0f 94 c2             	sete   %dl
  8026ab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8026ae:	8b 0d 04 50 80 00    	mov    0x805004,%ecx
  8026b4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8026b7:	39 fb                	cmp    %edi,%ebx
  8026b9:	74 21                	je     8026dc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8026bb:	84 d2                	test   %dl,%dl
  8026bd:	74 ca                	je     802689 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026bf:	8b 51 58             	mov    0x58(%ecx),%edx
  8026c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026ce:	c7 04 24 ed 35 80 00 	movl   $0x8035ed,(%esp)
  8026d5:	e8 06 e0 ff ff       	call   8006e0 <cprintf>
  8026da:	eb ad                	jmp    802689 <_pipeisclosed+0xe>
	}
}
  8026dc:	83 c4 2c             	add    $0x2c,%esp
  8026df:	5b                   	pop    %ebx
  8026e0:	5e                   	pop    %esi
  8026e1:	5f                   	pop    %edi
  8026e2:	5d                   	pop    %ebp
  8026e3:	c3                   	ret    

008026e4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	57                   	push   %edi
  8026e8:	56                   	push   %esi
  8026e9:	53                   	push   %ebx
  8026ea:	83 ec 1c             	sub    $0x1c,%esp
  8026ed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8026f0:	89 34 24             	mov    %esi,(%esp)
  8026f3:	e8 b8 f0 ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026fc:	74 61                	je     80275f <devpipe_write+0x7b>
  8026fe:	89 c3                	mov    %eax,%ebx
  802700:	bf 00 00 00 00       	mov    $0x0,%edi
  802705:	eb 4a                	jmp    802751 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802707:	89 da                	mov    %ebx,%edx
  802709:	89 f0                	mov    %esi,%eax
  80270b:	e8 6b ff ff ff       	call   80267b <_pipeisclosed>
  802710:	85 c0                	test   %eax,%eax
  802712:	75 54                	jne    802768 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802714:	e8 b1 ea ff ff       	call   8011ca <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802719:	8b 43 04             	mov    0x4(%ebx),%eax
  80271c:	8b 0b                	mov    (%ebx),%ecx
  80271e:	8d 51 20             	lea    0x20(%ecx),%edx
  802721:	39 d0                	cmp    %edx,%eax
  802723:	73 e2                	jae    802707 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802728:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80272c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80272f:	99                   	cltd   
  802730:	c1 ea 1b             	shr    $0x1b,%edx
  802733:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802736:	83 e1 1f             	and    $0x1f,%ecx
  802739:	29 d1                	sub    %edx,%ecx
  80273b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80273f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802743:	83 c0 01             	add    $0x1,%eax
  802746:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802749:	83 c7 01             	add    $0x1,%edi
  80274c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80274f:	74 13                	je     802764 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802751:	8b 43 04             	mov    0x4(%ebx),%eax
  802754:	8b 0b                	mov    (%ebx),%ecx
  802756:	8d 51 20             	lea    0x20(%ecx),%edx
  802759:	39 d0                	cmp    %edx,%eax
  80275b:	73 aa                	jae    802707 <devpipe_write+0x23>
  80275d:	eb c6                	jmp    802725 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80275f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802764:	89 f8                	mov    %edi,%eax
  802766:	eb 05                	jmp    80276d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    

00802775 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	57                   	push   %edi
  802779:	56                   	push   %esi
  80277a:	53                   	push   %ebx
  80277b:	83 ec 1c             	sub    $0x1c,%esp
  80277e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802781:	89 3c 24             	mov    %edi,(%esp)
  802784:	e8 27 f0 ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802789:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80278d:	74 54                	je     8027e3 <devpipe_read+0x6e>
  80278f:	89 c3                	mov    %eax,%ebx
  802791:	be 00 00 00 00       	mov    $0x0,%esi
  802796:	eb 3e                	jmp    8027d6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802798:	89 f0                	mov    %esi,%eax
  80279a:	eb 55                	jmp    8027f1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80279c:	89 da                	mov    %ebx,%edx
  80279e:	89 f8                	mov    %edi,%eax
  8027a0:	e8 d6 fe ff ff       	call   80267b <_pipeisclosed>
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	75 43                	jne    8027ec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027a9:	e8 1c ea ff ff       	call   8011ca <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027ae:	8b 03                	mov    (%ebx),%eax
  8027b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027b3:	74 e7                	je     80279c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027b5:	99                   	cltd   
  8027b6:	c1 ea 1b             	shr    $0x1b,%edx
  8027b9:	01 d0                	add    %edx,%eax
  8027bb:	83 e0 1f             	and    $0x1f,%eax
  8027be:	29 d0                	sub    %edx,%eax
  8027c0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027cb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ce:	83 c6 01             	add    $0x1,%esi
  8027d1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027d4:	74 12                	je     8027e8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8027d6:	8b 03                	mov    (%ebx),%eax
  8027d8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027db:	75 d8                	jne    8027b5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8027dd:	85 f6                	test   %esi,%esi
  8027df:	75 b7                	jne    802798 <devpipe_read+0x23>
  8027e1:	eb b9                	jmp    80279c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027e3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8027e8:	89 f0                	mov    %esi,%eax
  8027ea:	eb 05                	jmp    8027f1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8027f1:	83 c4 1c             	add    $0x1c,%esp
  8027f4:	5b                   	pop    %ebx
  8027f5:	5e                   	pop    %esi
  8027f6:	5f                   	pop    %edi
  8027f7:	5d                   	pop    %ebp
  8027f8:	c3                   	ret    

008027f9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	56                   	push   %esi
  8027fd:	53                   	push   %ebx
  8027fe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802804:	89 04 24             	mov    %eax,(%esp)
  802807:	e8 bb ef ff ff       	call   8017c7 <fd_alloc>
  80280c:	89 c2                	mov    %eax,%edx
  80280e:	85 d2                	test   %edx,%edx
  802810:	0f 88 4d 01 00 00    	js     802963 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802816:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80281d:	00 
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	89 44 24 04          	mov    %eax,0x4(%esp)
  802825:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80282c:	e8 b8 e9 ff ff       	call   8011e9 <sys_page_alloc>
  802831:	89 c2                	mov    %eax,%edx
  802833:	85 d2                	test   %edx,%edx
  802835:	0f 88 28 01 00 00    	js     802963 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80283b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80283e:	89 04 24             	mov    %eax,(%esp)
  802841:	e8 81 ef ff ff       	call   8017c7 <fd_alloc>
  802846:	89 c3                	mov    %eax,%ebx
  802848:	85 c0                	test   %eax,%eax
  80284a:	0f 88 fe 00 00 00    	js     80294e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802850:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802857:	00 
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802866:	e8 7e e9 ff ff       	call   8011e9 <sys_page_alloc>
  80286b:	89 c3                	mov    %eax,%ebx
  80286d:	85 c0                	test   %eax,%eax
  80286f:	0f 88 d9 00 00 00    	js     80294e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	89 04 24             	mov    %eax,(%esp)
  80287b:	e8 30 ef ff ff       	call   8017b0 <fd2data>
  802880:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802882:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802889:	00 
  80288a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802895:	e8 4f e9 ff ff       	call   8011e9 <sys_page_alloc>
  80289a:	89 c3                	mov    %eax,%ebx
  80289c:	85 c0                	test   %eax,%eax
  80289e:	0f 88 97 00 00 00    	js     80293b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	89 04 24             	mov    %eax,(%esp)
  8028aa:	e8 01 ef ff ff       	call   8017b0 <fd2data>
  8028af:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8028b6:	00 
  8028b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028c2:	00 
  8028c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ce:	e8 6a e9 ff ff       	call   80123d <sys_page_map>
  8028d3:	89 c3                	mov    %eax,%ebx
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	78 52                	js     80292b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028d9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8028ee:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	89 04 24             	mov    %eax,(%esp)
  802909:	e8 92 ee ff ff       	call   8017a0 <fd2num>
  80290e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802911:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	89 04 24             	mov    %eax,(%esp)
  802919:	e8 82 ee ff ff       	call   8017a0 <fd2num>
  80291e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802921:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
  802929:	eb 38                	jmp    802963 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80292b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80292f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802936:	e8 55 e9 ff ff       	call   801290 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802949:	e8 42 e9 ff ff       	call   801290 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	89 44 24 04          	mov    %eax,0x4(%esp)
  802955:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80295c:	e8 2f e9 ff ff       	call   801290 <sys_page_unmap>
  802961:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802963:	83 c4 30             	add    $0x30,%esp
  802966:	5b                   	pop    %ebx
  802967:	5e                   	pop    %esi
  802968:	5d                   	pop    %ebp
  802969:	c3                   	ret    

0080296a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802973:	89 44 24 04          	mov    %eax,0x4(%esp)
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	89 04 24             	mov    %eax,(%esp)
  80297d:	e8 b9 ee ff ff       	call   80183b <fd_lookup>
  802982:	89 c2                	mov    %eax,%edx
  802984:	85 d2                	test   %edx,%edx
  802986:	78 15                	js     80299d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	89 04 24             	mov    %eax,(%esp)
  80298e:	e8 1d ee ff ff       	call   8017b0 <fd2data>
	return _pipeisclosed(fd, p);
  802993:	89 c2                	mov    %eax,%edx
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	e8 de fc ff ff       	call   80267b <_pipeisclosed>
}
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 10             	sub    $0x10,%esp
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	75 24                	jne    8029d2 <wait+0x33>
  8029ae:	c7 44 24 0c 05 36 80 	movl   $0x803605,0xc(%esp)
  8029b5:	00 
  8029b6:	c7 44 24 08 1d 35 80 	movl   $0x80351d,0x8(%esp)
  8029bd:	00 
  8029be:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8029c5:	00 
  8029c6:	c7 04 24 10 36 80 00 	movl   $0x803610,(%esp)
  8029cd:	e8 15 dc ff ff       	call   8005e7 <_panic>
	e = &envs[ENVX(envid)];
  8029d2:	89 c3                	mov    %eax,%ebx
  8029d4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8029da:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8029dd:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029e3:	8b 73 48             	mov    0x48(%ebx),%esi
  8029e6:	39 c6                	cmp    %eax,%esi
  8029e8:	75 1a                	jne    802a04 <wait+0x65>
  8029ea:	8b 43 54             	mov    0x54(%ebx),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 13                	je     802a04 <wait+0x65>
		sys_yield();
  8029f1:	e8 d4 e7 ff ff       	call   8011ca <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029f6:	8b 43 48             	mov    0x48(%ebx),%eax
  8029f9:	39 f0                	cmp    %esi,%eax
  8029fb:	75 07                	jne    802a04 <wait+0x65>
  8029fd:	8b 43 54             	mov    0x54(%ebx),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	75 ed                	jne    8029f1 <wait+0x52>
		sys_yield();
}
  802a04:	83 c4 10             	add    $0x10,%esp
  802a07:	5b                   	pop    %ebx
  802a08:	5e                   	pop    %esi
  802a09:	5d                   	pop    %ebp
  802a0a:	c3                   	ret    

00802a0b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  802a11:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802a18:	75 50                	jne    802a6a <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  802a1a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a21:	00 
  802a22:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a29:	ee 
  802a2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a31:	e8 b3 e7 ff ff       	call   8011e9 <sys_page_alloc>
  802a36:	85 c0                	test   %eax,%eax
  802a38:	79 1c                	jns    802a56 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  802a3a:	c7 44 24 08 1c 36 80 	movl   $0x80361c,0x8(%esp)
  802a41:	00 
  802a42:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802a49:	00 
  802a4a:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  802a51:	e8 91 db ff ff       	call   8005e7 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802a56:	c7 44 24 04 74 2a 80 	movl   $0x802a74,0x4(%esp)
  802a5d:	00 
  802a5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a65:	e8 1f e9 ff ff       	call   801389 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a74:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a75:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802a7a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a7c:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  802a7f:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  802a81:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  802a86:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  802a89:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  802a8e:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  802a91:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  802a93:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  802a96:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  802a98:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  802a9a:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  802a9f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  802aa2:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  802aa7:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  802aaa:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  802aac:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  802ab1:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  802ab4:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  802ab9:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  802abc:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  802abe:	83 c4 08             	add    $0x8,%esp
	popal
  802ac1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802ac2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ac3:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ac4:	c3                   	ret    

00802ac5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	56                   	push   %esi
  802ac9:	53                   	push   %ebx
  802aca:	83 ec 10             	sub    $0x10,%esp
  802acd:	8b 75 08             	mov    0x8(%ebp),%esi
  802ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  802ad6:	83 f8 01             	cmp    $0x1,%eax
  802ad9:	19 c0                	sbb    %eax,%eax
  802adb:	f7 d0                	not    %eax
  802add:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  802ae2:	89 04 24             	mov    %eax,(%esp)
  802ae5:	e8 15 e9 ff ff       	call   8013ff <sys_ipc_recv>
	if (err_code < 0) {
  802aea:	85 c0                	test   %eax,%eax
  802aec:	79 16                	jns    802b04 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  802aee:	85 f6                	test   %esi,%esi
  802af0:	74 06                	je     802af8 <ipc_recv+0x33>
  802af2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802af8:	85 db                	test   %ebx,%ebx
  802afa:	74 2c                	je     802b28 <ipc_recv+0x63>
  802afc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802b02:	eb 24                	jmp    802b28 <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802b04:	85 f6                	test   %esi,%esi
  802b06:	74 0a                	je     802b12 <ipc_recv+0x4d>
  802b08:	a1 04 50 80 00       	mov    0x805004,%eax
  802b0d:	8b 40 74             	mov    0x74(%eax),%eax
  802b10:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802b12:	85 db                	test   %ebx,%ebx
  802b14:	74 0a                	je     802b20 <ipc_recv+0x5b>
  802b16:	a1 04 50 80 00       	mov    0x805004,%eax
  802b1b:	8b 40 78             	mov    0x78(%eax),%eax
  802b1e:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802b20:	a1 04 50 80 00       	mov    0x805004,%eax
  802b25:	8b 40 70             	mov    0x70(%eax),%eax
}
  802b28:	83 c4 10             	add    $0x10,%esp
  802b2b:	5b                   	pop    %ebx
  802b2c:	5e                   	pop    %esi
  802b2d:	5d                   	pop    %ebp
  802b2e:	c3                   	ret    

00802b2f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	57                   	push   %edi
  802b33:	56                   	push   %esi
  802b34:	53                   	push   %ebx
  802b35:	83 ec 1c             	sub    $0x1c,%esp
  802b38:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802b41:	eb 25                	jmp    802b68 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802b43:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b46:	74 20                	je     802b68 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802b48:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b4c:	c7 44 24 08 4e 36 80 	movl   $0x80364e,0x8(%esp)
  802b53:	00 
  802b54:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  802b5b:	00 
  802b5c:	c7 04 24 5a 36 80 00 	movl   $0x80365a,(%esp)
  802b63:	e8 7f da ff ff       	call   8005e7 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802b68:	85 db                	test   %ebx,%ebx
  802b6a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802b6f:	0f 45 c3             	cmovne %ebx,%eax
  802b72:	8b 55 14             	mov    0x14(%ebp),%edx
  802b75:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802b79:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b81:	89 3c 24             	mov    %edi,(%esp)
  802b84:	e8 53 e8 ff ff       	call   8013dc <sys_ipc_try_send>
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	75 b6                	jne    802b43 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  802b8d:	83 c4 1c             	add    $0x1c,%esp
  802b90:	5b                   	pop    %ebx
  802b91:	5e                   	pop    %esi
  802b92:	5f                   	pop    %edi
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    

00802b95 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802b9b:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802ba0:	39 c8                	cmp    %ecx,%eax
  802ba2:	74 17                	je     802bbb <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ba4:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802ba9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802bb2:	8b 52 50             	mov    0x50(%edx),%edx
  802bb5:	39 ca                	cmp    %ecx,%edx
  802bb7:	75 14                	jne    802bcd <ipc_find_env+0x38>
  802bb9:	eb 05                	jmp    802bc0 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802bc0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802bc3:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802bc8:	8b 40 40             	mov    0x40(%eax),%eax
  802bcb:	eb 0e                	jmp    802bdb <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802bcd:	83 c0 01             	add    $0x1,%eax
  802bd0:	3d 00 04 00 00       	cmp    $0x400,%eax
  802bd5:	75 d2                	jne    802ba9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802bd7:	66 b8 00 00          	mov    $0x0,%ax
}
  802bdb:	5d                   	pop    %ebp
  802bdc:	c3                   	ret    

00802bdd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bdd:	55                   	push   %ebp
  802bde:	89 e5                	mov    %esp,%ebp
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802be3:	89 d0                	mov    %edx,%eax
  802be5:	c1 e8 16             	shr    $0x16,%eax
  802be8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bf4:	f6 c1 01             	test   $0x1,%cl
  802bf7:	74 1d                	je     802c16 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802bf9:	c1 ea 0c             	shr    $0xc,%edx
  802bfc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c03:	f6 c2 01             	test   $0x1,%dl
  802c06:	74 0e                	je     802c16 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c08:	c1 ea 0c             	shr    $0xc,%edx
  802c0b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c12:	ef 
  802c13:	0f b7 c0             	movzwl %ax,%eax
}
  802c16:	5d                   	pop    %ebp
  802c17:	c3                   	ret    
  802c18:	66 90                	xchg   %ax,%ax
  802c1a:	66 90                	xchg   %ax,%ax
  802c1c:	66 90                	xchg   %ax,%ax
  802c1e:	66 90                	xchg   %ax,%ax

00802c20 <__udivdi3>:
  802c20:	55                   	push   %ebp
  802c21:	57                   	push   %edi
  802c22:	56                   	push   %esi
  802c23:	83 ec 0c             	sub    $0xc,%esp
  802c26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c2a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802c2e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802c32:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c36:	85 c0                	test   %eax,%eax
  802c38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c3c:	89 ea                	mov    %ebp,%edx
  802c3e:	89 0c 24             	mov    %ecx,(%esp)
  802c41:	75 2d                	jne    802c70 <__udivdi3+0x50>
  802c43:	39 e9                	cmp    %ebp,%ecx
  802c45:	77 61                	ja     802ca8 <__udivdi3+0x88>
  802c47:	85 c9                	test   %ecx,%ecx
  802c49:	89 ce                	mov    %ecx,%esi
  802c4b:	75 0b                	jne    802c58 <__udivdi3+0x38>
  802c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c52:	31 d2                	xor    %edx,%edx
  802c54:	f7 f1                	div    %ecx
  802c56:	89 c6                	mov    %eax,%esi
  802c58:	31 d2                	xor    %edx,%edx
  802c5a:	89 e8                	mov    %ebp,%eax
  802c5c:	f7 f6                	div    %esi
  802c5e:	89 c5                	mov    %eax,%ebp
  802c60:	89 f8                	mov    %edi,%eax
  802c62:	f7 f6                	div    %esi
  802c64:	89 ea                	mov    %ebp,%edx
  802c66:	83 c4 0c             	add    $0xc,%esp
  802c69:	5e                   	pop    %esi
  802c6a:	5f                   	pop    %edi
  802c6b:	5d                   	pop    %ebp
  802c6c:	c3                   	ret    
  802c6d:	8d 76 00             	lea    0x0(%esi),%esi
  802c70:	39 e8                	cmp    %ebp,%eax
  802c72:	77 24                	ja     802c98 <__udivdi3+0x78>
  802c74:	0f bd e8             	bsr    %eax,%ebp
  802c77:	83 f5 1f             	xor    $0x1f,%ebp
  802c7a:	75 3c                	jne    802cb8 <__udivdi3+0x98>
  802c7c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c80:	39 34 24             	cmp    %esi,(%esp)
  802c83:	0f 86 9f 00 00 00    	jbe    802d28 <__udivdi3+0x108>
  802c89:	39 d0                	cmp    %edx,%eax
  802c8b:	0f 82 97 00 00 00    	jb     802d28 <__udivdi3+0x108>
  802c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c98:	31 d2                	xor    %edx,%edx
  802c9a:	31 c0                	xor    %eax,%eax
  802c9c:	83 c4 0c             	add    $0xc,%esp
  802c9f:	5e                   	pop    %esi
  802ca0:	5f                   	pop    %edi
  802ca1:	5d                   	pop    %ebp
  802ca2:	c3                   	ret    
  802ca3:	90                   	nop
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	89 f8                	mov    %edi,%eax
  802caa:	f7 f1                	div    %ecx
  802cac:	31 d2                	xor    %edx,%edx
  802cae:	83 c4 0c             	add    $0xc,%esp
  802cb1:	5e                   	pop    %esi
  802cb2:	5f                   	pop    %edi
  802cb3:	5d                   	pop    %ebp
  802cb4:	c3                   	ret    
  802cb5:	8d 76 00             	lea    0x0(%esi),%esi
  802cb8:	89 e9                	mov    %ebp,%ecx
  802cba:	8b 3c 24             	mov    (%esp),%edi
  802cbd:	d3 e0                	shl    %cl,%eax
  802cbf:	89 c6                	mov    %eax,%esi
  802cc1:	b8 20 00 00 00       	mov    $0x20,%eax
  802cc6:	29 e8                	sub    %ebp,%eax
  802cc8:	89 c1                	mov    %eax,%ecx
  802cca:	d3 ef                	shr    %cl,%edi
  802ccc:	89 e9                	mov    %ebp,%ecx
  802cce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cd2:	8b 3c 24             	mov    (%esp),%edi
  802cd5:	09 74 24 08          	or     %esi,0x8(%esp)
  802cd9:	89 d6                	mov    %edx,%esi
  802cdb:	d3 e7                	shl    %cl,%edi
  802cdd:	89 c1                	mov    %eax,%ecx
  802cdf:	89 3c 24             	mov    %edi,(%esp)
  802ce2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ce6:	d3 ee                	shr    %cl,%esi
  802ce8:	89 e9                	mov    %ebp,%ecx
  802cea:	d3 e2                	shl    %cl,%edx
  802cec:	89 c1                	mov    %eax,%ecx
  802cee:	d3 ef                	shr    %cl,%edi
  802cf0:	09 d7                	or     %edx,%edi
  802cf2:	89 f2                	mov    %esi,%edx
  802cf4:	89 f8                	mov    %edi,%eax
  802cf6:	f7 74 24 08          	divl   0x8(%esp)
  802cfa:	89 d6                	mov    %edx,%esi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	f7 24 24             	mull   (%esp)
  802d01:	39 d6                	cmp    %edx,%esi
  802d03:	89 14 24             	mov    %edx,(%esp)
  802d06:	72 30                	jb     802d38 <__udivdi3+0x118>
  802d08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d0c:	89 e9                	mov    %ebp,%ecx
  802d0e:	d3 e2                	shl    %cl,%edx
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	73 05                	jae    802d19 <__udivdi3+0xf9>
  802d14:	3b 34 24             	cmp    (%esp),%esi
  802d17:	74 1f                	je     802d38 <__udivdi3+0x118>
  802d19:	89 f8                	mov    %edi,%eax
  802d1b:	31 d2                	xor    %edx,%edx
  802d1d:	e9 7a ff ff ff       	jmp    802c9c <__udivdi3+0x7c>
  802d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d28:	31 d2                	xor    %edx,%edx
  802d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d2f:	e9 68 ff ff ff       	jmp    802c9c <__udivdi3+0x7c>
  802d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	83 c4 0c             	add    $0xc,%esp
  802d40:	5e                   	pop    %esi
  802d41:	5f                   	pop    %edi
  802d42:	5d                   	pop    %ebp
  802d43:	c3                   	ret    
  802d44:	66 90                	xchg   %ax,%ax
  802d46:	66 90                	xchg   %ax,%ax
  802d48:	66 90                	xchg   %ax,%ax
  802d4a:	66 90                	xchg   %ax,%ax
  802d4c:	66 90                	xchg   %ax,%ax
  802d4e:	66 90                	xchg   %ax,%ax

00802d50 <__umoddi3>:
  802d50:	55                   	push   %ebp
  802d51:	57                   	push   %edi
  802d52:	56                   	push   %esi
  802d53:	83 ec 14             	sub    $0x14,%esp
  802d56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802d6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d70:	89 34 24             	mov    %esi,(%esp)
  802d73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d77:	85 c0                	test   %eax,%eax
  802d79:	89 c2                	mov    %eax,%edx
  802d7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d7f:	75 17                	jne    802d98 <__umoddi3+0x48>
  802d81:	39 fe                	cmp    %edi,%esi
  802d83:	76 4b                	jbe    802dd0 <__umoddi3+0x80>
  802d85:	89 c8                	mov    %ecx,%eax
  802d87:	89 fa                	mov    %edi,%edx
  802d89:	f7 f6                	div    %esi
  802d8b:	89 d0                	mov    %edx,%eax
  802d8d:	31 d2                	xor    %edx,%edx
  802d8f:	83 c4 14             	add    $0x14,%esp
  802d92:	5e                   	pop    %esi
  802d93:	5f                   	pop    %edi
  802d94:	5d                   	pop    %ebp
  802d95:	c3                   	ret    
  802d96:	66 90                	xchg   %ax,%ax
  802d98:	39 f8                	cmp    %edi,%eax
  802d9a:	77 54                	ja     802df0 <__umoddi3+0xa0>
  802d9c:	0f bd e8             	bsr    %eax,%ebp
  802d9f:	83 f5 1f             	xor    $0x1f,%ebp
  802da2:	75 5c                	jne    802e00 <__umoddi3+0xb0>
  802da4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802da8:	39 3c 24             	cmp    %edi,(%esp)
  802dab:	0f 87 e7 00 00 00    	ja     802e98 <__umoddi3+0x148>
  802db1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802db5:	29 f1                	sub    %esi,%ecx
  802db7:	19 c7                	sbb    %eax,%edi
  802db9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dc1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dc5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802dc9:	83 c4 14             	add    $0x14,%esp
  802dcc:	5e                   	pop    %esi
  802dcd:	5f                   	pop    %edi
  802dce:	5d                   	pop    %ebp
  802dcf:	c3                   	ret    
  802dd0:	85 f6                	test   %esi,%esi
  802dd2:	89 f5                	mov    %esi,%ebp
  802dd4:	75 0b                	jne    802de1 <__umoddi3+0x91>
  802dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ddb:	31 d2                	xor    %edx,%edx
  802ddd:	f7 f6                	div    %esi
  802ddf:	89 c5                	mov    %eax,%ebp
  802de1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802de5:	31 d2                	xor    %edx,%edx
  802de7:	f7 f5                	div    %ebp
  802de9:	89 c8                	mov    %ecx,%eax
  802deb:	f7 f5                	div    %ebp
  802ded:	eb 9c                	jmp    802d8b <__umoddi3+0x3b>
  802def:	90                   	nop
  802df0:	89 c8                	mov    %ecx,%eax
  802df2:	89 fa                	mov    %edi,%edx
  802df4:	83 c4 14             	add    $0x14,%esp
  802df7:	5e                   	pop    %esi
  802df8:	5f                   	pop    %edi
  802df9:	5d                   	pop    %ebp
  802dfa:	c3                   	ret    
  802dfb:	90                   	nop
  802dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e00:	8b 04 24             	mov    (%esp),%eax
  802e03:	be 20 00 00 00       	mov    $0x20,%esi
  802e08:	89 e9                	mov    %ebp,%ecx
  802e0a:	29 ee                	sub    %ebp,%esi
  802e0c:	d3 e2                	shl    %cl,%edx
  802e0e:	89 f1                	mov    %esi,%ecx
  802e10:	d3 e8                	shr    %cl,%eax
  802e12:	89 e9                	mov    %ebp,%ecx
  802e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e18:	8b 04 24             	mov    (%esp),%eax
  802e1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802e1f:	89 fa                	mov    %edi,%edx
  802e21:	d3 e0                	shl    %cl,%eax
  802e23:	89 f1                	mov    %esi,%ecx
  802e25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802e2d:	d3 ea                	shr    %cl,%edx
  802e2f:	89 e9                	mov    %ebp,%ecx
  802e31:	d3 e7                	shl    %cl,%edi
  802e33:	89 f1                	mov    %esi,%ecx
  802e35:	d3 e8                	shr    %cl,%eax
  802e37:	89 e9                	mov    %ebp,%ecx
  802e39:	09 f8                	or     %edi,%eax
  802e3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802e3f:	f7 74 24 04          	divl   0x4(%esp)
  802e43:	d3 e7                	shl    %cl,%edi
  802e45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e49:	89 d7                	mov    %edx,%edi
  802e4b:	f7 64 24 08          	mull   0x8(%esp)
  802e4f:	39 d7                	cmp    %edx,%edi
  802e51:	89 c1                	mov    %eax,%ecx
  802e53:	89 14 24             	mov    %edx,(%esp)
  802e56:	72 2c                	jb     802e84 <__umoddi3+0x134>
  802e58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802e5c:	72 22                	jb     802e80 <__umoddi3+0x130>
  802e5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802e62:	29 c8                	sub    %ecx,%eax
  802e64:	19 d7                	sbb    %edx,%edi
  802e66:	89 e9                	mov    %ebp,%ecx
  802e68:	89 fa                	mov    %edi,%edx
  802e6a:	d3 e8                	shr    %cl,%eax
  802e6c:	89 f1                	mov    %esi,%ecx
  802e6e:	d3 e2                	shl    %cl,%edx
  802e70:	89 e9                	mov    %ebp,%ecx
  802e72:	d3 ef                	shr    %cl,%edi
  802e74:	09 d0                	or     %edx,%eax
  802e76:	89 fa                	mov    %edi,%edx
  802e78:	83 c4 14             	add    $0x14,%esp
  802e7b:	5e                   	pop    %esi
  802e7c:	5f                   	pop    %edi
  802e7d:	5d                   	pop    %ebp
  802e7e:	c3                   	ret    
  802e7f:	90                   	nop
  802e80:	39 d7                	cmp    %edx,%edi
  802e82:	75 da                	jne    802e5e <__umoddi3+0x10e>
  802e84:	8b 14 24             	mov    (%esp),%edx
  802e87:	89 c1                	mov    %eax,%ecx
  802e89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e91:	eb cb                	jmp    802e5e <__umoddi3+0x10e>
  802e93:	90                   	nop
  802e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e9c:	0f 82 0f ff ff ff    	jb     802db1 <__umoddi3+0x61>
  802ea2:	e9 1a ff ff ff       	jmp    802dc1 <__umoddi3+0x71>
