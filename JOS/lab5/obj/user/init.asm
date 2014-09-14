
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 f5 03 00 00       	call   800426 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80004b:	85 db                	test   %ebx,%ebx
  80004d:	7e 1c                	jle    80006b <sum+0x2b>
char bss[6000];

int
sum(const char *s, int n)
{
	int i, tot = 0;
  80004f:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800054:	ba 00 00 00 00       	mov    $0x0,%edx
		tot ^= i * s[i];
  800059:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005d:	0f af ca             	imul   %edx,%ecx
  800060:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800062:	83 c2 01             	add    $0x1,%edx
  800065:	39 da                	cmp    %ebx,%edx
  800067:	75 f0                	jne    800059 <sum+0x19>
  800069:	eb 05                	jmp    800070 <sum+0x30>
char bss[6000];

int
sum(const char *s, int n)
{
	int i, tot = 0;
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
		tot ^= i * s[i];
	return tot;
}
  800070:	5b                   	pop    %ebx
  800071:	5e                   	pop    %esi
  800072:	5d                   	pop    %ebp
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	57                   	push   %edi
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800080:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  800083:	c7 04 24 00 2a 80 00 	movl   $0x802a00,(%esp)
  80008a:	e8 21 05 00 00       	call   8005b0 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  80008f:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80009e:	e8 9d ff ff ff       	call   800040 <sum>
  8000a3:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000a8:	74 1a                	je     8000c4 <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000aa:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000b1:	00 
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	c7 04 24 c8 2a 80 00 	movl   $0x802ac8,(%esp)
  8000bd:	e8 ee 04 00 00       	call   8005b0 <cprintf>
  8000c2:	eb 0c                	jmp    8000d0 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000c4:	c7 04 24 0f 2a 80 00 	movl   $0x802a0f,(%esp)
  8000cb:	e8 e0 04 00 00       	call   8005b0 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000d0:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000df:	e8 5c ff ff ff       	call   800040 <sum>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	74 12                	je     8000fa <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ec:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  8000f3:	e8 b8 04 00 00       	call   8005b0 <cprintf>
  8000f8:	eb 0c                	jmp    800106 <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000fa:	c7 04 24 26 2a 80 00 	movl   $0x802a26,(%esp)
  800101:	e8 aa 04 00 00       	call   8005b0 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  800106:	c7 44 24 04 3c 2a 80 	movl   $0x802a3c,0x4(%esp)
  80010d:	00 
  80010e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800114:	89 04 24             	mov    %eax,(%esp)
  800117:	e8 0f 0b 00 00       	call   800c2b <strcat>
	for (i = 0; i < argc; i++) {
  80011c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800120:	7e 42                	jle    800164 <umain+0xf0>
  800122:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800127:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80012d:	c7 44 24 04 48 2a 80 	movl   $0x802a48,0x4(%esp)
  800134:	00 
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 ee 0a 00 00       	call   800c2b <strcat>
		strcat(args, argv[i]);
  80013d:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800140:	89 44 24 04          	mov    %eax,0x4(%esp)
  800144:	89 34 24             	mov    %esi,(%esp)
  800147:	e8 df 0a 00 00       	call   800c2b <strcat>
		strcat(args, "'");
  80014c:	c7 44 24 04 49 2a 80 	movl   $0x802a49,0x4(%esp)
  800153:	00 
  800154:	89 34 24             	mov    %esi,(%esp)
  800157:	e8 cf 0a 00 00       	call   800c2b <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80015c:	83 c3 01             	add    $0x1,%ebx
  80015f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800162:	75 c9                	jne    80012d <umain+0xb9>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016e:	c7 04 24 4b 2a 80 00 	movl   $0x802a4b,(%esp)
  800175:	e8 36 04 00 00       	call   8005b0 <cprintf>

	cprintf("init: running sh\n");
  80017a:	c7 04 24 4f 2a 80 00 	movl   $0x802a4f,(%esp)
  800181:	e8 2a 04 00 00       	call   8005b0 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80018d:	e8 81 13 00 00       	call   801513 <close>
	if ((r = opencons()) < 0)
  800192:	e8 34 02 00 00       	call   8003cb <opencons>
  800197:	85 c0                	test   %eax,%eax
  800199:	79 20                	jns    8001bb <umain+0x147>
		panic("opencons: %e", r);
  80019b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80019f:	c7 44 24 08 61 2a 80 	movl   $0x802a61,0x8(%esp)
  8001a6:	00 
  8001a7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001ae:	00 
  8001af:	c7 04 24 6e 2a 80 00 	movl   $0x802a6e,(%esp)
  8001b6:	e8 fc 02 00 00       	call   8004b7 <_panic>
	if (r != 0)
  8001bb:	85 c0                	test   %eax,%eax
  8001bd:	74 20                	je     8001df <umain+0x16b>
		panic("first opencons used fd %d", r);
  8001bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c3:	c7 44 24 08 7a 2a 80 	movl   $0x802a7a,0x8(%esp)
  8001ca:	00 
  8001cb:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001d2:	00 
  8001d3:	c7 04 24 6e 2a 80 00 	movl   $0x802a6e,(%esp)
  8001da:	e8 d8 02 00 00       	call   8004b7 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001e6:	00 
  8001e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ee:	e8 75 13 00 00       	call   801568 <dup>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	79 20                	jns    800217 <umain+0x1a3>
		panic("dup: %e", r);
  8001f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fb:	c7 44 24 08 94 2a 80 	movl   $0x802a94,0x8(%esp)
  800202:	00 
  800203:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  80020a:	00 
  80020b:	c7 04 24 6e 2a 80 00 	movl   $0x802a6e,(%esp)
  800212:	e8 a0 02 00 00       	call   8004b7 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  800217:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  80021e:	e8 8d 03 00 00       	call   8005b0 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800223:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80022a:	00 
  80022b:	c7 44 24 04 b0 2a 80 	movl   $0x802ab0,0x4(%esp)
  800232:	00 
  800233:	c7 04 24 af 2a 80 00 	movl   $0x802aaf,(%esp)
  80023a:	e8 0f 1f 00 00       	call   80214e <spawnl>
		if (r < 0) {
  80023f:	85 c0                	test   %eax,%eax
  800241:	79 12                	jns    800255 <umain+0x1e1>
			cprintf("init: spawn sh: %e\n", r);
  800243:	89 44 24 04          	mov    %eax,0x4(%esp)
  800247:	c7 04 24 b3 2a 80 00 	movl   $0x802ab3,(%esp)
  80024e:	e8 5d 03 00 00       	call   8005b0 <cprintf>
			continue;
  800253:	eb c2                	jmp    800217 <umain+0x1a3>
		}
		wait(r);
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	e8 42 23 00 00       	call   80259f <wait>
  80025d:	8d 76 00             	lea    0x0(%esi),%esi
  800260:	eb b5                	jmp    800217 <umain+0x1a3>
  800262:	66 90                	xchg   %ax,%ax
  800264:	66 90                	xchg   %ax,%ax
  800266:	66 90                	xchg   %ax,%ax
  800268:	66 90                	xchg   %ax,%ax
  80026a:	66 90                	xchg   %ax,%ax
  80026c:	66 90                	xchg   %ax,%ax
  80026e:	66 90                	xchg   %ax,%ax

00800270 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800273:	b8 00 00 00 00       	mov    $0x0,%eax
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800280:	c7 44 24 04 33 2b 80 	movl   $0x802b33,0x4(%esp)
  800287:	00 
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	89 04 24             	mov    %eax,(%esp)
  80028e:	e8 78 09 00 00       	call   800c0b <strcpy>
	return 0;
}
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	57                   	push   %edi
  80029e:	56                   	push   %esi
  80029f:	53                   	push   %ebx
  8002a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002aa:	74 4a                	je     8002f6 <devcons_write+0x5c>
  8002ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002bc:	8b 75 10             	mov    0x10(%ebp),%esi
  8002bf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8002c1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002c4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002c9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002cc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002d0:	03 45 0c             	add    0xc(%ebp),%eax
  8002d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d7:	89 3c 24             	mov    %edi,(%esp)
  8002da:	e8 27 0b 00 00       	call   800e06 <memmove>
		sys_cputs(buf, m);
  8002df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e3:	89 3c 24             	mov    %edi,(%esp)
  8002e6:	e8 01 0d 00 00       	call   800fec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002eb:	01 f3                	add    %esi,%ebx
  8002ed:	89 d8                	mov    %ebx,%eax
  8002ef:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8002f2:	72 c8                	jb     8002bc <devcons_write+0x22>
  8002f4:	eb 05                	jmp    8002fb <devcons_write+0x61>
  8002f6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002fb:	89 d8                	mov    %ebx,%eax
  8002fd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800317:	75 07                	jne    800320 <devcons_read+0x18>
  800319:	eb 28                	jmp    800343 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80031b:	e8 7a 0d 00 00       	call   80109a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800320:	e8 e5 0c 00 00       	call   80100a <sys_cgetc>
  800325:	85 c0                	test   %eax,%eax
  800327:	74 f2                	je     80031b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800329:	85 c0                	test   %eax,%eax
  80032b:	78 16                	js     800343 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80032d:	83 f8 04             	cmp    $0x4,%eax
  800330:	74 0c                	je     80033e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800332:	8b 55 0c             	mov    0xc(%ebp),%edx
  800335:	88 02                	mov    %al,(%edx)
	return 1;
  800337:	b8 01 00 00 00       	mov    $0x1,%eax
  80033c:	eb 05                	jmp    800343 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80033e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800351:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800358:	00 
  800359:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80035c:	89 04 24             	mov    %eax,(%esp)
  80035f:	e8 88 0c 00 00       	call   800fec <sys_cputs>
}
  800364:	c9                   	leave  
  800365:	c3                   	ret    

00800366 <getchar>:

int
getchar(void)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80036c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800373:	00 
  800374:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800382:	e8 ef 12 00 00       	call   801676 <read>
	if (r < 0)
  800387:	85 c0                	test   %eax,%eax
  800389:	78 0f                	js     80039a <getchar+0x34>
		return r;
	if (r < 1)
  80038b:	85 c0                	test   %eax,%eax
  80038d:	7e 06                	jle    800395 <getchar+0x2f>
		return -E_EOF;
	return c;
  80038f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800393:	eb 05                	jmp    80039a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800395:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

0080039c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8003a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	89 04 24             	mov    %eax,(%esp)
  8003af:	e8 17 10 00 00       	call   8013cb <fd_lookup>
  8003b4:	85 c0                	test   %eax,%eax
  8003b6:	78 11                	js     8003c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8003b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bb:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003c1:	39 10                	cmp    %edx,(%eax)
  8003c3:	0f 94 c0             	sete   %al
  8003c6:	0f b6 c0             	movzbl %al,%eax
}
  8003c9:	c9                   	leave  
  8003ca:	c3                   	ret    

008003cb <opencons>:

int
opencons(void)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003d4:	89 04 24             	mov    %eax,(%esp)
  8003d7:	e8 7b 0f 00 00       	call   801357 <fd_alloc>
		return r;
  8003dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	78 40                	js     800422 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003e9:	00 
  8003ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003f8:	e8 bc 0c 00 00       	call   8010b9 <sys_page_alloc>
		return r;
  8003fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003ff:	85 c0                	test   %eax,%eax
  800401:	78 1f                	js     800422 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800403:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80040e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800411:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800418:	89 04 24             	mov    %eax,(%esp)
  80041b:	e8 10 0f 00 00       	call   801330 <fd2num>
  800420:	89 c2                	mov    %eax,%edx
}
  800422:	89 d0                	mov    %edx,%eax
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	56                   	push   %esi
  80042a:	53                   	push   %ebx
  80042b:	83 ec 10             	sub    $0x10,%esp
  80042e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800431:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800434:	e8 42 0c 00 00       	call   80107b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800439:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	74 17                	je     80045a <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800443:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800448:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80044b:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800451:	8b 49 40             	mov    0x40(%ecx),%ecx
  800454:	39 c1                	cmp    %eax,%ecx
  800456:	75 18                	jne    800470 <libmain+0x4a>
  800458:	eb 05                	jmp    80045f <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80045f:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800462:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800468:	89 15 90 77 80 00    	mov    %edx,0x807790
			break;
  80046e:	eb 0b                	jmp    80047b <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800470:	83 c2 01             	add    $0x1,%edx
  800473:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800479:	75 cd                	jne    800448 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80047b:	85 db                	test   %ebx,%ebx
  80047d:	7e 07                	jle    800486 <libmain+0x60>
		binaryname = argv[0];
  80047f:	8b 06                	mov    (%esi),%eax
  800481:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800486:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048a:	89 1c 24             	mov    %ebx,(%esp)
  80048d:	e8 e2 fb ff ff       	call   800074 <umain>

	// exit gracefully
	exit();
  800492:	e8 07 00 00 00       	call   80049e <exit>
}
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	5b                   	pop    %ebx
  80049b:	5e                   	pop    %esi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8004a4:	e8 9d 10 00 00       	call   801546 <close_all>
	sys_env_destroy(0);
  8004a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004b0:	e8 74 0b 00 00       	call   801029 <sys_env_destroy>
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	56                   	push   %esi
  8004bb:	53                   	push   %ebx
  8004bc:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8004bf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c2:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  8004c8:	e8 ae 0b 00 00       	call   80107b <sys_getenvid>
  8004cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d0:	89 54 24 10          	mov    %edx,0x10(%esp)
  8004d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004db:	89 74 24 08          	mov    %esi,0x8(%esp)
  8004df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e3:	c7 04 24 4c 2b 80 00 	movl   $0x802b4c,(%esp)
  8004ea:	e8 c1 00 00 00       	call   8005b0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	89 04 24             	mov    %eax,(%esp)
  8004f9:	e8 51 00 00 00       	call   80054f <vcprintf>
	cprintf("\n");
  8004fe:	c7 04 24 7e 2f 80 00 	movl   $0x802f7e,(%esp)
  800505:	e8 a6 00 00 00       	call   8005b0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80050a:	cc                   	int3   
  80050b:	eb fd                	jmp    80050a <_panic+0x53>

0080050d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	53                   	push   %ebx
  800511:	83 ec 14             	sub    $0x14,%esp
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800517:	8b 13                	mov    (%ebx),%edx
  800519:	8d 42 01             	lea    0x1(%edx),%eax
  80051c:	89 03                	mov    %eax,(%ebx)
  80051e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800521:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800525:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052a:	75 19                	jne    800545 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80052c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800533:	00 
  800534:	8d 43 08             	lea    0x8(%ebx),%eax
  800537:	89 04 24             	mov    %eax,(%esp)
  80053a:	e8 ad 0a 00 00       	call   800fec <sys_cputs>
		b->idx = 0;
  80053f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800545:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800549:	83 c4 14             	add    $0x14,%esp
  80054c:	5b                   	pop    %ebx
  80054d:	5d                   	pop    %ebp
  80054e:	c3                   	ret    

