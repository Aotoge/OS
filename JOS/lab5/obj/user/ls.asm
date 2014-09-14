
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 01 03 00 00       	call   800332 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800055:	74 23                	je     80007a <ls1+0x3a>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800057:	89 f0                	mov    %esi,%eax
  800059:	3c 01                	cmp    $0x1,%al
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	83 e0 c9             	and    $0xffffffc9,%eax
  800060:	83 c0 64             	add    $0x64,%eax
  800063:	89 44 24 08          	mov    %eax,0x8(%esp)
  800067:	8b 45 10             	mov    0x10(%ebp),%eax
  80006a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006e:	c7 04 24 62 26 80 00 	movl   $0x802662,(%esp)
  800075:	e8 65 1c 00 00       	call   801cdf <printf>
	if(prefix) {
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	74 38                	je     8000b6 <ls1+0x76>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007e:	b8 c8 26 80 00       	mov    $0x8026c8,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800083:	80 3b 00             	cmpb   $0x0,(%ebx)
  800086:	74 1a                	je     8000a2 <ls1+0x62>
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 30 0a 00 00       	call   800ac0 <strlen>
  800090:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
			sep = "/";
  800095:	b8 60 26 80 00       	mov    $0x802660,%eax
  80009a:	ba c8 26 80 00       	mov    $0x8026c8,%edx
  80009f:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000aa:	c7 04 24 6b 26 80 00 	movl   $0x80266b,(%esp)
  8000b1:	e8 29 1c 00 00       	call   801cdf <printf>
	}
	printf("%s", name);
  8000b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 e2 2a 80 00 	movl   $0x802ae2,(%esp)
  8000c4:	e8 16 1c 00 00       	call   801cdf <printf>
	if(flag['F'] && isdir)
  8000c9:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000d0:	74 12                	je     8000e4 <ls1+0xa4>
  8000d2:	89 f0                	mov    %esi,%eax
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0c                	je     8000e4 <ls1+0xa4>
		printf("/");
  8000d8:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  8000df:	e8 fb 1b 00 00       	call   801cdf <printf>
	printf("\n");
  8000e4:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8000eb:	e8 ef 1b 00 00       	call   801cdf <printf>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010d:	00 
  80010e:	89 3c 24             	mov    %edi,(%esp)
  800111:	e8 30 1a 00 00       	call   801b46 <open>
  800116:	89 c3                	mov    %eax,%ebx
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 08                	js     800124 <lsdir+0x2d>
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800122:	eb 57                	jmp    80017b <lsdir+0x84>
{
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
  800124:	89 44 24 10          	mov    %eax,0x10(%esp)
  800128:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80012c:	c7 44 24 08 70 26 80 	movl   $0x802670,0x8(%esp)
  800133:	00 
  800134:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013b:	00 
  80013c:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  800143:	e8 7b 02 00 00       	call   8003c3 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800148:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014f:	74 2a                	je     80017b <lsdir+0x84>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800151:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800155:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800166:	0f 94 c0             	sete   %al
  800169:	0f b6 c0             	movzbl %al,%eax
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 c5 fe ff ff       	call   800040 <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80017b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800182:	00 
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 d9 15 00 00       	call   801768 <readn>
  80018f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800194:	74 b2                	je     800148 <lsdir+0x51>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7e 20                	jle    8001ba <lsdir+0xc3>
		panic("short read in directory %s", path);
  80019a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80019e:	c7 44 24 08 86 26 80 	movl   $0x802686,0x8(%esp)
  8001a5:	00 
  8001a6:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ad:	00 
  8001ae:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  8001b5:	e8 09 02 00 00       	call   8003c3 <_panic>
	if (n < 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	79 24                	jns    8001e2 <lsdir+0xeb>
		panic("error reading directory %s: %e", path, n);
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c6:	c7 44 24 08 cc 26 80 	movl   $0x8026cc,0x8(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d5:	00 
  8001d6:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  8001dd:	e8 e1 01 00 00       	call   8003c3 <_panic>
}
  8001e2:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  8001f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001fa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 70 17 00 00       	call   80197c <stat>
  80020c:	85 c0                	test   %eax,%eax
  80020e:	79 24                	jns    800234 <ls+0x47>
		panic("stat %s: %e", path, r);
  800210:	89 44 24 10          	mov    %eax,0x10(%esp)
  800214:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800218:	c7 44 24 08 a1 26 80 	movl   $0x8026a1,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 7c 26 80 00 	movl   $0x80267c,(%esp)
  80022f:	e8 8f 01 00 00       	call   8003c3 <_panic>
	if (st.st_isdir && !flag['d'])
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800237:	85 c0                	test   %eax,%eax
  800239:	74 1a                	je     800255 <ls+0x68>
  80023b:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  800242:	75 11                	jne    800255 <ls+0x68>
		lsdir(path, prefix);
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 a4 fe ff ff       	call   8000f7 <lsdir>
  800253:	eb 23                	jmp    800278 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800255:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80025c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800260:	85 c0                	test   %eax,%eax
  800262:	0f 95 c0             	setne  %al
  800265:	0f b6 c0             	movzbl %al,%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 c8 fd ff ff       	call   800040 <ls1>
}
  800278:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <usage>:
	printf("\n");
}

void
usage(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800287:	c7 04 24 ad 26 80 00 	movl   $0x8026ad,(%esp)
  80028e:	e8 4c 1a 00 00       	call   801cdf <printf>
	exit();
  800293:	e8 12 01 00 00       	call   8003aa <exit>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <umain>:

void
umain(int argc, char **argv)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 20             	sub    $0x20,%esp
  8002a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b0:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 76 0f 00 00       	call   801231 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002bb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002be:	eb 1e                	jmp    8002de <umain+0x44>
		switch (i) {
  8002c0:	83 f8 64             	cmp    $0x64,%eax
  8002c3:	74 0a                	je     8002cf <umain+0x35>
  8002c5:	83 f8 6c             	cmp    $0x6c,%eax
  8002c8:	74 05                	je     8002cf <umain+0x35>
  8002ca:	83 f8 46             	cmp    $0x46,%eax
  8002cd:	75 0a                	jne    8002d9 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002cf:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  8002d6:	01 
			break;
  8002d7:	eb 05                	jmp    8002de <umain+0x44>
		default:
			usage();
  8002d9:	e8 a3 ff ff ff       	call   800281 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002de:	89 1c 24             	mov    %ebx,(%esp)
  8002e1:	e8 83 0f 00 00       	call   801269 <argnext>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	79 d6                	jns    8002c0 <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ed:	83 f8 01             	cmp    $0x1,%eax
  8002f0:	74 0c                	je     8002fe <umain+0x64>
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8002f2:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f7:	83 f8 01             	cmp    $0x1,%eax
  8002fa:	7f 18                	jg     800314 <umain+0x7a>
  8002fc:	eb 2d                	jmp    80032b <umain+0x91>
		default:
			usage();
		}

	if (argc == 1)
		ls("/", "");
  8002fe:	c7 44 24 04 c8 26 80 	movl   $0x8026c8,0x4(%esp)
  800305:	00 
  800306:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  80030d:	e8 db fe ff ff       	call   8001ed <ls>
  800312:	eb 17                	jmp    80032b <umain+0x91>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  800314:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	e8 ca fe ff ff       	call   8001ed <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800323:	83 c3 01             	add    $0x1,%ebx
  800326:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  800329:	7f e9                	jg     800314 <umain+0x7a>
			ls(argv[i], argv[i]);
	}
}
  80032b:	83 c4 20             	add    $0x20,%esp
  80032e:	5b                   	pop    %ebx
  80032f:	5e                   	pop    %esi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 10             	sub    $0x10,%esp
  80033a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80033d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800340:	e8 46 0c 00 00       	call   800f8b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800345:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80034b:	39 c2                	cmp    %eax,%edx
  80034d:	74 17                	je     800366 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80034f:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800354:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800357:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80035d:	8b 49 40             	mov    0x40(%ecx),%ecx
  800360:	39 c1                	cmp    %eax,%ecx
  800362:	75 18                	jne    80037c <libmain+0x4a>
  800364:	eb 05                	jmp    80036b <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  80036b:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80036e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800374:	89 15 20 44 80 00    	mov    %edx,0x804420
			break;
  80037a:	eb 0b                	jmp    800387 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80037c:	83 c2 01             	add    $0x1,%edx
  80037f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800385:	75 cd                	jne    800354 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800387:	85 db                	test   %ebx,%ebx
  800389:	7e 07                	jle    800392 <libmain+0x60>
		binaryname = argv[0];
  80038b:	8b 06                	mov    (%esi),%eax
  80038d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800392:	89 74 24 04          	mov    %esi,0x4(%esp)
  800396:	89 1c 24             	mov    %ebx,(%esp)
  800399:	e8 fc fe ff ff       	call   80029a <umain>

	// exit gracefully
	exit();
  80039e:	e8 07 00 00 00       	call   8003aa <exit>
}
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	5b                   	pop    %ebx
  8003a7:	5e                   	pop    %esi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8003b0:	e8 f1 11 00 00       	call   8015a6 <close_all>
	sys_env_destroy(0);
  8003b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003bc:	e8 78 0b 00 00       	call   800f39 <sys_env_destroy>
}
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003cb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ce:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8003d4:	e8 b2 0b 00 00       	call   800f8b <sys_getenvid>
  8003d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003e7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ef:	c7 04 24 f8 26 80 00 	movl   $0x8026f8,(%esp)
  8003f6:	e8 c1 00 00 00       	call   8004bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800402:	89 04 24             	mov    %eax,(%esp)
  800405:	e8 51 00 00 00       	call   80045b <vcprintf>
	cprintf("\n");
  80040a:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800411:	e8 a6 00 00 00       	call   8004bc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800416:	cc                   	int3   
  800417:	eb fd                	jmp    800416 <_panic+0x53>

00800419 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	53                   	push   %ebx
  80041d:	83 ec 14             	sub    $0x14,%esp
  800420:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800423:	8b 13                	mov    (%ebx),%edx
  800425:	8d 42 01             	lea    0x1(%edx),%eax
  800428:	89 03                	mov    %eax,(%ebx)
  80042a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800431:	3d ff 00 00 00       	cmp    $0xff,%eax
  800436:	75 19                	jne    800451 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800438:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80043f:	00 
  800440:	8d 43 08             	lea    0x8(%ebx),%eax
  800443:	89 04 24             	mov    %eax,(%esp)
  800446:	e8 b1 0a 00 00       	call   800efc <sys_cputs>
		b->idx = 0;
  80044b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800451:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800455:	83 c4 14             	add    $0x14,%esp
  800458:	5b                   	pop    %ebx
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    

0080045b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800464:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80046b:	00 00 00 
	b.cnt = 0;
  80046e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800475:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	89 44 24 08          	mov    %eax,0x8(%esp)
  800486:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800490:	c7 04 24 19 04 80 00 	movl   $0x800419,(%esp)
  800497:	e8 b8 01 00 00       	call   800654 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80049c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004ac:	89 04 24             	mov    %eax,(%esp)
  8004af:	e8 48 0a 00 00       	call   800efc <sys_cputs>

	return b.cnt;
}
  8004b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	e8 87 ff ff ff       	call   80045b <vcprintf>
	va_end(ap);

	return cnt;
}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    
  8004d6:	66 90                	xchg   %ax,%ax
  8004d8:	66 90                	xchg   %ax,%ax
  8004da:	66 90                	xchg   %ax,%ax
  8004dc:	66 90                	xchg   %ax,%ax
  8004de:	66 90                	xchg   %ax,%ax

008004e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	57                   	push   %edi
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 3c             	sub    $0x3c,%esp
  8004e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ec:	89 d7                	mov    %edx,%edi
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004f7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800508:	39 f1                	cmp    %esi,%ecx
  80050a:	72 14                	jb     800520 <printnum+0x40>
  80050c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80050f:	76 0f                	jbe    800520 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 70 ff             	lea    -0x1(%eax),%esi
  800517:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80051a:	85 f6                	test   %esi,%esi
  80051c:	7f 60                	jg     80057e <printnum+0x9e>
  80051e:	eb 72                	jmp    800592 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800520:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800523:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800527:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80052a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80052d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800531:	89 44 24 08          	mov    %eax,0x8(%esp)
  800535:	8b 44 24 08          	mov    0x8(%esp),%eax
  800539:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80053d:	89 c3                	mov    %eax,%ebx
  80053f:	89 d6                	mov    %edx,%esi
  800541:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800544:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800547:	89 54 24 08          	mov    %edx,0x8(%esp)
  80054b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	89 04 24             	mov    %eax,(%esp)
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055c:	e8 6f 1e 00 00       	call   8023d0 <__udivdi3>
  800561:	89 d9                	mov    %ebx,%ecx
  800563:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800567:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80056b:	89 04 24             	mov    %eax,(%esp)
  80056e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800572:	89 fa                	mov    %edi,%edx
  800574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800577:	e8 64 ff ff ff       	call   8004e0 <printnum>
  80057c:	eb 14                	jmp    800592 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80057e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800582:	8b 45 18             	mov    0x18(%ebp),%eax
  800585:	89 04 24             	mov    %eax,(%esp)
  800588:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058a:	83 ee 01             	sub    $0x1,%esi
  80058d:	75 ef                	jne    80057e <printnum+0x9e>
  80058f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800592:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800596:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ab:	89 04 24             	mov    %eax,(%esp)
  8005ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b5:	e8 46 1f 00 00       	call   802500 <__umoddi3>
  8005ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005be:	0f be 80 1b 27 80 00 	movsbl 0x80271b(%eax),%eax
  8005c5:	89 04 24             	mov    %eax,(%esp)
  8005c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005cb:	ff d0                	call   *%eax
}
  8005cd:	83 c4 3c             	add    $0x3c,%esp
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5f                   	pop    %edi
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 fa 01             	cmp    $0x1,%edx
  8005db:	7e 0e                	jle    8005eb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005e2:	89 08                	mov    %ecx,(%eax)
  8005e4:	8b 02                	mov    (%edx),%eax
  8005e6:	8b 52 04             	mov    0x4(%edx),%edx
  8005e9:	eb 22                	jmp    80060d <getuint+0x38>
	else if (lflag)
  8005eb:	85 d2                	test   %edx,%edx
  8005ed:	74 10                	je     8005ff <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005ef:	8b 10                	mov    (%eax),%edx
  8005f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005f4:	89 08                	mov    %ecx,(%eax)
  8005f6:	8b 02                	mov    (%edx),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	eb 0e                	jmp    80060d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	8d 4a 04             	lea    0x4(%edx),%ecx
  800604:	89 08                	mov    %ecx,(%eax)
  800606:	8b 02                	mov    (%edx),%eax
  800608:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80060d:	5d                   	pop    %ebp
  80060e:	c3                   	ret    

