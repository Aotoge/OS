
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 f6 0f 00 00       	call   80103a <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 5e 14 00 00       	call   8014b3 <close>
	if ((r = opencons()) < 0)
  800055:	e8 21 02 00 00       	call   80027b <opencons>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <umain+0x4b>
		panic("opencons: %e", r);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 20 24 80 	movl   $0x802420,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 2d 24 80 00 	movl   $0x80242d,(%esp)
  800079:	e8 e9 02 00 00       	call   800367 <_panic>
	if (r != 0)
  80007e:	85 c0                	test   %eax,%eax
  800080:	74 20                	je     8000a2 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 3c 24 80 	movl   $0x80243c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 2d 24 80 00 	movl   $0x80242d,(%esp)
  80009d:	e8 c5 02 00 00       	call   800367 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000a9:	00 
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 52 14 00 00       	call   801508 <dup>
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	79 20                	jns    8000da <umain+0xa7>
		panic("dup: %e", r);
  8000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000be:	c7 44 24 08 56 24 80 	movl   $0x802456,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 2d 24 80 00 	movl   $0x80242d,(%esp)
  8000d5:	e8 8d 02 00 00       	call   800367 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000da:	c7 04 24 5e 24 80 00 	movl   $0x80245e,(%esp)
  8000e1:	e8 7a 09 00 00       	call   800a60 <readline>
		if (buf != NULL)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	74 1a                	je     800104 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ee:	c7 44 24 04 6c 24 80 	movl   $0x80246c,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fd:	e8 2e 1b 00 00       	call   801c30 <fprintf>
  800102:	eb d6                	jmp    8000da <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800104:	c7 44 24 04 70 24 80 	movl   $0x802470,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800113:	e8 18 1b 00 00       	call   801c30 <fprintf>
  800118:	eb c0                	jmp    8000da <umain+0xa7>
  80011a:	66 90                	xchg   %ax,%ax
  80011c:	66 90                	xchg   %ax,%ax
  80011e:	66 90                	xchg   %ax,%ax

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 88 24 80 	movl   $0x802488,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 68 0a 00 00       	call   800bab <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80015a:	74 4a                	je     8001a6 <devcons_write+0x5c>
  80015c:	b8 00 00 00 00       	mov    $0x0,%eax
  800161:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016c:	8b 75 10             	mov    0x10(%ebp),%esi
  80016f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  800171:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800174:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800179:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80017c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800180:	03 45 0c             	add    0xc(%ebp),%eax
  800183:	89 44 24 04          	mov    %eax,0x4(%esp)
  800187:	89 3c 24             	mov    %edi,(%esp)
  80018a:	e8 17 0c 00 00       	call   800da6 <memmove>
		sys_cputs(buf, m);
  80018f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800193:	89 3c 24             	mov    %edi,(%esp)
  800196:	e8 f1 0d 00 00       	call   800f8c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80019b:	01 f3                	add    %esi,%ebx
  80019d:	89 d8                	mov    %ebx,%eax
  80019f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8001a2:	72 c8                	jb     80016c <devcons_write+0x22>
  8001a4:	eb 05                	jmp    8001ab <devcons_write+0x61>
  8001a6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8001ab:	89 d8                	mov    %ebx,%eax
  8001ad:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	5f                   	pop    %edi
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    

008001b8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001c7:	75 07                	jne    8001d0 <devcons_read+0x18>
  8001c9:	eb 28                	jmp    8001f3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001cb:	e8 6a 0e 00 00       	call   80103a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001d0:	e8 d5 0d 00 00       	call   800faa <sys_cgetc>
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	74 f2                	je     8001cb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8001d9:	85 c0                	test   %eax,%eax
  8001db:	78 16                	js     8001f3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001dd:	83 f8 04             	cmp    $0x4,%eax
  8001e0:	74 0c                	je     8001ee <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8001e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e5:	88 02                	mov    %al,(%edx)
	return 1;
  8001e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8001ec:	eb 05                	jmp    8001f3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800208:	00 
  800209:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80020c:	89 04 24             	mov    %eax,(%esp)
  80020f:	e8 78 0d 00 00       	call   800f8c <sys_cputs>
}
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <getchar>:

int
getchar(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80021c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800223:	00 
  800224:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 df 13 00 00       	call   801616 <read>
	if (r < 0)
  800237:	85 c0                	test   %eax,%eax
  800239:	78 0f                	js     80024a <getchar+0x34>
		return r;
	if (r < 1)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7e 06                	jle    800245 <getchar+0x2f>
		return -E_EOF;
	return c;
  80023f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800243:	eb 05                	jmp    80024a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800245:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    

0080024c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800252:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800255:	89 44 24 04          	mov    %eax,0x4(%esp)
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	89 04 24             	mov    %eax,(%esp)
  80025f:	e8 07 11 00 00       	call   80136b <fd_lookup>
  800264:	85 c0                	test   %eax,%eax
  800266:	78 11                	js     800279 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026b:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800271:	39 10                	cmp    %edx,(%eax)
  800273:	0f 94 c0             	sete   %al
  800276:	0f b6 c0             	movzbl %al,%eax
}
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <opencons>:

int
opencons(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800284:	89 04 24             	mov    %eax,(%esp)
  800287:	e8 6b 10 00 00       	call   8012f7 <fd_alloc>
		return r;
  80028c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80028e:	85 c0                	test   %eax,%eax
  800290:	78 40                	js     8002d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800292:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800299:	00 
  80029a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a8:	e8 ac 0d 00 00       	call   801059 <sys_page_alloc>
		return r;
  8002ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	78 1f                	js     8002d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002b3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002c8:	89 04 24             	mov    %eax,(%esp)
  8002cb:	e8 00 10 00 00       	call   8012d0 <fd2num>
  8002d0:	89 c2                	mov    %eax,%edx
}
  8002d2:	89 d0                	mov    %edx,%eax
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 10             	sub    $0x10,%esp
  8002de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8002e4:	e8 32 0d 00 00       	call   80101b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8002e9:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8002ef:	39 c2                	cmp    %eax,%edx
  8002f1:	74 17                	je     80030a <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8002f3:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8002f8:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8002fb:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800301:	8b 49 40             	mov    0x40(%ecx),%ecx
  800304:	39 c1                	cmp    %eax,%ecx
  800306:	75 18                	jne    800320 <libmain+0x4a>
  800308:	eb 05                	jmp    80030f <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80030f:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800312:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800318:	89 15 04 44 80 00    	mov    %edx,0x804404
			break;
  80031e:	eb 0b                	jmp    80032b <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800320:	83 c2 01             	add    $0x1,%edx
  800323:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800329:	75 cd                	jne    8002f8 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032b:	85 db                	test   %ebx,%ebx
  80032d:	7e 07                	jle    800336 <libmain+0x60>
		binaryname = argv[0];
  80032f:	8b 06                	mov    (%esi),%eax
  800331:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80033a:	89 1c 24             	mov    %ebx,(%esp)
  80033d:	e8 f1 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800342:	e8 07 00 00 00       	call   80034e <exit>
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5d                   	pop    %ebp
  80034d:	c3                   	ret    

0080034e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800354:	e8 8d 11 00 00       	call   8014e6 <close_all>
	sys_env_destroy(0);
  800359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800360:	e8 64 0c 00 00       	call   800fc9 <sys_env_destroy>
}
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	56                   	push   %esi
  80036b:	53                   	push   %ebx
  80036c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80036f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800372:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800378:	e8 9e 0c 00 00       	call   80101b <sys_getenvid>
  80037d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800380:	89 54 24 10          	mov    %edx,0x10(%esp)
  800384:	8b 55 08             	mov    0x8(%ebp),%edx
  800387:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80038b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80038f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800393:	c7 04 24 a0 24 80 00 	movl   $0x8024a0,(%esp)
  80039a:	e8 c1 00 00 00       	call   800460 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80039f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	89 04 24             	mov    %eax,(%esp)
  8003a9:	e8 51 00 00 00       	call   8003ff <vcprintf>
	cprintf("\n");
  8003ae:	c7 04 24 86 24 80 00 	movl   $0x802486,(%esp)
  8003b5:	e8 a6 00 00 00       	call   800460 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ba:	cc                   	int3   
  8003bb:	eb fd                	jmp    8003ba <_panic+0x53>

008003bd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 14             	sub    $0x14,%esp
  8003c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003c7:	8b 13                	mov    (%ebx),%edx
  8003c9:	8d 42 01             	lea    0x1(%edx),%eax
  8003cc:	89 03                	mov    %eax,(%ebx)
  8003ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003da:	75 19                	jne    8003f5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003dc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003e3:	00 
  8003e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	e8 9d 0b 00 00       	call   800f8c <sys_cputs>
		b->idx = 0;
  8003ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003f9:	83 c4 14             	add    $0x14,%esp
  8003fc:	5b                   	pop    %ebx
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800408:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040f:	00 00 00 
	b.cnt = 0;
  800412:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800419:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800430:	89 44 24 04          	mov    %eax,0x4(%esp)
  800434:	c7 04 24 bd 03 80 00 	movl   $0x8003bd,(%esp)
  80043b:	e8 b4 01 00 00       	call   8005f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800440:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800450:	89 04 24             	mov    %eax,(%esp)
  800453:	e8 34 0b 00 00       	call   800f8c <sys_cputs>

	return b.cnt;
}
  800458:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800466:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 04 24             	mov    %eax,(%esp)
  800473:	e8 87 ff ff ff       	call   8003ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800478:	c9                   	leave  
  800479:	c3                   	ret    
  80047a:	66 90                	xchg   %ax,%ax
  80047c:	66 90                	xchg   %ax,%ax
  80047e:	66 90                	xchg   %ax,%ax

00800480 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	57                   	push   %edi
  800484:	56                   	push   %esi
  800485:	53                   	push   %ebx
  800486:	83 ec 3c             	sub    $0x3c,%esp
  800489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80048c:	89 d7                	mov    %edx,%edi
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	8b 75 0c             	mov    0xc(%ebp),%esi
  800497:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80049a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80049d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004a8:	39 f1                	cmp    %esi,%ecx
  8004aa:	72 14                	jb     8004c0 <printnum+0x40>
  8004ac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004af:	76 0f                	jbe    8004c0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8004b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004ba:	85 f6                	test   %esi,%esi
  8004bc:	7f 60                	jg     80051e <printnum+0x9e>
  8004be:	eb 72                	jmp    800532 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004c3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8004ca:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8004cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004d9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004dd:	89 c3                	mov    %eax,%ebx
  8004df:	89 d6                	mov    %edx,%esi
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	89 04 24             	mov    %eax,(%esp)
  8004f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fc:	e8 7f 1c 00 00       	call   802180 <__udivdi3>
  800501:	89 d9                	mov    %ebx,%ecx
  800503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800507:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80050b:	89 04 24             	mov    %eax,(%esp)
  80050e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800512:	89 fa                	mov    %edi,%edx
  800514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800517:	e8 64 ff ff ff       	call   800480 <printnum>
  80051c:	eb 14                	jmp    800532 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800522:	8b 45 18             	mov    0x18(%ebp),%eax
  800525:	89 04 24             	mov    %eax,(%esp)
  800528:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052a:	83 ee 01             	sub    $0x1,%esi
  80052d:	75 ef                	jne    80051e <printnum+0x9e>
  80052f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800532:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800536:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80053a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800540:	89 44 24 08          	mov    %eax,0x8(%esp)
  800544:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054b:	89 04 24             	mov    %eax,(%esp)
  80054e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800551:	89 44 24 04          	mov    %eax,0x4(%esp)
  800555:	e8 56 1d 00 00       	call   8022b0 <__umoddi3>
  80055a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055e:	0f be 80 c3 24 80 00 	movsbl 0x8024c3(%eax),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056b:	ff d0                	call   *%eax
}
  80056d:	83 c4 3c             	add    $0x3c,%esp
  800570:	5b                   	pop    %ebx
  800571:	5e                   	pop    %esi
  800572:	5f                   	pop    %edi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800578:	83 fa 01             	cmp    $0x1,%edx
  80057b:	7e 0e                	jle    80058b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80057d:	8b 10                	mov    (%eax),%edx
  80057f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800582:	89 08                	mov    %ecx,(%eax)
  800584:	8b 02                	mov    (%edx),%eax
  800586:	8b 52 04             	mov    0x4(%edx),%edx
  800589:	eb 22                	jmp    8005ad <getuint+0x38>
	else if (lflag)
  80058b:	85 d2                	test   %edx,%edx
  80058d:	74 10                	je     80059f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80058f:	8b 10                	mov    (%eax),%edx
  800591:	8d 4a 04             	lea    0x4(%edx),%ecx
  800594:	89 08                	mov    %ecx,(%eax)
  800596:	8b 02                	mov    (%edx),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	eb 0e                	jmp    8005ad <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005a4:	89 08                	mov    %ecx,(%eax)
  8005a6:	8b 02                	mov    (%edx),%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ad:	5d                   	pop    %ebp
  8005ae:	c3                   	ret    