0080054f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800558:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80055f:	00 00 00 
	b.cnt = 0;
  800562:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800569:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	89 44 24 08          	mov    %eax,0x8(%esp)
  80057a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800580:	89 44 24 04          	mov    %eax,0x4(%esp)
  800584:	c7 04 24 0d 05 80 00 	movl   $0x80050d,(%esp)
  80058b:	e8 b4 01 00 00       	call   800744 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800590:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	e8 44 0a 00 00       	call   800fec <sys_cputs>

	return b.cnt;
}
  8005a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005ae:	c9                   	leave  
  8005af:	c3                   	ret    

008005b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	e8 87 ff ff ff       	call   80054f <vcprintf>
	va_end(ap);

	return cnt;
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    
  8005ca:	66 90                	xchg   %ax,%ax
  8005cc:	66 90                	xchg   %ax,%ax
  8005ce:	66 90                	xchg   %ax,%ax

008005d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	57                   	push   %edi
  8005d4:	56                   	push   %esi
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 3c             	sub    $0x3c,%esp
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dc:	89 d7                	mov    %edx,%edi
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8005ea:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f8:	39 f1                	cmp    %esi,%ecx
  8005fa:	72 14                	jb     800610 <printnum+0x40>
  8005fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ff:	76 0f                	jbe    800610 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 70 ff             	lea    -0x1(%eax),%esi
  800607:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80060a:	85 f6                	test   %esi,%esi
  80060c:	7f 60                	jg     80066e <printnum+0x9e>
  80060e:	eb 72                	jmp    800682 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800610:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800613:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800617:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80061a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80061d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800621:	89 44 24 08          	mov    %eax,0x8(%esp)
  800625:	8b 44 24 08          	mov    0x8(%esp),%eax
  800629:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80062d:	89 c3                	mov    %eax,%ebx
  80062f:	89 d6                	mov    %edx,%esi
  800631:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800634:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800637:	89 54 24 08          	mov    %edx,0x8(%esp)
  80063b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80063f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800642:	89 04 24             	mov    %eax,(%esp)
  800645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064c:	e8 0f 21 00 00       	call   802760 <__udivdi3>
  800651:	89 d9                	mov    %ebx,%ecx
  800653:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800657:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80065b:	89 04 24             	mov    %eax,(%esp)
  80065e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800662:	89 fa                	mov    %edi,%edx
  800664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800667:	e8 64 ff ff ff       	call   8005d0 <printnum>
  80066c:	eb 14                	jmp    800682 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80066e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800672:	8b 45 18             	mov    0x18(%ebp),%eax
  800675:	89 04 24             	mov    %eax,(%esp)
  800678:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067a:	83 ee 01             	sub    $0x1,%esi
  80067d:	75 ef                	jne    80066e <printnum+0x9e>
  80067f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800682:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800686:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80068a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800690:	89 44 24 08          	mov    %eax,0x8(%esp)
  800694:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069b:	89 04 24             	mov    %eax,(%esp)
  80069e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a5:	e8 e6 21 00 00       	call   802890 <__umoddi3>
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	0f be 80 6f 2b 80 00 	movsbl 0x802b6f(%eax),%eax
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
}
  8006bd:	83 c4 3c             	add    $0x3c,%esp
  8006c0:	5b                   	pop    %ebx
  8006c1:	5e                   	pop    %esi
  8006c2:	5f                   	pop    %edi
  8006c3:	5d                   	pop    %ebp
  8006c4:	c3                   	ret    

008006c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c8:	83 fa 01             	cmp    $0x1,%edx
  8006cb:	7e 0e                	jle    8006db <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8006cd:	8b 10                	mov    (%eax),%edx
  8006cf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8006d2:	89 08                	mov    %ecx,(%eax)
  8006d4:	8b 02                	mov    (%edx),%eax
  8006d6:	8b 52 04             	mov    0x4(%edx),%edx
  8006d9:	eb 22                	jmp    8006fd <getuint+0x38>
	else if (lflag)
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	74 10                	je     8006ef <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006e4:	89 08                	mov    %ecx,(%eax)
  8006e6:	8b 02                	mov    (%edx),%eax
  8006e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ed:	eb 0e                	jmp    8006fd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006ef:	8b 10                	mov    (%eax),%edx
  8006f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006f4:	89 08                	mov    %ecx,(%eax)
  8006f6:	8b 02                	mov    (%edx),%eax
  8006f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800705:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	3b 50 04             	cmp    0x4(%eax),%edx
  80070e:	73 0a                	jae    80071a <sprintputch+0x1b>
		*b->buf++ = ch;
  800710:	8d 4a 01             	lea    0x1(%edx),%ecx
  800713:	89 08                	mov    %ecx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	88 02                	mov    %al,(%edx)
}
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800722:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800725:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800729:	8b 45 10             	mov    0x10(%ebp),%eax
  80072c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	89 44 24 04          	mov    %eax,0x4(%esp)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 04 24             	mov    %eax,(%esp)
  80073d:	e8 02 00 00 00       	call   800744 <vprintfmt>
	va_end(ap);
}
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	57                   	push   %edi
  800748:	56                   	push   %esi
  800749:	53                   	push   %ebx
  80074a:	83 ec 3c             	sub    $0x3c,%esp
  80074d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800750:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800753:	eb 18                	jmp    80076d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800755:	85 c0                	test   %eax,%eax
  800757:	0f 84 c3 03 00 00    	je     800b20 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80075d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800761:	89 04 24             	mov    %eax,(%esp)
  800764:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	89 f3                	mov    %esi,%ebx
  800769:	eb 02                	jmp    80076d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076d:	8d 73 01             	lea    0x1(%ebx),%esi
  800770:	0f b6 03             	movzbl (%ebx),%eax
  800773:	83 f8 25             	cmp    $0x25,%eax
  800776:	75 dd                	jne    800755 <vprintfmt+0x11>
  800778:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80077c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800783:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80078a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	eb 1d                	jmp    8007b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80079a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80079e:	eb 15                	jmp    8007b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8007a6:	eb 0d                	jmp    8007b5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ae:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8007b8:	0f b6 06             	movzbl (%esi),%eax
  8007bb:	0f b6 c8             	movzbl %al,%ecx
  8007be:	83 e8 23             	sub    $0x23,%eax
  8007c1:	3c 55                	cmp    $0x55,%al
  8007c3:	0f 87 2f 03 00 00    	ja     800af8 <vprintfmt+0x3b4>
  8007c9:	0f b6 c0             	movzbl %al,%eax
  8007cc:	ff 24 85 c0 2c 80 00 	jmp    *0x802cc0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8007d3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8007d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8007d9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8007dd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8007e0:	83 f9 09             	cmp    $0x9,%ecx
  8007e3:	77 50                	ja     800835 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e5:	89 de                	mov    %ebx,%esi
  8007e7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ea:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8007ed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8007f0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8007f4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8007f7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8007fa:	83 fb 09             	cmp    $0x9,%ebx
  8007fd:	76 eb                	jbe    8007ea <vprintfmt+0xa6>
  8007ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800802:	eb 33                	jmp    800837 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8d 48 04             	lea    0x4(%eax),%ecx
  80080a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800812:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800814:	eb 21                	jmp    800837 <vprintfmt+0xf3>
  800816:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800819:	85 c9                	test   %ecx,%ecx
  80081b:	b8 00 00 00 00       	mov    $0x0,%eax
  800820:	0f 49 c1             	cmovns %ecx,%eax
  800823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800826:	89 de                	mov    %ebx,%esi
  800828:	eb 8b                	jmp    8007b5 <vprintfmt+0x71>
  80082a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80082c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800833:	eb 80                	jmp    8007b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800835:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083b:	0f 89 74 ff ff ff    	jns    8007b5 <vprintfmt+0x71>
  800841:	e9 62 ff ff ff       	jmp    8007a8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800849:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80084b:	e9 65 ff ff ff       	jmp    8007b5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	89 55 14             	mov    %edx,0x14(%ebp)
  800859:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	89 04 24             	mov    %eax,(%esp)
  800862:	ff 55 08             	call   *0x8(%ebp)
			break;
  800865:	e9 03 ff ff ff       	jmp    80076d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	89 55 14             	mov    %edx,0x14(%ebp)
  800873:	8b 00                	mov    (%eax),%eax
  800875:	99                   	cltd   
  800876:	31 d0                	xor    %edx,%eax
  800878:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80087a:	83 f8 0f             	cmp    $0xf,%eax
  80087d:	7f 0b                	jg     80088a <vprintfmt+0x146>
  80087f:	8b 14 85 20 2e 80 00 	mov    0x802e20(,%eax,4),%edx
  800886:	85 d2                	test   %edx,%edx
  800888:	75 20                	jne    8008aa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80088a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088e:	c7 44 24 08 87 2b 80 	movl   $0x802b87,0x8(%esp)
  800895:	00 
  800896:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 04 24             	mov    %eax,(%esp)
  8008a0:	e8 77 fe ff ff       	call   80071c <printfmt>
  8008a5:	e9 c3 fe ff ff       	jmp    80076d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8008aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008ae:	c7 44 24 08 5f 2f 80 	movl   $0x802f5f,0x8(%esp)
  8008b5:	00 
  8008b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	89 04 24             	mov    %eax,(%esp)
  8008c0:	e8 57 fe ff ff       	call   80071c <printfmt>
  8008c5:	e9 a3 fe ff ff       	jmp    80076d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8008cd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8d 50 04             	lea    0x4(%eax),%edx
  8008d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8008db:	85 c0                	test   %eax,%eax
  8008dd:	ba 80 2b 80 00       	mov    $0x802b80,%edx
  8008e2:	0f 45 d0             	cmovne %eax,%edx
  8008e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8008e8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8008ec:	74 04                	je     8008f2 <vprintfmt+0x1ae>
  8008ee:	85 f6                	test   %esi,%esi
  8008f0:	7f 19                	jg     80090b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f5:	8d 70 01             	lea    0x1(%eax),%esi
  8008f8:	0f b6 10             	movzbl (%eax),%edx
  8008fb:	0f be c2             	movsbl %dl,%eax
  8008fe:	85 c0                	test   %eax,%eax
  800900:	0f 85 95 00 00 00    	jne    80099b <vprintfmt+0x257>
  800906:	e9 85 00 00 00       	jmp    800990 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80090b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80090f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 b8 02 00 00       	call   800bd2 <strnlen>
  80091a:	29 c6                	sub    %eax,%esi
  80091c:	89 f0                	mov    %esi,%eax
  80091e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800921:	85 f6                	test   %esi,%esi
  800923:	7e cd                	jle    8008f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800925:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800929:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80092c:	89 c3                	mov    %eax,%ebx
  80092e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800932:	89 34 24             	mov    %esi,(%esp)
  800935:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800938:	83 eb 01             	sub    $0x1,%ebx
  80093b:	75 f1                	jne    80092e <vprintfmt+0x1ea>
  80093d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800940:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800943:	eb ad                	jmp    8008f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800945:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800949:	74 1e                	je     800969 <vprintfmt+0x225>
  80094b:	0f be d2             	movsbl %dl,%edx
  80094e:	83 ea 20             	sub    $0x20,%edx
  800951:	83 fa 5e             	cmp    $0x5e,%edx
  800954:	76 13                	jbe    800969 <vprintfmt+0x225>
					putch('?', putdat);
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800964:	ff 55 08             	call   *0x8(%ebp)
  800967:	eb 0d                	jmp    800976 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800970:	89 04 24             	mov    %eax,(%esp)
  800973:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800976:	83 ef 01             	sub    $0x1,%edi
  800979:	83 c6 01             	add    $0x1,%esi
  80097c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800980:	0f be c2             	movsbl %dl,%eax
  800983:	85 c0                	test   %eax,%eax
  800985:	75 20                	jne    8009a7 <vprintfmt+0x263>
  800987:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80098a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80098d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800990:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800994:	7f 25                	jg     8009bb <vprintfmt+0x277>
  800996:	e9 d2 fd ff ff       	jmp    80076d <vprintfmt+0x29>
  80099b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80099e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009a1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a7:	85 db                	test   %ebx,%ebx
  8009a9:	78 9a                	js     800945 <vprintfmt+0x201>
  8009ab:	83 eb 01             	sub    $0x1,%ebx
  8009ae:	79 95                	jns    800945 <vprintfmt+0x201>
  8009b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8009b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8009b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009b9:	eb d5                	jmp    800990 <vprintfmt+0x24c>
  8009bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8009c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009cf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d1:	83 eb 01             	sub    $0x1,%ebx
  8009d4:	75 ee                	jne    8009c4 <vprintfmt+0x280>
  8009d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009d9:	e9 8f fd ff ff       	jmp    80076d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8009de:	83 fa 01             	cmp    $0x1,%edx
  8009e1:	7e 16                	jle    8009f9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	8d 50 08             	lea    0x8(%eax),%edx
  8009e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ec:	8b 50 04             	mov    0x4(%eax),%edx
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009f7:	eb 32                	jmp    800a2b <vprintfmt+0x2e7>
	else if (lflag)
  8009f9:	85 d2                	test   %edx,%edx
  8009fb:	74 18                	je     800a15 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8d 50 04             	lea    0x4(%eax),%edx
  800a03:	89 55 14             	mov    %edx,0x14(%ebp)
  800a06:	8b 30                	mov    (%eax),%esi
  800a08:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a0b:	89 f0                	mov    %esi,%eax
  800a0d:	c1 f8 1f             	sar    $0x1f,%eax
  800a10:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a13:	eb 16                	jmp    800a2b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	8d 50 04             	lea    0x4(%eax),%edx
  800a1b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a1e:	8b 30                	mov    (%eax),%esi
  800a20:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a23:	89 f0                	mov    %esi,%eax
  800a25:	c1 f8 1f             	sar    $0x1f,%eax
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800a31:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800a36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a3a:	0f 89 80 00 00 00    	jns    800ac0 <vprintfmt+0x37c>
				putch('-', putdat);
  800a40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a44:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a4b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800a4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800a54:	f7 d8                	neg    %eax
  800a56:	83 d2 00             	adc    $0x0,%edx
  800a59:	f7 da                	neg    %edx
			}
			base = 10;
  800a5b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a60:	eb 5e                	jmp    800ac0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a62:	8d 45 14             	lea    0x14(%ebp),%eax
  800a65:	e8 5b fc ff ff       	call   8006c5 <getuint>
			base = 10;
  800a6a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800a6f:	eb 4f                	jmp    800ac0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800a71:	8d 45 14             	lea    0x14(%ebp),%eax
  800a74:	e8 4c fc ff ff       	call   8006c5 <getuint>
			base = 8;
  800a79:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a7e:	eb 40                	jmp    800ac0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800a80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a84:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a8b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a92:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a99:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	8d 50 04             	lea    0x4(%eax),%edx
  800aa2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800aac:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800ab1:	eb 0d                	jmp    800ac0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ab3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab6:	e8 0a fc ff ff       	call   8006c5 <getuint>
			base = 16;
  800abb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800ac4:	89 74 24 10          	mov    %esi,0x10(%esp)
  800ac8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800acb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ad3:	89 04 24             	mov    %eax,(%esp)
  800ad6:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ada:	89 fa                	mov    %edi,%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	e8 ec fa ff ff       	call   8005d0 <printnum>
			break;
  800ae4:	e9 84 fc ff ff       	jmp    80076d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aed:	89 0c 24             	mov    %ecx,(%esp)
  800af0:	ff 55 08             	call   *0x8(%ebp)
			break;
  800af3:	e9 75 fc ff ff       	jmp    80076d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800afc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b03:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b06:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800b0a:	0f 84 5b fc ff ff    	je     80076b <vprintfmt+0x27>
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	83 eb 01             	sub    $0x1,%ebx
  800b15:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b19:	75 f7                	jne    800b12 <vprintfmt+0x3ce>
  800b1b:	e9 4d fc ff ff       	jmp    80076d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800b20:	83 c4 3c             	add    $0x3c,%esp
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 28             	sub    $0x28,%esp
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b3b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b45:	85 c0                	test   %eax,%eax
  800b47:	74 30                	je     800b79 <vsnprintf+0x51>
  800b49:	85 d2                	test   %edx,%edx
  800b4b:	7e 2c                	jle    800b79 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b62:	c7 04 24 ff 06 80 00 	movl   $0x8006ff,(%esp)
  800b69:	e8 d6 fb ff ff       	call   800744 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b77:	eb 05                	jmp    800b7e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b86:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	89 04 24             	mov    %eax,(%esp)
  800ba1:	e8 82 ff ff ff       	call   800b28 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    
  800ba8:	66 90                	xchg   %ax,%ax
  800baa:	66 90                	xchg   %ax,%ax
  800bac:	66 90                	xchg   %ax,%ax
  800bae:	66 90                	xchg   %ax,%ax