0080060f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800615:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800619:	8b 10                	mov    (%eax),%edx
  80061b:	3b 50 04             	cmp    0x4(%eax),%edx
  80061e:	73 0a                	jae    80062a <sprintputch+0x1b>
		*b->buf++ = ch;
  800620:	8d 4a 01             	lea    0x1(%edx),%ecx
  800623:	89 08                	mov    %ecx,(%eax)
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	88 02                	mov    %al,(%edx)
}
  80062a:	5d                   	pop    %ebp
  80062b:	c3                   	ret    

0080062c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800632:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800635:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800639:	8b 45 10             	mov    0x10(%ebp),%eax
  80063c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	89 44 24 04          	mov    %eax,0x4(%esp)
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	89 04 24             	mov    %eax,(%esp)
  80064d:	e8 02 00 00 00       	call   800654 <vprintfmt>
	va_end(ap);
}
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	57                   	push   %edi
  800658:	56                   	push   %esi
  800659:	53                   	push   %ebx
  80065a:	83 ec 3c             	sub    $0x3c,%esp
  80065d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800660:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800663:	eb 18                	jmp    80067d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800665:	85 c0                	test   %eax,%eax
  800667:	0f 84 c3 03 00 00    	je     800a30 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80066d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800671:	89 04 24             	mov    %eax,(%esp)
  800674:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800677:	89 f3                	mov    %esi,%ebx
  800679:	eb 02                	jmp    80067d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80067b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067d:	8d 73 01             	lea    0x1(%ebx),%esi
  800680:	0f b6 03             	movzbl (%ebx),%eax
  800683:	83 f8 25             	cmp    $0x25,%eax
  800686:	75 dd                	jne    800665 <vprintfmt+0x11>
  800688:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80068c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800693:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80069a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a6:	eb 1d                	jmp    8006c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8006aa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8006ae:	eb 15                	jmp    8006c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8006b6:	eb 0d                	jmp    8006c5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8006b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006be:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8006c8:	0f b6 06             	movzbl (%esi),%eax
  8006cb:	0f b6 c8             	movzbl %al,%ecx
  8006ce:	83 e8 23             	sub    $0x23,%eax
  8006d1:	3c 55                	cmp    $0x55,%al
  8006d3:	0f 87 2f 03 00 00    	ja     800a08 <vprintfmt+0x3b4>
  8006d9:	0f b6 c0             	movzbl %al,%eax
  8006dc:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006e3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8006e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8006e9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8006ed:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8006f0:	83 f9 09             	cmp    $0x9,%ecx
  8006f3:	77 50                	ja     800745 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f5:	89 de                	mov    %ebx,%esi
  8006f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8006fd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800700:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800704:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800707:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80070a:	83 fb 09             	cmp    $0x9,%ebx
  80070d:	76 eb                	jbe    8006fa <vprintfmt+0xa6>
  80070f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800712:	eb 33                	jmp    800747 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8d 48 04             	lea    0x4(%eax),%ecx
  80071a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800722:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800724:	eb 21                	jmp    800747 <vprintfmt+0xf3>
  800726:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800729:	85 c9                	test   %ecx,%ecx
  80072b:	b8 00 00 00 00       	mov    $0x0,%eax
  800730:	0f 49 c1             	cmovns %ecx,%eax
  800733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800736:	89 de                	mov    %ebx,%esi
  800738:	eb 8b                	jmp    8006c5 <vprintfmt+0x71>
  80073a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80073c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800743:	eb 80                	jmp    8006c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800745:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800747:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074b:	0f 89 74 ff ff ff    	jns    8006c5 <vprintfmt+0x71>
  800751:	e9 62 ff ff ff       	jmp    8006b8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800756:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80075b:	e9 65 ff ff ff       	jmp    8006c5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8d 50 04             	lea    0x4(%eax),%edx
  800766:	89 55 14             	mov    %edx,0x14(%ebp)
  800769:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			break;
  800775:	e9 03 ff ff ff       	jmp    80067d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	89 55 14             	mov    %edx,0x14(%ebp)
  800783:	8b 00                	mov    (%eax),%eax
  800785:	99                   	cltd   
  800786:	31 d0                	xor    %edx,%eax
  800788:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80078a:	83 f8 0f             	cmp    $0xf,%eax
  80078d:	7f 0b                	jg     80079a <vprintfmt+0x146>
  80078f:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	75 20                	jne    8007ba <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80079a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80079e:	c7 44 24 08 33 27 80 	movl   $0x802733,0x8(%esp)
  8007a5:	00 
  8007a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 04 24             	mov    %eax,(%esp)
  8007b0:	e8 77 fe ff ff       	call   80062c <printfmt>
  8007b5:	e9 c3 fe ff ff       	jmp    80067d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8007ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007be:	c7 44 24 08 e2 2a 80 	movl   $0x802ae2,0x8(%esp)
  8007c5:	00 
  8007c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 04 24             	mov    %eax,(%esp)
  8007d0:	e8 57 fe ff ff       	call   80062c <printfmt>
  8007d5:	e9 a3 fe ff ff       	jmp    80067d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007dd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	ba 2c 27 80 00       	mov    $0x80272c,%edx
  8007f2:	0f 45 d0             	cmovne %eax,%edx
  8007f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8007f8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8007fc:	74 04                	je     800802 <vprintfmt+0x1ae>
  8007fe:	85 f6                	test   %esi,%esi
  800800:	7f 19                	jg     80081b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800802:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800805:	8d 70 01             	lea    0x1(%eax),%esi
  800808:	0f b6 10             	movzbl (%eax),%edx
  80080b:	0f be c2             	movsbl %dl,%eax
  80080e:	85 c0                	test   %eax,%eax
  800810:	0f 85 95 00 00 00    	jne    8008ab <vprintfmt+0x257>
  800816:	e9 85 00 00 00       	jmp    8008a0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80081b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80081f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800822:	89 04 24             	mov    %eax,(%esp)
  800825:	e8 b8 02 00 00       	call   800ae2 <strnlen>
  80082a:	29 c6                	sub    %eax,%esi
  80082c:	89 f0                	mov    %esi,%eax
  80082e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800831:	85 f6                	test   %esi,%esi
  800833:	7e cd                	jle    800802 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800835:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800839:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80083c:	89 c3                	mov    %eax,%ebx
  80083e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800842:	89 34 24             	mov    %esi,(%esp)
  800845:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800848:	83 eb 01             	sub    $0x1,%ebx
  80084b:	75 f1                	jne    80083e <vprintfmt+0x1ea>
  80084d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800850:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800853:	eb ad                	jmp    800802 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800855:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800859:	74 1e                	je     800879 <vprintfmt+0x225>
  80085b:	0f be d2             	movsbl %dl,%edx
  80085e:	83 ea 20             	sub    $0x20,%edx
  800861:	83 fa 5e             	cmp    $0x5e,%edx
  800864:	76 13                	jbe    800879 <vprintfmt+0x225>
					putch('?', putdat);
  800866:	8b 45 0c             	mov    0xc(%ebp),%eax
  800869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800874:	ff 55 08             	call   *0x8(%ebp)
  800877:	eb 0d                	jmp    800886 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800879:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800880:	89 04 24             	mov    %eax,(%esp)
  800883:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800886:	83 ef 01             	sub    $0x1,%edi
  800889:	83 c6 01             	add    $0x1,%esi
  80088c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800890:	0f be c2             	movsbl %dl,%eax
  800893:	85 c0                	test   %eax,%eax
  800895:	75 20                	jne    8008b7 <vprintfmt+0x263>
  800897:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80089a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80089d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	7f 25                	jg     8008cb <vprintfmt+0x277>
  8008a6:	e9 d2 fd ff ff       	jmp    80067d <vprintfmt+0x29>
  8008ab:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8008ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008b1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b7:	85 db                	test   %ebx,%ebx
  8008b9:	78 9a                	js     800855 <vprintfmt+0x201>
  8008bb:	83 eb 01             	sub    $0x1,%ebx
  8008be:	79 95                	jns    800855 <vprintfmt+0x201>
  8008c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8008c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008c9:	eb d5                	jmp    8008a0 <vprintfmt+0x24c>
  8008cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8008d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008df:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008e1:	83 eb 01             	sub    $0x1,%ebx
  8008e4:	75 ee                	jne    8008d4 <vprintfmt+0x280>
  8008e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008e9:	e9 8f fd ff ff       	jmp    80067d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008ee:	83 fa 01             	cmp    $0x1,%edx
  8008f1:	7e 16                	jle    800909 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8d 50 08             	lea    0x8(%eax),%edx
  8008f9:	89 55 14             	mov    %edx,0x14(%ebp)
  8008fc:	8b 50 04             	mov    0x4(%eax),%edx
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800904:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800907:	eb 32                	jmp    80093b <vprintfmt+0x2e7>
	else if (lflag)
  800909:	85 d2                	test   %edx,%edx
  80090b:	74 18                	je     800925 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8d 50 04             	lea    0x4(%eax),%edx
  800913:	89 55 14             	mov    %edx,0x14(%ebp)
  800916:	8b 30                	mov    (%eax),%esi
  800918:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80091b:	89 f0                	mov    %esi,%eax
  80091d:	c1 f8 1f             	sar    $0x1f,%eax
  800920:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800923:	eb 16                	jmp    80093b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8d 50 04             	lea    0x4(%eax),%edx
  80092b:	89 55 14             	mov    %edx,0x14(%ebp)
  80092e:	8b 30                	mov    (%eax),%esi
  800930:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800933:	89 f0                	mov    %esi,%eax
  800935:	c1 f8 1f             	sar    $0x1f,%eax
  800938:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80093e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800941:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800946:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094a:	0f 89 80 00 00 00    	jns    8009d0 <vprintfmt+0x37c>
				putch('-', putdat);
  800950:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800954:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80095b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80095e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800961:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800964:	f7 d8                	neg    %eax
  800966:	83 d2 00             	adc    $0x0,%edx
  800969:	f7 da                	neg    %edx
			}
			base = 10;
  80096b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800970:	eb 5e                	jmp    8009d0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800972:	8d 45 14             	lea    0x14(%ebp),%eax
  800975:	e8 5b fc ff ff       	call   8005d5 <getuint>
			base = 10;
  80097a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80097f:	eb 4f                	jmp    8009d0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800981:	8d 45 14             	lea    0x14(%ebp),%eax
  800984:	e8 4c fc ff ff       	call   8005d5 <getuint>
			base = 8;
  800989:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80098e:	eb 40                	jmp    8009d0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800990:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800994:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80099b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80099e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009a2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009a9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8d 50 04             	lea    0x4(%eax),%edx
  8009b2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8009bc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8009c1:	eb 0d                	jmp    8009d0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c6:	e8 0a fc ff ff       	call   8005d5 <getuint>
			base = 16;
  8009cb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8009d4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8009db:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ea:	89 fa                	mov    %edi,%edx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	e8 ec fa ff ff       	call   8004e0 <printnum>
			break;
  8009f4:	e9 84 fc ff ff       	jmp    80067d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009fd:	89 0c 24             	mov    %ecx,(%esp)
  800a00:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a03:	e9 75 fc ff ff       	jmp    80067d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a08:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a0c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a13:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a16:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800a1a:	0f 84 5b fc ff ff    	je     80067b <vprintfmt+0x27>
  800a20:	89 f3                	mov    %esi,%ebx
  800a22:	83 eb 01             	sub    $0x1,%ebx
  800a25:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a29:	75 f7                	jne    800a22 <vprintfmt+0x3ce>
  800a2b:	e9 4d fc ff ff       	jmp    80067d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800a30:	83 c4 3c             	add    $0x3c,%esp
  800a33:	5b                   	pop    %ebx
  800a34:	5e                   	pop    %esi
  800a35:	5f                   	pop    %edi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 28             	sub    $0x28,%esp
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a47:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a4b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a55:	85 c0                	test   %eax,%eax
  800a57:	74 30                	je     800a89 <vsnprintf+0x51>
  800a59:	85 d2                	test   %edx,%edx
  800a5b:	7e 2c                	jle    800a89 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a64:	8b 45 10             	mov    0x10(%ebp),%eax
  800a67:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a72:	c7 04 24 0f 06 80 00 	movl   $0x80060f,(%esp)
  800a79:	e8 d6 fb ff ff       	call   800654 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a87:	eb 05                	jmp    800a8e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a96:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a99:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	89 04 24             	mov    %eax,(%esp)
  800ab1:	e8 82 ff ff ff       	call   800a38 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    
  800ab8:	66 90                	xchg   %ax,%ax
  800aba:	66 90                	xchg   %ax,%ax
  800abc:	66 90                	xchg   %ax,%ax
  800abe:	66 90                	xchg   %ax,%ax

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	80 3a 00             	cmpb   $0x0,(%edx)
  800ac9:	74 10                	je     800adb <strlen+0x1b>
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad7:	75 f7                	jne    800ad0 <strlen+0x10>
  800ad9:	eb 05                	jmp    800ae0 <strlen+0x20>
  800adb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	53                   	push   %ebx
  800ae6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aec:	85 c9                	test   %ecx,%ecx
  800aee:	74 1c                	je     800b0c <strnlen+0x2a>
  800af0:	80 3b 00             	cmpb   $0x0,(%ebx)
  800af3:	74 1e                	je     800b13 <strnlen+0x31>
  800af5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800afa:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afc:	39 ca                	cmp    %ecx,%edx
  800afe:	74 18                	je     800b18 <strnlen+0x36>
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800b08:	75 f0                	jne    800afa <strnlen+0x18>
  800b0a:	eb 0c                	jmp    800b18 <strnlen+0x36>
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	eb 05                	jmp    800b18 <strnlen+0x36>
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b18:	5b                   	pop    %ebx
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	83 c1 01             	add    $0x1,%ecx
  800b2d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b31:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b34:	84 db                	test   %bl,%bl
  800b36:	75 ef                	jne    800b27 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b38:	5b                   	pop    %ebx
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	53                   	push   %ebx
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b45:	89 1c 24             	mov    %ebx,(%esp)
  800b48:	e8 73 ff ff ff       	call   800ac0 <strlen>
	strcpy(dst + len, src);
  800b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b50:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b54:	01 d8                	add    %ebx,%eax
  800b56:	89 04 24             	mov    %eax,(%esp)
  800b59:	e8 bd ff ff ff       	call   800b1b <strcpy>
	return dst;
}
  800b5e:	89 d8                	mov    %ebx,%eax
  800b60:	83 c4 08             	add    $0x8,%esp
  800b63:	5b                   	pop    %ebx
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b74:	85 db                	test   %ebx,%ebx
  800b76:	74 17                	je     800b8f <strncpy+0x29>
  800b78:	01 f3                	add    %esi,%ebx
  800b7a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800b7c:	83 c1 01             	add    $0x1,%ecx
  800b7f:	0f b6 02             	movzbl (%edx),%eax
  800b82:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b85:	80 3a 01             	cmpb   $0x1,(%edx)
  800b88:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8b:	39 d9                	cmp    %ebx,%ecx
  800b8d:	75 ed                	jne    800b7c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b8f:	89 f0                	mov    %esi,%eax
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ba1:	8b 75 10             	mov    0x10(%ebp),%esi
  800ba4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ba6:	85 f6                	test   %esi,%esi
  800ba8:	74 34                	je     800bde <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800baa:	83 fe 01             	cmp    $0x1,%esi
  800bad:	74 26                	je     800bd5 <strlcpy+0x40>
  800baf:	0f b6 0b             	movzbl (%ebx),%ecx
  800bb2:	84 c9                	test   %cl,%cl
  800bb4:	74 23                	je     800bd9 <strlcpy+0x44>
  800bb6:	83 ee 02             	sub    $0x2,%esi
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800bbe:	83 c0 01             	add    $0x1,%eax
  800bc1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	39 f2                	cmp    %esi,%edx
  800bc6:	74 13                	je     800bdb <strlcpy+0x46>
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bcf:	84 c9                	test   %cl,%cl
  800bd1:	75 eb                	jne    800bbe <strlcpy+0x29>
  800bd3:	eb 06                	jmp    800bdb <strlcpy+0x46>
  800bd5:	89 f8                	mov    %edi,%eax
  800bd7:	eb 02                	jmp    800bdb <strlcpy+0x46>
  800bd9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800bdb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bde:	29 f8                	sub    %edi,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bee:	0f b6 01             	movzbl (%ecx),%eax
  800bf1:	84 c0                	test   %al,%al
  800bf3:	74 15                	je     800c0a <strcmp+0x25>
  800bf5:	3a 02                	cmp    (%edx),%al
  800bf7:	75 11                	jne    800c0a <strcmp+0x25>
		p++, q++;
  800bf9:	83 c1 01             	add    $0x1,%ecx
  800bfc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bff:	0f b6 01             	movzbl (%ecx),%eax
  800c02:	84 c0                	test   %al,%al
  800c04:	74 04                	je     800c0a <strcmp+0x25>
  800c06:	3a 02                	cmp    (%edx),%al
  800c08:	74 ef                	je     800bf9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	0f b6 c0             	movzbl %al,%eax
  800c0d:	0f b6 12             	movzbl (%edx),%edx
  800c10:	29 d0                	sub    %edx,%eax
}
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800c22:	85 f6                	test   %esi,%esi
  800c24:	74 29                	je     800c4f <strncmp+0x3b>
  800c26:	0f b6 03             	movzbl (%ebx),%eax
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 30                	je     800c5d <strncmp+0x49>
  800c2d:	3a 02                	cmp    (%edx),%al
  800c2f:	75 2c                	jne    800c5d <strncmp+0x49>
  800c31:	8d 43 01             	lea    0x1(%ebx),%eax
  800c34:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800c36:	89 c3                	mov    %eax,%ebx
  800c38:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c3b:	39 f0                	cmp    %esi,%eax
  800c3d:	74 17                	je     800c56 <strncmp+0x42>
  800c3f:	0f b6 08             	movzbl (%eax),%ecx
  800c42:	84 c9                	test   %cl,%cl
  800c44:	74 17                	je     800c5d <strncmp+0x49>
  800c46:	83 c0 01             	add    $0x1,%eax
  800c49:	3a 0a                	cmp    (%edx),%cl
  800c4b:	74 e9                	je     800c36 <strncmp+0x22>
  800c4d:	eb 0e                	jmp    800c5d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	eb 0f                	jmp    800c65 <strncmp+0x51>
  800c56:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5b:	eb 08                	jmp    800c65 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5d:	0f b6 03             	movzbl (%ebx),%eax
  800c60:	0f b6 12             	movzbl (%edx),%edx
  800c63:	29 d0                	sub    %edx,%eax
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	53                   	push   %ebx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800c73:	0f b6 18             	movzbl (%eax),%ebx
  800c76:	84 db                	test   %bl,%bl
  800c78:	74 1d                	je     800c97 <strchr+0x2e>
  800c7a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800c7c:	38 d3                	cmp    %dl,%bl
  800c7e:	75 06                	jne    800c86 <strchr+0x1d>
  800c80:	eb 1a                	jmp    800c9c <strchr+0x33>
  800c82:	38 ca                	cmp    %cl,%dl
  800c84:	74 16                	je     800c9c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c86:	83 c0 01             	add    $0x1,%eax
  800c89:	0f b6 10             	movzbl (%eax),%edx
  800c8c:	84 d2                	test   %dl,%dl
  800c8e:	75 f2                	jne    800c82 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	eb 05                	jmp    800c9c <strchr+0x33>
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	53                   	push   %ebx
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ca9:	0f b6 18             	movzbl (%eax),%ebx
  800cac:	84 db                	test   %bl,%bl
  800cae:	74 16                	je     800cc6 <strfind+0x27>
  800cb0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800cb2:	38 d3                	cmp    %dl,%bl
  800cb4:	75 06                	jne    800cbc <strfind+0x1d>
  800cb6:	eb 0e                	jmp    800cc6 <strfind+0x27>
  800cb8:	38 ca                	cmp    %cl,%dl
  800cba:	74 0a                	je     800cc6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	0f b6 10             	movzbl (%eax),%edx
  800cc2:	84 d2                	test   %dl,%dl
  800cc4:	75 f2                	jne    800cb8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cd5:	85 c9                	test   %ecx,%ecx
  800cd7:	74 36                	je     800d0f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cd9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cdf:	75 28                	jne    800d09 <memset+0x40>
  800ce1:	f6 c1 03             	test   $0x3,%cl
  800ce4:	75 23                	jne    800d09 <memset+0x40>
		c &= 0xFF;
  800ce6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cea:	89 d3                	mov    %edx,%ebx
  800cec:	c1 e3 08             	shl    $0x8,%ebx
  800cef:	89 d6                	mov    %edx,%esi
  800cf1:	c1 e6 18             	shl    $0x18,%esi
  800cf4:	89 d0                	mov    %edx,%eax
  800cf6:	c1 e0 10             	shl    $0x10,%eax
  800cf9:	09 f0                	or     %esi,%eax
  800cfb:	09 c2                	or     %eax,%edx
  800cfd:	89 d0                	mov    %edx,%eax
  800cff:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d01:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d04:	fc                   	cld    
  800d05:	f3 ab                	rep stos %eax,%es:(%edi)
  800d07:	eb 06                	jmp    800d0f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	fc                   	cld    
  800d0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d0f:	89 f8                	mov    %edi,%eax
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d24:	39 c6                	cmp    %eax,%esi
  800d26:	73 35                	jae    800d5d <memmove+0x47>
  800d28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d2b:	39 d0                	cmp    %edx,%eax
  800d2d:	73 2e                	jae    800d5d <memmove+0x47>
		s += n;
		d += n;
  800d2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d32:	89 d6                	mov    %edx,%esi
  800d34:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d3c:	75 13                	jne    800d51 <memmove+0x3b>
  800d3e:	f6 c1 03             	test   $0x3,%cl
  800d41:	75 0e                	jne    800d51 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d43:	83 ef 04             	sub    $0x4,%edi
  800d46:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d49:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d4c:	fd                   	std    
  800d4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d4f:	eb 09                	jmp    800d5a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d51:	83 ef 01             	sub    $0x1,%edi
  800d54:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d57:	fd                   	std    
  800d58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d5a:	fc                   	cld    
  800d5b:	eb 1d                	jmp    800d7a <memmove+0x64>
  800d5d:	89 f2                	mov    %esi,%edx
  800d5f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d61:	f6 c2 03             	test   $0x3,%dl
  800d64:	75 0f                	jne    800d75 <memmove+0x5f>
  800d66:	f6 c1 03             	test   $0x3,%cl
  800d69:	75 0a                	jne    800d75 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d6b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	fc                   	cld    
  800d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d73:	eb 05                	jmp    800d7a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d75:	89 c7                	mov    %eax,%edi
  800d77:	fc                   	cld    
  800d78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	89 04 24             	mov    %eax,(%esp)
  800d98:	e8 79 ff ff ff       	call   800d16 <memmove>
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800da8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dae:	8d 78 ff             	lea    -0x1(%eax),%edi
  800db1:	85 c0                	test   %eax,%eax
  800db3:	74 36                	je     800deb <memcmp+0x4c>
		if (*s1 != *s2)
  800db5:	0f b6 03             	movzbl (%ebx),%eax
  800db8:	0f b6 0e             	movzbl (%esi),%ecx
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	38 c8                	cmp    %cl,%al
  800dc2:	74 1c                	je     800de0 <memcmp+0x41>
  800dc4:	eb 10                	jmp    800dd6 <memcmp+0x37>
  800dc6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800dcb:	83 c2 01             	add    $0x1,%edx
  800dce:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  800dd2:	38 c8                	cmp    %cl,%al
  800dd4:	74 0a                	je     800de0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  800dd6:	0f b6 c0             	movzbl %al,%eax
  800dd9:	0f b6 c9             	movzbl %cl,%ecx
  800ddc:	29 c8                	sub    %ecx,%eax
  800dde:	eb 10                	jmp    800df0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800de0:	39 fa                	cmp    %edi,%edx
  800de2:	75 e2                	jne    800dc6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	eb 05                	jmp    800df0 <memcmp+0x51>
  800deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	53                   	push   %ebx
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e04:	39 d0                	cmp    %edx,%eax
  800e06:	73 13                	jae    800e1b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e08:	89 d9                	mov    %ebx,%ecx
  800e0a:	38 18                	cmp    %bl,(%eax)
  800e0c:	75 06                	jne    800e14 <memfind+0x1f>
  800e0e:	eb 0b                	jmp    800e1b <memfind+0x26>
  800e10:	38 08                	cmp    %cl,(%eax)
  800e12:	74 07                	je     800e1b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e14:	83 c0 01             	add    $0x1,%eax
  800e17:	39 d0                	cmp    %edx,%eax
  800e19:	75 f5                	jne    800e10 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2a:	0f b6 0a             	movzbl (%edx),%ecx
  800e2d:	80 f9 09             	cmp    $0x9,%cl
  800e30:	74 05                	je     800e37 <strtol+0x19>
  800e32:	80 f9 20             	cmp    $0x20,%cl
  800e35:	75 10                	jne    800e47 <strtol+0x29>
		s++;
  800e37:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e3a:	0f b6 0a             	movzbl (%edx),%ecx
  800e3d:	80 f9 09             	cmp    $0x9,%cl
  800e40:	74 f5                	je     800e37 <strtol+0x19>
  800e42:	80 f9 20             	cmp    $0x20,%cl
  800e45:	74 f0                	je     800e37 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e47:	80 f9 2b             	cmp    $0x2b,%cl
  800e4a:	75 0a                	jne    800e56 <strtol+0x38>
		s++;
  800e4c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e54:	eb 11                	jmp    800e67 <strtol+0x49>
  800e56:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e5b:	80 f9 2d             	cmp    $0x2d,%cl
  800e5e:	75 07                	jne    800e67 <strtol+0x49>
		s++, neg = 1;
  800e60:	83 c2 01             	add    $0x1,%edx
  800e63:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e67:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e6c:	75 15                	jne    800e83 <strtol+0x65>
  800e6e:	80 3a 30             	cmpb   $0x30,(%edx)
  800e71:	75 10                	jne    800e83 <strtol+0x65>
  800e73:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e77:	75 0a                	jne    800e83 <strtol+0x65>
		s += 2, base = 16;
  800e79:	83 c2 02             	add    $0x2,%edx
  800e7c:	b8 10 00 00 00       	mov    $0x10,%eax
  800e81:	eb 10                	jmp    800e93 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800e83:	85 c0                	test   %eax,%eax
  800e85:	75 0c                	jne    800e93 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e87:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e89:	80 3a 30             	cmpb   $0x30,(%edx)
  800e8c:	75 05                	jne    800e93 <strtol+0x75>
		s++, base = 8;
  800e8e:	83 c2 01             	add    $0x1,%edx
  800e91:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e98:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e9b:	0f b6 0a             	movzbl (%edx),%ecx
  800e9e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ea1:	89 f0                	mov    %esi,%eax
  800ea3:	3c 09                	cmp    $0x9,%al
  800ea5:	77 08                	ja     800eaf <strtol+0x91>
			dig = *s - '0';
  800ea7:	0f be c9             	movsbl %cl,%ecx
  800eaa:	83 e9 30             	sub    $0x30,%ecx
  800ead:	eb 20                	jmp    800ecf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  800eaf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800eb2:	89 f0                	mov    %esi,%eax
  800eb4:	3c 19                	cmp    $0x19,%al
  800eb6:	77 08                	ja     800ec0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800eb8:	0f be c9             	movsbl %cl,%ecx
  800ebb:	83 e9 57             	sub    $0x57,%ecx
  800ebe:	eb 0f                	jmp    800ecf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800ec0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ec3:	89 f0                	mov    %esi,%eax
  800ec5:	3c 19                	cmp    $0x19,%al
  800ec7:	77 16                	ja     800edf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ec9:	0f be c9             	movsbl %cl,%ecx
  800ecc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ecf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ed2:	7d 0f                	jge    800ee3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ed4:	83 c2 01             	add    $0x1,%edx
  800ed7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800edb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800edd:	eb bc                	jmp    800e9b <strtol+0x7d>
  800edf:	89 d8                	mov    %ebx,%eax
  800ee1:	eb 02                	jmp    800ee5 <strtol+0xc7>
  800ee3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ee5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee9:	74 05                	je     800ef0 <strtol+0xd2>
		*endptr = (char *) s;
  800eeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eee:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ef0:	f7 d8                	neg    %eax
  800ef2:	85 ff                	test   %edi,%edi
  800ef4:	0f 44 c3             	cmove  %ebx,%eax
}
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
  800f07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	89 c3                	mov    %eax,%ebx
  800f0f:	89 c7                	mov    %eax,%edi
  800f11:	89 c6                	mov    %eax,%esi
  800f13:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <sys_cgetc>:

int
sys_cgetc(void)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	ba 00 00 00 00       	mov    $0x0,%edx
  800f25:	b8 01 00 00 00       	mov    $0x1,%eax
  800f2a:	89 d1                	mov    %edx,%ecx
  800f2c:	89 d3                	mov    %edx,%ebx
  800f2e:	89 d7                	mov    %edx,%edi
  800f30:	89 d6                	mov    %edx,%esi
  800f32:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	b8 03 00 00 00       	mov    $0x3,%eax
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7e 28                	jle    800f83 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f66:	00 
  800f67:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  800f6e:	00 
  800f6f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800f76:	00 
  800f77:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  800f7e:	e8 40 f4 ff ff       	call   8003c3 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f83:	83 c4 2c             	add    $0x2c,%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f91:	ba 00 00 00 00       	mov    $0x0,%edx
  800f96:	b8 02 00 00 00       	mov    $0x2,%eax
  800f9b:	89 d1                	mov    %edx,%ecx
  800f9d:	89 d3                	mov    %edx,%ebx
  800f9f:	89 d7                	mov    %edx,%edi
  800fa1:	89 d6                	mov    %edx,%esi
  800fa3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <sys_yield>:

void
sys_yield(void)
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
  800fb5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fba:	89 d1                	mov    %edx,%ecx
  800fbc:	89 d3                	mov    %edx,%ebx
  800fbe:	89 d7                	mov    %edx,%edi
  800fc0:	89 d6                	mov    %edx,%esi
  800fc2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800fd2:	be 00 00 00 00       	mov    $0x0,%esi
  800fd7:	b8 04 00 00 00       	mov    $0x4,%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe5:	89 f7                	mov    %esi,%edi
  800fe7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7e 28                	jle    801015 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  801010:	e8 ae f3 ff ff       	call   8003c3 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801015:	83 c4 2c             	add    $0x2c,%esp
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
  801023:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801026:	b8 05 00 00 00       	mov    $0x5,%eax
  80102b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801034:	8b 7d 14             	mov    0x14(%ebp),%edi
  801037:	8b 75 18             	mov    0x18(%ebp),%esi
  80103a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7e 28                	jle    801068 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801040:	89 44 24 10          	mov    %eax,0x10(%esp)
  801044:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80104b:	00 
  80104c:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  801053:	00 
  801054:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80105b:	00 
  80105c:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  801063:	e8 5b f3 ff ff       	call   8003c3 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801068:	83 c4 2c             	add    $0x2c,%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	b8 06 00 00 00       	mov    $0x6,%eax
  801083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	7e 28                	jle    8010bb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801093:	89 44 24 10          	mov    %eax,0x10(%esp)
  801097:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80109e:	00 
  80109f:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8010ae:	00 
  8010af:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  8010b6:	e8 08 f3 ff ff       	call   8003c3 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bb:	83 c4 2c             	add    $0x2c,%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    