008005af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8005be:	73 0a                	jae    8005ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8005c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005c3:	89 08                	mov    %ecx,(%eax)
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	88 02                	mov    %al,(%edx)
}
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	89 04 24             	mov    %eax,(%esp)
  8005ed:	e8 02 00 00 00       	call   8005f4 <vprintfmt>
	va_end(ap);
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	57                   	push   %edi
  8005f8:	56                   	push   %esi
  8005f9:	53                   	push   %ebx
  8005fa:	83 ec 3c             	sub    $0x3c,%esp
  8005fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800600:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800603:	eb 18                	jmp    80061d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800605:	85 c0                	test   %eax,%eax
  800607:	0f 84 c3 03 00 00    	je     8009d0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80060d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800611:	89 04 24             	mov    %eax,(%esp)
  800614:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800617:	89 f3                	mov    %esi,%ebx
  800619:	eb 02                	jmp    80061d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80061b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061d:	8d 73 01             	lea    0x1(%ebx),%esi
  800620:	0f b6 03             	movzbl (%ebx),%eax
  800623:	83 f8 25             	cmp    $0x25,%eax
  800626:	75 dd                	jne    800605 <vprintfmt+0x11>
  800628:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80062c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800633:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80063a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800641:	ba 00 00 00 00       	mov    $0x0,%edx
  800646:	eb 1d                	jmp    800665 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800648:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80064a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80064e:	eb 15                	jmp    800665 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800650:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800652:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800656:	eb 0d                	jmp    800665 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800665:	8d 5e 01             	lea    0x1(%esi),%ebx
  800668:	0f b6 06             	movzbl (%esi),%eax
  80066b:	0f b6 c8             	movzbl %al,%ecx
  80066e:	83 e8 23             	sub    $0x23,%eax
  800671:	3c 55                	cmp    $0x55,%al
  800673:	0f 87 2f 03 00 00    	ja     8009a8 <vprintfmt+0x3b4>
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800683:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800689:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80068d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800690:	83 f9 09             	cmp    $0x9,%ecx
  800693:	77 50                	ja     8006e5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800695:	89 de                	mov    %ebx,%esi
  800697:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80069d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006a4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006a7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006aa:	83 fb 09             	cmp    $0x9,%ebx
  8006ad:	76 eb                	jbe    80069a <vprintfmt+0xa6>
  8006af:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006b2:	eb 33                	jmp    8006e7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ba:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006c4:	eb 21                	jmp    8006e7 <vprintfmt+0xf3>
  8006c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d0:	0f 49 c1             	cmovns %ecx,%eax
  8006d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d6:	89 de                	mov    %ebx,%esi
  8006d8:	eb 8b                	jmp    800665 <vprintfmt+0x71>
  8006da:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006dc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006e3:	eb 80                	jmp    800665 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006eb:	0f 89 74 ff ff ff    	jns    800665 <vprintfmt+0x71>
  8006f1:	e9 62 ff ff ff       	jmp    800658 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006f6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006fb:	e9 65 ff ff ff       	jmp    800665 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 50 04             	lea    0x4(%eax),%edx
  800706:	89 55 14             	mov    %edx,0x14(%ebp)
  800709:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	ff 55 08             	call   *0x8(%ebp)
			break;
  800715:	e9 03 ff ff ff       	jmp    80061d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 50 04             	lea    0x4(%eax),%edx
  800720:	89 55 14             	mov    %edx,0x14(%ebp)
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	31 d0                	xor    %edx,%eax
  800728:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072a:	83 f8 0f             	cmp    $0xf,%eax
  80072d:	7f 0b                	jg     80073a <vprintfmt+0x146>
  80072f:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  800736:	85 d2                	test   %edx,%edx
  800738:	75 20                	jne    80075a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80073a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073e:	c7 44 24 08 db 24 80 	movl   $0x8024db,0x8(%esp)
  800745:	00 
  800746:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 04 24             	mov    %eax,(%esp)
  800750:	e8 77 fe ff ff       	call   8005cc <printfmt>
  800755:	e9 c3 fe ff ff       	jmp    80061d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80075a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80075e:	c7 44 24 08 b2 28 80 	movl   $0x8028b2,0x8(%esp)
  800765:	00 
  800766:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	89 04 24             	mov    %eax,(%esp)
  800770:	e8 57 fe ff ff       	call   8005cc <printfmt>
  800775:	e9 a3 fe ff ff       	jmp    80061d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80077d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 50 04             	lea    0x4(%eax),%edx
  800786:	89 55 14             	mov    %edx,0x14(%ebp)
  800789:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80078b:	85 c0                	test   %eax,%eax
  80078d:	ba d4 24 80 00       	mov    $0x8024d4,%edx
  800792:	0f 45 d0             	cmovne %eax,%edx
  800795:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800798:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80079c:	74 04                	je     8007a2 <vprintfmt+0x1ae>
  80079e:	85 f6                	test   %esi,%esi
  8007a0:	7f 19                	jg     8007bb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a5:	8d 70 01             	lea    0x1(%eax),%esi
  8007a8:	0f b6 10             	movzbl (%eax),%edx
  8007ab:	0f be c2             	movsbl %dl,%eax
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	0f 85 95 00 00 00    	jne    80084b <vprintfmt+0x257>
  8007b6:	e9 85 00 00 00       	jmp    800840 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	e8 a8 03 00 00       	call   800b72 <strnlen>
  8007ca:	29 c6                	sub    %eax,%esi
  8007cc:	89 f0                	mov    %esi,%eax
  8007ce:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	7e cd                	jle    8007a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8007d5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8007d9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007dc:	89 c3                	mov    %eax,%ebx
  8007de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e2:	89 34 24             	mov    %esi,(%esp)
  8007e5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e8:	83 eb 01             	sub    $0x1,%ebx
  8007eb:	75 f1                	jne    8007de <vprintfmt+0x1ea>
  8007ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007f3:	eb ad                	jmp    8007a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007f9:	74 1e                	je     800819 <vprintfmt+0x225>
  8007fb:	0f be d2             	movsbl %dl,%edx
  8007fe:	83 ea 20             	sub    $0x20,%edx
  800801:	83 fa 5e             	cmp    $0x5e,%edx
  800804:	76 13                	jbe    800819 <vprintfmt+0x225>
					putch('?', putdat);
  800806:	8b 45 0c             	mov    0xc(%ebp),%eax
  800809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800814:	ff 55 08             	call   *0x8(%ebp)
  800817:	eb 0d                	jmp    800826 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800820:	89 04 24             	mov    %eax,(%esp)
  800823:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800826:	83 ef 01             	sub    $0x1,%edi
  800829:	83 c6 01             	add    $0x1,%esi
  80082c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800830:	0f be c2             	movsbl %dl,%eax
  800833:	85 c0                	test   %eax,%eax
  800835:	75 20                	jne    800857 <vprintfmt+0x263>
  800837:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80083a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80083d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800840:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800844:	7f 25                	jg     80086b <vprintfmt+0x277>
  800846:	e9 d2 fd ff ff       	jmp    80061d <vprintfmt+0x29>
  80084b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800851:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800854:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800857:	85 db                	test   %ebx,%ebx
  800859:	78 9a                	js     8007f5 <vprintfmt+0x201>
  80085b:	83 eb 01             	sub    $0x1,%ebx
  80085e:	79 95                	jns    8007f5 <vprintfmt+0x201>
  800860:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800863:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800866:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800869:	eb d5                	jmp    800840 <vprintfmt+0x24c>
  80086b:	8b 75 08             	mov    0x8(%ebp),%esi
  80086e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800871:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800874:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800878:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80087f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800881:	83 eb 01             	sub    $0x1,%ebx
  800884:	75 ee                	jne    800874 <vprintfmt+0x280>
  800886:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800889:	e9 8f fd ff ff       	jmp    80061d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80088e:	83 fa 01             	cmp    $0x1,%edx
  800891:	7e 16                	jle    8008a9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8d 50 08             	lea    0x8(%eax),%edx
  800899:	89 55 14             	mov    %edx,0x14(%ebp)
  80089c:	8b 50 04             	mov    0x4(%eax),%edx
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a7:	eb 32                	jmp    8008db <vprintfmt+0x2e7>
	else if (lflag)
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	74 18                	je     8008c5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 50 04             	lea    0x4(%eax),%edx
  8008b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b6:	8b 30                	mov    (%eax),%esi
  8008b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	c1 f8 1f             	sar    $0x1f,%eax
  8008c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008c3:	eb 16                	jmp    8008db <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8d 50 04             	lea    0x4(%eax),%edx
  8008cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ce:	8b 30                	mov    (%eax),%esi
  8008d0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008d3:	89 f0                	mov    %esi,%eax
  8008d5:	c1 f8 1f             	sar    $0x1f,%eax
  8008d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008de:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ea:	0f 89 80 00 00 00    	jns    800970 <vprintfmt+0x37c>
				putch('-', putdat);
  8008f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008fb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800901:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800904:	f7 d8                	neg    %eax
  800906:	83 d2 00             	adc    $0x0,%edx
  800909:	f7 da                	neg    %edx
			}
			base = 10;
  80090b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800910:	eb 5e                	jmp    800970 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800912:	8d 45 14             	lea    0x14(%ebp),%eax
  800915:	e8 5b fc ff ff       	call   800575 <getuint>
			base = 10;
  80091a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80091f:	eb 4f                	jmp    800970 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800921:	8d 45 14             	lea    0x14(%ebp),%eax
  800924:	e8 4c fc ff ff       	call   800575 <getuint>
			base = 8;
  800929:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80092e:	eb 40                	jmp    800970 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800930:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800934:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80093e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800942:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800949:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800955:	8b 00                	mov    (%eax),%eax
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80095c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800961:	eb 0d                	jmp    800970 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800963:	8d 45 14             	lea    0x14(%ebp),%eax
  800966:	e8 0a fc ff ff       	call   800575 <getuint>
			base = 16;
  80096b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800970:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800974:	89 74 24 10          	mov    %esi,0x10(%esp)
  800978:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80097b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80097f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800983:	89 04 24             	mov    %eax,(%esp)
  800986:	89 54 24 04          	mov    %edx,0x4(%esp)
  80098a:	89 fa                	mov    %edi,%edx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	e8 ec fa ff ff       	call   800480 <printnum>
			break;
  800994:	e9 84 fc ff ff       	jmp    80061d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800999:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099d:	89 0c 24             	mov    %ecx,(%esp)
  8009a0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009a3:	e9 75 fc ff ff       	jmp    80061d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8009ba:	0f 84 5b fc ff ff    	je     80061b <vprintfmt+0x27>
  8009c0:	89 f3                	mov    %esi,%ebx
  8009c2:	83 eb 01             	sub    $0x1,%ebx
  8009c5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009c9:	75 f7                	jne    8009c2 <vprintfmt+0x3ce>
  8009cb:	e9 4d fc ff ff       	jmp    80061d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8009d0:	83 c4 3c             	add    $0x3c,%esp
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5f                   	pop    %edi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 28             	sub    $0x28,%esp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009eb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	74 30                	je     800a29 <vsnprintf+0x51>
  8009f9:	85 d2                	test   %edx,%edx
  8009fb:	7e 2c                	jle    800a29 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a12:	c7 04 24 af 05 80 00 	movl   $0x8005af,(%esp)
  800a19:	e8 d6 fb ff ff       	call   8005f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a27:	eb 05                	jmp    800a2e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a36:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a40:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	89 04 24             	mov    %eax,(%esp)
  800a51:	e8 82 ff ff ff       	call   8009d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    
  800a58:	66 90                	xchg   %ax,%ax
  800a5a:	66 90                	xchg   %ax,%ax
  800a5c:	66 90                	xchg   %ax,%ax
  800a5e:	66 90                	xchg   %ax,%ax