00800bb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb6:	80 3a 00             	cmpb   $0x0,(%edx)
  800bb9:	74 10                	je     800bcb <strlen+0x1b>
  800bbb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bc0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc7:	75 f7                	jne    800bc0 <strlen+0x10>
  800bc9:	eb 05                	jmp    800bd0 <strlen+0x20>
  800bcb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	53                   	push   %ebx
  800bd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	85 c9                	test   %ecx,%ecx
  800bde:	74 1c                	je     800bfc <strnlen+0x2a>
  800be0:	80 3b 00             	cmpb   $0x0,(%ebx)
  800be3:	74 1e                	je     800c03 <strnlen+0x31>
  800be5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800bea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bec:	39 ca                	cmp    %ecx,%edx
  800bee:	74 18                	je     800c08 <strnlen+0x36>
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800bf8:	75 f0                	jne    800bea <strnlen+0x18>
  800bfa:	eb 0c                	jmp    800c08 <strnlen+0x36>
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	eb 05                	jmp    800c08 <strnlen+0x36>
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800c08:	5b                   	pop    %ebx
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c15:	89 c2                	mov    %eax,%edx
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	83 c1 01             	add    $0x1,%ecx
  800c1d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c21:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c24:	84 db                	test   %bl,%bl
  800c26:	75 ef                	jne    800c17 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c28:	5b                   	pop    %ebx
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	53                   	push   %ebx
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c35:	89 1c 24             	mov    %ebx,(%esp)
  800c38:	e8 73 ff ff ff       	call   800bb0 <strlen>
	strcpy(dst + len, src);
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c44:	01 d8                	add    %ebx,%eax
  800c46:	89 04 24             	mov    %eax,(%esp)
  800c49:	e8 bd ff ff ff       	call   800c0b <strcpy>
	return dst;
}
  800c4e:	89 d8                	mov    %ebx,%eax
  800c50:	83 c4 08             	add    $0x8,%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c64:	85 db                	test   %ebx,%ebx
  800c66:	74 17                	je     800c7f <strncpy+0x29>
  800c68:	01 f3                	add    %esi,%ebx
  800c6a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800c6c:	83 c1 01             	add    $0x1,%ecx
  800c6f:	0f b6 02             	movzbl (%edx),%eax
  800c72:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c75:	80 3a 01             	cmpb   $0x1,(%edx)
  800c78:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7b:	39 d9                	cmp    %ebx,%ecx
  800c7d:	75 ed                	jne    800c6c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c7f:	89 f0                	mov    %esi,%eax
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c91:	8b 75 10             	mov    0x10(%ebp),%esi
  800c94:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c96:	85 f6                	test   %esi,%esi
  800c98:	74 34                	je     800cce <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800c9a:	83 fe 01             	cmp    $0x1,%esi
  800c9d:	74 26                	je     800cc5 <strlcpy+0x40>
  800c9f:	0f b6 0b             	movzbl (%ebx),%ecx
  800ca2:	84 c9                	test   %cl,%cl
  800ca4:	74 23                	je     800cc9 <strlcpy+0x44>
  800ca6:	83 ee 02             	sub    $0x2,%esi
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800cae:	83 c0 01             	add    $0x1,%eax
  800cb1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb4:	39 f2                	cmp    %esi,%edx
  800cb6:	74 13                	je     800ccb <strlcpy+0x46>
  800cb8:	83 c2 01             	add    $0x1,%edx
  800cbb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800cbf:	84 c9                	test   %cl,%cl
  800cc1:	75 eb                	jne    800cae <strlcpy+0x29>
  800cc3:	eb 06                	jmp    800ccb <strlcpy+0x46>
  800cc5:	89 f8                	mov    %edi,%eax
  800cc7:	eb 02                	jmp    800ccb <strlcpy+0x46>
  800cc9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800ccb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cce:	29 f8                	sub    %edi,%eax
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cde:	0f b6 01             	movzbl (%ecx),%eax
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 15                	je     800cfa <strcmp+0x25>
  800ce5:	3a 02                	cmp    (%edx),%al
  800ce7:	75 11                	jne    800cfa <strcmp+0x25>
		p++, q++;
  800ce9:	83 c1 01             	add    $0x1,%ecx
  800cec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cef:	0f b6 01             	movzbl (%ecx),%eax
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 04                	je     800cfa <strcmp+0x25>
  800cf6:	3a 02                	cmp    (%edx),%al
  800cf8:	74 ef                	je     800ce9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfa:	0f b6 c0             	movzbl %al,%eax
  800cfd:	0f b6 12             	movzbl (%edx),%edx
  800d00:	29 d0                	sub    %edx,%eax
}
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800d12:	85 f6                	test   %esi,%esi
  800d14:	74 29                	je     800d3f <strncmp+0x3b>
  800d16:	0f b6 03             	movzbl (%ebx),%eax
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 30                	je     800d4d <strncmp+0x49>
  800d1d:	3a 02                	cmp    (%edx),%al
  800d1f:	75 2c                	jne    800d4d <strncmp+0x49>
  800d21:	8d 43 01             	lea    0x1(%ebx),%eax
  800d24:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800d26:	89 c3                	mov    %eax,%ebx
  800d28:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d2b:	39 f0                	cmp    %esi,%eax
  800d2d:	74 17                	je     800d46 <strncmp+0x42>
  800d2f:	0f b6 08             	movzbl (%eax),%ecx
  800d32:	84 c9                	test   %cl,%cl
  800d34:	74 17                	je     800d4d <strncmp+0x49>
  800d36:	83 c0 01             	add    $0x1,%eax
  800d39:	3a 0a                	cmp    (%edx),%cl
  800d3b:	74 e9                	je     800d26 <strncmp+0x22>
  800d3d:	eb 0e                	jmp    800d4d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	eb 0f                	jmp    800d55 <strncmp+0x51>
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	eb 08                	jmp    800d55 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	0f b6 03             	movzbl (%ebx),%eax
  800d50:	0f b6 12             	movzbl (%edx),%edx
  800d53:	29 d0                	sub    %edx,%eax
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	53                   	push   %ebx
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800d63:	0f b6 18             	movzbl (%eax),%ebx
  800d66:	84 db                	test   %bl,%bl
  800d68:	74 1d                	je     800d87 <strchr+0x2e>
  800d6a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800d6c:	38 d3                	cmp    %dl,%bl
  800d6e:	75 06                	jne    800d76 <strchr+0x1d>
  800d70:	eb 1a                	jmp    800d8c <strchr+0x33>
  800d72:	38 ca                	cmp    %cl,%dl
  800d74:	74 16                	je     800d8c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d76:	83 c0 01             	add    $0x1,%eax
  800d79:	0f b6 10             	movzbl (%eax),%edx
  800d7c:	84 d2                	test   %dl,%dl
  800d7e:	75 f2                	jne    800d72 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800d80:	b8 00 00 00 00       	mov    $0x0,%eax
  800d85:	eb 05                	jmp    800d8c <strchr+0x33>
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8c:	5b                   	pop    %ebx
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	53                   	push   %ebx
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800d99:	0f b6 18             	movzbl (%eax),%ebx
  800d9c:	84 db                	test   %bl,%bl
  800d9e:	74 16                	je     800db6 <strfind+0x27>
  800da0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800da2:	38 d3                	cmp    %dl,%bl
  800da4:	75 06                	jne    800dac <strfind+0x1d>
  800da6:	eb 0e                	jmp    800db6 <strfind+0x27>
  800da8:	38 ca                	cmp    %cl,%dl
  800daa:	74 0a                	je     800db6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dac:	83 c0 01             	add    $0x1,%eax
  800daf:	0f b6 10             	movzbl (%eax),%edx
  800db2:	84 d2                	test   %dl,%dl
  800db4:	75 f2                	jne    800da8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800db6:	5b                   	pop    %ebx
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dc5:	85 c9                	test   %ecx,%ecx
  800dc7:	74 36                	je     800dff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dc9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dcf:	75 28                	jne    800df9 <memset+0x40>
  800dd1:	f6 c1 03             	test   $0x3,%cl
  800dd4:	75 23                	jne    800df9 <memset+0x40>
		c &= 0xFF;
  800dd6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	c1 e3 08             	shl    $0x8,%ebx
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	c1 e6 18             	shl    $0x18,%esi
  800de4:	89 d0                	mov    %edx,%eax
  800de6:	c1 e0 10             	shl    $0x10,%eax
  800de9:	09 f0                	or     %esi,%eax
  800deb:	09 c2                	or     %eax,%edx
  800ded:	89 d0                	mov    %edx,%eax
  800def:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800df1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800df4:	fc                   	cld    
  800df5:	f3 ab                	rep stos %eax,%es:(%edi)
  800df7:	eb 06                	jmp    800dff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	fc                   	cld    
  800dfd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dff:	89 f8                	mov    %edi,%eax
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e14:	39 c6                	cmp    %eax,%esi
  800e16:	73 35                	jae    800e4d <memmove+0x47>
  800e18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e1b:	39 d0                	cmp    %edx,%eax
  800e1d:	73 2e                	jae    800e4d <memmove+0x47>
		s += n;
		d += n;
  800e1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e22:	89 d6                	mov    %edx,%esi
  800e24:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e2c:	75 13                	jne    800e41 <memmove+0x3b>
  800e2e:	f6 c1 03             	test   $0x3,%cl
  800e31:	75 0e                	jne    800e41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e33:	83 ef 04             	sub    $0x4,%edi
  800e36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e39:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e3c:	fd                   	std    
  800e3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e3f:	eb 09                	jmp    800e4a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e41:	83 ef 01             	sub    $0x1,%edi
  800e44:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e47:	fd                   	std    
  800e48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e4a:	fc                   	cld    
  800e4b:	eb 1d                	jmp    800e6a <memmove+0x64>
  800e4d:	89 f2                	mov    %esi,%edx
  800e4f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e51:	f6 c2 03             	test   $0x3,%dl
  800e54:	75 0f                	jne    800e65 <memmove+0x5f>
  800e56:	f6 c1 03             	test   $0x3,%cl
  800e59:	75 0a                	jne    800e65 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e5b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e5e:	89 c7                	mov    %eax,%edi
  800e60:	fc                   	cld    
  800e61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e63:	eb 05                	jmp    800e6a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e65:	89 c7                	mov    %eax,%edi
  800e67:	fc                   	cld    
  800e68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 04 24             	mov    %eax,(%esp)
  800e88:	e8 79 ff ff ff       	call   800e06 <memmove>
}
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e9e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	74 36                	je     800edb <memcmp+0x4c>
		if (*s1 != *s2)
  800ea5:	0f b6 03             	movzbl (%ebx),%eax
  800ea8:	0f b6 0e             	movzbl (%esi),%ecx
  800eab:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb0:	38 c8                	cmp    %cl,%al
  800eb2:	74 1c                	je     800ed0 <memcmp+0x41>
  800eb4:	eb 10                	jmp    800ec6 <memcmp+0x37>
  800eb6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ebb:	83 c2 01             	add    $0x1,%edx
  800ebe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800ec2:	38 c8                	cmp    %cl,%al
  800ec4:	74 0a                	je     800ed0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800ec6:	0f b6 c0             	movzbl %al,%eax
  800ec9:	0f b6 c9             	movzbl %cl,%ecx
  800ecc:	29 c8                	sub    %ecx,%eax
  800ece:	eb 10                	jmp    800ee0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ed0:	39 fa                	cmp    %edi,%edx
  800ed2:	75 e2                	jne    800eb6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	eb 05                	jmp    800ee0 <memcmp+0x51>
  800edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	53                   	push   %ebx
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ef4:	39 d0                	cmp    %edx,%eax
  800ef6:	73 13                	jae    800f0b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef8:	89 d9                	mov    %ebx,%ecx
  800efa:	38 18                	cmp    %bl,(%eax)
  800efc:	75 06                	jne    800f04 <memfind+0x1f>
  800efe:	eb 0b                	jmp    800f0b <memfind+0x26>
  800f00:	38 08                	cmp    %cl,(%eax)
  800f02:	74 07                	je     800f0b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f04:	83 c0 01             	add    $0x1,%eax
  800f07:	39 d0                	cmp    %edx,%eax
  800f09:	75 f5                	jne    800f00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	0f b6 0a             	movzbl (%edx),%ecx
  800f1d:	80 f9 09             	cmp    $0x9,%cl
  800f20:	74 05                	je     800f27 <strtol+0x19>
  800f22:	80 f9 20             	cmp    $0x20,%cl
  800f25:	75 10                	jne    800f37 <strtol+0x29>
		s++;
  800f27:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2a:	0f b6 0a             	movzbl (%edx),%ecx
  800f2d:	80 f9 09             	cmp    $0x9,%cl
  800f30:	74 f5                	je     800f27 <strtol+0x19>
  800f32:	80 f9 20             	cmp    $0x20,%cl
  800f35:	74 f0                	je     800f27 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f37:	80 f9 2b             	cmp    $0x2b,%cl
  800f3a:	75 0a                	jne    800f46 <strtol+0x38>
		s++;
  800f3c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800f44:	eb 11                	jmp    800f57 <strtol+0x49>
  800f46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f4b:	80 f9 2d             	cmp    $0x2d,%cl
  800f4e:	75 07                	jne    800f57 <strtol+0x49>
		s++, neg = 1;
  800f50:	83 c2 01             	add    $0x1,%edx
  800f53:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f57:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f5c:	75 15                	jne    800f73 <strtol+0x65>
  800f5e:	80 3a 30             	cmpb   $0x30,(%edx)
  800f61:	75 10                	jne    800f73 <strtol+0x65>
  800f63:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f67:	75 0a                	jne    800f73 <strtol+0x65>
		s += 2, base = 16;
  800f69:	83 c2 02             	add    $0x2,%edx
  800f6c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f71:	eb 10                	jmp    800f83 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800f73:	85 c0                	test   %eax,%eax
  800f75:	75 0c                	jne    800f83 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f77:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f79:	80 3a 30             	cmpb   $0x30,(%edx)
  800f7c:	75 05                	jne    800f83 <strtol+0x75>
		s++, base = 8;
  800f7e:	83 c2 01             	add    $0x1,%edx
  800f81:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8b:	0f b6 0a             	movzbl (%edx),%ecx
  800f8e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f91:	89 f0                	mov    %esi,%eax
  800f93:	3c 09                	cmp    $0x9,%al
  800f95:	77 08                	ja     800f9f <strtol+0x91>
			dig = *s - '0';
  800f97:	0f be c9             	movsbl %cl,%ecx
  800f9a:	83 e9 30             	sub    $0x30,%ecx
  800f9d:	eb 20                	jmp    800fbf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800f9f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800fa2:	89 f0                	mov    %esi,%eax
  800fa4:	3c 19                	cmp    $0x19,%al
  800fa6:	77 08                	ja     800fb0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800fa8:	0f be c9             	movsbl %cl,%ecx
  800fab:	83 e9 57             	sub    $0x57,%ecx
  800fae:	eb 0f                	jmp    800fbf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800fb0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	3c 19                	cmp    $0x19,%al
  800fb7:	77 16                	ja     800fcf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800fb9:	0f be c9             	movsbl %cl,%ecx
  800fbc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fbf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fc2:	7d 0f                	jge    800fd3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800fc4:	83 c2 01             	add    $0x1,%edx
  800fc7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800fcb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800fcd:	eb bc                	jmp    800f8b <strtol+0x7d>
  800fcf:	89 d8                	mov    %ebx,%eax
  800fd1:	eb 02                	jmp    800fd5 <strtol+0xc7>
  800fd3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd9:	74 05                	je     800fe0 <strtol+0xd2>
		*endptr = (char *) s;
  800fdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fde:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800fe0:	f7 d8                	neg    %eax
  800fe2:	85 ff                	test   %edi,%edi
  800fe4:	0f 44 c3             	cmove  %ebx,%eax
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	89 c3                	mov    %eax,%ebx
  800fff:	89 c7                	mov    %eax,%edi
  801001:	89 c6                	mov    %eax,%esi
  801003:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_cgetc>:

int
sys_cgetc(void)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801010:	ba 00 00 00 00       	mov    $0x0,%edx
  801015:	b8 01 00 00 00       	mov    $0x1,%eax
  80101a:	89 d1                	mov    %edx,%ecx
  80101c:	89 d3                	mov    %edx,%ebx
  80101e:	89 d7                	mov    %edx,%edi
  801020:	89 d6                	mov    %edx,%esi
  801022:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	57                   	push   %edi
  80102d:	56                   	push   %esi
  80102e:	53                   	push   %ebx
  80102f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	b9 00 00 00 00       	mov    $0x0,%ecx
  801037:	b8 03 00 00 00       	mov    $0x3,%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 cb                	mov    %ecx,%ebx
  801041:	89 cf                	mov    %ecx,%edi
  801043:	89 ce                	mov    %ecx,%esi
  801045:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801047:	85 c0                	test   %eax,%eax
  801049:	7e 28                	jle    801073 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801056:	00 
  801057:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  80105e:	00 
  80105f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801066:	00 
  801067:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  80106e:	e8 44 f4 ff ff       	call   8004b7 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801073:	83 c4 2c             	add    $0x2c,%esp
  801076:	5b                   	pop    %ebx
  801077:	5e                   	pop    %esi
  801078:	5f                   	pop    %edi
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801081:	ba 00 00 00 00       	mov    $0x0,%edx
  801086:	b8 02 00 00 00       	mov    $0x2,%eax
  80108b:	89 d1                	mov    %edx,%ecx
  80108d:	89 d3                	mov    %edx,%ebx
  80108f:	89 d7                	mov    %edx,%edi
  801091:	89 d6                	mov    %edx,%esi
  801093:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <sys_yield>:

void
sys_yield(void)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010aa:	89 d1                	mov    %edx,%ecx
  8010ac:	89 d3                	mov    %edx,%ebx
  8010ae:	89 d7                	mov    %edx,%edi
  8010b0:	89 d6                	mov    %edx,%esi
  8010b2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	57                   	push   %edi
  8010bd:	56                   	push   %esi
  8010be:	53                   	push   %ebx
  8010bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	be 00 00 00 00       	mov    $0x0,%esi
  8010c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8010cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010d5:	89 f7                	mov    %esi,%edi
  8010d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	7e 28                	jle    801105 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010e8:	00 
  8010e9:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  8010f0:	00 
  8010f1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010f8:	00 
  8010f9:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  801100:	e8 b2 f3 ff ff       	call   8004b7 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801105:	83 c4 2c             	add    $0x2c,%esp
  801108:	5b                   	pop    %ebx
  801109:	5e                   	pop    %esi
  80110a:	5f                   	pop    %edi
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    

0080110d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	57                   	push   %edi
  801111:	56                   	push   %esi
  801112:	53                   	push   %ebx
  801113:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801116:	b8 05 00 00 00       	mov    $0x5,%eax
  80111b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801124:	8b 7d 14             	mov    0x14(%ebp),%edi
  801127:	8b 75 18             	mov    0x18(%ebp),%esi
  80112a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	7e 28                	jle    801158 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801130:	89 44 24 10          	mov    %eax,0x10(%esp)
  801134:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80113b:	00 
  80113c:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  801143:	00 
  801144:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80114b:	00 
  80114c:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  801153:	e8 5f f3 ff ff       	call   8004b7 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801158:	83 c4 2c             	add    $0x2c,%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5f                   	pop    %edi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801169:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116e:	b8 06 00 00 00       	mov    $0x6,%eax
  801173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801176:	8b 55 08             	mov    0x8(%ebp),%edx
  801179:	89 df                	mov    %ebx,%edi
  80117b:	89 de                	mov    %ebx,%esi
  80117d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	7e 28                	jle    8011ab <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801183:	89 44 24 10          	mov    %eax,0x10(%esp)
  801187:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80118e:	00 
  80118f:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  801196:	00 
  801197:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80119e:	00 
  80119f:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  8011a6:	e8 0c f3 ff ff       	call   8004b7 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ab:	83 c4 2c             	add    $0x2c,%esp
  8011ae:	5b                   	pop    %ebx
  8011af:	5e                   	pop    %esi
  8011b0:	5f                   	pop    %edi
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	57                   	push   %edi
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
  8011b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8011c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cc:	89 df                	mov    %ebx,%edi
  8011ce:	89 de                	mov    %ebx,%esi
  8011d0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	7e 28                	jle    8011fe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011da:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011e1:	00 
  8011e2:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  8011e9:	00 
  8011ea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011f1:	00 
  8011f2:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  8011f9:	e8 b9 f2 ff ff       	call   8004b7 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011fe:	83 c4 2c             	add    $0x2c,%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	57                   	push   %edi
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
  80120c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	b8 09 00 00 00       	mov    $0x9,%eax
  801219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	89 df                	mov    %ebx,%edi
  801221:	89 de                	mov    %ebx,%esi
  801223:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801225:	85 c0                	test   %eax,%eax
  801227:	7e 28                	jle    801251 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801229:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801234:	00 
  801235:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  80123c:	00 
  80123d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801244:	00 
  801245:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  80124c:	e8 66 f2 ff ff       	call   8004b7 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801251:	83 c4 2c             	add    $0x2c,%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	57                   	push   %edi
  80125d:	56                   	push   %esi
  80125e:	53                   	push   %ebx
  80125f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801262:	bb 00 00 00 00       	mov    $0x0,%ebx
  801267:	b8 0a 00 00 00       	mov    $0xa,%eax
  80126c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126f:	8b 55 08             	mov    0x8(%ebp),%edx
  801272:	89 df                	mov    %ebx,%edi
  801274:	89 de                	mov    %ebx,%esi
  801276:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801278:	85 c0                	test   %eax,%eax
  80127a:	7e 28                	jle    8012a4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80127c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801280:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801287:	00 
  801288:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  80128f:	00 
  801290:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801297:	00 
  801298:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  80129f:	e8 13 f2 ff ff       	call   8004b7 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012a4:	83 c4 2c             	add    $0x2c,%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b2:	be 00 00 00 00       	mov    $0x0,%esi
  8012b7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012c8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5f                   	pop    %edi
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e5:	89 cb                	mov    %ecx,%ebx
  8012e7:	89 cf                	mov    %ecx,%edi
  8012e9:	89 ce                	mov    %ecx,%esi
  8012eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	7e 28                	jle    801319 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012fc:	00 
  8012fd:	c7 44 24 08 7f 2e 80 	movl   $0x802e7f,0x8(%esp)
  801304:	00 
  801305:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80130c:	00 
  80130d:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  801314:	e8 9e f1 ff ff       	call   8004b7 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801319:	83 c4 2c             	add    $0x2c,%esp
  80131c:	5b                   	pop    %ebx
  80131d:	5e                   	pop    %esi
  80131e:	5f                   	pop    %edi
  80131f:	5d                   	pop    %ebp
  801320:	c3                   	ret    
  801321:	66 90                	xchg   %ax,%ax
  801323:	66 90                	xchg   %ax,%ax
  801325:	66 90                	xchg   %ax,%ax
  801327:	66 90                	xchg   %ax,%ax
  801329:	66 90                	xchg   %ax,%ax
  80132b:	66 90                	xchg   %ax,%ax
  80132d:	66 90                	xchg   %ax,%ax
  80132f:	90                   	nop

00801330 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	05 00 00 00 30       	add    $0x30000000,%eax
  80133b:	c1 e8 0c             	shr    $0xc,%eax
}
  80133e:	5d                   	pop    %ebp
  80133f:	c3                   	ret    

00801340 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80134b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801350:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80135a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80135f:	a8 01                	test   $0x1,%al
  801361:	74 34                	je     801397 <fd_alloc+0x40>
  801363:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801368:	a8 01                	test   $0x1,%al
  80136a:	74 32                	je     80139e <fd_alloc+0x47>
  80136c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801371:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801373:	89 c2                	mov    %eax,%edx
  801375:	c1 ea 16             	shr    $0x16,%edx
  801378:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80137f:	f6 c2 01             	test   $0x1,%dl
  801382:	74 1f                	je     8013a3 <fd_alloc+0x4c>
  801384:	89 c2                	mov    %eax,%edx
  801386:	c1 ea 0c             	shr    $0xc,%edx
  801389:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801390:	f6 c2 01             	test   $0x1,%dl
  801393:	75 1a                	jne    8013af <fd_alloc+0x58>
  801395:	eb 0c                	jmp    8013a3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801397:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80139c:	eb 05                	jmp    8013a3 <fd_alloc+0x4c>
  80139e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ad:	eb 1a                	jmp    8013c9 <fd_alloc+0x72>
  8013af:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013b4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013b9:	75 b6                	jne    801371 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013c4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013d1:	83 f8 1f             	cmp    $0x1f,%eax
  8013d4:	77 36                	ja     80140c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013d6:	c1 e0 0c             	shl    $0xc,%eax
  8013d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013de:	89 c2                	mov    %eax,%edx
  8013e0:	c1 ea 16             	shr    $0x16,%edx
  8013e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ea:	f6 c2 01             	test   $0x1,%dl
  8013ed:	74 24                	je     801413 <fd_lookup+0x48>
  8013ef:	89 c2                	mov    %eax,%edx
  8013f1:	c1 ea 0c             	shr    $0xc,%edx
  8013f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013fb:	f6 c2 01             	test   $0x1,%dl
  8013fe:	74 1a                	je     80141a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801400:	8b 55 0c             	mov    0xc(%ebp),%edx
  801403:	89 02                	mov    %eax,(%edx)
	return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
  80140a:	eb 13                	jmp    80141f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80140c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801411:	eb 0c                	jmp    80141f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801413:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801418:	eb 05                	jmp    80141f <fd_lookup+0x54>
  80141a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 14             	sub    $0x14,%esp
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80142e:	39 05 90 57 80 00    	cmp    %eax,0x805790
  801434:	75 1e                	jne    801454 <dev_lookup+0x33>
  801436:	eb 0e                	jmp    801446 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801438:	b8 ac 57 80 00       	mov    $0x8057ac,%eax
  80143d:	eb 0c                	jmp    80144b <dev_lookup+0x2a>
  80143f:	b8 70 57 80 00       	mov    $0x805770,%eax
  801444:	eb 05                	jmp    80144b <dev_lookup+0x2a>
  801446:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80144b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80144d:	b8 00 00 00 00       	mov    $0x0,%eax
  801452:	eb 38                	jmp    80148c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801454:	39 05 ac 57 80 00    	cmp    %eax,0x8057ac
  80145a:	74 dc                	je     801438 <dev_lookup+0x17>
  80145c:	39 05 70 57 80 00    	cmp    %eax,0x805770
  801462:	74 db                	je     80143f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801464:	8b 15 90 77 80 00    	mov    0x807790,%edx
  80146a:	8b 52 48             	mov    0x48(%edx),%edx
  80146d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801471:	89 54 24 04          	mov    %edx,0x4(%esp)
  801475:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  80147c:	e8 2f f1 ff ff       	call   8005b0 <cprintf>
	*dev = 0;
  801481:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80148c:	83 c4 14             	add    $0x14,%esp
  80148f:	5b                   	pop    %ebx
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    

00801492 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	56                   	push   %esi
  801496:	53                   	push   %ebx
  801497:	83 ec 20             	sub    $0x20,%esp
  80149a:	8b 75 08             	mov    0x8(%ebp),%esi
  80149d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014ad:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014b0:	89 04 24             	mov    %eax,(%esp)
  8014b3:	e8 13 ff ff ff       	call   8013cb <fd_lookup>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 05                	js     8014c1 <fd_close+0x2f>
	    || fd != fd2)
  8014bc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014bf:	74 0c                	je     8014cd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014c1:	84 db                	test   %bl,%bl
  8014c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c8:	0f 44 c2             	cmove  %edx,%eax
  8014cb:	eb 3f                	jmp    80150c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d4:	8b 06                	mov    (%esi),%eax
  8014d6:	89 04 24             	mov    %eax,(%esp)
  8014d9:	e8 43 ff ff ff       	call   801421 <dev_lookup>
  8014de:	89 c3                	mov    %eax,%ebx
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 16                	js     8014fa <fd_close+0x68>
		if (dev->dev_close)
  8014e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014ea:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	74 07                	je     8014fa <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014f3:	89 34 24             	mov    %esi,(%esp)
  8014f6:	ff d0                	call   *%eax
  8014f8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014fa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801505:	e8 56 fc ff ff       	call   801160 <sys_page_unmap>
	return r;
  80150a:	89 d8                	mov    %ebx,%eax
}
  80150c:	83 c4 20             	add    $0x20,%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801519:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 04 24             	mov    %eax,(%esp)
  801526:	e8 a0 fe ff ff       	call   8013cb <fd_lookup>
  80152b:	89 c2                	mov    %eax,%edx
  80152d:	85 d2                	test   %edx,%edx
  80152f:	78 13                	js     801544 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801531:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801538:	00 
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	89 04 24             	mov    %eax,(%esp)
  80153f:	e8 4e ff ff ff       	call   801492 <fd_close>
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <close_all>:

void
close_all(void)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	53                   	push   %ebx
  80154a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80154d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801552:	89 1c 24             	mov    %ebx,(%esp)
  801555:	e8 b9 ff ff ff       	call   801513 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80155a:	83 c3 01             	add    $0x1,%ebx
  80155d:	83 fb 20             	cmp    $0x20,%ebx
  801560:	75 f0                	jne    801552 <close_all+0xc>
		close(i);
}
  801562:	83 c4 14             	add    $0x14,%esp
  801565:	5b                   	pop    %ebx
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    

00801568 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	57                   	push   %edi
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801571:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801574:	89 44 24 04          	mov    %eax,0x4(%esp)
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	89 04 24             	mov    %eax,(%esp)
  80157e:	e8 48 fe ff ff       	call   8013cb <fd_lookup>
  801583:	89 c2                	mov    %eax,%edx
  801585:	85 d2                	test   %edx,%edx
  801587:	0f 88 e1 00 00 00    	js     80166e <dup+0x106>
		return r;
	close(newfdnum);
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	89 04 24             	mov    %eax,(%esp)
  801593:	e8 7b ff ff ff       	call   801513 <close>

	newfd = INDEX2FD(newfdnum);
  801598:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80159b:	c1 e3 0c             	shl    $0xc,%ebx
  80159e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a7:	89 04 24             	mov    %eax,(%esp)
  8015aa:	e8 91 fd ff ff       	call   801340 <fd2data>
  8015af:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015b1:	89 1c 24             	mov    %ebx,(%esp)
  8015b4:	e8 87 fd ff ff       	call   801340 <fd2data>
  8015b9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015bb:	89 f0                	mov    %esi,%eax
  8015bd:	c1 e8 16             	shr    $0x16,%eax
  8015c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c7:	a8 01                	test   $0x1,%al
  8015c9:	74 43                	je     80160e <dup+0xa6>
  8015cb:	89 f0                	mov    %esi,%eax
  8015cd:	c1 e8 0c             	shr    $0xc,%eax
  8015d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015d7:	f6 c2 01             	test   $0x1,%dl
  8015da:	74 32                	je     80160e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f7:	00 
  8015f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801603:	e8 05 fb ff ff       	call   80110d <sys_page_map>
  801608:	89 c6                	mov    %eax,%esi
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 3e                	js     80164c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80160e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801611:	89 c2                	mov    %eax,%edx
  801613:	c1 ea 0c             	shr    $0xc,%edx
  801616:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80161d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801623:	89 54 24 10          	mov    %edx,0x10(%esp)
  801627:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80162b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801632:	00 
  801633:	89 44 24 04          	mov    %eax,0x4(%esp)
  801637:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163e:	e8 ca fa ff ff       	call   80110d <sys_page_map>
  801643:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801645:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801648:	85 f6                	test   %esi,%esi
  80164a:	79 22                	jns    80166e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80164c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801657:	e8 04 fb ff ff       	call   801160 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80165c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801667:	e8 f4 fa ff ff       	call   801160 <sys_page_unmap>
	return r;
  80166c:	89 f0                	mov    %esi,%eax
}
  80166e:	83 c4 3c             	add    $0x3c,%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 24             	sub    $0x24,%esp
  80167d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801680:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801683:	89 44 24 04          	mov    %eax,0x4(%esp)
  801687:	89 1c 24             	mov    %ebx,(%esp)
  80168a:	e8 3c fd ff ff       	call   8013cb <fd_lookup>
  80168f:	89 c2                	mov    %eax,%edx
  801691:	85 d2                	test   %edx,%edx
  801693:	78 6d                	js     801702 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801695:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801698:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169f:	8b 00                	mov    (%eax),%eax
  8016a1:	89 04 24             	mov    %eax,(%esp)
  8016a4:	e8 78 fd ff ff       	call   801421 <dev_lookup>
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	78 55                	js     801702 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 50 08             	mov    0x8(%eax),%edx
  8016b3:	83 e2 03             	and    $0x3,%edx
  8016b6:	83 fa 01             	cmp    $0x1,%edx
  8016b9:	75 23                	jne    8016de <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016bb:	a1 90 77 80 00       	mov    0x807790,%eax
  8016c0:	8b 40 48             	mov    0x48(%eax),%eax
  8016c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	c7 04 24 ed 2e 80 00 	movl   $0x802eed,(%esp)
  8016d2:	e8 d9 ee ff ff       	call   8005b0 <cprintf>
		return -E_INVAL;
  8016d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016dc:	eb 24                	jmp    801702 <read+0x8c>
	}
	if (!dev->dev_read)
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	8b 52 08             	mov    0x8(%edx),%edx
  8016e4:	85 d2                	test   %edx,%edx
  8016e6:	74 15                	je     8016fd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016f6:	89 04 24             	mov    %eax,(%esp)
  8016f9:	ff d2                	call   *%edx
  8016fb:	eb 05                	jmp    801702 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801702:	83 c4 24             	add    $0x24,%esp
  801705:	5b                   	pop    %ebx
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	57                   	push   %edi
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	83 ec 1c             	sub    $0x1c,%esp
  801711:	8b 7d 08             	mov    0x8(%ebp),%edi
  801714:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801717:	85 f6                	test   %esi,%esi
  801719:	74 33                	je     80174e <readn+0x46>
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
  801720:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801725:	89 f2                	mov    %esi,%edx
  801727:	29 c2                	sub    %eax,%edx
  801729:	89 54 24 08          	mov    %edx,0x8(%esp)
  80172d:	03 45 0c             	add    0xc(%ebp),%eax
  801730:	89 44 24 04          	mov    %eax,0x4(%esp)
  801734:	89 3c 24             	mov    %edi,(%esp)
  801737:	e8 3a ff ff ff       	call   801676 <read>
		if (m < 0)
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 1b                	js     80175b <readn+0x53>
			return m;
		if (m == 0)
  801740:	85 c0                	test   %eax,%eax
  801742:	74 11                	je     801755 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801744:	01 c3                	add    %eax,%ebx
  801746:	89 d8                	mov    %ebx,%eax
  801748:	39 f3                	cmp    %esi,%ebx
  80174a:	72 d9                	jb     801725 <readn+0x1d>
  80174c:	eb 0b                	jmp    801759 <readn+0x51>
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	eb 06                	jmp    80175b <readn+0x53>
  801755:	89 d8                	mov    %ebx,%eax
  801757:	eb 02                	jmp    80175b <readn+0x53>
  801759:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80175b:	83 c4 1c             	add    $0x1c,%esp
  80175e:	5b                   	pop    %ebx
  80175f:	5e                   	pop    %esi
  801760:	5f                   	pop    %edi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    

00801763 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	53                   	push   %ebx
  801767:	83 ec 24             	sub    $0x24,%esp
  80176a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	89 1c 24             	mov    %ebx,(%esp)
  801777:	e8 4f fc ff ff       	call   8013cb <fd_lookup>
  80177c:	89 c2                	mov    %eax,%edx
  80177e:	85 d2                	test   %edx,%edx
  801780:	78 68                	js     8017ea <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801782:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801785:	89 44 24 04          	mov    %eax,0x4(%esp)
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178c:	8b 00                	mov    (%eax),%eax
  80178e:	89 04 24             	mov    %eax,(%esp)
  801791:	e8 8b fc ff ff       	call   801421 <dev_lookup>
  801796:	85 c0                	test   %eax,%eax
  801798:	78 50                	js     8017ea <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017a1:	75 23                	jne    8017c6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a3:	a1 90 77 80 00       	mov    0x807790,%eax
  8017a8:	8b 40 48             	mov    0x48(%eax),%eax
  8017ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b3:	c7 04 24 09 2f 80 00 	movl   $0x802f09,(%esp)
  8017ba:	e8 f1 ed ff ff       	call   8005b0 <cprintf>
		return -E_INVAL;
  8017bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c4:	eb 24                	jmp    8017ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	74 15                	je     8017e5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017de:	89 04 24             	mov    %eax,(%esp)
  8017e1:	ff d2                	call   *%edx
  8017e3:	eb 05                	jmp    8017ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017ea:	83 c4 24             	add    $0x24,%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	89 04 24             	mov    %eax,(%esp)
  801803:	e8 c3 fb ff ff       	call   8013cb <fd_lookup>
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 0e                	js     80181a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80180c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	53                   	push   %ebx
  801820:	83 ec 24             	sub    $0x24,%esp
  801823:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801826:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182d:	89 1c 24             	mov    %ebx,(%esp)
  801830:	e8 96 fb ff ff       	call   8013cb <fd_lookup>
  801835:	89 c2                	mov    %eax,%edx
  801837:	85 d2                	test   %edx,%edx
  801839:	78 61                	js     80189c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 d2 fb ff ff       	call   801421 <dev_lookup>
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 49                	js     80189c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801856:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80185a:	75 23                	jne    80187f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80185c:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801861:	8b 40 48             	mov    0x48(%eax),%eax
  801864:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186c:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801873:	e8 38 ed ff ff       	call   8005b0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187d:	eb 1d                	jmp    80189c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	8b 52 18             	mov    0x18(%edx),%edx
  801885:	85 d2                	test   %edx,%edx
  801887:	74 0e                	je     801897 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801890:	89 04 24             	mov    %eax,(%esp)
  801893:	ff d2                	call   *%edx
  801895:	eb 05                	jmp    80189c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801897:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80189c:	83 c4 24             	add    $0x24,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    

008018a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 24             	sub    $0x24,%esp
  8018a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	89 04 24             	mov    %eax,(%esp)
  8018b9:	e8 0d fb ff ff       	call   8013cb <fd_lookup>
  8018be:	89 c2                	mov    %eax,%edx
  8018c0:	85 d2                	test   %edx,%edx
  8018c2:	78 52                	js     801916 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ce:	8b 00                	mov    (%eax),%eax
  8018d0:	89 04 24             	mov    %eax,(%esp)
  8018d3:	e8 49 fb ff ff       	call   801421 <dev_lookup>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 3a                	js     801916 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e3:	74 2c                	je     801911 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ef:	00 00 00 
	stat->st_isdir = 0;
  8018f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018f9:	00 00 00 
	stat->st_dev = dev;
  8018fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801902:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801909:	89 14 24             	mov    %edx,(%esp)
  80190c:	ff 50 14             	call   *0x14(%eax)
  80190f:	eb 05                	jmp    801916 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801911:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801916:	83 c4 24             	add    $0x24,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
  801921:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801924:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80192b:	00 
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 e1 01 00 00       	call   801b18 <open>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	85 db                	test   %ebx,%ebx
  80193b:	78 1b                	js     801958 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	89 1c 24             	mov    %ebx,(%esp)
  801947:	e8 56 ff ff ff       	call   8018a2 <fstat>
  80194c:	89 c6                	mov    %eax,%esi
	close(fd);
  80194e:	89 1c 24             	mov    %ebx,(%esp)
  801951:	e8 bd fb ff ff       	call   801513 <close>
	return r;
  801956:	89 f0                	mov    %esi,%eax
}
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 10             	sub    $0x10,%esp
  801967:	89 c3                	mov    %eax,%ebx
  801969:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80196b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801972:	75 11                	jne    801985 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80197b:	e8 59 0d 00 00       	call   8026d9 <ipc_find_env>
  801980:	a3 00 60 80 00       	mov    %eax,0x806000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801985:	a1 90 77 80 00       	mov    0x807790,%eax
  80198a:	8b 40 48             	mov    0x48(%eax),%eax
  80198d:	8b 15 00 80 80 00    	mov    0x808000,%edx
  801993:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801997:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80199b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199f:	c7 04 24 26 2f 80 00 	movl   $0x802f26,(%esp)
  8019a6:	e8 05 ec ff ff       	call   8005b0 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019ab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019b2:	00 
  8019b3:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8019ba:	00 
  8019bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019bf:	a1 00 60 80 00       	mov    0x806000,%eax
  8019c4:	89 04 24             	mov    %eax,(%esp)
  8019c7:	e8 a7 0c 00 00       	call   802673 <ipc_send>
	cprintf("ipc_send\n");
  8019cc:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8019d3:	e8 d8 eb ff ff       	call   8005b0 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  8019d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019df:	00 
  8019e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019eb:	e8 1b 0c 00 00       	call   80260b <ipc_recv>
}
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 14             	sub    $0x14,%esp
  8019fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 40 0c             	mov    0xc(%eax),%eax
  801a07:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a11:	b8 05 00 00 00       	mov    $0x5,%eax
  801a16:	e8 44 ff ff ff       	call   80195f <fsipc>
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	85 d2                	test   %edx,%edx
  801a1f:	78 2b                	js     801a4c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a21:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801a28:	00 
  801a29:	89 1c 24             	mov    %ebx,(%esp)
  801a2c:	e8 da f1 ff ff       	call   800c0b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a31:	a1 80 80 80 00       	mov    0x808080,%eax
  801a36:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a3c:	a1 84 80 80 00       	mov    0x808084,%eax
  801a41:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4c:	83 c4 14             	add    $0x14,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5e:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801a63:	ba 00 00 00 00       	mov    $0x0,%edx
  801a68:	b8 06 00 00 00       	mov    $0x6,%eax
  801a6d:	e8 ed fe ff ff       	call   80195f <fsipc>
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	56                   	push   %esi
  801a78:	53                   	push   %ebx
  801a79:	83 ec 10             	sub    $0x10,%esp
  801a7c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8b 40 0c             	mov    0xc(%eax),%eax
  801a85:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801a8a:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a90:	ba 00 00 00 00       	mov    $0x0,%edx
  801a95:	b8 03 00 00 00       	mov    $0x3,%eax
  801a9a:	e8 c0 fe ff ff       	call   80195f <fsipc>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 6a                	js     801b0f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801aa5:	39 c6                	cmp    %eax,%esi
  801aa7:	73 24                	jae    801acd <devfile_read+0x59>
  801aa9:	c7 44 24 0c 46 2f 80 	movl   $0x802f46,0xc(%esp)
  801ab0:	00 
  801ab1:	c7 44 24 08 4d 2f 80 	movl   $0x802f4d,0x8(%esp)
  801ab8:	00 
  801ab9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801ac0:	00 
  801ac1:	c7 04 24 62 2f 80 00 	movl   $0x802f62,(%esp)
  801ac8:	e8 ea e9 ff ff       	call   8004b7 <_panic>
	assert(r <= PGSIZE);
  801acd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad2:	7e 24                	jle    801af8 <devfile_read+0x84>
  801ad4:	c7 44 24 0c 6d 2f 80 	movl   $0x802f6d,0xc(%esp)
  801adb:	00 
  801adc:	c7 44 24 08 4d 2f 80 	movl   $0x802f4d,0x8(%esp)
  801ae3:	00 
  801ae4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801aeb:	00 
  801aec:	c7 04 24 62 2f 80 00 	movl   $0x802f62,(%esp)
  801af3:	e8 bf e9 ff ff       	call   8004b7 <_panic>
	memmove(buf, &fsipcbuf, r);
  801af8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801afc:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b03:	00 
  801b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 f7 f2 ff ff       	call   800e06 <memmove>
	return r;
}
  801b0f:	89 d8                	mov    %ebx,%eax
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    