008010c3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	57                   	push   %edi
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	89 df                	mov    %ebx,%edi
  8010de:	89 de                	mov    %ebx,%esi
  8010e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	7e 28                	jle    80110e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ea:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  8010f9:	00 
  8010fa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801101:	00 
  801102:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  801109:	e8 b5 f2 ff ff       	call   8003c3 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80110e:	83 c4 2c             	add    $0x2c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
  80111c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801124:	b8 09 00 00 00       	mov    $0x9,%eax
  801129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	89 df                	mov    %ebx,%edi
  801131:	89 de                	mov    %ebx,%esi
  801133:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801135:	85 c0                	test   %eax,%eax
  801137:	7e 28                	jle    801161 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801139:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801144:	00 
  801145:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  80114c:	00 
  80114d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801154:	00 
  801155:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  80115c:	e8 62 f2 ff ff       	call   8003c3 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801161:	83 c4 2c             	add    $0x2c,%esp
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801172:	bb 00 00 00 00       	mov    $0x0,%ebx
  801177:	b8 0a 00 00 00       	mov    $0xa,%eax
  80117c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117f:	8b 55 08             	mov    0x8(%ebp),%edx
  801182:	89 df                	mov    %ebx,%edi
  801184:	89 de                	mov    %ebx,%esi
  801186:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801188:	85 c0                	test   %eax,%eax
  80118a:	7e 28                	jle    8011b4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801190:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801197:	00 
  801198:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  80119f:	00 
  8011a0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011a7:	00 
  8011a8:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  8011af:	e8 0f f2 ff ff       	call   8003c3 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011b4:	83 c4 2c             	add    $0x2c,%esp
  8011b7:	5b                   	pop    %ebx
  8011b8:	5e                   	pop    %esi
  8011b9:	5f                   	pop    %edi
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c2:	be 00 00 00 00       	mov    $0x0,%esi
  8011c7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011d5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011d8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    

008011df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	57                   	push   %edi
  8011e3:	56                   	push   %esi
  8011e4:	53                   	push   %ebx
  8011e5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ed:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	89 cb                	mov    %ecx,%ebx
  8011f7:	89 cf                	mov    %ecx,%edi
  8011f9:	89 ce                	mov    %ecx,%esi
  8011fb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	7e 28                	jle    801229 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801201:	89 44 24 10          	mov    %eax,0x10(%esp)
  801205:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80120c:	00 
  80120d:	c7 44 24 08 1f 2a 80 	movl   $0x802a1f,0x8(%esp)
  801214:	00 
  801215:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80121c:	00 
  80121d:	c7 04 24 3c 2a 80 00 	movl   $0x802a3c,(%esp)
  801224:	e8 9a f1 ff ff       	call   8003c3 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801229:	83 c4 2c             	add    $0x2c,%esp
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	53                   	push   %ebx
  801235:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80123e:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801240:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801243:	bb 00 00 00 00       	mov    $0x0,%ebx
  801248:	83 39 01             	cmpl   $0x1,(%ecx)
  80124b:	7e 0f                	jle    80125c <argstart+0x2b>
  80124d:	85 d2                	test   %edx,%edx
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	bb c8 26 80 00       	mov    $0x8026c8,%ebx
  801259:	0f 44 da             	cmove  %edx,%ebx
  80125c:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80125f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801266:	5b                   	pop    %ebx
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    

00801269 <argnext>:

int
argnext(struct Argstate *args)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	53                   	push   %ebx
  80126d:	83 ec 14             	sub    $0x14,%esp
  801270:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801273:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80127a:	8b 43 08             	mov    0x8(%ebx),%eax
  80127d:	85 c0                	test   %eax,%eax
  80127f:	74 71                	je     8012f2 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801281:	80 38 00             	cmpb   $0x0,(%eax)
  801284:	75 50                	jne    8012d6 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801286:	8b 0b                	mov    (%ebx),%ecx
  801288:	83 39 01             	cmpl   $0x1,(%ecx)
  80128b:	74 57                	je     8012e4 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80128d:	8b 53 04             	mov    0x4(%ebx),%edx
  801290:	8b 42 04             	mov    0x4(%edx),%eax
  801293:	80 38 2d             	cmpb   $0x2d,(%eax)
  801296:	75 4c                	jne    8012e4 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801298:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80129c:	74 46                	je     8012e4 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80129e:	83 c0 01             	add    $0x1,%eax
  8012a1:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012a4:	8b 01                	mov    (%ecx),%eax
  8012a6:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8012ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b1:	8d 42 08             	lea    0x8(%edx),%eax
  8012b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b8:	83 c2 04             	add    $0x4,%edx
  8012bb:	89 14 24             	mov    %edx,(%esp)
  8012be:	e8 53 fa ff ff       	call   800d16 <memmove>
		(*args->argc)--;
  8012c3:	8b 03                	mov    (%ebx),%eax
  8012c5:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8012c8:	8b 43 08             	mov    0x8(%ebx),%eax
  8012cb:	80 38 2d             	cmpb   $0x2d,(%eax)
  8012ce:	75 06                	jne    8012d6 <argnext+0x6d>
  8012d0:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012d4:	74 0e                	je     8012e4 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8012d6:	8b 53 08             	mov    0x8(%ebx),%edx
  8012d9:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8012dc:	83 c2 01             	add    $0x1,%edx
  8012df:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8012e2:	eb 13                	jmp    8012f7 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8012e4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8012eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8012f0:	eb 05                	jmp    8012f7 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8012f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8012f7:	83 c4 14             	add    $0x14,%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	53                   	push   %ebx
  801301:	83 ec 14             	sub    $0x14,%esp
  801304:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801307:	8b 43 08             	mov    0x8(%ebx),%eax
  80130a:	85 c0                	test   %eax,%eax
  80130c:	74 5a                	je     801368 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  80130e:	80 38 00             	cmpb   $0x0,(%eax)
  801311:	74 0c                	je     80131f <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801313:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801316:	c7 43 08 c8 26 80 00 	movl   $0x8026c8,0x8(%ebx)
  80131d:	eb 44                	jmp    801363 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80131f:	8b 03                	mov    (%ebx),%eax
  801321:	83 38 01             	cmpl   $0x1,(%eax)
  801324:	7e 2f                	jle    801355 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801326:	8b 53 04             	mov    0x4(%ebx),%edx
  801329:	8b 4a 04             	mov    0x4(%edx),%ecx
  80132c:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801338:	89 44 24 08          	mov    %eax,0x8(%esp)
  80133c:	8d 42 08             	lea    0x8(%edx),%eax
  80133f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801343:	83 c2 04             	add    $0x4,%edx
  801346:	89 14 24             	mov    %edx,(%esp)
  801349:	e8 c8 f9 ff ff       	call   800d16 <memmove>
		(*args->argc)--;
  80134e:	8b 03                	mov    (%ebx),%eax
  801350:	83 28 01             	subl   $0x1,(%eax)
  801353:	eb 0e                	jmp    801363 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801355:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80135c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801363:	8b 43 0c             	mov    0xc(%ebx),%eax
  801366:	eb 05                	jmp    80136d <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80136d:	83 c4 14             	add    $0x14,%esp
  801370:	5b                   	pop    %ebx
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 18             	sub    $0x18,%esp
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80137c:	8b 51 0c             	mov    0xc(%ecx),%edx
  80137f:	89 d0                	mov    %edx,%eax
  801381:	85 d2                	test   %edx,%edx
  801383:	75 08                	jne    80138d <argvalue+0x1a>
  801385:	89 0c 24             	mov    %ecx,(%esp)
  801388:	e8 70 ff ff ff       	call   8012fd <argnextvalue>
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    
  80138f:	90                   	nop