00800a60 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	83 ec 1c             	sub    $0x1c,%esp
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	74 18                	je     800a88 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a70:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a74:	c7 44 24 04 b2 28 80 	movl   $0x8028b2,0x4(%esp)
  800a7b:	00 
  800a7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a83:	e8 a8 11 00 00       	call   801c30 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a8f:	e8 b8 f7 ff ff       	call   80024c <iscons>
  800a94:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800a96:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800a9b:	e8 76 f7 ff ff       	call   800216 <getchar>
  800aa0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	79 25                	jns    800acb <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800aab:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800aae:	0f 84 88 00 00 00    	je     800b3c <readline+0xdc>
				cprintf("read error: %e\n", c);
  800ab4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ab8:	c7 04 24 bf 27 80 00 	movl   $0x8027bf,(%esp)
  800abf:	e8 9c f9 ff ff       	call   800460 <cprintf>
			return NULL;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac9:	eb 71                	jmp    800b3c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800acb:	83 f8 7f             	cmp    $0x7f,%eax
  800ace:	74 05                	je     800ad5 <readline+0x75>
  800ad0:	83 f8 08             	cmp    $0x8,%eax
  800ad3:	75 19                	jne    800aee <readline+0x8e>
  800ad5:	85 f6                	test   %esi,%esi
  800ad7:	7e 15                	jle    800aee <readline+0x8e>
			if (echoing)
  800ad9:	85 ff                	test   %edi,%edi
  800adb:	74 0c                	je     800ae9 <readline+0x89>
				cputchar('\b');
  800add:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800ae4:	e8 0c f7 ff ff       	call   8001f5 <cputchar>
			i--;
  800ae9:	83 ee 01             	sub    $0x1,%esi
  800aec:	eb ad                	jmp    800a9b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aee:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800af4:	7f 1c                	jg     800b12 <readline+0xb2>
  800af6:	83 fb 1f             	cmp    $0x1f,%ebx
  800af9:	7e 17                	jle    800b12 <readline+0xb2>
			if (echoing)
  800afb:	85 ff                	test   %edi,%edi
  800afd:	74 08                	je     800b07 <readline+0xa7>
				cputchar(c);
  800aff:	89 1c 24             	mov    %ebx,(%esp)
  800b02:	e8 ee f6 ff ff       	call   8001f5 <cputchar>
			buf[i++] = c;
  800b07:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800b0d:	8d 76 01             	lea    0x1(%esi),%esi
  800b10:	eb 89                	jmp    800a9b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800b12:	83 fb 0d             	cmp    $0xd,%ebx
  800b15:	74 09                	je     800b20 <readline+0xc0>
  800b17:	83 fb 0a             	cmp    $0xa,%ebx
  800b1a:	0f 85 7b ff ff ff    	jne    800a9b <readline+0x3b>
			if (echoing)
  800b20:	85 ff                	test   %edi,%edi
  800b22:	74 0c                	je     800b30 <readline+0xd0>
				cputchar('\n');
  800b24:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800b2b:	e8 c5 f6 ff ff       	call   8001f5 <cputchar>
			buf[i] = 0;
  800b30:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800b37:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  800b3c:	83 c4 1c             	add    $0x1c,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    
  800b44:	66 90                	xchg   %ax,%ax
  800b46:	66 90                	xchg   %ax,%ax
  800b48:	66 90                	xchg   %ax,%ax
  800b4a:	66 90                	xchg   %ax,%ax
  800b4c:	66 90                	xchg   %ax,%ax
  800b4e:	66 90                	xchg   %ax,%ax

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	80 3a 00             	cmpb   $0x0,(%edx)
  800b59:	74 10                	je     800b6b <strlen+0x1b>
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b60:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b67:	75 f7                	jne    800b60 <strlen+0x10>
  800b69:	eb 05                	jmp    800b70 <strlen+0x20>
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	53                   	push   %ebx
  800b76:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7c:	85 c9                	test   %ecx,%ecx
  800b7e:	74 1c                	je     800b9c <strnlen+0x2a>
  800b80:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b83:	74 1e                	je     800ba3 <strnlen+0x31>
  800b85:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800b8a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8c:	39 ca                	cmp    %ecx,%edx
  800b8e:	74 18                	je     800ba8 <strnlen+0x36>
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800b98:	75 f0                	jne    800b8a <strnlen+0x18>
  800b9a:	eb 0c                	jmp    800ba8 <strnlen+0x36>
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba1:	eb 05                	jmp    800ba8 <strnlen+0x36>
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	53                   	push   %ebx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb5:	89 c2                	mov    %eax,%edx
  800bb7:	83 c2 01             	add    $0x1,%edx
  800bba:	83 c1 01             	add    $0x1,%ecx
  800bbd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bc1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bc4:	84 db                	test   %bl,%bl
  800bc6:	75 ef                	jne    800bb7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	53                   	push   %ebx
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bd5:	89 1c 24             	mov    %ebx,(%esp)
  800bd8:	e8 73 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800be4:	01 d8                	add    %ebx,%eax
  800be6:	89 04 24             	mov    %eax,(%esp)
  800be9:	e8 bd ff ff ff       	call   800bab <strcpy>
	return dst;
}
  800bee:	89 d8                	mov    %ebx,%eax
  800bf0:	83 c4 08             	add    $0x8,%esp
  800bf3:	5b                   	pop    %ebx
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
  800bfb:	8b 75 08             	mov    0x8(%ebp),%esi
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c04:	85 db                	test   %ebx,%ebx
  800c06:	74 17                	je     800c1f <strncpy+0x29>
  800c08:	01 f3                	add    %esi,%ebx
  800c0a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800c0c:	83 c1 01             	add    $0x1,%ecx
  800c0f:	0f b6 02             	movzbl (%edx),%eax
  800c12:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c15:	80 3a 01             	cmpb   $0x1,(%edx)
  800c18:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c1b:	39 d9                	cmp    %ebx,%ecx
  800c1d:	75 ed                	jne    800c0c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c1f:	89 f0                	mov    %esi,%eax
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
  800c2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c31:	8b 75 10             	mov    0x10(%ebp),%esi
  800c34:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c36:	85 f6                	test   %esi,%esi
  800c38:	74 34                	je     800c6e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800c3a:	83 fe 01             	cmp    $0x1,%esi
  800c3d:	74 26                	je     800c65 <strlcpy+0x40>
  800c3f:	0f b6 0b             	movzbl (%ebx),%ecx
  800c42:	84 c9                	test   %cl,%cl
  800c44:	74 23                	je     800c69 <strlcpy+0x44>
  800c46:	83 ee 02             	sub    $0x2,%esi
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800c4e:	83 c0 01             	add    $0x1,%eax
  800c51:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c54:	39 f2                	cmp    %esi,%edx
  800c56:	74 13                	je     800c6b <strlcpy+0x46>
  800c58:	83 c2 01             	add    $0x1,%edx
  800c5b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c5f:	84 c9                	test   %cl,%cl
  800c61:	75 eb                	jne    800c4e <strlcpy+0x29>
  800c63:	eb 06                	jmp    800c6b <strlcpy+0x46>
  800c65:	89 f8                	mov    %edi,%eax
  800c67:	eb 02                	jmp    800c6b <strlcpy+0x46>
  800c69:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c6e:	29 f8                	sub    %edi,%eax
}
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c7e:	0f b6 01             	movzbl (%ecx),%eax
  800c81:	84 c0                	test   %al,%al
  800c83:	74 15                	je     800c9a <strcmp+0x25>
  800c85:	3a 02                	cmp    (%edx),%al
  800c87:	75 11                	jne    800c9a <strcmp+0x25>
		p++, q++;
  800c89:	83 c1 01             	add    $0x1,%ecx
  800c8c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c8f:	0f b6 01             	movzbl (%ecx),%eax
  800c92:	84 c0                	test   %al,%al
  800c94:	74 04                	je     800c9a <strcmp+0x25>
  800c96:	3a 02                	cmp    (%edx),%al
  800c98:	74 ef                	je     800c89 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9a:	0f b6 c0             	movzbl %al,%eax
  800c9d:	0f b6 12             	movzbl (%edx),%edx
  800ca0:	29 d0                	sub    %edx,%eax
}
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800caf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800cb2:	85 f6                	test   %esi,%esi
  800cb4:	74 29                	je     800cdf <strncmp+0x3b>
  800cb6:	0f b6 03             	movzbl (%ebx),%eax
  800cb9:	84 c0                	test   %al,%al
  800cbb:	74 30                	je     800ced <strncmp+0x49>
  800cbd:	3a 02                	cmp    (%edx),%al
  800cbf:	75 2c                	jne    800ced <strncmp+0x49>
  800cc1:	8d 43 01             	lea    0x1(%ebx),%eax
  800cc4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800cc6:	89 c3                	mov    %eax,%ebx
  800cc8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ccb:	39 f0                	cmp    %esi,%eax
  800ccd:	74 17                	je     800ce6 <strncmp+0x42>
  800ccf:	0f b6 08             	movzbl (%eax),%ecx
  800cd2:	84 c9                	test   %cl,%cl
  800cd4:	74 17                	je     800ced <strncmp+0x49>
  800cd6:	83 c0 01             	add    $0x1,%eax
  800cd9:	3a 0a                	cmp    (%edx),%cl
  800cdb:	74 e9                	je     800cc6 <strncmp+0x22>
  800cdd:	eb 0e                	jmp    800ced <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce4:	eb 0f                	jmp    800cf5 <strncmp+0x51>
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	eb 08                	jmp    800cf5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ced:	0f b6 03             	movzbl (%ebx),%eax
  800cf0:	0f b6 12             	movzbl (%edx),%edx
  800cf3:	29 d0                	sub    %edx,%eax
}
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	53                   	push   %ebx
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800d03:	0f b6 18             	movzbl (%eax),%ebx
  800d06:	84 db                	test   %bl,%bl
  800d08:	74 1d                	je     800d27 <strchr+0x2e>
  800d0a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800d0c:	38 d3                	cmp    %dl,%bl
  800d0e:	75 06                	jne    800d16 <strchr+0x1d>
  800d10:	eb 1a                	jmp    800d2c <strchr+0x33>
  800d12:	38 ca                	cmp    %cl,%dl
  800d14:	74 16                	je     800d2c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	0f b6 10             	movzbl (%eax),%edx
  800d1c:	84 d2                	test   %dl,%dl
  800d1e:	75 f2                	jne    800d12 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800d20:	b8 00 00 00 00       	mov    $0x0,%eax
  800d25:	eb 05                	jmp    800d2c <strchr+0x33>
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	53                   	push   %ebx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800d39:	0f b6 18             	movzbl (%eax),%ebx
  800d3c:	84 db                	test   %bl,%bl
  800d3e:	74 16                	je     800d56 <strfind+0x27>
  800d40:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800d42:	38 d3                	cmp    %dl,%bl
  800d44:	75 06                	jne    800d4c <strfind+0x1d>
  800d46:	eb 0e                	jmp    800d56 <strfind+0x27>
  800d48:	38 ca                	cmp    %cl,%dl
  800d4a:	74 0a                	je     800d56 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d4c:	83 c0 01             	add    $0x1,%eax
  800d4f:	0f b6 10             	movzbl (%eax),%edx
  800d52:	84 d2                	test   %dl,%dl
  800d54:	75 f2                	jne    800d48 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800d56:	5b                   	pop    %ebx
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d65:	85 c9                	test   %ecx,%ecx
  800d67:	74 36                	je     800d9f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d69:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d6f:	75 28                	jne    800d99 <memset+0x40>
  800d71:	f6 c1 03             	test   $0x3,%cl
  800d74:	75 23                	jne    800d99 <memset+0x40>
		c &= 0xFF;
  800d76:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	c1 e3 08             	shl    $0x8,%ebx
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	c1 e6 18             	shl    $0x18,%esi
  800d84:	89 d0                	mov    %edx,%eax
  800d86:	c1 e0 10             	shl    $0x10,%eax
  800d89:	09 f0                	or     %esi,%eax
  800d8b:	09 c2                	or     %eax,%edx
  800d8d:	89 d0                	mov    %edx,%eax
  800d8f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d91:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d94:	fc                   	cld    
  800d95:	f3 ab                	rep stos %eax,%es:(%edi)
  800d97:	eb 06                	jmp    800d9f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	fc                   	cld    
  800d9d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d9f:	89 f8                	mov    %edi,%eax
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db4:	39 c6                	cmp    %eax,%esi
  800db6:	73 35                	jae    800ded <memmove+0x47>
  800db8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dbb:	39 d0                	cmp    %edx,%eax
  800dbd:	73 2e                	jae    800ded <memmove+0x47>
		s += n;
		d += n;
  800dbf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800dc2:	89 d6                	mov    %edx,%esi
  800dc4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dcc:	75 13                	jne    800de1 <memmove+0x3b>
  800dce:	f6 c1 03             	test   $0x3,%cl
  800dd1:	75 0e                	jne    800de1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd3:	83 ef 04             	sub    $0x4,%edi
  800dd6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dd9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800ddc:	fd                   	std    
  800ddd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ddf:	eb 09                	jmp    800dea <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de1:	83 ef 01             	sub    $0x1,%edi
  800de4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800de7:	fd                   	std    
  800de8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dea:	fc                   	cld    
  800deb:	eb 1d                	jmp    800e0a <memmove+0x64>
  800ded:	89 f2                	mov    %esi,%edx
  800def:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df1:	f6 c2 03             	test   $0x3,%dl
  800df4:	75 0f                	jne    800e05 <memmove+0x5f>
  800df6:	f6 c1 03             	test   $0x3,%cl
  800df9:	75 0a                	jne    800e05 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	fc                   	cld    
  800e01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e03:	eb 05                	jmp    800e0a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e05:	89 c7                	mov    %eax,%edi
  800e07:	fc                   	cld    
  800e08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 04 24             	mov    %eax,(%esp)
  800e28:	e8 79 ff ff ff       	call   800da6 <memmove>
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800e41:	85 c0                	test   %eax,%eax
  800e43:	74 36                	je     800e7b <memcmp+0x4c>
		if (*s1 != *s2)
  800e45:	0f b6 03             	movzbl (%ebx),%eax
  800e48:	0f b6 0e             	movzbl (%esi),%ecx
  800e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e50:	38 c8                	cmp    %cl,%al
  800e52:	74 1c                	je     800e70 <memcmp+0x41>
  800e54:	eb 10                	jmp    800e66 <memcmp+0x37>
  800e56:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800e5b:	83 c2 01             	add    $0x1,%edx
  800e5e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800e62:	38 c8                	cmp    %cl,%al
  800e64:	74 0a                	je     800e70 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800e66:	0f b6 c0             	movzbl %al,%eax
  800e69:	0f b6 c9             	movzbl %cl,%ecx
  800e6c:	29 c8                	sub    %ecx,%eax
  800e6e:	eb 10                	jmp    800e80 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e70:	39 fa                	cmp    %edi,%edx
  800e72:	75 e2                	jne    800e56 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
  800e79:	eb 05                	jmp    800e80 <memcmp+0x51>
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	53                   	push   %ebx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800e8f:	89 c2                	mov    %eax,%edx
  800e91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e94:	39 d0                	cmp    %edx,%eax
  800e96:	73 13                	jae    800eab <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e98:	89 d9                	mov    %ebx,%ecx
  800e9a:	38 18                	cmp    %bl,(%eax)
  800e9c:	75 06                	jne    800ea4 <memfind+0x1f>
  800e9e:	eb 0b                	jmp    800eab <memfind+0x26>
  800ea0:	38 08                	cmp    %cl,(%eax)
  800ea2:	74 07                	je     800eab <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea4:	83 c0 01             	add    $0x1,%eax
  800ea7:	39 d0                	cmp    %edx,%eax
  800ea9:	75 f5                	jne    800ea0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800eab:	5b                   	pop    %ebx
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    