00801b18 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	53                   	push   %ebx
  801b1c:	83 ec 24             	sub    $0x24,%esp
  801b1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b22:	89 1c 24             	mov    %ebx,(%esp)
  801b25:	e8 86 f0 ff ff       	call   800bb0 <strlen>
  801b2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b2f:	7f 60                	jg     801b91 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b34:	89 04 24             	mov    %eax,(%esp)
  801b37:	e8 1b f8 ff ff       	call   801357 <fd_alloc>
  801b3c:	89 c2                	mov    %eax,%edx
  801b3e:	85 d2                	test   %edx,%edx
  801b40:	78 54                	js     801b96 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b46:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801b4d:	e8 b9 f0 ff ff       	call   800c0b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b62:	e8 f8 fd ff ff       	call   80195f <fsipc>
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	79 17                	jns    801b84 <open+0x6c>
		fd_close(fd, 0);
  801b6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b74:	00 
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	89 04 24             	mov    %eax,(%esp)
  801b7b:	e8 12 f9 ff ff       	call   801492 <fd_close>
		return r;
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	eb 12                	jmp    801b96 <open+0x7e>
	}
	return fd2num(fd);
  801b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b87:	89 04 24             	mov    %eax,(%esp)
  801b8a:	e8 a1 f7 ff ff       	call   801330 <fd2num>
  801b8f:	eb 05                	jmp    801b96 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b91:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801b96:	83 c4 24             	add    $0x24,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
  801b9c:	66 90                	xchg   %ax,%ax
  801b9e:	66 90                	xchg   %ax,%ax

00801ba0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	57                   	push   %edi
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  801bac:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  801bb3:	e8 f8 e9 ff ff       	call   8005b0 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  801bb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bbf:	00 
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 4d ff ff ff       	call   801b18 <open>
  801bcb:	89 c7                	mov    %eax,%edi
  801bcd:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	0f 88 09 05 00 00    	js     8020e4 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  801bdb:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  801be2:	e8 c9 e9 ff ff       	call   8005b0 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801be7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801bee:	00 
  801bef:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf9:	89 3c 24             	mov    %edi,(%esp)
  801bfc:	e8 07 fb ff ff       	call   801708 <readn>
  801c01:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c06:	75 0c                	jne    801c14 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  801c08:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c0f:	45 4c 46 
  801c12:	74 36                	je     801c4a <spawn+0xaa>
		close(fd);
  801c14:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c1a:	89 04 24             	mov    %eax,(%esp)
  801c1d:	e8 f1 f8 ff ff       	call   801513 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c22:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801c29:	46 
  801c2a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c34:	c7 04 24 92 2f 80 00 	movl   $0x802f92,(%esp)
  801c3b:	e8 70 e9 ff ff       	call   8005b0 <cprintf>
		return -E_NOT_EXEC;
  801c40:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801c45:	e9 f9 04 00 00       	jmp    802143 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  801c4a:	c7 04 24 ac 2f 80 00 	movl   $0x802fac,(%esp)
  801c51:	e8 5a e9 ff ff       	call   8005b0 <cprintf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801c56:	b8 07 00 00 00       	mov    $0x7,%eax
  801c5b:	cd 30                	int    $0x30
  801c5d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c63:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	0f 88 7b 04 00 00    	js     8020ec <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c71:	89 c6                	mov    %eax,%esi
  801c73:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801c79:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801c7c:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c82:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c88:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c8f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c95:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  801c9b:	c7 04 24 b9 2f 80 00 	movl   $0x802fb9,(%esp)
  801ca2:	e8 09 e9 ff ff       	call   8005b0 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	85 c0                	test   %eax,%eax
  801cae:	74 38                	je     801ce8 <spawn+0x148>
  801cb0:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801cb5:	be 00 00 00 00       	mov    $0x0,%esi
  801cba:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801cbd:	89 04 24             	mov    %eax,(%esp)
  801cc0:	e8 eb ee ff ff       	call   800bb0 <strlen>
  801cc5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801cc9:	83 c3 01             	add    $0x1,%ebx
  801ccc:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801cd3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	75 e3                	jne    801cbd <spawn+0x11d>
  801cda:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801ce0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ce6:	eb 1e                	jmp    801d06 <spawn+0x166>
  801ce8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  801cef:	00 00 00 
  801cf2:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  801cf9:	00 00 00 
  801cfc:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d01:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d06:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d0b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d0d:	89 fa                	mov    %edi,%edx
  801d0f:	83 e2 fc             	and    $0xfffffffc,%edx
  801d12:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d19:	29 c2                	sub    %eax,%edx
  801d1b:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d21:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d24:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801d29:	0f 86 cd 03 00 00    	jbe    8020fc <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d2f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d36:	00 
  801d37:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d3e:	00 
  801d3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d46:	e8 6e f3 ff ff       	call   8010b9 <sys_page_alloc>
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 88 f0 03 00 00    	js     802143 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d53:	85 db                	test   %ebx,%ebx
  801d55:	7e 46                	jle    801d9d <spawn+0x1fd>
  801d57:	be 00 00 00 00       	mov    $0x0,%esi
  801d5c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  801d65:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d6b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801d71:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801d74:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	89 3c 24             	mov    %edi,(%esp)
  801d7e:	e8 88 ee ff ff       	call   800c0b <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d83:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 22 ee ff ff       	call   800bb0 <strlen>
  801d8e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d92:	83 c6 01             	add    $0x1,%esi
  801d95:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  801d9b:	75 c8                	jne    801d65 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801d9d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801da3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801da9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801db0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801db6:	74 24                	je     801ddc <spawn+0x23c>
  801db8:	c7 44 24 0c 2c 30 80 	movl   $0x80302c,0xc(%esp)
  801dbf:	00 
  801dc0:	c7 44 24 08 4d 2f 80 	movl   $0x802f4d,0x8(%esp)
  801dc7:	00 
  801dc8:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  801dcf:	00 
  801dd0:	c7 04 24 c5 2f 80 00 	movl   $0x802fc5,(%esp)
  801dd7:	e8 db e6 ff ff       	call   8004b7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ddc:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801de2:	89 c8                	mov    %ecx,%eax
  801de4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801de9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801dec:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801df2:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801df5:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801dfb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e01:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e08:	00 
  801e09:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801e10:	ee 
  801e11:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e17:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e1b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e22:	00 
  801e23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2a:	e8 de f2 ff ff       	call   80110d <sys_page_map>
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	85 c0                	test   %eax,%eax
  801e33:	0f 88 f4 02 00 00    	js     80212d <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801e39:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e40:	00 
  801e41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e48:	e8 13 f3 ff ff       	call   801160 <sys_page_unmap>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	0f 88 d6 02 00 00    	js     80212d <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  801e57:	c7 04 24 d1 2f 80 00 	movl   $0x802fd1,(%esp)
  801e5e:	e8 4d e7 ff ff       	call   8005b0 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801e63:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801e69:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801e70:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e76:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801e7d:	00 
  801e7e:	0f 84 dc 01 00 00    	je     802060 <spawn+0x4c0>
  801e84:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801e8b:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  801e8e:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801e94:	83 38 01             	cmpl   $0x1,(%eax)
  801e97:	0f 85 a2 01 00 00    	jne    80203f <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e9d:	89 c1                	mov    %eax,%ecx
  801e9f:	8b 40 18             	mov    0x18(%eax),%eax
  801ea2:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801ea5:	83 f8 01             	cmp    $0x1,%eax
  801ea8:	19 c0                	sbb    %eax,%eax
  801eaa:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801eb0:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  801eb7:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ebe:	89 c8                	mov    %ecx,%eax
  801ec0:	8b 51 04             	mov    0x4(%ecx),%edx
  801ec3:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801ec9:	8b 79 10             	mov    0x10(%ecx),%edi
  801ecc:	8b 49 14             	mov    0x14(%ecx),%ecx
  801ecf:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801ed5:	8b 40 08             	mov    0x8(%eax),%eax
  801ed8:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801ede:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ee3:	74 14                	je     801ef9 <spawn+0x359>
		va -= i;
  801ee5:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  801eeb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801ef1:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801ef3:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801ef9:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801f00:	0f 84 39 01 00 00    	je     80203f <spawn+0x49f>
  801f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0b:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801f10:	39 f7                	cmp    %esi,%edi
  801f12:	77 31                	ja     801f45 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f14:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1e:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801f24:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f28:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f2e:	89 04 24             	mov    %eax,(%esp)
  801f31:	e8 83 f1 ff ff       	call   8010b9 <sys_page_alloc>
  801f36:	85 c0                	test   %eax,%eax
  801f38:	0f 89 ed 00 00 00    	jns    80202b <spawn+0x48b>
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	e9 c8 01 00 00       	jmp    80210d <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f45:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f4c:	00 
  801f4d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f54:	00 
  801f55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5c:	e8 58 f1 ff ff       	call   8010b9 <sys_page_alloc>
  801f61:	85 c0                	test   %eax,%eax
  801f63:	0f 88 9a 01 00 00    	js     802103 <spawn+0x563>
  801f69:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f6f:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f75:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f7b:	89 04 24             	mov    %eax,(%esp)
  801f7e:	e8 6d f8 ff ff       	call   8017f0 <seek>
  801f83:	85 c0                	test   %eax,%eax
  801f85:	0f 88 7c 01 00 00    	js     802107 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801f8b:	89 fa                	mov    %edi,%edx
  801f8d:	29 f2                	sub    %esi,%edx
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  801f97:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f9c:	0f 47 c1             	cmova  %ecx,%eax
  801f9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801faa:	00 
  801fab:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 4f f7 ff ff       	call   801708 <readn>
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	0f 88 4a 01 00 00    	js     80210b <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801fc1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  801fcb:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801fd1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801fd5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801fdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fdf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fe6:	00 
  801fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fee:	e8 1a f1 ff ff       	call   80110d <sys_page_map>
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	79 20                	jns    802017 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  801ff7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ffb:	c7 44 24 08 de 2f 80 	movl   $0x802fde,0x8(%esp)
  802002:	00 
  802003:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  80200a:	00 
  80200b:	c7 04 24 c5 2f 80 00 	movl   $0x802fc5,(%esp)
  802012:	e8 a0 e4 ff ff       	call   8004b7 <_panic>
			sys_page_unmap(0, UTEMP);
  802017:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80201e:	00 
  80201f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802026:	e8 35 f1 ff ff       	call   801160 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80202b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802031:	89 de                	mov    %ebx,%esi
  802033:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802039:	0f 82 d1 fe ff ff    	jb     801f10 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80203f:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802046:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  80204d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802054:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  80205a:	0f 8f 2e fe ff ff    	jg     801e8e <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802060:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802066:	89 04 24             	mov    %eax,(%esp)
  802069:	e8 a5 f4 ff ff       	call   801513 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80206e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 80 f1 ff ff       	call   801206 <sys_env_set_trapframe>
  802086:	85 c0                	test   %eax,%eax
  802088:	79 20                	jns    8020aa <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  80208a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80208e:	c7 44 24 08 fb 2f 80 	movl   $0x802ffb,0x8(%esp)
  802095:	00 
  802096:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80209d:	00 
  80209e:	c7 04 24 c5 2f 80 00 	movl   $0x802fc5,(%esp)
  8020a5:	e8 0d e4 ff ff       	call   8004b7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8020aa:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8020b1:	00 
  8020b2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 f3 f0 ff ff       	call   8011b3 <sys_env_set_status>
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	79 30                	jns    8020f4 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  8020c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020c8:	c7 44 24 08 15 30 80 	movl   $0x803015,0x8(%esp)
  8020cf:	00 
  8020d0:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  8020d7:	00 
  8020d8:	c7 04 24 c5 2f 80 00 	movl   $0x802fc5,(%esp)
  8020df:	e8 d3 e3 ff ff       	call   8004b7 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8020e4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020ea:	eb 57                	jmp    802143 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8020ec:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020f2:	eb 4f                	jmp    802143 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  8020f4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020fa:	eb 47                	jmp    802143 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8020fc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802101:	eb 40                	jmp    802143 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802103:	89 c3                	mov    %eax,%ebx
  802105:	eb 06                	jmp    80210d <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802107:	89 c3                	mov    %eax,%ebx
  802109:	eb 02                	jmp    80210d <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80210b:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  80210d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802113:	89 04 24             	mov    %eax,(%esp)
  802116:	e8 0e ef ff ff       	call   801029 <sys_env_destroy>
	close(fd);
  80211b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802121:	89 04 24             	mov    %eax,(%esp)
  802124:	e8 ea f3 ff ff       	call   801513 <close>
	return r;
  802129:	89 d8                	mov    %ebx,%eax
  80212b:	eb 16                	jmp    802143 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80212d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802134:	00 
  802135:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213c:	e8 1f f0 ff ff       	call   801160 <sys_page_unmap>
  802141:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802143:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802149:	5b                   	pop    %ebx
  80214a:	5e                   	pop    %esi
  80214b:	5f                   	pop    %edi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    

0080214e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	57                   	push   %edi
  802152:	56                   	push   %esi
  802153:	53                   	push   %ebx
  802154:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80215b:	74 61                	je     8021be <spawnl+0x70>
  80215d:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802165:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802168:	83 c0 04             	add    $0x4,%eax
  80216b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80216f:	74 04                	je     802175 <spawnl+0x27>
		argc++;
  802171:	89 ca                	mov    %ecx,%edx
  802173:	eb f0                	jmp    802165 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802175:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  80217c:	83 e0 f0             	and    $0xfffffff0,%eax
  80217f:	29 c4                	sub    %eax,%esp
  802181:	8d 74 24 0b          	lea    0xb(%esp),%esi
  802185:	c1 ee 02             	shr    $0x2,%esi
  802188:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  80218f:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802191:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802194:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  80219b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  8021a2:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8021a3:	89 ce                	mov    %ecx,%esi
  8021a5:	85 c9                	test   %ecx,%ecx
  8021a7:	74 25                	je     8021ce <spawnl+0x80>
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  8021ae:	83 c0 01             	add    $0x1,%eax
  8021b1:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  8021b5:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8021b8:	39 f0                	cmp    %esi,%eax
  8021ba:	75 f2                	jne    8021ae <spawnl+0x60>
  8021bc:	eb 10                	jmp    8021ce <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  8021be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  8021c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8021cb:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8021ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	89 04 24             	mov    %eax,(%esp)
  8021d8:	e8 c3 f9 ff ff       	call   801ba0 <spawn>
}
  8021dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	66 90                	xchg   %ax,%ax
  8021e7:	66 90                	xchg   %ax,%ax
  8021e9:	66 90                	xchg   %ax,%ax
  8021eb:	66 90                	xchg   %ax,%ax
  8021ed:	66 90                	xchg   %ax,%ax
  8021ef:	90                   	nop