00801390 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	05 00 00 00 30       	add    $0x30000000,%eax
  80139b:	c1 e8 0c             	shr    $0xc,%eax
}
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013ba:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8013bf:	a8 01                	test   $0x1,%al
  8013c1:	74 34                	je     8013f7 <fd_alloc+0x40>
  8013c3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8013c8:	a8 01                	test   $0x1,%al
  8013ca:	74 32                	je     8013fe <fd_alloc+0x47>
  8013cc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013d1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 16             	shr    $0x16,%edx
  8013d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	74 1f                	je     801403 <fd_alloc+0x4c>
  8013e4:	89 c2                	mov    %eax,%edx
  8013e6:	c1 ea 0c             	shr    $0xc,%edx
  8013e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f0:	f6 c2 01             	test   $0x1,%dl
  8013f3:	75 1a                	jne    80140f <fd_alloc+0x58>
  8013f5:	eb 0c                	jmp    801403 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8013f7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8013fc:	eb 05                	jmp    801403 <fd_alloc+0x4c>
  8013fe:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 08                	mov    %ecx,(%eax)
			return 0;
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
  80140d:	eb 1a                	jmp    801429 <fd_alloc+0x72>
  80140f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801414:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801419:	75 b6                	jne    8013d1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801424:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    

0080142b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801431:	83 f8 1f             	cmp    $0x1f,%eax
  801434:	77 36                	ja     80146c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801436:	c1 e0 0c             	shl    $0xc,%eax
  801439:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80143e:	89 c2                	mov    %eax,%edx
  801440:	c1 ea 16             	shr    $0x16,%edx
  801443:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80144a:	f6 c2 01             	test   $0x1,%dl
  80144d:	74 24                	je     801473 <fd_lookup+0x48>
  80144f:	89 c2                	mov    %eax,%edx
  801451:	c1 ea 0c             	shr    $0xc,%edx
  801454:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80145b:	f6 c2 01             	test   $0x1,%dl
  80145e:	74 1a                	je     80147a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	89 02                	mov    %eax,(%edx)
	return 0;
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
  80146a:	eb 13                	jmp    80147f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80146c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801471:	eb 0c                	jmp    80147f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801478:	eb 05                	jmp    80147f <fd_lookup+0x54>
  80147a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    

00801481 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	53                   	push   %ebx
  801485:	83 ec 14             	sub    $0x14,%esp
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80148e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801494:	75 1e                	jne    8014b4 <dev_lookup+0x33>
  801496:	eb 0e                	jmp    8014a6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801498:	b8 20 30 80 00       	mov    $0x803020,%eax
  80149d:	eb 0c                	jmp    8014ab <dev_lookup+0x2a>
  80149f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  8014a4:	eb 05                	jmp    8014ab <dev_lookup+0x2a>
  8014a6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8014ab:	89 03                	mov    %eax,(%ebx)
			return 0;
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	eb 38                	jmp    8014ec <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8014b4:	39 05 20 30 80 00    	cmp    %eax,0x803020
  8014ba:	74 dc                	je     801498 <dev_lookup+0x17>
  8014bc:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8014c2:	74 db                	je     80149f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014c4:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8014ca:	8b 52 48             	mov    0x48(%edx),%edx
  8014cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014d5:	c7 04 24 4c 2a 80 00 	movl   $0x802a4c,(%esp)
  8014dc:	e8 db ef ff ff       	call   8004bc <cprintf>
	*dev = 0;
  8014e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014ec:	83 c4 14             	add    $0x14,%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    

008014f2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
  8014f7:	83 ec 20             	sub    $0x20,%esp
  8014fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8014fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801500:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801503:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801507:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80150d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 13 ff ff ff       	call   80142b <fd_lookup>
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 05                	js     801521 <fd_close+0x2f>
	    || fd != fd2)
  80151c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80151f:	74 0c                	je     80152d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801521:	84 db                	test   %bl,%bl
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
  801528:	0f 44 c2             	cmove  %edx,%eax
  80152b:	eb 3f                	jmp    80156c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80152d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801530:	89 44 24 04          	mov    %eax,0x4(%esp)
  801534:	8b 06                	mov    (%esi),%eax
  801536:	89 04 24             	mov    %eax,(%esp)
  801539:	e8 43 ff ff ff       	call   801481 <dev_lookup>
  80153e:	89 c3                	mov    %eax,%ebx
  801540:	85 c0                	test   %eax,%eax
  801542:	78 16                	js     80155a <fd_close+0x68>
		if (dev->dev_close)
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80154a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 07                	je     80155a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801553:	89 34 24             	mov    %esi,(%esp)
  801556:	ff d0                	call   *%eax
  801558:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80155a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80155e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801565:	e8 06 fb ff ff       	call   801070 <sys_page_unmap>
	return r;
  80156a:	89 d8                	mov    %ebx,%eax
}
  80156c:	83 c4 20             	add    $0x20,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801579:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 04 24             	mov    %eax,(%esp)
  801586:	e8 a0 fe ff ff       	call   80142b <fd_lookup>
  80158b:	89 c2                	mov    %eax,%edx
  80158d:	85 d2                	test   %edx,%edx
  80158f:	78 13                	js     8015a4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801591:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801598:	00 
  801599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159c:	89 04 24             	mov    %eax,(%esp)
  80159f:	e8 4e ff ff ff       	call   8014f2 <fd_close>
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <close_all>:

void
close_all(void)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 b9 ff ff ff       	call   801573 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ba:	83 c3 01             	add    $0x1,%ebx
  8015bd:	83 fb 20             	cmp    $0x20,%ebx
  8015c0:	75 f0                	jne    8015b2 <close_all+0xc>
		close(i);
}
  8015c2:	83 c4 14             	add    $0x14,%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    

008015c8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	57                   	push   %edi
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	89 04 24             	mov    %eax,(%esp)
  8015de:	e8 48 fe ff ff       	call   80142b <fd_lookup>
  8015e3:	89 c2                	mov    %eax,%edx
  8015e5:	85 d2                	test   %edx,%edx
  8015e7:	0f 88 e1 00 00 00    	js     8016ce <dup+0x106>
		return r;
	close(newfdnum);
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	89 04 24             	mov    %eax,(%esp)
  8015f3:	e8 7b ff ff ff       	call   801573 <close>

	newfd = INDEX2FD(newfdnum);
  8015f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015fb:	c1 e3 0c             	shl    $0xc,%ebx
  8015fe:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801607:	89 04 24             	mov    %eax,(%esp)
  80160a:	e8 91 fd ff ff       	call   8013a0 <fd2data>
  80160f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801611:	89 1c 24             	mov    %ebx,(%esp)
  801614:	e8 87 fd ff ff       	call   8013a0 <fd2data>
  801619:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80161b:	89 f0                	mov    %esi,%eax
  80161d:	c1 e8 16             	shr    $0x16,%eax
  801620:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801627:	a8 01                	test   $0x1,%al
  801629:	74 43                	je     80166e <dup+0xa6>
  80162b:	89 f0                	mov    %esi,%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801637:	f6 c2 01             	test   $0x1,%dl
  80163a:	74 32                	je     80166e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80163c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801643:	25 07 0e 00 00       	and    $0xe07,%eax
  801648:	89 44 24 10          	mov    %eax,0x10(%esp)
  80164c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801650:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801657:	00 
  801658:	89 74 24 04          	mov    %esi,0x4(%esp)
  80165c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801663:	e8 b5 f9 ff ff       	call   80101d <sys_page_map>
  801668:	89 c6                	mov    %eax,%esi
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 3e                	js     8016ac <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80166e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801671:	89 c2                	mov    %eax,%edx
  801673:	c1 ea 0c             	shr    $0xc,%edx
  801676:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80167d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801683:	89 54 24 10          	mov    %edx,0x10(%esp)
  801687:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80168b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801692:	00 
  801693:	89 44 24 04          	mov    %eax,0x4(%esp)
  801697:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169e:	e8 7a f9 ff ff       	call   80101d <sys_page_map>
  8016a3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016a8:	85 f6                	test   %esi,%esi
  8016aa:	79 22                	jns    8016ce <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b7:	e8 b4 f9 ff ff       	call   801070 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c7:	e8 a4 f9 ff ff       	call   801070 <sys_page_unmap>
	return r;
  8016cc:	89 f0                	mov    %esi,%eax
}
  8016ce:	83 c4 3c             	add    $0x3c,%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	53                   	push   %ebx
  8016da:	83 ec 24             	sub    $0x24,%esp
  8016dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e7:	89 1c 24             	mov    %ebx,(%esp)
  8016ea:	e8 3c fd ff ff       	call   80142b <fd_lookup>
  8016ef:	89 c2                	mov    %eax,%edx
  8016f1:	85 d2                	test   %edx,%edx
  8016f3:	78 6d                	js     801762 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	89 04 24             	mov    %eax,(%esp)
  801704:	e8 78 fd ff ff       	call   801481 <dev_lookup>
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 55                	js     801762 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801710:	8b 50 08             	mov    0x8(%eax),%edx
  801713:	83 e2 03             	and    $0x3,%edx
  801716:	83 fa 01             	cmp    $0x1,%edx
  801719:	75 23                	jne    80173e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171b:	a1 20 44 80 00       	mov    0x804420,%eax
  801720:	8b 40 48             	mov    0x48(%eax),%eax
  801723:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172b:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  801732:	e8 85 ed ff ff       	call   8004bc <cprintf>
		return -E_INVAL;
  801737:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173c:	eb 24                	jmp    801762 <read+0x8c>
	}
	if (!dev->dev_read)
  80173e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801741:	8b 52 08             	mov    0x8(%edx),%edx
  801744:	85 d2                	test   %edx,%edx
  801746:	74 15                	je     80175d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80174f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801752:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801756:	89 04 24             	mov    %eax,(%esp)
  801759:	ff d2                	call   *%edx
  80175b:	eb 05                	jmp    801762 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80175d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801762:	83 c4 24             	add    $0x24,%esp
  801765:	5b                   	pop    %ebx
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	57                   	push   %edi
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	83 ec 1c             	sub    $0x1c,%esp
  801771:	8b 7d 08             	mov    0x8(%ebp),%edi
  801774:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801777:	85 f6                	test   %esi,%esi
  801779:	74 33                	je     8017ae <readn+0x46>
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801785:	89 f2                	mov    %esi,%edx
  801787:	29 c2                	sub    %eax,%edx
  801789:	89 54 24 08          	mov    %edx,0x8(%esp)
  80178d:	03 45 0c             	add    0xc(%ebp),%eax
  801790:	89 44 24 04          	mov    %eax,0x4(%esp)
  801794:	89 3c 24             	mov    %edi,(%esp)
  801797:	e8 3a ff ff ff       	call   8016d6 <read>
		if (m < 0)
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 1b                	js     8017bb <readn+0x53>
			return m;
		if (m == 0)
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	74 11                	je     8017b5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017a4:	01 c3                	add    %eax,%ebx
  8017a6:	89 d8                	mov    %ebx,%eax
  8017a8:	39 f3                	cmp    %esi,%ebx
  8017aa:	72 d9                	jb     801785 <readn+0x1d>
  8017ac:	eb 0b                	jmp    8017b9 <readn+0x51>
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	eb 06                	jmp    8017bb <readn+0x53>
  8017b5:	89 d8                	mov    %ebx,%eax
  8017b7:	eb 02                	jmp    8017bb <readn+0x53>
  8017b9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017bb:	83 c4 1c             	add    $0x1c,%esp
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5f                   	pop    %edi
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 24             	sub    $0x24,%esp
  8017ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	89 1c 24             	mov    %ebx,(%esp)
  8017d7:	e8 4f fc ff ff       	call   80142b <fd_lookup>
  8017dc:	89 c2                	mov    %eax,%edx
  8017de:	85 d2                	test   %edx,%edx
  8017e0:	78 68                	js     80184a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8b 00                	mov    (%eax),%eax
  8017ee:	89 04 24             	mov    %eax,(%esp)
  8017f1:	e8 8b fc ff ff       	call   801481 <dev_lookup>
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 50                	js     80184a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801801:	75 23                	jne    801826 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801803:	a1 20 44 80 00       	mov    0x804420,%eax
  801808:	8b 40 48             	mov    0x48(%eax),%eax
  80180b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80180f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801813:	c7 04 24 ac 2a 80 00 	movl   $0x802aac,(%esp)
  80181a:	e8 9d ec ff ff       	call   8004bc <cprintf>
		return -E_INVAL;
  80181f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801824:	eb 24                	jmp    80184a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801829:	8b 52 0c             	mov    0xc(%edx),%edx
  80182c:	85 d2                	test   %edx,%edx
  80182e:	74 15                	je     801845 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801837:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80183e:	89 04 24             	mov    %eax,(%esp)
  801841:	ff d2                	call   *%edx
  801843:	eb 05                	jmp    80184a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801845:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80184a:	83 c4 24             	add    $0x24,%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <seek>:

int
seek(int fdnum, off_t offset)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801856:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	89 04 24             	mov    %eax,(%esp)
  801863:	e8 c3 fb ff ff       	call   80142b <fd_lookup>
  801868:	85 c0                	test   %eax,%eax
  80186a:	78 0e                	js     80187a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 24             	sub    $0x24,%esp
  801883:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801886:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801889:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188d:	89 1c 24             	mov    %ebx,(%esp)
  801890:	e8 96 fb ff ff       	call   80142b <fd_lookup>
  801895:	89 c2                	mov    %eax,%edx
  801897:	85 d2                	test   %edx,%edx
  801899:	78 61                	js     8018fc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80189b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	89 04 24             	mov    %eax,(%esp)
  8018aa:	e8 d2 fb ff ff       	call   801481 <dev_lookup>
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 49                	js     8018fc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ba:	75 23                	jne    8018df <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018bc:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018c1:	8b 40 48             	mov    0x48(%eax),%eax
  8018c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cc:	c7 04 24 6c 2a 80 00 	movl   $0x802a6c,(%esp)
  8018d3:	e8 e4 eb ff ff       	call   8004bc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018dd:	eb 1d                	jmp    8018fc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e2:	8b 52 18             	mov    0x18(%edx),%edx
  8018e5:	85 d2                	test   %edx,%edx
  8018e7:	74 0e                	je     8018f7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018f0:	89 04 24             	mov    %eax,(%esp)
  8018f3:	ff d2                	call   *%edx
  8018f5:	eb 05                	jmp    8018fc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018fc:	83 c4 24             	add    $0x24,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	53                   	push   %ebx
  801906:	83 ec 24             	sub    $0x24,%esp
  801909:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 0d fb ff ff       	call   80142b <fd_lookup>
  80191e:	89 c2                	mov    %eax,%edx
  801920:	85 d2                	test   %edx,%edx
  801922:	78 52                	js     801976 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	89 04 24             	mov    %eax,(%esp)
  801933:	e8 49 fb ff ff       	call   801481 <dev_lookup>
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 3a                	js     801976 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801943:	74 2c                	je     801971 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801945:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801948:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80194f:	00 00 00 
	stat->st_isdir = 0;
  801952:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801959:	00 00 00 
	stat->st_dev = dev;
  80195c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801962:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801966:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801969:	89 14 24             	mov    %edx,(%esp)
  80196c:	ff 50 14             	call   *0x14(%eax)
  80196f:	eb 05                	jmp    801976 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801971:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801976:	83 c4 24             	add    $0x24,%esp
  801979:	5b                   	pop    %ebx
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	56                   	push   %esi
  801980:	53                   	push   %ebx
  801981:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801984:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80198b:	00 
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 af 01 00 00       	call   801b46 <open>
  801997:	89 c3                	mov    %eax,%ebx
  801999:	85 db                	test   %ebx,%ebx
  80199b:	78 1b                	js     8019b8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a4:	89 1c 24             	mov    %ebx,(%esp)
  8019a7:	e8 56 ff ff ff       	call   801902 <fstat>
  8019ac:	89 c6                	mov    %eax,%esi
	close(fd);
  8019ae:	89 1c 24             	mov    %ebx,(%esp)
  8019b1:	e8 bd fb ff ff       	call   801573 <close>
	return r;
  8019b6:	89 f0                	mov    %esi,%eax
}
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5d                   	pop    %ebp
  8019be:	c3                   	ret    

008019bf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 10             	sub    $0x10,%esp
  8019c7:	89 c6                	mov    %eax,%esi
  8019c9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019cb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019d2:	75 11                	jne    8019e5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019db:	e8 64 09 00 00       	call   802344 <ipc_find_env>
  8019e0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019e5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019ec:	00 
  8019ed:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8019f4:	00 
  8019f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019f9:	a1 00 40 80 00       	mov    0x804000,%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 d8 08 00 00       	call   8022de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a0d:	00 
  801a0e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a19:	e8 58 08 00 00       	call   802276 <ipc_recv>
}
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	5b                   	pop    %ebx
  801a22:	5e                   	pop    %esi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    

00801a25 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 14             	sub    $0x14,%esp
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a44:	e8 76 ff ff ff       	call   8019bf <fsipc>
  801a49:	89 c2                	mov    %eax,%edx
  801a4b:	85 d2                	test   %edx,%edx
  801a4d:	78 2b                	js     801a7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a56:	00 
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	e8 bc f0 ff ff       	call   800b1b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5f:	a1 80 50 80 00       	mov    0x805080,%eax
  801a64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a6a:	a1 84 50 80 00       	mov    0x805084,%eax
  801a6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	83 c4 14             	add    $0x14,%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	b8 06 00 00 00       	mov    $0x6,%eax
  801a9b:	e8 1f ff ff ff       	call   8019bf <fsipc>
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 10             	sub    $0x10,%esp
  801aaa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ab8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac8:	e8 f2 fe ff ff       	call   8019bf <fsipc>
  801acd:	89 c3                	mov    %eax,%ebx
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	78 6a                	js     801b3d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ad3:	39 c6                	cmp    %eax,%esi
  801ad5:	73 24                	jae    801afb <devfile_read+0x59>
  801ad7:	c7 44 24 0c c9 2a 80 	movl   $0x802ac9,0xc(%esp)
  801ade:	00 
  801adf:	c7 44 24 08 d0 2a 80 	movl   $0x802ad0,0x8(%esp)
  801ae6:	00 
  801ae7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801aee:	00 
  801aef:	c7 04 24 e5 2a 80 00 	movl   $0x802ae5,(%esp)
  801af6:	e8 c8 e8 ff ff       	call   8003c3 <_panic>
	assert(r <= PGSIZE);
  801afb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b00:	7e 24                	jle    801b26 <devfile_read+0x84>
  801b02:	c7 44 24 0c f0 2a 80 	movl   $0x802af0,0xc(%esp)
  801b09:	00 
  801b0a:	c7 44 24 08 d0 2a 80 	movl   $0x802ad0,0x8(%esp)
  801b11:	00 
  801b12:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801b19:	00 
  801b1a:	c7 04 24 e5 2a 80 00 	movl   $0x802ae5,(%esp)
  801b21:	e8 9d e8 ff ff       	call   8003c3 <_panic>
	memmove(buf, &fsipcbuf, r);
  801b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b2a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801b31:	00 
  801b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b35:	89 04 24             	mov    %eax,(%esp)
  801b38:	e8 d9 f1 ff ff       	call   800d16 <memmove>
	return r;
}
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 24             	sub    $0x24,%esp
  801b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b50:	89 1c 24             	mov    %ebx,(%esp)
  801b53:	e8 68 ef ff ff       	call   800ac0 <strlen>
  801b58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b5d:	7f 60                	jg     801bbf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b62:	89 04 24             	mov    %eax,(%esp)
  801b65:	e8 4d f8 ff ff       	call   8013b7 <fd_alloc>
  801b6a:	89 c2                	mov    %eax,%edx
  801b6c:	85 d2                	test   %edx,%edx
  801b6e:	78 54                	js     801bc4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b74:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b7b:	e8 9b ef ff ff       	call   800b1b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b90:	e8 2a fe ff ff       	call   8019bf <fsipc>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	85 c0                	test   %eax,%eax
  801b99:	79 17                	jns    801bb2 <open+0x6c>
		fd_close(fd, 0);
  801b9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ba2:	00 
  801ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	e8 44 f9 ff ff       	call   8014f2 <fd_close>
		return r;
  801bae:	89 d8                	mov    %ebx,%eax
  801bb0:	eb 12                	jmp    801bc4 <open+0x7e>
	}
	return fd2num(fd);
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	89 04 24             	mov    %eax,(%esp)
  801bb8:	e8 d3 f7 ff ff       	call   801390 <fd2num>
  801bbd:	eb 05                	jmp    801bc4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bbf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801bc4:	83 c4 24             	add    $0x24,%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    

00801bca <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	53                   	push   %ebx
  801bce:	83 ec 14             	sub    $0x14,%esp
  801bd1:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801bd3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801bd7:	7e 31                	jle    801c0a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801bd9:	8b 40 04             	mov    0x4(%eax),%eax
  801bdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be0:	8d 43 10             	lea    0x10(%ebx),%eax
  801be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be7:	8b 03                	mov    (%ebx),%eax
  801be9:	89 04 24             	mov    %eax,(%esp)
  801bec:	e8 d2 fb ff ff       	call   8017c3 <write>
		if (result > 0)
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	7e 03                	jle    801bf8 <writebuf+0x2e>
			b->result += result;
  801bf5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801bf8:	39 43 04             	cmp    %eax,0x4(%ebx)
  801bfb:	74 0d                	je     801c0a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	ba 00 00 00 00       	mov    $0x0,%edx
  801c04:	0f 4f c2             	cmovg  %edx,%eax
  801c07:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c0a:	83 c4 14             	add    $0x14,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <putch>:

static void
putch(int ch, void *thunk)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c1a:	8b 53 04             	mov    0x4(%ebx),%edx
  801c1d:	8d 42 01             	lea    0x1(%edx),%eax
  801c20:	89 43 04             	mov    %eax,0x4(%ebx)
  801c23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c26:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c2a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c2f:	75 0e                	jne    801c3f <putch+0x2f>
		writebuf(b);
  801c31:	89 d8                	mov    %ebx,%eax
  801c33:	e8 92 ff ff ff       	call   801bca <writebuf>
		b->idx = 0;
  801c38:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c3f:	83 c4 04             	add    $0x4,%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c57:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c5e:	00 00 00 
	b.result = 0;
  801c61:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c68:	00 00 00 
	b.error = 1;
  801c6b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c72:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c75:	8b 45 10             	mov    0x10(%ebp),%eax
  801c78:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c83:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8d:	c7 04 24 10 1c 80 00 	movl   $0x801c10,(%esp)
  801c94:	e8 bb e9 ff ff       	call   800654 <vprintfmt>
	if (b.idx > 0)
  801c99:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ca0:	7e 0b                	jle    801cad <vfprintf+0x68>
		writebuf(&b);
  801ca2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ca8:	e8 1d ff ff ff       	call   801bca <writebuf>

	return (b.result ? b.result : b.error);
  801cad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc4:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	89 04 24             	mov    %eax,(%esp)
  801cd8:	e8 68 ff ff ff       	call   801c45 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <printf>:

int
printf(const char *fmt, ...)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ce5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ce8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cfa:	e8 46 ff ff ff       	call   801c45 <vfprintf>
	va_end(ap);

	return cnt;
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    
  801d01:	66 90                	xchg   %ax,%ax
  801d03:	66 90                	xchg   %ax,%ax
  801d05:	66 90                	xchg   %ax,%ax
  801d07:	66 90                	xchg   %ax,%ax
  801d09:	66 90                	xchg   %ax,%ax
  801d0b:	66 90                	xchg   %ax,%ax
  801d0d:	66 90                	xchg   %ax,%ax
  801d0f:	90                   	nop

00801d10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	56                   	push   %esi
  801d14:	53                   	push   %ebx
  801d15:	83 ec 10             	sub    $0x10,%esp
  801d18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	89 04 24             	mov    %eax,(%esp)
  801d21:	e8 7a f6 ff ff       	call   8013a0 <fd2data>
  801d26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d28:	c7 44 24 04 fc 2a 80 	movl   $0x802afc,0x4(%esp)
  801d2f:	00 
  801d30:	89 1c 24             	mov    %ebx,(%esp)
  801d33:	e8 e3 ed ff ff       	call   800b1b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d38:	8b 46 04             	mov    0x4(%esi),%eax
  801d3b:	2b 06                	sub    (%esi),%eax
  801d3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d4a:	00 00 00 
	stat->st_dev = &devpipe;
  801d4d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d54:	30 80 00 
	return 0;
}
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 14             	sub    $0x14,%esp
  801d6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d6d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d78:	e8 f3 f2 ff ff       	call   801070 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d7d:	89 1c 24             	mov    %ebx,(%esp)
  801d80:	e8 1b f6 ff ff       	call   8013a0 <fd2data>
  801d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d90:	e8 db f2 ff ff       	call   801070 <sys_page_unmap>
}
  801d95:	83 c4 14             	add    $0x14,%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	57                   	push   %edi
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	83 ec 2c             	sub    $0x2c,%esp
  801da4:	89 c6                	mov    %eax,%esi
  801da6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801da9:	a1 20 44 80 00       	mov    0x804420,%eax
  801dae:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801db1:	89 34 24             	mov    %esi,(%esp)
  801db4:	e8 d3 05 00 00       	call   80238c <pageref>
  801db9:	89 c7                	mov    %eax,%edi
  801dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbe:	89 04 24             	mov    %eax,(%esp)
  801dc1:	e8 c6 05 00 00       	call   80238c <pageref>
  801dc6:	39 c7                	cmp    %eax,%edi
  801dc8:	0f 94 c2             	sete   %dl
  801dcb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801dce:	8b 0d 20 44 80 00    	mov    0x804420,%ecx
  801dd4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801dd7:	39 fb                	cmp    %edi,%ebx
  801dd9:	74 21                	je     801dfc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ddb:	84 d2                	test   %dl,%dl
  801ddd:	74 ca                	je     801da9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ddf:	8b 51 58             	mov    0x58(%ecx),%edx
  801de2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801de6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dee:	c7 04 24 03 2b 80 00 	movl   $0x802b03,(%esp)
  801df5:	e8 c2 e6 ff ff       	call   8004bc <cprintf>
  801dfa:	eb ad                	jmp    801da9 <_pipeisclosed+0xe>
	}
}
  801dfc:	83 c4 2c             	add    $0x2c,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5f                   	pop    %edi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    