00800eae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eba:	0f b6 0a             	movzbl (%edx),%ecx
  800ebd:	80 f9 09             	cmp    $0x9,%cl
  800ec0:	74 05                	je     800ec7 <strtol+0x19>
  800ec2:	80 f9 20             	cmp    $0x20,%cl
  800ec5:	75 10                	jne    800ed7 <strtol+0x29>
		s++;
  800ec7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eca:	0f b6 0a             	movzbl (%edx),%ecx
  800ecd:	80 f9 09             	cmp    $0x9,%cl
  800ed0:	74 f5                	je     800ec7 <strtol+0x19>
  800ed2:	80 f9 20             	cmp    $0x20,%cl
  800ed5:	74 f0                	je     800ec7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ed7:	80 f9 2b             	cmp    $0x2b,%cl
  800eda:	75 0a                	jne    800ee6 <strtol+0x38>
		s++;
  800edc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800edf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee4:	eb 11                	jmp    800ef7 <strtol+0x49>
  800ee6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800eeb:	80 f9 2d             	cmp    $0x2d,%cl
  800eee:	75 07                	jne    800ef7 <strtol+0x49>
		s++, neg = 1;
  800ef0:	83 c2 01             	add    $0x1,%edx
  800ef3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ef7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800efc:	75 15                	jne    800f13 <strtol+0x65>
  800efe:	80 3a 30             	cmpb   $0x30,(%edx)
  800f01:	75 10                	jne    800f13 <strtol+0x65>
  800f03:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f07:	75 0a                	jne    800f13 <strtol+0x65>
		s += 2, base = 16;
  800f09:	83 c2 02             	add    $0x2,%edx
  800f0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f11:	eb 10                	jmp    800f23 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 0c                	jne    800f23 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f17:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f19:	80 3a 30             	cmpb   $0x30,(%edx)
  800f1c:	75 05                	jne    800f23 <strtol+0x75>
		s++, base = 8;
  800f1e:	83 c2 01             	add    $0x1,%edx
  800f21:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f2b:	0f b6 0a             	movzbl (%edx),%ecx
  800f2e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f31:	89 f0                	mov    %esi,%eax
  800f33:	3c 09                	cmp    $0x9,%al
  800f35:	77 08                	ja     800f3f <strtol+0x91>
			dig = *s - '0';
  800f37:	0f be c9             	movsbl %cl,%ecx
  800f3a:	83 e9 30             	sub    $0x30,%ecx
  800f3d:	eb 20                	jmp    800f5f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800f3f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f42:	89 f0                	mov    %esi,%eax
  800f44:	3c 19                	cmp    $0x19,%al
  800f46:	77 08                	ja     800f50 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800f48:	0f be c9             	movsbl %cl,%ecx
  800f4b:	83 e9 57             	sub    $0x57,%ecx
  800f4e:	eb 0f                	jmp    800f5f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800f50:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f53:	89 f0                	mov    %esi,%eax
  800f55:	3c 19                	cmp    $0x19,%al
  800f57:	77 16                	ja     800f6f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f59:	0f be c9             	movsbl %cl,%ecx
  800f5c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f5f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f62:	7d 0f                	jge    800f73 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f64:	83 c2 01             	add    $0x1,%edx
  800f67:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f6b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f6d:	eb bc                	jmp    800f2b <strtol+0x7d>
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	eb 02                	jmp    800f75 <strtol+0xc7>
  800f73:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	74 05                	je     800f80 <strtol+0xd2>
		*endptr = (char *) s;
  800f7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f7e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f80:	f7 d8                	neg    %eax
  800f82:	85 ff                	test   %edi,%edi
  800f84:	0f 44 c3             	cmove  %ebx,%eax
}
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
  800f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	89 c3                	mov    %eax,%ebx
  800f9f:	89 c7                	mov    %eax,%edi
  800fa1:	89 c6                	mov    %eax,%esi
  800fa3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <sys_cgetc>:

int
sys_cgetc(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb5:	b8 01 00 00 00       	mov    $0x1,%eax
  800fba:	89 d1                	mov    %edx,%ecx
  800fbc:	89 d3                	mov    %edx,%ebx
  800fbe:	89 d7                	mov    %edx,%edi
  800fc0:	89 d6                	mov    %edx,%esi
  800fc2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
  800fcf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd7:	b8 03 00 00 00       	mov    $0x3,%eax
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	89 cb                	mov    %ecx,%ebx
  800fe1:	89 cf                	mov    %ecx,%edi
  800fe3:	89 ce                	mov    %ecx,%esi
  800fe5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	7e 28                	jle    801013 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800feb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fef:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ff6:	00 
  800ff7:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  800ffe:	00 
  800fff:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801006:	00 
  801007:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  80100e:	e8 54 f3 ff ff       	call   800367 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801013:	83 c4 2c             	add    $0x2c,%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5f                   	pop    %edi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	b8 02 00 00 00       	mov    $0x2,%eax
  80102b:	89 d1                	mov    %edx,%ecx
  80102d:	89 d3                	mov    %edx,%ebx
  80102f:	89 d7                	mov    %edx,%edi
  801031:	89 d6                	mov    %edx,%esi
  801033:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <sys_yield>:

void
sys_yield(void)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801040:	ba 00 00 00 00       	mov    $0x0,%edx
  801045:	b8 0b 00 00 00       	mov    $0xb,%eax
  80104a:	89 d1                	mov    %edx,%ecx
  80104c:	89 d3                	mov    %edx,%ebx
  80104e:	89 d7                	mov    %edx,%edi
  801050:	89 d6                	mov    %edx,%esi
  801052:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801054:	5b                   	pop    %ebx
  801055:	5e                   	pop    %esi
  801056:	5f                   	pop    %edi
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	57                   	push   %edi
  80105d:	56                   	push   %esi
  80105e:	53                   	push   %ebx
  80105f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801062:	be 00 00 00 00       	mov    $0x0,%esi
  801067:	b8 04 00 00 00       	mov    $0x4,%eax
  80106c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801075:	89 f7                	mov    %esi,%edi
  801077:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7e 28                	jle    8010a5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801081:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801088:	00 
  801089:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  801090:	00 
  801091:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801098:	00 
  801099:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8010a0:	e8 c2 f2 ff ff       	call   800367 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010a5:	83 c4 2c             	add    $0x2c,%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b6:	b8 05 00 00 00       	mov    $0x5,%eax
  8010bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	7e 28                	jle    8010f8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010db:	00 
  8010dc:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  8010e3:	00 
  8010e4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010eb:	00 
  8010ec:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8010f3:	e8 6f f2 ff ff       	call   800367 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010f8:	83 c4 2c             	add    $0x2c,%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110e:	b8 06 00 00 00       	mov    $0x6,%eax
  801113:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801116:	8b 55 08             	mov    0x8(%ebp),%edx
  801119:	89 df                	mov    %ebx,%edi
  80111b:	89 de                	mov    %ebx,%esi
  80111d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80111f:	85 c0                	test   %eax,%eax
  801121:	7e 28                	jle    80114b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801123:	89 44 24 10          	mov    %eax,0x10(%esp)
  801127:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80112e:	00 
  80112f:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  801136:	00 
  801137:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80113e:	00 
  80113f:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  801146:	e8 1c f2 ff ff       	call   800367 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114b:	83 c4 2c             	add    $0x2c,%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	53                   	push   %ebx
  801159:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801161:	b8 08 00 00 00       	mov    $0x8,%eax
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	89 df                	mov    %ebx,%edi
  80116e:	89 de                	mov    %ebx,%esi
  801170:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801172:	85 c0                	test   %eax,%eax
  801174:	7e 28                	jle    80119e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801176:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801181:	00 
  801182:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  801189:	00 
  80118a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801191:	00 
  801192:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  801199:	e8 c9 f1 ff ff       	call   800367 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80119e:	83 c4 2c             	add    $0x2c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8011b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bf:	89 df                	mov    %ebx,%edi
  8011c1:	89 de                	mov    %ebx,%esi
  8011c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	7e 28                	jle    8011f1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011cd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011d4:	00 
  8011d5:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011e4:	00 
  8011e5:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8011ec:	e8 76 f1 ff ff       	call   800367 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011f1:	83 c4 2c             	add    $0x2c,%esp
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	b8 0a 00 00 00       	mov    $0xa,%eax
  80120c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120f:	8b 55 08             	mov    0x8(%ebp),%edx
  801212:	89 df                	mov    %ebx,%edi
  801214:	89 de                	mov    %ebx,%esi
  801216:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801218:	85 c0                	test   %eax,%eax
  80121a:	7e 28                	jle    801244 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80121c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801220:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801227:	00 
  801228:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  80122f:	00 
  801230:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801237:	00 
  801238:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  80123f:	e8 23 f1 ff ff       	call   800367 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801244:	83 c4 2c             	add    $0x2c,%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801252:	be 00 00 00 00       	mov    $0x0,%esi
  801257:	b8 0c 00 00 00       	mov    $0xc,%eax
  80125c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125f:	8b 55 08             	mov    0x8(%ebp),%edx
  801262:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801265:	8b 7d 14             	mov    0x14(%ebp),%edi
  801268:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	57                   	push   %edi
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801278:	b9 00 00 00 00       	mov    $0x0,%ecx
  80127d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801282:	8b 55 08             	mov    0x8(%ebp),%edx
  801285:	89 cb                	mov    %ecx,%ebx
  801287:	89 cf                	mov    %ecx,%edi
  801289:	89 ce                	mov    %ecx,%esi
  80128b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80128d:	85 c0                	test   %eax,%eax
  80128f:	7e 28                	jle    8012b9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801291:	89 44 24 10          	mov    %eax,0x10(%esp)
  801295:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80129c:	00 
  80129d:	c7 44 24 08 cf 27 80 	movl   $0x8027cf,0x8(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8012ac:	00 
  8012ad:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8012b4:	e8 ae f0 ff ff       	call   800367 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012b9:	83 c4 2c             	add    $0x2c,%esp
  8012bc:	5b                   	pop    %ebx
  8012bd:	5e                   	pop    %esi
  8012be:	5f                   	pop    %edi
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    
  8012c1:	66 90                	xchg   %ax,%ax
  8012c3:	66 90                	xchg   %ax,%ax
  8012c5:	66 90                	xchg   %ax,%ax
  8012c7:	66 90                	xchg   %ax,%ax
  8012c9:	66 90                	xchg   %ax,%ax
  8012cb:	66 90                	xchg   %ax,%ax
  8012cd:	66 90                	xchg   %ax,%ax
  8012cf:	90                   	nop

008012d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012db:	c1 e8 0c             	shr    $0xc,%eax
}
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    

008012f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012fa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012ff:	a8 01                	test   $0x1,%al
  801301:	74 34                	je     801337 <fd_alloc+0x40>
  801303:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801308:	a8 01                	test   $0x1,%al
  80130a:	74 32                	je     80133e <fd_alloc+0x47>
  80130c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801311:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801313:	89 c2                	mov    %eax,%edx
  801315:	c1 ea 16             	shr    $0x16,%edx
  801318:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131f:	f6 c2 01             	test   $0x1,%dl
  801322:	74 1f                	je     801343 <fd_alloc+0x4c>
  801324:	89 c2                	mov    %eax,%edx
  801326:	c1 ea 0c             	shr    $0xc,%edx
  801329:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801330:	f6 c2 01             	test   $0x1,%dl
  801333:	75 1a                	jne    80134f <fd_alloc+0x58>
  801335:	eb 0c                	jmp    801343 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801337:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80133c:	eb 05                	jmp    801343 <fd_alloc+0x4c>
  80133e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 08                	mov    %ecx,(%eax)
			return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
  80134d:	eb 1a                	jmp    801369 <fd_alloc+0x72>
  80134f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801354:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801359:	75 b6                	jne    801311 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801364:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801371:	83 f8 1f             	cmp    $0x1f,%eax
  801374:	77 36                	ja     8013ac <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801376:	c1 e0 0c             	shl    $0xc,%eax
  801379:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80137e:	89 c2                	mov    %eax,%edx
  801380:	c1 ea 16             	shr    $0x16,%edx
  801383:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138a:	f6 c2 01             	test   $0x1,%dl
  80138d:	74 24                	je     8013b3 <fd_lookup+0x48>
  80138f:	89 c2                	mov    %eax,%edx
  801391:	c1 ea 0c             	shr    $0xc,%edx
  801394:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139b:	f6 c2 01             	test   $0x1,%dl
  80139e:	74 1a                	je     8013ba <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb 13                	jmp    8013bf <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b1:	eb 0c                	jmp    8013bf <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b8:	eb 05                	jmp    8013bf <fd_lookup+0x54>
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    

008013c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	53                   	push   %ebx
  8013c5:	83 ec 14             	sub    $0x14,%esp
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013ce:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8013d4:	75 1e                	jne    8013f4 <dev_lookup+0x33>
  8013d6:	eb 0e                	jmp    8013e6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013d8:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8013dd:	eb 0c                	jmp    8013eb <dev_lookup+0x2a>
  8013df:	b8 00 30 80 00       	mov    $0x803000,%eax
  8013e4:	eb 05                	jmp    8013eb <dev_lookup+0x2a>
  8013e6:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8013eb:	89 03                	mov    %eax,(%ebx)
			return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb 38                	jmp    80142c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8013f4:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8013fa:	74 dc                	je     8013d8 <dev_lookup+0x17>
  8013fc:	39 05 00 30 80 00    	cmp    %eax,0x803000
  801402:	74 db                	je     8013df <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801404:	8b 15 04 44 80 00    	mov    0x804404,%edx
  80140a:	8b 52 48             	mov    0x48(%edx),%edx
  80140d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801411:	89 54 24 04          	mov    %edx,0x4(%esp)
  801415:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  80141c:	e8 3f f0 ff ff       	call   800460 <cprintf>
	*dev = 0;
  801421:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80142c:	83 c4 14             	add    $0x14,%esp
  80142f:	5b                   	pop    %ebx
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	56                   	push   %esi
  801436:	53                   	push   %ebx
  801437:	83 ec 20             	sub    $0x20,%esp
  80143a:	8b 75 08             	mov    0x8(%ebp),%esi
  80143d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801440:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801443:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801447:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80144d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801450:	89 04 24             	mov    %eax,(%esp)
  801453:	e8 13 ff ff ff       	call   80136b <fd_lookup>
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 05                	js     801461 <fd_close+0x2f>
	    || fd != fd2)
  80145c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80145f:	74 0c                	je     80146d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801461:	84 db                	test   %bl,%bl
  801463:	ba 00 00 00 00       	mov    $0x0,%edx
  801468:	0f 44 c2             	cmove  %edx,%eax
  80146b:	eb 3f                	jmp    8014ac <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80146d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801470:	89 44 24 04          	mov    %eax,0x4(%esp)
  801474:	8b 06                	mov    (%esi),%eax
  801476:	89 04 24             	mov    %eax,(%esp)
  801479:	e8 43 ff ff ff       	call   8013c1 <dev_lookup>
  80147e:	89 c3                	mov    %eax,%ebx
  801480:	85 c0                	test   %eax,%eax
  801482:	78 16                	js     80149a <fd_close+0x68>
		if (dev->dev_close)
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801487:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80148a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80148f:	85 c0                	test   %eax,%eax
  801491:	74 07                	je     80149a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801493:	89 34 24             	mov    %esi,(%esp)
  801496:	ff d0                	call   *%eax
  801498:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80149a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80149e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a5:	e8 56 fc ff ff       	call   801100 <sys_page_unmap>
	return r;
  8014aa:	89 d8                	mov    %ebx,%eax
}
  8014ac:	83 c4 20             	add    $0x20,%esp
  8014af:	5b                   	pop    %ebx
  8014b0:	5e                   	pop    %esi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 04 24             	mov    %eax,(%esp)
  8014c6:	e8 a0 fe ff ff       	call   80136b <fd_lookup>
  8014cb:	89 c2                	mov    %eax,%edx
  8014cd:	85 d2                	test   %edx,%edx
  8014cf:	78 13                	js     8014e4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014d8:	00 
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	89 04 24             	mov    %eax,(%esp)
  8014df:	e8 4e ff ff ff       	call   801432 <fd_close>
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <close_all>:

void
close_all(void)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	53                   	push   %ebx
  8014ea:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014f2:	89 1c 24             	mov    %ebx,(%esp)
  8014f5:	e8 b9 ff ff ff       	call   8014b3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014fa:	83 c3 01             	add    $0x1,%ebx
  8014fd:	83 fb 20             	cmp    $0x20,%ebx
  801500:	75 f0                	jne    8014f2 <close_all+0xc>
		close(i);
}
  801502:	83 c4 14             	add    $0x14,%esp
  801505:	5b                   	pop    %ebx
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    

00801508 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	57                   	push   %edi
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801511:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801514:	89 44 24 04          	mov    %eax,0x4(%esp)
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 48 fe ff ff       	call   80136b <fd_lookup>
  801523:	89 c2                	mov    %eax,%edx
  801525:	85 d2                	test   %edx,%edx
  801527:	0f 88 e1 00 00 00    	js     80160e <dup+0x106>
		return r;
	close(newfdnum);
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 04 24             	mov    %eax,(%esp)
  801533:	e8 7b ff ff ff       	call   8014b3 <close>

	newfd = INDEX2FD(newfdnum);
  801538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80153b:	c1 e3 0c             	shl    $0xc,%ebx
  80153e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 91 fd ff ff       	call   8012e0 <fd2data>
  80154f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801551:	89 1c 24             	mov    %ebx,(%esp)
  801554:	e8 87 fd ff ff       	call   8012e0 <fd2data>
  801559:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80155b:	89 f0                	mov    %esi,%eax
  80155d:	c1 e8 16             	shr    $0x16,%eax
  801560:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801567:	a8 01                	test   $0x1,%al
  801569:	74 43                	je     8015ae <dup+0xa6>
  80156b:	89 f0                	mov    %esi,%eax
  80156d:	c1 e8 0c             	shr    $0xc,%eax
  801570:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801577:	f6 c2 01             	test   $0x1,%dl
  80157a:	74 32                	je     8015ae <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80157c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801583:	25 07 0e 00 00       	and    $0xe07,%eax
  801588:	89 44 24 10          	mov    %eax,0x10(%esp)
  80158c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801590:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801597:	00 
  801598:	89 74 24 04          	mov    %esi,0x4(%esp)
  80159c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a3:	e8 05 fb ff ff       	call   8010ad <sys_page_map>
  8015a8:	89 c6                	mov    %eax,%esi
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 3e                	js     8015ec <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b1:	89 c2                	mov    %eax,%edx
  8015b3:	c1 ea 0c             	shr    $0xc,%edx
  8015b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015bd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015d2:	00 
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015de:	e8 ca fa ff ff       	call   8010ad <sys_page_map>
  8015e3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015e8:	85 f6                	test   %esi,%esi
  8015ea:	79 22                	jns    80160e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f7:	e8 04 fb ff ff       	call   801100 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801600:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801607:	e8 f4 fa ff ff       	call   801100 <sys_page_unmap>
	return r;
  80160c:	89 f0                	mov    %esi,%eax
}
  80160e:	83 c4 3c             	add    $0x3c,%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 24             	sub    $0x24,%esp
  80161d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	89 44 24 04          	mov    %eax,0x4(%esp)
  801627:	89 1c 24             	mov    %ebx,(%esp)
  80162a:	e8 3c fd ff ff       	call   80136b <fd_lookup>
  80162f:	89 c2                	mov    %eax,%edx
  801631:	85 d2                	test   %edx,%edx
  801633:	78 6d                	js     8016a2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801635:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	8b 00                	mov    (%eax),%eax
  801641:	89 04 24             	mov    %eax,(%esp)
  801644:	e8 78 fd ff ff       	call   8013c1 <dev_lookup>
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 55                	js     8016a2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801650:	8b 50 08             	mov    0x8(%eax),%edx
  801653:	83 e2 03             	and    $0x3,%edx
  801656:	83 fa 01             	cmp    $0x1,%edx
  801659:	75 23                	jne    80167e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80165b:	a1 04 44 80 00       	mov    0x804404,%eax
  801660:	8b 40 48             	mov    0x48(%eax),%eax
  801663:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  801672:	e8 e9 ed ff ff       	call   800460 <cprintf>
		return -E_INVAL;
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb 24                	jmp    8016a2 <read+0x8c>
	}
	if (!dev->dev_read)
  80167e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801681:	8b 52 08             	mov    0x8(%edx),%edx
  801684:	85 d2                	test   %edx,%edx
  801686:	74 15                	je     80169d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801688:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80168f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801696:	89 04 24             	mov    %eax,(%esp)
  801699:	ff d2                	call   *%edx
  80169b:	eb 05                	jmp    8016a2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80169d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016a2:	83 c4 24             	add    $0x24,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	57                   	push   %edi
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 1c             	sub    $0x1c,%esp
  8016b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016b7:	85 f6                	test   %esi,%esi
  8016b9:	74 33                	je     8016ee <readn+0x46>
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c5:	89 f2                	mov    %esi,%edx
  8016c7:	29 c2                	sub    %eax,%edx
  8016c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016cd:	03 45 0c             	add    0xc(%ebp),%eax
  8016d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d4:	89 3c 24             	mov    %edi,(%esp)
  8016d7:	e8 3a ff ff ff       	call   801616 <read>
		if (m < 0)
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 1b                	js     8016fb <readn+0x53>
			return m;
		if (m == 0)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	74 11                	je     8016f5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016e4:	01 c3                	add    %eax,%ebx
  8016e6:	89 d8                	mov    %ebx,%eax
  8016e8:	39 f3                	cmp    %esi,%ebx
  8016ea:	72 d9                	jb     8016c5 <readn+0x1d>
  8016ec:	eb 0b                	jmp    8016f9 <readn+0x51>
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 06                	jmp    8016fb <readn+0x53>
  8016f5:	89 d8                	mov    %ebx,%eax
  8016f7:	eb 02                	jmp    8016fb <readn+0x53>
  8016f9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016fb:	83 c4 1c             	add    $0x1c,%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5f                   	pop    %edi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	53                   	push   %ebx
  801707:	83 ec 24             	sub    $0x24,%esp
  80170a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801710:	89 44 24 04          	mov    %eax,0x4(%esp)
  801714:	89 1c 24             	mov    %ebx,(%esp)
  801717:	e8 4f fc ff ff       	call   80136b <fd_lookup>
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	85 d2                	test   %edx,%edx
  801720:	78 68                	js     80178a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801725:	89 44 24 04          	mov    %eax,0x4(%esp)
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	8b 00                	mov    (%eax),%eax
  80172e:	89 04 24             	mov    %eax,(%esp)
  801731:	e8 8b fc ff ff       	call   8013c1 <dev_lookup>
  801736:	85 c0                	test   %eax,%eax
  801738:	78 50                	js     80178a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801741:	75 23                	jne    801766 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801743:	a1 04 44 80 00       	mov    0x804404,%eax
  801748:	8b 40 48             	mov    0x48(%eax),%eax
  80174b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80174f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801753:	c7 04 24 5c 28 80 00 	movl   $0x80285c,(%esp)
  80175a:	e8 01 ed ff ff       	call   800460 <cprintf>
		return -E_INVAL;
  80175f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801764:	eb 24                	jmp    80178a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801769:	8b 52 0c             	mov    0xc(%edx),%edx
  80176c:	85 d2                	test   %edx,%edx
  80176e:	74 15                	je     801785 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801770:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801773:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801777:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80177a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80177e:	89 04 24             	mov    %eax,(%esp)
  801781:	ff d2                	call   *%edx
  801783:	eb 05                	jmp    80178a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801785:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80178a:	83 c4 24             	add    $0x24,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <seek>:

int
seek(int fdnum, off_t offset)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801796:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	89 04 24             	mov    %eax,(%esp)
  8017a3:	e8 c3 fb ff ff       	call   80136b <fd_lookup>
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	78 0e                	js     8017ba <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 24             	sub    $0x24,%esp
  8017c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	89 1c 24             	mov    %ebx,(%esp)
  8017d0:	e8 96 fb ff ff       	call   80136b <fd_lookup>
  8017d5:	89 c2                	mov    %eax,%edx
  8017d7:	85 d2                	test   %edx,%edx
  8017d9:	78 61                	js     80183c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	8b 00                	mov    (%eax),%eax
  8017e7:	89 04 24             	mov    %eax,(%esp)
  8017ea:	e8 d2 fb ff ff       	call   8013c1 <dev_lookup>
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 49                	js     80183c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017fa:	75 23                	jne    80181f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017fc:	a1 04 44 80 00       	mov    0x804404,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801801:	8b 40 48             	mov    0x48(%eax),%eax
  801804:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180c:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  801813:	e8 48 ec ff ff       	call   800460 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801818:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181d:	eb 1d                	jmp    80183c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80181f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801822:	8b 52 18             	mov    0x18(%edx),%edx
  801825:	85 d2                	test   %edx,%edx
  801827:	74 0e                	je     801837 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80182c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801830:	89 04 24             	mov    %eax,(%esp)
  801833:	ff d2                	call   *%edx
  801835:	eb 05                	jmp    80183c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801837:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80183c:	83 c4 24             	add    $0x24,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	53                   	push   %ebx
  801846:	83 ec 24             	sub    $0x24,%esp
  801849:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 0d fb ff ff       	call   80136b <fd_lookup>
  80185e:	89 c2                	mov    %eax,%edx
  801860:	85 d2                	test   %edx,%edx
  801862:	78 52                	js     8018b6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	8b 00                	mov    (%eax),%eax
  801870:	89 04 24             	mov    %eax,(%esp)
  801873:	e8 49 fb ff ff       	call   8013c1 <dev_lookup>
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 3a                	js     8018b6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801883:	74 2c                	je     8018b1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801885:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801888:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80188f:	00 00 00 
	stat->st_isdir = 0;
  801892:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801899:	00 00 00 
	stat->st_dev = dev;
  80189c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a9:	89 14 24             	mov    %edx,(%esp)
  8018ac:	ff 50 14             	call   *0x14(%eax)
  8018af:	eb 05                	jmp    8018b6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018b6:	83 c4 24             	add    $0x24,%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018cb:	00 
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 e1 01 00 00       	call   801ab8 <open>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 db                	test   %ebx,%ebx
  8018db:	78 1b                	js     8018f8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e4:	89 1c 24             	mov    %ebx,(%esp)
  8018e7:	e8 56 ff ff ff       	call   801842 <fstat>
  8018ec:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ee:	89 1c 24             	mov    %ebx,(%esp)
  8018f1:	e8 bd fb ff ff       	call   8014b3 <close>
	return r;
  8018f6:	89 f0                	mov    %esi,%eax
}
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 10             	sub    $0x10,%esp
  801907:	89 c3                	mov    %eax,%ebx
  801909:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80190b:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801912:	75 11                	jne    801925 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80191b:	e8 dd 07 00 00       	call   8020fd <ipc_find_env>
  801920:	a3 00 44 80 00       	mov    %eax,0x804400

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  801925:	a1 04 44 80 00       	mov    0x804404,%eax
  80192a:	8b 40 48             	mov    0x48(%eax),%eax
  80192d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  801933:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193f:	c7 04 24 79 28 80 00 	movl   $0x802879,(%esp)
  801946:	e8 15 eb ff ff       	call   800460 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80194b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801952:	00 
  801953:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80195a:	00 
  80195b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80195f:	a1 00 44 80 00       	mov    0x804400,%eax
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	e8 2b 07 00 00       	call   802097 <ipc_send>
	cprintf("ipc_send\n");
  80196c:	c7 04 24 8f 28 80 00 	movl   $0x80288f,(%esp)
  801973:	e8 e8 ea ff ff       	call   800460 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  801978:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80197f:	00 
  801980:	89 74 24 04          	mov    %esi,0x4(%esp)
  801984:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198b:	e8 9f 06 00 00       	call   80202f <ipc_recv>
}
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 14             	sub    $0x14,%esp
  80199e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b6:	e8 44 ff ff ff       	call   8018ff <fsipc>
  8019bb:	89 c2                	mov    %eax,%edx
  8019bd:	85 d2                	test   %edx,%edx
  8019bf:	78 2b                	js     8019ec <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c1:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019c8:	00 
  8019c9:	89 1c 24             	mov    %ebx,(%esp)
  8019cc:	e8 da f1 ff ff       	call   800bab <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d1:	a1 80 50 80 00       	mov    0x805080,%eax
  8019d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019dc:	a1 84 50 80 00       	mov    0x805084,%eax
  8019e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ec:	83 c4 14             	add    $0x14,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    

008019f2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fe:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a03:	ba 00 00 00 00       	mov    $0x0,%edx
  801a08:	b8 06 00 00 00       	mov    $0x6,%eax
  801a0d:	e8 ed fe ff ff       	call   8018ff <fsipc>
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	83 ec 10             	sub    $0x10,%esp
  801a1c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
  801a25:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a2a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	b8 03 00 00 00       	mov    $0x3,%eax
  801a3a:	e8 c0 fe ff ff       	call   8018ff <fsipc>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 6a                	js     801aaf <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a45:	39 c6                	cmp    %eax,%esi
  801a47:	73 24                	jae    801a6d <devfile_read+0x59>
  801a49:	c7 44 24 0c 99 28 80 	movl   $0x802899,0xc(%esp)
  801a50:	00 
  801a51:	c7 44 24 08 a0 28 80 	movl   $0x8028a0,0x8(%esp)
  801a58:	00 
  801a59:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801a60:	00 
  801a61:	c7 04 24 b5 28 80 00 	movl   $0x8028b5,(%esp)
  801a68:	e8 fa e8 ff ff       	call   800367 <_panic>
	assert(r <= PGSIZE);
  801a6d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a72:	7e 24                	jle    801a98 <devfile_read+0x84>
  801a74:	c7 44 24 0c c0 28 80 	movl   $0x8028c0,0xc(%esp)
  801a7b:	00 
  801a7c:	c7 44 24 08 a0 28 80 	movl   $0x8028a0,0x8(%esp)
  801a83:	00 
  801a84:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801a8b:	00 
  801a8c:	c7 04 24 b5 28 80 00 	movl   $0x8028b5,(%esp)
  801a93:	e8 cf e8 ff ff       	call   800367 <_panic>
	memmove(buf, &fsipcbuf, r);
  801a98:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801aa3:	00 
  801aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa7:	89 04 24             	mov    %eax,(%esp)
  801aaa:	e8 f7 f2 ff ff       	call   800da6 <memmove>
	return r;
}
  801aaf:	89 d8                	mov    %ebx,%eax
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    

00801ab8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	53                   	push   %ebx
  801abc:	83 ec 24             	sub    $0x24,%esp
  801abf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ac2:	89 1c 24             	mov    %ebx,(%esp)
  801ac5:	e8 86 f0 ff ff       	call   800b50 <strlen>
  801aca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801acf:	7f 60                	jg     801b31 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ad1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad4:	89 04 24             	mov    %eax,(%esp)
  801ad7:	e8 1b f8 ff ff       	call   8012f7 <fd_alloc>
  801adc:	89 c2                	mov    %eax,%edx
  801ade:	85 d2                	test   %edx,%edx
  801ae0:	78 54                	js     801b36 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ae2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae6:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801aed:	e8 b9 f0 ff ff       	call   800bab <strcpy>
	fsipcbuf.open.req_omode = mode;
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801afd:	b8 01 00 00 00       	mov    $0x1,%eax
  801b02:	e8 f8 fd ff ff       	call   8018ff <fsipc>
  801b07:	89 c3                	mov    %eax,%ebx
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	79 17                	jns    801b24 <open+0x6c>
		fd_close(fd, 0);
  801b0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b14:	00 
  801b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	e8 12 f9 ff ff       	call   801432 <fd_close>
		return r;
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	eb 12                	jmp    801b36 <open+0x7e>
	}
	return fd2num(fd);
  801b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b27:	89 04 24             	mov    %eax,(%esp)
  801b2a:	e8 a1 f7 ff ff       	call   8012d0 <fd2num>
  801b2f:	eb 05                	jmp    801b36 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b31:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801b36:	83 c4 24             	add    $0x24,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 14             	sub    $0x14,%esp
  801b43:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b45:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b49:	7e 31                	jle    801b7c <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b4b:	8b 40 04             	mov    0x4(%eax),%eax
  801b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b52:	8d 43 10             	lea    0x10(%ebx),%eax
  801b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b59:	8b 03                	mov    (%ebx),%eax
  801b5b:	89 04 24             	mov    %eax,(%esp)
  801b5e:	e8 a0 fb ff ff       	call   801703 <write>
		if (result > 0)
  801b63:	85 c0                	test   %eax,%eax
  801b65:	7e 03                	jle    801b6a <writebuf+0x2e>
			b->result += result;
  801b67:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b6a:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b6d:	74 0d                	je     801b7c <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	ba 00 00 00 00       	mov    $0x0,%edx
  801b76:	0f 4f c2             	cmovg  %edx,%eax
  801b79:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b7c:	83 c4 14             	add    $0x14,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    

00801b82 <putch>:

static void
putch(int ch, void *thunk)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	53                   	push   %ebx
  801b86:	83 ec 04             	sub    $0x4,%esp
  801b89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b8c:	8b 53 04             	mov    0x4(%ebx),%edx
  801b8f:	8d 42 01             	lea    0x1(%edx),%eax
  801b92:	89 43 04             	mov    %eax,0x4(%ebx)
  801b95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b98:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b9c:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ba1:	75 0e                	jne    801bb1 <putch+0x2f>
		writebuf(b);
  801ba3:	89 d8                	mov    %ebx,%eax
  801ba5:	e8 92 ff ff ff       	call   801b3c <writebuf>
		b->idx = 0;
  801baa:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801bb1:	83 c4 04             	add    $0x4,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    

00801bb7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bc9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bd0:	00 00 00 
	b.result = 0;
  801bd3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bda:	00 00 00 
	b.error = 1;
  801bdd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801be4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801be7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bff:	c7 04 24 82 1b 80 00 	movl   $0x801b82,(%esp)
  801c06:	e8 e9 e9 ff ff       	call   8005f4 <vprintfmt>
	if (b.idx > 0)
  801c0b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c12:	7e 0b                	jle    801c1f <vfprintf+0x68>
		writebuf(&b);
  801c14:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c1a:	e8 1d ff ff ff       	call   801b3c <writebuf>

	return (b.result ? b.result : b.error);
  801c1f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c25:	85 c0                	test   %eax,%eax
  801c27:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c36:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c39:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 68 ff ff ff       	call   801bb7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <printf>:

int
printf(const char *fmt, ...)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c57:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c6c:	e8 46 ff ff ff       	call   801bb7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    
  801c73:	66 90                	xchg   %ax,%ax
  801c75:	66 90                	xchg   %ax,%ax
  801c77:	66 90                	xchg   %ax,%ax
  801c79:	66 90                	xchg   %ax,%ax
  801c7b:	66 90                	xchg   %ax,%ax
  801c7d:	66 90                	xchg   %ax,%ax
  801c7f:	90                   	nop

00801c80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
  801c88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 4a f6 ff ff       	call   8012e0 <fd2data>
  801c96:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c98:	c7 44 24 04 cc 28 80 	movl   $0x8028cc,0x4(%esp)
  801c9f:	00 
  801ca0:	89 1c 24             	mov    %ebx,(%esp)
  801ca3:	e8 03 ef ff ff       	call   800bab <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca8:	8b 46 04             	mov    0x4(%esi),%eax
  801cab:	2b 06                	sub    (%esi),%eax
  801cad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cba:	00 00 00 
	stat->st_dev = &devpipe;
  801cbd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cc4:	30 80 00 
	return 0;
}
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 14             	sub    $0x14,%esp
  801cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce8:	e8 13 f4 ff ff       	call   801100 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 eb f5 ff ff       	call   8012e0 <fd2data>
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d00:	e8 fb f3 ff ff       	call   801100 <sys_page_unmap>
}
  801d05:	83 c4 14             	add    $0x14,%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    

00801d0b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	57                   	push   %edi
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	83 ec 2c             	sub    $0x2c,%esp
  801d14:	89 c6                	mov    %eax,%esi
  801d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d19:	a1 04 44 80 00       	mov    0x804404,%eax
  801d1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d21:	89 34 24             	mov    %esi,(%esp)
  801d24:	e8 1c 04 00 00       	call   802145 <pageref>
  801d29:	89 c7                	mov    %eax,%edi
  801d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 0f 04 00 00       	call   802145 <pageref>
  801d36:	39 c7                	cmp    %eax,%edi
  801d38:	0f 94 c2             	sete   %dl
  801d3b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d3e:	8b 0d 04 44 80 00    	mov    0x804404,%ecx
  801d44:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d47:	39 fb                	cmp    %edi,%ebx
  801d49:	74 21                	je     801d6c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d4b:	84 d2                	test   %dl,%dl
  801d4d:	74 ca                	je     801d19 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d4f:	8b 51 58             	mov    0x58(%ecx),%edx
  801d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5e:	c7 04 24 d3 28 80 00 	movl   $0x8028d3,(%esp)
  801d65:	e8 f6 e6 ff ff       	call   800460 <cprintf>
  801d6a:	eb ad                	jmp    801d19 <_pipeisclosed+0xe>
	}
}
  801d6c:	83 c4 2c             	add    $0x2c,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	57                   	push   %edi
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 1c             	sub    $0x1c,%esp
  801d7d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801d80:	89 34 24             	mov    %esi,(%esp)
  801d83:	e8 58 f5 ff ff       	call   8012e0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d8c:	74 61                	je     801def <devpipe_write+0x7b>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	bf 00 00 00 00       	mov    $0x0,%edi
  801d95:	eb 4a                	jmp    801de1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	e8 6b ff ff ff       	call   801d0b <_pipeisclosed>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 54                	jne    801df8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801da4:	e8 91 f2 ff ff       	call   80103a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dac:	8b 0b                	mov    (%ebx),%ecx
  801dae:	8d 51 20             	lea    0x20(%ecx),%edx
  801db1:	39 d0                	cmp    %edx,%eax
  801db3:	73 e2                	jae    801d97 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dbc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dbf:	99                   	cltd   
  801dc0:	c1 ea 1b             	shr    $0x1b,%edx
  801dc3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801dc6:	83 e1 1f             	and    $0x1f,%ecx
  801dc9:	29 d1                	sub    %edx,%ecx
  801dcb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801dcf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801dd3:	83 c0 01             	add    $0x1,%eax
  801dd6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dd9:	83 c7 01             	add    $0x1,%edi
  801ddc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ddf:	74 13                	je     801df4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de1:	8b 43 04             	mov    0x4(%ebx),%eax
  801de4:	8b 0b                	mov    (%ebx),%ecx
  801de6:	8d 51 20             	lea    0x20(%ecx),%edx
  801de9:	39 d0                	cmp    %edx,%eax
  801deb:	73 aa                	jae    801d97 <devpipe_write+0x23>
  801ded:	eb c6                	jmp    801db5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801def:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801df4:	89 f8                	mov    %edi,%eax
  801df6:	eb 05                	jmp    801dfd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    

00801e05 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	57                   	push   %edi
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 1c             	sub    $0x1c,%esp
  801e0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e11:	89 3c 24             	mov    %edi,(%esp)
  801e14:	e8 c7 f4 ff ff       	call   8012e0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e1d:	74 54                	je     801e73 <devpipe_read+0x6e>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
  801e26:	eb 3e                	jmp    801e66 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801e28:	89 f0                	mov    %esi,%eax
  801e2a:	eb 55                	jmp    801e81 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	89 f8                	mov    %edi,%eax
  801e30:	e8 d6 fe ff ff       	call   801d0b <_pipeisclosed>
  801e35:	85 c0                	test   %eax,%eax
  801e37:	75 43                	jne    801e7c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e39:	e8 fc f1 ff ff       	call   80103a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e3e:	8b 03                	mov    (%ebx),%eax
  801e40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e43:	74 e7                	je     801e2c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e45:	99                   	cltd   
  801e46:	c1 ea 1b             	shr    $0x1b,%edx
  801e49:	01 d0                	add    %edx,%eax
  801e4b:	83 e0 1f             	and    $0x1f,%eax
  801e4e:	29 d0                	sub    %edx,%eax
  801e50:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e58:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e5b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e5e:	83 c6 01             	add    $0x1,%esi
  801e61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e64:	74 12                	je     801e78 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801e66:	8b 03                	mov    (%ebx),%eax
  801e68:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e6b:	75 d8                	jne    801e45 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e6d:	85 f6                	test   %esi,%esi
  801e6f:	75 b7                	jne    801e28 <devpipe_read+0x23>
  801e71:	eb b9                	jmp    801e2c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e73:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e78:	89 f0                	mov    %esi,%eax
  801e7a:	eb 05                	jmp    801e81 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e81:	83 c4 1c             	add    $0x1c,%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e94:	89 04 24             	mov    %eax,(%esp)
  801e97:	e8 5b f4 ff ff       	call   8012f7 <fd_alloc>
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	85 d2                	test   %edx,%edx
  801ea0:	0f 88 4d 01 00 00    	js     801ff3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ead:	00 
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebc:	e8 98 f1 ff ff       	call   801059 <sys_page_alloc>
  801ec1:	89 c2                	mov    %eax,%edx
  801ec3:	85 d2                	test   %edx,%edx
  801ec5:	0f 88 28 01 00 00    	js     801ff3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ece:	89 04 24             	mov    %eax,(%esp)
  801ed1:	e8 21 f4 ff ff       	call   8012f7 <fd_alloc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 88 fe 00 00 00    	js     801fde <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee7:	00 
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef6:	e8 5e f1 ff ff       	call   801059 <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 d9 00 00 00    	js     801fde <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 d0 f3 ff ff       	call   8012e0 <fd2data>
  801f10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f19:	00 
  801f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f25:	e8 2f f1 ff ff       	call   801059 <sys_page_alloc>
  801f2a:	89 c3                	mov    %eax,%ebx
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 97 00 00 00    	js     801fcb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	89 04 24             	mov    %eax,(%esp)
  801f3a:	e8 a1 f3 ff ff       	call   8012e0 <fd2data>
  801f3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f46:	00 
  801f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f52:	00 
  801f53:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5e:	e8 4a f1 ff ff       	call   8010ad <sys_page_map>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 52                	js     801fbb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f69:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f7e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 32 f3 ff ff       	call   8012d0 <fd2num>
  801f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 22 f3 ff ff       	call   8012d0 <fd2num>
  801fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	eb 38                	jmp    801ff3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 35 f1 ff ff       	call   801100 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd9:	e8 22 f1 ff ff       	call   801100 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 0f f1 ff ff       	call   801100 <sys_page_unmap>
  801ff1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801ff3:	83 c4 30             	add    $0x30,%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5e                   	pop    %esi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802000:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 59 f3 ff ff       	call   80136b <fd_lookup>
  802012:	89 c2                	mov    %eax,%edx
  802014:	85 d2                	test   %edx,%edx
  802016:	78 15                	js     80202d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	89 04 24             	mov    %eax,(%esp)
  80201e:	e8 bd f2 ff ff       	call   8012e0 <fd2data>
	return _pipeisclosed(fd, p);
  802023:	89 c2                	mov    %eax,%edx
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	e8 de fc ff ff       	call   801d0b <_pipeisclosed>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 10             	sub    $0x10,%esp
  802037:	8b 75 08             	mov    0x8(%ebp),%esi
  80203a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  802040:	85 c0                	test   %eax,%eax
  802042:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802047:	0f 44 c2             	cmove  %edx,%eax
  80204a:	89 04 24             	mov    %eax,(%esp)
  80204d:	e8 1d f2 ff ff       	call   80126f <sys_ipc_recv>
	if (err_code < 0) {
  802052:	85 c0                	test   %eax,%eax
  802054:	79 16                	jns    80206c <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  802056:	85 f6                	test   %esi,%esi
  802058:	74 06                	je     802060 <ipc_recv+0x31>
  80205a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802060:	85 db                	test   %ebx,%ebx
  802062:	74 2c                	je     802090 <ipc_recv+0x61>
  802064:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80206a:	eb 24                	jmp    802090 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80206c:	85 f6                	test   %esi,%esi
  80206e:	74 0a                	je     80207a <ipc_recv+0x4b>
  802070:	a1 04 44 80 00       	mov    0x804404,%eax
  802075:	8b 40 74             	mov    0x74(%eax),%eax
  802078:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  80207a:	85 db                	test   %ebx,%ebx
  80207c:	74 0a                	je     802088 <ipc_recv+0x59>
  80207e:	a1 04 44 80 00       	mov    0x804404,%eax
  802083:	8b 40 78             	mov    0x78(%eax),%eax
  802086:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  802088:	a1 04 44 80 00       	mov    0x804404,%eax
  80208d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5d                   	pop    %ebp
  802096:	c3                   	ret    

00802097 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	57                   	push   %edi
  80209b:	56                   	push   %esi
  80209c:	53                   	push   %ebx
  80209d:	83 ec 1c             	sub    $0x1c,%esp
  8020a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8020a9:	eb 25                	jmp    8020d0 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8020ab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ae:	74 20                	je     8020d0 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8020b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020b4:	c7 44 24 08 eb 28 80 	movl   $0x8028eb,0x8(%esp)
  8020bb:	00 
  8020bc:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8020c3:	00 
  8020c4:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  8020cb:	e8 97 e2 ff ff       	call   800367 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8020d0:	85 db                	test   %ebx,%ebx
  8020d2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020d7:	0f 45 c3             	cmovne %ebx,%eax
  8020da:	8b 55 14             	mov    0x14(%ebp),%edx
  8020dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020e9:	89 3c 24             	mov    %edi,(%esp)
  8020ec:	e8 5b f1 ff ff       	call   80124c <sys_ipc_try_send>
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	75 b6                	jne    8020ab <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8020f5:	83 c4 1c             	add    $0x1c,%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5e                   	pop    %esi
  8020fa:	5f                   	pop    %edi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    

008020fd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  802103:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  802108:	39 c8                	cmp    %ecx,%eax
  80210a:	74 17                	je     802123 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80210c:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802111:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802114:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80211a:	8b 52 50             	mov    0x50(%edx),%edx
  80211d:	39 ca                	cmp    %ecx,%edx
  80211f:	75 14                	jne    802135 <ipc_find_env+0x38>
  802121:	eb 05                	jmp    802128 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  802128:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80212b:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802130:	8b 40 40             	mov    0x40(%eax),%eax
  802133:	eb 0e                	jmp    802143 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802135:	83 c0 01             	add    $0x1,%eax
  802138:	3d 00 04 00 00       	cmp    $0x400,%eax
  80213d:	75 d2                	jne    802111 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80213f:	66 b8 00 00          	mov    $0x0,%ax
}
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    