008021f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	56                   	push   %esi
  8021f4:	53                   	push   %ebx
  8021f5:	83 ec 10             	sub    $0x10,%esp
  8021f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	89 04 24             	mov    %eax,(%esp)
  802201:	e8 3a f1 ff ff       	call   801340 <fd2data>
  802206:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802208:	c7 44 24 04 54 30 80 	movl   $0x803054,0x4(%esp)
  80220f:	00 
  802210:	89 1c 24             	mov    %ebx,(%esp)
  802213:	e8 f3 e9 ff ff       	call   800c0b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802218:	8b 46 04             	mov    0x4(%esi),%eax
  80221b:	2b 06                	sub    (%esi),%eax
  80221d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802223:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80222a:	00 00 00 
	stat->st_dev = &devpipe;
  80222d:	c7 83 88 00 00 00 ac 	movl   $0x8057ac,0x88(%ebx)
  802234:	57 80 00 
	return 0;
}
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    

00802243 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	53                   	push   %ebx
  802247:	83 ec 14             	sub    $0x14,%esp
  80224a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80224d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 03 ef ff ff       	call   801160 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80225d:	89 1c 24             	mov    %ebx,(%esp)
  802260:	e8 db f0 ff ff       	call   801340 <fd2data>
  802265:	89 44 24 04          	mov    %eax,0x4(%esp)
  802269:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802270:	e8 eb ee ff ff       	call   801160 <sys_page_unmap>
}
  802275:	83 c4 14             	add    $0x14,%esp
  802278:	5b                   	pop    %ebx
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	57                   	push   %edi
  80227f:	56                   	push   %esi
  802280:	53                   	push   %ebx
  802281:	83 ec 2c             	sub    $0x2c,%esp
  802284:	89 c6                	mov    %eax,%esi
  802286:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802289:	a1 90 77 80 00       	mov    0x807790,%eax
  80228e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802291:	89 34 24             	mov    %esi,(%esp)
  802294:	e8 88 04 00 00       	call   802721 <pageref>
  802299:	89 c7                	mov    %eax,%edi
  80229b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 7b 04 00 00       	call   802721 <pageref>
  8022a6:	39 c7                	cmp    %eax,%edi
  8022a8:	0f 94 c2             	sete   %dl
  8022ab:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022ae:	8b 0d 90 77 80 00    	mov    0x807790,%ecx
  8022b4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022b7:	39 fb                	cmp    %edi,%ebx
  8022b9:	74 21                	je     8022dc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022bb:	84 d2                	test   %dl,%dl
  8022bd:	74 ca                	je     802289 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022bf:	8b 51 58             	mov    0x58(%ecx),%edx
  8022c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ce:	c7 04 24 5b 30 80 00 	movl   $0x80305b,(%esp)
  8022d5:	e8 d6 e2 ff ff       	call   8005b0 <cprintf>
  8022da:	eb ad                	jmp    802289 <_pipeisclosed+0xe>
	}
}
  8022dc:	83 c4 2c             	add    $0x2c,%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	57                   	push   %edi
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 1c             	sub    $0x1c,%esp
  8022ed:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022f0:	89 34 24             	mov    %esi,(%esp)
  8022f3:	e8 48 f0 ff ff       	call   801340 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fc:	74 61                	je     80235f <devpipe_write+0x7b>
  8022fe:	89 c3                	mov    %eax,%ebx
  802300:	bf 00 00 00 00       	mov    $0x0,%edi
  802305:	eb 4a                	jmp    802351 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802307:	89 da                	mov    %ebx,%edx
  802309:	89 f0                	mov    %esi,%eax
  80230b:	e8 6b ff ff ff       	call   80227b <_pipeisclosed>
  802310:	85 c0                	test   %eax,%eax
  802312:	75 54                	jne    802368 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802314:	e8 81 ed ff ff       	call   80109a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802319:	8b 43 04             	mov    0x4(%ebx),%eax
  80231c:	8b 0b                	mov    (%ebx),%ecx
  80231e:	8d 51 20             	lea    0x20(%ecx),%edx
  802321:	39 d0                	cmp    %edx,%eax
  802323:	73 e2                	jae    802307 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802328:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80232c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80232f:	99                   	cltd   
  802330:	c1 ea 1b             	shr    $0x1b,%edx
  802333:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802336:	83 e1 1f             	and    $0x1f,%ecx
  802339:	29 d1                	sub    %edx,%ecx
  80233b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80233f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802343:	83 c0 01             	add    $0x1,%eax
  802346:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802349:	83 c7 01             	add    $0x1,%edi
  80234c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80234f:	74 13                	je     802364 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802351:	8b 43 04             	mov    0x4(%ebx),%eax
  802354:	8b 0b                	mov    (%ebx),%ecx
  802356:	8d 51 20             	lea    0x20(%ecx),%edx
  802359:	39 d0                	cmp    %edx,%eax
  80235b:	73 aa                	jae    802307 <devpipe_write+0x23>
  80235d:	eb c6                	jmp    802325 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80235f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802364:	89 f8                	mov    %edi,%eax
  802366:	eb 05                	jmp    80236d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    

00802375 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	57                   	push   %edi
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	83 ec 1c             	sub    $0x1c,%esp
  80237e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802381:	89 3c 24             	mov    %edi,(%esp)
  802384:	e8 b7 ef ff ff       	call   801340 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80238d:	74 54                	je     8023e3 <devpipe_read+0x6e>
  80238f:	89 c3                	mov    %eax,%ebx
  802391:	be 00 00 00 00       	mov    $0x0,%esi
  802396:	eb 3e                	jmp    8023d6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802398:	89 f0                	mov    %esi,%eax
  80239a:	eb 55                	jmp    8023f1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80239c:	89 da                	mov    %ebx,%edx
  80239e:	89 f8                	mov    %edi,%eax
  8023a0:	e8 d6 fe ff ff       	call   80227b <_pipeisclosed>
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 43                	jne    8023ec <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023a9:	e8 ec ec ff ff       	call   80109a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023ae:	8b 03                	mov    (%ebx),%eax
  8023b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023b3:	74 e7                	je     80239c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b5:	99                   	cltd   
  8023b6:	c1 ea 1b             	shr    $0x1b,%edx
  8023b9:	01 d0                	add    %edx,%eax
  8023bb:	83 e0 1f             	and    $0x1f,%eax
  8023be:	29 d0                	sub    %edx,%eax
  8023c0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023cb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ce:	83 c6 01             	add    $0x1,%esi
  8023d1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023d4:	74 12                	je     8023e8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8023d6:	8b 03                	mov    (%ebx),%eax
  8023d8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023db:	75 d8                	jne    8023b5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023dd:	85 f6                	test   %esi,%esi
  8023df:	75 b7                	jne    802398 <devpipe_read+0x23>
  8023e1:	eb b9                	jmp    80239c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023e3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023e8:	89 f0                	mov    %esi,%eax
  8023ea:	eb 05                	jmp    8023f1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023f1:	83 c4 1c             	add    $0x1c,%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5f                   	pop    %edi
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    

008023f9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802404:	89 04 24             	mov    %eax,(%esp)
  802407:	e8 4b ef ff ff       	call   801357 <fd_alloc>
  80240c:	89 c2                	mov    %eax,%edx
  80240e:	85 d2                	test   %edx,%edx
  802410:	0f 88 4d 01 00 00    	js     802563 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802416:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80241d:	00 
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 44 24 04          	mov    %eax,0x4(%esp)
  802425:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242c:	e8 88 ec ff ff       	call   8010b9 <sys_page_alloc>
  802431:	89 c2                	mov    %eax,%edx
  802433:	85 d2                	test   %edx,%edx
  802435:	0f 88 28 01 00 00    	js     802563 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80243b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80243e:	89 04 24             	mov    %eax,(%esp)
  802441:	e8 11 ef ff ff       	call   801357 <fd_alloc>
  802446:	89 c3                	mov    %eax,%ebx
  802448:	85 c0                	test   %eax,%eax
  80244a:	0f 88 fe 00 00 00    	js     80254e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802450:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802457:	00 
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802466:	e8 4e ec ff ff       	call   8010b9 <sys_page_alloc>
  80246b:	89 c3                	mov    %eax,%ebx
  80246d:	85 c0                	test   %eax,%eax
  80246f:	0f 88 d9 00 00 00    	js     80254e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	89 04 24             	mov    %eax,(%esp)
  80247b:	e8 c0 ee ff ff       	call   801340 <fd2data>
  802480:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802482:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802489:	00 
  80248a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802495:	e8 1f ec ff ff       	call   8010b9 <sys_page_alloc>
  80249a:	89 c3                	mov    %eax,%ebx
  80249c:	85 c0                	test   %eax,%eax
  80249e:	0f 88 97 00 00 00    	js     80253b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	89 04 24             	mov    %eax,(%esp)
  8024aa:	e8 91 ee ff ff       	call   801340 <fd2data>
  8024af:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024b6:	00 
  8024b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024c2:	00 
  8024c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024ce:	e8 3a ec ff ff       	call   80110d <sys_page_map>
  8024d3:	89 c3                	mov    %eax,%ebx
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	78 52                	js     80252b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024d9:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024ee:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	89 04 24             	mov    %eax,(%esp)
  802509:	e8 22 ee ff ff       	call   801330 <fd2num>
  80250e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802511:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 12 ee ff ff       	call   801330 <fd2num>
  80251e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802521:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
  802529:	eb 38                	jmp    802563 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80252b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80252f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802536:	e8 25 ec ff ff       	call   801160 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802549:	e8 12 ec ff ff       	call   801160 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	89 44 24 04          	mov    %eax,0x4(%esp)
  802555:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255c:	e8 ff eb ff ff       	call   801160 <sys_page_unmap>
  802561:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802563:	83 c4 30             	add    $0x30,%esp
  802566:	5b                   	pop    %ebx
  802567:	5e                   	pop    %esi
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    

0080256a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802573:	89 44 24 04          	mov    %eax,0x4(%esp)
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	89 04 24             	mov    %eax,(%esp)
  80257d:	e8 49 ee ff ff       	call   8013cb <fd_lookup>
  802582:	89 c2                	mov    %eax,%edx
  802584:	85 d2                	test   %edx,%edx
  802586:	78 15                	js     80259d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	89 04 24             	mov    %eax,(%esp)
  80258e:	e8 ad ed ff ff       	call   801340 <fd2data>
	return _pipeisclosed(fd, p);
  802593:	89 c2                	mov    %eax,%edx
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	e8 de fc ff ff       	call   80227b <_pipeisclosed>
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 10             	sub    $0x10,%esp
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	75 24                	jne    8025d2 <wait+0x33>
  8025ae:	c7 44 24 0c 73 30 80 	movl   $0x803073,0xc(%esp)
  8025b5:	00 
  8025b6:	c7 44 24 08 4d 2f 80 	movl   $0x802f4d,0x8(%esp)
  8025bd:	00 
  8025be:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8025c5:	00 
  8025c6:	c7 04 24 7e 30 80 00 	movl   $0x80307e,(%esp)
  8025cd:	e8 e5 de ff ff       	call   8004b7 <_panic>
	e = &envs[ENVX(envid)];
  8025d2:	89 c3                	mov    %eax,%ebx
  8025d4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8025da:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8025dd:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8025e3:	8b 73 48             	mov    0x48(%ebx),%esi
  8025e6:	39 c6                	cmp    %eax,%esi
  8025e8:	75 1a                	jne    802604 <wait+0x65>
  8025ea:	8b 43 54             	mov    0x54(%ebx),%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 13                	je     802604 <wait+0x65>
		sys_yield();
  8025f1:	e8 a4 ea ff ff       	call   80109a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8025f6:	8b 43 48             	mov    0x48(%ebx),%eax
  8025f9:	39 f0                	cmp    %esi,%eax
  8025fb:	75 07                	jne    802604 <wait+0x65>
  8025fd:	8b 43 54             	mov    0x54(%ebx),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	75 ed                	jne    8025f1 <wait+0x52>
		sys_yield();
}
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	5b                   	pop    %ebx
  802608:	5e                   	pop    %esi
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    

0080260b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	83 ec 10             	sub    $0x10,%esp
  802613:	8b 75 08             	mov    0x8(%ebp),%esi
  802616:	8b 45 0c             	mov    0xc(%ebp),%eax
  802619:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  80261c:	85 c0                	test   %eax,%eax
  80261e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802623:	0f 44 c2             	cmove  %edx,%eax
  802626:	89 04 24             	mov    %eax,(%esp)
  802629:	e8 a1 ec ff ff       	call   8012cf <sys_ipc_recv>
	if (err_code < 0) {
  80262e:	85 c0                	test   %eax,%eax
  802630:	79 16                	jns    802648 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802632:	85 f6                	test   %esi,%esi
  802634:	74 06                	je     80263c <ipc_recv+0x31>
  802636:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80263c:	85 db                	test   %ebx,%ebx
  80263e:	74 2c                	je     80266c <ipc_recv+0x61>
  802640:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802646:	eb 24                	jmp    80266c <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802648:	85 f6                	test   %esi,%esi
  80264a:	74 0a                	je     802656 <ipc_recv+0x4b>
  80264c:	a1 90 77 80 00       	mov    0x807790,%eax
  802651:	8b 40 74             	mov    0x74(%eax),%eax
  802654:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802656:	85 db                	test   %ebx,%ebx
  802658:	74 0a                	je     802664 <ipc_recv+0x59>
  80265a:	a1 90 77 80 00       	mov    0x807790,%eax
  80265f:	8b 40 78             	mov    0x78(%eax),%eax
  802662:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802664:	a1 90 77 80 00       	mov    0x807790,%eax
  802669:	8b 40 70             	mov    0x70(%eax),%eax
}
  80266c:	83 c4 10             	add    $0x10,%esp
  80266f:	5b                   	pop    %ebx
  802670:	5e                   	pop    %esi
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	57                   	push   %edi
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	83 ec 1c             	sub    $0x1c,%esp
  80267c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80267f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802682:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802685:	eb 25                	jmp    8026ac <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802687:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80268a:	74 20                	je     8026ac <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  80268c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802690:	c7 44 24 08 89 30 80 	movl   $0x803089,0x8(%esp)
  802697:	00 
  802698:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80269f:	00 
  8026a0:	c7 04 24 95 30 80 00 	movl   $0x803095,(%esp)
  8026a7:	e8 0b de ff ff       	call   8004b7 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8026ac:	85 db                	test   %ebx,%ebx
  8026ae:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026b3:	0f 45 c3             	cmovne %ebx,%eax
  8026b6:	8b 55 14             	mov    0x14(%ebp),%edx
  8026b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026c5:	89 3c 24             	mov    %edi,(%esp)
  8026c8:	e8 df eb ff ff       	call   8012ac <sys_ipc_try_send>
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	75 b6                	jne    802687 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	5b                   	pop    %ebx
  8026d5:	5e                   	pop    %esi
  8026d6:	5f                   	pop    %edi
  8026d7:	5d                   	pop    %ebp
  8026d8:	c3                   	ret    