00801e04 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	57                   	push   %edi
  801e08:	56                   	push   %esi
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 1c             	sub    $0x1c,%esp
  801e0d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e10:	89 34 24             	mov    %esi,(%esp)
  801e13:	e8 88 f5 ff ff       	call   8013a0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e1c:	74 61                	je     801e7f <devpipe_write+0x7b>
  801e1e:	89 c3                	mov    %eax,%ebx
  801e20:	bf 00 00 00 00       	mov    $0x0,%edi
  801e25:	eb 4a                	jmp    801e71 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e27:	89 da                	mov    %ebx,%edx
  801e29:	89 f0                	mov    %esi,%eax
  801e2b:	e8 6b ff ff ff       	call   801d9b <_pipeisclosed>
  801e30:	85 c0                	test   %eax,%eax
  801e32:	75 54                	jne    801e88 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e34:	e8 71 f1 ff ff       	call   800faa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e39:	8b 43 04             	mov    0x4(%ebx),%eax
  801e3c:	8b 0b                	mov    (%ebx),%ecx
  801e3e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e41:	39 d0                	cmp    %edx,%eax
  801e43:	73 e2                	jae    801e27 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e48:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e4c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e4f:	99                   	cltd   
  801e50:	c1 ea 1b             	shr    $0x1b,%edx
  801e53:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e56:	83 e1 1f             	and    $0x1f,%ecx
  801e59:	29 d1                	sub    %edx,%ecx
  801e5b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e5f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e63:	83 c0 01             	add    $0x1,%eax
  801e66:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e69:	83 c7 01             	add    $0x1,%edi
  801e6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e6f:	74 13                	je     801e84 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e71:	8b 43 04             	mov    0x4(%ebx),%eax
  801e74:	8b 0b                	mov    (%ebx),%ecx
  801e76:	8d 51 20             	lea    0x20(%ecx),%edx
  801e79:	39 d0                	cmp    %edx,%eax
  801e7b:	73 aa                	jae    801e27 <devpipe_write+0x23>
  801e7d:	eb c6                	jmp    801e45 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e7f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e84:	89 f8                	mov    %edi,%eax
  801e86:	eb 05                	jmp    801e8d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e8d:	83 c4 1c             	add    $0x1c,%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    

00801e95 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	57                   	push   %edi
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 1c             	sub    $0x1c,%esp
  801e9e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ea1:	89 3c 24             	mov    %edi,(%esp)
  801ea4:	e8 f7 f4 ff ff       	call   8013a0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ead:	74 54                	je     801f03 <devpipe_read+0x6e>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	be 00 00 00 00       	mov    $0x0,%esi
  801eb6:	eb 3e                	jmp    801ef6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801eb8:	89 f0                	mov    %esi,%eax
  801eba:	eb 55                	jmp    801f11 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ebc:	89 da                	mov    %ebx,%edx
  801ebe:	89 f8                	mov    %edi,%eax
  801ec0:	e8 d6 fe ff ff       	call   801d9b <_pipeisclosed>
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	75 43                	jne    801f0c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ec9:	e8 dc f0 ff ff       	call   800faa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ece:	8b 03                	mov    (%ebx),%eax
  801ed0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ed3:	74 e7                	je     801ebc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ed5:	99                   	cltd   
  801ed6:	c1 ea 1b             	shr    $0x1b,%edx
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	83 e0 1f             	and    $0x1f,%eax
  801ede:	29 d0                	sub    %edx,%eax
  801ee0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eeb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eee:	83 c6 01             	add    $0x1,%esi
  801ef1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ef4:	74 12                	je     801f08 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801ef6:	8b 03                	mov    (%ebx),%eax
  801ef8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801efb:	75 d8                	jne    801ed5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801efd:	85 f6                	test   %esi,%esi
  801eff:	75 b7                	jne    801eb8 <devpipe_read+0x23>
  801f01:	eb b9                	jmp    801ebc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f03:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f08:	89 f0                	mov    %esi,%eax
  801f0a:	eb 05                	jmp    801f11 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f11:	83 c4 1c             	add    $0x1c,%esp
  801f14:	5b                   	pop    %ebx
  801f15:	5e                   	pop    %esi
  801f16:	5f                   	pop    %edi
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    

00801f19 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	56                   	push   %esi
  801f1d:	53                   	push   %ebx
  801f1e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f24:	89 04 24             	mov    %eax,(%esp)
  801f27:	e8 8b f4 ff ff       	call   8013b7 <fd_alloc>
  801f2c:	89 c2                	mov    %eax,%edx
  801f2e:	85 d2                	test   %edx,%edx
  801f30:	0f 88 4d 01 00 00    	js     802083 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f3d:	00 
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4c:	e8 78 f0 ff ff       	call   800fc9 <sys_page_alloc>
  801f51:	89 c2                	mov    %eax,%edx
  801f53:	85 d2                	test   %edx,%edx
  801f55:	0f 88 28 01 00 00    	js     802083 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	e8 51 f4 ff ff       	call   8013b7 <fd_alloc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 88 fe 00 00 00    	js     80206e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f70:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f77:	00 
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f86:	e8 3e f0 ff ff       	call   800fc9 <sys_page_alloc>
  801f8b:	89 c3                	mov    %eax,%ebx
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	0f 88 d9 00 00 00    	js     80206e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	89 04 24             	mov    %eax,(%esp)
  801f9b:	e8 00 f4 ff ff       	call   8013a0 <fd2data>
  801fa0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa9:	00 
  801faa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb5:	e8 0f f0 ff ff       	call   800fc9 <sys_page_alloc>
  801fba:	89 c3                	mov    %eax,%ebx
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	0f 88 97 00 00 00    	js     80205b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	89 04 24             	mov    %eax,(%esp)
  801fca:	e8 d1 f3 ff ff       	call   8013a0 <fd2data>
  801fcf:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801fd6:	00 
  801fd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fe2:	00 
  801fe3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fee:	e8 2a f0 ff ff       	call   80101d <sys_page_map>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 52                	js     80204b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ff9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80200e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	89 04 24             	mov    %eax,(%esp)
  802029:	e8 62 f3 ff ff       	call   801390 <fd2num>
  80202e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802031:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 52 f3 ff ff       	call   801390 <fd2num>
  80203e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802041:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	eb 38                	jmp    802083 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80204b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80204f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802056:	e8 15 f0 ff ff       	call   801070 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80205b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802069:	e8 02 f0 ff ff       	call   801070 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	89 44 24 04          	mov    %eax,0x4(%esp)
  802075:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80207c:	e8 ef ef ff ff       	call   801070 <sys_page_unmap>
  802081:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802083:	83 c4 30             	add    $0x30,%esp
  802086:	5b                   	pop    %ebx
  802087:	5e                   	pop    %esi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802090:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802093:	89 44 24 04          	mov    %eax,0x4(%esp)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	89 04 24             	mov    %eax,(%esp)
  80209d:	e8 89 f3 ff ff       	call   80142b <fd_lookup>
  8020a2:	89 c2                	mov    %eax,%edx
  8020a4:	85 d2                	test   %edx,%edx
  8020a6:	78 15                	js     8020bd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 ed f2 ff ff       	call   8013a0 <fd2data>
	return _pipeisclosed(fd, p);
  8020b3:	89 c2                	mov    %eax,%edx
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	e8 de fc ff ff       	call   801d9b <_pipeisclosed>
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    
  8020bf:	90                   	nop

008020c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020d0:	c7 44 24 04 1b 2b 80 	movl   $0x802b1b,0x4(%esp)
  8020d7:	00 
  8020d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 38 ea ff ff       	call   800b1b <strcpy>
	return 0;
}
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	57                   	push   %edi
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fa:	74 4a                	je     802146 <devcons_write+0x5c>
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802106:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80210c:	8b 75 10             	mov    0x10(%ebp),%esi
  80210f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802111:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802114:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802119:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80211c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802120:	03 45 0c             	add    0xc(%ebp),%eax
  802123:	89 44 24 04          	mov    %eax,0x4(%esp)
  802127:	89 3c 24             	mov    %edi,(%esp)
  80212a:	e8 e7 eb ff ff       	call   800d16 <memmove>
		sys_cputs(buf, m);
  80212f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802133:	89 3c 24             	mov    %edi,(%esp)
  802136:	e8 c1 ed ff ff       	call   800efc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80213b:	01 f3                	add    %esi,%ebx
  80213d:	89 d8                	mov    %ebx,%eax
  80213f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802142:	72 c8                	jb     80210c <devcons_write+0x22>
  802144:	eb 05                	jmp    80214b <devcons_write+0x61>
  802146:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80214b:	89 d8                	mov    %ebx,%eax
  80214d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802167:	75 07                	jne    802170 <devcons_read+0x18>
  802169:	eb 28                	jmp    802193 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80216b:	e8 3a ee ff ff       	call   800faa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802170:	e8 a5 ed ff ff       	call   800f1a <sys_cgetc>
  802175:	85 c0                	test   %eax,%eax
  802177:	74 f2                	je     80216b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 16                	js     802193 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80217d:	83 f8 04             	cmp    $0x4,%eax
  802180:	74 0c                	je     80218e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	88 02                	mov    %al,(%edx)
	return 1;
  802187:	b8 01 00 00 00       	mov    $0x1,%eax
  80218c:	eb 05                	jmp    802193 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021a8:	00 
  8021a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 48 ed ff ff       	call   800efc <sys_cputs>
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <getchar>:

int
getchar(void)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021c3:	00 
  8021c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d2:	e8 ff f4 ff ff       	call   8016d6 <read>
	if (r < 0)
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 0f                	js     8021ea <getchar+0x34>
		return r;
	if (r < 1)
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	7e 06                	jle    8021e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021e3:	eb 05                	jmp    8021ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 27 f2 ff ff       	call   80142b <fd_lookup>
  802204:	85 c0                	test   %eax,%eax
  802206:	78 11                	js     802219 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802211:	39 10                	cmp    %edx,(%eax)
  802213:	0f 94 c0             	sete   %al
  802216:	0f b6 c0             	movzbl %al,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <opencons>:

int
opencons(void)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802221:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802224:	89 04 24             	mov    %eax,(%esp)
  802227:	e8 8b f1 ff ff       	call   8013b7 <fd_alloc>
		return r;
  80222c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 40                	js     802272 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802232:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802239:	00 
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802248:	e8 7c ed ff ff       	call   800fc9 <sys_page_alloc>
		return r;
  80224d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 1f                	js     802272 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802253:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802268:	89 04 24             	mov    %eax,(%esp)
  80226b:	e8 20 f1 ff ff       	call   801390 <fd2num>
  802270:	89 c2                	mov    %eax,%edx
}
  802272:	89 d0                	mov    %edx,%eax
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	56                   	push   %esi
  80227a:	53                   	push   %ebx
  80227b:	83 ec 10             	sub    $0x10,%esp
  80227e:	8b 75 08             	mov    0x8(%ebp),%esi
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802287:	85 c0                	test   %eax,%eax
  802289:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80228e:	0f 44 c2             	cmove  %edx,%eax
  802291:	89 04 24             	mov    %eax,(%esp)
  802294:	e8 46 ef ff ff       	call   8011df <sys_ipc_recv>
	if (err_code < 0) {
  802299:	85 c0                	test   %eax,%eax
  80229b:	79 16                	jns    8022b3 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80229d:	85 f6                	test   %esi,%esi
  80229f:	74 06                	je     8022a7 <ipc_recv+0x31>
  8022a1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8022a7:	85 db                	test   %ebx,%ebx
  8022a9:	74 2c                	je     8022d7 <ipc_recv+0x61>
  8022ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022b1:	eb 24                	jmp    8022d7 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8022b3:	85 f6                	test   %esi,%esi
  8022b5:	74 0a                	je     8022c1 <ipc_recv+0x4b>
  8022b7:	a1 20 44 80 00       	mov    0x804420,%eax
  8022bc:	8b 40 74             	mov    0x74(%eax),%eax
  8022bf:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8022c1:	85 db                	test   %ebx,%ebx
  8022c3:	74 0a                	je     8022cf <ipc_recv+0x59>
  8022c5:	a1 20 44 80 00       	mov    0x804420,%eax
  8022ca:	8b 40 78             	mov    0x78(%eax),%eax
  8022cd:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8022cf:	a1 20 44 80 00       	mov    0x804420,%eax
  8022d4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022d7:	83 c4 10             	add    $0x10,%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 1c             	sub    $0x1c,%esp
  8022e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8022f0:	eb 25                	jmp    802317 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8022f2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022f5:	74 20                	je     802317 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  8022f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fb:	c7 44 24 08 27 2b 80 	movl   $0x802b27,0x8(%esp)
  802302:	00 
  802303:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80230a:	00 
  80230b:	c7 04 24 33 2b 80 00 	movl   $0x802b33,(%esp)
  802312:	e8 ac e0 ff ff       	call   8003c3 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802317:	85 db                	test   %ebx,%ebx
  802319:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80231e:	0f 45 c3             	cmovne %ebx,%eax
  802321:	8b 55 14             	mov    0x14(%ebp),%edx
  802324:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802328:	89 44 24 08          	mov    %eax,0x8(%esp)
  80232c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802330:	89 3c 24             	mov    %edi,(%esp)
  802333:	e8 84 ee ff ff       	call   8011bc <sys_ipc_try_send>
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 b6                	jne    8022f2 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80233c:	83 c4 1c             	add    $0x1c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  80234a:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80234f:	39 c8                	cmp    %ecx,%eax
  802351:	74 17                	je     80236a <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  802358:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80235b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802361:	8b 52 50             	mov    0x50(%edx),%edx
  802364:	39 ca                	cmp    %ecx,%edx
  802366:	75 14                	jne    80237c <ipc_find_env+0x38>
  802368:	eb 05                	jmp    80236f <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80236f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802372:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802377:	8b 40 40             	mov    0x40(%eax),%eax
  80237a:	eb 0e                	jmp    80238a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80237c:	83 c0 01             	add    $0x1,%eax
  80237f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802384:	75 d2                	jne    802358 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802386:	66 b8 00 00          	mov    $0x0,%ax
}
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    

0080238c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802392:	89 d0                	mov    %edx,%eax
  802394:	c1 e8 16             	shr    $0x16,%eax
  802397:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a3:	f6 c1 01             	test   $0x1,%cl
  8023a6:	74 1d                	je     8023c5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023a8:	c1 ea 0c             	shr    $0xc,%edx
  8023ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023b2:	f6 c2 01             	test   $0x1,%dl
  8023b5:	74 0e                	je     8023c5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b7:	c1 ea 0c             	shr    $0xc,%edx
  8023ba:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023c1:	ef 
  8023c2:	0f b7 c0             	movzwl %ax,%eax
}
  8023c5:	5d                   	pop    %ebp
  8023c6:	c3                   	ret    
  8023c7:	66 90                	xchg   %ax,%ax
  8023c9:	66 90                	xchg   %ax,%ax
  8023cb:	66 90                	xchg   %ax,%ax
  8023cd:	66 90                	xchg   %ax,%ax
  8023cf:	90                   	nop

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023ec:	89 ea                	mov    %ebp,%edx
  8023ee:	89 0c 24             	mov    %ecx,(%esp)
  8023f1:	75 2d                	jne    802420 <__udivdi3+0x50>
  8023f3:	39 e9                	cmp    %ebp,%ecx
  8023f5:	77 61                	ja     802458 <__udivdi3+0x88>
  8023f7:	85 c9                	test   %ecx,%ecx
  8023f9:	89 ce                	mov    %ecx,%esi
  8023fb:	75 0b                	jne    802408 <__udivdi3+0x38>
  8023fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802402:	31 d2                	xor    %edx,%edx
  802404:	f7 f1                	div    %ecx
  802406:	89 c6                	mov    %eax,%esi
  802408:	31 d2                	xor    %edx,%edx
  80240a:	89 e8                	mov    %ebp,%eax
  80240c:	f7 f6                	div    %esi
  80240e:	89 c5                	mov    %eax,%ebp
  802410:	89 f8                	mov    %edi,%eax
  802412:	f7 f6                	div    %esi
  802414:	89 ea                	mov    %ebp,%edx
  802416:	83 c4 0c             	add    $0xc,%esp
  802419:	5e                   	pop    %esi
  80241a:	5f                   	pop    %edi
  80241b:	5d                   	pop    %ebp
  80241c:	c3                   	ret    
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	39 e8                	cmp    %ebp,%eax
  802422:	77 24                	ja     802448 <__udivdi3+0x78>
  802424:	0f bd e8             	bsr    %eax,%ebp
  802427:	83 f5 1f             	xor    $0x1f,%ebp
  80242a:	75 3c                	jne    802468 <__udivdi3+0x98>
  80242c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802430:	39 34 24             	cmp    %esi,(%esp)
  802433:	0f 86 9f 00 00 00    	jbe    8024d8 <__udivdi3+0x108>
  802439:	39 d0                	cmp    %edx,%eax
  80243b:	0f 82 97 00 00 00    	jb     8024d8 <__udivdi3+0x108>
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	83 c4 0c             	add    $0xc,%esp
  80244f:	5e                   	pop    %esi
  802450:	5f                   	pop    %edi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    
  802453:	90                   	nop
  802454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 f8                	mov    %edi,%eax
  80245a:	f7 f1                	div    %ecx
  80245c:	31 d2                	xor    %edx,%edx
  80245e:	83 c4 0c             	add    $0xc,%esp
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	8b 3c 24             	mov    (%esp),%edi
  80246d:	d3 e0                	shl    %cl,%eax
  80246f:	89 c6                	mov    %eax,%esi
  802471:	b8 20 00 00 00       	mov    $0x20,%eax
  802476:	29 e8                	sub    %ebp,%eax
  802478:	89 c1                	mov    %eax,%ecx
  80247a:	d3 ef                	shr    %cl,%edi
  80247c:	89 e9                	mov    %ebp,%ecx
  80247e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802482:	8b 3c 24             	mov    (%esp),%edi
  802485:	09 74 24 08          	or     %esi,0x8(%esp)
  802489:	89 d6                	mov    %edx,%esi
  80248b:	d3 e7                	shl    %cl,%edi
  80248d:	89 c1                	mov    %eax,%ecx
  80248f:	89 3c 24             	mov    %edi,(%esp)
  802492:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802496:	d3 ee                	shr    %cl,%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	d3 e2                	shl    %cl,%edx
  80249c:	89 c1                	mov    %eax,%ecx
  80249e:	d3 ef                	shr    %cl,%edi
  8024a0:	09 d7                	or     %edx,%edi
  8024a2:	89 f2                	mov    %esi,%edx
  8024a4:	89 f8                	mov    %edi,%eax
  8024a6:	f7 74 24 08          	divl   0x8(%esp)
  8024aa:	89 d6                	mov    %edx,%esi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	f7 24 24             	mull   (%esp)
  8024b1:	39 d6                	cmp    %edx,%esi
  8024b3:	89 14 24             	mov    %edx,(%esp)
  8024b6:	72 30                	jb     8024e8 <__udivdi3+0x118>
  8024b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024bc:	89 e9                	mov    %ebp,%ecx
  8024be:	d3 e2                	shl    %cl,%edx
  8024c0:	39 c2                	cmp    %eax,%edx
  8024c2:	73 05                	jae    8024c9 <__udivdi3+0xf9>
  8024c4:	3b 34 24             	cmp    (%esp),%esi
  8024c7:	74 1f                	je     8024e8 <__udivdi3+0x118>
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	e9 7a ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	31 d2                	xor    %edx,%edx
  8024da:	b8 01 00 00 00       	mov    $0x1,%eax
  8024df:	e9 68 ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	83 c4 0c             	add    $0xc,%esp
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	83 ec 14             	sub    $0x14,%esp
  802506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80250a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80250e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802512:	89 c7                	mov    %eax,%edi
  802514:	89 44 24 04          	mov    %eax,0x4(%esp)
  802518:	8b 44 24 30          	mov    0x30(%esp),%eax
  80251c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802520:	89 34 24             	mov    %esi,(%esp)
  802523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802527:	85 c0                	test   %eax,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	75 17                	jne    802548 <__umoddi3+0x48>
  802531:	39 fe                	cmp    %edi,%esi
  802533:	76 4b                	jbe    802580 <__umoddi3+0x80>
  802535:	89 c8                	mov    %ecx,%eax
  802537:	89 fa                	mov    %edi,%edx
  802539:	f7 f6                	div    %esi
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	31 d2                	xor    %edx,%edx
  80253f:	83 c4 14             	add    $0x14,%esp
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	66 90                	xchg   %ax,%ax
  802548:	39 f8                	cmp    %edi,%eax
  80254a:	77 54                	ja     8025a0 <__umoddi3+0xa0>
  80254c:	0f bd e8             	bsr    %eax,%ebp
  80254f:	83 f5 1f             	xor    $0x1f,%ebp
  802552:	75 5c                	jne    8025b0 <__umoddi3+0xb0>
  802554:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802558:	39 3c 24             	cmp    %edi,(%esp)
  80255b:	0f 87 e7 00 00 00    	ja     802648 <__umoddi3+0x148>
  802561:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802565:	29 f1                	sub    %esi,%ecx
  802567:	19 c7                	sbb    %eax,%edi
  802569:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80256d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802571:	8b 44 24 08          	mov    0x8(%esp),%eax
  802575:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802579:	83 c4 14             	add    $0x14,%esp
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	85 f6                	test   %esi,%esi
  802582:	89 f5                	mov    %esi,%ebp
  802584:	75 0b                	jne    802591 <__umoddi3+0x91>
  802586:	b8 01 00 00 00       	mov    $0x1,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	f7 f6                	div    %esi
  80258f:	89 c5                	mov    %eax,%ebp
  802591:	8b 44 24 04          	mov    0x4(%esp),%eax
  802595:	31 d2                	xor    %edx,%edx
  802597:	f7 f5                	div    %ebp
  802599:	89 c8                	mov    %ecx,%eax
  80259b:	f7 f5                	div    %ebp
  80259d:	eb 9c                	jmp    80253b <__umoddi3+0x3b>
  80259f:	90                   	nop
  8025a0:	89 c8                	mov    %ecx,%eax
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 14             	add    $0x14,%esp
  8025a7:	5e                   	pop    %esi
  8025a8:	5f                   	pop    %edi
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    
  8025ab:	90                   	nop
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	8b 04 24             	mov    (%esp),%eax
  8025b3:	be 20 00 00 00       	mov    $0x20,%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	29 ee                	sub    %ebp,%esi
  8025bc:	d3 e2                	shl    %cl,%edx
  8025be:	89 f1                	mov    %esi,%ecx
  8025c0:	d3 e8                	shr    %cl,%eax
  8025c2:	89 e9                	mov    %ebp,%ecx
  8025c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c8:	8b 04 24             	mov    (%esp),%eax
  8025cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025cf:	89 fa                	mov    %edi,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 f1                	mov    %esi,%ecx
  8025d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025dd:	d3 ea                	shr    %cl,%edx
  8025df:	89 e9                	mov    %ebp,%ecx
  8025e1:	d3 e7                	shl    %cl,%edi
  8025e3:	89 f1                	mov    %esi,%ecx
  8025e5:	d3 e8                	shr    %cl,%eax
  8025e7:	89 e9                	mov    %ebp,%ecx
  8025e9:	09 f8                	or     %edi,%eax
  8025eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025ef:	f7 74 24 04          	divl   0x4(%esp)
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f9:	89 d7                	mov    %edx,%edi
  8025fb:	f7 64 24 08          	mull   0x8(%esp)
  8025ff:	39 d7                	cmp    %edx,%edi
  802601:	89 c1                	mov    %eax,%ecx
  802603:	89 14 24             	mov    %edx,(%esp)
  802606:	72 2c                	jb     802634 <__umoddi3+0x134>
  802608:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80260c:	72 22                	jb     802630 <__umoddi3+0x130>
  80260e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802612:	29 c8                	sub    %ecx,%eax
  802614:	19 d7                	sbb    %edx,%edi
  802616:	89 e9                	mov    %ebp,%ecx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	d3 e8                	shr    %cl,%eax
  80261c:	89 f1                	mov    %esi,%ecx
  80261e:	d3 e2                	shl    %cl,%edx
  802620:	89 e9                	mov    %ebp,%ecx
  802622:	d3 ef                	shr    %cl,%edi
  802624:	09 d0                	or     %edx,%eax
  802626:	89 fa                	mov    %edi,%edx
  802628:	83 c4 14             	add    $0x14,%esp
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    
  80262f:	90                   	nop
  802630:	39 d7                	cmp    %edx,%edi
  802632:	75 da                	jne    80260e <__umoddi3+0x10e>
  802634:	8b 14 24             	mov    (%esp),%edx
  802637:	89 c1                	mov    %eax,%ecx
  802639:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80263d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802641:	eb cb                	jmp    80260e <__umoddi3+0x10e>
  802643:	90                   	nop
  802644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802648:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80264c:	0f 82 0f ff ff ff    	jb     802561 <__umoddi3+0x61>
  802652:	e9 1a ff ff ff       	jmp    802571 <__umoddi3+0x71>