00802145 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80214b:	89 d0                	mov    %edx,%eax
  80214d:	c1 e8 16             	shr    $0x16,%eax
  802150:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80215c:	f6 c1 01             	test   $0x1,%cl
  80215f:	74 1d                	je     80217e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802161:	c1 ea 0c             	shr    $0xc,%edx
  802164:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80216b:	f6 c2 01             	test   $0x1,%dl
  80216e:	74 0e                	je     80217e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802170:	c1 ea 0c             	shr    $0xc,%edx
  802173:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80217a:	ef 
  80217b:	0f b7 c0             	movzwl %ax,%eax
}
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    

00802180 <__udivdi3>:
  802180:	55                   	push   %ebp
  802181:	57                   	push   %edi
  802182:	56                   	push   %esi
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	8b 44 24 28          	mov    0x28(%esp),%eax
  80218a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80218e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802192:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802196:	85 c0                	test   %eax,%eax
  802198:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80219c:	89 ea                	mov    %ebp,%edx
  80219e:	89 0c 24             	mov    %ecx,(%esp)
  8021a1:	75 2d                	jne    8021d0 <__udivdi3+0x50>
  8021a3:	39 e9                	cmp    %ebp,%ecx
  8021a5:	77 61                	ja     802208 <__udivdi3+0x88>
  8021a7:	85 c9                	test   %ecx,%ecx
  8021a9:	89 ce                	mov    %ecx,%esi
  8021ab:	75 0b                	jne    8021b8 <__udivdi3+0x38>
  8021ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b2:	31 d2                	xor    %edx,%edx
  8021b4:	f7 f1                	div    %ecx
  8021b6:	89 c6                	mov    %eax,%esi
  8021b8:	31 d2                	xor    %edx,%edx
  8021ba:	89 e8                	mov    %ebp,%eax
  8021bc:	f7 f6                	div    %esi
  8021be:	89 c5                	mov    %eax,%ebp
  8021c0:	89 f8                	mov    %edi,%eax
  8021c2:	f7 f6                	div    %esi
  8021c4:	89 ea                	mov    %ebp,%edx
  8021c6:	83 c4 0c             	add    $0xc,%esp
  8021c9:	5e                   	pop    %esi
  8021ca:	5f                   	pop    %edi
  8021cb:	5d                   	pop    %ebp
  8021cc:	c3                   	ret    
  8021cd:	8d 76 00             	lea    0x0(%esi),%esi
  8021d0:	39 e8                	cmp    %ebp,%eax
  8021d2:	77 24                	ja     8021f8 <__udivdi3+0x78>
  8021d4:	0f bd e8             	bsr    %eax,%ebp
  8021d7:	83 f5 1f             	xor    $0x1f,%ebp
  8021da:	75 3c                	jne    802218 <__udivdi3+0x98>
  8021dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8021e0:	39 34 24             	cmp    %esi,(%esp)
  8021e3:	0f 86 9f 00 00 00    	jbe    802288 <__udivdi3+0x108>
  8021e9:	39 d0                	cmp    %edx,%eax
  8021eb:	0f 82 97 00 00 00    	jb     802288 <__udivdi3+0x108>
  8021f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	31 d2                	xor    %edx,%edx
  8021fa:	31 c0                	xor    %eax,%eax
  8021fc:	83 c4 0c             	add    $0xc,%esp
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    
  802203:	90                   	nop
  802204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802208:	89 f8                	mov    %edi,%eax
  80220a:	f7 f1                	div    %ecx
  80220c:	31 d2                	xor    %edx,%edx
  80220e:	83 c4 0c             	add    $0xc,%esp
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	89 e9                	mov    %ebp,%ecx
  80221a:	8b 3c 24             	mov    (%esp),%edi
  80221d:	d3 e0                	shl    %cl,%eax
  80221f:	89 c6                	mov    %eax,%esi
  802221:	b8 20 00 00 00       	mov    $0x20,%eax
  802226:	29 e8                	sub    %ebp,%eax
  802228:	89 c1                	mov    %eax,%ecx
  80222a:	d3 ef                	shr    %cl,%edi
  80222c:	89 e9                	mov    %ebp,%ecx
  80222e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802232:	8b 3c 24             	mov    (%esp),%edi
  802235:	09 74 24 08          	or     %esi,0x8(%esp)
  802239:	89 d6                	mov    %edx,%esi
  80223b:	d3 e7                	shl    %cl,%edi
  80223d:	89 c1                	mov    %eax,%ecx
  80223f:	89 3c 24             	mov    %edi,(%esp)
  802242:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802246:	d3 ee                	shr    %cl,%esi
  802248:	89 e9                	mov    %ebp,%ecx
  80224a:	d3 e2                	shl    %cl,%edx
  80224c:	89 c1                	mov    %eax,%ecx
  80224e:	d3 ef                	shr    %cl,%edi
  802250:	09 d7                	or     %edx,%edi
  802252:	89 f2                	mov    %esi,%edx
  802254:	89 f8                	mov    %edi,%eax
  802256:	f7 74 24 08          	divl   0x8(%esp)
  80225a:	89 d6                	mov    %edx,%esi
  80225c:	89 c7                	mov    %eax,%edi
  80225e:	f7 24 24             	mull   (%esp)
  802261:	39 d6                	cmp    %edx,%esi
  802263:	89 14 24             	mov    %edx,(%esp)
  802266:	72 30                	jb     802298 <__udivdi3+0x118>
  802268:	8b 54 24 04          	mov    0x4(%esp),%edx
  80226c:	89 e9                	mov    %ebp,%ecx
  80226e:	d3 e2                	shl    %cl,%edx
  802270:	39 c2                	cmp    %eax,%edx
  802272:	73 05                	jae    802279 <__udivdi3+0xf9>
  802274:	3b 34 24             	cmp    (%esp),%esi
  802277:	74 1f                	je     802298 <__udivdi3+0x118>
  802279:	89 f8                	mov    %edi,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	e9 7a ff ff ff       	jmp    8021fc <__udivdi3+0x7c>
  802282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802288:	31 d2                	xor    %edx,%edx
  80228a:	b8 01 00 00 00       	mov    $0x1,%eax
  80228f:	e9 68 ff ff ff       	jmp    8021fc <__udivdi3+0x7c>
  802294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802298:	8d 47 ff             	lea    -0x1(%edi),%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	83 c4 0c             	add    $0xc,%esp
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    
  8022a4:	66 90                	xchg   %ax,%ax
  8022a6:	66 90                	xchg   %ax,%ax
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__umoddi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	83 ec 14             	sub    $0x14,%esp
  8022b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8022ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8022be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8022c2:	89 c7                	mov    %eax,%edi
  8022c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8022cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8022d0:	89 34 24             	mov    %esi,(%esp)
  8022d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	89 c2                	mov    %eax,%edx
  8022db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022df:	75 17                	jne    8022f8 <__umoddi3+0x48>
  8022e1:	39 fe                	cmp    %edi,%esi
  8022e3:	76 4b                	jbe    802330 <__umoddi3+0x80>
  8022e5:	89 c8                	mov    %ecx,%eax
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	f7 f6                	div    %esi
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	31 d2                	xor    %edx,%edx
  8022ef:	83 c4 14             	add    $0x14,%esp
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	39 f8                	cmp    %edi,%eax
  8022fa:	77 54                	ja     802350 <__umoddi3+0xa0>
  8022fc:	0f bd e8             	bsr    %eax,%ebp
  8022ff:	83 f5 1f             	xor    $0x1f,%ebp
  802302:	75 5c                	jne    802360 <__umoddi3+0xb0>
  802304:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802308:	39 3c 24             	cmp    %edi,(%esp)
  80230b:	0f 87 e7 00 00 00    	ja     8023f8 <__umoddi3+0x148>
  802311:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802315:	29 f1                	sub    %esi,%ecx
  802317:	19 c7                	sbb    %eax,%edi
  802319:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80231d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802321:	8b 44 24 08          	mov    0x8(%esp),%eax
  802325:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802329:	83 c4 14             	add    $0x14,%esp
  80232c:	5e                   	pop    %esi
  80232d:	5f                   	pop    %edi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
  802330:	85 f6                	test   %esi,%esi
  802332:	89 f5                	mov    %esi,%ebp
  802334:	75 0b                	jne    802341 <__umoddi3+0x91>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	f7 f6                	div    %esi
  80233f:	89 c5                	mov    %eax,%ebp
  802341:	8b 44 24 04          	mov    0x4(%esp),%eax
  802345:	31 d2                	xor    %edx,%edx
  802347:	f7 f5                	div    %ebp
  802349:	89 c8                	mov    %ecx,%eax
  80234b:	f7 f5                	div    %ebp
  80234d:	eb 9c                	jmp    8022eb <__umoddi3+0x3b>
  80234f:	90                   	nop
  802350:	89 c8                	mov    %ecx,%eax
  802352:	89 fa                	mov    %edi,%edx
  802354:	83 c4 14             	add    $0x14,%esp
  802357:	5e                   	pop    %esi
  802358:	5f                   	pop    %edi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    
  80235b:	90                   	nop
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	8b 04 24             	mov    (%esp),%eax
  802363:	be 20 00 00 00       	mov    $0x20,%esi
  802368:	89 e9                	mov    %ebp,%ecx
  80236a:	29 ee                	sub    %ebp,%esi
  80236c:	d3 e2                	shl    %cl,%edx
  80236e:	89 f1                	mov    %esi,%ecx
  802370:	d3 e8                	shr    %cl,%eax
  802372:	89 e9                	mov    %ebp,%ecx
  802374:	89 44 24 04          	mov    %eax,0x4(%esp)
  802378:	8b 04 24             	mov    (%esp),%eax
  80237b:	09 54 24 04          	or     %edx,0x4(%esp)
  80237f:	89 fa                	mov    %edi,%edx
  802381:	d3 e0                	shl    %cl,%eax
  802383:	89 f1                	mov    %esi,%ecx
  802385:	89 44 24 08          	mov    %eax,0x8(%esp)
  802389:	8b 44 24 10          	mov    0x10(%esp),%eax
  80238d:	d3 ea                	shr    %cl,%edx
  80238f:	89 e9                	mov    %ebp,%ecx
  802391:	d3 e7                	shl    %cl,%edi
  802393:	89 f1                	mov    %esi,%ecx
  802395:	d3 e8                	shr    %cl,%eax
  802397:	89 e9                	mov    %ebp,%ecx
  802399:	09 f8                	or     %edi,%eax
  80239b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80239f:	f7 74 24 04          	divl   0x4(%esp)
  8023a3:	d3 e7                	shl    %cl,%edi
  8023a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023a9:	89 d7                	mov    %edx,%edi
  8023ab:	f7 64 24 08          	mull   0x8(%esp)
  8023af:	39 d7                	cmp    %edx,%edi
  8023b1:	89 c1                	mov    %eax,%ecx
  8023b3:	89 14 24             	mov    %edx,(%esp)
  8023b6:	72 2c                	jb     8023e4 <__umoddi3+0x134>
  8023b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8023bc:	72 22                	jb     8023e0 <__umoddi3+0x130>
  8023be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8023c2:	29 c8                	sub    %ecx,%eax
  8023c4:	19 d7                	sbb    %edx,%edi
  8023c6:	89 e9                	mov    %ebp,%ecx
  8023c8:	89 fa                	mov    %edi,%edx
  8023ca:	d3 e8                	shr    %cl,%eax
  8023cc:	89 f1                	mov    %esi,%ecx
  8023ce:	d3 e2                	shl    %cl,%edx
  8023d0:	89 e9                	mov    %ebp,%ecx
  8023d2:	d3 ef                	shr    %cl,%edi
  8023d4:	09 d0                	or     %edx,%eax
  8023d6:	89 fa                	mov    %edi,%edx
  8023d8:	83 c4 14             	add    $0x14,%esp
  8023db:	5e                   	pop    %esi
  8023dc:	5f                   	pop    %edi
  8023dd:	5d                   	pop    %ebp
  8023de:	c3                   	ret    
  8023df:	90                   	nop
  8023e0:	39 d7                	cmp    %edx,%edi
  8023e2:	75 da                	jne    8023be <__umoddi3+0x10e>
  8023e4:	8b 14 24             	mov    (%esp),%edx
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8023ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8023f1:	eb cb                	jmp    8023be <__umoddi3+0x10e>
  8023f3:	90                   	nop
  8023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8023fc:	0f 82 0f ff ff ff    	jb     802311 <__umoddi3+0x61>
  802402:	e9 1a ff ff ff       	jmp    802321 <__umoddi3+0x71>