008026d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8026df:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8026e4:	39 c8                	cmp    %ecx,%eax
  8026e6:	74 17                	je     8026ff <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026e8:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8026ed:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026f0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026f6:	8b 52 50             	mov    0x50(%edx),%edx
  8026f9:	39 ca                	cmp    %ecx,%edx
  8026fb:	75 14                	jne    802711 <ipc_find_env+0x38>
  8026fd:	eb 05                	jmp    802704 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802704:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802707:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80270c:	8b 40 40             	mov    0x40(%eax),%eax
  80270f:	eb 0e                	jmp    80271f <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802711:	83 c0 01             	add    $0x1,%eax
  802714:	3d 00 04 00 00       	cmp    $0x400,%eax
  802719:	75 d2                	jne    8026ed <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80271b:	66 b8 00 00          	mov    $0x0,%ax
}
  80271f:	5d                   	pop    %ebp
  802720:	c3                   	ret    

00802721 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802727:	89 d0                	mov    %edx,%eax
  802729:	c1 e8 16             	shr    $0x16,%eax
  80272c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802738:	f6 c1 01             	test   $0x1,%cl
  80273b:	74 1d                	je     80275a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80273d:	c1 ea 0c             	shr    $0xc,%edx
  802740:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802747:	f6 c2 01             	test   $0x1,%dl
  80274a:	74 0e                	je     80275a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80274c:	c1 ea 0c             	shr    $0xc,%edx
  80274f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802756:	ef 
  802757:	0f b7 c0             	movzwl %ax,%eax
}
  80275a:	5d                   	pop    %ebp
  80275b:	c3                   	ret    
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__udivdi3>:
  802760:	55                   	push   %ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	83 ec 0c             	sub    $0xc,%esp
  802766:	8b 44 24 28          	mov    0x28(%esp),%eax
  80276a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80276e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802772:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802776:	85 c0                	test   %eax,%eax
  802778:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80277c:	89 ea                	mov    %ebp,%edx
  80277e:	89 0c 24             	mov    %ecx,(%esp)
  802781:	75 2d                	jne    8027b0 <__udivdi3+0x50>
  802783:	39 e9                	cmp    %ebp,%ecx
  802785:	77 61                	ja     8027e8 <__udivdi3+0x88>
  802787:	85 c9                	test   %ecx,%ecx
  802789:	89 ce                	mov    %ecx,%esi
  80278b:	75 0b                	jne    802798 <__udivdi3+0x38>
  80278d:	b8 01 00 00 00       	mov    $0x1,%eax
  802792:	31 d2                	xor    %edx,%edx
  802794:	f7 f1                	div    %ecx
  802796:	89 c6                	mov    %eax,%esi
  802798:	31 d2                	xor    %edx,%edx
  80279a:	89 e8                	mov    %ebp,%eax
  80279c:	f7 f6                	div    %esi
  80279e:	89 c5                	mov    %eax,%ebp
  8027a0:	89 f8                	mov    %edi,%eax
  8027a2:	f7 f6                	div    %esi
  8027a4:	89 ea                	mov    %ebp,%edx
  8027a6:	83 c4 0c             	add    $0xc,%esp
  8027a9:	5e                   	pop    %esi
  8027aa:	5f                   	pop    %edi
  8027ab:	5d                   	pop    %ebp
  8027ac:	c3                   	ret    
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	39 e8                	cmp    %ebp,%eax
  8027b2:	77 24                	ja     8027d8 <__udivdi3+0x78>
  8027b4:	0f bd e8             	bsr    %eax,%ebp
  8027b7:	83 f5 1f             	xor    $0x1f,%ebp
  8027ba:	75 3c                	jne    8027f8 <__udivdi3+0x98>
  8027bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8027c0:	39 34 24             	cmp    %esi,(%esp)
  8027c3:	0f 86 9f 00 00 00    	jbe    802868 <__udivdi3+0x108>
  8027c9:	39 d0                	cmp    %edx,%eax
  8027cb:	0f 82 97 00 00 00    	jb     802868 <__udivdi3+0x108>
  8027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	31 d2                	xor    %edx,%edx
  8027da:	31 c0                	xor    %eax,%eax
  8027dc:	83 c4 0c             	add    $0xc,%esp
  8027df:	5e                   	pop    %esi
  8027e0:	5f                   	pop    %edi
  8027e1:	5d                   	pop    %ebp
  8027e2:	c3                   	ret    
  8027e3:	90                   	nop
  8027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	89 f8                	mov    %edi,%eax
  8027ea:	f7 f1                	div    %ecx
  8027ec:	31 d2                	xor    %edx,%edx
  8027ee:	83 c4 0c             	add    $0xc,%esp
  8027f1:	5e                   	pop    %esi
  8027f2:	5f                   	pop    %edi
  8027f3:	5d                   	pop    %ebp
  8027f4:	c3                   	ret    
  8027f5:	8d 76 00             	lea    0x0(%esi),%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	8b 3c 24             	mov    (%esp),%edi
  8027fd:	d3 e0                	shl    %cl,%eax
  8027ff:	89 c6                	mov    %eax,%esi
  802801:	b8 20 00 00 00       	mov    $0x20,%eax
  802806:	29 e8                	sub    %ebp,%eax
  802808:	89 c1                	mov    %eax,%ecx
  80280a:	d3 ef                	shr    %cl,%edi
  80280c:	89 e9                	mov    %ebp,%ecx
  80280e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802812:	8b 3c 24             	mov    (%esp),%edi
  802815:	09 74 24 08          	or     %esi,0x8(%esp)
  802819:	89 d6                	mov    %edx,%esi
  80281b:	d3 e7                	shl    %cl,%edi
  80281d:	89 c1                	mov    %eax,%ecx
  80281f:	89 3c 24             	mov    %edi,(%esp)
  802822:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802826:	d3 ee                	shr    %cl,%esi
  802828:	89 e9                	mov    %ebp,%ecx
  80282a:	d3 e2                	shl    %cl,%edx
  80282c:	89 c1                	mov    %eax,%ecx
  80282e:	d3 ef                	shr    %cl,%edi
  802830:	09 d7                	or     %edx,%edi
  802832:	89 f2                	mov    %esi,%edx
  802834:	89 f8                	mov    %edi,%eax
  802836:	f7 74 24 08          	divl   0x8(%esp)
  80283a:	89 d6                	mov    %edx,%esi
  80283c:	89 c7                	mov    %eax,%edi
  80283e:	f7 24 24             	mull   (%esp)
  802841:	39 d6                	cmp    %edx,%esi
  802843:	89 14 24             	mov    %edx,(%esp)
  802846:	72 30                	jb     802878 <__udivdi3+0x118>
  802848:	8b 54 24 04          	mov    0x4(%esp),%edx
  80284c:	89 e9                	mov    %ebp,%ecx
  80284e:	d3 e2                	shl    %cl,%edx
  802850:	39 c2                	cmp    %eax,%edx
  802852:	73 05                	jae    802859 <__udivdi3+0xf9>
  802854:	3b 34 24             	cmp    (%esp),%esi
  802857:	74 1f                	je     802878 <__udivdi3+0x118>
  802859:	89 f8                	mov    %edi,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	e9 7a ff ff ff       	jmp    8027dc <__udivdi3+0x7c>
  802862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802868:	31 d2                	xor    %edx,%edx
  80286a:	b8 01 00 00 00       	mov    $0x1,%eax
  80286f:	e9 68 ff ff ff       	jmp    8027dc <__udivdi3+0x7c>
  802874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802878:	8d 47 ff             	lea    -0x1(%edi),%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	83 c4 0c             	add    $0xc,%esp
  802880:	5e                   	pop    %esi
  802881:	5f                   	pop    %edi
  802882:	5d                   	pop    %ebp
  802883:	c3                   	ret    
  802884:	66 90                	xchg   %ax,%ax
  802886:	66 90                	xchg   %ax,%ax
  802888:	66 90                	xchg   %ax,%ax
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <__umoddi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	83 ec 14             	sub    $0x14,%esp
  802896:	8b 44 24 28          	mov    0x28(%esp),%eax
  80289a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80289e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8028a2:	89 c7                	mov    %eax,%edi
  8028a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8028ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8028b0:	89 34 24             	mov    %esi,(%esp)
  8028b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	89 c2                	mov    %eax,%edx
  8028bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028bf:	75 17                	jne    8028d8 <__umoddi3+0x48>
  8028c1:	39 fe                	cmp    %edi,%esi
  8028c3:	76 4b                	jbe    802910 <__umoddi3+0x80>
  8028c5:	89 c8                	mov    %ecx,%eax
  8028c7:	89 fa                	mov    %edi,%edx
  8028c9:	f7 f6                	div    %esi
  8028cb:	89 d0                	mov    %edx,%eax
  8028cd:	31 d2                	xor    %edx,%edx
  8028cf:	83 c4 14             	add    $0x14,%esp
  8028d2:	5e                   	pop    %esi
  8028d3:	5f                   	pop    %edi
  8028d4:	5d                   	pop    %ebp
  8028d5:	c3                   	ret    
  8028d6:	66 90                	xchg   %ax,%ax
  8028d8:	39 f8                	cmp    %edi,%eax
  8028da:	77 54                	ja     802930 <__umoddi3+0xa0>
  8028dc:	0f bd e8             	bsr    %eax,%ebp
  8028df:	83 f5 1f             	xor    $0x1f,%ebp
  8028e2:	75 5c                	jne    802940 <__umoddi3+0xb0>
  8028e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8028e8:	39 3c 24             	cmp    %edi,(%esp)
  8028eb:	0f 87 e7 00 00 00    	ja     8029d8 <__umoddi3+0x148>
  8028f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028f5:	29 f1                	sub    %esi,%ecx
  8028f7:	19 c7                	sbb    %eax,%edi
  8028f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802901:	8b 44 24 08          	mov    0x8(%esp),%eax
  802905:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802909:	83 c4 14             	add    $0x14,%esp
  80290c:	5e                   	pop    %esi
  80290d:	5f                   	pop    %edi
  80290e:	5d                   	pop    %ebp
  80290f:	c3                   	ret    
  802910:	85 f6                	test   %esi,%esi
  802912:	89 f5                	mov    %esi,%ebp
  802914:	75 0b                	jne    802921 <__umoddi3+0x91>
  802916:	b8 01 00 00 00       	mov    $0x1,%eax
  80291b:	31 d2                	xor    %edx,%edx
  80291d:	f7 f6                	div    %esi
  80291f:	89 c5                	mov    %eax,%ebp
  802921:	8b 44 24 04          	mov    0x4(%esp),%eax
  802925:	31 d2                	xor    %edx,%edx
  802927:	f7 f5                	div    %ebp
  802929:	89 c8                	mov    %ecx,%eax
  80292b:	f7 f5                	div    %ebp
  80292d:	eb 9c                	jmp    8028cb <__umoddi3+0x3b>
  80292f:	90                   	nop
  802930:	89 c8                	mov    %ecx,%eax
  802932:	89 fa                	mov    %edi,%edx
  802934:	83 c4 14             	add    $0x14,%esp
  802937:	5e                   	pop    %esi
  802938:	5f                   	pop    %edi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    
  80293b:	90                   	nop
  80293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802940:	8b 04 24             	mov    (%esp),%eax
  802943:	be 20 00 00 00       	mov    $0x20,%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	29 ee                	sub    %ebp,%esi
  80294c:	d3 e2                	shl    %cl,%edx
  80294e:	89 f1                	mov    %esi,%ecx
  802950:	d3 e8                	shr    %cl,%eax
  802952:	89 e9                	mov    %ebp,%ecx
  802954:	89 44 24 04          	mov    %eax,0x4(%esp)
  802958:	8b 04 24             	mov    (%esp),%eax
  80295b:	09 54 24 04          	or     %edx,0x4(%esp)
  80295f:	89 fa                	mov    %edi,%edx
  802961:	d3 e0                	shl    %cl,%eax
  802963:	89 f1                	mov    %esi,%ecx
  802965:	89 44 24 08          	mov    %eax,0x8(%esp)
  802969:	8b 44 24 10          	mov    0x10(%esp),%eax
  80296d:	d3 ea                	shr    %cl,%edx
  80296f:	89 e9                	mov    %ebp,%ecx
  802971:	d3 e7                	shl    %cl,%edi
  802973:	89 f1                	mov    %esi,%ecx
  802975:	d3 e8                	shr    %cl,%eax
  802977:	89 e9                	mov    %ebp,%ecx
  802979:	09 f8                	or     %edi,%eax
  80297b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80297f:	f7 74 24 04          	divl   0x4(%esp)
  802983:	d3 e7                	shl    %cl,%edi
  802985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802989:	89 d7                	mov    %edx,%edi
  80298b:	f7 64 24 08          	mull   0x8(%esp)
  80298f:	39 d7                	cmp    %edx,%edi
  802991:	89 c1                	mov    %eax,%ecx
  802993:	89 14 24             	mov    %edx,(%esp)
  802996:	72 2c                	jb     8029c4 <__umoddi3+0x134>
  802998:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80299c:	72 22                	jb     8029c0 <__umoddi3+0x130>
  80299e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8029a2:	29 c8                	sub    %ecx,%eax
  8029a4:	19 d7                	sbb    %edx,%edi
  8029a6:	89 e9                	mov    %ebp,%ecx
  8029a8:	89 fa                	mov    %edi,%edx
  8029aa:	d3 e8                	shr    %cl,%eax
  8029ac:	89 f1                	mov    %esi,%ecx
  8029ae:	d3 e2                	shl    %cl,%edx
  8029b0:	89 e9                	mov    %ebp,%ecx
  8029b2:	d3 ef                	shr    %cl,%edi
  8029b4:	09 d0                	or     %edx,%eax
  8029b6:	89 fa                	mov    %edi,%edx
  8029b8:	83 c4 14             	add    $0x14,%esp
  8029bb:	5e                   	pop    %esi
  8029bc:	5f                   	pop    %edi
  8029bd:	5d                   	pop    %ebp
  8029be:	c3                   	ret    
  8029bf:	90                   	nop
  8029c0:	39 d7                	cmp    %edx,%edi
  8029c2:	75 da                	jne    80299e <__umoddi3+0x10e>
  8029c4:	8b 14 24             	mov    (%esp),%edx
  8029c7:	89 c1                	mov    %eax,%ecx
  8029c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8029cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8029d1:	eb cb                	jmp    80299e <__umoddi3+0x10e>
  8029d3:	90                   	nop
  8029d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8029dc:	0f 82 0f ff ff ff    	jb     8028f1 <__umoddi3+0x61>
  8029e2:	e9 1a ff ff ff       	jmp    802901 <__umoddi3+0x71>
